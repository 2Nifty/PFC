<%@ Page Language="C#" AutoEventWireup="true" Trace="false" CodeFile="CostAnalysisReport.aspx.cs"
    EnableEventValidation="false" ValidateRequest="false" Inherits="CostingAnalysisReport" %>

<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="~/CostAnalysisReport/Common/UserControls/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="~/CostAnalysisReport/Common/UserControls/Footer.ascx" TagName="BottomFooter"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Cost Analysis Report </title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
    
    function PrintReport()
    {  
        var WinPrint = window.open('print.aspx','Print','height=10,width=10,scrollbars=no,status=no,top=0,left=0,resizable=NO',"");       
    }   
    
     function BindValue(sortExpression)
    {     
        //alert('test');
        if(document.getElementById("hidSortExpression") !=null)
            document.getElementById("hidSortExpression").value= sortExpression;
        document.getElementById("btnSort").click();
    }     
        
      // Javascript Function To Call Server Side Function Using Ajax
    function DeleteFiles(session)
    {   //alert('testo');
        CostingAnalysisReport.DeleteExcel('CostingAnalysisReport'+session).value
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
                <td id="tdHeader" colspan="2" style="width: 1032px; height: 5%">
                    <uc1:Header ID="ucHeader" runat="server" />
                </td>
            </tr>
            <tr>
                <td valign="top" colspan="2" style="width: 1032px">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="PageHead" colspan="4" style="height: 30px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td class="Left5pxPadd BannerText" width="70%">
                                            Cost Analysis by Branch 
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
                                                        <img align="right" src="../Common/Images/Close.gif" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
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
                <td class="LeftPadding TabHead" style="height: 10px; width: 1032px;" colspan="2">
                    <asp:UpdatePanel ID="pnlResVer" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <table cellspacing="0" cellpadding="0" height="40" width="100%">
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td valign="top" style="width: 220px">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td align="left" colspan="3">
                                                                <asp:Label ID="Label1" runat="server" Text="Beginning Date: " Width="88px" Height="20px"></asp:Label><asp:Label
                                                                    ID="lblStartDt" runat="server" Width="80px" Height="20px"></asp:Label></td>
                                                        </tr>                                                       
                                                    </table>
                                                </td>
                                                <td valign="top" style="padding-left: 10px; width: 220px;" >
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td colspan="3" style="height: 14px">
                                                                <asp:Label ID="Label3" runat="server" Text="Ending Date:" Width="75px" Height="20px"></asp:Label><asp:Label
                                                                    ID="lblEndDt" runat="server" Width="60px" Height="20px"></asp:Label></td>                                                            
                                                        </tr>                                                        
                                                    </table>
                                                </td>
                                                <td valign="top" style="width: 420px">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td align="left" colspan="3">
                                                                <asp:Label ID="label36" runat="server" Text="Restricted: " Width="88px" Height="20px"></asp:Label><asp:Label
                                                                    ID="lblRestrictedVer" runat="server" Width="80px" Height="20px"></asp:Label></td>
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
                <td colspan="2" align="left" valign="top" style="width: 1032px">
                    <asp:UpdatePanel ID="upnlGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                top: 0px; left: 0px; height: 510px; width: 1018px; border: 0px solid;">
                                <asp:GridView PagerSettings-Visible="false" 
                                    ID="gvCostMetrics" runat="server" ShowFooter="True" AllowSorting="True"
                                    AutoGenerateColumns="False" OnRowDataBound="gvCostMetrics_RowDataBound" OnSorting="gvCostMetrics_Sorting"
                                    AllowPaging="True">
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
                                        <asp:BoundField HeaderText="Branch" DataField="Branch" SortExpression="Branch">
                                            <ItemStyle HorizontalAlign="Left" CssClass="Left5pxPadd" Width="105px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle HorizontalAlign="Center" Width="99px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="ExtSell" HeaderText="Sales" DataFormatString="{0:#,##0.00}"
                                            SortExpression="ExtSell">
                                            <ItemStyle HorizontalAlign="Right" Width="75px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="65px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="RplCost" HeaderText="Replacement" DataFormatString="{0:#,##0.00}"
                                            SortExpression="RplCost">
                                            <ItemStyle HorizontalAlign="Right" Width="75px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="65px" />
                                        </asp:BoundField>                                        
                                        <asp:BoundField HtmlEncode="False" DataField="SmthAvg" HeaderText="Smooth Avg" DataFormatString="{0:#,##0.00}"
                                            SortExpression="SmthAvg" >
                                            <ItemStyle HorizontalAlign="Right" Width="75px" Wrap="False" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="65px" />
                                        </asp:BoundField>                                        
                                        <asp:BoundField HtmlEncode="False" DataField="AvgCost" HeaderText="Average" DataFormatString="{0:#,##0.00}"
                                            SortExpression="AvgCost" >
                                            <ItemStyle HorizontalAlign="Right" Width="75px" Wrap="False" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="65px" />
                                        </asp:BoundField>  
                                                                              
                                        <asp:BoundField HtmlEncode="False" ReadOnly="True" ShowHeader="False">
                                            <ItemStyle HorizontalAlign="Center" Wrap="False" Width="10px" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Right" Width="10px" />
                                        </asp:BoundField>
                                        
                                        <asp:BoundField HtmlEncode="False" DataField="GMRplPct" HeaderText="Replacement" DataFormatString="{0:#,##0.0}"
                                            SortExpression="GMRplPct">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="75px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="True" HorizontalAlign="Center" Width="95px" />
                                        </asp:BoundField>
                                        
                                        <asp:BoundField HtmlEncode="False" DataField="GMSmthAvgPct" HeaderText="Smooth Avg" DataFormatString="{0:#,##0.0}"
                                            SortExpression="GMSmthAvgPct">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="75px"  />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="95px"  />
                                        </asp:BoundField>
                                        
                                        <asp:BoundField HtmlEncode="False" DataField="GMAvgPct" HeaderText="Average" DataFormatString="{0:#,##0.0}"
                                            SortExpression="GMAvgPct" >
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="75px"  />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="95px"  />
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
                <td colspan="2" valign="top" style="width: 1013px">                    
                        <uc2:BottomFooter ID="ucFooter" Title="Cost Analysis By Branch" runat="server" />
                        <asp:HiddenField ID="hidShowMode" runat="server" />
                        <asp:HiddenField ID="hidFileName" Value="" runat="server" />                  
                </td>
            </tr>
        </table>
    </form>
</body>
</html>


                                      