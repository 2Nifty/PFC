<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MessageDisplay.ascx.cs" Inherits="PFCIntranet_Common_UserControls_MessageDisplay" %>

<table id=MessageBox runat=server  bgcolor=#FFE67D>
<tr>
    <td class="MessageContent">MessageBox</td>
</tr>
</table>
<asp:Panel ID="panMessage" HorizontalAlign=Center runat=server>
    <table border="0" id="MainTable" runat=server visible=false cellpadding="5" cellspacing="5">
        <tr>
        <td>
            <table  border="0" cellpadding="0" cellspacing="0" bgcolor="#FFE67D">
              <tr>
                <td width="1" height="1" align="left" valign="top"><asp:Image ID="Image1" runat="server" ImageUrl="~/Common/Images/MessageBox/lTCUrve.gif" width="6" height="6" /></td>
                <td rowspan="2"><asp:Label id="lblFlag" runat="server" CssClass="MessageContent"></asp:Label></td>
                <td width="1" height="1" align="right" valign="top"><asp:Image ID="Image2" runat="server" ImageUrl="~/Common/Images/MessageBox/RTCUrve.gif" width="6" height="6" /></td>
              </tr>
              <tr>
                <td width="1" height="1" align="left" valign="bottom"><asp:Image ID="Image3" runat="server" ImageUrl="~/Common/Images/MessageBox/lbCUrve.gif" width="6" height="6" /></td>
                <td align="right" valign="bottom"><asp:Image ID="Image4" runat="server" ImageUrl="~/Common/Images/MessageBox/rbCUrve.gif" width="6" height="6" /></td>
              </tr>
            </table>
        </td>
        </tr>    
    </table>
</asp:Panel>