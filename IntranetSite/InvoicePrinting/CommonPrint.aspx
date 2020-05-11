<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CommonPrint.aspx.cs" Inherits="CommonPrint" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body onload="javascript:PrintPage();">
    <form id="form1" runat="server">
    <div runat=server id="divContent">
    
    </div>
    </form>
    <script type="text/javascript">
    function PrintPage()
    {
    window.focus();
    window.print();
    window.close();
    }
    </script>
</body>
</html>
