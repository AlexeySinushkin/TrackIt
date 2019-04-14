using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using TrackIt.Transmission.Model;
using System.Runtime.Serialization;

namespace TrackIt.Model
{
    [Table("Devices")]
    public class Device : activableObject<Device>, IDevice
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

        Container container;
        [ReferenceTo("ContainerID")]
        public Container Container
        {
            get { return container; }
            set { container = value; }
        }

        DateTime? connectionDate;
        [Column]
        public DateTime? ConnectionDate
        {
            get { return connectionDate; }
            set { connectionDate = value; }
        }

        int x;
        /// <summary>
        /// Положение по оси X в мм
        /// </summary>
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
                return serialNumber.ToString("D15");
            }
        }

        string passwordServer;
        /// <summary>
        /// Пароль для доступа к серверу
        /// </summary>
        [Column]
        public string PasswordServer
        {
            get { return passwordServer; }
            set { passwordServer = value; }
        }

        byte[] passwordBT;
        /// <summary>
        /// Пароль для bluetooth
        /// </summary>
        [Column]
        public byte[] PasswordBT
        {
            get { return passwordBT; }
            set { passwordBT = value; }
        }

        short? position;
        /// <summary>
        /// Посиция сенсора по порядку
        /// </summary>
        [Column]
        public short? Position
        {
            get { return position; }
            set { position = value; }
        }

        public static implicit operator Sensor(Device d)
        {
            Sensor s = new Sensor();
            s.ID = d.ID;
            s.SerialNumber = d.SerialNumber;
            return s;
        }

    }
}
