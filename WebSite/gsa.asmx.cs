using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using TrackIt.Model;
using NHibernate.Expression;
using Common;
using System.Xml.Serialization;

namespace TrackIt.WebSite
{
    /// <summary>
    /// Summary description for gsa
    /// </summary>
    [WebServiceBindingAttribute(Name = "GSAServer",  Namespace = "http://www.track-it.ru/")]
    [WebService(Namespace = "http://www.track-it.ru/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class gsa : System.Web.Services.WebService
    {
        WebUser currentUser
        {
            get
            {
                if (Session["currentUser"] == null)
                {
                    try
                    {
                        WebUser u = WebUser.GetAnonymous();
                        Session["currentUser"] = u;
                    }
                    catch (Exception ex)
                    {
                        Ex.Add(ex);
                    }

                }
                return (WebUser)Session["currentUser"];
            }
            set
            {
                Session["currentUser"] = value;
            }
        }
        IUser currentActor
        {
            get
            {
                if (Session["currentActor"] == null)
                {
                    currentActor = currentUser;
                    UserVsCompany vs = UserVsCompany.FindFirst(Expression.Eq("User", currentUser));
                    if (vs != null)
                    {
                        currentActor = vs.Company;
                    }
                }
                return (IUser)Session["currentActor"];
            }
            set
            {
                Session["currentActor"] = value;
            }
        }

        public class Reply
        {
            public bool anwer = false;
            public string text = "";
        }
        

        public class SoapGateway : Reply
        {
            public long serialNumber;
            public string passwordServer;
            public byte[] passwordBT;
        }

        

        [WebMethod(EnableSession=true)]
        public Reply Login(String UserName, String Password)
        {
            Reply result = new Reply();
            //TODO:защита от подбора пароля.
            WebUser tmpUsr = WebUser.FindFirst(Expression.Eq("Login", UserName), Expression.Eq("Password", Password));
            if (tmpUsr != null)
            {
                currentUser = tmpUsr;
                result.anwer = true;
                result.text = "Авторизация прошла успешно";
            }
            else
            {
                result.text = "Такой пользователь не найден";
            }
            return result;
        }

        [WebMethod(EnableSession = true), XmlInclude(typeof(SoapGateway))]
        public SoapGateway CreateGateway()
        {
            SoapGateway result = new SoapGateway();
            if (currentUser.IsAnonymous)
            {
                result.text = "Вы не авторизованы";
                return result;
            }

            try
            {
                Gateway gw = new Gateway();
                gw.DeviceType = new DeviceType(DeviceType.DeviceTypes.Gateway);
                gw.PasswordServer = Guid.NewGuid().ToString();
                gw.PasswordBT = Guid.NewGuid().ToByteArray();
                gw.Container = TrackIt.Model.Container.FindFirst(Expression.Eq("Owner", currentActor));
                gw.Create();
                gw.SerialNumber = gw.ID;
                gw.Update();
                result.anwer = true;
                result.serialNumber=gw.SerialNumber;
                result.passwordBT=gw.PasswordBT;
                result.passwordServer=gw.PasswordServer;
            }
            catch (Exception ex)
            {
                result.text = ex.ToString();
            }

            return result;
        }

        [WebMethod(EnableSession = true), XmlInclude(typeof(SoapGateway))]
        public SoapGateway GetGateway(long sn)
        {
            SoapGateway result = new SoapGateway();
            if (currentUser.IsAnonymous)
            {
                result.text = "Вы не авторизованы";
                return result;
            }

            try
            {
                Gateway gw = Gateway.FindFirst(Expression.Eq("Container", TrackIt.Model.Container.FindFirst(Expression.Eq("Owner", currentActor))),
                    Expression.Eq("SerialNumber", sn));
                if (gw != null)
                {
                    result.anwer = true;
                    result.serialNumber = gw.SerialNumber;
                    result.passwordBT = gw.PasswordBT;
                    result.passwordServer = gw.PasswordServer;
                }
                else
                {
                    result.text = "Устройство ненайдено, либо не принадлежит Вам";
                }

            }
            catch (Exception ex)
            {
                result.text = ex.ToString();
            }

            return result;
        }
    }
}
