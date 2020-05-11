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
		    case "countsheet": 			
		        var pageURL = "CountSheet.aspx";
                window.open(pageURL,"CountSheet" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',""); 		 
		    break;	
    		case "countsheetprint": 			
		        var pageURL = "CountSheetPrint.aspx";
                window.open(pageURL,"CountSheet" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',""); 		 
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
                        <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Physical Inventory"></asp:Label></span>
                </td>
            </tr>
            <tr>
                <td valign="top" class="LoginFormBk">
                    <table width="100%" border="0" cellspacing="2" cellpadding="2" id="table2">
                        <tr valign="top">
                            <td class="BlueBorder">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td id="5TD" class="blackTxt">                                                                                      
                                            <p class="10pxPadding" style="padding-top:10px;">                                            
                                             <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('countsheet');">&nbsp;&nbsp;<a
                                                href="#" alt="View Physical Inventory Qty Adjustment Screen" onclick="LoadPage('countsheet');"
                                                onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">&nbsp;Physical Inventory ERP Qty Adjustment</a></p>
                                                <p class="10pxPadding" style="padding-top:10px;">                                            
                                             <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('countsheetprint');">
                                             <a
                                                href="#" alt="Print Physical Inventory Count Sheet" onclick="LoadPage('countsheetprint');"
                                                onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">&nbsp;
                                                    Print Count Sheet</a></p>
                                                                                         
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
