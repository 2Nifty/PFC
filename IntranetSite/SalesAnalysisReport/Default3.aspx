<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default3.aspx.cs" Inherits="SalesAnalysisReport_Default3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
<!-- #Include virtual="../common/include/ScriptX.inc" -->
    <title>Untitled Page</title>
    <script src="../Common/JavaScript/ScriptX.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
                    <script type="text/javascript">
//alert('Portrait');
                        //Portrait with 1/4 inch margins
                        SetPrintSettings(true, 0.25, 0.25, 0.25, 0.25);
                    </script>
    <div>
    Portrait
    </div>
    </form>
</body>
</html>
