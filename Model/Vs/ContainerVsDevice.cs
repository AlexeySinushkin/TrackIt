using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;
using TrackIt.Transmission.Model;

namespace TrackIt.Model
{
    [Table("ContainerVsDevice")]
    public class ContainerVsDevice : modelObject<ContainerVsDevice>
    {
        Container container;
        [ReferenceTo("ContainerID")]
        public Container Container
        {
            get
            {
                return container;
            }
            set
            {
                container = value;
            }
        }


        Device device;
        [ReferenceTo("DeviceID")]
        public Device Device
        {
            get
            {
                return device;
            }
            set
            {
                device = value;
            }
        }

    }
}
