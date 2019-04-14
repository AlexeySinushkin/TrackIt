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





/* ------------------------------------------------------------------------------------------------
   Register control helpers
   "Static" methods and fields on class
   ------------------------------------------------------------------------------------------------ */

// Main namespace for ENTIRE library (JS parts)
if( !window.Gaia  )
  Gaia = Class.create();

Gaia.Control = Class.create();

Gaia.Control._itsRegisteredInvisibleControls = new Array();

Gaia.Control._itsRegisteredControls = new Array();
Gaia.Control._itsRegisteredControlsArray = new Array();
Gaia.Control._updateControl = null;

Gaia.Control.setUpdateControl = function(el, isCallback){
  Gaia.Control._updateControl = el;
  if( el ){
    Element.hide(el);
  }
}

Gaia.Control.registerControl = function(control){
  if( Gaia.Control._itsRegisteredControls[control.element.id] ){
    // Existing control wrapping element, existing control must be destroyed...!!
    Gaia.Control._itsRegisteredControls[control.element.id].destroy();
  }
  Gaia.Control._itsRegisteredControls[control.element.id] = control;
  Gaia.Control._itsRegisteredControlsArray.push(control);
  return control;
}

Gaia.Control.destroyAllContaining = function(inId, except){
  var arr = new Array();
  Gaia.Control._itsRegisteredControlsArray.each(function(idx){
    if(idx.element.id != except && idx.element.id.indexOf(inId) != -1 )
      arr.push(idx);
  });
  arr.each(function(idx){
    idx.destroy();
  });
}

$G = function(control){
  return Gaia.Control._itsRegisteredControls[control];
}

$FC = function(field){
  if($(field))
    return $(field);
  var input = document.createElement('input');
  input.type = 'hidden';
  input.name = field;
  input.id = field;
  document.getElementsByTagName('form')[0].appendChild(input);
  return input;
}

$FChange = function(field, unchangedTo, value){
  var el = $FC(field);
  el.value = el.value.substr(0, unchangedTo) + value;
}

Gaia.Control._defaultUrl = null;

Gaia.Control._version = '1.0';

Gaia.Control._activeRequest = false;
Gaia.Control._activeRequests = new Array();

Gaia.Control._createNewRequestImplementation = function(controlToCallFor, methodAfter, evt, extraParams, url, evalScripts){
  // "Locking" to make sure there can be only ONE at the same time...
  Gaia.Control._activeRequest = true;
  if( Gaia.Control._updateControl )
    Element.show(Gaia.Control._updateControl);

  // Creating options for Ajax.Request
  var evalScriptsPar = true;
  if( evalScripts != null )
    evalScriptsPar = evalScripts;
  var opt = {
    method: 'post',
    postBody: 'GaiaCallback=true',
    onSuccess: function(t){
      if( methodAfter ){
        if( Gaia.Control._updateControl )
          Element.hide(Gaia.Control._updateControl);
        methodAfter(t);
      }
      Gaia.Control._activeRequests.splice(0,1);
      Gaia.Control._activeRequest = false;
    },
    onFailure: function(err){
      if( confirm('Error from server: ' + err.status + ', \''+err.statusText+'\', Ajax Engine shutdown for security reasons, refresh page to enable application again...\nDo you wish to see the debug results?') ){
        var dbg = document.createElement('iframe');
        dbg.width = '100%';
        dbg.height = '100%';
        dbg.style.position = 'absolute';
        dbg.style.left = '0px';
        dbg.style.top = '0px';
        dbg.style.zIndex = 10000;
        document.body.appendChild(dbg);
        dbg.contentWindow.document.open();
        dbg.contentWindow.document.write(err.responseText);
        dbg.contentWindow.document.close();
      }
    },
    evalScripts: false
  };
  if( $('__GAIA_FILES') ){
    opt.postBody += '&__GAIA_FILES=' + encodeURIComponent($F('__GAIA_FILES'));
  }
  if( $('__EVENTVALIDATION') ){
    opt.postBody += '&__EVENTVALIDATION=' + encodeURIComponent($F('__EVENTVALIDATION'));
  }
  if( $('__VIEWSTATE') ){
    opt.postBody += '&__VIEWSTATE=' + encodeURIComponent($F('__VIEWSTATE'));
  }
  if( $('__VIEWSTATEENCRYPTED') ){
    opt.postBody += '&__VIEWSTATEENCRYPTED=' + encodeURIComponent($F('__VIEWSTATEENCRYPTED'));
  }
  if( extraParams ){
    opt.postBody += '&gaiaParams='+encodeURIComponent(extraParams);
  }

  // Serializing all Controls to the post body of the request
  Gaia.Control._itsRegisteredControlsArray.each(function(ctrl){

    // The "this" control should ALWAYS be serialized
    if( ctrl == this )
      opt.postBody += ctrl._getElementPostValueEvent(evt);

    // Other controls MIGHT be serialized, but not nessecarely!
    else
      opt.postBody += ctrl._getElementPostValue();
  }.bind(controlToCallFor));

  // Initiating our request
  new Ajax.Request((url || (controlToCallFor ? controlToCallFor.options.url : null) || Gaia.Control._defaultUrl), opt);
}

