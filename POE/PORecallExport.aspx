<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PORecallExport.aspx.cs" Inherits="PORecallExport" %>

<%@ Register Src="Common/UserControls/PrintHeader.ascx" TagName="PrintHeader" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>PO Recall Export</title>
    <%= PFC.POE.BusinessLogicLayer.Common.PrintStyleSheet %>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table runat="server" cellpadding="0" cellspacing="0" width="100%" id="mainTable"
            class="lightBg">
            <tr>
                <td bgcolor="white" width="100%" colspan="2">
                    <uc1:PrintHeader ID="PrintHeader1" runat="server" />
                    
                </td>
            </tr>
            <tr>
                <td class="SubHeaderPanels" style="width: 100%; height: 13px" valign="top">
                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                        <tr>
                            <td style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px;" width="130px">
                                <asp:Label ID="lblPurchaseOrder" runat="server" Text="Purchase Order No " Font-Bold="True"
                                    Width="125px"></asp:Label>
                            </td>
                            <td style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px;">
                                <asp:Label ID="lblPONo" runat="server" Text=" " Font-Bold="false"
                                    Width="105px" CssClass="lblColor"></asp:Label>
                                
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table id="tHeader1" runat="server" width="100%" border="0" cellspacing="0" cellpadding="0"
                        class="HeaderPanels">
                        <tr>
                            <td valign="top" width="15%">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td colspan="2" style="height: 5px">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="20" style="padding-left: 4px;">
                                            <asp:Label ID="Label22" runat="server" Text="Order No:" CssClass="TabHead" Font-Bold="True"
                                                Width="70px"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblOrderNo" runat="server" Text="~Order No~" CssClass="lblColor" Width="70px"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="20" style="padding-left: 4px;">
                                            <asp:Label ID="Label23" runat="server" Text="Order Type:" CssClass="TabHead" Font-Bold="True"
                                                Width="70px"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblOrderType" runat="server" Text="~Order Type~" CssClass="lblColor"
                                                Width="70px"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="20" style="padding-left: 4px;">
                                            <asp:Label ID="Label24" runat="server" Text="Order Date:" CssClass="TabHead" Font-Bold="True"
                                                Width="70px"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblOrderDt" runat="server" Text="~Order Date~" Width="70px"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" class="HeaderPanels" width="30%" style="padding-left: 4px">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%" height="90%">
                                    <tr>
                                        <td width="50px" valign="top">
                                            <table cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblBuyFrom" runat="server" CssClass="TabHead" Text="Buy From:" Width="65px"
                                                            Font-Bold="True"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblBuyFromVendorNo" runat="server" CssClass="lblbox" Width="65px">
                                                        </asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td valign="top">
                                            <table cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblBuy_Name" runat="server" CssClass="lblColor"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblBuy_Address" runat="server" CssClass="lblColor"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblBuy_City" runat="server" CssClass="lblColor"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblBuyCom" runat="server" CssClass="lblColor" Text=",&nbsp;"></asp:Label></td>
                                                    <td>
                                                        <asp:Label ID="lblBuy_Territory" runat="server" CssClass="lblColor"></asp:Label></td>
                                                    <td>
                                                        &nbsp;<asp:Label ID="lblBuy_Pincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                                    <td>
                                                        &nbsp;<asp:Label ID="lblBuyCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblBuy_Phone" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <table cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblOrderContact" runat="server" CssClass="TabHead" Text="Order Contact:"
                                                            Width="80px"></asp:Label>
                                                    </td>
                                                    <td style="padding-left: 5px;">
                                                        <asp:Label ID="lblBuyFromContact" Text="" Width="100px" runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblPayTo" runat="server" CssClass="TabHead" Text="Pay To:" Width="75px"
                                                Font-Bold="true"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblTermDesc" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" class="HeaderPanels" style="padding-left: 4px" width="30%">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td width="55px">
                                            <asp:Label ID="lblShipTo" runat="server" CssClass="TabHead" Text="Ship To:" Width="75px"
                                                Font-Bold="True"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblShip_Name" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblCustNum" runat="server" CssClass="lblbox"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblShip_Address" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblShip_City" runat="server" CssClass="lblColor"></asp:Label></td>
                                                    <td>
                                                        <asp:Label ID="lblShipCom" runat="server" CssClass="lblColor" Text=",&nbsp;"></asp:Label></td>
                                                    <td>
                                                        <asp:Label ID="lblShip_State" runat="server" CssClass="lblColor"></asp:Label></td>
                                                    <td>
                                                        &nbsp;<asp:Label ID="lblShip_Pincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                                    <td>
                                                        &nbsp;<asp:Label ID="lblShipCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblShip_Phone" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td style="height: 14px">
                                            Contact:
                                            <asp:Label ID="lblShipToContact" runat="server" Text="~Ship To Contact~"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" class="HeaderPanels" style="padding-left: 4px" width="25%">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td colspan="2" style="height: 5px">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="20" style="padding-left: 4px;">
                                            <asp:Label ID="Label6" runat="server" Text="Total Cost" CssClass="TabHead" Font-Bold="True"
                                                Width="80px"></asp:Label>
                                        </td>
                                        <td style="height: 20px;">
                                            <asp:Label ID="lblTotCost" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="20" style="padding-left: 4px;">
                                            <asp:Label ID="Label12" runat="server" Text="Total Weight:" CssClass="TabHead" Font-Bold="True"
                                                Width="80px"></asp:Label>
                                        </td>
                                        <td style="height: 20px;">
                                            <asp:Label ID="lblTotWeight" runat="server" CssClass="lblColor"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="20" style="padding-left: 4px;">
                                            <asp:Label ID="Label15" runat="server" Text="Order Status:" CssClass="TabHead" Font-Bold="True"
                                                Width="80px"></asp:Label>
                                        </td>
                                        <td style="height: 20px;">
                                            <asp:Label ID="lblOrderStatus" runat="server" Text=""></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td height="20" style="padding-left: 4px;">
                                            <asp:Label ID="Label16" runat="server" Text="Ship Status:" CssClass="TabHead" Font-Bold="True"
                                                Width="80px"></asp:Label>
                                        </td>
                                        <td style="height: 20px;">
                                            <asp:Label ID="lblShipStatus" runat="server"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td height="20" style="padding-left: 4px;">
                                            <asp:Label ID="Label19" runat="server" Text="PO Status:" CssClass="TabHead" Font-Bold="True"
                                                Width="80px"></asp:Label>
                                        </td>
                                        <td style="height: 20px;">
                                            <asp:Label ID="lblPOStatus" runat="server" Text=""></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td height="20" style="padding-left: 4px;">
                                            <asp:Label ID="Label25" runat="server" Text="Expenses:" CssClass="TabHead" Font-Bold="True"
                                                Width="80px"></asp:Label>
                                        </td>
                                        <td style="height: 20px;">
                                            <asp:Label ID="lblExpenses" runat="server" Text=""></asp:Label>&nbsp;</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                
                <td class="longHeaderPanels" style="width: 100%">
                    <table id="tHeader2" runat="server" width="100%" cellspacing="0" cellpadding="3">
                        <tr>
                            <td   style="padding-left: 4px;" width="9%">
                                <asp:Label ID="Label1" runat="server" Text="Buyer:" Font-Bold="True" Width="80px"></asp:Label>
                            </td>
                            <td width="24%">
                                <asp:Label ID="lblBuyer" runat="server" Width="90px"></asp:Label>
                            </td>
                            
                            <td style="padding-left: 4px;" width="9%">
                                <asp:Label ID="Label3" runat="server" Text="Carrier:" Font-Bold="True" Width="80px"></asp:Label>
                            </td>
                            <td width="24%">
                                <asp:Label ID="lblCarrier" runat="server" Width="90px"></asp:Label>
                            </td>
                           
                            <td style="padding-left: 4px;" width="9%">
                                <asp:Label ID="Label11" runat="server" Text=" Schd Rept Dt:" Font-Bold="True" ></asp:Label>
                            </td>
                            <td width="8%">
                                <asp:Label ID="lblSchdReptDt" runat="server" Width="90px"></asp:Label>
                            </td>
                           
                            <td style="padding-left: 4px;" width="9%">
                                <asp:Label ID="Label4" runat="server" Text="Complete Dt:" Font-Bold="True"  ></asp:Label>
                            </td>
                            <td width="9%">
                                <asp:Label ID="lblCompleteDt" runat="server" Width="90px"></asp:Label>
                            </td>
                          
                        </tr>
                        <tr>
                            <td style="padding-left: 4px;">
                                <asp:Label ID="Label5" runat="server" Text=" Ref Type:" Font-Bold="True" Width="80px"></asp:Label>
                            </td>
                            <td >
                                <asp:Label ID="lblRefType" runat="server" Width="90px"></asp:Label>
                            </td>
                         
                            <td style="padding-left: 4px; " >
                                <asp:Label ID="Label7" runat="server" Text="ShipMethod:" Font-Bold="True" Width="80px"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblShipMethod" runat="server" Width="90px"></asp:Label>
                            </td>
                           
                            <td style="padding-left: 4px;">
                                <asp:Label ID="Label8" runat="server" Text="Schd Ship Dt:" Font-Bold="True" Width="100px"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblSchdShipDt" runat="server" Width="90px"></asp:Label>
                            </td>
                           
                            <td style="padding-left: 4px;">
                                <asp:Label ID="Label9" runat="server" Text="Receipt Dt:" Font-Bold="True" Width="60px"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblReceiptDt" runat="server" Width="90px"></asp:Label>
                            </td>
                           
                        </tr>
                        <tr>
                            <td style="padding-left: 4px;">
                                <asp:Label ID="Label10" runat="server" Text="References:" Font-Bold="True" Width="80px"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblReferences" runat="server" Width="90px"></asp:Label>
                            </td>
                           
                            <td style="padding-left: 4px;">
                                <asp:Label ID="Label13" runat="server" Text="Terms:" Font-Bold="True" Width="100px"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblTerms" runat="server" Width="150px"></asp:Label>
                            </td>
                            
                            <td style="padding-left: 4px;">
                                <asp:Label ID="Label14" runat="server" Text="PO Print Dt:" Font-Bold="True" Width="100px"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblPOPrintDt" runat="server" Width="90px"></asp:Label>
                            </td>
                           
                            <td style="padding-left: 4px;">
                                <asp:Label ID="Label17" runat="server" Text="Received By:" Font-Bold="True" Width="100px"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblReceivedBy" runat="server" Width="90px"></asp:Label>
                            </td>
                           
                        </tr>
                        <tr>
                            <td style="padding-left: 4px; "  >
                                <asp:Label ID="Label18" runat="server" Text="Confirming:" Font-Bold="True" Width="80px"></asp:Label>
                            </td>
                            <td  colspan=3>
                                <asp:Label ID="lblConfirming" runat="server" Width="90px"></asp:Label>
                            </td>  
                            <td style=" padding-left: 4px; ">
                                <asp:Label ID="Label20" runat="server" Text="Delete Dt:" Font-Bold="True" Width="100px"></asp:Label></td>
                            <td >
                                 
                                <asp:Label ID="lblDeleteDt" runat="server" Width="100%"></asp:Label></td>
                          
                            <td style="  padding-left: 4px; " >
                                 <asp:Label ID="Label21" runat="server" Text="Entry ID:" Font-Bold="True" Width="100%"></asp:Label></td>
                            <td  >
                                 <asp:Label ID="lblEntryID" runat="server" Width="100%"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 4px;" colspan=2>
                                <asp:Label ID="Label26" runat="server" Text="Shipping Instructions:" Font-Bold="True"
                                    Width="125px"></asp:Label>
                            </td>
                            <td style="width: 100px" colspan=6>
                                <asp:Label ID="lblShipInstructions" runat="server" Width="90px"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
               
            <tr>
                <td valign="top">
                    <asp:DataList ID="dlCommentTop" runat="server" Style="background-color: White; padding-top: 3px;
                        padding-bottom: 3px; font-style: italic; font-weight: bold;">
                        <ItemTemplate>
                            <%# DataBinder.Eval(Container, "DataItem.CommText") %>
                        </ItemTemplate>
                        <ItemStyle CssClass="locked" />
                    </asp:DataList>
                    <asp:GridView UseAccessibleHeader="false" PagerSettings-Visible="false" PageSize="17"
                                                Width="1100px" ID="gvRecallGird" runat="server" AllowPaging="false" ShowHeader="true"
                                                ShowFooter="true" AllowSorting="false" AutoGenerateColumns="false" OnRowDataBound="gvRecallGird_RowDataBound">
                                                <HeaderStyle HorizontalAlign="center" CssClass="GridHead" Font-Bold="true" BackColor="#DFF3F9" />
                                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                                <RowStyle CssClass="itemShade" Wrap="False" BackColor="#FFFFFF" Height="25px" BorderWidth="1px" />
                                                <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="25px" BorderWidth="1px" />
                                                <Columns>
                                                    <asp:BoundField HeaderText="PFC Item#" DataField="ItemNo" DataFormatString="{0:MM/dd/yy}"
                                                        SortExpression="ItemNo" ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="120px" />
                                                        <FooterStyle HorizontalAlign="Right" />
                                                        <HeaderStyle HorizontalAlign="center" Width="120px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HtmlEncode="false" HeaderText="Vendor Item#" DataField="VendorItemNo"
                                                        SortExpression="VendorItemNo">
                                                        <ItemStyle HorizontalAlign="Center" Width="120px" Wrap="False" />
                                                        <FooterStyle HorizontalAlign="Right" />
                                                        <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="120px" />
                                                    </asp:BoundField>
                                                    <asp:TemplateField HeaderText="Description">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblLineNo" Visible="false" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.POLineNo") %>'></asp:Label>
                                                            <asp:Label ID="lblDesc" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.ItemDesc") %>'></asp:Label>
                                                            <div style="padding-top: 3px; padding-bottom: 3px; padding-left: 10px; padding-right: 5px;
                                                                font-style: italic; font-weight: bold;">
                                                                <asp:DataList ID="dlComment" runat="server">
                                                                 <ItemStyle BorderWidth=0 />
                                                                 <AlternatingItemStyle BorderWidth=0 />
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblComment" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.CommText") %>'></asp:Label>
                                                                    </ItemTemplate>
                                                                </asp:DataList>
                                                            </div>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="300px" HorizontalAlign="left" />
                                                        <HeaderStyle HorizontalAlign=center />
                                                    </asp:TemplateField>
                                                    <asp:BoundField HtmlEncode="false" DataField="QtyOrdered" HeaderText="Order Qty"
                                                        SortExpression="QtyOrdered" DataFormatString="{0:#,##0}" >
                                                        <ItemStyle HorizontalAlign="Center" Width="25px" Wrap="False" />
                                                        <FooterStyle HorizontalAlign="Right" />
                                                        <HeaderStyle Wrap="False" HorizontalAlign="Left" Width="25px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HtmlEncode="false" DataField="CostUM" HeaderText="Cost/UM" SortExpression="CostUM"
                                                        DataFormatString="{0:#,##0.00}">
                                                        <ItemStyle HorizontalAlign="Right" Width="30px" />
                                                        <FooterStyle HorizontalAlign="Center" />
                                                        <HeaderStyle Wrap="True" HorizontalAlign="Center" Width="30px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HtmlEncode="false" DataField="ExtendedCost" HeaderText="Extended Cost"
                                                        ItemStyle-HorizontalAlign="Center" SortExpression="ExtendedCost" DataFormatString="{0:#,##0.00}">
                                                        <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                                        <FooterStyle HorizontalAlign="Center" />
                                                        <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HtmlEncode="false" DataField="ExtendedWeight" HeaderText="Extended Weight"
                                                        ItemStyle-HorizontalAlign="Center" SortExpression="ExtendedWeight" DataFormatString="{0:#,##0.00}">
                                                        <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                                        <FooterStyle HorizontalAlign="Center" />
                                                        <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HtmlEncode="false" DataField="ReceivingLocation" HeaderText="Ship Loc"
                                                        SortExpression="ReceivingLocation" >
                                                        <ItemStyle HorizontalAlign="Center" Width="25px" Wrap="False" />
                                                        <FooterStyle HorizontalAlign="Left" />
                                                        <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="25px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HtmlEncode="false" DataField="ScheduledReceiptDt" HeaderText="Schd Rcpt Dt"
                                                        SortExpression="ScheduledReceiptDt" DataFormatString="{0:MM/dd/yyyy}">
                                                        <ItemStyle HorizontalAlign="Center" Width="90px" Wrap="False" />
                                                        <FooterStyle HorizontalAlign="Right" />
                                                        <HeaderStyle Wrap="False" HorizontalAlign="right" Width="90px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HtmlEncode="false" DataField="ScheduledShipDt" HeaderText="Schd Ship Dt"
                                                        DataFormatString="{0:MM/dd/yyyy}" SortExpression="ScheduledShipDt">
                                                        <ItemStyle HorizontalAlign="Center" Width="90px" Wrap="False" />
                                                        <FooterStyle HorizontalAlign="Right" />
                                                        <HeaderStyle Wrap="False" HorizontalAlign="right" Width="90px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HtmlEncode="false" DataField="POLineStatus" HeaderText="Status" SortExpression="POLineStatus">
                                                        <ItemStyle HorizontalAlign="center" Width="40px" Wrap="true" />
                                                        <FooterStyle HorizontalAlign="Left" />
                                                        <HeaderStyle Wrap="False" HorizontalAlign="right" Width="40px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HtmlEncode="false" DataField="BaseQtyUM" HeaderText="Base Qty/UOM"
                                                        DataFormatString="{0:#,##0}" SortExpression="BaseQtyUM">
                                                        <ItemStyle HorizontalAlign="Right" Width="35px" Wrap="true" />
                                                        <FooterStyle HorizontalAlign="Right" />
                                                        <HeaderStyle Wrap="False" HorizontalAlign="right" Width="35px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HtmlEncode="false" DataField="SuperEquivQty" HeaderText="Super Eqv"
                                                         SortExpression="SuperEquivQty" DataFormatString="{0:#,##0}">
                                                        <ItemStyle HorizontalAlign="Right" Width="25px" Wrap="true" />
                                                        <FooterStyle HorizontalAlign="Right" />
                                                        <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="25px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HtmlEncode="false" DataField="TransitDays" HeaderText="Transist Days"
                                                        SortExpression="TransitDays">
                                                        <ItemStyle HorizontalAlign="Center" Width="50px" Wrap="False" />
                                                        <FooterStyle HorizontalAlign="Right" />
                                                        <HeaderStyle Wrap="true" HorizontalAlign="Center" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HtmlEncode="false" DataField="POLineNo" HeaderText="Line No" SortExpression="POLineNo">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" Wrap="False" />
                                                        <FooterStyle HorizontalAlign="Right" />
                                                        <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="50px" />
                                                    </asp:BoundField>
                                                </Columns>
                                            </asp:GridView>
                    <asp:DataList ID="dlCommentBtm" runat="server" Style="background-color: White; padding-top: 3px;
                        padding-bottom: 3px; font-style: italic; font-weight: bold;">
                        <ItemTemplate>
                            <%# DataBinder.Eval(Container, "DataItem.CommText") %>
                        </ItemTemplate>
                        <ItemStyle CssClass="locked" />
                    </asp:DataList>
                    <input id="Hidden1" type="hidden" name="Hidden1" runat="server" />
                    <asp:Label ID="lblMsg" ForeColor="Red" Font-Bold="true" Style="text-align: right;
                        font-size: 12px; vertical-align: middle; height: 25px" runat="server" Width="491px"></asp:Label>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
