using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace WebSite.Common
{
    public class Ex
    {
        public static log4net.ILog log = log4net.LogManager.GetLogger("ErrorLogger");
        /// <summary>
        /// Добавить исключение
        /// </summary>
        /// <param name="Text"></param>
        public static void Add(string Text)
        {
            Ex ex = new Ex();
            //ex.text = Text;
            //ex.WriteMessage();
            Debug.Write(Text + "\r\n");
            log.Error(Text + "\r\n");
        }

        /// <summary>
        /// Добавить исключение
        /// </summary>
        /// <param name="Except"></param>
        public static void Add(Exception Except)
        {
            Ex.Add(Except.ToString());
        }

        //string text;
        //public void Write(string Text)
        //{
        //    this.text = Text;
        //    System.Threading.Thread th = new System.Threading.Thread(new System.Threading.ThreadStart(this.WriteMessage));
        //    th.Priority = System.Threading.ThreadPriority.Lowest;
        //    th.Start();
        //}
        //void WriteMessage()
        //{
        //   //throw new Exception(this.text);
        //    if (Config.OSType == Config.OSTypes.Unix)
        //    {
        //        System.IO.FileStream fs = new System.IO.FileStream("/temp/exception_" + DateTime.Now.ToString("dd.MM.yyyy HH.mm.ss ").Replace(":", ".").Replace("/", ".").Replace("\\", ".") + "_" + DateTime.Now.Millisecond.ToString() + " " + Guid.NewGuid().ToString() + ".txt", System.IO.FileMode.Create);
        //        byte[] b_text = System.Text.Encoding.UTF8.GetBytes(this.text);
        //        fs.Write(b_text, 0, b_text.Length);
        //        fs.Close();
        //    }
        //}
    }
}
