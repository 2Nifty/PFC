<%@ Page Language="VB" AutoEventWireup="false" CodeFile="MakeTransfers.aspx.vb" Inherits="MakeTransfers" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>AD Transfer Page</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet"  type="text/css" />
</head>
<body>
    <asp:SqlDataSource ID="ProcessNames" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnectionString %>" 
        SelectCommand="SELECT DISTINCT SatisfiedByProcess FROM ADResults ORDER BY SatisfiedByProcess" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="FromBranches" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnectionString %>" 
        SelectCommand="SELECT DISTINCT FromLoc FROM ADResults ORDER BY FromLoc" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="ToBranches" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnectionString %>" 
        SelectCommand="SELECT DISTINCT ToLoc FROM ADResults ORDER BY ToLoc" ></asp:SqlDataSource>
    <form id="form1" runat="server">
    <div>
         <table width="100%" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="middle" class="PageHead" colspan="2">
                       <span class="Left5pxPadd">
                       <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Auto Distribution Transfer Maker"></asp:Label>
                       </span>
                </td><td align="right"  class="PageHead" >
            <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="Images/Close.gif" 
                        PostBackUrl="javascript:window.close();"  CausesValidation="false"/>
            </td>
            </tr>
        </table>
         <table  cellspacing="0" cellpadding="0" border="1" bordercolor="black">
                    <tr><td class="Left5pxPadd">
                    Select Transfer Package Type
                    </td><td class="Left5pxPadd" style="background-color: #bce6f2">
                    Hot Rush Filter
                    </td><td class="Left5pxPadd" colspan="2">
                    AD Process used to create results
                    </td>
                    <td class="Left5pxPadd" style="background-color: #bce6f2">
                    From Branch
                    </td>
                        <td  class="Left5pxPadd" rowspan="3" style="background-color: #bce6f2">
                        <asp:ListBox ID="FromListBox" runat="server" SelectionMode="Multiple" DataSourceID="FromBranches" DataTextField="FromLoc" DataValueField="FromLoc"></asp:ListBox>
                    </td>
                    <td class="Left5pxPadd">
                    To Branch
                    </td>
                    <td  class="Left5pxPadd" rowspan="3">
                        <asp:ListBox ID="ToListBox" runat="server" SelectionMode="Multiple" DataSourceID="ToBranches" DataTextField="ToLoc" DataValueField="ToLoc"></asp:ListBox>
                    </td>
                    <td  rowspan="4" class="PageBg" align="center">
                        Generate<br />Transfers <br />
                        <asp:ImageButton ID="ShowTransferButton"  ImageUrl="Images/ok.gif" runat="server" />
                        </td></tr>
                    <tr>
                    <td align="left">
                    <asp:RadioButtonList ID="PackageRadioButtonList" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Selected="true">Bulk</asp:ListItem>
                        <asp:ListItem>Package</asp:ListItem>
                    </asp:RadioButtonList>
                    </td>
                    <td align="left" style="background-color: #bce6f2">
                    <asp:RadioButtonList ID="RushRadioButtonList" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Selected="true">All</asp:ListItem>
                        <asp:ListItem>Hot</asp:ListItem>
                        <asp:ListItem>Not</asp:ListItem>
                    </asp:RadioButtonList>
                    </td>
                    <td class="Left5pxPadd">Filter
                    <asp:CheckBox ID="FilterByProcessCheckBox" runat="server" />
                    </td>
                    <td class="Left5pxPadd"> 
                    <asp:DropDownList ID="ProcessFilter" runat="server" DataSourceID="ProcessNames" DataTextField="SatisfiedByProcess" DataValueField="SatisfiedByProcess" >
                    </asp:DropDownList>
                    </td>
                     <td class="Left5pxPadd" style="background-color: #bce6f2">Filter
                    <asp:CheckBox ID="FilterByFromCheckBox" runat="server" />
                    </td>
                     <td class="Left5pxPadd">Filter
                    <asp:CheckBox ID="FilterByToCheckBox" runat="server" />
                    </td>                  
                    </tr>
                    <tr><td colspan="5">
                       <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen" Width="240px"></asp:Label>
                    </td>
                    <td></td></tr>
        </table>
    </div>
         <table width="100%" cellspacing="0" cellpadding="0">
            <tr>
                <td>
        <asp:Panel ID="TransferPanel" runat="server" Height="500px" Width="95%" ScrollBars="Vertical">
         <table width="100%" cellspacing="0" cellpadding="0">
                <tr class="PageBg" >
                    <td>Transfers
                    </td>
                    <td class="Left5pxPadd">
                        Load transfer detail to ERP
                        <asp:ImageButton ID="ExportTransferButton"  ImageUrl="Images/ok.gif" runat="server" />
                     </td>
                </tr>
                <tr>
                    <td colspan="2">
                    <asp:GridView ID="TransfersGridView" runat="server" AutoGenerateColumns="false"
                    AlternatingRowStyle-BackColor="#DCF3FB" OnRowEditing="ShowSelectedHandler"
                    >
                    <Columns>
                    <asp:CommandField  ShoweditButton="true" EditText="Show"  />
                    <asp:BoundField DataField="FromLoc" HeaderText="From" ReadOnly="True" SortExpression="FromLoc" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="ToLoc" HeaderText="To" ReadOnly="True" SortExpression="ToLoc" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="TransferNo" HeaderText="Transfer" ReadOnly="True" SortExpression="TransferNo" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="Lines" HeaderText="Lines" ReadOnly="True" SortExpression="Lines" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="XFerQty" HeaderText="Qty" ItemStyle-HorizontalAlign="Center"
                        ReadOnly="True" SortExpression="XFerQty" />
                    <asp:BoundField DataField="XFerWght" HeaderText="Wght" ItemStyle-HorizontalAlign="Right"
                        ReadOnly="True" SortExpression="XFerWght" DataFormatString="{0:N1}" />
                    <asp:BoundField DataField="XFerRush" HeaderText="Rush" ItemStyle-HorizontalAlign="Center"
                        ReadOnly="True" SortExpression="XFerRush" />
                    </Columns>
                    </asp:GridView>
                    
                    </td>
                </tr>
             </table>
               
             </asp:Panel>
                </td>
                <td>
                <asp:Panel ID="TransferEditPanel" runat="server" Height="125px" Width="95%" class="BluBg">
                <table cellspacing="0" cellpadding="0" class="BluBg">
                        <tr>
                            <td class="Left5pxPadd">Transfer
                            </td>
                            <td class="Left5pxPadd">
                                <asp:Label ID="TransferNumberLabel" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="Left5pxPadd">Item
                            </td>
                            <td class="Left5pxPadd">
                                <asp:Label ID="ItemLabel" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="Left5pxPadd">Priority (1=Hot Rush, 0=Normal)
                            </td>
                            <td class="Left5pxPadd">
                                <asp:TextBox ID="NewPriority" runat="server" Width="20"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="Left5pxPadd">Ship Qty
                            </td>
                            <td class="Left5pxPadd">
                                <asp:TextBox ID="NewShipQty" runat="server" Width="40"></asp:TextBox>
                            </td>
                            </tr>
                        <tr>
                            <td colspan="2" class="Left5pxPadd">
                            <asp:ImageButton ID="SaveButt" runat="server" ImageUrl="Images/accept.jpg" />
                            <asp:ImageButton ID="DoneButt" runat="server" ImageUrl="Images/done.gif" CausesValidation="False" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
              <asp:Panel ID="TransferDetailPanel" runat="server" Height="500px" Width="95%" ScrollBars="Vertical">
                <table width="100%" cellspacing="0" cellpadding="0">
                <tr>
                    <td><asp:HiddenField ID="HiddenID" runat="server" />
                    <asp:GridView ID="TransferDetailGridView" runat="server" AutoGenerateColumns="False"
                     AutoGenerateEditButton="True" DataKeyNames="pADResultsID" OnRowDeleting="GridDeleteHandler"
                      OnRowEditing="GridEditHandler"
                    AlternatingRowStyle-BackColor="#DCF3FB" >
                    <Columns>
                    <asp:CommandField ShowDeleteButton="true"    />
                    <asp:BoundField DataField="Priority" HeaderText="Priority" ReadOnly="True" SortExpression="Priority" >
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="FromLoc" HeaderText="From" ReadOnly="True" SortExpression="FromLoc" >
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ToLoc" HeaderText="To" ReadOnly="True" SortExpression="ToLoc" >
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="TransferNo" HeaderText="Transfer" ReadOnly="True" SortExpression="TransferNo" >
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="LineNumber" HeaderText="Line" ReadOnly="True" SortExpression="LineNumber" >
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Item" HeaderText="Item" InsertVisible="False"
                    ReadOnly="True" SortExpression="Item" />
                    <asp:BoundField DataField="ShipQty" HeaderText="Qty"
                        SortExpression="ShipQty" >
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Weight" HeaderText="Weight"
                        ReadOnly="True" SortExpression="Weight" DataFormatString="{0:N1}" >
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="pADResultsID" HeaderText="ID" 
                        ReadOnly="True" SortExpression="pADResultsID"  >
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    </Columns>
                        <AlternatingRowStyle BackColor="#DCF3FB" />
                    </asp:GridView>
                    </td>
                </tr>
            </table>
        </asp:Panel>
               </td>
            </tr>
        </table>    
    </form>
</body>
</html>
