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
   Class wrapping a Panel that can be dragged around on the 
   browser surface
   --------------------------------------------------------------------------- */
if( !Gaia.Extensions )
  Gaia.Extensions = Class.create();

Gaia.Extensions.DraggablePanel = function(element, options){
  this.initializeDraggablePanel(element, options);
}

// Inheriting from Panel
Object.extend(Gaia.Extensions.DraggablePanel.prototype, Gaia.Panel.prototype);

// Custom parts
Object.extend(Gaia.Extensions.DraggablePanel.prototype, {
  initializeDraggablePanel: function(element, options){

    // Calling base class constructor
    this.initialize(element, options);

    if( this.options.draggable )
      this.draggable = new Draggable(this.element, { noDroppables: true } );
  },

  setDraggable: function(value){
    if( !value && this.draggable ) {
      this.draggable.destroy();
      delete this.draggable;
    }
    else if( value && !this.draggable ){
      this.draggable = new Draggable(this.element, { noDroppables: true } );
    }
  }
});

Gaia.Extensions.DraggablePanel.browserFinishedLoading = true;
