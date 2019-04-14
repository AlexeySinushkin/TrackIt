using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    /// <summary>
    /// ���� ��������
    /// </summary>
    [Table("nt_types")]
    public class nt_types : modelObject<nt_types>
    {
        string text = String.Empty;
        /// <summary>
        /// �������� �������.
        /// </summary>
        public string Text
        {
            get { return text; }
            set { text = value; }
        }

    }
}
