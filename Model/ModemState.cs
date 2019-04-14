using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    /// <summary>
    /// ��������� ������ � ������������ � �� �������.
    /// </summary>
    [Table("ModemStates")]
    public class ModemState :modelObject<ModemState>      
    {     

        int modemID;
        /// <summary>
        /// �������� �����
        /// </summary>
        [Column("ModemID")]
        public int ModemID
        {
            get { return modemID; }
            set { modemID = value; }
        }

        DateTime theDate;
        /// <summary>
        /// ���� ������ ����������
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
        /// ������
        /// </summary>
        [Column]
        public int GpsLatitude
        {
            get { return gpsLatitude; }
            set { gpsLatitude = value; }
        }
        int gpsLongtitude = -1;
        /// <summary>
        /// �������
        /// </summary>
        [Column]
        public int GpsLongtitude
        {
            get { return gpsLongtitude; }
            set { gpsLongtitude = value; }
        }
        int gpsAccuracy = -1;
        /// <summary>
        /// �������� � ������
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
