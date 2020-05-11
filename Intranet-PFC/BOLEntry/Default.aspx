<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>BOL Charge Entry</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
   <script type="text/javascript">
    function LoadHelp()
    {
     window.open("Help.htm",'Help','height=710,width=1020,scrollbars=yes,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
       
    }  
    </script>
    <script type="text/javascript" src="date.js"></script>


</head>
<body>
    <asp:SqlDataSource ID="SqlHeaderlData" runat="server" ConnectionString="<%$ ConnectionStrings:BOLEntryConnectionString %>">
   </asp:SqlDataSource>
    <form id="form1" runat="server">
    <div>
       <table cellspacing="0" cellpadding="2" width="100%">
       <tr>
            <td class="PageHead" style="height: 40px" colspan="2">
                <div class="LeftPadding"><div  class="BannerText">BOL Charge Entry</div>
                </div>
            </td>
        </tr>
        </table>  <br />
        <asp:Panel ID="SearchPanel" runat="server">
        <table cellspacing="0" cellpadding="2" width="100%">
       <tr><td class="LeftPadding">BOL Number:</td>
        <td>
            <asp:TextBox ID="BOLNumber" runat="server"></asp:TextBox></td></tr>
       <tr><td class="LeftPadding">BOL Date mm[/]dd[/][yy]yy:</td>
        <td>
            <asp:TextBox ID="BOLDate" runat="server"  onblur="ValidateDate(this.value,this.id);" /></td></tr>
       <tr><td class="LeftPadding">Spread By Weight:</td>
        <td>
            <asp:TextBox ID="WghtAmt" runat="server"></asp:TextBox></td></tr>
       <tr><td class="LeftPadding">Spread By Amt:</td>
        <td>
            <asp:TextBox ID="AmtAmt" runat="server"></asp:TextBox></td></tr>

        <tr><td class="LeftPadding" colspan="2"><div  class="BannerText">
            <asp:Label ID="OpStatus" runat="server" Text=""></asp:Label></div>
        </td></tr>
        <tr>
        <td class="BluBg" colspan="2">'
            <div class="LeftPadding">
            <img src="images/help.gif" alt = "" onclick="LoadHelp();" style="cursor:hand"  /> 
            <asp:ImageButton ID="OK_BOL" runat="server" ImageUrl="images/ok.gif" />
            <asp:ImageButton ID="Del_BOL" runat="server" ImageUrl="images/BtnDelete.gif" />
            <asp:ImageButton ID="List_BOL" runat="server" ImageUrl="images/list.gif" PostBackUrl="WorkRecent.aspx" />
            </div></td></tr>
        <tr>
        <td colspan="2">
            &nbsp;
            </td></tr>
        </table>  <br />  </asp:Panel>
       <asp:Panel ID="BOLDetail" runat="server" Height="400px" ScrollBars="Both">
        <table cellspacing="0" cellpadding="2" width="500">
          <tr>
               <td ><asp:DetailsView ID="HeaderView" runat="server" Height="50px" DataSourceID="SqlHeaderlData" AllowPaging="true" Width="210px">
                   </asp:DetailsView></td>
          </tr>
         </table>    
      </asp:Panel>
    </div>
    </form>
</body>
</html>
