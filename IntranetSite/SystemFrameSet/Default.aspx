<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<script language="javascript">
function getUser()
{
 
  alert(Request.ServerVariables('LOGON_USER'));
   
}
</script>

<body >
    <form id="form1" runat="server" >
    <div>
    <input type="hidden" id="UserId" runat="server"  /> 
    </div>
    </form>
</body>
</html>
