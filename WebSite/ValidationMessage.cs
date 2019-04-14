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

namespace TrackIt.Website
{
    public class ValidationMessage
    {
        public ValidationMessage(string targetID, string message)
        {
            this.targetID = targetID;
            this.message = message;
        }

        string targetID;
        public string TargetID
        {
            get { return targetID; }
            set { targetID = value; }
        }

        string message;

        public string Message
        {
            get { return message; }
            set { message = value; }
        }
    }
}
