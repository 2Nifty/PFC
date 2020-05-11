<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" ValidateRequest="false"   CodeFile="BOLHistDetail.aspx.cs" Inherits="BOLHistDetail" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>GER History</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css">
    <link href="../SalesAnalysisReport/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet"
        type="text/css" />
    <link href="../GER/Common/StyleSheet/FreezeGrid.css" rel="stylesheet"  type="text/css" />
   
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
    function PrintHistDet()
    {   
        var prtContent = "<html><head><link href=Common/StyleSheet/Styles.css rel=stylesheet type=text/css /><style>.GridItem {	font-family: Arial, Helvetica, sans-serif;	font-size: 11px;	color: #000000;	text-decoration:none;}</style></head><body>";
            var WinPrint = window.open('','HistDetPrint','left=0,top=0,width=1,height=1,toolbar=0,scrollbars=0,status=0');        
            prtContent = prtContent + document.getElementById("DataPanel").innerHTML ;
            prtContent = prtContent + document.getElementById("DetailSection").innerHTML.replace('1200px;','100%') ; // Used to set the grid width as 100% in print mode
            prtContent = prtContent + "</body></html>";        
            WinPrint.document.write(prtContent);
            WinPrint.document.close();
            WinPrint.focus();
            WinPrint.print();
            WinPrint.close();
            return false;
    }

    function Close(session)
	{
	    BOLHistDetail.DeleteExcel('BOLHistDetail'+session).value;
		window.close();
    }

    </script>
