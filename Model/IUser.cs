using System;
using System.Collections.Generic;
using System.Text;

namespace TrackIt.Model
{
    /// <summary>
    /// Mark interface for User and Company
    /// </summary>
    public interface IUser
    {
        int ID { get; set; }
        string Name { get; set; }
        string About { get; set; }
        string TempKey { get; }
        bool IsNew { get; }
        bool IsActive { get; set; }
        /// <summary>
        /// Тип объекта (для колонки типа в базе)
        /// </summary>
        int IUserType { get; }
        string IUserClassName { get; }

        WebFileLight Photo { get; set; }
        WebFileLight PhotoLight { get; set; }
    }
    public enum IUserTypes { Company = 1, WebUser = 2 }
}
