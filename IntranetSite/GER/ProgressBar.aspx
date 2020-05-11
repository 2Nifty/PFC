<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ProgressBar.aspx.cs" Inherits="ProgressBar" %>
<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Goods En Route</title>    
    <script>
    function showProgress()
    {
        document.getElementById("iFrame1").height = document.documentElement.clientHeight ;
        document.getElementById("Progress").style.left = document.documentElement.clientWidth/2 - document.getElementById("Preloader").width/2;
        document.getElementById("Progress").style.top = document.documentElement.clientHeight/2 - document.getElementById("Preloader").height/2;
        document.getElementById("Progress").style.display ="block";
        
        
        var url="<%=Request.QueryString["destPage"]%>";
		document.getElementById("iFrame1").src = url; 
        
    }</script>
</head>
<body onload="showProgress()" style="margin:0px">
    <form id="form1" runat="server" >
    <div>
        <table cellpadding=0 cellspacing=0 width=100% >
              <tr>
                <td valign=top>
                    <div id="Progress" zindex="100" style="position:absolute;layer-background-color:#000000; text-align=center">
                        <img id="Preloader" src="../Common/Images/Preloader.gif" width="214" height="21"/>
                    </div>
                    <iframe id="iFrame1" name="iFrame1"  src="" width="100%" height="600" scrolling=no frameborder=0 marginheight=0 marginwidth=0 ></iframe>
                </td>
              </tr>
         </table>
    </div>
    </form>
</body>
</html>
