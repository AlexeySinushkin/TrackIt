using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;

namespace TrackIt.Model
{
    [Table("AddressRegion")]
    public class AddressRegion : modelObject<AddressRegion>
    {

        string name = "";
        /// <summary>
        /// Название области, республики, штата
        /// </summary>
        [Column(100)]
        public string Name
        {
            get
            {
                return name;
            }
            set
            {
                name = value;
            }
        }
    }
}
