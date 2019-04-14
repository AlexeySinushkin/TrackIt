using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using NHibernate.Expression;

namespace TrackIt.Model
{
    [Table("EventTypes")]
    public class EventType : localizableObject<EventType>
    {
        public static EventType Get(string key)
        {
            EventType evt = EventType.FindFirst(Expression.Eq("Key", key));
            if (evt == null)
            {
                evt = new EventType();
                evt.key = key;
                evt.CreateAndFlush();
            }
            return evt;
        }

        string key;
        [Column]
        public string Key
        {
            get { return key; }
            set { key = value; }
        }


        string name;
        [Localizable]
        public string Name
        {
            get { return name; }
            set { name = value; }
        }
    }
}
