<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SOE</title>
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
   
    function LoadPage(report)
    {
        switch (report)
        {
            case "IR": 
		        window.open('InvoiceRegister.aspx' ,'Order','height=700,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");	
		    break;	
            case "IRCSRFilter": 
			    window.open('InvoiceRegisterCSRFilter.aspx' ,'Order','height=700,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");	
		    break;
		    case "IRFilterTbl": 
			    window.open('InvoiceRegisterFilterTable.aspx' ,'Order','height=700,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");	
		    break;
		    case "NewIRFilterTbl": 
			    window.open('NewInvoiceRegisterFilterTable.aspx' ,'Order','height=700,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");	
		    break;	    
		}
   	    
    }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="ToolTip" style="font-family: arial; size: 11px; display: none; position: absolute;
            background-color: #ffffcc; border: 1px solid #666666; padding: 0px 5px 0px 5px;
            layer-background-color: #ffffcc;" zindex="1">
            &nbsp;</div>
        <table width="100%" border="0" cellspacing="2" cellpadding="0" id="table1">
            <tr>
                <!-- <td valign="middle" background="../Common/Images/inbannerbk.jpg"><img src="../Common/Images/dashboardBanner.jpg"  ></td>-->
                <td>
                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                </td>
            </tr>
            <tr>
                <td valign="top" class="LoginFormBk">
                    <table width="100%" border="0" cellspacing="2" cellpadding="2" id="table2">
                        <tr valign="top">
                            <td class="BlueBorder" style="width: 100%">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="TabHeadBk" width="100%" style="height: 30px">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                <tr>
                                                    <td width="16">
                                                        <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                    <td>
                                                        <strong class="redtitle2">Invoice Register</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="5TD" class="blackTxt" style="height: 92px" width="100%">
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage();">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('IR');" id="A2" alt="View invoice register"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Invoice Register</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage();">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('IRCSRFilter');" id="A1"
                                                    alt="View invoice register with customer & CSR filters" onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Invoice Register (CSR Filter)</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage();">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('IRFilterTbl');" id="A3"
                                                    alt="View invoice register - Only for filter table customers" onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Invoice Register Filter Table</a></p>
                                            <% 
                                                if (Session["MaxSensitivity"].ToString() == "9")
                                                {
                                            %>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage();">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('NewIRFilterTbl');" id="A4"
                                                    alt="View new invoice register - Selectable filter table customers" onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;New Invoice Register</a></p>
                                            <%
                                                } %>
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
