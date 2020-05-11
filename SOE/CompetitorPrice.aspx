<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CompetitorPrice.aspx.cs" Inherits="CompetitorPrice" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title>Competitor Price</title>
    
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
</head>
<body bgcolor="#ECF9FB" scroll="no" style="margin: 3px" >
    <form id="form1" runat="server" >
    <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="pnlCustomerSearch" runat="server" UpdateMode="conditional">
            <ContentTemplate>
                <div>
                <asp:Panel  ID="container" runat="server">
                    <table width="100%" cellpadding="0" cellspacing="0" class="splitBorder" style="border:1px solid #88D2E9;">
                <tr>
                    <td class="splitBorder" style="padding-top:5px;" align=center>
                        <asp:Label ID="lblMessage" ForeColor="Red" Font-Bold="True" CssClass="Tabhead" runat="server" style="padding-top:20px;"
                            Visible="False"></asp:Label></td>
                </tr>
                <tr>
                    <td class="splitBorder">
                        <div id="divdatagrid" class="Sbar" style="overflow: auto;overflow-x:hidden; position: relative; top: 0px;
                                    left: 0px; width: 550px; height: 200px; border: 0px solid; color:White">
                            <asp:DataGrid  ID="dgCompetitor" BorderColor="#9AB8C3" runat="server" BorderWidth="0" Width="545px"
                                 GridLines="both" AutoGenerateColumns="False" 
                                AllowSorting="True" TabIndex="-1" OnItemDataBound="dgCompetitor_ItemDataBound" OnSortCommand="dgCompetitor_SortCommand">
                                <HeaderStyle HorizontalAlign="Center" Height="25px" CssClass="GridHead" BorderColor="#DAEEEF"
                                    Font-Bold="True" BackColor="#DFF3F9" />
                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                <ItemStyle CssClass="item" BorderColor="#FFFFFF" Wrap="False" BackColor="White"
                                    Height="20px" BorderWidth="1px" />
                                <AlternatingItemStyle BorderColor="#DAEEEF" CssClass="itemShade" BackColor="#ECF9FB"
                                    Height="20px" BorderWidth="1px" />
                                <Columns>  
                                    <asp:BoundColumn DataField="PrimeCompetitor" ItemStyle-CssClass="Left5pxPadd" SortExpression="PrimeCompetitor" HeaderText="PrimeCompetitor" Visible=false>
                                        <HeaderStyle BorderWidth="1px" />
                                        <ItemStyle BorderWidth="1px" Width="50px" CssClass="Left5pxPadd" />
                                    </asp:BoundColumn>  
                                    <asp:BoundColumn DataField="CompetitorName"  SortExpression="CompetitorName" HeaderText="Competitor Name" >
                                        <HeaderStyle BorderWidth="1px" />
                                        <ItemStyle BorderWidth="1px" Width="170px" />
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="CompetitorItem" SortExpression="CompetitorItem"  HeaderText="Item Number">
                                        <HeaderStyle BorderWidth="1px"/>
                                        <ItemStyle BorderWidth="1px" Width="100px" />
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="Price" SortExpression="Price" DataFormatString="{0:#,##0.0}"  HeaderText="Price">
                                        <HeaderStyle BorderWidth="1px" />
                                        <ItemStyle BorderWidth="1px" Width="70px" />
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="PriceUM" SortExpression="PriceUM"  HeaderText="PriceUM">
                                        <HeaderStyle BorderWidth="1px" />
                                        <ItemStyle BorderWidth="1px" Width="50px" />
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="CompetitorPieceCount" SortExpression="CompetitorPieceCount" HeaderText="UM Piece Count">
                                        <HeaderStyle BorderWidth="1px" />
                                        <ItemStyle BorderWidth="1px" Width="100px" />
                                    </asp:BoundColumn>                                  
                                </Columns>
                            </asp:DataGrid>
                            <input id="hidSort" type="hidden" name="Hidden1" runat="server">                            
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="background: url(common/images/commandlineBg.jpg) left -80px;">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td class="splitborder_t_v splitborder_b_v" align="right" width="100%" id="td1" style="padding-top:5px;padding-right:10px;" valign=middle>
                                    <img src="Common/Images/close.gif" style="cursor: hand;" onclick="javascript:window.close();"
                                        id="img3" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                <td>
                    <uc2:Footer ID="Footer1" Title="Competitor Price" runat="server"></uc2:Footer>
                </td>
            </tr>
            </table>
                </asp:Panel>
        </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
    <script>
self.focus();
</script>
</body>
</html>
