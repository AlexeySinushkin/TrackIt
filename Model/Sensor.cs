using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using TrackIt.Transmission.Model;

namespace TrackIt.Model
{
    [Table("Devices", Where = "DeviceTypeID = 1")]
    public class Sensor : modelObject<Sensor>, IDevice    
    {

        DeviceType deviceType;
        [ReferenceTo("DeviceTypeID")]
        public DeviceType DeviceType
        {
            get { return deviceType; }
            set { deviceType = value; }
        }

        Int64 serialNumber;
        /// <summary>
        /// Серийный номер
        /// </summary>
        [Column("SerialNumber")]
        public Int64 SerialNumber
        {
            get { return serialNumber; }
            set { serialNumber = value; }
        }

        public string SerialAsString
        {
            get
            {
                return serialNumber.ToString("D8");
            }
        }

        public static implicit operator Device(Sensor s)
        {
            Device d = new Device();
            d.ID = s.ID;
            d.SerialNumber = s.SerialNumber;
            return d;
        }


        string webColor = "#000000";
        public string WebColor
        {
            get { return webColor; }
            set { webColor = value;}
        }

    }
}
