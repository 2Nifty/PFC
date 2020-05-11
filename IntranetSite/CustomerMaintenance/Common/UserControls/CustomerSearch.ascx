<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomerSearch.ascx.cs"
    Inherits="PFC.Intranet.Maintenance.CustomerSearch" %>
<asp:Panel ID="Panel1" runat="server" Width="100%" DefaultButton="btnSearch">
    <table width="100%" class="shadeBgDown">
        <tr>
            <td class="Left2pxPadd DarkBluTxt boldText" width="12%">
                <asp:Label ID="lblSch" runat="server" Text="Customer Number"></asp:Label>
            </td>
            <td valign="middle">
                <table>
                    <tr>
                        <td>
                            <asp:TextBox AutoCompleteType="disabled" MaxLength="10" ID="txtCustomer" runat="server"
                                CssClass="FormCtrl" Width="150px"></asp:TextBox><br />
                        </td>
                        <td>
                        </td>
                        <td>
                            <asp:Button ID="btnSearch" Width="70px" Height="23" OnClientClick="javascript:return CheckLock(this.id);"
                                runat="server" Text="" Style="background-image: url(Common/images/Search.jpg);
                                background-color: Transparent; border: none; cursor: hand;" OnClick="btnSearch_Click"
                                CausesValidation="False" />
                            <asp:HiddenField ID="hidCustomerID" runat="server" />
                            <asp:HiddenField ID="hidBillToCustomerNo" runat="server" />
                            <asp:HiddenField ID="hidBillToCustomerID" runat="server" />
                        </td>
                    </tr>
                </table>
            </td>
            <td align="right" valign="middle">
                <table>
                    <tr>
                        <td>
                            <asp:Button ID="btnAdd" Width="70px" Height="23" runat="server" Text="" Style="background-image: url(Common/images/newAdd.gif);
                                background-color: Transparent; border: none; cursor: hand;" OnClick="btnAdd_Click"
                                OnClientClick="javascript:return AddNewCustomer(this.id);" CausesValidation="False" />
                        </td>
                        <td style="padding-top: 2px;">
                            <asp:ImageButton ID="ibtnHelp" runat="server" ImageUrl="~/customerMaintenance/Common/images/help.gif" />
                            <asp:ImageButton ID="ibtnClose" runat="server" ImageUrl="~/customerMaintenance/Common/images/close.jpg"
                                OnClick="ibtnClose_Click" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Panel>
