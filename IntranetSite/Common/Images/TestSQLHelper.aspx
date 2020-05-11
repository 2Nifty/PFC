<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TestSQLHelper.aspx.cs" Inherits="TestSQLHelper" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>SQLHelper</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />

    <script language="javascript" src="Common/javascript/ContextMenu.js"></script>

</head>
<body>
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" runat="server" id="BodyTable">
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="5" height="97" valign="top" class="BannerBg">
                                <div class="bannerImg">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="PageHead" width="100%" height="100%" valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td valign="middle" style="height: 40px">
                                            <div class="LeftPadding">
                                                <div align="left" class="BannerText">
                                                    SQLHelper
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                                    <tr>
                                        <td valign="middle">
                                            SELECT RecordSet&nbsp;&nbsp;
                                            <asp:ImageButton ID="btnSelect" runat="server" ImageUrl="../Common/images/go.gif" OnClick="btnSelect_Click" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td valign="top" width="100%">
                                                        <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px;
                                                            left: 0px; width: 1000px; height: 100px; border: 0px solid;">
                                                            <asp:DataGrid ID="dgItem1" BackColor="#F4FBFD" runat="server" BorderWidth="1px" 
                                                                AutoGenerateColumns="False" ShowFooter="True">
                                                                <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                                                <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD" />
                                                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                                <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                                                <Columns>
                                                                    <asp:BoundColumn DataField="ItemNo" HeaderText="Item #" SortExpression="ItemNo">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="100px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="ItemDesc" HeaderText="Description" SortExpression="ItemDesc">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="250px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="250px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="SellStkUM" HeaderText="Sell Stk UM"
                                                                        SortExpression="SellStkUM" DataFormatString="{0:0}">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="GrossWght" HeaderText="Gross Weight"
                                                                        SortExpression="GrossWght" DataFormatString="{0:0.000}">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="UPCCd" HeaderText="UPC" SortExpression="UPCCd">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="100px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="ChangeID" HeaderText="Change ID" SortExpression="ChangeID">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="100px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                </Columns>
                                                            </asp:DataGrid>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="middle">
                                            UPDATE RecordSet&nbsp;&nbsp;
                                            <asp:ImageButton ID="btnUpdate" runat="server" ImageUrl="../Common/images/go.gif" OnClick="btnUpdate_Click" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="middle">
                                            DELETE RecordSet&nbsp;&nbsp;
                                            <asp:ImageButton ID="btnDelete" runat="server" ImageUrl="../Common/images/go.gif" OnClick="btnDelete_Click" />
                                        </td>
                                    </tr>


                                    <tr>
                                        <td valign="middle">
                                            INSERT RecordSet&nbsp;&nbsp;
                                            <asp:ImageButton ID="btnInsert" runat="server" ImageUrl="../Common/images/go.gif" OnClick="btnInsert_Click" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td valign="middle">
                                            EXECUTE Procedure&nbsp;&nbsp;
                                            <asp:ImageButton ID="btnExecSP" runat="server" ImageUrl="../Common/images/go.gif" OnClick="btnExecSP_Click" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td valign="middle">
                                            SELECT RecordSet from SP&nbsp;&nbsp;
                                            <asp:ImageButton ID="btnSelSP" runat="server" ImageUrl="../Common/images/go.gif" OnClick="btnSelSP_Click" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td valign="top" width="100%">
                                                        <div class="Sbar" id="div1" style="overflow: auto; position: relative; top: 0px;
                                                            left: 0px; width: 1000px; height: 100px; border: 0px solid;">
                                                            <asp:DataGrid ID="dgItem2" BackColor="#F4FBFD" runat="server" BorderWidth="1px" 
                                                                AutoGenerateColumns="False" ShowFooter="True">
                                                                <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                                                <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD" />
                                                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                                <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                                                <Columns>
                                                                    <asp:BoundColumn DataField="ItemNo" HeaderText="Item #" SortExpression="ItemNo">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="100px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="ItemDesc" HeaderText="Description" SortExpression="ItemDesc">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="250px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="250px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="SellStkUM" HeaderText="Sell Stk UM"
                                                                        SortExpression="SellStkUM" DataFormatString="{0:0}">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="GrossWght" HeaderText="Gross Weight"
                                                                        SortExpression="GrossWght" DataFormatString="{0:0.000}">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="UPCCd" HeaderText="UPC" SortExpression="UPCCd">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="100px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="EntryID" HeaderText="My Ent ID" SortExpression="EntryID">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="100px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>
                                                                    
                                                                    <asp:BoundColumn DataField="ChangeID" HeaderText="Change ID" SortExpression="ChangeID">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="100px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                </Columns>
                                                            </asp:DataGrid>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>



                                    <tr>
                                        <td valign="middle">
                                            <asp:TextBox ID="txtItemNo" runat="server" Text=""></asp:TextBox>
                                        </td>
                                    </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
