using System;
using System.Collections.Generic;
using System.Text;
using System.Reflection;
using Common.Attributes;
using Common;
using NHibernate.Expression;

namespace TrackIt.Model
{
    /// <summary>
    /// Базовый класс для классов, поддерживающих локализацию.
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public abstract class localizableObject<T> : modelObject<T>
        where T : localizableObject<T>
    {

        Culture culture;
        /// <summary>
        /// <remarks>
        /// Объеденяем insert и update в одно потому, что 
        /// не знаем присутствовала ли запись для новой культуры раньше или нет.
        /// </remarks>
        /// </summary>
        protected enum localizationActions { select = 0, insert_update = 1, delete = 2 }
        protected Type thisType;
        internal List<string> targetProperties = new List<string>();
        protected string targetClassName;
        bool inited = false;
        protected localizationActions lastAction = localizationActions.select;


        public override void Create()
        {
            base.Create();
            lastAction = localizableObject<T>.localizationActions.insert_update;
        }
        public override void Update()
        {
            if (this.IsNew) throw new InvalidOperationException("Необходимо сначала сохранить объект в базе");
            base.Update();
            lastAction = localizableObject<T>.localizationActions.insert_update;
        }
        public override void Save()
        {   base.Save();
            lastAction = localizableObject<T>.localizationActions.insert_update;
        }
        public override void Delete()
        {
            if (this.IsNew) throw new InvalidOperationException("Необходимо сначала сохранить объект в базе");
            base.Delete();
            lastAction = localizableObject<T>.localizationActions.delete;
        }

        public void CreateAndLocalizate()
        {
            this.Create();
            lastAction = localizableObject<T>.localizationActions.insert_update;
            this.Localizate();
        }

        /// <summary>
        /// Извлечение из таблицы CultureContent значение properties для currentCulture
        /// помеченных атрибутом Localizable
        /// </summary>
        /// <returns></returns>
        public virtual void Localizate()
        {
            this.Localizate(currentCulture);
        }
        /// <summary>
        /// Извлечение из таблицы CultureContent значение properties 
        /// помеченных атрибутом Localizable
        /// </summary>
        /// <returns></returns>
        public virtual void Localizate(Culture culture)
        {
            this.culture = culture;
            init();
            if (lastAction == localizableObject<T>.localizationActions.select)
            {
                select();
            }
            else if (lastAction == localizableObject<T>.localizationActions.insert_update)
            {
                insert();
            }
            else if (lastAction == localizableObject<T>.localizationActions.delete)
            {
                delete();
            }
        }

        public static int[] GetParentKeys(IEnumerable<localizableObject<T>> collection)
        {
            List<int> result = new List<int>();
            IEnumerator<localizableObject<T>> enumerator = collection.GetEnumerator();
            while (enumerator.MoveNext())
            {
                result.Add(enumerator.Current.ID);
            }
            return result.ToArray();
        }
        /// <summary>
        /// Used for FindAll method
        /// </summary>
        /// <param name="collection"></param>
        /// <returns></returns>
        public static IEnumerable<localizableObject<T>> Localizate(IEnumerable<localizableObject<T>> collection)
        {
            Culture culture = null;
            if (System.Web.HttpContext.Current != null)
            {
                culture = System.Web.HttpContext.Current.Session["currentCulture"] as Culture;
            }
            if (culture == null) throw new ArgumentNullException("Culture is not defined");            
            return Localizate(collection, culture);
        }
        public static IEnumerable<localizableObject<T>> Localizate(IEnumerable<localizableObject<T>> collection, Culture culture)
        {
            int[] ids = GetParentKeys(collection);

            Type thisType = typeof(T);
            string targetClassName = thisType.Name;
            List<string> targetProperties = new List<string>();

            foreach (PropertyInfo pi in thisType.GetProperties())
            {
                object[] atrs = pi.GetCustomAttributes(typeof(LocalizableAttribute), true);
                if (atrs == null || atrs.Length == 0) continue;
                targetProperties.Add(pi.Name);
            }          
            
            CommonContent[] contents = CommonContent.FindAll(Order.Asc("Text"), Expression.Eq("ClassName", targetClassName),
                Expression.Eq("Culture", culture), Expression.InG<int>("ParentID", ids));

            IEnumerator<localizableObject<T>> enumerator = collection.GetEnumerator();
            while (enumerator.MoveNext())
            {
                foreach (CommonContent content in contents)
                {
                    if (content.ParentID != enumerator.Current.ID) continue;
                    PropertyInfo pi = thisType.GetProperty(content.PropertyName);
                    if (pi != null)
                    {
                        pi.SetValue(enumerator.Current, content.Text, null);
                    }
                }
            }
            return collection;
        }

        public static T[] FindAllLocalizated(Order order, params ICriterion[] criteria)
        {
            T[] result=localizableObject<T>.FindAll(order,criteria);
            return localizableObject<T>.Localizate(result) as T[];
        }
        public static T[] FindAllLocalizated(params ICriterion[] criteria)
        {
            T[] result = localizableObject<T>.FindAll(criteria);
            return localizableObject<T>.Localizate(result) as T[];
        }

        private void init()
        {
            if (inited) return;      
      
            if (culture == null) throw new ArgumentNullException("Забыли определить Culture");
            thisType = this.GetType();
            targetClassName = thisType.Name;
            foreach(PropertyInfo pi in thisType.GetProperties())
            {
                object[] atrs=pi.GetCustomAttributes(typeof(LocalizableAttribute),true);
                if (atrs == null || atrs.Length == 0) continue;
                targetProperties.Add(pi.Name);
            }
            inited = true;
        } 
        protected virtual void select()
        {
            foreach (string property in targetProperties)
            {
                PropertyInfo pi = thisType.GetProperty(property);
                pi.SetValue(this, null, null);
            }
            CommonContent[] contents = CommonContent.FindAll(Expression.Eq("ClassName", targetClassName),
                Expression.In("PropertyName", targetProperties.ToArray()), Expression.Eq("Culture", culture),Expression.Eq("ParentID",this.ID));
            foreach (CommonContent content in contents)
            {
                PropertyInfo pi = thisType.GetProperty(content.PropertyName);
                if (pi != null)
                {
                    pi.SetValue(this, content.Text, null);
                }
            }
        }
        protected virtual void insert()
        {
            foreach (string property in targetProperties)
            {
                PropertyInfo pi = thisType.GetProperty(property);
                object propertyValue=pi.GetValue(this, null);
                string value="";
                if (propertyValue!=null)value=propertyValue.ToString();
                CommonContent temp = CommonContent.FindFirst(Expression.Eq("ClassName", targetClassName),
                Expression.Eq("PropertyName", property), Expression.Eq("Culture", culture),Expression.Eq("ParentID",this.ID));
                if (temp == null)//insert
                {
                    temp = new CommonContent();
                    temp.ClassName = targetClassName;
                    temp.PropertyName = property;
                    temp.Culture = culture;
                    temp.Text = value;
                    temp.ParentID = this.ID;
                    temp.Create();
                }
                else//update
                {
                    temp.Text = value;
                    temp.Update();
                }
            }
        }
        protected virtual void delete()
        {
            foreach (string property in targetProperties)
            {
                CommonContent temp = CommonContent.FindFirst(Expression.Eq("ClassName", targetClassName),
                Expression.Eq("PropertyName", property), Expression.Eq("CultureID", culture.ID),Expression.Eq("ParentID",this.ID));
                if (temp!=null)
                {
                    temp.Delete();
                }
            } 
        }



    }
}
