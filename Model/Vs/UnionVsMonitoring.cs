using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;

namespace TrackIt.Model
{
    [Table("UnionVsMonitoring")]
    public class UnionVsMonitoring : modelObject<UnionVsMonitoring>
    {
        int unionID = -1;
        [Column]
        public int UnionID
        {
            get { return unionID; }
            set { unionID = value; }
        }
        int monitoringID = -1;
        [Column]
        public int MonitoringID
        {
            get { return monitoringID; }
            set { monitoringID = value; }
        }
    }
}
