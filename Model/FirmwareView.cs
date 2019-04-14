using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using System.Collections;
using Common;
using NHibernate.Expression;

namespace TrackIt.Model
{
    [Table("FirmwaresView",DynamicUpdate=false)]
    public class FirmwareView : activableObject<FirmwareView>
    {

        [Column]
        public byte VerMaj { get; set; }
        [Column]
        public byte VerMin { get; set; }
        [Column]
        public UInt16 VerSVN { get; set; }

        [Column]
        public string Version { get; set; }

        [ReferenceTo("DeviceTypeID")]
        public DeviceType DeviceType { get; set; }


        public string DeviceTypeName
        {
            get
            {
                if (DeviceType == null) return "";
                DeviceType.Localizate();
                return DeviceType.Name;
            }
        }
    }
}
