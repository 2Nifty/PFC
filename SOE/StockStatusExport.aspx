<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StockStatusExport.aspx.cs"
    Inherits="StockStatusExport" %>

<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Stock Status Document</title>

    <script>
    function SetHeight()
    { 
        var DetailGridPanel = document.getElementById("SSGridView")
        var TBLControl = document.getElementById("SSTotalTable");
        if (TBLControl != null && DetailGridPanel != null)
        {
            TotQty = 0;
            RemBrCount = 0;
            var TotCells = TBLControl.getElementsByTagName("TD");
            var GridCells = DetailGridPanel.getElementsByTagName("TR")[0].getElementsByTagName("TD");
            for (var i = 0, il = TotCells.length-2; i <= il; i++)
            {
                var TotCell = TotCells[i];
                var GridCell = GridCells[i];
                TotCell.style.width =  (9.5 * (parseInt(GridCell.style.width, 10)/100)).toString() + "in";
                //TotCell.style.width = GridCell.style.width;
                //alert(GridCell.style.width);
            }
        }
    }
    
    function Paginate()
    {
        var DocTable = document.getElementById("DocTable");
        var pageHeader = document.getElementById("header");
        var pageNumCell = document.getElementById("pageNoCell");
        var pages = document.getElementById("NumberOfPages");
        pageNumCell.innerText = "1 of "+pages.value;
        if (DocTable != null)
        {
            var DocRows = DocTable.getElementsByTagName("TR");
            for (var i = 0, il = DocRows.length; i < il; i++)
            {
                if (DocRows[i].firstChild.id.substr(0,7) == 'XHeader')
                {
                    var PageNo = DocRows[i].firstChild.id.substr(7,3);
                    var newPageHeader = pageHeader.cloneNode(true);
                    newPageHeader.getElementsByTagName("TD")[11].innerText = PageNo +" of "+pages.value;
                    //alert(newPageHeader.getElementsByTagName("TD")[11].innerText);
                    DocRows[i].replaceChild(newPageHeader, DocRows[i].firstChild);
                    DocRows[i].firstChild.className = "newPage";
                }
            }
        }
    }
    

    </script>

    <style type="text/css">
/* */
.printPage
{
    width : 10.5in;
    height : 8in;
    font-size : 12px;
    font-family : Arial, sans-serif;
    size: landscape;
}
.docTitle
{
    font-size : 24px;
    font-style : italic;
    border-bottom : 1px solid black;
}
.pageHeader
{
}
.newPage
{
    page-break-before: always
}
/*#pageFooter
{
    page-break-before: always
}
#docFooter
{
    position:absolute;
    top:9in
}*/
.locName
{
    float : left;
    font-size : 18px;
    font-weight : bold;
    padding-top : 5px;
}
.locAddr
{
    float : left;
    clear : both;
}
.rightFloat
{
    float : right;
}
.bold
{
    font-weight: bold;
}
.newLine
{
    border-bottom : 1px solid black;
}
.rightCol
{
    border-right : 1px solid black;
}
.rightPad
{
    padding-right : 3px;
    text-align : right
}
.leftPad
{
    padding-left : 3px;
}
.bottomMessage
{
    font-size : 11px;
    font-family : Arial, sans-serif;
}
.quoteTotal
{
    font-size : 16px;
}
.invsible 
{
	display: none;
}
.rightBorder 
{
	border-right-width: 1px;
	border-right-style: solid;
	border-right-color: black;
}
.groupBorder 
{
	border-right-width: 3px;
	border-right-style: solid;
	border-right-color: black;
}
.hubGridLine
{
	border-right-width: 1px;
	border-right-style: solid;
	border-right-color: black;
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: black;
	color: #008000;
	font-weight: bold;
	margin-bottom: 2px;
}
.hubGroupBorder 
{
	border-right-width: 3px;
	border-right-style: solid;
	border-right-color: black;
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: black;
	color: #008000;
	font-weight: bold;
	margin-bottom: 2px;
}
.altGridLine
{
	background-color: white;
}

