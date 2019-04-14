<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="sinushkin's-boiler.aspx.cs" MasterPageFile="~/MasterCenterDark.Master" Inherits="TrackIt.Website.sinushkin_s_boiler" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">
<%=cm.Get("SB$Title", "Котёл Синюшкин")%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="preface" runat="server">
    <iframe id="ytplayer" type="text/html" width="790" height="460"
src="https://www.youtube.com/embed/xOqLAy4WYRU"
frameborder="0" style="position:absolute; z-index:10" allowfullscreen>
        </iframe>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bc" runat="server">
    <div style="height:360px; float:none"></div>
    Пока блок управления не готов.
</asp:Content>

