using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("LocationVsUser")]
    public class LocationVsIUser : modelObject<LocationVsIUser>
    {


        IUser user;
        [Any(typeof(int), MetaType = typeof(int),
            TypeColumn = "IUserType", IdColumn = "IUserID", Cascade = Castle.ActiveRecord.CascadeEnum.SaveUpdate)]
        [MetaValue("1", typeof(Company))]
        [MetaValue("2", typeof(WebUser))]
        public IUser IUser
        {
            get
            {
                return user;
            }
            set
            {
                user = value;
            }
        }

        Location realty;
        [ReferenceTo("LocationID",NotNull=true)]
        public Location Location
        {
            get { return realty; }
            set { realty = value; }
        }

    }
}
