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
   Class basically wrapping the ASP.TextBox WebControl class
   --------------------------------------------------------------------------- */
Gaia.TextBox = function(element, options){
  this.initialize(element, options);
}

// Inheriting from WebControl
Object.extend(Gaia.TextBox.prototype, Gaia.WebControl.prototype);

// Adding custom parts
Object.extend(Gaia.TextBox.prototype, {
  // "Constructor"
  initialize: function(element, options){
    // Calling base class constructor
    this.baseInitializeWebControl(element, options);
  },

  // Shows or hides the wrapped element
  // Overridden from Gaia.Control
  setVisible: function(value){
    var containerEl = $('__' + this.element.id + '__');
    $A(containerEl.childNodes).each(function(el){
      value ? Element.show(el) : Element.hide(el);
    });
    return this;
  },

  // Sets text of TextBox
  setText: function(value){
    this.element.value = value;
    return this;
  },
  
  // Sets the tabindex of the control
  setTabIndex: function(value){
    this.element.tabIndex = value;
    return this;
  },

  setAutoCallBack: function(value){
    return this;
  },

  setTextAlign: function(value){
    // Finding element to move
    var containerEl = $('__' + this.element.id + '__');
    var elToMove = null;
    $A(containerEl.childNodes).each(function(el){
      if(el.id != this.element.id)
        elToMove = el;
    }.bind(this));

    // Doing the "moving"
    containerEl.removeChild(elToMove);
    if( value == 'Left' ){
      containerEl.insertBefore(elToMove, containerEl.firstChild);
    } else {
      containerEl.appendChild(elToMove);
    }
    return this;
  },

  _getElementPostValue: function(){
    return '&' + this.getCallbackName() + '=' + encodeURIComponent($F(this.element.id));
  },

  _getElementPostValueEvent: function(){
    return '&' + this.getCallbackName() + '=' + encodeURIComponent($F(this.element.id)) + '&__EVENTTARGET=' + this.getCallbackName();
  }
});

Gaia.TextBox.browserFinishedLoading = true;
