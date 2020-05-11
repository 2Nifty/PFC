<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="ReadyToShip_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script>
    function NewScreen()
    {
        var winOpen=window.open('','RTSShipSummary','height=710,width=1020,titlebar=no,scrollbars=no,directories=no,location=no,statusbar=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO','');
        winOpen.focus();
        
    }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
            <input type=button name="Submit" id=submit value="Submit" onclick="NewScreen()" />
        </div>
    </form>
</body>
</html>
