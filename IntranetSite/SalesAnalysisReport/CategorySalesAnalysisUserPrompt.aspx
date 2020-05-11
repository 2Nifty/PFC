<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CategorySalesAnalysisUserPrompt.aspx.cs" Inherits="Sales_Analysis_Report_CategoryTrendAnalysisUserPrompt" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Category Sales Analysis User Prompt</title>
    <link href="Stylesheet/Styles.css" rel="stylesheet"
        type="text/css" />
    <Script>
function ShowHide(SHMode)
{
	if (SHMode.id == "Hide") {
		document.getElementById("HideLabel").style.display = "none";
		document.getElementById("LeftMenu").style.display = "none";
		document.getElementById("LeftMenuContainer").style.width = "1";
		document.getElementById("SHButton").innerHTML = "<img ID='Show' src='Images/ShowButton.gif' width='22' height='21' onClick='ShowHide(this)'>";
		//alert(document.getElementById(SHMode.id));
	}
	if (SHMode.id == "ShowTopMenu") {
		document.getElementById("TopMenu").style.display = "block";
		//document.getElementById("LeftMenu").style.display = "block";
		//document.getElementById("LeftMenuContainer").style.width = "230";
		document.getElementById("TopMenuControl").innerHTML = "<input name='HideTopMenu' id='HideTopMenu' type='button' class='FormButton' value='Hide this Menu' onClick='ShowHide(this)'>";
		//alert(document.getElementById(SHMode.id));
	}
	if (SHMode.id == "HideTopMenu") {
		document.getElementById("TopMenu").style.display = "none";
		//document.getElementById("LeftMenu").style.display = "block";
		//document.getElementById("LeftMenuContainer").style.width = "230";
		document.getElementById("TopMenuControl").innerHTML = "<input name='ShowTopMenu' id='ShowTopMenu' type='button' class='FormButton' value='Show this Menu' onClick='ShowHide(this)'>";
		//alert(document.getElementById(SHMode.id));
	}
	if (SHMode.id == "Show") {
		document.getElementById("HideLabel").style.display = "block";
		document.getElementById("LeftMenu").style.display = "block";
		document.getElementById("LeftMenuContainer").style.width = "230";
		document.getElementById("SHButton").innerHTML = "<img ID='Hide' src='../Common/Images/HidButton.gif' width='22' height='21' onClick='ShowHide(this)'>";
		//alert(document.getElementById(SHMode.id));
	}
}

