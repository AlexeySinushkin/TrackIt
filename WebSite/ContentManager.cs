using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Text.RegularExpressions;
using TrackIt.Model;
using System.Reflection;
using System.Threading;


namespace TrackIt.Website
{
    public class ContentManager
    {
        public enum Options{JavaScriptEscape=1}
        static Regex itemPattern = new Regex(@"^(?<className>\w{1,20})\$(?<propertyName>\w{1,30})$");
        //public Culture culture;
        public HttpContext context;
        object lockCache = new object();
        private ContentManager() { }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="key">index$Slogan</param>
        /// <returns></returns>
        public string Get(string key)
        {
            return this.Get(key, "");
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="key">index$Slogan</param>
        /// <param name="alernativeText">Default text</param>
        /// <returns></returns>
        public string Get(string key, string alernativeText)
        {
            return alernativeText;
            /*if (string.IsNullOrEmpty(key)) return alernativeText;
            Match m = itemPattern.Match(key);
            string result = alernativeText;
            if (!m.Success || !m.Groups["className"].Success || !m.Groups["propertyName"].Success)
            {
                return result;
            }
            string fullKey = culture.CultureName + "$" + m.Groups["className"].Value + "$" + m.Groups["propertyName"].Value;
            lock (lockCache)
            {
                if (context.Application[fullKey] != null)
                {
                    result = (string)context.Application[fullKey];
                }
                else
                {
                    //Если ключ не кэширован, загружаем из базы
                    WebUIContent content = WebUIContent.FindFirst(Expression.Eq("ClassName", m.Groups["className"].Value),
                        Expression.Eq("PropertyName", m.Groups["propertyName"].Value), Expression.Eq("Culture", culture));
                    if (content != null)
                    {
                        context.Application[fullKey] = content.Text;
                        result = (string)context.Application[fullKey];

                        //такой ключ и свойство есть
                        //загружаем остальные
                        ParameterizedThreadStart pThreadStart = new ParameterizedThreadStart(loadClassName);
                        Thread thLoader = new Thread(pThreadStart);
                        thLoader.Name = "UIContent loader";
                        thLoader.Start(m.Groups["className"].Value);
                    }
                    else
                    {
                        //такого в базе нету, создаем его
                        try
                        {
                            content = new WebUIContent();
                            content.ClassName = m.Groups["className"].Value;
                            content.PropertyName = m.Groups["propertyName"].Value;
                            content.Culture = Culture.FindFirst(Expression.Eq("CultureName", "ru-RU"));
                            content.Text = alernativeText;
                            content.Create();
                            context.Application[fullKey] = alernativeText;
                        }
                        catch (Exception ex)
                        {
                            Ex.Add(ex);
                        }
                    }
                }
            }
            return result;*/
        }

        void loadClassName(object objClassName)
        {
          /*  string className = (string)objClassName;
            try
            {
                foreach (WebUIContent web in WebUIContent.FindAll(Expression.Eq("ClassName", className),
                    Expression.Eq("Culture", culture)))
                {
                    lock (lockCache)
                    {
                        string fullKey = culture.CultureName + "$" + web.ClassName + "$" + web.PropertyName;
                        if (context.Application[fullKey] == null)
                        {
                            context.Application[fullKey] = web.Text;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Ex.Add(ex);
            }*/
        }

        public string Get(string key, string alternativeText, bool escape)
        {
            string result = Get(key, alternativeText);
            if (escape)
            {
                return result.Replace("'", @"\'");
            }
            return result;
        }

        static ContentManager cmStatic;
        internal static ContentManager GetCurrent()
        {
            if (cmStatic == null)
            {
                if (System.Web.HttpContext.Current != null)
                {
                    cmStatic = new ContentManager();
                    cmStatic.context = System.Web.HttpContext.Current;
                }
                
            }
            return cmStatic;
            /*
            if (System.Web.HttpContext.Current != null)
            {
                if (System.Web.HttpContext.Current.Session["$cm"]==null)
                {
                    lock (System.Web.HttpContext.Current)
                    {
                        ContentManager cm = new ContentManager();
                        cm.culture = TrackIt.Model.Culture.FindFirst();
                        cm.context = System.Web.HttpContext.Current;
                        System.Web.HttpContext.Current.Session["$cm"] = cm;
                    }
                }
                return System.Web.HttpContext.Current.Session["$cm"] as ContentManager;
            }
            return null;*/
        }
    }
}
