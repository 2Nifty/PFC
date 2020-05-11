<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BranchItemSalesAnalysisUserPrompt.aspx.cs"    Inherits="BranchItemSalesAnalysisUserPrompt" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Branch Item Sales Analysis User Prompt</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>

function ValidateNumber()
{
     if (window.event.keyCode < 47 || window.event.keyCode > 58) window.event.keyCode = 0;
}

function ValidateText(sender,args)
{
    var validCtl=document.getElementById("csvCategory");
    var fromCategory=document.getElementById("txtCatFrom");
    var toCategory=document.getElementById("txtCatTo");
    switch(toCategory.value.length)
    {
        case 0:
            if(fromCategory.value.length==0)
                args.IsValid=true;
            else
            {
                args.IsValid=false;
                validCtl.innerHTML="Check From Category";
            }
            break;
        default:
            if(fromCategory.value.length==0&&toCategory.value.length!=0)
            {
                args.IsValid=false;
                validCtl.innerHTML="Check to category";
            }
            else
                args.IsValie=true;
        break;
                
    }
}
function LoadHelp()
{
 window.open("../Help/HelpFrame.aspx?Name=BranchItem",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
   
}
function CheckLength(sender,args)
{
    var validCtl=document.getElementById("csvLength");
    var fromCategory=document.getElementById("txtCatFrom");
    var toCategory=document.getElementById("txtCatTo");
    if(fromCategory.value.length==0&&toCategory.value.length==0)
        args.IsValid=true;
    else
       if(fromCategory.value.length==5&&toCategory.value.length==5)
            args.IsValid=true;
        else
        {
            args.IsValid=false;
            validCtl.innerHTML="Check the from and to category it should be 5 digits";
        }
}
function ViewReport()
{
    var Url = "BranchItemSalesAnalysis.aspx?Month=" + document.form1.ddlMonth.value + "~Year=" + document.form1.ddlYear.value + "~Branch=" + document.form1.ddlBranch.value +"~MonthName="+document.form1.ddlMonth.options[document.form1.ddlMonth.selectedIndex].text +"~BranchName="+document.form1.ddlBranch.options[document.form1.ddlBranch.selectedIndex].text +
     "~CategoryFrom="+ document.form1.txtCatFrom.value + "~CategoryTo=" + document.form1.txtCatTo.value+"~VarianceFrom="+document.form1.txtVariance.value+ "~VarianceTo="+document.form1.txtVarianceTo.value+"~SalesRep="+document.form1.ddlRep.options[document.form1.ddlRep.selectedIndex].text.replace("'","|");
    Url = "ProgressBar.aspx?destPage="+Url;
    window.open(Url,"BranchItemSalesAnalysis" ,'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
}

    </script>

</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="upanel" runat="server" UpdateMode="conditional">
        <ContentTemplate>
            <table  width="100%">
            <tr>
            <td>                
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="top" >
                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                </td>
                   
            </tr>
            <tr>
                <td width="100%" height="100%" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="2" >
                        <tr>
                            <td class="PageHead" style="height: 40px">
                            <div class="LeftPadding"><div align="left" class="BannerText"> Branch Item Sales Analysis Report</div></div></td>
                            <td class="PageHead"  style="height: 40px" >
                            <div class="LeftPadding"><div align="right" class="BannerText" > <img src="../Common/images/close.gif" onclick="javascript:window.history.back();" style="cursor:hand"/></div></div></td>
                        </tr>
                        <tr>
                            <td colspan="2">
<table border="0" cellspacing="0" cellpadding="3" style="width: 794px; height: 131px" >
    <tr>
            <td style="width: 93px">
                <span class="LeftPadding">Period</span>
            </td>
            <td colspan="3" style="height: 26px;">
                <table align=left>
                <tr>
                 <td><asp:DropDownList ID="ddlMonth" runat="server" CssClass="FormCtrl" Width="115px">
                    
                    <asp:ListItem Text="January" Value="01"></asp:ListItem>
                    <asp:ListItem Text="February" Value="02"></asp:ListItem>
                    <asp:ListItem Text="March" Value="03"></asp:ListItem>
                    <asp:ListItem Text="April" Value="04"></asp:ListItem>
                    <asp:ListItem Text="May" Value="05"></asp:ListItem>
                    <asp:ListItem Text="June" Value="06"></asp:ListItem>
                    <asp:ListItem Text="July" Value="07"></asp:ListItem>
                    <asp:ListItem Text="August" Value="08"></asp:ListItem>
                    <asp:ListItem Text="September" Value="09"></asp:ListItem>
                    <asp:ListItem Text="October" Value="10"></asp:ListItem>
                    <asp:ListItem Text="November" Value="11"></asp:ListItem>
                    <asp:ListItem Text="December" Value="12"></asp:ListItem>
                    </asp:DropDownList>
                 </td>
                 <td style="width: 140px; height: 22px;">
                    <asp:DropDownList ID="ddlYear" runat="server" CssClass="FormCtrl" Width="66px">
                    </asp:DropDownList>
                 </td>
                 </tr>
                </table>
            </td>
    </tr>
    <tr>
            <td style="width: 93px">
            <span class="LeftPadding">Branch</span></td>
            <td colspan="3" style="width: 288px">
                <asp:DropDownList ID="ddlBranch" runat="server" CssClass="FormCtrl" Width="190px" AutoPostBack=true OnSelectedIndexChanged="ddlBranch_SelectedIndexChanged">
                </asp:DropDownList>
            </td>
    </tr>
    <tr>
        <td style="width: 93px"><span class="LeftPadding">Sales Rep</span></td>
        <td colspan="3" style="width: 288px">
            <asp:DropDownList ID="ddlRep" runat="server" CssClass="FormCtrl" Width="190px">
            </asp:DropDownList></td>
    </tr>
    <tr>
        <td style="width: 93px; height: 33px;">
            <span class="LeftPadding">Category From</span></td>
        <td style="width: 99px; height: 33px;" >
            <asp:TextBox ID="txtCatFrom" runat="server" CssClass="FormCtrl"  onkeyPress="javascript:ValidateNumber(this);" MaxLength="5" Width="121px"></asp:TextBox>
   
        </td>
        <td style="width: 81px; height: 33px;">
            <span class="LeftPadding">Thru</span></td>
        <td style="width: 483px; height: 33px;">
            <asp:TextBox ID="txtCatTo" runat="server" CssClass="FormCtrl"  onkeyPress="javascript:ValidateNumber(this);"  MaxLength="5" Width="113px"></asp:TextBox></td>
    </tr>
    <tr>
        <td style="width: 93px" ><span class="LeftPadding">Variance From</span></td>
        <td style="width: 99px" >
            <asp:TextBox ID="txtVariance" runat="server" MaxLength="3"  onkeyPress="javascript:ValidateNumber(this);" CssClass="FormCtrl" Width="120px"></asp:TextBox></td>
        <td style="width: 81px">
            <span class="LeftPadding">Thru</span>
        </td>
        <td style="width: 483px">
            <asp:TextBox ID="txtVarianceTo" runat="server" CssClass="FormCtrl" MaxLength="3"  onkeyPress="javascript:ValidateNumber(this);" Width="113px"></asp:TextBox></td>
</tr>

</table>
                            </td>
                        </tr>
            <tr>
                <td  class="BluBg" style="height: 27px">
                    <div class="LeftPadding"><span class="LeftPadding" style="vertical-align:middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img id=Img1  src="../common/images/viewReport.gif" style="cursor:hand" onclick="javascript:ViewReport();" />&nbsp;<img src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor:hand"  /></span></div></td>
                <td  class="BluBg" style="height: 27px">
                    
                    
                    </td>
                    </tr>
                    </table>
                </td>
            </tr>
        </table>
        </table>    
        </ContentTemplate>
        </asp:UpdatePanel>
    </form>

   

</body>
</html>
