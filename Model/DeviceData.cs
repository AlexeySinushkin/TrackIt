using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("DevicesData")]
    public class DeviceData : modelObject<DeviceData>      
    {

        DateTime sampleDate;
        [Column]
        public DateTime SampleDate
        {
            get { return sampleDate; }
            set { sampleDate = value; }
        }

        int sampleValue;
        [Column]
        public int SampleValue
        {
            get { return sampleValue; }
            set { sampleValue = value; }
        }

        Device device;
        /// <summary>
        /// устройство
        /// </summary>
        [ReferenceTo("DeviceID")]
        public Device Device
        {
            get { return device; }
            set { device = value; }
        }

    }
}
