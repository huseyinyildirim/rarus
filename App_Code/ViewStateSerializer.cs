/*
*                        Serialization   Deserialization Compression Amount of Data to use   Security    Indicated to:
* ViewState normal:      Good            Bad (binary)    None        Use low Data            *None       Forms with low controls, Grids with paging
* Serializer normal:     Good            Bad (binary)    Good        Mid proposes            Moderate    Grids with Viewstate turned On Without paging
* Serializer optimized:  Regular         Regular         Regular     Grand Data (DataTableGetir)  Moderate    ViewState with DataTables & Grids with paging or without the Viewstate turned off
* 
* ViewState Serializer / Compressor / Encrypter by ModMa (Manuel Soler)
* V1.3 Compatible with ajax toolkit (Tested in FW 2.0)
* 
* NOTE: The author has not responsible for data loss, damage or system unstability.
* 
* Changes in V1.3:
* A new option to select the MachineKey encryption
* No need anymore set ViewStateEncryptionMode="Never"
* CompressPage() now works in ajax
* More optimized De/Serialization
* 
* Changes in V1.2:
* Now uses PageStatePersister: more easy, compatible & can use a PageAdapter
* 
* Changes in V1.1:
* Use reflection hacks to work with Ajax
* 
* USAGE in Page:

#region ViewState Compression
private ViewStateSerializer.ViewStateSerializer _persister = null;

protected override PageStatePersister PageStatePersister
{
get
{
if (_persister == null)
{
_persister = new ViewStateSerializer.ViewStateSerializer(Page, ViewStateSerializer.ViewStateSerializer.SecurityLevel.Low, false);
_persister.CompressPage(); // optional (compress all output HTML page) if have problems, comment it
}
return _persister;
}
}
#endregion
 
*/

using System;
using System.Collections;
using System.IO;
using System.Security.Cryptography;
using System.Security.Permissions;
using System.Web;
using System.Web.UI;

namespace ViewStateSerializer
{
            /// <summary>
            /// Advanced ViewState Serializer / Compressor / Encrypter
            /// </summary>
            [AspNetHostingPermission(SecurityAction.LinkDemand, Level = AspNetHostingPermissionLevel.Minimal), AspNetHostingPermission(SecurityAction.InheritanceDemand, Level = AspNetHostingPermissionLevel.Minimal)]
            public class ViewStateSerializer : PageStatePersister
            {
                        //2007-2008 ModMa Technoligies

                        const string SessionKey = "SerialCryptKey";
                        private SecurityLevel _encript = SecurityLevel.None;
                        private bool _optimize = false;
                        private System.Reflection.PropertyInfo _ClientState = null;
                        private System.Reflection.PropertyInfo _RequestValueCollection = null;
                        private System.Reflection.PropertyInfo _RequestViewStateString = null;
                        private System.Reflection.MethodInfo _EncDecMethod = null;
                        private System.Reflection.MethodInfo _GetMemoryStream = null;
                        private System.Reflection.MethodInfo _GetMacKeyModifier = null;
                        private readonly string _pHash;

                        #region "Class Inits"

                        public ViewStateSerializer(Page page)
                                    : base(page)
                        {
                                    _pHash = getPageHash();
                                    //by default
                                    SetViewStateValues(SecurityLevel.None, false);
                        }

                        public ViewStateSerializer(Page page, SecurityLevel EnCrypt, bool Optimize)
                                    : base(page)
                        {
                                    _pHash = getPageHash();
                                    SetViewStateValues(EnCrypt, Optimize);
                        }

