<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Update.aspx.vb" Inherits="Update" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>RB Pipe Update</title>
<link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
                <table cellspacing=0 width=100% cellpadding="2">
                   <tr>
                        <td class="PageHead" style="height: 40px" width=75%>
                            <div class="LeftPadding"><div align="left" class="BannerText">The RB Pipe Update Log</div>
                            </div>
                        </td>
                        <td class="PageHead"  style="height: 40px" >
            <div class="LeftPadding"><div align="right" class="BannerText" >
                <asp:ImageButton ID="CloseButt" runat="server"  ImageUrl="images/close.gif"/>
                </div></div></td>
                    </tr>
         </table>
    <asp:Table ID="WorkTable" runat="server" WIDTH=100% BORDER=1 CELLSPACING=0 CELLPADDING=0 Font-Size="11">
    <asp:TableHeaderRow>
    <asp:TableHeaderCell width="120">Shipper</asp:TableHeaderCell>
    <asp:TableHeaderCell HorizontalAlign="Left" >Result</asp:TableHeaderCell>
    </asp:TableHeaderRow>
    </asp:Table>
    
    </div>
    </form>
</body>
</html>
