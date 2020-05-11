<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Excel.aspx.vb" Inherits="Excel" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>AD Excel Page</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet"  type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
         <table width="100%" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="middle" class="PageHead" colspan="2">
                       <span class="Left5pxPadd">
                       <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Auto Distribution Excel Files"></asp:Label>
                       </span>
                </td>
            </tr>
            <tr class="PageBg"><td align="right" >
            <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="Images/Close.gif" 
                                PostBackUrl="javascript:window.close();"  CausesValidation="false"/></td></tr>
            <tr><td>
            <br />
                <table cellspacing="0">
                    <tr  >
                        <td class="Left5pxPadd">
                        Show Results in Excel
                        </td>
                        <td class="Left5pxPadd" >
                        <asp:ImageButton ID="ResultsButt" runat="server" ImageUrl="Images/ok.gif"  />
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr  >
                        <td class="Left5pxPadd" >
                        Show Hungry in Excel
                        </td>
                        <td class="Left5pxPadd" >
                        <asp:ImageButton ID="HungerButt" runat="server" ImageUrl="Images/ok.gif"   />
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr><td colspan="2" class="Left5pxPadd"><br />
                    Press "Back" on the Browser to return to this menu.
                    </td></tr>
                </table>
    </td></tr></table>
    </div>
    </form>
</body>
</html>
