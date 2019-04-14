using System;
using System.Web.UI.WebControls;

using TrackIt.Model;
using System.Web.SessionState;
using System.Web.UI;
using TrackIt.Website.Model;
using WebSite.Common;

namespace TrackIt.Website
{
    public class baseTextBox:TextBox
    {
        protected WebUser currentUser
        {
            get
            {
                if (this.Context.Session["currentUser"] == null)
                {
                    try
                    {
                        WebUser u = new WebUser();
                        this.Context.Session["currentUser"] = u;
                    }
                    catch (Exception ex)
                    {
                        Ex.Add(ex);
                    }

                }
                return (WebUser)this.Context.Session["currentUser"];
            }
            set
            {
                this.Context.Session["currentUser"] = value;
            }
        }
    }
}
