using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using Common;
using System.Globalization;

namespace TrackIt.Model
{

    [Table("GPSPoints")]
    public class GPSPoint : modelObject<GPSPoint>, ICoordinate
    {

        #region ICoordinate Members
        string name = "";
        [Column(100)]
        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        string desc = "";

        public string Description
        {
            get
            {
                return desc;
            }
            set
            {
                desc = value;
            }
        }
        int latitude;
        [Column]
        public int Latitude
        {
            get
            {
                return latitude;
            }
            set
            {
                latitude = value;
            }
        }
        int longitude;
        [Column]
        public int Longitude
        {
            get
            {
                return longitude;
            }
            set
            {
                longitude = value;
            }
        }


        public float LatDeg
        {
            get
            {
                return GPS.NativeToDeg(this.latitude);
            }
            set
            {
                this.latitude = GPS.DegToNative(value);
            }
        }

        public float LngDeg
        {
            get
            {
                return GPS.NativeToDeg(this.longitude);
            }
            set
            {
                this.longitude = GPS.DegToNative(value);
            }
        }

        public string LatDegString
        {
            get { return LatDeg.ToString("0.000000", this); }
            set
            {
                float f;
                float.TryParse(value, NumberStyles.Float, this, out f);
                LatDeg = f;
            }
        }
        public string LngDegString
        {
            get { return LngDeg.ToString("0.000000", this); }
            set
            {
                float f; 
                float.TryParse(value, NumberStyles.Float, this, out f);
                LngDeg = f;
            }
        }

        public string DescriptionEscaped
        {
            get { return desc.Replace("'", "\\'"); }
        }

        WebFileLight photo;
        //[ReferenceTo("PhotoID")]
        public WebFileLight Photo
        {
            get { return photo; }
            set { photo = value; }
        }

        WebFileLight photoLight;
        //[ReferenceTo("PhotoLightID")]
        public WebFileLight PhotoLight
        {
            get { return photoLight; }
            set { photoLight = value; }
        }

        #endregion
        /// <summary>
        /// в метрах
        /// </summary>
        /// <param name="point1"></param>
        /// <param name="point2"></param>
        /// <returns></returns>
        public static double operator -(GPSPoint point1, GPSPoint point2)
        {
            return Math.Abs(GPS.GetDistance(GPS.NativeToRad(point1.Latitude), GPS.NativeToRad(point1.Longitude), 
                GPS.NativeToRad(point2.Latitude), GPS.NativeToRad(point2.Longitude)));
        }

        #region ICoordinate Members


        public int ICoordinateType
        {
            get { return 1; }
        }

        #endregion
    }
}
