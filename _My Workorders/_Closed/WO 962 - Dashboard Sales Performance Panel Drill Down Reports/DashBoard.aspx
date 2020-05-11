<%@ Page Language="C#" AutoEventWireup="true" MaintainScrollPositionOnPostback="true" CodeFile="DashBoard.aspx.cs" Inherits="PFC.Intranet.DashBoard" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet">
</head>

<script language="javascript">

function doOpen(url,name)
{
    var w = window.open(url, name, 'height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
    w.focus();
    return false;
}

function DashBoardControl(Item,SHMode)
{
    
		switch (SHMode)
		{
		case "Hide": 			
			document.getElementById(Item+"TD").style.display = "none";
			
			//Toggle Question Div Content to activate Hide Function
			if(Item=="5")
			document.getElementById(Item+"Container").innerHTML = 
			"<img src=\"../Common/Images/add.gif\" style='Cursor:hand'  hspace=\"2\" id=\"\" onClick=\"OpenEdit('Favourite')\" onMouseOver=\"this.src='../Common/Images/addMo.gif'\" onMouseOut=\"this.src='../Common/Images/add.gif'\"><Img id='"+Item+"' onClick=\"DashBoardControl(this.id,'Show')\" style='Cursor:hand;margin-right:3px;' src=../Common/Images/ShowDropMenu.gif onMouseOver=\"this.src='../Common/Images/ShowDropMenuMo.gif'\" onMouseOut=\"this.src='../Common/Images/ShowDropMenu.gif'\"/>";
			else if(Item=="2")
			document.getElementById(Item+"Container").innerHTML = 
			"<img src=\"../Common/Images/add.gif\" style='Cursor:hand'  hspace=\"2\" id=\"\" onClick=\"OpenEdit('ShortCuts')\" onMouseOver=\"this.src='../Common/Images/addMo.gif'\" onMouseOut=\"this.src='../Common/Images/add.gif'\"><Img id='"+Item+"' onClick=\"DashBoardControl(this.id,'Show')\" style='Cursor:hand;margin-right:3px;' src=../Common/Images/ShowDropMenu.gif onMouseOver=\"this.src='../Common/Images/ShowDropMenuMo.gif'\" onMouseOut=\"this.src='../Common/Images/ShowDropMenu.gif'\"/>";
			else if(Item=="6")
			document.getElementById(Item+"Container").innerHTML = 
			"<img src=\"../Common/Images/add.gif\" style='Cursor:hand'  hspace=\"2\" id=\"\" onClick=\"OpenEdit('DoList')\" onMouseOver=\"this.src='../Common/Images/addMo.gif'\" onMouseOut=\"this.src='../Common/Images/add.gif'\"><Img id='"+Item+"' onClick=\"DashBoardControl(this.id,'Show')\" style='Cursor:hand;margin-right:3px;' src=../Common/Images/ShowDropMenu.gif onMouseOver=\"this.src='../Common/Images/ShowDropMenuMo.gif'\" onMouseOut=\"this.src='../Common/Images/ShowDropMenu.gif'\"/>";			
			
		    HidState(Item);
		break;
		case "Show": 					
			document.getElementById(Item+"TD").style.display = "block";
			
			//Toggle Question Div Content to activate Hide Function
			if(Item=="5")
			document.getElementById(Item+"Container").innerHTML = 
				"<img src=\"../Common/Images/add.gif\" style='Cursor:hand'  hspace=\"2\" id=\"\" onClick=\"OpenEdit('Favourite')\" onMouseOver=\"this.src='../Common/Images/addMo.gif'\" onMouseOut=\"this.src='../Common/Images/add.gif'\"><Img id='"+Item+"' onClick=\"DashBoardControl(this.id,'Hide')\" style='Cursor:hand;margin-right:3px;' src='../Common/Images/HideDropMenu.gif' onMouseOver=\"this.src='../Common/Images/HideDropMenuMo.gif'\" onMouseOut=\"this.src='../Common/Images/HideDropMenu.gif'\"/>";
			else if(Item=="2")
			document.getElementById(Item+"Container").innerHTML = 
				"<img src=\"../Common/Images/add.gif\" style='Cursor:hand'  hspace=\"2\" id=\"\" onClick=\"OpenEdit('ShortCuts')\" onMouseOver=\"this.src='../Common/Images/addMo.gif'\" onMouseOut=\"this.src='../Common/Images/add.gif'\"><Img id='"+Item+"' onClick=\"DashBoardControl(this.id,'Hide')\" style='Cursor:hand;margin-right:3px;' src='../Common/Images/HideDropMenu.gif' onMouseOver=\"this.src='../Common/Images/HideDropMenuMo.gif'\" onMouseOut=\"this.src='../Common/Images/HideDropMenu.gif'\"/>";
			else if(Item=="6")
			document.getElementById(Item+"Container").innerHTML = 
				"<img src=\"../Common/Images/add.gif\" style='Cursor:hand'  hspace=\"2\" id=\"\" onClick=\"OpenEdit('DoList')\" onMouseOver=\"this.src='../Common/Images/addMo.gif'\" onMouseOut=\"this.src='../Common/Images/add.gif'\"><Img id='"+Item+"' onClick=\"DashBoardControl(this.id,'Hide')\" style='Cursor:hand;margin-right:3px;' src='../Common/Images/HideDropMenu.gif' onMouseOver=\"this.src='../Common/Images/HideDropMenuMo.gif'\" onMouseOut=\"this.src='../Common/Images/HideDropMenu.gif'\"/>";
			
			ShowState(Item);
		break;
		
		case "Hideadd": 		    
			document.getElementById(Item+"TD").style.display = "none";
			//Toggle Question Div Content to activate Hide Function
			document.getElementById(Item+"Container").innerHTML = 
			"<img align=\"right\"  id='"+Item+"' style='Cursor:hand;margin-right:3px;' onClick=\"DashBoardControl(this.id,'Showadd')\" src=../Common/Images/ShowDropMenu.gif onMouseOver=\"this.src='../Common/Images/ShowDropMenuMo.gif'\" onMouseOut=\"this.src='../Common/Images/ShowDropMenu.gif'\"/>";
			 HidState(Item);			 
		break;
		case "Showadd": 
			document.getElementById(Item+"TD").style.display = "block";
			
			//Toggle Question Div Content to activate Hide Function
			document.getElementById(Item+"Container").innerHTML = 
			"<img align=\"right\" id='"+Item+"' style='Cursor:hand;margin-right:3px;' onClick=\"DashBoardControl(this.id,'Hideadd')\" src='../Common/Images/HideDropMenu.gif' onMouseOver=\"this.src='../Common/Images/HideDropMenuMo.gif'\" onMouseOut=\"this.src='../Common/Images/HideDropMenu.gif'\"/>";
			ShowState(Item);
			
		break;
		default : alert("Out of range");	
		}
}
function HidState(hidnumber)
{
    switch (hidnumber){
    case "8":
         parent.banner.document.getElementById("topform").Hid8.value="Hide";        
		break;
	case "4": 					
		 parent.banner.document.getElementById("topform").Hid4.value="Hide";  
	break;
	case "10": 					
		 parent.banner.document.getElementById("topform").Hid10.value="Hide";  
	break;
	case "2": 					
		 parent.banner.document.getElementById("topform").Hid2.value="Hide";  
	break;
	case "5": 					
		 parent.banner.document.getElementById("topform").Hid5.value="Hide";  
	break;
	case "3": 					
		 parent.banner.document.getElementById("topform").Hid3.value="Hide";  
	break;
	case "6": 					
		 parent.banner.document.getElementById("topform").Hid6.value="Hide";  
	break;
    case "7": 
		 parent.banner.document.getElementById("topform").Hid7.value="Hide";  
	break;
	default : alert("Out of range");	
	}
}
function ShowState(shownumber)
{
    switch (shownumber){
    case "8":
         parent.banner.document.getElementById("topform").Hid8.value="";        
		break;
	case "4": 					
		 parent.banner.document.getElementById("topform").Hid4.value="";  
	break;
	case "10": 					
		 parent.banner.document.getElementById("topform").Hid10.value="";  
	break;
	case "2": 					
		 parent.banner.document.getElementById("topform").Hid2.value="";  
	break;
	case "5": 					
		 parent.banner.document.getElementById("topform").Hid5.value="";  
	break;
	case "3": 					
		 parent.banner.document.getElementById("topform").Hid3.value="";  
	break;
	case "6": 					
		 parent.banner.document.getElementById("topform").Hid6.value="";  
	break;
	case "7": 					
		 parent.banner.document.getElementById("topform").Hid7.value="";  
	break;
	default : alert("Out of range");	
	}
}
function sessionHide()
{
    
    if(parent.banner.document.getElementById("topform") && parent.banner.document.getElementById("topform").Hid8 && parent.banner.document.getElementById("topform").Hid8.value=="Hide")
    {
            document.getElementById("8TD").style.display = "none";			
			//Toggle Question Div Content to activate Hide Function
			document.getElementById("8Container").innerHTML = 
			"<img align=\"right\"  id='8' style='Cursor:hand;margin-right:3px;' onClick=\"DashBoardControl(this.id,'Showadd')\" src=../Common/Images/ShowDropMenu.gif onMouseOver=\"this.src='../Common/Images/ShowDropMenuMo.gif'\" onMouseOut=\"this.src='../Common/Images/ShowDropMenu.gif'\"/>";
    }  
    if(parent.banner.document.getElementById("topform") && parent.banner.document.getElementById("topform").Hid4 && parent.banner.document.getElementById("topform").Hid4.value=="Hide")
    {
            document.getElementById("4TD").style.display = "none";			
			//Toggle Question Div Content to activate Hide Function
			document.getElementById("4Container").innerHTML = 
			"<img align=\"right\"  id='4' style='Cursor:hand;margin-right:3px;' onClick=\"DashBoardControl(this.id,'Showadd')\" src=../Common/Images/ShowDropMenu.gif onMouseOver=\"this.src='../Common/Images/ShowDropMenuMo.gif'\" onMouseOut=\"this.src='../Common/Images/ShowDropMenu.gif'\"/>";
    }  
    if(parent.banner.document.getElementById("topform") && parent.banner.document.getElementById("topform").Hid10 && parent.banner.document.getElementById("topform").Hid10.value=="Hide")
    {
            document.getElementById("10TD").style.display = "none";			
			//Toggle Question Div Content to activate Hide Function
			document.getElementById("10Container").innerHTML = 
			"<img align=\"right\"  id='10' style='Cursor:hand;margin-right:3px;' onClick=\"DashBoardControl(this.id,'Showadd')\" src=../Common/Images/ShowDropMenu.gif onMouseOver=\"this.src='../Common/Images/ShowDropMenuMo.gif'\" onMouseOut=\"this.src='../Common/Images/ShowDropMenu.gif'\"/>";
    }  
    if( parent.banner.document.getElementById("topform") && parent.banner.document.getElementById("topform").Hid2 && parent.banner.document.getElementById("topform").Hid2.value=="Hide")
    {
    document.getElementById("2TD").style.display = "none";
			
			//Toggle Question Div Content to activate Hide Function
			document.getElementById("2Container").innerHTML = 
			"<img src=\"../Common/Images/add.gif\" style='Cursor:hand'  hspace=\"2\" id=\"\" onClick=\"OpenEdit('ShortCuts')\" onMouseOver=\"this.src='../Common/Images/addMo.gif'\" onMouseOut=\"this.src='../Common/Images/add.gif'\"><Img id='2' onClick=\"DashBoardControl(this.id,'Show')\" style='Cursor:hand;margin-right:3px;' src=../Common/Images/ShowDropMenu.gif onMouseOver=\"this.src='../Common/Images/ShowDropMenuMo.gif'\" onMouseOut=\"this.src='../Common/Images/ShowDropMenu.gif'\"/>";        
    }  
    if(parent.banner.document.getElementById("topform")  && parent.banner.document.getElementById("topform").Hid5 && parent.banner.document.getElementById("topform").Hid5.value=="Hide")
    {
    document.getElementById("5TD").style.display = "none";
			
			//Toggle Question Div Content to activate Hide Function
			document.getElementById("5Container").innerHTML = 
			"<img src=\"../Common/Images/add.gif\" style='Cursor:hand'  hspace=\"2\" id=\"\" onClick=\"OpenEdit('Favourite')\" onMouseOver=\"this.src='../Common/Images/addMo.gif'\" onMouseOut=\"this.src='../Common/Images/add.gif'\"><Img id='5' onClick=\"DashBoardControl(this.id,'Show')\" style='Cursor:hand;margin-right:3px;' src=../Common/Images/ShowDropMenu.gif onMouseOver=\"this.src='../Common/Images/ShowDropMenuMo.gif'\" onMouseOut=\"this.src='../Common/Images/ShowDropMenu.gif'\"/>";        
    }  
    if(parent.banner.document.getElementById("topform") && parent.banner.document.getElementById("topform").Hid3 && parent.banner.document.getElementById("topform").Hid3.value=="Hide")
    {
    document.getElementById("3TD").style.display = "none";
			
			//Toggle Question Div Content to activate Hide Function
			document.getElementById("3Container").innerHTML = 
			"<img align=\"right\"  id='3' style='Cursor:hand;margin-right:3px;' onClick=\"DashBoardControl(this.id,'Showadd')\" src=../Common/Images/ShowDropMenu.gif onMouseOver=\"this.src='../Common/Images/ShowDropMenuMo.gif'\" onMouseOut=\"this.src='../Common/Images/ShowDropMenu.gif'\"/>";
    }  
    if(parent.banner.document.getElementById("topform") && parent.banner.document.getElementById("topform").Hid6 && parent.banner.document.getElementById("topform").Hid6.value=="Hide")
    {
    document.getElementById("6TD").style.display = "none";
			
			//Toggle Question Div Content to activate Hide Function
			document.getElementById("6Container").innerHTML = 
			"<img src=\"../Common/Images/add.gif\" style='Cursor:hand'  hspace=\"2\" id=\"\" onClick=\"OpenEdit('DoList')\" onMouseOver=\"this.src='../Common/Images/addMo.gif'\" onMouseOut=\"this.src='../Common/Images/add.gif'\"><Img id='6' onClick=\"DashBoardControl(this.id,'Show')\" style='Cursor:hand;margin-right:3px;' src=../Common/Images/ShowDropMenu.gif onMouseOver=\"this.src='../Common/Images/ShowDropMenuMo.gif'\" onMouseOut=\"this.src='../Common/Images/ShowDropMenu.gif'\"/>";        
    } 
     if(parent.banner.document.getElementById("topform") && parent.banner.document.getElementById("topform").Hid7 && parent.banner.document.getElementById("topform").Hid7.value=="Hide")
    {
    document.getElementById("7TD").style.display = "none";
			
			//Toggle Question Div Content to activate Hide Function
			document.getElementById("7Container").innerHTML = 
			"<Img id='7' onClick=\"DashBoardControl(this.id,'Showadd')\" style='Cursor:hand;margin-right:3px;' src=../Common/Images/ShowDropMenu.gif onMouseOver=\"this.src='../Common/Images/ShowDropMenuMo.gif'\" onMouseOut=\"this.src='../Common/Images/ShowDropMenu.gif'\"/>";        
    }  
}

function ChangePassword()
{
    var hWnd= window.open('ChangePassword.aspx',"ChangePasswordPage",'height=240,width=500,scrollbars=no,status=no,top='+((screen.height/2) - (240/2))+',left='+((screen.width/2) - (500/2))+',resizable=no');	    
    hWnd.opener = self;	
	if (window.focus) {hWnd.focus()}
    
}
function OpenEdit(userType)
{
    var hWnd= window.open('UserFavourite.aspx?Mode='+userType,"PopUpPage",'height=480,width=500,scrollbars=no,status=no,top='+((screen.height/2) - (480/2))+',left='+((screen.width/2) - (500/2))+',resizable=no');		
    hWnd.opener = self;	
	if (window.focus) {hWnd.focus()}
}
function DisplayAccessSummary()
{
    var hWnd=window.open('AccessSummaryHistory.aspx',"SummaryPage",'height=480,width=500,scrollbars=no,status=no,top='+((screen.height/2) - (480/2))+',left='+((screen.width/2) - (500/2))+',resizable=no');		
    hWnd.opener = self;	
	if (window.focus) {hWnd.focus()}
}
function LoadContent(Mode)
{
    var hWnd=window.open("Description.aspx", 'Description', 'height=220,width=530,scrollbars=no,status=no,top='+((screen.height/2) - (480/2))+',left='+((screen.width/2) - (500/2))+',resizable=no');		
    hWnd.opener = self;	
    if (window.focus) {hWnd.focus()}
      
} 
function LoadCsr()
{    
    var hWnd=window.open("CSRReport.aspx?BranchID="+ document.getElementById("ddlBranch").value, 'Descrip', 'height=680,width=1000,scrollbars=no,status=no,top='+((screen.height/2) - (680/2))+',left='+((screen.width/2) - (500))+',resizable=no');		       
    hWnd.opener = self;	
    if (window.focus) {hWnd.focus()}
}
function LoadRegion()
{
        var hWnd=window.open("LoadRegion.aspx?RegionID="+ document.getElementById("ddlRegion").value, 'Region', 'height=680,width=1000,scrollbars=no,status=no,top='+((screen.height/2) - (680/2))+',left='+((screen.width/2) - (500))+',resizable=no');		       
        hWnd.opener = self;	
        if (window.focus) {hWnd.focus()}       
}

function LoadSalesReport()
{              
    var hwin=window.open('../DailySalesReport/DailySalesReport.aspx?BranchID='+document.form1.ddlBranch.value ,'DailySalesReport1','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=No','');
             hwin.focus(); 
}

function formatGrid()
{
    if (navigator.appName.indexOf("Microsoft Internet Explorer")>(-1))
    {}
    else
    {
        var strForm=document.form1.innerHTML;
        document.form1.innerHTML=strForm.replace(/rules\=\"all\"/g,'');
    }
}
</script>

<body class="frame" scroll="yes">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td>
                </td>
            </tr>
            <tr>
                <td width="100%" valign="top">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr>
                            <td height="97" valign="top" class="BannerBg">
                                <div class="bannerImg">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" class="DashBoardBk" >
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bottomBorder">
                                    <tr>
                                        <td width="33%" valign="top" class="rightBorder">
                                            <div id="mydiv" style="display: none; left=0; top=0;">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder">
                                                    <tr>
                                                        <td class="TabHeadBk">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                                <tr>
                                                                    <td width="1">
                                                                        <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4" onmouseover="this.style.cursor='hand'"
                                                                            onmousedown="var x=document.getElementsByTagName('body');x[0].style.cursor='crosshair';"
                                                                            onmouseup="var x=document.getElementsByTagName('body');x[0].style.cursor='crosshair';"></td>
                                                                    <td width="100%">
                                                                        <strong>User's Profile information</strong></td>
                                                                    <td align="right">
                                                                        <img src="../Common/Images/ShowDropMenu.gif" height="19" style="cursor: hand"></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td valign="top" class="TabCntBk" style="height: 66px">
                                                            <div align="left" class="10pxPadding">
                                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp; Customer
                                                                Sales Analysis<br>
                                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp; Customer
                                                                Sales Analysis<br>
                                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp; Customer
                                                                Sales Analysis<br>
                                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp; Customer
                                                                Sales Analysis
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                                <tr>
                                                    <td class="Left5pxPadd">
                                                        <strong class="BlackBold">User Information </strong>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder">
                                                            <tr>
                                                                <td class="TabHeadBk">
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                                        <tr>
                                                                            <td width="16">
                                                                                <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4" ondrag="follow"></td>
                                                                            <td width="100">
                                                                                <strong>My Profile</strong> &nbsp; &nbsp; &nbsp; </td>
                                                                                <td width="117" class="10pxPadding"><a href="#" onclick="ChangePassword();">Change Password</a></td>
                                                                                 
                                                                            <td width="63" id="1Container">
                                                                                </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top" id="1TD">
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder">
                                                            <tr>
                                                                <td class="TabHeadBk" width="100%">
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                                        <tr>
                                                                            <td width="16">
                                                                                <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4" ondrag="follow"></td>
                                                                            <td width="217">
                                                                                <strong>Sales Performance</strong></td>
                                                                            <td align="right" id="8Container">
                                                                                <img id="8" align="right" src="../Common/Images/HideDropMenu.gif" height="19" style="cursor: hand; margin-right:3px;"
                                                                                    onclick="DashBoardControl(this.id,'Hideadd')" onmouseover="this.src='../Common/Images/HideDropMenuMo.gif'"
                                                                                    onmouseout="this.src='../Common/Images/HideDropMenu.gif'">
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2" valign="top">
                                                                    <div class="TabCntBk" id="8TD">
                                                                        <asp:Table Width="100%" ID="dtUserProfile" runat="server">
                                                                            <asp:TableHeaderRow>
                                                                                <asp:TableHeaderCell></asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">Day</asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">Br Avg</asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">MTD</asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">Forecast</asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">LMTD</asp:TableHeaderCell>
                                                                            </asp:TableHeaderRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>G/M $</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Exp Bud</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Profit</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>G/M %</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Sales $</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell># Order</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell># Lines</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Lbs Ship</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Price  Lbs</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>GP $  Lbs</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                        </asp:Table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                            
                                                        
                                                <tr>
                                                    <td valign =top>
                                                        <table id="tblRegion" runat=server width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder">
                                                            <tr>
                                                                <td class="TabHeadBk" style="height: 30px">
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                                        <tr>
                                                                            <td width="16">
                                                                                <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                                            <td width="216">
                                                                                <strong>Region Performance Summary</strong></td>
                                                                            <td id="7Container" align=right  >                                                                              
                                                                                <img id="7" src="../Common/Images/HideDropMenu.gif"
                                                                                        height="19" onclick="DashBoardControl(this.id,'Hideadd')" style="cursor: hand;margin-right:3px;" onmouseover="this.src='../Common/Images/HideDropMenuMo.gif'"
                                                                                        onmouseout="this.src='../Common/Images/HideDropMenu.gif'" align="right"></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td  valign="top" style="padding:0px;">
                                                                    <div align="left" class="TabCntBk" id="7TD">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td >
                                                                                    <div>
                                                                                        &nbsp;Region Name
                                                                                    </div>
                                                                                </td>
                                                                                <td >
                                                                                    <asp:DropDownList CssClass="FormControls" Width="130px" ID="ddlRegion" runat="server" >
                                                                                    </asp:DropDownList></td>
                                                                                <td align="right"  >
                                                                                    <img src="../Common/Images/ViewRpt.gif" visible="true" id="ibtnRegion" onclick="LoadRegion();"
                                                                                        style='cursor: hand; margin-right:1px;' runat="server" onmouseover="this.src='../Common/Images/ViewRptMo.gif'"
                                                                                        onmouseout="this.src='../Common/Images/ViewRpt.gif'" height="19"  align="right" /></td>
                                                                            </tr>
                                                                        </table>                                                                  
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>                                                            
                                                <tr>
                                                    <td>
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder">
                                                            <tr>
                                                                <td class="TabHeadBk">
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                                        <tr>
                                                                            <td width="16">
                                                                                <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                                            <td width="216">
                                                                                <strong>Branch Performance Summary</strong></td>
                                                                            <td  align=right id="4Container">
                                                                                <img id="4"  src="../Common/Images/HideDropMenu.gif" height="19" style="cursor: hand;padding-right:3px;"
                                                                                    onclick="DashBoardControl(this.id,'Hideadd')" onmouseover="this.src='../Common/Images/HideDropMenuMo.gif'"
                                                                                    onmouseout="this.src='../Common/Images/HideDropMenu.gif'"></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td  valign="top">
                                                                <asp:UpdatePanel ID="pnlBranchPerformSummary" runat="server" UpdateMode="Conditional">
                                                                <ContentTemplate>
                                                                    <div align="left" class="TabCntBk" id="4TD">
                                                                    <div>
                                                                    <table width="100%" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td >  <div>Branch Name</div></td>
                                                                            <td ><asp:DropDownList CssClass="FormControls" Width="130px" ID="ddlBranch" runat="server" OnSelectedIndexChanged="ddlBranch_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList></td>
                                                                            <td align="right" valign="top" width="50px" >                                                                               
                                                                                            <img src="../Common/Images/dsales_n.gif" visible="false" id="ibtnDailySales" onclick="LoadSalesReport();"
                                                                                                style='cursor: hand; margin-right:0px;' runat="server" onmouseover="this.src='../Common/Images/dsales_o.gif'"
                                                                                                onmouseout="this.src='../Common/Images/dsales_n.gif'" />                                                                                  
                                                                                        <img src="../Common/Images/ListCsr.gif" visible="false" id="ibtnCsr" onclick="LoadCsr();" style='Cursor:hand;padding-top:1px;' runat="server" onmouseover="this.src='../Common/Images/ListCsrMo.gif'" onmouseout="this.src='../Common/Images/ListCsr.gif'"  />
                                                                                       
                                                                               <input id="hidLastBusiDay" type="hidden" runat="server" />
                                                                                </td>
                                                                        </tr>
                                                                    </table>                                                                    
                                                                    </div>   
                                                                                    <asp:Table width="100%" ID="dtBrPerformance" runat="server">
                                                                                        <asp:TableHeaderRow>
                                                                                        <asp:TableHeaderCell></asp:TableHeaderCell>
                                                                                        <asp:TableHeaderCell HorizontalAlign="Right">Day</asp:TableHeaderCell>
                                                                                        <asp:TableHeaderCell HorizontalAlign="Right">Br Avg</asp:TableHeaderCell>
                                                                                        <asp:TableHeaderCell HorizontalAlign="Right">MTD</asp:TableHeaderCell>
                                                                                        <asp:TableHeaderCell HorizontalAlign="Right">Forecast</asp:TableHeaderCell>
                                                                                        <asp:TableHeaderCell HorizontalAlign="Right">Budget</asp:TableHeaderCell>
                                                                                        </asp:TableHeaderRow>
                                                                                        <asp:TableRow>
                                                                                        <asp:TableCell>G/M $</asp:TableCell>
                                                                                         <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                          <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                            <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                        </asp:TableRow>
                                                                                        <asp:TableRow>
                                                                                        <asp:TableCell>Exp Bud</asp:TableCell>
                                                                                         <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                          <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                            <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                        </asp:TableRow>
                                                                                        <asp:TableRow>
                                                                                        <asp:TableCell>Profit</asp:TableCell>
                                                                                         <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                          <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                            <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                        </asp:TableRow>                                                                                        
                                                                                         <asp:TableRow>
                                                                                        <asp:TableCell>G/M %</asp:TableCell>
                                                                                         <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                          <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                            <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                        </asp:TableRow>
                                                                                         <asp:TableRow>
                                                                                        <asp:TableCell>Sales $</asp:TableCell>
                                                                                         <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                          <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                            <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                        </asp:TableRow>
                                                                                         <asp:TableRow>
                                                                                        <asp:TableCell># Order</asp:TableCell>
                                                                                         <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                          <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                            <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                        </asp:TableRow>
                                                                                         <asp:TableRow>
                                                                                        <asp:TableCell># Lines</asp:TableCell>
                                                                                         <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                          <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                            <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                        </asp:TableRow>
                                                                                          <asp:TableRow>
                                                                                        <asp:TableCell>Lbs Ship</asp:TableCell>
                                                                                         <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                          <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                            <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                        </asp:TableRow>
                                                                                         <asp:TableRow>
                                                                                        <asp:TableCell>Price  Lbs</asp:TableCell>
                                                                                         <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                          <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                            <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                        </asp:TableRow>
                                                                                        <asp:TableRow>
                                                                                        <asp:TableCell>GP $  Lbs</asp:TableCell>
                                                                                         <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                          <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                           <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                            <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                        </asp:TableRow>                                                                                        
                                                        </asp:Table>
                                                                    <br />
                                                                   
                                                                    </div>
                                                                </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td valign="top" class="rightBorder">
                                            <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                                <tr>
                                                    <td class="Left5pxPadd">
                                                        <strong class="BlackBold">Application</strong>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" >
                                                         <tr>
                                                    <td>
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder">
                                                            <tr>
                                                                <td class="TabHeadBk">
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                                        <tr>
                                                                            <td width="16">
                                                                                <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                                            <td width="216">
                                                                                <strong>Marketing</strong></td>
                                                                            <td align="right" id="10Container">
                                                                                <img id="10" align="right" src="../Common/Images/HideDropMenu.gif" height="19" style="cursor: hand; margin-right:3px;"
                                                                                    onclick="DashBoardControl(this.id,'Hideadd')" onmouseover="this.src='../Common/Images/HideDropMenuMo.gif'"
                                                                                    onmouseout="this.src='../Common/Images/HideDropMenu.gif'"></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td valign="top">
                                                                    <div align="left" class="TabCntBk" id="10TD">
                                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0"  >
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:DataGrid ID="dgMargeting" runat="server" AutoGenerateColumns="False" BorderWidth="0"
                                                                                        ShowHeader="False" OnItemDataBound="dgMargeting_ItemDataBound" >
                                                                                        <ItemStyle CssClass="blackTxt" VerticalAlign="Top" Width="250px" />
                                                                                        <HeaderStyle Height="0px" HorizontalAlign="Center" />
                                                                                        <Columns>
                                                                                            <asp:TemplateColumn>
                                                                                                <ItemTemplate>
                                                                                                    <img src="../Common/Images/Bullet.gif" hspace="5" />
                                                                                                   <asp:HyperLink ID="HyperLink1" NavigateUrl='<%# GetTipsURL(Container)%>' Text='' runat="server" Target="_blank"></asp:HyperLink>
                                                                                                </ItemTemplate>
                                                                                            </asp:TemplateColumn>
                                                                                        </Columns>
                                                                                    </asp:DataGrid></td>
                                                                            </tr>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr><td></td></tr><tr><td></td></tr> <tr><td></td> </tr> <tr> <td></td> </tr><tr><td></td></tr>
                                                            <tr>
                                                            <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder"><tr>
                                                            <td class="TabHeadBk"> <table width="100%" border="0" cellspacing="0" cellpadding="3" >
                                                                        <tr>
                                                                            <td width="16">
                                                                                <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4" ondrag="follow"></td>
                                                                            <td width="204">
                                                                                <strong>Shortcuts </strong>
                                                                            </td>
                                                                            <td align="right" id="2Container">                                                                               
                                                                                <img src="../Common/Images/add.gif" alt="Add new shortcut" style="cursor: hand" hspace="1"
                                                                                    id="Img2" onclick="OpenEdit('ShortCuts')" onmouseover="this.src='../Common/Images/addMo.gif'"
                                                                                    onmouseout="this.src='../Common/Images/add.gif'"><img src="../Common/Images/HideDropMenu.gif"
                                                                                        height="19" hspace="1" id="2" style="cursor: hand; margin-right:3px;" onclick="DashBoardControl(this.id,'Hide')"
                                                                                        onmouseover="this.src='../Common/Images/HideDropMenuMo.gif'" onmouseout="this.src='../Common/Images/HideDropMenu.gif'"></td>
                                                                        </tr>
                                                                    </table></td></tr>
                                                                    
                                                                     <tr>
                                                            <td valign="top" >
                                                                    <div align="left" class="TabCntBk" id="2TD">
                                                                        <asp:DataGrid ID="dgShortCuts" runat="server" AutoGenerateColumns="False" BorderWidth="0"
                                                                            ShowHeader="False" OnItemDataBound="dgShortCuts_ItemDataBound">
                                                                            <ItemStyle CssClass="blackTxt" Width="250px" VerticalAlign="Top"></ItemStyle>
                                                                            <HeaderStyle HorizontalAlign="Center" Height="0px"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn>
                                                                                    <ItemTemplate>
                                                                                        <img src="../Common/Images/Bullet.gif" hspace="5" />
                                                                                        <asp:HyperLink ID="HyperLink1" NavigateUrl='<%# GetURL(Container)%>' Text='<%#DataBinder.Eval(Container, "DataItem.Content")%>'
                                                                                            runat="server" Target="_self"></asp:HyperLink>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                    </div>
                                                                </td>
                                                                
                                                            </tr>
                                                                    </table></td>
                                                              
                                                            </tr>
                                                           
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder">
                                                            <tr>
                                                                <td class="TabHeadBk">
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                                        <tr>
                                                                            <td width="16">
                                                                                <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                                            <td width="213">
                                                                                <strong>Favorite Links </strong>
                                                                            </td>
                                                                            <td align="right" id="5Container">
                                                                               
                                                                                <img src="../Common/Images/add.gif" alt="Add new favorite item" hspace="1" id="Img3"
                                                                                    onclick="OpenEdit('Favourite')" onmouseover="this.src='../Common/Images/addMo.gif'"
                                                                                    onmouseout="this.src='../Common/Images/add.gif'" style="cursor: hand"><img id="5"
                                                                                        src="../Common/Images/HideDropMenu.gif" height="19" hspace="1" onclick="DashBoardControl(this.id,'Hide')"
                                                                                        style="cursor: hand; margin-right:3px;" onmouseover="this.src='../Common/Images/HideDropMenuMo.gif'"
                                                                                        onmouseout="this.src='../Common/Images/HideDropMenu.gif'"></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td  valign="top">
                                                                    <div align="left" class="TabCntBk" id="5TD">
                                                                        <asp:DataGrid ID="dgFavourite" runat="server" AutoGenerateColumns="False" BorderWidth="0"
                                                                            ShowHeader="False">
                                                                            <ItemStyle CssClass="blackTxt" VerticalAlign="Top" Width="250px" />
                                                                            <HeaderStyle Height="0px" HorizontalAlign="Center" />
                                                                            <Columns>
                                                                                <asp:TemplateColumn>
                                                                                    <ItemTemplate>
                                                                                        <img src="../Common/Images/Bullet.gif" hspace="5" />
                                                                                        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%#GetRedirectURL(Container)%>'
                                                                                            Target="_blank" Text='<%#DataBinder.Eval(Container, "DataItem.Content")%>'></asp:HyperLink>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="33%" valign="top">
                                            <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                                <tr>
                                                    <td class="Left5pxPadd">
                                                        <strong class="BlackBold">Administrator's Announcements</strong>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder">
                                                            <tr>
                                                                <td class="TabHeadBk">
                                                                    <table width="100%" border="0" cellspacing="0"  cellpadding="3">
                                                                        <tr>
                                                                            <td width="16">
                                                                                <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4" ondrag="follow"></td>
                                                                            <td width="219">
                                                                                <strong>Announcements</strong></td>
                                                                            <td  id="3Container" align="right">
                                                                                <img id="3" src="../Common/Images/HideDropMenu.gif" align="right" height="19" style="cursor: hand;margin-right:3px;"
                                                                                    onclick="DashBoardControl(this.id,'Hideadd')" onmouseover="this.src='../Common/Images/HideDropMenuMo.gif'"
                                                                                    onmouseout="this.src='../Common/Images/HideDropMenu.gif'"></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td valign="top">
                                                                    <div id="3TD" align="left" class="TabCntBk">
                                                                        <asp:DataGrid ID="dgAnnouncement" runat="server" AutoGenerateColumns="False" BorderWidth="0"
                                                                                        ShowHeader="False" OnItemDataBound="dgAnnouncement_ItemDataBound" >
                                                                        <ItemStyle CssClass="blackTxt" VerticalAlign="Top" Width="250px" />
                                                                        <HeaderStyle Height="0px" HorizontalAlign="Center" />
                                                                        <Columns>
                                                                            <asp:TemplateColumn>
                                                                                <ItemTemplate>
                                                                                    <img src="../Common/Images/Bullet.gif" hspace="5" />
                                                                                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# GetAnnouncementURL(Container)%>'
                                                                                        Target="_blank" Text=''></asp:HyperLink>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                        </Columns>
                                                                    </asp:DataGrid>
                                                                    </div></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder">
                                                            <tr>
                                                                <td class="TabHeadBk">
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                                        <tr>
                                                                            <td width="16">
                                                                                <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                                            <td width="216">
                                                                                <strong>My to Do list</strong></td>
                                                                            <td  id="6Container">                                                                             
                                                                                <img src="../Common/Images/add.gif" style="cursor: hand" alt="Add new task" hspace="3"
                                                                                    id="Img5" onclick="OpenEdit('DoList')" onmouseover="this.src='../Common/Images/addMo.gif'"
                                                                                    onmouseout="this.src='../Common/Images/add.gif'"><img id="6" src="../Common/Images/HideDropMenu.gif"
                                                                                        height="19" onclick="DashBoardControl(this.id,'Hide')" style="cursor: hand; margin-right:3px;" onmouseover="this.src='../Common/Images/HideDropMenuMo.gif'"
                                                                                        onmouseout="this.src='../Common/Images/HideDropMenu.gif'"></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td  valign="top">
                                                                    <div align="left" class="TabCntBk" id="6TD">
                                                                        <asp:DataGrid ID="dgDolist" runat="server" AutoGenerateColumns="False" BorderWidth="0"
                                                                            ShowHeader="False" OnItemDataBound="dgDolist_ItemDataBound">
                                                                            <ItemStyle CssClass="blackTxt" VerticalAlign="Top" Width="250px" />
                                                                            <HeaderStyle Height="0px" HorizontalAlign="Center" />
                                                                            <Columns>
                                                                                <asp:TemplateColumn>
                                                                                    <ItemTemplate>
                                                                                        <img src="../Common/Images/Bullet.gif" hspace="5" />
                                                                                        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%#GetDoURL(Container)%>'
                                                                                            Target="_blank" Text='<%#DataBinder.Eval(Container, "DataItem.Content")%>'></asp:HyperLink>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid><br>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
      <script>sessionHide();formatGrid();</script>
    </form>
</body>
</html>
