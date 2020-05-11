<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MfgAddress.aspx.cs" Inherits="PFC.WebPage.MfgAddress" %>

<%@ Register Src="Common/UserControls/MinFooter.ascx" TagName="MinFooter" TagPrefix="uc1" %>

<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc5" %>


<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>WOE - Manufacture Information</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="Common/JavaScript/Common.js"></script>

</head>
<body   onclick="javascript:document.getElementById('lblMessage').innerText='';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1"  AsyncPostBackTimeout ="360000" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table class="HeaderPanels" border="0" cellpadding="0" cellspacing="0" style="width: 100%;
            height: 100%">
            <tr>
                <td class="lightBg" style="padding: 0px;">
                    <table border="0" cellpadding="3" cellspacing="0" width="100%">
                        <tr>
                            <td style="width: 50px; padding-left: 8px;">
                                <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="Work Order Number:"
                                    Width="117px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblWONumber" runat="server" Font-Bold="False" CssClass="lblBluebox"
                                    Style="padding-left: 5px" Width="50px"></asp:Label>
                                &nbsp;
                            </td>
                            <td>
                            </td>
                            <td style="width: 100px; padding-right: 7px;" align="right">
                                <asp:ImageButton ID="ibtnHelp" runat="server" ImageUrl="~/Common/Images/help.gif" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px;">
                    <asp:UpdatePanel ID="pnlContactEntry" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table height="5px" border="0" cellpadding="3" cellspacing="0" width="100%">
                                <tr>
                                    <td colspan="2">
                                        </td>
                                    <td>
                                    </td>
                                    <td colspan="2">
                                        </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 5px;">
                                            <tr>
                                                <td align="center">
                                                    <hr color="#003366" />
                                                </td>
                                                <td align="center" width="50px">
                                                    <asp:Label ID="Label6" runat="server" Text="Address" Font-Bold="True" Width="55px"></asp:Label></td>
                                                <td align="center">
                                                    <hr align="center" color="#003366" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="75px">
                                    </td>
                                    <td colspan="2">
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%;">
                                            <tr>
                                                <td align="center">
                                                    <hr color="#003366" />
                                                </td>
                                                <td align="center" width="50px">
                                                    <asp:Label ID="Label7" runat="server" Font-Bold="True" Text="Contact"></asp:Label></td>
                                                <td align="center">
                                                    <hr align="center" color="#003366" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label1" runat="server" Text="Name" Font-Bold="True" Width="60px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblName" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Name" Width="70px"></asp:Label></td>
                                    <td colspan="1">
                                        <asp:Label ID="lblContactName" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="170px"></asp:Label></td>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Address 1" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblAddress1" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="Job Title" Width="70px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblContactTitle" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="170px"></asp:Label></td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label8" runat="server" Font-Bold="True" Text="Address 2" Width="60px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblAddress2" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Department" Width="70px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblContactDept" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="170px"></asp:Label></td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label13" runat="server" Font-Bold="True" Text="City / State" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblCity" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label><asp:Label
                                            Style="padding-left: 5px" ID="lblState" runat="server" Font-Bold="False" Width="50px"
                                            CssClass="lblBluebox"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label14" runat="server" Font-Bold="True" Text="Phone / Ext" Width="70px"></asp:Label></td>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td>
                                                   
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblContactPhone" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                                        Width="108px"></asp:Label><asp:Label ID="lblContactExt" runat="server" CssClass="lblBluebox"
                                                            Font-Bold="False" Width="50px"></asp:Label></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label11" runat="server" Font-Bold="True" Text="Postcode" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblPostcode" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label17" runat="server" Font-Bold="True" Text="Fax No" Width="70px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblContactFax" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="170px"></asp:Label></td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label12" runat="server" Font-Bold="True" Text="Country" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblCountry" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label16" runat="server" Font-Bold="True" Text="Mobile No" Width="70px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblContactMob" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="170px"></asp:Label></td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;<asp:Label ID="Label10" runat="server" Font-Bold="True" Text="Phone" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblPhone" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label15" runat="server" Font-Bold="True" Text="Email" Width="70px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblContactEmail" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="170px"></asp:Label></td>
                                    <td align="right">
                                        <asp:ImageButton ID="ibtnSave" runat="server" ImageUrl="~/Common/Images/Save.jpg" Visible="False"
                                             /></td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="right" width="100%" id="tdButton" class="commandLine splitborder_t_v splitborder_b_v"
                    style="height: 20px; background-position: -80px  left;">
                    <asp:UpdatePanel ID="pnlStatusMessage" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td align="left" style="padding-left: 10px;" width="90%">
                                        <asp:UpdateProgress ID="pnlProgress" runat="server">
                                            <ProgressTemplate>
                                                <span class="TabHead">Loading...</span></ProgressTemplate>
                                        </asp:UpdateProgress>
                                        <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                    </td>
                                    <td colspan="4">
                                        <uc5:PrintDialogue ID="printDialogue" runat="server" Visible="false"></uc5:PrintDialogue>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" width="90%">
                                    </td>
                                    <td colspan="4" style="padding-top: 3px; padding-bottom: 3px; padding-right: 5px;">
                                        <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" /></td>
                                    <td>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <uc1:MinFooter ID="MinFooter1" runat="server" Title="Manufacture Information" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
