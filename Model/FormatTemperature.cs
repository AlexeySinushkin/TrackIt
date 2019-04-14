using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("FormatsTemperature")]
    public class FormatTemperature : modelObject<FormatTemperature>
    {
        string format = "C";
        [Column]
        public string Format
        {
            get { return format; }
            set { format = value; }
        }

    }
}
