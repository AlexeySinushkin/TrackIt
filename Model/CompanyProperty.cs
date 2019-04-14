using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("CompanyProperties")]
    public class CompanyProperty : modelObject<CompanyProperty>
    {

        Company company;
        [ReferenceTo("CompanyID")]
        public Company Company
        {
            get { return company; }
            set { company = value; }
        }

        CompanyPropertyType propertyType;
        [ReferenceTo("PropertyTypeID")]
        public CompanyPropertyType PropertyType
        {
            get { return propertyType; }
            set { propertyType = value; }
        }


        string text = String.Empty;
        [Column(200)]
        public string Text
        {
            get { return text; }
            set { text = value; }
        }


    }
}
