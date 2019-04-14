using System;
using System.Collections.Generic;
using System.Text;

namespace TrackIt.Model
{
    /// <summary>
    /// Interface for Trailers, some boxes etc
    /// </summary>
    public interface ITrackContainer
    {
        int ID { get; set; }

        IUser Owner { get; set; }
        /// <summary>
        /// Допустим гос номер, если это трейлер
        /// или адрес, если это складское помещение
        /// </summary>
        string Name { get; }
        /// <summary>
        /// Дополнительное описание. Скажем количество дверей.
        /// или объем помещения.
        /// </summary>
        string About { get; }
        string TempKey { get; }
        /// <summary>
        /// Тип объекта (для колонки типа в базе)
        /// </summary>
        int ITrackContainerType { get; }
        WebFileLight Photo { get; set; }
        WebFileLight PhotoLight { get; set; }
    }
}