</style>
</head>
<body style="margin: 0px;" onload="SetHeight();">
    <form id="form1" runat="server">
        <div class="printPage">
            <table cellspacing="0" cellpadding="2" class="panelborder">
                <tr>
                    <td align="right" class="bold">
                        Item Number
                    </td>
                    <td>
                        <asp:Label CssClass="ws_whitebox_left" ID="ItemNoLabel" runat="server" Width="100px"
                            TabIndex="1" onfocus="javascript:this.select();" onkeypress="javascript:if(event.keyCode==13){ZItem(this.value);}"></asp:Label>&nbsp;
                    </td>
                </tr>
            </table>
            <asp:Panel ID="HeaderPanel" runat="server" Height="100px" Width="100%">
                <table width="100%" border="0" cellspacing="2" cellpadding="1">
                    <col width="9%" />
                    <col width="16%" />
                    <col width="8%" />
                    <col width="6%" />
                    <col width="9%" />
                    <col width="7%" />
                    <col width="10%" />
                    <col width="6%" />
                    <col width="8%" />
                    <col width="8%" />
                    <col width="8%" />
                    <col width="5%" />
                    <tr>
                        <td class="bold" align="right">
                            Description:
                        </td>
                        <td>
                            <asp:Label ID="ItemDescLabel" runat="server" Text="" CssClass="ws_data_left" Width="180px">
                            </asp:Label>
                        </td>
                        <td class="bold" align="right">
                            Weight/100:
                        </td>
                        <td>
                            <asp:Label CssClass="ws_data_right bold" ID="Wgt100Label" runat="server" Text=""
                                Width="50px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                            Sell Stock:
                        </td>
                        <td>
                            <asp:Label CssClass="ws_data_right bold" ID="QtyUOMLabel" runat="server" Text=""
                                Width="50px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                            Std Cost:
                        </td>
                        <td>
                            <asp:Label CssClass="ws_data_right bold" ID="StdCostLabel" runat="server" Text=""
                                Width="50px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                            UPC Code:
                        </td>
                        <td>
                            <asp:Label ID="UPCLabel" runat="server" CssClass="ws_data_right bold" Text="" Width="80px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                            Web OK:
                        </td>
                        <td>
                            <asp:Label ID="WebLabel" runat="server" CssClass="ws_data_right bold" Text="" Width="30px"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="bold" align="right">
                            Category:
                        </td>
                        <td>
                            <asp:Label ID="CategoryLabel" runat="server" Text="" CssClass="ws_data_left" Width="180px">
                            </asp:Label>
                        </td>
                        <td class="bold" align="right">
                            Net LB:
                        </td>
                        <td>
                            <asp:Label CssClass="ws_data_right bold" ID="NetWghtLabel" runat="server" Text=""
                                Width="50px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                            Super Eqv:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="SuperEqLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                            List Price:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="ListLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                            Tariff:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="HarmCodeLabel" runat="server" Text="" Width="80px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                            Pkg Grp:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="PackGroupLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="bold" align="right">
                            Plating Type:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_left" ID="PlatingLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                            Gross LB:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="GrossWghtLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                            Price UM:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="PriceUMLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                            Corp Fixed Vel.:
                        </td>
                        <td class="bold">
                            <asp:Label ID="CFVLabel" runat="server" CssClass="ws_data_right" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                            PPI Code:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="PPILabel" runat="server" Text="" Width="80px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                        Low Profile:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="LowProfileLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="bold" align="right">
                            Parent Item:
                        </td>
                        <td class="bold">
                            <a id="ParentLink" onclick="OpenParent();">
                                <asp:Label ID="ParentLabel" runat="server" Text="" CssClass="ws_data_left" Width="100px">
                                </asp:Label>
                            </a>
                        </td>
                        <td class="bold" align="right">
                            Stock Ind:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="StockLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                            Cost UM:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="CostUMLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                            Category Vel.:
                        </td>
                        <td class="bold">
                            <asp:Label ID="CatVelLabel" runat="server" CssClass="ws_data_right" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                            Created:
                        </td>
                        <td class="bold">
                            <asp:Label ID="CreatedLabel" runat="server" CssClass="ws_data_right" Text="" Width="80px"></asp:Label>
                        </td>
                        <td class="bold" align="right">
                            Pkg Vel.:
                        </td>
                        <td class="bold">
                            <asp:Label ID="PkgVelLabel" runat="server" CssClass="ws_data_right" Text="" Width="50px"></asp:Label>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Table ID="SSHeadingTable" runat="server" CellPadding="0" CellSpacing="0" Width="100%"
                CssClass="GridHeads">
                <asp:TableRow CssClass="bold" Width="100%">
                    <asp:TableCell Width="4%" HorizontalAlign="center">Loc.</asp:TableCell>
                    <asp:TableCell Width="4%" HorizontalAlign="center">30D</asp:TableCell>
                    <asp:TableCell Width="4%" HorizontalAlign="center">Sales</asp:TableCell>
                    <asp:TableCell Width="4%" HorizontalAlign="center">90Day</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="25%" ColumnSpan="5">CURRENT QUANTITY</asp:TableCell>
                    <asp:TableCell ColumnSpan="5" HorizontalAlign="center" Width="25%">FUTURE QUANTITY</asp:TableCell>
                    <asp:TableCell Width="5%" HorizontalAlign="center">Cat.</asp:TableCell>
                    <asp:TableCell ColumnSpan="5" HorizontalAlign="center" Width="25%">COST</asp:TableCell>
                    <asp:TableCell Width="3%" HorizontalAlign="center">Stock</asp:TableCell>
                    <asp:TableCell Width="2%">&nbsp;</asp:TableCell>
                </asp:TableRow>
                <asp:TableRow CssClass="bold" Width="100%">
                    <asp:TableCell HorizontalAlign="center" Width="4%">Code</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="4%">Usage</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="4%">Vel.</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="4%">ROP</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Avail.</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Sales</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Trans</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Back Ord</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">On Hand</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Purch</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">On Water</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Prod.</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Return</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Tr. In</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Vel.</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Avg.</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Last</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Stndrd</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Replace</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Avg.</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="3%">Ind</asp:TableCell>
                    <asp:TableCell Width="2%">&nbsp;</asp:TableCell>
                </asp:TableRow>
            </asp:Table>
            <asp:Panel ID="DetailPanel" runat="server" Width="100%" ScrollBars="none" BorderWidth="0">
                <asp:GridView ID="SSGridView" runat="server" AutoGenerateColumns="false" BackColor="#f4fbfd"
                    OnRowDataBound="SSLineFormat" Width="98%" ShowHeader="false" CssClass="bold">
                    <AlternatingRowStyle BackColor="#FFFFFF" />
                    <Columns>
                        <asp:BoundField HeaderText="Location Code" DataField="LocID" SortExpression="LocID"
                            ItemStyle-CssClass="rightBorder" ItemStyle-Width="4%" ItemStyle-HorizontalAlign="center">
                        </asp:BoundField>
                        <asp:BoundField HeaderText="30D Use" DataField="Use30D" SortExpression="Use30D" ItemStyle-Wrap="false"
                            HtmlEncode="false" ItemStyle-Width="4%" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="rightBorder"></asp:BoundField>
                        <asp:BoundField HeaderText="SV" DataField="SVCode" SortExpression="SVCode" ItemStyle-Wrap="false"
                            ItemStyle-CssClass="rightBorder" ItemStyle-Width="4%" ItemStyle-HorizontalAlign="center">
                        </asp:BoundField>
                        <asp:BoundField HeaderText="90Day ROP" DataField="ROP" SortExpression="ROP" ItemStyle-Wrap="false"
                            HtmlEncode="false" ItemStyle-Width="4%" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="groupBorder"></asp:BoundField>
                        <asp:BoundField HeaderText="Available" DataField="Avail" SortExpression="Avail" ItemStyle-Wrap="false"
                            HtmlEncode="false" ItemStyle-Width="5%" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="rightBorder"></asp:BoundField>
                        <asp:TemplateField ItemStyle-Width="5%" HeaderText="Alloc Sales" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="Sales" ItemStyle-CssClass="rightBorder">
                            <ItemTemplate>
                                <asp:Label ID="SalesLabel" runat="server" Text='<%# Eval("Sales", "{0:#,##0} ") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="5%" HeaderText="Alloc Trans" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="TransOut" ItemStyle-CssClass="rightBorder">
                            <ItemTemplate>
                                <asp:Label ID="TransOutLabel" runat="server" Text='<%# Eval("TransOut", "{0:#,##0} ") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="5%" HeaderText="BackOrders" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="TransOut" ItemStyle-CssClass="rightBorder">
                            <ItemTemplate>
                                <asp:Label ID="BackLabel" runat="server" Text='<%# Eval("Back", "{0:#,##0} ") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField HeaderText="On Hand" DataField="QOH" SortExpression="QOH" ItemStyle-Wrap="false"
                            HtmlEncode="false" ItemStyle-Width="5%" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="groupBorder"></asp:BoundField>
                        <asp:TemplateField ItemStyle-Width="5%" HeaderText="Purch Ord" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="PO" ItemStyle-CssClass="rightBorder">
                            <ItemTemplate>
                                <asp:Label ID="POLabel" runat="server" Text='<%# Eval("PO", "{0:#,##0} ") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="5%" HeaderText="On Water" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="OTW" ItemStyle-CssClass="rightBorder">
                            <ItemTemplate>
                                <asp:Label ID="OTWLabel" runat="server" Text='<%# Eval("OTW", "{0:#,##0} ") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="5%" HeaderText="Prod Ord" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="WO" ItemStyle-CssClass="rightBorder">
                            <ItemTemplate>
                                <asp:Label ID="WOLabel" runat="server" Text='<%# Eval("WO", "{0:#,##0} ") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="5%" HeaderText="Return Ord" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="RO" ItemStyle-CssClass="rightBorder">
                            <ItemTemplate>
                                <asp:Label ID="ROLabel" runat="server" Text='<%# Eval("RO", "{0:#,##0} ") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="5%" HeaderText="Tr. In" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="TransIn" ItemStyle-CssClass="groupBorder">
                            <ItemTemplate>
                                <asp:Label ID="TransInLabel" runat="server" Text='<%# Eval("TransIn", "{0:#,##0} ") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField HeaderText="Category Velocity" DataField="CatVCode" SortExpression="CatVCode"
                            ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-Width="5%" ItemStyle-HorizontalAlign="center"
                            ItemStyle-CssClass="groupBorder"></asp:BoundField>
                        <asp:BoundField HeaderText="Average" DataField="SellAvgGlued" SortExpression="SellAvgCost"
                            ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-Width="5%" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="rightBorder"></asp:BoundField>
                        <asp:BoundField HeaderText="Last" DataField="SellLastGlued" SortExpression="SellLastCost"
                            ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-Width="5%" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="rightBorder"></asp:BoundField>
                        <asp:BoundField HeaderText="Stndrd" DataField="SellStdGlued" SortExpression="SellStdCost"
                            ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-Width="5%" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="rightBorder"></asp:BoundField>
                        <asp:BoundField HeaderText="Replace" DataField="SellReplGlued" SortExpression="SellReplCost"
                            ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-Width="5%" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="rightBorder"></asp:BoundField>
                        <asp:BoundField HeaderText="Average" DataField="AvgGlued" SortExpression="AvgCost"
                            ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-Width="5%" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="groupBorder"></asp:BoundField>
                        <asp:BoundField HeaderText="Stock Ind" DataField="Stocked" SortExpression="Stocked"
                            ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-Width="3%" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="rightBorder"></asp:BoundField>
                        <asp:BoundField HeaderText="Line Color" DataField="IMDisplayColor" SortExpression="IMDisplayColor"
                            ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="invsible">
                        </asp:BoundField>
                    </Columns>
                </asp:GridView>
                <asp:Table ID="SSTotalTable" runat="server" CellPadding="2" CellSpacing="0" Width="98%">
                    <asp:TableRow CssClass="bold totals">
                        <asp:TableCell HorizontalAlign="center">Total</asp:TableCell>
                        <asp:TableCell HorizontalAlign="right">
                            <asp:Label ID="UsageTotLabel" runat="server"></asp:Label></asp:TableCell>
                        <asp:TableCell HorizontalAlign="center">&nbsp;</asp:TableCell>
                        <asp:TableCell HorizontalAlign="right">
                            <asp:Label ID="ROPTotLabel" runat="server"></asp:Label></asp:TableCell>
                        <asp:TableCell HorizontalAlign="right">
                            <asp:Label ID="AvailTotLabel" runat="server"></asp:Label></asp:TableCell>
                        <asp:TableCell HorizontalAlign="right">
                            <asp:Label ID="SalesTotLabel" runat="server"></asp:Label></asp:TableCell>
                        <asp:TableCell HorizontalAlign="right">
                            <asp:Label ID="TransOutTotLabel" runat="server"></asp:Label></asp:TableCell>
                        <asp:TableCell HorizontalAlign="right">
                            <asp:Label ID="BackTotLabel" runat="server"></asp:Label></asp:TableCell>
                        <asp:TableCell HorizontalAlign="right">
                            <asp:Label ID="QOHTotLabel" runat="server"></asp:Label></asp:TableCell>
                        <asp:TableCell HorizontalAlign="right">
                            <asp:Label ID="PurchTotLabel" runat="server"></asp:Label></asp:TableCell>
                        <asp:TableCell HorizontalAlign="right">
                            <asp:Label ID="OTWTotLabel" runat="server"></asp:Label></asp:TableCell>
                        <asp:TableCell HorizontalAlign="right">
                            <asp:Label ID="ProdTotLabel" runat="server"></asp:Label></asp:TableCell>
                        <asp:TableCell HorizontalAlign="right">
                            <asp:Label ID="ReturnTotLabel" runat="server"></asp:Label></asp:TableCell>
                        <asp:TableCell HorizontalAlign="right">
                            <asp:Label ID="TransInTotLabel" runat="server"></asp:Label></asp:TableCell>
                        <asp:TableCell ColumnSpan="7">&nbsp;</asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
                <table>
                    <tr>
                        <td colspan="2">
                            <asp:Label ID="CategorySpecLabel" runat="server" CssClass="bold"></asp:Label>&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Image ID="HeadImage" runat="server" Height="75" />
                        </td>
                        <td>
                            <asp:Image ID="BodyImage" runat="server" Height="75" />
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
