using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using Common;
using NHibernate.Expression;

namespace TrackIt.Model
{
    [Table("TrackControlCheckPoints")]
    public class TrackControlCheckPoint : modelObject<TrackControlCheckPoint>,ITrackControl
    {


        DateTime expectedDateFrom;
        [Column]
        public DateTime ExpectedDateFrom
        {
            get { return expectedDateFrom; }
            set { expectedDateFrom = value; }
        }

        DateTime expectedDateTo;
        [Column]
        public DateTime ExpectedDateTo
        {
            get { return expectedDateTo; }
            set { expectedDateTo = value; }
        }

        public void SetExpectedDate(DateTime date, int accuracy)
        {
            this.expectedDateFrom = date.AddMinutes(-accuracy);
            this.expectedDateTo = date.AddMinutes(accuracy);
        }
        public DateTime GetExpectedDate()
        {
            return expectedDateFrom.AddMinutes(GetDateAccuracy());
        }
        public int GetDateAccuracy()
        {
            return ((int)(expectedDateTo - expectedDateFrom).TotalMinutes) / 2;
        }
        public int DateAccuracy
        {
            get
            {
                return GetDateAccuracy();
            }
        }

        public CoordinateTypes CoordinateType
        {
            get 
            {
                if (coordinate == null) return CoordinateTypes.Unknown;
                if (coordinate.GetType() == typeof(Location)) return CoordinateTypes.Realty;
                if (coordinate.GetType() == typeof(GPSPoint)) return CoordinateTypes.Random;
                return CoordinateTypes.Unknown;
            }
        }



        [JSON("name",true)]  
        public string PointName
        {
            get
            {
                if (Coordinate == null) return "";
                return Coordinate.Name;
            }
            set
            {
                if (Coordinate == null) return;
                Coordinate.Name = value;
            }
        }
        public override string ToString()
        {
            return PointName;
        }
        public string PointNameEscaped
        {
            get { return Coordinate.Name.Replace("'","\\'"); }
        }
        [JSON("latitude")]  
        public string LatDegString
        {
            get { return Coordinate.LatDegString; }
        }
        [JSON("longitude")]
        public string LngDegString
        {
            get { return Coordinate.LngDegString; }
        }
        [JSON("isStart")]
        public bool isStart
        {
            get
            {
                if (Track!=null && Track.StartCheckPoint == this) return true;
                return false;
            }
        }
        [JSON("isStop")]
        public bool isStop
        {
            get
            {
                if (Track!=null && Track.StopCheckPoint == this) return true;
                return false;
            }
        }

        public string ExpectedDateFromString
        {
            get {
                if (ExpectedDateFrom.Equals(DateTime.MinValue)) return "";
                return ExpectedDateFrom.ToString(currentUser.DateTimeFormat); }
        }
        public string ExpectedDateToString
        {
            get {
                if (ExpectedDateTo.Equals(DateTime.MinValue)) return "";
                return ExpectedDateTo.ToString(currentUser.DateTimeFormat); }
        }

        public string ExpectedDateString
        {
            get
            {
                return currentUser.GetUserDateTime(GetExpectedDate()).ToString(currentUser.DateTimeFormat);
            }
        }

        ICoordinate coordinate;

        [Any(typeof(int), MetaType = typeof(int),
            TypeColumn = "CoordinateType", IdColumn = "CoordinateID", Cascade = Castle.ActiveRecord.CascadeEnum.All)]
        [MetaValue("1", typeof(Location))]
        [MetaValue("2", typeof(GPSPoint))]
        public ICoordinate Coordinate
        {
            get
            {
                return coordinate;
            }
            set
            {
                coordinate = value;
            }
        }


        #region ITrackControl Members
        Track track;
        [ReferenceTo("TrackID", NotNull=true, Cascade = Castle.ActiveRecord.CascadeEnum.None)]
        public Track Track
        {
            get { return track; }
            set { track = value; }
        }
        #endregion
    }
}
