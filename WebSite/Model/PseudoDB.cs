using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TrackIt.Model;
using TrackIt.Website.Model;

namespace TrackIt.Website.Model
{
    public class PseudoDB
    {
        public static List<Device> devices
        {
            get
            {
                return getDataBunch().devices;
            }
        }
        public static List<DeviceMove> deviceMoves
        {
            get
            {
                return getDataBunch().deviceMoves;
            }
        }

        public static DataBunch getDataBunch()
        {
            if (HttpContext.Current.Cache["dataBunch"] == null)
            {
                HttpContext.Current.Cache["dataBunch"] = new DataBunch();
            }
            return (DataBunch)HttpContext.Current.Cache["dataBunch"];
        }

        internal static Device GetDevice(Int64 imei)
        {
            var result = getDataBunch().devices.Find(p => p.SerialNumber == imei);
            if (result == null)
            {                
                result = new Device(imei);
                getDataBunch().devices.Add(result);
            }
            return result;
        }
    }
}