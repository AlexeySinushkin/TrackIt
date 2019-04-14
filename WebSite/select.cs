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
using System.Collections.Specialized;
using System.Collections;
using TrackIt.WebSite;

namespace TrackIt.Website
{
    public class select:DropDownList
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
        
        
        public override string SelectedValue
        {
            get
            {
                if (this.Context.Session[this.UniqueID+ "$SelectedKey"] == null)
                {
                    this.Context.Session[this.UniqueID + "$SelectedKey"] = "";
                }
                return this.Context.Session[this.UniqueID + "$SelectedKey"] as string;
            }
            set
            {
                this.Context.Session[this.UniqueID + "$SelectedKey"] = value;
            }
        }

        public override int SelectedIndex
        {
            get
            {
                System.Diagnostics.StackTrace st = new System.Diagnostics.StackTrace();
                
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        public override ListItem SelectedItem
        {
            get
            {
                throw new Exception("Use GetCurrent() method instead");
            }
        }

        bool selectedIndexChanged = false;

        protected override void OnInit(EventArgs e)
        {
            EnableViewState = false;
            if (string.IsNullOrEmpty(DataValueField)) DataValueField = "ID";
            if (string.IsNullOrEmpty(DataTextField)) DataTextField = "ID";
            base.OnInit(e);
        }
        protected override bool LoadPostData(string postDataKey, System.Collections.Specialized.NameValueCollection postCollection)
        {
            string newKey = postCollection[postDataKey];
            if (newKey != SelectedValue)
            {
                SelectedValue = newKey;
                selectedIndexChanged = true;  
            }
            return selectedIndexChanged; //base.LoadPostData(postDataKey, postCollection);
        }
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            //if (selectedIndexChanged) OnSelectedIndexChanged(new EventArgs()); делается родителем
        }
        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            this.Attributes.Add("name", this.UniqueID);
            this.Attributes.Add("id", this.ClientID);
            this.Attributes.Add("class", this.CssClass);
            if (this.AutoPostBack)
            {
                this.Attributes.Add("onchange", string.Format("javascript:setTimeout('__doPostBack(\\'{0}\\',\\'\\')', 0)",this.UniqueID));
            }
            Type parentType = getParent(this.Parent).GetType();
            FieldInfo thisField = parentType.GetField(this.ID);
            if (thisField != null)
            {
                object[] formItems = thisField.GetCustomAttributes(typeof(FormItemAttribute), true);
                if (formItems.Length > 0)
                {
                    FormItemAttribute f = formItems[0] as FormItemAttribute;
                    this.Attributes.Add("regex", f.InExpression);
                    //this.Attributes.Add("onkeyup", "$(this).check()");
                    this.Attributes.Add("onchange", "$(this).check()");
                }
            }
        }
        Control getParent(Control control)
        {
            if (control == null) return null;
            if (control is BaseControl) return control;
            if (control is BasePage) return control;
            return getParent(control.Parent);
        }
        /// <summary>
        /// Возвращает выделенный объект
        /// </summary>
        /// <returns></returns>
        public object GetCurrent()
        {
            IList list = DataSource as IList;
            if (list != null)
            {
                IEnumerator en = list.GetEnumerator();
                while (en.MoveNext())
                {
                    if (DataBinder.Eval(en.Current, this.DataValueField).ToString() == SelectedValue)
                    {
                        return en.Current;
                    }
                }
            }
            return null;
        }
        public void SetCurrent(object obj)
        {
            if (obj == null)
            {
                SelectedValue = "";
                return;
            }
            SelectedValue=DataBinder.Eval(obj, this.DataValueField).ToString();
        }

        /*
    <select name="ctl00$BottomCenter$st$carrier" onchange="javascript:setTimeout('__doPostBack(\'ctl00$BottomCenter$st$carrier\',\'\')', 0)" id="ctl00_BottomCenter_st_carrier">
		<option value="-1">выберете</option>
		<option value="068975e9">Сидор Сидоров</option>
		<option value="01ac3122">Красный петух</option>
	</select>

         */
        public override void RenderControl(HtmlTextWriter writer)
        {

            writer.Write("<select ");
            foreach (string key in Attributes.Keys)
            {
                writer.Write("{0}=\"{1}\" ", key, Attributes[key]);
            }
            writer.Write(">");

            IList list = DataSource as IList;
            if (list != null)
            {
                if (list.Count > 0)
                {
                    if (string.IsNullOrEmpty(SelectedValue)) SelectedValue = "-1";
                    if (!string.IsNullOrEmpty(ContentKey))
                    {
                        writer.Write("<option value=\"-1\">{0}</option>", ContentManager.GetCurrent().Get(ContentKey, DefaultText));
                    }
                }
                IEnumerator en = list.GetEnumerator();              

                while (en.MoveNext())
                {
                    string value = DataBinder.Eval(en.Current, DataValueField).ToString();
                    object text = DataBinder.Eval(en.Current, DataTextField);
                    if (value == SelectedValue)
                    {
                        writer.Write("<option selected value=\"{0}\">{1}</option>", value, text);
                    }
                    else
                    {
                        writer.Write("<option value=\"{0}\">{1}</option>", value, text);
                    }
                }
            }
            writer.Write("</select>");
        }
    }
    
}