function LoadHelp()
{
window.open("../Help/HelpFrame.aspx?Name=CategorySales",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
   
}
function NewWindow()
{
    var msg=document.getElementById("Label1");
    var stMonth=document.getElementById("ddlStMonth").options[document.getElementById("ddlStMonth").selectedIndex].value;
    var stYear=document.getElementById("ddlStYear").options[document.getElementById("ddlStYear").selectedIndex].text;
    if(stMonth!=0)
    {
        msg.style.display='none';
        var strUrl="Month=" +stMonth+
                    "~Year="+stYear+
                      "~Period=" +document.getElementById("ddlStMonth").options[document.getElementById("ddlStMonth").selectedIndex].text+" "+stYear+
                      "~CategoryFrom="+document.getElementById("txtCatFrom").value+"~CategoryTo="+document.getElementById("txtCatTo").value+
                      "~VarianceFrom="+document.getElementById("txtVariance").value+
                      "~VarianceTo="+document.getElementById("txtVarianceTo").value
                      +"~MonthName="+document.form1.ddlStMonth.options[document.form1.ddlStMonth.selectedIndex].text;

        var a=window.screen.availWidth-60;
        
        //window.open('CategorySalesAnalysis.aspx?'+strUrl, '', 'width='+window.screen.availWidth+',height='+a+', top=0,left=0,scrollbars=yes');
        
        var Url = 'CategorySalesAnalysis.aspx?'+strUrl;
        Url = "ProgressBar.aspx?destPage="+Url;
        window.open(Url,"CategorySalesAnalysis" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
        
    }
    else
    {
        msg.style.display='';
        msg.innerHTML="Check The Month"
    }
}
function ValidateNumber()
{
     if (window.event.keyCode < 47 || window.event.keyCode > 58) window.event.keyCode = 0;
}

</Script>

</head>
<body>
    <form id="form1" runat="server">
    
        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="100%" height="400" valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="2">
              <tr>
                <td colspan="2" valign="middle" >
                        <table width="100%"  border="0" cellspacing="0" cellpadding="0" >
                            <tr><td valign="top" colspan=2>
                                <uc1:PageHeader ID="PageHeader1" runat="server" />
                            </td></tr>
                            <tr><td class="PageHead" style="height: 40px"><div class="LeftPadding"><div align="left" class="BannerText"> Category Sales Analysis Report</div></div></td>
                                <td class="PageHead"  style="height: 40px" >
                            <div class="LeftPadding"><div align="right" class="BannerText" > <img src="../Common/images/close.gif" onclick="javascript:window.location.href='ReportsDashBoard.aspx';" style="cursor:hand"/></div></div></td>
                            </tr>
                        </table>
                </td>
            </tr>
      <tr>
        <td colspan="2" ><table  border="0" cellspacing="0" cellpadding="3">
          <tr>
            <td ><span class="LeftPadding">Month</span></td>
            <td colspan="2" style="height: 26px; width: 112px;"><asp:DropDownList ID=ddlStMonth runat=server CssClass="FormCtrl" Width="106px">
                                <asp:ListItem Text="--Select Month---" Value=0></asp:ListItem>
                                <asp:ListItem Text="January" Value=1></asp:ListItem>
                                <asp:ListItem Text="February" Value=2></asp:ListItem>
                                <asp:ListItem Text="March" Value=3></asp:ListItem>
                                <asp:ListItem Text="April" Value=4></asp:ListItem>
                                <asp:ListItem Text="May" Value=5></asp:ListItem>
                                <asp:ListItem Text="June" Value=6></asp:ListItem>
                                <asp:ListItem Text="July" Value=7></asp:ListItem>
                                <asp:ListItem Text="August" Value=8></asp:ListItem>
                                <asp:ListItem Text="September" Value=9></asp:ListItem>
                                <asp:ListItem Text="October" Value=10></asp:ListItem>
                                <asp:ListItem Text="November" Value=11></asp:ListItem>
                                <asp:ListItem Text="December" Value=12></asp:ListItem>
                                </asp:DropDownList></td>
            <td ><span class="LeftPadding">Year</span></td>
            <td style="height: 26px" >
                                <asp:DropDownList ID=ddlStYear runat=server CssClass="FormCtrl" Width="106px"></asp:DropDownList></td>
            <td style="width: 250px"><asp:Label CssClass="TabHead" style="display:none;" ID="Label1" runat="server" ForeColor="Red"></asp:Label>
                </td>
          </tr>
          <tr>
            <td ><span class="LeftPadding">Category From</span></td>
            <td colspan="2" style="width: 112px"><asp:TextBox onkeypress="ValidateNumber()" ID="txtCatFrom" runat="server" CssClass="FormCtrl" MaxLength="5"></asp:TextBox></td>
            <td ><span class="LeftPadding">Thru</span></td>
            <td><asp:TextBox ID="txtCatTo"  runat="server" onkeypress="ValidateNumber()" CssClass="FormCtrl" MaxLength="5"></asp:TextBox></td>
            <td style="width: 51px">
                &nbsp;</td>
          </tr>
            <tr>
                <td><span class=LeftPadding>Variance From</span></td>
                <td colspan="2" style="width: 112px"><asp:TextBox ID="txtVariance" onkeypress="ValidateNumber()" runat="server" MaxLength="5" CssClass="FormCtrl"></asp:TextBox></td>
                <td style="width: 83px"><span class="LeftPadding">Thru</span>
                </td>
                <td>
                    <asp:TextBox ID="txtVarianceTo" runat="server" CssClass="FormCtrl" onkeypress="ValidateNumber()" MaxLength="5"></asp:TextBox></td>
                <td style="width: 51px">
                </td>
            </tr>
        </table></td>
      </tr>
      <tr>
        <td width="8%" class="BluBg">&nbsp;</td>
        <td width="92%" class="BluBg"><img id=btnReport  src="../common/images/viewReport.gif" style="cursor:hand" onclick="javascript:NewWindow();" />&nbsp;<img src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor:hand" /></td>
      </tr>
    </table></td>
  </tr>
 
</table>

    
        
                    
            
    </form>
    <SCRIPT language=JavaScript1.2 src="javascript/loadMenus.js"></SCRIPT>

<SCRIPT language=JavaScript1.2 src="javascript/mm_menu.js"></SCRIPT>

<SCRIPT language=JavaScript1.2>mmLoadMenus();</SCRIPT>  

</body>
</html>