Gaia.Control._dispatchNextRequest = function(request){
  if( Gaia.Control._activeRequest ) {
    // Ongoing request, must wait for it to finish, else viewstate and everything else goes bananas...!!
    setTimeout(function(){
      Gaia.Control._dispatchNextRequest(request)
    }, 50);
  } else {
    Gaia.Control._createNewRequestImplementation(request.control, request.method, request.evtIn, request.xtraParams, request.urlToCall, request.evaluate);
  }
}

Gaia.Control._createNewRequest = function(controlToCallFor, methodAfter, evt, extraParams, url, evalScripts){
  var retVal = {
    control: controlToCallFor, 
    method: methodAfter, 
    evtIn: evt, 
    xtraParams: extraParams, 
    urlToCall: url, 
    evaluate: evalScripts
  };
  Gaia.Control._activeRequests.push(retVal);
  Gaia.Control._dispatchNextRequest(retVal);
  return retVal;
}

Gaia.Control.returnValue = null;

Gaia.Control.callPageMethod = function(method, params, onFinished){
  var parsedParams = method+',PageMethod';
  if( params ){
    params.each(function(param){
      var idxParam = param;
      if( typeof param == 'string' ){
        while( idxParam.indexOf(',') != -1 ){
          idxParam = idxParam.replace(',', '|$|');
        }
      }
      parsedParams += ',' + idxParam;
    });
  }
  Gaia.Control._createNewRequest(
    null, 
    function(t){
      Gaia.Control.evalServerCallback('Gaia.Control.returnValue = ' + t.responseText);
      if( onFinished )
        onFinished(Gaia.Control.returnValue);
    },
    null,
    parsedParams,
    null,
    false);
}

Gaia.Control.callControlMethod = function(method, params, onFinished, passId){
  var parsedParams = method+',ControlMethod,' + (passId || this.element.id);
  if( params ){
    params.each(function(param){
      var idxParam = param;
      if( typeof param == 'string' ){
        while( idxParam.indexOf(',') != -1 ){
          idxParam = idxParam.replace(',', '|$|');
        }
      }
      parsedParams += ',' + idxParam;
    });
  }
  Gaia.Control._createNewRequest(
    null, 
    function(t){
      Gaia.Control.evalServerCallback('Gaia.Control.returnValue = ' + t.responseText);
      if( onFinished )
        onFinished(Gaia.Control.returnValue);
    },
    null,
    parsedParams,
    null,
    false);
}


Gaia.Control.currentIdx = 0;
Gaia.Control.lastLoadedScript = null;


Gaia.Control.evalServerCallback = function(script){

  // Set the javascript files to wait for to ZERO
  // When we load a JavaScript files this one is incremented by on, when that JavaScript file
  // is finished loading typeof typeToWaitFor != 'undefined' the Gaia.javaScriptFilesToWaitFor is decremented
  // When it reaches ZERO execution will pass to NEXT part of the script...!!
  //(parts are separated by ";;;"...)
  Gaia.javaScriptFilesToWaitFor = 0;
  Gaia.Control.lastLoadedScript = script.split(';;;;;');
  Gaia.Control.currentIdx = 0;
  return Gaia.Control._executeScript(true);
}

Gaia.Control._executeScript = function(shouldExecute){
  var retVal = null;
  if( Gaia.Control.currentIdx < Gaia.Control.lastLoadedScript.length ) {
    if( shouldExecute ) {
      retVal = eval(Gaia.Control.lastLoadedScript[Gaia.Control.currentIdx]);
      // Then we need to call our NEXT JavaScript part
      // This time we set the "execute" to false, this makes sure we get into our 
      // "wait for JavaScript files to load" logic before we move on
      setTimeout('Gaia.Control._executeScript(false);', 100);
    } else {
      // Checking to see if we need to wait for more JavaScript files...!!
      if( Gaia.javaScriptFilesToWaitFor == 0 ){
        // Running NEXT script...!!
        // No more files to wait for...
        Gaia.Control.currentIdx += 1;
        Gaia.Control._executeScript(true);
      } else {
        // We've got more files to load
        // Try again in 1/10 of a second
        setTimeout('Gaia.Control._executeScript(false);', 100);
      }
    }
  }
  return retVal;
}








/* ---------------------------------------------------------------------------
   Common class for all Controls, basically wraps the Gaia.Control class
   --------------------------------------------------------------------------- */
