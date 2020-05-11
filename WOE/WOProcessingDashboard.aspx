<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WOProcessingDashboard.aspx.cs" Inherits="WOProcessingDashboard" %>

<%@ Register Src="Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>WorkOrder Processing Dashboard</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet"  type="text/css" />
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
         case "MRPWS": 
            window.open('./WOWorkSheet/WOWorkSheet.aspx' ,'WorkSheet','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		 break;	
		 case "MRPWOE": 
            window.open("Frame.aspx?UserID=" + '<%= Session["UserID"].ToString().Trim() %>&UserName=<%= Session["UserName"].ToString().Trim() %>'  ,'WOE','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		 break;	
		 case "WOEPRT": 
            window.location='./WOPrinting/WODocNoPrompt.aspx' ,'WOPrint','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','';	
		 break;	
		 case "WOAltPar": 
            window.open('WOParentAltPack.aspx' ,'WOAltPar','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=yes','');	
		 break;	
		 default : alert("Out of range");	
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
                <td>
                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                </td>
            </tr>
            <tr>
                <td valign="middle" class="PageHead">
                    <span class="Left5pxPadd"><asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="WorkOrder Processing"></asp:Label></span>
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
                                                        <img src="Common/Images/DragBullet.gif" width="8" height="23" hspace="4">
                                                    </td>
                                                    <td>
                                                        <strong class="redtitle2">WorkOrder Processing</strong>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="blackTxt" style="height: 92px" width="100%">
                                            <p align="left" class="10pxPadding"></p>
                                            <p>
                                                <img src="Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('MRPWS');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('MRPWS');" href="#" alt="Launch MRP WorkOrder WorkSheet" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;WorkOrder WorkSheet</a>
                                            </p>
                                            <p>
                                                <img src="Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('MRPWOE');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('MRPWOE');" href="#" alt="Launch MRP WorkOrder Entry" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;WorkOrder Entry</a>
                                            </p>
                                            <p>
                                                <img src="Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('WOEPRT');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('WOEPRT');" href="#" alt="Launch WorkOrder Printing" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;WorkOrder Printing</a>
                                            </p>
                                            <p>
                                                <img src="Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('WOAltPar');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('WOAltPar');" href="#" alt="Show Worksheet Alternate Parent Item Pack Opportunities" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Print Alternate Parent Item Pack Opportunities</a>
                                            </p>
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