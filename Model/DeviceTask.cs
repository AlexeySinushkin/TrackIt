using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;


namespace TrackIt.Model
{
    [Table("DeviceTasks")]
    public class DeviceTask : modelObject<DeviceTask>      
    {

        Device device;
        /// <summary>
        /// устройство
        /// </summary>
        [ReferenceTo("DeviceID")]
        public Device Device
        {
            get { return device; }
            set { device = value; }
        }

        byte taskType;
        [Column]
        public byte TaskType
        {
            get { return taskType; }
            set { taskType = value; }
        }

        bool mandatory;
        [Column]
        public bool Mandatory
        {
            get { return mandatory; }
            set { mandatory = value; }
        }

        TaskStatus status;
        [ReferenceTo("TaskStatusID")]
        public TaskStatus Status
        {
            get { return status; }
            set { status = value; }
        }

        DateTime uploadDate;
        /// <summary>
        /// После достижения этой даты, следует задачу загружать
        /// </summary>
        [Column]
        public DateTime UploadDate
        {
            get { return uploadDate; }
            set { uploadDate = value; }
        }

        DateTime? sentDate;
        [Column]
        public DateTime? SentDate
        {
            get { return sentDate; }
            set { sentDate = value; }
        }

        DateTime? endDate;
        [Column]
        public DateTime? EndDate
        {
            get { return endDate; }
            set { endDate = value; }
        }

        Track track;
        [ReferenceTo("TrackID")]
        public Track Track
        {
            get { return track; }
            set { track = value; }
        }

        byte[] data;
        [Column]
        public byte[] Data
        {
            get { return data; }
            set { data = value; }
        }

    }
}
