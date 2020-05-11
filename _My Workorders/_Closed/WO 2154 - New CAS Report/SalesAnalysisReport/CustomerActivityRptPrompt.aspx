<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerActivityRptPrompt.aspx.cs" Inherits="CustomerActivityRptPrompt" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title>Customer Activity Report Filters</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <script language="javascript" src="../Common/javascript/ContextMenu.js"></script>

    <script language="javascript" type="text/javascript">
        function LoadHelp()
        {
            window.open('CustomerActivityHelp.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
        }
        
        function Close(session)
        {
            CustomerActivityRptPrompt.Close();
            window.location.href = 'ReportsDashBoard.aspx';
        }

        function RptPreview(RecID, RecType)
        {
            var hwnd, Url;
            var _Version, _Group;

            if (document.frmMain("chkCustRpt").checked == true)
                _Version = "Cus";
            if (document.frmMain("chkEmpRpt").checked == true)
                _Version = "Emp";
                
            if (document.frmMain("chkBuyGrpRpt").checked == true)
                _Group = "BuyGroup";
            if (document.frmMain("chkCatRpt").checked == true)
                _Group = "Category";

            Url = "CustomerActivityRpt.aspx" +
                  "?RecID=" + RecID +
                  "&RecType=" + RecType +
                  "&Period=" + document.getElementById("hidPeriod").value +
                  "&Version=" + _Version + 
                  "&Group=" + _Group;

            hwnd=window.open(Url,"CustomerActivityRpt" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
            hwnd.focus();
        }
    </script>
</head>
<body>
    <form id="frmMain" runat="server">
    <asp:ScriptManager ID="smCAR" EnablePartialRendering="true" runat="server"></asp:ScriptManager>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="100%" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td valign="middle">
                                <%--Banner & Title Header--%>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td valign="top" colspan="2">
                                            <uc1:PageHeader ID="PageHeader1" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="PageHead" style="height: 40px; width:620px;">
                                            <div class="LeftPadding BannerText" align="left">Customer Activity Report</div>
                                        </td>
                                        <td class="PageHead" style="height: 40px;">
                                                <img src="../Common/images/help.gif" onclick="javascript:LoadHelp();" style="cursor: hand" />&nbsp;&nbsp;
                                                <img src="../Common/images/close.gif" onclick="javascript:Close();" style="cursor: hand" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="middle">
                                <%--User Prompts--%>
                                <table width="765" border="0" cellspacing="0" cellpadding="3">
                                    <tr>
                                        <td align="left" valign="middle" class="TabHead LeftPadding" style="height:20px; width:175px;">
                                            Period
                                        </td>
                                        <td width="200px"  valign="middle">
                                            <asp:UpdatePanel runat="server" ID="pnlPeriod" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td>
                                                                <asp:DropDownList ID="ddlMonth" runat="server" CssClass="FormCtrl" Width="125px">
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
                                                                </asp:DropDownList></td>
                                                            <td>
                                                                <asp:DropDownList ID="ddlYear" runat="server" CssClass="FormCtrl" Width="60px" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td width="150px">
                                            &nbsp;
                                        </td>
                                        <td width="240px">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="middle" class="TabHead LeftPadding" style="height:20px;">
                                            Branch
                                        </td>
                                        <td valign="middle">
                                            <asp:UpdatePanel runat="server" ID="pnlBranch" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:DropDownList ID="ddlBranch" runat="server" CssClass="FormCtrl" Width="195px" AutoPostBack="true" OnSelectedIndexChanged="ddlBranch_SelectedIndexChanged" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td colspan="2">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="middle" class="TabHead LeftPadding" style="height:20px;">
                                            Chain
                                        </td>
                                        <td valign="middle">
                                            <asp:UpdatePanel runat="server" ID="pnlChain" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:DropDownList ID="ddlChain" runat="server" CssClass="FormCtrl" Width="195px" AutoPostBack="true" OnSelectedIndexChanged="ddlChain_SelectedIndexChanged" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td colspan="2">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="left" valign="middle" class="TabHead LeftPadding" style="height:20px;">
                                            <asp:UpdatePanel runat="server" ID="pnlChainXLS" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="width:765px;">
                                                        <tr>
                                                            <td style="width:181px;">
                                                                &nbsp;&nbsp;&nbsp;&nbsp;or&nbsp;<asp:CheckBox ID="chkChainXLS" runat="server" AutoPostBack="true" OnCheckedChanged="chkChainXLS_CheckedChanged" />&nbsp;Excel Import
                                                            </td>
                                                            <td colspan="2" valign="middle" align="left" style="width:350px;">
                                                                <asp:FileUpload ID="uplChainXLS" CssClass="formCtrl" runat="server" Width="345px" Enabled="false" />
                                                            </td>
                                                            <td valign="middle" align="left" style="width:240px; padding-left:10px;">
                                                                <%--<asp:ImageButton ID="btnSubmitChain" runat="server" ImageUrl="../Common/images/submit.gif" />--%>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="left" valign="middle" class="TabHead LeftPadding" style="height:20px;">
                                            <asp:UpdatePanel runat="server" ID="pnlListChain" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="width:765px;">
                                                        <tr>
                                                            <td style="width:176px;">
                                                                &nbsp;&nbsp;&nbsp;&nbsp;or&nbsp;<asp:CheckBox ID="chkListChain" runat="server" AutoPostBack="true" OnCheckedChanged="chkListChain_CheckedChanged" />&nbsp;List
                                                            </td>
                                                            <td colspan="3" valign="middle" align="left">
                                                                <asp:TextBox ID="txtListChain" CssClass="formCtrl" runat="server" ToolTip="Comma delimited list of Customer Chain Codes" Width="550px" MaxLength="3000" Enabled="false" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="middle" class="TabHead LeftPadding" style="height:20px;">
                                            Customer No
                                        </td>
                                        <td valign="middle">
                                            <asp:UpdatePanel runat="server" ID="pnlCustNo" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:TextBox ID="txtCustNo" CssClass="formCtrl" runat="server" Width="75px" MaxLength="6" AutoPostBack="true" OnTextChanged="txtCustNo_TextChanged" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td colspan="2">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="left" valign="middle" class="TabHead LeftPadding" style="height:20px;">
                                            <asp:UpdatePanel runat="server" ID="pnlCustXLS" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="width:765px;">
                                                        <tr>
                                                            <td style="width:181px;">
                                                                &nbsp;&nbsp;&nbsp;&nbsp;or&nbsp;<asp:CheckBox ID="chkCustXLS" runat="server" AutoPostBack="true" OnCheckedChanged="chkCustXLS_CheckedChanged" />&nbsp;Excel Import
                                                            </td>
                                                            <td colspan="2" valign="middle" align="left" style="width:350px;">
                                                                <asp:FileUpload ID="uplCustXLS" CssClass="formCtrl" runat="server" Width="345px" Enabled="false" />
                                                            </td>
                                                            <td valign="middle" align="left" style="width:240px; padding-left:10px;">
                                                                <%--<asp:ImageButton ID="btnSubmitCust" runat="server" ImageAlign="Middle" ImageUrl="../Common/images/submit.gif" />--%>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="left" valign="middle" class="TabHead LeftPadding" style="height:20px;">
                                            <asp:UpdatePanel runat="server" ID="pnlListCust" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="width:765px;">
                                                        <tr>
                                                            <td style="width:176px;">
                                                                &nbsp;&nbsp;&nbsp;&nbsp;or&nbsp;<asp:CheckBox ID="chkListCust" runat="server" AutoPostBack="true" OnCheckedChanged="chkListCust_CheckedChanged" />&nbsp;List
                                                            </td>
                                                            <td colspan="3" valign="middle" align="left">
                                                                <asp:TextBox ID="txtListCust" CssClass="formCtrl" runat="server" ToolTip="Comma delimited list of Customer Numbers" Width="550px" MaxLength="3000" Enabled="false" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="middle" class="TabHead LeftPadding" style="height:20px;">
                                            Territory
                                        </td>
                                        <td valign="middle">
                                            <asp:UpdatePanel runat="server" ID="pnlTerritory" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:DropDownList ID="ddlTerritory" runat="server" CssClass="FormCtrl" Width="195px" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td align="left" valign="middle" colspan="2" class="TabHead LeftPadding" style="height:20px;">
                                            <asp:UpdatePanel runat="server" ID="pnlCount" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:Label ID="lblResults" runat="server" Visible="false" Text="Customers or Chains to Report:&nbsp;&nbsp;"></asp:Label>
                                                    <asp:Label ID="lblRptCount" runat="server" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="middle" class="TabHead LeftPadding" style="height:20px;">
                                            Outside Sales Rep
                                        </td>
                                        <td valign="middle">
                                            <asp:UpdatePanel runat="server" ID="pnlOutsideRep" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:DropDownList ID="ddlOutsideRep" runat="server" CssClass="FormCtrl" Width="195px" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td valign="top" colspan="2" rowspan="6" class="LeftPadding">
                                            <asp:UpdatePanel ID="pnlResults" runat="server" UpdateMode="conditional">
                                                <ContentTemplate>
                                                    <div id="divdatagrid" class="Sbar" align="left" runat="server" visible="false" style="overflow:auto; width:350px; position:relative; top:0px; left:0px; height:150px; border:0px solid; vertical-align:top; overflow-y:scroll;">
                                                        <asp:DataGrid ID="dgResults" Width="330px" runat="server" BorderWidth="1px" BorderColor="#DAEEEF" CssClass="grid" style="height: auto;"
                                                            UseAccessibleHeader="true" AutoGenerateColumns="false" AllowSorting="false" ShowHeader="false" ShowFooter="false"
                                                            PagerStyle-Visible="false" AllowPaging="false" OnItemDataBound="dgResults_ItemDataBound">
                                                                <ItemStyle CssClass="GridItem" />
                                                                <AlternatingItemStyle CssClass="zebra" />
                                                                <Columns>
                                                                <%--<asp:BoundColumn DataField="pCustMstrID">
                                                                        <ItemStyle Width="30px" HorizontalAlign="Center" Wrap="False" />
                                                                    </asp:BoundColumn>--%>
                                                                    
                                                                    <asp:TemplateColumn>
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="lnkPreview" runat="server" Text="Preview"></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                        <ItemStyle Width="30px" HorizontalAlign="Center" Wrap="False" />
                                                                    </asp:TemplateColumn>
                                                                    
                                                                    <asp:BoundColumn DataField="CustNo">
                                                                        <ItemStyle Width="30px" HorizontalAlign="Center" Wrap="False" />
                                                                    </asp:BoundColumn>
                                                                    
                                                                    <asp:BoundColumn DataField="CustName">
                                                                        <ItemStyle Width="250px" HorizontalAlign="Left" Wrap="False" />
                                                                    </asp:BoundColumn>
                                                                </Columns>
                                                        </asp:DataGrid>
                                                    </div>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="middle" class="TabHead LeftPadding" style="height:20px;">
                                            Inside Sales Rep
                                        </td>
                                        <td valign="middle">
                                            <asp:UpdatePanel runat="server" ID="pnlInsideRep" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:DropDownList ID="ddlInsideRep" runat="server" CssClass="FormCtrl" Width="195px" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td colspan="2">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="middle" class="TabHead LeftPadding" style="height:20px;">
                                            Regional Manager
                                        </td>
                                        <td valign="middle">
                                            <asp:UpdatePanel runat="server" ID="pnlRegionalMgr" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:DropDownList ID="ddlRegionalMgr" runat="server" CssClass="FormCtrl" Width="195px" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td colspan="2">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="middle" class="TabHead LeftPadding" style="height:20px;">
                                            Buy Group
                                        </td>
                                        <td valign="middle">
                                            <asp:UpdatePanel runat="server" ID="pnlBuyGroup" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:DropDownList ID="ddlBuyGroup" runat="server" CssClass="FormCtrl" Width="195px" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td colspan="2">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="middle" class="TabHead LeftPadding" style="height:20px;">
                                            <asp:UpdatePanel runat="server" ID="pnlCustRpt" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:CheckBox ID="chkCustRpt" Text="Customer Version" runat="server" AutoPostBack="true" OnCheckedChanged="chkCustRpt_CheckedChanged" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td align="left" valign="middle" class="TabHead LeftPadding">
                                            <asp:UpdatePanel runat="server" ID="pnlEmpRpt" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:CheckBox ID="chkEmpRpt" Text="Employee Version" runat="server" AutoPostBack="true" OnCheckedChanged="chkEmpRpt_CheckedChanged" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td colspan="2">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="middle" class="TabHead LeftPadding" style="height:20px;">
                                            <asp:UpdatePanel runat="server" ID="pnlBuyGrpRpt" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:CheckBox ID="chkBuyGrpRpt" Text="Buy Group" runat="server" AutoPostBack="true" OnCheckedChanged="chkBuyGrpRpt_CheckedChanged" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td align="left" valign="middle" class="TabHead LeftPadding">
                                            <asp:UpdatePanel runat="server" ID="pnlCatRpt" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:CheckBox ID="chkCatRpt" Text="Category" runat="server" AutoPostBack="true" OnCheckedChanged="chkCatRpt_CheckedChanged" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td colspan="2">
                                            &nbsp;
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="lightBlueBg buttonBar" style="border-top:solid 1px #CDECF6" height="20px">
                                <table>
                                    <tr>
                                        <td>
                                            <asp:UpdateProgress ID="pnlProgress" runat="server" DisplayAfter="1" DynamicLayout="false">
                                                <ProgressTemplate>
                                                    <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                                </ProgressTemplate>
                                            </asp:UpdateProgress>
                                        </td>
                                        <td>
                                            <asp:UpdatePanel ID="pnlStatus" runat="server" UpdateMode="conditional">
                                                <ContentTemplate>
                                                    <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                                        runat="server" Width="500px" Text=""></asp:Label>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr class="PageBg" height="30">
                            <td align="left" class="TabHead" colspan="2" valign="middle">
                                <asp:UpdatePanel ID="udpReportContent" UpdateMode="Conditional" RenderMode="Inline" runat="server">
                                    <ContentTemplate>
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="width: 420px">&nbsp;</td>
                                                <td>
                                                    <asp:ImageButton ID="btnSubmit" runat="server" ImageUrl="../Common/images/submit.gif" OnClick="btnSubmit_Click" />
                                                    <asp:ImageButton ID="btnClear" Visible="false" runat="server" ImageUrl="../Common/images/btnClear.gif" OnClick="btnClear_Click" />
                                                </td>
                                                <td style="padding-right:15px; width:280px;" align="right">
                                                    <asp:ImageButton ID="btnPostToPrint" Visible="false" runat="server" ImageUrl="../Common/images/print.gif" />
                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:PostBackTrigger ControlID="btnSubmit" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <asp:HiddenField ID="hidPeriod" runat="server" />
    </form>
</body>
</html>