                        private void SetViewStateValues(SecurityLevel EnCrypt, bool Optimize)
                        {
                                    // now only in New
                                    _encript = EnCrypt;
                                    _optimize = Optimize;

                                    //need to access to this properties via reflection, because are declared 'internal'
                                    Type _PageType = typeof(System.Web.UI.Page);
                                    _ClientState = _PageType.GetProperty("ClientState", System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic);
                                    _RequestValueCollection = _PageType.GetProperty("RequestValueCollection",
                                    System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic);
                                    _RequestViewStateString = _PageType.GetProperty("RequestViewStateString",
                                    System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic);

                                    Type _modeType = typeof(ObjectStateFormatter);
                                    _GetMemoryStream = _modeType.GetMethod("GetMemoryStream",
                                    System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Static);
                                    _GetMacKeyModifier = _modeType.GetMethod("GetMacKeyModifier",
                                    System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic);

                                    Type machineKeySection = typeof(System.Web.Configuration.MachineKeySection);
                                    _EncDecMethod = machineKeySection.GetMethod("EncryptOrDecryptData",
                                    System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Static, Type.DefaultBinder,
                                    new Type[] { typeof(bool), typeof(byte[]), typeof(byte[]), typeof(int), typeof(int) }, null);
                        }

                        #endregion

                        #region "Overrided Functions Load & Save ViewState"

                        public override void Load()
                        {
                                    if (_RequestValueCollection.GetValue(base.Page, null) != null)
                                    {
                                                string requestViewStateString = null;
                                                try
                                                {
                                                            requestViewStateString = (string)_RequestViewStateString.GetValue(base.Page, null);
                                                            if (!string.IsNullOrEmpty(requestViewStateString))
                                                            {
                                                                        Pair pair = (Pair)this.DeSerialize(requestViewStateString);
                                                                        base.ViewState = pair.First;
                                                                        base.ControlState = pair.Second;
                                                            }
                                                }
                                                catch (Exception exception)
                                                {
                                                            if (exception.InnerException is ViewStateException)
                                                            {
                                                                        throw exception;
                                                            }

                                                            //this method are declared 'internal' too in framework
                                                            Type _exViewState = typeof(ViewStateException);
                                                            System.Reflection.MethodInfo ThrowViewStateError = _exViewState.GetMethod("ThrowViewStateError",
                                                            System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Static);
                                                            object[] parms = { exception, requestViewStateString };
                                                            ThrowViewStateError.Invoke(base.Page, parms);
                                                }
                                    }
                        }

                        public override void Save()
                        {
                                    if ((base.ViewState != null) || (base.ControlState != null))
                                    {
                                                _ClientState.SetValue(base.Page, this.Serialize(new Pair(base.ViewState, base.ControlState)), null);
                                    }
                        }

                        #endregion

                        #region "Functions to Init the Serialization / Deserialization"

                        protected string Serialize(object viewState)
                        {
                                    if (viewState == null)
                                    {
                                                throw new ArgumentNullException("viewState is Nothing", "Serialize params Error");
                                    }

                                    //Saves the Current Page Configuration
                                    Hashtable cfg = getCryptCfg();
                                    cfg["optSlzEncrypt_" + _pHash] = _encript;
                                    cfg["optSlzOptimize_" + _pHash] = _optimize;

                                    byte[] bytes;
                                    if (_optimize)
                                    {
                                                //optimize for data option
                                                System.Runtime.Serialization.Formatters.Binary.BinaryFormatter formatter =
                                                new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
                                                MemoryStream writer = new MemoryStream();
                                                object transform = cc(viewState);
                                                formatter.Serialize(writer, transform);
                                                writer.Position = 0;
                                                bytes = writer.ToArray();
                                    }
                                    else
                                    {
                                                //classic mode
                                                bytes = SerializeInternal(base.StateFormatter, viewState);
                                    }

                                    const string errorCompression = "ViewState Compression Error";
                                    try
                                    {
                                                //compress process
                                                bytes = GZipCompress(bytes);
                                    }
                                    catch (Exception ex)
                                    {
                                                throw new Exception(errorCompression + ": " + ex.Message, ex);
                                    }

                                    switch (_encript)
                                    {
                                                case SecurityLevel.None:
                                                            break;
                                                case SecurityLevel.Machine:
                                                            bytes = (byte[])_EncDecMethod.Invoke(null, new object[] { true, bytes, GetMacKeyModifier(base.StateFormatter), 0, bytes.Length });
                                                            break;
                                                default:
                                                            bytes = Cryptos(bytes, this.GetKeys, CryptosMode.EnCrypt);
                                                            break;
                                    }

                                    return Convert.ToBase64String(bytes);
                        }

