<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Purchase Order Entry</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
    
    function LoadPage()
    {
   	    var hwd = window.open("http://pfcwebapp2/POE/frame.aspx?UserID="+'<%= Session["UserID"].ToString().Trim() %>&UserName=<%= Session["UserName"].ToString().Trim() %>' ,'POE','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO',"");	    
	    window.close();
    }
    </script>

</head>
<body onload="javascript:LoadPage();">
    <form id="form1" runat="server">
    </form>
</body>
</html>
