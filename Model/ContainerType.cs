using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("ContainerTypes")]
    public class ContainerType : localizableObject<ContainerType>
    {
        string key = String.Empty;
        [Column]
        public string Key
        {
            get { return key; }
            set { key = value; }
        }

        string name = String.Empty;
        [Localizable]
        public string Name
        {
            get { return name; }
            set { name = value; }
        }

    }
}
