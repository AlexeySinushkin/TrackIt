using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using TrackIt.Model;
using System.Text.RegularExpressions;

namespace TrackIt.Website
{
    public class TextDate
    {
        static Regex rLastDigit = new Regex("(?<second>[0-9]{0,1})(?<first>[0-9]{1})$");

        public static string GetText(TimeSpan ts)
        {
            StringBuilder sb = new StringBuilder();

            //if (cult == null)
            //{
            int totalDays = (int)ts.TotalDays;
                if ((int)ts.TotalDays > 0)
                {
                    sb.Append(totalDays.ToString());
                    sb.Append(" ");
                    sb.Append(getDaysPostfix(totalDays));
                    sb.Append(" ");
                }
                if (ts.Hours > 0)
                {
                    sb.Append(ts.Hours.ToString());
                    sb.Append(" ");
                    sb.Append(getHoursPostfix(ts.Hours));
                    sb.Append(" ");
                }
                if (ts.Minutes > 0)
                {
                    sb.Append(ts.Minutes);
                    sb.Append(" ");
                    sb.Append(getMinutesPostfix(ts.Minutes));
                }
                if (ts.TotalSeconds < 60 && ts.TotalSeconds > 0)
                {
                    sb.Append("меньше минуты");
                }
            //}
            return sb.ToString();
        }

        static string getDaysPostfix(int number)
        {
            Match m=rLastDigit.Match(number.ToString("D8"));
            int f=int.Parse(m.Groups["first"].Value);
            int s = int.Parse(m.Groups["second"].Value);

            if (s == 1) return "дней";//10 дней, 16 дней
            if (f == 0) return "дней";//20 дней, 30 дней
            if (f==1)return "день";
            if (f>=2 && f<=4)return "дня";
            if (f >= 5 && f <= 9) return "дней";
            return "days";
        }
        static string getHoursPostfix(int number)
        {
            Match m = rLastDigit.Match(number.ToString("D8"));
            int f = int.Parse(m.Groups["first"].Value);
            int s = int.Parse(m.Groups["second"].Value);

            if (s == 1) return "часов";
            if (f == 0) return "часов";
            if (f == 1) return "час";
            if (f >= 2 && f <= 4) return "часа";
            if (f >= 5 && f <= 9) return "часов";
            return "hours";
        }
        static string getMinutesPostfix(int number)
        {
            Match m = rLastDigit.Match(number.ToString("D8"));
            int f = int.Parse(m.Groups["first"].Value);
            int s = int.Parse(m.Groups["second"].Value);

            if (s == 1) return "минут";
            if (f == 0) return "минут";
            if (f == 1) return "минуту";
            if (f >= 2 && f <= 4) return "минуты";
            if (f >= 5 && f <= 9) return "минут";
            return "minutes";
        }
    }
}