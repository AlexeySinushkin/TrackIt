using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using TrackIt.Transmission.Model;

namespace TrackIt.Model
{
    [Table("TrackVsDevice")]
    public class TrackVsDevice : modelObject<TrackVsDevice>
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


        Device device;
        [ReferenceTo("DeviceID")]
        public Device Device
        {
            get
            {
                return device;
            }
            set
            {
                device = value;
            }
        }

    }
}
