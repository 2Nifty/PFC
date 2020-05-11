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
    // Page inside Umbrella
    //			 if(parent.bodyframe!=null)
    //				parent.bodyframe.location.href="http://PFCCrystal//QA/INV/CPRDetail.aspx";		
    //
    // Page in New Window
    //		    var pageURL = "../GER/ProgressBar.aspx?destPage=DataEntry.aspx";
    //            window.open(pageURL,"GER" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
        switch (report){
		case "BSA": 
		    var pageURL = "../CPR/SKUAnalysis.aspx";
            window.open(pageURL,"BSA" ,'height=710,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		    break;
		case "Alias": 
            if(parent.bodyframe!=null)
                parent.bodyframe.location.href="../MaintItemAlias/TextToItemAlias.aspx";	
		    break;
		case "ItemCard": 
            if(parent.bodyframe!=null)
                parent.bodyframe.location.href="http://10.1.36.34/TDixon/MaintItemCard/MaintItemCard.aspx";		
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
                <td>
                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                </td>
            </tr>
            <tr>
                <td valign="middle" class="PageHead">
                    <span class="Left5pxPadd">
                        <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Inventory Maintenance"></asp:Label></span>
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
                                            <table border="0" cellspacing="0" cellpadding="3">
                                                <tr>
                                                    <td style="width: 1px">
                                                        <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                    <td width="219" style="padding-left:5px">
                                                        <strong class="redtitle2" >Inventory Maintenance Applications</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="5TD" class="blackTxt">
                                            <br />
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('BSA');">&nbsp;&nbsp;
                                                <a id="Option01" alt="Run Branch Stocking Analysis Application" onmouseover="ToolTip(this,window.event);"
                                                    href="#" onclick="LoadPage('BSA');"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Branch Stocking Analysis</a></p>
                                            <p align="left" class="10pxPadding">
                                            </p>                                            
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('Alias');">&nbsp;&nbsp;
                                                <a id="Option02" alt="Run Build Item Alias Application" onmouseover="ToolTip(this,window.event);"
                                                    href="#" onclick="LoadPage('Alias');"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Build Item Alias</a></p>
                                            <p align="left" class="10pxPadding">
                                            </p>                                            
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('ItemCard');">&nbsp;&nbsp;
                                                <a id="Option03" alt="Run Item Card Maintenance Application" onmouseover="ToolTip(this,window.event);"
                                                    href="#" onclick="LoadPage('ItemCard');"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Item Card Maintenance</a></p>
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
