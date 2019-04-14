using System;
using System.Collections.Generic;
using System.Text;
using Castle.ActiveRecord;
using Common;
using System.Globalization;
using NHibernate.Expression;

namespace TrackIt.Model
{   
    public class modelObject<T>:ActiveRecordBase<T>, IModelObject,IFormatProvider
        where T : ActiveRecordBase<T>
    {
        int id = -1;
        /// <summary>
        /// Unique number of object
        /// Attention! Everyone Table in DataBase must have PK "ID"
        /// </summary>
        [PrimaryKey(UnsavedValue = "-1")]
        public virtual int ID
        {
            get { return id; }
            set { id = value; }
        }
        public static int[] GetParentKeys(ICollection<modelObject<T>> collection)
        {
            int[] result = new int[collection.Count];
            IEnumerator<modelObject<T>> enumerator = collection.GetEnumerator();
            int counter=0;
            while (enumerator.MoveNext())
            {
                result[counter++] = enumerator.Current.ID;
            }
            return result;
        }
        string tempKey = Guid.NewGuid().ToString().Substring(0,8);
        public string TempKey
        {
            get { return tempKey; }
        }
        DateTime createDate = DateTime.UtcNow;
        /// <summary>
        /// Дата Вставки в таблицу
        /// </summary>
        [Property]
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

        WebUser user;
        protected WebUser currentUser
        {
            get
            {
                if (user == null && System.Web.HttpContext.Current !=null)
                {
                    if (System.Web.HttpContext.Current.Session["currentUser"] != null) user = System.Web.HttpContext.Current.Session["currentUser"] as WebUser;
                }
                return user;
            }
        }
        Culture cCulture = null;
        protected Culture currentCulture
        {
            get
            {

                if (System.Web.HttpContext.Current != null)
                {
                    System.Web.SessionState.HttpSessionState session = System.Web.HttpContext.Current.Session;
                    if (session["currentCulture"] == null)
                    {
                        session["currentCulture"]=TrackIt.Model.Culture.FindFirst();
                    }
                    return session["currentCulture"] as Culture;
                }
                if (cCulture == null)
                {
                    cCulture = TrackIt.Model.Culture.FindFirst();
                }
                return cCulture;
            }
            set
            {
                cCulture = value;
                if (System.Web.HttpContext.Current != null)
                {
                    System.Web.SessionState.HttpSessionState session = System.Web.HttpContext.Current.Session;
                    session["currentCulture"] = value;
                }
            }
        }
        public static List<T> GetAll(params object[] obs)
        {
            return null;
        }
        public List<I> GetObjects<I, Vs>()
        {
            return null;
        }
        public static T Find(int ID)
        {
            return modelObject<T>.FindFirst(Expression.Eq("ID", ID));
        }

        #region IFormatProvider Members

        NumberFormatInfo nfi;
        public virtual object GetFormat(Type formatType)
        {
            if (formatType == typeof(NumberFormatInfo))
            {
                if (nfi == null)
                {
                    nfi = new NumberFormatInfo();
                    nfi.NumberDecimalSeparator = ".";
                    nfi.NumberGroupSeparator = "";
                }
                return nfi;
            }
            return null;
        }

        #endregion


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
        public override bool Equals(object obj)
        {
            if (obj == null) return false;
            if (obj.GetType() == typeof(T) && obj.GetHashCode() == this.GetHashCode()) return true;
            return base.Equals(obj);
        }
        public override int GetHashCode()
        {
            if (this.IsNew)
            {
                return base.GetHashCode();
            }
            return this.ToString().GetHashCode();
        }
        public override string ToString()
        {
            return base.ToString().Replace("#","$");
        }
        public void BeginTrackChanges()
        {

        }
        public void EndTrackChanges()
        {

        }


        public string ToJSON()
        {
            return JSON.Convert(this);
        }

    }
}
