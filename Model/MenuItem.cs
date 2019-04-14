using System;
using System.Collections.Generic;
using System.Text;
using Common.Attributes;

namespace TrackIt.Model
{
    [Table("MenuItems")]
    public class MenuItem:localizableObject<MenuItem>
    {
        string text;
        [Localizable]
        public string Text
        {
            get { return text; }
            set {text = value; }
        }

    }
}
