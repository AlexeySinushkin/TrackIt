using System;
using System.Collections.Generic;
using System.Text;

namespace Common.Attributes
{
    #region Атрибуты
    /// <summary>
    /// Этим атрибутом необходимо помечать Property
    /// Это название столбца
    /// </summary>
    [AttributeUsage(AttributeTargets.Property, AllowMultiple = false)]
    public class ColumnAttribute : Castle.ActiveRecord.PropertyAttribute
    {


        /// <summary>
        /// Атрибут которым следует помечать те 
        /// поля или свойства которые присутствую в базе данных
        /// названия должны совпадать
        /// </summary>
        /// <param name="ColumnName">Название столбца</param>
        public ColumnAttribute(string ColumnName)
        {
            this.colName = ColumnName;
        }
        /// <summary>
        /// Атрибут которым следует помечать те 
        /// поля или свойства которые присутствую в базе данных
        /// названия должны совпадать
        /// </summary>
        /// <param name="ColumnName">Название столбца</param>
        /// <param name="IsPK">Первичный ключ. В предложениях INSERT он будет опускаться</param>
        public ColumnAttribute(string ColumnName, bool IsPK)
        {
            this.colName = ColumnName;
            this.pk = IsPK;
        }
        /// <summary>
        /// Название колонки будет соотвествовать названию Свойству.
        /// </summary>
        /// <param name="ColumnName"></param>
        public ColumnAttribute()
        {
        }
        /// <summary>
        /// Название колонки будет соотвествовать названию Свойству.
        /// </summary>
        /// <param name="length">длинна колонки varchar</param>
        public ColumnAttribute(int length)
        {
            this.length = length;
        }
        /// <summary>
        /// Установить называние колонки
        /// </summary>
        /// <param name="name"></param>
        public void SetColumnName(string name)
        {
            colName = name;
        }
        /// <summary>
        /// Установить называние таблицы
        /// </summary>
        /// <param name="name"></param>
        public void SetTableName(string name)
        {
            tableName = name;
        }
        int length = 100;
        /// <summary>
        /// Длинна для varchar2 или подобных
        /// По умолчанию 100.
        /// </summary>
        public int Length
        {
            get { return length; }
            set { length = value; }
        }

        int level = 0;
        /// <summary>
        /// Уровень свойства по иерархии наследования.
        /// 0-базовый
        /// 1 и т.д. - другие таблицы
        /// </summary>
        public int Level
        {
            get { return level; }
            set { level = value; }
        }


        string colName = "";
        bool pk = false;
        /// <summary>
        /// Является ли первичным ключем
        /// </summary>
        public bool IsPK
        {
            get { return pk; }
            set { pk = value; }
        }
        /// <summary>
        /// Имя столбца таблицы
        /// </summary>
        /// <returns></returns>
        public string ColumnNameShort
        {
            get
            {
                return colName;
            }
        }

        string tableName = "";
        public string TableName
        {
            get { return tableName; }
        }
        /// <summary>
        /// Имя столбца таблицы
        /// вида Table1.Column1
        /// </summary>
        /// <returns></returns>
        public string ColumnNameLong
        {
            get
            {
                return tableName + "." + colName;
            }
        }
        /*private Type colType;
        /// <summary>
        /// Тип столбца
        /// </summary>
        public Type ColumnType
        {
            get { return colType; }
            set { colType = value; }
        }*/
        public override string ToString()
        {
            return colName;
        }
        /// <summary>
        /// Считаем, что если названия столбцов одинаковы
        /// объекты считаются одинаковыми
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public override bool Equals(object obj)
        {
            return this.ColumnNameShort.ToLower().Equals(((ColumnAttribute)obj).ColumnNameShort.ToLower());
        }
        public override int GetHashCode()
        {
            return this.ColumnNameShort.ToLower().GetHashCode();
        }
        public override bool Match(object obj)
        {
            return this.ColumnNameShort.ToLower().Equals(((ColumnAttribute)obj).ColumnNameShort.ToLower());
        }

    }

    [AttributeUsage(AttributeTargets.Property, AllowMultiple = false)]
    public class ReferenceToAttribute : Castle.ActiveRecord.BelongsToAttribute
    {
        public ReferenceToAttribute(string columnName):base(columnName)
        {            
        }
    }
    
    [AttributeUsage(AttributeTargets.Property, AllowMultiple = false)]
    public class HasManyAttribute : Castle.ActiveRecord.HasManyAttribute
    {
        public HasManyAttribute(Type mapType, string keyColumn, string table)
            : base(mapType, keyColumn, table)
        {
        }
    }

    [AttributeUsage(AttributeTargets.Property, AllowMultiple = false)]
    public class AnyAttribute : Castle.ActiveRecord.AnyAttribute
    {
        public AnyAttribute(Type idType) : base(idType) { }
    }
    [AttributeUsage(AttributeTargets.Property, AllowMultiple = true)]
    public class MetaValueAttribute : Castle.ActiveRecord.Any.MetaValueAttribute
    {
        public MetaValueAttribute(string classType, Type type) : base(classType, type) { }
    }

