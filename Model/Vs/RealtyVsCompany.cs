using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;

namespace Limovka.Transmission.Model
{
    [Table("RealtyVsCompany")]
    public class RealtyVsCompany : modelObject<RealtyVsCompany>
    {
        Company company;
        [ReferenceTo("CompanyID",NotNull=true)]
        public Company Company
        {
            get { return company; }
            set { company = value; }
        }

        Realty realty;
        [ReferenceTo("RealtyID", NotNull = true)]
        public Realty Realty
        {
            get { return realty; }
            set { realty = value; }
        }

    }
}
