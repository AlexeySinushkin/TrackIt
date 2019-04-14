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
    public class SecurityMan
    {
        public static void AddUnSuccessfulIP(string ip)
        {

        }
        public static bool allowedLogin(string ip)
        {

            return true;
        }
    }
}
