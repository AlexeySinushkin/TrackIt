using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.IO;

namespace Common
{
    public class ImageResizer
    {

        
        Image m_src_image;
        public Image SourceImage
        {
            get { return m_src_image; }
            set { m_src_image = value; }
        }

        Stream sourseImageStream;
        /// <summary>
        /// Stream исходного изображения
        /// </summary>
        public Stream SourseImageStream
        {
            get { return sourseImageStream; }
            set { sourseImageStream = value; }
        }

        double m_width;
        public double Width
        {
            get { return m_width; }
            set { m_width = value; }
        }
        double m_height;
        public double Height
        {
            get { return m_height; }
            set { m_height = value; }
        }

        public byte[] GetImageAsFile(string contentType)
        {
            System.Drawing.Imaging.ImageFormat imgFormat;
            string ct=contentType.Trim().ToLower();
            if (ct.IndexOf("gif")>=0)
            {
                imgFormat = System.Drawing.Imaging.ImageFormat.Gif;
            }
            else if (ct.IndexOf("bmp") >= 0)
            {
                imgFormat = System.Drawing.Imaging.ImageFormat.Bmp;
            }
            else if (ct.IndexOf("png") >= 0)
            {
                imgFormat = System.Drawing.Imaging.ImageFormat.Png;
            }
            else
            {
                imgFormat = System.Drawing.Imaging.ImageFormat.Jpeg;
            }        
            Image img = GetImage();
            using (MemoryStream ms = new MemoryStream())
            {
                img.Save(ms, imgFormat);
                return ms.ToArray();
            }
        }

        public Image GetImage()
        {
            Graphics m_graphics;

            double new_width = Width;
            double new_height = Height;
            if (m_src_image == null)
            {
                m_src_image = Image.FromStream(sourseImageStream);
            }


            if (Width != 0 && Height == 0)
            {
                new_height = (Width / (double)m_src_image.Width) * m_src_image.Height;
            }
            else if (Height != 0 && Width == 0)
            {
                new_width = (Height / (double)m_src_image.Height) * m_src_image.Width;
            }

            Bitmap bitmap = new Bitmap((int)new_width, (int)new_height, m_src_image.PixelFormat);
            m_graphics = Graphics.FromImage(bitmap);
            m_graphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
            m_graphics.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;

            m_graphics.DrawImage(m_src_image, 0, 0, bitmap.Width, bitmap.Height);
            return bitmap;
        }
    }
}
