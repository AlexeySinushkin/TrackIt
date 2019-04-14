// JScript File
var defaultPage="index-free.aspx";
function addCss(fileName)
{
    css = document.createElement('link');
    css.setAttribute('rel', 'stylesheet');
    css.setAttribute('type', 'text/css');
    css.setAttribute('href', fileName);
    document.getElementsByTagName('head')[0].appendChild(css);
} 
function addJs(src)
{
    var js = document.createElement("script");
    js.setAttribute("type","text/javascript");
    js.setAttribute("src",src);
    document.getElementById('temp_container').appendChild(js);
}
function addImg(src)
{
    var img = new Image(1,1);
    img.src=src;
    document.getElementById('temp_container').appendChild(img);
}
function getAutoCompleteList(textBox)
{
    new Ajax.Request('autocomplete.ashx',
        {
        method:'POST',
        parameters:{'ac':textBox.name,'text':textBox.value},
        onSuccess:function(transport, json)
            {
                var ac=eval('ac'+textBox.id);
                ac.autoCompleter.hasFocus=true;
                ac.autoCompleter.updateChoices(transport.responseText);
            }
        }
    );
}

Element.addMethods({

    showEffect: function (element) {
        element = $(element);
        element.setStyle({ opacity: 0 });
        element.show();
        new Effect.Opacity(element);
        element.relativize();
    },
    hideEffect: function (element) {
        element = $(element);
        new Effect.Opacity(element, { from: 1, to: 0, afterFinish: function () { element.hide(); } });
    },

    check: function (element) {
        element = $(element); //input
        var result = true;
        element.setStyle({ 'backgroundImage': '', 'backgroundColor': '' });
        var pattern = element.getAttribute('regex');
        if (pattern != null) {
            var regex = new RegExp(pattern);
            if (!regex.test(element.value)) {
                result = false;
                //делаем подсветку
                if (!element.hasClassName('bad-value')) element.addClassName('bad-value');
            }
            else//убираем подсветку
            {
                if (element.hasClassName('bad-value')) element.removeClassName('bad-value');
            }
        }
        return result;
    },

    //проверка валидности дочерних элементов с аттрибутом regex
    checkDescendants: function (element) {
        element = $(element); //form, dl, div и т.д. который содержит <input-ы
        var result = true;
        element.descendants().each
    (
        function (input) {
            if (!$(input).check()) {
                result = false;
            }
        }
    );
        return result;
    },

    //изменение называния кнопки
    changeButtonName: function (element, name) {
        element = $(element);
        if (element.match('a')) {
            element.setAttribute('title', name);
        }
        var img = element.down('img');
        if (img != null) {
            var n = '/images/buttons/' + name;
            var nd = '/images/buttonsdown/' + name; addImg(nd);
            var no = '/images/buttonsover/' + name; addImg(no);
            img.src = n;
            img.observe('mouseover', function (event) { var elt = $(Event.element(event)); elt.src = no; });
            img.observe('mousedown', function (event) { var elt = $(Event.element(event)); elt.src = nd; });
            img.observe('mouseout', function (event) { var elt = $(Event.element(event)); elt.src = n; });
        }
    },

    radioValue: function (anyRadio) {
       return Form.getInputs(anyRadio.form, 'radio', anyRadio.name).find(function (radio) { return radio.checked; }).value;
    }

});

var gpsPoint = Class.create();
gpsPoint.prototype = 
{
    initialize: function(latitude, longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    },
    toString: function()
    {
        return $(this.latitude, this.longitude).join(', ');
    }
};
Date.prototype.addMinutes=function(value)
{
var m=this.getTime();
m+=((value||0)*60*1000);
return new Date(m);
}

var dateToString = function(date, format) 
{
if (date=="undefined")return "";
if (date.toString()=="Invalid Date")return "";
    var year = '' + date.getFullYear();
    var month = ''+(date.getMonth() < 9 ? '0'+(date.getMonth()+1) : (date.getMonth()+1));
    var day = ''+(date.getDate() < 10 ? '0'+date.getDate() : date.getDate());
    var hours = ''+(date.getHours() < 10 ? '0'+date.getHours() : date.getHours());
    var minutes = ''+(date.getMinutes() < 10 ? '0'+date.getMinutes() : date.getMinutes());
    var retVal = format;
    retVal = retVal.replace('yyyy', year);
    retVal = retVal.replace('MM', month);
    retVal = retVal.replace('dd', day);
    retVal = retVal.replace('HH', hours);
    retVal = retVal.replace('mm', minutes);
return retVal;
}

