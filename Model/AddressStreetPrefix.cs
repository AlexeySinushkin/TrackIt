using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;

namespace TrackIt.Model
{
    [Table("AddressStreetPrefix")]
    public class AddressStreetPrefix : modelObject<AddressStreetPrefix>
    {

        string name = "";
        /// <summary>
        /// проспект улица переулок 
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
        public enum Prefix { Avenue = 1, Street = 2, Alley =3}
    }
}
