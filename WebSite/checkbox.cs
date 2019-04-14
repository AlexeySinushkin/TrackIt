using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Text;
using System.ComponentModel;
using System.Text.RegularExpressions;

namespace TrackIt.Website
{
    public class checkbox:CheckBox
    {
        string contentKey;
        [Browsable(true)]
        [DefaultValue(true)]
        public string ContentKey
        {
            get { return contentKey; }
            set { contentKey = value; }
        }

        string defaultText;
        [Browsable(true)]
        [DefaultValue(true)]
        public string DefaultText
        {
            get { return defaultText; }
            set { defaultText = value; }
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            ContentManager cm = ContentManager.GetCurrent();
            if (cm!=null)this.Text = cm.Get(this.contentKey, this.defaultText);
        }


    }

}
