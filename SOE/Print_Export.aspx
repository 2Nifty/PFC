<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" CodeFile="Print_Export.aspx.cs"
    Inherits="CustomerActivitySheet_Print_Export" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="Common/StyleSheet/printstyles.css" rel="stylesheet" type="text/css" />

    <script>
function CallPrint() 
{    
    var pageDiv = document.getElementById("divContents");
    var strMode='<%=Request.QueryString["Mode"].Trim() %>';
    if (strMode== "Print")
    {
        if(pageDiv.innerHTML!='')
        {
            window.print();
            window.close();
        }
    }    
} 
    </script>

</head>
<body onload="javascript:CallPrint();">
    <form id="form1" runat="server">
        <div id="divContents" runat="server" style="width: 100%;">
        </div>
    </form>
</body>
</html>
