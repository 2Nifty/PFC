<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ExcelImport.aspx.vb" Inherits="BudgetImport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>CAS Cust PL Review</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script language="javascript">
function LoadHelp()
{
 window.open("BudgetMaintHelp.htm",'Help','height=710,width=1020,scrollbars=yes,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
   
}
    </script>
</head>
<body>
    <form id="ReviewForm" runat="server">
    <div>
        <table border=0 cellpadding=3 cellspacing=0 width=100%>
        <tr>
            <td class="PageHead" style="height: 40px" width=75%>
                <div class="LeftPadding"><div align="left" class="BannerText">CAS Customer P&L Import : Review Page</div>
                </div>
            </td>
            <td class="PageHead"  style="height: 40px" >
        <div class="LeftPadding"><div align="right" class="BannerText" >
        <img src="images/Close.gif" onclick="javascript:location.replace('ExcelBrowse.aspx');" style="cursor:hand"/></div></div></td>
        </tr>
          <tr>
                <td colspan="2" class=redtitle>
                    <asp:Label ID="OPStatus" runat="server" Text=""></asp:Label>
                    <asp:HiddenField ID="HiddenFileName" runat="server" />
                    <asp:HiddenField ID="HiddenYear" runat="server" />
                    <asp:HiddenField ID="HiddenMonth" runat="server" />
                    <asp:HiddenField ID="HiddenType" runat="server" />
                    <asp:HiddenField ID="HiddenLocation" runat="server" />
                </td>
            </tr>
          </table>
   <asp:Panel ID="ExcelInPage" runat="server" Height="500px" Width="100%" Visible="false">
         <table border=0 cellpadding=3 cellspacing=0 width=100%>
        <tr>
            <td class="BluBg" colspan="2" valign="top"><div class="LeftPadding">
                    <asp:ImageButton ID="LoadSpreadSheet" runat="server" ImageUrl="images/update.gif" />
                  </div>  
                </td>
            </tr>
         <tr>
                <td colspan="2">
     <asp:Table ID="WorkTable" runat="server" BORDER=1 CELLSPACING=0 CELLPADDING=3 Font-Size="11">
    <asp:TableHeaderRow>
    <asp:TableHeaderCell Wrap="false" HorizontalAlign="Left">Data for <%= LoadMonth %>/<%=LoadYear%> </asp:TableHeaderCell>
    <asp:TableHeaderCell Wrap="false" HorizontalAlign="Left">Value</asp:TableHeaderCell>
    <asp:TableHeaderCell Wrap="false" HorizontalAlign="Left">Mapped</asp:TableHeaderCell>
    </asp:TableHeaderRow>
    </asp:Table>
                    </td>
            </tr>
        </table>
     </asp:Panel>
   </div>
        
    </form>
</body>
</html>
