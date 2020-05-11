<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesForecastingPreview.aspx.cs"
    Inherits="SalesForeCastingTool_SalesForecastingTool" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Sales Forecasting - Print Preview</title>
    <link href="../SalesForeCastingTool/Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />
    <link href="../SalesForeCastingTool/Common/StyleSheet/Styles.css" rel="stylesheet"
        type="text/css" />

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>

    <script>
        function OpenSaleForeCastingTool(custNumber)
        {
             window.open('CustomerSelectorPreview.aspx?CustNumber='+custNumber,'','height=700,width=930,scrollbars=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (930/2))+',resizable=no','');
        }
        
        function BindValue(sortExpression)
        {
           
            if(document.getElementById("hidSortExpression") !=null)
                document.getElementById("hidSortExpression").value= sortExpression;
                              
            document.getElementById("btnSort").click();
        }
    </script>

    <style type="text/css">
        .diffPadding {padding-right:10px}
        .diffPaddings {padding-right:2px}
        .rightsplit {border-right:1px solid #cccccc;}
        .bottomsplit {border-bottom:1px solid #cccccc;border-top:1px solid #cccccc;}
        .FormCtrl 
        {
	        font-family: Arial, Helvetica, sans-serif;	
	        font-size: 11px;	
	        font-weight: normal;	
	        color: #3A3A56;	
        }
    </style>
</head>
<body onload="print_header();" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
            <table id="master" class="GreyBorderAll" style="width: 100%;border-collapse: collapse;
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
                                <td>
                                    <div id="PrintHeader2" style="display: none;">
                                        <table width="100%">
                                            <tr>
                                                <td class="TabHead" style="width: 130px">
                                                    Run By :
                                                    <%= Session["UserName"]%>
                                                </td>
                                                <td class="TabHead" style="width: 130px">
                                                    Run Date :
                                                    <%=DateTime.Now.ToShortDateString()%>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" bgcolor="white" id="tblHeader" runat="server">
                                    <div id="NewPrint"">
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
                                                                    <strong>Customer #
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
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" border="0" >
                            <tr>
                                <td valign="top">
                                    <asp:UpdatePanel ID="pnldgrid" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                        <ContentTemplate>
                                            <div class="Sbar" runat="server" id="divdatagrid" style="overflow-x: hidden; overflow-y: auto;
                                                position: relative; top: 0px; left: 0px; height: 400px; border: 0px solid;">
                                                
                                               <asp:DataGrid ID="dgBranchSummary" Width="980px" BorderWidth="1" runat="server" AllowSorting="True" 
                                                    AutoGenerateColumns="False" ShowFooter="false" BorderColor="#DAEEEF" AllowPaging="False"
                                                    PagerStyle-Visible="false" OnPageIndexChanged="dgBranchSummary_PageIndexChanged"
                                                    ShowHeader="true" OnItemDataBound="dgBranchSummary_ItemDataBound">                                                                                                    
                                                    <HeaderStyle  BorderWidth=1  BorderColor="#DAEEEF" Height="20px"
                                                        HorizontalAlign="Left" />
                                                    <ItemStyle CssClass=" GridItem" BorderWidth=1px   BackColor="white" BorderColor="#DAEEEF"
                                                        Height="20px" HorizontalAlign="Left" />
                                                    <AlternatingItemStyle CssClass=" GridItem" BorderWidth=1px BorderColor="#DAEEEF" BackColor="#F4FBFD"
                                                        HorizontalAlign="Left" />
                                                    <Columns>
                                                        <asp:BoundColumn DataField="CatGrpNo" ItemStyle-Width=0px  SortExpression="CatGrpNo" Visible="false"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="CatGrpDesc" SortExpression="CatGrpDesc">
                                                            <ItemStyle HorizontalAlign="Left" Width="170px" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Q1ActualLbs" SortExpression="Q1ActualLbs" DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn   DataField="Q1AddedPct" ItemStyle-Width="33px"   DataFormatString="{0:#,##0.0}" ItemStyle-HorizontalAlign=Right ></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Q1ForeCastLbs" DataFormatString="{0:#,##0}" ItemStyle-HorizontalAlign=Right ItemStyle-Width=60px>                                                            
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Q2ActualLbs" SortExpression="Q2ActualLbs" DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                                        </asp:BoundColumn>                                                        
                                                        <asp:BoundColumn  DataField="Q2AddedPct" ItemStyle-Width="33px" DataFormatString="{0:#,##0.0}" ItemStyle-HorizontalAlign=Right></asp:BoundColumn>
                                                        <asp:BoundColumn ItemStyle-HorizontalAlign="Right" DataField="Q2ForeCastLbs" DataFormatString="{0:#,##0}" ItemStyle-Width=60px>
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Q3ActualLbs" SortExpression="Q3ActualLbs" DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Q3AddedPct" ItemStyle-Width="33px" DataFormatString="{0:#,##0.0}" ItemStyle-HorizontalAlign=Right ></asp:BoundColumn>
                                                        <asp:BoundColumn  ItemStyle-HorizontalAlign="Right" DataField="Q3ForeCastLbs" DataFormatString="{0:#,##0}" ItemStyle-Width=60px>
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Q4ActualLbs" SortExpression="Q4ActualLbs" DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Q4AddedPct" ItemStyle-Width="33px" DataFormatString="{0:#,##0.0}" ItemStyle-HorizontalAlign=Right></asp:BoundColumn>
                                                        <asp:BoundColumn ItemStyle-HorizontalAlign="Right" DataField="Q4ForeCastLbs" DataFormatString="{0:#,##0}" ItemStyle-Width=60px>
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="AnnualActualLbs" SortExpression="AnnualActualLbs" DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="AnnualAddedPct" ItemStyle-Width="33px" DataFormatString="{0:#,##0.0}" ItemStyle-HorizontalAlign=Right></asp:BoundColumn>
                                                        <asp:BoundColumn ItemStyle-HorizontalAlign="Right"  DataField="AnnualForeCastLbs" DataFormatString="{0:#,##0}" ItemStyle-Width=60px>
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="PctDiff" SortExpression="PctDiff" DataFormatString="{0:0.0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" CssClass="diffPadding" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                    <PagerStyle Visible="False" />
                                                </asp:DataGrid>
                                            </div>
                                            <asp:HiddenField ID="hidSortExpression" runat="server" />
                                            <asp:Button ID="btnSort" runat="server" Style="display: none;" Text="Sort" OnClick="btnSort_Click" />
                                            <input type="hidden" runat="server" id="hidSort" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" class="BluBg buttonBar">
                                    <table >
                                        <tr>
                                            <td>
                                                <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                                    <ContentTemplate>
                                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="Green" Font-Bold="True"
                                                            runat="server"></asp:Label>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                            <td >
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
                        <uc2:Footer ID="Footer1" runat="server" Title="Sales Forecasting Tool: Customer Selector" />
                    </td>
                </tr>
            </table>
    </form>
</body>
</html>

<script>
        //Javascript function to Show the preview page
        function PrintReport()
        {
             var prtContent =  "<html><head><link href='../SalesForeCastingTool/Common/StyleSheet/LM_Styles.css' rel='stylesheet' type='text/css' /><link href='common/StyleSheet/styles.css' rel='stylesheet' type='text/css' /><style>.BluBordAll {border: 1px solid #000000;} .splitBorder {border-bottom:1px Solid #efefef;border-top:0px Solid #ffffff;}.rightsplit {border-right:1px solid #cccccc;}</style> </head><body>";
             
             prtContent= prtContent+"<table cellspacing=0  border=0 cellpadding=0 width='100%'><tr><td style='height=30px' width='100%' colspan=2><h3>Sales Forecasting</h3></td></tr><tr><td width='65%'><h4>"+ document.getElementById("lblHeaderBranch").innerHTML +"</h4></td><td>"+document.getElementById("PrintHeader2").innerHTML+"</td></tr><tr>";
             
             if(document.getElementById("dgCas"))
                prtContent = prtContent + "<td colspan=2 >"+ document.getElementById("dgCas").innerHTML + "</td></tr><tr>" ;
                
             prtContent = prtContent + "<td colspan=2>" + document.getElementById("divdatagrid").innerHTML; 
               
             prtContent = prtContent + "</td></tr></table></body></html>";
             
             var WinPrint = window.open('','','letf=0,top=0,width=1,height=1,resizeBy=yes,toolbar=0,scrollbars=0,status=0');
             WinPrint.document.write(prtContent);
             WinPrint.document.close();
             WinPrint.focus();
             WinPrint.print();
             WinPrint.close();
             window.close();
      }
function print_header() 
{ 
    var table = document.getElementById("dgBranchSummary"); // the id of your DataGrid
    var str = table.outerHTML; 
    str = str.replace(/<TBODY>/i, ""); 
    str = str.replace(/<TR/g, "<THEAD style='display:table-header-group;'><TR"); 
    str = str.replace(/<\/TR>/g, "</TR></THEAD><TBODY>"); 
    table.outerHTML = str; 
} 
</script>
