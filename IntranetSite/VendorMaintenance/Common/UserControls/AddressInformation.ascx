<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddressInformation.ascx.cs"
    Inherits="PFC.Intranet.VendorMaintenance.AddressInformation" %>
<%@ Register Src="Contacts.ascx" TagName="Contacts" TagPrefix="uc1" %>

<table width=100% cellpadding="0" cellspacing="0"><tr><td> <div  style="border-collapse: collapse;" id="divAddInfo" runat=server>
            <table width="100%" class="blueBorder" style="border-collapse: collapse; border-bottom: none;">
                <tr>
                    <td class="lightBlueBg">
                        <asp:Label ID="lblAddressInfo" CssClass="BanText" runat="server" Text="Ship From Information"></asp:Label>
                    </td>
                    <td class="lightBlueBg" align="right">
                     
                        <asp:ImageButton ID="btnEdit" runat="server" CausesValidation=false ImageUrl="~/VendorMaintenance/Common/images/edit.gif" OnClick="btnEdit_Click" />
                        <asp:ImageButton ID="ibtnDelete" OnClientClick="javascript:PromptDelete(this.id);"  runat="server" CausesValidation="false" ImageUrl="~/VendorMaintenance/Common/images/btndelete.gif" OnClick="btnDelete_Click" />
                        <asp:ImageButton ID="btnClose" runat="server" CausesValidation=false ImageUrl="~/VendorMaintenance/Common/images/Close.gif" OnClick="btnClose_Click" />
                        
                        <asp:HiddenField ID=hidMode runat=server />
                        <asp:HiddenField ID=hidShipID runat=server />
                        <asp:HiddenField ID=hidVendor runat=server />
                        <asp:HiddenField ID=hidType runat=server />
                        <asp:HiddenField ID=hidBuyID runat=server />
                    </td>
                </tr>
                <tr>
                    <td style="padding-left: 10px;">
                        <table width="90%" cellpadding="5" cellspacing="0">
                            <tr>
                                <td class="boldText">
                                    <asp:Label CssClass="blackTxt" ID="lblAddress" runat="server">Ship From Address</asp:Label></td>
                                <td class="splitBorder_r_h " colspan="2">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td class="splitBorder_r_h " >
                                    <asp:Label CssClass="blackTxt" ID="lblLine1" runat="server">lblLine1,lblLine2</asp:Label></td>
                                <td class="splitBorder_r_h ">
                                    &nbsp;</td>
                                <td>
                                    <span class="boldText">Transit Days: </span>
                                    <asp:Label CssClass="blackTxt" ID="lblTransitDay" runat="server">lblTransitDay</asp:Label></td>
                            </tr>
                            <tr>
                                <td class="splitBorder_r_h ">
                                    <asp:Label CssClass="blackTxt" ID="lblCity" runat="server">City,State,Zip</asp:Label></td>
                                <td class="splitBorder_r_h ">
                                    &nbsp;</td>
                                <td>
                                    <span class="boldText">Product Type: </span>
                                    <asp:Label CssClass="blackTxt" ID="lblProductType" runat="server">ProductType</asp:Label></td>
                            </tr>
                            <tr>
                                <td class="splitBorder_r_h ">
                                    <asp:Label CssClass="blackTxt" ID="lblCountry" runat="server">Country</asp:Label></td>
                                <td>
                                    &nbsp;</td>
                                <td nowrap=nowrap>
                                    <span class="boldText">Email: </span>
                                    <asp:Label CssClass="blackTxt" ID="lblEmail" runat="server"></asp:Label></td>
                            </tr>
                            <tr>
                                <td class="splitBorder_r_h " colspan="2">
                                    <span class="boldText">Phone:&nbsp;</span><asp:Label CssClass="blackTxt" ID="lblPhone"
                                        runat="server">Phone</asp:Label>                               
                                    <span class="boldText">&nbsp;&nbsp;Fax:&nbsp;</span><asp:Label CssClass="blackTxt" ID="lblFax"
                                        runat="server">Fax</asp:Label></td>
                                <td>
                                    <span class="boldText">Web Page: </span>
                                    <asp:Label CssClass="blackTxt" ID="lblWebPage" runat="server">WebPage</asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div></td></tr><tr><td> <div id="divCntDisplay" runat="server" >
            <uc1:Contacts ID="vendorContacts" runat="server" />
        </div></td></tr></table>
       
       
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