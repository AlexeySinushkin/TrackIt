using System;
using System.Collections.Generic;
using System.Text;

namespace Common
{
    public static class Str
    {
        /// <summary>
        /// Для отсечения строки определенной длинны
        /// </summary>
        /// <param name="Text"></param>
        /// <param name="Count">Длинна строки</param>
        /// <returns></returns>
        public static string Left(string Text, int Length)
        {
            if ((Text == null) || (Text == ""))
            {
                return "";
            }
            else if (Text.Length < Length)
            {
                return Text;
            }
            else
            {
                Text = Text.Remove(Length, Text.Length - Length);
                return Text;
            }
        }
        /// <summary>
        /// Оставляет спрва заданное число символов.
        /// Остальную левую часть отсекает
        /// </summary>
        /// <param name="Text"></param>
        /// <param name="Count"></param>
        /// <returns></returns>
        public static string Right(string Text, int Count)
        {
            if (Count > Text.Length)
            {
                return Text;
            }
            Text = Text.Remove(Text.Length - Count, Count);
            return Text;
        }
    }
}
