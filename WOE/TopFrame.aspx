<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TopFrame.aspx.cs" Inherits="TopFrame" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SOE Banner</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 0px">
    <div id="header">
        <h1 style="padding-top: 10px; padding-left: 5px">
            Work Order Entry
        </h1>
        <div id="userInfo">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td>
                        <asp:Image ID="imgHeaderLeft" runat="server" ImageUrl="~/Common/Images/userinfo_left.gif"
                            Width="11" Height="25" />
                    </td>
                    <td class="userinfobg" style="padding-right: 5px">
                        <asp:Image ID="lblDate" runat="server" ImageUrl="~/Common/Images/clock.gif"></asp:Image>
                    </td>
                    <td class="userinfobg" style="padding-left: 1px">
                        <asp:Label ID="lblUserInfo" runat="server"></asp:Label>
                    </td>
                    <td>
                        <asp:Image ID="Image1" runat="server" ImageUrl="~/Common/Images/userinfo_right.gif"
                            Width="11" Height="25" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>
