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
     function OpenGER()
    {
        window.open("../GER/ProgressBar.aspx?destPage=DataEntry.aspx","GER" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (970/2))+',resizable=YES',"");        
    }
    function LoadPage(report)
    {
        switch (report){
		case "CPR7Pre": 
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href="CPRv7Preview.aspx";		
		break;
		case "CPR7Sum": 
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href="CPRv7SPreview.aspx";	
		break;
		case "BOM": 
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href="NewBOMPreview.aspx";	
		
		break;
		case "GER": 
			 //window.open("http://208.29.238.24/IntranetSite/GER/DataEntry.aspx","GER" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		    var pageURL = "../GER/ProgressBar.aspx?destPage=DataEntry.aspx";
            window.open(pageURL,"GER" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
 
    	break;
		
		case "ADProcessMaint": 
		    var pageURL = "http://pfcquote/AD/ProcessMaint.aspx";
            window.open(pageURL,"ProcessMaint" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
		
		case "ADStepMaint": 
		    var pageURL = "http://pfcquote/AD/StepMaint.aspx";
            window.open(pageURL,"StepMaint" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
		
		case "ADProcess": 
		    var pageURL = "http://pfcquote/AD/processor.aspx";
            window.open(pageURL,"Processor" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
		
		case "ADMinMaxMaint": 
		    var pageURL = "http://pfcquote/AD/MinMaxMaint.aspx";
            window.open(pageURL,"MinMaxMaint" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
        case "IRR": 
		  
		    var pageURL = "../InventoryReconsiliation/InventoryReconsiliation.aspx";
            window.open(pageURL,"ChargeMaint" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
			 //if(parent.bodyframe!=null)
			//	parent.bodyframe.location.href="../GER/BOLHistDetail.aspx";	
		break;

		case "ExcessInv": 
		    var pageURL = "../ExcessInventoryRpt/ExcessInventoryRpt.aspx";
            window.open(pageURL, "ExcessInv", 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
        case "POPastDue": 
		    var pageURL = "../InvPOPastDueReport/POPastDueByReportGroup.aspx";
            window.open(pageURL, "ExcessInv", 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
        case "SelSKU": 
			 if(parent.bodyframe!=null)
				parent.bodyframe.location.href="../SelectedSKU/SelectedSKUAnalysisPrompt.aspx";
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
                        <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Inventory Reporting"></asp:Label></span>
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
                                            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                <tr>
                                                    <td width="16">
                                                        <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                    <td width="219">
                                                        <strong class="redtitle2">Inventory Reports</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="5TD" class="blackTxt" width="50%">
                                            <p align="left" class="10pxPadding">
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('CPR7Pre');">&nbsp;&nbsp;<a
                                                    href="http://pfccrystal/prod/INV/CPRv7Preview.aspx" id="x" alt="View Consolidated Purchasing Requirements with Parent Detail Report"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">&nbsp;Consolidated
                                                    Purchase Requirements Report with Bulk Parent Detail</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('CPR7Sum');">&nbsp;&nbsp;<a
                                                    href="http://pfccrystal/prod/INV/CPRv7SPreview.aspx" id="A1" alt="View Consolidated Purchasing Requirements with Parent Summary Report"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">&nbsp;Consolidated
                                                    Purchase Requirements Report with Bulk Parent Summary</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('BOM');">&nbsp;&nbsp;<a
                                                    href="http://pfccrystal/prod/INV/NewBOMPreview.aspx/NewBOMPreview.aspx" id="x"
                                                    alt="View Bill of Material Component Report" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Bill of Material Component Report</a></p>
                                            <% if (Session["MaxSensitivity"].ToString() == "9")
                                               { %>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp;<a href="http://pfcquote/Intranet-PFC/KPIReports/RGASummary.aspx"
                                                    id="A2" alt="View Monthly RGA Reason Code Summary" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Monthly RGA Reason Code Summary</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('IRR');">&nbsp;&nbsp;<a
                                                    href="#" id="A3" alt="View Inventory Reconciliation" onclick="LoadPage('IRR');"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">&nbsp;Inventory
                                                    Reconciliation</a></p>
                                            <%} %>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('ExcessInv');">&nbsp;&nbsp;<a
                                                    href="#" alt="View Excess Inventory Report" onclick="LoadPage('ExcessInv');"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">&nbsp;Excess
                                                    Inventory Report</a></p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('POPastDue');">&nbsp;&nbsp;<a
                                                    href="#" alt="View PO Past Due Report" onclick="LoadPage('POPastDue');" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;PO Past Due Report</a></p>
                                            <% if (Convert.ToInt16(Session["MaxSensitivity"].ToString()) >= 5)
                                                { %>
                                                    <p class="10pxPadding">
                                                        <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SelSKU');">&nbsp;&nbsp;<a
                                                            href="#" alt="View Selected SKU Report" onclick="LoadPage('SelSKU');" onmouseover="ToolTip(this,window.event);"
                                                            onmouseout="ToolTip(this,window.event);">&nbsp;Selected SKU Analysis Report</a></p>
                                            <%  } %>
                                        </td>
                                        <td class="blackTxt" valign="top">
                                            <!--    <p align="left" class="10pxPadding">
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp;<a
                                                    href="http://pfcquote/Intranet-PFC/CriticalItemRpt/CriticalItemRpt.aspx"
                                                    alt="Critical Item report" onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">&nbsp;Critical Item Report</a></p> -->
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
