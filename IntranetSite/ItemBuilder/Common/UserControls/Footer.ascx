<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Footer.ascx.cs" 
Inherits="PFC.Intranet.ListMaintenance.NewFooter" %>
<script type="text/javascript" src="../Common/Javascript/Global.js"></script>

<tr bgcolor="#DFF3F9">
    <td height="29" class="BluTopBord">
        <div id="Footer" class="Footer">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    
                    <td>
                        <div align="right">
                            <asp:Image ImageUrl="~/MaintenanceApps/Common/Images/userinfo_left_rev.gif" runat="server"
                                ID="imgFooterLeftRev" /></div>
                    </td>
                    <td class="userinfobgrev" align="center" style="color: #FFFFFF; width:300px">
                        <strong>
                            <asp:Label ID="lblHeading" runat="server" Text=""></asp:Label>
                        </strong>
                    </td>
                    <td>
                        <div align="left">
                            <asp:Image ImageUrl="~/MaintenanceApps/Common/Images/userinfo_right_rev.gif" runat="server"
                                ID="imgFooterRightRev" /></div>
                    </td>
                    
                    
                </tr>
            </table>
        </div>
       
    </td>
</tr>
