using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;

namespace TrackIt.Model
{
    /// <summary>
    /// Таблица связывающая пользователя и объединение
    /// Создана в результате необходимости иметь связь * *
    /// </summary>
    [Table("UserVsPhone")]
    public class UserVsPhone : modelObject<UserVsPhone>
    {
        int userID = -1;
        [Column]
        public int UserID
        {
            get { return userID; }
            set { userID = value; }
        }
        int phoneID = -1;
        [Column]
        public int PhoneID
        {
            get { return phoneID; }
            set { phoneID = value; }
        }

    }
}
