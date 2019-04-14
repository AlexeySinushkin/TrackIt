using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("TimeIntervals")]
    public class TimeInterval : localizableObject<TimeInterval>
    {
        int _value = 10;
        [Column]
        public int Value
        {
            get { return _value; }
            set { _value = value; }
        }


        string name;
        /// <summary>
        /// 10 минут
        /// </summary>
        [Localizable]
        public string Name
        {
            get { return name; }
            set { name = value; }
        }

    }
}
