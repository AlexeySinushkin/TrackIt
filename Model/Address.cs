using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;
using Common;
using NHibernate.Expression;

namespace TrackIt.Model
{

    [Table("Addresses")]
    public class Address : modelObject<Address>
    {
        #region Адрес

        int country = -1;
        [Column]
        public int CountryID
        {
            get { return country; }
            set { country = value; }
        }
        public string CountryName
        {
            get { return Country.Name; }
            set
            {
                value = value.Trim();
                //если имена совпадают, знчит страна та-же
                //используем Country а не addressCountry чтобы обезопаситься от null
                if (!(this.Country.Name.ToLower() == value.ToLower()))
                {
                    //ищем таккую страну
                    addressCountry = AddressCountry.Get(Expression.Eq("Name", value));
                    if (addressCountry.IsNew)
                    {
                        //не нашли. значит создаем.
                        addressCountry.Name = value;
                        addressCountry.Create();
                        if (this.AddressChanged != null)
                        {
                            AddressChanged(addressCountry, EventArgs.Empty);
                        }
                    }
                    //назначаем новый id
                    this.country = addressCountry.ID;
                }
            }
        }
        AddressCountry addressCountry;
        public AddressCountry Country
        {
            get
            {
                if (addressCountry == null)
                {
                    addressCountry = AddressCountry.Get(country);
                }
                return addressCountry;
            }
            set
            {
                addressCountry = value;
                country = addressCountry.ID;
            }
        }


        int region = -1;
        [Column]
        public int RegionID
        {
            get { return region; }
            set { region = value; }
        }
        public string RegionName
        {
            get { return Region.Name; }
            set
            {
                value = value.Trim();
                if (!(this.Region.Name.ToLower() == value.ToLower()))
                {
                    addressRegion = AddressRegion.Get(Expression.Eq("Name", value));
                    if (addressRegion.IsNew)
                    {
                        addressRegion.Name = value;
                        addressRegion.Create();
                        if (this.AddressChanged != null)
                        {
                            AddressChanged(addressRegion, EventArgs.Empty);
                        }
                    }
                    this.country = addressRegion.ID;
                }
            }
        }
        AddressRegion addressRegion;
        public AddressRegion Region
        {
            get
            {
                if (addressRegion == null)
                {
                    addressRegion = AddressRegion.Get(region);
                }
                return addressRegion;
            }
            set
            {
                addressRegion = value;
                region = addressRegion.ID;
            }
        }




        int city = -1;
        [Column]
        public int CityID
        {
            get { return city; }
            set { city = value; }
        }
        public string CityName
        {
            get { return City.Name; }
            set
            {
                value = value.Trim();
                if (!(this.City.Name.ToLower() == value.ToLower()))
                {
                    addressCity = AddressCity.Get(Expression.Eq("Name", value));
                    if (addressCity.IsNew)
                    {
                        addressCity.Name = value;
                        addressCity.Create();
                        if (this.AddressChanged != null)
                        {
                            AddressChanged(addressCity, EventArgs.Empty);
                        }
                    }
                    this.country = addressCity.ID;
                }
            }
        }
        AddressCity addressCity;
        public AddressCity City
        {
            get
            {
                if (addressCity == null)
                {
                    addressCity = AddressCity.Get(city);
                }
                return addressCity;
            }
            set
            {
                addressCity = value;
                region = addressCity.ID;
            }
        }



        int prefix = -1;
        [Column]
        public int StreetPrefixID
        {
            get { return prefix; }
            set { prefix = value; }
        }
        public string StreetPrefixName
        {
            get { return StreetPrefix.Name; }
            set
            {
                value = value.Trim();
                if (!(this.StreetPrefix.Name.ToLower() == value.ToLower()))
                {
                    addressStreetPrefix = AddressStreetPrefix.Get(Expression.Eq("Name", value));
                    if (addressStreetPrefix.IsNew)
                    {
                        addressStreetPrefix.Name = value;
                        addressStreetPrefix.Create();
                    }
                    this.country = addressStreetPrefix.ID;
                }
            }
        }
        AddressStreetPrefix addressStreetPrefix;
        public AddressStreetPrefix StreetPrefix
        {
            get
            {
                if (addressStreetPrefix == null)
                {
                    addressStreetPrefix = AddressStreetPrefix.Get(prefix);
                }
                return addressStreetPrefix;
            }
            set
            {
                addressStreetPrefix = value;
                region = addressStreetPrefix.ID;
            }
        }




        int street = -1;
        [Column]
        public int StreetID
        {
            get { return street; }
            set { street = value; }
        }
        public string StreetName
        {
            get { return Street.Name; }
            set
            {
                value = value.Trim();
                if (!(this.Street.Name.ToLower() == value.ToLower()))
                {
                    addressStreet = AddressStreet.Get(Expression.Eq("Name", value));
                    if (addressStreet.IsNew)
                    {
                        addressStreet.Name = value;
                        addressStreet.Create();
                        if (this.AddressChanged != null)
                        {
                            AddressChanged(addressStreet, EventArgs.Empty);
                        }
                    }
                    this.country = addressStreet.ID;
                }
            }
        }
        AddressStreet addressStreet;
        public AddressStreet Street
        {
            get
            {
                if (addressStreet == null)
                {
                    addressStreet = AddressStreet.Get(street);
                }
                return addressStreet;
            }
            set
            {
                addressStreet = value;
                region = addressStreet.ID;
            }
        }




        string houseNumber = "";
        [Column(10)]
        public string HouseNumber
        {
            get { return houseNumber; }
            set { houseNumber = value; }
        }

        string flatNumber = "";
        [Column(10)]
        public string FlatNumber
        {
            get { return flatNumber; }
            set { flatNumber = value; }
        }

        string info = "";
        /// <summary>
        /// Дополнительная информация
        /// </summary>
        [Column(100)]
        public string Info
        {
            get { return info; }
            set
            {
                info = value;
            }
        }

        #region GPS
        int gpsLatitude = -1;
        /// <summary>
        /// Широта
        /// </summary>
        [Column]
        public int GpsLatitude
        {
            get { return gpsLatitude; }
            set { gpsLatitude = value; }
        }
        int gpsLongtitude = -1;
        /// <summary>
        /// Долгота
        /// </summary>
        [Column]
        public int GpsLongtitude
        {
            get { return gpsLongtitude; }
            set { gpsLongtitude = value; }
        }
        int gpsAccuracy = -1;
        /// <summary>
        /// Точность в метрах
        /// </summary>
        [Column]
        public int GpsAccuracy
        {
            get { return gpsAccuracy; }
            set { gpsAccuracy = value; }
        }
        #endregion

        #endregion

        public event EventHandler AddressChanged;
    }


}
