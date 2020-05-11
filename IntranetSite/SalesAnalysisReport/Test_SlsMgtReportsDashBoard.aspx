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
   
    
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="ToolTip" style="font-family:arial; size:11px; display:none;position:absolute;background-color: #ffffcc; border:1px solid #666666; padding: 0px 5px 0px 5px;layer-background-color: #ffffcc;" zindex=1 >&nbsp;</div>
    <table width="100%"  border="0" cellspacing="2" cellpadding="0" id="table1">
      <tr>
        <!-- <td valign="middle" background="../Common/Images/inbannerbk.jpg"><img src="../Common/Images/dashboardBanner.jpg"  ></td>-->
        <td>
            <uc1:PageHeader ID="PageHeader1" runat="server" />
        </td>
      </tr>
        <tr>
            <td valign=middle class=PageHead>
                   <span class=Left5pxPadd><asp:Label ID="lblParentMenuName" CssClass=BannerText runat="server" Text="Inventory Reporting"></asp:Label></span> </td>
        </tr>
      <tr>
        <td valign="top" class="LoginFormBk" >
          <table width="100%"  border="0" cellspacing="2" cellpadding="2" id="table2" >
              <tr valign="top">
                  <td class="BlueBorder" style="width:100%">
                  <table width="100%"  border="0" cellpadding="0" cellspacing="0" >
                  <tr>
                    <td class="TabHeadBk" width="100%" style="height: 30px"><table width="100%"  border="0" cellspacing="0" cellpadding="3">
                        <tr>
                          <td width="16"><img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                          <td ><strong class="redtitle2">Sales Management &nbsp;Reports</strong></td>
                        </tr>
                    </table></td>
                  </tr>
                  
                   <tr>
                    <td id="Td1" class="blackTxt" style="height: 92px" width="100%">
                        <p align="left" class="10pxPadding">
                        </p>
                             <p class="10pxPadding"><img src="../Common/Images/Bullet.gif" width="10" height="9" >&nbsp;&nbsp;<a href="AvgSellPrcBlkPreview.aspx" id="x" alt="View Average Selling Price Bulk Report" onMouseOver="ToolTip(this,window.event);" onMouseOut="ToolTip(this,window.event);"
                             >&nbsp;Average Selling Price - Bulk</a>
                                </p>
                   </td>
                  </tr>
                </table>
                  
                  </td>
                 
              </tr>
        </table></td>
        </tr>
    </table> 
   
    </form>
</body>
</html>