                        protected object DeSerialize(string viewState)
                        {
                                    if (viewState == null || viewState.Equals(string.Empty))
                                    {
                                                throw new ArgumentNullException("viewState is Nothing or Empty", "DeSerialize params Error");
                                    }

                                    //Loads the Current Page Configuration
                                    Hashtable cfg = getCryptCfg();
                                    if (cfg["optSlzEncrypt_" + _pHash] != null)
                                    {
                                                _encript = (SecurityLevel)cfg["optSlzEncrypt_" + _pHash];
                                    }
                                    if (cfg["optSlzOptimize_" + _pHash] != null)
                                    {
                                                _optimize = (bool)cfg["optSlzOptimize_" + _pHash];
                                    }

                                    byte[] bytes = Convert.FromBase64String(viewState);
                                    switch (_encript)
                                    {
                                                case SecurityLevel.None:
                                                            break;
                                                case SecurityLevel.Machine:
                                                            bytes = (byte[])_EncDecMethod.Invoke(null, new object[] { false, bytes, GetMacKeyModifier(base.StateFormatter), 0, bytes.Length });
                                                            break;
                                                default:
                                                            bytes = Cryptos(bytes, this.GetKeys, CryptosMode.DeCrypt);
                                                            break;
                                    }

                                    try
                                    {
                                                bytes = GZipDecompress(bytes);
                                    }
                                    catch (Exception ex)
                                    {
                                                throw new Exception("ViewState Data Error: " + ex.Message, ex);
                                    }

                                    if (_optimize)
                                    {
                                                //optimize for data option
                                                System.Runtime.Serialization.Formatters.Binary.BinaryFormatter formatter =
                                                new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
                                                MemoryStream writer = new MemoryStream(bytes);
                                                writer.Position = 0;
                                                object transform = formatter.Deserialize(writer);
                                                return cc2(transform);
                                    }
                                    else
                                    {
                                                //classic mode
                                                return DeSerializeInternal(base.StateFormatter, bytes);
                                    }
                        }

                        private byte[] SerializeInternal(IStateFormatter StateFormatter, object viewState)
                        {
                                    ObjectStateFormatter format = (ObjectStateFormatter)StateFormatter;
                                    MemoryStream memoryStream = (MemoryStream)_GetMemoryStream.Invoke(format, null);
                                    format.Serialize(memoryStream, viewState);
                                    memoryStream.SetLength(memoryStream.Position);
                                    byte[] bytes = new byte[memoryStream.Length];
                                    Array.Copy(memoryStream.GetBuffer(), bytes, memoryStream.Length);
                                    memoryStream.Position = 0;
                                    memoryStream.SetLength(0);
                                    return bytes;
                        }

                        private object DeSerializeInternal(IStateFormatter StateFormatter, byte[] bytes)
                        {
                                    ObjectStateFormatter format = (ObjectStateFormatter)StateFormatter;
                                    MemoryStream memoryStream = (MemoryStream)_GetMemoryStream.Invoke(format, null);
                                    memoryStream.Write(bytes, 0, bytes.Length);
                                    memoryStream.Position = 0;
                                    object viewState = format.Deserialize(memoryStream);
                                    memoryStream.Position = 0;
                                    memoryStream.SetLength(0);
                                    return viewState;
                        }

                        #endregion

                        #region "Functions to manage the compression (only Framework 2.0)"

                        //based in a code of Dario Solera: http://www.codeproject.com/aspnet/ViewStateCompression.asp
                        public byte[] GZipCompress(byte[] data)
                        {
                                    MemoryStream output = new MemoryStream();
                                    System.IO.Compression.GZipStream gzip = new System.IO.Compression.GZipStream(output, System.IO.Compression.CompressionMode.Compress, true);
                                    gzip.Write(data, 0, data.Length);
                                    gzip.Close();
                                    return output.ToArray();
                        }

