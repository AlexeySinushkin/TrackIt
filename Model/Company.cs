using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    /// <summary>
    /// Компания
    /// </summary>
    [Table("Companies")]
    public class Company: localizableObject<Company>,IUser
    {



        string name = "";
        /// <summary>
        /// Название компании
        /// </summary>
        [Column(100)]
        public string Name
        {
            get { return name; }
            set
            {
                name = value;
            }
        }


        string about;
        [Localizable]
        public string About
        {
            get { return about; }
            set { about = value; }
        }
        public override string ToString()
        {
            
           return Name;

        }


        IList<CompanyProperty> properties;
        [HasMany(typeof(CompanyProperty), "CompanyID", "CompanyProperties")] //FIXME: ,Lazy=true CompanyControl initProperties() problem
        public virtual IList<CompanyProperty> Properties
        {
            get { return properties; }
            set { properties = value; }
        }

        string website;
        [Column(100)]
        public string Website
        {
            get { return website; }
            set { website = value; }
        }

        string email;
        [Column(100)]
        public string EMail
        {
            get { return email; }
            set { email = value; }
        }

        Country country;
        [ReferenceTo("CountryID")]
        public Country Country
        {
            get { return country; }
            set { country = value; }
        }

        string province;
        [Column(100)]
        public string Province
        {
            get { return province; }
            set { province = value; }
        }

        string zip;
        [Column(30)]
        public string ZIP
        {
            get { return zip; }
            set { zip = value; }
        }

        string city;
        [Column(100)]
        public string City
        {
            get { return city; }
            set { city = value; }
        }

        string street;
        [Column(100)]
        public string Street
        {
            get { return street; }
            set { street = value; }
        }

        string buildNumer;
        [Column(100)]
        public string BuildNumber
        {
            get { return buildNumer; }
            set { buildNumer = value; }
        }

        string addressInfo;
        [Column(500)]
        public string AddressInfo
        {
            get { return addressInfo; }
            set { addressInfo = value; }
        }

        bool isActive = true;
        [Column]
        public bool IsActive { get { return isActive; } set { isActive = value; } }


        WebFileLight photo;
        [ReferenceTo("PhotoID")]
        public WebFileLight Photo
        {
            get { return photo; }
            set { photo = value; }
        }

        WebFileLight photoLight;
        [ReferenceTo("PhotoLightID")]
        public WebFileLight PhotoLight
        {
            get { return photoLight; }
            set { photoLight = value; }
        }


        public int IUserType
        {
            get { return 1; }
        }

        public string IUserClassName
        {
            get { return "Company"; }
        }
    }
}
