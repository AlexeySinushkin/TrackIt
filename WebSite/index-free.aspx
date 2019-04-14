<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index-free.aspx.cs" Inherits="TrackIt.Website.indexfree" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Track It - Отслеживание</title>
    <meta name="verify-v1" content="gN7GrPgQhQBoeMn1yjvomX2jc2eBOBXJIrL/BFH5aa0=" />
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta name="keywords" content="отслеживание, логистика, телеметрия, состояние груза, перевозка груза, перевозка, температура, влажность, GPS, ГЛОНАСС" /> 
    <meta name="description" content="Служба отслеживания груза - климматическое состояние, географическое положешние, логистика" /> 
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />

        <script type="text/javascript">
            function addCss(fileName) {
                css = document.createElement('link');
                css.setAttribute('rel', 'stylesheet');
                css.setAttribute('type', 'text/css');
                css.setAttribute('href', fileName);
                document.getElementsByTagName('head')[0].appendChild(css);
            }
            function addJs(src) {
                var js = document.createElement("script");
                js.setAttribute("type", "text/javascript");
                js.setAttribute("src", src);
                document.getElementById('temp_container').appendChild(js);
            }
            function addImg(src) {
                var img = new Image(1, 1);
                img.src = src;
                document.getElementById('temp_container').appendChild(img);
            }
    </script>
    <% if (firstLoad)
       { %>
       <style type="text/css" >
        <%= GetLightStyle() %>
       </style>
    <%}
       else
       { %>
       
        <link rel="Stylesheet" type="text/css" href="/App_Themes/style.css" />        

        <script type="text/javascript" src="/scripts/prototype.js"></script>   
        <script type="text/javascript" src="/scripts/Menu.js"></script>        
        <script type="text/javascript" src="/scripts/effects.js"></script>  
        <script type="text/javascript" src="/scripts/dragdrop.js"></script>  
        <script type="text/javascript" src="/scripts/Control.js"></script>      
        <script type="text/javascript" src="/scripts/slider.js"></script> 
        <script type="text/javascript" src="/scripts/cropper.js"></script>     
        <script type="text/javascript" src="/scripts/common.js"></script>
        <script type="text/javascript" src="/scripts/WebControl.js"></script>  
        <script type="text/javascript" src="/scripts/ContainerWidget.js"></script>     
        <script type="text/javascript" src="/scripts/Panel.js"></script>          
        <script type="text/javascript" src="/scripts/DraggablePanel.js"></script>          
        <script type="text/javascript" src="/scripts/controls.js"></script>
        <script type="text/javascript" src="/scripts/builder.js"></script>
        <script type="text/javascript" src="/scripts/Skinnable.js"></script> 
        <script type="text/javascript" src="/scripts/TextBox.js"></script>
        <script type="text/javascript" src="/scripts/Window.js"></script> 
        <script type="text/javascript" src="/scripts/ru-RU/DateTimePicker.js"></script> 
        <script type="text/javascript" src="/scripts/AutoCompleter.js"></script>
        
    <% }%>
    <%=GetPageStyle()%>
    <style type="text/css">
    .slogan
    {
	    background-image: url(/images/ru-RU/caption.<%=pageName %>.gif);
    }
    </style>
</head>
<body onload="pageLoaded();">

<div id="temp_container" style="display:none;" ></div>
<form id="form1" runat="server">
    <asp:ScriptManager ID="sm" runat="server" EnablePartialRendering="true" ScriptMode="Release" EnableScriptGlobalization="true"
    EnableScriptLocalization="true" EnablePageMethods="true">
    </asp:ScriptManager>
<table class="top" cellpadding="0" cellspacing="0">
<tr>
    <td class="left">
        <div class="captchaimei" style="opacity:0.2">
       <BotDetect:WebFormsCaptcha runat="server" ID="IMEICaptcha"
            UserInputControlID="IMEICaptchaTextBox" /></div>
    </td>
    <td class="right">
          <dl class="form login-free">
            <dd>
                Код с картинки
            </dd>
            <dt class="tbox">
                <asp:TextBox ID="IMEICaptchaTextBox" runat="server"
                    onkeypress="submitOnEnter(event)"></asp:TextBox>
            </dt>
            <dd>
                IMEI
            </dd>
            <dt class="tbox">
                <control:textBox ID="TextBoxIMEI" runat="server"
                    onkeypress="submitOnEnter(event)"></control:textBox>
            </dt>
            <dd></dd>
            <dt>            
                <control:button ContentKey="MainFree$Enter" DefaultText="Войти" ID="EnterButton"
            runat="server" OnClick="OnUpIMEIClick"  OnClientClick="javascript:buttonLoginClick();"/>
                <input type="hidden" name="timeZone" id="timeZone" />
                    <script type="text/javascript">
                        function buttonLoginClick() {
                            x = new Date()
                            // Вычислим значение смещения текущего часового пояса в часах
                            currentTimeZoneOffsetInHours = -x.getTimezoneOffset() / 60;
                            $('timeZone').value = currentTimeZoneOffsetInHours;
                        }
                        function submitOnEnter(event) {
                            if (event.keyCode == 13) {
                                buttonLoginClick();
                                document.getElementById('form1').submit();
                            }
                        }
                        addImg('/images/buttonsover/<%=cm.Get("LoginControl$LogIn", "Войти")%>');
                    addImg('/images/buttonsdown/<%=cm.Get("LoginControl$LogIn", "Войти")%>');

                    </script>
                    <span class="error" id="loginErrorMessage" style="position:relative;z-index:1;top:-25px;
