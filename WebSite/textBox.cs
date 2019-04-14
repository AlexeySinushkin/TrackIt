using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.ComponentModel;
using System.Reflection;

namespace TrackIt.Website
{
    public class textBox:TextBox
    {

        string validateText;
        /// <summary>
        /// текст валидации
        /// </summary>
        public string ValidateText
        {
            get { return validateText; }
            set { validateText = value; }
        }

        public override void RenderEndTag(HtmlTextWriter writer)
        {
            base.RenderEndTag(writer);
            if (!string.IsNullOrEmpty(validateText))
            {
                writer.Write("<div class='error'>{0}</div>", validateText);
            }
        }
    }
    
}
