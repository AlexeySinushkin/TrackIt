using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("WebActions")]
    public class WebAction : localizableObject<WebAction>
    {
        string text = string.Empty;
        [Localizable]
        public string Text
        {
            get { return text; }
            set { text = value; }
        }

        string windowName = String.Empty;
        [Column(50)]
        public string Link
        {
            get { return windowName; }
            set { windowName = value; }
        }

        int indent=0;
        /// <summary>
        /// Величина отступа для дочерних элементов
        /// text-indent:10;
        /// </summary>
        public int Indent
        {
            get { return indent; }
            set { indent = value; }
        }

        WebAction parentAction;
        [ReferenceTo("ParentID")]
        public WebAction ParentAction
        {
            get { return parentAction; }
            set { parentAction = value; }
        }

        int position;
        [Column]
        public int Position
        {
            get { return position; }
            set { position = value; }
        }

        int section;
        [Column]
        public int Section
        {
            get { return section; }
            set { section = value; }
        }


        public bool NoLink
        {
            get
            {
                if (string.IsNullOrEmpty(Link)) return true;
                System.Web.HttpContext context = System.Web.HttpContext.Current;
                if (context != null)
                {
                    if (context.Request.Url.PathAndQuery.Replace("/","").ToLower()==Link.ToLower())
                    {
                        return true;
                    }
                }
                return false;
            }
        }
        public string Html
        {
            get
            {
                if (NoLink) return Text;
                return string.Format("<a href=\"{0}\">{1}</a>", Link, Text);
            }
        }
    }
}
