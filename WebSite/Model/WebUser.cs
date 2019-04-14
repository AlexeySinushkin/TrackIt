using System;
using System.Collections.Generic;
using System.Text;

using System.Globalization;

namespace TrackIt.Website.Model
{
    /// <summary>
    /// Физическое лицо.
    /// </summary>
    //[Table("Users")]
    public class WebUser :IFormatProvider
    {
        public int ID { get; set; } = -1;

        bool captchaSuccess = false;
        public bool CaptchaSuccess
        {
            get { return captchaSuccess; }
            set { captchaSuccess = value; }
        }
        

        string login = String.Empty;
        //[Column(30)]
        public string Login
        {
            get { return login; }
            set { login = value; }
        }

        string password = String.Empty;
        //[Column(30)]
        public string Password
        {
            get { return password; }
            set { password = value; }
        }

        /*
        FormatDate formatDate;
        //[ReferenceTo("FormatDateID")]
        public FormatDate FormatDate
        {
            get { return formatDate; }
            set { formatDate = value; }
        }

        FormatTime formatTime;
        //[ReferenceTo("FormatTimeID")]
        public FormatTime FormatTime
        {
            get { return formatTime; }
            set { formatTime = value; }
        }

        FormatDistance formatDistance;
        //[ReferenceTo("FormatDistanceID")]
        public FormatDistance FormatDistance
        {
            get { return formatDistance; }
            set { formatDistance = value; }
        }

        FormatTemperature formatTemperature;
        //[ReferenceTo("FormatTemperatureID")]
        public FormatTemperature FormatTemperature
        {
            get { return formatTemperature; }
            set { formatTemperature = value; }
        }
        */
        bool isActive = true;
        //[Column]
        public bool IsActive { get { return isActive; } set { isActive = value; } }
        /*
        public string DateTimeFormat
        {
            get
            {
                return string.Format("{0} {1}", (formatDate!=null)? formatDate.Format:"dd/MM/yyyy",
                    (formatTime!=null)?formatTime.Format:"HH:mm");
            }
        }
        */

        string firstName = "";
        /// <summary>
        /// Имя
        /// </summary>
        //[Column(100)]
        public string FirstName
        {
            get { return firstName; }
            set { firstName = value; }
        }
        string lastName = "";
        /// <summary>
        /// Фамилия
        /// </summary>
        //[Column(100)]
        public string LastName
        {
            get { return lastName; }
            set { lastName = value; }
        }
        string middleName = "";
        /// <summary>
        /// Для России это Отчество
        /// </summary>
        //[Column(100)]
        public string MiddleName
        {
            get { return middleName; }
            set { middleName = value; }
        }

        string email = "";
        /// <summary>
        /// E-mail
        /// </summary>
        //[Column(100)]
        public string EMail
        {
            get { return email; }
            set { email = value; }
        }

        public string Name
        {
            get { return string.Format("[{0}] ",this.Login)+FirstName + " " + LastName; }
            set { }
        }
        public string About
        {
            get { return ""; }
            set{}
        }

        /// <summary>
        /// true - пользователь анонимен.
        /// </summary>
        public bool IsAnonymous
        {
            get
            {
                if (this.ID > 0) return false;
                return true;
            }
        }
        long anonDeviceIMEI = 0;
        public long AnonymousDeviceIMEI
        {
            get { return anonDeviceIMEI; }
            set { anonDeviceIMEI = value; }
        }

        public static WebUser GetAnonymous()
        {
            WebUser u = new WebUser();
            /*
            u.ID = -1;
            u.formatDate = FormatDate.FindFirst();
            u.formatTime = FormatTime.FindFirst();
            u.formatDistance = FormatDistance.FindFirst();
            u.formatTemperature = FormatTemperature.FindFirst();
            u.timeZone = UserTimeZone.FindFirst(Expression.Eq("TimeZoneID", "Greenwich Standard Time"));
            */
            return u;
        }

        public object GetFormat(Type formatType)
        {
            throw new NotImplementedException();
        }

        //public List<Company> GetUnions()
        //{
        //    List<Company> l = new List<Company>();
        //    l.AddRange(Company.GetAll(Expression.In("ID", "Select UnionID from UserVsUnion where UserID="+this.ID.ToString())));
        //    return l;

        //}
        /*
                List<Company> unions;

                public List<Company> Unions
                {
                    get {
                        if (unions == null)
                        {
                            unions = this.GetObjects<Company, UserVsCompany>();
                        }
                        return unions; 
                    }
                    set { unions = value; }
                }


                #region IFormatProvider Members

                public override object GetFormat(Type formatType)
                {
                    if (typeof(DateTime) == formatType || typeof(DateTimeFormatInfo)==formatType) 
                    {
                        return DateTimeFormat;
                    }
                    return base.GetFormat(formatType);
                }

                #endregion

                public DateTime GetGMT(DateTime value)
                {
                    if (timeZone == null) throw new InvalidOperationException("UserTimeZone is not defined");
                    if (timeZone.timeZone == null)
                    {
                        timeZone.timeZone = TimeZoneInfo.FindSystemTimeZoneById(timeZone.TimeZoneID) ?? TimeZoneInfo.Utc;
                    }
                    return TimeZoneInfo.ConvertTimeToUtc(value, timeZone.timeZone);
                }

                public DateTime GetUserDateTime(DateTime value)
                {
                    if (timeZone == null) throw new InvalidOperationException("UserTimeZone is not defined");
                    if (timeZone.timeZone == null)
                    {
                        timeZone.timeZone = TimeZoneInfo.FindSystemTimeZoneById(timeZone.TimeZoneID) ?? TimeZoneInfo.Utc;
                    }
                    return TimeZoneInfo.ConvertTimeFromUtc(value, timeZone.timeZone);
                }

                public int GetNativeTemperature(float value)
                {
                    if (formatTemperature.Format == "C")
                    {
                        return Temperature.FromCelsiusToNative(value);
                    }
                    return Temperature.FromCelsiusToNative(value);
                }
                public float GetUserTemperature(int value)
                {
                    if (formatTemperature.Format == "C")
                    {
                        return Temperature.FromNativeToCelsius(value);
                    }
                    return Temperature.FromNativeToCelsius(value);
                }

                bool isAdmin = false;
                [Column]
                public bool IsAdmin
                {
                    get { return isAdmin; }
                    set { isAdmin = value; }
                }



                UserTimeZone timeZone;
                [ReferenceTo("TimeZoneID")]
                public UserTimeZone TimeZone
                {
                    get { return timeZone; }
                    set { timeZone = value; }
                }

                WebFileLight photo;
                [ReferenceTo("PhotoID")]
                public WebFileLight Photo
                {
                    get { return photo; }
                    set { photo = value; }
                }

                WebFileLight photoLight;
                [ReferenceTo("PhotoLightID")]
                public WebFileLight PhotoLight
                {
                    get { return photoLight; }
                    set { photoLight = value; }
                }



                public int IUserType
                {
                    get { return 2; }
                }



                public string IUserClassName
                {
                    get { return "WebUser"; }
                }
                */

    }
}