</head>
<body >
    <form id="form1" runat="server">
        <table cellspacing="0" cellpadding="0">
            <tr>
                <td valign=middle class=PageHead colspan=2>
                       <span class=Left5pxPadd>
                       <asp:Label ID="lblParentMenuName" CssClass=BannerText runat="server" Text="BOL Historical Detail"></asp:Label>
                       </span>
                </td>
            </tr>
            <tr>
                <td colspan=2>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                    <td width="100" class="PageBg">
                    <asp:Label ID="BOLLabel" runat="server" Text="BOL&nbsp;Number"></asp:Label>
                    </td>
                    <td width="100" class="PageBg">
                <asp:TextBox ID="BOLNumberBox" runat="server"></asp:TextBox>
                        <input id="PrintHide" name="PrintHide" type="hidden"  value="Print"/>
                    </td>
                    <td class="PageBg">
                <asp:ImageButton ID="FindBOLButt" runat="server" ImageUrl="common/Images/search.gif" />
                    </td>
                   <td align="left" class="PageBg">
                    <asp:Label ID="lblErrorMessage" runat="server" CssClass="txtError"></asp:Label>
                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen" Width="240px"></asp:Label></td>
                    <td align="right" class="PageBg" valign="bottom">
                        <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                        <td style="padding-left: 5px">
                            <img runat="server" src="common/Images/Print.gif" alt="Print"
                                onclick="javascript:PrintHistDet();" />
                            <asp:ImageButton ID="ibtnExcelExport" runat="server" ImageUrl="common/Images/exporttoexcel.gif" OnClick="ibtnExcelExport_Click" />
                            <img id="CloseButton" src="common/Images/close.jpg" style="cursor:hand" onclick="javascript:Close('<%=Session["SessionID"].ToString() %>');" />
                        </td>
                        </tr>
                        </table>
                    </td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                <asp:Panel ID="DataPanel" runat="server" height="90" Width="100%" >
                    <table id="Header" >
                        <tr>
                            <td valign=top >
                    <asp:DetailsView ID="BOLHeaderLeft" runat="server" AutoGenerateRows="false" AlternatingRowStyle-BackColor="#DCF3FB" >
                    <AlternatingRowStyle CssClass="GridItem" BackColor="#DCF3FB" BorderColor="#DAEEEF" Height="20px"/>
                    <RowStyle CssClass="GridItem" BorderColor="#DAEEEF" Height="20px" />
                        <Fields>
                            <asp:TemplateField HeaderText="Bill of Lading"  ItemStyle-Font-Size=11px  ItemStyle-Font-Names="font-family: Arial, Helvetica, sans-serif" ItemStyle-HorizontalAlign="Right" >
                            <ItemTemplate> 
                              <asp:Label ID="BOLNoLabel"  Runat="Server" Text='<%# Eval("BOLNo") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                           <asp:TemplateField HeaderText="BOL Date" ItemStyle-HorizontalAlign="Right" >
                            <ItemTemplate> 
                              <asp:Label ID="BOLDateLabel" Runat="Server" Text='<%# Eval("BOLDate", "{0:MM/dd/yyyy}") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Location" ItemStyle-HorizontalAlign="Left">
                            <ItemTemplate> 
                              <asp:Label ID="LocationLabel" Runat="Server" Text='<%# Eval("PFCLocCd") %> ' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                             <asp:TemplateField HeaderText="Name" ItemStyle-HorizontalAlign="Left">
                            <ItemTemplate> 
                              <asp:Label ID="LocationNameLabel" Runat="Server" Text='<%# Eval("PFCLocName") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                      </Fields>
                    </asp:DetailsView>
                            </td>
                            <td valign=top>
                     <asp:DetailsView ID="BOLHeaderCenter" runat="server" CellPadding="1" AutoGenerateRows="false" AlternatingRowStyle-BackColor="#DCF3FB">
                         <AlternatingRowStyle CssClass="GridItem" BackColor="#DCF3FB" BorderColor="#DAEEEF" Height="20px"/>
                        <RowStyle CssClass="GridItem" BorderColor="#DAEEEF" Height="20px" />
                         <Fields>
                            <asp:TemplateField HeaderText="Processed" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="ProcDtLabel" Runat="Server" Text='<%# Eval("ProcDt", "{0:MM/dd/yyyy}") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Vendor" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="VendNoLabel" Runat="Server" Text='<%# Eval("VendNo") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                             <asp:TemplateField HeaderText="Name" ItemStyle-HorizontalAlign="Left">
                            <ItemTemplate> 
                              <asp:Label ID="VendNameLabel" Runat="Server" Text='<%# Eval("VendName") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Pay-To Acct" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="PayToVendLabel" Runat="Server" Text='<%# Eval("PayToVend") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                         </Fields>
                   </asp:DetailsView>
                           </td>
                            <td valign=top>
                     <asp:DetailsView ID="BOLHeaderRight" runat="server" CellPadding="1" AutoGenerateRows="false" AlternatingRowStyle-BackColor="#DCF3FB">
                        <AlternatingRowStyle CssClass="GridItem" BackColor="#DCF3FB" BorderColor="#DAEEEF" Height="20px"/>
                        <RowStyle CssClass="GridItem" BorderColor="#DAEEEF" Height="20px" />
                         <Fields>
                            <asp:TemplateField HeaderText="Receipt Type" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="RcptTypeDescLabel" Runat="Server" Text='<%# Eval("RcptTypeDesc") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Port of Lading" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="PortofLadingLabel" Runat="Server" Text='<%# Eval("PortofLading") %>' />
                            </ItemTemplate>
                            </asp:TemplateField>                        
                            <asp:TemplateField HeaderText="Vessel Name" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate> 
                              <asp:Label ID="VesselNameLabel" Runat="Server" Text='<%# Eval("VesselName") %>' />
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
                <td>
                <div id="printHeader" style="display:none">
                <table width=100% class=PageBg>
                    <tr>
                    <td width=120px>
                        <asp:Label ID="lblHeaderCaption" Text="BOL Number: " runat=server></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="lblBOLNumber" Text="BOL Number " runat=server></asp:Label>
                    </td>
                    </tr>
                </table>
                
                </div>
                </td>
            </tr>
            <tr><td><br />
                <asp:Panel ID="DetailPanel" runat="server" Height="550"  ScrollBars="Auto">
                <div class="Sbar" id="DetailSection" style="overflow-x:auto; overflow-y:auto; position:relative; top:0px;
                                    left: 0px; height: 500px; border: 0px solid;width:1000px " >
                <asp:DataGrid ID="BOLDetail" runat="server" AllowSorting="true" AutoGenerateColumns="false" OnSortCommand="Sort_Grid" Width=1200 >
                    <AlternatingItemStyle CssClass="GridItem" BackColor="#DCF3FB" BorderColor="#DAEEEF" Height="20px"/>
                    <ItemStyle CssClass="GridItem" BorderColor="#DAEEEF" Height="20px" />
                    <Columns>
                        <asp:TemplateColumn HeaderText="Invoice" SortExpression="VendInvNo">
                            <ItemTemplate>
                                <asp:Label ID="VendInvNoLabel" runat="server" Width="90px" CssClass="cntnopadding" Text='<%# Eval("VendInvNo")%>' ToolTip="Invoice Number"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle Width="90px" Wrap=false />
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="Inv. Date" SortExpression="VendInvDt">
                            <ItemTemplate>
                                <asp:Label ID="VendInvDtLabel" runat="server" Width="70px" CssClass="cntnopadding" Text='<%# Eval("VendInvDt", "{0:MM/dd/yyyy}")%>' ToolTip="Invoice Date"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle Width="40px" Wrap=true />
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="Container" SortExpression="ContainerNo">
                            <ItemTemplate>
                                <asp:Label ID="ContainerNoLabel" runat="server" Width="80px" CssClass="cntnopadding" Text='<%# Eval("ContainerNo")%>' ToolTip="Container"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle Width="80px" />
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="P.O." SortExpression="PFCPONo">
                            <ItemTemplate>
                                <asp:Label ID="PFCPONoLabel" runat="server"  CssClass="cntnopadding" Text='<%# Eval("PFCPONo")%>' ToolTip="P.O. Number"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="Item" SortExpression="PFCItemNo">
                            <ItemTemplate>
                                <asp:Label ID="PFCItemNoLabel" runat="server"  CssClass="cntnopadding" Text='<%# Eval("PFCItemNo")%>' ToolTip="Item Number"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle Width=120px Wrap=false />
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="Item Description" SortExpression="PFCItemDesc">
                            <ItemTemplate>
                                <asp:Label ID="PFCItemDescLabel" runat="server" Width="150" CssClass="cntnopadding" Text='<%# Eval("PFCItemDesc")%>' ToolTip="Description"></asp:Label>
                            </ItemTemplate>                            
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="U/M Qty" SortExpression="RcptQty" HeaderStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:Label ID="RcptQtyLabel" runat="server" CssClass="cntnopadding" Text='<%# Eval("UMQty")%>' ToolTip="Quantity Received"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="Pcs Qty" SortExpression="PcsPerAlt" HeaderStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:Label ID="PcsQtyLabel" runat="server" CssClass="cntnopadding" Text='<%# Eval("PcsPerAlt", "{0,-10:###,##0}")%>' ToolTip="Cost"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="Land Cost U/M" SortExpression="UOMatlAmtLanded" HeaderStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:Label ID="UOMatlAmtLandedLabel" runat="server" CssClass="cntnopadding" Text='<%# Eval("UOMatlAmtLanded", "{0,-10:$##,##0.00}")%>' ToolTip="Cost"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="Mat'l Cost" SortExpression="MatlCost" HeaderStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:Label ID="MatlCostLabel" runat="server" CssClass="cntnopadding" Text='<%# Eval("MatlCost", "{0,-10:$##,##0.00}")%>' ToolTip="Cost"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="Duty" SortExpression="DutyPerUnit" HeaderStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:Label ID="UODutyAmtLabel" runat="server" CssClass="cntnopadding" Text='<%# Eval("DutyPerUnit", "{0,-10:$##,##0.00}")%>' ToolTip="Duty"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Right"  />
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="Oc. Fr." SortExpression="OceanPerUnit" HeaderStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:Label ID="UOOceanFrghtAmtLabel" runat="server" CssClass="cntnopadding" Text='<%# Eval("OceanPerUnit", "{0,-10:$##,##0.00}")%>' ToolTip="Ocean Freight"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Right"  />
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="Broker" SortExpression="BrokerPerUnit" HeaderStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:Label ID="UOBrokerageAmtLabel" runat="server" CssClass="cntnopadding" Text='<%# Eval("BrokerPerUnit", "{0,-10:$##,##0.00}")%>' ToolTip="Brokerage"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Right"  />
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="Dray" SortExpression="DrayPerUnit" HeaderStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:Label ID="UODrayAmtLabel" runat="server" CssClass="cntnopadding" Text='<%# Eval("DrayPerUnit", "{0,-10:$##,##0.00}")%>' ToolTip="Drayage"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="Harbor" SortExpression="HarborPerUnit" HeaderStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:Label ID="UOMerchProcFeeLabel" runat="server" CssClass="cntnopadding" Text='<%# Eval("HarborPerUnit", "{0,-10:$##,##0.00}")%>' ToolTip="Merchandise Processing Fee"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="Misc" SortExpression="MiscPerUnit" HeaderStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:Label ID="UOHarborMaintFeeLabel" runat="server" CssClass="cntnopadding" Text='<%# Eval("MiscPerUnit", "{0,-10:$##,##0.00}")%>' ToolTip="Harbor Maintenance Fee"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="Trk. Frt." SortExpression="TruckPerUnit" HeaderStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:Label ID="UOMiscFeeAmtLabel" runat="server" CssClass="cntnopadding" Text='<%# Eval("TruckPerUnit", "{0,-10:$##,##0.00}")%>' ToolTip="Miscellaneous Fee"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Right" Width="50px" />
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderText="Alt Cost" SortExpression="MatlK" HeaderStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:Label ID="UOTrkFrghtAmtLabel" runat="server" CssClass="cntnopadding" Text='<%# Eval("MatlK", "{0,-10:$##,##0.0}M")%>' ToolTip="Truck Freight"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Right" Width="40px" />
                        </asp:TemplateColumn>
                    </Columns>
                </asp:DataGrid>
                </div>
                </asp:Panel>
           </td>
            </tr>
        </table>
    </form>
</body>

</html>
