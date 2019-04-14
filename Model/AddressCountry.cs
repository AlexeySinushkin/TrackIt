using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;

namespace TrackIt.Model
{
    [Table("AddressCountry")]
    public class AddressCountry : modelObject<AddressCountry>
    {

        string name = "";
        /// <summary>
        /// �������� ������
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
    }
}
