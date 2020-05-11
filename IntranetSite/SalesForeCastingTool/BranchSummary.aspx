<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BranchSummary.aspx.cs" Inherits="SalesForeCastingTool_BranchSummary" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Branch Summary</title>
    <link href="../SalesForeCastingTool/Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />
    <link href="../SalesForeCastingTool/Common/StyleSheet/Styles.css" rel="stylesheet"
        type="text/css" />
    <script src="Common/Javascript/Common.js" type="text/javascript"></script>

    <script type="text/javascript">
        //Javascript function to Show the preview page
        function PrintReport()
        {
            var url= "Branch=" + '<%=Request.QueryString["Branch"] %>'+'&Sort='+ document.getElementById("hidSort").value +"&HeaderText="+'<%=Request.QueryString["HeaderText"] %>' ;
            window.open('BranchSummaryPreview.aspx?'+url,'','height=700,width=950,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
        }
        
        function BindValue(sortExpression)
        {
            if(document.getElementById("hidSortExpression") !=null)
                document.getElementById("hidSortExpression").value= sortExpression;
                              
            document.getElementById("btnSort").click();
        }
        
        function OpenSaleForeCastingTool(custNumber,orderType)
        {
            var url = "SalesForecastingTool.aspx?CustNumber="+custNumber +"&Branch=" + '<%=Request.QueryString["Branch"] %>'+ "&OrderType=" + orderType +"&HeaderText="+'<%=Request.QueryString["HeaderText"] %>';
            window.open(url,'','height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (930/2))+',resizable=no','');
        }
    </script>

</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <div class="page">
            <table id="master" class="DashBoardBk" width="100%" style="width: 100%; border-collapse: collapse;
                page-break-after: always;">
                <tr>
                    <td id="tdHeader">
                        <uc1:Header ID="Header1" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="PageBorder"
                            style="border-collapse: collapse;">
                            <tr>
                                <td colspan="2" class="PageHead" style="padding-left: 0px;">
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td style="padding-left: 10px; width: 84%; height: 28px;">
                                                <asp:Label ID="lblHeaderBranch" runat="server" CssClass="BannerText"></asp:Label></td>
                                            <td style="height: 28px; width: 74px;" colspan="1" rowspan="">
                                                <img onclick="javascript:PrintReport();" src="../SalesForeCastingTool/Common/images/Print.gif"
                                                    style="cursor: hand" /></td>
                                            <td style="height: 28px;" align="left">
                                                <img src="../SalesForeCastingTool/Common/images/close.gif" onclick="Javascript:window.close();"
                                                    style="cursor: hand" /></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" bgcolor="white">
                                    <asp:DataGrid ID="dgCas" runat="server" BorderWidth="0" BorderColor="#c9c6c6" Width="650"
                                        PageSize="1" AllowPaging="true" ShowHeader="false" PagerStyle-Visible="false"
                                        AutoGenerateColumns="false">
                                        <Columns>
                                            <asp:TemplateColumn>
                                                <ItemTemplate>
                                                    <table width="100%" cellpadding="0" cellspacing="0" style="padding-left: 10px">
                                                        <tr>
                                                            <td width="30%" valign="top">
                                                                <div align="left" style="height: 54px">
                                                                    <strong>Customer # &nbsp; &nbsp;
                                                                        <%#DataBinder.Eval(Container.DataItem, "CustNo")%>
                                                                    </strong>
                                                                    <br>
                                                                    Chain Name:
                                                                    <%#DataBinder.Eval(Container.DataItem, "Chain")%>
                                                                    <br>
                                                                    Cust Type:
                                                                    <%#DataBinder.Eval(Container.DataItem, "CustType")%>
                                                                </div>
                                                                <br />
                                                                <div align="left">
                                                                    <strong>
                                                                        <%#DataBinder.Eval(Container.DataItem,"CustName") %>
                                                                    </strong>
                                                                    <br>
                                                                    <%#DataBinder.Eval(Container.DataItem,"CustAddress") %>
                                                                    <br>
                                                                    <%#DataBinder.Eval(Container.DataItem,"CustCity") %>
                                                                    ,
                                                                    <%#DataBinder.Eval(Container.DataItem,"CustState") %>
                                                                    <%#DataBinder.Eval(Container.DataItem,"CustZip") %>
                                                                    <br>
                                                                    Ph:
                                                                    <%#DataBinder.Eval(Container.DataItem,"CustPhone") %>
                                                                    <br>
                                                                    Fx:
                                                                    <%#DataBinder.Eval(Container.DataItem,"CustFax") %>
                                                                    <br>
                                                                </div>
                                                            </td>
                                                            <td width="38%" rowspan="2" valign="top">
                                                                <table width="100%" height="140" cellpadding="0" cellspacing="0" class="cntt">
                                                                    <tr>
                                                                        <td>
                                                                            <strong>Customer Profile</strong></td>
                                                                        <td>
                                                                            <strong>
                                                                                <%#DataBinder.Eval(Container.DataItem, "CustProfile").ToString().ToUpper()%>
                                                                            </strong>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 19px">
                                                                            Sales $ Ranking
                                                                        </td>
                                                                        <td style="height: 19px">
                                                                            <%#DataBinder.Eval(Container.DataItem, "SalesDollarVolume")%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            Margin $ Ranking
                                                                        </td>
                                                                        <td>
                                                                            <%#DataBinder.Eval(Container.DataItem, "MarginDollars")%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            Margin %
                                                                        </td>
                                                                        <td>
                                                                            <%# DataBinder.Eval(Container.DataItem, "MarginPercent")%>
                                                                            %&nbsp;/&nbsp;<%# DataBinder.Eval(Container.DataItem, "MarginPctCorpAvg")%>%
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            Price per LB
                                                                        </td>
                                                                        <td>
                                                                            <%#DataBinder.Eval(Container.DataItem, "PricePerLB")%>
                                                                            &nbsp;/&nbsp;<%#DataBinder.Eval(Container.DataItem, "PricePerLBCorpAvg")%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            Order $ per SO
                                                                        </td>
                                                                        <td>
                                                                            <%#DataBinder.Eval(Container.DataItem, "OrderDollarPerSO")%>
                                                                            &nbsp;/&nbsp;<%#DataBinder.Eval(Container.DataItem, "OrdDolPerSoCorpAvg")%></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            Order $ per SO Line
                                                                        </td>
                                                                        <td>
                                                                            <%#DataBinder.Eval(Container.DataItem, "OrderDollarPerSOLine")%>
                                                                            &nbsp;/&nbsp;<%#DataBinder.Eval(Container.DataItem, "OrdDolPerSOLineCorpAvg")%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            Rebate %
                                                                        </td>
                                                                        <td>
                                                                            <%#DataBinder.Eval(Container.DataItem, "RebatePct", "{0:0.0#}")%>
                                                                            /C
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td width="32%" rowspan="2" valign="top">
                                                                <table cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td>
                                                                            <strong>Sales Brn:
                                                                                <%#DataBinder.Eval(Container.DataItem,"BranchDesc") %>
                                                                            </strong>
                                                                            <br>
                                                                            Inside Sales:
                                                                            <%#DataBinder.Eval(Container.DataItem,"InsideSls") %>
                                                                            <br>
                                                                            Sales Rep:
                                                                            <%#DataBinder.Eval(Container.DataItem,"SalesRep") %>
                                                                            <br>
                                                                            Buying Grp:
                                                                            <%#DataBinder.Eval(Container.DataItem,"BuyGrp") %>
                                                                            <br>
                                                                            Key Cust:
                                                                            <%#DataBinder.Eval(Container.DataItem, "KeyCustRebate")%>
                                                                            <br>
                                                                            Annual:
                                                                            <%#DataBinder.Eval(Container.DataItem, "AnnualRebate")%>
                                                                            <br>
                                                                            Commission Rep:
                                                                            <%#DataBinder.Eval(Container.DataItem,"SalesPerson") %>
                                                                            <br>
                                                                            Hub:
                                                                            <%#DataBinder.Eval(Container.DataItem,"HubSatellites") %>
                                                                            <br>
                                                                            Terms:
                                                                            <%#DataBinder.Eval(Container.DataItem,"Terms") %>
                                                                            <br>
                                                                            <%-- DSO: <%#DataBinder.Eval(Container.DataItem,"DSO") %>&nbsp;Days<br>--%>
                                                                            Credit Limit:
                                                                            <%#DataBinder.Eval(Container.DataItem, "CreditLimit")%>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                </ItemTemplate>
                                                <ItemStyle VerticalAlign="Top" />
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <PagerStyle Visible="False" />
                                    </asp:DataGrid>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td valign="top">
                                    <asp:UpdatePanel ID="pnldgrid" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                        <ContentTemplate>
                                            <table id="tblHeader" runat="server" cellpadding="0" border='0' class="GreyBorderAll"
                                                bgcolor='#dff3f9' cellspacing='0' height="20">
                                                <tr height="20" align="right">
                                                    <td align="right" class="GridHead splitBorder" colspan="2">
                                                        &nbsp;</td>
                                                    <td class="GridHead splitBorder" align="center" colspan="2">
                                                        Q1 &nbsp;</td>
                                                    <td class="GridHead splitBorder" align="center" colspan="2">
                                                        Q2 &nbsp;</td>
                                                    <td class="GridHead splitBorder" align="center" colspan="2">
                                                        Q3&nbsp;</td>
                                                    <td align="center" class="GridHead splitBorder" colspan="2">
                                                        Q4</td>
                                                    <td align="center" class="GridHead splitBorder" colspan="2">
                                                        Annual</td>
                                                    <td align="right" class="GridHead splitBorder">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr align="right" height="20">
                                                    <td align="center" class="GridHead splitBorders" width="70">
                                                        <center>
                                                            <div onclick="javascript:BindValue('CustOrdDesc');" style="cursor:hand;">
                                                                Cust</div>
                                                        </center>
                                                    </td>
                                                    <td align="center" class="GridHead splitBorders" width="172">
                                                        <center>
                                                            <div onclick="javascript:BindValue('CustomerName');"  style="cursor:hand;">
                                                                Name</div>
                                                        </center>
                                                    </td>
                                                    <td align="center" class="GridHead splitBorders" width="67">
                                                        <center>
                                                            <div onclick="javascript:BindValue('Q1ActualLbs');"  style="cursor:hand;">
                                                                Actual</div>
                                                        </center>
                                                    </td>
                                                    <td align="center" class="GridHead splitBorders" width="66">
                                                        <center>
                                                            <div onclick="javascript:BindValue('Q1ForeCastLbs');"  style="cursor:hand;">
                                                                Forecast</div>
                                                        </center>
                                                    </td>
                                                    <td align="center" class="GridHead splitBorders" width="67">
                                                        <center>
                                                            <div onclick="javascript:BindValue('Q2ActualLbs');"  style="cursor:hand;">
                                                                Actual</div>
                                                        </center>
                                                    </td>
                                                    <td align="center" class="GridHead splitBorders" width="66">
                                                        <center>
                                                            <div onclick="javascript:BindValue('Q2ForeCastLbs');"  style="cursor:hand;">
                                                                Forecast</div>
                                                        </center>
                                                    </td>
                                                    <td align="center" class="GridHead splitBorders" width="67">
                                                        <center>
                                                            <div onclick="javascript:BindValue('Q3ActualLbs');"  style="cursor:hand;">
                                                                Actual</div>
                                                        </center>
                                                    </td>
                                                    <td align="center" class="GridHead splitBorders" width="66">
                                                        <center>
                                                            <div onclick="javascript:BindValue('Q5ForeCastLbs');"  style="cursor:hand;">
                                                                Forecast</div>
                                                        </center>
                                                    </td>
                                                    <td align="center" class="GridHead splitBorders" width="67">
                                                        <center>
                                                            <div onclick="javascript:BindValue('Q4ActualLbs');"  style="cursor:hand;">
                                                                Actual</div>
                                                        </center>
                                                    </td>
                                                    <td align="center" class="GridHead splitBorders" width="66">
                                                        <center>
                                                            <div onclick="javascript:BindValue('Q4ForeCastLbs');"  style="cursor:hand;">
                                                                Forecast</div>
                                                        </center>
                                                    </td>
                                                    <td align="center" class="GridHead splitBorders" width="67">
                                                        <center>
                                                            <div onclick="javascript:BindValue('AnnualActualLbs');"  style="cursor:hand;">
                                                                Actual</div>
                                                        </center>
                                                    </td>
                                                    <td align="center" class="GridHead splitBorders" width="66">
                                                        <center>
                                                            <div onclick="javascript:BindValue('AnnualForecastLbs');"  style="cursor:hand;">
                                                                Forecast</div>
                                                        </center>
                                                    </td>
                                                    <td align="center" class="GridHead splitBorders" width="55">
                                                        <center>
                                                            <div onclick="javascript:BindValue('PctDiff');"  style="cursor:hand;">
                                                                %Diff</div>
                                                        </center>
                                                    </td>
                                                </tr>
                                            </table>
                                            <div class="Sbar" id="div-datagrid" style="overflow-x: hidden; overflow-y: auto;
                                                position: relative; top: 0px; left: 0px; height: 370px; border: 0px solid;">
                                                <asp:DataGrid ID="dgBranchSummary" BorderWidth="1" runat="server" AllowSorting="True"
                                                    AutoGenerateColumns="False" ShowFooter="True" BorderColor="#DAEEEF" AllowPaging="False"
                                                    PagerStyle-Visible="false" UseAccessibleHeader="true" OnPageIndexChanged="dgBranchSummary_PageIndexChanged"
                                                    OnSortCommand="dgBranchSummary_SortCommand" ShowHeader="False" OnItemDataBound="dgBranchSummary_ItemDataBound">
                                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                                        HorizontalAlign="Center" />
                                                    <ItemStyle CssClass="GridItem Left5pxPadd" BackColor="White" BorderColor="#CCCCCC"
                                                        Height="20px" HorizontalAlign="Left" />
                                                    <AlternatingItemStyle CssClass="GridItem Left5pxPadd" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                                        HorizontalAlign="Left" />
                                                    <FooterStyle   CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                                        HorizontalAlign="Center" />
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="Cust" SortExpression="Customer">
                                                            <ItemTemplate>
                                                                <a href="#" onclick="javascript:OpenSaleForeCastingTool('<%#  DataBinder.Eval(Container.DataItem,"Customer")%>','<%#  DataBinder.Eval(Container.DataItem,"OrderType")%>');">
                                                                    <%#  DataBinder.Eval(Container.DataItem, "CustOrdDesc")%>
                                                                </a>
                                                            </ItemTemplate>
                                                            <FooterStyle BorderColor="#cccccc" />
                                                            <ItemStyle Width="68px" BorderColor="#cccccc" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn  HeaderText="Name" DataField="CustomerName" SortExpression="CustomerName">
                                                            <ItemStyle HorizontalAlign="Left"  Width="167px" Wrap="False" CssClass="leftMargin"  BorderColor="#cccccc" />
                                                            <FooterStyle BorderColor="#cccccc"  HorizontalAlign="Right" />                                                            
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="Actual" DataField="Q1ActualLbs" SortExpression="Q1ActualLbs"
                                                            DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="65px" Wrap="False" BorderColor="#cccccc"/>
                                                            <FooterStyle BorderColor="#cccccc"  HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="ForeCast" DataField="Q1ForeCastLbs" SortExpression="Q1ForeCastLbs"
                                                            DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="64px" Wrap="False" BorderColor="#cccccc" />
                                                            <FooterStyle BorderColor="#cccccc"  HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="Actual" DataField="Q2ActualLbs" SortExpression="Q2ActualLbs"
                                                            DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="65px" Wrap="False" BorderColor="#cccccc" />
                                                            <FooterStyle BorderColor="#cccccc"  HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="ForeCast" DataField="Q2ForeCastLbs" SortExpression="Q2ForeCastLbs"
                                                            DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="64px" Wrap="False" BorderColor="#cccccc" />
                                                            <FooterStyle BorderColor="#cccccc"  HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="Actual" DataField="Q3ActualLbs" SortExpression="Q3ActualLbs"
                                                            DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="65px" Wrap="False" BorderColor="#cccccc" />
                                                            <FooterStyle BorderColor="#cccccc"  HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="ForeCast" DataField="Q3ForeCastLbs" SortExpression="Q3ForeCastLbs"
                                                            DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="64px" Wrap="False" BorderColor="#cccccc" />
                                                            <FooterStyle BorderColor="#cccccc"  HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="Actual" DataField="Q4ActualLbs" SortExpression="Q4ActualLbs"
                                                            DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="65px" Wrap="False" BorderColor="#cccccc" />
                                                            <FooterStyle BorderColor="#cccccc"  HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="ForeCast" DataField="Q4ForeCastLbs" SortExpression="Q4ForeCastLbs"
                                                            DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="64px" Wrap="False" BorderColor="#cccccc" />
                                                            <FooterStyle BorderColor="#cccccc"  HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="Ann Actual" DataField="AnnualActualLbs" SortExpression="AnnualActualLbs"
                                                            DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="65px" Wrap="False" BorderColor="#cccccc" />
                                                            <FooterStyle BorderColor="#cccccc"  HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="Ann Forecast" DataField="AnnualForecastLbs" SortExpression="AnnualForecastLbs"
                                                            DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="64px" Wrap="False" BorderColor="#cccccc" />
                                                            <FooterStyle BorderColor="#cccccc"  HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="% Diff" DataField="PctDiff" SortExpression="PctDiff"
                                                            DataFormatString="{0:#,##0.0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" BorderColor="#cccccc" />
                                                            <FooterStyle BorderColor="#cccccc"  HorizontalAlign="Right" />
                                                            <HeaderStyle Width="100px" Wrap="False" BorderWidth="0px" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                    <PagerStyle Visible="False" />
                                                </asp:DataGrid>
                                            </div>
                                            <input type="hidden" runat="server" id="hidSort" />
                                            <asp:HiddenField ID="hidSortExpression" runat="server" />
                                             <asp:Button ID="btnSort" runat="server" Style="display: none;" Text="Sort" OnClick="btnSort_Click" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" class="BluBg buttonBar">
                                    <table>
                                        <tr>
                                            <td>
                                                <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                                    <ContentTemplate>
                                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="Green" Font-Bold="True"
                                                            runat="server"></asp:Label>
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
                        </table>
                        <uc2:Footer ID="Footer1" runat="server" Title="Sales Forecasting Tool: Branch Summary" />
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
