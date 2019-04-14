using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Web.SessionState;
using System.Web.UI;
using TrackIt.Model;
using TrackIt.Website.Model;
using TrackIt.WebSite;

namespace TrackIt.Website
{

    
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public abstract class BaseHttpHandler : IHttpHandler, IRequiresSessionState
    {
        protected HttpContext context;
        protected HttpRequest request;
        protected HttpResponse response;
        //public static readonly Config config = Config.GetConfig();
        protected System.Web.SessionState.HttpSessionState Session;
        /// <summary>
        /// Текущий пользователь
        /// Может быть NULL !!!
        /// </summary>
        protected WebUser currentUser
        {
            get
            {
                return (WebUser)Session["currentUser"];
            }
            set
            {
                Session["currentUser"] = value;
            }
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
        public void ProcessRequest(HttpContext context)
        {
            this.context = context;
            this.request = context.Request;
            this.response = context.Response;
            this.Session = context.Session;

            Process();
        }
        protected BaseControl getBaseControl(Control childControl)
        {
            if (childControl == null) return null;
            if (childControl is BaseControl) return childControl as BaseControl;
            return getBaseControl(childControl.Parent);
        }
        protected UpdatePanel getUpdatePanel(Control childControl)
        {
            if (childControl == null) return null;
            if (childControl is UpdatePanel) return childControl as UpdatePanel;
            return getUpdatePanel(childControl.Parent);
        }


        protected bool have(string p)
        {
            if (request[p] == null) return false;
            return true;
        }
        protected string value(string p)
        {
            if (have(p)) return request[p];
            return "";
        }

        public abstract void Process();





    }
}
