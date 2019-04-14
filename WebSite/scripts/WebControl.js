// Gaia Ajax Widgets Copyright (C) 2007  Frost Innovation AS. details at http://ajaxwidgets.com/
/* 
 * Gaia Ajax Widgets, an Ajax Widget Library
 * Copyright (C) 2007  Frost Innovation AS
 * All rights reserved.
 * This program is distributed under either GPL version 2 
 * as published by the Free Software Foundation or the
 * Gaia Commercial License version 1 as published by
 * Frost Innovation AS
 * read the details at http://ajaxwidgets.com/
 */




/* ---------------------------------------------------------------------------
   Common class for all WebControls, basically wraps the WebControl class
   --------------------------------------------------------------------------- */

// Creating our class
Gaia.WebControl = Class.create();

// Inheriting from Gaia.Control
Object.extend(Gaia.WebControl.prototype, Gaia.Control.prototype);

// Adding custom parts
Object.extend(Gaia.WebControl.prototype, {
  // This one should have been "overridet" in extended classes and that method should call "baseInitializeWebControl" instead!
  initialize: Prototype.emptyFunction,

  // "Constructor" for object
  baseInitializeWebControl: function(element, options){
    this.baseInitializeControl(element, options);
  },

  // Property setters/getters
  setAccessKey: function(value){
    this.element.accessKey = value;
    return this;
  },

  setStyle: function(styles){
    var style = '';
    for( var idx in styles){
      style += idx.camelize() + ': ' + styles[idx];
    }
    this.element.style = style;
    return this;
  },

  // Returns an alpha value that can be between 0.0 and 1.0 and a color value that can either be a named color or a value
  // in format #xxxxxx or #xxx
  _parseARGB: function(value){
    var isARGB = false;
    if( value.length == 8 ){
      isARGB = true;
      value.split('').each(function(ch){
        switch(ch){
          case '0':
          case '1':
          case '2':
          case '3':
          case '4':
          case '5':
          case '6':
          case '7':
          case '8':
          case '9':
          case 'a':
          case 'b':
          case 'c':
          case 'd':
          case 'e':
          case 'f':
            break;
          default:
            isARGB = false;
            throw $break;
        }
      });
    }
    if( isARGB == true ){
      return {color: '#' + value.substr(2), alpha: parseInt(value.substr(0,2), 16) / 255};
    } else {
      return {color: value, alpha: 1.0};
    }
  },

  // Sets background color, can take named color, color hexa value (6 or 3 digits) or 8 diget alpha and color value
  // Format is #AARRGGBB (AA=alpha, RR=red, GG=green, BB=blue)
  setBackColor: function(value){
    var colorParts = this._parseARGB(value);
    Element.setStyle(this.element.id, {backgroundColor: colorParts.color});
    Element.setOpacity(this.element.id, colorParts.alpha);
    return this;
  },

  // Sets border color, can take named color, color hexa value (6 or 3 digits) or 8 diget alpha and color value
  // Format is #AARRGGBB (AA=alpha, RR=red, GG=green, BB=blue)
  setBorderColor: function(value){
    var colorParts = this._parseARGB(value);
    Element.setStyle(this.element.id, {borderColor: colorParts.color});
    return this;
  },

  // Sets the style of the border  ('Dottet', 'Ridged' or so on)
  setBorderStyle: function(value){
    Element.setStyle(this.element.id, {borderStyle: value});
    return this;
  },

  // Sets the width of the border
  setBorderWidth: function(value){
    Element.setStyle(this.element.id, {borderWidth: value});
    return this;
  },

  // Sets the CSS class, note it REMOVES ALL other css classes
  setCssClass: function(value){
    this.element.className = value;
    return this;
  },

  // Enables or disables the element (true/false)
  setEnabled: function(value){
    value ? Form.Element.enable(this.element.id) : Form.Element.disable(this.element.id);
    return this;
  },

  // Sets the font of the element to either bold(true) or normal(false)
  setFontBold: function(value){
    Element.setStyle(this.element.id, {fontWeight: (value?'bold':'normal')});
    return this;
  },

  // Sets the font of the element to either italic(true) or normal(false)
  setFontItalic: function(value){
    Element.setStyle(this.element.id, {fontStyle: (value?'italic':'normal')});
    return this;
  },

  // Sets the font family names to use for the element
  setFontNames: function(value){
    if( value && value != '' )
      Element.setStyle(this.element.id, {fontFamily: value});
    return this;
  },

  // Sets the font of the element to either overline style(true) or normal(false)
  setFontOverline: function(value){
    Element.setStyle(this.element.id, {textDecoration: (value?'overline':'none')});
    return this;
  },

  // Sets the font size of the element
  setFontSize: function(value){
    Element.setStyle(this.element.id, {fontSize: value});
    return this;
  },

  // Sets the font of the element to either strikeout(true) or normal(false)
  setFontStrikeout: function(value){
    Element.setStyle(this.element.id, {textDecoration: (value?'line-through':'normal')});
    return this;
  },

  // Sets the font of the element to either underline(true) or normal(false)
  setFontUnderline: function(value){
    Element.setStyle(this.element.id, {textDecoration: (value?'underline':'normal')});
    return this;
  },

  // Sets foreground (font) color, can take named color, color hexa value (6 or 3 digits) or 8 diget alpha and color value
  // Format is #AARRGGBB (AA=alpha, RR=red, GG=green, BB=blue)
  setForeColor: function(value){
    var colorParts = this._parseARGB(value);
    Element.setStyle(this.element.id, {color: colorParts.color});
    return this;
  },

  // Sets the height of the element
  setHeight: function(value){
    Element.setStyle(this.element.id, {height: value});
    return this;
  },

  // Sets the tooltip of the element (title element)
  setToolTip: function(value){
    this.element.title = value;
    return this;
  },

  // Sets the width of the element
  setWidth: function(value){
    Element.setStyle(this.element.id, {width: value});
    return this;
  }
});

Gaia.WebControl.browserFinishedLoading = true;
