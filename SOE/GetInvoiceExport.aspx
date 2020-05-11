<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GetInvoiceExport.aspx.cs" Inherits="GetInvoicePDF" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Invoice</title>
    <link href="http://206.72.71.194/SOE/Common/StyleSheet/printstyles.css" rel="stylesheet"
        type="text/css" />

    <script>
    function OpenInvoice()
    {
        var Invoice='<%=Request.QueryString["Invoice"] %>';
        alert(Invoice);
        var url="http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232c4%3BNoUI%3D1%3BF0%3D"+Invoice;
        var popup= window.open(url,"Invoice",'height=400,width=650,scrollbars=no,status=no,top='+((screen.height/2) - (400/2))+',left='+((screen.width/2) - (650/2))+',resizable=NO',"");
        popop.focus();
    }
    </script>

</head>
<body style="margin:2px" onload="window.print();window.close();">
    <form id="form1" runat="server">
        <div>
            <table cellpadding="2" style="border: 1px solid #BAEBF4;" cellspacing="0">
                <tr>
                    <td width="500px">
                        <table cellpadding="3" cellspacing="3">
                            <tr>
                                <td style="width: 60px; padding-right: 5px; padding-left: 2px" align="left">
                                    <strong>Invoice No: </strong>
                                </td>
                                <td style="padding-right: 3px; padding-left: 2px">
                                    <asp:Label ID="txtInvoiceNumber" runat="server" Font-Bold="false"></asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="width: 500px;" >
                        <asp:GridView ID="gvCertificates" ShowHeader="false" AllowPaging="false" runat="server"
                            AutoGenerateColumns="False">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:Image ID="imgCerts" Width="800px" Height="500px" ImageUrl='<%# DataBinder.Eval(Container,"DataItem.ImageURL")%>'
                                            runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <PagerSettings Visible="False" />
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                <td>
                 <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
