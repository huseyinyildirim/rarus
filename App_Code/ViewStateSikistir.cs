using System.IO;
using System.IO.Compression;

public class ViewStateSikistir
{

    public static byte[] Compress(byte[] data)
    {
        MemoryStream ms = new MemoryStream();
        DeflateStream stream = new DeflateStream(ms, CompressionMode.Compress);
        stream.Write(data, 0, data.Length);
        stream.Close();
        return ms.ToArray();
    }

    public static byte[] Decompress(byte[] data)
    {
        MemoryStream ms = new MemoryStream();
        ms.Write(data, 0, data.Length);
        ms.Position = 0;
        DeflateStream stream = new DeflateStream(ms, CompressionMode.Decompress);
        MemoryStream temp = new MemoryStream();
        byte[] buffer = new byte[1024];

        while (true)
        {
            int read = stream.Read(buffer, 0, buffer.Length);
            if (read <= 0)
            {
                break;
            }
            else
            {
                temp.Write(buffer, 0, buffer.Length);
            }
        }
        stream.Close();
        return temp.ToArray();
    }

}