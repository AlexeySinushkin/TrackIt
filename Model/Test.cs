using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    /// <summary>
    /// ���������� ����.
    /// </summary>
    [Table("Test")]
    public class Test : modelObject<Test>
    {
        #region Properties
        string text = "��� ��";
        [Column]
        public string Text
        {
            get { return text; }
            set { text = value; }
        }

        #endregion


    }
}
