using System;
using System.Collections.Generic;
using System.Text;

namespace Common
{
    public class Temperature
    {
        public static int FromCelsiusToNative(float value)
        {
            return (int)((value + 273.15) * 100);
        }
        public static float FromNativeToCelsius(int value)
        {
            return (float)((value / 100) - 273.15);
        }
        
    }
}
