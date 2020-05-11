<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet"  type="text/css" />

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
		    case "UnrcvdPO": 
		        var pageURL = "../PMReportDashboard/UnreceivedPORpt.aspx";
                window.open(pageURL, "UnrcvdPO", 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		    break;

		    case "POAging": 
		        var pageURL = document.getElementById("hidPOESiteURL").value + "POAgingRpt/POAgingRpt.aspx?UserID=" + document.getElementById("hidUserID").value + "&UserName=" + document.getElementById("hidUserName").value + "&SessionID=" + document.getElementById("hidSessionID").value ;
                window.open(pageURL, "POAging", 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		    break;
    		
		    case "CategoryBuy": 
		        var pageURL = "../PMReportDashboard/CategoryBuyReport.aspx";
                window.open(pageURL, "UnrcvdPO", 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		    break;
    		
		    default : alert("Out of range");	
		}
    } 
    </script>

	<script language="C#" runat="server">
	
		private void Page_Load(object sender, System.EventArgs e)
		{
            hidPOESiteURL.Value = ConfigurationSettings.AppSettings["POESiteURL"];
            hidUserID.Value = Session["UserID"].ToString().Trim();
            hidUserName.Value = Session["UserName"].ToString().Trim();
            hidSessionID.Value = Session["SessionID"].ToString().Trim();
        }
	</script>



</head>
<body>
    <form id="form1" runat="server">
    <div id="ToolTip" style="font-family:arial; size:11px; display:none;position:absolute;background-color: #ffffcc; border:1px solid #666666; padding: 0px 5px 0px 5px;layer-background-color: #ffffcc;" zindex=1 >&nbsp;</div>
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
                        <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Procurement Reporting"></asp:Label></span>
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
                                                        <strong class="redtitle2">CPR Reports</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="5TD" class="blackTxt" style="height: 92px" width="100%">
                                            <p align="left" class="10pxPadding">
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp; <a href="http://10.1.35.236//InetDev/Intra2006/Reports_csp/PBOPreview.aspx"
                                                    id="x" alt="View Purchase Backorder Report" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Purchase Backorder Report&nbsp;</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp; <a href="http://10.1.35.236//InetDev/Intra2006/reports_csp/VCCPreview.aspx"
                                                    id="x" alt="View Vendor Price Comparision Report" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Vendor Price Comparison Report</a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp; <a href="http://pfcdev/intranetsite/PMReportDashboard/OpenPOPreview.aspx"
                                                    id="A1" alt="View Open Purchase Orders Report" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Open Purchase Orders Report</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp; <a href="../CPR/FrontEnd.aspx"
                                                    id="A3" alt="View CPR Web Report" onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    CPR Web Report&nbsp;</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp; <a href="../CPR/FrontEnd.aspx?Type=Buy"
                                                    id="A4" alt="View CPR Buy Report" onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    CPR Buy Report&nbsp;</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('UnrcvdPO');">&nbsp;&nbsp;<a
                                                    href="#" alt="View Unreceived Purchase Orders By Category" onclick="LoadPage('UnrcvdPO');" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Unreceived PO Report</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('CategoryBuy');">&nbsp;&nbsp;<a
                                                    href="#" alt="View Category Buy Report" onclick="LoadPage('CategoryBuy');" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Category Buy Report</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('POAging');">&nbsp;&nbsp;<a
                                                    href="#" alt="View PO Aging Trend Report" onclick="LoadPage('POAging');" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;PO Aging Trend Report</a></p>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <asp:HiddenField ID="hidPOESiteURL" runat="server" />
        <asp:HiddenField ID="hidUserName" runat="server" />
        <asp:HiddenField ID="hidUserID" runat="server" />
        <asp:HiddenField ID="hidSessionID" runat="server" />
    </form>
</body>
</html>
