<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RBMoveTransfers.aspx.vb"
    Inherits="RBMoveXfer" Debug="true" %>

<%@ Register Src="~/IntranetTheme/UserControls/PageHeader.ascx" TagName="Header"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>NV->RB Transfer Receipts</title>
    <link href="IntranetTheme/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td valign="top" colspan="2">
                        <uc1:Header ID="PageHeader1" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td valign="middle" class="PageHead">
                        <span class="Left5pxPadd">
                            <asp:Label ID="Label1" CssClass="BannerText" runat="server" Text="Radio Beacon Create Transfer Receipts"></asp:Label></span>
                    </td>
                    <td align="right" class="PageHead">
                        <asp:ImageButton ID="HelpButton" runat="server" ImageUrl="IntranetTheme/Images/Buttons/help.gif"
                            PostBackUrl="RBMoveTransfersHelp.aspx" />
                    </td>
                </tr>
            </table>
            <table width="100%" border="1">
                <%--<tr>
            <td valign=middle class=PageHead>
                   <span class=Left5pxPadd><asp:Label ID="lblParentMenuName" CssClass=BannerText 
                   runat="server" Text="Radio Beacon Create Transfer Receipts"></asp:Label></span></td>
            </tr>--%>
                <tr>
                    <td>
                        <table border="1">
                            <tr>
                                <td>
                                    <asp:Panel ID="ControlPanel" runat="server" Height="400px" Width="100px">
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="UserLabel" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    &nbsp;<table>
                                            <tr>
                                                <td>
                                                    Enter TO numbers below
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:TextBox ID="OrdersToProcessTextBox" runat="server" Rows="20" Wrap="true" Width="150"
                                                        Height="280px" TextMode="MultiLine"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Move 'em.
                                                    <asp:ImageButton ID="SubmitButt" runat="server" ImageUrl="images/submit.gif" />
                                                </td>
                                            </tr>
                                        </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </td>
                                <td align="center" valign="middle">
                                    <asp:Panel ID="InputPanel" runat="server" Height="400px" Width="170px">
                                        &nbsp;<br />
                                        <br />
                                        <br />
                                        <br />
                                        <br />
                                        <asp:Label ID="RunTextBox" runat="server" CssClass="FormCtrl" Height="265px" Width="151px"></asp:Label></asp:Panel>
                                </td>
                                <td valign="top">
                                    <asp:Panel ID="RunPanel" runat="server" Height="400px" Width="340" HorizontalAlign="center"
                                        Visible="false" ScrollBars="Vertical">
                                        <table>
                                            <tr>
                                                <td>
                                                    Move Results
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:GridView ID="ResultsGrid" runat="server">
                                                    </asp:GridView>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
