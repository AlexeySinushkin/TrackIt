using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using TrackIt.Model;
using System.Collections.Generic;
using System.Reflection;

using System.Text;
using System.Text.RegularExpressions;
using System.Globalization;
using TrackIt.Website.Model;
using WebSite.Common;

namespace TrackIt.Website
{
    public class Translator :IFormatProvider
    {
        public Translator(Control container, IModelObject obj)
        {
            this.container = container;
            this.obj = obj;
            if (System.Web.HttpContext.Current != null) context = System.Web.HttpContext.Current;
            #region создаем мост
            try
            {
                bridge = new Dictionary<FormItemAttribute, PropertyInfo>();
                if (obj != null)
                {
                    Type objType = obj.GetType();
                    Type controlType = this.container.GetType();
                    foreach (FieldInfo fi in controlType.GetFields())
                    {
                        object[] formItems = fi.GetCustomAttributes(typeof(FormItemAttribute), true);
                        if (formItems.Length > 0)
                        {
                            FormItemAttribute fia = (FormItemAttribute)formItems[0];
                            fia.fieldInfo = fi;
                            fia.regEx = new Regex(fia.InExpression, fia.regOption);
                            bridge.Add(fia, objType.GetProperty(fia.PropertyName));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Ex.Add(ex);
            }
            #endregion
        }

        IModelObject obj;
        Control container;
        HttpContext context;

        /// <summary>
        /// <paramref name="string">FieldInfo of asp.net control</paramref>
        /// <paramref name="string">PropertyInfo of object</paramref>
        /// </summary>
        Dictionary<FormItemAttribute, PropertyInfo> bridge;

        /// <summary>
        /// Словарь динамической проверки входных данных.
        /// допустим для поля BirthDate можно задать только ^dd.MM.yyyy$
        /// <paramref name="string">Называние свойства</paramref>
        /// <paramref name="string">Выражение</paramref>
        /// </summary>
        protected Dictionary<string, string> regexes
        {
            get
            {
                if (this.context.Session["$regexes" + container.ClientID] == null)
                {
                    this.context.Session["$regexes" + container.ClientID] = new Dictionary<string, string>();
                }
                return this.context.Session["$regexes" + container.ClientID] as Dictionary<string, string>;
            }
            set
            {
                this.context.Session["$regexes" + container.ClientID] = value;
            }
        }
        
        /// <summary>
        /// Словарь динамического формирования выходных данных.
        /// допустим для поля BirthDate можно задать только dd.MM.yyyy
        /// <paramref name="string">Называние свойства</paramref>
        /// <paramref name="string">Формат</paramref>
        /// </summary>
        protected Dictionary<string, string> formatters
        {
            get
            {
                if (this.context.Session["$formatters" + container.ClientID] == null)
                {
                    this.context.Session["$formatters" + container.ClientID] = new Dictionary<string, string>();
                }
                return this.context.Session["$formatters" + container.ClientID] as Dictionary<string, string>;
            }
            set
            {
                this.context.Session["$formatters" + container.ClientID] = value;
            }
        }

        List<WebControl> invalidFields;

        public List<WebControl> InvalidFields
        {
            get { return invalidFields; }
            set { invalidFields = value; }
        }

        #region Request
        /// <summary>
        /// Вызывать для присвоения значений свойствам целевого объекта
        /// </summary>
        public bool OnRequest()
        {
           return OnRequest("");
        }
        internal bool OnRequest(string sectionName)
        {
            invalidFields = new List<WebControl>();
            foreach (FormItemAttribute fi in bridge.Keys)
            {
                if (fi.SectionName != sectionName) continue;
                //обновляем Regex
                if (regexes.ContainsKey(fi.PropertyName))
                {
                    fi.regEx = new Regex(regexes[fi.PropertyName]);
                }
                WebControl field = fi.fieldInfo.GetValue(this.container) as WebControl;
                if (fi.fieldInfo.FieldType == typeof(textBox))
                {
                    requestBind((TextBox)field, fi);
                }
                else if (fi.fieldInfo.FieldType == typeof(select))
                {
                    requestBind((ListControl)field, fi);
                }
            }
            if (invalidFields.Count > 0) return false;
            return true;
        }
        void requestBind(TextBox textControl, FormItemAttribute fi)
        {
            PropertyInfo pi = null;
            Type objType = obj.GetType();
            if (bridge.ContainsKey(fi))
            {
                pi = bridge[fi];
            }
            else
            {
                pi = objType.GetProperty(fi.PropertyName);
            }
            if (pi == null)
            {
                Ex.Add("PropertyInfo is null for Property " + fi.PropertyName + " for FieldInfo " + fi.fieldInfo.Name);
                return;
            }
            if (fi.regEx.IsMatch(textControl.Text))
            {
                if (fi.BindType == FormItemAttribute.BindTypes.Object)
                {

                }
                else if (fi.BindType == FormItemAttribute.BindTypes.Simple)
                {
                    requestSetValue(pi, textControl.Text);
                }
                else if (fi.BindType == FormItemAttribute.BindTypes.DoNotBind)
                {
                    return;
                }
            }
            else
            {
                WebControl wc = textControl as WebControl;
                invalidFields.Add(wc);
                wc.CssClass += " bad-value";
            }
        }
        void requestBind(ListControl listControl, FormItemAttribute fi)
        {
            if (fi.regEx.IsMatch(listControl.SelectedValue))
            {
                if (fi.BindType==FormItemAttribute.BindTypes.Object)
                {
                    if (listControl is select)
                    {
                        requestSetValue(bridge[fi], ((select)listControl).GetCurrent());
                    }
                }
                else if (fi.BindType == FormItemAttribute.BindTypes.Simple)
                {
                    requestSetValue(bridge[fi], listControl.SelectedValue);
                }
                else if (fi.BindType == FormItemAttribute.BindTypes.DoNotBind)
                {
                    return;
                }
            }
            else
            {
                invalidFields.Add(listControl);
                listControl.CssClass += " bad-value";
            }
        }
        void requestSetValue(PropertyInfo pi, object rawValue)
        {
            if (pi.PropertyType == typeof(string))
            {
                pi.SetValue(obj, rawValue, null);
            }
            else if (pi.PropertyType == typeof(DateTime))
            {
                DateTime dt = new DateTime(1970, 1, 1);
                DateTime.TryParse(rawValue.ToString(), out dt);
                pi.SetValue(obj, dt, null);
            }
            else if (pi.PropertyType == typeof(int))
            {
                int i = -1;
                Int32.TryParse(rawValue.ToString(), out i);
                pi.SetValue(obj, i, null);
            }
            else if (pi.PropertyType == typeof(float))
            {
                float f = -1;
                Single.TryParse(rawValue.ToString(),System.Globalization.NumberStyles.Float,this, out f);
                pi.SetValue(obj, f, null);
            }
            else if (pi.PropertyType == typeof(long))
            {
                Int64 i = -1;
                Int64.TryParse(rawValue.ToString(), out i);
                pi.SetValue(obj, i, null);
            }
            else
            {
                pi.SetValue(obj, rawValue, null);
            }
        }
        #endregion

        #region Response
        /// <summary>
        /// Вызывать для заполнения формы значениями
        /// </summary>
        public void OnResponse()
        {
            OnResponse("");
        }
        internal void OnResponse(string sectionName)
        {
            foreach (FormItemAttribute fi in bridge.Keys)
            {
                if (fi.SectionName != sectionName) continue;
                //обновляем Format
                if (formatters.ContainsKey(fi.PropertyName))
                {
                    fi.OutFormat = formatters[fi.PropertyName];
                }
                WebControl field = fi.fieldInfo.GetValue(this.container) as WebControl;
                if (field != null)
                {
                    field.Attributes.Add("regex", fi.InExpression);
                    field.Attributes.Add("onkeyup", "Element.check(this)");
                    field.Attributes.Add("onchange", "Element.check(this)");
                    //присваиваем текстбоксам значения
                    if (fi.fieldInfo.FieldType == typeof(textBox))
                    {
                        responseBind((textBox)field, fi);
                    }
                    else if (fi.fieldInfo.FieldType == typeof(select))
                    {
                        responseBind((ListControl)field, fi);
                    }
                }
            }       
        }
        void responseBind(ITextControl textControl, FormItemAttribute fi)
        {
            object objValue = null;
            Type objType = obj.GetType();
            PropertyInfo pi = null;
            try
            {
                if (bridge.ContainsKey(fi))
                {
                    pi = bridge[fi];
                    objValue = pi.GetValue(obj, null);
                }
                else
                {
                    pi = objType.GetProperty(fi.PropertyName);
                    objValue = pi.GetValue(obj, null);
                }
            }
            catch (Exception ex)
            {
                Ex.Add(ex);
                if (pi == null) return;
            }

            if (pi.PropertyType == typeof(string))
            {
                textControl.Text = (string)objValue;
            }
            else if (pi.PropertyType == typeof(DateTime))
            {
                textControl.Text = ((DateTime)objValue).ToString(fi.OutFormat);
            }
            else if (pi.PropertyType == typeof(int))
            {
                textControl.Text = ((int)objValue).ToString(fi.OutFormat);
            }
            else if (pi.PropertyType == typeof(float))
            {
                textControl.Text = ((float)objValue).ToString(fi.OutFormat,this);
            }
            else if (pi.PropertyType == typeof(long))
            {
                textControl.Text = ((Int64)objValue).ToString(fi.OutFormat);
            }
        }
        void responseBind(ListControl listControl, FormItemAttribute fi)
        {
            object objValue = bridge[fi].GetValue(obj, null);
            PropertyInfo pi = bridge[fi];
            if (pi.PropertyType == typeof(string))
            {
                listControl.SelectedValue = (string)objValue;
            }
            else if (pi.PropertyType == typeof(DateTime))
            {
                listControl.SelectedValue = ((DateTime)objValue).ToString(fi.OutFormat);
            }
            else if (pi.PropertyType == typeof(int))
            {
                listControl.SelectedValue = ((int)objValue).ToString(fi.OutFormat);
            }
            else if (pi.PropertyType == typeof(float))
            {
                listControl.SelectedValue = ((float)objValue).ToString(fi.OutFormat);
            }
            else if (pi.PropertyType == typeof(long))
            {
                listControl.SelectedValue = ((Int64)objValue).ToString(fi.OutFormat);
            }
            else
            {
                if (listControl.GetType() == typeof(select))
                {
                    select s = (select)listControl;
                    s.SetCurrent(objValue);
                }
            }
        }




        #endregion

        static Translator()
        {
            nfi.NumberDecimalSeparator = ".";
        }

        static NumberFormatInfo nfi = new NumberFormatInfo();

        public object GetFormat(Type formatType)
        {
            if (formatType == typeof(NumberFormatInfo))
            {              
                return nfi;
            }
            return null;
        }

 
    }
}
