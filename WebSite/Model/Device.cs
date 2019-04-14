using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.Serialization;
using System.Web;
using TrackIt.Website.Model;

namespace TrackIt.Website.Model
{

    public class Device 
    {

        public Device()
        {

        }


        public Device(Int64 imei)
        {
            this.serialNumber = imei;
        }

        Int64 serialNumber;
        /// <summary>
        /// Серийный номер
        /// </summary>
        public Int64 SerialNumber
        {
            get { return serialNumber; }
            set { serialNumber = value; }
        }



        DateTime? connectionDate;
        //[Column]
        public DateTime? ConnectionDate
        {
            get { return connectionDate; }
            set { connectionDate = value; }
        }

        public string SerialAsString
        {
            get
            {
                return serialNumber.ToString("D15");
            }
        }

        internal void Create()
        {
            PseudoDB.devices.Add(this);
        }
    }
}