left:-200px;background-color:White;display:block;border:2px;" onmouseover="this.style.display='none';"><%=ErrorMessage %></span>
                    </dt>
        </dl>
    </td>
</tr>
</table>

<div class="middle">
    <div class="left">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td class="left-rez">
                &nbsp;<!--IE-->
                </td>
                <td valign="top" class="left-content">
                    <div class="slogan">
                    </div>
                    <div class="slogan-info">
                        
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div class="right">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td id="trailer_foto" class="right-content">                
                </td>
                <td class="right-rez">
                &nbsp;<!--IE-->
                </td>
            </tr>
        </table>
    </div>
</div>

<div class="bottom-container">


             
             

<table class="bottom" cellpadding="0" cellspacing="0" id="bottom">
<tr>
<td class="left dark">
    <div class="shadow-horizont"></div>
    <div class="container">
        <div class="content">
            <p>Track It - это бесплатный сервис по сбору данных о 
                        местоположение смартфона, мото сигнализации и любого устройства 
                        поддерживающего <a href="/gate-free.asmx">протокол</a> работы</p>
            <p>Мы не спрашиваем как Вас зовут и другие персональные данные.
                Для идентификации используется IMEI вашего смартфона. Для того чтобы узнать 
                IMEI нужно набрать *#06#
            </p>
            <p>
                Для того чтобы данные начали появляться нужно установить приложение <a href="https://play.google.com/store/apps/details?id=ru.track_it.trackit">TrackIt</a> из
                Google Play Market<a href="/view-free.aspx?testing=1">.</a>
            </p>
        </div>
    </div>
</td>
<td class="shadow">
</td>
<td class="right bright">
    <div class="container">
        <div class="content">
          
        </div>
    </div>
</td>
</tr>
</table>


</div>

<div class="footer-container">
<table class="footer" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td>
            <div class="left dark">
                <%DateTime.Now.Year.ToString();%>
                &copy;Алексей Синюшкин 861187030982469

            </div>
        </td>
        <td>
            <div class="right bright">
            <asp:UpdatePanel ID="UpdatePanel1"  runat="server" UpdateMode="Always">
                <ContentTemplate>
            Время выполнения: <%=GetMilliseconds()%> мс.
            </ContentTemplate></asp:UpdatePanel>
            <span style="display:none;"><%=DateTime.UtcNow.ToString() %></span>
            </div>
        </td>
        <td><div style="width:12px"></div></td>        
    </tr>
</table>
</div>
</form>

<div style="position:absolute;z-index:1;margin-bottom:20px;left:40%;" id="please_wait"><%=cm.Get("index$PleaseWait","Пожалуйста дождитесь полной загрузки страницы.")%></div>


    <script type="text/javascript" src="/scripts/prototype.js"></script>    
    <script type="text/javascript" src="/scripts/Menu.js"></script>    
    <script type="text/javascript" src="/scripts/effects.js"></script>    
     
<script type="text/javascript">
    function pageLoaded() {
        $("please_wait").hide();
        new Effect.Appear($$("div.captchaimei")[0], {
            duration: 2, from: 0.2, to: 1.0, afterFinish: function () {
                var s = $$('a.BDC_SoundLink')[0];
                $('temp_container').appendChild(s);
            }
        });
        
    }
</script>

    <script type="text/javascript">
        var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
        document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
    </script>
    <script type="text/javascript">
        try {
            var pageTracker = _gat._getTracker("UA-8146792-1");
            pageTracker._trackPageview();
        } catch (err) { }
    </script>   


<script type="text/javascript">
    var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
    document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
    try {
        var pageTracker = _gat._getTracker("UA-8146792-1");
        pageTracker._trackPageview();
    } catch (err) { }
</script>

</body>

</html>
