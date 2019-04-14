using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;

namespace Limovka.Transmission.Model
{
    /// <summary>
    /// Некоторое объеденение физических лиц
    /// </summary>
    [Table("Families",Level=1)]
    public class Family : Company
    {

        public override int ObjectType
        {
            get
            {
                return 1;
            }
            set
            {
            }
        }

        int baseID = -1;
        [Column(Level = 1)]
        public int BaseID
        {
            get { return baseID; }
            set { baseID = value; }
        }


    }
}
