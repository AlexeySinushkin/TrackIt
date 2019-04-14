using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("Cultures")]
    public class Culture : activableObject<Culture>  
    {
        string culture;
        /// <summary>
        /// ru-RU или en-EN
        /// </summary>
        [Column]
        public string CultureName
        {
            get { return culture; }
            set { culture = value; }
        }
    }
}
