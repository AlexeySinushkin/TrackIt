using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using TrackIt.Model;

namespace TrackIt.Model
{
    [Table("TaskStatuses")]
    public class TaskStatus : localizableObject<TaskStatus>  
    {
        public enum TaskStatuses {New=1,
            Waiting=2,//Послано уведомление. Ожидается подключение.
            Sent=3,//Команда послана
            Success=4,//Успешно принята
            Fail=5 //Отвергнута
        }

        public TaskStatus()
        {
            this.ID = (int)TaskStatuses.New;
        }
        public TaskStatus(TaskStatuses status)
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

        public static implicit operator TaskStatuses(TaskStatus ts)
        {
            return (TaskStatuses)ts.ID;
        }
        public static implicit operator TaskStatus(TaskStatuses ts)
        {
            return new TaskStatus(ts);
        }
    }
}
