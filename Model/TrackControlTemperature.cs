using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using Common;

namespace TrackIt.Model
{
    [Table("TrackControlTemperatures")]
    public class TrackControlTemperature : modelObject<TrackControlTemperature>, ITrackControl
    {


        int? rangeFrom;
        [Column]
        public int? RangeFrom
        {
            get { return rangeFrom; }
            set { rangeFrom = value; }
        }

        int? rangeTo;
        [Column]
        public int? RangeTo
        {
            get { return rangeTo; }
            set { rangeTo = value; }
        }

        int period;
        [Column]
        public int Period
        {
            get { return period; }
            set { period = value; }
        }

        #region ITrackControl Members
        Track track;
        [ReferenceTo("TrackID", NotNull = true, Cascade = Castle.ActiveRecord.CascadeEnum.All)]
        public Track Track
        {
            get { return track; }
            set { track = value; }
        }
        #endregion
    }
}
