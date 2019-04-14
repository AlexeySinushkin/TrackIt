using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Globalization;

namespace Common
{
    public class FormatProvider: IFormatProvider
    {
        static FormatProvider fp;
        public static FormatProvider GetProvider()
        {
            if (fp == null) fp = new FormatProvider();
            return fp;
        }
        static FormatProvider()
        {
            // TODO: Complete member initialization
        }

        #region IFormatProvider Members

        NumberFormatInfo nfi;
        public object GetFormat(Type formatType)
        {
            if (formatType == typeof(NumberFormatInfo))
            {
                if (nfi == null)
                {
                    nfi = new NumberFormatInfo();
                    nfi.NumberDecimalSeparator = ".";
                    nfi.NumberGroupSeparator = "";
                }
                return nfi;
            }
            return null;
        }

        #endregion


    }
}
