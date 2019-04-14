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
        /// ���� ��� �����
        /// �� ������ �� ������
        /// </summary>
        [ReferenceTo("RequestID")]
        public ConnectionData Request
        {
            get { return request; }
            set { request = value; }
        }

        Device gateway;
        /// <summary>
        /// ����������
        /// </summary>
        [ReferenceTo("GatewayID")]
        public Device Gateway
        {
            get { return gateway; }
            set { gateway = value; }
        }

        Device device;
        /// <summary>
        /// ����������
        /// </summary>
        [ReferenceTo("DeviceID")]
        public Device Device
        {
            get { return device; }
            set { device = value; }
        }

        int direction = 0;
        /// <summary>
        /// 0 - �� ���������� � �������
        /// 1 - �� ������� � ����������
        /// </summary>
        [Column]
        public int Direction
        {
            get { return direction; }
            set { direction = value; }
        }


        int dataSize = 0;
        /// <summary>
        /// ������ ������� ����
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
