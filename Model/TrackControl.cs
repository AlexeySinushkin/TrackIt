using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;
using Common;

namespace Limovka.Transmission.Model
{
    [Table("TrackControls")]
    public class TrackControl : modelObject<TrackControl>
    {
        Track track;
        [ReferenceTo("TrackID",Cascade=Castle.ActiveRecord.CascadeEnum.All)]
        public Track Track
        {
            get { return track; }
            set { track = value; }
        }


        TrackControlTypes controlType;
        [Column(ColumnType = typeof(TrackControlTypes), SqlType = "int")]
        public TrackControlTypes ControlType
        {
            get { return controlType; }
            set { controlType = value; }
        }

        ITrackControl control;
        public ITrackControl Control
        {
            get
            {
                if (control == null)
                {
                    if (controlType == TrackControlTypes.CheckPoint)
                    {
                        control = TrackControlCheckPoint.FindFirst(Expression.Eq("Control", this));
                    }
                    if (controlType == TrackControlTypes.Temperature)
                    {
                        control = TrackControlTemperature.FindFirst(Expression.Eq("Control", this));
                    }
                }
                return control;
            }
            set { control = value; }
        }
    }
}
