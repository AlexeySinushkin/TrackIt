using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("TrackStatuses")]
    public class TrackStatus : localizableObject<TrackStatus>  
    {
        public enum TrackStatuses {New=1,
            WaitingOfStart=2,//Создан сохранен в базе. Ожидается наступление время отправления.
            Tracking=3,//Отслеживается
            Finished=4,//Успешно завершено
            Cancelled=5 //Отменено
        }

        public TrackStatus()
        {
            this.ID = (int)TrackStatuses.New;
        }
        public TrackStatus(TrackStatuses status)
        {
            this.ID = (int)status;
        }
        string keyName;
        /// <summary>
        /// 
        /// </summary>
        [Column]
        public string KeyName
        {
            get { return keyName; }
            set { keyName = value; }
        }

        string name;
        [Localizable]
        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        public static implicit operator TrackStatuses(TrackStatus ts)
        {
            return (TrackStatuses)ts.ID;
        }
        public static implicit operator TrackStatus(TrackStatuses ts)
        {
            return new TrackStatus(ts);
        }

    }
}
