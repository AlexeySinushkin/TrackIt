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



/* --------------------------------------------------------------------------------------------------------
   Helper class to wrap the AutoCompleter and add up a little bit of "custom action" to it
   -------------------------------------------------------------------------------------------------------- */
Ajax.GaiaAutocompleter = Class.create();

Ajax.GaiaAutocompleter.prototype = Object.extend(new Autocompleter.Base(), Object.extend(new Gaia.Skinnable(), {
  initialize: function(element, update, options, parentWebControl) {
    this.baseInitialize(element, update, options);
    this.options.asynchronous  = true;
    this.parentWebControl      = parentWebControl;
    this.options.afterUpdateElement = this._onAfterUpdateElement.bind(this);

    this.options.onHide = function(element, update){
      Element.setOpacity(update.id, 0);
      Element.hide(update);
      $A(this.update.childNodes).each(function(el){
        el.parentNode.removeChild(el);
      });
      delete this.actualContentCell;
    }.bind(this);

    this.options.onShow = function(element, update){

      var tblSkin = this.createSkinTable();
      this.update.appendChild(tblSkin.topTbl);
      this.update.appendChild(tblSkin.midTbl);
      this.update.appendChild(tblSkin.bottomTbl);

      var hasClassName = this.options.className != null && this.options.className != '';
      if( !hasClassName ){
        update.style.width = '250px';
      }

      if(!update.style.position || update.style.position=='absolute') {
        update.style.position = 'absolute';
        Position.clone(element, update, {
          setHeight: false, 
          offsetTop: element.offsetHeight,
          setWidth: false // THOMAS PATCH to let user decide width of element himself...!!
        });
      }
      Element.setOpacity(update.id, 1.0);
      Element.show(update);
    }.bind(this);
  },

  getUpdatedChoices: function() {
    this.parentWebControl._getChoices(this.onFinishedFetching.bind(this));
  },

  onFinishedFetching: function(result) {
    this.updateChoices(result);
  },

  updateChoices: function(choices) {
    if(!this.changed && this.hasFocus) {
      if( !this.actualContentCell ){
        this.options.onShow(this.element, this.update);
      }
      this.actualContentCell.innerHTML = choices;
      Element.cleanWhitespace(this.actualContentCell);
      if( choices.length > 0 ){
        Element.cleanWhitespace(this.actualContentCell.down());
      }

      if(this.actualContentCell.firstChild && this.actualContentCell.down().childNodes) {
        this.entryCount = 
          this.actualContentCell.down().childNodes.length;
        for (var i = 0; i < this.entryCount; i++) {
          var entry = this.getEntry(i);
          entry.autocompleteIndex = i;
          this.addObservers(entry);
        }
      } else { 
        this.entryCount = 0;
      }
      this.stopIndicator();
      this.index = 0;
      
      if(this.entryCount==1 && this.options.autoSelect) {
        this.selectEntry();
        this.hide();
      } else {
        this.render();
      }
    }
  },

  getEntry: function(index) {
    return this.actualContentCell.firstChild.childNodes[index];
  },
      
  setFocus: function(){
    this.element.focus();
    return this;
  },
  
  _onAfterUpdateElement: function(a,b){
    this.parentWebControl._selectionChanged(b.id);
  }
}));







/* ---------------------------------------------------------------------------
   Class basically wrapping the ASP.TextBox WebControl class
   --------------------------------------------------------------------------- */
Gaia.AutoCompleter = function(element, options){
  this.initializeAutoCompleter(element, options);
}

Gaia.AutoCompleter.prototype = Object.extend(new Gaia.TextBox(),{

  // "Constructor"
  initializeAutoCompleter: function(element, options){
    // Calling base class constructor
    this.initialize(element, options);
    
    if( this.options.dropDownButton ) {
      this.options.dropDownButton = $(this.options.dropDownButton);
      Element.observe(this.options.dropDownButton, 'click', this.onShowAll.bind(this));
    }

    // Creating our ScriptAculous AutoCompleter object...!
    this.autoCompleter = new Ajax.GaiaAutocompleter(this.element.id, this.options.renderingDiv, {
      frequency: this.options.frequency,
      minChars:this.options.minimumPrefixLength,
      className:this.options.className
    }, this);
  },

  onShowAll: function(){
    this.element.focus();
    this.autoCompleter.hasFocus = true;
    this.autoCompleter.getUpdatedChoices();
  },

  _getChoices: function(afterCallback){
    Gaia.Control.callControlMethod.bind(this)('GetAutoCompleteList', [this.autoCompleter.getToken()], function(retVal){
      afterCallback(retVal);
    }.bind(this));
  },

  _selectionChanged: function(id){
    Gaia.Control.callControlMethod.bind(this)('SelectionChangedMethod', [id], null);
  },

  _getElementPostValue: function(){
    return '&' + this.getCallbackName() + '=' + encodeURIComponent($F(this.element.id));
  },

  _getElementPostValueEvent: function(){
    return '&' + this.getCallbackName() + '=' + encodeURIComponent($F(this.element.id)) + '&__EVENTTARGET=' + this.getCallbackName();
  }
});

Gaia.AutoCompleter.browserFinishedLoading = true;
