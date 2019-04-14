using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("CommonContent")]
    public class CommonContent : modelObject<CommonContent>  
    {
        int parentID;
        /// <summary>
        /// ID родительского экземпляра объекта
        /// </summary>
        [Column]
        public int ParentID
        {
            get { return parentID; }
            set { parentID = value; }
        }

        string className;
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
        internal Culture Culture
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
