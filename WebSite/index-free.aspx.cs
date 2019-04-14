using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TrackIt.Model;

namespace TrackIt.Website
{
    public partial class indexfree : BasePage
    {
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        //[FormItem("TextBoxIMEI", InExpression = @"^\d{15}$")]
        public textBox TextBoxIMEI;



        protected void OnUpIMEIClick(object sender, EventArgs e)
        {
            if (IMEICaptcha.Validate(IMEICaptchaTextBox.Text))
            {
                Regex r = new Regex(@"^\d{15}$");
                if (r.IsMatch(TextBoxIMEI.Text))
                {
                    currentUser.CaptchaSuccess = true;
                    currentUser.AnonymousDeviceIMEI=long.Parse(TextBoxIMEI.Text);
                    int tZone=0;
                    int.TryParse(Request.Params["timeZone"], out tZone);
                    //UserTimeZone tz = UserTimeZone.FindFirst(Expression.Eq("OffsetHours", tZone));
                    //if (tz != null) currentUser.TimeZone = tz;
                    Response.Redirect("/view-free.aspx");
                }
                else
                {
                    ErrorMessage = "Неправильный IMEI. Должно быть 15 цифр";
                }
            }
            else
            {
                ErrorMessage = "Неправильный код с картинки";
            }
            //Device.FindFirst(Expression.Eq("ID", int.Parse(tbSn.Text)))
        }
    }
}