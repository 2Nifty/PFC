<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RTSMenu.aspx.cs" Inherits="ReadyToShip_RTSAdminPage" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Goods En Route - Ready to Ship</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
    function ToolTip(Item,evt)
    {	   
//	    document.getElementById("ToolTip").style.top = evt.clientY+offY;
//	    document.getElementById("ToolTip").style.left = evt.clientX+offX;
//	    if(evt.type == "mouseover") {
//		    document.getElementById("ToolTip").innerText = Item.alt;
//		    document.getElementById("ToolTip").style.display = 'block';
//	    }
//	    if(evt.type == "mouseout") {
//		    document.getElementById("ToolTip").style.display = 'none';
//	    }
    }
    
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <table width="100%">
            <tr>
                <td>
                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                </td>
            </tr>
            <%--  <tr>
                <td valign="middle" class="PageHead" colspan=2>
                    <span class="Left5pxPadd">
                        <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Goods En Route - Ready to Ship"></asp:Label></span>
                </td>
            </tr>--%>
             <tr>
                                        <td class="TabHeadBk" width="100%" style="height: 30px">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                <tr>
                                                    <td width="16">
                                                        <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                    <td>
                                                        <strong class="redtitle2">Goods En Route - Ready To Ship</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
            <tr>
                <td valign="top" class="LoginFormBk" width="100%">
                    <table width="100%" border="0" cellspacing="2" cellpadding="10" id="table2">
                        <tr valign="top">
                            <td class="BlueBorder" width="100%">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                   
                                    <tr>
                                        <td id="5TD" class="blackTxt" width="100%">
                                            <p align="left" class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp;
                                                <asp:LinkButton runat="server" ID="lnkRTSAdmin" Text="Ready To Ship Administration"
                                                    OnClick="lnkRTSAdmin_Click" Visible="False"></asp:LinkButton>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp;<a href="#"
                                                    onclick="window.open('RTSVendorUpload.aspx','Upload','height=710,width=1020,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');"
                                                    id="x" alt="Import Vendor Ready to Ship Excel File" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Import Vendor Ready to Ship Excel File</a>
                                               </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp;<a href="RTSCalcRecommend.aspx"
                                                    id="A1" alt="Run Recommended Ready to Ship Calculation" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Run Recommended Ready to
                                                Ship Calculations</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp;<a href="#"
                                                    onclick="window.open('RTSRecommendations.aspx','Order','height=710,width=1020,scrollbars=yes,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');"
                                                    id="A2" alt="Review Ready to Ship Recommendations" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Review Ready to Ship Recommendations</a></p>
                                            <p class="10pxPadding">
                                                <a alt="Review Ready to Ship Summary Page" href="#" onmouseout="ToolTip(this,window.event);"
                                                    onmouseover="ToolTip(this,window.event);"></a>
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp;<a href="#"
                                                    id="A3" onclick="window.open('RTSShipSummary.aspx','RTSShipSummary','height=680,width=1020,scrollbars=no,location=no,status=no,top=0,left='+((screen.width/2) - (1020/2))+',resizable=no','');"
                                                    alt="Review Ready to Ship Summary Page" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Review Ready to Ship Summary Page</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp;<a href="#"
                                                   onclick="window.open('RTSVendorAdvice.aspx','Advice','height=710,width=1020,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');"
                                                   id="A4" alt="Review vendor Advice" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Review\Export to Excel Ready to Ship
                                                    Vendor Advice Page</a></p>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                          
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
