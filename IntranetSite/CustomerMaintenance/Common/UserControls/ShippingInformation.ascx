<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ShippingInformation.ascx.cs"
    Inherits="PFC.Intranet.Maintenance.ShippingDetails" %>
<%@ Register Src="~/CustomerMaintenance/Common/UserControls/PhoneNumber.ascx" TagName="PhoneNumber"
    TagPrefix="uc2" %>
    
<script>
   
   function CheckCtrl(id)
   {
        var txtVendNo=document.getElementById(id+"txtVendNo").value.replace(/\s/g,'');
        var txtVendName=document.getElementById(id+"txtVenName").value.replace(/\s/g,'');
        var txtCode=document.getElementById(id+"txtVenCode").value.replace(/\s/g,'');
        var txtLocName=document.getElementById(id+"txtAddressName").value.replace(/\s/g,'');
        
        if(txtVendNo!="" && txtVendName!="" && txtCode!="" && txtLocName!="")
            return true;
        else
        {
            alert("'*' Marked fields are mandatory")
            return false;;
        }
    }
    
    
</script>
<table width="100%" height=100% cellpadding="0" cellspacing="0">
    <tr>
        <td>
            <div id="divCredit" runat="server">
                <asp:Panel ID="pnlDetails" runat="server" DefaultButton="ibtnSave">
                    <table cellpadding="0" cellspacing="0" height=401px width="100%" class="blueBorder">
                        <tr>
                            <td class="lightBlueBg">
                                <asp:Label ID="lblInfo" CssClass="BanText" runat="server" Text="Shipping Information"></asp:Label>
                            </td>
                            <td class="lightBlueBg" align="right">
                                <table>
                                    <tr>
                                        <td>
                                            <asp:Button ID="ibtnSave" Width="73px" OnClientClick="Javascript:return CheckCtrl(this.id.replace('ibtnSave',''));"
                                                Height="23" runat="server" Text="" Style="background-image: url(Common/images/btnsave.gif);
                                                background-color: Transparent; border: none; cursor: hand;" OnClick="ibtnSave_Click"
                                                CausesValidation="true" /></td>
                                        <td>
                                            <asp:ImageButton ID="ibtnCancel" runat="server" ImageUrl="~/customerMaintenance/Common/images/cancel.png"
                                                OnClick="ibtnCancel_Click" /></td>
                                    </tr>
                                </table>  
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="padding-top: 3px;">
                                <table width="75%" cellpadding="3" cellspacing="0">
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" colspan="3">
                                            <asp:HiddenField ID="hidCustomerID" runat="server" />
                                            &nbsp;<%-- <span style="color:Red;">* Marked fields are required</span>--%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Ship Loc</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="150px" ID="ddlShippingLoc" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Consolidation Method</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="150px" ID="ddlConsolidationMethod" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Usage Location</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="150px" ID="ddlUsageLoc" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt  " style="height: 26px">
                                            Invoice Sort Order
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="height: 26px">
                                            <asp:DropDownList Width="150px" ID="ddlSortOrder" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Carrier</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="150px" ID="ddlCarrier" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            UPS Account Number</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:TextBox ID="txtUPSAccount" CssClass="FormCtrl" MaxLength=20 runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Expedite</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="150px" ID="ddlExpedite" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Special Label</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:TextBox ID="txtSpecialLabel" MaxLength="15" CssClass="FormCtrl" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Method</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="150px" ID="ddlMethod" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList></td>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            ASN Format</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:TextBox ID="txtASNFormat" MaxLength="15" CssClass="FormCtrl" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Priority</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="150px" ID="ddlPriority" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt  " style="height: 26px" rowspan="4">
                                            <asp:CheckBoxList ID="chkList" runat="server">
                                                <asp:ListItem Value="PD" Text="Proof Delivery"></asp:ListItem>
                                                <asp:ListItem Value="AP" Text="Allow Partials"></asp:ListItem>
                                                <asp:ListItem Value="AS" Text="Allow Subs"></asp:ListItem>
                                                <asp:ListItem Value="RA" Text="Requires ASN "></asp:ListItem>
                                            </asp:CheckBoxList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt  " style="height: 26px" rowspan="4">
                                            <asp:CheckBoxList ID="chkList2" runat="server">
                                                <asp:ListItem Value="AB" Text="Allow BackOrders"></asp:ListItem>
                                                <asp:ListItem Value="RE" Text="Requires 870"></asp:ListItem>
                                                <asp:ListItem Value="RD" Text="Residential Delivery"></asp:ListItem>
                                                <asp:ListItem Value="PR" Text="Packslip Required"></asp:ListItem>
                                            </asp:CheckBoxList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Shipping Instructions</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="150px" ID="ddlShippingInstruction" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Transfer Location</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="150px" ID="ddlTrfLoc" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </div>
        </td>
    </tr>
</table>