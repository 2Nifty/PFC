<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CategoryTrendAnalysisUserPrompt.aspx.cs" Inherits="Sales_Analysis_Report_CategoryTrendAnalysisUserPrompt" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>CategoryTrend Analysis User Prompt</title>
    <link href="Stylesheet/Styles.css" rel="stylesheet"
        type="text/css" />
    <Script>

function NewWindow()
{
    var msg=document.getElementById("Label1");
    var stMonth=document.getElementById("ddlStMonth").options[document.getElementById("ddlStMonth").selectedIndex].value;
    
    var endMonth=document.getElementById("ddlEndMonth").options[document.getElementById("ddlEndMonth").selectedIndex].value;
    var stYear=document.getElementById("ddlStYear").options[document.getElementById("ddlStYear").selectedIndex].text;
    var endYear=document.getElementById("ddlEndYear").options[document.getElementById("ddlEndYear").selectedIndex].text;
    if(stMonth!=0)
    {
        if(endMonth!=0)
        {
            if(stYear<=endYear)
            {
                
               // if(document.getElementById("ddlBranch").options[document.getElementById("ddlBranch").selectedIndex].value!=0)
                {
                    msg.style.display='none';
                    var startDate=stMonth+"/"+stYear;
                    var endDate=endMonth+"/"+endYear;
                    var strUrl="Branch=" + document.getElementById("ddlBranch").options[document.getElementById("ddlBranch").selectedIndex].text+
                                                                      "~BranchID=" + document.getElementById("ddlBranch").options[document.getElementById("ddlBranch").selectedIndex].value+
                                                                      "~StDate=" + startDate +
                                                                      "~EndDate=" + endDate +
                                                                      "~Period=" +
                                                                      document.getElementById("ddlStMonth").options[document.getElementById("ddlStMonth").selectedIndex].text+
                                                                      stYear.substring(2,4)+ "." +
                                                                      document.getElementById("ddlEndMonth").options[document.getElementById("ddlEndMonth").selectedIndex].text+
                                                                      endYear.substring(2,4)+
                                                                      "~CategoryFrom="+document.getElementById("txtCatFrom").value+"~CategoryTo="+document.getElementById("txtCatTo").value
                                                                      +"~VarianceFrom="+document.getElementById("txtVariance").value
                                                                      +"~VarianceTo="+document.getElementById("txtVarianceTo").value
                                                                      +"~MonthName="+document.form1.ddlStMonth.options[document.form1.ddlStMonth.selectedIndex].text
                                                                      +"~BranchName="+document.form1.ddlBranch.options[document.form1.ddlBranch.selectedIndex].text
                                                                      +"~SalesRep="+document.form1.ddlRep.options[document.form1.ddlRep.selectedIndex].text.replace("'","|");

                    var a=window.screen.availWidth-60;
                    
                    //window.open('CategoryTrendAnalysis.aspx?'+strUrl, '', 'width='+window.screen.availWidth+',height='+a+', top=0,left=0');
                    
                    var Url = 'CategoryTrendAnalysis.aspx?'+strUrl;
                    Url = "ProgressBar.aspx?destPage="+Url;
                    window.open(Url,"CategoryTrendAnalysis" ,'height=700,width=840,scrollbars=no,status=no,top='+((screen.height/2) - (700/2))+',left='+((screen.width/2) - (840/2))+',resizable=YES',"");
                    }
                    //else
                    //{
                    //    msg.style.display='';
                    //    msg.innerHTML="Select Branch";
                    //}
            }
            else
            {
                msg.style.display='';
                msg.innerHTML="End year must be greater than  or equal to starting year";
            }
        }
        else
        {
            msg.style.display='';
            msg.innerHTML="Select End Month"
        }
    }
    else
    {
        msg.style.display='';
        msg.innerHTML="select Starting Month"
    }
}

