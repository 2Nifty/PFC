<%@ Page Language="C#" AutoEventWireup="true" Trace="false" CodeFile="HitRateItemReport.aspx.cs"
    EnableEventValidation="false" ValidateRequest="false" Inherits="HitRateItemReport" %>

<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="~/InvoiceRegister/Common/UserControls/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="~/InvoiceRegister/Common/UserControls/Footer.ascx" TagName="BottomFooter"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Hit Rate Report - Category/Item Level</title>
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
        HitRateItemReport.DeleteExcel('HitRateItemReport'+session).value
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
                                            Hit Rate Report - Category/Item Level</td>
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
                <td class="LeftPadding TabHead" style="height: 10px" colspan="2">
                    <asp:UpdatePanel ID="pnlBranch" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <table cellspacing="0" cellpadding="0" height="20" width="100%">
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td valign="top" style="width: 150px">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td align="left" colspan="3">
                                                                <asp:Label ID="Label4" runat="server" Text="Category: " Width="55px" Height="20px"></asp:Label><asp:Label
                                                                    ID="lblCategory" runat="server" Width="80px" Height="20px"></asp:Label></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td valign="top" style="width: 150px">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td align="left" colspan="3">
                                                                <asp:Label ID="Label1" runat="server" Text="Region: " Width="48px" Height="20px"></asp:Label><asp:Label
                                                                    ID="lblRegion" runat="server" Width="80px" Height="20px"></asp:Label></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 10px; width: 120px;" valign="bottom">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td colspan="3" style="height: 14px">
                                                                <asp:Label ID="Label2" runat="server" Text="Days:" Width="30px" Height="20px"></asp:Label><asp:Label
                                                                    ID="lblDays" runat="server" Width="60px" Height="20px"></asp:Label></td>                                                            
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 10px; width: 220px;" valign="bottom">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td colspan="3" style="height: 14px">
                                                                <asp:Label ID="Label3" runat="server" Text="CSR:" Width="30px" Height="20px"></asp:Label><asp:Label
                                                                    ID="lblCSRName" runat="server" Width="120px" Height="20px"></asp:Label></td>                                                            
                                                        </tr>
                                                    </table>
                                                </td>
                                                
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="right" style="padding-right: 10px;" valign="bottom">
                                        <asp:UpdateProgress ID="upPanel" runat="server" DisplayAfter="10" DynamicLayout="false">
                                            <ProgressTemplate>
                                                <span style="padding-left: 5px; font-weight: bold; padding-top: 0px; color: Red;">Loading...</span>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="left" valign="top">
                    <asp:UpdatePanel ID="upnlGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                top: 0px; left: 0px; height: 530px; width: 1018px; border: 0px solid;">
                                <asp:GridView UseAccessibleHeader="true" PagerSettings-Visible="false" 
                                    ID="gvHitRate" runat="server" ShowHeader="true" ShowFooter="true" AllowSorting="True"
                                    AutoGenerateColumns="false" OnRowDataBound="gvHitRate_RowDataBound" OnSorting="gvHitRate_Sorting"
                                    AllowPaging="true">
                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" />
                                    <RowStyle CssClass="GridItem " BackColor="White" BorderColor="White" Height="19px"
                                        HorizontalAlign="Left" />
                                    <AlternatingRowStyle CssClass="GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                        HorizontalAlign="Left" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" />
                                    <EmptyDataRowStyle VerticalAlign="Top" BorderWidth="0px" CssClass="GridHead" BackColor="#DFF3F9"
                                        HorizontalAlign="Center" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="PFC Item No" SortExpression="PFCItemNo">
                                            <ItemTemplate>
                                                <asp:Label ID="lblCategory" runat=server Text='<%#DataBinder.Eval(Container,"DataItem.PFCItemNo")%>' Width=100px></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign=center />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Desc" SortExpression="" Visible=false>
                                            <ItemTemplate>
                                                <asp:Label ID="lblRegion" runat=server Text="" Width=60px></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField HtmlEncode="False" DataField="LbsHitRate" HeaderText="Lbs"
                                            SortExpression="LbsHitRate" DataFormatString="{0:#,##0.0}">
                                            <ItemStyle HorizontalAlign="Right" Width="45px" Wrap="False" />    
                                            <FooterStyle HorizontalAlign="Right" Width="45px" Wrap="False" />                                                                                    
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="AvlHitRate" HeaderText="AvlHitRate"
                                            SortExpression="AvlHitRate" DataFormatString="{0:#,##0.0}">
                                            <ItemStyle HorizontalAlign="Right" Width="45px" Wrap="False" />   
                                            <FooterStyle HorizontalAlign="Right" Width="45px" Wrap="False" />                                             
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="LnCntHitRage" HeaderText="LnCntHitRage"
                                            SortExpression="LnCntHitRage" DataFormatString="{0:#,##0.0}">
                                            <ItemStyle HorizontalAlign="Right" Width="45px" />     
                                            <FooterStyle HorizontalAlign="Right" Width="45px" />                                           
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="ValueHitRate" HeaderText="ValueHitRate"
                                            SortExpression="ValueHitRate" DataFormatString="{0:#,##0.0}">
                                            <ItemStyle HorizontalAlign="Right" Width="45px" Wrap="True" />     
                                            <FooterStyle HorizontalAlign="Right" Width="45px" Wrap="True" />                                        
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="GMHitRate" HeaderText="GMHitRate"
                                            SortExpression="GMHitRate" DataFormatString="{0:#,##0.0}">
                                            <ItemStyle HorizontalAlign="Right" Width="45px" />          
                                            <FooterStyle HorizontalAlign="Right" Width="45px" />                                      
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="ValueOGQty" HeaderText="ValueOGQty"
                                            SortExpression="ValueOGQty" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Width="93px" />    
                                            <FooterStyle HorizontalAlign="Right" Width="93px" />                                           
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="ValueMOQty" HeaderText="ValueMOQty"
                                            SortExpression="ValueMOQty" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="95px" />    
                                            <FooterStyle HorizontalAlign="Right" Wrap="False" Width="95px" />                                         
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="GMOGQty" HeaderText="GMOGQty" 
                                            SortExpression="GMOGQty" DataFormatString="{0:#,##0}">
                                           <ItemStyle HorizontalAlign="Right" Width="90px" />   
                                           <FooterStyle HorizontalAlign="Right" Width="90px" />                                                                                     
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="GMMOQty" HeaderText="GMMOQty" 
                                            SortExpression="GMMOQty" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="95px" />    
                                            <FooterStyle HorizontalAlign="Right" Wrap="False" Width="95px" />                                         
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="GMOG" HeaderText="GMOG"
                                            SortExpression="GMOG"  DataFormatString="{0:#,##0.0}">
                                            <ItemStyle HorizontalAlign="Right" Width="40px" />
                                            <FooterStyle HorizontalAlign="Right" Width="40px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="GMMO" HeaderText="GMMO"
                                            SortExpression="GMMO" DataFormatString="{0:#,##0.0}">
                                            <ItemStyle HorizontalAlign="Right" Width="40px" />
                                            <FooterStyle HorizontalAlign="Right" Width="40px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="GMDiff" HeaderText="GMDiff" 
                                            SortExpression="GMDiff"  DataFormatString="{0:#,##0.0}">
                                            <ItemStyle HorizontalAlign="Right" Width="35px" />
                                            <FooterStyle HorizontalAlign="Right" Width="35px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="LbsOGQty" HeaderText="LbsOGQty" 
                                            SortExpression="LbsOGQty" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Width="96px" />     
                                            <FooterStyle HorizontalAlign="Right" Width="96px" />    
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="LbsMOQty" HeaderText="LbsMOQty"
                                            SortExpression="LbsMOQty" DataFormatString="{0:#,##0}">
                                           <ItemStyle HorizontalAlign="Right" Wrap="False" Width="90px" /> 
                                           <FooterStyle HorizontalAlign="Right" Wrap="False" Width="90px" />    
                                        </asp:BoundField>
                                        
                                        <asp:BoundField HtmlEncode="False" DataField="MOLineCnt" HeaderText="MOLineCnt"
                                            SortExpression="MOLineCnt" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Width="90px" />  
                                            <FooterStyle HorizontalAlign="Right" Width="90px" /> 
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="TotLineCnt" HeaderText="TotLineCnt"
                                            SortExpression="TotLineCnt" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="95px" /> 
                                            <FooterStyle HorizontalAlign="Right" Wrap="False" Width="95px" /> 
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="ValueOGPerLb" HeaderText="ValueOGPerLb"  DataFormatString="{0:#,##0.00}"
                                            SortExpression="ValueOGPerLb">
                                            <ItemStyle HorizontalAlign="Right" Width="90px" />  
                                            <FooterStyle HorizontalAlign="Right" Width="90px" />  
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="ValueMOPerLb" HeaderText="ValueMOPerLb"  DataFormatString="{0:#,##0.00}"
                                            SortExpression="ValueMOPerLb">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="95px" /> 
                                            <FooterStyle HorizontalAlign="Right" Wrap="False" Width="95px" /> 
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="GMOGPerLb" HeaderText="GMOGPerLb"  DataFormatString="{0:#,##0.00}"
                                            SortExpression="GMOGPerLb">
                                           <ItemStyle HorizontalAlign="Right" Width="90px" />  
                                           <FooterStyle HorizontalAlign="Right" Width="90px" />  
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="GMMOPerLb" HeaderText="GMMOPerLb"  DataFormatString="{0:#,##0.00}"
                                            SortExpression="GMMOPerLb">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="95px" /> 
                                            <FooterStyle HorizontalAlign="Right" Wrap="False" Width="95px" /> 
                                        </asp:BoundField>
                                    </Columns>
                                    <PagerSettings Visible="False" />
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
                        <uc2:BottomFooter ID="ucFooter" Title="Hit Rate Item Report" runat="server" />
                        <asp:HiddenField ID="hidShowMode" runat="server" />
                        <asp:HiddenField ID="hidFileName" Value="" runat="server" />                  
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
