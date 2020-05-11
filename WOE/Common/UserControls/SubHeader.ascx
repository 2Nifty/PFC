<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SubHeader.ascx.cs" Inherits="Common_UserControls_SubHeader" %>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td valign="top" class="SubHeaderPanels" style="padding-left: 4px; padding-top: 4px;"
            width="30%">
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td height="20" valign="middle">
                        <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="Work Order Number:"
                            Width="117px"></asp:Label></td>
                    <td>
                        <asp:Label ID="lblWONumber" runat="server" Font-Bold="False"
                            Style="padding-left: 5px" Width="50px"></asp:Label></td>
                </tr>
            </table>
            <asp:HiddenField ID="hidPONumber" runat="server" />
        </td>
        <td valign="top" class="SubHeaderPanels" width="35%" style="padding-left: 4px; padding-top: 4px;">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td>
                        <asp:LinkButton ID="lnkMfgGrp" runat="server" Font-Underline="false" CssClass="TabHead"
                            OnClientClick="Javascript:return false;" Text="Mfg Group:" Font-Bold="True" Width="62px"></asp:LinkButton></td>
                    <td>
                        <asp:Label ID="lblMfgName" runat="server" CssClass="lblColor"></asp:Label></td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblMfgCode" runat="server" CssClass="lblColor"></asp:Label></td>
                    <td>
                        <asp:Label ID="lblMfgAddress" runat="server" CssClass="lblColor"></asp:Label></td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <asp:Label ID="lblMfgAddress2" runat="server" CssClass="lblColor"></asp:Label></td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <asp:Label ID="lblMfgCity" runat="server" CssClass="lblColor"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblMfgComma" runat="server" CssClass="lblColor">, </asp:Label></td>
                                <td>
                                    &nbsp;<asp:Label ID="lblMfgState" runat="server" CssClass="lblColor"></asp:Label></td>
                                <td>
                                    &nbsp;<asp:Label ID="lblMfgPincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                <td>
                                    &nbsp;<asp:Label ID="lblMfgCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <asp:Label ID="lblMfgPhone" runat="server" CssClass="lblColor"></asp:Label></td>
                </tr>
            </table>
        </td>
        <td valign="top" class="SubHeaderPanels" style="padding-left: 4px; padding-top: 4px;"
            width="35%">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td width="55px">
                        <asp:LinkButton ID="lnkPackBy" runat="server" CssClass="TabHead" Font-Underline="false"
                            OnClientClick="Javascript:return false;" Text="Pack By:" Font-Bold="True" Width="45px"></asp:LinkButton></td>
                    <td>
                        <asp:Label ID="lblPckName" runat="server" CssClass="lblColor"></asp:Label></td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <asp:Label ID="lblPckAddress" runat="server" CssClass="lblColor"></asp:Label></td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <asp:Label ID="lblPckAddress2" runat="server" CssClass="lblColor"></asp:Label></td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <asp:Label ID="lblPckCity" runat="server" CssClass="lblColor"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblPckComma" runat="server" CssClass="lblColor">, </asp:Label></td>
                                <td>
                                    &nbsp;<asp:Label ID="lblPckState" runat="server" CssClass="lblColor"></asp:Label></td>
                                <td>
                                    &nbsp;<asp:Label ID="lblPckPincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                <td>
                                    &nbsp;<asp:Label ID="lblPckCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <asp:Label ID="lblPckPhone" runat="server" CssClass="lblColor"></asp:Label></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
