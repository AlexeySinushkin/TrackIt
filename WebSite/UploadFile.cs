using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace TrackIt.Website
{
    public class UploadFile
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="tempName">1-d64969de-9ff4-455f-9958-890411b865bf</param>
        public UploadFile(string tempName)
        {
            this.requestFileName = tempFileName + ".request";
            this.tempFileName = tempName + ".file";
        }

        string requestFileName;
        /// <summary>
        /// Называние файла реквеста в директории files-in-upload
        /// 1-d64969de-9ff4-455f-9958-890411b865bf.request
        /// </summary>
        public string RequestFileName
        {
            get { return requestFileName; }
            set { requestFileName = value; }
        }

        string tempFileName;
        /// <summary>
        /// Временное название файла в директории files-in-upload
        /// 1-d64969de-9ff4-455f-9958-890411b865bf.file
        /// </summary>
        public string TempFileName
        {
            get { return tempFileName; }
            set { tempFileName = value; }
        }

        string fileName;
        public string FileName
        {
            get { return fileName; }
            set { fileName = value; }
        }

        string contentType;
        /// <summary>
        /// image/jpeg к примеру
        /// </summary>
        public string ContentType
        {
            get { return contentType; }
            set { contentType = value; }
        }

        string url;
        /// <summary>
        /// /files/d64969de-9ff4-455f-9958-890411b865bf
        /// </summary>
        public string Url
        {
            get { return url; }
            set { url = value; }
        }


        bool isComplete = false;
        public bool IsComplete
        {
            get { return isComplete; }
            set { isComplete = value; }
        }

    }
}
