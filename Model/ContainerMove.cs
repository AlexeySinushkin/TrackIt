using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using Common;

namespace TrackIt.Model
{
    [Table("ContainerMove")]
    public class ContainerMove : modelObject<ContainerMove> 
    {

        DateTime sampleDate;
        [Column]
        public DateTime SampleDate
        {
            get { return sampleDate; }
            set { sampleDate = value; }
        }

        int latitude;
        [Column]        
        public int Latitude
        {
            get { return latitude; }
            set { latitude = value; }
        }

        int longitude;
        [Column]
        public int Longitude
        {
            get { return longitude; }
            set { longitude = value; }
        }

        int accuracy;
        [Column]
        public int Accuracy
        {
            get { return accuracy; }
            set { accuracy = value; }
        }

        int hwStateEvent;
        [Column]
        public int HwStateEvent
        {
            get { return hwStateEvent; }
            set { hwStateEvent = value; }
        }

        Container container;
        /// <summary>
        /// 
        /// </summary>
        [ReferenceTo("ContainerID")]
        public Container Container
        {
            get { return container; }
            set { container = value; }
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
        public static double operator -(ContainerMove point1, ContainerMove point2)
        {
            return Math.Abs(GPS.GetDistance(GPS.NativeToRad(point1.latitude), GPS.NativeToRad(point1.longitude),
                GPS.NativeToRad(point2.latitude), GPS.NativeToRad(point2.longitude)));
        }

        
    }
}
