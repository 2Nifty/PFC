<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PFCTools.aspx.cs" Inherits="RequestQuote_CertRequest" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Certs Request</title>
    <link href="Common/StyleSheets/Quote.css" rel="stylesheet" type="text/css" />
    <style>
    .content{background:url(common/images/contentBg.jpg) repeat-x top left;}
    .container {border:1px solid #BAEBF4;width:1000px;}
    .copy2 {border-top:4px solid #cc0000;background:#ffffff url(common/images/copyBg.jpg) repeat-x top left;padding:20px;}

    </style>    

</head>
<body>
    <form id="form1" runat="server">
        <table cellpadding="0" cellspacing="0" align="center">
            <tr>
                <td class="content">
                    <table cellpadding="0" cellspacing="0" width="970px" style="padding: 0px; margin: 0px;"
                        border="0" class="container">
                        <tr>
                            <td colspan="1" style="padding: 10px; padding-bottom: 0px;">
                                <img src="common/images/registrationBanner.gif" alt="" width="970px" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table width="100%">
                                    <tr>
                                        <td width="10%">
                                        </td>
                                        <td width="60%" height="240px" class="copy2">
                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton Style="cursor: hand;"  ImageUrl="common/images/ccross.gif"
                                                            ID="imgCCRefFile" runat="server" Height="50px" OnClick="imgCCRefFile_Click" />
                                                    </td>
                                                    <td align="right">
                                                        <asp:Button CssClass="frmBtn" ID="btnClose" OnClientClick="javascript:window.close();"
                                                            runat="server" Text="Close" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-top: 30px;">
                                                        <asp:ImageButton Style="cursor: hand;" ID="imgGetCerts" ImageUrl="common/images/getcosts.gif" runat="server" OnClick="imgGetCerts_Click"  /></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="10%">
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
</html>
