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
        switch (report)
        {
         case "CreateRTSImport":       
			    var hnd = window.open('PurchaseImportCatMaint.aspx' ,'RTSImportExcel','height=700,width=1000,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (1000/2))+',resizable=yes','');	
		    break;
         case "CreateXML":       
			    var hnd1 = window.open('PurchaseImportXmlExport.aspx' ,'PIXmlExport','height=700,width=1000,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (1000/2))+',resizable=yes','');	
		    break;
         case "CreateERPXML":       
			    var hnd1 = window.open('ERPPurchImportXmlExport.aspx' ,'ERPPIXmlExport','height=700,width=1000,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (1000/2))+',resizable=yes','');	
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
                        <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Purchase Import Processing"></asp:Label></span>
                </td>
            </tr>
            <tr>
                <td valign="top" class="LoginFormBk">
                    <table width="100%" border="0" cellspacing="2" cellpadding="2" id="table2">
                        <tr valign="top">
                            <td class="BlueBorder" style="width: 100%">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td id="5TD" class="blackTxt" style="height: 92px" width="100%">
                                            <p>
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('CreateRTSImport');" alt="Create Vendor RTS Excel" />&nbsp;&nbsp;
                                                <a id="A1" alt="Create Vendor RTS Excel" href="#" onclick="LoadPage('CreateRTSImport');"
                                                    onmouseout="ToolTip(this,window.event);" onmouseover="ToolTip(this,window.event);">Create RTS Excel Files</a>
                                                <br />
                                                <br />
                                            </p>
                                            <p>
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('CreateXML');" alt="Export GER PO Data" />&nbsp;&nbsp;
                                                <a id="A2" alt="Export GER PO Data" href="#" onclick="LoadPage('CreateXML');"
                                                    onmouseout="ToolTip(this,window.event);" onmouseover="ToolTip(this,window.event);">Create Purchase Import XML data</a>
                                                <br />
                                                <br />
                                            </p>
                                            <p>
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('CreateERPXML');" alt="Export PO Data" />&nbsp;&nbsp;
                                                <a id="A3" alt="Export PO Data" href="#" onclick="LoadPage('CreateERPXML');"
                                                    onmouseout="ToolTip(this,window.event);" onmouseover="ToolTip(this,window.event);">Create ERP Purchase Order XML data</a>
                                                <br />
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                &nbsp;</p>
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
