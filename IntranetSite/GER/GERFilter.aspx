<%@ Page Language="C#" AutoEventWireup="true" Trace="false" CodeFile="GERFilter.aspx.cs"
    EnableEventValidation="false" ValidateRequest="false" Inherits="GERBOLSearch" %>

<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="~/InvoiceRegister/Common/UserControls/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="~/InvoiceRegister/Common/UserControls/Footer.ascx" TagName="BottomFooter"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>GER BOL Search</title>
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
    function PrintReport()
    {  
        var WinPrint = window.open('print.aspx','Print','height=10,width=10,scrollbars=no,status=no,top=0,left=0,resizable=NO',"");       
    }   
    
    // Javascript Function To Call Server Side Function Using Ajax
    function DeleteFiles(session)
    {
        GERBOLSearch.DeleteExcel('GERBOLExport'+session).value
        parent.window.close();           
    }
    
    function ShowCatPriceSchedule(custNo)
    {
        var winHnd = window.open('../CustomerMaintenance/CatPriceSchedMaint.aspx?CustNo=' + custNo ,'CatPriceSchedMaint','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=yes','');	
        winHnd.focus();          
    }
    </script>

    <style>
    .Right5pxPadd 
    {
	    padding-Right: 10px;
    }
    </style>
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
                                            GER BOL Search Results</td>
                                        <td align="right" style="width: 30%; padding-right: 5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td>
                                                        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="conditional">
                                                            <ContentTemplate>
                                                                <asp:ImageButton ID="ibtnPrint" runat="server" ImageAlign="middle" ImageUrl="~/InvoiceRegister/Common/Images/Print.gif"
                                                                    OnClick="ibtnPrint_Click" Style="cursor: hand" />
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                    <td style="padding-right:3px;" valign="middle">
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td valign="middle">
                                                        <img align="right" src="../Common/images/close.gif" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
                                                            style="cursor: hand;" />
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
                <td class="LeftPadding TabHead" colspan="2">
                    <table cellspacing="0" border="0" cellpadding="0" height="20" width="100%">
                        <tr>
                            <td style="height:20px;" align="center" valign="middle">
                                Item #&nbsp;<asp:Label ID="lblItemNo" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                Container #&nbsp;<asp:Label ID="lblContainerNo" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                PO #&nbsp;<asp:Label ID="lblPONo" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                Loc:&nbsp;<asp:Label ID="lblLocation" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                Start Dt:&nbsp;<asp:Label ID="lblStartDt" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                End Dt:&nbsp;<asp:Label ID="lblEndDt" runat="server"></asp:Label>
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
                </td>
            </tr>
            <tr>
                <td colspan="2" align="left" valign="top">
                    <asp:UpdatePanel ID="upnlGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                top: 0px; left: 0px; height: 518px; width: 950px; border: 0px solid;">
                                <asp:GridView ID="gvBOLHist" runat="server" AllowPaging="True" OnRowDataBound="gvBOLHist_RowDataBound"
                                    AutoGenerateColumns="false" AllowSorting="True" OnSorting="gvBOLHist_Sorting"
                                    UseAccessibleHeader="False">
                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" Width="70px" />
                                    <RowStyle CssClass="GridItem Right5pxPadd" BackColor="White" BorderColor="White"
                                        Height="19px" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                        HorizontalAlign="Right" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Right" />
                                    <EmptyDataRowStyle VerticalAlign="Top" BorderWidth="0px" CssClass="GridHead" BackColor="#DFF3F9"
                                        HorizontalAlign="Right" />
                                    <PagerSettings Visible="False" />
                                    <Columns>
                                        <asp:TemplateField SortExpression="BOLNo" ItemStyle-HorizontalAlign="Left"
                                            ItemStyle-Wrap="false" HeaderText="BOL #" HeaderStyle-HorizontalAlign="center"
                                            HeaderStyle-Width="90" ItemStyle-Width="90" HeaderStyle-Wrap="false">
                                            <ItemTemplate>
                                                <asp:HyperLink style="padding-left:5px;" ID="hplBOLNo" Font-Underline=true runat="server" Visible="true" NavigateUrl='<%# "BOLHistDetail.aspx?BOLNo=" + DataBinder.Eval(Container,"DataItem.BOLNo") %>'
                                                    Text='<%# DataBinder.Eval(Container,"DataItem.BOLNo")%>'></asp:HyperLink>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ContainerNo" HeaderText="Container #" SortExpression="ContainerNo">
                                            <HeaderStyle HorizontalAlign="Center" Width="90px" />
                                            <ItemStyle HorizontalAlign="Left" Width="90px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="VendInvNo" HeaderText="Vendor #" SortExpression="VendInvNo">
                                            <HeaderStyle HorizontalAlign="Center" Width="90px" />
                                            <ItemStyle HorizontalAlign="Left" Width="90px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="EntryDt" HeaderText="Entry Date" SortExpression="EntryDt">
                                            <HeaderStyle HorizontalAlign="Center" Width="90px" />
                                            <ItemStyle HorizontalAlign="Left" Width="90px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="PFCItemNo" HeaderText="PFC Item #" SortExpression="PFCItemNo">
                                            <HeaderStyle HorizontalAlign="Center" Width="90px" />
                                            <ItemStyle HorizontalAlign="Left" Width="90px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="PFCItemDesc" HeaderText="Description" SortExpression="PFCItemDesc">
                                            <HeaderStyle HorizontalAlign="Center" Width="90px" />
                                            <ItemStyle HorizontalAlign="Left" Width="310px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="PFCPONo" HeaderText="PO #" SortExpression="PFCPONo">
                                            <HeaderStyle HorizontalAlign="Center" Width="90px" />
                                            <ItemStyle HorizontalAlign="Left" Width="90px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="PFCLocNo" HeaderText="PFC Location" SortExpression="PFCLocNo">
                                            <HeaderStyle HorizontalAlign="Center" Width="70px" />
                                            <ItemStyle HorizontalAlign="Left" Width="70px" />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                                <div align="center">
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label></div>
                                <input type="hidden" runat="server" id="hidSortExpression" />
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
                    <uc2:BottomFooter ID="ucFooter" Title="GER BOL Search" runat="server" />
                    <asp:HiddenField ID="hidShowMode" runat="server" />
                    <asp:HiddenField ID="hidFileName" Value="" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
