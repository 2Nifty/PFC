<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" ValidateRequest="false"   CodeFile="BOLSummary.aspx.cs" Inherits="BOLSummary" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>GER BOL Summary</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css">
    <link href="../SalesAnalysisReport/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet"
        type="text/css" />
    <link href="../GER/Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
   
    <style>
    .PageBg 
    {
	    background-color: #B3E2F0;
	    padding: 1px;
    }    
    </style>

    <script language="javascript" src="Common/Javascript/ger.js"></script>

    <script language="javascript" src="Common/Javascript/ContextMenu.js"></script>
    

    <script language="javascript">
    <!--
        function PrintIt(BOLNo)
        {
        aWindow = window.open('BOLSummary.aspx?BOL='+BOLNo,'BOL','','');
        aWindow.print();   
        }

    -->
    </script>

</head>
<body >
    <form id="form1" runat="server">
        <table width=100%>
            <tr>
                <td valign=middle class=PageHead colspan=2>
                       <span class=Left5pxPadd>
                       <asp:Label ID="lblParentMenuName" CssClass=BannerText runat="server" Text="BOL Summary"></asp:Label>
                       </span>
                </td>
            </tr>
            <tr>
                <td width=200>
                <asp:Panel ID="PromptPanel" runat="server" height="30" Width="200px">
                    <table width="200">
                        <tr>
                            <td width="100">
                            <asp:Label ID="BOLLabel" runat="server" Text="BOL&nbsp;Number"></asp:Label>
                            </td>
                            <td width="100">
                        <asp:TextBox ID="BOLNumberBox" runat="server"></asp:TextBox>
                                <input id="PrintHide" name="PrintHide" type="hidden"  value="Print"/>
                            </td>
                            <td>
                        <asp:ImageButton ID="FindBOLButt" runat="server" ImageUrl="common/Images/search.gif" />
                            </td>
                        </tr>
                    </table>        
                </asp:Panel>
                </td>
                        </tr>
                        <tr>
                <td>
                <asp:Panel ID="DataPanel" runat="server" height="300" Width="100%" >
                    <table>
                        <tr>
                            <td valign=top>
                    <asp:DetailsView ID="BOLDetails" runat="server" Font-Size="Larger" AutoGenerateRows="false">
                        <Fields>
                            <asp:TemplateField HeaderText="Bill of Lading" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="BOLNoLabel" Runat="Server" Text='<%# Eval("BOLNo") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Bill of Lading Date" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="BOLDateLabel" Runat="Server" Text='<%# Eval("BOLDate", "{0:MM/dd/yyyy}") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Vendor" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="VendNoLabel" Runat="Server" Text='<%# Eval("VendNo") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Vendor Name" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="VendNameLabel" Runat="Server" Text='<%# Eval("VendName") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="AP Invoice Number" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="APInvoiceNumberLabel" Runat="Server" Text='<%# Eval("APInvoiceNumber") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Purchase Receipt Number" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="PurchReceiptNumberLabel" Runat="Server" Text='<%# Eval("PurchReceiptNumber") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Transfer Order Number" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="TransferOrderNumberLabel" Runat="Server" Text='<%# Eval("TransferOrderNumber") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Transfer Shipment Number" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="TransferShipmentNumberLabel" Runat="Server" Text='<%# Eval("TransferShipmentNumber") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                       </Fields>
                    </asp:DetailsView>
                            </td>
                            <td valign=top>
                     <asp:DetailsView ID="BOLAmounts" runat="server" Font-Size="Larger" CellPadding="1" AutoGenerateRows="false">
                         <Fields>
                            <asp:TemplateField HeaderText="Material" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="UOMatlAmtLabel" Runat="Server" Text='<%# Eval("UOMatlAmt", "{0,-10:$##,##0.00}") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                             <asp:TemplateField HeaderText="Duty" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="UODutyAmtLabel" Runat="Server" Text='<%# Eval("UODutyAmt", "{0,-10:$##,##0.00}") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Freight" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="UOOceanFrghtAmtLabel" Runat="Server" Text='<%# Eval("UOOceanFrghtAmt", "{0,-10:$##,##0.00}") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Brokerage" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="UOBrokerageAmtLabel" Runat="Server" Text='<%# Eval("UOBrokerageAmt", "{0,-10:$##,##0.00}") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Drayage" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="UODrayAmtLabel" Runat="Server" Text='<%# Eval("UODrayAmt", "{0,-10:$##,##0.00}") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Merchandise Processing" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="UOMerchProcFeeLabel" Runat="Server" Text='<%# Eval("UOMerchProcFee", "{0,-10:$##,##0.00}") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Harbor Maintenance" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="UOHarborMaintFeeLabel" Runat="Server" Text='<%# Eval("UOHarborMaintFee", "{0,-10:$##,##0.00}") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Misc. Weight Fee" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="UOMiscWghtFeeLabel" Runat="Server" Text='<%# Eval("UOMiscWghtFee", "{0,-10:$##,##0.00}") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Misc. Fee" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="UOMiscFeeAmtLabel" Runat="Server" Text='<%# Eval("UOMiscFeeAmt", "{0,-10:$##,##0.00}") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Truck Freight" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="UOTrkFrghtAmtLabel" Runat="Server" Text='<%# Eval("UOTrkFrghtAmt", "{0,-10:$##,##0.00}") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                         </Fields>
                   </asp:DetailsView>
                           </td>
                        </tr>
                    </table>
                </asp:Panel>
                </td>
            </tr>
            <tr>
                <td colspan=2>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                    <td align="left" class="PageBg">
                    <asp:Label ID="lblErrorMessage" runat="server" CssClass="txtError"></asp:Label>
                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen" Width="240px"></asp:Label></td>
                    <td align="right" class="PageBg" valign="bottom">
                        <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                        <td style="padding-left: 5px">
                            <asp:ImageButton ID="PrintButton" runat="server" ImageUrl="common/Images/Print.gif" 
                                PostBackUrl="javascript:PrintIt(document.form1.BOLNumberBox.value);" Visible="false" />
                            <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="common/Images/close.jpg" 
                                PostBackUrl="../InvReportDashboard/InvReportsDashBoard.aspx" />
                        </td>
                        </tr>
                        </table>
                    </td>
                    </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>

<script language="javascript">
//if (document.form1.PrintHide.value == "Print") 
window.print();
</script>
</body>

</html>
