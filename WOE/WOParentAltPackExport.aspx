<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WOParentAltPackExport.aspx.cs"
    Inherits="WOParentAltPackExport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Alt. Parent Item Pack Export</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <%--        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td style="height: 23px" bgcolor="#EFF9FC">
                </td>
                <td bgcolor="#EFF9FC" style="height: 23px">
                    <div align="right">
                        <span>
                            &nbsp;<img src="../Common/images/close.gif" style="cursor: hand" onclick="javascript:window.close();" />
                        </span>
                    </div>
                </td>
            </tr>
        </table>--%>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr valign="top">
                <td style="height: 314px">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr>
                            <td class="PageHead" valign="middle">
                                <div align="left" class="LeftPadding">
                                    <span style="font-size: 16px; font-weight: bold; color: #3A3A56;">Alternate Parent Item
                                        Pack Opportunities</span></div>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" class="PageBg" height="25px" width="1200px">
                                <table border="0" class="TabHead" cellpadding="0" cellspacing="0" width="100%">
                                    <tr valign="middle">
                                        <td style="width: 85px" valign="middle">
                                            <asp:Label ID="Label1" runat="server" Text="Action Status:" Width="85px"></asp:Label></td>
                                        <td style="width: 80px">
                                            <asp:Label Font-Bold="false" ID="lblActionStatus" runat="server" Width="80px"></asp:Label></td>
                                        <td style="width: 80px">
                                            <asp:Label ID="Label2" runat="server" Text="Priority Code:" Width="75px"></asp:Label></td>
                                        <td style="width: 85px">
                                            <asp:Label Font-Bold="false" ID="lblPriorityCd" runat="server" Width="80px"></asp:Label></td>
                                        <td style="width: 50px">
                                            <asp:Label ID="Label3" runat="server" Text="User:" Width="40px"></asp:Label></td>
                                        <td style="width: 60px">
                                            <asp:Label Font-Bold="false" ID="lblUser" runat="server" Width="55px"></asp:Label></td>
                                        <td style="width: 50px">
                                            <asp:Label ID="Label7" runat="server" Text="Branch:" Width="50px"></asp:Label></td>
                                        <td style="width: 170px">
                                            <asp:Label Font-Bold="false" ID="lblBranch" runat="server" Width="165px"></asp:Label></td>
                                        <td style="width: 65px">
                                            <asp:Label ID="Label4" runat="server" Text="Category:" Width="65px"></asp:Label></td>
                                        <td style="width: 50px">
                                            <asp:Label Font-Bold="false" ID="lblCategory" runat="server" Width="50px"></asp:Label></td>
                                        <td style="width: 35px">
                                            <asp:Label ID="Label5" runat="server" Text="Size:" Width="35px"></asp:Label></td>
                                        <td style="width: 45px">
                                            <asp:Label Font-Bold="false" ID="lblSize" runat="server" Width="45px"></asp:Label></td>
                                        <td style="width: 60px">
                                            <asp:Label ID="Label6" runat="server" Text="Variance:" Width="60px"></asp:Label></td>
                                        <td style="width: 30px">
                                            <asp:Label Font-Bold="false" ID="lblVariance" runat="server" Width="30px"></asp:Label></td>
                                        <td colspan="1" rowspan="2" valign="middle">
                                            <table width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td align="right" class="TabHead">
                                                        <span class="LeftPadding">Run Date :
                                                            <%=DateTime.Now.Month%>
                                                            /<%=DateTime.Now.Day%>/<%=DateTime.Now.Year%></span></td>
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
                                            <asp:DataGrid ID="dgWorkSheet" BackColor="#F4FBFD" Width="1135px" runat="server"
                                                BorderWidth="1px" ShowFooter="False"
                                                AutoGenerateColumns="False">
                                                <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                                <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD"
                                                    Height="18px" />
                                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                <AlternatingItemStyle CssClass="GridItem" BackColor="White" Height="18px" />
                                                <Columns>
                                                    <asp:BoundColumn HeaderText="Usage Velocity" DataField="UsageVelocityCd" SortExpression="UsageVelocityCd">
                                                        <HeaderStyle Width="50px" />
                                                        <ItemStyle Width="50px" HorizontalAlign="Center" Wrap="False" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Action Status" DataField="ActionStatus" SortExpression="ActionStatus">
                                                        <HeaderStyle Width="100px" />
                                                        <ItemStyle Width="100px" HorizontalAlign="Center" Wrap="False" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Priority Code" DataField="PriorityCd" SortExpression="PriorityCd">
                                                        <HeaderStyle Width="60px" />
                                                        <ItemStyle Width="60px" HorizontalAlign="Center" Wrap="False" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Finished Item No" DataField="FinishedItemNo" SortExpression="FinishedItemNo">
                                                        <HeaderStyle Width="115px" />
                                                        <ItemStyle Width="115px" HorizontalAlign="Center" Wrap="False" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Description" DataField="Description" SortExpression="Description">
                                                        <HeaderStyle Width="350px" />
                                                        <ItemStyle Width="350px" HorizontalAlign="Left" Wrap="False" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Action Qty" DataField="ActionQty" SortExpression="ActionQty"
                                                        DataFormatString="{0:N0}">
                                                        <HeaderStyle Width="55px" />
                                                        <ItemStyle Width="55px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Parent Item No" DataField="ParentItemNo" SortExpression="ParentItemNo">
                                                        <HeaderStyle Width="115px" />
                                                        <ItemStyle Width="115px" HorizontalAlign="Center" Wrap="False" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Alt. Item No" DataField="AltItem" SortExpression="AltItem">
                                                        <HeaderStyle Width="115px" />
                                                        <ItemStyle Width="115px" HorizontalAlign="Center" Wrap="False" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Alt. Qty" DataField="AltItemQty" SortExpression="AltItemQty">
                                                        <HeaderStyle Width="55px" />
                                                        <ItemStyle Width="55px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Branch" DataField="WOBranch" SortExpression="WOBranch">
                                                        <HeaderStyle Width="50px" />
                                                        <ItemStyle Width="50px" HorizontalAlign="Center" Wrap="False" />
                                                    </asp:BoundColumn>
<%--                                                    <asp:BoundColumn HeaderText="Due Date" DataField="WODueDt" SortExpression="WODueDt"
                                                        DataFormatString="{0:MM/dd/yyyy}">
                                                        <HeaderStyle Width="60px" />
                                                        <ItemStyle Width="60px" HorizontalAlign="Center" Wrap="False" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Type" DataField="Type" SortExpression="Type">
                                                        <HeaderStyle Width="50px" />
                                                        <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Accept Action Date" DataField="AcceptActionDt" SortExpression="AcceptActionDt"
                                                        DataFormatString="{0:MM/dd/yyyy}">
                                                        <HeaderStyle Width="85px" />
                                                        <ItemStyle Width="85px" HorizontalAlign="Center" Wrap="False" />
                                                    </asp:BoundColumn>
--%>                                                </Columns>
                                            </asp:DataGrid>
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
