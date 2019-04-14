using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using TrackIt.Model;
using System.Collections.Generic;
using System.Reflection;

using System.Text.RegularExpressions;
using System.Text;
namespace TrackIt.Website
{
    /// <summary>
    /// Атрибут которым помечается поле формы.
    /// </summary>
    [AttributeUsage(AttributeTargets.Field,AllowMultiple=false)]
    public class FormItemAttribute:System.Attribute
    {
        public FormItemAttribute(string propertyName)
        {
            this.propertyName = propertyName;
        }

        string sectionName = "";
        /// <summary>
        /// часть формы которую надо проверять
        /// </summary>
        public string SectionName
        {
            get { return sectionName; }
            set { sectionName = value; }
        }

        string outFormat=string.Empty;
        /// <summary>
        /// Формат вывода значения (Вместо 0 выводить 0.00)
        /// </summary>
        public string OutFormat
        {
            get { return outFormat; }
            set { outFormat = value; }
        }
        string inExpression = string.Empty;
        /// <summary>
        /// Регулярное выражение для валидирования входящей величины
        /// </summary>
        public string InExpression
        {
            get { return inExpression; }
            set { inExpression = value; }
        }

        string errorMessage = string.Empty;
        /// <summary>
        /// Сообщение об ошибке в случае неуспешной валидации
        /// </summary>
        public string ErrorMessage 
        {
            get { return errorMessage;}
            set { errorMessage = value; }
        }
        string propertyName = string.Empty;
        /// <summary>
        /// По умолчанию такое же как называние помечаемого поля
        /// </summary>
        public string PropertyName
        {
            get { return propertyName; }
            set { propertyName = value; }
        }
        Type targetType;
        /// <summary>
        /// Тип объекта который мы хотим проверить
        /// </summary>
        public Type TargetType
        {
            get { return targetType; }
            set { targetType = value; }
        }
        /// <summary>
        /// 
        /// При DoNotBind будет проверяться только лишь Regex-ом но Bind-иться не будет
        /// </summary>
        public enum BindTypes {Simple=1,Object=2,DoNotBind=3 }
        
        BindTypes bindType = BindTypes.Simple;
        /// <summary>
        /// Если true будет присваивать свойству целевого объекта
        /// объект выбранный из скажем селекта TrackIt.WebSite.select методом GetCurrent()
        /// </summary>
        public BindTypes BindType
        {
            get { return bindType; }
            set { bindType = value; }
        }
        /// <summary>
        /// TextBox или DrowDownList
        /// </summary>
        internal FieldInfo fieldInfo;
        internal Regex regEx;
        public RegexOptions regOption = RegexOptions.IgnoreCase;
    }
    
}
