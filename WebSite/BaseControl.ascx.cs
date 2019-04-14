using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections.Generic;
using TrackIt.Model;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Text;
using TrackIt.Website.Model;
using TrackIt.Website;
using WebSite.Common;

namespace TrackIt.WebSite
{
    public abstract partial class BaseControl : System.Web.UI.UserControl
    {
        public static string currentNameSpace = "TrackIt.WebSite";

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            //Culture c = currentCulture;            
        }
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
        }
        protected WebUser currentUser
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
        /*
        protected IUser currentActor
        {
            get
            {
                if (Session["currentActor"] == null)
                {
                    currentActor = currentUser;
                    if (!currentUser.IsNew)
                    {
                        UserVsCompany vs = UserVsCompany.FindFirst(Expression.Eq("User", currentUser));
                        if (vs != null)
                        {
                            currentActor = vs.Company;
                        }
                    }
                }
                return (IUser)Session["currentActor"];
            }
            set
            {
                Session["currentActor"] = value;
            }
        }
        protected Culture currentCulture
        {
            get
            {
                if (Session["currentCulture"] == null)
                {
                    Session["currentCulture"] = TrackIt.Model.Culture.FindFirst();
                }
                return (Culture)Session["currentCulture"];
            }
            set
            {
                Session["currentCulture"] = value;
            }
        }*/
        protected string currentPage
        {
            get { return "index.aspx"; }
        }

        /// <summary>
        /// Ключ уникальности страницы
        /// </summary>
        public string Key
        {
            get
            {
                return ((BasePage)this.Page).KeyViewState;
            }
        }


        protected bool firstLoad
        {
            get
            {
                if (Session["firstLoad"] == null)
                {
                    Session["firstLoad"] = currentUser.IsAnonymous;
                }
                return (bool)Session["firstLoad"];
            }
            set
            {
                Session["firstLoad"] = value;
            }
        }

        public ContentManager cm
        {
            get
            {
                if (this.Session["$cm"] == null)
                {
                    this.Session["$cm"] = ContentManager.GetCurrent();
                }
                return this.Session["$cm"] as ContentManager;
            }
            set
            {
                this.Session["$cm"] = value;
            }
        }
        protected string pageName
        {
            get
            {
                return Request.Path.Replace("/", "");
            }
        }/*
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
        //public static Config config = Config.GetConfig();


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

        protected bool contains(string key)
        {
            if (Request[key] == null) return false;
            return true;
        }
        protected string getValue(string key)
        {
            if (contains(key)) return Request[key];
            return "";
        }

    }
}
