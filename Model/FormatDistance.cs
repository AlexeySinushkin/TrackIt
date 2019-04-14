using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("FormatsDistance")]
    public class FormatDistance : localizableObject<FormatDistance>
    {
        string format = "meter";
        [Column]
        public string Format
        {
            get { return format; }
            set { format = value; }
        }


        string shortName;
        /// <summary>
        /// м
        /// </summary>
        [Localizable]
        public string ShortName
        {
            get { return shortName; }
            set { shortName = value; }
        }
        string longName;
        /// <summary>
        /// км
        /// </summary>
        [Localizable]
        public string LongName
        {
            get { return longName; }
            set { longName = value; }
        }
    }
}
