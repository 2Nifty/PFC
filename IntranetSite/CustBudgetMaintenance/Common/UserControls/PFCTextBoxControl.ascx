<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PFCTextBoxControl.ascx.cs" Inherits="PFCTextBox" %>
<script language="javascript">

    function CallPFCTextBoxServerEvent(txtClientId)
    {
        //alert('fired');
        var txtBoxValue = document.getElementById(txtClientId).value;
        var hidPreviousValue = document.getElementById(txtClientId.replace("txtBox","hidPreviousValue")).value;
        
        if(txtBoxValue != hidPreviousValue)
        {
            document.getElementById(txtClientId.replace("txtBox","btnCallServerEvent")).click();
            return false;
        }
        else
        {
            event.keyCode=9; 
            return event.keyCode;
        }
        
        return false;
    }

    function OnlyNumbers(evt)
    {
        
        var e = event || evt; // for trans-browser compatibility
        var charCode = e.which || e.keyCode;    
          
        if  (charCode != 46 && 
             charCode != 45 && 
             charCode != 44 && 
            (charCode > 31 && (charCode < 48 || charCode > 57)))
            {
                e.keyCode=0; 
                return false;
            }

        return true;
    }
</script>

<table border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td>
            <asp:TextBox ID="txtBox" runat="server" Font-Bold="true"
                onfocus="javascript:this.select();"
                onkeydown="javascript:if (event.keyCode==13 && this.value == '') {event.keyCode=9; return event.keyCode }if((event.keyCode==9 || event.keyCode==13 )&& (this.value != '')){CallPFCTextBoxServerEvent(this.id);}">
            </asp:TextBox></td>
        <td>
            <asp:HiddenField ID="hidPreviousValue" runat="server" />
        </td>
        <td>
            <asp:Button ID="btnCallServerEvent" runat="server" Text="CallServerEvent" Style="display:none;" OnClick="btnCallServerEvent_Click"/></td>
        <td>
        </td>
    </tr>
</table>

