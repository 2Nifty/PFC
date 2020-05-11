<%@ Control Language="C#" AutoEventWireup="true" CodeFile="FooterImage2.ascx.cs" Inherits="Common_UserControls_FooterImage2" %>
        <div id="userInfo" style="color:#ffffff;" ><center>
            <table width="100%" border="0" cellspacing="0" cellpadding="0"  class="FooterImagebg" >
                <tr >
                   <td width="25%" class="foottxt2">Best Viewed in 1024 x 768 &amp; above resolutions.</td>
                   <td align="right">                        
                        <asp:Image ID="imgHeaderLeft" runat="server" ImageUrl="~/Common/Images/userinfo_left.gif" Width="11" Height="25" />
                    </td>
                    <td class="userinfobg" style="padding-left:1px"><b>                        
                        <asp:Label ID="lblPageTitle" runat="server" style="color:#ffffff;"></asp:Label></b>
                       <input type="hidden" id="hidFooterTitle" runat="server" />
                   </td>
                    <td align="left">
                     <asp:Image ID="Image1" runat="server" ImageUrl="~/Common/Images/userinfo_right.gif" Width="11" Height="25" />
                     </td>
                    <td width="12%" class="foottxt2">
                        <a href="http://www.porteousfastener.com" target="_blank" title="All Rights Reserved. Terms & Conditions." style="color: #1C7893;">
                            &copy;&nbsp;Copyright&nbsp;<asp:Label ID="CopyrightYear" runat="server" Text="2008"></asp:Label>
                        </a>
                    </td>
                    <td width="13%">
                        <a href="http://www.novantus.com" target="_blank">
                            <img src="../Common/Images/umbrellaPower.gif" border="0Px" alt="Powered By www.novantus.com"/>
                        </a>
                    </td>
                </tr>
            </table></center>
        </div>
