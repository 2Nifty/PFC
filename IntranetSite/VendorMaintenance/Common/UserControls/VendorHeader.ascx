<%@ Control Language="C#" AutoEventWireup="true" CodeFile="VendorHeader.ascx.cs"
    Inherits="PFC.Intranet.VendorMaintenance.VendorHeader" %>
<table cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td width="50%" valign="top" style="padding-top: 5px;">
            <table width="100%" cellpadding="3" cellspacing="0">
                <tr>
                    <td class="Left2pxPadd boldText" width="18%">
                        Vendor #:</td>
                    <td class="splitBorder_r_h " width="35%">
                        <asp:Label ID="lblVendNo" runat="server"></asp:Label></td>
                    <td class="Left2pxPadd DarkBluTxt boldText" width="19%">
                        </td>
                    <td class="splitBorder_r_h " width="25%">
                       </td>
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText">
                        Vendor Name:</td>
                    <td class="splitBorder_r_h ">
                        <asp:Label ID="lblVenName"  runat="server"></asp:Label></td>
                    <td class="Left2pxPadd DarkBluTxt boldText">
                        1099 Code:
                    </td>
                    <td class="splitBorder_r_h ">
                        <asp:Label ID="lblCode"  runat="server"></asp:Label></td>
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText">
                        Vendor Code:</td>
                    <td class="splitBorder_r_h ">
                        <asp:Label ID="lblVenCode"  runat="server"></asp:Label></td>
                    <td class="Left2pxPadd DarkBluTxt boldText">
                        Terms Code:</td>
                    <td class="splitBorder_r_h ">
                        <asp:Label ID="lblTC"  runat="server"></asp:Label></td>
                </tr>
                <tr>
                    <td class="Left2pxPadd DarkBluTxt boldText">
                        Federal Tax ID:</td>
                    <td class="splitBorder_r_h ">
                        <asp:Label  ID="lblFTD" runat="server"></asp:Label></td>
                    <td class="Left2pxPadd DarkBluTxt boldText">
                        Currency Code:</td>
                    <td class="splitBorder_r_h ">
                        <asp:Label ID="lblCC"  runat="server"></asp:Label></td>
                </tr>
            </table>
        </td>
        <td id="tdAddress" runat="server" width="50%" style="padding: 4px;">
            <table width="100%" class="blueBorder TabCntBk">
                <tr>
                    <td>
                        <table width="50%" cellpadding="2" cellspacing="0">
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt boldText" runat="server" id="tdPayAddress" nowrap=nowrap align=left>
                                    <asp:LinkButton ID="lnkPayto" runat="server" Font-Underline="true" Text="Pay To"
                                        CssClass="TabHead"></asp:LinkButton><br />
                                    <div id="divToolTips" class="list" style="display: none; position: absolute;" onmouseup="return false;">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                           <tr>
                                                <td>
                                                    <span class="">Entry ID: </span>
                                                    <asp:Label ID="lblEntryID" runat="server" Text="" Font-Bold="false"></asp:Label></td><td>
                                                    <span class="" style="padding-left:5px;">Entry Date: </span>
                                                    <asp:Label ID="lblEntryDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                </tr>  <tr>
                                                <td >
                                                    <span class="">Change ID: </span>
                                                    <asp:Label ID="lblChangeID" runat="server" Text="" Font-Bold="false"></asp:Label></td> <td>
                                                    <span class="" style="padding-left:5px;">Change Date: </span>
                                                    <asp:Label ID="lblChangeDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                            </tr> 
                                           
                                        </table>
                                    </div>
                                </td>
                                <td>
                                    <asp:Label  ID="lblAddress" runat="server">Pay To Address</asp:Label></td>
                                <td class="splitBorder_r_h ">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;</td>
                                <td class="splitBorder_r_h " nowrap="nowrap">
                                    <asp:Label  ID="lblLine1" runat="server">lblLine1,lblLine2</asp:Label></td>
                                <td class="splitBorder_r_h ">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;</td>
                                <td class="splitBorder_r_h " nowrap="nowrap">
                                    <asp:Label  ID="lblCity" runat="server">City,State,Zip</asp:Label></td>
                                <td class="splitBorder_r_h ">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;</td>
                                <td class="splitBorder_r_h ">
                                    <asp:Label  ID="lblCountry" runat="server">Country</asp:Label></td>
                                <td>
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;</td>
                                <td class="splitBorder_r_h " nowrap=nowrap>
                                   <asp:Label  ID="lblPhones"
                                        runat="server" CssClass="boldText">Phone:&nbsp;</asp:Label><asp:Label  ID="lblPhone"
                                        runat="server">Phone</asp:Label></td>
                                <td class="splitBorder_r_h " nowrap=nowrap>
                                    <asp:Label  ID="lblFaxs"
                                        runat="server"  CssClass="boldText">Fax:&nbsp;</asp:Label><asp:Label  ID="lblFax"
                                        runat="server">Fax</asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <%--  <td valign=middle id=tdDetails runat=server>
                                        <table width="100%" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td valign=middle width=65% style="padding-right:40px;">
                                                    <table cellpadding=1 cellspacing=1 class=blueBorder width=100%>
                                                        <tr><td class="Left2pxPadd DarkBluTxt"></td></tr>
                                                        <tr><td class="Left2pxPadd DarkBluTxt"><asp:Label ID=lblLocationName runat=server Text="Location Name"></asp:Label></td></tr>
                                                        <tr><td class="Left2pxPadd DarkBluTxt"><asp:Label ID=lblAddressLine1 runat=server Text="Addressline1,"></asp:Label><asp:Label ID=lblAddressLine2 runat=server Text="Addressline2"></asp:Label></td></tr>
                                                        <tr><td class="Left2pxPadd DarkBluTxt"><asp:Label ID=lblPTCity runat=server Text="City, "></asp:Label><asp:Label ID=lblPTState runat=server Text="State, "></asp:Label><asp:Label ID=lblCountry runat=server Text="Country"></asp:Label></td></tr>
                                                    </table>
                                                </td>
                                              
                                            </tr>
                                        </table>
                                    </td>--%>
    </tr>
</table>
