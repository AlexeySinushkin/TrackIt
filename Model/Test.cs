using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    /// <summary>
    /// Физическое лицо.
    /// </summary>
    [Table("Test")]
    public class Test : modelObject<Test>
    {
        #region Properties
        string text = "Что то";
        [Column]
        public string Text
        {
            get { return text; }
            set { text = value; }
        }

        #endregion


    }
}
