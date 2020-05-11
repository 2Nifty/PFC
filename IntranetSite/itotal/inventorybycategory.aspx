<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InventoryByCategory.aspx.cs"
    Inherits="PFC.Intranet.ITotalReports.InventoryByCategory" %>

<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Inventory By Category</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
<link href="../ITotal/Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="Common/Javascript/Common.js"></script>
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script>
     function showProgress()
    {
    
    window.parent.document.getElementById("Progress").style.display='';
  
    }
    function PrintReport(url)
    {
        var hwin=window.open('InventoryByCategoryPreview.aspx?'+url, 'InventoryByCategoryPreview', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (1010/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
        hwin.focus();
    }
    
    // Javascript Function To Call Server Side Function Using Ajax
    function DeleteFiles(session)
    {
        var str=InventoryByCategory.DeleteExcel('BranchItemDetail_'+session).value.toString();
        parent.window.close();
    }
    
    function BindValue(sortExpression)
    { 
        if(document.getElementById("hidSortExpression") !=null)
            document.getElementById("hidSortExpression").value= sortExpression;
        document.getElementById("btnSort").click();
    }
    </script>

</head>
<body onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
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
                                            Inventory By Category </td>
                                        <td align="right" style="width: 280px; padding-right: 3px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td>
                                                        <asp:UpdatePanel ID="UpdatePanel1" UpdateMode="conditional" runat="server">
                                                            <ContentTemplate>
                                                                <asp:ImageButton runat="server" Style="cursor: hand" ID="ibtnPrint" ImageUrl="~/Common/Images/Print.gif"
                                                                    ImageAlign="middle" OnClick="ibtnPrint_Click" />
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                    <td>
                                                        <img align="right" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
                                                            src="Common/Images/Close.gif" style="cursor: hand; padding-right: 2px;" /></td>
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
                <td class="LeftPadding TabHead" style="height: 10px" colspan="2" align="right">
                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                        <tr>
                            <td align="right">
                                <asp:UpdatePanel ID="pnlBranch" UpdateMode="always" runat="server">
                                    <ContentTemplate>
                                        <table cellspacing="0" cellpadding="0" style="padding-right: 15px">
                                            <tr>
                                                <td class="Left2pxPadd boldText">Bulk/Pkg</td> 
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    <asp:DropDownList ID="ddlPkgType" runat="server" Width="120px" CssClass="FormCtrl" AutoPostBack="True" OnSelectedIndexChanged="ddlPkgType_SelectedIndexChanged">
                                                        <asp:ListItem Text="ALL" Selected="True" Value="ALL"></asp:ListItem>
                                                        <asp:ListItem Text="Bulk Items" Value="BULK"></asp:ListItem>
                                                        <asp:ListItem Text="Pkg Items" Value="PKG"></asp:ListItem>
                                                    </asp:DropDownList>  
                                                </td> 
                                                <td style="width: 315px" colspan="" >
                                                    &nbsp;</td>                                                     
                                                
                                              <%--  <td style="padding-right:560px;">
                                                    <asp:CheckBox ID="chkShowBULK" runat="server" ForeColor="#CC0000" Text="Show BULK Only " AutoPostBack="True"/></td>--%>
                                            
                                                <td width="100" style="padding-right: 15px">
                                                    <asp:Label ID="lblPeriod" runat="server" Text=""></asp:Label>
                                                </td>
                                                <td align="right">
                                                    <img src="Common/Images/btn_showcal.gif" id="imgShow" onclick="ShowPanel();" />
                                                    <img src="Common/Images/btn_hidecal.gif" style="display: none;" id="imgHide" onclick="javascript: document.getElementById('leftPanel').style.display='none';document.getElementById('imgShow').style.display='';this.style.display='none';document.getElementById('div-datagrid').style.width='1010px';hidShowMode.value='Hide';" /></td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <asp:UpdatePanel ID="upnlCalendar" UpdateMode="always" runat="server">
                        <ContentTemplate>
                            <table cellspacing="0" cellpadding="0" id="leftPanel" style="display: none;" height="523">
                                <tr>
                                    <td valign="top" style="background-color: #F4FBFD; border-right-width: 1px; border-right-style: solid;
                                        border-right-color: #8CD5EA;" height="493">
                                        <table id="LeftMenuContainer" width="170" border="0" cellspacing="0" cellpadding="2">
                                            <tr>
                                                <td class="ShowHideBarBk" id="HideLabel">
                                                    <div align="right">
                                                        Select Date
                                                    </div>
                                                </td>
                                                <td width="1" class="ShowHideBarBk">
                                                    <div align="right" id="SHButton">
                                                        <img id="Hide" style="cursor: hand" src="../Common/Images/HidButton.gif" width="22"
                                                            height="21" onclick="ShowHide('Hide')"></div>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                            </tr>
                                        </table>
                                        <table id="LeftMenu" width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="redhead Left5pxPadd">
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td width="100%" valign="top" style="padding-left: 5px">
                                                    <asp:Calendar BorderColor="#DAEEEF" ID="cldStartDt" runat="server" Visible="true"
                                                        Width="150px" ></asp:Calendar>
                                                </td>
                                            </tr>
                                              <tr>
                                        <td>
                                            &nbsp;</td>
                                    </tr>
                                    <tr valign="top">
                                        <td width="100%" align="center" class=" Left5pxPadd">
                                        <asp:ImageButton runat="server" ID="ibtnRunReport" OnClientClick="javascript:showProgress();" ImageUrl="Common/Images/runreport.gif"
                                                                    ImageAlign="middle" OnClick="ibtnRunReport_Click" />
                                        </td></tr>

                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td align="left" valign="top">
                    <asp:UpdatePanel ID="upnlGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow-x: scroll; overflow-y: hidden;
                                position: relative; top: 0px; left: 0px; height: 498px; width: 1010px; border: 0px solid;">
                                <asp:GridView UseAccessibleHeader="false" PagerSettings-Visible="false" PageSize="17" ID="dvBIOnhand" Width="1150px"
                                    runat="server" AllowPaging="true" ShowHeader="true" ShowFooter="true" AllowSorting="true"
                                    AutoGenerateColumns="false" OnRowDataBound="dvBIOnhand_RowDataBound" OnSorting="dvBIOnhand_Sorting">
                                    <HeaderStyle CssClass="GridHead" Wrap="false" BackColor="#DFF3F9" BorderColor="#DAEEEF"
                                        Height="20px" HorizontalAlign="Center" />
                                    <RowStyle CssClass=" GridItem Left5pxPadd" BackColor="White" BorderColor="White"
                                        Height="20px" HorizontalAlign="Left" />
                                    <AlternatingRowStyle CssClass=" GridItem Left5pxPadd" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                        HorizontalAlign="Left" />
                                    <FooterStyle CssClass="GridHead Right5pxPadd" BackColor="#DFF3F9" BorderColor="#DAEEEF"
                                        Height="20px" HorizontalAlign="Right" />
                                    <EmptyDataRowStyle VerticalAlign="top" BorderWidth="0" CssClass="GridHead" BackColor="#DFF3F9"
                                        HorizontalAlign="Center" />
                                    <Columns>
                                        <asp:TemplateField SortExpression="Category" HeaderText="Category" FooterStyle-CssClass="Right5pxPadd"
                                            FooterStyle-HorizontalAlign="Left" HeaderStyle-Width="200px">
                                            <ItemTemplate>
                                                <asp:HyperLink ID="hplInvByCatItem" runat="server" Visible="true" Text='<%# DataBinder.Eval(Container,"DataItem.CatDesc") %>'
                                                    NavigateUrl='<%# "InvByCategoryItem.aspx?Period="+ cldStartDt.SelectedDate.ToShortDateString() +"&Category="+ DataBinder.Eval(Container,"DataItem.Category")+"&CategoryDesc="+ DataBinder.Eval(Container,"DataItem.CatDesc") %>'></asp:HyperLink>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField SortExpression="BrDol" HeaderText="$" FooterStyle-CssClass="Right5pxPadd">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" />
                                            <ItemTemplate>
                                                <asp:HyperLink ID="hplInvByCatBr" runat="server" Visible="true" Text='<%# String.Format("{0:#,##0}",DataBinder.Eval(Container,"DataItem.BrDol")) %>'
                                                    NavigateUrl='<%# "InvByCategoryBranch.aspx?Period="+ cldStartDt.SelectedDate.ToShortDateString() +"&Category="+ DataBinder.Eval(Container,"DataItem.Category")+"&CategoryDesc="+ DataBinder.Eval(Container,"DataItem.CatDesc") %>'></asp:HyperLink>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField HeaderText="Lbs" HtmlEncode="false" DataFormatString="{0:#,##0}" DataField="BrLB" SortExpression="BrLB" FooterStyle-CssClass="Right5pxPadd">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="$/Lbs" HtmlEncode="false" DataField="BrDolPerLb" FooterStyle-CssClass="Right5pxPadd"
                                            SortExpression="BrDolPerLb" DataFormatString="{0:#,##0.000}">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="50px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="$" HtmlEncode="false" DataField="CarTrDol" SortExpression="CarTrDol"
                                            FooterStyle-CssClass="Right5pxPadd" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Lbs" HtmlEncode="false" DataField="CarTrLB" SortExpression="CarTrLB"
                                            FooterStyle-CssClass="Right5pxPadd" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Width="60px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Car$/Lbs" HtmlEncode="false" DataField="CarTrDolPerLb"
                                            SortExpression="CarTrDolPerLb" DataFormatString="{0:#,##0.000}">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="50px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Intra$" HtmlEncode="false" DataField="IntraTrDol" SortExpression="IntraTrDol"
                                            FooterStyle-CssClass="Right5pxPadd" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="60px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="IntraLbs" HtmlEncode="false" DataField="IntraTrLB" SortExpression="IntraTrLB"
                                            FooterStyle-CssClass="Right5pxPadd" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="60px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="intra$/Lbs" HtmlEncode="false" DataField="IntraTrDolPerLb"
                                            SortExpression="IntraTrDolPerLb" DataFormatString="{0:#,##0.000}">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="50px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="OTW$" HtmlEncode="false" DataField="OTWDol" SortExpression="OTWDol"
                                            FooterStyle-CssClass="Right5pxPadd" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="60px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="OTWLbs" HtmlEncode="false" DataField="OTWLB" SortExpression="OTWLB"
                                            FooterStyle-CssClass="Right5pxPadd" DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="60px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="OTW$/Lbs" HtmlEncode="false" DataField="OTWDolPerLb"
                                            SortExpression="OTWDolPerLb" DataFormatString="{0:#,##0.000}">
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" Width="50px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" HeaderText="30D Usage $"  SortExpression="ThirtyDayDol" DataField="ThirtyDayDol"
                                            DataFormatString="{0:#,##0}">
                                            <ItemStyle HorizontalAlign="Right" Width="70px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Months On-Hand" HtmlEncode="false" DataField="MOH" SortExpression="MOH"
                                            DataFormatString="{0:#,##0.0}">
                                            <ItemStyle HorizontalAlign="Right" Width="50px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                                <div style="width: 100%;" align="center">
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label></div>
                                <input type="hidden" runat="server" id="hidSortExpression" />
                                <asp:Button ID="btnSort" runat="server" Text="" Style="display: none;" OnClick="btnSort_Click" />
                                <input type="hidden" runat="server" id="hidSort" />
                                <input type="hidden" runat="server" id="hidPeriod" />
                            </div>
                            <div  >
                                <uc3:pager ID="Pager" runat="server" OnBubbleClick="Pager_PageChanged" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="BluBg buttonBar" colspan="2" height="20px" style="border-top: solid 1px #DAEEEF">
                    <table cellpadding="0" cellspacing="0" style="padding-top: 1px;">
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="always">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" valign="top">
                    <table width="100%">
                        <uc2:BottomFooter ID="ucFooter" Title="PFC I Total Report" runat="server" />
                        <asp:HiddenField ID="hidShowMode" runat="server" />
                        <asp:HiddenField ID="hidFileName" Value="" runat="server" />
                    </table>
                </td>
            </tr>
        </table>
    </form>

    <script>
    if (document.getElementById('hidShowMode').value == "Show")
    {
        document.getElementById('leftPanel').style.display='';
        document.getElementById('imgHide').style.display='';
        document.getElementById('imgShow').style.display='none';
        document.getElementById('div-datagrid').style.width='830px';
        document.getElementById('hidShowMode').value='Show';
    }
    </script>
    <script language="javascript">
    window.parent.document.getElementById("Progress").style.display='none';</script>

</body>
</html>