                        //based in a code of Dario Solera: http://www.codeproject.com/aspnet/ViewStateCompression.asp
                        public byte[] GZipDecompress(byte[] data)
                        {
                                    MemoryStream input = new MemoryStream(data);
                                    input.Position = 0;
                                    System.IO.Compression.GZipStream gzip = new System.IO.Compression.GZipStream(input, System.IO.Compression.CompressionMode.Decompress, true);
                                    MemoryStream output = new MemoryStream();
                                    byte[] buff = new byte[4096];
                                    int read = -1;

                                    read = gzip.Read(buff, 0, buff.Length);
                                    while (read > 0)
                                    {
                                                output.Write(buff, 0, read);
                                                read = gzip.Read(buff, 0, buff.Length);
                                    }
                                    gzip.Close();
                                    return output.ToArray();
                        }

                        //based in a code of Dario Solera: http://www.codeproject.com/aspnet/HttpCompressionQnD.asp
                        public void CompressPage()
                        {
#if ScriptManager
ScriptManager scrm = ScriptManager.GetCurrent(base.Page);
if (scrm == null || !scrm.IsInAsyncPostBack) 
#endif

                                    //check if this was invoked
                                    if (!(base.Page.Response.Filter is System.IO.Compression.GZipStream) && !(base.Page.Response.Filter is System.IO.Compression.DeflateStream))
                                    { //compress the page
                                                string Accept_encoding = base.Page.Request.Headers["Accept-encoding"];
                                                if (Accept_encoding == null) Accept_encoding = string.Empty;

                                                if (base.Page.Request.UserAgent.ToLower().IndexOf("konqueror") == -1)
                                                {
                                                            if (Accept_encoding.IndexOf("gzip") != -1)
                                                            {
                                                                        base.Page.Response.Filter =
                                                                        new System.IO.Compression.GZipStream(base.Page.Response.Filter,
                                                                                            System.IO.Compression.CompressionMode.Compress, true);
                                                                        base.Page.Response.AppendHeader("Content-encoding", "gzip");
                                                            }
                                                }
                                                else
                                                {
                                                            if (Accept_encoding.IndexOf("deflate") != -1)
                                                            {
                                                                        base.Page.Response.Filter =
                                                                        new System.IO.Compression.DeflateStream(base.Page.Response.Filter,
                                                                                            System.IO.Compression.CompressionMode.Compress, true);
                                                                        base.Page.Response.AppendHeader("Content-encoding", "deflate");
                                                            }
                                                }
                                    }
                        }

                        #endregion

                        #region "Functions to manage the Cryptography"

                        private byte[] GetMacKeyModifier(IStateFormatter StateFormatter)
                        {
                                    return (byte[])_GetMacKeyModifier.Invoke(StateFormatter, null);
                        }

                        public static byte[] Cryptos(byte[] data, Hashtable keys, CryptosMode modo)
                        {
                                    if ((keys == null) || (keys["Key"] == null) || (keys["IV"] == null) || (data == null))
                                    {
                                                throw new ArgumentNullException("data or keys is Nothing", "Cryptos params Error");
                                    }

                                    MemoryStream output = new MemoryStream();
                                    DESCryptoServiceProvider des = new DESCryptoServiceProvider();
                                    CryptoStream cs = new CryptoStream(output, (modo == CryptosMode.EnCrypt ?
                                    des.CreateEncryptor((byte[])keys["Key"], (byte[])keys["IV"]) :
                                    des.CreateDecryptor((byte[])keys["Key"], (byte[])keys["IV"])), CryptoStreamMode.Write);
                                    cs.Write(data, 0, data.Length);
                                    cs.FlushFinalBlock();
                                    cs.Close();
                                    return output.ToArray();
                        }

                        public enum CryptosMode
                        {
                                    DeCrypt = 0,
                                    EnCrypt = 1
                        }

