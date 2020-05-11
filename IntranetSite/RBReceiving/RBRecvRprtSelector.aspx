<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RBRecvRprtSelector.aspx.cs" Inherits="RBRecvRprtSelector" %>

<%@ Register Src="../PrintUtility/Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Warehouse Receiving Report</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script src="../Common/JavaScript/Common.js" type="text/javascript"></script>
</head>
<body>
    <asp:SqlDataSource ID="LocationCodes" runat="server" ConnectionString="<%$ ConnectionStrings:PFCERPConnectionString %>"
        SelectCommand="select LocID as Code, LocID+' - '+LocName as Name from [LocMaster] with (NOLOCK) where LocType = 'B' order by LocID">
    </asp:SqlDataSource>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="RecvSelectScriptManager" runat="server" EnablePartialRendering="true" />
        <div>
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="middle" class="PageHead" colspan="2">
                        <span class="Left5pxPadd">
                            <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Warehouse Receiving Report"></asp:Label>
                        </span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Panel ID="PromptPanel" runat="server" Height="100" Width="100%">
                            <asp:UpdatePanel ID="PromptUpdatePanel" runat="server" UpdateMode="Conditional">
                                <contenttemplate>
                            <table width="300">
                                <tr>
                                    <td class="Left5pxPadd bold">
                                        <asp:Label CssClass="BlackBold" ID="LocLabel" runat="server" Text="PFC&nbsp;Location"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="LocationDropDownList" runat="server" DataTextField="Name" DataValueField="Code"
                                            DataSourceID="LocationCodes" Width="150px">
                                        </asp:DropDownList>
                                        <input id="PrintHide" name="PrintHide" type="hidden" value="Print" />
                                    </td>
                                    <td>
                                        <asp:ImageButton ID="FindDataButt" runat="server" ImageUrl="../Common/Images/ShowButton.gif" 
                                        OnClick="Submit_Click" AlternateText="Find records for Branch" />
                                        <asp:HiddenField ID="yh" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Left5pxPadd">
                                        <asp:Label CssClass="BlackBold" ID="LPNLabel" runat="server" Text="License&nbsp;Plate&nbsp;Number"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="LPNTextBox" runat="server"></asp:TextBox>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Left5pxPadd">
                                        <asp:Label CssClass="BlackBold" ID="ContainerLabel" runat="server" Text="Container&nbsp;Number"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="ContainerTextBox" runat="server"></asp:TextBox>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                            </table>
                            </contenttemplate>
                            </asp:UpdatePanel>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td align="left" class="PageBg">
                                    <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                    <asp:Label ID="lblErrorMessage" runat="server"  ForeColor="Red"></asp:Label>
                                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen" Width="240px"></asp:Label></td>
                                    </ContentTemplate></asp:UpdatePanel>
                                <td align="right" class="PageBg" valign="bottom">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td align="right">
                                                <div style="width: 70px;">
                                                    <asp:UpdatePanel ID="PrintUpdatePanel" runat="server" UpdateMode="Conditional">
                                                        <contenttemplate>
                                                                <uc1:PrintDialogue id="Print" runat="server" EnableFax="true">
                                                                </uc1:PrintDialogue>
                                                            </contenttemplate>
                                                    </asp:UpdatePanel>
                                                </div>
                                            </td>
                                            <td style="padding-left: 5px">
                                                <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="../Common/Images/close.gif"
                                                    PostBackUrl="../WhsRecvDashboard/WhsRcvDashBoard.aspx" />
                                            </td>
                                        </tr>
                                    </table>
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
