using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using System.Collections;
using Common;
using NHibernate.Expression;

namespace TrackIt.Model
{
    [Table("Tracks")]
    public class Track : activableObject<Track>
    {

        IList<ITrackControl> controls;
        public IList<ITrackControl> TrackControls
        {
            get
            {
                if (controls == null)
                {
                    controls = new List<ITrackControl>();
                    if (!this.IsNew)
                    {
                        controls.Add(TrackControlCheckPoint.FindFirst(Expression.Eq("Track", this)));
                        controls.Add(TrackControlTemperature.FindFirst(Expression.Eq("Track", this)));
                    }
                }
                return controls;
            }
            set
            {
                controls = value;
            }
        }


    //    ITrackContainer container;
    //    [Any(typeof(int), MetaType = typeof(int),
    //TypeColumn = "ContainerType", IdColumn = "ContainerID", 
    //Cascade = Castle.ActiveRecord.CascadeEnum.None)]
    //    [MetaValue("1", typeof(Trailer))]
    //    public ITrackContainer Container
    //    {
    //        get { return container; }
    //        set { container = value; }
    //    }

        Container container;
        [ReferenceTo("ContainerID")]
        public Container Container
        {
            get { return container; }
            set { container = value; }
        }

        IUser sender;
        [Any(typeof(int), MetaType = typeof(int),
            TypeColumn = "SenderType", IdColumn = "SenderID",
            Cascade = Castle.ActiveRecord.CascadeEnum.None)]
        [MetaValue("1", typeof(Company))]
        [MetaValue("2", typeof(WebUser))]
        public IUser Sender
        {
            get
            {
                return sender;
            }
            set
            {
                sender = value;
            }
        }

        IUser carrier;
        [Any(typeof(int), MetaType = typeof(int),
            TypeColumn = "CarrierType", IdColumn = "CarrierID",
            Cascade = Castle.ActiveRecord.CascadeEnum.None)]
        [MetaValue("1", typeof(Company))]
        [MetaValue("2", typeof(WebUser))]
        public IUser Carrier
        {
            get
            {
                return carrier;
            }
            set
            {
                carrier = value;
            }
        }

        IUser recipient;
        [Any(typeof(int), MetaType = typeof(int),
            TypeColumn = "RecipientType", IdColumn = "RecipientID",
            Cascade = Castle.ActiveRecord.CascadeEnum.None)]
        [MetaValue("1", typeof(Company))]
        [MetaValue("2", typeof(WebUser))]
        public IUser Recipient
        {
            get
            {
                return recipient;
            }
            set
            {
                recipient = value;
            }
        }

        TrackControlCheckPoint startCheckPoint;
        [ReferenceTo("StartCheckPointID")]
        public TrackControlCheckPoint StartCheckPoint
        {
            get { return startCheckPoint; }
            set { startCheckPoint = value; }
        }

        TrackControlCheckPoint stopCheckPoint;
        [ReferenceTo("StopCheckPointID")]
        public TrackControlCheckPoint StopCheckPoint
        {
            get { return stopCheckPoint; }
            set { stopCheckPoint = value; }
        }

        TrackStatus status; 
        [ReferenceTo("TrackStatusID")]
        public TrackStatus Status
        {
            get { return status; }
            set { status = value; }
        }


        string code;
        [Column(30)]
        public string Code
        {
            get { return code; }
            set { code = value; }
        }
        public static string GenerateTrackCode(Track track)
        {
            return string.Format("{0}-{1}", track.IsNew ? "NEW" : track.ID.ToString(), Guid.NewGuid().ToString().Substring(0, 5).ToUpper());
        }

        DateTime? startDate;
        [Column]
        public DateTime? StartDate
        {
            get { return startDate; }
            set { startDate = value; }
        }

        DateTime? stopDate;
        [Column]
        public DateTime? StopDate
        {
            get { return stopDate; }
            set { stopDate = value; }
        }

        public DateTime GetStartDate()
        {
            DateTime date = startDate.HasValue ? startDate.Value : DateTime.UtcNow.AddYears(-100);
            return date;
        }
        public DateTime GetStopDate()
        {
            DateTime date = DateTime.UtcNow.AddYears(-100).AddMinutes(2);
            if (this.stopDate.HasValue) date = this.stopDate.Value;
            if (this.status!=null && this.status.ID == (int)TrackStatus.TrackStatuses.Tracking)
            {
                date = DateTime.UtcNow;
            }
            return date;
        }
    }
}
