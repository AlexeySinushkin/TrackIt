using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    /// <summary>
    /// тип устройства
    /// </summary>
    [Table("DeviceTypes")]
    public class DeviceType : localizableObject<DeviceType>
    {
        
        public enum DeviceTypes {Unknown=0, SensorTemperature=1, Gateway=2, Base=3, Smartphone=4 }


        public DeviceType(DeviceTypes type)
        {
            this.ID = (int)type;
        }
        public DeviceType()
        {

        }

        string key;
        [Column]
        public string Key
        {
            get { return key; }
            set { key = value; }
        }

        string name;
        [Localizable]
        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        public static implicit operator DeviceTypes(DeviceType type)
        {
            if (type == null) return DeviceTypes.Unknown;
            if (type.IsNew) return DeviceTypes.Unknown;
            return (DeviceTypes)type.ID;
        }
        public static implicit operator DeviceType(DeviceTypes type)
        {
            return new DeviceType(type);
        }
    }
}
