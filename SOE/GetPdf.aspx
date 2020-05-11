<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GetPdf.aspx.cs" Inherits="GetPdf" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
<script>
    function OpenInvoice()
    {
    alert('invoice');
    //alert(value);
     //var url="http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232c4%3BNoUI%3D1%3BF0%3D62570";
     var _session = '<%= Session["FileName"].ToString() %>';
       alert(_session)
    var url="http://10.1.36.34/WebOe/InvoiceFile/"+_session;
    alert(url);
     var popup= window.open(url,"Invoice",'height=400,width=650,scrollbars=no,status=no,top='+((screen.height/2) - (400/2))+',left='+((screen.width/2) - (650/2))+',resizable=NO',"");
      popup.focus(); 
    }
    </script>
</head>
<body >
    <form id="form1" runat="server">
    <div>
    <a href ="#" onclick="Javascript:OpenInvoice();"> Invoice</a>
    
    </div>
    </form>
</body>
</html>
