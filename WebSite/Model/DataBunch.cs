using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TrackIt.Model;
using TrackIt.Website.Model;

namespace TrackIt.Website.Model
{
    public class DataBunch
    {
        public List<Device> devices = new List<Device>();
        public List<DeviceMove> deviceMoves = new List<DeviceMove>();
    }
}