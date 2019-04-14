using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    /// <summary>
    /// Контейнер - нечто содержащее в себе один или более модемов
    /// может быть это прицеп, вагон или просто дорожная сумка.
    /// </summary>
    [Table("Containers")]
    public class Container : activableObject<Container>, ITrackContainer
    {
        IUser owner;
        [Any(typeof(int), MetaType = typeof(int),
            TypeColumn = "OwnerType", IdColumn = "OwnerID", Cascade = Castle.ActiveRecord.CascadeEnum.SaveUpdate)]
        [MetaValue("1", typeof(Company))]
        [MetaValue("2", typeof(WebUser))]
        public IUser Owner
        {
            get
            {
                return owner;
            }
            set
            {
                owner = value;
            }
        }

        ContainerType containerType;
        [ReferenceTo("ContainerTypeID")]
        public ContainerType ContainerType
        {
            get { return containerType; }
            set { containerType = value; }
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


        int length;
        [Column]
        public int Length
        {
            get { return length; }
            set { length = value; }
        }

        int width;
        [Column]
        public int Width
        {
            get { return width; }
            set { width = value; }
        }

        int height;
        [Column]
        public int Height
        {
            get { return height; }
            set { height = value; }
        }



        #region ITrackContainer Members


        public string Name
        {
            get { return RegistrationNumber; }
            set { registrationNumber = value; }
        }

        public string About
        {
            get { return info; }
            set { info = value; }
        }

        public int ITrackContainerType
        {
            get {return containerType.ID; }
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
        #endregion
    }
}
