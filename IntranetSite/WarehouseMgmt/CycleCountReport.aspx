<%@ Page Language="C#" AutoEventWireup="true" Trace="false" CodeFile="CycleCountReport.aspx.cs" 
    EnableEventValidation="false" ValidateRequest="false" Inherits="CycleCountReport" %>

<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="~/InvoiceRegister/Common/UserControls/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="~/InvoiceRegister/Common/UserControls/Footer.ascx" TagName="BottomFooter"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Cycle Count Report </title>
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
        CycleCountReport.DeleteExcel('CycleCountReport'+session).value
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
                                            Cycle Count Report&nbsp;</td>
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
                                                        <tr>
                                                            <td colspan="3">
                                                                <asp:Label ID="Label4" runat="server" Text="Branch:" Height="20px" Width="45px"></asp:Label><asp:Label
                                                                    ID="lblBranch" runat="server" Width="120px" Height="20px"></asp:Label></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 10px; width: 320px;" valign="bottom">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td colspan="3" style="height: 14px">
                                                                <asp:Label ID="Label3" runat="server" Text="Ending Date:" Width="75px" Height="20px"></asp:Label><asp:Label
                                                                    ID="lblEndDt" runat="server" Width="60px" Height="20px"></asp:Label></td>                                                            
                                                            <td colspan="1" style="height: 14px;padding-left:25px;" >
                                                                <asp:Label ID="Label2" runat="server" Height="20px" Text="Min Adjustment Value:"
                                                                    Width="126px"></asp:Label><asp:Label ID="lblMinAdjValue" runat="server" Height="20px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3" valign="middle" style="padding-right: 5px;">
                                                                <asp:Label ID="Label7" runat="server" Text="RF User Id:" Width="61px" Height="20px"></asp:Label><asp:Label
                                                                    ID="lblRFUserId" runat="server" Height="20px"></asp:Label></td>                                                            
                                                            <td colspan="1" style="padding-right: 5px" valign="middle">
                                                            </td>
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
                                top: 0px; left: 0px; height: 520px; width: 1018px; border: 0px solid;">
                                <asp:GridView UseAccessibleHeader="true" PagerSettings-Visible="false" 
                                    ID="gvCycleCount" runat="server" ShowHeader="true" ShowFooter="true" AllowSorting="True"
                                    AutoGenerateColumns="false" OnRowDataBound="gvCycleCount_RowDataBound" OnSorting="gvCycleCount_Sorting"
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
                                        <asp:BoundField HeaderText="RF User ID" DataField="UserID" SortExpression="UserID">
                                            <ItemStyle HorizontalAlign="Left" CssClass="Left5pxPadd" />                                            
                                            <HeaderStyle HorizontalAlign="Center" Width=80px />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" HeaderText="Type" DataField="Type"
                                            SortExpression="Type" >
                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />                                            
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width=80px />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="DATE_Time" HeaderText="Created Date"
                                            SortExpression="DATE_Time">
                                            <ItemStyle HorizontalAlign="Left" Width="75px" Wrap="False" />                                            
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="75px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="Extended" HeaderText="PFC Item No"
                                            SortExpression="Extended">
                                            <ItemStyle HorizontalAlign="Left" Width="90px" Wrap="False" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="90px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="ItemDesc" HeaderText="Item Desc"
                                            SortExpression="ItemDesc" >
                                            <ItemStyle HorizontalAlign="Left" Width="200px" />
                                            <HeaderStyle Wrap="True" HorizontalAlign="Center" Width="200px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="Binlabel" HeaderText="Bin Label"
                                            SortExpression="Binlabel">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" Wrap="True" />
                                            <HeaderStyle Wrap="True" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="adjQty" HeaderText="Adj. Qty"
                                            SortExpression="adjQty" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="ExtValue" HeaderText="Ext. Value"
                                            SortExpression="ExtValue" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="Reason" HeaderText="Reason"
                                            SortExpression="Reason">
                                            <ItemStyle HorizontalAlign="Center" Wrap="False" Width="80px" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
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
                        <uc2:BottomFooter ID="ucFooter" Title="Cycle Count Report" runat="server" />
                        <asp:HiddenField ID="hidShowMode" runat="server" />
                        <asp:HiddenField ID="hidFileName" Value="" runat="server" />                  
                </td>
            </tr>
        </table>
    </form>
     <script>window.parent.document.getElementById("Progress").style.display='none';</script>
</body>
</html>
