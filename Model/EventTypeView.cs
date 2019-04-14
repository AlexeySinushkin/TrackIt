using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using NHibernate.Expression;

namespace TrackIt.Model
{
    [Table("EventTypesView")]
    public class EventTypeView : modelObject<EventTypeView>
    {

        string key;
        [Column]
        public string Key
        {
            get { return key; }
            set { key = value; }
        }


        string name;
        [Column]
        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        int? cultureID;
        [Column]
        public int? CultureID
        {
            get { return cultureID; }
            set { cultureID = value; }
        }
    }
}
