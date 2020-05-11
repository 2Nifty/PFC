<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EnlargePartImage.aspx.cs" Inherits="ShowPartImage" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <script>
        function ClosePage()
        {
            window.close();	
        }
    </script>
    <title>Item Image</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 0px" bgcolor="#ECF9FB" >
    <form id="form1" runat="server">
    <div>
        <table width="900px">
            <tr>
                <td>
                 <table width="600px" style="border:1px solid #88D2E9; ">
                    <tr class="bold">
                        <td align="right"><div >Item #</div>
                        </td>
                        <td>
                            <asp:Label CssClass="lbl_whitebox" ID="ItemNoLabel" runat="server" Text="" Width="100px"
                             ></asp:Label>&nbsp;
                        </td>
                        <td align="right"><div >Description:</div>
                        </td>
                        <td>
                            <asp:Label CssClass="lbl_whitebox" ID="DescriptionLabel" runat="server" Text=" " Width="250px"
                             ></asp:Label>
                        </td>
                        <td align="right">
                        <img src="Common/Images/close.gif" style="cursor: hand" onclick="ClosePage();">&nbsp;&nbsp;
                        </td>
                    </tr>
                </table>
               </td>
            </tr>
            <tr>
                <td>
                    <asp:Panel ID="ImagePanel" runat="server" Height="250px" Width="590px" style="border:1px solid #88D2E9; background-color:#FFFFFF" >
                    <br /><br />
                    <asp:Table ID="HeadTable" runat="server">
                    <asp:TableRow>
                    <asp:TableCell HorizontalAlign="Center">
                            <asp:Image ID="HeadImage" runat="server" Height="75px"/>
                    </asp:TableCell>
                    <asp:TableCell>
                            <asp:Image ID="BodyImage" runat="server" Height="75px"/>
                    </asp:TableCell>
                    </asp:TableRow>
                    </asp:Table>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>&nbsp;
                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
