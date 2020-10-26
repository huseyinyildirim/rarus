using System.Configuration;

namespace Moduller
{
    public class OzelAyar : ConfigurationSection
    {
        public static OzelAyar GetConfig()
        {
            return ConfigurationManager.GetSection("OzelAyarlar") as OzelAyar;
        }

        [ConfigurationProperty("Ayar", IsRequired = true)]
        public OzelAyarStateCollection Ayar
        {
            get
            {
                return this["Ayar"] as OzelAyarStateCollection;
            }
        }
    }

    public class OzelAyarState : ConfigurationElement
    {
        [ConfigurationProperty("Ad", IsRequired = true)]
        public string Ad
        {
            get
            {
                return this["Ad"] as string;
            }
        }

        [ConfigurationProperty("Deger", IsRequired = true)]
        public string Deger
        {
            get
            {
                return this["Deger"] as string;
            }
        }
    }

    public class OzelAyarStateCollection : ConfigurationElementCollection
    {
        public OzelAyarState this[int i]
        {
            get
            {
                return base.BaseGet(i) as OzelAyarState;
            }
            set
            {
                if (base.BaseGet(i) != null)
                {
                    base.BaseRemoveAt(i);
                }

                this.BaseAdd(i, value);
            }
        }

        protected override ConfigurationElement CreateNewElement()
        {
            return new OzelAyarState();
        }

        protected override object GetElementKey(ConfigurationElement E)
        {
            return ((OzelAyarState)E).Ad;
        }
    }
}