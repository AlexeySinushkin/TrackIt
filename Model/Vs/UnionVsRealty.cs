using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;

namespace TrackIt.Model
{

    [Table("UnionVsRealty")]
    public class UnionVsRealty : modelObject<UnionVsRealty>
    {
        int unionID = -1;
        [Column]
        public int UnionID
        {
            get { return unionID; }
            set { unionID = value; }
        }
        int realtyID = -1;
        [Column]
        public int RealtyID
        {
            get { return realtyID; }
            set { realtyID = value; }
        }
    }
}
