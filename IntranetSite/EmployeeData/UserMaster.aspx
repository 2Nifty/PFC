<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserMaster.aspx.cs" Inherits="UserMaster" %>

<%@ Register Src="~/EmployeeData/Common/UserControl/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="~/EmployeeData/Common/UserControl/Footer.ascx" TagName="BottomFooter"
    TagPrefix="uc2" %>
<%@ Register Src="~/EmployeeData/Common/UserControl/Locations.ascx" TagName="LeftFrame"
    TagPrefix="uc3" %>
<%@ Register Src="~/EmployeeData/Common/UserControl/User.ascx" TagName="LeftUser"
    TagPrefix="uc4" %>
<%@ Register Src="~/EmployeeData/Common/UserControl/EmpData.ascx" TagName="EmployeeData"
    TagPrefix="uc5" %>
<%@ Register Src="~/EmployeeData/Common/UserControl/UserSettings.ascx" TagName="UserSettings"
    TagPrefix="uc6" %>
<%@ Register Src="~/EmployeeData/Common/UserControl/UserSecurity.ascx" TagName="UserSecurity"
    TagPrefix="uc7" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Master</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <style>
    .PageH{
	    background-color: #EFF9FC;
	    }
    </style>

    <script type="text/javascript">
    
    function ShowHide(SHMode)
    {
        if (SHMode == "User")
         {
            document.getElementById('divUser').style.display = '';
		    document.getElementById('divLocation').style.display="none";
		    document.getElementById("SHButton").innerHTML = "<img ID='iLocation' style='cursor:hand' src='Common/images/ShowDropMenu.gif' onclick=\"javascript:ShowHide('Location');\">";    		
	    }
	    if (SHMode== "Location")
	    {
            document.getElementById("ucLocation_btnLocation").click();
	    }	
    }
    
    function ShowHide()
    {
        var myindex  = document.getElementById('ddlViewOption').selectedIndex
        var SHMode = document.getElementById('ddlViewOption').options[myindex].value
        
        if (SHMode == "User")
         {
            document.getElementById("btnBindUsers").click();	    
	    }
	    if (SHMode== "Location")
	    {	    
	        document.getElementById("hidLocSearch").value="Location";
            document.getElementById("ucLocation_btnLocation").click();
	    }	
    }
    </script>

    <script>

var dtCh= "/";
var minYear=1900;
var maxYear=2100;

function isInteger(s){
	var i;
    for (i = 0; i < s.length; i++){   
        // Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}
function stripCharsInBag(s, bag){
	var i;
    var returnString = "";
    // Search through string's characters one by one.
    // If character is not in bag, append to returnString.
    for (i = 0; i < s.length; i++){   
        var c = s.charAt(i);
        if (bag.indexOf(c) == -1) returnString += c;
    }
    return returnString;
}
function daysInFebruary (year){
	// February has 29 days in any year evenly divisible by four,
    // EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
}
function DaysArray(n) {
	for (var i = 1; i <= n; i++) {
		this[i] = 31
		if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
		if (i==2) {this[i] = 29}
   } 
   return this
}
function isDate(dtStr){
	var daysInMonth = DaysArray(12)
	var pos1=dtStr.indexOf(dtCh)
	var pos2=dtStr.indexOf(dtCh,pos1+1)
	var strMonth=dtStr.substring(0,pos1)
	var strDay=dtStr.substring(pos1+1,pos2)
	var strYear=dtStr.substring(pos2+1)
	strYr=strYear
	if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
	if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
	for (var i = 1; i <= 3; i++) {
		if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
	}
	month=parseInt(strMonth)
	day=parseInt(strDay)
	year=parseInt(strYr)
	if (pos1==-1 || pos2==-1){
		alert("The date format should be : mm/dd/yyyy")
		return false
	}
	if (strMonth.length<1 || month<1 || month>12){
		alert("Please enter a valid month")
		return false
	}
	if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
		alert("Please enter a valid day")
		return false
	}
	if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){
		alert("Please enter a valid 4 digit year between "+minYear+" and "+maxYear)
		return false
	}
	if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false){
		alert("Please enter a valid date")
		return false
	}
	return true
}

