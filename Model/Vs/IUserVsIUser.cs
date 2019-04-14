using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("IUserVsIUser")]
    public class IUserVsIUser : modelObject<IUserVsIUser>
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

        IUser relationIUser;
        [Any(typeof(int), MetaType = typeof(int),
            TypeColumn = "RelationIUserType", IdColumn = "RelationIUserID", Cascade = Castle.ActiveRecord.CascadeEnum.SaveUpdate)]
        [MetaValue("1", typeof(Company))]
        [MetaValue("2", typeof(WebUser))]
        public IUser RelationIUser
        {
            get
            {
                return relationIUser;
            }
            set
            {
                relationIUser = value;
            }
        }

    }
}
