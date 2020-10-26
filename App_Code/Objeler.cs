using System.Collections.Generic;
using System;

public class Objeler
{
    //public class Tanimlar : SHOPObjeler.Tanimlar
    public class Tanimlar
    {
        public class Diller
        {
            public string Dil { get; set; }
            public int ID { get; set; }
            public string Kisaltma { get; set; }
            public string Kodlama { get; set; }
            public string Ikon { get; set; }
            public int Sira { get; set; }
            public bool Onay { get; set; }
            public bool AnaDil { get; set; }
            public Diller() { }
            public Diller(string _Dil, int _ID, string _Kisaltma, string _Kodlama, string _Ikon, int _Sira, bool _Onay, bool _AnaDil)
            {
                _Dil = Dil;
                _ID = ID;
                _Kisaltma = Kisaltma;
                _Kodlama = Kodlama;
                _Ikon = Ikon;
                _Sira = Sira;
                _Onay = Onay;
                _AnaDil = AnaDil;
            }
        }

        public class Dil
        {
            public string SessionID { get; set; }
            public int DilID { get; set; }
            public string IP { get; set; }
            public DateTime Tarih { get; set; }
            public Dil() { }
            public Dil(string _SessionID, int _ID, DateTime _Tarih, string _IP)
            {
                _SessionID = SessionID;
                _ID = DilID;
                _Tarih = Tarih;
                _IP = IP;
            }
        }

        public class Admin
        {
            public string SessionID { get; set; }
            public int ID { get; set; }
            public bool Root { get; set; }
            public string IP { get; set; }
            public DateTime Tarih { get; set; }
            public Admin() { }
            public Admin(string _SessionID, int _ID, DateTime _Tarih, string _IP, bool _Root)
            {
                _SessionID = SessionID;
                _ID = ID;
                _Tarih = Tarih;
                _IP = IP;
                _Root = Root;
            }
        }

        public class Urun
        {
            public int kategori_id { get; set; }
            public int marka_id { get; set; }
            public string kod { get; set; }
            public string ad { get; set; }
            public string on_aciklama { get; set; }
            public Urun() { }
            public Urun(int _kategori_id, int _marka_id, string _kod, string _ad, string _on_aciklama)
            {
                _kategori_id = kategori_id;
                _marka_id = marka_id;
                _kod = kod;
                _ad = ad;
                _on_aciklama = on_aciklama;
            }
        }
    }

    //public class Listeler : SHOPObjeler.Listeler
    public class Listeler
    {
        public static List<Tanimlar.Diller> Diller = new List<Tanimlar.Diller>();
        public static List<Tanimlar.Dil> Dil = new List<Tanimlar.Dil>();
        public static List<Tanimlar.Admin> Admin = new List<Tanimlar.Admin>();
    }
}