<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Frame.aspx.cs" Inherits="Frame" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server"  >
    <title id="pageCaption" runat="server">Work Order Entry</title>
</head>
<script type="text/javascript">

function CloseWindow()
{ 
 window.open("Release.aspx",'Release','height=5,width=5,scrollbars=no,location=no,status=no,top=0,left=0,resizable=no',"");
}
function OpenOrderTypeUpdate()
{

    var orderType=window.open ("PendingOrderSubType.aspx?FormClose=True" ,"PendingOrderSubType",'height=230,width=380,scrollbars=no,status=no,top='+((screen.height/2) - (230/2))+',left='+((screen.width/2) - (380/2))+',resizable=NO',"");
    orderType.focus();
  
}
</script>
<frameset rows="40,*" border="0" id="Frame1">
    <frame name="banner" scrolling="no" noresize src="TopFrame.aspx">
    <frameset cols="25,*" border="0" name="soeFrame">
        <frame name="menuFrame" src="LeftMenu.aspx" scrolling="no" noresize  />
        <frame id="bodyFrame" name="bodyFrame" src="WorkOrderEntry.aspx?UserID=<%=Request.QueryString["UserID"] %>&UserName=<%=Request.QueryString["UserName"] %>">          
    </frameset>
</frameset>

</html>
