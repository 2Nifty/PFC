<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>RB Reprint Shipper</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script language="javascript">
function LoadHelp()
{
 window.open("Help.htm",'Help','height=710,width=1020,scrollbars=yes,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
   
}
function CheckAll(Type)
{
for (var i = 1; i<form1.elements.length; i++) {
    var el = form1.elements[i];
    if (el.name.substring(0,2) == "Do") {
        var rd = document.getElementsByName(el.name);
        if (Type == "Reprint") rd[0].checked = true;
        if (Type == "Repick") rd[1].checked = true;
        }
    }   
}
    </script>
</head>
<body>
    <asp:SqlDataSource ID="SqlHeaderlData" runat="server" ConnectionString="<%$ ConnectionStrings:TheRBPipeConnectionString %>" 
    SelectCommand="SELECT  No_ AS Shipper, ThePipeStepCtr, ThePipeIn, ThePipeOut, [Ship-to Name], [Ship-to City], [Posting Date], [Location Code] FROM [ThePipeSalesHeader]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlBranchData" runat="server" ConnectionString="<%$ ConnectionStrings:TheRBPipeConnectionString %>" 
    SelectCommand="SELECT pLoc_ID as BranchValue, pLoc_ID + ' - ' + Loc_Name as BranchText FROM Loc_Pref">
    </asp:SqlDataSource>
    <form id="form1" runat="server">
    <div>
       <table cellspacing=0 cellpadding="2" width="100%">
       <tr>
            <td class="PageHead" style="height: 40px" colspan="2">
                <div class="LeftPadding"><div align="left" class="BannerText">Radio Beacon Shipper Reprint/Repick</div>
                </div>
            </td>
        </tr>
        </table>  
        <asp:Panel ID="SearchPanel" runat="server">
        <table cellspacing="0" cellpadding="2" >
       <tr><td class="LeftPadding">Branch:</td>
        <td>
            <asp:DropDownList ID="BranchFilterDropDownList" runat="server" DataSourceID="SqlBranchData" DataTextField="BranchText" 
            DataValueField="BranchValue">
            </asp:DropDownList>
        </td><td>
           <asp:RadioButton ID="ShippingBranch" runat="server" GroupName="BranchType" Checked="true" 
           ToolTip="Use this option to filter by the branch that is SHIPPING THE ORDER" />Shipping 
           <asp:RadioButton ID="OrderBranch" runat="server"  GroupName="BranchType" 
           ToolTip="Use this option to filter by the branch that PLACED THE ORDER" />Order
        </td></tr>
            
       <tr><td class="LeftPadding">Sales/Transfer Order Range:</td>
        <td>
            <asp:TextBox ID="BegShipperToProcess" runat="server"></asp:TextBox>  
            </td><td><asp:TextBox ID="EndShipperToProcess" runat="server"></asp:TextBox>
        </td></tr>
       <tr><td class="LeftPadding" valign="top">Date Range:
       <hr />You can select by either<br /> the date the shipper went <br />through The RB Pipe <br />or the Order Date<br />
           <asp:RadioButton ID="PipeDate" runat="server" GroupName="ShipperDate" Checked="true" />Pipe Date <br />
           <asp:RadioButton ID="OrderDate" runat="server"  GroupName="ShipperDate" />Order Date 
           
       </td>
        <td>Start<br />
            <asp:Calendar ID="BegDate" runat="server" CssClass="BluBg"></asp:Calendar>
            </td><td>End<br /><asp:Calendar ID="EndDate" runat="server" CssClass="BluBg"></asp:Calendar>
        </td></tr>
        </table> 
        <table cellspacing=0 cellpadding="2" width="100%">
        <tr><td class="LeftPadding" colspan="3"><div align="left" class="BannerText">
            <asp:Label ID="OpStatus" runat="server" Text=""></asp:Label></div>
        </td></tr>
        <tr>
        <td class="BluBg" colspan="3">
            <div class="LeftPadding">
            <img src="images/help.gif" onclick="LoadHelp();" style="cursor:hand"  /> 
            <asp:ImageButton ID="Reprint" runat="server" ImageUrl="images/ok.gif" /></div></td></tr>
        <tr>
        <td colspan="3">
            &nbsp;
            </td></tr>       
            <tr>
        <td class="BluBg" colspan="3">
            <div class="LeftPadding"><div class="BannerText"> View Most Recent entries
           <asp:ImageButton ID="RecentButton" runat="server" ImageUrl="images/ok.gif" PostBackUrl="WorkRecent.aspx" /></div></div></td></tr>
        </table>  <br />  
        </asp:Panel>
       <asp:Panel ID="ShipperDetail" runat="server" Height="400px" ScrollBars="Both">
        <table cellspacing=0 cellpadding="2" width="500">
          <tr>
               <td ><asp:DetailsView ID="HeaderView" runat="server" Height="50px" DataSourceID="SqlHeaderlData" AllowPaging="true" Width="310px">
                   </asp:DetailsView></td>
          </tr>
          <tr>
            <td>
            <table cellspacing="0" cellpadding="0" width="100%">
                <tr class="BluBg">
                    <td class="LeftPadding">Cancel&nbsp;&nbsp;
                    </td>
                    <td><asp:ImageButton ID="Cancel" runat="server" ImageUrl="images/ok.gif" />
                    </td>
                    <td class="LeftPadding">Reprint (No Pick Change)&nbsp;&nbsp;
                    </td>
                    <td><asp:ImageButton ID="ReprintOnly" runat="server" ImageUrl="images/ok.gif" />
                    <asp:HiddenField ID="HiddenShipper" runat="server" />
                    </td>
                    <td class="LeftPadding">Reprint and Repick (If possible, Shipper printed)&nbsp;&nbsp;
                    </td>
                    <td><asp:ImageButton ID="ReprintRepick" runat="server" ImageUrl="images/ok.gif" />
                    </td>
                </tr>
            </table>
            </td>
         </tr>
         </table>    
      </asp:Panel>
        <asp:Panel ID="ShipperHeaderPanel" runat="server" Height="45px" Width="100%">
            <table cellpadding="0" cellspacing="0" width="100%">
                <tr class="BluBg">
                    <td class="LeftPadding" align="right">Cancel&nbsp;&nbsp;
                    </td>
                    <td align="left"><asp:ImageButton ID="GridCancelButton" runat="server" ImageUrl="images/ok.gif" />
                    </td>
                    <td class="LeftPadding" align="right">Check All Reprint Flags&nbsp;&nbsp;
                    </td>
                    <td align="left">
                        <img src="images/ok.gif" onclick="CheckAll('Reprint');" style="cursor:hand" />
                    </td>
                    <td class="LeftPadding" align="right">Check All Repick Flags&nbsp;&nbsp;
                    </td>
                    <td align="left">
                        <img src="images/ok.gif" onclick="CheckAll('Repick');" style="cursor:hand" />
                    </td>
                    <td class="LeftPadding" align="right">Process Selected Shippers&nbsp;&nbsp;
                    </td>
                    <td align="left">
                      <asp:ImageButton ID="UpdButton" runat="server"  ImageUrl="images/update.gif" PostBackUrl="update.aspx" />
                     <asp:HiddenField ID="BackTo" runat="server"  Value="Default.aspx"/>
                   </td>
                </tr>
            </table>
         <asp:Table ID="HeaderTable" runat="server" BORDER="1" CELLSPACING="0" CELLPADDING="0" Font-Size="11" Width="100%">
         <asp:TableRow>
         <asp:TableCell HorizontalAlign="center" Width="110">
         <asp:LinkButton ID="Shipper" runat="server" OnClick="TableSort_Click">Shipper</asp:LinkButton></asp:TableCell>
         <asp:TableCell HorizontalAlign="center" Width="300">
         <asp:LinkButton ID="Cust" runat="server" OnClick="TableSort_Click">Cust</asp:LinkButton></asp:TableCell>
         <asp:TableCell HorizontalAlign="center" Width="40">
         <asp:LinkButton ID="Br" runat="server" OnClick="TableSort_Click">Br</asp:LinkButton></asp:TableCell>
         <asp:TableCell HorizontalAlign="center" Width="40">
         <asp:LinkButton ID="Ship" runat="server" OnClick="TableSort_Click">Ship</asp:LinkButton></asp:TableCell>
         <asp:TableCell HorizontalAlign="center" Width="180">
         <asp:LinkButton ID="Date" runat="server" OnClick="TableSort_Click">Date</asp:LinkButton></asp:TableCell>
         <asp:TableCell HorizontalAlign="center" Width="120">
         <asp:LinkButton ID="Tech" runat="server" OnClick="TableSort_Click">Tech</asp:LinkButton></asp:TableCell>
         <asp:TableCell HorizontalAlign="center" Width="50">Print</asp:TableCell>
         <asp:TableCell HorizontalAlign="center" Width="50">Pick</asp:TableCell>
         </asp:TableRow>
         </asp:Table>
        </asp:Panel>
       <asp:Panel ID="ShipperGridPanel" runat="server" Height="500px" width="100%" ScrollBars="Both">
         <asp:Table ID="WorkTable" runat="server" BORDER="1" CELLSPACING="0" CELLPADDING="0" Font-Size="11" Width="100%">
         </asp:Table>
      </asp:Panel>
    </div>
    </form>
</body>
</html>
