using System;
using TrackIt.Website.Model;
using WebSite.Common;
using Website.Common;
using System.Globalization;
using TrackIt.Website.Model;

namespace TrackIt.Model
{
    //[Table("DeviceMove")]
    public class DeviceMove : IFormatProvider
    {

        DateTime sampleDate;
       //[Column]
        public DateTime SampleDate
        {
            get { return sampleDate; }
            set { sampleDate = value; }
        }

        int latitude;
        //[Column]        
        public int Latitude
        {
            get { return latitude; }
            set { latitude = value; }
        }

        int longitude;
        //[Column]
        public int Longitude
        {
            get { return longitude; }
            set { longitude = value; }
        }

        int accuracy;
        //[Column]
        public int Accuracy
        {
            get { return accuracy; }
            set { accuracy = value; }
        }

        int hwStateEvent;
        //[Column]
        public int HwStateEvent
        {
            get { return hwStateEvent; }
            set { hwStateEvent = value; }
        }

        Device device;
        /// <summary>
        /// 
        /// </summary>
        //[ReferenceTo("DeviceID")]
        public Device Device
        {
            get { return device; }
            set { device = value; }
        }

        string action;
        /// <summary>
        /// Действие связанное с точкой
        /// Начал движение, Остановился
        /// </summary>
        [JSON("as", UseQuotes = true)]
        public string ActionOrState
        {
            get { return action; }
            set { action = value; }
        }
        [JSON("la", UseQuotes = true)]
        public float LatitudeDegree
        {
            get
            {
                return GPS.NativeToDeg(latitude);
            }
        }
        [JSON("lo", UseQuotes = true)]
        public float LongitudeDegree
        {
            get
            {
                return GPS.NativeToDeg(longitude);
            }
        }
        public string LatitudeDegreeString
        {
            get
            {
                return LatitudeDegree.ToString("0.000000",this);
            }
        }
        public string LongitudeDegreeString
        {
            get
            {
                return LongitudeDegree.ToString("0.000000", this);
            }
        }

        /// <summary>
        /// в метрах
        /// </summary>
        /// <param name="point1"></param>
        /// <param name="point2"></param>
        /// <returns></returns>
        public static double operator -(DeviceMove point1, DeviceMove point2)
        {
            return Math.Abs(GPS.GetDistance(GPS.NativeToRad(point1.latitude), GPS.NativeToRad(point1.longitude),
                GPS.NativeToRad(point2.latitude), GPS.NativeToRad(point2.longitude)));
        }

        internal void Create()
        {
            PseudoDB.deviceMoves.Add(this);            
        }

        #region IFormatProvider Members

        static NumberFormatInfo nfi;
        public virtual object GetFormat(Type formatType)
        {
            if (formatType == typeof(NumberFormatInfo))
            {
                if (nfi == null)
                {
                    nfi = new NumberFormatInfo();
                    nfi.NumberDecimalSeparator = ".";
                    nfi.NumberGroupSeparator = "";
                }
                return nfi;
            }
            return null;
        }

        #endregion
    }
}
