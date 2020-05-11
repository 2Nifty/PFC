<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TheoreticalFillRateRpt.aspx.cs" Inherits="TheoreticalFillRate" %>

<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head2" runat="server">
    <title>Theoretical Fill Rate Report</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script language="javascript" type="text/javascript">
    
        function Close(session)
        {
            //alert('Test');
            Unload(session);
            TheoreticalFillRate.Close(session).value;
            parent.window.close();      //used parent. since page is inside a frame in the Progress bar page (iFrame1)
           
        }

        function Unload(session)
        {
            TheoreticalFillRate.DelExcel(session).value;
        }

    </script>
</head>
<body onunload="javascript:Unload('<%=Session["SessionID"].ToString() %>');">
    <form id="frmMain" runat="server" >
        <asp:ScriptManager runat="server" ID="smSKU">
        </asp:ScriptManager>
        <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse;" id="mainTable" >
            <tr>
                <td style="height:5%;">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <%--BEGIN MAIN--%>
                    <table id="tblMain" style="width: 100%;" class="blueBorder" cellpadding="0" cellspacing="0" >
                        <tr style="vertical-align:top;">
                            <td style="width: 1467px;">
                                <%--TITLE--%>
                                <table id="tblTitle" border="0" cellpadding="0" cellspacing="0" style="width: 100%" class="lightBlueBg">
                                    <tr>
                                        <td class="Left5pxPadd BannerText">
                                            Theoretical Fill Rate Report
                                        </td>

                                        <td align="right">
                                            <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                        </td>
                                        <td width="80px">
                                            <img align="right" onclick="javascript:Close('<%=Session["SessionID"].ToString() %>');"
                                                src="../Common/Images/Close.gif" style="cursor: hand; padding-right: 5px;" />
                                        </td>
                                    </tr>
                                </table>

                                <%--PARAMETERS--%>

                                <table cellspacing="0" cellpadding="0" height="40px" width="100%">
                                    <tr id="trHead" class="PageBg">
                                        <td class="LeftPadding TabHead" style="height: 10px" colspan="2">
                                            <asp:UpdatePanel ID="pnlBranch" UpdateMode="conditional" runat="server">
                                                <ContentTemplate>
                                                    <table cellspacing="0" cellpadding="0" height="40px" width="100%">
                                                        <tr>
                                                            <td width="175px">
                                                                <asp:Label ID="lblRollingMonths" runat="server" Text=""></asp:Label></td>                                                            
                                                            <td width="175px">
                                                                <asp:Label ID="lblAddAvailWO" runat="server" Text=""></asp:Label></td>
                                                            <td width="175px">
                                                                <asp:Label ID="lblAddAvailPO" runat="server" Text=""></asp:Label></td>
                                                            <td width="175px">
                                                                <asp:Label ID="lblAddAvailTI" runat="server" Text=""></asp:Label></td>
                                                            <td width="175px">
                                                                <asp:Label ID="lblPlatingCdList" runat="server" Text=""></asp:Label></td>    
                                                            <td width="*">&nbsp;</td>                                                            
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="lblStartLoc" runat="server" Text=""></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblEndLoc" runat="server"></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblLocList" runat="server"></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblStartCat" runat="server" Text=""></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblEndCat" runat="server" Text=""></asp:Label></td>
                                                             <td>
                                                                <asp:Label ID="lblCatList" runat="server" Text=""></asp:Label></td>    
                                                        </tr>
                                                       <%-- <tr>
                                                            <td>
                                                                <asp:Label ID="lblStartSize" runat="server" Text=""></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblEndSize" runat="server" Text=""></asp:Label></td>    
                                                            <td>
                                                                <asp:Label ID="lblSizeList" runat="server" Text=""></asp:Label></td>       
                                                            <td>
                                                                <asp:Label ID="lblStartVar" runat="server" Text=""></asp:Label></td>
                                                            <td >
                                                                <asp:Label ID="lblEndVar" runat="server" Text=""></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblVarList" runat="server" Text=""></asp:Label></td>
                                                        </tr>--%>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="lblStartCFV" runat="server" Text=""></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblEndCFV" runat="server"></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblCFVList" runat="server"></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblStartSVC" runat="server" Text=""></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblEndSVC" runat="server" Text=""></asp:Label></td>
                                                             <td>
                                                                <asp:Label ID="lblSVCList" runat="server" Text=""></asp:Label></td>    
                                                        </tr>
                                                   <%--     <%--<tr>
                                                            <%--<td>
                                                                <asp:Label ID="lblPkType" runat="server" Text=""></asp:Label></td>--%>
                                                           <%-- <td>
                                                                <asp:Label ID="lblPkTypeList" runat="server"></asp:Label></td>--%>
                                                            <%--<td>
                                                                <asp:Label ID="lblPlatingCdList" runat="server"></asp:Label></td> --%>                                                                                                              
                                                        
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                                <table cellpadding="0" border="0" cellspacing="0" width="100%" >
                                    <tr>
                                        <td align="left" valign="top">
                                            <asp:UpdatePanel ID="pnlGrid" UpdateMode="conditional" runat="server" >
                                                <ContentTemplate >
                                                    <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative; 
                                                        top: 0px; left: 0px; height: 500px; width: 1020px; border: 0px solid;">
                                                        <asp:GridView ID="gvSKU" runat="server" Width="1220px" PageSize="19" ShowHeader="true" ShowFooter="false" AutoGenerateColumns="false" 
                                                            UseAccessibleHeader="false" PagerSettings-Visible="false" AllowPaging="true" AllowSorting="true" 
                                                            OnRowDataBound="gvSKU_RowDataBound" OnSorting="gvSKU_Sorting" BorderWidth="0px">
                                                            <HeaderStyle CssClass="GridHead" Wrap="True" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Center" />
                                                            <RowStyle CssClass="Left5pxPadd GridItem " BackColor="White" BorderColor="White" Height="20px" HorizontalAlign="Right"  />
                                                            <AlternatingRowStyle CssClass="Left5pxPadd GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Right" />
                                                            <EmptyDataRowStyle CssClass="GridHead" BackColor="#DFF3F9" BorderWidth="0px" Height="20px" HorizontalAlign="Right"  />
                                                            <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Right" />
                                                            <Columns>
	                                                            <asp:BoundField HeaderText="Item No" DataField="ItemNo" SortExpression="ItemNo"
	                                                                HtmlEncode="False" >
                                                                    <FooterStyle CssClass="locked" />
                                                                    <HeaderStyle CssClass="locked" />
                                                                    <ItemStyle CssClass="locked" HorizontalAlign="Center" Width="90px" />
                                                                </asp:BoundField>
	                                                                
	                                                            <asp:BoundField HeaderText="Desc" DataField="ItemDesc" SortExpression="ItemDesc"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle HorizontalAlign="Left" Width="230px" />
                                                                </asp:BoundField>  
	                                                              
	                                                            <asp:BoundField HeaderText="CFV" DataField="CorpFixedVelocity" SortExpression="CorpFixedVelocity"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle HorizontalAlign="Center" Width="23px" />
                                                                </asp:BoundField>   
	                                                                
	                                                            <asp:BoundField HeaderText="Loc" DataField="Location" SortExpression="Location"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle HorizontalAlign="Center" Width="25px" />
                                                                </asp:BoundField>                                                       
	                                                              
	                                                            <asp:BoundField HeaderText="SVC" DataField="SalesVelocityCd" SortExpression="SalesVelocityCd"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle HorizontalAlign="Center" Width="23px" />
                                                                </asp:BoundField>                                                              
                            
                                                                <asp:BoundField HeaderText="Qty Avl" DataField="QtyAvail" SortExpression="QtyAvail" DataFormatString="{0:#,##0}"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle Width="50px" />
                                                                </asp:BoundField>
	                                                                
	                                                            <asp:BoundField HeaderText="Avail Wght" DataField="AvailWght" SortExpression="AvailWght" DataFormatString="{0:#,##0}"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle Width="50px" />
                                                                </asp:BoundField> 
	                                                               
	                                                            <asp:BoundField HeaderText="Net Sale Qty" DataField="NetSalesQty" SortExpression="NetSalesQty" DataFormatString="{0:#,##0}"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle Width="50px" />
                                                                </asp:BoundField>  
	                                                                
	                                                            <asp:BoundField HeaderText="Net Sale Wght" DataField="NetSaleWghtt" SortExpression="NetSaleWghtt" DataFormatString="{0:#,##0}"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle Width="65px" />
                                                                </asp:BoundField> 
	                                                                
	                                                            <asp:BoundField HeaderText="Month Lbs" DataField="MonthLbs" SortExpression="MonthLbs" DataFormatString="{0:#,##0}"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle Width="40px" />
                                                                </asp:BoundField>  
	                                                                
	                                                            <asp:BoundField HeaderText="Months Avail" DataField="MonthsAvail" SortExpression="MonthsAvail" DataFormatString="{0:#,##0.0}"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle Width="45px" />
                                                                </asp:BoundField>              
	                                                            
	                                                            <asp:BoundField HeaderText="Modifier Value" DataField="ModifierValueMo" SortExpression="ModifierValueMo" DataFormatString="{0:#,##0.00}"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle Width="45px" />
                                                                </asp:BoundField> 
	                                                                
	                                                            <asp:BoundField HeaderText="Corp Qty Avl+TI" DataField="BegQOH" SortExpression="BegQOH" DataFormatString="{0:#,##0}"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle Width="55px" />
                                                                </asp:BoundField> 
	                                                                
	                                                            <asp:BoundField HeaderText="Corp Months Avail" DataField="CorpMonthsAvail" SortExpression="CorpMonthsAvail" DataFormatString="{0:#,##0.0}"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle Width="45px" />
                                                                </asp:BoundField>    
	                                                                
	                                                            <asp:BoundField HeaderText="Corp Usage Wght" DataField="CorpUsage36MoWght" SortExpression="CorpUsage36MoWght" DataFormatString="{0:#,##0}"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle Width="50px" />
                                                                </asp:BoundField>  
	                                                                
	                                                            <asp:BoundField HeaderText="Pct to Total" DataField="Pct_To_Total" SortExpression="Pct_To_Total" DataFormatString="{0:#,##0.00}"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle Width="50px" />
                                                                </asp:BoundField>
	                                                            
	                                                            <asp:BoundField HeaderText="ModValue" DataField="ModValue" SortExpression="ModValue" DataFormatString="{0:#,##0.00}"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle Width="50px" />
                                                                </asp:BoundField>
                                                                	                                                            
	                                                            <asp:BoundField HeaderText="Cum. of Total" DataField="Running_Total" SortExpression="Running_Total" DataFormatString="{0:#,##0.00}"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle Width="50px" />
                                                                </asp:BoundField>   
                                                                
                                                                <asp:BoundField HeaderText="Co Fill Resip" DataField="MDiffPct_ModV" SortExpression="MDiffPct_ModV" DataFormatString="{0:#,##0.00}"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle Width="50px" />
                                                                </asp:BoundField>  
                                                                
                                                                <asp:BoundField HeaderText="T-Fill" DataField="TFill" SortExpression="TFill" DataFormatString="{0:#,##0.00}"
	                                                                HtmlEncode="False" >
                                                                    <ItemStyle Width="50px" />
                                                                </asp:BoundField> 
                                                                                 
                                                            </Columns>
                                                            <PagerSettings Visible="False" />
                                                        </asp:GridView>
                                                        <input type="hidden" runat="server" id="hidSort" />
                                                    </div>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>   
                <td class="lightBlueBg buttonBar" height="20px">
                    <table>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlStatus" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true" runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdateProgress ID="pnlProgress" runat="server" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>    <%--PAGER Control--%>
                <td>
                <div id="divPager" runat="server">
                    <uc3:pager ID="gvPager" runat="server" OnBubbleClick="gvPager_PageChanged" />
                </div>
                
                </td>
            
            </tr>

            <tr>
                <td>
                    <uc2:Footer ID="Footer1" Title="Theoretical Fill Rate Report" runat="server" />
                </td>
            </tr>
        </table>
    </form>
        <script>window.parent.document.getElementById("Progress").style.display='none';</script>
</body>
</html>

