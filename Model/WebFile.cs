using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;
using Common;
using NHibernate.Expression;
using System.Globalization;

namespace TrackIt.Model
{

    [Table("Files")]
    public class WebFile : modelObject<WebFile>
    {

        string guid= System.Guid.NewGuid().ToString();
        [Column(200)]
        public string Guid
        {
            get { return guid; }
            set { guid = value; }
        }


        string fileName;
        [Column(200)]
        public string FileName
        {
            get { return fileName; }
            set { fileName = value; }
        }

        string contentType;
        /// <summary>
        /// image/jpeg к примеру
        /// </summary>
        [Column(100)]
        public string ContentType
        {
            get { return contentType; }
            set { contentType = value; }
        }
        byte[] content;
        [Column]
        public byte[] Content
        {
            get { return content; }
            set { content = value; }
        }

        public string Url
        {
            get
            {
                return "/files/" + this.guid;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="url">relative url for example /files/e2277865-4aaf-479f-b5e1-02a37546d0cd</param>
        /// <returns></returns>
        public static WebFile GetForURL(string url)
        {
            if (string.IsNullOrEmpty(url)) return null;
            return WebFile.FindFirst(Expression.Eq("Guid", url.Replace("/files/", "")));
        }
    }
}
