using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using Common;

namespace TrackIt.Model
{
    /// <summary>
    /// Недвижимость
    /// </summary>
    [Table("Location")]
    public class Location : localizableObject<Location>,ICoordinate
    {

        IList<LocationVsIUser> relations;
        [HasMany(typeof(LocationVsIUser), "LocationID", "LocationVsUser")]
        public IList<LocationVsIUser> Relations
        {
            get { return relations; }
            set { relations = value; }
        }

        string name = "";
        [Column]
        public string Name
        {
            get { return name; }
            set { name = value; }
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

        string phone;
        [Column(100)]
        public string Phone
        {
            get { return phone; }
            set { phone = value; }
        }

        string addressInfo;
        [Column(500)]
        public string AddressInfo
        {
            get { return addressInfo; }
            set { addressInfo = value; }
        }


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

        #region ICoordinate Members
        string desc = "";
        [Localizable]
        public string Description
        {
            get
            {
                return desc;
            }
            set
            {
                desc = value;
            }
        }
        int latitude;
        [Column]
        public int Latitude
        {
            get
            {
                return latitude;
            }
            set
            {
                latitude = value;
            }
        }
        int longitude;
        [Column]
        public int Longitude
        {
            get
            {
                return longitude;
            }
            set
            {
                longitude = value;
            }
        }

        
        
        public float LatDeg
        {
            get
            {
                return GPS.NativeToDeg(this.latitude);
            }
            set
            {
                this.latitude = GPS.DegToNative(value);
            }
        }

        public float LngDeg
        {
            get
            {
                return GPS.NativeToDeg(this.longitude);
            }
            set
            {
                this.longitude = GPS.DegToNative(value);
            }
        }

        public string LatDegString
        {
            get { return LatDeg.ToString("0.000000", this); }
            set { LatDeg = float.Parse(value, this); }
        }
        public string LngDegString
        {
            get { return LngDeg.ToString("0.000000", this); }
            set { LngDeg = float.Parse(value, this); }
        }

        public string DescriptionEscaped
        {
            get { return desc.Replace("'", "\\'"); }
        }

        #endregion


        #region ICoordinate Members


        public int ICoordinateType
        {
            get
            {
                return 2;
            }
        }

        #endregion
    }
}
