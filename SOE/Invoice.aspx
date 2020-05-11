<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Invoice.aspx.cs" Inherits="Invoice" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script>
    
      </script>
</head>
<frameset rows="*,*" border="0" id="Frame1">
    <frame name="banner" scrolling="no" noresize src="GetInvoice.aspx?InvoiceNo=<%=Request.QueryString["InvoiceNo"] %>">
    
    <frame name="Image" scrolling="no" noresize src="GetPdf.aspx">
    
</frameset>
</html>
