<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ACAdmin.aspx.vb" Inherits="ACAdmin" %>

<%@ Register Src="Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc4" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/newfooter.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Average Cost Admin Adjustments</title>

    <script type="text/javascript" src="date.js"></script>

    <script type="text/javascript">
    function LoadHelp()
    {
     window.open("Common/Help/AdminHelp.htm",'HelpWindow','height=710,width=1020,scrollbars=yes,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
       
    }  
      function Loadreport()
    {
    if(document.getElementById("lblMessage") != null && document.getElementById("lblMessage").innerText=="")
    {
        var hwin= window.open("exceptions.aspx",'exceptions','height=710,width=1020,scrollbars=yes,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
        hwin.focus();
       return false;
       }
    }  
    function KeyPress(control)
    {
    if(event.keyCode==13){
    document.getElementById('hidValue').value='Load';
    control.blur();}
    }
    
    //********************************************* Validate Date ************************************************************************************************************************************************************************************************************************************************************// 
// To validate the Date

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
	// If dashes aren't there, add them
	if (pos1==-1 ){
		dtStr=dtStr.substring(0,2) + dtCh + dtStr.substring(2,4) + dtCh + dtStr.substring(4)
		pos1=dtStr.indexOf(dtCh)
	}
	var pos2=dtStr.indexOf(dtCh,pos1+1)
	var strMonth=dtStr.substring(0,pos1)
	var strDay=dtStr.substring(pos1+1,pos2)
	var strYear=dtStr.substring(pos2+1)
	var curDate = new Date()
	var curYear = new String(curDate.getFullYear())
	if (strYear.length == 2 ){
	    strYear=curYear.substring(0,2) + strYear
		dtStr=dtStr.substring(0,6) + strYear
	}
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
		alert("Please enter a valid year ")
		return false
	}
	if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false){
		alert("Please enter a valid date")
		return false
	}
return dtStr
}
function ValidateDate(dateObject){
	
	var txtDate = dateObject.value;
	var txtID = dateObject.id;
	if(txtDate!="")
	{
	    if (isDate(txtDate.replace(/\s/g,''))==false){
	        document.getElementById(txtID).value="";
		    document.getElementById(txtID).focus()
		    document.getElementById('hidValue').value="";
		    return false
	    }
	    // If the date is good, call it again to get it back formatted
	    document.getElementById(txtID).value=isDate(txtDate.replace(/\s/g,''))
        return true
    }
 }
    </script>

    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="upPanel" runat="server" UpdateMode="always">
        <ContentTemplate>
          <table width="100%" border="0" cellspacing="0" cellpadding="2">
            <tr>
                <td>
                    <uc3:PageHeader ID="PageHeader1" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                  
                        <table cellspacing="2" cellpadding="2" width="100%">
                            <tr>
                                <td class="PageHead" style="height: 40px" width="100%">
                                   <table width="100%"><tr><td> <div class="LeftPadding">
                                        <div align="left" class="BannerText">
                                            Average Cost Exception Resolution Processing</div>
                                    </div></td>
                                    <td><div class="LeftPadding"><div align="right" class="BannerText" > <img tabindex="5" src="../Common/images/close.gif" onclick="javascript:window.history.back();" style="cursor:hand"/></div></td></tr></table>
                                   
                                   
                                    
                                </td>
                               
                            </tr>
                             <tr>
                                <td class="LeftPadding">
                                    <table border="0" cellspacing="5" cellpadding="2">
                                        <tr>
                                            <td>
                                                Exception Date </td>
                                            <td>
                                                <asp:TextBox TabIndex="1" onkeydown="javascript:KeyPress(this);" onchange = "javascript:ValidateDate(this);" ID="ExcpLmtDate" CssClass="FormCtrl" runat="server" 
                                                    CausesValidation="True" OnTextChanged="ExcpLmtDate_TextChanged" ToolTip="From Date for exceptions to Resolve" AutoPostBack="True" /><asp:Label ID="lblDateMessage" runat="server" Text="" ForeColor=red></asp:Label></td>
                                        </tr>
                                    <%--    <tr>
                                            <td>
                                                Administrative Adjustment Authorization:</td>
                                            <td>
                                                <asp:TextBox ID="Author" CssClass="FormCtrl" runat="server" CausesValidation="True"
                                                    AutoPostBack="True" /></td>
                                        </tr>--%>
                                        <tr>
                                            <td>
                                                Adjustment Effective Date</td>
                                            <td>
                                                <asp:TextBox TabIndex="2" OnTextChanged="EffectiveDt_TextChanged" onkeydown="javascript:KeyPress(this);" onchange = "javascript:ValidateDate(this);" ID="EffectiveDt" CssClass="FormCtrl" runat="server" CausesValidation="True"
                                                    AutoPostBack="True" /><asp:Label ID="lblMessage" runat="server" Text="" ForeColor=red></asp:Label></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            
                            <tr>
                                <td class="BluBg" colspan="2" style="padding-left:100px;">
                                    <div class="LeftPadding">
                                            <img src="Common/images/viewReport.gif" runat="server" tabindex="3" ID="DisplayExceptions" onclick="javascript:if(document.getElementById('hidValue').value=='')Loadreport();" style="cursor: hand" />
                                        <img src="Common/images/help.gif" runat="server" onblur="javascript:document.getElementById('ExcpLmtDate').focus();" tabindex="4" onclick="LoadHelp()" style="cursor: hand" />
                                        
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    &nbsp;<asp:hiddenfield ID="hidValue" runat="server"></asp:hiddenfield>

                                </td>
                            </tr>
                        </table>
                        <br />
                  
                </td>
            </tr>
         
        </table>
        </ContentTemplate>
        </asp:UpdatePanel>      
    </form>
</body>
</html>
