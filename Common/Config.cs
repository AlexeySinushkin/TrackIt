using System;
using System.Collections.Generic;
using System.Text;
using System.Configuration;
using System.ComponentModel;

namespace Common
{
    [Serializable]
    public class Config : ConfigurationSection, INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        public enum OSTypes { Windows, Unix };
        public static OSTypes OSType
        {
            get
            {
                if (Type.GetType("Mono.Runtime") == null) return OSTypes.Windows;
                return OSTypes.Unix;
            }
        }


        static Configuration conf;
        static Config config;

        public static Config GetConfig()
        {
            if (config == null)
            {
                if (conf.Sections["ProjectConfig"] == null)
                {
                    conf.Sections.Add("ProjectConfig", new Config());
                    conf.Save(ConfigurationSaveMode.Modified);
                }
                config = conf.Sections["ProjectConfig"] as Config;
                config.PropertyChanged += new PropertyChangedEventHandler(config.AppConfiguration_PropertyChanged);
            }
            return config;
        }
        static Config()
        {
            if (System.Web.HttpContext.Current != null)
            {
                ExeConfigurationFileMap fm = new ExeConfigurationFileMap();
                fm.ExeConfigFilename=System.Web.HttpContext.Current.Server.MapPath("~/Web.config");
                conf = ConfigurationManager.OpenMappedExeConfiguration(fm,ConfigurationUserLevel.None);
            }
            else
            {
                conf = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
            }
        }
        private Config()
        {

        }
        public void Save(ConfigurationSaveMode mode)
        {
            if (conf != null)
            {
                conf.Save(mode);
            }
        }


        [ConfigurationProperty("MapScriptURL")]//, DefaultValue="/scripts/maps.js")]
        public string MapScriptURL
        {
            get { return (string)this["MapScriptURL"]; }
            set { this["MapScriptURL"] = value; }
        }

        [ConfigurationProperty("GraphImagesDirectory")]
        public virtual string GraphImagesDirectory
        {
            get
            {
                if (this["GraphImagesDirectory"]==null || string.IsNullOrEmpty(this["GraphImagesDirectory"].ToString()))
                {
                    if (System.Web.HttpContext.Current != null)
                    {
                        string path = System.Web.HttpContext.Current.Server.MapPath("~/images/graph/");
                        this["GraphImagesDirectory"] = path;
                    }
                }
                return (string)this["GraphImagesDirectory"];
            }
            set { this["GraphImagesDirectory"] = value; }
        }

        [ConfigurationProperty("UploadingFilesDirectory")]
        public virtual string UploadingFilesDirectory
        {
            get
            {
                if (this["UploadingFilesDirectory"] == null || string.IsNullOrEmpty(this["UploadingFilesDirectory"].ToString()))
                {
                    if (System.Web.HttpContext.Current != null)
                    {
                        string path = System.Web.HttpContext.Current.Server.MapPath("~/files-in-upload/");
                        this["UploadingFilesDirectory"] = path;
                    }
                }
                return (string)this["UploadingFilesDirectory"];
            }
            set { this["UploadingFilesDirectory"] = value; }
        }
        /// <summary>
        /// Если расстояние между точками меньше этого значения
        /// значит считаем, что нет движения.
        /// </summary>
        [ConfigurationProperty("StandMeters", IsRequired = true, DefaultValue = "50")]
        public int StandMeters
        {
            get { return (int)this["StandMeters"]; }
            set { this["StandMeters"] = value; }
        }

        [ConfigurationProperty("SmtpHost")]
        public virtual string SmtpHost
        {
            get { return (string)this["SmtpHost"]; }
            set { this["SmtpHost"] = value; }
        }
        [ConfigurationProperty("SmtpPort")]
        public virtual int SmtpPort
        {
            get { return (int)this["SmtpPort"]; }
            set { this["SmtpPort"] = value; }
        }
        [ConfigurationProperty("SmtpLogin")]
        public virtual string SmtpLogin
        {
            get { return (string)this["SmtpLogin"]; }
            set { this["SmtpLogin"] = value; }
        }
        [ConfigurationProperty("SmtpPassword")]
        public virtual string SmtpPassword
        {
            get { return (string)this["SmtpPassword"]; }
            set { this["SmtpPassword"] = value; }
        }
        [ConfigurationProperty("SmtpFrom")]
        public virtual string SmtpFrom
        {
            get { return (string)this["SmtpFrom"]; }
            set { this["SmtpFrom"] = value; }
        }


        void AppConfiguration_PropertyChanged(object sender, PropertyChangedEventArgs e)
        {

        }


    }
}
