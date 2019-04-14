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
   Class basically wrapping the Skinnable objects (Window, AutoCompleter etc)
   --------------------------------------------------------------------------- */

Gaia.Skinnable = function(){}

Gaia.Skinnable.prototype = {

  createSkinTable: function(){

    // Checking to see if it HAS a CSS class name
    var hasClassName = this.options.className != null && this.options.className != '';

    // Top table first
    var tblSkinTop = document.createElement('table');
    if( hasClassName ){
      Element.addClassName(tblSkinTop, this.options.className + '_table_window');
      Element.addClassName(tblSkinTop, this.options.className + '_top_draggable');
    } else {
      tblSkinTop.style.backgroundColor = '#ddd';
      tblSkinTop.style.width = '100%';
      tblSkinTop.style.borderCollapse = 'collapse';
    }
    var tblBdy = document.createElement('tbody');
    tblSkinTop.appendChild(tblBdy);
    var tblRow = document.createElement('tr');
    tblBdy.appendChild(tblRow);
    var cell = document.createElement('td');
    if( hasClassName )
      Element.addClassName(cell, this.options.className + '_nw');
    cell.innerHTML = '&nbsp;';
    tblRow.appendChild(cell);
    cell = document.createElement('td');
    if( hasClassName )
      Element.addClassName(cell, this.options.className + '_n');
    cell.innerHTML = '&nbsp;';
    tblRow.appendChild(cell);
    cell = document.createElement('td');
    if( hasClassName )
      Element.addClassName(cell, this.options.className + '_ne');
    cell.innerHTML = '&nbsp;';
    tblRow.appendChild(cell);

    // Then the "mid" table
    var tblSkinMiddle = document.createElement('table');
    tblBdy = document.createElement('tbody');
    tblSkinMiddle.appendChild(tblBdy);
    tblRow = document.createElement('tr');
    tblBdy.appendChild(tblRow);
    cell = document.createElement('td');
    cell.innerHTML = '&nbsp;';
    if( hasClassName ) {
      Element.addClassName(cell, this.options.className + '_w');
    } else {
      cell.style.backgroundColor = '#ddd';
      cell.style.width = '5px';
    }
    tblRow.appendChild(cell);
    cell = document.createElement('td');
    if( hasClassName ) {
      Element.addClassName(cell, this.options.className + '_content');
    } else {
      cell.style.backgroundColor = '#eee';
      cell.style.width = '100%';
    }
    tblRow.appendChild(cell);
    this.actualContentCell = cell;
    cell = document.createElement('td');
    cell.innerHTML = '&nbsp;';
    if( hasClassName ) {
      Element.addClassName(tblSkinMiddle, this.options.className + '_table_window');
      Element.addClassName(cell, this.options.className + '_e');
    } else {
      tblSkinMiddle.style.borderCollapse = 'collapse';
      cell.style.backgroundColor = '#ddd';
      cell.style.width = '5px';
    }
    tblRow.appendChild(cell);

    // Then the "bottom" table
    var tblSkinBottom = document.createElement('table');
    if( hasClassName ){
      Element.addClassName(tblSkinBottom, this.options.className + '_table_window');
    } else {
      tblSkinBottom.style.backgroundColor = '#ddd';
      tblSkinBottom.style.width = '100%';
      tblSkinBottom.style.borderCollapse = 'collapse';
    }
    tblBdy = document.createElement('tbody');
    tblSkinBottom.appendChild(tblBdy);
    tblRow = document.createElement('tr');
    tblBdy.appendChild(tblRow);
    cell = document.createElement('td');
    if( hasClassName )
      Element.addClassName(cell, this.options.className + '_sw');
    cell.innerHTML = '&nbsp;';
    tblRow.appendChild(cell);
    cell = document.createElement('td');
    if( hasClassName )
      Element.addClassName(cell, this.options.className + '_s');
    cell.innerHTML = '&nbsp;';
    tblRow.appendChild(cell);
    cell = document.createElement('td');
    if( hasClassName )
      Element.addClassName(cell, this.options.className + '_se');
    cell.innerHTML = '&nbsp;';
    tblRow.appendChild(cell);

    return {
      topTbl: tblSkinTop,
      midTbl: tblSkinMiddle,
      bottomTbl: tblSkinBottom
    };
  }
};

Gaia.Skinnable.browserFinishedLoading = true;
