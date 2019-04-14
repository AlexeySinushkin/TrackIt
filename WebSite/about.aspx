<%@ Page Language="C#" MasterPageFile="~/MasterDarkBright.Master" AutoEventWireup="true" CodeBehind="about.aspx.cs" Inherits="TrackIt.Website.about" EnableEventValidation="false" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">
<%=cm.Get("About$Title", "О проекте")%>
</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">

</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="preface" runat="server">


</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="bleft" runat="server">
<div class="title"><h3></h3></div>
<p>Сервис по быстрому и бесплатному сохранению геоданных. Данные хранятся 3 дня.</p>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="bright" runat="server">
    <div style="display:block; float:left; clear:right">
<dl class="form">
<dd>e-mail:</dd>
<dt>sinushкin_aleхey@mail.ru</dt>
<dd>ICQ:</dd>
<dt>462-251-289</dt>
<dd>Телефон:</dd>
<dt>+7 924 751 56 84</dt>
</dl>
        </div>
<div>
*адрес почты не копировать, а печатать вручную.</div>
</asp:Content>

<asp:Content ID="Content7" ContentPlaceHolderID="scripts" runat="server">
    <script type="text/javascript">

    </script>
</asp:Content>