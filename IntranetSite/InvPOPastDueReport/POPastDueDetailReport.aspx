<%@ Page Language="C#" AutoEventWireup="true" Trace="false" CodeFile="POPastDueDetailReport.aspx.cs"
    EnableEventValidation="false" ValidateRequest="false" Inherits="POPastDueDetailReport" %>

<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="~/InvoiceRegister/Common/UserControls/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="~/InvoiceRegister/Common/UserControls/Footer.ascx" TagName="BottomFooter"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>PO Past Due Report </title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
    function PrintReport()
    {  
        var WinPrint = window.open('print.aspx','Print','height=10,width=10,scrollbars=no,status=no,top=0,left=0,resizable=NO',"");       
    }   
    
    function BindValue(sortExpression)
    {     
        if(document.getElementById("hidSortExpression") !=null)
            document.getElementById("hidSortExpression").value= sortExpression;
        document.getElementById("btnSort").click();
    }
    // Javascript Function To Call Server Side Function Using Ajax
    function DeleteFiles(session)
    {
        POPastDueReport.DeleteExcel('POPastDueReport'+session).value
        parent.window.close();           
    }
    </script>

</head>
<body scroll="no" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="360000"
            EnablePartialRendering="true">
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
                                            PO Past Due Detail Report
                                        </td>
                                        <td align="right" style="width: 30%; padding-right: 5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/InvoiceRegister/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td>
                                                        <asp:UpdatePanel ID="UpdatePanel1" UpdateMode="conditional" runat="server">
                                                            <ContentTemplate>
                                                                <asp:ImageButton runat="server" Style="cursor: hand" ID="ibtnPrint" ImageUrl="~/InvoiceRegister/Common/Images/Print.gif"
                                                                    ImageAlign="middle" OnClick="ibtnPrint_Click" />
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                    <td>
                                                        <img align="right" src="Common/Images/Close.gif" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
                                                            style="cursor: hand; padding-right: 2px;" />
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
            <tr id="trHead" class="PageBg">
                <td class="TabHead" style="height: 10px" colspan="2">
                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                        <tr>
                            <td style="padding-left: 8px">
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td style="width: 81px">
                                            Report Group:</td>
                                        <td style="width: 218px">
                                            <asp:Label ID="lblReportGroup" runat="server" Text=""></asp:Label></td>     
                                        <td style="width: 64px">
                                            Buy Group:</td>
                                        <td style="width: 339px">
                                            <asp:Label ID="lblBugGroup" runat="server" Text=""></asp:Label></td>                                     
                                    </tr>
                                </table>
                            </td>
                            <td style="width: 100px">
                                        <asp:UpdateProgress ID="upPanel" runat="server" DisplayAfter="10" DynamicLayout="false">
                                            <ProgressTemplate>
                                                <span style="padding-left: 5px; font-weight: bold; padding-top: 0px; color: Red;">Loading...</span>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>            
            <tr>
                <td colspan="2" align="left" valign="top">
                    <asp:UpdatePanel ID="upnlGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                top: 0px; left: 0px; height: 545px; width: 1018px; border: 0px solid;">
                                <asp:GridView UseAccessibleHeader="true" PagerSettings-Visible="false" Width="850px"
                                    ID="gvPOPastDue" runat="server" ShowHeader="true" ShowFooter="false" AllowSorting="True"
                                    AutoGenerateColumns="false" OnRowDataBound="gvPOPastDue_RowDataBound" OnSorting="gvPOPastDue_Sorting"
                                    AllowPaging="true">
                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" />
                                    <RowStyle CssClass="GridItem " BackColor="White" BorderColor="White" Height="20px"
                                        HorizontalAlign="Left" />
                                    <AlternatingRowStyle CssClass="GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Left" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Right" />
                                    <EmptyDataRowStyle VerticalAlign="Top" BorderWidth="0px" CssClass="GridHead" BackColor="#DFF3F9"
                                        HorizontalAlign="Center" />
                                    <Columns>                                        
                                        <asp:TemplateField SortExpression="ItemNo" ItemStyle-HorizontalAlign="center" 
                                        HeaderText="Item No">
                                        <ItemTemplate>
                                            <asp:HyperLink ID="hplItemNo" Target="_blank" runat="server" Visible="true" 
                                                NavigateUrl='<%#  ConfigurationManager.AppSettings["SOESiteURL"].ToString() + "SSDocs.aspx?ItemNo=" + DataBinder.Eval(Container,"DataItem.ItemNo") + "&Type=PO" %>'
                                                Text='<%#DataBinder.Eval(Container,"DataItem.ItemNo")%>'></asp:HyperLink>                                            
                                        </ItemTemplate>                                                             
                                        <ItemStyle HorizontalAlign="Left" />                                            
                                        <HeaderStyle HorizontalAlign="Center" />
                                        </asp:TemplateField> 
                                        <asp:BoundField HtmlEncode="False" DataField="TotOpenPOQty" HeaderText="Tot Open PO Qty"
                                            SortExpression="TotOpenPOQty" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Width="40px" Wrap="False" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="40px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="TotOpenPOLbs" HeaderText="Tot Open PO Lbs"
                                            SortExpression="TotOpenPOLbs" DataFormatString="{0:#,##0.00}">
                                            <ItemStyle HorizontalAlign="Right" Width="75px" />
                                            <HeaderStyle Wrap="True" HorizontalAlign="Center" Width="75px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="OpenPOMosSupply" HeaderText="Open PO Mos Supply"
                                            SortExpression="OpenPOMosSupply" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Width="45px" Wrap="true" />
                                            <HeaderStyle Wrap="true" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="PastDueLbs" HeaderText="Past Due Lbs"
                                            SortExpression="PastDueLbs" DataFormatString="{0:#,##0.00}">
                                            <ItemStyle HorizontalAlign="Right" Width="75px" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="PastDueMos" HeaderText="Past Due Mos"
                                            SortExpression="PastDueMos" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Width="45px" Wrap="true"/>
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="CurLbs" HeaderText="Cur Lbs"
                                            SortExpression="CurLbs" DataFormatString="{0:#,##0.00}">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="65px" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="CurMos" HeaderText="Cur Mos" SortExpression="CurMos"
                                             DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Width="45px" Wrap="True" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="Fut1Lbs" HeaderText="Future 1 Lbs" 
                                            SortExpression="Fut1Lbs" DataFormatString="{0:#,##0.00}">
                                            <ItemStyle HorizontalAlign="Right" Width="55px" Wrap="True" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="Fut1Mos" HeaderText="Future 1 Mos" DataFormatString="{0:#,##0}"
                                            SortExpression="Fut1Mos">
                                            <ItemStyle HorizontalAlign="Right" Width="45px" Wrap="True" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                       <asp:BoundField HtmlEncode="False" DataField="Fut2Lbs" HeaderText="Future 2 Lbs" 
                                            SortExpression="Fut2Lbs" DataFormatString="{0:#,##0.00}">
                                            <ItemStyle HorizontalAlign="Right" Width="55px" Wrap="True" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="Fut2Mos" HeaderText="Future 2 Mos" DataFormatString="{0:#,##0}"
                                            SortExpression="Fut2Mos">
                                            <ItemStyle HorizontalAlign="Right" Width="45px" Wrap="True" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="Fut3Lbs" HeaderText="Future 3 Lbs" 
                                            SortExpression="Fut3Lbs" DataFormatString="{0:#,##0.00}">
                                            <ItemStyle HorizontalAlign="Right" Width="55px" Wrap="True" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="Fut3Mos" HeaderText="Future 3 Mos" DataFormatString="{0:#,##0}"
                                            SortExpression="Fut3Mos">
                                            <ItemStyle HorizontalAlign="Right" Width="45px" Wrap="True" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                                <div align="center">
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label></div>
                                <input type="hidden" runat="server" id="hidSortExpression" />
                                <asp:Button ID="btnSort" runat="server" Text="" Style="display: none;" OnClick="btnSort_Click" />
                                <input type="hidden" runat="server" id="hidSort" />
                            </div>
                            <div id="divPager" runat="server">
                                <uc3:pager ID="pager" runat="server" OnBubbleClick="Pager_PageChanged" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>            
            <tr>
                <td colspan="2" valign="top">                    
                        <uc2:BottomFooter ID="ucFooter" Title="PO Past Due Detail Report" runat="server" />
                        <asp:HiddenField ID="hidShowMode" runat="server" />
                        <asp:HiddenField ID="hidFileName" Value="" runat="server" />                  
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
