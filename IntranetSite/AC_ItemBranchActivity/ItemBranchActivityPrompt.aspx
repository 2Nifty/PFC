<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ItemBranchActivityPrompt.aspx.cs"
    Inherits="PFC.Intranet.ItemBranchActivityPrompt" %>

<%@ Register Src="Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>AC Item Branch Activity Prompt</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

<script language="javascript">


function CheckCrossReferenceNumber(itemNo)
{

    document.getElementById("lblMessage").innerText ="";

    if(itemNo!="")
    {
        var section="";
        var completeItem=0;
        var status = ItemBranchActivityPrompt.GetCrossreference(itemNo).value;

        if(status !="true")
        {
            switch(itemNo.split('-').length)
            {
                case 1:
                    event.keyCode=0;
                    itemNo = "00000" + itemNo;
                    itemNo = itemNo.substr(itemNo.length-5,5);
                    document.getElementById("txtItemNo").value=itemNo+"-"; 
                    break;
                case 2:
                    // close if they are entering an empty part
                    if (itemNo.split('-')[0] == "00000") {ClosePage()};
                    event.keyCode=0;
                    section = "0000" + itemNo.split('-')[1];
                    section = section.substr(section.length-4,4);
                    document.getElementById("txtItemNo").value=itemNo.split('-')[0]+"-"+section+"-";  
                    break;
                case 3:
                    event.keyCode=0;
                    section = "000" + itemNo.split('-')[2];
                    section = section.substr(section.length-3,3);
                    document.getElementById("txtItemNo").value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
                    completeItem=1;
                    break;
            }

            if (completeItem==1)
            {
                itemNo = document.getElementById("txtItemNo").value;
                var status = ItemBranchActivityPrompt.GetCrossreference(itemNo).value;
                if(status !="true")
                {
                    document.getElementById("txtItemNo").value = "";
                    document.getElementById("lblMessage").innerText ="Item not found";
                }
                else
                    ViewReport();
            }
        }
        else
            ViewReport();
    }
}

function ViewReport()
{
    if(document.getElementById("hidEndDt").value == "1/1/0001" || document.getElementById("hidStartDt").value == "1/1/0001")
    {
        alert('Please select beginning & ending date');
    }
    else
    { 
        if(document.form1.txtItemNo.value == "")
        {
            alert('Please enter a valid item #');
        }
        else
        {
            var Url =   "ItemBranchActivity.aspx?BeginDt=" + document.getElementById("hidStartDt").value + "~EndDt=" + document.getElementById("hidEndDt").value +
                        "~Branch=" + document.form1.ddlBranch.value + "~ItemNo=" + document.form1.txtItemNo.value;

            Url = "ProgressBar.aspx?destPage=" + Url;
            window.open(Url,'ItemBranchActivity','height=710,width=1020,scrollbars=no,status=yes,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
        }
    }
}

function LoadHelp()
{
    window.open('Help.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
}

</script>

</head>
<body scroll="auto">
    <form id="form1" runat="server">
        <table width="100%">
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td valign="top">
                                <uc1:PageHeader ID="PageHeader1" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="height: 100%;">
                                <asp:ScriptManager runat="server" ID="scmPostBack">
                                </asp:ScriptManager>
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td class="PageHead" style="height: 40px" width="75%">
                                            <div class="LeftPadding">
                                                <div align="left" class="BannerText">
                                                    AC Item Branch Activity Filter Menu</div>
                                            </div>
                                        </td>
                                        <td class="PageHead" style="height: 40px; width: 275px;">
                                            <div class="LeftPadding">
                                                <div align="right" class="BannerText">
                                                    <img src="../Common/images/close.gif" onclick="javascript:window.location='/intranetsite/AC_AdminCostAdj/AvgCstDashBoard.aspx';" style="cursor: hand" /></div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table border="0" cellspacing="0" cellpadding="3">
                                                <tr id="tdRange" runat="server">
                                                    <td colspan="2" style="width: 400px; height: 20px">
                                                        <asp:UpdatePanel runat="server" ID="upPostBack">
                                                            <ContentTemplate>
                                                                <table>
                                                                    <tr>
                                                                        <td style="height: 12px; width: 165px;">
                                                                            <asp:Label ID="lblStartDt" runat="server" Text="Beginning Date" Width="93px" Font-Bold="True"
                                                                                ForeColor="Red"></asp:Label>
                                                                        </td>
                                                                        <td>&nbsp;</td>
                                                                        <td>
                                                                            <asp:Label ID="lblEndDt" runat="server" Text="Ending Date" Width="67px" Font-Bold="True"
                                                                                ForeColor="Red"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 165px; height: 12px">
                                                                            <asp:Calendar ID="cldStartDt" runat="server" Visible="true" OnSelectionChanged="cldStartDt_SelectionChanged"
                                                                                Width="150px"></asp:Calendar>
                                                                            <input type="hidden" id="hidStartDt" runat="server" />
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Calendar ID="cldEndDt" runat="server" Visible="true" OnSelectionChanged="cldEndDt_SelectionChanged"
                                                                                Width="150px"></asp:Calendar>
                                                                            <input type="hidden" id="hidEndDt" runat="server" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                    <td colspan="1" style="width: 560px; height: 20px">
                                                        <table border="0" cellpadding="5" cellspacing="0" style="width: 200px;">
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="lblBranch" runat="server" Text="Branch"></asp:Label>
                                                                </td>
                                                                <td colspan="3">
                                                                    <asp:DropDownList ID="ddlBranch" runat="server" CssClass="FormCtrl" Width="207px">
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="lblItem" runat="server" Text="Item #"></asp:Label>
                                                                </td>
                                                                <td colspan="3">
                                                                    <asp:TextBox AutoCompleteType="Disabled" ID="txtItemNo" MaxLength="30" runat="server" CssClass="FormCtrl" Width="200px"
                                                                        onkeydown="javascript:if(event.keyCode==9){CheckCrossReferenceNumber(this.value);return false;}"
                                                                        onkeypress="javascript:if(event.keyCode==13)CheckCrossReferenceNumber(this.value);"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 100px">&nbsp</td>
                                                                <td colspan="3">
                                                                    <asp:Label ID="lblMessage" ForeColor="red" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 100%" valign="top">
                            <asp:UpdatePanel runat="server" ID="pnlStatus">
                                <ContentTemplate>
                                    <asp:Label ID="lblError" runat="server" Font-Bold="True" ForeColor="Red" Text=""
                                        Visible="false" Width="67px"></asp:Label></td>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </tr>
                        <tr>
                            <td class="BluBg" style="">
                                <div class="LeftPadding">
                                    <span class="LeftPadding" style="vertical-align: middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <img id="Img1" src="../common/images/viewReport.gif" style="cursor: hand" onclick="javascript:ViewReport();" />&nbsp;<img
                                            src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />&nbsp;
                                    </span>
                                </div>
                            </td>
                            <td class="BluBg">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
