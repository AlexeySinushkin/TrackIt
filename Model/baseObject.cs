using System;
using System.Collections.Generic;
using System.Text;
using Common.DBAdapter;
using Common;
using System.Text.RegularExpressions;
using System.Collections;
using System.Reflection;

namespace Limovka.Transmission.Model
{
    /// <summary>
    /// Базовый класс с опредленными колонками ID CreateDate
    /// </summary>
    public abstract class baseObject
    {
        int id = -1;
        /// <summary>
        /// Unique number of object
        /// Attention! Everyone Table in DataBase must have PK "ID"
        /// </summary>
        [Column("ID", true)]
        public virtual int ID
        {
            get { return id; }
            set { id = value; }
        }
        DateTime createDate = DateTime.Now;
        /// <summary>
        /// Дата Вставки в таблицу
        /// </summary>
        [Column("CREATEDATE")]
        public virtual DateTime CreateDate
        {
            get { return createDate; }
            set { createDate = value; }
        }
        /// <summary>
        /// true - новый объект. Его ID меньше или равен нулю.
        /// </summary>
        public virtual bool IsNew
        {
            get
            {
                if (this.ID > 0) return false;
                return true;
            }
        }
        /// <summary>
        /// Сохраняем текущий объект
        /// </summary>
        public virtual void Save()
        {
            throw new Exception("The method implemented. in modelObject class");
        }
    }
}
