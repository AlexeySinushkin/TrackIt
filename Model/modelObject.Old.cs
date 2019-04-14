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
    public class modelObjectOld<T>:baseObject,IEnumerable,IEnumerator
        where T:modelObjectOld<T>
    {
        /// <summary>
        /// Processing Object
        /// </summary>
        DBAdapter<T> workDb;
        /// <summary>
        /// Current Object
        /// </summary>
        T currentObj;
        /// <summary>
        /// Тип текущего объекта.
        /// </summary>
        Type currentType;
        LanguageExtender le;

        /// <summary>
        /// Словарь в котором ключ - название поля или свойства
        /// а значение - его значение ему соответствующего
        /// Нужен для доступа к полям по индексу
        /// <value>Имя поля. Не его значение!</value>
        /// </summary>
        protected Dictionary<int, string> propertyDictionary;
        
        public modelObjectOld()
        {
            currentType = this.GetType();
            if (Config.OSType == Config.OSTypes.Unix)
            {
                DBToolkit dbtk = new DBToolkit();
                dbtk.Connection = new System.Data.OracleClient.OracleConnection(Config.DbConnectionString);
                dbtk.Command = dbtk.Connection.CreateCommand();
                dbtk.Command.Connection = dbtk.Connection;
                workDb = new DBAdapter<T>(dbtk, typeof(T));
                workDb.SetFactory(Config.DBFactory);
            }
            else
            {
                workDb = new DBAdapter<T>(Config.DbConnectionString, currentType);
                workDb.SetFactory(Config.DBFactory);
            }
            currentObj = (T)this;
            initDictionary();
        }
        /// <summary>
        /// Добавление свойств класса в словарь propertyDictionary
        /// </summary>
        void initDictionary()
        {
            propertyDictionary = new Dictionary<int, string>();
            ///заносим все  свойства которые помечены 
            ///атрибутом Column
            ///
            PropertyInfo[] pi = currentType.GetProperties();
            int i=0;
            foreach (PropertyInfo p in pi)
            {
                object[] columnAtributes = p.GetCustomAttributes(typeof(ColumnAttribute), true);
                if (columnAtributes.Length != 0)
                {
                    propertyDictionary.Add(i++, p.Name);
                }
            }
        }

        public delegate void Processed(T Obj);
        /// <summary>
        /// Вызывается при удачной вставки строки.
        /// </summary>
        public event Processed ObjectAdded;
        /// <summary>
        /// Вызывается при удачном обновление объекта.
        /// </summary>
        public event Processed ObjectUpdated;
        /// <summary>
        /// Вызывается при удачном удаление объекта.
        /// </summary>
        public event Processed ObjectDeleted;

        /// <summary>
        /// Тип объекта
        /// </summary>
        public virtual int ObjectType
        {
            get { return -1; }
        }


        public static modelObjectOld<T> GetNew()
        {
            Type t = typeof(T);
            T obj = t.GetConstructor(new Type[0] { }).Invoke(new object[0] { }) as T;
            return obj;
        }
        
        #region DB

        

        internal static string pkName { get { return "ID"; } }

        /// <summary>
        /// Добавление элемента
        /// (Insert)
        /// </summary>
        /// <returns></returns>
        public virtual bool Create()
        {
            bool b = workDb.AddObject(currentObj);
            if (b && ObjectAdded != null)
            {
                ObjectAdded(currentObj);
            }
            return b;
        }

        /// <summary>
        /// Обновление свойств объекта по его PK 
        /// (Where ID=123123123)
        /// </summary>
        /// <returns></returns>
        public virtual int Update()
        {
            int i = workDb.UpdateObject(currentObj);
            if (i > 0 && ObjectUpdated != null)
            {
                ObjectUpdated(currentObj);
            }
            return i;
        }
        /// <summary>
        /// Определение обновить или создать
        /// ну и собственно обновление или сохранение
        /// </summary>
        public override void Save()
        {
            if (this.IsNew)
            {
                this.Create();
            }
            else
            {
                this.Update();
            }
        }
        /// <summary>
        /// Удаление объекта по текущему PK
        /// </summary>
        /// <returns></returns>
        public virtual int Delete()
        {
            int i = workDb.DeleteObject(currentObj);
            if (i > 0 && ObjectDeleted != null)
            {
                ObjectDeleted(currentObj);
            }
            return i;
        }
        /// <summary>
        /// Получить коллекцию объектов
        /// будет использоваться таблица Vs
        /// </summary>
        /// <typeparam name="I">Тип объектов, которые хочешь получить</typeparam>
        /// <typeparam name="Vs">Тип связи</typeparam>
        /// <returns></returns>
        public List<I> GetObjects<I,Vs>()
            where I:modelObjectOld<I>
        {            
            Type vsType=typeof(Vs);
            vsType=vsType.GetConstructor(new Type[0]).Invoke(new object[0]).GetType();
            string vsName = "";
                vsName = vsType.Name;
            Type objAType = this.GetType();
            string colA = objAType.Name + "ID";

            Type objBType = typeof(I);
            objBType = objBType.GetConstructor(new Type[0]).Invoke(new object[0]).GetType();
            string colB = objBType.Name + "ID";

            List<I> l = modelObjectOld<I>.GetAll(Expression.In(pkName, "Select "+colB+" from "+vsName+" where "+colA+"=" + this.ID.ToString()));            
            return l;
        }




        static DBAdapter<T> db = null;
        static modelObjectOld()
        {
            if (Config.OSType == Config.OSTypes.Unix)
            {
                DBToolkit dbtk = new DBToolkit();
                dbtk.Connection = new System.Data.OracleClient.OracleConnection(Config.DbConnectionString);
                dbtk.Command = dbtk.Connection.CreateCommand();
                dbtk.Command.Connection = dbtk.Connection;
                db = new DBAdapter<T>(dbtk, typeof(T));
                db.SetFactory(Config.DBFactory);
                return;
            }
            db = new DBAdapter<T>(Config.DbConnectionString, typeof(T));
            db.SetFactory(Config.DBFactory);
        }

        /// <summary>
        /// Сохраняем связь между объектами Aobj и Bobj
        /// в таблицу AobjVsBobj в колонки AobjID и BobjID
        /// будет использоваться таблица &lt;T&gt;
        /// </summary>
        public static void SaveVs(baseObject Aobj,baseObject Bobj)
        {
            Type objAType=Aobj.GetType();
            string colA = objAType.Name + "ID";

            Type objBType=Bobj.GetType();
            string colB = objBType.Name+"ID";
            
            try
            {
                //извлекаем связь на тот случай если она уже
                //существует
                modelObjectOld<T> objTable = modelObjectOld<T>.Get(Expression.And(Expression.Eq(colA,Aobj.ID), Expression.Eq(colB,Bobj.ID)));
                
                Type objType = typeof(T);
                //если связи не существовало, устанавливаем свзяь между Pk
                if (objTable.IsNew)
                {
                    objType.GetProperty(colA).SetValue(objTable, Aobj.ID, new object[0]);
                    objType.GetProperty(colB).SetValue(objTable, Bobj.ID, new object[0]);
                }
                
                objTable.Save();
            }
            catch (Exception ex)
            {
                Exs.Add(ex);
            }            
        }
        /// <summary>
        /// Проверить есть ли связь между объектами.
        /// </summary>
        /// <param name="Aobj"></param>
        /// <param name="Bobj"></param>
        /// <returns></returns>
        public static bool HaveVS(baseObject Aobj, baseObject Bobj)
        {
            Type objAType = Aobj.GetType();
            string colA = objAType.Name + "ID";

            Type objBType = Bobj.GetType();
            string colB = objBType.Name + "ID";

            try
            {
                modelObjectOld<T> objTable = modelObjectOld<T>.Get(Expression.And(Expression.Eq(colA, Aobj.ID), Expression.Eq(colB, Bobj.ID)));
                if (!objTable.IsNew) return true;
            }
            catch (Exception ex)
            {
                Exs.Add(ex);
            }   
            return false;
        }

        /// <summary>
        /// Получить объект по заданным критериям
        /// </summary>
        /// <param name="WhereString"></param>
        /// <returns></returns>
        public static T Get(string WhereString)
        {
            return db.GetObject(WhereString);
        }
        /// <summary>
        /// Получить объект по его ID
        /// </summary>
        /// <param name="WhereString"></param>
        /// <returns></returns>
        public static T Get(int Pk)
        {
            return db.GetObject(Expression.Eq(pkName, Pk));
        }
        /// <summary>
        /// Получить объект по Expression
        /// </summary>
        /// <returns></returns>
        public static T Get(Expression expression)
        {
            if (db == null) Exs.Add("DB Adapter is null");
            return db.GetObject(expression);
        }

        /// <summary>
        /// Получить объект по заданным критериям
        /// </summary>
        /// <param name="WhereString"></param>
        /// <returns></returns>
        public static T Get<I>(string WhereString)
        {
            DBAdapter<T> db = new DBAdapter<T>(Config.DbConnectionString, typeof(I));
            db.SetFactory(Config.DBFactory);
            return db.GetObject(WhereString);
        }
        /// <summary>
        /// Получить объект по его ID
        /// </summary>
        /// <param name="WhereString"></param>
        /// <returns></returns>
        public static T Get<I>(int Pk)
        {
            DBAdapter<T> db = new DBAdapter<T>(Config.DbConnectionString, typeof(I));
            db.SetFactory(Config.DBFactory);
            return db.GetObject(Expression.Eq("ID", Pk));
        }
        /// <summary>
        /// Получить объект по Expression
        /// </summary>
        /// <returns></returns>
        public static T Get<I>(Expression expression)
        {
            DBAdapter<T> db = new DBAdapter<T>(Config.DbConnectionString, typeof(I));
            db.SetFactory(Config.DBFactory);
            return db.GetObject(expression);
        }


        /// <summary>
        /// Получить объекты по Expression
        /// </summary>
        /// <param name="WhereString"></param>
        /// <returns></returns>
        public static List<T> GetAll(Expression expression)
        {
            return db.GetObjects(expression);
        }
        /// <summary>
        /// Получение объектов по критериям.
        /// Слово WHERE писать ненужно
        /// </summary>
        /// <param name="WhereString"></param>
        /// <returns></returns>
        public static List<T> GetAll(string WhereString)
        {
            return db.GetObjects(WhereString);
        }
        /// <summary>
        /// Возвращяет все объекты заданого типа
        /// </summary>
        /// <returns></returns>
        public static List<T> GetAll()
        {
            return db.GetObjects();
        }

        /// <summary>
        /// Получить объекты по Expression
        /// </summary>
        /// <param name="WhereString"></param>
        /// <returns></returns>
        public static List<T> GetAll(Type objType, Expression expression)
        {
            DBAdapter<T> db = new DBAdapter<T>(Config.DbConnectionString, objType);
            db.SetFactory(Config.DBFactory);
            return db.GetObjects(expression);
        }
        /// <summary>
        /// Получение объектов по критериям.
        /// Слово WHERE писать ненужно
        /// </summary>
        /// <param name="WhereString"></param>
        /// <returns></returns>
        public static List<T> GetAll(Type objType, string WhereString)
        {
            DBAdapter<T> db = new DBAdapter<T>(Config.DbConnectionString, objType);
            db.SetFactory(Config.DBFactory);
            return db.GetObjects(WhereString);
        }
        /// <summary>
        /// Возвращяет все объекты заданого типа
        /// </summary>
        /// <returns></returns>
        public static List<T> GetAll(Type objType)
        {
            DBAdapter<T> db = new DBAdapter<T>(Config.DbConnectionString, objType);
            db.SetFactory(Config.DBFactory);
            return db.GetObjects();
        } 
        #endregion

        #region ObjectDataSource реализация
        /// <summary>
        /// Число столбцов
        /// </summary>
        public int Count
        {
            get { return propertyDictionary.Count; }
        }

        /// <summary>
        /// Получение значения свойства по его имени
        /// Допускаеются Property и Field
        /// </summary>
        /// <param name="propertyName"></param>
        /// <returns></returns>
        public object GetValue(string propertyName)
        {
            return getValue(propertyName); 
        }
        /// <summary>
        /// Получение значения свойства по его имени
        /// Допускаеются Property и Field
        /// </summary>
        /// <param name="propertyName"></param>
        /// <returns></returns>
        public object this[string propertyName]
        {
            get
            {
                return getValue(propertyName);
            }
        }
        /// <summary>
        /// Получение значения свойства по индексу
        /// Допускаеются Property и Field
        /// </summary>
        /// <returns></returns>
        public object this[int i]
        {
            get
            {
                return getValue(i);
            }
        }
        /// <summary>
        /// Получение значения свойства по его имени
        /// Допускаеются Property и Field
        /// </summary>
        /// <param name="propertyName"></param>
        /// <returns></returns>
        object getValue(string propertyName)
        {
            object result = null;
            try
            {
                PropertyInfo pi=currentType.GetProperty(propertyName);
                if (pi != null)
                {
                    result = pi.GetValue(this, new object[0] { });
                }
                if (this.GetType() == typeof(ILanguageable))
                {
                    if (le == null)
                    {
                        le = new LanguageExtender();
                    }
                    
                }
                return result;
            }
            catch (Exception ex)
            {
                Exs.Add(ex);
            }
            return result;
        }
        

        /// <summary>
        /// Получение значения свойства по его индексу из propertyDictionary
        /// Допускаеются Property и Field
        /// </summary>
        /// <param name="propertyName"></param>
        /// <returns></returns>
        object getValue(int i)
        {
            string propName = propertyDictionary[i];
            if (propName != null)
            {
                if (!propName.Equals(""))
                {
                    return getValue(propName);
                }
            }
            Exs.Add("Bad Property an modelObjectOld Index#"+i.ToString());
            return null;
        }



        /// <summary>
        /// Исключительно для ObjectDataSource
        /// </summary>
        /// <returns></returns>
        public object GetThis()
        {
            return this;
        }

        #region IEnumerable Members

        public IEnumerator GetEnumerator()
        {
            return this;
        }

        #endregion

        #region IEnumerator Members
        int current = -1;
        public object Current
        {
            get
            {
                return this[current];
            }
        }

        public bool MoveNext()
        {
            if (current == propertyDictionary.Count-1) return false;
            current++;
            return true;
        }

        public void Reset()
        {
            current = 0;
        }

        #endregion

        #endregion

        public override string ToString()
        {
            return currentType.FullName + " #" + ID.ToString();
        }

    }
}