var stringToDate = function(dateStr, format) 
{
if( dateStr.length == 0 )
  return null;
    try 
    {
        var startOfFullYear = format.indexOf('yyyy');
        var startOfMonth = format.indexOf('MM');
        var startOfDay = format.indexOf('dd');
        var startOfHours = format.indexOf('HH');
        var startOfMinutes = format.indexOf('mm');
        var mustBeMinimum = Math.max(startOfFullYear + 4,
        Math.max(startOfMonth + 2,
          Math.max(startOfDay + 2,
            Math.max(startOfHours, 
              Math.max(startOfMinutes, 0)))));
        if( dateStr.length < mustBeMinimum )
        return null;

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
    } 
    catch(e) 
    {
    }
return null;    
}

//получить цвет в формате #000000 
function getHexColor(color)
{
    if (/#[0-9a-fA-F]{6}/.test(color)) //#000000 format
    {
        return color;
    }
    else    //rgb(0,0,0) format
    {
        var result='';
        color.scan(/\d+/, function(match)
        {
        result+=parseInt(match[0]).toColorPart();
        });
        return '#'+result;             
    }
}
function getGPSDistance(point1,point2)
{
var earthRadius=6366707.02;
var a1=point1.la*Math.PI/180;
var b1=point1.lo*Math.PI/180;
var a2=point2.la*Math.PI/180;
var b2=point2.lo*Math.PI/180;
var result= Math.acos(Math.cos(a1)*Math.cos(b1)*Math.cos(a2)*Math.cos(b2) + 
            Math.cos(a1)*Math.sin(b1)*Math.cos(a2)*Math.sin(b2) + Math.sin(a1)*Math.sin(a2)) * earthRadius;
return result;
}

var DateTimeRanger = Class.create();
DateTimeRanger.prototype =
{
    initialize: function (prefix, options) {
        this.prefix = prefix;
        this.options = options;
        this.format = this.options.format || 'dd/MM/yyyy HH:mm';
        this.date_from = stringToDate(this.options.from, this.format) || new Date();
        this.date_to = stringToDate(this.options.to, this.format) || new Date();
        this.limit_from = this.date_from;
        this.limit_to = this.date_to;
        this.elapsed = 10;
        this.chaned = true;   //false;//для первого срабатывания

        var deltaMilliseconds = this.date_to.getTime() - this.date_from.getTime();
        this.minutes = (deltaMilliseconds / (1000 * 60)).toFixed(0);



        this.range_color = $(prefix + '_range_color');
        this.handle_from = $(prefix + '_handle_from'); //div-ы - бегунки
        this.handle_to = $(prefix + '_handle_to');
        this.textbox_from = $(prefix + '_textbox_from'); //textbox-ы с датой
        this.textbox_to = $(prefix + '_textbox_to');
        this.textbox_from.observe('change', this.onDateTimeFromChanged.bindAsEventListener(this));
        this.textbox_to.observe('change', this.onDateTimeToChanged.bindAsEventListener(this));

        this.dtp_from = new Gaia.DateTimePicker(this.textbox_from, { className: 'classic', hasTimePart: true, format: this.format, hasButton: null, onSelectionChanged: this.onDateTimeFromChanged.bindAsEventListener(this) });
        this.dtp_from.onClose = function () { this.textbox_from.check(); };
        this.dtp_to = new Gaia.DateTimePicker(this.textbox_to, { className: 'classic', hasTimePart: true, format: this.format, hasButton: null, onSelectionChanged: this.onDateTimeToChanged.bindAsEventListener(this) });
        this.dtp_to.onClose = function () { this.textbox_to.check(); };

        this.initSliders();
        this.slider.setValue(0, 0);
        this.slider.setValue(this.minutes, 1);
        new PeriodicalExecuter(this.onTick.bindAsEventListener(this), 0.1);
        this.autoUpdate = false;
        this.peAutoUpdate = new PeriodicalExecuter(function (pe) {
            this.minuteTick();
        } .bind(this), 60);
    },
    initSliders: function () {
        if (this.slider) {
            this.slider.dispose();
        }


        this.slider = new Control.Slider([this.prefix + '_handle_from', this.prefix + '_handle_to'], this.prefix + '_range', { axis: 'horizontal', range: $R(0, this.minutes), step: 1 });
        this.slider.options.onChange = this.onSlideOrChange.bindAsEventListener(this);
        this.slider.options.onSlide = this.slider.options.onChange;

        this.slider.setValue(this.minutes, 1);
        this.onDateTimeFromChanged();
    },
    disableAutoUpdate: function () {
        this.autoUpdate = false;
    },
    enableAutoUpdate: function () {
        this.autoUpdate = true;
    },
    minuteTick: function () {
        this.limit_to = this.limit_to.addMinutes(1);
        this.date_to = this.date_to.addMinutes(1);

        if (this.autoUpdate) {
            var deltaMilliseconds = this.limit_to.getTime() - this.limit_from.getTime();
            this.minutes = (deltaMilliseconds / (1000 * 60)).toFixed(0);

            new Effect.Opacity(this.prefix + '_ranger', { from: 1, to: 0.3, duration: 1.0, queue: 'abc' });
            new Effect.Opacity(this.prefix + '_ranger', { from: 0.3, to: 1, duration: 1.0, queue: 'abc' });

            this.initSliders();

            this.onDateTimeFromChanged();
            this.onDateTimeToChanged();

            $(this.prefix + '_gmiddle').update(dateToString(this.limit_from.addMinutes(this.minutes / 2), this.format)).highlight();
            $(this.prefix + '_gto').update(dateToString(this.limit_to, this.format)).highlight();
        }
    },
    getDeltaMinutes: function (d1, d2) {
        var m1 = d1.getTime() || 0;
        var m2 = d2.getTime() || 0;
        return (m1 - m2) / (1000 * 60);
    },
    updateColor: function () {
        var fromOffset = this.handle_from.offsetLeft;
        var toOffset = this.handle_to.offsetLeft;
        var left = fromOffset + 5 || 0;
        var width = toOffset - fromOffset - 5 || 0;
        width = (width > 0) ? width : 0;
        this.range_color.setStyle({ 'left': left + 'px', 'width': width + 'px' });

        if (toOffset - fromOffset <= 10) {
            this.range_color.hide();
        }
        else {
            this.range_color.show();
        }
    },
    onSlideOrChange: function (value) {
        this.date_from = this.limit_from.addMinutes(value[0]);
        this.textbox_from.value = dateToString(this.date_from, this.format);

        this.date_to = this.limit_from.addMinutes(value[1]);
        this.textbox_to.value = dateToString(this.date_to, this.format);

        this.updateColor();
        this.changed = true;
        this.elapsed = 10;
    },
    onDateTimeFromChanged: function () {
        if (this.textbox_from.value == 'undefined' || this.textbox_from.value == '' || this.textbox_from.value == null) return;
        var from = stringToDate(this.textbox_from.value, this.format);
        if (from >= this.limit_from && from <= this.limit_to) {
            this.slider.setValue(this.getDeltaMinutes(from, this.limit_from), 0);
        }
        else {
            this.textbox_from.value = dateToString(this.date_from, this.format);
        }
        this.changed = true;
        this.elapsed = 10;
    },
    onDateTimeToChanged: function () {
        if (this.textbox_to.value == 'undefined' || this.textbox_to.value == '' || this.textbox_to.value == null) return;
        var to = stringToDate(this.textbox_to.value, this.format);
        if (to <= this.limit_to && to >= this.limit_from) {
            this.slider.setValue(this.getDeltaMinutes(to, this.limit_from), 1);
        }
        else {
            this.textbox_to.value = dateToString(this.date_to, this.format);
        }
        this.changed = true;
        this.elapsed = 10;
    },
    onTick: function (pe) {
        if (!this.changed) return;
        if (this.elapsed == 0) {
            this.changed = false;

            try {

                this.onChange(this.textbox_from, this.textbox_to);

            } catch (e) { alert(e.toString()); throw e }

            this.elapsed = 10;
        }
        else {
            this.elapsed--;
        }
    },
    onChange: function (_from, _to) {
    }

}

var GraphicControl = Class.create();
GraphicControl.prototype =
{
    initialize: function (prefix, options) {
        this.prefix = prefix;
        this.options = options;
        this.x1 = 0;
        this.y1 = 0;
        this.x2 = 16;
        this.y2 = 16;
        this.date_formString = '';
        this.date_toString = '';

        //картинка
        this.img = $(this.prefix + '_gg');
        //реагируем на загрузку картинки
        this.img.observe('load', this.onGGLoaded.bind(this));

        //под зумом
        this.imgZoom = $(this.prefix + '_zg');
        //реагируем на загрузку картинки
        this.imgZoom.observe('load', this.onZGLoaded.bind(this));

        //было ли хоть одно выделение кропа
        this.firstCropDone = false;
        //изменился ли кроп
        this.changed = false;

        //сенсоры
        this.sensors = new Array();
        this.defineSensors();
        //реагируем на изменение checkbox
        $$('#' + this.prefix + '_sensors input').each(function (item, intex) {
            item.observe('click', this.onSensorsChanged.bindAsEventListener(this));
        } .bind(this));

    },
    attachCropper: function () {
        //cropper
        if (this.cropper != null) this.cropper.remove();
        if (!this.firstCropDone) {
            this.cropper = new Cropper.Img(this.img,
                { onEndCrop: this.onEndCrop.bind(this),
                    minWidth: 16, minHeight: 16, scroll: window
                });
        }
        else {
            this.cropper = new Cropper.Img(this.img,
                { onEndCrop: this.onEndCrop.bind(this),
                    minWidth: 16, minHeight: 16, scroll: window, displayOnInit: true,
                    onloadCoords: { x1: this.x1, y1: this.y1, x2: this.x2, y2: this.y2}
                });
        }
    },
    onDateChanged: function (textbox_from, textbox_to) {
        this.date_fromString = textbox_from.value;
        this.date_toString = textbox_to.value;

        this.updateGGraph();
    },

    onEndCrop: function (coords, dimensions) {

        if (this.x1 != coords.x1) this.changed = true;
        if (this.y1 != coords.y1) this.changed = true;
        if (this.x2 != coords.x2) this.changed = true;
        if (this.y2 != coords.y2) this.changed = true;
        this.x1 = coords.x1;
        this.y1 = coords.y1;
        this.x2 = coords.x2;
        this.y2 = coords.y2;

        if (this.changed) {
            this.firstCropDone = true;
            this.updateZGraph();
        }
        this.changed = false;
    },

    onGGLoaded: function () {
        new Effect.Opacity(this.img, { duration: 0.5, from: 0, to: 1,
            beforeStart: function () {
                this.img.setOpacity(0).show();
            } .bind(this)
        });

        setTimeout(function () { this.attachCropper(); } .bind(this), 100);
    },
    onZGLoaded: function () {
        new Effect.Opacity(this.imgZoom, { duration: 0.5, from: 0, to: 1,
            beforeStart: function () {
                this.imgZoom.setOpacity(0).show();
            } .bind(this)
        });
    },
    onSensorsChanged: function (event) {
        var sensor = Event.element(event);
        this.defineSensors();
        this.updateGGraph();
        this.updateZGraph();
    },
    defineSensors: function () {
        this.sensors = new Array();
        $$('#' + this.prefix + '_sensors input').each(function (item, index) {
            if (!item.checked) return;

            var color = item.next('label').getStyle('color');
            var labelColor = getHexColor(color);
            this.sensors.push(item.value + labelColor);
        } .bind(this));
    },
    updateGGraph: function () {
        if (this.cropper != null) {
            this.cropper.remove();
            this.cropper = null;
        }

        new Effect.Opacity(this.img, { duration: 0.5, from: 1, to: 0,
            afterStop: function () {
                this.img.hide();
            } .bind(this)
        });

        var query = { type: 1, from: this.date_fromString, to: this.date_toString,
            code: this.options.code, cache: (new Date()).getTime(), sensors: this.sensors
        };
        
        this.img.src = '/graphic.ashx?' + Object.toQueryString(query);

        //обновляем зум, если кроп-область выделена
        if (this.firstCropDone) this.changed = true;
    },
    updateZGraph: function () {
        new Effect.Opacity(this.imgZoom, { duration: 0.5, from: 1, to: 0,
            afterStop: function () {
                this.imgZoom.hide();
            } .bind(this)
        });

        var query = { type: 2, from: this.date_fromString, to: this.date_toString, code: this.options.code,
            x1: this.x1, y1: this.y1, x2: this.x2, y2: this.y2, cache: (new Date()).getTime(), sensors: this.sensors
        };
        
        this.imgZoom.src = '/graphic.ashx?' + Object.toQueryString(query);
    }
}
/*
//id карты должно быть prefix_map
var MapEngine = Class.create();
MapEngine.prototype =
{
    initialize: function (prefix, options) {
        this.map = null;
        this.prefix = prefix;
        this.IsReady = false;
        this.currentZoom = 3;
        document.observe('dom:loaded', function () {
            new PeriodicalExecuter(function (pe) {
                //check type GMap2
                if (typeof (GMap2) != "undefined") {
                    pe.stop();
                    this.initMap();
                }
            } .bind(this), 3);
        } .bind(this));
    },
    initMap: function () {
        if (GBrowserIsCompatible()) {
            this.map = new GMap2(document.getElementById(this.prefix + '_map'));
            this.map.setMapType(G_SATELLITE_MAP);
            this.map.setCenter(new GLatLng(52.262629, 104.26207), 4); //обязательно
            this.map.addControl(new GLargeMapControl());
            this.map.addControl(new GMapTypeControl());
            this.map.addControl(new GScaleControl());
            this.map.enableScrollWheelZoom();
            this.map.enableInfoWindow();
            GEvent.addListener(this.map, "zoomend", this.onZoomChange.bind(this));
            GEvent.addListener(this.map, "click", this.onMapClick.bind(this));

            GLatLng.prototype.getKey = function () { return this.lat() + '$' + this.lng() };

            this.IsReady = true;
            this.onLoad();
        } else {
            this.notCompatible();
        }
    },
    onZoomChange: function (prev, current) {
        this.currentZoom = current;
    },
    onMapClick: function (marker, click_point) {
    },
    notCompatible: function () {
    },
    onLoad: function () {
    },
    setCenter: function (lat, lng) {
        this.map.setCenter(new GLatLng(lat, lng), this.currentZoom);
    }
}
*/
var MapEngine3 = Class.create();
MapEngine3.prototype =
{
    initialize: function (prefix, options) {
        this.map = null;
        this.prefix = prefix;
        this.IsReady = false;
        this.currentZoom = 3;
    },
    initMap: function () {

            this.map = new google.maps.Map(document.getElementById(this.prefix + '_map'), {
                center: { lat: 52.262629, lng: 104.26207 },
                zoom: 8});             
            //this.map.setMapTypeId('SATELLITE');//HYBRID ROADMAP SATELLITE TERRAIN
            //this.map.setCenter(new google.maps.LatLng(52.262629, 104.26207));//{lat: -34, lng: 151}
            this.map.addListener("zoom_changed", function () { this.onZoomChange(); }.bind(this));
            this.map.addListener("click", function (objll) { this.onMapClick(objll.latLng); }.bind(this));
            google.maps.LatLng.prototype.getKey = function () { return this.lat() + '$' + this.lng() };

            this.IsReady = true;
            this.onLoad();
    },
    getBounds: function(){
        return this.map.getBounds();
    },
    onZoomChange: function () {
        this.currentZoom = this.map.getZoom();
        //alert('zoom' + this.currentZoom);
        this.gpsdm.onZoomChange();
    },
    onMapClick: function (ll) {
        //alert('map click' + ll.getKey());
        this.gpsdm.onMapClick(ll);
    },
    onLoad: function () {
    },
    setCenter: function (lat, lng) {
        this.map.setCenter(new google.maps.LatLng(lat, lng));
    }
}
var GPSPoint = Class.create();
GPSPoint.prototype =
{
    initialize: function (prefix, options) {
    }
}

var GPSDataManager = Class.create();
GPSDataManager.prototype =
{
    initialize: function (prefix, options) {
        this.prefix = prefix;
        this.options = options;
        this.format = this.options.format || 'dd/MM/yyyy HH:mm';
        this.me = new MapEngine3(prefix);
        this.me.gpsdm = this;
        this.me.notCompatible = function () {
            alert(this.invalidBrowser);
            $$('span.map-preload-title').each(function (loadText) {
                loadText.innerHTML = this.invalidBrowser;
            })
        }.bind(this);

        this.pTable = $(prefix + '_gpsTable');

        this.gpsMapBounds = $('gpsBounds');
        this.rowTemplate = new Template("<tr><td class='ts'>#{ts}</td><td>#{sd}</td><td class='small'>#{la} #{lo}</td><td>#{as}</td></tr>");
        this.eventMouseDown = this.startDrag.bindAsEventListener(this);
        this.eventMouseUp = this.endDrag.bindAsEventListener(this);
        this.eventMouseMove = this.onDrag.bindAsEventListener(this);

        //будет вызываться также каждый раз при появление в DOM "новой" pTable
        this.pTable.observe("mousedown", this.eventMouseDown);

        this.startTR = null;
        this.stopTR = null;

        this.points = new Hash(); // {id:,sd:,la:,lo:,as:,c:} 

        this.updatePanelID = ('mapTable');//.gsub('_', '$');
        //загружаем gpsTable, нажимаем на кнопку
        document.observe('dom:loaded', function () {
            // __doPostBack(this.updatePanelID,'');делается DateTimeRanger-ом
        } .bind(this));
    },
    onZoomChange: function () {
        this.gpsMapBounds.value = this.me.getBounds();
    },
    onMapClick: function (ll) {
        var point = this.points.get(ll.getKey());
        if (point)//"наша" точка
        {
            $(this.prefix + '_gpsTableContainer').scrollTop = $(point.row).offsetTop;
            $(point.row).highlight();
        }
    },
    refreshPage: function () {
        __doPostBack(this.updatePanelID, '');
    },
    clearPoints: function () {
        if (this.ptbody != 'undefined') {
            element = $(this.ptbody);

            element.descendants().each(function (elem) {
                Event.stopObserving(elem);
                elem.remove();
            });            
            element.update();

            this.points.each(function (point) {
                point.value.m.setMap(null);
                this.points.unset(point.key);
            }.bind(this));
        }
    },
    definePoints: function () {
        this.pTable = $(this.prefix + '_gpsTable');
        this.ptbody = this.pTable.down('TBODY');
        //try {
            
            
            this.pTable.observe("mousedown", this.eventMouseDown);
            //{ts:,sd:,la:,lo:,as:,c:} 

            var npString = $(this.prefix + '_gpsdata').innerHTML;
            var newpoints = eval(npString);
            $A(newpoints).each(function (point, index) {
                if (this.points.keys().indexOf(point.ts) < 0) {//если такой точки еще нет
                    this.points.set(point.ts, point);
                    point.p = new google.maps.LatLng(point.la, point.lo);
                    point.m = new google.maps.Marker({position: point.p,
                        map: this.me.map,
                        title: point.sd
                    });
                    point.m.setClickable(true);
                    point.m.addListener('click', function () {
                        $(this.tr).highlight();}.bind(point));

                    //добавление в таблицу
                    this.ptbody.insert({ top: this.rowTemplate.evaluate(point) });
                    point.tr = this.ptbody.down('tr');
                }
            }.bind(this));
            new Effect.Opacity(this.ptbody, { from: 0, to: 1, duration: 0.4 });
    },

    onDateChanged: function (textbox_from, textbox_to) {
        setTimeout(function () { __doPostBack(this.updatePanelID, ''); } .bind(this), 100);
    },

    startDrag: function (event) {
        var element = Event.element(event);
        if (element.descendantOf(this.pTable.down('TBODY'))) {
            this.startTR = element.tagName.toUpperCase() == 'TR' ? element : element.up('TR');
            //слушаем действия мышки мышки
            document.observe("mouseup", this.eventMouseUp);
            document.observe("mousemove", this.eventMouseMove);
        }
        var calc = $(this.prefix + '_gpsCalc');
        if (calc.visible()) {
            new Effect.Opacity(calc, { from: 1, to: 0, duration: 0.4, afterFinish: function () { calc.hide(); } });
        }
    },
    onDrag: function (event) {
        var element = Event.element(event);
        if (element.descendantOf(this.pTable.down('TBODY'))) {
            this.stopTR = element.tagName.toUpperCase() == 'TR' ? element : element.up('TR');
        }

    },

    endDrag: function (event) {
        var element = Event.element(event);
        if (element.descendantOf(this.pTable.down('TBODY'))) {
            this.stopTR = element.tagName.toUpperCase() == 'TR' ? element : element.up('TR');
        }

        //прекращаем слушать независимо от того на td остановились или нет
        Event.stopObserving(document, "mouseup", this.eventMouseUp);
        Event.stopObserving(document, "mousemove", this.eventMouseMove);
        //try {
            var startPoint = this.getPoint(this.startTR);
            var stopPoint = this.getPoint(this.stopTR);

            //исправляем выделение снизу вверх          
            if (startPoint.ts > stopPoint.ts) {
                var temp = stopPoint;
                stopPoint = startPoint;
                startPoint = temp;
            }
            if (startPoint.ts == stopPoint.ts) {
                this.me.map.setCenter(startPoint.p);
                $(this.startTR).highlight();
            } else {
                var arrowHeight = 14; //размер стрелки
                var startOffset = Position.positionedOffset(startPoint.row);
                var stopOffset = Position.positionedOffset(stopPoint.row);
                //считаем длинну тела стрелки
                var bodyHeight = (stopOffset.top + stopPoint.row.getHeight()) - (startOffset.top) - arrowHeight * 2 - 10;
                if (bodyHeight < 0) bodyHeight = 0;
                var calc = $(this.prefix + '_gpsCalc');
                var body = calc.down('td', 1);
                var info = calc.down('div.info');
                calc.setStyle({ top: startOffset.top + 'px', left: $(this.prefix + '_gpsTableContainer').getWidth() - 40 + 'px' });
                body.setStyle({ height: 0 + 'px' });


                new Effect.Parallel([
                    new Effect.Opacity(calc, { from: 0, to: 1 }),
                    new Effect.Tween(body, 0, bodyHeight, function (value) { body.setStyle({ height: value + 'px' }); })
                    ], { duration: 2, beforeStart: function () { calc.setOpacity(0).show(); }, afterFinish: function () { calc.show(); } }
                );
                var directDist = getGPSDistance(startPoint, stopPoint).toFixed(2);
                var text = this.betweenExtreme + ":<b>" + directDist + "</b><br/>";
                info.update(text);
                var sumDist = 0;
                var start = false; //флаг что старт точка выделения найдена
                var prevPoint = null;
                this.points.each(function (item, index) {
                    if (start) {
                        sumDist += getGPSDistance(prevPoint, item.value);
                        prevPoint = item.value;
                    } else {
                        if (item.key == startPoint.getKey()) {
                            start = true;
                            prevPoint = startPoint;
                        }
                    }
                    if (item.key == stopPoint.getKey()) throw $break;
                });
                text += this.sumBetweenExtreme + ":<b>" + sumDist.toFixed(2) + "</b>";
                info.update(text);
            }
        //}
        //catch (o) {
        //    alert(o + o.toString());
        //}

    },
    getPoint: function (tr) {
        var ts = tr.down('td').innerHTML;
        return this.points.get(ts);
    }
}    


var FileUploader=Class.create();
FileUploader.prototype =
{
    initialize: function (prefix, options) {
        this.prefix = prefix;
        this.container = $(this.prefix + "_fileWrap");

        this.filetype = options.filetype || 'file';

        var temp = new Template("<iframe frameborder='0' height='24px' marginheight='0' scrolling='no' width='100%' " +
        "src='about:blank' id='#{prefix}_frame' style='height:24px;width:100%;border:0;padding:0;margin:0;scrollbars:none;'></iframe>");

        this.container.update(temp.evaluate({ prefix: this.prefix }));
        this.frame = $(this.prefix + '_frame');

        if (this.frame.contentDocument) {
            this.doc = this.frame.contentDocument;
            this.win = this.frame.contentWindow; //this.frame.contentDocument.defaultView;
        } else if (this.frame.contentWindow) {
            this.doc = this.frame.contentWindow.document;
            this.win = this.frame.contentWindow;
        }
        this.doc = $(this.doc);
        this.doc.open();

        var temp = new Template("<html><body style='margin:0;padding:0;background-color:#{bg}'><form action='/file-upload.ashx?filetype=#{filetype}&action=upload' enctype='multipart/form-data' method='POST' id='#{prefix}_form' name='#{prefix}_form'><nobr>" +
        " " +
        "<input type='file' style='vertical-align:top;height:20px;width:#{inputFileWidth}' id='#{prefix}_file' name='#{prefix}_file' />" +
        "<a href='javascript:submit();'><img style='border:0;' src='/images/buttons/#{buttonCaption}' onmouseover=\"this.src='/images/buttonsover/#{buttonCaption}';\" onmousedown=\"this.src='/images/buttonsdown/#{buttonCaption}';\" onmouseout=\"this.src='/images/buttons/#{buttonCaption}';\" /></a> " +
        "</nobr></form></body></html>");
        this.doc.write(temp.evaluate({ filetype: this.filetype, prefix: this.prefix, buttonCaption: options.buttonCaption, inputFileWidth: options.inputFileWidth, bg: options.backgroundColor }));
        this.doc.close();
        this.file = $(this.doc.getElementById(this.prefix + '_file'));
        this.form = $(this.file.form);
        this.win.submit = this.onClick.bind(this);
        this.win.onscroll = function () { this.scrollTo(0, 0); } .bind(this.win);

    },
    onClick: function () {
        this.fileName = this.file.value;
        if (this.fileName == 'undefined') return;
        if (this.fileName.indexOf('/') > -1) {
            this.fileName = this.fileName.substring(this.fileName.lastIndexOf('/') + 1, this.fileName.length);
        } else {
            this.fileName = this.fileName.substring(this.fileName.lastIndexOf('\\') + 1, this.fileName.length);
        }
        if (this.fileName.strip().length == 0) return;

        setTimeout(this.afterSubmit.bind(this), 100);
        this.form.action += '&name=' + this.fileName;
        this.form.submit();
    },
    afterSubmit: function () {
        this.frame.hide();

        var temp = new Template("<img src='/images/wait.gif' /> #{fileName} <span id='#{prefix}_status'></span>");
        new Insertion.Bottom(this.container, temp.evaluate({ prefix: this.prefix, fileName: this.fileName }));
        this.status = $(this.prefix + "_status");
        this.allowNext = true;
        new PeriodicalExecuter(function (pe) {
            if (this.stop) { pe.stop(); return; }
            if (this.allowNext) {
                new Ajax.Request('/file-upload.ashx',
            { method: 'get', parameters: { filetype: this.filetype, action: 'status', name: this.fileName, rnd: Math.random() }, onComplete: this.onAjaxUpdate.bind(this) });
            }
            this.allowNext = false;

        } .bind(this), 2);
    },
    onAjaxUpdate: function (transport) {
        this.allowNext = true;
        var json = eval(transport.responseText);
        if (transport.status == 200 && json) {
            if (json.status == 'complete') {
                this.stop = true;
                this.container.update(this.fileName);
                this.onComplete(json.url);
            }
            else if (json.status == 'error') {
                this.stop = true;
                this.container.update('Error' + json.text);
            }
        }
    },
    onComplete: function (relativeURL) {

    }
}
var Button=Class.create();
Button.prototype = 
{
    initialize: function(container, text, options) 
    {
        this.container=$(container);
        this.text=text||'Button';
        if (options=='undefined')options={};
        if (options.onClick)this.onClick=options.onClick;
        this.id=this.container.id + '_'+(options.id||Math.round(Math.random()*1000));
        var tmp = new Template("<a href='#'id='#{id}' class='button'><img src='/images/buttons/#{text}' alt='#{text}' /></a>");
        new Insertion.Bottom(this.container, tmp.evaluate({id:this.id, text:this.text}));
        this.a=this.container.down('a#'+this.id);
        this.img=this.a.down('img');
        this.img.observe('mouseover',this.onMouseOver.bind(this));
        this.img.observe('mouseout',this.onMouseOut.bind(this));
        this.img.observe('mousedown',this.onMouseDown.bind(this));
        this.a.observe('click', this._onClick.bindAsEventListener(this));
    },
    _onClick:function(event)
    {
        try{this.onClick(event);}catch(e){alert(e)};
    },
    onMouseOver:function()
    {
        this.img.src='/images/buttonsover/'+this.text;
    },
    onMouseOut:function()
    {
        this.img.src='/images/buttons/'+this.text;
    },
    onMouseDown:function()
    {
        this.img.src='/images/buttonsdown/'+this.text;
    },
    setText:function(text)
    {
        this.text=text;
        this.onMouseOut();
    }
}
var ContactListManager=Class.create();
ContactListManager.prototype = 
{
    initialize: function(src, dst, options) 
    {
        this.src=$(src);
        this.dst=$(dst);
        Droppables.add(this.dst,{hoverclass: 'ready-to-trash', onDrop: this.onAdd.bind(this) });
    },
    onAdd: function(card)
    {
        new Effect.Shrink(card, {queue: 'front', afterFinish:function()
        {
            new Insertion.Top(this.dst, card);  
            new Effect.Grow(card, {queue: 'front',afterFinish:function(){card.setOpacity(1);}});                
        }.bind(this)}); 
        var id=card.down('.classic_nw span');
        this.action.value='add#'+id.innerHTML;
        var cardItem=this.cards.get(id.innerHTML);
        //cardItem.cardDrag.destroy();
        cardItem.button.setText(this.removeText);     
        cardItem.button.onClick=function(event)
        {
            this.onRemove(card);
            Event.stop(event);
        }.bind(this);
        __doPostBack(this.contactsUpdater.id.gsub('_','$'),'');
    },
    onRemove: function(card)
    {
        //do not use this.cards!
        var id=card.down('.classic_nw span');
        this.action.value='remove#'+id.innerHTML;
        new Effect.Shrink(card, {afterFinish:function(){card.remove();}});
        __doPostBack(this.contactsUpdater.id.gsub('_','$'),'');
    },
    initDragDrops: function()
    {
        this.cards=$H();
        new Effect.Appear(this.src.down('div'));
        $(this.searchButtonID).observe('click',function(){new Effect.Fade(this.src.down('div'), {queue:'hideshow'});}.bind(this));
        $$('#'+this.src.id+' .icard').each(function(card)
        {
            var cardItem={};
            /*cardItem.cardDrag = new Draggable(card , {handle: 'classic_top_draggable', revert:true, 
            scroll:this.src.id, onStart: this.onStartDrag.bind(this), onEnd: this.onEndDrag.bind(this)});*/
            cardItem.button = new Button(card.down('.classic_content'),this.addText,{onClick:function(event){this.onAdd(card);Event.stop(event);}.bind(this)});
            this.cards.set(card.down('.classic_nw span').innerHTML, cardItem);
        }.bind(this));
    },
    initUserList:function()
    {
        $$('#'+this.dst.id+' .icard').each(function(card)
        {
            new Button(card.down('.classic_content'),this.removeText,{onClick:function(event){this.onRemove(card);Event.stop(event);}.bind(this)});      
        }.bind(this));        
    },
    onStartDrag: function (dragObj,event)
    {
       $$('#'+this.src.id+' .icard').each(function(card){
            if (card==dragObj.element)return;
            card.hide();
        });
       this.src.addClassName('no-overflow-hide');    
    },
    onEndDrag: function (dragObj,event)
    {
        this.src.removeClassName('no-overflow-hide');
        $$('#'+this.src.id+' .icard').each(function(card){
            if (card==dragObj.element)return;
            card.show();
        });
    }
}    