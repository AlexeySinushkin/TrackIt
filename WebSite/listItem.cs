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
using System.ComponentModel;
using System.Drawing.Design;

namespace TrackIt.Website
{
    [ParseChildren(true, "Text")]
    public class listItem : IStateManager, IParserAccessor, IAttributeAccessor
    {

        Control text;
        [DefaultValue("")]
        [Editor("System.Web.UI.Design.WebControls.DataControlFieldTypeEditor, System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a", typeof(UITypeEditor))]
        [MergableProperty(false)]
        [PersistenceMode(PersistenceMode.InnerProperty)]
        public Control Text
        {
            get
            {
                if (text == null) text = new Control();
                return text;
            }
            set { text = value; }
        }

        

        #region IStateManager Members

        public bool IsTrackingViewState
        {
            get { return false; }
        }

        public void LoadViewState(object state)
        {
            
        }

        public object SaveViewState()
        {
            return null;
        }

        public void TrackViewState()
        {
           
        }

        #endregion

        #region IParserAccessor Members

        public void AddParsedSubObject(object obj)
        {
            
        }

        #endregion

        #region IAttributeAccessor Members

        public string GetAttribute(string key)
        {
            return "";
        }

        public void SetAttribute(string key, string value)
        {
            
        }

        #endregion
    }
}
