<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CSRReport.aspx.cs" Inherits="SystemFrameSet_CSRReport" %>

<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CSR Report - By Entry ID</title>
    <link href="../Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet">
    <link href="../ReadyToShip/Common/StyleSheet/RTS_Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" runat="server" id="BodyTable">
            <tr>
                <td colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="HeadeBG">
                        <tr>
                            <td width="62%" valign="middle">
                                <img src="../Common/Images/Logo.gif" height="50" hspace="25" vspace="10"></td>
                            <td width="38%" valign="bottom" class="10pxPadding">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <asp:UpdatePanel ID="pnlItemDetails" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder"
                                align="center">
                                <tr>
                                    <td width="100%">
                                        <table width="100%" cellpadding="0" cellspacing="0" border="0" class="blueBorder lightBlueBg"
                                            style="border-left: none; border-right: none; border-top: none">
                                            <tr>
                                                <td align="left" width="90%" style="padding-right: 5px; padding-left: 5px; padding-bottom: 5px;
                                                    padding-top: 5px">
                                                    <span style="color: #CC0000; font-size: 18px; margin: 0px; padding: 0px; font-weight: normal;
                                                        line-height: 25px; margin-left: 10px;">CSR Report - By Entry ID</span>
                                                </td>
                                                <td align="left" colspan="2">
                                                    <asp:UpdatePanel ID="UpdatePanel1" UpdateMode="conditional" runat="server">
                                                        <ContentTemplate>
                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td style="width: 100px">
                                                                        <asp:ImageButton runat="server" Style="cursor: hand" ID="ibtnPrint" ImageUrl="~/Common/Images/Print.gif"
                                                                            ImageAlign="middle" OnClick="ibtnPrint_Click" /></td>
                                                                    <td style="width: 100px">
                                                                        <asp:ImageButton ID="ibtnClose" runat="server" Style="padding-right: 10px;"
                                                                            ImageUrl="../common/images/close.gif" OnClientClick="javascript:window.close();" /></td>
                                                                </tr>
                                                            </table>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </td>
                                            </tr>
                                            <tr class="PageBg" height="20">
                                                <td align="left" class="TabHead" style="padding-left: 10px" colspan="2">
                                                    <asp:Label ID="Label1" runat="server" Text="Branch Name"></asp:Label>
                                                    &nbsp;&nbsp;
                                                    <asp:DropDownList CssClass="FormControls" ID="ddlBranch" runat="server" OnSelectedIndexChanged="ddlBranch_SelectedIndexChanged"
                                                        AutoPostBack="true" Width="170px">
                                                    </asp:DropDownList></td>
                                                <td align="right" style="padding-right: 15px">
                                                    <asp:UpdateProgress DynamicLayout="false" ID="upPanel" runat="server">
                                                        <ProgressTemplate>
                                                            <span style="padding-left: 5px" class="TabHead">Loading...</span>
                                                        </ProgressTemplate>
                                                    </asp:UpdateProgress>
                                                </td>
                                            </tr>
                                            <tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div id="div1" class="Sbar" align="center" style="overflow-x: hidden; overflow-y: auto;
                                            position: relative; top: 0px; left: 0px; width: 1000px; height: 508px; border: 0px solid;">
                                            <div align="left" id="4TD">
                                                <asp:DataList ID="dlRegion" runat="server" OnItemDataBound="dlRegion_ItemDataBound"
                                                    RepeatColumns="3" RepeatDirection="Horizontal" CellSpacing="6" Style="left: 3px;
                                                    top: 3px" CellPadding="0" ShowFooter="False" ShowHeader="False">
                                                    <HeaderTemplate>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder">
                                                            <tr>
                                                                <td class="TabHeadBk">
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                                        <tr>
                                                                            <td width="5%">
                                                                                <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                                            <td width="95%">
                                                                                <strong>CSR :
                                                                                    <asp:Label ID="lblBrID" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.USERNAME")%>'></asp:Label>
                                                                                </strong>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td valign="top">
                                                                    <div align="left" class="TabCntBk" id="4TD">
                                                                        <asp:Table Width="308" ID="dtBrPerformance" runat="server">
                                                                            <asp:TableHeaderRow>
                                                                                <asp:TableHeaderCell></asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">Day</asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">Br Avg</asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">MTD</asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">LMTD</asp:TableHeaderCell>
                                                                            </asp:TableHeaderRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Gross Margin $</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Gross Margin %</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Sales $</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>No of Order</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>No of Lines</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Lbs Shipped</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Price per Lbs</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>GM per Lbs</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                        </asp:Table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                    </FooterTemplate>
                                                </asp:DataList>
                                                <div align="center">
                                                    <asp:Label ID="lblNorecords" runat="server" CssClass="redtitle" Visible="false" Text="No Records Found"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td align="right" colspan="2">
                                <uc1:BottomFrame ID="BottomFrame1" runat="server" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>

<script>
    function PrintReport(url)
    {
            var hwin=window.open('CSRReportPreview.aspx?'+url, 'CSRReportPrint', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (1010/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
            hwin.focus();
    }
</script>

