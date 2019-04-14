using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using Common;
using NHibernate.Expression;

namespace TrackIt.Model
{

    [Table("TimeZones")]
    public class UserTimeZone : localizableObject<UserTimeZone>
    {
        string timeZoneID;
        [Column]
        public string TimeZoneID
        {
            get { return timeZoneID; }
            set { timeZoneID = value; }
        }

        string name;
        [Localizable]
        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        string offset;
        public string Offset
        {
            get
            {
                if (string.IsNullOrEmpty(offset))
                {
                    if (timeZone == null)
                    {
                        timeZone = TimeZoneInfo.FindSystemTimeZoneById(TimeZoneID) ?? TimeZoneInfo.Utc;
                    }
                    int hour = timeZone.BaseUtcOffset.Hours;
                    int minute = timeZone.BaseUtcOffset.Minutes;
                    if (hour == 0 && minute == 0)
                    {
                        offset = "GMT";
                    }
                    else
                    {
                        string plusminus="-";
                        if (timeZone.BaseUtcOffset.TotalMinutes >= 0) plusminus = "+";
                        offset = string.Format("GMT{0}{1}:{2}", plusminus, Math.Abs(hour).ToString("00"), Math.Abs(minute).ToString("00"));
                    }
                }
                return offset;
            }
        }

        public string OffsetAndName
        {
            get
            {
                return Offset + " " + Name;
            }
        }

        bool display = false;
        [Column]
        public bool Display
        {
            get { return display; }
            set { display = value; }
        }

        int offsetHours;
        [Column]
        public int OffsetHours
        {
            get { return offsetHours; }
            set { offsetHours = value; }
        }

        int offsetMinutes;
        [Column]
        public int OffsetMinutes
        {
            get { return offsetMinutes; }
            set { offsetMinutes = value; }
        }

        bool isDaylightSupports;
        [Column(SqlType = "int")]
        public bool IsDaylightSupports
        {
            get { return isDaylightSupports; }
            set { isDaylightSupports = value; }
        }
        public TimeZoneInfo timeZone;



        public static void Define()
        {
            Culture culture = Culture.FindFirst();
            bool skip = true;
            foreach (TimeZoneInfo tzi in TimeZoneInfo.GetSystemTimeZones())
            {
                if (tzi.StandardName == "Тасманийское время (зима)")
                {
                    skip = false;
                    continue;
                }
                if (skip) continue;

                UserTimeZone utz = new UserTimeZone();
                utz.TimeZoneID = tzi.Id;
                utz.Name = tzi.StandardName;
                utz.OffsetHours = tzi.BaseUtcOffset.Hours;
                utz.OffsetMinutes = tzi.BaseUtcOffset.Minutes;
                utz.IsDaylightSupports = tzi.SupportsDaylightSavingTime;
                utz.currentCulture = culture;
                utz.CreateAndLocalizate();
            }
        }
    }


}
