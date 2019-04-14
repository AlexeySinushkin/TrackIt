using System;
using TrackIt.Model;
using Common.Attributes;
namespace TrackIt.Transmission.Model
{
    public interface IDevice
    {
        DeviceType DeviceType { get; set; }
        string SerialAsString { get; }
        long SerialNumber { get; set; }
    }
}
