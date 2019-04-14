using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;

namespace TrackIt.Model
{
    [Table("AddressCity")]
    public class AddressCity : modelObject<AddressCity>
    {

        string name = "";
        /// <summary>
        /// Название города
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
