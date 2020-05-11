<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Header.ascx.cs" Inherits="PFC.Intranet.ACItemBranch.Header" %>
<div id="PageHeader" style="color: #FFFFFF;" class="PageHeader">
    <div id="userInfo">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <asp:Image ID="imgHeaderLeft" runat="server" ImageUrl="../Images/userinfo_left.gif"
                        Width="11" Height="25" />
                </td>
                <td class="userinfobg" style="width: 400px">
                    <asp:Label ID="lblUserInfo" CssClass="Date" runat="server"></asp:Label>
                </td>
                <td>
                    <asp:Image ID="Image1" runat="server" ImageUrl="../Images/userinfo_right.gif" Width="11"
                        Height="25" />
                </td>
            </tr>
        </table>
    </div>
</div>
