<%@ Page Language="C#" AutoEventWireup="true"  EnableEventValidation="false"  CodeFile="WIPOverReceiptChoice.aspx.cs" Inherits="WIPOverReceiptChoice" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Receipt Choice</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
        function pageUnload() 
        {
            //if (window.opener != null) 
            //{
            //    var txtQtyToRec = window.opener.document.getElementById('txtQtyToRec');
            //    txtQtyToRec.focus();
            //}
        }
        function ClosePage()
        {
            window.close();	
        }

        function SetChoice() 
        {
            var ReceiveButton = window.opener.document.getElementById('btnProcessWipOverRcpt');
            ReceiveButton.click();
            window.close();
        }

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="header" class="BlueBorder">
            <h1 style="padding-top: 10px; padding-left: 5px">
                WIP Over Receipt Confirmation
            </h1>
        </div>
        <div>
            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>
                    <td class="Left5pxPadd bold" colspan="2">
                        You are receiving a Mfg Qty that is greater than the Qty Picked.
                    </td>
                </tr>
                <tr>
                    <td class="Left5pxPadd bold">
                        Total Receipt Qty
                    </td>
                    <td>
                        <asp:Label ID="lblTotalRecQty" runat="server" Text="Label"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="Left5pxPadd bold">
                        WIP Qty
                    </td>
                    <td>
                        <asp:Label ID="lblWIPQty" runat="server" Text="Label"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td align="right" colspan="2">
                        <asp:ImageButton ID="ImageButton1" Style="padding-left: 5px;" runat="server" CausesValidation="false"
                            AlternateText="OK" ImageUrl="~/Common/Images/submit.gif" OnClientClick="SetChoice();" />
                        <asp:ImageButton ID="ImageButton2" Style="padding-left: 5px;" runat="server" CausesValidation="false"
                            AlternateText="Cancel" ImageUrl="~/Common/Images/cancel.gif" OnClientClick="ClosePage();" />
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
