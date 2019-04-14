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
using System.Drawing.Design;
using System.Collections.Generic;
using TrackIt.WebSite;

namespace TrackIt.Website
{
    [ParseChildren(true, "Items")]
    public class radio : DataBoundControl, IPostBackDataHandler
    {

        public string SelectedValue
        {
            get
            {
                if (this.Context.Session[this.UniqueID+ "$SelectedValue"] == null)
                {
                    this.Context.Session[this.UniqueID + "$SelectedValue"] = "";
                }
                return this.Context.Session[this.UniqueID + "$SelectedValue"] as string;
            }
            set
            {
                this.Context.Session[this.UniqueID + "$SelectedValue"] = value;
            }
        }
        bool selectedIndexChanged = false;
        [Browsable(true)]
        [Editor("System.Web.UI.Design.WebControls.DataControlFieldTypeEditor, System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a", typeof(UITypeEditor))]
        public event EventHandler SelectedIndexChanged;

        string defaultValue;
        [Browsable(true)]
        [DefaultValue(true)]
        public string DefaultValue
        {
            get { return defaultValue; }
            set { defaultValue = value; }
        }

        protected override void OnInit(EventArgs e)
        {
            EnableViewState = false;
            base.OnInit(e);
        }
        

        bool IPostBackDataHandler.LoadPostData(string postDataKey, NameValueCollection postCollection)
        {
            string newKey = postCollection[postDataKey];
            if (newKey != SelectedValue)
            {
                SelectedValue = newKey;
                selectedIndexChanged = true;  
            }
            return true;
        }
        public void RaisePostDataChangedEvent()
        {

        }
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            if (string.IsNullOrEmpty(SelectedValue)) SelectedValue = DefaultValue;
            foreach (radioItem item in Items)
            {
                this.Controls.Add(item);
            }
            if (selectedIndexChanged && this.SelectedIndexChanged!=null) SelectedIndexChanged(this,new EventArgs());
        }
        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            this.Attributes.Add("name", this.UniqueID);
            this.Attributes.Add("id", this.ClientID);
            //if (this.AutoPostBack)
            //{
            //    this.Attributes.Add("onchange", string.Format("javascript:setTimeout('__doPostBack(\\'{0}\\',\\'\\')', 0)",this.UniqueID));
            //}
            Type parentType = getParent(this.Parent).GetType();
            FieldInfo thisField = parentType.GetField(this.ID);
            if (thisField != null)
            {
                object[] formItems = thisField.GetCustomAttributes(typeof(FormItemAttribute), true);
                if (formItems.Length > 0)
                {
                    FormItemAttribute f = formItems[0] as FormItemAttribute;
                    this.Attributes.Add("regex", f.InExpression);
                    this.Attributes.Add("onkeyup", "$(this).check()");
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

        radioItemCollection items;
        [DefaultValue("")]
        [MergableProperty(false)]
        [PersistenceMode(PersistenceMode.InnerProperty)]
        public  radioItemCollection Items
        {
            get
            {
                if (items == null) items = new radioItemCollection();
                return items;
            }
        }

        public override void RenderControl(HtmlTextWriter writer)
        {
            Attributes["class"] = "radio " + this.CssClass;
            writer.Write("<ul ");
            foreach (string key in Attributes.Keys)
            {
                writer.Write("{0}=\"{1}\" ", key, Attributes[key]);
            }
            writer.Write(">");
            
            foreach (radioItem item in Items)
            {
                writer.Write("<li>");
                item.RenderControl(writer);
                writer.Write("</li>");
            }
            writer.Write("</ul>\r\n");           
        }

        




    }
    public class radioItemCollection : List<radioItem>
    {

    }
    [ParseChildren(true, "Text")]
    public class radioItem : Control, INamingContainer
    {


        string _value;
        [Browsable(true)]
        [DefaultValue(true)]
        public string Value
        {
            get { return _value; }
            set { _value = value; }
        }

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
        radio parent;
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            Control control;
            while (true)
            {
                control = this.Parent;
                if (control is radio || control == null)
                {
                    parent = (radio)control;
                    break;
                }
            }
        }
        //<input id="ctl00_BottomCenter_vt_map_desc_1" type="radio" value="1" name="ctl00$BottomCenter$vt$map_desc"/>
        public override void RenderControl(HtmlTextWriter writer)
        {

            if (text != null)
            {
                string selected = (parent.SelectedValue == Value) ? "checked=\"checked\"" : "";
                writer.Write("<input id=\"{0}_{2}\" name=\"{1}\" type=\"radio\" value=\"{2}\" {3} />",
                    parent.ClientID, parent.UniqueID, Value, selected);
                writer.Write("<label for=\"{0}_{1}\">", parent.ClientID, Value);
                text.RenderControl(writer);
                writer.Write("</label>");
            }
        }


    }
    
}
