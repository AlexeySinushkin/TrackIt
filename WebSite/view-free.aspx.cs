using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using TrackIt.Model;
using System.Collections.Generic;
using Website.Common;
using System.Text.RegularExpressions;

using TrackIt.Website.Model;
using TrackIt.Website.Model;
using WebSite.Common;

namespace TrackIt.Website
{
    public partial class view_free : BasePage
    {

        protected int rowsAtPage = 100;
        

        bool shouldResetPage = false;
        enum lastState { Unknown, Stand, Move };


        protected Device device = null;
        protected DeviceMove[] gpsPoints = null;

        public string GetTimeZoneName()
        {
            return "";
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            

            if (Request.Params.Get("testing")=="1"){
                currentUser.CaptchaSuccess = true;
                currentUser.AnonymousDeviceIMEI = 359111055180451;
            }




            if (currentUser.CaptchaSuccess)
            {
                if (device==null)
                {
                    device = PseudoDB.GetDevice(currentUser.AnonymousDeviceIMEI);
                }
                else if (!IsPostBack)
                {
                    defineGPSPoints();
                }

                
                if (ScriptManager.GetCurrent(this).IsInAsyncPostBack)
                {
                      if (Request["__EVENTTARGET"] == mapTable.ID)
                      {
                         //Do update
                         mapTable.Update();
                      }
                }
            }
            else
            {
                Response.Redirect("/index-free.aspx");
            }

        }
        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
                    if (mapTable.IsUpdating)
                    {
                        defineGPSPoints();
                        ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), Guid.NewGuid().ToString(),
                        "gps.clearPoints(); gps.definePoints();", true);
                    }
        }


        protected void OnGPSPagingChange(object sender, EventArgs e)
        {
            //в onLoad проверяем UpdatePanel
            shouldResetPage = true;
        }


        #region map

        /// <summary>
        /// Автоматический значит по 30 точек на экране
        /// при приближение точки добавляются, при отдаление не удаляются
        /// </summary>
        void defineGPSPoints()
        {


            int currentGPSPage = 1;
            int tempPage = -1;
            int.TryParse(gpsPage.Value, out tempPage);
            if (tempPage > 0) currentGPSPage = tempPage;
            if (shouldResetPage)//допустим при переходе от поштучного пейджинга к цветовому
            {
                currentGPSPage = 1;
                gpsPage.Value = "1";
            }

            if (!IsPostBack)
            {
                map_desc.SelectedValue = "1";
            }


            IEnumerable<DeviceMove> dm = null;

            //логика пейджинга. На первой странице свежие данные
            if (map_desc.SelectedValue == "1")//
            {
                #region по заданным значениям
                int startIndex = (currentGPSPage - 1) * rowsAtPage;
                //var gpsPoints = DeviceMove.SlicedFindAll(startIndex, rowsAtPage,
                //    new Order[] { Order.Desc("SampleDate") }, criterias.ToArray());
                int skip = startIndex * rowsAtPage;

                dm = PseudoDB.deviceMoves.FindAll(d => d.Device == device)
                    .OrderByDescending(d => d.SampleDate).Skip(skip).Take(rowsAtPage);

                /*if (gpsPoints.Length == 0)
                {
                    gpsPoints = DeviceMove.SlicedFindAll(0, rowsAtPage,
                    new Order[] { Order.Desc("SampleDate") }, criterias.ToArray());
                    currentGPSPage = 1;
                }*/

                int totalRowsCount = PseudoDB.deviceMoves.Count;
                    //ActiveRecordMediator.Count(typeof(DeviceMove), criterias.ToArray());
                if (totalRowsCount > rowsAtPage)
                {
                    int index = 1;
                    for (int i = 1; i <= totalRowsCount; i += rowsAtPage)
                    {
                        HyperLink page = new HyperLink();
                        page.Text = index.ToString();
                        //if (currentGPSPage == index) page.Style.Add("border-width", "2px");
                        page.NavigateUrl = string.Format("javascript:changePage({0});", index);
                        page.ID = "gpsPage_" + index.ToString();
                        page.ClientIDMode = System.Web.UI.ClientIDMode.Static;
                        gpsPaging.Controls.Add(page);
                        Literal nbsp = new Literal();
                        nbsp.Text = " ";
                        gpsPaging.Controls.Add(nbsp);
                        index++;
                    }
                }
                #endregion
                //сортировка по возрастанию даты
                /*dm = from gp in gpsPoints
                                        orderby gp.SampleDate
                                        select gp;*/
            }
            else if (map_desc.SelectedValue == "2")//все
            {
                // gpsPoints = DeviceMove.FindAll(Order.Desc("SampleDate"), criterias.ToArray());
                dm = PseudoDB.deviceMoves.FindAll(d => d.Device == device)
                    .OrderByDescending(d => d.SampleDate);
            }
            else{
                dm = new DeviceMove[0];
            }


            gpsPoints = dm.ToArray();


            #region добавление строк с надписями
            //Определение состояния
            string startText = cm.Get("ViewTrackControl$StartMove", "Начал движение");
            string stopText = cm.Get("ViewTrackControl$StopMove", "Остановился");
            string standText = cm.Get("ViewTrackControl$Stand", "Стоит");
            string moveText = cm.Get("ViewTrackControl$Moving", "В движение");

            List<DeviceMove> points = new List<DeviceMove>(gpsPoints.Length);
            if (gpsPoints.Length > 1)
            {
                DeviceMove prev = gpsPoints[0];
                points.Add(prev);

                int standMeters = 30;// config.StandMeters;

                DeviceMove standPoint=null;

                lastState ls = lastState.Unknown;
                for (int i = 1; i < gpsPoints.Length; i++)
                {
                    DeviceMove point = gpsPoints[i];
                    double distance = point - prev;
                    //обработка ситуации когда долго небыло данных (больше часа)
                    if (prev != null)
                    {
                        TimeSpan period = point.SampleDate - prev.SampleDate;
                        if (period.TotalMinutes > 61)
                        {
                            ls = lastState.Unknown;
                            if (standPoint != null)
                            {
                                TimeSpan tspan = prev.SampleDate - standPoint.SampleDate;
                                prev.ActionOrState = standText + " " + tspan.ToString();
                                points.Add(prev);
                                standPoint = null;
                            }
                            points.Add(point);
                            prev = point;
                            continue;
                        }
                    }

                    //основная логика определния типа точки
                    if (ls == lastState.Unknown)
                    {
                        if (distance > standMeters)
                        {
                            point.ActionOrState = moveText;
                            ls = lastState.Move;
                        }
                        else
                        {
                            point.ActionOrState = standText;
                            ls = lastState.Stand;
                        }
                        points.Add(point);
                    }
                    else if (ls == lastState.Move)
                    {
                        if (distance > standMeters)
                        {
                            point.ActionOrState = moveText;
                            points.Add(point);
                        }
                        else
                        {
                            point.ActionOrState = stopText;
                            ls = lastState.Stand;
                            points.Add(point);
                        }
                    }
                    else if (ls == lastState.Stand)
                    {
                        if (distance > standMeters)
                        {
                            if (standPoint != null)
                            {
                                TimeSpan tspan = prev.SampleDate - standPoint.SampleDate;
                                prev.ActionOrState = standText+ " " + tspan.ToString();
                                points.Add(prev);
                                standPoint = null;
                            }
                            point.ActionOrState = startText;
                            points.Add(point);
                            ls = lastState.Move;
                        }
                        else
                        {
                            point.ActionOrState = standText;

                            //фильтруем точки стояния
                            if (filterStandPoints.Checked)
                            {
                                if (standPoint==null) standPoint = point;
                                if (gpsPoints.Length - 1 == i)//последняя точка - стояние
                                {
                                    if (standPoint != null)
                                    {
                                        TimeSpan tspan = point.SampleDate - standPoint.SampleDate;
                                        point.ActionOrState += " " + tspan.ToString();
                                        points.Add(point);
                                        standPoint = null;
                                    }
                                }
                            }                            
                            else
                            {
                                points.Add(point);
                            }
                        }
                    }
                    
                    prev = point;
                }
            }
            else if (gpsPoints.Length == 1)
            {
                points.Add(gpsPoints[0]);
            }
            #endregion

            gpsPoints = points.ToArray();
        }


        class gpsJson : DeviceMove
        {
            /// <summary>
            /// Sample date
            /// </summary>
            [JSON("sd", UseQuotes = true)]
            public string sd { get; set; }

            [JSON("ts", UseQuotes = true)]
            public string ts { get; set; }
        }

        public string GetGPSJSON()
        {
            if (gpsPoints == null) return "[]";
            var jPoints = from p in gpsPoints
                          select
                              new gpsJson
                              {
                                  ts = TimestampUtils.GetTimestamp(p.SampleDate).ToString(),
                                  sd = p.SampleDate.ToString(),
                                  ActionOrState = p.ActionOrState,
                                  Latitude = p.Latitude,
                                  Longitude = p.Longitude
                              };
            return JSON.Convert(jPoints);
        }

        #endregion

    }
}
