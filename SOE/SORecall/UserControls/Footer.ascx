<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Footer.ascx.cs" 
Inherits="PFC.Intranet.ListMaintenance.NewFooter" %>

<tr bgcolor="#DFF3F9">
    <td height="29" class="BluTopBord">
        <div id="Footer" class="Footer">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        Best Viewed in 1024 x 768 &amp; above resolutions.</td>
                    <td>
                        <div align="right">
                            <asp:Image ImageUrl="../Images/userinfo_left_rev.gif" runat="server"
                                ID="imgFooterLeftRev" /></div>
                    </td>
                    <td class="userinfobgrev" align="center" style="color: #FFFFFF; width: 400px">
                        <strong>
                            <asp:Label ID="lblHeading" runat="server" Text=""></asp:Label>
                        </strong>
                    </td>
                    <td>
                        <div align="left">
                            <asp:Image ImageUrl="../Images/userinfo_right_rev.gif" runat="server"
                                ID="imgFooterRightRev" /></div>
                    </td>
                    <td>
                        <a href="http://www.porteousfastener.com/" target=_blank class="redTxt" id="lnkCpyright" title="Porteous Fastener Company. All Rights Reserved.">Copyright 2008. </a>
                    </td>
                    <td>
                        <div align="right">
                            <a href="http://www.novantus.com" target="_blank">
                                <asp:Image ImageUrl="../Images/umbrellaPower.gif" runat="server" alt="Powered By www.novantus.com" ID="Image1" /> </a></div>
                    </td>
                </tr>
            </table>
        </div>
    </td>
</tr>
