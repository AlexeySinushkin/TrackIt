using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("FormatsTime")]
    public class FormatTime : modelObject<FormatTime>
    {
        string format = "HH:mm";
        [Column]
        public string Format
        {
            get { return format; }
            set { format = value; }
        }

    }
}
