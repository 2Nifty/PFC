<%@ Control Language="C#" AutoEventWireup="true" CodeFile="VendorDetails.ascx.cs"
    Inherits="PFC.Intranet.VendorMaintenance.VendorDetails" %>
<%@ Register src="~/VendorMaintenance/Common/UserControls/PhoneNumber.ascx" TagName="PhoneNumber"
    TagPrefix="uc2" %>
<%@ Register Src="Contacts.ascx" TagName="Contacts" TagPrefix="uc1" %>


<table width="100%" cellpadding="0" cellspacing="0">
<tr><td> <div id="divVendorInfo" runat="server">
    <asp:Panel ID="pnlVendorDetails" runat="server" DefaultButton="ibtnUpdate" >  <table cellpadding="0" cellspacing="0" width="100%" class="blueBorder">
                <tr>
                    <td class="lightBlueBg">
                        <asp:Label ID="lblVendorInfo" CssClass="BanText" runat="server" Text="Vendor Information"></asp:Label>
                    </td>
                    <td class="lightBlueBg" align="right">
                        <asp:ImageButton ID="btnContacts" CausesValidation="false" runat="server" ImageUrl="~/VendorMaintenance/Common/images/contacts.gif" OnClick="btnContacts_Click" />&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2" style="padding-top: 3px;">
                        <table width="75%" cellpadding="1" cellspacing="0">
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt ">
                                </td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" colspan="3">
                                    &nbsp;<%-- <span style="color:Red;">* Marked fields are required</span>--%> </td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt ">
                                    Vendor #</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox MaxLength=10 ID="txtVendNo" onkeypress="javascript:ValdateNumber();"  CssClass="FormCtrl" runat="server"></asp:TextBox>
                                    <span style="color:Red;">*</span>    
                                </td>
                                <td class="Left2pxPadd DarkBluTxt ">
                                    </td>      <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    </td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt ">
                                    Vendor Name</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox ID="txtVenName" MaxLength="40" CssClass="FormCtrl" runat="server"></asp:TextBox>
                                    <span style="color:Red;">*</span>    
                                </td>
                                <td class="Left2pxPadd DarkBluTxt ">
                                    1099 Code</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox ID="txtCode" MaxLength="10" CssClass="FormCtrl" runat="server"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt ">
                                    Vendor Code</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox ID="txtVenCode" MaxLength="10" CssClass="FormCtrl" runat="server"></asp:TextBox>
                                    <span style="color:Red;">*</span>    
                                </td>
                                <td class="Left2pxPadd DarkBluTxt ">
                                    Terms Code</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox ID="txtTC" MaxLength="5" CssClass="FormCtrl" runat="server"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt ">
                                    Federal Tax ID</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox CssClass="FormCtrl" onkeypress="javascript:ValidateZip();" MaxLength="30" ID="txtFTD" runat="server"></asp:TextBox></td>
                                <td class="Left2pxPadd DarkBluTxt ">
                                    Currency Code</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox ID="txtCC" MaxLength="10" CssClass="FormCtrl" runat="server"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:Label ID="Label1" CssClass="smallBanText" runat="server" Text="Pay To Information"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt ">
                                    Address Name</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox MaxLength="50" CssClass="FormCtrl" ID="txtAddressName" runat="server"></asp:TextBox>
                                     <span style="color:Red;">*</span>
                                </td>
                                <td>
                                    &nbsp;</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt  " style="height: 26px">
                                    Line 1</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="height: 26px">
                                    <asp:TextBox MaxLength="40" CssClass="FormCtrl" ID="txtLine1" runat="server"></asp:TextBox></td>
                                <td class="Left2pxPadd DarkBluTxt  " style="height: 26px">
                                    Line 2</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="height: 26px">
                                    <asp:TextBox MaxLength="40" CssClass="FormCtrl" ID="txtLine2" runat="server"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt  ">
                                    City</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox MaxLength="20" CssClass="FormCtrl" ID="txtCity" runat="server"></asp:TextBox></td>
                                <td class="Left2pxPadd DarkBluTxt  ">
                                    State</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox MaxLength="2" ID="txtState" runat="server" CssClass="FormCtrl"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt  ">
                                    Zip Code</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox MaxLength="10" CssClass="FormCtrl" onkeypress="javascript:ValidateZip();" ID="txtZipCode" runat="server"></asp:TextBox></td>
                                <td class="Left2pxPadd DarkBluTxt  ">
                                    Country</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:DropDownList ID="ddlCountry" CssClass="FormCtrl" runat="server" Width="130px" Height="20px">
                                    </asp:DropDownList></td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt  ">
                                    Phone</td>
                                <td class="splitBorder_r_h Right2pxPadd">
                                    <uc2:PhoneNumber   ID="phVendor" runat="server" />
                                </td>
                                <td class="Left2pxPadd DarkBluTxt  ">
                                    Fax</td>
                                <td class="splitBorder_r_h Right2pxPadd">
                                    <uc2:PhoneNumber ID="fxVendor" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt  ">
                                    Email</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" colspan="3">
                                    <asp:TextBox CssClass="FormCtrl" MaxLength="80" ID="txtEmail" Width="200px" runat="server"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail"
                                        Display="Dynamic" ErrorMessage="* Invalid" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        &nbsp;</td>
                </tr>
                <tr height="36px" valign="middle">
                    <td class="lightBlueBg" colspan="2" style="padding-left: 120px; vertical-align: middle;
                        border-collapse: collapse;">
                        <asp:ImageButton ID="ibtnSave" CausesValidation=true runat="server" ImageUrl="~/VendorMaintenance/Common/images/BtnSave.gif" OnClientClick="Javascript:return CheckCtrl(this.id.replace('ibtnSave',''));" OnClick="ibtnSave_Click" />
                        <asp:ImageButton ID="ibtnUpdate" CausesValidation=true  runat="server" ImageUrl="~/VendorMaintenance/Common/images/update.gif" OnClientClick="Javascript:return CheckCtrl(this.id.replace('ibtnUpdate',''));" OnClick="ibtnUpdate_Click" />
                        <asp:ImageButton ID="ibtnCancel" runat="server" ImageUrl="~/VendorMaintenance/Common/images/cancel.png" OnClick="ibtnCancel_Click" />
                        <asp:HiddenField ID=hidVendor runat=server />
                        <asp:HiddenField ID=hidAddress runat=server />
                    </td>
                </tr>
            </table>
    </asp:Panel>
          
        </div></td>
        </tr>
        <tr><td> <div id="divCntDisplay" runat="server" class="Sbar" >
            <uc1:Contacts ID="vendorContacts" runat="server" />
        </div></td></tr>
</table>

       
       
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