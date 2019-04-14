using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    /// <summary>
    /// ��������� - ����� ���������� � ���� ���� ��� ����� �������
    /// ����� ���� ��� ������, ����� ��� ������ �������� �����.
    /// </summary>
    [Table("ContainerOwnerRelations")]
    public class ContainerOwnerRelation : modelObject<ContainerOwnerRelation>
    {


        int containerID;
        /// <summary>
        /// ID ����������
        /// </summary>
        public int ContainerID
        {
            get { return containerID; }
            set { containerID = value; }
        }
        int ownerID;
        /// <summary>
        /// ID ���������
        /// </summary>
        [Column]
        public int OwnerID
        {
            get { return ownerID; }
            set { ownerID = value; }
        }
        int ownerType;
        /// <summary>
        /// ���������� ��� ����������� ����
        /// </summary>
        [Column]
        public int OwnerType
        {
            get { return ownerType; }
            set { ownerType = value; }
        }



        /// <summary>
        /// 3 - ��������� ������
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
