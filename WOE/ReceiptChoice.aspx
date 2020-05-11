<%--<%@ Page Language="C#" AutoEventWireup="true" Codebehind="ReceiptChoice.aspx.cs" EnableEventValidation="false" Inherits="ReceiptChoice" %>
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Receipt Choice</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
    function SetChoice() 
    {
        var PartialChoice = document.getElementById('rbtnPartial');
        var ShortChoice = document.getElementById('rbtnShort');
        var CompleteChoice = document.getElementById('rbtnComplete');
        if (!PartialChoice.checked && !ShortChoice.checked && !CompleteChoice.checked)
        {
            alert("Please select a Receipt method or click on the Cancel button");
            return;
        }
        var ReceiveMethod = window.opener.document.getElementById('hdReceiveMethod');
        if (PartialChoice.checked)
            ReceiveMethod.value = "Partial";
        if (ShortChoice.checked)
            ReceiveMethod.value = "Short";
        if (CompleteChoice.checked)
            ReceiveMethod.value = "Complete";
        var ReceiveButton = window.opener.document.getElementById('btnProcessChoice');
        ReceiveButton.click();
        window.close();
    }

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="header" class="BlueBorder">
            <h1 style="padding-top: 10px; padding-left: 5px">
                Receipt Confirmation
            </h1>
        </div>
        <div>
            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>
                    <td class="Left5pxPadd bold">
                        Receive Partial?
                    </td>
                    <td>
                        <asp:RadioButton ID="rbtnPartial" GroupName="Choice" runat="server" />
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td class="Left5pxPadd bold">
                        Receive Short?
                    </td>
                    <td>
                        <asp:RadioButton ID="rbtnShort" GroupName="Choice" runat="server" />
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td class="Left5pxPadd bold">
                        Receive Complete?
                    </td>
                    <td>
                        <asp:RadioButton ID="rbtnComplete" GroupName="Choice" runat="server" />
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                    </td>
                    <td align="right">
                        <asp:ImageButton ID="ImageButton1" Style="padding-left: 5px;" runat="server" CausesValidation="false"
                            AlternateText="Submit" ImageUrl="~/Common/Images/submit.gif" OnClientClick="SetChoice();" />
                        <asp:ImageButton ID="ImageButton2" Style="padding-left: 5px;" runat="server" CausesValidation="false"
                            AlternateText="Cancel" ImageUrl="~/Common/Images/cancel.gif" OnClientClick="window.close();" />
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
