using System;
using System.Collections.Generic;
using System.Text;

namespace TrackIt.Model
{
    public enum CoordinateTypes {Unknown=0, Realty=1, Random=2 }
    public interface ICoordinate
    {
        int ID { get; set; }
        /// <summary>
        /// ICoordinateType 
        /// ContainerMove - 1
        /// Realty - 2
        /// </summary>
        int ICoordinateType { get; }
        string Name { get; set; }
        string Description { get; set; }
        string DescriptionEscaped { get; }
        string TempKey { get; }
        int Latitude { get; set; }
        int Longitude { get; set; }
        float LatDeg { get; set; }
        float LngDeg { get; set; }
        string LatDegString { get; set; }
        string LngDegString { get; set; }

        WebFileLight Photo { get; set; }
        WebFileLight PhotoLight { get; set; }

    }
}
