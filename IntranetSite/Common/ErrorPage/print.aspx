<%@ Page Language="C#" AutoEventWireup="true" CodeFile="print.aspx.cs" Inherits="InvoiceRegister_print" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
    <link href='../StyleSheet/styles.css' rel='stylesheet' type='text/css' />
</head>
<body >
    <form id="form1" runat="server">
    <div>
    <%=Session["PrintContent"].ToString() %>
    </div>
    </form>
    <script type="text/javascript">
    window.print();
    setTimeout('window.close()', 3000);
    </script>
</body>
</html>
