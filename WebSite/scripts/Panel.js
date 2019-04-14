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
   Class basically wrapping the ASP.Panel WebControl class
   --------------------------------------------------------------------------- */
Gaia.Panel = function(element, options){
  this.initialize(element, options);
}

// Inheriting from WebControl
Object.extend(Gaia.Panel.prototype, Gaia.WebControl.prototype);

// Inheriting from Container
Object.extend(Gaia.Panel.prototype, Gaia.Container.prototype);

// Adding Custom parts
Object.extend(Gaia.Panel.prototype, {
  // "Constructor"
  initialize: function(element, options){
    // Calling base class constructor
    this.baseInitializeWebControl(element, options);
  },
  
  // Sets the tabindex of the button
  setTabIndex: function(value){
    this.element.tabIndex = value;
    return this;
  },

  setVisible: function(value){
    value ? Element.show(this.element) : Element.hide(this.element);
    if( value != true ){

      // Making sure control and child controls is destroyed...
      this.destroy();
    }
    return this;
  },

  destroy: function(){
    // Destroying all CHILDREN controls
    this.destroyChildrenControls();

    // Dispatching to container DTOR
    this.destroyContainer(this.element.id);

    // Calling Object.destroy implementation...
    this._destroyImpl();
  },

  _getElementPostValue: function(){
    return '';
  }
});

Gaia.Panel.browserFinishedLoading = true;
