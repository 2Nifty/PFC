<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Register Src="Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
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
			case "Acadmin": 
		    var pageURL = "acadmin.aspx";
		    location.href=pageURL;
            //window.open(pageURL,"GER" ,'height=760,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;

			case "ACIBA": 
		    var pageURL = "../AC_ItemBranchActivity/ItemBranchActivityPrompt.aspx";
		    location.href=pageURL;
            //window.open(pageURL,"GER" ,'height=760,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
		break;
		
		default : alert("Out of range");	
		}
    
    }    
    function CallPage()
    {
        window.location.href='../ReadyToShip/RTSMenu.aspx';        
    }
    </script>

</head>
<body>
    <form id="form1" runat="server">
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
                        <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Average Cost"></asp:Label></span>
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
                                                        <strong class="redtitle2" >Average Cost Administration</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="5TD" class="blackTxt">
                                            <p align="left" class="10pxPadding">
                                            </p>                                            
                                            <p class="10pxPadding">
                                                <img src="Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('Acadmin');">&nbsp;&nbsp;<a
                                                    href="#" onclick="LoadPage('Acadmin');" id="A2"
                                                    alt="Resolve Average Cost Exceptions" style=cursor:hand>&nbsp;Resolve Average Cost Exceptions</a><br />
                                            </p>
                                                                                           
                                            <p class="10pxPadding">
                                                <img src="Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('CPR7Sum');">&nbsp;&nbsp;<a
                                                    href="#" id="A1"
                                                    alt="Display Average Cost Daily Totals" style=cursor:hand>&nbsp;Average Cost Inventory Daily
                                                Totals</a><br />
                                            </p>
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
                                        <td id="Td1" class="blackTxt">
                                            <p align="left" class="10pxPadding">
                                            </p>                                            
                                            <p class="10pxPadding">
                                                <img src="Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('ACIBA');">&nbsp;&nbsp;<a
                                                    href="#" onclick="LoadPage('ACIBA');" id="A3"
                                                    alt="Average Cost Item Branch Activity" style=cursor:hand>&nbsp;Average Cost Item Branch Activity</a><br />
                                            </p>
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
