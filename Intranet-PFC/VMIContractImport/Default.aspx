<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>VMI Excel Import</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script language="javascript">
function LoadHelp()
{
 window.open("Help.htm",'Help','height=710,width=1020,scrollbars=yes,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
   
}
    </script>
</head>
<body>
    <form action="VMIImport.aspx" method="post" name="testform" id="testform" runat=server>
        <table border=0 cellpadding=3 cellspacing=0 width=100%>
        <tr>
            <td class="PageHead" style="height: 40px" colspan="2">
                <div class="LeftPadding"><div align="left" class="BannerText">VMI Import Contract</div>
                </div>
            <%=StatMessage%></td>
        </tr>
            <tr>
                <td class="redtitle">
                  <asp:Label ID="Label1" runat="server" Text="Select a file to copy to the Contract Folder"></asp:Label>
                    
                    </td>
            </tr>
           <tr>
                <td class="LeftPadding">
                    <asp:FileUpload ID="FileUpload1" runat="server" Width="300" ToolTip="Upload to Contract Folder" />
                   
                </td>
            </tr>
            <tr>
                <td  class="BluBg"><div class="LeftPadding">
                    <div class="redtitle">
                 Copy File to Contract Folder and Review 
                 <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="images/ok.gif" />
                 </div> </div></td>
            </tr>
             <tr>
                <td>
                  <hr /></td>
            </tr>
          <tr>
                <td class=redtitle>Files in the Contract Folder : 
                    <asp:Literal ID="Literal1" runat="server" Text="<%$ appSettings:ExcelFilePath%>" /> 
                </td>
            </tr>
            <tr>
                <td class="LeftPadding"> 
     <asp:Table ID="WorkTable" runat="server" BORDER=1 CELLSPACING=0 CELLPADDING=1 Font-Size="11">
    <asp:TableHeaderRow>
    <asp:TableHeaderCell Wrap="false" HorizontalAlign="Left">Contracts Ready for Review</asp:TableHeaderCell>
    <asp:TableHeaderCell Wrap="false" HorizontalAlign="Left">Date Modified</asp:TableHeaderCell>
    </asp:TableHeaderRow>
    </asp:Table>
                </td>
            </tr>
        <tr>
            <td valign="top" Class="BluBg"><div class="LeftPadding">
                    <img src="images/help.gif" onclick="LoadHelp();" style="cursor:hand"  /> 
                    </div> 
                       </td>
        </tr>
        </table>
    </form>
</body>
</html>
