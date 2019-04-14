using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("TimeAccuracy")]
    public class TimeAccuracy : localizableObject<TimeAccuracy>
    {
        int _value = 30;
        [Column]
        public int Value
        {
            get { return _value; }
            set { _value = value; }
        }


        string name;
        /// <summary>
        /// +/- 5 минут
        /// </summary>
        [Localizable]
        public string Name
        {
            get { return name; }
            set { name = value; }
        }

    }
}
