<%@ Page Language="C#" AutoEventWireup="true" CodeFile="home.aspx.cs" Inherits="home" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <%--<script>
    function WindowOpen()
    {
        window.open("frame.aspx",'Order','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
        window.opener=top; 
        window.open('','_parent','');
        window.close();
    }
    </script>--%>
    
<script LANGUAGE="JavaScript">
<!--
function WindowOpen()
{
  window.open("frame.aspx?UserName=intranet&UserID=328",'Order','height=710,width=1020,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
  //window.showModelessDialog("frame.aspx",'','dialogWidth=1020px;dialogHeight=760px;status:no;help:no;minimize:yes;')
}

function fnOpenModeless()
{
  window.showModelessDialog("2.html")
}
// -->
</script>
</head>

<body onload="WindowOpen();">
    <form id="form1" runat="server" >
    <div>
        <input id="btnOpen" onclick="WindowOpen();" type="button" value="button" />&nbsp;
        
    </div>
    </form>
</body>
</html>
