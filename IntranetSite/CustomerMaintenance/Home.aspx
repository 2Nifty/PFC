<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Home.aspx.cs" Inherits="ReadyToShip_Home" %>

<%@ Register Src="Common/UserControls/Contacts.ascx" TagName="Contacts" TagPrefix="uc2" %>

<%@ Register Src="Common/UserControls/CustomerLocations.ascx" TagName="CustomerLocations"
    TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript">
    function LoadPage()
    {
    //document.location.href=window.opener.location.href;

   //	 window.open('http://localhost/Intranetsite/VendorMaintenance/VendorMaintenance.aspx' ,'Orders','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
   	 	//window.open('http://localhost/Intranetsite/VendorMaintenance/VendorMaintenance.aspx' ,'Orders','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
	}
    </script>
</head>
<body  >
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
    <div>
        <uc2:Contacts ID="Contacts1" runat="server" />
       
    </div>
    </form>
</body>
</html>
