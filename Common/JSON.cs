using System;
using System.Collections.Generic;
using System.Text;
using System.Reflection;
using Common.Attributes;
using System.Collections;

namespace Common
{
    public class JSON
    {
        public static string Convert(object obj)
        {
            return Convert(obj, true);
        }
        static string Convert(object obj, bool withQuotes)
        {
           Type objType = obj.GetType();
            Dictionary<PropertyInfo, JSONAttribute> targetProperties = new Dictionary<PropertyInfo, JSONAttribute>();
            foreach (PropertyInfo pi in objType.GetProperties())
            {
                object[] atrs = pi.GetCustomAttributes(typeof(JSONAttribute), true);
                if (atrs == null || atrs.Length == 0) continue;
                targetProperties.Add(pi, (JSONAttribute)atrs[0]);
            }
            StringBuilder sb = new StringBuilder();
            if (withQuotes) sb.Append("(");
            sb.Append("{");
            bool isFirst = true;
            foreach (PropertyInfo pi in targetProperties.Keys)
            {
                if (!isFirst)
                {
                    sb.Append(", ");
                }
                isFirst = false;
                sb.Append(targetProperties[pi].Name);
                sb.Append(":");
                object value=pi.GetValue(obj, null);                
                if (targetProperties[pi].UseQuotes)
                {
                    sb.Append("'");
                }
                if (pi.PropertyType == typeof(bool))
                {
                    sb.Append(value.ToString().ToLower());
                }
                else if (pi.PropertyType ==typeof(double)
                    || pi.PropertyType == typeof(float))
                {
                    sb.Append(value.ToString().Replace(",", "."));
                }
                else
                {
                    if (value != null) sb.Append(value.ToString().Replace("'", "\\'"));
                }
                if (targetProperties[pi].UseQuotes)
                {
                    sb.Append("'");
                }

            }
            sb.Append("}");
            if (withQuotes) sb.Append(")");
            return sb.ToString();
        }
        public static string Convert(IEnumerable objs)
        {
            IEnumerator enumerator = objs.GetEnumerator();
            StringBuilder sb = new StringBuilder();
            bool isFirst = true;
            sb.Append("[");
            while (enumerator.MoveNext())
            {
                if (!isFirst)
                {
                    sb.Append(", ");
                }
                isFirst = false;
                sb.Append(Convert(enumerator.Current,false));
            }
            sb.Append("]");
            return sb.ToString();
        }
    }
}
