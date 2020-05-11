<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SubHeader.ascx.cs" Inherits="SubHeader" %>
         
<table border="0" cellpadding="0" cellspacing="0" width=100%   >
    <tr>
        <td valign="top" class="SubHeaderPanels"  style="padding-left:4px;padding-top:5px"  width=30%>
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <asp:Label ID="lblPON0Caption" runat="server" Text="Purchase Order No :" Font-Bold="True" Width="130px"></asp:Label></td>
                    <td>
                        <asp:Label ID="txtPONumber" runat="server" CssClass="lblbox"  Width="50px" ></asp:Label></td>
                </tr>
                <tr>
                    <td   valign=middle>
                        </td>
                    <td>
                        </td>
                </tr>
                <tr>
                    <td   valign=middle>
                        </td>
                    <td>
                        </td>
                </tr>
            </table>
        </td>
        <td valign="top" class="SubHeaderPanels" width=35%  style="padding-left:4px;padding-top:5px">
            <table border="0" cellpadding="0" cellspacing="0" width=100%>
                <tr>
                    <td width="65px">
                        <asp:Label ID="lnkBuyFrom" runat="server" CssClass="TabHead" Text="Buy From:" Font-Bold="True" Width="55px"></asp:Label></td>
                    <td>
                        <asp:Label ID="lblBuy_Name" runat="server" CssClass="lblColor"></asp:Label></td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblBuyVendorNum" runat="server" CssClass="lblbox"></asp:Label></td>
                    <td>
                        <asp:Label ID="lblBuy_Address" runat="server" CssClass="lblColor"></asp:Label></td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <asp:Label ID="lblBuy_City" runat="server" CssClass="lblColor"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblBuyCom" runat="server" CssClass="lblColor" Text=",&nbsp;"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblBuy_Territory" runat="server" CssClass="lblColor"></asp:Label></td>
                                <td>
                                    &nbsp;<asp:Label ID="lblBuy_Pincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                <td>
                                    &nbsp;<asp:Label ID="lblBuyCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <asp:Label ID="lblBuy_Phone" runat="server" CssClass="lblColor"></asp:Label></td>
                </tr>
            </table>
        </td>
        <td  valign="top" class="SubHeaderPanels" style="padding-left:4px;padding-top:5px" width=35%>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td  width=55px>
                        <asp:Label ID="lnkShipTo" runat="server" CssClass="TabHead" 
                            Text="Ship To:" Font-Bold="True"></asp:Label></td>
                    <td>
                        <asp:Label ID="lblShip_Name" runat="server" CssClass="lblColor"></asp:Label></td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblShipVendorNum" runat="server" CssClass="lblbox"></asp:Label></td>
                    <td>
                        <asp:Label ID="lblShip_Address" runat="server" CssClass="lblColor"></asp:Label></td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <asp:Label ID="lblShip_City" runat="server" CssClass="lblColor"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblShipCom" runat="server" CssClass="lblColor" Text=",&nbsp;"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblShip_State" runat="server" CssClass="lblColor"></asp:Label></td>
                                <td>
                                    &nbsp;<asp:Label ID="lblShip_Pincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                <td>
                                    &nbsp;<asp:Label ID="lblShipCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <asp:Label ID="lblShip_Phone" runat="server" CssClass="lblColor"></asp:Label></td>
                </tr>
            </table>
        </td>
      </tr>
      
    <tr>
        <td >
            <asp:UpdatePanel ID="upContext" runat="server" UpdateMode ="Conditional" >
           
            <ContentTemplate>
                    <div id="divTool" class="MarkItUp_ContextMenu_MenuTable" style="display: none; word-break: keep-all;
                        position: absolute">
                        <table border="0" bordercolor="#000099" cellpadding="0" cellspacing="0" class="MarkItUp_ContextMenu_Outline"
                            width="20%">
                            <tr>
                                <td class="bgmsgboxtile">
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td class="txtBlue" width="90%">
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="bgtxtbox">
                                    <table border="0" cellspacing="0" width="100%">
                                        <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                            onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'">
                                            <td>
                      <%--                          <asp:ListBox ID="lstDetails" runat="server" AutoPostBack="true" CssClass="cnt Sbar"
                                                    OnSelectedIndexChanged="lstDetails_SelectedIndexChanged" Width="200px"></asp:ListBox>
                                                    
                     --%>            
                     
                                            <asp:ListBox ID="lstDetails" runat="server" AutoPostBack="true" CssClass="cnt Sbar"
                                                     Width="200px"></asp:ListBox>
                                                    
                  
                                </td>
                                        </tr>
                                        <tr>
                                            <td>
                                           <%-- OnClick="btnGetDetails_Click" --%>
                                                <asp:Button ID="btnGetDetails" runat="server" Style="display: none"
                                                    Text="" />
                                                <asp:HiddenField ID="hidCurrentControl" runat="server" Value="" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </ContentTemplate>
       </asp:UpdatePanel>
                
        </td>
        <td >
        </td>
        <td>
            <asp:HiddenField ID="hidPreviousValue" runat="server" />
            <asp:HiddenField ID="hidVendorNo" runat="server" />
            <asp:HiddenField ID="hidPOOrderID" runat="server" />
             <%--OnClick="btnLoadAll_Click"--%>
            <asp:Button ID="btnLoadAll" runat="server" CausesValidation="false"
                Style="display: none" /></td>        
    </tr>
</table>
