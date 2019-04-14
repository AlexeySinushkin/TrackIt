using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("NotificationRules")]
    public class NotificationRule : modelObject<NotificationRule>
    {
        EventType eventType;
        [ReferenceTo("EventTypeID")]
        public EventType EventType
        {
            get { return eventType; }
            set { eventType = value; }
        }


        string text = String.Empty;
        [Column]
        public string Text
        {
            get { return text; }
            set { text = value; }
        }
    }
}
