using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;

namespace TrackIt.Model
{

    [Table("UserVsEmail")]
    public class UserVsEmail : modelObject<UserVsEmail>
    {
        int userID = -1;
        [Column]
        public int UserID
        {
            get { return userID; }
            set { userID = value; }
        }

        int emailID = -2;
        [Column]
        public int EmailID
        {
            get { return emailID; }
            set { emailID = value; }
        }

    }
}
