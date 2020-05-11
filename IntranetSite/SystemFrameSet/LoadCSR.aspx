<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LoadCSR.aspx.cs" Inherits="SystemFrameSet_LoadCSR" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>CSR Sales Performance</title>
    <link href="../Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet">
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true"></asp:ScriptManager>
    <asp:UpdatePanel ID="pnlCSR" runat="server" UpdateMode="conditional">
        <ContentTemplate> 
        <table width="50%" border="0" cellspacing="0" cellpadding="0" runat="server" id="BodyTable">
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
                <td>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder"
                        align="center">
                        <tr>
                            <td class="TabHeadBk" width="100%">
                                <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                    <tr>
                                        <td width="16">
                                            <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4" ondrag="follow"></td>
                                        <td width="217" class="TabHead">
                                            <strong>Sales Performance</strong></td>
                                        <td width="10%" id="8container" align="right">
                                            <img id="imgClose" align="right" style="cursor: hand" onclick="javascript:window.close();"
                                                src="../common/images/close.gif" />
                                            &nbsp;</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" id="8Td" valign="top" class="TabCntBk">
                                <div>
                                    <table width="100%" align="center" class="BlueBorder">
                                        <tr>
                                            <td>
                                                <div>
                                                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; CSR's Name</div>
                                            </td>
                                            <td colspan="2">
                                                <asp:DropDownList CssClass="FormControls" ID="ddlCsr" runat="server" OnSelectedIndexChanged="ddlBranch_SelectedIndexChanged"
                                                    AutoPostBack="True" Width="150">
                                                </asp:DropDownList></td>
                                            <td colspan="1" align="right">
                                                   <asp:UpdateProgress DynamicLayout=false ID="upPanel" runat="server">
                                                        <ProgressTemplate>
                                                            <span style="padding-left: 5px" class="TabHead">Loading...</span>
                                                        </ProgressTemplate>
                                                    </asp:UpdateProgress>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <asp:Table Width="100%" ID="dtUserProfile" runat="server" align="center" class="BlueBorder"
                                    BorderStyle="Double">
                                    <asp:TableHeaderRow BorderWidth="1">
                                        <asp:TableHeaderCell BorderWidth="1">&nbsp;&nbsp;&nbsp;</asp:TableHeaderCell>
                                        <asp:TableHeaderCell HorizontalAlign="Right" BorderWidth="1">Day</asp:TableHeaderCell>
                                        <asp:TableHeaderCell HorizontalAlign="Right" BorderWidth="1">Br Avg</asp:TableHeaderCell>
                                        <asp:TableHeaderCell HorizontalAlign="Right" BorderWidth="1">MTD</asp:TableHeaderCell>
                                        <asp:TableHeaderCell HorizontalAlign="Right" BorderWidth="1">LMTD</asp:TableHeaderCell>
                                    </asp:TableHeaderRow>
                                    <asp:TableRow BorderWidth="1">
                                        <asp:TableCell BorderWidth="1" Width="20%">Gross Margin $</asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" Width="20%" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" Width="20%" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" Width="20%" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" Width="20%" BorderWidth="1"></asp:TableCell>
                                    </asp:TableRow>
                                    <asp:TableRow BorderWidth="1">
                                        <asp:TableCell BorderWidth="1">Gross Margin %</asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                    </asp:TableRow>
                                    <asp:TableRow BorderWidth="1">
                                        <asp:TableCell BorderWidth="1">Sales $</asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                    </asp:TableRow>
                                    <asp:TableRow BorderWidth="1">
                                        <asp:TableCell BorderWidth="1">No of Order</asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                    </asp:TableRow>
                                    <asp:TableRow BorderWidth="1">
                                        <asp:TableCell BorderWidth="1">No of Lines</asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                    </asp:TableRow>
                                    <asp:TableRow BorderWidth="1">
                                        <asp:TableCell BorderWidth="1">Lbs Shipped</asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                    </asp:TableRow>
                                    <asp:TableRow BorderWidth="1">
                                        <asp:TableCell BorderWidth="1">Price per Lbs</asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                    </asp:TableRow>
                                    <asp:TableRow BorderWidth="1">
                                        <asp:TableCell BorderWidth="1">GM per Lbs</asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                        <asp:TableCell HorizontalAlign="Right" BorderWidth="1"></asp:TableCell>
                                    </asp:TableRow>
                                </asp:Table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr bgcolor="#DFF3F9">
                <td height="25" class="foottxt1">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="23%" height="25" class="foottxt1">
                                <a href="http://www.porteousfastener.com/" style="color: #1c7893" target="_blank">&nbsp;&nbsp;Copyright
                                    2007 Porteous Fastener Co. All rights reserved.,</a>
                            </td>
                            <td width="13%" align="right">
                                <a href="http://www.novantus.com" target="_blank">
                                    <img src="../Common/Images/umbrellaPower.gif" border="0Px" /></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    </form>
</body>
</html>