                        public enum SecurityLevel
                        {
                                    None = 0,
                                    Low = 1,
                                    High = 2,
                                    Machine = 3
                        }

                        //gets the Cryptography config (all pages get this)
                        protected Hashtable GetKeys
                        {
                                    get
                                    {
                                                Hashtable Config = getCryptCfg();
                                                //go to create the keys
                                                byte[] key;
                                                byte[] IV;
                                                if (Config["Key1"] == null || Config["IV1"] == null)
                                                {   // bost security (more aleatory)
                                                            RNGCryptoServiceProvider randObj = new RNGCryptoServiceProvider();
                                                            IV = new byte[8];
                                                            randObj.GetNonZeroBytes(IV);
                                                            key = BitConverter.GetBytes(System.DateTime.Now.Ticks);
                                                            //END arrays generation
                                                            Config.Add("Key1", key); // save the key
                                                            Config.Add("IV1", IV);// save initial value
                                                }
                                                if (Config["Key2"] == null || Config["IV2"] == null)
                                                {   // moderate security (starting days + actual day)
                                                            MD5 hash = MD5.Create();
                                                            System.Text.ASCIIEncoding encoder = new System.Text.ASCIIEncoding();
                                                            byte[] tValue;
                                                            //START IV: server starting time XOR server host name
                                                            TimeSpan ts = new TimeSpan(0, 0, 0, 0, System.Environment.TickCount); //you can use this, or aplication start time...
                                                            ts = new TimeSpan(ts.Days, ((int)(ts.TotalDays * 10) % 10 >= 5) ? 12 : 0, 0, 0); // days /2
                                                            tValue = hash.ComputeHash(encoder.GetBytes(base.Page.Server.MachineName.ToLower()));
                                                            IV = BitConverter.GetBytes(ts.Ticks);
                                                            IV[0] = (byte)(IV[0] ^ tValue[0] ^ tValue[8]);
                                                            IV[1] = (byte)(IV[1] ^ tValue[1] ^ tValue[9]);
                                                            IV[2] = (byte)(IV[2] ^ tValue[2] ^ tValue[10]);
                                                            IV[3] = (byte)(IV[3] ^ tValue[3] ^ tValue[11]);
                                                            IV[4] = (byte)(IV[4] ^ tValue[4] ^ tValue[12]);
                                                            IV[5] = (byte)(IV[5] ^ tValue[5] ^ tValue[13]);
                                                            IV[6] = (byte)(IV[6] ^ tValue[6] ^ tValue[14]);
                                                            IV[7] = (byte)(IV[7] ^ tValue[7] ^ tValue[15]);
                                                            //START key: actual day XOR this assembly physical location
                                                            key = BitConverter.GetBytes(new DateTime( // only actual day
                                                            DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day).Ticks);
                                                            tValue = hash.ComputeHash(encoder.GetBytes(
                                                            System.Reflection.Assembly.GetExecutingAssembly().CodeBase.ToLower())); //assembly physical location
                                                            key[0] = (byte)(key[0] ^ tValue[0] ^ tValue[8]);
                                                            key[1] = (byte)(key[1] ^ tValue[1] ^ tValue[9]);
                                                            key[2] = (byte)(key[2] ^ tValue[2] ^ tValue[10]);
                                                            key[3] = (byte)(key[3] ^ tValue[3] ^ tValue[11]);
                                                            key[4] = (byte)(key[4] ^ tValue[4] ^ tValue[12]);
                                                            key[5] = (byte)(key[5] ^ tValue[5] ^ tValue[13]);
                                                            key[6] = (byte)(key[6] ^ tValue[6] ^ tValue[14]);
                                                            key[7] = (byte)(key[7] ^ tValue[7] ^ tValue[15]);
                                                            //END arrays generation
                                                            Config.Add("Key2", key); // save the key
                                                            Config.Add("IV2", IV);// save initial value
                                                }

                                                //set the output configuration
                                                Hashtable Salida = new Hashtable();
                                                switch (_encript)
                                                {
                                                            case SecurityLevel.None:
                                                                        Salida.Add("Key", null);
                                                                        Salida.Add("IV", null);
                                                                        break;
                                                            case SecurityLevel.Low:
                                                                        Salida.Add("Key", Config["Key2"]);
                                                                        Salida.Add("IV", Config["IV2"]);
                                                                        break;
                                                            case SecurityLevel.Machine:
                                                                        Salida.Add("Key", null);
                                                                        Salida.Add("IV", null);
                                                                        break;
                                                            default:
                                                                        Salida.Add("Key", Config["Key1"]);
                                                                        Salida.Add("IV", Config["IV1"]);
                                                                        break;
                                                }
                                                return Salida;
                                    }
                        }