Gaia.Control.prototype = {
  // This one should have been "overridet" in extended classes and that method should call "baseInitializeControl" instead!
  initialize: Prototype.emptyFunction,

  // "Constructor" for object
  baseInitializeControl: function(element){
    this.element = $(element);
    if( !this.element )
      this.element = element; // IN-Visible controls....
    this.options = Object.extend({
      url: Gaia.Control._defaultUrl
    }, arguments[1] || {});
  },

  // Shows or hides the wrapped element
  setVisible: function(value){
    value ? Element.show(this.element) : Element.hide(this.element);
    return this;
  },
  
  setFocus: function(){
    this.element.focus();
    return this;
  },
    
  destroy: function(){
    this._destroyImpl();
  },

  _destroyImpl: function(){
    // Stopping event observers
    if( this._subscribedEvents ){
      this._subscribedEvents.each(function(evt){
        Element.stopObserving(this.element, evt.name, evt.evt);
      }.bind(this));
    }

    // Destroying control and removing control references
    var toDestroy;
    var idx = 0;
    Gaia.Control._itsRegisteredControlsArray.each(function(ctrl){
      if( ctrl.element.id == this.element.id ){
        toDestroy = ctrl;
        throw $break;
      }
      idx += 1;
    }.bind(this));
    if( toDestroy ){
      Gaia.Control._itsRegisteredControlsArray.splice(idx, 1);
      delete Gaia.Control._itsRegisteredControls[this.element.id];
    }
  },
  
  _observeImpl: function(evtName, bubbleUp){
    if( this._subscribedEvents == null ){
      this._subscribedEvents = new Array();
    }
    if( !this._subscribedEvents[evtName] ){
      var _onEventEvent = this._onEvent.bindAsEventListener(this, evtName, bubbleUp);
      Element.observe(this.element, evtName, _onEventEvent);
      this._subscribedEvents.push({name:evtName, evt:_onEventEvent});
    }
  },

  // Use to observe specific events and call server when they occur
  // If you observe an event through this method the server WILL be called when that event occurs
  // and if there's a match on the server for such an event that event will be called
  observe: function(evtName, bubbleUp){
    // Making sure we don't DOUBLE subscribe...
    this._observeImpl(evtName, (bubbleUp ? true : false));
    return this;
  },

  _getElementPostValue: function(){
    throw "Abstract _getElementPostValue not overridet";
  },

  getCallbackName: function(){
    if( this.element.name && this.element.name.length > 0 )
      return this.element.name;
    var retVal = this.element.id;
    while( retVal.indexOf('_') != -1 ){
      retVal = retVal.replace('_', '$');
    }
    return retVal;
  },

  _getElementPostValueEvent: function(){
    throw "Abstract _getElementPostValueEvent not overridet";
  },

  // Private implementation of the observe event handler
  // This is the one doing the actually "ajax magic" and calls our server
  _onEventImpl: function(evt, evtName){

    // Checking to see if we should "validate" page (RequiredFieldValidator etc...)
    if( typeof(WebForm_OnSubmit) == 'function' ){
      if(WebForm_OnSubmit() != true)
        return;
    }

    // Code to circumvent flaw in Sharepoint 2007 
    if ( window['_spFormOnSubmitCalled'] != null && window['_spFormOnSubmitCalled'] != 'undefined' ) {
      _spFormOnSubmitCalled = false;
    }

    // Making sure our element is NOT enabled during the request!
    if( Gaia.Control._updateControl == null )
      this.setEnabled(false);
    this._updaterControl = Gaia.Control._updateControl;

    // Creating actually Ajax.Request
    Gaia.Control._createNewRequest(this, this._afterEvent.bind(this), evt);
  },

  _shouldRunAjaxRequest: function(){
    return true;
  },

  _onEvent: function(evt, evtName, bubbleUp){
     // modified 04-09-2007 by Matthew M.
     // -- added updated alert message if this section errors out
     // suggestion - all events should have a 'fall-through' to normal web function (non-ajax) if 
     // this routine fails.

     // Raising event
    try {
      this._onEventImpl(evt, evtName);
    } catch(err) {
      // More informative error report
      alert("Gaia Error: _onEvent/Gaia - Control.js fire\n\nError Message:\n\n" + err);
    }

    // Preventing event to bubble upwards!
    if( !bubbleUp )
      Event.stop(evt);
  },

  _destroyAllChildren: function(el){
    var g = $G(el.id);
    // For speed and to avoid stack overrun we use FOR here and NOT .each !!
    for( var idx = 0; idx < el.childNodes.length; idx++ ){
      this._destroyAllChildren(el.childNodes[idx]);
    }
    if( g )
      g.destroy();
  },

  // Called by framework when server side event handler returns
  _afterEvent: function(t){

    // We MUST set this value FIRST since some of the properties set in the callback might be to DISABLE the "this" control...!
    // First checking to see if the "this" haven't been deleted by the response script though...
    if( $(this.element.id) ){
      if( this._updaterControl == null )
        this.setEnabled(true);
    }

    // Evaluating the response from the server...!
    Gaia.Control.evalServerCallback(t.responseText);
  }
};

Gaia.Control.browserFinishedLoading = true;
