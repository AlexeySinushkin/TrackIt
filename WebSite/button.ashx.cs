using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Drawing;
using System.IO;
using System.Text.RegularExpressions;

namespace TrackIt.Website
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    //[WebService(Namespace = "http://tempuri.org/")]
    //[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class buttonLoader : IHttpHandler
    {
        HttpContext context;

        byte[] buttonBackground
        {
            get
            {
                if (context.Application["button"] == null)
                {
                    context.Application["button"] = File.ReadAllBytes(context.Request.MapPath("/images/button.jpg"));
                }
                return (byte[])context.Application["button"];
            }
        }
        byte[] buttonBackgroundOver
        {
            get
            {
                if (context.Application["buttonOver"] == null)
                {
                    context.Application["buttonOver"] =File.ReadAllBytes(context.Request.MapPath("/images/buttonover.jpg"));
                }
                return (byte[])context.Application["buttonOver"];
            }
        }
        byte[] buttonBackgroundDown
        {
            get
            {
                if (context.Application["buttonDown"] == null)
                {
                    context.Application["buttonDown"] = File.ReadAllBytes(context.Request.MapPath("/images/buttondown.jpg"));
                }
                return (byte[])context.Application["buttonDown"];
            }
        }
        static Regex buttons = new Regex("/images/buttons(?<type>(over)|(down))?/(?<text>.{1,50})", RegexOptions.IgnoreCase);
        enum buttonTypes { normal = 0, over = 1, down = 2 }
        public void ProcessRequest(HttpContext context)
        {
            this.context=context;
            //string test=System.Web.HttpUtility.UrlDecode(context.Request.RawUrl,context.Request.ContentEncoding);

            Match buttonMatch = buttons.Match(context.Request.Path);
            string text = "Error";
            buttonTypes buttonType = buttonTypes.normal;
            if (buttonMatch.Success && buttonMatch.Groups["text"].Success)
            {
                text = buttonMatch.Groups["text"].Value;
                if (buttonMatch.Groups["type"].Success)
                {
                    if (buttonMatch.Groups["type"].Value == "over") buttonType = buttonTypes.over;
                    if (buttonMatch.Groups["type"].Value == "down") buttonType = buttonTypes.down;
                }
            }
            else
            {
                text = context.Request["text"];
                if (text == null || text.Length > 50) text = "Error";
            }

            context.Response.ContentType = "image/jpeg";
            Font font = new Font(new FontFamily("Tahoma"), 10,FontStyle.Bold);
            Pen pen = new Pen(Color.FromArgb(0xfe,0xfe,0xfe));
            pen.DashStyle = System.Drawing.Drawing2D.DashStyle.Solid;
            Brush brush = pen.Brush;

            Image background =null;
            if (buttonType==buttonTypes.over)
            {
                using (MemoryStream ms = new MemoryStream(buttonBackgroundOver))
                {
                    background = Bitmap.FromStream(ms);
                }
            }
            else if (buttonType == buttonTypes.down)
            {
                using (MemoryStream ms = new MemoryStream(buttonBackgroundDown))
                {
                    background = Bitmap.FromStream(ms);
                }
            }
            else
            {
                using (MemoryStream ms = new MemoryStream(buttonBackground))
                {
                    background = Bitmap.FromStream(ms);
                }
            }
            //define graphics for measureing of string
            Graphics graf = Graphics.FromImage(background);
            SizeF textSize=graf.MeasureString(text,font);
            //define new image with known width
            Bitmap bmap = new Bitmap((int)textSize.Width+12, 20);
            float x = (bmap.Width / 2) - (textSize.Width / 2)+4;
            float y = (bmap.Height / 2) - (textSize.Height / 2);
            //redefine graphics
            graf = Graphics.FromImage(bmap);
            graf.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
            graf.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
            graf.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
            graf.CompositingMode = System.Drawing.Drawing2D.CompositingMode.SourceOver;
            graf.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;            

            //draw
            graf.DrawImage(background, new Rectangle(0,0,bmap.Width,bmap.Height), new Rectangle(0,0,background.Width,background.Height), GraphicsUnit.Pixel);
            graf.DrawString(text, font, brush, x, y);
            
            
            bmap.Save(context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}
