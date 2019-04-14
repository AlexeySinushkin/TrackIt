using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;

namespace Limovka.Transmission.Model
{
    [Table("RealtyVsUser")]
    public class RealtyVsUser : modelObject<RealtyVsUser>
    {
        WebUser user;
        [ReferenceTo("UserID",NotNull=true)]
        public WebUser User
        {
            get { return user; }
            set { user = value; }
        }

        Realty realty;
        [ReferenceTo("RealtyID",NotNull=true)]
        public Realty Realty
        {
            get { return realty; }
            set { realty = value; }
        }

    }
}
