using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("WebUIContent")]
    public class WebUIContent : modelObject<WebUIContent>  
    {

        string className="index";
        [Column]
        public string ClassName
        {
            get { return className; }
            set { className = value; }
        }
        string propertyName;
        [Column]
        public string PropertyName
        {
            get { return propertyName; }
            set { propertyName = value; }
        }
        Culture culture;
        [ReferenceTo("CultureID")]
        public Culture Culture
        {
            get { return culture; }
            set { culture = value; }
        }
        string text;
        [Column]
        public string Text
        {
            get { return text; }
            set { text = value; }
        }
    }
}
