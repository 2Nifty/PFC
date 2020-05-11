<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SubHeader.ascx.cs" Inherits="SubHeader" %>
         
<table border="0" cellpadding="0" cellspacing="0" width=100%   >
    <tr>
        <td valign="top" class="SubHeaderPanels"  style="padding-left:4px;padding-top:5px"  width=30%>
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <asp:Label ID="lblSON0Caption" runat="server" Text="Sales Order Number :" Font-Bold="True" Width="130px"></asp:Label></td>
                    <td>
                        <asp:Label ID="txtSONumber" runat="server" CssClass="lblbox"  Width="50px" ></asp:Label></td>
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
                    <td width=50px>
                        <asp:Label ID="lnkSoldTo" runat="server" CssClass="TabHead" Text="Sold To:" Font-Bold="True" Width="45px"></asp:Label></td>
                    <td>
                        <asp:Label ID="lblSold_Name" runat="server" CssClass="lblColor"></asp:Label></td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblSoldCustNum" runat="server" CssClass="lblbox"></asp:Label></td>
                    <td>
                        <asp:Label ID="lblSold_Address" runat="server" CssClass="lblColor"></asp:Label></td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <asp:Label ID="lblSold_City" runat="server" CssClass="lblColor"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblSoldCom" runat="server" CssClass="lblColor" Text=",&nbsp;"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblSold_Territory" runat="server" CssClass="lblColor"></asp:Label></td>
                                <td>
                                    &nbsp;<asp:Label ID="lblSold_Pincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                <td>
                                    &nbsp;<asp:Label ID="lblSoldCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <asp:Label ID="lblSold_Phone" runat="server" CssClass="lblColor"></asp:Label></td>
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
                        <asp:Label ID="lblShipCustNum" runat="server" CssClass="lblbox"></asp:Label></td>
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
             <%--OnClick="btnLoadAll_Click"--%>
            <asp:Button ID="btnLoadAll" runat="server" CausesValidation="false"
                Style="display: none" /></td>        
    </tr>
</table>
