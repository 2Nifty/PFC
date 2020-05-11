<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CustomerBudgetMaint.aspx.vb" Inherits="BudgetMaint" %>

<%@ Register Src="IntranetTheme/UserControls/PageHeader.ascx" TagName="PageHeader"
    TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Customer Budget Maintenance</title>
    <link href="intranettheme/stylesheet/Styles.css" rel="stylesheet" type="text/css" />
    <script language="javascript">
function LoadHelp()
{
 window.open("BudgetMaintHelp.htm",'Help','height=710,width=1020,scrollbars=yes,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
   
}
    </script>
</head>
<body>
    <form action="CustomerBudgetImport.aspx" method="post" name="testform" id="testform" runat=server>
        <table border=0 cellpadding=0 cellspacing=0 width=100%>
        <tr>
<td valign="top">
                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                </td>
</tr>
 
        <tr>
             <td class="PageHead"  style="height: 40px" >
        
                        <table width="100%"  border="0" cellspacing="0" cellpadding="3">
                        <tr>
                          <td  style="height: 40px">
                <div class="LeftPadding"><div align="left" class="BannerText">Customer Budget Load</div>
                </div>
            <%=StatMessage%></td>
                          <td ><div class="LeftPadding"><div align="right" class="BannerText" >
        <img src="images/CloseBig.gif" onclick="javascript:location.replace('ReportsDashBoard.aspx');" style="cursor:hand"/></div></div></td>
                        </tr>
                    </table>

        </td>
       </tr>
          <tr>
                <td class="LoginFormBk">
                <table width="100%"  border="0" cellspacing="0" cellpadding="3">
                        <tr>
                          <td width="16"></td>
                          <td><strong class="redtitle">Enter Month and Year for the budgets you are loading</strong></td>
                        </tr>
                    </table>
                    </td>
            </tr>
           <tr>
                <td class="LeftPadding">
                    
                      <table border="0" cellspacing="0" cellpadding="3">
                        <tr>
                          <td width="140">Select the Month of <br />the budgets you are loading.<br />
                          </td>
                          <td><asp:ListBox CssClass="ListCtrl" Width="50px" ID="BudgetMonth" runat="server" Rows="12"></asp:ListBox>
                          </td>
                          <td>/</td>
                          <td>Select the Year of 
                              <br />
                              the budgets you are loading</td>
                          <td> 
                          <asp:ListBox CssClass="ListCtrl" Width="50px" ID="BudgetYear" runat="server" Rows="12"></asp:ListBox>
                          </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="LeftPadding">
                    <table border="0" cellspacing="0" cellpadding="3">
                        <tr>
                            <td width="140"><asp:Label ID="Label1" runat="server" Text="Select a file"></asp:Label><br />
                            </td>
                            <td colspan="4">
                    <asp:FileUpload ID="FileUpload1" runat="server" Width="300" ToolTip="Upload to Budget Folder" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td  class="BluBg"><div class="LeftPadding">
                    
                 <table border="0" cellspacing="0" cellpadding="3">
                        <tr>
                          <td><strong class="redtitle">Copy File to Budget Folder and Review</strong> </td>
                          <td><strong class="redtitle"><asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="images/ok.gif" />
                          <img src="images/help.gif" onclick="LoadHelp();" style="cursor:hand"  /></strong>
                          </td>
                        </tr>
                    </table>
                </div> </td>
            </tr>
             <tr>
                <td style="height: 34px">
                  <hr /></td>
            </tr>
          <tr>
                <td class="LoginFormBk">
                <table width="100%"  border="0" cellspacing="0" cellpadding="3">
                        <tr>
                          <td width="16"></td>
                          <td><strong class="redtitle">Files in the Budget Folder : 
                    <asp:Literal ID="Literal1" runat="server" Text="<%$ appSettings:BudgetExcelFilePath%>" /> </strong></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="LeftPadding"> 
     <asp:Table ID="WorkTable" runat="server" BORDER=1 CELLSPACING=0 CELLPADDING=1 Font-Size="11">
    <asp:TableHeaderRow CssClass="GridHead">
    <asp:TableHeaderCell Wrap="false" HorizontalAlign="Left">Budget Files Ready for Review</asp:TableHeaderCell>
    <asp:TableHeaderCell Wrap="false" HorizontalAlign="Left">Date Modified</asp:TableHeaderCell>
    </asp:TableHeaderRow>
    </asp:Table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
