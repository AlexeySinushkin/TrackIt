using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("FormatsDate")]
    public class FormatDate : modelObject<FormatDate>
    {
        string format = "dd/MM/yyyy";
        [Column]
        public string Format
        {
            get { return format; }
            set { format = value; }
        }

    }
}
