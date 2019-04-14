using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    /// <summary>
    /// Даты характерезующие отслеживание
    /// Дата создания
    /// Дата начала
    /// Дата окончания и т.д.
    /// </summary>
    [Table("TrackDates")]
    public class TrackDate : localizableObject<TrackDate>
    {
        public enum TrackDateTypes {CreateDate=1, StartDate=2, StopDate=3 }
        string text;
        [Localizable]
        public string Text
        {
            get { return text; }
            set {text = value; }
        }

    }
}
