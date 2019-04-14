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
    public class button:LinkButton
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

        string Caption = "Submit";

        string Script = "";

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            ContentManager cm = ContentManager.GetCurrent();
            if (cm!=null)this.Caption = cm.Get(this.contentKey, this.defaultText);
            //избавляемся от точки на конце
            this.Caption = new Regex(@"(\.)$").Replace(this.Caption,"");

            this.Attributes.Add("title", Caption);
            StringBuilder sb = new StringBuilder();
            sb.Append(string.Format("<img src='/images/buttons/{0}' alt='{0}'", Caption));
            sb.Append(string.Format("onmouseover=\"this.src='/images/buttonsover/{0}';\" ",Caption));
            sb.Append(string.Format("onmousedown=\"this.src='/images/buttonsdown/{0}';\" ", Caption));
            sb.Append(string.Format("onmouseout=\"this.src='/images/buttons/{0}';\" ", Caption));
            sb.Append(" />");

            this.Text = sb.ToString();
        }
        public override void RenderEndTag(HtmlTextWriter writer)
        {
            base.RenderEndTag(writer);
            string script=string.Format("<script type=\"text/javascript\">addImg('/images/buttonsover/{0}');addImg('/images/buttonsdown/{0}');</script>",Caption);
            if (ScriptManager.GetCurrent(this.Page).IsInAsyncPostBack)
            {
                ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), Guid.NewGuid().ToString(),
                script, false);
            }
            else
            {
                writer.Write(script);
            }
        }


    }

}
