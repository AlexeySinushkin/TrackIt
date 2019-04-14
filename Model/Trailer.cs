using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("Containers", Where = "ContainerTypeID = 1")]
    public class Trailer:modelObject<Trailer>, ITrackContainer
    {

        IUser owner;
        [Any(typeof(int), MetaType=typeof(int), 
            TypeColumn="OwnerType", IdColumn="OwnerID", Cascade=Castle.ActiveRecord.CascadeEnum.SaveUpdate)]
        [MetaValue("1", typeof(Company))]
        [MetaValue("2", typeof (WebUser))]
        public IUser Owner
        {
            get
            {
                return owner;
            }
            set
            {
                owner=value;
            }
        }

        string registrationNumber;
        [Column]
        public string RegistrationNumber
        {
            get { return registrationNumber; }
            set { registrationNumber = value; }
        }

        string info;
        [Column]
        public string Info
        {
            get { return info; }
            set { info = value; }
        }

        public string Name
        {
            get
            {
                return registrationNumber;
            }
        }
        public override string ToString()
        {
            return Name;
        }
        public string About
        {
            get
            {
                return info;
            }
        }


        public int ITrackContainerType
        {
            get { return 1; }
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
    }
}
