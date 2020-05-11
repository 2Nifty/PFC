<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Footer.ascx.cs" Inherits="PFC.WOE.Footer" %>
<script type="text/javascript" src="../Common/Javascript/Global.js"></script>
<script src="Common/JavaScript/Global.js" type="text/javascript"></script>

<tr bgcolor="#DFF3F9">
    <td height="29" class="BluTopBord">
        <div id="Footer" class="Footer">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="30%" align="center">
                        <asp:Label ID="lblLeftText" runat="server" Text="Best Viewed in 1024 x 768 &amp; above resolutions."></asp:Label>
                    </td>

                    <td width="40%" align="center" valign="middle">
                        <table border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="right">
                                    <asp:Image ImageUrl="../Images/userinfo_left_rev.gif" runat="server" ID="imgFooterLeftRev" Width="11px" Height="25px" />
                                </td>
                                <td class="userinfobgrev" align="center" style="color: #FFFFFF; width: 400px; height: 25px;">
                                    <strong>
                                        <asp:Label ID="lblHeading" runat="server" Text="" ForeColor="white"></asp:Label>
                                    </strong>
                                </td>
                                <td>
                                    <asp:Image ImageUrl="../Images/userinfo_right_rev.gif" runat="server" ID="imgFooterRightRev" Width="11px" Height="25px" />
                                </td>
                            </tr>
                        </table> 
                    </td>

                    <td width="15%" align="center">
                            <a href="http://www.porteousfastener.com/" target="_blank" id="lnkCpyright" onmouseover="showHideCorporateTooltip(this.id,event,'show');">
                                <asp:Label ID="lblCpyright" runat="server" Text="Copyright 2010"></asp:Label></a>
                    </td>

                    <td width="15%" align="right">
                            <a href="http://www.novantus.com" target="_blank">
                                <asp:Image ImageUrl="~/Common/Images/umbrellaPower.gif" runat="server" ID="imgPowerBy" alt="Powered By www.novantus.com" /></a>
                    </td>

<%--                <tr>
                    <td>
                        Best Viewed in 1024 x 768 &amp; above resolutions.</td>
                    <td>
                        <div align="right">
                            <asp:Image ImageUrl="../Images/userinfo_left_rev.gif" runat="server"
                                ID="imgFooterLeftRev" /></div>
                    </td>
                    <td class="userinfobgrev" align="center" style="color: #FFFFFF; width: 400px">
                        <strong>
                            <asp:Label ID="lblHeading" runat="server" Text="" ForeColor=white></asp:Label>
                        </strong>
                    </td>
                    <td>
                        <div align="left">
                            <asp:Image ImageUrl="../Images/userinfo_right_rev.gif" runat="server"
                                ID="imgFooterRightRev" /></div>
                    </td>
                    <td>
                        <a href="http://www.porteousfastener.com/" target=_blank class="tooltipAnchor" id="lnkCpyright" onmouseover="showHideCorporateTooltip(this.id,event,'show');">Copyright 2010</a>
                    </td>
                    <td>
                        <div align="right">
                            <a href="http://www.novantus.com" target="_blank">
                                <asp:Image ImageUrl="~/Common/Images/umbrellaPower.gif" runat="server" ID="imgPowerBy" alt="Powered By www.novantus.com" /> </a></div>
                    </td>
                </tr>--%>
                
            </table>
        </div>
        <div id="Tooltip" class="Tooltip" onmouseover="DisplayToolTip('true')" style="position:absolute;">
            <asp:HyperLink runat=server ID="lnkCopyRight" NavigateUrl="http://www.porteousfastener.com/" onclick="DisplayToolTip('false')" onmouseover="DisplayToolTip('true')"; onmouseout="DisplayToolTip('false')";  Target=_blank></asp:HyperLink>
        </div>
    </td>
</tr>
