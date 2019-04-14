using System;
using System.Collections.Generic;
using System.Text;
using System.Reflection;
using Common.Attributes;
using Common;
using NHibernate.Expression;
using Castle.ActiveRecord;
namespace TrackIt.Model
{
    /// <summary>
    /// Наследуется от localizableObject и копирует свойства
    /// activableObject
    /// (нет поддержки множественного наследования)
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public abstract class laObject<T> : localizableObject<T>
        where T : laObject<T>
    {

        bool isActive = true;
        [Property]
        public virtual bool IsActive { get { return isActive; } set { isActive = value; } }


        public static T[] FindAllActive(Order order, params ICriterion[] criteria)
        {
            List<ICriterion> cr = new List<ICriterion>();
            cr.AddRange(criteria);
            cr.Add(Expression.Eq("IsActive", true));
            return modelObject<T>.FindAll(order, cr.ToArray());
        }

        public static T FindFirstActive(params ICriterion[] criteria)
        {
            List<ICriterion> cr = new List<ICriterion>();
            cr.AddRange(criteria);
            cr.Add(Expression.Eq("IsActive", true));
            return modelObject<T>.FindFirst(cr.ToArray());
        }


    }
}
