<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PrintDialogue.ascx.cs" Inherits="PrintDialogue" %>

<table width="100%" cellpadding="0" cellspacing="0">
    <tr>
        <td>
            <asp:ImageButton ID="ibtnEmail" Style="cursor: hand;" CausesValidation="false" ImageUrl="~/Common/Images/mail.gif"
                ToolTip="Click here to send eMail" runat="server" OnClientClick="javascript:document.getElementById('hidParent').value='true';" OnClick="ibtnEmail_Click1" /></td>
        <td>
            <asp:ImageButton ID="ibtnPrint" Style="cursor: hand;" CausesValidation="false" ImageUrl="~/Common/Images/printer.gif"
                ToolTip="Click here to Print" runat="server" OnClientClick="javascript:document.getElementById('hidParent').value='true';" OnClick="ibtnPrint_Click1" /></td>
        <td>
            <asp:ImageButton ID="ibtnFax" Style="cursor: hand;" CausesValidation="false" ImageUrl="~/Common/Images/fax.gif"
                ToolTip="Click here to Fax" runat="server" OnClientClick="javascript:document.getElementById('hidParent').value='true';" OnClick="ibtnFax_Click" />
        </td>
         <td>
              <input type="hidden" id="hidPageURL" runat="server" />
              <input type="hidden" id="hidPageTitle" runat="server" />
              <input type="hidden" id="hidCustomerNo" runat="server" />
              <input type="hidden" id="hidFormName" runat="server" />
               <input type="hidden" id="hidShowFax" runat="server" value="true" />
               <input type="hidden" id="hidShowEmail" runat="server" value="true" />
              <input type="hidden" id="hidParent"/>
         </td>
    </tr>
</table>
