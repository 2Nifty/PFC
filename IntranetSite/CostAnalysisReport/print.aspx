<%@ Page Language="C#" AutoEventWireup="true" CodeFile="print.aspx.cs" Inherits="InvoiceRegister_print" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Printing Report</title>
    <link href='common/StyleSheet/styles.css' rel='stylesheet' type='text/css' />
</head>
<body >
    <form id="form1" runat="server">
    <div>
    <%=Session["PrintContent"].ToString() %>
    </div>
    </form>
    <script type="text/javascript">
    window.print();                       //Comment out if I want to test print...Copy Properties into a browser to view print priview
    setTimeout('window.close()', 3000);    //Comment out if I want to test print...Copy Properties into a browser to view print priview
    </script>
</body>
</html>
