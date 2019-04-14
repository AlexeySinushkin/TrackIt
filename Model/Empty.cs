using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("Users")]
    public class Empty : modelObject<Empty>
    {
        string text = String.Empty;
        [Column(30)]
        public string Text
        {
            get { return text; }
            set { text = value; }
        }
    }
}
