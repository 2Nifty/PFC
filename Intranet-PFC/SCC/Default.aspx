<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default"  Debug="true"%>
<%@ Register Src="IntranetTheme/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Standard Cost Creator</title>
 <link href="IntranetTheme/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
 <script language="javascript">
function LoadHelp()
{
 window.open("Help.htm",'Help','height=710,width=1020,scrollbars=yes,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
   
}
    </script>
</head>
<body>
    <asp:SqlDataSource 
        ConnectionString="<%$ ConnectionStrings:PFCReportsConnectionString %>" 
        ID="GroupDataSource" runat="server" SelectCommand="SELECT convert(varchar,GroupNo) as GroupNo, convert(varchar,GroupNo)+' : '+min(Category) +'-'+max(Category)+' '+min(Description) as Categories &#13;&#10;FROM CAS_CatGrpDesc&#13;&#10;group by GroupNo"></asp:SqlDataSource>   
     <form id="OptionForm" runat="server" >
        <asp:HiddenField ID="OptionStat" runat="server" />
        <asp:HiddenField ID="CostsReady" runat="server" />
        <asp:HiddenField ID="DBServer" runat="server" />
        <asp:HiddenField ID="DBName" runat="server" />
        <asp:HiddenField ID="GroupToUse" runat="server" />
   <table width="100%" border="0" cellpadding=2 cellspacing=0>
   <tr>
                <td valign="top" colspan="3">
                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="PageHead" valign="top" style="height: 40px">
                    <div align="left" class="BannerText">Standard Cost Creator</div>
                </td>
                <td class="PageHead" align="right" valign="top" style="height: 40px"><img src="images/help.gif" onclick="LoadHelp();" style="cursor:hand"  /></td>
            </tr>
            <tr>
            <td id="tblTD" runat="server" colspan="3" style="height: 40px" >
                <asp:Table ID="HeadingText" runat="server">
                <asp:TableRow>                
                <asp:TableCell RowSpan=2>
                <asp:Table ID="HeadingOptions" runat="server"  CellPadding=0 CellSpacing=0 Visible=false>
                <asp:TableRow>
                <asp:TableCell ColumnSpan=2  HorizontalAlign=Right>Corp Fixed Velocity Code Filter:</asp:TableCell>
                <asp:TableCell>
                <asp:TextBox ID="VelocityCodeFilter2" runat="server" Width="50px"  style="text-transform:uppercase"></asp:TextBox></asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                <asp:TableCell>Status:
                        <asp:Label ID="StatusText" runat="server" Text="" ForeColor="Red"></asp:Label></asp:TableCell>
                <asp:TableCell HorizontalAlign=Right>Package Filter:</asp:TableCell>
                <asp:TableCell><asp:TextBox ID="PackageFilter2" runat="server" Width="50px"></asp:TextBox></asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
               <asp:TableCell>Category Group: <asp:DropDownList ID="SelectedGroup2" runat="server" DataSourceID="GroupDataSource"
             DataTextField="Categories" DataValueField="GroupNo" Width="298px" AutoPostBack="true"
             OnSelectedIndexChanged="GetOptionDropDown2_Click"></asp:DropDownList></asp:TableCell>
                <asp:TableCell HorizontalAlign=Right>Plating Filter:</asp:TableCell>
                <asp:TableCell><asp:TextBox ID="PlatingFilter2" runat="server" Width="50px"></asp:TextBox></asp:TableCell>
                </asp:TableRow>
                </asp:Table>
                </asp:TableCell>
                </asp:TableRow>               
                </asp:Table>
            </td>

            </tr>          
        
           <tr>
                <td  Width="30%" valign="top">
            <asp:Table id="FilterTable" runat="server" BorderWidth="1"  BorderStyle="Inset" BorderColor="black" CellSpacing="0">
            <asp:TableRow BorderColor="black">
            <asp:TableCell ColumnSpan=2><div class="LeftPadding">
             Category Group: <asp:DropDownList ID="SelectedGroup" CssClass="FormCtrl" runat="server" DataSourceID="GroupDataSource"
                 DataTextField="Categories" DataValueField="GroupNo" Width="298px" AutoPostBack="true">
             </asp:DropDownList></div></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
            <asp:TableCell BorderColor="black" BorderWidth="1"  BorderStyle="Inset" ><div class="LeftPadding">
             Corp Fixed Velocity Code Filter: </div></asp:TableCell>
            <asp:TableCell BorderColor="black" BorderWidth="1"  BorderStyle="Inset">
            <asp:TextBox ID="VelocityCodeFilter" CssClass="FormCtrl" runat="server" Width="60px" style="text-transform:uppercase"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
            <asp:TableCell BorderColor="black" BorderWidth="1"  BorderStyle="Inset" ><div class="LeftPadding">
             Package Filter: </div></asp:TableCell>
            <asp:TableCell BorderColor="black" BorderWidth="1"  BorderStyle="Inset" >
            <asp:TextBox ID="PackageFilter" CssClass="FormCtrl" runat="server" Width="60px"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
            <asp:TableCell BorderColor="black" BorderWidth="1"  BorderStyle="Inset" ><div class="LeftPadding">
             Plating Filter: </div></asp:TableCell>
            <asp:TableCell BorderColor="black" CssClass="FormCtrl" BorderWidth="1"  BorderStyle="Inset" ><asp:TextBox  CssClass="FormCtrl" ID="PlatingFilter" runat="server" Width="60px"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
            <asp:TableCell cssClass="BluBg"><div class="LeftPadding">
            Get SCC Adders </div></asp:TableCell>
            <asp:TableCell cssClass="BluBg">
            <asp:ImageButton ID="GetOption" runat="server"  ImageUrl="images/ok.gif" CausesValidation="false" /></asp:TableCell>
            </asp:TableRow>
            </asp:Table>
     <asp:Panel ID="OptionPanel" runat="server">
         <table BORDER=1 CELLSPACING=0 CELLPADDING=3 width=100%>
               <tr>
                    <td colspan=3 class="PageHead"><div class="LeftPadding">
                    <div align="left" class="BannerText">
                            SCC Options:</div>
                </div>
                    </td>
                </tr>
              <tr>
                    <td class="LeftPadding">Discount Reciprocal:
                    </td>
                    <td> 
                        <asp:TextBox CssClass="FormCtrl"  ID="DiscountReciprocal" runat="server" Width="60px"></asp:TextBox>%
                    </td>
                    <td>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" CssClass="Required" runat="server" ErrorMessage="Required" ControlToValidate="DiscountReciprocal"></asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidator1" CssClass="Required" runat="server" ErrorMessage="Range 0-100" ControlToValidate="DiscountReciprocal" MaximumValue="100" MinimumValue="0" Type="Double"></asp:RangeValidator>
                    </td>
              </tr>
                <tr>
                    <td class="LeftPadding">Velocity Adder:
                    </td>
                    <td>
                        <asp:TextBox  CssClass="FormCtrl" ID="VelocityAdder" runat="server" Width="60px"></asp:TextBox>%
                    </td>
                    <td>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" CssClass="Required" runat="server" ErrorMessage="Required" ControlToValidate="VelocityAdder"></asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidator2" CssClass="Required" runat="server" ErrorMessage="Range 0-100" ControlToValidate="VelocityAdder" MaximumValue="100" MinimumValue="0" Type="Double"></asp:RangeValidator>
                   </td>
                </tr>
                <tr>
                    <td class="LeftPadding">Premium Category Adder:
                    </td>
                    <td><asp:TextBox CssClass="FormCtrl" ID="PremiumCategoryAdder" runat="server" Width="60px"></asp:TextBox>%
                    </td>
                    <td>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" CssClass="Required" runat="server" ErrorMessage="Required" ControlToValidate="PremiumCategoryAdder"></asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidator3" CssClass="Required" runat="server" ErrorMessage="Range 0-100" ControlToValidate="PremiumCategoryAdder" MaximumValue="100" MinimumValue="0" Type="Double"></asp:RangeValidator>
                    </td>
                </tr>
                <tr>
                    <td class="LeftPadding">Packaging Adder:
                    </td>
                    <td>
                        <asp:TextBox CssClass="FormCtrl" ID="PackagingAdder" runat="server" Width="60px"></asp:TextBox>%
                    </td>
                    <td>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" CssClass="Required" runat="server" ErrorMessage="Required" ControlToValidate="PackagingAdder"></asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidator4" CssClass="Required" runat="server" ErrorMessage="Range 0-100" ControlToValidate="PackagingAdder" MaximumValue="100" MinimumValue="0" Type="Double"></asp:RangeValidator>
                    </td>
                </tr>
        <tr>
            <td valign="top" Class="BluBg"><div class="LeftPadding">
            Update (Save) SCC Options </div></td>
                    <td class="BluBg" colspan="2">
                   <asp:ImageButton ID="SaveButton" runat="server"  ImageUrl="images/update.gif" />
            <asp:ImageButton ID="UpdateButton" runat="server" ImageUrl="images/update.gif" />
           </td>
        </tr>
       <tr>
        </tr>
       <tr Class="BluBg" >
            <td valign="top" colspan="3" >
                <table cellpadding=3 cellspacing=0 border=1>
                    <tr>
                        <td align="center">Calculate Costs <%= CalcCount %>
                        </td>
                        <td align="center">
                        <asp:ImageButton ID="CalcCosts" runat="server"  ImageUrl="images/ok.gif" />
                        </td>
                    </tr>
                    <tr>
                        <td align="center"><%= ExportFile %>
                        </td>
                        <td align="center"><asp:ImageButton ID="ExportCosts" runat="server" ImageUrl="images/ExporttoExcel.gif" />
                        </td>
                    </tr>
                    <tr>
                        <td align="center">Create Report Page
                        </td>
                        <td align="center">
                            <asp:ImageButton ID="PrintCosts" runat="server" ImageUrl="images/Print.gif"  PostBackUrl="<%$ appSettings:PreviewURL %>"/>
                        </td>
                    </tr>
                </table>
                </td>
        </tr>
       <tr>
            <td valign="top" Class="BluBg" colspan="3" ><div class="LeftPadding" >
                <asp:Label ID="UpdCostLabel" runat="server" Text=""></asp:Label>&nbsp;
                <asp:ImageButton ID="UpdCostButton" runat="server"  ImageUrl="images/update.gif" PostBackUrl="update.aspx" /></div>
     </td>
        </tr>
        </table>
    </asp:Panel>  
              </td>
                <td Width="60%" valign=top>
     <asp:Table ID="HeaderTable" runat="server" BORDER=1 CELLSPACING=0 CELLPADDING=0 Font-Size="11" Width="100%">
    <asp:TableHeaderRow>
    <asp:TableHeaderCell CssClass="GridHead" width="110" Wrap="false">Item</asp:TableHeaderCell>
    <asp:TableHeaderCell CssClass="GridHead" HorizontalAlign="Right" Width="70">Direct</asp:TableHeaderCell>
    <asp:TableHeaderCell CssClass="GridHead" width="70" HorizontalAlign="Right">Base</asp:TableHeaderCell>
    <asp:TableHeaderCell CssClass="GridHead" width="80" HorizontalAlign="center">Start</asp:TableHeaderCell>
    <asp:TableHeaderCell CssClass="GridHead" width="50" HorizontalAlign="center">Origin</asp:TableHeaderCell>
    <asp:TableHeaderCell CssClass="GridHead" HorizontalAlign="Center" Width="80">Std. Cost</asp:TableHeaderCell>
    <asp:TableHeaderCell CssClass="GridHead" width="50" >Ignore</asp:TableHeaderCell>
    </asp:TableHeaderRow>
    </asp:Table>
   <asp:Panel ID="CostPanel" runat="server" ScrollBars="Vertical" Height="400">
    <asp:Table CssClass="GridItem" ID="WorkTable" runat="server" BORDER=1 CELLSPACING=0 CELLPADDING=0 Font-Size="11" Width="100%">
    </asp:Table>
    </asp:Panel>  
                </td>
            </tr>
        </table>  <br />
     </form> 
</body>
</html>
