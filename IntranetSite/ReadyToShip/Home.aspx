<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Home.aspx.cs" Inherits="ReadyToShip_Home" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript">
    function LoadPage()
    {
    
   	window.open('http://208.29.238.26/intranetsite/ReadytoShip/RTSRecommendations.aspx' ,'Order','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
	}
    </script>
</head>
<body onload="LoadPage();">
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
