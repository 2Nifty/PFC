<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MRPMenu.aspx.cs" Inherits="MRPMenuPage" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MRP Menu</title>
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
                                                        <strong class="redtitle2">MRP Menu</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
            <tr>
                <td valign="top" class="LoginFormBk" width="100%">
                    <table width="100%" border="0" cellspacing="2" cellpadding="10" id="table2">
                        <tr valign="top">
                            <td class="BlueBorder" width="50%">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                   
                                    <tr>
                                        <td id="5TD" class="blackTxt" width="100%">
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp;<a href="#"
                                                   onclick="window.open('ProcessMaint.aspx','ProcessMaint','scrollbars=no,location=no,status=no,resizable=yes','');"
                                                   id="A9" alt="Category Filter Maintenance" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Process Maintenance</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp;<a href="#"
                                                   onclick="window.open('CatFilterMaint.aspx','CatFilterMaint','scrollbars=no,location=no,status=no,resizable=yes','');"
                                                   id="A3" alt="Category Filter Maintenance" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Category Filter Maintenance</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp;<a href="#"
                                                   onclick="window.open('StepMaint.aspx','StepMaint','scrollbars=no,location=no,status=no,resizable=yes','');"
                                                   id="A2" alt="Step Maintenance" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Process Step Maintenance</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp;<a href="#"
                                                   onclick="window.open('VelCodeMaint.aspx','VelCodeMaint','scrollbars=no,location=no,status=no,resizable=yes','');"
                                                   id="A1" alt="Step Maintenance" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Velocity Code Maintenance</a></p>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td class="BlueBorder" width="50%">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                   
                                    <tr>
                                        <td id="Td1" class="blackTxt" width="100%">
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp;<a href="#"
                                                   onclick="window.open('Processor.aspx','Processor','scrollbars=no,location=no,status=no,resizable=yes','');"
                                                   id="A4" alt="Run an MRP Process" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Run A Process</a></p>
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