function ValidateDate(id)
{
	var dt=document.getElementById(id).value;
	if(dt!="")
	{
	if (isDate(dt)==false)
	{
      document.getElementById(id).value="";
		return false
	}
	
    return true
    }
 }

    </script>

    <script>

    function SelectSecurityItem(rowID,Value)
    {
        var color;
     
        if(rowID.style.fontWeight=='bold') 
        {   
             rowID.style.fontWeight='normal';
             rowID.style.backgroundColor = ''; 
             document.getElementById("ucSecurity_hidValue").value=document.getElementById("ucSecurity_hidValue").value.replace(Value,'');    
        }
        else
        {   
           rowID.style.fontWeight='bold';
           rowID.style.backgroundColor = "#FFFFCC"; 
           document.getElementById("ucSecurity_hidValue").value=document.getElementById("ucSecurity_hidValue").value+Value;
        }
      
     }
 
    //Update User Group 
    function UpdateUser()
    {
        if(document.getElementById("ucSecurity_hidValue").value!="")   
            document.getElementById("ucSecurity_btnUserUpdate").click();
        else
        {
            //alert('No security group selected. Please select atleast one.');
            document.form1.style.cursor='auto';   
        }
        
    }
 
    // Disable the entire selected item 
    function DisableSelect()
    {
        document.form1.style.cursor="move";
        document.selection.empty();
        return false;
    }
 
    //Select an Item from Group 
    function SelectUserItem(rowID,Value,SecID)
    {
        if(rowID.style.fontWeight=='bold')
        {
        
        rowID.style.fontWeight='normal';
        rowID.style.backgroundColor=""; 
        document.getElementById("ucSecurity_hidUserValue").value=document.getElementById("ucSecurity_hidUserValue").value.replace(Value,'');
        document.getElementById("ucSecurity_hidUserID").value=document.getElementById("ucSecurity_hidUserID").value.replace(SecID,'');
      
        }
        else
        {
            rowID.style.fontWeight='bold';
            rowID.style.backgroundColor = "#FFFFCC"; 
            document.getElementById("ucSecurity_hidUserValue").value=document.getElementById("ucSecurity_hidUserValue").value+Value;
            document.getElementById("ucSecurity_hidUserID").value=document.getElementById("ucSecurity_hidUserID").value+SecID;
        }
   
    }

    //Update Security Group 
    function UpdateSecurity()
    { 
        if(document.getElementById("ucSecurity_hidUserValue").value!="")
            document.getElementById("ucSecurity_btnSecurityUpdate").click();
        else
        {
            //alert('No user group selected. Please select atleast one.');
            document.form1.style.cursor='auto';     
        }
    }
    </script>

    <script>
    
    function UserLocation(Location,UserName)
    {     
        document.getElementById("ddlViewOption").selectedIndex=1;
        document.getElementById("hidUser").value="";
        document.getElementById("hidUser").value=UserName;
         
        //To Bind Location Value 
        document.getElementById('ucLocation_hidLocName').value="";
        document.getElementById('ucLocation_hidLocName').value=Location;
          
        document.getElementById("hidLocSearch").value="Location";
        document.getElementById("ucLocation_btnLocation").click();
          
        return false;
	}	
    function LoadLocation()
    {
        document.getElementById('ucLocation_hidLocName').value="";
        document.getElementById('divUser').style.display = "none";
        
		document.getElementById('divLocation').style.display='';
		//document.getElementById("SHButton").innerHTML = "<img ID='iUser' style='cursor:hand' src='Common/images/ShowDropMenu.gif' onclick=\"javascript:ShowHide('User');\">";
        document.getElementById('ucLocation_hidLocName').value="";   
    }
   
    function GetUserName(UserName)
    {
        // document.getElementById("ddlViewOption").selectedIndex=0;
        // document.getElementById("ddlSearch").selectedIndex=0;
        document.getElementById("txtSearch").value=UserName;
        
   
        document.getElementById("hidLeftFrameBindMode").value="Click";
        document.getElementById("ucUser_hidLeftFrameBindMode").value="Click";
     
        document.getElementById("ibtnSearch").click();  
    }
   
    </script>

    <script>
   
   function ValdateNumber()
    {

        if(event.keyCode<48 || event.keyCode>58)
            event.keyCode=0;
    }

   function ValdateNumberWithDot(value)
    {
    
        if(event.keyCode<46 || event.keyCode>58 ||event.keyCode==47)
            event.keyCode=0;
            
        if(event.keyCode==46 && value.indexOf('.')!=-1)
             event.keyCode=0;
         
    }
    
    function LoadTabData(tabName)
    {
        if(tabName=='EmployeeData')
        {
            divEmployee.style.display = '';
            divUSerSecurity.style.display= 'none';
            divUserSetting.style.display = 'none';
            
            document.getElementById('ibtnEmpData').src = "Common/images/tab_empdata_o.gif";
            document.getElementById('ibtnUserSetting').src = "Common/images/tab_userset_n.gif";
            document.getElementById('ibtnUserSecurity').src = "Common/images/tab_usersecurity_n.gif";
        }
        else if(tabName=='Settings')
        {   
            divEmployee.style.display = 'none';
            divUserSetting.style.display = '';
            divUSerSecurity.style.display= 'none';
            
            document.getElementById('ibtnUserSecurity').src = "Common/images/tab_userset_n.gif";
            document.getElementById('ibtnEmpData').src = "Common/images/tab_empdata_n.gif";            
            document.getElementById('ibtnUserSetting').src = "Common/images/tab_usersecurity_o.gif";        
        }
        else if(tabName=='Security')
        {   
            divUSerSecurity.style.display= '';
            divUserSetting.style.display = 'none';  
            divEmployee.style.display = 'none';     
                   
            document.getElementById('ibtnUserSecurity').src = "Common/images/tab_usersecurity_o.gif";   
            document.getElementById('ibtnUserSetting').src = "Common/images/tab_userset_n.gif";
            document.getElementById('ibtnEmpData').src = "Common/images/tab_empdata_n.gif";            
               
        }
        
    }   
    
    function HighLightTabSheet(tabName)
    {
        if(tabName=='EmployeeData')
        {
            document.getElementById('ibtnEmpData').src = "Common/images/tab_empdata_o.gif";
            document.getElementById('ibtnUserSetting').src = "Common/images/tab_userset_n.gif";
            document.getElementById('ibtnUserSecurity').src = "Common/images/tab_usersecurity_n.gif";
        }
        else if(tabName=='Settings')
        {   
            document.getElementById('ibtnUserSecurity').src = "Common/images/tab_userset_n.gif";
            document.getElementById('ibtnEmpData').src = "Common/images/tab_empdata_n.gif";            
            document.getElementById('ibtnUserSetting').src = "Common/images/tab_usersecurity_o.gif";        
        }
        else if(tabName=='Security')
        {                      
            document.getElementById('ibtnUserSecurity').src = "Common/images/tab_usersecurity_o.gif";   
            document.getElementById('ibtnUserSetting').src = "Common/images/tab_userset_n.gif";
            document.getElementById('ibtnEmpData').src = "Common/images/tab_empdata_n.gif";            
               
        }
        
    } 
    
    function SetFocusID1()
    {
       
        if(event.keyCode==9)
        {
       
        var id=document.getElementById("ucEmpData_dtpHireDate_textBox");
        //document.getElementById("ucEmpData_dtpHireDate_textBox").focus();
        id.value='123';
       id.focus();
       return;
      }
      
         
    }
    function SetFocusUser()
    {
    document.getElementById("ucSetting_txtPassword").focus();
    }
    </script>

