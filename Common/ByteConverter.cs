using System;
using System.Collections.Generic;
using System.Text;

namespace Common
{
    public class ByteConverter
    {
        public static UInt32 GetUInt32(byte[] buf, int offset)
        {
            return BitConverter.ToUInt32(buf, offset);
        }
        public static Int32 GetInt32(byte[] buf, int offset)
        {
            return BitConverter.ToInt32(buf, offset);
        }
        public static UInt16 GetUInt16(byte[] buf, int offset)
        {
            return BitConverter.ToUInt16(buf, offset);
        }
        
        public static byte[] GetBytes(UInt32 value)
        {
            return BitConverter.GetBytes(value);
        }
    }
}
