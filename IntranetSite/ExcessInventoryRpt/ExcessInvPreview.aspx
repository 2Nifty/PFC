<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ExcessInvPreview.aspx.cs" Inherits="ExcessInvPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Excess Inventory Report Preview</title>
    
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
                                       <span style="font-size: 16px;font-weight: bold;color: #3A3A56;">Excess Inventory Report</span></div>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" class="PageBg" height="25px" width="1000px">
                                    <table border="0" class="TabHead" cellpadding="0" cellspacing="0" width="100%">
                                    <tr valign="middle">
                                        <td style="width: 55px" valign="middle">
                                            <asp:Label ID="Label1" runat="server" Text="Location:" Width="55px"></asp:Label></td>
                                        <td style="width: 150px" align="left">
                                            <asp:Label Font-Bold="false" ID="lblLoc" runat="server" Width="150px"></asp:Label></td>
                                        <td style="width: 65px">
                                            <asp:Label ID="Label2" runat="server" Text="Item Type:" Width="65px"></asp:Label></td>
                                        <td style="width: 55px" align="left">
                                            <asp:Label Font-Bold="false" ID="lblRecType" runat="server" Width="55px"></asp:Label></td>
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
                                        <td style="width: 75px">
                                            <asp:Label ID="Label6" runat="server" Text="Min Excess:" Width="75px"></asp:Label></td>
                                        <td style="width: 40px" align="left">
                                            <asp:Label Font-Bold="false" ID="lblMin" runat="server" Width="40px"></asp:Label></td>
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
                                            <asp:DataGrid ID="dgExcessInv" BackColor="#F4FBFD" Width="1003px" runat="server" BorderWidth="1px" ShowFooter="False" AutoGenerateColumns="False">
                                                <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                                <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD" Height=18px />
                                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                <AlternatingItemStyle CssClass="GridItem" BackColor="White" Height=18px />
                                                    <Columns>
                                                        <asp:BoundColumn HeaderText="Item Type" DataField="RecordType" SortExpression="RecordType">
                                                            <HeaderStyle Width="70px" />
                                                            <ItemStyle Width="70px" HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundColumn>
                                                        
                                                        <asp:BoundColumn HeaderText="Item Number" DataField="ItemNo" SortExpression="ItemNo">
                                                            <HeaderStyle Width="100px" />
                                                            <ItemStyle Width="100px" HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundColumn>
                                                        
                                                        <asp:BoundColumn HeaderText="Loc" DataField="Branch" SortExpression="Branch">
                                                            <HeaderStyle Width="30px" />
                                                            <ItemStyle Width="30px" HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Size" DataField="ItemSize" SortExpression="ItemSize">
                                                            <HeaderStyle Width="200px" />
                                                            <ItemStyle Width="200px" HorizontalAlign="Left" Wrap="False" />
                                                        </asp:BoundColumn>
                                                        
                                                        <asp:BoundColumn HeaderText="Description" DataField="Description" SortExpression="Description">
                                                            <HeaderStyle Width="315px" />
                                                            <ItemStyle Width="315px" HorizontalAlign="Left" Wrap="False" />
                                                        </asp:BoundColumn>
                                                        
                                                        <asp:BoundColumn HeaderText="UOM" DataField="UOM" SortExpression="UOM">
                                                            <HeaderStyle Width="28px" />
                                                            <ItemStyle Width="28px" HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Available" DataField="AvailableQty" SortExpression="AvailableQty" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="70px" />
                                                            <ItemStyle Width="70px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Excess Qty" DataField="ExcessQty" SortExpression="ExcessQty" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="60px" />
                                                            <ItemStyle Width="60px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Excess Wght" DataField="ExcessWght" SortExpression="ExcessWght" DataFormatString="{0:n3}">
                                                            <HeaderStyle Width="80px" />
                                                            <ItemStyle Width="80px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>
                                                        
                                                        <asp:BoundColumn HeaderText="ROP" DataField="ReOrderPoint" SortExpression="ReOrderPoint" DataFormatString="{0:n1}">
                                                            <HeaderStyle Width="50px" />
                                                            <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>
                                                    </Columns>
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
