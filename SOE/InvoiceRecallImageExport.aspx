<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InvoiceRecallImageExport.aspx.cs" Inherits="InvoiceRecallImageExport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Invoice Recall Export</title>
     <link href="http://206.72.71.194/SOE/Common/StyleSheet/printstyles.css" rel="stylesheet"
        type="text/css" />

</head>
<body style="margin:2px">
    <form id="form1" runat="server">
    <div>
        <table cellpadding="2" style="border: 1px solid #BAEBF4;" cellspacing="0">
            <tr>
                <td style="padding-right: 5px; padding-left: 2px" align="left">
                    <center>
                        <strong>Invoice Recall </strong>
                    </center>
                </td>
            </tr>
            <tr>
                <td style="width: 500px;">
                    <asp:GridView ID="gvCertificates" ShowHeader="false" AllowPaging="false" runat="server"
                        AutoGenerateColumns="False">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:Image ID="imgCerts" Width="800px" Height="600px" ImageUrl='<%# DataBinder.Eval(Container,"DataItem.ImageURL")%>'
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
