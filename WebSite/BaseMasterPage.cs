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

using System.IO;
using TrackIt.Website.Model;
using WebSite.Common;

namespace TrackIt.Website
{
    public class BaseMasterPage : System.Web.UI.MasterPage
    {


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
                    UserVsCompany vs = UserVsCompany.FindFirst(Expression.Eq("User", currentUser));
                    if (vs != null)
                    {
                        currentActor = vs.Company;
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
        }
        */
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
        protected override void OnUnload(EventArgs e)
        {
            base.OnUnload(e);
            firstLoad = false;
        }
        protected string pageName
        {
            get
            {
                return Request.Path.Replace("/", "");
            }
        }
        public ContentManager cm
        {
            get
            {
                if (this.Session["$cm"] == null)
                {
                    ContentManager cm = ContentManager.GetCurrent();
                    //cm.culture = currentCulture;
                    cm.context = Context;
                    this.Session["$cm"] = cm;
                }
                return this.Session["$cm"] as ContentManager;
            }
            set
            {
                this.Session["$cm"] = value;
            }
        }
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
        /*
        public string GetUserDateAndTime(object value)
        {
            if (value is DateTime)
            {
                DateTime dt = currentUser.GetUserDateTime((DateTime)value);
                return dt.ToString(currentUser.FormatDate.Format + " " + currentUser.FormatTime.Format);
            }
            return "";
        }*/

        DateTime start
        {
            get
            {
                return ((BasePage)this.Page).start;
            }
        }
        public string GetMilliseconds()
        {
            TimeSpan ts = DateTime.Now - start;
            if (ts.TotalMilliseconds == 0) return "< 1";
            return Math.Round(ts.TotalMilliseconds).ToString();
        }
        public string GetLightStyle()
        {
            string path=MapPath("~/App_Themes/style.css");
            if (File.Exists(path))
            {
                string text= File.ReadAllText(path);
                int i = text.IndexOf("/*preload-end*/");
                if (i > 0) return text.Substring(0, i);
            }
            return "";
        }
        public string GetPageStyle()
        {
            return String.Format("<link rel='stylesheet' type='text/css' href='/App_Themes/{0}.css' />", pageName);
        }

    }
}
