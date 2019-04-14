using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    /// <summary>
    /// Физическое лицо.
    /// </summary>
    [Table("Monitoring")]
    public class Monitoring : modelObject<Monitoring>
    {

        DateTime planeStartDate = DateTime.Now;
        [Column]
        public DateTime PlaneStartDate
        {
            get { return planeStartDate; }
            set { planeStartDate = value; }
        }

        DateTime planeStopDate = DateTime.Now;
        [Column]
        public DateTime PlaneStopDate
        {
            get { return planeStopDate; }
            set { planeStopDate = value; }
        }


        int intervalServer = 600;
        [Column]
        public int IntervalServer
        {
            get { return intervalServer; }
            set { intervalServer = value; }
        }

        int intervalModem = 300;
        [Column]
        public int IntervalModem
        {
            get { return intervalModem; }
            set { intervalModem = value; }
        }

    }
}
