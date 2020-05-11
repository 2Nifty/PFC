<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GetInvoicePDF.aspx.cs" Inherits="GetInvoicePDF" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Invoice</title>
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
<body onload ="javascript:OpenInvoice();">
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
