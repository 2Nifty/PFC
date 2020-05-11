<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PackingAndPlatingExport.aspx.cs" Inherits="ShowPackingAndPlatingExport" %>
<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialog" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Packing & Plating Options V1.0.0</title>
    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>
    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/PriceSheetStyles.css" rel="stylesheet" type="text/css" />
    <!-- Used to include print style sheet -->
    <%= PFC.SOE.DataAccessLayer.Global.PrintStyleSheet %>
</head>
<body >
    <form id="form1" runat="server">
    <div class=LandscapeDiv >  
        <div id="SheetContainer~|">
        <table width="400px" class="PageBg" >
            <tr>
                <td class="Left5pxPadd">
                    <table width="395px" style="border:1px solid #88D2E9; ">
                        <tr>
                            <td class="Left5pxPadd" valign="top">
                                <table>
                                    <tr>
                                        <td class="bold" Width="100px">Requested Item:
                                        </td>
                                        <td colspan="3">
                                            <asp:Label CssClass="ws_whitebox_left" ID="ItemNoTextBox" runat="server" Text="" Width="80px"
                                            ></asp:Label>
                                            <asp:HiddenField ID="ItemPromptInd" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bold" >
                                            Requested Location:
                                        </td>
                                        <td  colspan="3">
                                            <asp:Label CssClass="ws_whitebox_left" ID="ReqLocTextBox" runat="server" Text="" Width="60"
                                            TabIndex=2 ></asp:Label>
                                            <asp:HiddenField ID="HasProcessed" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bold">
                                            Requested Quantity:
                                        </td>
                                        <td align="right">
                                            <asp:Label CssClass="ws_whitebox" ID="ReqQtyLabel" runat="server" Text="" Width="60"></asp:Label>
                                            <asp:HiddenField ID="ReqQtyHidden" runat="server" />
                                        </td>
                                        <td class="bold">
                                            Alt Qty:
                                        </td>
                                        <td align="right">
                                            <asp:Label CssClass="ws_whitebox" ID="AltQtyLabel" runat="server" Text="" Width="60"></asp:Label>
                                            <asp:HiddenField ID="AltQtyHidden" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bold">
                                            Requested Available:
                                        </td>
                                        <td align="right">
                                            <asp:Label CssClass="ws_whitebox" ID="ReqAvailLabel" runat="server" Text="" Width="60"></asp:Label>
                                            <asp:HiddenField ID="ReqAvailHidden" runat="server" />
                                        </td>
                                        <td class="bold">
                                            Alt Available:
                                        </td>
                                        <td align="right">
                                            <asp:Label CssClass="ws_whitebox" ID="AltAvailLabel" runat="server" Text="" Width="60"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="Left5pxPadd" align="left" valign="middle">
                    <asp:Panel ID="ImagePanel" runat="server" Height="250px" Width="380px" style="border:1px solid #88D2E9; background-color:#FFFFFF" 
                     ScrollBars="Vertical" >
                        <asp:GridView ID="PackPlateGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                         Width="90%" RowStyle-CssClass="priceDarkLabel">
                        <AlternatingRowStyle CssClass="priceLightLabel" />
                        <Columns>
                        <asp:BoundField DataField="SubItem" HeaderText="Item #" 
                            ItemStyle-HorizontalAlign="center" HeaderStyle-HorizontalAlign="Center"/>
                        <asp:BoundField DataField="QOH" HeaderText="Available" DataFormatString="{0:#,##0} " 
                            ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="70"/>
                        <asp:BoundField DataField="AltQOH" HeaderText="Total Pcs" DataFormatString="{0:#,##0} " 
                            ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="70"/>
                        <asp:BoundField DataField="SellGlued" HeaderText="Qty/Unit"  ItemStyle-Width="70"
                            ItemStyle-HorizontalAlign="center" HeaderStyle-HorizontalAlign="Center"/>
                        <asp:BoundField DataField="Plate" HeaderText="Plate" 
                            ItemStyle-HorizontalAlign="center" HeaderStyle-HorizontalAlign="Center"/>
                        </Columns>
                        </asp:GridView>
                    </asp:Panel>
                </td>
            </tr>
       </table>
    </div>
    </div>
    </form>
</body>
</html>
