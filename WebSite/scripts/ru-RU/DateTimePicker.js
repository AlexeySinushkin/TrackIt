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
Gaia.DateTimePicker = function(element, options){
  this.initializeDateTimePicker(element, options);
}

// Inheriting from TextBox
Object.extend(Gaia.DateTimePicker.prototype, Gaia.TextBox.prototype);

// Inheriting from Skinnable
Object.extend(Gaia.DateTimePicker.prototype, Gaia.Skinnable.prototype);

// Adding custom parts
Object.extend(Gaia.DateTimePicker.prototype, {
  initializeDateTimePicker: function(element, options) {
    // Calling base class constructor
    this.initialize(element, options);
    if( !this.options.onSelectionChanged )
      this.options.onSelectionChanged = Prototype.emptyFunction;

    // Initializing control
    this.picker = null;
    this.value = this._string2Date($F(this.element));
    this._onDropClicked = this._dropClicked.bindAsEventListener(this);
    if( this.options.hasButton ) {
      Element.observe($(this.options.hasButton), 'click', this._onDropClicked);
    } else {
      Element.observe(this.element, 'click', this._onDropClicked);
    }
  },

  destroy: function(){
    if( this.options.hasButton ) {
      Element.stopObserving($(this.options.hasButton), 'click', this._onDropClicked);
    } else {
      Element.stopObserving(this.element, 'click', this._onDropClicked);
    }

    // Calling Object.destroy implementation...
    this._destroyImpl();
  },

  observe: function(evtName){
    // Making sure we don't DOUBLE subscribe...
    this._observeImpl(evtName);
    if( evtName == 'change' ){
      // Need to create an onSelectionChanged wrapper!
      this.options.onSelectionChanged = function(This){
        // TextBox don't need the event...!!
        This._onEvent(evtName);
      }
    }
    return this;
  },

  _containsDOM: function(container, containee) {
    var isParent = false;
    do {
      if ((isParent = container == containee))
        break;
      containee = containee.parentNode;
    } while (containee != null);
    return isParent;
  },

  _checkMouseLeave: function(el, evt) {
    if (el.contains && evt.toElement) {
      return !el.contains(evt.toElement);
    }
    else if (evt.relatedTarget) {
      return !this._containsDOM(el, evt.relatedTarget);
    }
  },

  _dropClicked: function(evt){
    if( this.picker )
      return;
    if( this.element.disabled == true )
      return;
    this._popUp();
  },

  _popUp: function(){

    // Creating wrapper control div
    this.picker = document.createElement('div');

    // Adding CSS class (or style)
    var hasClassName = this.options.className != null && this.options.className != '';
    if( hasClassName ){
      Element.addClassName(this.picker, 'date_' + this.options.className);
    } else {
      // Default values if no CSS class is given...!!
      this.picker.style.width = '210px';
      this.picker.style.fontSize = '12px';
    }

    // Creating skin "around" datetimepicker...
    var tblSkin = this.createSkinTable();
    this.picker.appendChild(tblSkin.topTbl);
    this.picker.appendChild(tblSkin.midTbl);
    this.picker.appendChild(tblSkin.bottomTbl);

    // Absolutize and adding picker to DOM...!!
    this.element.parentNode.appendChild(this.picker);
    Position.absolutize(this.picker);

    // Making the calendar widget "draggable"...!!
    this.draggable = new Draggable(this.picker, {
      handle:tblSkin.topTbl,
      starteffect:Prototype.emptyFunction, 
      endeffect:function(){
        this._justCaptured = true;
      }.bind(this)
    });

    // Creating our "click the body" of the document part (closing popup)
    this._onClickBodyOrWhatever = this._clickBodyOrWhatever.bind(this);
    setTimeout(function(){
      Element.observe(document, 'click', this._onClickBodyOrWhatever);
    }.bind(this), 500);

    this._onPickerClicked = this._pickerClicked.bindAsEventListener(this);
    Element.observe(this.picker, 'click', this._onPickerClicked);

    // Creating the table that the contents is rendered within
    this._renderDate(this._string2Date($F(this.element)));

    // Initial HIDE of Content
    Element.setOpacity(this.actualContentTable, 0);

    // Setting position of picker
    Position.clone(this.element, this.picker, {setWidth:false, setHeight:false, offsetTop:Element.getHeight(this.element)});

    new Effect.Appear(this.actualContentTable, {duration:0.4});
  },

  _clickBodyOrWhatever: function(){
    if( this._justCaptured ){
      delete this._justCaptured;
    } else {
      if( this.options.hasTimePart )
        var date = new Date(this.value.getFullYear(), this.value.getMonth(), this.value.getDate(), parseInt($F(this.hoursEl), 10), parseInt($F(this.minutesEl), 10));
      else
        var date = new Date(this.value.getFullYear(), this.value.getMonth(), this.value.getDate(), 0, 0);
      this._closePopUp(function(){
        this.options.onSelectionChanged(this);
      }.bind(this), date);
    }
  },

  _pickerClicked: function(evt){
    Event.stop(evt);
    if( this._justCaptured )
      delete this._justCaptured;
  },

  // Override to get other languages!
  getCalendarMonthName: function(monthNo){
    if( this.options.localize ){
      var val = this.options.localize('nameOfMonth', monthNo);
      if( val )
        return val;
    } 
    switch(monthNo) {
      case 1:return 'Январь';
      case 2:return 'Февраль';
      case 3:return 'Март';
      case 4:return 'Апрель';
      case 5:return 'Май';
      case 6:return 'Июнь';
      case 7:return 'Июль';
      case 8:return 'Август';
      case 9:return 'Сентябрь';
      case 10:return 'Октябрь';
      case 11:return 'Ноябрь';
      case 12:return 'Декабрь';
    }
    throw "Undefined month!";
  },

  _renderHeader: function(){
    var hRow = document.createElement('tr');
    var hCell = document.createElement('td');
    hCell.colSpan = 8;
    hCell.innerHTML = this.getCalendarMonthName(this.currentMonth.getMonth() + 1);
    Element.addClassName(hCell, 'monthYear');
    hCell.innerHTML += ' - ' + this.currentMonth.getFullYear();
    hRow.appendChild(hCell);
    return hRow;
  },

  _leftYearClicked: function(evt){
    this.currentMonth = new Date(
      this.currentMonth.getFullYear()-1, 
      this.currentMonth.getMonth(), 
      this.currentMonth.getDate(),
      (this.options.hasTimePart ? parseInt($F(this.hoursEl), 10) : this.currentMonth.getHours()),
      (this.options.hasTimePart ? parseInt($F(this.minutesEl), 10) : this.currentMonth.getMinutes()));
    this._renderDate(this.currentMonth);
    Event.stop(evt);
  },

  _leftMonthClicked: function(evt){
    this.currentMonth = this.currentMonth.getMonth() == 0
      ? new Date(
          this.currentMonth.getFullYear() - 1, 
          11, 
          this.currentMonth.getDate(),
          (this.options.hasTimePart ? parseInt($F(this.hoursEl), 10) : this.currentMonth.getHours()),
          (this.options.hasTimePart ? parseInt($F(this.minutesEl), 10) : this.currentMonth.getMinutes()))
      : new Date(
          this.currentMonth.getFullYear(), 
          this.currentMonth.getMonth() - 1, 
          this.currentMonth.getDate(),
          (this.options.hasTimePart ? parseInt($F(this.hoursEl), 10) : this.currentMonth.getHours()),
          (this.options.hasTimePart ? parseInt($F(this.minutesEl), 10) : this.currentMonth.getMinutes()));
    this._renderDate(this.currentMonth);
    Event.stop(evt);
  },

  _rightMonthClicked: function(evt){
    this.currentMonth = this.currentMonth.getMonth() == 11 
      ? new Date(
          this.currentMonth.getFullYear() + 1, 
          0, 
          this.currentMonth.getDate(),
          (this.options.hasTimePart ? parseInt($F(this.hoursEl), 10) : this.currentMonth.getHours()),
          (this.options.hasTimePart ? parseInt($F(this.minutesEl), 10) : this.currentMonth.getMinutes()))
      : new Date(
          this.currentMonth.getFullYear(), 
          this.currentMonth.getMonth() + 1, 
          this.currentMonth.getDate(),
          (this.options.hasTimePart ? parseInt($F(this.hoursEl), 10) : this.currentMonth.getHours()),
          (this.options.hasTimePart ? parseInt($F(this.minutesEl), 10) : this.currentMonth.getMinutes()));
    this._renderDate(this.currentMonth);
    Event.stop(evt);
  },

  _rightYearClicked: function(evt){
    this.currentMonth = new Date(
      this.currentMonth.getFullYear()+1, 
      this.currentMonth.getMonth(), 
      this.currentMonth.getDate(),
      (this.options.hasTimePart ? parseInt($F(this.hoursEl), 10) : this.currentMonth.getHours()),
      (this.options.hasTimePart ? parseInt($F(this.minutesEl), 10) : this.currentMonth.getMinutes()));
    this._renderDate(this.currentMonth);
    Event.stop(evt);
  },

  todayClicked: function(){
    this._clicked(new Date());
  },

  _renderNavigator: function(){
    var nRow = document.createElement('tr');
    Element.addClassName(nRow, 'navigate');

    // Left button
    var hLeftYear = document.createElement('td');
    this.hLeftYear = hLeftYear;
    hLeftYear.innerHTML = '&lt;&lt;'; //<<
    this._onLeftYearClicked = this._leftYearClicked.bindAsEventListener(this);
    Element.observe(hLeftYear, 'click', this._onLeftYearClicked);
    nRow.appendChild(hLeftYear);

    var hLeftMonth = document.createElement('td');
    this.hLeftMonth = hLeftMonth;
    hLeftMonth.innerHTML = '&lt;'; //<
    this._onLeftMonthClicked = this._leftMonthClicked.bindAsEventListener(this);
    Element.observe(hLeftMonth, 'click', this._onLeftMonthClicked);
    nRow.appendChild(hLeftMonth);

    // Today button
    var hToday = document.createElement('td');
    this.hToday = hToday;
    hToday.colSpan = 4;

    var todayString = 'Сегодня';
    if( this.options.localize ){
      var val = this.options.localize('todayName', null);
      if( val )
        todayString = val;
    }
    hToday.innerHTML = todayString;
    this._onTodayClicked = this.todayClicked.bind(this);
    Element.observe(hToday, 'click', this._onTodayClicked);
    nRow.appendChild(hToday);

    // Right button
    var hRightMonth = document.createElement('td');
    this.hRightMonth = hRightMonth;
    hRightMonth.innerHTML = '&gt;'; //>
    this._onRightMonthClicked = this._rightMonthClicked.bindAsEventListener(this);
    Element.observe(hRightMonth, 'click', this._onRightMonthClicked);
    nRow.appendChild(hRightMonth);

    var hRightYear = document.createElement('td');
    this.hRightYear = hRightYear;
    hRightYear.innerHTML = '&gt;&gt;'; //>>
    this._onRightYearClicked = this._rightYearClicked.bindAsEventListener(this);
    Element.observe(hRightYear, 'click', this._onRightYearClicked);
    nRow.appendChild(hRightYear);

    // Adding up "hover" logic...
    this._onHoverOverButtonArray = new Array();
    [hLeftMonth, hLeftYear, hRightMonth, hRightYear, hToday].each(function(el){
      var obj = new Object();
      obj.el = el;
      obj._evtOn = this._hoverOverButton.bind(this, el);
      obj._evtOff = this._hoverOffButton.bind(this, el);
      this._onHoverOverButtonArray.push(obj);
      Element.observe(el, 'mouseover', obj._evtOn);
      Element.observe(el, 'mouseout', obj._evtOff);
    }.bind(this));
    return nRow;
  },

  _hoverOverButton: function(el){
    Element.addClassName(el, 'mouseOverBtn');
  },

  _hoverOffButton: function(el){
    Element.removeClassName(el, 'mouseOverBtn');
  },

  // Override to give support for other languages, though 0 == Week or something while 1 == monday, 2 == tuesday etc...
  getDayName: function(noDay){
    if( this.options.localize ){
      var val = this.options.localize('nameOfDay', noDay);
      if( val )
        return val;
    }
    switch(noDay){
      case 0: return '&nbsp;';
      case 1: return 'Пн.';
      case 2: return 'Вт.';
      case 3: return 'Ср.';
      case 4: return 'Чт.';
      case 5: return 'Пт.';
      case 6: return 'Сб.';
      case 7: return 'Вс.';
    }
    throw "Out of bounds in getDayName";
  },

  // Override to implement holidays in other languages...
  // This is the default rendering only sundays and parts of the x-mas as "holidays"...
  isHoliday: function(date){
    if( this.options.localize ){
      var val = this.options.localize('isHoliday', date);
      if( val != null )
        return val;
    }
    if( date.getDay() == 6 || date.getDay() == 0 ) // Saturday and sunday
      return true;
    if( date.getMonth() == 4 && date.getDate() == 1 )
      return true; // 1.st of May
    if( date.getMonth() == 0 && date.getDate() == 1 )
      return true; // 1.st of January
    if( date.getMonth() == 11 ){
      if( date.getDate() == 25 || date.getDate() == 26 ) // 25'th and 26'th of December
        return true;
    }
    return false;
  },

  _renderDate:function(curDate){
    this._removeEventHandlers();

    this.value = new Date(curDate.valueOf());
    this.currentMonth = curDate;

    // In case this is just a navigation render we need to preserve the earlier position of the calendar picker
    var x, y;
    if( this.picker.childNodes.length > 0 ){
      x = this.picker.childNodes[0].style.left;
      y = this.picker.childNodes[0].style.top;
    }
    var table = document.createElement('table');
    var tbody = document.createElement('tbody');

    if( x && y ){
      table.style.left = x;
      table.style.top = y;
    }
    this._allCellEventsArray = new Array();

    // Finding LAST monday in previous month...
    // Basically we render parts of the previous and the upcoming month unless the current month starts or ends exactly on a monday!
    var idxDate = curDate;
    idxDate.setDate(1);
    while(idxDate.getDay() != 1){
      idxDate = new Date(idxDate.valueOf() - (1000*3600*24));
    }

    // Header
    var hRow = this._renderHeader();
    tbody.appendChild(hRow);

    // Now the NAVIGATORs...
    var nRow = this._renderNavigator();
    tbody.appendChild(nRow);

    // Since we want to hover both the week no cell and the week day cell we need to cache these up as we traverse
    // the days...
    var weekNoCacheCell = null;
    var weekDayCacheCell = new Array();

    // Rows or actually DATE cells...!!
    for(var rowNo=0;rowNo<7;rowNo++){
      var row = document.createElement('tr');

      // Columns
      for(var colNo=0;colNo<8;colNo++){
        var cell = document.createElement('td');
        if( rowNo == 0 ){
          // Weekdays header row
          if( colNo != 0 )
            weekDayCacheCell.push(cell);
          cell.innerHTML = this.getDayName(colNo);
          if( colNo == 0 )
            Element.addClassName(cell, 'weekHeader')
          else
            Element.addClassName(cell, 'weekDayHeader')
        } else {
          if( this.isHoliday(idxDate) )
            Element.addClassName(cell, 'holliday');

          // Normal date row
          if( colNo == 0 ){
            // Leftmost column, display weekno
            cell.innerHTML = this._getWeekNr(idxDate);
            Element.addClassName(cell, 'weekNo');

            // Storing this one for later...
            weekNoCacheCell = cell;
          } else {
            // Setting cells content to day of month
            cell.innerHTML = idxDate.getDate();

            var evtForCell = new Object();
            evtForCell.el = cell;
            evtForCell.evtName = 'mouseover';
            evtForCell.binded = this._mouseOver.bind(this, cell, weekNoCacheCell, weekDayCacheCell[colNo-1]);
            this._allCellEventsArray.push(evtForCell);
            Element.observe(evtForCell.el, evtForCell.evtName, evtForCell.binded);

            evtForCell = new Object();
            evtForCell.el = cell;
            evtForCell.evtName = 'click';
            evtForCell.binded = this._clicked.bind(this, idxDate);
            this._allCellEventsArray.push(evtForCell);
            Element.observe(evtForCell.el, evtForCell.evtName, evtForCell.binded);

            evtForCell = new Object();
            evtForCell.el = cell;
            evtForCell.evtName = 'mouseout';
            evtForCell.binded = this._mouseOut.bind(this, cell, weekNoCacheCell, weekDayCacheCell[colNo-1]);
            this._allCellEventsArray.push(evtForCell);
            Element.observe(evtForCell.el, evtForCell.evtName, evtForCell.binded);

            // Checking to see if this date is within month
            if( idxDate.getMonth() != curDate.getMonth() )
              Element.addClassName(cell, 'offMonth');

            if( this.value.getFullYear() == idxDate.getFullYear() &&
                this.value.getDate() == idxDate.getDate() &&
                this.value.getMonth() == idxDate.getMonth() ){
              Element.addClassName(cell, 'selectedDate');
            }

            // Incrementing idxDate by ONE DAY!
            // Note that by law the LAST sunday in October actually have 25 hours due to Daylight Savings...!
            // Also the last Sunday in April has ONE HOUR LESS then normal (23)
            // Therefor we need to check if this is th last Sunday in october and if it is we add ** 25 ** hours instead of 24...!!
            var hoursToAdd = 24; // Defaulting to 24
            if( idxDate.getMonth() == 9 ){
              if( idxDate.getDay() == 0 && idxDate.getDate() >= 25 )
                hoursToAdd = 25;
            }
            idxDate = new Date(idxDate.valueOf() + (1000*3600*hoursToAdd));
          }
        }
        row.appendChild(cell);
      }
      tbody.appendChild(row);
      if( (idxDate.getMonth() > curDate.getMonth() && idxDate.getFullYear() == curDate.getFullYear()) ||
          (idxDate.getMonth() < curDate.getMonth() && idxDate.getFullYear() > curDate.getFullYear()))
        break;
    }

    if( this.options.hasTimePart == true ){
      // Adding up the time parts below the actual calendar part...!!
      var sub = this._createSub();
      tbody.appendChild(sub);
    }

    table.appendChild(tbody);
    if( this.actualContentTable )
      this.actualContentTable.parentNode.removeChild(this.actualContentTable);
    this.actualContentTable = table;
    this.actualContentCell.appendChild(table);
  },

  _hourPlusMouseDown: function(evt){
    delete this.hasMoved;
    Element.addClassName(this.hoursEl, 'selected');
    this.hoursCapture = Event.pointerX(evt);
    Event.stop(evt);
  },

  _minutePlusMouseDown: function(evt){
    delete this.hasMoved;
    Element.addClassName(this.minutesEl, 'selected');
    this.minutesCapture = Event.pointerX(evt);
    Event.stop(evt);
  },

  _hoursInputKeyDown: function(){
    this.hasChanges = true;
  },

  _minutesInputKeyDown: function(){
    this.hasChanges = true;
  },

  _createSub: function(){

    // Spacer to the left...!!
    var sub = document.createElement('tr');
    Element.addClassName(sub, 'timePartRow');
    var left = document.createElement('td');
    left.colSpan = 2;
    sub.appendChild(left);

    // Hours...!!
    var hPP = document.createElement('td');
    hPP.className = 'date_'+this.options.className + '_navigator';
    hPP.innerHTML = '+';
    sub.appendChild(hPP);

    this._hourPlus = hPP;
    this._onHourPlusMouseDown = this._hourPlusMouseDown.bindAsEventListener(this);
    Element.observe(this._hourPlus, 'mousedown', this._onHourPlusMouseDown);

    // Time part...!!
    var timePart = document.createElement('td');
    timePart.colSpan = 2;

    var hours = document.createElement('input');
    this._hoursInput = hours;
    this._onHoursInputKeyDown = this._hoursInputKeyDown.bind(this);
    Element.observe(this._hoursInput, 'keydown', this._onHoursInputKeyDown);
    hours.type='text';
    var hourValue = this.value.getHours();
    if( hourValue < 10 )
      hourValue = '0' + hourValue;
    hours.value = hourValue;
    timePart.appendChild(hours);
    this.hoursEl = hours;

    // Colon
    var colon = document.createElement('b');
    colon.innerHTML = ':';
    timePart.appendChild(colon);

    // Minutes to the right
    var minutes = document.createElement('input');
    this._minutesInput = minutes;
    this._onMinutesInputKeyDown = this._minutesInputKeyDown.bind(this);
    Element.observe(this._minutesInput, 'keydown', this._onMinutesInputKeyDown);
    minutes.type='text';
    var minuteValue = this.value.getMinutes();
    if( minuteValue < 10 )
      minuteValue = '0' + minuteValue;
    minutes.value = minuteValue;
    timePart.appendChild(minutes);
    this.minutesEl = minutes;
    sub.appendChild(timePart);

    // Minutes...
    var mPP = document.createElement('td');
    mPP.className = 'date_'+this.options.className + '_navigator';
    mPP.innerHTML = '+';
    this._minutePlus = mPP;
    this._onMinutePlusMouseDown = this._minutePlusMouseDown.bindAsEventListener(this);
    Element.observe(this._minutePlus, 'mousedown', this._onMinutePlusMouseDown);
    sub.appendChild(mPP);

    // For both the hours and the minutes
    Element.observe(document.getElementsByTagName('body')[0], 'mouseup', function(evt){
      if(this.hoursCapture){
        this._justCaptured = true;
        Element.removeClassName(this.hoursEl, 'selected');
        delete this.hoursCapture;
        if( !this.hasMoved ){
          this.hasChanges = true;
          var value = parseInt($F(this.hoursEl), 10);
          if( evt.shiftKey ){
            if( value == 0 ) value = 23;
            else value -= 1;
          } else {
            if( value == 23 ) value = 0;
            else value += 1;
          }
          if( value < 10 ) this.hoursEl.value = '0'+value;
          else this.hoursEl.value = value;
        }
      } else if( this.minutesCapture){
        this._justCaptured = true;
        Element.removeClassName(this.minutesEl, 'selected');
        delete this.minutesCapture;
        if( !this.hasMoved ){
          this.hasChanges = true;
          var value = parseInt($F(this.minutesEl), 10);
          if( evt.shiftKey ){
            if( value == 0 ) value = 59;
            else value -= 1;
          } else {
            if( value == 59 ) value = 0;
            else value += 1;
          }
          if( value < 10 ) this.minutesEl.value = '0'+value;
          else this.minutesEl.value = value;
        }
      } 
    }.bindAsEventListener(this));
    Element.observe(document.getElementsByTagName('body')[0], 'mousemove', function(evt){
      if( this.hoursCapture ){
        var startX = this.hoursCapture;
        var newX = Event.pointerX(evt)
        var delta = newX - startX;
        if( Math.abs(delta) > 4 ){
          this.hasChanges = true;
          this.hasMoved = true;
          var value = parseInt($F(this.hoursEl), 10);
          value += delta > 0 ? 1 : -1;
          if( value < 0 ) value = 23;
          if( value > 23 ) value = 0;
          if( value < 10 ) this.hoursEl.value = '0'+value;
          else this.hoursEl.value = value;
          this.hoursCapture = newX;
        }
        Event.stop(evt);
      } else if( this.minutesCapture ){
        var startX = this.minutesCapture;
        var newX = Event.pointerX(evt)
        var delta = newX - startX;
        if( Math.abs(delta) > 4 ){
          this.hasChanges = true;
          this.hasMoved = true;
          var value = parseInt($F(this.minutesEl), 10);
          value += delta > 0 ? 1 : -1;
          if( value < 0 ) value = 59;
          if( value > 59 ) value = 0;
          if( value < 10 ) this.minutesEl.value = '0'+value;
          else this.minutesEl.value = value;
          this.minutesCapture = newX;
        }
        Event.stop(evt);
      }
    }.bindAsEventListener(this));

    // Spacer to the right...!!
    var right = document.createElement('td');
    right.colSpan = 2;
    sub.appendChild(right);
    return sub;
  },

  _mouseOver: function(cellElement, weekNoCacheCell, weekDayCell){
    Element.addClassName(cellElement, 'hoover')
    Element.removeClassName(weekNoCacheCell, 'weekNo')
    Element.addClassName(weekNoCacheCell, 'hooverWeekNo')
    Element.removeClassName(weekDayCell, 'weekDayHeader')
    Element.addClassName(weekDayCell, 'hooverWeekDayHeader')
  },

  _mouseOut: function(cellElement, weekNoCacheCell, weekDayCell){
    Element.removeClassName(cellElement, 'hoover')
    Element.removeClassName(weekNoCacheCell, 'hooverWeekNo')
    Element.addClassName(weekNoCacheCell, 'weekNo')
    Element.addClassName(weekDayCell, 'weekDayHeader')
    Element.removeClassName(weekDayCell, 'hooverWeekDayHeader')
  },

  _clicked: function(date){
    this.hasChanges = true;
    this._closePopUp(function(){
      this.options.onSelectionChanged(this);
    }.bind(this), date);
  },

  getValueAsString: function(){
    return this._date2String(this.value);
  },

  _removeEventHandlers: function(){
    var idx = 0;
    if( this.hLeftMonth){
      [this.hLeftMonth, this.hLeftYear, this.hRightMonth, this.hRightYear, this.hToday].each(function(el){
        Element.stopObserving(el, 'mouseover', this._onHoverOverButtonArray[idx]._evtOn);
        Element.stopObserving(el, 'mouseout', this._onHoverOverButtonArray[idx]._evtOff);
        idx += 1;
      }.bind(this));
    }

    if(this._onHourPlusMouseDown){
      Element.stopObserving(this._hourPlus, 'mousedown', this._onHourPlusMouseDown);
      Element.stopObserving(this._hoursInput, 'keydown', this._onHoursInputKeyDown);
      Element.stopObserving(this._minutesInput, 'keydown', this._onMinutesInputKeyDown);
      Element.stopObserving(this._minutePlus, 'mousedown', this._onMinutePlusMouseDown);
    }

    // Clearing up hover, no-hover and click for every cell in datetimepicker
    if(this._allCellEventsArray){
      this._allCellEventsArray.each(function(idxEvt){
        Element.stopObserving(idxEvt.el, idxEvt.evtName, idxEvt.binded);
      });
    }

    if(this.hLeftYear) {
      Element.stopObserving(this.picker, 'click', this._onPickerClicked);
      Element.stopObserving(this.hLeftYear, 'click', this._onLeftYearClicked);
      Element.stopObserving(this.hLeftMonth, 'click', this._onLeftMonthClicked);
      Element.stopObserving(this.hRightMonth, 'click', this._onRightMonthClicked);
      Element.stopObserving(this.hRightYear, 'click', this._onRightYearClicked);
      Element.stopObserving(this.hToday, 'click', this._onTodayClicked);
    }
  },

  _closePopUp: function(afterFinished, date){
    // We DON'T close the datetimepicker if the user is dragging any of the hour/minutes controls...
    if( this.hoursCapture || this.minutesCapture )
      return;

    // Removing "local" event handlers....
    this._removeEventHandlers();
    delete this.hLeftYear;
    delete this.hLeftMonth;

    // Freeing draggable
    this.draggable.destroy();

    Element.stopObserving(document, 'click', this._onClickBodyOrWhatever);

    var changes = this.hasChanges;

    // Checking to see if anything has changed...!!
    if( this.hasChanges && date){
      if( this.options.hasTimePart )
        this.value = new Date(
          date.getFullYear(), 
          date.getMonth(), 
          date.getDate(), 
          parseInt($F(this.hoursEl), 10), 
          parseInt($F(this.minutesEl), 10));
      else
        this.value = new Date(
          date.getFullYear(), 
          date.getMonth(), 
          date.getDate(), 
          0, 
          0);
      this.element.value = this._date2String(this.value);
    }

    // Fading away DateTimePicker
    new Effect.Fade(this.actualContentTable, {
      duration: 0.2,
      afterFinish: function(){
        if( this.picker && this.picker.parentNode ){
          Element.hide(this.picker);
          setTimeout(function(){
            this.picker.parentNode.removeChild(this.picker);
            this.picker = null;
          }.bind(this), 50);
        }
        if( changes && afterFinished ){
          afterFinished();
        }
      }.bind(this)
    });

    // Flashing input field... but ONLY if changes occured...!!
    if( this.hasChanges && date ){
      new Effect.Highlight(this.element, {
        duration:0.4
      });
    }
    delete this.hasChanges;
    delete this.hasMoved;
    delete this.hoursCapture;
    delete this.minutesCapture;
    try{this.onClose();}catch(o){}
  },

  _getWeekNr: function(dateIn) {
    var dy = dateIn.getDate();
    var mo = dateIn.getMonth();
    var yr = dateIn.getFullYear();
    var P3D = 259200000;
    var P7D = 604800000;
    var s = Math.floor((Date.UTC(yr, mo, dy) + P3D) / P7D)
    var tmp = new Date(s * P7D)
    var j = tmp.getFullYear();
    var q = 1 + s - Math.floor((Date.UTC(j, 0, 4) + P3D) / P7D)
    return q
  },

  _date2String: function(date) {
    var year = '' + date.getFullYear();
    var month = ''+(date.getMonth() < 9 ? '0'+(date.getMonth()+1) : (date.getMonth()+1));
    var day = ''+(date.getDate() < 10 ? '0'+date.getDate() : date.getDate());
    var hours = ''+(date.getHours() < 10 ? '0'+date.getHours() : date.getHours());
    var minutes = ''+(date.getMinutes() < 10 ? '0'+date.getMinutes() : date.getMinutes());
    var retVal = this.options.format;
    retVal = retVal.replace('yyyy', year);
    retVal = retVal.replace('MM', month);
    retVal = retVal.replace('dd', day);
    retVal = retVal.replace('HH', hours);
    retVal = retVal.replace('mm', minutes);
    return retVal;
  },

  _string2Date: function(dateStr) {
    if( dateStr.length == 0 )
      return new Date();
    try {
      var startOfFullYear = this.options.format.indexOf('yyyy');
      var startOfMonth = this.options.format.indexOf('MM');
      var startOfDay = this.options.format.indexOf('dd');
      var startOfHours = this.options.format.indexOf('HH');
      var startOfMinutes = this.options.format.indexOf('mm');
      var mustBeMinimum = Math.max(startOfFullYear + 4,
        Math.max(startOfMonth + 2,
          Math.max(startOfDay + 2,
            Math.max(startOfHours, 
              Math.max(startOfMinutes, 0)))));
      if( dateStr.length < mustBeMinimum )
        return new Date();

      var year = dateStr.substr(startOfFullYear, 4);
      var month = dateStr.substr(startOfMonth, 2);
      var day = dateStr.substr(startOfDay, 2);
      var hours = dateStr.substr(startOfHours, 2);
      var minutes = dateStr.substr(startOfMinutes, 2);

      year = parseInt(year, 10);
      month = parseInt(month, 10) - 1;
      day = parseInt(day, 10);
      hours = parseInt(hours, 10);
      minutes = parseInt(minutes, 10);
      return new Date(year, month, day, hours, minutes);
    } catch(e) {
      return new Date();
    }
  }
});

Gaia.DateTimePicker.browserFinishedLoading = true;
