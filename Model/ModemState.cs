using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    /// <summary>
    /// Состояние модема в пространстве и во времени.
    /// </summary>
    [Table("ModemStates")]
    public class ModemState :modelObject<ModemState>      
    {     

        int modemID;
        /// <summary>
        /// Серийный номер
        /// </summary>
        [Column("ModemID")]
        public int ModemID
        {
            get { return modemID; }
            set { modemID = value; }
        }

        DateTime theDate;
        /// <summary>
        /// Дата взятия информации
        /// </summary>
        [Column("TheDate")]
        public DateTime TheDate
        {
            get { return theDate; }
            set { theDate = value; }
        }


        #region GPS
        int gpsLatitude = -1;
        /// <summary>
        /// Широта
        /// </summary>
        [Column]
        public int GpsLatitude
        {
            get { return gpsLatitude; }
            set { gpsLatitude = value; }
        }
        int gpsLongtitude = -1;
        /// <summary>
        /// Долгота
        /// </summary>
        [Column]
        public int GpsLongtitude
        {
            get { return gpsLongtitude; }
            set { gpsLongtitude = value; }
        }
        int gpsAccuracy = -1;
        /// <summary>
        /// Точность в метрах
        /// </summary>
        [Column]
        public int GpsAccuracy
        {
            get { return gpsAccuracy; }
            set { gpsAccuracy = value; }
        }
        #endregion

    }
}
