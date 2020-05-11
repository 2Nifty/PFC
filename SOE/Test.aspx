<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test.aspx.cs" Inherits="Test" %>




<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
  <script>
  function open()
  {
  var url="http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232c4%3BNoUI%3D1%3BF0%3D62570";

  window.open(url,"Invoice",'height=750,width=600,scrollbars=no,status=no,top='+((screen.height/2) - (650/2))+',left='+((screen.width/2) - (800/2))+',resizable=NO',"");
    
  }
  </script>
 
</head>
<body>
    <form id="form1" runat="server">
       
    
        
        <asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" />
        <asp:Label ID="lblResult" runat="server" Text=""></asp:Label>
        &nbsp;
        <br />
        
        
    </form>
    
</body>
</html>
