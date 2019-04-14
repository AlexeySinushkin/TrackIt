using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;

namespace TrackIt.Model
{
    [Table("UserVsMonitoring")]
    public class UserVsMonitoring : modelObject<UserVsMonitoring>
    {
        int userID = -1;
        [Column]
        public int UserID
        {
            get { return userID; }
            set { userID = value; }
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