function ValidateNumber()
{
     if (window.event.keyCode < 47 || window.event.keyCode > 58) window.event.keyCode = 0;
}
function LoadHelp()
{
window.open("../Help/HelpFrame.aspx?Name=CategoryTrend",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
   
}

</Script>

</head>
<body>
    <form id="form1" runat="server">
      <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="upanel" runat="server" UpdateMode="conditional">
        <ContentTemplate>
        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="100%" height="400" valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="2">
      <tr>
        <td colspan="2" valign="middle" >
        <table width="100%"  border="0" cellspacing="0" cellpadding="0" >
            <tr>
                <td valign="top" colspan=2>
                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                    </td>
                   
            </tr>
           
            
          <tr>
            <td class="PageHead" style="height: 40px"><div class="LeftPadding"><div align="left" class="BannerText"> Category Trend Analysis Report</div></div></td>
           <td class="PageHead"  style="height: 40px" >
                            <div class="LeftPadding"><div align="right" class="BannerText" > <img src="../Common/images/close.gif" onclick="javascript:window.location.href='ReportsDashBoard.aspx';" style="cursor:hand"/></div></div></td>
          </tr>
        </table>
            </td>
        </tr>
      <tr>
        <td colspan="2" ><table  border="0" cellspacing="0" cellpadding="3">
          <tr>
            <td ><span class="LeftPadding">Start Month</span></td>
            <td colspan="2" style="height: 26px; width: 162px;"><asp:DropDownList ID=ddlStMonth runat=server CssClass="FormCtrl" Width="139px">
                                <asp:ListItem Text="---Select Month---" Value=0></asp:ListItem>
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
            <td style="width: 83px" ><span class="LeftPadding">Year</span></td>
            <td style="height: 26px; width: 135px;" >
                                <asp:DropDownList ID=ddlStYear runat=server CssClass="FormCtrl" Width="131px"></asp:DropDownList></td>
            <td style="width: 250px"><asp:Label CssClass="TabHead" style="display:none;" ID="Label1" runat="server" ForeColor="Red"></asp:Label></td>
          </tr>
            <tr>
                <td><span class="LeftPadding">End Month</span></td>
                <td colspan="2" style="height: 26px; width: 162px;">
                                <asp:DropDownList ID=ddlEndMonth runat=server CssClass="FormCtrl" Width="140px">
                                <asp:ListItem Text="---Select Month---" Value=0></asp:ListItem>
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
                <td style="width: 83px"><span class="LeftPadding">Year</span></td>
                <td style="height: 26px; width: 135px;"><asp:DropDownList ID=ddlEndYear runat=server CssClass="FormCtrl" Width="131px"></asp:DropDownList></td>
                <td style="width: 51px">
                    &nbsp;</td>
            </tr>
            <tr>
                <td><span class="LeftPadding">Branch</span></td>
                <td colspan="2" style="width: 162px"><asp:DropDownList ID=ddlBranch runat=server CssClass="FormCtrl" Width="138px" AutoPostBack=true OnSelectedIndexChanged="ddlBranch_SelectedIndexChanged"></asp:DropDownList></td>
                <td style="width: 83px">
                    &nbsp;</td>
                <td style="width: 135px">
                </td>
                <td style="width: 51px">
                </td>
            </tr> 
            <tr>
        <td style="width: 93px"><span class="LeftPadding">Sales Rep</span></td>
        <td colspan="3" style="width: 288px">
            <asp:DropDownList ID="ddlRep" runat="server" CssClass="FormCtrl" Width="138px" Height="20px">
            </asp:DropDownList></td>
            <td style="width: 135px">
                </td>
                <td style="width: 51px">
                </td>
    </tr>           
          <tr>
            <td ><span class="LeftPadding">Category From</span></td>
            <td colspan="2" style="width: 162px"><asp:TextBox ID="txtCatFrom" onkeypress="ValidateNumber()" runat="server" CssClass="FormCtrl" MaxLength="5" Width="132px"></asp:TextBox></td>
            <td style="width: 83px" ><span class="LeftPadding">Thru</span></td>
            <td style="width: 135px"><asp:TextBox ID="txtCatTo"  runat="server" onkeypress="ValidateNumber()" CssClass="FormCtrl" MaxLength="5" Width="124px"></asp:TextBox></td>
            <td style="width: 51px">
                &nbsp;</td>
          </tr>
            
            <tr>
                <td><span class=LeftPadding>Variance From</span></td>
                <td colspan="2" style="width: 162px"><asp:TextBox ID="txtVariance" runat="server" onkeypress="ValidateNumber()" MaxLength="5" CssClass="FormCtrl" Width="133px"></asp:TextBox></td>
                <td style="width: 83px"><span class="LeftPadding">Thru</span>
                </td>
                <td style="width: 135px">
                    <asp:TextBox ID="txtVarianceTo" runat="server" CssClass="FormCtrl" onkeypress="ValidateNumber()" MaxLength="5" Width="125px"></asp:TextBox></td>
                <td style="width: 51px">
                </td>
            </tr>
        </table></td>
      </tr>
      <tr>
        <td width="8%" class="BluBg">&nbsp;</td>
        <td width="92%" class="BluBg"><img id=btnReport  style="cursor:hand" src="../common/images/viewReport.gif" OnClick="NewWindow()"/>&nbsp;<img src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor:hand" /></td>
      </tr>
    </table></td>
  </tr>
 
</table></ContentTemplate></asp:UpdatePanel>

    
        
                    
            
    </form>
 <SCRIPT language=JavaScript1.2 src="javascript/loadMenus.js"></SCRIPT>

<SCRIPT language=JavaScript1.2 src="javascript/mm_menu.js"></SCRIPT>

<SCRIPT language=JavaScript1.2>mmLoadMenus();</SCRIPT>  

</body>
</html>
