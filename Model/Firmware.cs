using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using Common;
using NHibernate.Expression;
using System.Globalization;
using System.Text.RegularExpressions;

namespace TrackIt.Model
{

    [Table("Firmwares")]
    public class Firmware : activableObject<Firmware>
    {
        [Column]
        public byte VerMaj { get; set; }
        [Column]
        public byte VerMin { get; set; }
        [Column]
        public int VerSVN { get; set; }

        public string Version
        {
            get { return string.Format("{0}.{1}.{2}", VerMaj, VerMin, VerSVN); }
            set
            {
                Regex r = new Regex(@"^(?<maj>[\d]{1,3})\.(?<min>[\d]{1,3})\.(?<svn>[\d]{1,6})$");
                Match m = r.Match(value);
                if (m.Success)
                {
                    VerMaj = byte.Parse(m.Groups["maj"].Value);
                    VerMin = byte.Parse(m.Groups["min"].Value);
                    VerSVN = int.Parse(m.Groups["svn"].Value);
                }
            }
        }

        [ReferenceTo("DeviceTypeID")]
        public DeviceType DeviceType { get; set; }

        [Column]
        public int PageSize { get; set; }

        [Column]
        public int PageCount { get; set; }

        byte[] content;
        [Column]
        public byte[] Content
        {
            get { return content; }
            set { content = value; }
        }

    }
}
