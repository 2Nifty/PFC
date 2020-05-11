<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CrossRefBuilder.aspx.cs"
    Inherits="CrossRefBuilder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cross Reference Builder</title>
    <link href="Common/StyleSheets/CrossRefStyles.css" rel="stylesheet" type="text/css">    
</head>
<body bgcolor="#ECF9FB">
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" id="table1">
            <tr>
                <td class="BorderAll" valign="top" style="height: 445px">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" id="table2">
                        <tr>
                            <td align="center">
                                <asp:Label ID="Label1" runat="server" CssClass="Banner" Text="Creating your Cross-Reference File"
                                    Font-Bold="True" Font-Italic="False"></asp:Label>
                            </td>
                        </tr>
                        <tr valign="top">
                            <td class="BlueBorder" style="width: 100%; padding-top: 10px;">
                                <table align="center">
                                    <tr>
                                        <td valign="top" width="373px" style="padding-top: 33px; background-image: url(Common/Images/bar1.gif);
                                            height: 264px;">
                                            <table width="100%">
                                                <tr>
                                                    <td align="center">
                                                        <asp:Label CssClass="Banner" ID="lbl" runat="server" Text="Item Builder" Font-Bold="True"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 130px;">
                                                        <asp:ImageButton ID="ibtnitem1" runat="server" ImageUrl="Common/Images/clickhere.jpg"
                                                            OnClick="ibtnitem1_Click" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 40px;">
                                                        <p style="line-height: 20px;">
                                                            <strong>Creating your own cross-reference file through the
                                                                <br />
                                                                use of Item Builder.</strong>
                                                        </p>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 40px; padding-top: 10px;">
                                                        <strong>Apply the following steps</strong></td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 48px; padding-top: 5px;">
                                                        <font style="font-weight: bold;">
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        1. Select an item from the left menu</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        2. Select a product line</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        3. Select a plating and/or package option</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        4. Select "Get Results"</td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="height: 16px">
                                                                        5. You are now ready to build your Cross-Reference File</td>
                                                                </tr>
                                                            </table>
                                                        </font>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td valign="top" width="373px" style="padding-top: 33px; background-image: url(Common/Images/bar1.gif);
                                            height: 264px;">
                                            <table width="100%">
                                                <tr>
                                                    <td align="center">
                                                        <asp:Label CssClass="Banner" ID="Label2" runat="server" Text="Import from File" Font-Bold="True"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 130px;">
                                                        <asp:ImageButton ID="btnItem2" runat="server" ImageUrl="Common/Images/clickhere.jpg"
                                                            OnClick="ibtnitem2_Click" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 40px;">
                                                        <p style="line-height: 20px;">
                                                            <strong>Create cross-reference file through upload from file </strong>
                                                        </p>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 40px; padding-top: 10px;">
                                                        <strong></strong>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 48px; padding-top: 5px;">
                                                        <font style="font-weight: bold;"></font>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>

<script>
if(window.opener !=null)
    window.opener.close(); 
</script>

</html>
