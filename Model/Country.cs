using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("Countries")]
    public class Country : localizableObject<Country>
    {
        string key;
        [Column]
        public string Key
        {
            get { return key; }
            set { key = value; }
        }


        string name;
        [Localizable]
        public string Name
        {
            get { return name; }
            set { name = value; }
        }
    }
}
