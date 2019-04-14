using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("Changes")]
    public class Change : modelObject<Change>
    {
        Event _event;
        [ReferenceTo("EventID")]
        public Event Event
        {
            get { return _event; }
            set { _event = value; }
        }

        string oldValue = String.Empty;
        [Column]
        public string OldValue
        {
            get { return oldValue; }
            set { oldValue = value; }
        }

        string newValue = String.Empty;
        [Column]
        public string NewValue
        {
            get { return newValue; }
            set { newValue = value; }
        }
    }
}
