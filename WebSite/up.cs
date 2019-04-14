using System.Web.UI;
using System.ComponentModel;

namespace TrackIt.Website
{
    public class UPanel:UpdatePanel
    {

        /// <summary>
        /// Обновляется ли эта UpdatePanel
        /// </summary>
        public bool IsUpdating
        {
            get
            {
                bool updatingresult = false;
                ScriptManager current=ScriptManager.GetCurrent(this.Page);
                Control control = this.Page.FindControl(current.AsyncPostBackSourceElementID);
                while (control != null)
                {
                    if (control is UpdatePanel) break;
                    control = control.Parent;
                }
                if (control != null)
                {
                    if (this.ClientID == control.ClientID) updatingresult = true;                    
                }
                if (this.IsInPartialRendering)
                {
                    updatingresult = true;
                }
                if (this.RequiresUpdate)
                {
                    updatingresult = true;
                }
                return updatingresult;
            }
        }

        string cssClass;
        [Browsable(true)]
        public string CssClass
        {
            get { return cssClass; }
            set { cssClass = value; }
        }

        string style;
        [Browsable(true)]
        public string Style
        {
            get { return style; }
            set { style = value; }
        }

        protected override void Render(HtmlTextWriter writer)
        {
            if (!string.IsNullOrEmpty(cssClass))
            {
                writer.AddAttribute("class", cssClass);
            }
            if (!string.IsNullOrEmpty(style))
            {
                writer.AddAttribute("style", style);
            }
            base.Render(writer);
        }
    }
}
