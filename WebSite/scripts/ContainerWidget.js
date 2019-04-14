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
   Class basically wrapping the common functions of ContainerWidgets 
   (Window, AutoCompleter etc)
   --------------------------------------------------------------------------- */
Gaia.Container = function(){}

Gaia.Container.prototype = {

  forceAnUpdate: function(){
    // Destroying all CHILDREN controls
    this.destroyChildrenControls();
  },

  reInit: function(){
    this.element = $(this.element.id);
  },

  destroyChildrenControls: function(){
    // First we need to destroy all CHILD (Gaia) widgets...!!
    try{
      $A(this.element.childNodes).each(function(el){
        this._destroyAllChildren(el);
      }.bind(this));
    } catch(err){
      alert(err);
    }
  },

  destroyContainer: function(elId){
    // Destroying all IN-Visible controls with in container (e.g. Timer is IN-Visible)
    var arrayToBeRemoved = new Array();
    Gaia.Control._itsRegisteredInvisibleControls.each(function(idx){
      if( idx.element.id.indexOf(elId) == 0 ){
        arrayToBeRemoved.push(idx);
      }
    }.bind(this));
    arrayToBeRemoved.each(function(idx){
      var idxNo = 0;
      Gaia.Control._itsRegisteredInvisibleControls.each(function(idxInner){
        if( idxInner.element.id == idx.element.id )
          throw $break;
        idxNo += 1;
      });
      Gaia.Control._itsRegisteredInvisibleControls.splice(idxNo, 1)[0];
      idx.destroy();
    });
  }
};

Gaia.Container.browserFinishedLoading = true;
