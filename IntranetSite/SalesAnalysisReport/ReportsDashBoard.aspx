<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReportsDashBoard.aspx.cs"
    Inherits="SalesAnalysisReport_ReportsDashBoard" %>

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
		case "Sales": 
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href='CustomerSalesAnalysisUserPrompt.aspx?SessionID=<%=Session["SessionID"]%>';		
		break;
		case "Branch": 
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href="BranchItemSalesAnalysisUserPrompt.aspx";	
		break;
		case "Agent": 
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href="BranchItemShippingSalesAnalysisUserPrompt.aspx";	
		break;
		case "Trend": 
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href="CategoryTrendAnalysisUserPrompt.aspx";	
		break;
		case "CAR": 
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href="CustomerActivityRptPrompt.aspx";	
		break;
		case "Category": 
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href="CategorySalesAnalysisUserPrompt.aspx";	
		break;
		case "Budget": 
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href="../CustBudgetMaintenance/CustBudgetPrompt.aspx";		
		break;
		case "NextYear": 
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href="../CustBudgetMaintenance/CustNextYearBudgetPrompt.aspx";		
		break;
		case "ROI": 
			    
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href="../ROISalesReport/SalesReportByCatGroupUserPrompt.aspx";	
		break;
		case "DailySales":
		 var hwin=window.open('../DailySalesReport/DailySalesReport.aspx?BranchID=ALL' ,'DailySalesReport','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=No','');
             hwin.focus();
        break;
		case "AItem": 
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href="../A-ItemSales/AItemSalesRpt.aspx";	
		break;
		case "Open": 
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href="../OpenOrderRpt/OpenOrderRpt.aspx";	
		break;
		case "BookingRpt": 
			location.href="../InvoiceRegister/BookingReportPrompt.aspx";
		    break;	
		case "QuoteMetrics": 
		    location.href = '../QuoteMetrics/QuoteMetricsPrompt.aspx';	
	    break;
	    
	    case "LLL": 
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href="LostLeadersRptPrompt.aspx";	
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
                <!-- <td valign="middle" background="../Common/Images/inbannerbk.jpg"><img src="../Common/Images/dashboardBanner.jpg"  ></td>-->
                <td>
                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                </td>
            </tr>
            <tr>
                <td valign="middle" class="PageHead">
                    <span class="Left5pxPadd">
                        <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Sales Reporting"></asp:Label></span>
                </td>
            </tr>
            <tr>
                <td valign="top" class="LoginFormBk">
                    <table width="100%" border="0" cellspacing="2" cellpadding="2" id="table2">
                        <tr valign="top">
                            <td class="BlueBorder">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="TabHeadBk" style="height: 30px">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                <tr>
                                                    <td width="1px">
                                                        <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                    <td>
                                                        <strong class="redtitle2">Period Analysis Reports</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="5TD" class="blackTxt">
                                            <p align="left" class="10pxPadding">
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('Sales');"
                                                    hspace="5"><a href="CustomerSalesAnalysisUserPrompt.aspx" alt="View Customer Sales Analysis Report"
                                                        onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">Customer
                                                        Sales Analysis</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('Branch');"
                                                    hspace="5"><a href="BranchItemSalesAnalysisUserPrompt.aspx" id="A1" alt="View Branch Item Sales Analysis Report"
                                                        onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">Branch
                                                        Item Sales Analysis </a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('Agent');"
                                                    hspace="5"><a href="BranchItemShippingSalesAnalysisUserPrompt.aspx" id="A2" alt="View Item Shipping Agent Sales Analysis Report"
                                                        onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">Item
                                                        Shipping Agent Sales Analysis </a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('Category');"
                                                    hspace="5"><a href="CategorySalesAnalysisUserPrompt.aspx" alt="View Category Sales Analysis Report"
                                                        onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">Category
                                                        Sales Analysis </a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('CAR');"
                                                    hspace="5"><a href="CustomerActivityRptPrompt.aspx" alt="View Customer Activity Report"
                                                        onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">Customer Activity Report</a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('LLL');"
                                                    hspace="5"><a href="../LostLeadersDashboard/LostLeadersRptPrompt.aspx" alt="View Lost Leaders Report"
                                                        onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">Lost Leaders Report</a>
                                            </p>                                            
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td class="BlueBorder">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="TabHeadBk">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                <tr>
                                                    <td width="1px">
                                                        <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                    <td>
                                                        <strong class="redtitle2">Trend Analysis Reports</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="Td1" valign="top" class="blackTxt">
                                            <div align="left" class="10pxPadding">
                                                <p class="10pxPadding">
                                                    <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('Trend');"
                                                        hspace="5"><a href="CategoryTrendAnalysisUserPrompt.aspx" alt="View Category Trend Analysis Report"
                                                            onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">Category
                                                            Trend Analysis</a></p>                                                            
                                                <p class="10pxPadding">
                                                    <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="location.href='../InvoiceAnalysis/InvoiceAnalysisByCustNoPrompt.aspx'"
                                                        hspace="5"><a href="../InvoiceAnalysis/InvoiceAnalysisByCustNoPrompt.aspx" alt="View Sales Performance by Filter Report"
                                                            onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">Sales Performance by Filter Report</a></p>
                                                 <% 
                                                 if (Convert.ToInt16(Session["MaxSensitivity"].ToString()) >= 5)
                                                {
                                                %>
                                               <p class="10pxPadding">
                                                    <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="location.href='../SalesByPackageGrouping/SalesByPackageGroupPrompt.aspx'"
                                                        hspace="5"><a href="../SalesByPackageGrouping/SalesByPackageGroupPrompt.aspx" alt="View Sales Performance by Filter Report"
                                                            onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">Sales by Package Grouping Report</a></p>  
                                                <%
                                                } %>           
                                                            
                                            </div>
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
                                            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                <tr>
                                                    <td width="1px">
                                                        <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                    <td>
                                                        <strong class="redtitle2">Data Maintenance</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="Td2" class="blackTxt">
                                            <p>
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('Budget');"
                                                    hspace="5">
                                                <a href="#" onclick="LoadPage('Budget');" id="A3" alt="Load Customer YTD Sales Goals"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    Customer Goals Maintenance</a>
                                            </p>
                                            <% 
                                                if (Session["MaxSensitivity"].ToString() == "9")
                                                {
                                            %>
																						<p id="ForecastLink" runat="server">
																							<img height="9" hspace="5" onclick="LoadPage('NextYear');" src="../Common/Images/Bullet.gif"
																								width="10">
																							<a id="A7" alt="Load Customer Next Year Sales Forecasts" href="#" onclick="LoadPage('NextYear');"
																								onmouseout="ToolTip(this,window.event);" onmouseover="ToolTip(this,window.event);">
																								Customer Next Year Forecast Maintenance</a>
																						</p>
                                            <%
                                                } %>
																				</td>
                                    </tr>
                                </table>
                            </td>
                            <td class="BlueBorder">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="TabHeadBk" style="height: 30px">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                <tr>
                                                    <td width="1px">
                                                        <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                    <td>
                                                        <strong class="redtitle2">Executive Sales Reporting</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="Td3" class="blackTxt">
                                            <% 
                                                if (Session["MaxSensitivity"].ToString() == "9")
                                                {
                                            %>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('ROI');"
                                                    hspace="5">
                                                <a href="../ROISalesReport/SalesReportByCatGroupUserPrompt.aspx" id="A4" alt="Load ROI Sales Report"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    ROI Sales Report by Category Group</a>
                                            </p>
                                            <%
                                                } %>
                                            <% 
                                                int security = Convert.ToInt16(Session["MaxSensitivity"].ToString());
                                                if (security >= 3)
                                                {
                                            %>
                                            <p class="10pxPadding">
                                                &nbsp;
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" id="IMG1" onclick="LoadPage('DailySales');"
                                                    title="Daily Sales Analysis">&nbsp; <a href="#" onclick="LoadPage('DailySales');"
                                                        id="A10" alt="Daily Sales Analysis(.net)" onmouseover="ToolTip(this,window.event);"
                                                        onmouseout="ToolTip(this,window.event);">Daily Sales Analysis </a>
                                            </p>
                                            <%} %>
                                            <% 
                                                if (Session["MaxSensitivity"].ToString() == "9")
                                                {
                                            %>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('AItem');"
                                                    hspace="5">
                                                <a href="../A-ItemSales/AItemSalesRpt.aspx" id="A5" alt="'A' Item Sales Report" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">'A' Item Sales Report</a>
                                            </p>
                                            <%
                                                } %>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr valign="top">
                            <td class="BlueBorder">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="TabHeadBk" style="height: 30px">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                <tr>
                                                    <td width="1px">
                                                        <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                    <td>
                                                        <strong class="redtitle2">PFC Direct Connect Sales Analysis</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="Td4" class="blackTxt" style="height: 30px">
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('eCommerce');"
                                                    hspace="5">
                                                <a href="../eCommerceReport/eCommerceSalesAnalysisUserPrompt.aspx" id="A6" alt="Load eCommerce Quote And Order Analysis Report"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    eCommerce Quote And Order Analysis Report</a></p>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td class="BlueBorder">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="TabHeadBk">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                <tr>
                                                    <td width="1px">
                                                        <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                    <td>
                                                        <strong class="redtitle2">Sales Reports</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="Td5" valign="top" class="blackTxt">
                                            <div align="left" class="10pxPadding">
                                             <% 
                                              if (Convert.ToInt16(Session["MaxSensitivity"].ToString()) >= 5)
                                              {
                                            %>
                                                <p class="10pxPadding">
                                                    <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('Open');"
                                                        hspace="5"><a href="../OpenOrderRpt/OpenOrderRptPrompt.aspx" alt="View Open Order Report"
                                                            onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">Open
                                                            Order Report</a></p>                                                                              
                                                <p class="10pxPadding">
                                                    <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('BookingRpt');"
                                                        hspace="5"><a href="#" onclick="LoadPage('BookingRpt');" alt="View Booking Report"
                                                            onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">Booking
                                                            Report</a></p> 
                                             <% } %>   
                                             <% 
                                              if (Convert.ToInt16(Session["MaxSensitivity"].ToString()) >= 3)
                                              {
                                            %>                                            
                                                <p class="10pxPadding">
                                                    <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('QuoteMetrics');"
                                                        hspace="5"><a href="#" onclick="LoadPage('QuoteMetrics');" alt="View Quote Metrics Report"
                                                            onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">Quote Metrics Report</a></p>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
        </table>
    </form>
</body>
</html>
+