using System;
using System.Collections.Generic;

using System.Text;

namespace WebSite.Common
{
    public class Timestamp
    {
        public static DateTime GetDate(byte[] buf, int offset)
        {
            return GetDate(ByteConverter.GetUInt32(buf, offset));
        }

        public static DateTime GetDate(uint seconds)
        {
            DateTime dt = new DateTime(1970, 1, 1, 0, 0, 0);
            return dt.AddSeconds(seconds);
        }
        public static UInt32 GetTimestamp(DateTime date)
        {
            DateTime start = new DateTime(1970, 1, 1, 0, 0, 0);
            TimeSpan ts = date - start;
            return (UInt32)ts.TotalSeconds;
        }

        public static DateTime Now()
        {
            return DateTime.UtcNow;
        }

    }
}
