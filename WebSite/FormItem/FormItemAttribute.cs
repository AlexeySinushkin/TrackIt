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
    /// ������� ������� ���������� ���� �����.
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
        /// ����� ����� ������� ���� ���������
        /// </summary>
        public string SectionName
        {
            get { return sectionName; }
            set { sectionName = value; }
        }

        string outFormat=string.Empty;
        /// <summary>
        /// ������ ������ �������� (������ 0 �������� 0.00)
        /// </summary>
        public string OutFormat
        {
            get { return outFormat; }
            set { outFormat = value; }
        }
        string inExpression = string.Empty;
        /// <summary>
        /// ���������� ��������� ��� ������������� �������� ��������
        /// </summary>
        public string InExpression
        {
            get { return inExpression; }
            set { inExpression = value; }
        }

        string errorMessage = string.Empty;
        /// <summary>
        /// ��������� �� ������ � ������ ���������� ���������
        /// </summary>
        public string ErrorMessage 
        {
            get { return errorMessage;}
            set { errorMessage = value; }
        }
        string propertyName = string.Empty;
        /// <summary>
        /// �� ��������� ����� �� ��� ��������� ����������� ����
        /// </summary>
        public string PropertyName
        {
            get { return propertyName; }
            set { propertyName = value; }
        }
        Type targetType;
        /// <summary>
        /// ��� ������� ������� �� ����� ���������
        /// </summary>
        public Type TargetType
        {
            get { return targetType; }
            set { targetType = value; }
        }
        /// <summary>
        /// 
        /// ��� DoNotBind ����� ����������� ������ ���� Regex-�� �� Bind-����� �� �����
        /// </summary>
        public enum BindTypes {Simple=1,Object=2,DoNotBind=3 }
        
        BindTypes bindType = BindTypes.Simple;
        /// <summary>
        /// ���� true ����� ����������� �������� �������� �������
        /// ������ ��������� �� ������ ������� TrackIt.WebSite.select ������� GetCurrent()
        /// </summary>
        public BindTypes BindType
        {
            get { return bindType; }
            set { bindType = value; }
        }
        /// <summary>
        /// TextBox ��� DrowDownList
        /// </summary>
        internal FieldInfo fieldInfo;
        internal Regex regEx;
        public RegexOptions regOption = RegexOptions.IgnoreCase;
    }
    
}
