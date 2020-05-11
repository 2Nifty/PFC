<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowItems.aspx.cs" Inherits="ShowItems" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>CPR Items</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
            <asp:GridView ID="ReportItemsGrid" runat="server" BackColor="#f4fbfd" AutoGenerateColumns="false" 
             BorderWidth="0" BorderStyle="None"  AllowSorting="true" OnSorting="SortCurItems">
            <AlternatingRowStyle  CssClass="GridItem"  BackColor="#FFFFFF"/>
            <Columns>
                <asp:BoundField HeaderText="Item" DataField="Item" SortExpression="Item" ItemStyle-Wrap="false" 
                    ItemStyle-Width="100" ItemStyle-HorizontalAlign="center" HeaderStyle-Wrap="false"></asp:BoundField>
                <asp:BoundField HeaderText="Cat" DataField="Cat" SortExpression="Cat" ItemStyle-Wrap="false" 
                    ItemStyle-Width="60" ItemStyle-HorizontalAlign="center" HeaderStyle-Wrap="false"></asp:BoundField>
                <asp:BoundField HeaderText="Pt" DataField="Plate" SortExpression="Plate" ItemStyle-Wrap="false" 
                    ItemStyle-Width="20" ItemStyle-HorizontalAlign="center" HeaderStyle-Wrap="false"></asp:BoundField>
                <asp:BoundField HeaderText="Var" DataField="Var" SortExpression="Var" ItemStyle-Wrap="false" 
                    ItemStyle-Width="40" ItemStyle-HorizontalAlign="center" HeaderStyle-Wrap="false"></asp:BoundField>
             </Columns>
            </asp:GridView>
    
    </div>
    </form>
</body>
</html>
