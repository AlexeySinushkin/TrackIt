using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("DevicesData", DynamicUpdate=false, DynamicInsert=false)]
    public class TemperatureDataView : modelObject<TemperatureDataView>      
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

        int deviceID;
        /// <summary>
        /// устройство
        /// </summary>
        [Column]
        public int DeviceID
        {
            get { return deviceID; }
            set { deviceID = value; }
        }

    }
}
