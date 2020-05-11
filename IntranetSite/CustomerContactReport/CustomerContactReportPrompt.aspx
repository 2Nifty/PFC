<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerContactReportPrompt.aspx.cs"
    Inherits="PFC.Intranet.CustomerContactReportPrompt" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Contact Report Prompt</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script language="javascript">

function ViewReport()
{    
    var branchID =document.form1.ddlBranch.value ;    
    var w = document.form1.ddlBranch.selectedIndex;
    var Bselected_text = document.form1.ddlBranch.options[w].text;    
    if(Bselected_text == "All")
        branchID = "";
   
    var customer = document.form1.ddlCustomer.value ; 
    var customerIndex = document.form1.ddlCustomer.selectedIndex;
    var Custselected_text = document.form1.ddlCustomer.options[customerIndex].text;    
    if(Custselected_text == "All")
        customer = "";
        

    var contact = document.form1.ddlContact.value ; 
    var contactIndex = document.form1.ddlContact.selectedIndex;
    var contactselected_text = document.form1.ddlContact.options[contactIndex].text;    
    if(contactselected_text == "ALL")
        contact = "";


    var Buyer = document.form1.ddlBuying.value ; 
    var BuyerIndex = document.form1.ddlBuying.selectedIndex;
    var Buyerselected_text = document.form1.ddlBuying.options[BuyerIndex].value;    
    if(Buyerselected_text == "ALL")
        Buyer = "";

    var hwnd,Url;
          
    Url =   "CustomerContactReportPage.aspx?CustomerType=" + customer + "&Branch=" + branchID + 
            "&ContactType=" + contact+"&BuyingGroup="+ Buyer +
            "&BGName="+ Buyerselected_text +
            "&CustName="+ Custselected_text +
            "&ContName="+ contactselected_text +
            "&BrnName="+ Bselected_text +
            "&FilterDt=" + document.getElementById('hidFilterDt').value;
            
            hwnd=window.open(Url,"CCReport" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
            hwnd.focus();
   
   }
   function LoadHelp()
   {
    window.open("../Help/HelpFrame.aspx?Name=InvoiceReport",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
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
                                                    Customer Contact Report</div>
                                            </div>
                                        </td>
                                        <td class="PageHead" style="height: 40px; width: 275px;">
                                            <div class="LeftPadding">
                                                <div align="right" class="BannerText">
                                                    <img src="../Common/images/close.gif" onclick="javascript:window.close();" style="cursor: hand" /></div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table border="0" cellspacing="0" cellpadding="3">
                                                <tr id="tdRange" runat="server">
                                                    <td colspan="1" style="width: 360px; height: 20px">
                                                        <table border="0" cellpadding="5" cellspacing="0" style="width: 200px;">
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="Label2" runat="server" Text="Branch:"></asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:DropDownList ID="ddlBranch" runat="server" CssClass="FormCtrl" Width="203px">
                                                                    </asp:DropDownList></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="Label1" runat="server" Text="Customer Type:"></asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:DropDownList ID="ddlCustomer" runat="server" CssClass="FormCtrl" Width="203px">
                                                                        <asp:ListItem Text="ALL"></asp:ListItem>
                                                                        <asp:ListItem Text="Mill" Value="1"></asp:ListItem>
                                                                        <asp:ListItem Text="Warehouse" Value="0"></asp:ListItem>
                                                                    </asp:DropDownList></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="Label3" runat="server" Text="Contact Type:"></asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:DropDownList ID="ddlContact" runat="server" CssClass="FormCtrl" Width="203px">
                                                                    </asp:DropDownList></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="Label8" runat="server" Font-Bold="False" Text="Buying Group:" Width="84px"></asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:DropDownList ID="ddlBuying" runat="server" CssClass="FormCtrl" Width="203px">
                                                                        <asp:ListItem Text="ALL"></asp:ListItem>
                                                                    </asp:DropDownList></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="Label4" runat="server" Font-Bold="False" Text="Filter Date:" Width="84px"></asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:UpdatePanel runat="server" ID="pnlDateControl">
                                                                        <ContentTemplate>
                                                                            <table border=0 cellpadding=0 cellspacing=0>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Calendar ID="cdChangeDt" runat="server" OnSelectionChanged="cdChangeDt_SelectionChanged" Width="200px">
                                                                                        </asp:Calendar>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:HiddenField ID="hidFilterDt" runat="server" />
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
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
