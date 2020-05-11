<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerSelectorPreview.aspx.cs"
    Inherits="SalesForeCastingTool_CustomerSelectorPreview" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Selector - Print Preview</title>
    <link href="../SalesForeCastingTool/Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />
    <link href="../SalesForeCastingTool/Common/StyleSheet/Styles.css" rel="stylesheet"
        type="text/css" />
  
    <script src="Common/Javascript/Common.js" type="text/javascript"></script>

</head>
<body onload="print_header();" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
      
        <div class="page">
            <table id="master" class="DashBoardBk" width="100%" style="width: 100%; border-collapse: collapse;
                page-break-after: always;">
                <tr>
                    <td id="tdHeader" >
                        <uc1:Header ID="Header1" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td valign="top" >
                    
                        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="PageBorder"
                            style="border-collapse: collapse;">
                            <tr>
                                <td colspan="2" class="PageHead" style="padding-left: 0px;">
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td style="padding-left: 10px;" width="84%">
                                                <asp:Label ID="lblHeaderBranch" runat="server" CssClass="BannerText"></asp:Label></td>
                                            <td style="height: 14px" width="60px">
                                                <img onclick="javascript:PrintReport();" src="../SalesForeCastingTool/Common/images/Print.gif"
                                                    style="cursor: hand" /></td>
                                            <td style="height: 14px" width="60px">
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
                                <td valign="top" colspan="" bgcolor="white">
                                    <div id="PrintDG1">
                                    <table width="100%"><tr><td><table  width="100%"><tr> <td class="TabHead"  width="60%">
                                    &nbsp;
                                </td>
                                <td class="TabHead" style="width:130px">
                                    Run By : <%= Session["UserName"]%>
                                </td>
                                <td class="TabHead" style="width:130px">
                                    Run Date : <%=DateTime.Now.ToShortDateString()%>
                                </td></tr></table></td> </tr>
                                    <tr><td>    <asp:DataGrid ID="dgCas" runat="server" BorderWidth="0px" BorderColor="#c9c6c6" Width="650"
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
                                        </asp:DataGrid></td>
                                  </tr></table>                                     
                                     
                                    </div>
                                </td>
                            </tr>
                        </table>
                        
                       
                    </td>
                    
                </tr>
                <tr><td> <table id="Table1" style="border-collapse: collapse; page-break-after: always;">
                            <tr>
                                <td>   
                                    
                                        <div class="Sbar" id="div-datagrid" style="overflow-x: hidden; overflow-y: auto;
                                                position: relative; top: 0px; left: 0px; height: 420px;width: 925px; border: 0px solid;">                                                
                                                  <div id="PrintDG2">  <asp:DataGrid ID="dgCustomer" Width="99%" BorderWidth="1" runat="server" AllowSorting="True"
                                                        AutoGenerateColumns="False" ShowFooter="false" BorderColor="#DAEEEF" AllowPaging="False"
                                                        PagerStyle-Visible="false" UseAccessibleHeader="false" OnItemDataBound="dgCustomer_ItemDataBound"
                                                        OnPageIndexChanged="dgCustomer_PageIndexChanged">
                                                       <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                                            HorizontalAlign="Center" />
                                                        <ItemStyle CssClass="Left5pxPadd GridItem" BorderWidth="1"  BackColor="White" BorderColor="#cccccc"
                                                            Height="20px" HorizontalAlign="Left" />
                                                        <AlternatingItemStyle CssClass="Left5pxPadd GridItem" BorderWidth="1" BackColor="#F4FBFD" BorderColor="#cccccc"
                                                            HorizontalAlign="Left" />
                                                        <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                                            HorizontalAlign="Center" />
                                                        <Columns>
                                                       
                                                            <asp:BoundColumn HeaderText="Cust" ItemStyle-BorderWidth="1" DataField="cust" SortExpression="cust">
                                                                <ItemStyle HorizontalAlign="Left" Width="50px" ForeColor="#CC0000" Wrap="False" />
                                                                <HeaderStyle Width="80px" Wrap="False" BorderWidth=0px />
                                                                
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Name" ItemStyle-BorderWidth="1" DataField="CustName" SortExpression="CustName">
                                                                <ItemStyle HorizontalAlign="Left" Width="150px" Wrap="False" />
                                                                <FooterStyle HorizontalAlign="Right" />
                                                                <HeaderStyle Width="210px" Wrap="False" BorderWidth=0px />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="YTD Lbs" ItemStyle-BorderWidth="1" DataField="YTDWgt" SortExpression="YTDWgt"
                                                                DataFormatString="{0:#,##0}">
                                                                <ItemStyle HorizontalAlign="Right" Width="90px" Wrap="False" />
                                                                <FooterStyle HorizontalAlign="Right" />
                                                                <HeaderStyle Width="100px" Wrap="False" BorderWidth=0px/>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="YTD Dollars" ItemStyle-BorderWidth="1" DataField="YTDSales" SortExpression="YTDSales"
                                                                DataFormatString="{0:#,##0}">
                                                                <ItemStyle HorizontalAlign="Right" Width="90px" Wrap="False" />
                                                                <FooterStyle HorizontalAlign="Right" />
                                                                <HeaderStyle Width="100px" Wrap="False" BorderWidth=0px />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="$/Lb" ItemStyle-BorderWidth="1" DataField="SalesPerLb" SortExpression="SalesPerLb"
                                                                DataFormatString="{0:#,##0.00}">
                                                                <ItemStyle HorizontalAlign="Right" Width="40px" Wrap="False" />
                                                                <FooterStyle HorizontalAlign="Right" />
                                                                <HeaderStyle Width="50px" Wrap="False" BorderWidth=0px/>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="YTD GP$" ItemStyle-BorderWidth="1" DataField="YTDGM" SortExpression="YTDGM" DataFormatString="{0:#,##0}">
                                                                <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                                                <FooterStyle HorizontalAlign="Right" />
                                                                <HeaderStyle Width="70px" Wrap="False" BorderWidth=0px/>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="GP %" ItemStyle-BorderWidth="1" DataField="GPPct" SortExpression="GPPct" DataFormatString="{0:#,##0.0}">
                                                                <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                                                <FooterStyle HorizontalAlign="Right" />
                                                                <HeaderStyle Width="70px" Wrap="False" BorderWidth=0px />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn ItemStyle-BorderWidth="1">
                                                                <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                                                <FooterStyle HorizontalAlign="Right" />
                                                                <HeaderStyle  Wrap="False" BorderWidth=0px />
                                                            </asp:BoundColumn>
                                                        </Columns>
                                                        <PagerStyle Visible="False" />
                                                    </asp:DataGrid>
                                                
                                            </div>
                                            </div>
                                        
                                </td>
                            </tr>
                        </table>
                        <uc2:Footer ID="Footer1" runat="server" Title="Sales Forecasting Tool: Customer Selector" /></td></tr>
            </table>
        </div>
    </form>
</body>
</html>

<script type="text/javascript">
 //Javascript function to Show the preview page

function PrintReport()
{
     var prtContent = "<html><head><link href='../SalesForeCastingTool/Common/StyleSheet/LM_Styles.css' rel='stylesheet' type='text/css' /><link href='common/StyleSheet/styles.css' rel='stylesheet' type='text/css' /><style>.BluBordAll {border: 1px solid #000000;} .splitBorder {border-bottom:1px Solid #efefef;border-top:0px Solid #ffffff;}</style> </head><body>"
     prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td ><h3>Sales Forecasting - Customer Report </h3></td></tr><tr>";
     prtContent = prtContent + document.getElementById("PrintDG1").innerHTML+"</table>"; 
     prtContent = prtContent + document.getElementById("PrintDG2").innerHTML;     
     prtContent = prtContent + "</body></html>";
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
    var table = document.getElementById("dgCustomer"); // the id of your DataGrid
    var str = table.outerHTML; 
    str = str.replace(/<TBODY>/i, ""); 
    str = str.replace(/<TR/g, "<THEAD style='display:table-header-group;'><TR"); 
    str = str.replace(/<\/TR>/g, "</TR></THEAD><TBODY>"); 
    table.outerHTML = str; 
} 

</script>

