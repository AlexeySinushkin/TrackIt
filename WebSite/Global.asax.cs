using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Reflection;
using System.Threading;
using System.Globalization;
using System.IO;

using System.Net;
using TrackIt.Model;
using WebSite.Common;

namespace TrackIt.Website
{
    public class Global : System.Web.HttpApplication
    {
        //StateManager stateManer;

        public static NumberFormatInfo nfi;
        public static string gfrcmKey = "GateFreeRequestsControlManager";
        static Global()
        {
            //Важно для Json Чтобы не хардкодить Replace(",",".")
            nfi = new NumberFormatInfo();
            nfi.NumberDecimalSeparator = ".";
            nfi.NumberGroupSeparator = "";
        }
        protected void Application_Start(object sender, EventArgs e)
        {
            log4net.Config.XmlConfigurator.Configure();

            //Castle.ActiveRecord.ActiveRecordStarter.Initialize();            
            //Castle.ActiveRecord.ActiveRecordStarter.RegisterAssemblies(Assembly.Load("Model"));
            
            

            try
            {
                //Common.Config config = Common.Config.GetConfig();
                /*
                if (!Directory.Exists(config.UploadingFilesDirectory))
                {
                    Directory.CreateDirectory(config.UploadingFilesDirectory);
                }
                */
                /*
                stateManer = new StateManager();
                Thread th = new Thread(new ThreadStart(stateManer.Start));
                th.Name = "State Manager";
                th.Priority = ThreadPriority.Lowest;
                th.Start();
                 * */



            }
            catch (Exception ex)
            {
                Ex.Add(ex);
            }


            //Thread.CurrentThread.CurrentCulture.NumberFormat = nfi;
            //Thread.CurrentThread.CurrentUICulture.NumberFormat = nfi;
        }


        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {
            
        }
    }
}