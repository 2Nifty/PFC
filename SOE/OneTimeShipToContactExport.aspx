<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OneTimeShipToContactExport.aspx.cs"
    Inherits="SoldToAddressExport" %>

<%@ Register Src="Common/UserControls/PhoneNumber.ascx" TagName="PhoneNumber" TagPrefix="uc4" %>

<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/SubHeader.ascx" TagName="CEHeader" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SOE- Ship To Information</title>
    <link href="http://206.72.71.194/SOE/Common/StyleSheet/printstyles.css" rel="stylesheet"
        type="text/css" />

    <script type="text/javascript" src="Common/JavaScript/PendingOrdersAndQuotes.js"></script>

</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table class="PageBg"  border="0" cellpadding="0" cellspacing="0" style="height: 100%">
            <tr>
                <td bgcolor="white" style="padding-right: 0px; padding-left: 0px; padding-bottom: 0px;
                    padding-top: 0px">
                            <asp:Image ID="imglogo" runat="server" ImageUrl="http://206.72.71.194/SOE/Common/Images/PFC_logo.gif" /></td>
            </tr>
            <tr>
                <td style="padding-right: 5px; padding-left: 5px; padding-bottom: 5px; padding-top: 5px">
                </td>
            </tr>
            <tr>
                <td style="padding: 5px;">
                    <table border="0" cellpadding="3" cellspacing="0">
                        <tr>
                            <td style="width: 50px; padding-left: 8px;">
                                <asp:Label ID="Label9" style="display:inline-block;width:250px" runat="server" Font-Bold="True" Text="Ship To Information For Sales Order Number:"
                                    ></asp:Label></td>
                            <td>
                                <asp:Label ID="lblSONumber" runat="server" Font-Bold="False" CssClass="lblBluebox"
                                    Style="padding-left: 5px" Width="50px"></asp:Label>
                                <input id="hidCustNo" type="hidden" name="hidCustNo" runat="server">
                            </td>
                            <td>
                            </td>
                            <td style="width: 100px; padding-right: 7px;" align="right">
                                </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px;">
                    <table height="5px" border="0" cellpadding="3" cellspacing="0" width="100%">
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
                                        <asp:Label ID="txtContactName" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="175px"></asp:Label></td>
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
                                        <asp:Label ID="txtContactJobTitle" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="175px"></asp:Label></td>
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
                                        <asp:Label ID="txtContactDepart" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="175px"></asp:Label></td>
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
                                        <asp:Label ID="txtContactPhoneNo" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="80px"></asp:Label>&nbsp;
                                        <asp:Label ID="txtContactExt" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="50px"></asp:Label></td>
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
                                        <asp:Label ID="txtContactFax" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="105px"></asp:Label></td>
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
                                        <asp:Label ID="txtContactMob" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="105px"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label10" runat="server" Font-Bold="True" Text="Phone" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblPhone" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label15" runat="server" Font-Bold="True" Text="Email" Width="70px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="txtContactEmail" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="175px"></asp:Label></td>
                                </tr>
                            </table>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="border-collapse: collapse;">
                    <div class="blueBorder">
                            </div>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
