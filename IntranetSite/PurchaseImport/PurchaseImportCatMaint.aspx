<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PurchaseImportCatMaint.aspx.cs" Inherits="PurchaseImportCatMaint" %>
<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage2.ascx" TagName="Footer2" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script>
        var PurchImpReceiptWindow;
        function pageUnload() 
        {
            if (PurchImpReceiptWindow != null) {PurchImpReceiptWindow.close();PurchImpReceiptWindow=null;}
        }
        function ClosePage()
        {
            window.close();	
        }

        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            // size the grid
            var DetailGridPanel = $get("DetailGridPanel");
            if (DetailGridPanel != null)
            {
                DetailGridPanel.style.height = yh - 132;  
                //DetailGridPanel.style.width = xw - 5;  Visible="false"
            }
        }
    </script>

    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <title>Purchase Import Category Maintenance</title>
</head>
<body  onload="SetHeight();" onresize="SetHeight();" >
    <asp:SqlDataSource ID="LocationCodes" runat="server" ConnectionString="<%$ ConnectionStrings:PFCERPConnectionString %>"  
        SelectCommand="select LocID as Code, LocID+' - '+LocName as Name from [LocMaster] with (NOLOCK) where ShipMethCd like @LocFilter order by LocID" >
        <SelectParameters>
        <asp:ControlParameter ControlID="LocFilter" Name="LocFilter" PropertyName="Value" DefaultValue="%" />
        </SelectParameters>
        </asp:SqlDataSource>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="LPNSummScriptManager" runat="server" EnablePartialRendering="true" />
    <div>
        <asp:UpdatePanel ID="MainUpdatePanel1" runat="server">
        <ContentTemplate>
        <table width="100%" cellspacing="0" cellpadding="0" border="0">
            <tr>
                <td colspan="2">
                    <uc1:Header id="Pageheader" runat="server">
                    </uc1:Header>
                <asp:HiddenField ID="LocFilter" runat="server" />
                </td>
            </tr>
            <tr>
                <td colspan="2" class="PageHead" style="height: 40px">
                    <div class="LeftPadding" >
                        <div align="left" class="BannerText">
                            Purchase Import Category List Maintenance</div>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="width:60%;">
                    <asp:Panel ID="DetailGridPanel" runat="server"  ScrollBars="both">
                        <asp:HiddenField ID="DetailGridHeightHidden" runat="server" />
                        <asp:HiddenField ID="DetailGridWidthHidden" runat="server" />
                        <asp:HiddenField ID="SortHidden" runat="server" />
                    <asp:UpdatePanel ID="DetailUpdatePanel" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                    <asp:GridView ID="PurchImpGridView" runat="server" HeaderStyle-CssClass="GridHead"  AutoGenerateColumns="false"
                    RowStyle-BackColor="#FFFFFF" RowStyle-CssClass="Left5pxPadd" AllowSorting="true" OnSorting="SortDetailGrid"
                    OnRowDataBound="DetailRowBound" OnRowCommand="PurchImpGridView_RowCommand"

                    >
                    <AlternatingRowStyle CssClass="Left5pxPadd" BackColor="#DCF3FB" BorderColor="#DAEEEF" />
                    <Columns>
                        <asp:ButtonField CommandName="Fix" Text="Edit/RTS" ItemStyle-Width="60px" ItemStyle-HorizontalAlign="Center"  />
                        <asp:BoundField DataField="Vendor" HeaderText="Vendor" ItemStyle-HorizontalAlign="center" 
                            ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="60px" HeaderStyle-HorizontalAlign="Center"
                            SortExpression="Vendor" />
                        <asp:BoundField DataField="CategoryFrom" HeaderText="Cat. Beg" ItemStyle-HorizontalAlign="center" 
                            ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="60px" HeaderStyle-HorizontalAlign="Center"
                            SortExpression="CategoryFrom" />
                        <asp:BoundField DataField="CategoryTo" HeaderText="Cat. End" ItemStyle-HorizontalAlign="center" 
                            ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="60px" HeaderStyle-HorizontalAlign="Center"
                            SortExpression="CategoryTo" />
                        <asp:BoundField DataField="ImportFileName" HeaderText="File Name" ItemStyle-HorizontalAlign="center" 
                            ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="80px" HeaderStyle-HorizontalAlign="Center"
                            SortExpression="ImportFileName" />
                        <asp:BoundField DataField="pPurchaseImportCatListID" HeaderText="ID" 
                            
                            SortExpression="pPurchaseImportCatListID" />
                    </Columns>
                    </asp:GridView>
                    </ContentTemplate></asp:UpdatePanel>
                    </asp:Panel>
                </td>
                <td valign="top">
                    <asp:UpdatePanel ID="DataUpdatePanel" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                    <table cellspacing="2" cellpadding="1" border="0">
                        <tr>
                            <td colspan="2" valign="middle"  class="BannerText">
                            Category Filter Data
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100px; padding-left: 10px;"><b>Vendor</b>
                            </td>
                            <td>
                                <asp:TextBox ID="txtVendor" runat="server" Width="100px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100px; padding-left: 10px;">
                                <b>Beg. Category</b>
                            </td>
                            <td> 
                                <asp:TextBox ID="txtBegCat" runat="server" Width="60px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100px; padding-left: 10px;"><b>End Category</b> 
                            </td>
                            <td>
                                <asp:TextBox ID="txtEndCat" runat="server" Width="60px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100px; padding-left: 10px;"><b>File Name</b>
                            </td>
                            <td>
                                <asp:TextBox ID="txtFileName" runat="server" Width="150px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" valign="middle" align="center">
                            <asp:ImageButton id="btnAdd" OnClick="Add_Click" AlternateText="Show Unprocessed LPNs"
                                runat="server" ImageUrl="../Common/Images/newadd.gif" CausesValidation="false" />
                            <asp:ImageButton id="btnUpd" ImageUrl="../Common/Images/update.gif"
                                runat="server" OnClick="Update_Click" />
                            <asp:ImageButton id="btnDel" ImageUrl="../Common/Images/BtnDelete.gif"
                                runat="server" OnClick="Delete_Click" />
                            <asp:ImageButton id="btnCancel" ImageUrl="../Common/Images/cancel.gif"
                                runat="server" OnClick="Cancel_Click" CausesValidation="false" />
                            <asp:HiddenField ID="hidRecID" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                            <asp:ImageButton id="btnRTS" ImageUrl="../Common/Images/ExporttoExcel.gif"
                                runat="server" OnClick="RTS_Click" CausesValidation="false" />
                            </td>
                        </tr>
                    </table>
                    </ContentTemplate>
                    <Triggers>
                        <asp:PostBackTrigger ControlID="btnRTS" />
                    </Triggers>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="BluBg">
                    <asp:Panel ID="BottomPanel" runat="server">
                    <table width="100%">
                        <tr>
                            <td align="left">&nbsp;&nbsp;&nbsp;
                            <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>&nbsp;
                                <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                            </ContentTemplate></asp:UpdatePanel>
                            </td>
                            <td>&nbsp;
                            </td>
                            <td align="right">
                                <asp:ImageButton ID="GridCloseButton" ImageUrl="../Common/Images/close.gif" runat="server" OnClientClick="ClosePage();" /></td>
                        </tr>
                    </table>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <uc2:Footer2 id="PageFooter2" runat="server">
                    </uc2:Footer2>
                </td>
            </tr>
        </table>
        </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    </form>
</body>
</html>
