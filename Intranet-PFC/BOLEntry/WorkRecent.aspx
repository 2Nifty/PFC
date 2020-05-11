<%@ Page Language="VB" AutoEventWireup="false" CodeFile="WorkRecent.aspx.vb" Inherits="WorkRecent" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Existing Bill of Lading</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <asp:SqlDataSource ID="TunnelData" runat="server" ConnectionString="<%$ ConnectionStrings:BOLEntryConnectionString %>" 
    SelectCommand="SELECT   BillofLadingNo AS [BOL No], EntryDt AS [BOL Dt], ToAllocWght AS [Alloc By Weight], ToAllocAmt AS [Alloc By Amt], TotBOLAmt AS [Total BOL Amt], TotBOLWght AS [Total BOL Wght] FROM AvgCstPORecExpenses ORDER BY EntryDt DESC,BillofLadingNo" >
    </asp:SqlDataSource>
    <form id="form1" runat="server" method="post">
    <asp:Table ID="PageTable" runat="server"  CELLSPACING="0" CELLPADDING="0" Font-Size="11" Width="100%">
    <asp:TableRow>
    <asp:TableCell CssClass="PageHead"><div class="LeftPadding">
        <div class="BannerText">Bills of Lading</div>
    </div></asp:TableCell>
    <asp:TableCell cssclass="PageHead"  style="height: 40px" >
            <div class="LeftPadding"><div align="Center" class="BannerText" >
             <img src="images/close.gif" alt = "" onclick="javascript:location.replace('Default.aspx');" style="cursor:hand"/></div></div>
             </asp:TableCell>
    </asp:TableRow>
    <asp:TableRow>
     <asp:TableCell>
     <asp:Panel ID="WorkPanel" runat="server" Height="400px" Width="720px" ScrollBars="Vertical">
     <asp:Table ID="WorkTable" runat="server"  CELLSPACING="0" CELLPADDING="0" Font-Size="11">
     <asp:TableRow>
     <asp:TableCell HorizontalAlign="center">[Bol No]</asp:TableCell>
     <asp:TableCell HorizontalAlign="center">[BOL Date]</asp:TableCell>
     <asp:TableCell HorizontalAlign="center">[Alloc By Wght]</asp:TableCell>
     <asp:TableCell HorizontalAlign="center">[Alloc By Amt]</asp:TableCell>
     <asp:TableCell HorizontalAlign="center">[Total BOL Wght]</asp:TableCell>
     <asp:TableCell HorizontalAlign="center">[Total BOL Amt]</asp:TableCell>
     </asp:TableRow>
     </asp:Table>
     </asp:Panel>
     
     </asp:TableCell>
     </asp:TableRow>
    </asp:Table>
    </form>
</body>
</html>
