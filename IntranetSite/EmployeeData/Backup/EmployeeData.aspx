<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EmployeeData.aspx.cs" Inherits="EmployeeData" %>

<%@ Register Src="~/EmployeeData/Common/UserControl/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Data</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
   
   <style >
   .GridHead
{
	background:url(../images/table_HdBg.jpg) repeat-x;
 
}
   </style>
    <script>
     //Script to validate Date
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
	
	if (isDate(dt)==false)
	{
      document.getElementById(id).value="";
		return false
	}
    return true
 }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <table cellpadding="0" cellspacing="0" border="0" width="100%">
         <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        
            <tr height="20px">
                <td>
                    <table cellpadding="0" cellspacing="0" width="100%" class=" Left5pxPadd PageBg">
                        <tr height="20px">
                            <td class=" BannerText " width="70%" >
                                Employee Data
                            </td>
                            <td  align="center">
                            <asp:UpdatePanel ID="upnlEmp" UpdateMode="conditional" runat="server">
                             <ContentTemplate>
                                <asp:ImageButton runat="server" ID="ibtnAdd" ImageUrl="~/EmployeeData/Common/images/newadd.gif"
                                    ImageAlign="middle" OnClick="ibtnAdd_Click" />
                                    </ContentTemplate>
                                    </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                <asp:UpdatePanel ID="upnlUser" UpdateMode="conditional" runat="server">
              <ContentTemplate>
                    <table cellpadding="0" cellspacing="0" border="0" class="Left5pxPadd">
                        <tr>
                            <td class=" DarkBluTxt boldText">
                            
                                <asp:Label ID="Label1" runat="server" Text="UserName:" Width="70px" Font-Underline="true"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblUserName" runat="server" Width="100px"></asp:Label>
                            </td>
                        </tr>
                    </table>
                    </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr class="Left5pxPadd DarkBluTxt boldText">
                <td >
                    <asp:Label ID="Label2" runat="server" Text="Hire Location" Width="100px"></asp:Label>
                </td>
            </tr>
            <tr class="Left5pxPadd ">
                <td>
                    <asp:DropDownList ID="ddlHireLocation" runat="server" Width="150px"  AutoPostBack="true" 
                    CssClass="FormCtrl" OnSelectedIndexChanged="ddlHireLocation_SelectedIndexChanged">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td>
                    <table cellpadding="0" cellspacing="0" border="0" class="Left2pxPadd">
                        <tr class="Left5pxPadd DarkBluTxt boldText">
                            <td  >
                                <asp:Label ID="Label3" runat="server" Text="Employee No" Width="100px"></asp:Label>
                            </td>
                            <td >
                                <asp:Label ID="Label4" runat="server" Text="Status" Width="100px"></asp:Label>
                            </td>
                            <td >
                                <asp:Label ID="Label5" runat="server" Text="Hire Date" Width="100px"></asp:Label>
                            </td>
                        </tr>
                        <tr >
                            <td  width="225px" class="Left5pxPadd">
                                <asp:TextBox ID="txtEmpNo" runat="server" Width="150px"  CssClass="FormCtrl"></asp:TextBox>
                            </td>
                            <td  width="225px">
                                <asp:DropDownList ID="ddlStatus" runat="server" Width="150px" CssClass="FormCtrl">
                                </asp:DropDownList>
                            </td>
                            <td  width="225px">
                                <uc3:novapopupdatepicker ID="dtpHireDate" runat="server" />
                                <%--<asp:TextBox ID="txtHireDate" runat="server" Width="150px"></asp:TextBox>--%>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="height: 43px">
                    <table cellpadding="0" cellspacing="0" border="0" class="Left5pxPadd">
                        <tr>
                            <td colspan="3"  width="370px" class=" DarkBluTxt boldText">
                                <asp:Label ID="Label6" runat="server" Text="Employee Name" Width="150px"></asp:Label>
                            </td>
                            <td width="100px" class=" DarkBluTxt boldText">
                                <asp:Label ID="Label28" runat="server" Text="Salutation" Width="100px"></asp:Label>
                            </td>
                        </tr>
                        <tr >
                            <td >
                                <asp:TextBox ID="txtFirstName" runat="server" Width="125px"  CssClass="FormCtrl"></asp:TextBox>
                            </td>
                            <td >
                                <asp:TextBox ID="txtMiddleName" runat="server" Width="50px"  CssClass="FormCtrl"></asp:TextBox>
                            </td>
                            <td  width="150px">
                                <asp:TextBox ID="txtLastName" runat="server" Width="125px"  CssClass="FormCtrl"></asp:TextBox>
                            </td>
                            <td width="150px">
                                <asp:DropDownList ID="ddlSalutation" runat="server" Width="75px" CssClass="FormCtrl">
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table cellpadding="0" cellspacing="0" border="0">
                        <tr class="Left5pxPadd">
                            <td  width="250px" colspan="2" class="DarkBluTxt boldText">
                                <asp:Label ID="Label7" runat="server" Text="Email Address" Width="100px"></asp:Label>
                            </td>
                            <td  width="150px" class="Left2pxPadd DarkBluTxt boldText">
                                <asp:Label ID="Label8" runat="server" Text="Phone No" Width="100px"></asp:Label>
                            </td>
                            <td class=" DarkBluTxt boldText">
                                <asp:Label ID="Label9" runat="server" Text="Fax No" Width="100px"></asp:Label>
                            </td>
                        </tr>
                        <tr class="Left5pxPadd" >
                            <td>
                                <asp:TextBox ID="txtEmail" runat="server" Width="150px"  CssClass="FormCtrl"></asp:TextBox>
                            </td>
                            <td  width="150px" class="Left2pxPadd DarkBluTxt boldText">
                                <asp:Label ID="Label10" runat="server" Text="@porteousfastener.com" Width="120px"></asp:Label>
                            </td>
                            <td >
                                <asp:TextBox ID="txtPhone" runat="server" Width="150px"  CssClass="FormCtrl"></asp:TextBox>
                            </td>
                            <td >
                                <asp:TextBox ID="txtFax" runat="server" Width="150px"  CssClass="FormCtrl"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                <asp:UpdatePanel ID="upnlDept" UpdateMode="conditional" runat="server">
              <ContentTemplate>
                    <table cellpadding="0" cellspacing="0" border="0" class="Left5pxPadd">
                        <tr>
                            <td  width="150px" class=" DarkBluTxt boldText">
                                <asp:Label ID="Label11" runat="server" Text="Department" Width="100px"></asp:Label>
                            </td>
                            <td  width="150px" class=" DarkBluTxt boldText">
                                <asp:Label ID="Label12" runat="server" Text="Position" Width="100px"></asp:Label>
                            </td>
                            <td  width="150px" class=" DarkBluTxt boldText">
                                <asp:Label ID="Label13" runat="server" Text="Shift" Width="100px"></asp:Label>
                            </td>
                            <td  width="150px" class=" DarkBluTxt boldText">
                                <asp:Label ID="Label14" runat="server" Text="Supervisior" Width="100px"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td >
                                <asp:DropDownList ID="ddlDepartment" runat="server" Width="150px" CssClass="FormCtrl">
                                </asp:DropDownList>
                            </td>
                            <td >
                                <asp:DropDownList ID="ddlPosition" runat="server" Width="150px" CssClass="FormCtrl">
                                </asp:DropDownList>
                            </td>
                            <td >
                                <asp:DropDownList ID="ddlShift" runat="server" Width="80px" CssClass="FormCtrl">
                                </asp:DropDownList>
                            </td>
                            <td >
                                <asp:DropDownList ID="ddlSupervisior" runat="server" Width="150px" CssClass="FormCtrl">
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="height: 80px">
                    <table cellpadding="0" cellspacing="0" border="0" class="Left5pxPadd" >
                        <tr height="20px" class="DarkBluTxt boldText">
                            <td  width="150px" >
                                <asp:Label ID="Label15" runat="server" Text="PayCode" Width="100px"></asp:Label>
                            </td>
                            <td width="150px" >
                                <asp:Label ID="Label16" runat="server" Text="Payroll Employee No" Width="150px"></asp:Label>
                            </td>
                            <td  width="150px" >
                                <asp:Label ID="Label17" runat="server" Text="Payroll Location" Width="100px"></asp:Label>
                            </td>
                        </tr>
                        <tr height="20px">
                            <td >
                                <asp:DropDownList ID="ddlPayCode" runat="server" Width="150px" CssClass="FormCtrl">
                                </asp:DropDownList>
                            </td>
                            <td >
                            <asp:TextBox ID="txtPayrollEmpNo" runat="server" Width="120px"  CssClass="FormCtrl"></asp:TextBox>
                                
                            </td>
                            <td >
                                <asp:DropDownList ID="ddlPayrollLoc" runat="server" Width="150px" CssClass="FormCtrl">
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="height: 15px">
                
                </td>
            </tr>
            
            <tr>
                <td >
                    <table cellpadding="0" cellspacing="0" border="0" align="center" class="Left5pxPadd BlueBorder" >
                    <tr>
                    <td  colspan="6" >
                    <table cellpadding="0" cellspacing="0" border="1" bgcolor="#f4fbfd"  width="100%">
                    
                        <tr height="25px" class="Left5pxPadd GridHead "  >
                            <td  width="150px" colspan="2" >
                                <asp:Label ID="Label18" runat="server" Text="Paid Hours"></asp:Label>
                            </td>
                            <td  width="250px" colspan="2" >
                                <asp:Label ID="Label19" runat="server" Text="Leave of Absence days "></asp:Label>
                            </td>
                            <td  width="200px" colspan="2" >
                                <asp:Label ID="Label20" runat="server" Text="Benefits Amount"></asp:Label>
                            </td>
                        </tr>
                    </table>
                    </td>
                    </tr>
                        <tr>
                            <td  width="100px" class="Left2pxPadd DarkBluTxt boldText">
                                <asp:Label ID="Label21" runat="server" Text="Holiday"></asp:Label>
                            </td>
                            <td  width="50px">
                                <asp:TextBox ID="txtHoliday" runat="server" Width="50px"  CssClass="FormCtrl"></asp:TextBox>
                            </td>
                            <td  width="100px" class="Left2pxPadd DarkBluTxt boldText">
                                <asp:Label ID="Label22" runat="server" Text="Begin "  ></asp:Label>
                            </td>
                            <td  width="50px">
                                <asp:TextBox ID="txtBegin" runat="server" Width="100px"  CssClass="FormCtrl"  onblur="javascript:alert(10);ValidateDate(this.id);"></asp:TextBox>
                            </td>
                            <td  width="100px" class=" DarkBluTxt boldText">
                                <asp:Label ID="Label23" runat="server" Text="BALANCE"></asp:Label>
                            </td>
                            <td  width="50px">
                                <asp:TextBox ID="txtBalance" runat="server" Width="100px"  CssClass="FormCtrl"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td width="100px" class=" Left2pxPadd DarkBluTxt boldText">
                                <asp:Label ID="Label24" runat="server" Text="Sick"></asp:Label>
                            </td>
                            <td  width="100px">
                                <asp:TextBox ID="txtSick" runat="server" Width="50px"  CssClass="FormCtrl"></asp:TextBox>
                            </td>
                            <td  width="100px" class="Left2pxPadd DarkBluTxt boldText">
                                <asp:Label ID="Label25" runat="server" Text="End "></asp:Label>
                            </td>
                            <td  width="100px">
                                <asp:TextBox ID="txtEnd" runat="server" Width="100px"  onblur="javascript:ValidateDate(this.id);" CssClass="FormCtrl"></asp:TextBox>
                            </td>
                            <td style="padding-left: 5px; height: 20px" width="100px" colspan="2">
                            </td>
                        </tr>
                        <tr>
                            <td  width="100px" class="Left2pxPadd DarkBluTxt boldText">
                                <asp:Label ID="Label26" runat="server" Text="Vacation"></asp:Label>
                            </td>
                            <td  width="100px">
                                <asp:TextBox ID="txtVacation" runat="server" Width="50px"  CssClass="FormCtrl"></asp:TextBox>
                            </td>
                            <td  width="100px" class="Left2pxPadd DarkBluTxt boldText">
                                <asp:Label ID="Label27" runat="server" Text="BALANCE"></asp:Label>
                            </td>
                            <td  width="100px">
                                <asp:TextBox ID="txtAbsenceBal" runat="server" Width="100px"  CssClass="FormCtrl" onblur="javascript:ValidateDate(this.id);"></asp:TextBox>
                            </td>
                            <td  width="100px" colspan="2">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            
            
            
        </table>
    </form>
</body>
</html>