</head>
<body scroll="no" onclick="javascript:document.getElementById('lblMessage').innerText='';"
    onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" border="0" width="100%" id="mainTable">
            <tr>
                <td height="5%" id="tdHeader" colspan="2">
                    <uc1:Header ID="ucHeader" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="padding-top: 1px;" width="100%" colspan="2">
                <asp:UpdatePanel ID="pnlOptions" UpdateMode="conditional" runat="server">
                                    <ContentTemplate>
                    <table class="shadeBgDown" width="100%">
                        <tr>
                            <td class="Left2pxPadd DarkBluTxt boldText" width="84%">
                            </td>
                            <td>
                                <asp:ImageButton runat="server" ID="ibtnAdd" ImageUrl="~/EmployeeData/Common/images/newadd.gif"
                                    ImageAlign="right" OnClick="ibtnAdd_Click" CausesValidation="false" />
                            </td>
                            <td style="padding-right: 10px">
                                <img id="imgHelp" src="Common/images/help.gif" runat="server" align="right" />
                            </td>
                        </tr>
                    </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
                </td>
            </tr>
            <tr width="28%">
                <td class="PageHead " style="height: 10px; padding-left: 8px;">
                    <table>
                        <tr align="center">
                            <td>
                                <asp:Label ID="Label1" runat="server" CssClass="DarkBluTxt" Text="View By" Width="60px"></asp:Label></td>
                            <td style="width: 100px">
                                <asp:DropDownList ID="ddlViewOption" runat="server" CssClass="FormCtrl" Width="100px"
                                    onchange="javascript:ShowHide();" TabIndex="40">
                                    <asp:ListItem>User</asp:ListItem>
                                    <asp:ListItem>Location</asp:ListItem>
                                </asp:DropDownList></td>
                            <td>
                                &nbsp;<asp:ImageButton ImageUrl="~/EmployeeData/Common/images/refresh.gif" ID="ibtnRefresh"
                                    ImageAlign="middle" runat="server" CausesValidation="false" OnClick="ibtnRefresh_Click" />&nbsp;
                            </td>
                            <td>
                                <asp:UpdatePanel ID="UpdatePanel2" UpdateMode="conditional" runat="server">
                                    <ContentTemplate>
                                        <asp:Button ID="ibtnSearch" Width="20" Style="display: none;" runat="server" OnClick="ibtnSearch_Click" />&nbsp;<asp:HiddenField ID="hidLocSearch" runat ="server" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
                <td align="left" rowspan="1" valign="bottom" class="PageHead " style="height: 10px;padding-bottom:1px;">
                    <table cellpadding="0" cellspacing="0" border="0" style="padding-left: 10px;" width="100%">
                        <tr>
                            <td width="80px">
                                <img id="ibtnEmpData" style="cursor:hand;" runat=server align="absbottom" src="Common/images/tab_empdata_n.gif" onclick="javascript:LoadTabData('EmployeeData')" />
                            </td>
                            <td style="padding-left: 2px" width="80px">
                                <img id="ibtnUserSetting" style="cursor:hand;" runat=server align="absbottom" src="Common/images/tab_userset_n.gif"
                                    onclick="javascript:LoadTabData('Settings')" />
                            </td>
                            <td style="padding-left: 2px" width="100px">
                                <img id="ibtnUserSecurity" style="cursor:hand;" runat=server align="absbottom" src="Common/images/tab_usersecurity_n.gif"
                                    onclick="javascript:LoadTabData('Security')" />
                            </td>
                            <td align=right style="padding-right:15px;">                            
                                <asp:UpdateProgress ID="upPanel" runat="server" DisplayAfter="1" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <asp:Label ID="lblprogress" Font-Size=8 Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Text="Loading..."></asp:Label>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>                            
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr width="28%">
                <td valign="top" style="height: 25px;">
                    <asp:Panel ID="pnlSearch" runat="server" Height="30px" DefaultButton="ibtnSearchByButton">
                        <table cellpadding="0" cellspacing="0" border="0" class="Search BlueBorder" width="100%">
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt boldText">
                                    <asp:DropDownList ID="ddlSearch" runat="server" Width="120px" CssClass="FormCtrl"
                                        TabIndex="41">
                                        <asp:ListItem Text="User's Name" Selected="True" Value="Name"></asp:ListItem>
                                        <asp:ListItem Text="User Name" Value="UserName"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtSearch" runat="server" Width="120px" MaxLength="40" TabIndex="42"
                                        CssClass="FormCtrl"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:ImageButton runat="server" ID="ibtnSearchByButton" ImageUrl="~/EmployeeData/Common/images/lens.gif"
                                        ImageAlign="Left" OnClick="ibtnSearchByButton_Click" CausesValidation="false"
                                        TabIndex="43" Width="20px" />
                                </td>
                            </tr>
                        </table><asp:HiddenField ID="hidMode" runat ="server" />
                    </asp:Panel>
                </td>
                <td align="left" valign="top" rowspan="4">
                    <asp:UpdatePanel ID="upnlData" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <div id="divEmployee" runat="server">
                                <uc5:EmployeeData ID="ucEmpData" runat="server" OnBubbleClick="Delete_Click" />
                            </div>
                            <div id="divUserSetting" runat="server">
                                <uc6:UserSettings ID="ucSetting" runat="server" />
                            </div>
                            <div id="divUSerSecurity" runat="server">
                                <uc7:UserSecurity ID="ucSecurity" runat="server" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td valign="top" width="28%" class="BlueBorder">
                    <asp:UpdatePanel ID="upnlMenu" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <table id="LeftMenu" width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr valign="top">
                                    <td width="97%" valign="top">
                                        <div id="divUser" runat="server">
                                            <uc4:LeftUser ID="ucUser" runat="server" />
                                            <asp:Button ID="btnBindUsers" Width="20" Style="display: none;" runat="server" OnClick="btnBindUsers_Click" />
                                        </div>
                                        <div id="divLocation" runat="server" style="display: none;">
                                            <uc3:LeftFrame ID="ucLocation" runat="server" />
                                        </div>
                                        <asp:HiddenField ID="hidLeftFrameBindMode" runat="server" />
                                    </td>
                                </tr>
                            </table>
                            <asp:HiddenField ID="hidUser" runat="server" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td valign="top" width="28%" class="Search BlueBorder">
                    <asp:UpdatePanel ID="upnlSearchResult" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <table cellpadding="0" cellspacing="0" border="0" class="Search " width="100%">
                                <tr>
                                    <td class="Left2pxPadd DarkBluTxt boldText" width="86px">
                                        Search Results:
                                    </td>
                                    <td align="left">
                                        <asp:Label ID="lblSearch" runat="server" CssClass="lbl_whitebox" Font-Bold="true"
                                            Width="120px"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td width="28%" class="BluBg buttonBar" height="30px">
                    <table cellpadding="0" cellspacing="0" style="padding-top: 1px;">
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="upnlMessage" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" valign="top">
                    <table width="100%">
                        <uc2:BottomFooter ID="ucFooter" Title="User Master" runat="server" />
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
