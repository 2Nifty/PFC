<%@ Page Language="C#" AutoEventWireup="true" CodeFile="~/Previewpage.aspx.cs" Inherits="_Default" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/SubHeader.ascx" TagName="SoHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Comments Preview</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table border="0" cellpadding="0" cellspacing="2" style="width: 100%;"
            class="HeaderPanels">
            <tr>
                <td>
                    <uc1:SoHeader ID="poHeader" runat="server"></uc1:SoHeader>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="vertical-align: top; padding-bottom: 3px; padding-top: 3px;
                    padding-left: 5px">
                    <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;height:320px;
                        top: 0px; left: 0px; border: 1px solid #88D2E9; width: 700px; scrollbar-3dlight-color: white;
                        scrollbar-arrow-color: #1D7E94; scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC;
                        scrollbar-face-color: #9EDEEC; scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94">
                        <asp:DataList ID="dlCommentTop" runat="server" Style="background-color: White; padding-top: 3px;
                            padding-bottom: 3px; font-style: italic; font-weight: bold;">
                            <ItemTemplate>
                                <%# DataBinder.Eval(Container, "DataItem.CommText") %>
                            </ItemTemplate>
                            <ItemStyle   CssClass="lock" />
                        </asp:DataList>
                        <asp:GridView ShowFooter="false" UseAccessibleHeader="true" ID="gvComment" PagerSettings-Visible="false"
                            Width="700" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="true"
                            AutoGenerateColumns="false" Height="53px" OnRowDataBound="gvComment_RowDataBound">
                            <HeaderStyle HorizontalAlign="Center" CssClass="GridHead" Font-Bold="True" BackColor="#DFF3F9" />
                            <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                            <RowStyle CssClass="item" Wrap="False" BackColor="White" Height="25px" BorderWidth="1px" />
                            <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="25px" BorderWidth="1px" />
                            <Columns>
                                <asp:BoundField HeaderText="Vendor Item No" DataField="VendorItemNo">
                                    <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="left" Width="125px" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Item No" DataField="ItemNo">
                                    <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Left" Width="120px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Item Description">
                                    <ItemTemplate>
                                        <asp:Label ID="lblLineNo" Visible="false" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.POLineNo") %>'></asp:Label>
                                        <asp:Label ID="lblDesc" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.ItemDesc") %>'></asp:Label>
                                        <div style="padding-top: 3px; padding-bottom: 3px; padding-left: 10px; padding-right: 5px;
                                            font-style: italic; font-weight: bold;">
                                            <asp:DataList ID="dlComment" runat="server" OnItemDataBound="dlComment_ItemDataBound">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblComment" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.CommText") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:DataList>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle  Width=250 />
                                </asp:TemplateField>
                                <asp:BoundField DataField="QtyOrdered" HeaderText="Qty Ordered">
                                    <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Left" Width="95px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="POLineNo" HeaderText="LineNo">
                                    <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Left" Width="95px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ReceivingLocation" HeaderText="Rec Location">
                                    <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Left" Width="155px" />
                                </asp:BoundField>
                            </Columns>
                            <PagerSettings Visible="False" />
                        </asp:GridView>
                        <asp:DataList ID="dlCommentBtm" runat="server" Style="background-color: White; padding-top: 3px;
                            padding-bottom: 3px; font-style: italic; font-weight: bold;">
                            <ItemTemplate>
                                <%# DataBinder.Eval(Container, "DataItem.CommText") %>
                            </ItemTemplate>
                            <ItemStyle   CssClass="locked" />
                        </asp:DataList>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="Footer1" Title="Comment Entry" runat="server"></uc2:Footer>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
