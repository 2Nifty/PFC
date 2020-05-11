<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Footer.ascx.cs" 
Inherits="PFC.Intranet.ListMaintenance.NewFooter" %>

<tr bgcolor="#DFF3F9">
    <td height="29" class="BluTopBord">
        <div id="Footer" class="Footer">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        </td>
                    <td>
                        <div align="right">
                            <asp:Image ImageUrl="~/vendormaintenance/Common/Images/userinfo_left_rev.gif" runat="server"
                                ID="imgFooterLeftRev" /></div>
                    </td>
                    <td class="userinfobgrev" align="center" style="color: #FFFFFF; width: 400px">
                        <strong>
                            <asp:Label ID="lblHeading" runat="server" Text=""></asp:Label>
                        </strong>
                    </td>
                    <td>
                        <div align="left">
                            <asp:Image ImageUrl="~/vendormaintenance/Common/Images/userinfo_right_rev.gif" runat="server"
                                ID="imgFooterRightRev" /></div>
                    </td>
                    <td>
                        <a href="http://www.porteousfastener.com/" target=_blank class="tooltipAnchor" id="lnkCpyright" onmouseover="showHideCorporateTooltip(this.id,event,'show');"> </a>
                    </td>
                    <td>
                        <div align="right">
                            <a href="http://www.novantus.com" target="_blank">&nbsp;</a></div>
                    </td>
                </tr>
            </table>
        </div>
    </td>
</tr>
