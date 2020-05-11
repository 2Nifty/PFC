<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ExcelBrowse.aspx.vb" Inherits="BudgetMaint" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>CAS Excel Import</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script language="javascript">
function LoadHelp()
{
 window.open("Help.htm",'Help','height=710,width=1020,scrollbars=yes,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
   
}
    </script>
</head>
<body>
    <form action="ExcelImport.aspx" method="post" name="testform" id="testform" runat=server>
        <table border=0 cellpadding=3 cellspacing=0 width=100%>
        <tr>
             <td class="PageHead"  style="height: 40px" >
        
                        <table width="100%"  border="0" cellspacing="0" cellpadding="3">
                        <tr>
                          <td class="PageHead" style="height: 40px">
                <div class="LeftPadding"><div align="left" class="BannerText">CAS Excel Import</div>
                </div>
            <%=StatMessage%></td>
                          <td class="PageHead"><div class="LeftPadding"><div align="right" class="BannerText" >
        </div></div></td>
                        </tr>
                    </table>

        </td>
       </tr>
          <tr>
                <td class="LoginFormBk">
                <table width="100%"  border="0" cellspacing="0" cellpadding="3">
                        <tr>
                          <td width="16"><img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                          <td><strong class="redtitle2">Enter Month and Year you are loading</strong></td>
                        </tr>
                    </table>
                    </td>
            </tr>
           <tr>
                <td class="LeftPadding">
                    
                      <table border="0" cellspacing="0" cellpadding="3">
                        <tr>
                          <td>Select the Month <br />you are loading.<br />
                          </td>
                          <td><asp:ListBox ID="LoadMonth" runat="server" Rows="12"></asp:ListBox>
                          </td>
                          <td>/</td>
                          <td>Select the Year 
                              <br />
                              you are loading</td>
                          <td> 
                          <asp:ListBox ID="LoadYear" runat="server" Rows="12"></asp:ListBox>
                          </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="LoginFormBk">
                <table width="100%"  border="0" cellspacing="0" cellpadding="3">
                        <tr>
                          <td width="16"><img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                          <td><strong class="redtitle2"><asp:Label ID="Label1" runat="server" Text="Select a file"></asp:Label></strong></td>
                        </tr>
                    </table>
                    </td>
            </tr>
           <tr>
                <td class="LeftPadding">
                    <asp:FileUpload ID="FileUpload1" runat="server" Width="300" ToolTip="Upload to Budget Folder" />
                </td>
            </tr>
            <tr>
                <td  class="BluBg"><div class="LeftPadding">
                    
                 <table border="0" cellspacing="0" cellpadding="3">
                        <tr>
                          <td><strong class="redtitle2">Copy File to Folder and Review</strong> </td>
                          <td><strong class="redtitle2"><asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="images/ok.gif" />
                          <img src="images/help.gif" onclick="LoadHelp();" style="cursor:hand"  />
                          </td>
                        </tr>
                    </table>
                </div> </td>
            </tr>
             <tr>
                <td>
                  <hr /></td>
            </tr>
          <tr>
                <td class="LoginFormBk">
                <table width="100%"  border="0" cellspacing="0" cellpadding="3">
                        <tr>
                          <td width="16"><img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                          <td><strong class="redtitle2">Files in the Folder : 
                    <asp:Literal ID="Literal1" runat="server" Text="<%$ appSettings:ExcelFilePath%>" /> </strong></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="LeftPadding"> 
     <asp:Table ID="WorkTable" runat="server" BORDER=1 CELLSPACING=0 CELLPADDING=1 Font-Size="11">
    <asp:TableHeaderRow>
    <asp:TableHeaderCell Wrap="false" HorizontalAlign="Left">Files Ready for Review</asp:TableHeaderCell>
    <asp:TableHeaderCell Wrap="false" HorizontalAlign="Left">Date Modified</asp:TableHeaderCell>
    </asp:TableHeaderRow>
    </asp:Table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
