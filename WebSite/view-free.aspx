<%@ Page Language="C#"  MasterPageFile="~/MasterDarkBright.Master" AutoEventWireup="true" CodeBehind="view-free.aspx.cs" Inherits="TrackIt.Website.view_free" EnableEventValidation="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">
<%=cm.Get("ViewFree$Title", "Отслеживание устройства")%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="preface" runat="server">
IMEI/SN: <%=device.SerialAsString %><br />
<!--Часовой пояс: < %=GetTimeZoneName() %>-->

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bleft" runat="server">


<table width="100%">
<caption>
    <%=cm.Get("ViewTrackControl$ViewPointsMode","Показывать точки")%>:</caption>
<tr>
    <td rowspan="2">
        <control:radio runat="server" ID="map_desc" DefaultValue="1" CssClass="gps-paging-type"
            OnSelectedIndexChanged="OnGPSPagingChange" onchange="onMapDescChange(this);" SelectedValue="1">
            <Items>
                <control:radioItem ID="RadioItem1" Value="1" runat="server">
                    <Text>
                        <%=rowsAtPage.ToString()%> <%=cm.Get("ViewTrackControl$CountPerPage","штук на странице")%>
                    </Text>                    
                </control:radioItem>
                <control:radioItem ID="RadioItem2" Value="2" runat="server">
                    <Text>
                        <%=cm.Get("ViewTrackControl$All","все")%></Text>
                </control:radioItem>
            </Items>
        </control:radio>
    </td>
    <td>
        <asp:CheckBox ID="filterStandPoints" runat="server" onchange="onFilterStandPoints();" />
        <label for="<%=filterStandPoints.ClientID%>">
            <%=cm.Get("ViewTrackControl$FilterStandPoints","Фильтровать точки стояния")%></label>
    </td>
</tr>
</table>
<control:UPanel runat="server" ID="mapTable"  ClientIDMode="Static"
     ChildrenAsTriggers="true" UpdateMode="Conditional">
<ContentTemplate>
<div style="display:none">
    <div id="<%=this.ClientID%>_gpsdata"><%=GetGPSJSON()%></div>
</div>              
</ContentTemplate>
</control:UPanel>
<!--UpdatePanel-->      
<div id="<%=this.ClientID%>_gpsProgress" style="display: none;">
</div>
<asp:HiddenField ID="gpsPage"  runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="gpsBounds" runat="server" ClientIDMode="Static"  />
<div class="gps-pager">
    <asp:PlaceHolder ID="gpsPaging" runat="server" EnableViewState="false" />
</div>
<div class="gps-table-container" id="<%=this.ClientID%>_gpsTableContainer">
<table class="gps-calculator" style="display: none;" id="<%=this.ClientID%>_gpsCalc">
    <tr>
        <td class="up">
        </td>
    </tr>
    <tr>
        <td class="gps-calc-body">
            &nbsp;<div class="FFBug">
                <div class="info">
                </div>
            </div>
        </td>
    </tr>
    <tr>
        <td class="down">
        </td>
    </tr>
</table>
<table class="formtable gps-table" id="<%=this.ClientID%>_gpsTable">
    <thead>
        <tr>
            <th class="ts"></th>
            <th>
                <%=cm.Get("ViewTrackControl$DateAndTime","Дата и время")%>
            </th>
            <th>
                <%=cm.Get("ViewTrackControl$Latitude","Широта")%> 
                <%=cm.Get("ViewTrackControl$Longitude","Долгота")%>
            </th>
            <th>
                Событие/Состояние
            </th>
        </tr>
    </thead>
    <tbody>
    </tbody>
    <% if (gpsPoints == null || gpsPoints.Length == 0)
    { %>
    <tfoot>
        <tr>
            <td colspan="3">
                <%=cm.Get("ViewTrackControl$NotFound", "Нет точек для отображения")%>
            </td>
        </tr>
    </tfoot>
    <%}%>
</table>
</div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="bright" runat="server">
    <div class="map_wrap" id="<%=this.ClientID%>_map">
                <span class="map-preload-title">
            <%=cm.Get("ViewTrackControl$MapPreload", "Карта загружается. Пожалуйста подождите.")%></span>
        <img src="/images/3f3.jpg" style="width:100%;height:100%" alt="map" />

    </div>
        <script type="text/javascript">

            var gps;//gps.me MapEngine gps.me.map GoogleMap
            function initMap() {
                //инициализация работы GPS
                gps = new GPSDataManager('<%=this.ClientID%>', { format: 'dd/MM/yyyy HH:mm' });
                gps.betweenExtreme = '<%=cm.Get("ViewTrackControl$BetweenExtreme","Расстояние между крайними точками (по прямой)",true )%>';
                gps.sumBetweenExtreme = '<%=cm.Get("ViewTrackControl$SumBetweenExtreme","Сумма расстояний между смежными точками",true)%>';
                gps.invalidBrowser = '<%=cm.Get("ViewTrackControl$MapBrowserInvalid", "Ваш браузер не способен загрузить карту...")%>';
                gps.me.initMap();
                highlightPage(1);
                gps.definePoints();
            }

            function onMapDescChange() {
                if ($('<%=map_desc.ClientID%>_1').getValue() == 1) {//bleft_map_desc_1
                    $$('div.gps-pager').each(function (elem) {
                        elem.show();
                    });
                } else {
                    $$('div.gps-pager').each(function (elem) {
                        elem.hide();
                    });
                }
                new Effect.Opacity(gps.pTable.down('TBODY'), { from: 1, to: 0, duration: 0.4 });                
                gps.refreshPage();
            }
            function onFilterStandPoints() {
                new Effect.Opacity(gps.pTable.down('TBODY'), { from: 1, to: 0, duration: 0.4 });
                gps.refreshPage();
            }
            function changePage(pageNumber) {
                new Effect.Opacity(gps.pTable.down('TBODY'), { from: 1, to: 0, duration: 0.4 });
                highlightPage(pageNumber);
                $('gpsPage').value = pageNumber;
                gps.refreshPage();
            }
            function highlightPage(pageNumber) {
                try {
                    $$('div.gps-pager a').each(function (elem) {
                        elem.setStyle({ 'border-color': '#43595f' });
                    });
                    $('gpsPage_' + pageNumber).setStyle({ 'border-color': '#fea355' });
                } catch (ex) {
                }
            }
    </script>
    <script async defer
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCUuI4OUZJV8NvcF2psvRG3VBqgWS1HsIc&callback=initMap">
    </script>
</asp:Content>
