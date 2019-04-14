using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using TrackIt.Transmission.Model;
using System.Xml.Serialization;

namespace TrackIt.Model
{
    [Table("Devices", Where = "DeviceTypeID = 2")]
    public class Gateway : activableObject<Gateway>, IDevice  
    {

        DeviceType deviceType;
        [ReferenceTo("DeviceTypeID")]
        public DeviceType DeviceType
        {
            get { return deviceType; }
            set { deviceType = value; }
        }

        Container container;
        [ReferenceTo("ContainerID")]
        public Container Container
        {
            get { return container; }
            set { container = value; }
        }


        Int64 serialNumber;
        /// <summary>
        /// �������� �����
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

        string passwordServer;
        /// <summary>
        /// ������ ��� ������� � �������
        /// </summary>
        [Column]
        public string PasswordServer
        {
            get { return passwordServer; }
            set { passwordServer = value; }
        }

        byte[] passwordBT;
        /// <summary>
        /// ������ ��� bluetooth
        /// </summary>
        [Column]
        public byte[] PasswordBT
        {
            get { return passwordBT; }
            set { passwordBT = value; }
        }
    }
}
