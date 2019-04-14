using System;
using System.Collections.Generic;
using System.Text;

namespace Common
{
    public class GPS
    {
        /// <summary>
        /// конвертация родных значений в градусы
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static float NativeToDeg(int value)
        {
            double rad = (float)value / 0x10000000;
            double deg= rad * (float)180 / Math.PI;
            return (float)deg;
        }
        /// <summary>
        /// конвертация градусов в родные значения
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static int DegToNative(float value)
        {
            return (int)((value * 0x10000000 * Math.PI) / 180.0);
        }
        public static float NativeToRad(int value)
        {
            return (float)((float)value / 0x10000000);
        }
        public static int RadToNative(float value)
        {
            return (int)(value * 0x10000000);
        }
        public static float DegToRad(float value)
        {
            return (float)(Math.PI * value / 180.0);
        }
        /// <summary>
        /// радиус земли в метрах
        /// </summary>
        static double earthRadius = 6366707.02;
        /// <summary>
        /// Получить дистанцию между двумя точками
        /// </summary>
        /// <param name="lat1">Широта первой точки в радианах</param>
        /// <param name="lng1">Долгота первой точки в радианах</param>
        /// <param name="lat2">Широта второй точки в радианах</param>
        /// <param name="lng2">Долгота первой точки в радианах</param>
        /// <returns></returns>
        public static double GetDistance(double lat1, double lng1,double lat2, double lng2)
        {
            double a = Math.Cos(lat1) * Math.Cos(lng1) * Math.Cos(lat2) * Math.Cos(lng2);
            double b = Math.Cos(lat1) * Math.Sin(lng1) * Math.Cos(lat2) * Math.Sin(lng2);
            double c = Math.Sin(lat1) * Math.Sin(lat2);
            double d = Math.Acos(a + b + c);
            double result= d * earthRadius;
            return result;
        }
        
    }
}
