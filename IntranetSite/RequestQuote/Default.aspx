<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="RequestQuote_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Request For Quote</title>
    <script>
    
    function LoadPage()
    {
   	    var hwd = window.open("RequestQuote.aspx?BranchID="+'<%= (Request.QueryString["BranchID"]!= null ? Request.QueryString["BranchID"].ToString() : "") %>' ,'Order','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO',"");
	    window.close();
    }
    </script>
</head>
<body onload="javascript:LoadPage();">
    <form id="form1"  runat="server">
    <div>
       
    </div>
    </form>
</body>
</html>
