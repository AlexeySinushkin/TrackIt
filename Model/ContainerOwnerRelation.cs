using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    /// <summary>
    ///  онтейнер - нечто содержащее в себе один или более модемов
    /// может быть это прицеп, вагон или просто дорожна€ сумка.
    /// </summary>
    [Table("ContainerOwnerRelations")]
    public class ContainerOwnerRelation : modelObject<ContainerOwnerRelation>
    {


        int containerID;
        /// <summary>
        /// ID контейнера
        /// </summary>
        public int ContainerID
        {
            get { return containerID; }
            set { containerID = value; }
        }
        int ownerID;
        /// <summary>
        /// ID владельца
        /// </summary>
        [Column]
        public int OwnerID
        {
            get { return ownerID; }
            set { ownerID = value; }
        }
        int ownerType;
        /// <summary>
        /// ‘изическое или юридическое лицо
        /// </summary>
        [Column]
        public int OwnerType
        {
            get { return ownerType; }
            set { ownerType = value; }
        }



        /// <summary>
        /// 3 - контейнер модема
        /// </summary>
        //public override int ObjectType
        //{
        //    get
        //    {
        //        return 3;
        //    }
        //}
        /*
        public static ContainerOwnerRelation GetNew()
        {
            ContainerOwnerRelation c = new ContainerOwnerRelation();
            c.ID = -1;
            return c;
        }
         */
    }
}
