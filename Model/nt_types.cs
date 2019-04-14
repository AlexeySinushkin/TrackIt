using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    /// <summary>
    /// Типы объектов
    /// </summary>
    [Table("nt_types")]
    public class nt_types : modelObject<nt_types>
    {
        string text = String.Empty;
        /// <summary>
        /// Описание объекта.
        /// </summary>
        public string Text
        {
            get { return text; }
            set { text = value; }
        }

    }
}
