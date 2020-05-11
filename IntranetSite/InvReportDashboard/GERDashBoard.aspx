<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GERDashBoard.aspx.cs" Inherits="InvReportDashboard_GER" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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

		case "GER": 
		    var pageURL = "../GER/ProgressBar.aspx?destPage=DataEntry.aspx";
            window.open(pageURL,"GER" ,'height=720,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
		
		case "GERFinReview": 
		    var pageURL = "../GER/FinReview.aspx";
            window.open(pageURL,"GERHistDet" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
		
		case "GERBOLSummary": 
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href="../GER/BOLSummary.aspx";	
		break;

		case "GERBOLHistDetail": 
		    var pageURL = "../GER/BOLHistDetail.aspx";
            window.open(pageURL,"GERHistDet" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
		
		case "ChargeMaint": 
		    var pageURL = "../GER/ChargesMaint.aspx";
            window.open(pageURL,"ChargeMaint" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
		
		case "SupportMaint": 
		    var pageURL = "../GER/SupportTableMaint.aspx";
            window.open(pageURL,"SupportMaint" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
		
		case "GERReconcile": 
            if(parent.bodyframe!=null)
                parent.bodyframe.location.href="../GER/GERReconcileMenu.aspx";	
		break;
		
		case "GERProcessStatus": 
            if(parent.bodyframe!=null)
                parent.bodyframe.location.href="../GER/ChangeProcessStatus.aspx";	
		break;
		
		case "GERHistoryMove": 
            if(parent.bodyframe!=null)
                parent.bodyframe.location.href="../GER/MoveFromHist.aspx";	
		break;
		
		case "GERBOLFilter": 
            if(parent.bodyframe!=null)
                parent.bodyframe.location.href="../GER/GERFilterPrompt.aspx";	
		break;
		
		default : alert("Out of range");	
		}
    
    }    
    function CallPage(pagename)
    {
        switch (pagename){

		case "RTS": 
            window.location.href='../ReadyToShip/RTSMenu.aspx';        
		break;
		
		case "ContXDoc": 
		    var pageURL = "../CrossDoc/ContainerXDocSumm.aspx";
            window.open(pageURL,"ContXdocSelect" ,'height=710,width=800,toolbar=0,scrollbars=0,status=1,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (800/2))+',resizable=YES',"");
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
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
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
                        <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Goods En Route"></asp:Label></span>
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
                                                        <strong class="redtitle2">Goods En Route</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="Td2" class="blackTxt" width="50%">
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('GER');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('GER');" id="A2" alt="GER Maintenance"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;GER Maintenance</a>
                                                <%-- <asp:UpdatePanel ID="upnlGERLink" runat="server" >
                                                        <ContentTemplate>
                                                        <img src="../Common/Images/Bullet.gif" width="10" height="9" >
                                                        <a style="cursor: hand; color: Black;"  id="A8" alt="Goods En Route"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                      <asp:LinkButton ID="lnkGER" runat="server" OnClick="lnkGER_Click">&nbsp;&nbsp;&nbsp;GER Maintenance</asp:LinkButton></a>
                                                        </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                        --%>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('ChargeMaint');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('ChargeMaint');" id="A6"
                                                    alt="Charge Maintenance" onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Charge Maintenance</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SupportMaint');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('SupportMaint');" id="A7"
                                                    alt="Support Table Maintenance" onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Support Table Maintenance</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('GERProcessStatus');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('GERProcessStatus');" id="A8"
                                                    alt="Change GER Process Status" onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Change GER Process Status</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('GERHistoryMove');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('GERHistoryMove');" id="A9"
                                                    alt="Move BOL from History for Reprocessing" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Reprocess BOL from History</a></p>
                                        </td>
                                        <td id="Td3" class="blackTxt" valign="top">
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('GERFinReview');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('GERFinReview');" id="A3"
                                                    alt="GER Financial Review" onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;GER Finance Review</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('GERBOLSummary');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('GERBOLSummary');" id="A4"
                                                    alt="GER BOL Summary" onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Bill of Lading Summary</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('GERBOLHistDetail');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('GERBOLHistDetail');" id="A5"
                                                    alt="View Historical BOL" onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;View Historical BOL</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('GERReconcile');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('GERReconcile');" id="A1"
                                                    alt="View GER to AP Reconcilliation" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;View GER to AP Reconciliation</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('GERBOLFilter');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('GERBOLFilter');" id="A12"
                                                    alt="View GER BOL Search" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;GER BOL Search</a></p>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr valign="top">
                            <td class="BlueBorder">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="TabHeadBk" style="height: 30px">
                                            <table border="0" cellspacing="0" cellpadding="3">
                                                <tr>
                                                    <td width="16">
                                                        <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                    <td width="219">
                                                        <strong class="redtitle2">Goods En Route - Ready To Ship</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="Td6" style="height: 20px" class="blackTxt">
                                            <p align="left" class="10pxPadding">
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp;<a href="#"
                                                    style="cursor: hand;" onclick="javascript:CallPage('RTS');" id="A11" alt="GER Ready to Ship"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">&nbsp;GER
                                                    Ready to Ship</a></p>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr valign="top">
                            <td class="BlueBorder">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="TabHeadBk" style="height: 30px">
                                            <table border="0" cellspacing="0" cellpadding="3">
                                                <tr>
                                                    <td width="16">
                                                        <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                    <td width="219">
                                                        <strong class="redtitle2">Goods En Route - Cross Dock</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="Td1" style="height: 20px" class="blackTxt">
                                            <p align="left" class="10pxPadding">
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp;<a href="#"
                                                    style="cursor: hand;" onclick="javascript:CallPage('ContXDoc');" id="A10" alt="GER Container Cross Dock"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">&nbsp;Container Cross Dock</a></p>
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
