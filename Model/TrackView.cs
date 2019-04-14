using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using System.Collections;
using Common;
using NHibernate.Expression;

namespace TrackIt.Model
{
    [Table("TracksView",DynamicUpdate=false)]
    public class TrackView : activableObject<TrackView>
    {

        //int containerType;
        //[Column]
        //public int ContainerType
        //{
        //    get { return containerType; }
        //    set { containerType = value; }
        //}
        int containerID;
        [Column]
        public int ContainerID
        {
            get { return containerID; }
            set { containerID = value; }
        }

        int senderType;
        [Column]
        public int SenderType
        {
            get { return senderType; }
            set { senderType = value; }
        }
        int senderID;
        [Column]
        public int SenderID
        {
            get { return senderID; }
            set { senderID = value; }
        }

        int carrierType;
        [Column]
        public int CarrierType
        {
            get { return carrierType; }
            set { carrierType = value; }
        }
        int carrierID;
        [Column]
        public int CarrierID
        {
            get { return carrierID; }
            set { carrierID = value; }
        }

        int recipientType;
        [Column]
        public int RecipientType
        {
            get { return recipientType; }
            set { recipientType = value; }
        }
        int recipientID;
        [Column]
        public int RecipientID
        {
            get { return recipientID; }
            set { recipientID = value; }
        }

        int startCheckPointID;
        [Column]
        public int StartCheckPointID
        {
            get { return startCheckPointID; }
            set { startCheckPointID = value; }
        }
        int stopCheckPointID;
        [Column]
        public int StopCheckPointID
        {
            get { return stopCheckPointID; }
            set { stopCheckPointID = value; }
        }


        string code;
        [Column(30)]
        public string Code
        {
            get { return code; }
            set { code = value; }
        }

        DateTime? startDate;
        [Column]
        public DateTime? StartDate
        {
            get { return startDate; }
            set { startDate = value; }
        }
        DateTime? stopDate;
        [Column]
        public DateTime? StopDate
        {
            get { return stopDate; }
            set { stopDate = value; }
        }

        string senderName;
        [Column]
        public string SenderName
        {
            get { return senderName; }
            set { senderName = value; }
        }
        string carrierName;
        [Column]
        public string CarrierName
        {
            get { return carrierName; }
            set { carrierName = value; }
        }
        string recipientName;
        [Column]
        public string RecipientName
        {
            get { return recipientName; }
            set { recipientName = value; }
        }
        string containerName;
        [Column]
        public string ContainerName
        {
            get { return containerName; }
            set { containerName = value; }
        }
        string startPointName;
        [Column]
        public string StartPointName
        {
            get { return startPointName; }
            set { startPointName = value; }
        }
        string stopPointName;
        [Column]
        public string StopPointName
        {
            get { return stopPointName; }
            set { stopPointName = value; }
        }
    }
}
