
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using TrackIt.Model;
using TrackIt.Website.Model;
using TrackIt.Website.Model;
using Website.Common;
using WebSite.Common;

namespace TrackIt.Website
{
    /// <summary>
    /// Сводное описание для WebService1
    /// </summary>
    [WebService(Namespace = "http://track-it.ru/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // Чтобы разрешить вызывать веб-службу из скрипта с помощью ASP.NET AJAX, раскомментируйте следующую строку. 
    // [System.Web.Script.Services.ScriptService]
    public class gatefree : System.Web.Services.WebService
    {


        const long MIN_SERIAL_NUMBER = 1000000;
        const string ERROR = "RESULT-ERROR ";
        
        /// <summary>
        /// 
        /// </summary>
        /// <returns>RESULT-REJECT RESULT-OK RESULT-ERROR</returns>
        [WebMethod]
        public string AddData(string IMEI, string _Timestamp, 
            string Latitude, string Longitude, string Accuracy)
        {
            try
            {
                long imei = Int64.Parse(IMEI);
                if (imei < MIN_SERIAL_NUMBER)
                {
                    return ERROR + "Abnormal serial number";
                }

                
                DateTime sampleDate = Timestamp.GetDate(UInt32.Parse(_Timestamp));
                
                if (sampleDate.AddDays(3) < DateTime.UtcNow)
                {
                    return "RESULT-REJECT";
                }


                Device device = PseudoDB.GetDevice(imei);
                device.ConnectionDate = DateTime.UtcNow;


                /*DeviceMove dMove = DeviceMove.FindOne(Expression.Eq("Device", device),
                    Expression.Eq("SampleDate", sampleDate));*/
                var dMove = PseudoDB.deviceMoves.Find(d => d.Device == device 
                    && d.SampleDate==sampleDate);

                if (dMove != null)//такие данные уже есть
                {
                    return "RESULT-REJECT";
                }

                dMove = new DeviceMove();
                dMove.SampleDate = sampleDate;
                dMove.Latitude = GPS.DegToNative(float.Parse(Latitude, Global.nfi));
                dMove.Longitude = GPS.DegToNative(float.Parse(Longitude, Global.nfi));
                dMove.Accuracy = UInt16.Parse(Accuracy);
                dMove.Device = device;
                dMove.Create();
                return "RESULT-OK";

            }
            catch (Exception ex)
            {
                Ex.Add(ex);
                Ex.log.ErrorFormat("On request with params {0} {1} {2} {3} {4} ", 
                    IMEI, _Timestamp, Latitude, Longitude, Accuracy);
            }
            return "RESULT-ERROR";
        }
    }
}
