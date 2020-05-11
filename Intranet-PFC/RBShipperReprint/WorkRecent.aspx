<%@ Page Language="VB" AutoEventWireup="false" CodeFile="WorkRecent.aspx.vb" Inherits="WorkRecent" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>RB Pipe Shippers</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <asp:SqlDataSource ID="TunnelData" runat="server" ConnectionString="<%$ ConnectionStrings:TheRBPipeConnectionString %>" 
    SelectCommand="SELECT   TimeInTunnel AS Dur, ThePipeOut, ThePipeStepCtr, No_ AS Shipper, [Location Code] AS Branch, [Location Name 2] AS BrName FROM TimeInTunnel" UpdateCommand="UPDATE ThePipeSalesHeader SET ThePipeStepCtr = 200000 WHERE (No_ = @PARAM1)">
        <UpdateParameters>
            <asp:FormParameter FormField="gridview1" Name="PARAM1" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="BranchData" runat="server" ConnectionString="<%$ ConnectionStrings:TheRBPipeConnectionString %>" 
    SelectCommand="SELECT  [pLoc_ID] + ' - ' + Loc_Name AS BranchText, pLoc_ID as BranchValue FROM Loc_Pref"></asp:SqlDataSource>
    <form id="form1" runat="server" method=post action="Update.aspx">
    <asp:Table ID="PageTable" runat="server" BORDER=1 CELLSPACING=0 CELLPADDING=0 Font-Size="11" Width="100%">
    <asp:TableRow>
    <asp:TableCell CssClass=PageHead><div class="LeftPadding">
        <div align="left" class="BannerText">RB Pipe Shippers</div>
    </div></asp:TableCell>
    <asp:TableCell cssclass="PageHead"  style="height: 40px" >
            <div class="LeftPadding"><div align="right" class="BannerText" >
             <img src="images/close.gif" onclick="javascript:location.replace('Default.aspx');" style="cursor:hand"/></div></div>
             </asp:TableCell>
    </asp:TableRow>
    <asp:TableRow>
     <asp:TableCell VerticalAlign=top>
     <br />
     &nbsp;
     <br />
     <asp:ImageButton ID="UpdCostButton" runat="server"  ImageUrl="images/update.gif" PostBackUrl="update.aspx" />
     <asp:HiddenField ID="BackTo" runat="server"  Value="WorkRecent.aspx"/>
     <br />
     Status:&nbsp;<asp:Label ID="StatusText" runat="server" Text="" ForeColor="Red"></asp:Label>
     <br />
         <asp:DropDownList ID="BranchFilter" runat="server" DataSourceID="BranchData" DataTextField="BranchText" DataValueField="BranchValue" AutoPostBack="true">
         </asp:DropDownList>
     </asp:TableCell>
     <asp:TableCell>
     <asp:Panel ID="WorkPanel" runat="server" Height="400px" Width="720px" ScrollBars="Both">
     <asp:Table ID="WorkTable" runat="server" BORDER=1 CELLSPACING=0 CELLPADDING=0 Font-Size="11">
     <asp:TableRow>
     <asp:TableCell HorizontalAlign=center>Shipper</asp:TableCell>
     <asp:TableCell HorizontalAlign=center>Branch</asp:TableCell>
     <asp:TableCell HorizontalAlign=center>Stepctr</asp:TableCell>
     <asp:TableCell HorizontalAlign=center>IN</asp:TableCell>
     <asp:TableCell HorizontalAlign=center>OUT</asp:TableCell>
     <asp:TableCell HorizontalAlign=center>Name</asp:TableCell>
     <asp:TableCell HorizontalAlign=center>Print</asp:TableCell>
     <asp:TableCell HorizontalAlign=center>Pick</asp:TableCell>
     </asp:TableRow>
     </asp:Table>
     </asp:Panel>
     
     </asp:TableCell>
     </asp:TableRow>
    </asp:Table>
    </form>
</body>
</html>