                        //bad name: aux function to create the session config
                        private Hashtable getCryptCfg()
                        {
                                    Hashtable salida;
                                    if ((base.Page.Session[SessionKey] == null) || !(base.Page.Session[SessionKey] is Hashtable))
                                    {
                                                salida = new Hashtable();
                                                base.Page.Session.Add(SessionKey, salida);
                                    }
                                    else
                                    {
                                                salida = (Hashtable)base.Page.Session[SessionKey];
                                    }
                                    return salida;
                        }

                        //returns the page string MD5 hash
                        public string getPageHash()
                        {
                                    try
                                    {
                                                string dPage = base.Page.Request.FilePath.Trim().ToLower();
                                                System.Text.ASCIIEncoding ascEnc = new System.Text.ASCIIEncoding();
                                                return Convert.ToBase64String(
                                                MD5.Create().ComputeHash(ascEnc.GetBytes(dPage)));
                                    }
                                    catch
                                    {
                                                //the object is not created, ignore it; desinger mode?
                                                return string.Empty;
                                    }
                        }

                        #endregion

                        #region "Functions to prepare the binary serialization, replace of Triplet and Pair"

                        private object cc(object tipo)
                        {
                                    if (tipo == null) return null;
                                    if (esConocido(tipo))
                                    {
                                                return tipo;
                                    }
                                    else if (tipo is System.Web.UI.Triplet)
                                    {
                                                System.Web.UI.Triplet triple = (System.Web.UI.Triplet)tipo;
                                                return new seriable3(cc(triple.First), cc(triple.Second), cc(triple.Third));
                                    }
                                    else if (tipo is System.Web.UI.Pair)
                                    {
                                                System.Web.UI.Pair par = (System.Web.UI.Pair)tipo;
                                                return new seriable2(cc(par.First), cc(par.Second));
                                    }
                                    else if (tipo is ArrayList)
                                    {
                                                ArrayList trans = (ArrayList)tipo;
                                                ArrayList salida = new ArrayList(trans.Count);
                                                foreach (object x in trans)
                                                {
                                                            salida.Add(cc(x));
                                                }
                                                return salida;
                                    }
                                    else if (tipo is Array)
                                    {
                                                Array trans = (Array)tipo;
                                                Array salida = Array.CreateInstance(tipo.GetType().GetElementType(), trans.Length);
                                                for (int x = 0; x < trans.Length; x++)
                                                {
                                                            salida.SetValue(cc(trans.GetValue(x)), x);
                                                }
                                                return salida;
                                    }
                                    else if (tipo is Hashtable)
                                    {
                                                IDictionaryEnumerator enumerator = ((Hashtable)tipo).GetEnumerator();
                                                Hashtable salida = new Hashtable();
                                                while (enumerator.MoveNext())
                                                {
                                                            salida.Add(cc(enumerator.Key), cc(enumerator.Value));
                                                }
                                                return salida;
                                    }
                                    else
                                    {
                                                Type valueType = tipo.GetType();
                                                Type destinationType = typeof(string);
                                                bool flag;
                                                bool flag2;
                                                System.ComponentModel.TypeConverter converter = System.ComponentModel.TypeDescriptor.GetConverter(valueType);
                                                if (((converter == null) || converter is System.ComponentModel.ReferenceConverter))
                                                {
                                                            flag = false;
                                                            flag2 = false;
                                                }
                                                else
                                                {
                                                            flag = converter.CanConvertTo(destinationType);
                                                            flag2 = converter.CanConvertFrom(destinationType);
                                                }
                                                if ((flag && flag2))
                                                {
                                                            return new generalCnv(valueType, converter.ConvertToInvariantString(tipo));
                                                }
                                                else
                                                {
                                                            return tipo;
                                                            //Salida General
                                                }
                                    }
                        }

