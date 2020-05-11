<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SalesInformation.ascx.cs"
    Inherits="PFC.Intranet.Maintenance.SalesDetails" %>
<%@ Register Src="novapopupdatepicker.ascx" TagName="novapopupdatepicker" TagPrefix="uc1" %>
<%@ Register Src="~/CustomerMaintenance/Common/UserControls/PhoneNumber.ascx" TagName="PhoneNumber"
    TagPrefix="uc2" %>
<%@ Reference VirtualPath="~/CustomerMaintenance/Common/UserControls/CustomerHeader.ascx" %>    
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
<table width="100%" cellpadding="0" cellspacing="0">
    <tr>
        <td>
            <div id="divCredit" runat="server">
                <asp:Panel ID="pnlDetails" runat="server" DefaultButton="ibtnSave">
                    <table cellpadding="0" cellspacing="0" width="100%" class="blueBorder">
                        <tr>
                            <td class="lightBlueBg">
                                <asp:Label ID="lblInfo" CssClass="BanText" runat="server" Text="Sales Information"></asp:Label>
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
                            <td colspan="2" style="padding-top: 2px;">
                            <div class="Sbar" oncontextmenu="Javascript:return false;" id="divdatagrid1" style="overflow-x: auto;
                                                    overflow-y: auto; position: relative; top: 0px; left: 0px; height: 360px; width: 790px;
                                                    border: 0px solid; vertical-align: top;">  
                                <table width="75%" cellpadding="3" cellspacing="0">
                                    
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Last Purchase Date</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <uc1:novapopupdatepicker ID="dpLastPurchaseDate" runat="server" />
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Serial No. Code</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlSerialCode" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            First Activity Date</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <uc1:novapopupdatepicker ID="dpFirstActivity" runat="server" />
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Type of Order</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlTypeOrder" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Cust Ship Loc</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlIMLocation" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList></td>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Shipping Terms</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlShippingTerms" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            ABC Code</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlAbcCode" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Reason Code</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlReasonCode" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Price Code</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlPriceCode" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Class of Trade</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlClassTrade" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Chain Code</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlChainCode" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Region</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlRegion" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Customer Type</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlCustomerType" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Sales Organization</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlSalesOrganization" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt" style="height: 26px">
                                            Contract Number</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="height: 26px">
                                            <asp:TextBox MaxLength="20" CssClass="FormCtrl" ID="txtContractNo" runat="server"></asp:TextBox></td>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                            Sales Territory</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlTerritory" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Contract Schedule 1</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlcSchedule1" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList></td>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Sales Rep</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" CssClass="FormCtrl" ID="ddlSalesRep" runat="server"
                                                Height="20px">
                                            </asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Contract Schedule 2</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlcSchedule2" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList></td>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Support Rep
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlcSupportRep" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Contract Schedule 3
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlcSchedule3" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Sales Rank
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlSalesRank" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Contract Schedule 4
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlcSchedule4" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Invoice Instructions
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlInvoiceIns" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Contract Schedule 5
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlcSchedule5" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Invoice Delivery
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlInvDelivery" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Contract Schedule 6
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlcSchedule6" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Discount Type
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlDiscountType" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Contract Schedule 7
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlcSchedule7" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Buy Group
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlBuyGroup" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt" style="height: 26px">
                                            Customer Default Price</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="height: 26px">
                                            <asp:DropDownList Width="128px" ID="ddlCustDefPrice" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Rebate Group
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlRebateGroup" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt" style="height: 26px">Customer Price Ind</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="height: 26px">
                                            <asp:DropDownList Width="128px" ID="ddlCustPriceInd" CssClass="FormCtrl" runat="server"
                                                Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Min Billing Amount
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:TextBox ID="txtMinBillingAmt" MaxLength=18 runat="server" onkeypress="javascript:ValidateNumber();" CssClass="FormCtrl"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt" style="height: 26px">
                                            Web Discount Pct</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="height: 26px">
                                            <asp:TextBox MaxLength="10" CssClass="FormCtrl" ID="txtWebDiscPct" runat="server" onkeypress="javascript:ValidateNumber();" OnTextChanged="txtWebDiscPct_TextChanged"></asp:TextBox></td>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            LOB
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlLOB" CssClass="FormCtrl" runat="server" Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt" style="height: 26px">&nbsp;</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="height: 26px" valign="top">
                                            <asp:CheckBox ID="chkWebDiscInd" runat="server" Text="Enable Web Discount" />
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            SIC
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlSIC" CssClass="FormCtrl" runat="server" Height="20px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt" style="height: 26px">
                                            SO Document Sort</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="height: 26px" valign="top">
                                            <asp:DropDownList Width="128px" ID="ddlSODocSort" CssClass="FormCtrl" runat="server" Height="20px">
                                            </asp:DropDownList></td>
                                        <td class="Left2pxPadd DarkBluTxt">
                                            Cert Required</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            <asp:DropDownList Width="128px" ID="ddlCertsInd" CssClass="FormCtrl" runat="server" Height="20px">
                                            </asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt" style="height: 26px">
                                            IRS EIN Number</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                            &nbsp;<asp:TextBox MaxLength="15" CssClass="FormCtrl" ID="txtIRSEINNo" runat="server"></asp:TextBox></td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" rowspan="3">
                                            <asp:CheckBoxList ID="chkList" runat="server">
                                                <asp:ListItem Value="NP" Text="Net Price"></asp:ListItem>
                                                <asp:ListItem Value="NX" Text="Next Price"></asp:ListItem>
                                                <asp:ListItem Value="SC" Text="Surcharge"></asp:ListItem>
                                            </asp:CheckBoxList>
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" rowspan="2" valign=top>
                                            <asp:CheckBoxList ID="chkList2" runat="server">
                                                <asp:ListItem Value="PO" Text="PO Required"></asp:ListItem>
                                            </asp:CheckBoxList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt" style="height: 26px">
                                            </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="height: 26px">
                                            </td>
                                        <td colspan="2" class="Left2pxPadd DarkBluTxt" style="height: 26px">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt ">
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" colspan="3">
                                            <asp:HiddenField ID="hidCustomerID" runat="server" />
                                            &nbsp;<%-- <span style="color:Red;">* Marked fields are required</span>--%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                </table>
                            </div>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </div>
        </td>
    </tr>
</table>