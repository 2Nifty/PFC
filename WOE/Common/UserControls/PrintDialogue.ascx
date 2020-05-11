<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PrintDialogue.ascx.cs" Inherits="PrintDialogue" %>

<table cellpadding="0" cellspacing="0">
    <tr>
        <td style="padding-right:3px;">
            <asp:ImageButton ID="ibtnEmail" Style="cursor: hand;" CausesValidation="false" ImageUrl="../Images/mail.gif"
                ToolTip="Click here to send eMail" runat="server" OnClick="ibtnEmail_Click1" /></td>
        <td style="padding-right:3px;">
            <asp:ImageButton ID="ibtnPrint" Style="cursor: hand;" CausesValidation="false" ImageUrl="../Images/print.gif"
                ToolTip="Click here to Print" runat="server" OnClick="ibtnPrint_Click1" /></td>
        <td>
            <asp:ImageButton ID="ibtnFax" Style="cursor: hand;padding-right:3px;" CausesValidation="false" ImageUrl="../Images/fax.gif"
                ToolTip="Click here to Fax" runat="server" OnClick="ibtnFax_Click" />
        </td>
         <td>
                <input type="hidden" id="hidPageURL" runat="server" />
                <input type="hidden" id="hidPageTitle" runat="server" />
                <input type="hidden" id="hidCustomerNo" runat="server" />
                <input type="hidden" id="hidFormName" runat="server" />
         </td>
    </tr>
</table>
