

<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="CPR_Default" %>

<%@ Register Src="Common/UserControls/WebUserControl.ascx" TagName="WebUserControl"
    TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <asp:fileupload ID="Fileupload1" runat="server"></asp:fileupload>
        <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click" />
        <br />
        <uc1:WebUserControl ID="WebUserControl1" runat="server" />
        
        
         <asp:fileupload ID="Fileupload2" runat="server" EnableViewState="true"  ></asp:fileupload>
        <asp:Button ID="Button1d" runat="server" Text="Button" OnClick="Button1d_Click" />
        
        <asp:Button ID="btn" runat="server" Text="Button" OnClientClick="javascript:document.getElementById('Fileupload2').click();return false;"  />
        <asp:TextBox ID="txt" runat=server ></asp:TextBox>
    </div>
    </form>
</body>
</html>
