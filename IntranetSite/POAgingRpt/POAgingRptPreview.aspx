<%@ Page Language="C#" AutoEventWireup="true" CodeFile="POAgingRptPreview.aspx.cs" Inherits="POAgingRptPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>PO Aging Trend Report</title>

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
                                       <span style="font-size: 16px;font-weight: bold;color: #3A3A56;">PO Aging Trend Report</span></div>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" class="PageBg" height="25px" width="2380px">
                                <table border="0" class="TabHead" cellpadding="0" cellspacing="0" width="100%">
                                    <tr valign="middle">
                                        <td valign="middle">
                                            <table width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td align="left" class="TabHead">
                                                        <span class="LeftPadding">Run Date :
                                                            <%=DateTime.Now.Month%>/<%=DateTime.Now.Day%>/<%=DateTime.Now.Year%></span></td>
                                                    <td align="right" class="TabHead">
                                                        <span class="LeftPadding">Run By :
                                                            <%=Session["UserName"].ToString() %></span></td>
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
                                            <asp:DataGrid ID="dgPOAging" BackColor="#F4FBFD" Width="2380px" runat="server" BorderWidth="1px" ShowFooter="false" AutoGenerateColumns="False" OnItemDataBound="dgPOAging_ItemDataBound">
                                                <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="gridHeader" />
                                                <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD" Height="18px" />
                                                <AlternatingItemStyle CssClass="GridItem" BackColor="White" Height="18px" />
                                                <FooterStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Right" CssClass="gridHeader" />
                                                <Columns>
                                                    <asp:BoundColumn HeaderText="Category Group" DataField="CatGroup">
                                                        <HeaderStyle Width="425px" />
                                                        <ItemStyle Width="425px" HorizontalAlign="Left" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Avg Use Lbs" DataField="AvgUseLbs" DataFormatString="{0:n0}">
                                                        <HeaderStyle Width="90px" />
                                                        <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Avl Lbs" DataField="AvlLbs" DataFormatString="{0:n0}">
                                                        <HeaderStyle Width="90px" />
                                                        <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>
                                                    
                                                    <asp:BoundColumn HeaderText="Avl Mos" DataField="AvlMos" DataFormatString="{0:n1}">
                                                        <HeaderStyle Width="50px" />
                                                        <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Trf Lbs" DataField="TrfLbs" DataFormatString="{0:n0}">
                                                        <HeaderStyle Width="90px" />
                                                        <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Trf Mos" DataField="TrfMos" DataFormatString="{0:n1}">
                                                        <HeaderStyle Width="50px" />
                                                        <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="OTW Lbs" DataField="OTWLbs" DataFormatString="{0:n0}">
                                                        <HeaderStyle Width="90px" />
                                                        <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="OTW Mos" DataField="OTWMos" DataFormatString="{0:n1}">
                                                        <HeaderStyle Width="55px" />
                                                        <ItemStyle Width="55px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="RTS Lbs" DataField="RTSLbs" DataFormatString="{0:n0}">
                                                        <HeaderStyle Width="90px" />
                                                        <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="RTS Mos" DataField="RTSMos" DataFormatString="{0:n1}">
                                                        <HeaderStyle Width="50px" />
                                                        <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="OO Lbs" DataField="OOLbs" DataFormatString="{0:n0}">
                                                        <HeaderStyle Width="90px" />
                                                        <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="OO Mos" DataField="OOMos" DataFormatString="{0:n1}">
                                                        <HeaderStyle Width="50px" />
                                                        <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Tot Lbs" DataField="TotalLbs" DataFormatString="{0:n0}">
                                                        <HeaderStyle Width="90px" />
                                                        <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Tot Mos" DataField="TotalMos" DataFormatString="{0:n1}">
                                                        <HeaderStyle Width="50px" />
                                                        <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Month 1 Sales" DataField="ForecastLbs1" DataFormatString="{0:n0}">
                                                        <HeaderStyle Width="90px" />
                                                        <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Month 1 Receipts" DataField="Month1RcptLbs" DataFormatString="{0:n0}">
                                                        <HeaderStyle Width="100px" />
                                                        <ItemStyle Width="100px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>
                                                    
                                                    <asp:BoundColumn HeaderText="Month 1 Avl" DataField="Month1AvlLbs" DataFormatString="{0:n0}">
                                                        <HeaderStyle Width="90px" />
                                                        <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Mth 1 Mos" DataField="Month1Mos" DataFormatString="{0:n1}">
                                                        <HeaderStyle Width="60px" />
                                                        <ItemStyle Width="60px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Month 2 Sales" DataField="ForecastLbs2" DataFormatString="{0:n0}">
                                                        <HeaderStyle Width="90px" />
                                                        <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Month 2 Receipts" DataField="Month2RcptLbs" DataFormatString="{0:n0}">
                                                        <HeaderStyle Width="100px" />
                                                        <ItemStyle Width="100px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>
                                                    
                                                    <asp:BoundColumn HeaderText="Month 2 Avl" DataField="Month2AvlLbs" DataFormatString="{0:n0}">
                                                        <HeaderStyle Width="90px" />
                                                        <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Mth 2 Mos" DataField="Month2Mos" DataFormatString="{0:n1}">
                                                        <HeaderStyle Width="60px" />
                                                        <ItemStyle Width="60px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Month 3 Sales" DataField="ForecastLbs3" DataFormatString="{0:n0}">
                                                        <HeaderStyle Width="90px" />
                                                        <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Month 3 Receipts" DataField="Month3RcptLbs" DataFormatString="{0:n0}">
                                                        <HeaderStyle Width="100px" />
                                                        <ItemStyle Width="100px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>
                                                    
                                                    <asp:BoundColumn HeaderText="Month 3 Avl" DataField="Month3AvlLbs" DataFormatString="{0:n0}">
                                                        <HeaderStyle Width="90px" />
                                                        <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderText="Mth 3 Mos" DataField="Month3Mos" DataFormatString="{0:n1}">
                                                        <HeaderStyle Width="60px" />
                                                        <ItemStyle Width="60px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>
                                                </Columns>
                                            </asp:DataGrid>

                                            <table id="tblGrdTotals" class="BluBordAll" border="0" cellspacing="0" cellpadding="0" runat="server" visible="true" style="position: relative; top: 0px; left: 0px; border: 1px solid;">
                                                <tr style="border:1px solid#999999; background-color:#B3E2F0;">
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="left"><table width="404px"><tr><td>Grand Totals for all Groups ...</td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="89px"><tr><td><asp:Label ID="lblTotAvgUseLbs" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="90px"><tr><td><asp:Label ID="lblTotAvlLbs" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="50px"><tr><td><asp:Label ID="lblTotAvlMos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="89px"><tr><td><asp:Label ID="lblTotTrfLbs" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="50px"><tr><td><asp:Label ID="lblTotTrfMos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="89px"><tr><td><asp:Label ID="lblTotOTWLbs" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="55px"><tr><td><asp:Label ID="lblTotOTWMos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="89px"><tr><td><asp:Label ID="lblTotRTSLbs" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="50px"><tr><td><asp:Label ID="lblTotRTSMos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="90px"><tr><td><asp:Label ID="lblTotOOLbs" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="50px"><tr><td><asp:Label ID="lblTotOOMos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="90px"><tr><td><asp:Label ID="lblTotalLbs" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="50px"><tr><td><asp:Label ID="lblTotalMos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="90px"><tr><td><asp:Label ID="lblTotMth1Sls" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="99px"><tr><td><asp:Label ID="lblTotMth1Rct" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="89px"><tr><td><asp:Label ID="lblTotMth1Avl" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="60px"><tr><td><asp:Label ID="lblTotMth1Mos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="90px"><tr><td><asp:Label ID="lblTotMth2Sls" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="99px"><tr><td><asp:Label ID="lblTotMth2Rct" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="90px"><tr><td><asp:Label ID="lblTotMth2Avl" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="61px"><tr><td><asp:Label ID="lblTotMth2Mos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="90px"><tr><td><asp:Label ID="lblTotMth3Sls" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="99px"><tr><td><asp:Label ID="lblTotMth3Rct" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="90px"><tr><td><asp:Label ID="lblTotMth3Avl" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #999999;" align="right"><table width="60px"><tr><td><asp:Label ID="lblTotMth3Mos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                </tr>
                                            </table>
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
