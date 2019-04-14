using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using TrackIt.Transmission.Model;

namespace TrackIt.Model
{
    [Table("DevicesView")]
    public class DeviceView :modelObject<DeviceView>
    {
        int deviceTypeID;
        [Column("DeviceTypeID")]
        public int DeviceTypeID
        {
            get { return deviceTypeID; }
            set { deviceTypeID = value; }
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

        string containerName;
        [Column]
        public string ContainerName
        {
            get { return containerName; }
            set { containerName = value; }
        }

        int x;
        [Column]
        public int X
        {
            get { return x; }
            set { x = value; }
        }
        int y;
        [Column]
        public int Y
        {
            get { return y; }
            set { y = value; }
        }
        int z;
        [Column]
        public int Z
        {
            get { return z; }
            set { z = value; }
        }


        public string SerialAsString
        {
            get
            {
                return serialNumber.ToString("D8");
            }
        }



    }
}
