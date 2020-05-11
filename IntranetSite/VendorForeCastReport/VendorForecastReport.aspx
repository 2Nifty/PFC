<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VendorForecastReport.aspx.cs" Inherits="CustomerSalesAnalysis" %>
<%@ Register Src="../Common/UserControls/VendorPager.ascx" TagName="pager" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Vendor Forecast Report</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
    function PrintReport()
    {
        window.open('VendorForecastReportPreview.aspx','VendorForecastReportPreview' ,'height=700,width=760,scrollbars=no,status=no,top='+((screen.height/2) - (700/2))+',left='+((screen.width/2) - (760/2))+',resizable=YES','');
    }
    function Close()
    {
        var fileName = document.getElementById("hidExcelFileName").value;
        CustomerSalesAnalysis.DeleteExcelFile(fileName);
        window.parent.close();
    }
    </script>
</head>
<body bottommargin="0">
    <form id="form1" runat="server">
         <asp:ScriptManager ID="MyScript" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" runat="server" id="BodyTable">
            <tr>
                <td colspan="2">
                    <table width="100%"  style="height: 590px" border="0" cellspacing="1" cellpadding="0">
                        <tr>
                            <td colspan="2" valign="middle" class="PageHead">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                                    <tr>
                                        <td style="height: 36px;width:460px" valign=middle><div align="left" class="LeftPadding">Vendor Forecast Report</div></td>
                                        <td align="right">
                                            <table cellpadding="0" cellspacing="5">
                                                <tr>
                                                    <td align="center" valign="middle" style="width:100px">
                                                        <asp:UpdateProgress ID="UpProgress" runat="server">
                                                            <ProgressTemplate>
                                                                <asp:Label Width="30px" ID="lbl" Text=" Loading..." ForeColor="red" Font-Names="Arial" Font-Size="X-Small" runat="server"></asp:Label>
                                                            </ProgressTemplate>
                                                        </asp:UpdateProgress>
                                                    </td>
                                                    <td>
                                                         <asp:UpdatePanel ID="updatePanel"  RenderMode=Inline  runat="server">
                                                            <ContentTemplate>
                                                                <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif" ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                    <td>
                                                        <input type="hidden" runat="server" id="hidExcelFileName" />
                                                        <img style="cursor:hand;" align="middle" src="../Common/Images/Print.gif" onclick="PrintReport()" />
                                                    </td>
                                                    <td>
                                                        <img style="cursor:hand;" align="middle" src="../common/images/close.gif" onclick="javascript:Close();" id="imgClose"/>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" class="PageBg">
                            </td>
                        </tr>
                        <tr>
                            <td align="center" bgcolor="#EFF9FC" colspan="2">
                                <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                    Visible="False"></asp:Label></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0" >
                                    <tr>
                                        <td valign="top" width="100%" >
                                            <div class="Sbar" id="divdatagrid" style="overflow: auto; position: relative; top: 0px; left: 0px;
                                                width: 833px; height: 518px; border: 0px solid;">
                                                <asp:DataGrid ShowFooter="True" PageSize="1" BorderWidth=1px ShowHeader=False PagerStyle-Visible=true  ID=dgCategory  AllowPaging=True AutoGenerateColumns=False  runat=server OnItemDataBound="dgCategory_ItemDataBound1" OnPageIndexChanged="dgCategory_PageIndexChanged" >
                                                <Columns>
                                                    <asp:TemplateColumn>
                                                        <ItemTemplate >
                                                            <table cellpadding="0" border="0" cellspacing=0 width=100%>
                                                                <tr bgcolor="#f4fbfd"><td colspan=2 height=5></td></tr>
                                                                <tr bgcolor="#f4fbfd">
                                                                    <td width=2% class=TabHead height=18>Category :&nbsp;</td>
                                                                    <td width=98% >
                                                                        <asp:Label ID="lblCategory" runat=server Text='<%#DataBinder.Eval(Container,"DataItem.Category")%>'></asp:Label>&nbsp;&nbsp;<asp:Label ID="Label1" runat=server Text='<%#DataBinder.Eval(Container,"DataItem.CategoryDesc")%>'></asp:Label>
                                                                        <asp:HiddenField ID="hidForeCastUSG" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.ForeCastUSG")%>' />
                                                                        <asp:HiddenField ID="hidUSGUOM" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.USGUOM")%>' />
                                                                        <asp:HiddenField ID="hidUSGLBS" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.USGLBS")%>' />
                                                                        <asp:HiddenField ID="hidUSGKGS" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.USGKGS")%>' />
                                                                    </td>
                                                                <tr>
                                                                    <td colspan="2" style="height: 117px">   
                                                                    <asp:DataGrid ShowFooter="True" BorderWidth=1px ShowHeader=False AllowPaging=false ID=dgSort Width="100%" AutoGenerateColumns=False  runat=server OnItemDataBound="dgSort_ItemDataBound1" OnPageIndexChanged="dgCategory_PageIndexChanged" >
                                                                        <Columns>
                                                                            <asp:TemplateColumn>
                                                                                <ItemTemplate>
                                                                                        <asp:label id="lblItemPrefixCaption" CssClass="TabHead" Text="Item Prefix : " runat=server>  </asp:label><asp:Label ID="lblItemPrefix" Text='<%#DataBinder.Eval(Container,"DataItem.ItemSort")%>' runat=server></asp:Label>
                                                                                        <asp:DataGrid ID="dgCategoryDetail" AllowPaging=false BackColor="#F4FBFD" runat="server" AutoGenerateColumns="False" BorderWidth="1px" ShowFooter="true" Width="100%" OnItemDataBound="dgCategoryDetail_ItemDataBound" >
                                                                                            <HeaderStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                                                            <ItemStyle CssClass="GridItem" BorderStyle=Solid Wrap=False BackColor="#F4FBFD" />
                                                                                            <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                                                            <AlternatingItemStyle CssClass="GridItem"  BackColor="White" />
                                                                                                <Columns>
                                                                                                <asp:BoundColumn HeaderText="Item #"  DataField="Itemno"  SortExpression="Itemno">
                                                                                                    <ItemStyle CssClass="GridItem" Width="115px" HorizontalAlign=Left />
                                                                                                    <FooterStyle CssClass="GridHead"/>
                                                                                                    <HeaderStyle CssClass="GridHead" HorizontalAlign="center" Wrap="False" />
                                                                                                </asp:BoundColumn>
                                                                                                <asp:BoundColumn HeaderText="Size" DataField="Size" SortExpression="Size">
                                                                                                    <ItemStyle CssClass="GridItem" Width="110px" HorizontalAlign="Left" Wrap="False" />
                                                                                                    <FooterStyle CssClass="GridHead"/>
                                                                                                    <HeaderStyle CssClass="GridHead" HorizontalAlign="center" />
                                                                                                </asp:BoundColumn>
                                                                                                <asp:BoundColumn HeaderText="Category Description" DataField="CategoryDesc" SortExpression="CategoryDesc">
                                                                                                    <ItemStyle CssClass="GridItem" Width="160px" HorizontalAlign="Left" Wrap="False" />
                                                                                                    <FooterStyle CssClass="GridHead"/>
                                                                                                    <HeaderStyle CssClass="GridHead" HorizontalAlign="center" />
                                                                                                </asp:BoundColumn>
                                                                                                <asp:BoundColumn HeaderText="Plating" DataField="Plate" SortExpression="Plate">
                                                                                                    <ItemStyle CssClass="GridItem" Width="35px" HorizontalAlign="Left" Wrap="False" />
                                                                                                    <FooterStyle CssClass="GridHead"/>
                                                                                                    <HeaderStyle CssClass="GridHead" HorizontalAlign="center" />
                                                                                                </asp:BoundColumn>
                                                                                                <asp:BoundColumn DataFormatString="{0:#,##0}" DataField="ForecastUsg" SortExpression="ForecastUsg">
                                                                                                    <ItemStyle  Width="60px" HorizontalAlign="Right" Wrap="False" />
                                                                                                    <FooterStyle CssClass="GridHead"/>
                                                                                                </asp:BoundColumn>
                                                                                                <asp:BoundColumn DataField="USGUOM" DataFormatString="{0:#,##0}" SortExpression="USGUOM">
                                                                                                    <ItemStyle  Width="60px" HorizontalAlign="Right" Wrap="False" />
                                                                                                    <FooterStyle CssClass="GridHead"/>
                                                                                                </asp:BoundColumn>
                                                                                                <asp:BoundColumn  DataField="USGLBS" DataFormatString="{0:#,##0}" SortExpression="USGLBS">
                                                                                                    <ItemStyle  Width="65px" HorizontalAlign="Right" Wrap="False" />
                                                                                                    <FooterStyle CssClass="GridHead"/>
                                                                                                </asp:BoundColumn>
                                                                                                <asp:BoundColumn DataField="USGKGS" DataFormatString="{0:#,##0}" SortExpression="USGKGS">
                                                                                                    <ItemStyle Width="55px" HorizontalAlign="Right" Wrap="False" />
                                                                                                    <FooterStyle CssClass="GridHead"/>
                                                                                                </asp:BoundColumn>
                                                                                                </Columns>
                                                                                            <PagerStyle Visible="False" />
                                                                                        </asp:DataGrid>       
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                        </Columns>
                                                                    </asp:DataGrid>                                                                 
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="810px" />
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                    <PagerStyle Visible="False" ForeColor="#C00000" HorizontalAlign="Right" VerticalAlign="Middle" Mode="NumericPages"  />
                                                </asp:DataGrid>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table width="100%" id="tblPager" runat="SERVER">
                                    <tr>
                                        <td><uc1:pager ID="Pager1" runat="server" />
                                            </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <input type=hidden runat=server id=hidSort/>
                    <asp:HiddenField ID="hidReport" runat="server" />
                    <asp:HiddenField ID="hidVersion" runat="server"/>                    
                </td>
            </tr>
        </table>
    </form>
    <script language="javascript">
    window.parent.document.getElementById("Progress").style.display='none';</script>
</body>
</html>
