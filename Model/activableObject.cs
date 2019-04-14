using System;
using System.Collections.Generic;
using System.Text;
using Castle.ActiveRecord;
using Common;
using System.Globalization;
using NHibernate.Expression;

namespace TrackIt.Model
{   
    /// <summary>
    /// Объект к которому применимо свойство IsActive
    /// false - объект помечен неактивным (удаленным) в базе
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class activableObject<T>:modelObject<T>
        where T : modelObject<T>
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
