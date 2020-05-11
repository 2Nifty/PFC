<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Header.ascx.cs" Inherits="PFC.Intranet.ListMaintenance.Header" %>
<div id="PageHeader" style="color:#FFFFFF;">
     <div  style="padding-top:8px;padding-left:5px;">
     <table width=100%><tr><td><asp:Label ID="Label1" runat="server"  CssClass="BannerText" Text="Cross Reference Builder"></asp:Label> </td>
     <td align=right style="padding-right:10px;">
         <asp:Label ID="Label2" ForeColor=#CC0000 Font-Bold=true runat="server" Text="Customer Name:"> </asp:Label>&nbsp;<asp:Label ForeColor=#CC0000 ID="lblCustNo" runat="server" Font-Bold=true>     
     </asp:Label></td>
     </tr></table>
     
    </div>
        <div id="userInfo" style="display:none;">
            <table width="100%" border="0" cellspacing="0" id="tdHeaderSection1" cellpadding="0">
                <tr>
                    <td>                        
                        <asp:Image ID="imgHeaderLeft" runat=server ImageUrl="~/Common/Images/userinfo_left.gif" Width="11" Height="25" />
                    </td>                    
                    <td class="userinfobg" style="width:400px" >                        
                        <asp:Label ID="lblUserInfo" CssClass="Date" runat="server"></asp:Label>
                    </td>
                    <td>
                     <asp:Image ID="Image1" runat=server ImageUrl="~/Common/Images/userinfo_right.gif" Width="11" Height="25" />
                     </td>
                </tr>
            </table>
        </div>
    </div>
