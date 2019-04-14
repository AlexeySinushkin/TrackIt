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
using System.Text.RegularExpressions;


namespace TrackIt.Website
{
    public class HttpModule:IHttpModule,IHttpHandler
    {


        public void Dispose()
        {
           
        }
        HttpApplication context;
        public void Init(HttpApplication context)
        {
            context.BeginRequest += new EventHandler(context_BeginRequest);
            this.context = context;
        }

        void context_BeginRequest(object sender, EventArgs e)
        {
            if (context.Request.Path.Equals("/"))
            {
                context.Context.RewritePath("/index.aspx");
            }           
        }


        public bool IsReusable
        {
            get { return false; }
        }


        public void ProcessRequest(HttpContext context)
        {

        }

    }
}
