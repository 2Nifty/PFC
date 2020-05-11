<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ItemBranchActivity.aspx.cs" Inherits="ItemBranchActivity" %>

<%@ Register Src="Common/UserControls/Pager.ascx" TagName="pager" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>AC Item Branch Activity</title>

    <link href="Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../Common/Javascript/Common.js"></script>
    <script type="text/javascript" src="../Common/Javascript/ContextMenu.js"></script>

<script>

    function PrintReport(BeginDt, EndDt, Branch, ItemNo)
    {
        var URL = "ItemBranchActivityPreview.aspx?BeginDt=" + BeginDt + "&EndDt=" + EndDt + "&Branch=" + Branch + "&ItemNo=" + ItemNo;
        window.open(URL,'Preview','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
    }

   function DeleteFiles(session)
   {
        ItemBranchActivity.DeleteExcel('ACItemBranch'+session).value;
        parent.window.close();
   }
</script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr>
                <td height="5%" id="tdHeader" colspan="2">
                    <uc1:Header ID="ucHeader" runat="server" />
                </td>
            </tr>
            <tr>
                <td width="100%" valign="top" colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="PageHead" colspan="4" style="height: 30px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td class="Left5pxPadd BannerText" width="70%">
                                            Avg Cost Item Branch Activity
                                        </td>
                                        <td align="right" style="width:280px; padding-right: 3px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton runat="server" Style="cursor: hand" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td>
                                                        <img Style="cursor: hand" src="../Common/Images/Print.gif"
                                                            align="middle" onclick="Javascript:PrintReport('<%=Request.QueryString["BeginDt"] %>', '<%=Request.QueryString["EndDt"] %>', '<%=Request.QueryString["Branch"] %>', '<%=Request.QueryString["ItemNo"] %>');" />
                                                    </td>
                                                    <td>
                                                        <img align="right" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
                                                            src="Common/Images/Close.gif" style="cursor: hand; padding-right: 2px;" />
                                                    </td>
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
            <tr>
                <td align="left" valign="top" id="tdgrid">
                    <asp:UpdatePanel ID="upnlGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative;
                                top: 0px; left: 5px; height: 555px; width: 1010px; border: 0px solid;">
                                    <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" runat="server" BorderWidth="1px"
                                        ShowFooter="False" AutoGenerateColumns="False" PageSize="22" AllowPaging="true"
                                        PagerStyle-Visible="false" AllowSorting="true" OnSortCommand="GridView1_SortCommand">
                                    <HeaderStyle CssClass="GridHead" Wrap=false BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Center" />
                                    <ItemStyle CssClass="Left5pxPadd" BackColor="White" BorderColor="White" />
                                    <AlternatingItemStyle CssClass="Left5pxPadd" BackColor="#F4FBFD" BorderColor="#DAEEEF" />
                                    <Columns>
                                        <asp:BoundColumn HeaderText="Cur Date" DataField="CurDate" SortExpression="CurDate" DataFormatString="{0:MM/dd/yyyy}">
                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Center" Width="75px" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Branch" DataField="Branch">
                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Center" Width="50px" />
                                        </asp:BoundColumn>
                                        
                                        <asp:BoundColumn HeaderText="Item No" DataField="ItemNo">
                                            <HeaderStyle CssClass="GridHead" Width="125px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Center" Width="125px" />
                                        </asp:BoundColumn>
                                        
                                        <asp:BoundColumn HeaderText="Qty On Hand" DataField="QOH" SortExpression="QOH" DataFormatString="{0:N0}">
                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                            <ItemStyle HorizontalAlign="Right" Width="75px" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Rcpt Qty" DataField="RcptQty" SortExpression="RcptQty" DataFormatString="{0:N0}">
                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="75px" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Iss Qty" DataField="IssQty" SortExpression="IssQty" DataFormatString="{0:N0}">
                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="75px" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Adj Qty" DataField="AdjQty" SortExpression="AdjQty" DataFormatString="{0:N0}">
                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Right" Width="75px" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Doc No" DataField="DocNo" SortExpression="DocNo">
                                            <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Center" Width="100px" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Parent Doc No" DataField="ParentDocNo" SortExpression="ParentDocNo">
                                            <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Center" Width="100px" />
                                        </asp:BoundColumn>

                                        <asp:BoundColumn HeaderText="Source ID" DataField="SourceID" SortExpression="SourceID">
                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Center" Width="75px" />
                                        </asp:BoundColumn>
                                    </Columns>
                                </asp:DataGrid>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
                <tr>
                    <td colspan="2" class="BluBg">
                        <table width="100%" id="Table1" runat="SERVER">
                            <tr>
                                <td>
                                    <uc1:pager ID="Pager1" OnBubbleClick="Pager_PageChanged" runat="server" Visible="true" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            <tr>
                <td colspan="2" valign="top">
                    <table width="100%">
                        <uc2:BottomFooter ID="ucFooter" Title="AC Item Branch Activity" runat="server" />
                    </table>
                    <INPUT id="hidSort" type="hidden" name="hidSort" runat="server">
                    <asp:HiddenField ID="hidRange" runat="server" />
                </td>
            </tr>


        </table>
    </form>
    
        <script>window.parent.document.getElementById("Progress").style.display='none';</script>

</body>
</html>
