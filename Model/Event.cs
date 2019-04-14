using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using System.Web;

namespace TrackIt.Model
{
    [Table("Events")]
    public class Event : modelObject<Event>
    {
        public void Init(WebUser wu,IUser actor)
        {
            eventDate = DateTime.UtcNow;
            sessionUser = wu;
            ActorType = ObjectType.Get(actor.IUserClassName);
            ActorID = actor.ID;
        }

        EventType eventType;
        /// <summary>
        /// Тип события
        /// </summary>
        [ReferenceTo("EventTypeID")]
        public EventType EventType
        {
            get { return eventType; }
            set { eventType = value; }
        }

        DateTime eventDate;
        /// <summary>
        /// Дата события (GMT)
        /// </summary>
        [Column]
        public DateTime EventDate
        {
            get { return eventDate; }
            set { eventDate = value; }
        }

        ObjectType actorType;
        /// <summary>
        /// Тип того, кто произвел событие
        /// </summary>
        [ReferenceTo("ActorTypeID")]
        public ObjectType ActorType
        {
            get { return actorType; }
            set { actorType = value; }
        }
        int? actorID;
        [Column]
        public int? ActorID
        {
            get { return actorID; }
            set { actorID = value; }
        }

        


        ObjectType passiveType;
        /// <summary>
        /// Тип того, над кем произошло событие, либо любой другой тип в зависимости от ситуации
        /// Может быть NULL
        /// </summary>
        [ReferenceTo("PassiveTypeID")]
        public ObjectType PassiveType
        {
            get { return passiveType; }
            set { passiveType = value; }
        }
        /// <summary>
        /// 
        /// </summary>
        int? passiveID;
        [Column]
        public int? PassiveID
        {
            get { return passiveID; }
            set { passiveID = value; }
        }

        WebUser sessionUser;
        [ReferenceTo("SessionUserID")]
        public WebUser SessionUser
        {
            get { return sessionUser; }
            set { sessionUser = value; }
        }


        string actorName;
        public string ActorName
        {
            get
            {
                if (string.IsNullOrEmpty(actorName) && actorID.HasValue)
                {
                    actorName = actorType.GetObjectName(actorID.Value);
                }
                return actorName;
            }
            set { actorName = value; }
        }

        string passiveName;
        public string PassiveName
        {
            get
            {
                if (string.IsNullOrEmpty(passiveName) && passiveID.HasValue)
                {
                    passiveName = passiveType.GetObjectName(passiveID.Value);
                }
                return passiveName;
            }
            set { passiveName = value; }
        }

        //IList<Change> changes;
        //[HasMany(typeof(Change),"EventID","Changes")]
        //public IList<Change> Changes
        //{
        //    get { return changes; }
        //    set { changes = value; }
        //}
    }
}
