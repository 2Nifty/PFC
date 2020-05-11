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

		case "SingleBOL": 
            if(parent.bodyframe!=null)
                parent.bodyframe.location.href="../GER/GERReconSinglePrompt.aspx";	
		break;
		
		case "ExceptionBOLs": 
            //if(parent.bodyframe!=null)
            //    parent.bodyframe.location.href="../GER/GERReconExceptionPrompt.aspx";	
		break;

		case "AllBOLs": 
            //if(parent.bodyframe!=null)
            //    parent.bodyframe.location.href="../GER/GERReconAllPrompt.aspx";	
		break;
		
		
		default : alert("Out of range");	
		}
    
    }    
    function ClosePage()
    {
        if(parent.bodyframe!=null)
            parent.bodyframe.location.href="../InvReportDashboard/GERDashBoard.aspx";	
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
                <td valign="top" class="LoginFormBk" colspan="2">
                    <table width="100%" border="0" cellspacing="2" cellpadding="2" id="table2">
                        <tr valign="top">
                            <td class="BlueBorder">
                                <p class="10pxPadding">
                                    <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SingleBOL');">&nbsp;&nbsp;
                                    <a style="cursor: hand; color: Black;" onclick="LoadPage('SingleBOL');" id="A2" alt="Single Bill of Lading"
                                        onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                        &nbsp;Single Bill of Lading</a></p>
                                <p class="10pxPadding">
                                    <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('ExceptionBOLs');">&nbsp;&nbsp;
                                    <a style="cursor: hand; color: Black;" onclick="LoadPage('ExceptionBOLs');" id="A6" alt="All 'Value Exception' Bill of Ladings"
                                        onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                        &nbsp;All 'Value Exception' Bill of Ladings</a></p>
                                <p class="10pxPadding">
                                    <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('AllBOLs');">&nbsp;&nbsp;
                                    <a style="cursor: hand; color: Black;" onclick="LoadPage('AllBOLs');" id="A7" alt="All Bill of Ladings"
                                        onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                        &nbsp;All Bill of Ladings</a></p>
                            </td>
                            <td>
                            </td>
                        </tr>
            <tr class="BluBg"><td colspan="2" align="center">
                     <img src="../Common/Images/help.gif" >&nbsp;&nbsp;
            </td></tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
