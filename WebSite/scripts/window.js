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
   Class basically wrapping the Gaia Ajax WebWidgets Panel class.
   --------------------------------------------------------------------------- */
Gaia.Window = function(element, options){
  this.initialize(element, options);
}

// To keep track of visible windows so that we now how to move windows around 
// when active window changes and so on...
Gaia.Window._visibleWindows = new Array();

// Inheriting from WebControl
Object.extend(Gaia.Window.prototype, Gaia.WebControl.prototype);

// Inheriting from Container
Object.extend(Gaia.Window.prototype, Gaia.Container.prototype);

// Custom parts
Object.extend(Gaia.Window.prototype, {
  // "Constructor"
  initialize: function(element, options){
    // Calling base class constructor
    this.baseInitializeWebControl(element, options);

    // Setting width and height, NOTE DO THIS FIRST to avoid flickering...
    this.options.width = this.options.width || 600;
    this.options.height = this.options.height || 400;

    // Setting initial width and height
    Position.absolutize(this.element);
    this.setWidth(this.options.width);
    this.setHeight(this.options.height);

    // Checking to see if we're about to CENTER the form, do EARLY to avoid flickering...
    if( this.options.center == true )
      this.center();
    else {
      if( this.options.left || this.options.top ){
        this.options.left = (this.options.left || 0);
        this.options.top = (this.options.top || 0);
        this.setLocation(this.options.left, this.options.top);
      }
    }

    // Checking to see if the window is closable with the escape key
    if( this.options.escape && this.options.closable ){
      this._onKeyDown = this._keyDown.bindAsEventListener(this);
      Element.observe(this.element, 'keydown', this._onKeyDown);
    }

    // Checking to see if window is initially visible
    this.setVisible(this.options.visible);

    // Making it movable
    if( this.options.draggable == true ){
      this.addDraggable();
    }

    this._onClick = this._click.bind(this);
    Element.observe(this.element, 'click', this._onClick);

    // Setting the minimizable properties
    if( this.options.minimizable ){
      this._onMinimizerClicked = this._minimizerClicked.bind(this);
      Element.observe($(this.element.id+'_MINIMIZER'), 'click', this._onMinimizerClicked);
    }

    // Setting the maximizable properties
    if( this.options.maximizable ){
      this._onMaximizerClicked = this._maximizerClicked.bind(this);
      Element.observe($(this.element.id+'_MAXIMIZER'), 'click', this._onMaximizerClicked);
      var caption = $(this.element.id+'_CAPTION');
      if( caption ){
        Element.observe(caption, 'dblclick', this._onMaximizerClicked);
      }
      Element.observe($(this.element.id+'_HANDLE'), 'dblclick', this._onMaximizerClicked);
    }

    // Checking to see if window is initially visible
    if( this.options.closable ){
      this._onCloseMethod = this._closeMethod.bind(this);
      Element.observe($(this.element.id+'_CLOSER'), 'click', this._onCloseMethod);
    }

    // Checking to see if window is resizable
    if( this.options.resizable == true ){
      this.addResizers();
    }
    this.element.style.visibility = this.options.visibility;
    return this;
  },
 
  setStyle: function(styles){
    return this;
  },

  setLeft: function(value){
    this.element.style.left = value;
    return this;
  },

  setTop: function(value){
    this.element.style.top = value;
    return this;
  },

  setCaption: function(value){
    $(this.element.id+'_CAPTION').innerHTML = value;
    return this;
  },

  setMinHeight: function(value){
    this.options.minHeight = value;
    return this;
  },

  setMinWidth: function(value){
    this.options.minWidth = value;
    return this;
  },

  setDraggable: function(value){
    if( !value ){
      if( this.draggable )
        this.draggable.destroy();
      if( this.draggable2 )
        this.draggable2.destroy();
    } else {
      this.addDraggable();
    }
    return this;
  },

  animateMove: function(x, y){
    new Effect.Move(this.element, {
      x: x,
      y: y,
      mode: 'absolute'});
    return this;
  },

  _maximizerClicked: function(){
    if( this.oldHeight ){
      this.element.style.height = this.oldHeight;
      this.element.style.width = this.oldWidth;
      delete this.oldHeight;
      delete this.oldWidth;
      Element.toggle($(this.element.id.substr(0,this.element.id.length-4)+'_CONTENT_TBL'));
    }

    var inner = $(this.element.id.substr(0,this.element.id.length-4));
    if( this.isMaximized ){
      // Restoring
      inner.setStyle({
        width: this.isMaximized.innerWidth,
        height: this.isMaximized.innerHeight
      });
      this.element.setStyle({
        width: this.isMaximized.width, 
        height: this.isMaximized.height,
        top:this.isMaximized.top,
        left:this.isMaximized.left
      });
      delete this.isMaximized;
      
      if ( this.options.resizable == true ){
        this.addResizers();
      }
   
      if (this.options.draggable == true){
        this.addDraggable();
      }
    } else {
      // Maximizing
      this.isMaximized = {
        width:this.element.style.width, 
        height:this.element.style.height, 
        innerWidth:inner.style.width, 
        innerHeight:inner.style.height,
        top: this.element.style.top,
        left: this.element.style.left};
      var pageSize = this.getPageSize();
      inner.setStyle({
        width: (pageSize.pageWidth - this.options.widthOfBorders) + 'px',
        height: (pageSize.pageHeight - this.options.heightOfBorders) + 'px'
      });
      this.element.setStyle({
        width: pageSize.pageWidth + 'px', 
        height: pageSize.pageHeight + 'px',
        top:'0px',
        left:'0px'
      });
      
      if ( this.options.resizable == true ){
        this.removeResizers();
      }
   
      if (this.options.draggable == true){
        this.removeDraggable();
      }
      
      this.restoreCaption();
    }
    
    if( this.options.resizedDefined ){
	  Gaia.Control.callControlMethod.bind(this)(
	    'ResizedMethod', 
	    [parseInt(this.element.style.width), parseInt(this.element.style.height), (this.isMaximized?true:false), (this.oldHeight?true:false)], 
	    function(retVal){
		  if( retVal == 'false' ){
		    this.element.style.width = this._oldWidth;
		    this.element.style.height = this._oldHeight;
		  }
	    }.bind(this), 
	    this.element.id.substr(0,this.element.id.length - 4));
    }
  },

  _minimizerClicked: function(){
    var inner = $(this.element.id.substr(0,this.element.id.length-4)+'_CONTENT_TBL');
    
    if( this.isMaximized )
        this._maximizerClicked();
        
    if( this.element.style.height == '0px' ) {
      this.element.style.height = this.oldHeight;
      this.element.style.width = this.oldWidth;
      delete this.oldHeight;
      delete this.oldWidth;
      this.restoreCaption();
    } else {
      this.oldHeight = this.element.style.height;
      this.oldWidth = this.element.style.width;
      this.element.style.height = '0px';
      this.element.style.width = '200px';
      this.shortenCaption();
    }
    Element.toggle(inner);
    
    if( this.options.resizedDefined ){
	  Gaia.Control.callControlMethod.bind(this)(
	    'ResizedMethod', 
	    [parseInt(this.element.style.width), parseInt(this.element.style.height), (this.isMaximized?true:false), (this.oldHeight?true:false)], 
	    function(retVal){
		  if( retVal == 'false' ){
		    this.element.style.width = this._oldWidth;
		    this.element.style.height = this._oldHeight;
		  }
	    }.bind(this), 
	    this.element.id.substr(0,this.element.id.length - 4));
    }
  },
  
  shortenCaption: function(){
    var captionElement = $(this.element.id+'_CAPTION');
    if( captionElement && captionElement.innerHTML.length >= 10 ) {
      this.fullCaption = captionElement.innerHTML;
      
      var tmpCaption = captionElement.innerHTML.stripTags();
      var firstSpaceIndex = tmpCaption.indexOf(' ');
      
      if( firstSpaceIndex > 2 && firstSpaceIndex <= 7 )
        captionElement.innerHTML = tmpCaption.substring(0, firstSpaceIndex) + '...';  
      else
        captionElement.innerHTML = tmpCaption.truncate(10);  
    }
  },
  
  restoreCaption: function(){
    if( this.fullCaption ) {
      $(this.element.id+'_CAPTION').innerHTML = this.fullCaption;
      delete this.fullCaption;
    }
  },

  _click: function(){
    // Checking to see if we need to flip with the zIndex'es
    if( this.isTopOne )
      return; // Short circuit, clicked already to become top one...
    this.bringWindowToFront();
  },

  bringWindowToFront: function(){
    var highestZ = this;
    Gaia.Window._visibleWindows.each(function(idxWnd){
      if( idxWnd.element.style.zIndex > highestZ.element.style.zIndex ){
        highestZ = idxWnd;
      }
      idxWnd.isTopOne = false;
    }.bind(this));
    if( highestZ == this )
      return;

    // We must move around the zIndex'es of the windows, we just flip them
    this.isTopOne = true;
    var thisOldZ = this.element.style.zIndex;
    this.element.style.zIndex = highestZ.element.style.zIndex;
    highestZ.element.style.zIndex = thisOldZ;
  },

  _keyDown: function(evt){
    if( evt.keyCode == Event.KEY_ESC ){
      this._closeMethod();
    }
  },

  _closeMethod: function(){
    if( !this._closingInProgress ){
      this._closingInProgress = true;
      Gaia.Control.callControlMethod.bind(this)('CloseMethod', [], function(retVal){
         // DO NOTHING, Server dispatches to setVisible method...!!
        delete this._closingInProgress;
        if( Gaia.Window._visibleWindows.length > 0 ){
          if( Gaia.Window._visibleWindows[Gaia.Window._visibleWindows.length-1].options.focusOnOpen )
            Gaia.Window._visibleWindows[Gaia.Window._visibleWindows.length-1].element.focus();
        }
      }.bind(this), this.element.id.substr(0,this.element.id.length - 4));
    }
  },

  setWidth: function(value){
    this.options.width = value;
    this.element.setStyle({
      width: (parseInt(this.options.width, 10)) + 'px'
    });
    var inner = $(this.element.id.substr(0,this.element.id.length-4));
    inner.setStyle({
      width: (parseInt(this.options.width, 10) - this.options.widthOfBorders) + 'px'
    });
    return this;
  },

  setHeight: function(value){
    if( this.options.scaleHeightToContent ){
      this.options.height = value;
      return this;
    }
    this.options.height = value;
    this.element.setStyle({
      height: (parseInt(this.options.height, 10)) + 'px'
    });
    var inner = $(this.element.id.substr(0,this.element.id.length-4));
    inner.setStyle({
      height: (parseInt(this.options.height, 10) - this.options.heightOfBorders) + 'px'
    });
    return this;
  },

  addResizers: function(){
    var resizer = $(this.element.id+'_RESIZER');
    Element.addClassName(resizer, this.options.className + '_sizer');

    this._onResizerMouseDown = this._resizerMouseDown.bindAsEventListener(this);
    this._onResizerMouseUp = this._resizerMouseUp.bindAsEventListener(this);
    this._onResizerMouseMove = this._resizerMouseMove.bindAsEventListener(this);

    Element.observe(resizer, 'mousedown', this._onResizerMouseDown);
    Element.observe(document, 'mouseup', this._onResizerMouseUp);
    Element.observe(document, 'mousemove', this._onResizerMouseMove);
  },
  
  removeResizers: function(){
    var resizer = $(this.element.id+'_RESIZER');
    
    Element.stopObserving(resizer, 'mousedown', this._onResizerMouseDown);
    Element.stopObserving(document, 'mouseup', this._onResizerMouseUp);
    Element.stopObserving(document, 'mousemove', this._onResizerMouseMove);
  },

  _endEffectDraggables: function(){
    if( this.options.movedDefined ){
      Gaia.Control.callControlMethod.bind(this)(
        'MovedMethod', 
        [parseInt(this.element.style.left), parseInt(this.element.style.top)], 
        function(retVal){
          if( retVal == 'false' ){
            this.element.style.left = this._oldX;
            this.element.style.top = this._oldY;
          }
        }.bind(this), 
        this.element.id.substr(0,this.element.id.length - 4));
    }
  },

  _startEffectDraggables: function(){
    this._oldX = this.element.style.left;
    this._oldY = this.element.style.top;
  },
  
  addDraggable: function(){
    this.draggable = new Draggable(this.element, {
      handle:this.element.id+'_HANDLE', 
      starteffect:this._startEffectDraggables.bind(this), 
      noDroppables: true,
      endeffect:this._endEffectDraggables.bind(this)
    });
    var elCaption = $(this.element.id+'_CAPTION');
    if( elCaption ){
      this.draggable2 = new Draggable(this.element, {
        handle:elCaption, 
        starteffect:this._startEffectDraggables.bind(this), 
        noDroppables: true,
        endeffect:this._endEffectDraggables.bind(this)
      });
    }
  },
  
  removeDraggable: function(){
    this.draggable.destroy();
    if( this.draggable2 )
      this.draggable2.destroy();
  },
  
  _resizerMouseDown: function(evt){
    if( this.oldHeight )
      return;
    this._x = Event.pointerX(evt);
    this._y = Event.pointerY(evt);
    this.bringWindowToFront();
    if( document.body.style.mozUserSelect ){
      this._oldMozSelect = document.body.style.mozUserSelect;
      document.body.style.mozUserSelect = 'none';
    } else {
      this._stopSelect = function(evt){Event.stop(evt);}.bindAsEventListener(this);
      Element.observe(document.body, 'selectstart', this._stopSelect);
    }
  },

  _resizerMouseUp: function(evt){
    if ( !this._x && !this._y )
      return;
    delete this._x;
    delete this._y;
    if( document.body.style.mozUserSelect ){
      document.body.style.mozUserSelect = this._oldMozSelect;
    } else {
      Element.stopObserving(document.body, 'selectstart', this._stopSelect);
    }
    
    if( this.options.resizedDefined ){
	  Gaia.Control.callControlMethod.bind(this)(
	    'ResizedMethod', 
	    [parseInt(this.element.style.width), parseInt(this.element.style.height), (this.isMaximized?true:false), (this.oldHeight?true:false)], 
	    function(retVal){
		  if( retVal == 'false' ){
		    this.element.style.width = this._oldWidth;
		    this.element.style.height = this._oldHeight;
		  }
	    }.bind(this), 
	    this.element.id.substr(0,this.element.id.length - 4));
	    try{this.onResized();}catch(o){}
    }
  },

  _resizerMouseMove: function(evt){
    if( this._x && this._y ){

      // User are holding down mouse button...!!
      var oldX = this._x;
      var oldY = this._y;
      this._x = Event.pointerX(evt);
      this._y = Event.pointerY(evt);
      var deltaX = (this._x - oldX);
      var deltaY = (this._y - oldY);

      // Retrieving the inner element (Panel) for later usage
      var inner = $(this.element.id.substr(0,this.element.id.length-4));


      // Setting width of ALL window
      var newWidth = parseInt(this.element.style.width,10) + deltaX;

      // Checking to see if size is less than minimum accepted size
      if (newWidth < this.options.minWidth)
        newWidth = this.options.minWidth;


      // Setting height/width of just the container div WITHIN window
      var newInnerWidth = parseInt(inner.style.width,10) + deltaX;

      // Checking to see if size is less than minimum accepted size
      if (newInnerWidth + this.options.widthOfBorders < this.options.minWidth){
        newInnerWidth = this.options.minWidth - this.options.widthOfBorders;
        this._x = oldX;
      }


      // Setting height of ALL window
      var newHeight;
      if( this.options.scaleHeightToContent ){
        newHeight = parseInt(this.element.clientHeight,10) + deltaY;
      } else {
        newHeight = parseInt(this.element.style.height,10) + deltaY;
      }

      // Checking to see if size is less than minimum accepted size
      if (newHeight < this.options.minHeight)
        newHeight = this.options.minHeight;


      // Setting height/width of just the container div WITHIN window
      var newInnerHeight;
      if( this.options.scaleHeightToContent ){
        newInnerHeight = parseInt(inner.clientHeight,10) + deltaY;

        // Deleting the option to make sure setting heights from callbacks works
        // in addition to optimize scaling in IE...
        delete this.options.scaleHeightToContent;
      } else {
        newInnerHeight = parseInt(inner.style.height,10) + deltaY;
      }

      // Checking to see if size is less than minimum accepted size
      if (newInnerHeight + this.options.heightOfBorders < this.options.minHeight){
        newInnerHeight = this.options.minHeight - this.options.heightOfBorders;
        this._y = oldY;
      }


      // Setting the new size
      this.element.setStyle({
        width: newWidth+'px', 
        height: newHeight+'px'
      });

      // Setting the new size
      inner.setStyle({
        width: newInnerWidth+'px',
        height: newInnerHeight+'px'
      });
      
          try{this.onResizerMouseMove(newInnerWidth);}catch(o){}
    
    }
  },

  setVisible: function(value){
    if( value == true ){

      // Making window appear ON TOP of any other visible windows...!!
      var zIndex = 500;
      Gaia.Window._visibleWindows.each(function(idxWnd){
        if( parseInt(idxWnd.element.style.zIndex, 10) > zIndex){
          zIndex = parseInt(idxWnd.element.style.zIndex, 10);
        }
      });
      zIndex += 2;

      Gaia.Window._visibleWindows.push(this);

      Element.show(this.element);
      Element.setStyle(this.element, {zIndex:(zIndex + 1)});

      // Checking to see if we need to obscure the rest of the surface...!!
      if( this.options.modal ){
        this.obscurer = Builder.node('div', {
          style:'z-index:'+(zIndex)+';'+
            'background-color:#ccf;'+
            'position:absolute;'
        });
        var size = this.getPageSize();
        var scroll = this._getWindowScroll(window);

        // We should probably try to FIX this, but for now we set the obscurer to fill the EXACT space of the viewport since IE will mess with
        // the opacity if it becomes TOO big and we therefore CAN'T set its size to the size of the page...
        this.obscurer.style.height = (size.windowHeight+'px');
        this.obscurer.style.width = (size.windowWidth+'px');
        this.obscurer.style.left = (scroll.left+'px');
        this.obscurer.style.top = (scroll.top+'px');
        this.obscurer.style.display = 'block';
        Element.setOpacity(this.obscurer, 0.6);
        document.body.appendChild(this.obscurer);
      }
      if( this.options.autoCenter || this.options.modal ){
        this.pageSize = null;
        this._onScroll = this._scroll.bindAsEventListener(this);
        Event.observe(window, 'scroll', this._onScroll);

        this._onResize = function(evt){
          var size = this.getPageSize();

          // IE sends out some crapy events for this event
          if (this.pageSize && this.pageSize.pageWidth == size.windowWidth && this.pageSize.pageHeight == size.windowHeight)
            return;
          this.pageSize = size;

          if( this.obscurer ){
            this.obscurer.style.height = (size.windowHeight+'px');
            this.obscurer.style.width = (size.windowWidth+'px');
          }
          if( this.options.autoCenter )
            this.center();
        }.bindAsEventListener(this);
        Event.observe(window, 'resize', this._onResize);
      }

      // Checking to see if we need to do some default styling...
      if( this.options.className == null || this.options.className == '' ){
        var mainId = this.getMainElement().id;

        // Top table
        this.element.style.backgroundColor = '#eee';
        this.element.style.border = 'solid 1px Black';
        var topTbl = $(mainId+'_TOP_TABLE');
        topTbl.style.width = '100%';
        topTbl.style.backgroundColor='#ccf';
        var nw = $(mainId+'_NW');
        nw.style.width = '5px';
        var n = $(mainId+'_DIV_HANDLE');
        n.style.width = '100%';
        var ne = $(mainId+'_NE');
        ne.style.width = '5px';

        // Closer
        var closer = $(mainId+'_DIV_CLOSER');
        if(closer){
          closer.innerHTML = 'X';
          closer.style.position = 'absolute';
          closer.style.left = '25px';
        }

        // minimizer
        var mini = $(mainId+'_DIV_MINIMIZER');
        if(mini){
          mini.innerHTML = '_';
          mini.style.position = 'absolute';
          mini.style.left = '40px';
        }

        // maxi
        var maxi = $(mainId+'_DIV_MAXIMIZER');
        if(maxi){
          maxi.innerHTML = 'O';
          maxi.style.position = 'absolute';
          maxi.style.left = '55px';
        }

        // Content table
        var content = $(mainId+'_CONTENT_TBL');
        content.style.width='100%';
        //content.style.height='100%';
      }
    } else {
      // Making sure control and child controls is destroyed...
      this.destroy();

      var idx = 0;
      Gaia.Window._visibleWindows.each(function(wnd){
        if( wnd == this )
          throw $break;
        idx += 1;
      }.bind(this));
      Gaia.Window._visibleWindows.splice(idx, 1);
      Element.hide(this.element);
      if( this.obscurer ){
        this.obscurer.parentNode.removeChild(this.obscurer);
        delete this.obscurer;
      }
    }
  },

  _scroll: function(evt){
    var scroll = this._getWindowScroll(window);
    if( this.obscurer ){
      this.obscurer.style.left = (scroll.left+'px');
      this.obscurer.style.top = (scroll.top+'px');
    }
    if(this.options.autoCenter)
      this.center();
  },

  getMainElement: function(){
    if( !this._mainElement )
      this._mainElement = $(this.element.id.substr(0,this.element.id.length-4));
    return this._mainElement;
  },

  destroy: function(){

    // Unregistering draggable...
    if( this.draggable )
      this.draggable.destroy();
    if( this.draggable2 )
      this.draggable2.destroy();

    // Unregistering listeners
    if(this._onKeyDown)
      Element.stopObserving(this.element, 'keydown', this._onKeyDown);
    if(this._onClick)
      Element.stopObserving(this.element, 'click', this._onClick);
    if(this._onMinimizerClicked)
      Element.stopObserving($(this.element.id+'_MINIMIZER'), 'click', this._onMinimizerClicked);
    if(this._onMaximizerClicked){
      Element.stopObserving($(this.element.id+'_MAXIMIZER'), 'click', this._onMaximizerClicked);
      var caption = $(this.element.id+'_CAPTION');
      if( caption ){
        Element.stopObserving(caption, 'dblclick', this._onMaximizerClicked);
      }
      Element.stopObserving($(this.element.id+'_HANDLE'), 'dblclick', this._onMaximizerClicked);
    }
    if(this._onCloseMethod)
      Element.stopObserving($(this.element.id+'_CLOSER'), 'click', this._onCloseMethod);
    if(this._onResizerMouseDown) {
      Element.stopObserving($(this.element.id+'_RESIZER'), 'mousedown', this._onResizerMouseDown);
      Element.stopObserving(document, 'mouseup', this._onResizerMouseUp);
      Element.stopObserving(document, 'mousemove', this._onResizerMouseMove);
    }
    if(this._onScroll)
      Event.stopObserving(window, 'scroll', this._onScroll);
    if(this._onResize)
      Event.stopObserving(window, 'resize', this._onResize);

    // Destroying all CHILDREN controls
    this.destroyChildrenControls();

    // Dispatching to container DTOR
    this.destroyContainer(this.element.id.substr(0,this.element.id.length-4));

    // Calling Object.destroy implementation...
    this._destroyImpl();
  },

  center: function(){
    var pageSize = this.getPageSize();
    var scroll = this._getWindowScroll(window);
    var left = Math.max((pageSize.windowWidth / 2) - (parseInt(this.options.width, 10) / 2) + scroll.left, 0);
    var top = Math.max((pageSize.windowHeight / 2) - (parseInt(this.options.height, 10) / 2) + scroll.top, 0);
    this.setLocation(left, top);
  },

  setLocation: function(x, y){
    if( typeof x == 'number' )
      this.element.setStyle({left: (x + 'px')});
    else
      this.element.setStyle({left: x});
    if( typeof y == 'number' )
      this.element.setStyle({top: (y + 'px')});
    else
      this.element.setStyle({top: y});
  },

  // From script aculous...!!
  _getWindowScroll: function(w) {
    var T, L, W, H;
    with (w.document) {
      if (w.document.documentElement && documentElement.scrollTop != 'undefined') {
        T = documentElement.scrollTop;
        L = documentElement.scrollLeft;
      } else if (w.document.body) {
        T = body.scrollTop;
        L = body.scrollLeft;
      }
      if (w.innerWidth) {
        W = w.innerWidth;
        H = w.innerHeight;
      } else if (w.document.documentElement && documentElement.clientWidth) {
        W = documentElement.clientWidth;
        H = documentElement.clientHeight;
      } else {
        W = body.offsetWidth;
        H = body.offsetHeight
      }
    }
    return { top: T, left: L, width: W, height: H };
  },

  getPageSize: function(){

  	var xScroll;
  	var yScroll;
  	if (window.innerHeight && window.scrollMaxY) {	
  	  xScroll = document.body.scrollWidth;
  	  yScroll = window.innerHeight + window.scrollMaxY;
  	} else if (document.body.scrollHeight > document.body.offsetHeight){
  	  xScroll = document.body.scrollWidth;
  	  yScroll = document.body.scrollHeight;
  	} else {
  	  xScroll = document.body.offsetWidth;
  	  yScroll = document.body.offsetHeight;
  	}

  	var windowWidth;
  	var windowHeight;
  	if (self.innerHeight) {
  	  windowWidth = self.innerWidth;
  	  windowHeight = self.innerHeight;
  	} else if (document.documentElement && document.documentElement.clientHeight) {
  	  windowWidth = document.documentElement.clientWidth;
  	  windowHeight = document.documentElement.clientHeight;
  	} else if (document.body) {
  	  windowWidth = document.body.clientWidth;
  	  windowHeight = document.body.clientHeight;
  	}	

  	var pageHeight;
  	var pageWidth;
  	if(yScroll < windowHeight){
  	  pageHeight = windowHeight;
  	} else { 
  	  pageHeight = yScroll;
  	}
  	if(xScroll < windowWidth){
  	  pageWidth = windowWidth;
  	} else {
  	  pageWidth = xScroll;
  	}
  	return {
  	  pageWidth: pageWidth, 
  	  pageHeight: pageHeight, 
  	  windowWidth: windowWidth, 
  	  windowHeight: windowHeight
  	};
  },

  _getElementPostValue: function(){
    return '';
  }
});

Gaia.Window.browserFinishedLoading = true;
