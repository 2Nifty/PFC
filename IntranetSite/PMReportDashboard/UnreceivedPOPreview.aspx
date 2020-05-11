<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UnreceivedPOPreview.aspx.cs" Inherits="UnreceivedPOPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Unreceived PO Report</title>
    
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
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
                                       <span style="font-size: 16px;font-weight: bold;color: #3A3A56;">Unreceived Purchase Orders By Category</span></div>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" class="PageBg" height="25px" width="1375px">
                                <table border="0" class="TabHead" cellpadding="0" cellspacing="0" width="100%">
                                    <tr valign="middle">
                                        <td style="width: 60px">
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
                                            <asp:Label Font-Bold="false" ID="lblVariance" runat="server" Width="45px"></asp:Label></td>
                                        <td colspan="1" rowspan="2" valign="middle">
                                            <table width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td align="right" class=TabHead>
                                                        <span class=LeftPadding>Run Date :
                                                            <%=DateTime.Now.Month%>/<%=DateTime.Now.Day%>/<%=DateTime.Now.Year%></span></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td valign="top" width="100%">

                                            <asp:DataGrid ID="dgUnrcvdPOCat" Width="1375px" runat="server" BorderWidth="1px" BorderColor="#DAEEEF" Style="height: auto;"
                                                ShowHeader="false" AutoGenerateColumns="False" OnItemDataBound="dgUnrcvdPOCat_ItemDataBound">
                                                    <Columns>
                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <asp:DataGrid ID="dgUnrcvdPODtl" BackColor="#F4FBFD" Width="1375px" runat="server" BorderWidth="1px" ShowFooter="True" AutoGenerateColumns="False" OnItemDataBound="dgUnrcvdPODtl_ItemDataBound">
                                                                    <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="gridHeader" />
                                                                    <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD" Height=18px />
                                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="White" Height=18px />
                                                                    <FooterStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Right" CssClass="gridHeader" />
                                                                    <Columns>
                                                                        <asp:BoundColumn HeaderText="Category Description" DataField="CatDesc">
                                                                            <HeaderStyle Width="315px" />
                                                                            <ItemStyle Width="315px" HorizontalAlign="Left" Wrap="False" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn HeaderText="Item Number" DataField="ItemNo">
                                                                            <HeaderStyle Width="100px" />
                                                                            <ItemStyle Width="100px" HorizontalAlign="Center" Wrap="False" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn HeaderText="Size" DataField="ItemSize">
                                                                            <HeaderStyle Width="200px" />
                                                                            <ItemStyle Width="200px" HorizontalAlign="Left" Wrap="False" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn HeaderText="Doc No" DataField="DocNo">
                                                                            <HeaderStyle Width="70px" />
                                                                            <ItemStyle Width="70px" HorizontalAlign="Center" Wrap="False" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn HeaderText="Status" DataField="POStatusCd">
                                                                            <HeaderStyle Width="40px" />
                                                                            <ItemStyle Width="40px" HorizontalAlign="Center" Wrap="False" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn HeaderText="Vendor" DataField="VendorCd">
                                                                            <HeaderStyle Width="45px" />
                                                                            <ItemStyle Width="45px" HorizontalAlign="Center" Wrap="False" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn HeaderText="Loc" DataField="Loc">
                                                                            <HeaderStyle Width="30px" />
                                                                            <ItemStyle Width="30px" HorizontalAlign="Center" Wrap="False" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn HeaderText="--------- SE" DataField="QtySuperEquiv" DataFormatString="{0:n0}">
                                                                            <HeaderStyle Width="40px" />
                                                                            <ItemStyle Width="40px" HorizontalAlign="Right" Wrap="False" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn HeaderText="-- Qty -- ORD" DataField="QtyOrdered" DataFormatString="{0:n0}">
                                                                            <HeaderStyle Width="45px" />
                                                                            <ItemStyle Width="45px" HorizontalAlign="Right" Wrap="False" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn HeaderText="--------- RCVD" DataField="QtyReceived" DataFormatString="{0:n0}">
                                                                            <HeaderStyle Width="45px" />
                                                                            <ItemStyle Width="45px" HorizontalAlign="Right" Wrap="False" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn HeaderText="--------------- Requested" DataField="RequestedDt" DataFormatString="{0:MM/dd/yyyy}">
                                                                            <HeaderStyle Width="70px" />
                                                                            <ItemStyle Width="70px" HorizontalAlign="Center" Wrap="False" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn HeaderText="--- Dates --- Planned" DataField="PlannedRcptDt" DataFormatString="{0:MM/dd/yyyy}">
                                                                            <HeaderStyle Width="70px" />
                                                                            <ItemStyle Width="70px" HorizontalAlign="Center" Wrap="False" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn HeaderText="--------------- Expected" DataField="ExpectedDt" DataFormatString="{0:MM/dd/yyyy}">
                                                                            <HeaderStyle Width="70px" />
                                                                            <ItemStyle Width="70px" HorizontalAlign="Center" Wrap="False" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn HeaderText="Qty Due" DataField="QtyDue" DataFormatString="{0:n0}">
                                                                            <HeaderStyle Width="45px" />
                                                                            <ItemStyle Width="45px" HorizontalAlign="Right" Wrap="False" />
                                                                        </asp:BoundColumn>

                                                                        <asp:TemplateColumn HeaderText="Cost">
                                                                            <ItemTemplate>
                                                                                <asp:Label ID="lblCost" Width="80px" runat="server" CssClass="txtRight" Text="Cost"></asp:Label>
                                                                            </ItemTemplate>
                                                                            <ItemStyle Width="80px" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                                        </asp:TemplateColumn>

                                                                        <asp:BoundColumn HeaderText="Ext Cost" DataField="ExtendedCost">
                                                                            <HeaderStyle Width="80px" />
                                                                            <ItemStyle Width="80px" HorizontalAlign="Right" Wrap="False" />
                                                                        </asp:BoundColumn>
                                                                    </Columns>
                                                                </asp:DataGrid>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="1375px" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                <PagerStyle Visible="False" />
                                            </asp:DataGrid>

                                            <table id="tblGrdTotals" class="BluBordAll" border="0" cellspacing="0" cellpadding="0" runat="server" visible=false
                                              style="position: relative; top: 0px; left: 0px; height: 30px; border: 1px solid;">
                                                <tr style="border:1px solid #e1e1e1; background-color:#B3E2F0;">
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="311px"><tr><td>Grand Totals for all Categories ...</td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="99px"><tr><td>&nbsp</td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="198px"><tr><td><asp:Label ID="lblTotLines" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="72px"><tr><td>&nbsp</td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="41px"><tr><td>&nbsp</td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="47px"><tr><td>&nbsp</td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="32px"><tr><td>&nbsp</td></tr></table></td>
                                                    <%--<td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="43px"><tr><td>&nbsp</td></tr></table></td>--%>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="89px"><tr><td><asp:Label ID="lblTotQtyOrd" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="47px"><tr><td><asp:Label ID="lblTotQtyRcvd" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="71px"><tr><td>&nbsp</td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="72px"><tr><td>&nbsp</td></tr></table></td>
                                                    <%--<td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="74px"><tr><td>&nbsp</td></tr></table></td>--%>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="121px"><tr><td><asp:Label ID="lblTotQtyDue" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                                    <%--<td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="86px"><tr><td>&nbsp</td></tr></table></td>--%>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="165px"><tr><td><asp:Label ID="lblTotExtCost" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                                </tr>
                                            </table>
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
