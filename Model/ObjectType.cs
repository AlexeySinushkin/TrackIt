using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using NHibernate.Expression;
using Common;
using Castle.ActiveRecord;

namespace TrackIt.Model
{
    [Table("ObjectTypes")]
    public class ObjectType : localizableObject<ObjectType>
    {
        public static ObjectType Get(string key)
        {
            ObjectType obj = ObjectType.FindFirst(Expression.Eq("Key", key));
            if (obj == null)
            {
                obj = new ObjectType();
                obj.className = key;
                obj.CreateAndFlush();
            }
            return obj;
        }

        string className;
        [Column]
        public string ClassName
        {
            get { return className; }
            set { className = value; }
        }

        string nameProperty;
        [Column]
        public string NameProperty
        {
            get { return nameProperty; }
            set { nameProperty = value; }
        }

        string name;
        [Localizable]
        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        public string GetObjectName(int ID)
        {
            IModelObject obj = GetObject(ID);
            if (obj != null)
            {
                try
                {
                    return (string)obj.GetType().GetProperty(NameProperty).GetValue(obj, null);
                }
                catch (Exception ex)
                {
                    Ex.Add(ex);
                }
            }
            return "";
        }

        public IModelObject GetObject(int ID)
        {
            try
            {
                Type objType = Type.GetType("TrackIt.Model." + ClassName);
                IModelObject obj = ActiveRecordMediator.FindFirst(objType, Expression.Eq("ID", ID)) as IModelObject;
                return obj;
            }
            catch (Exception ex)
            {
                Ex.Add(ex);
            }
            return null;
        }

    }
}
