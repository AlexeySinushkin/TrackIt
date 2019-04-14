using System;
using System.Web.UI;
using System.Collections.Generic;
using TrackIt.Model;

using System.Reflection;

using System.Configuration;

using System.IO;
using TrackIt.Website.Model;
using WebSite.Common;

namespace TrackIt.Website
{

    public partial class BasePage : System.Web.UI.Page
    {

        public DateTime start = DateTime.Now;
        public string GetMilliseconds()
        {
            TimeSpan ts = DateTime.Now - start;
            if (ts.TotalMilliseconds == 0) return "< 1";
            return Math.Round(ts.TotalMilliseconds).ToString();
        }
        public string GetLightStyle()
        {
            string path = MapPath("~/App_Themes/style.css");
            if (File.Exists(path))
            {
                string text = File.ReadAllText(path);
                int i = text.IndexOf("/*preload-end*/");
                if (i > 0) return text.Substring(0, i);
            }
            return "";
        }
        public string GetPageStyle(){
            return String.Format("<link rel='stylesheet' type='text/css' href='/App_Themes/{0}.css' />",pageName);
        }
        string errorMessage = "";
        /// <summary>
        /// Сообщение об ошибке
        /// </summary>
        public string ErrorMessage
        {
            get { return errorMessage; }
            set { errorMessage = value; }
        }
        string infoMessage = "";
        /// <summary>
        /// Информационное сообщение
        /// </summary>
        public string InfoMessage
        {
            get { return infoMessage; }
            set { infoMessage = value; }
        }

        /// <summary>
        /// Ключ уникальности страницы
        /// </summary>
        public string KeyViewState
        {
            get
            {                
                if (ViewState["Key"] == null) ViewState.Add("Key", Guid.NewGuid().ToString());
                return ViewState["Key"].ToString();
            }
        }
        protected string pageName
        {
            get
            {
                return Request.Path.Replace("/", "");
            }
        }
        protected string title = string.Empty;

        public WebUser currentUser
        {
            get
            {
                if (Session["currentUser"] == null)
                {
                    try
                    {
                        WebUser u = WebUser.GetAnonymous();
                        Session["currentUser"] = u;
                    }
                    catch (Exception ex)
                    {
                        Ex.Add(ex);
                    }

                }
                return (WebUser)Session["currentUser"];
            }
            set
            {
                Session["currentUser"] = value;
            }
        }

        public ContentManager cm
        {
            get { return ContentManager.GetCurrent(); }
        }
       /* public ContentManager cm
        {
            get
            {
                if (this.Session["$cm"] == null)
                {
                    ContentManager cm = ContentManager.GetCurrent();
                    cm.culture = currentCulture;
                    cm.context = Context;
                    this.Session["$cm"] = cm;
                }
                return this.Session["$cm"] as ContentManager;
            }
            set
            {
                this.Session["$cm"] = value;
            }
        }*/


        //public static Config config = Config.GetConfig();

        protected bool firstLoad
        {
            get
            {
                if (currentUser.IsAnonymous)
                {
                    if (contains("login")) return false;
                    if (!this.IsPostBack)return true;
                }

                return false;
            }
        }

        /*
        public string GetUserDateAndTime(object value)
        {
            if (value is DateTime)
            {
                DateTime dt = currentUser.GetUserDateTime((DateTime)value);
                return dt.ToString(currentUser.FormatDate.Format + " " + currentUser.FormatTime.Format);
            }
            return "";
        }
        */

        bool contains(string key)
        {
            if (Request[key] == null) return false;
            return true;
        }
        string req(string key)
        {
            if (contains(key)) return Request[key];
            return "";
        }

    }
}
