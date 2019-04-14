using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;
using TrackIt.Transmission.Model;

namespace TrackIt.Model
{
    [Table("TrackVsDevice")]
    public class TrackVsSensor : modelObject<TrackVsSensor>
    {
        Track track;
        [ReferenceTo("TrackID")]
        public Track Track
        {
            get
            {
                return track;
            }
            set
            {
                track = value;
            }
        }


        Sensor sensor;
        [ReferenceTo("DeviceID")]
        public Sensor Sensor
        {
            get
            {
                return sensor;
            }
            set
            {
                sensor = value;
            }
        }

    }
}
