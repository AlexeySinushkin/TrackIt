using System;
using System.Collections.Generic;
using System.Text;
using System.Net.Mail;
using System.Threading;

namespace Common
{
    public class MailManager :MailMessage
    {
        public MailManager()
        {
            
        }
        static Config config = Config.GetConfig();
        public void ThreadSend()
        {
            Thread th = new Thread(new ThreadStart(this.threadSend));
            th.Start();
        }
        void threadSend()
        {
            Send();
        }
        public bool Send()
        {
            bool result = false;
            try
            {
                SmtpClient client = new SmtpClient();
                client.Host = config.SmtpHost;
                client.Port = config.SmtpPort;
                client.Credentials = new System.Net.NetworkCredential(config.SmtpLogin, config.SmtpPassword);
                if (this.From == null) this.From = new MailAddress(config.SmtpFrom, "www.track-it.ru", Encoding.ASCII);
                client.Send(this);
                result = true;
            }
            catch (Exception ex)
            {
                Ex.Add(this.To.ToString()+this.Subject+this.Body + ex.ToString());                
            }
            return result;
        }
    }
}
