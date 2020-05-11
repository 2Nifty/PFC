<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default.aspx.cs" Inherits="_Default" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <br />
        <br />
        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
        <asp:Button ID="btnAddNewRow" runat="server" OnClick="btnAddNewRow_Click" Style="z-index: 100;
            left: 66px; position: absolute; top: 287px" Text="Add New Row" Width="145px" />
        <asp:Panel ID="Panel1" runat="server" Height="50px" Style="z-index: 102; left: 73px;
            position: absolute; top: 8px" Width="125px">
        </asp:Panel>
    </div>
    </form>
</body>
</html>