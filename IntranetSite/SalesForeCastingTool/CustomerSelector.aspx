<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerSelector.aspx.cs"
    Inherits="SalesForeCastingTool_CustomerSelector" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Selector</title>
    <link href="../SalesForeCastingTool/Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />
    <link href="../SalesForeCastingTool/Common/StyleSheet/Styles.css" rel="stylesheet"
        type="text/css" />
    <link href="../SalesForeCastingTool/Common/StyleSheet/FreezeGrid.css" rel="stylesheet"
        type="text/css" />

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>

    <script type="text/javascript">
        //Javascript function to Show the preview page
        function PrintReport()
        {
            var url= "Branch=" + '<%=Request.QueryString["Branch"] %>' +
                     "&OrderType=" + '<%=Request.QueryString["OrderType"] %>'+'&Sort='+ document.getElementById("hidSort").value +"&HeaderText="+'<%=Request.QueryString["HeaderText"] %>' ;
            window.open('CustomerSelectorPreview.aspx?'+url,'','height=700,width=930,scrollbars=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (930/2))+',resizable=no','');
        }
        
        function BindValue(sortExpression)
        {
           
            if(document.getElementById("hidSortExpression") !=null)
                document.getElementById("hidSortExpression").value= sortExpression;
                              
            document.getElementById("btnSort").click();
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
                                                                            <%#DataBinder.Eval(Container.DataItem, "RebatePct")%>
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
                                                                            Credit Limit:<%#DataBinder.Eval(Container.DataItem, "CreditLimit")%>
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
                                <td>
                                    <asp:UpdatePanel ID="pnldgrid" runat="server" UpdateMode="Conditional" RenderMode=Inline> 
                                        <ContentTemplate>
                                            <div class="Sbar" id="divOuter" style="overflow-x: hidden; overflow-y: auto; position: relative;
                                                top: 0px; left: 0px; height: 390px; border: 0px solid;">
                                                <table width="100%" cellpadding="0" border='0' class="GreyBorderAll" bgcolor='#dff3f9'
                                                    cellspacing='0' height="30">
                                                    <tr align="center" height="20px">
                                                        <td class="GridHead splitBorder" style="width: 52px">
                                                            Select
                                                        </td>
                                                        <td class="GridHead splitBorder" style="width: 52px; cursor: hand;">
                                                            <center>
                                                                <div onclick="javascript:BindValue('cust');">
                                                                    Cust</div>
                                                            </center>
                                                        </td>
                                                        <td class="GridHead splitBorder" style="width: 152px; cursor: hand;">
                                                            <center>
                                                                <div onclick="javascript:BindValue('CustName');">
                                                                    Name</div>
                                                            </center>
                                                        </td>
                                                        <td class="GridHead splitBorder" style="width: 92px; cursor: hand;">
                                                            <div onclick="javascript:BindValue('YTDWgt');">
                                                                YTD Lbs</div>
                                                        </td>
                                                        <td class="GridHead splitBorder" style="width: 92px; cursor: hand;">
                                                            <div onclick="javascript:BindValue('YTDSales');">
                                                                YTD Dollars</div>
                                                        </td>
                                                        <td class="GridHead splitBorder" style="width: 44px; cursor: hand;">
                                                            <div onclick="javascript:BindValue('SalesPerLb');">
                                                                $/Lb</div>
                                                        </td>
                                                        <td class="GridHead splitBorder" style="width: 62px; cursor: hand;">
                                                            <div onclick="javascript:BindValue('YTDGM');">
                                                                YTD GP$</div>
                                                        </td>
                                                        <td class="GridHead splitBorder" style="width: 62px; cursor: hand;">
                                                            <div onclick="javascript:BindValue('GPPct');">
                                                                GP %</div>
                                                        </td>
                                                        <td class="GridHead" style="padding-right: 6px">
                                                            <table width="25%" align="right">
                                                                <tr>
                                                                    <td>
                                                                        <asp:ImageButton ID="ibtnAccept" Style="cursor: hand" ImageUrl="~/SalesForeCastingTool/Common/Images/accept.jpg"
                                                                            runat="server" OnClick="ibtnAccept_Click" ImageAlign="Right" /></td>
                                                                    <td style="padding-right: 10px">
                                                                        <asp:ImageButton ID="ibtnClearAll" Style="cursor: hand" ImageUrl="~/SalesForeCastingTool/Common/Images/clearall.jpg"
                                                                            runat="server" OnClick="ibtnClearAll_Click" ImageAlign="Right" /></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr height="20" align="right">
                                                        <td class="GridHead splitBorders">
                                                            &nbsp;
                                                        </td>
                                                        <td class="GridHead splitBorders" style="padding-left: 10px" align="left" colspan="2">
                                                            Total
                                                        </td>
                                                        <td class="GridHead splitBorders">
                                                            &nbsp;
                                                            <asp:Label runat="server" ID="lblYtdWgt" Text=""></asp:Label>
                                                        </td>
                                                        <td class="GridHead splitBorders">
                                                            &nbsp;
                                                            <asp:Label runat="server" ID="lblYTDSales" Text=""></asp:Label>
                                                        </td>
                                                        <td class="GridHead splitBorders">
                                                            &nbsp;
                                                            <asp:Label runat="server" ID="lblSlsPerLb"></asp:Label>
                                                        </td>
                                                        <td class="GridHead splitBorders">
                                                            &nbsp;
                                                            <asp:Label runat="server" ID="lblYTDGM" Text=""></asp:Label>
                                                        </td>
                                                        <td class="GridHead splitBorders">
                                                            &nbsp;
                                                            <asp:Label runat="server" ID="lblGPPct" Text=""></asp:Label>
                                                        </td>
                                                        <td class="GridHead splitBorders">
                                                        </td>
                                                    </tr>
                                                </table>
                                                <div class="Sbar" id="div-datagrid" style="overflow-x: hidden; overflow-y: auto;
                                                    position: relative; top: 0px; left: 0px; height: 338px; border: 0px solid;">
                                                    <asp:DataGrid ID="dgCustomer" Width="99%" BorderWidth="1" runat="server" AllowSorting="True"
                                                        AutoGenerateColumns="False" ShowFooter="false" BorderColor="#DAEEEF" AllowPaging="false"
                                                        PagerStyle-Visible="false" UseAccessibleHeader="true" OnItemDataBound="dgCustomer_ItemDataBound"
                                                        OnPageIndexChanged="dgCustomer_PageIndexChanged" ShowHeader="False">
                                                        <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                                            HorizontalAlign="Center" />
                                                        <ItemStyle CssClass="Left5pxPadd GridItem" BackColor="White" BorderColor="#CCCCCC"
                                                            Height="20px" HorizontalAlign="Left" />
                                                        <AlternatingItemStyle CssClass="Left5pxPadd GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                                            HorizontalAlign="Left" />
                                                        <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                                            HorizontalAlign="Center" />
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="Select">
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="ProcessChkBox" AutoPostBack="true" onclick="window.event.keyCode = 0;document.getElementById('hidScrollTop').value =document.getElementById('div-datagrid').scrollTop;" runat="server" OnCheckedChanged="ProcessChkBox_CheckedChanged" />
                                                                </ItemTemplate>
                                                                <ItemStyle HorizontalAlign="Center" Width="50px" />
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn HeaderText="Cust" DataField="cust" SortExpression="cust">
                                                                <ItemStyle HorizontalAlign="Left" Width="50px" ForeColor="#CC0000" Wrap="False" />
                                                                <HeaderStyle Width="80px" Wrap="False" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Name" DataField="CustName" SortExpression="CustName">
                                                                <ItemStyle HorizontalAlign="Left" Width="150px" Wrap="False" />
                                                                <FooterStyle HorizontalAlign="Right" />
                                                                <HeaderStyle Width="210px" Wrap="False" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="YTD Lbs" DataField="YTDWgt" SortExpression="YTDWgt"
                                                                DataFormatString="{0:#,##0}">
                                                                <ItemStyle HorizontalAlign="Right" Width="90px" Wrap="False" />
                                                                <FooterStyle HorizontalAlign="Right" />
                                                                <HeaderStyle Width="100px" Wrap="False" BorderWidth="0px" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="YTD Dollars" DataField="YTDSales" SortExpression="YTDSales"
                                                                DataFormatString="{0:#,##0}">
                                                                <ItemStyle HorizontalAlign="Right" Width="90px" Wrap="False" />
                                                                <FooterStyle HorizontalAlign="Right" />
                                                                <HeaderStyle Width="100px" Wrap="False" BorderWidth="0px" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="$/Lb" DataField="SalesPerLb" SortExpression="SalesPerLb"
                                                                DataFormatString="{0:#,##0.00}">
                                                                <ItemStyle HorizontalAlign="Right" Width="42px" Wrap="False" />
                                                                <FooterStyle HorizontalAlign="Right" />
                                                                <HeaderStyle Width="50px" Wrap="False" BorderWidth="0px" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="YTD GP$" DataField="YTDGM" SortExpression="YTDGM" DataFormatString="{0:#,##0}">
                                                                <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                                                <FooterStyle HorizontalAlign="Right" />
                                                                <HeaderStyle Width="70px" Wrap="False" BorderWidth="0px" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="GP %" DataField="GPPct" SortExpression="GPPct" DataFormatString="{0:#,##0.0}">
                                                                <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                                                <FooterStyle HorizontalAlign="Right" />
                                                                <HeaderStyle Width="70px" Wrap="False" BorderWidth="0px" />
                                                            </asp:BoundColumn>
                                                            <asp:TemplateColumn>
                                                                <ItemStyle HorizontalAlign="Right" />
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle Visible="False" />
                                                    </asp:DataGrid>
                                                </div>
                                            </div>
                                            <asp:HiddenField ID="hidSortExpression" runat="server" />
                                            <asp:HiddenField ID="hidScrollTop" Value="0" runat="server" />
                                            <asp:Button ID="btnSort" runat="server" Style="display: none;" Text="Sort" OnClick="btnSort_Click" />
                                            <input type="hidden" runat="server" id="hidSort" />
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
                                                <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="false" DisplayAfter="300">
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
                        <uc2:Footer ID="Footer1" runat="server" Title="Sales Forecasting Tool: Customer Selector" />
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
