<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
    
    var offX = 5;
    var offY = 10;
    function ToolTip(Item,evt)
    {	   
	    document.getElementById("ToolTip").style.top = evt.clientY+offY;
	    document.getElementById("ToolTip").style.left = evt.clientX+offX;
	    if(evt.type == "mouseover") {
		    document.getElementById("ToolTip").innerText = Item.alt;
		    document.getElementById("ToolTip").style.display = 'block';
	    }
	    if(evt.type == "mouseout") {
		    document.getElementById("ToolTip").style.display = 'none';
	    }
    }
    
    function StartReport()
    {
		    var BOL = document.getElementById("BOL").value;
		    var pageURL = "../GER/GERReconcileReport.aspx?RunType=Single&BOL=" + BOL;
            window.open(pageURL,"GERRec" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
    }    

    function ClosePage()
    {
        if(parent.bodyframe!=null)
            parent.bodyframe.location.href="../GER/GERReconcileMenu.aspx";	
    }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="ToolTip" style="font-family: arial; size: 11px; display: none; position: absolute;
            background-color: #ffffcc; border: 1px solid #666666; padding: 0px 5px 0px 5px;
            layer-background-color: #ffffcc;" zindex="1">
            &nbsp;</div>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" id="table1">
            <tr>
                <!-- <td valign="middle" background="../Common/Images/inbannerbk.jpg"><img src="../Common/Images/dashboardBanner.jpg"  ></td>-->
                <td colspan="2">
                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                </td>
            </tr>
            <tr>
                <td valign="middle" class="PageHead">
                    <span class="Left5pxPadd">
                        <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="GER to AP Reconciliation Report"></asp:Label></span>
                </td>
                <td align="right" class="PageHead">
                     <img src="../Common/Images/close.gif" onclick="ClosePage();">&nbsp;&nbsp;
               </td>
            </tr>
            <tr>
                <td valign="top" colspan="2">
                    <table border="0" cellspacing="2" cellpadding="2" id="table2">
                        <tr valign="top">
                            <td  class="Left5pxPadd"><b>Bill of Lading</b><br />
                                <asp:TextBox ID="BOL" runat="server"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr class="BluBg"><td colspan="2" class="Left5pxPadd">
                <img src="../Common/Images/viewReport.gif" onclick="StartReport();">&nbsp;&nbsp;
                <img src="../Common/Images/help.gif">&nbsp;&nbsp;
            </td></tr>
        </table>
    </form>
    <script>
    document.getElementById("BOL").focus();
    </script>
</body>
</html>
