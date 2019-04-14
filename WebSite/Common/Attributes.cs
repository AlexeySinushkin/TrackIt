using System;
using System.Collections.Generic;
using System.Text;

namespace WebSite.Common
{

    [AttributeUsage(AttributeTargets.Property, AllowMultiple = false)]
    public class JSONAttribute : System.Attribute
    {
        public string Name = string.Empty;
        public bool UseQuotes = false;
        public JSONAttribute(string Name)
        {
            this.Name = Name;
        }
        public JSONAttribute(string Name,bool UseQuotes)
        {
            this.Name = Name;
            this.UseQuotes = UseQuotes;
        }
    }
 
}