    /// <summary>
    /// Этим атрибутом необходимо помечать Поле или Свойство 
    /// Это название столбца
    /// </summary>
    [AttributeUsage(AttributeTargets.Property, AllowMultiple = false)]
    public class PrimaryKeyAttribute : Castle.ActiveRecord.PrimaryKeyAttribute
    {


        /// <summary>
        /// Атрибут которым следует помечать те 
        /// поля или свойства которые присутствую в базе данных
        /// названия должны совпадать
        /// </summary>
        /// <param name="ColumnName">Название столбца</param>
        public PrimaryKeyAttribute(string ColumnName)
        {
            this.colName = ColumnName;
        }
        /// <summary>
        /// Атрибут которым следует помечать те 
        /// поля или свойства которые присутствую в базе данных
        /// названия должны совпадать
        /// </summary>
        /// <param name="ColumnName">Название столбца</param>
        /// <param name="IsPK">Первичный ключ. В предложениях INSERT он будет опускаться</param>
        public PrimaryKeyAttribute(string ColumnName, bool IsPK)
        {
            this.colName = ColumnName;
            this.pk = IsPK;
        }
        /// <summary>
        /// Название колонки будет соотвествовать названию Свойству.
        /// </summary>
        /// <param name="ColumnName"></param>
        public PrimaryKeyAttribute()
        {
        }
        /// <summary>
        /// Название колонки будет соотвествовать названию Свойству.
        /// </summary>
        /// <param name="length">длинна колонки varchar</param>
        public PrimaryKeyAttribute(int length)
        {
            this.length = length;
        }
        /// <summary>
        /// Установить называние колонки
        /// </summary>
        /// <param name="name"></param>
        public void SetColumnName(string name)
        {
            colName = name;
        }
        /// <summary>
        /// Установить называние таблицы
        /// </summary>
        /// <param name="name"></param>
        public void SetTableName(string name)
        {
            tableName = name;
        }
        int length = 100;
        /// <summary>
        /// Длинна для varchar2 или подобных
        /// По умолчанию 100.
        /// </summary>
        public int Length
        {
            get { return length; }
            set { length = value; }
        }

        int level = 0;
        /// <summary>
        /// Уровень свойства по иерархии наследования.
        /// 0-базовый
        /// 1 и т.д. - другие таблицы
        /// </summary>
        public int Level
        {
            get { return level; }
            set { level = value; }
        }


        string colName = "";
        bool pk = false;
        /// <summary>
        /// Является ли первичным ключем
        /// </summary>
        public bool IsPK
        {
            get { return pk; }
            set { pk = value; }
        }
        /// <summary>
        /// Имя столбца таблицы
        /// </summary>
        /// <returns></returns>
        public string ColumnNameShort
        {
            get
            {
                return colName;
            }
        }

        string tableName = "";
        public string TableName
        {
            get { return tableName; }
        }
        /// <summary>
        /// Имя столбца таблицы
        /// вида Table1.Column1
        /// </summary>
        /// <returns></returns>
        public string ColumnNameLong
        {
            get
            {
                return tableName + "." + colName;
            }
        }
        private Type colType;
        /// <summary>
        /// Тип столбца
        /// </summary>
        public Type ColumnType
        {
            get { return colType; }
            set { colType = value; }
        }
        public override string ToString()
        {
            return colName;
        }
        /// <summary>
        /// Считаем, что если названия столбцов одинаковы
        /// объекты считаются одинаковыми
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public override bool Equals(object obj)
        {
            return this.ColumnNameShort.ToLower().Equals(((ColumnAttribute)obj).ColumnNameShort.ToLower());
        }
        public override int GetHashCode()
        {
            return this.ColumnNameShort.ToLower().GetHashCode();
        }
        public override bool Match(object obj)
        {
            return this.ColumnNameShort.ToLower().Equals(((ColumnAttribute)obj).ColumnNameShort.ToLower());
        }

    }
    
    /// <summary>
    /// Этим атрибутом необходимо помечать класс или структуру 
    /// Это название таблицы
    /// </summary>
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Struct |AttributeTargets.Interface, AllowMultiple = true, Inherited = true)]
    public class TableAttribute : Castle.ActiveRecord.ActiveRecordAttribute
    {
        public TableAttribute(string TableName)
        {
            tableName = TableName;
            this.Table = tableName;
        }
        string tableName = "";
        /// <summary>
        /// Получить имя таблицы
        /// </summary>
        /// <returns></returns>
        public string TableName
        {
            get
            {
                return tableName;
            }
        }

        int level = 0;

        /// <summary>
        /// Уровень свойства по иерархии наследования.
        /// 0-базовый
        /// 1 и т.д. - другие таблицы
        /// </summary>
        public int Level
        {
            get { return level; }
            set { level = value; }
        }
    }

    [AttributeUsage(AttributeTargets.Property, AllowMultiple = false)]
    public class LocalizableAttribute : System.Attribute
    {
    }

    [AttributeUsage(AttributeTargets.Property, AllowMultiple = false)]
    public class JSONAttribute : System.Attribute
    {
        public string Name = string.Empty;
        public bool UseQuotes = false;
        public JSONAttribute(string Name)
        {
            this.Name = Name;
        }
        public JSONAttribute(string Name,bool UseQuotes)
        {
            this.Name = Name;
            this.UseQuotes = UseQuotes;
        }
    }
    #endregion
}
