<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddressInformation.ascx.cs"
    Inherits="PFC.Intranet.Maintenance.AddressInformation" %>
<%@ Register Src="Contacts.ascx" TagName="Contacts" TagPrefix="uc1" %>
<%@ Register Src="PhoneNumber.ascx" TagName="PhoneNumber" TagPrefix="uc1" %>
<table width="100%" cellpadding="0" cellspacing="0">
    <tr>
        <td>
            <div style="border-collapse: collapse;" id="divAddInfo" runat="server">
                <table width="100%" class="blueBorder" style="border-collapse: collapse; border-bottom: none;">
                    <tr style="display: none;">
                        <td colspan="2">
                            <asp:HiddenField ID="hidMode" runat="server" />
                            <asp:HiddenField ID="hidAddressID" runat="server" />
                            <asp:HiddenField ID="hidBillCustomerID" runat="server" />
                            <asp:HiddenField ID="hidType" runat="server" />
                            <asp:HiddenField ID="hidCustomerID" runat="server" />
                            <asp:HiddenField ID="hidCustomerNo" runat="server" />
                            <asp:HiddenField ID="hidBillCustomerNo" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="lightBlueBg">
                            <asp:Label ID="lblAddressInfo" CssClass="BanText" runat="server" Text="Address Information"></asp:Label>
                        </td>
                        <td class="lightBlueBg" align="right">
                            <table>
                                <tr>
                                    <td>
                                        <asp:Button ID="btnSave" Width="73px" Height="23" runat="server" Text="" Style="background-image: url(Common/images/btnsave.gif);
                                            background-color: Transparent; border: none; cursor: hand;" OnClientClick="Javascript:return btnSaveClick(this.id);"
                                            OnClick="btnSave_Click" CausesValidation="true" />
                                    </td>
                                    <td>
                                        <asp:Button ID="btnCancel" Width="70px" Height="23" runat="server" Text="" Style="background-image: url(Common/images/cancel.png);
                                            background-color: Transparent; border: none; cursor: hand;" OnClick="btnClose_Click"
                                            CausesValidation="False" /></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 10px;" colspan="2">
                            <table width="90%" cellpadding="1" style="border-collapse: collapse;">
                                <tr>
                                    <td width="50%">
                                        <table width="100%">
                                            <tr>
                                                <td class="Left2pxPadd DarkBluTxt boldText" id="td7">
                                                    <asp:LinkButton ID="lblNamelnk" runat="server" Font-Underline="true" Font-Bold="true"
                                                        Text="Customer No"></asp:LinkButton><br /><div id="divToolTips" class="list" style="display: none; position: absolute;" onmouseup="return false;">
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td>
                                                                    <span class="">Entry ID: </span>
                                                                    <asp:Label ID="lblEntryID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                <td>
                                                                    <span class="" style="padding-left: 5px;">Entry Date: </span>
                                                                    <asp:Label ID="lblEntryDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <span class="">Change ID: </span>
                                                                    <asp:Label ID="lblChangeID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                <td>
                                                                    <span class="" style="padding-left: 5px;">Change Date: </span>
                                                                    <asp:Label ID="lblChangeDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                    
                                                </td>
                                                <td class="Left2pxPadd" valign="middle">
                                                    <table cellpadding="1" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox MaxLength="10" CssClass="FormCtrl" AutoPostBack="true" ID="txtCustNo"
                                                                    runat="server" OnTextChanged="txtCustNo_TextChanged"></asp:TextBox>
                                                            </td>
                                                            <td>
                                                                <span id="spCustNo" class="Required"></span>
                                                            </td>
                                                            <td style="padding-left: 10px;">
                                                                <asp:Label ID="lblCode" runat="server" Text="Type "></asp:Label></td>
                                                            <td style="padding-left: 10px;">
                                                                <asp:DropDownList ID="ddlCode" CssClass="FormCtrl" runat="server" Width="70px" Height="20px">
                                                                </asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd">
                                                    <asp:Label ID="lblName1" runat="server" Text="Name"></asp:Label></td>
                                                <td class="Left2pxPadd">
                                                    <asp:TextBox MaxLength="40" CssClass="FormCtrl" ID="txtCustName" runat="server" Width="190px"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd">
                                                    <asp:Label ID="lblname2" runat="server" Text="Name 2 "></asp:Label></td>
                                                <td class="Left2pxPadd">
                                                    <asp:TextBox MaxLength="50" CssClass="FormCtrl" ID="txtCustName2" runat="server"
                                                        Width="190px"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd">
                                                    <asp:Label ID="lblSKey" runat="server" Text="Search Key "></asp:Label></td>
                                                <td colspan="3" class="Left2pxPadd">
                                                    <asp:TextBox MaxLength="15" CssClass="FormCtrl" ID="txtSearchKey" runat="server"
                                                        Width="190px"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd">
                                                    <asp:Label ID="lblaltname" runat="server" Text="Alt Customer Name "></asp:Label></td>
                                                <td colspan="3" class="Left2pxPadd">
                                                    <asp:TextBox MaxLength="40" CssClass="FormCtrl" ID="txtAltCustName" runat="server"
                                                        Width="190px"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd">
                                                    <asp:Label ID="lblSortName" runat="server" Text="Sort Name "></asp:Label></td>
                                                <td colspan="3" class="Left2pxPadd">
                                                    <asp:TextBox CssClass="FormCtrl" MaxLength="40" ID="txtSortName" runat="server" Width="190px"></asp:TextBox></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="50%">
                                        <table width="100%">
                                            <tr>
                                                <td class="Left2pxPadd">
                                                    <asp:Label ID="Label1" runat="server" Text="Address 1"></asp:Label></td>
                                                <td class="Left2pxPadd" valign="middle">
                                                    <table cellpadding="1" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox MaxLength="40" CssClass="FormCtrl" ID="txtAddress1" runat="server"></asp:TextBox>
                                                                <span id="spAddress1" class="Required"></span>
                                                            </td>
                                                            <td style="padding-left: 10px;">
                                                                <asp:Label ID="Label2" runat="server" Text="Type "></asp:Label></td>
                                                            <td style="padding-left: 10px;">
                                                                <asp:DropDownList ID="ddlAddType" CssClass="FormCtrl" runat="server" Width="70px"
                                                                    Height="20px">
                                                                </asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd">
                                                    <asp:Label ID="Label3" runat="server" Text="Address 2"></asp:Label></td>
                                                <td class="Left2pxPadd" style="padding-left: 6px;">
                                                    <asp:TextBox MaxLength="40" CssClass="FormCtrl" ID="txtAddress2" runat="server" Width="190px"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd">
                                                    <asp:Label ID="Label4" runat="server" Text="City"></asp:Label></td>
                                                <td class="Left2pxPadd" style="padding-left: 6px;">
                                                    <asp:TextBox MaxLength="20" CssClass="FormCtrl" ID="txtCity" runat="server" Width="190px"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd">
                                                    <asp:Label ID="Label5" runat="server" Text="State"></asp:Label></td>
                                                <td colspan="3" valign="middle" style="padding-left: 5px;">
                                                    <table cellpadding="1" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox MaxLength="2" CssClass="FormCtrl" ID="txtState" runat="server" Width="80px"></asp:TextBox>
                                                            </td>
                                                            <td style="padding-left: 10px;">
                                                                <asp:Label ID="Label8" runat="server" Text="PostCode "></asp:Label></td>
                                                            <td style="padding-left: 10px;">
                                                                <asp:TextBox ID="txtPostCode" onkeypress="Javascript:ValidateKeyPress(event);" CssClass="FormCtrl"
                                                                    MaxLength="10" runat="server" Width="70px">
                                                                </asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd">
                                                    <asp:Label ID="Label6" runat="server" Text="Country"></asp:Label></td>
                                                <td colspan="3" class="Left2pxPadd" style="padding-left: 6px;">
                                                    <asp:TextBox MaxLength="4" CssClass="FormCtrl" ID="txtCountry" runat="server" Width="190px"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd">
                                                    <asp:Label ID="Label7" runat="server" Text="Phone"></asp:Label></td>
                                                <td colspan="3" class="Left2pxPadd" style="padding-left: 3px;">
                                                    <uc1:PhoneNumber ID="txtPhone" runat="server" />
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
        </td>
    </tr>
    <tr>
        <td>
            <div id="divCntDisplay" runat="server">
                <uc1:Contacts ID="customerContacts" runat="server" />
            </div>
        </td>
    </tr>
</table>

<script>    
    function PromptDelete(ctrlID)
    {
        var info=document.getElementById(ctrlID.replace('ibtnDelete','lblAddressInfo')).innerText;
        if(confirm('Do you want to delete this '+info+'?'))
            return true;
        else
            return false;
    }
</script>

