<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HeaderImage.ascx.cs" Inherits="Common_UserControls_HeaderImage" %>
<div id="userInfo" style="color:#ffffff;"  class="HeaderImagebg"><center>
            <table width="50%" border="0" cellspacing="0" cellpadding="0" >
                <tr >
                    <td align="right">                        
                        <asp:Image ID="imgHeaderLeft" runat=server ImageUrl="~/Common/Images/userinfo_left.gif" Width="11" Height="25" />
                    </td>
                    <td class="userinfobg" style="padding-right:5px">
                        <asp:Image ID="lblDate" runat=server ImageUrl="~/Common/Images/clock.gif" ></asp:Image>
                    </td>
                    <td class="userinfobg" style="padding-left:1px">                        
                        <asp:Label ID="lblUserInfo" runat="server"></asp:Label>
                    </td>
                    <td align="left">
                     <asp:Image ID="Image1" runat=server ImageUrl="~/Common/Images/userinfo_right.gif" Width="11" Height="25" />
                     </td>
                </tr>
            </table></center>
        </div>
