using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using Common;
using NHibernate.Expression;
using System.Globalization;

namespace TrackIt.Model
{

    [Table("ConnectionData")]
    public class ConnectionData : modelObject<ConnectionData>
    {

        ConnectionData request;
        /// <summary>
        /// ≈сли это ќтвет
        /// то ссылка на запрос
        /// </summary>
        [ReferenceTo("RequestID")]
        public ConnectionData Request
        {
            get { return request; }
            set { request = value; }
        }

        Device gateway;
        /// <summary>
        /// устройство
        /// </summary>
        [ReferenceTo("GatewayID")]
        public Device Gateway
        {
            get { return gateway; }
            set { gateway = value; }
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

        int direction = 0;
        /// <summary>
        /// 0 - от устройства к серверу
        /// 1 - от сервера к устройству
        /// </summary>
        [Column]
        public int Direction
        {
            get { return direction; }
            set { direction = value; }
        }


        int dataSize = 0;
        /// <summary>
        /// –азмер массива байт
        /// </summary>
        [Column]
        public int DataSize
        {
            get { return dataSize; }
            set { dataSize = value; }
        }

        byte[] data;
        [Column]
        public byte[] Data
        {
            get { return data; }
            set { data = value; }
        }



    }
}
