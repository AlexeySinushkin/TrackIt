using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using System.Text.RegularExpressions;

namespace TrackIt.Model
{
    [Table("CompanyPropertyTypes")]
    public class CompanyPropertyType : modelObject<CompanyPropertyType>
    {
        Country country;
        [ReferenceTo("CountryID")]
        public Country Country
        {
            get { return country; }
            set { country = value; }
        }

        string key;
        /// <summary>
        /// К примеру "RU-OGRN"
        /// </summary>
        [Column(Unique=true)]
        public string Key
        {
            get { return key; }
            set { key = value; }
        }

        string propertyType;
        /// <summary>
        /// К примеру date - Будет создан DateTimePicker
        /// text - просто текстбокс
        /// </summary>
        [Column]
        public string PropertyType
        {
            get { return propertyType; }
            set { propertyType = value; }
        }


        string propertyName;
        /// <summary>
        /// К примеру "ОГРН"
        /// </summary>
        [Column(100)]
        public string PropertyName
        {
            get { return propertyName; }
            set { propertyName = value; }
        }


        Regex regex;
        public Regex Regex
        {
            get
            {
                if (regex == null) regex = new Regex(pattern);
                return regex;
            }
            set { regex = value; }
        }

        string pattern;
        [Column(NotNull=true)]
        public string Pattern
        {
            get { return pattern; }
            set { pattern = value; }
        }

        string example;
        [Column(200)]
        public string Example
        {
            get { return example; }
            set { example = value; }
        }




        public string GetHtml(CompanyProperty property, string parentClientID, string parentUniqueID)
        {
            string value = (property != null) ? property.Text : "";
            bool isValid = Regex.IsMatch(value);

            switch (this.PropertyType)
            {
                case "text":
                    return string.Format("<input type=\"text\" id=\"{0}\" name=\"{1}\" value=\"{2}\" regex=\"{3}\" class=\"{4}\" onkeyup=\"Element.check(this)\" onchange=\"Element.check(this)\" />",
                        parentClientID+"_"+this.Key,parentUniqueID+"$"+this.Key,value,this.Pattern, (isValid)?"":"bad-value");
                    break;
                case "textarea":
                    //return string.Format("<textarea rows=\"2\" type=\"text\" id=\"{0}\" name=\"{1}\" regex=\"{3}\" class=\"{4}\" style=\"overflow:visible;height:auto;\" onkeyup=\"Element.check(this)\" onchange=\"Element.check(this)\" >{2}</textarea>",
                    //    parentClientID + "_" + this.Key, parentUniqueID + "$" + this.Key, value, this.Pattern, (isValid) ? "" : "bad-value");
                    break;
                case "date":
                    break;

                default:
                    break;
            }
            return "";
        }
    }
}
