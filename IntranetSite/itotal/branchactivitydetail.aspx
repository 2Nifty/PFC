<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BranchActivityDetail.aspx.cs"
    Inherits="PFC.Intranet.ITotalReports.BranchItemDetail" %>

<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Branch Activity Detail Report</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
<link href="../ITotal/Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="Common/Javascript/Common.js"></script>

    <script>
    function PrintReport(url)
    {
        var hwin=window.open('BranchActivityDetailPreview.aspx?'+url, 'BranchActivityDetail', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (1010/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
        hwin.focus();
    }
    
    // Javascript Function To Call Server Side Function Using Ajax
    function DeleteFiles(session)
    {
        var str=BranchItemDetail.DeleteExcel('BranchActivityDetail_'+session).value.toString();
        parent.window.close();
    }
    
    function OpenBrActivityDetails(reportType)
    {        
        
        if(reportType == 'Receipts')
        {
            var url = "InvBrActivityReceipts.aspx?Period="+ document.getElementById("hidPeriod").value +"&Branch=" + <%= "'" + Request.QueryString["Branch"].ToString() + "'" %> +"&BranchDesc='" + <%= "'" + Request.QueryString["BranchDesc"].ToString() + "'" %> + "'";                       
            window.open(url ,'Receipts','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
            hwin.focus();
        }
        else if(reportType == "Issued")
        {
            var url = "InvBrActivityIssue.aspx?Period="+ document.getElementById("hidPeriod").value +"&Branch=" + <%= "'" + Request.QueryString["Branch"].ToString() + "'" %> +"&BranchDesc='" + <%= "'" + Request.QueryString["BranchDesc"].ToString() + "'" %> + "'";           
            window.open(url ,'Issued','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
            hwin.focus();
        }
         else if(reportType == "Adjusted")
        {
            var url = "InvBrActivityAdj.aspx?Period="+ document.getElementById("hidPeriod").value +"&Branch=" + <%= "'" + Request.QueryString["Branch"].ToString() + "'" %> +"&BranchDesc='" + <%= "'" + Request.QueryString["BranchDesc"].ToString() + "'" %> + "'";           
            window.open(url ,'Issued','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
            hwin.focus();
        }
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
                                              Inventory Branch Activity Detail</td>
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
                            <td width="200px" align="left">
                                <asp:Label ID="lblBranch" runat="server" Text=""></asp:Label></td>
                            <td>
                                </td>
                            <td>
                                <asp:UpdatePanel ID="pnlBranch" UpdateMode="always" runat="server">
                                    <ContentTemplate>
                                        <table cellspacing="0" cellpadding="0" style="padding-right: 15px">
                                            <tr>
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
                                        <asp:ImageButton runat="server" ID="ibtnRunReport" ImageUrl="Common/Images/runreport.gif"
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
                    <asp:UpdatePanel ID="upnlGrid" UpdateMode="always" runat="server">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow-x: hidden; overflow-y: hidden; position: relative;
                                top: 0px; left: 0px; height: 498px; width: 1015px; border: 0px solid;">
                                <asp:DataGrid CssClass="data" Style="height: auto" Width="98%" runat="server" BorderWidth=0 ID="dgBranchActivity"
                                            GridLines="both" ShowHeader=false AutoGenerateColumns="false" UseAccessibleHeader="true" AllowSorting="True" TabIndex="19">
                                            <HeaderStyle CssClass="GridHead" Wrap=false BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Center" />
                                    <ItemStyle CssClass=" GridItem Left5pxPadd" BackColor="White" BorderColor="White"
                                        Height="20px" HorizontalAlign="Left" />
                                    <AlternatingItemStyle CssClass=" GridItem Left5pxPadd" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                        HorizontalAlign="Left" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Center" />                                   
                                        
                                            <Columns>
                                                <asp:TemplateColumn HeaderText="">
                                                    <ItemTemplate >
                                                        <table cellpadding="0" cellspacing="0" border="1" style="border-collapse: collapse;"
                                                            bordercolor="#DAEEEF" width="100%">
                                                            <tr class="GridHead Left5pxPadd" bgcolor="#DFF3F9" bordercolor="#DAEEEF" height="20px">
                                                                <th width="100px">
                                                                    &nbsp;</th>
                                                                <th width="80px" align=center>
                                                                    Qty</th>
                                                                <th width="80px" align=center>
                                                                    Cost $</th>
                                                                <th width="80px" align=center>
                                                                    Weight</th>
                                                                <th width="80px" align=center>
                                                                    $/Lb</th>
                                                                    <td width="750px">
                                                                    &nbsp;</td>
                                                            </tr>
                                                            <tr class="GridItem Left5pxPadd" bordercolor="#DAEEEF" height="20px">
                                                            <%if (Request.QueryString["Branch"].ToString() != "ALL")
                                                              {%>                                                            
                                                                <td style="font-weight: bold;">
                                                                     <a onclick="OpenBrActivityDetails('Receipts')" style="cursor:hand">Received</a></td>
                                                                     <%}
                                                              else {%>
                                                              <td style="font-weight: bold;">
                                                                     Received</td>
                                                                     <%} %>
                                                                <td align=right >
                                                                    <%#String.Format("{0:#,##0}", DataBinder.Eval(Container, "DataItem.ReceiptsQty"))%>
                                                                </td>
                                                                <td align=right>
                                                                    <%#String.Format("{0:#,##0.00}", DataBinder.Eval(Container, "DataItem.ReceiptsValue"))%>
                                                                </td>
                                                                <td align=right>
                                                                    <%#String.Format("{0:#,##0}", DataBinder.Eval(Container, "DataItem.RecWeight"))%>
                                                                </td>
                                                                <td align=right>
                                                                    <%#String.Format("{0:#,##0.000}", DataBinder.Eval(Container, "DataItem.RecperLB"))%>
                                                                </td> <td width="400px">
                                                                    &nbsp;</td>
                                                            </tr>
                                                            <tr class="GridItem Left5pxPadd" bgcolor="#F4FBFD" bordercolor="#DAEEEF" height="20px">
                                                                <%if (Request.QueryString["Branch"].ToString() != "ALL")
                                                              {%>
                                                                <td style="font-weight: bold;">
                                                                    <a onclick="OpenBrActivityDetails('Issued')" style="cursor:hand">Issued</a></td>
                                                                     <%}
                                                              else {%>
                                                               <td style="font-weight: bold;">
                                                                     Issued</td>
                                                                     <%} %>
                                                                <td align=right>
                                                                    <%#String.Format("{0:#,##0}", DataBinder.Eval(Container, "DataItem.IssuesQty"))%>
                                                                </td>
                                                                <td align=right>
                                                                    <%#String.Format("{0:#,##0.00}", DataBinder.Eval(Container, "DataItem.IssuesValue"))%>
                                                                </td>
                                                                <td align=right>
                                                                    <%#String.Format("{0:#,##0}", DataBinder.Eval(Container, "DataItem.IssWeight"))%>
                                                                </td>
                                                                <td align=right>
                                                                    <%#String.Format("{0:#,##0.000}", DataBinder.Eval(Container, "DataItem.IssperLB"))%>
                                                                </td> <td width="400px">
                                                                    &nbsp;</td>
                                                            </tr>
                                                            <tr class="GridItem Left5pxPadd" bordercolor="#DAEEEF" height="20px">
                                                            <%if (Request.QueryString["Branch"].ToString() != "ALL")
                                                              {%>
                                                                <td style="font-weight: bold;">
                                                                    <a onclick="OpenBrActivityDetails('Adjusted')" style="cursor:hand">Adjusted</a></td>
                                                                     <%}
                                                              else {%>
                                                              <td style="font-weight: bold;">
                                                                     Adjusted</td>
                                                                     <%} %>
                                                               <td align=right>
                                                                    <%#String.Format("{0:#,##0}", DataBinder.Eval(Container, "DataItem.AdjQty"))%>
                                                                </td>
                                                                <td align=right>
                                                                    <%#String.Format("{0:#,##0.00}", DataBinder.Eval(Container, "DataItem.AdjValue"))%>
                                                                </td>
                                                                <td align=right>
                                                                    <%#String.Format("{0:#,##0}", DataBinder.Eval(Container, "DataItem.AdjWeight"))%>
                                                                </td>
                                                                <td align=right>
                                                                    <%#String.Format("{0:#,##0.000}", DataBinder.Eval(Container, "DataItem.AdjperLB"))%>
                                                                </td>
                                                                <td width="400px">
                                                                    &nbsp;</td>
                                                            </tr>
                                                        </table>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="left" Width="100%" />
                                                </asp:TemplateColumn>                                              
                                                
                                            </Columns>
                                        </asp:DataGrid>
                                          <asp:HiddenField ID="hidPeriod" Value="" runat="server" />
                                <div style="width: 100%;" align="center">
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label></div>                               
                            </div>
                            <div>                                    
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

</body>
</html>
