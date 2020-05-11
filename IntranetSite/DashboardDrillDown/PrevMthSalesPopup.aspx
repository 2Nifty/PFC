<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PrevMthSalesPopup.aspx.cs" Inherits="PrevMthSalesPopup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Dashboard Performance Drilldown - Previous Month Sales Popup</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

<style type="text/css"> 
    .LeftPad {padding-left: 3px;}
    .RightPad {padding-right: 3px;}
    .TopPad {padding-top: 3px;}
    .BottomPad {padding-bottom: 3px;}
</style> 
</head>

<body>
    <form id="frmTemplate1020x710" runat="server">
        <asp:ScriptManager runat="server" ID="smTemplate1020x710">
        </asp:ScriptManager>
        <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse; vertical-align:center;" id="mainTable">
<%--            <tr>
                <td style="height:5%;">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>--%>

            <tr>
                <td class="TopPad RightPad LeftPad BottomPad" valign="middle">
                    <table id="tblMain" style="width: 100%;" border="1px" cellpadding="2" cellspacing="0">
                        <tr style="vertical-align:top; background-color:#DFF3F9;">
                            <td class="LeftPad">
                                &nbsp;
                            </td>
                            <td class="TabHead" align="center">
                                Prev Mth 1
                            </td>
                            <td class="TabHead" align="center">
                                Prev Mth 2
                            </td>
                            <td class="TabHead" align="center">
                                Prev Mth 3
                            </td>
                        </tr>

<%--                        <tr>
                            <td class="TabHead" colspan="3" align="center">
                                Sales $
                            </td>
                        </tr>--%>


                        <tr>
                            <td class="TabHead" align="center">
                                Sales $
                            </td>
                            <td align="right">
                                <asp:Label ID="lblPrevSls1" runat="server" Text="lblPrevSls1"></asp:Label>
                            </td>
                            <td align="right">
                                <asp:Label ID="lblPrevSls2" runat="server" Text="lblPrevSls2"></asp:Label>
                            </td>
                            <td align="right">
                                <asp:Label ID="lblPrevSls3" runat="server" Text="lblPrevSls3"></asp:Label>
                            </td>
                        </tr>

<%--                        <tr>
                            <td class="TabHead" colspan="3" align="center">
                                GM $
                            </td>
                        </tr>--%>

                        <tr>
                            <td class="TabHead" align="center">
                                GM %
                            </td>
                            <td align="right">
                                <asp:Label ID="lblPrevGM1" runat="server" Text="lblPrevGM1"></asp:Label>
                            </td>
                            <td align="right">
                                <asp:Label ID="lblPrevGM2" runat="server" Text="lblPrevGM2"></asp:Label>
                            </td>
                            <td align="right">
                                <asp:Label ID="lblPrevGM3" runat="server" Text="lblPrevGM3"></asp:Label>
                            </td>
                        </tr>




                    </table>
                </td>
            </tr>

<%--            <tr>
                <td class="BluBg buttonBar" height="20px">
                    <table>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlStatus" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true" runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdateProgress ID="pnlProgress" runat="server" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="Footer1" Title="Template1020x710" runat="server" />
                </td>
            </tr>--%>

        </table>
    </form>
</body>
</html>
