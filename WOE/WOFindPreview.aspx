<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WOFindPreview.aspx.cs" Inherits="WOFindPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>WO Find Print Preview</title>

    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        .zebra td
            {padding-right: 0px;}

        .gridItem
            {padding-right: 0px;}

        .txtCenter
            {horizontal-align: center;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr valign="top">
                <td style="height: 314px">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr>
                            <td class="PageHead" valign="middle">
                                    <div align="left" class="LeftPadding">
                                       <span style="font-size: 16px;font-weight: bold;color: #3A3A56;">WO Find Report</span></div>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" class="PageBg" height="25px" width="1125px">
                                <table border="0" class="TabHead" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
<%--                                        <td style="width: 60px">
                                            <asp:Label ID="Label3" runat="server" Text="Category:" Width="60px"></asp:Label></td>
                                        <td style="width: 50px" align="left">
                                            <asp:Label Font-Bold="false" ID="lblCategory" runat="server" Width="50px"></asp:Label></td>
                                        <td style="width: 35px">
                                            <asp:Label ID="Label4" runat="server" Text="Size:" Width="35px"></asp:Label></td>
                                        <td style="width: 45px" align="left">
                                            <asp:Label Font-Bold="false" ID="lblSize" runat="server" Width="45px"></asp:Label></td>
                                        <td style="width: 60px">
                                            <asp:Label ID="Label5" runat="server" Text="Variance:" Width="60px"></asp:Label></td>
                                        <td style="width: 45px" align="left">
                                            <asp:Label Font-Bold="false" ID="lblVariance" runat="server" Width="45px"></asp:Label></td>--%>

<%--                                        <td colspan="1" rowspan="2" valign="middle">
                                            <table width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td align="left" class=TabHead>
                                                        <span class=LeftPadding>Run Date :
                                                            <%=DateTime.Now.Month%>/<%=DateTime.Now.Day%>/<%=DateTime.Now.Year%></span></td>
                                                </tr>
                                            </table>
                                        </td>--%>
                                        <td align="center"><asp:Label ID="lblLegend" runat="server" CssClass="txtCenter"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td valign="top" width="100%">
                                            <asp:DataGrid ID="dgFind" Width="1125px" runat="server" BorderWidth="1px" BorderColor="#DAEEEF" Style="height: auto;"
                                                ShowHeader="true" AutoGenerateColumns="False">
                                                <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" BackColor="#DFF3F9" />
                                                <ItemStyle CssClass="GridItem" />
                                                <AlternatingItemStyle CssClass="zebra" />
                                                <Columns>
                                                    <asp:BoundColumn HeaderStyle-Width="85px" HeaderText="Order No" DataField="POOrderNo"
                                                                     ItemStyle-Width="85px" ItemStyle-HorizontalAlign="Center">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="75px" HeaderText="PO Type"
                                                                     ItemStyle-Width="75px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="POType">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="40px" HeaderText="Loc"
                                                                     ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="LocationCd">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="90px" HeaderText="Item No"
                                                                     ItemStyle-Width="90px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="ItemNo">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="300px" HeaderText="Item Desc"
                                                                     ItemStyle-Width="300px" ItemStyle-HorizontalAlign="Left"
                                                                     DataField="ItemDesc">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="60px" HeaderText="Mfg Qty"
                                                                     ItemStyle-Width="60px" ItemStyle-HorizontalAlign="Right"
                                                                     DataField="QtyOrdered" DataFormatString="{0:#,##0}">
                                                    </asp:BoundColumn>
                                                    
                                                    <asp:BoundColumn HeaderStyle-Width="40px" HeaderText="UM"
                                                                     ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="BaseQtyUM">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="65px" HeaderText="SO Ref No" DataField="SORefNo"
                                                                     ItemStyle-Width="65px" ItemStyle-HorizontalAlign="Center">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="125px" HeaderText="User Id"
                                                                     ItemStyle-Width="125px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="UserId">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="75px" HeaderText="Order Dt"
                                                                     ItemStyle-Width="75px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="OrderDt" DataFormatString="{0:MM/dd/yyyy}">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="75px" HeaderText="Pick Sheet Dt"
                                                                     ItemStyle-Width="75px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="PickSheetDt" DataFormatString="{0:MM/dd/yyyy}">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="75px" HeaderText="Due Dt"
                                                                     ItemStyle-Width="75px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="RequestedReceiptDt" DataFormatString="{0:MM/dd/yyyy}">
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn HeaderStyle-Width="60px" HeaderText="Routing"
                                                                     ItemStyle-Width="60px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="RoutingDesc">
                                                    </asp:BoundColumn>
                                                </Columns>
                                            </asp:DataGrid>
                                            <asp:HiddenField ID="hidFilter" runat="server" />
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
</body>
</html>