                        private object cc2(object tipo)
                        {
                                    if (tipo == null) return null;
                                    if (tipo is seriable3)
                                    {
                                                seriable3 trans = (seriable3)tipo;
                                                return new System.Web.UI.Triplet(cc2(trans.First), cc2(trans.Second), cc2(trans.Third));
                                    }
                                    else if (tipo is seriable2)
                                    {
                                                seriable2 trans = (seriable2)tipo;
                                                return new System.Web.UI.Pair(cc2(trans.First), cc2(trans.Second));
                                    }
                                    else if (tipo is ArrayList)
                                    {
                                                ArrayList salida = (ArrayList)tipo;
                                                for (int x = 0; x < salida.Count; x++)
                                                {
                                                            salida[x] = cc2(salida[x]);
                                                }
                                                return salida;
                                    }
                                    else if (tipo is Array)
                                    {
                                                Array salida = (Array)tipo;
                                                for (int x = 0; x < salida.Length; x++)
                                                {
                                                            salida.SetValue(cc2(salida.GetValue(x)), x);
                                                }
                                                return salida;
                                    }
                                    else if (tipo is Hashtable)
                                    {
                                                IDictionaryEnumerator enumerator = ((Hashtable)tipo).GetEnumerator();
                                                Hashtable salida = new Hashtable();
                                                while (enumerator.MoveNext())
                                                {
                                                            salida.Add(cc2(enumerator.Key), cc2(enumerator.Value));
                                                }
                                                return salida;
                                    }
                                    else if (tipo is generalCnv)
                                    {
                                                generalCnv datos = (generalCnv)tipo;
                                                System.ComponentModel.TypeConverter converter = System.ComponentModel.TypeDescriptor.GetConverter(datos.bTipo);
                                                return converter.ConvertFromInvariantString(datos.bString);
                                    }
                                    else
                                    {
                                                return tipo;
                                                //Salida General
                                    }
                        }

                        private static bool esConocido(object elemento)
                        {
                                    if ((elemento.GetType().IsSealed) && !(elemento is ArrayList) && !(elemento is Array) && !(elemento is Hashtable)
                                    && !(elemento is System.Web.UI.Pair) && !(elemento is System.Web.UI.Triplet))
                                    {
                                                return elemento.GetType().IsSerializable;
                                    }
                                    return false;
                        }

                        #endregion

                        #region "Aux Objects, replace of Triplet and Pair"

                        [Serializable()]
                        private class seriable3
                        {
                                    public object First;
                                    public object Second;
                                    public object Third;

                                    public seriable3()
                                    {
                                    }
                                    public seriable3(object i_First, object i_Second, object i_Third)
                                    {
                                                First = i_First;
                                                Second = i_Second;
                                                Third = i_Third;
                                    }
                        }

                        [Serializable()]
                        private class seriable2
                        {
                                    public object First;
                                    public object Second;

                                    public seriable2()
                                    {
                                    }
                                    public seriable2(object i_First, object i_Second)
                                    {
                                                First = i_First;
                                                Second = i_Second;
                                    }
                        }

                        [Serializable()]
                        private class generalCnv
                        {
                                    public System.Type bTipo;
                                    public string bString;

                                    public generalCnv()
                                    {
                                    }
                                    public generalCnv(System.Type i_bTipo, string i_bString)
                                    {
                                                bTipo = i_bTipo;
                                                bString = i_bString;
                                    }
                        }

                        #endregion

            }
}