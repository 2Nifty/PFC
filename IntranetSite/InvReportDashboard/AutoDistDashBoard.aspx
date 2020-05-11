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
    
    function LoadPage(report)
    {
        switch (report){
		
		case "ADProcessMaint": 
		    var pageURL = "http://pfcintranet/AD/ProcessMaint.aspx";
            window.open(pageURL,"SupportMaint" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
		
		case "ADStepMaint": 
		    var pageURL = "http://pfcintranet/AD/StepMaint.aspx";
            window.open(pageURL,"SupportMaint" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
		
		case "ADProcess": 
		    var pageURL = "http://pfcintranet/AD/Processor.aspx";
		    //var pageURL = "http://pfcrnd/inetdev/intra2006/AD/Processor.aspx";
            window.open(pageURL,"SupportMaint" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
		
		case "ADMinMaxMaint": 
		    var pageURL = "http://pfcintranet/AD/MinMaxMaint.aspx";
            window.open(pageURL,"SupportMaint" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
		
		case "ADTransfers": 
		    var pageURL = "http://pfcintranet/AD/MakeTransfers.aspx";
            window.open(pageURL,"CreateXFer" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
		
		case "ADHelp": 
		    var pageURL = "http://pfcintranet/AD/AutoDistributionHelp.htm";
            window.open(pageURL,"ADHelp" ,'height=710,width=1010,scrollbars=YES,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
		
		default : alert("Out of range");	
		}
    
    }    
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="ToolTip" style="font-family: arial; font-size: 11px; display: none; position: absolute;
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
                <td valign="middle" class="PageHead">
                    <span class="Left5pxPadd">
                        <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Auto Distribution"></asp:Label></span>
                </td>
            </tr>
            <tr>
                <td valign="top" class="LoginFormBk">
                    <table width="100%" border="0" cellspacing="2" cellpadding="2" id="table2">
                        <tr valign="top">
                            <td class="BlueBorder">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="TabHeadBk" style="height: 30px" colspan="2">
                                            <table border="0" cellspacing="0" cellpadding="3">
                                                <tr>
                                                    <td width="16">
                                                        <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                    <td width="219">
                                                        <strong class="redtitle2">Auto Distribution</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="Td4" class="blackTxt" width="50%">
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('ADProcessMaint');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('ADProcessMaint');" id="A8" 
                                                    alt="Auto Distribution Process Maintenance"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Process Maintenance</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('ADStepMaint');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('ADStepMaint');" id="A9"
                                                    alt="Auto Distribution Step Maintenance" onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Step Maintenance</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('ADMinMaxMaint');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('ADMinMaxMaint');" id="A10"
                                                    alt="Auto Distribution Step Maintenance" onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Min/Max Maintenance</a></p>
                                        </td>
                                        <td id="Td5" class="blackTxt" valign="top">
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('ADProcess');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('ADProcess');" id="A12" 
                                                alt="Run Auto Distribution/View Results"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Run AD Process/View Results</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('ADTransfers');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('ADTransfers');" id="A1" 
                                                alt="Create Transfers from Results"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Create AD Transfers</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('ADHelp');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('ADHelp');" id="A2" 
                                                alt="View the AD Help page"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;AD Help</a></p>
                                        </td>
                                    </tr>
                                 </table>
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
