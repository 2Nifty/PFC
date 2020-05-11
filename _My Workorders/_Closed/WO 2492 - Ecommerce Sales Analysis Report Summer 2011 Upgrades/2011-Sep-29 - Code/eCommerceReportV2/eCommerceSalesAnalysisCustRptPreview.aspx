<%@ Page Language="C#" AutoEventWireup="true" CodeFile="eCommerceSalesAnalysisCustRptPreview.aspx.cs" Inherits="eCommerceSalesAnalysisCustRptPreview" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>eCommerce Quote and Order Report Preview</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script language="javascript" type="text/javascript">
        function PrintReport(strid1,strid2)
        {
            var prtContent = "<html><head><link href='common/StyleSheet/stylesheet.css' rel='stylesheet' type='text/css' /></head><body>"
            prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='70%'><tr><td style='width:350px;'colspan=3><h3>eCommerce Quote and Order Report</h3></td></tr>";
            prtContent = prtContent +"</table><br>"; 
            prtContent = prtContent + document.getElementById(strid1).innerHTML; 
            prtContent = prtContent + document.getElementById(strid2).innerHTML;     
            prtContent = prtContent + "</body></html>";
            var WinPrint = window.open('','','letf=0,top=0,width=1,height=1,toolbar=0,scrollbars=0,status=0');
            prtContent = prtContent.replace(/BORDER-COLLAPSE: collapse;/i,"border-collapse:separate;");
            prtContent = prtContent.replace(/BORDER-LEFT: #c9c6c6 1px solid;/i,"BORDER-LEFT: #c9c6c6 0px solid;");
            prtContent = prtContent.replace(/BORDER-RIGHT: #c9c6c6 1px solid;/i,"BORDER-RIGHT: #c9c6c6 0px solid;");
            prtContent = prtContent.replace(/BORDER-TOP: #c9c6c6 1px solid;/i,"BORDER-TOP: #c9c6c6 0px solid;");
            prtContent = prtContent.replace(/BORDER-BOTTOM: #c9c6c6 1px solid;/i,"BORDER-BOTTOM: #c9c6c6 0px solid;");
            WinPrint.document.write(prtContent);
            WinPrint.document.close();
            WinPrint.focus();
            WinPrint.print();
            WinPrint.close();
        }

        function print_header() 
        {
            var table = document.getElementById("dgQuote2Order"); // the id of your DataGrid
            var str = table.outerHTML; 
//alert(str);
            str = str.replace(/<TBODY>/g, ""); 
            str = str.replace(/<TR/g, "<THEAD style='display:table-header-group;'><TR"); 
            str = str.replace(/<\/TR>/g, "</TR></THEAD><TBODY>"); 
            table.outerHTML = str; 
        } 
    </script>
</head>
<body onload="javascript:print_header()">
    <form id="form1" runat="server">
        <div id="pagePrint">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="100%" height="100%" valign="top">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="PageHead" colspan="4" style="height: 40px">
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr>
                                            <td class="Left5pxPadd BannerText" width="90%">
                                                <asp:Label Text="eCommerce Quote and Order Report" Style="word-wrap: normal" ID="lblReportCap"
                                                    runat="server" Width="350px"></asp:Label>
                                            </td>
                                            <td valign="middle" align="right">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td align="right" width="70%" style="padding: 5px;">
                                                            <img onclick="javascript:PrintReport('trHead','PrintDG2');" src="../Common/Images/Print.gif"
                                                                style="cursor: hand" id="IMG1" /></td>
                                                        <td align="left" width="30%">
                                                            <img src="Common/Images/Buttons/Close.gif" style="cursor: hand" onclick="javascript:window.close();" /></td>
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
                    <td>
                        <table cellpadding="1" cellspacing="0" width="100%">
                            <tr>
                                <td class="LeftPadding TabHead" style="width: 130px">
                                    Customer # :
                                    <%=(Request.QueryString["CustNo"].ToString() == "") ? "All" : Request.QueryString["CustNo"].ToString()%>
                                </td>
                                <td class="LeftPadding TabHead" style="width: 180px">
                                    Branch :
                                    <%=Request.QueryString["BranchName"].ToString()%>
                                </td>
                                <td class="TabHead" style="width: 200px">
                                    Period :
                                    <%=Request.QueryString["MonthName"].ToString()%>
                                    <%=Request.QueryString["StartDate"].ToString()%>
                                    -
                                    <%=Request.QueryString["Year"].ToString()%>
                                    <%=Request.QueryString["EndDate"].ToString()%>
                                </td>
                                <td>
                                    &nbsp;</td>
                                <td class="TabHead" style="width: 130px">
                                    Run By :
                                    <%= Session["UserName"].ToString() %>
                                </td>
                                <td class="TabHead" style="width: 130px">
                                    Run Date :
                                    <%=DateTime.Now.ToShortDateString()%>
                                </td>
                            </tr>
                            <tr>
                                <td class="LeftPadding TabHead" colspan="2">
                                    CSR Name:
                                    <%=Request.QueryString["RepName"].ToString()%>
                                </td>
                                <td class="TabHead" style="width: 200px">
                                </td>
                                <td>
                                </td>
                                <td class="TabHead" style="width: 130px">
                                </td>
                                <td class="TabHead" style="width: 130px">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="Sbar" id="div-datagrid" style="overflow-x: hidden; overflow-y: auto;
                            position: relative; top: 0px; left: 0px; width: 100%; height: 575px; border: 0px solid;">
                            <div id="PrintDG2">
                                <asp:DataGrid ID="dgQuote2Order" BackColor="#f4fbfd" runat="server" AutoGenerateColumns="false"
                                    ShowFooter="true" PagerStyle-Visible="false" BorderWidth="1" GridLines="both"
                                    BorderColor="#c9c6c6" OnItemDataBound="dgQuote2Order_ItemDataBound">
                                    <HeaderStyle HorizontalAlign="center" Wrap="false" Height="25px" CssClass="GridHead" BackColor="#DFF3F9" />
                                    <ItemStyle HorizontalAlign="Left" Wrap="false" CssClass="GridItem" BackColor="#F4FBFD" />
                                    <AlternatingItemStyle HorizontalAlign="Left" Wrap="false" CssClass="GridItem" BackColor="White" />
                                    <FooterStyle HorizontalAlign="Center" Wrap="false" CssClass="GridHead" Height="20px" BackColor="#DFF3F9" />
                                    <Columns>



                                                <asp:BoundColumn HeaderStyle-Width="40" HeaderText="Cust #" ItemStyle-Width="40" DataField="CustomerNumber" SortExpression="CustomerNumber" />
                                                    
                                                <asp:BoundColumn HeaderStyle-Width="250" HeaderText="Name" ItemStyle-Width="250" FooterStyle-HorizontalAlign="right" DataField="CustomerName" SortExpression="CustomerName" />
                                                
                                                <asp:BoundColumn HeaderStyle-Width="20" HeaderText="Brn" ItemStyle-Width="20" FooterStyle-HorizontalAlign="right" DataField="SalesLocationCode" SortExpression="SalesLocationCode" />

                                                <asp:BoundColumn HeaderStyle-Width="40" HeaderText="# of Quotes" ItemStyle-Width="40" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="NoOfECommQuotes" DataFormatString="{0:#,##0}" SortExpression="NoOfECommQuotes" />

                                                <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Extended $ Amt" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="ECommExtAmount" DataFormatString="{0:#,##0.00}" SortExpression="ECommExtAmount" />
                                                    
                                                <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Extended Weight" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="ECommExtWeight" DataFormatString="{0:#,##0.00}" SortExpression="ECommExtWeight" />
                                                
                                                <asp:BoundColumn HeaderStyle-Width="40" HeaderText="# of Orders" ItemStyle-Width="40" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="NoOfECommOrders" DataFormatString="{0:#,##0}" SortExpression="NoOfECommOrders" />                                 
                                                
                                                <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Extended $ Amt" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="ECommExtOrdAmount" DataFormatString="{0:#,##0.00}" SortExpression="ECommExtOrdAmount" />
                                                    
                                                <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Extended Weight" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="ECommExtOrdWeight" SortExpression="ECommExtOrdWeight" DataFormatString="{0:#,##0.00}" />                                       

                                                <asp:BoundColumn HeaderStyle-Width="40" HeaderText="# of Quotes" ItemStyle-Width="40" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="NoOfManualQuotes" DataFormatString="{0:#,##0}" SortExpression="NoOfManualQuotes" />  

                                                <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Extended $ Amt" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="ManualExtAmount" DataFormatString="{0:#,##0.00}" SortExpression="ManualExtAmount" />
                                                    
                                                <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Extended Weight" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="ManualExtWeight" DataFormatString="{0:#,##0.00}" SortExpression="ManualExtWeight" />                                     

                                                <asp:BoundColumn HeaderStyle-Width="40" HeaderText="# of Orders" ItemStyle-Width="40" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="NoOfManualOrders" DataFormatString="{0:#,##0}" SortExpression="NoOfManualOrders" /> 

                                                <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Extended $ Amt" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="ManualExtOrdAmount" DataFormatString="{0:#,##0.00}" SortExpression="ManualExtOrdAmount" />
                                                    
                                                <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Extended Weight" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="ManualExtOrdWeight" SortExpression="ManualExtOrdWeight" DataFormatString="{0:#,##0.00}" />

                                                <asp:BoundColumn HeaderStyle-Width="40" HeaderText="# of Quotes" ItemStyle-Width="40" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="NoOfMissedECommQuotes" DataFormatString="{0:#,##0}" SortExpression="NoOfMissedECommQuotes" /> 

                                                <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Extended $ Amt" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="MissedECommExtAmount" DataFormatString="{0:#,##0.00}" SortExpression="MissedECommExtAmount" />
                                                    
                                                <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Extended Weight" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="MissedECommExtWeight" DataFormatString="{0:#,##0.00}" SortExpression="MissedECommExtWeight" />

                                                <asp:BoundColumn HeaderStyle-Width="40" HeaderText="# of Quotes" ItemStyle-Width="40" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="NoOfMissedManualQuotes" DataFormatString="{0:#,##0}" SortExpression="NoOfMissedManualQuotes" />                                     
                                                
                                                <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Extended $ Amt" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="MissedManualExtAmount" DataFormatString="{0:#,##0.00}" SortExpression="MissedManualExtAmount" />
                                                    
                                                <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Extended Weight" ItemStyle-Width="100" ItemStyle-HorizontalAlign="right" FooterStyle-HorizontalAlign="right"
                                                    DataField="MissedManualExtWeight" SortExpression="MissedManualExtWeight" DataFormatString="{0:#,##0.00}" />




                                    </Columns>
                                </asp:DataGrid>
                                <center>
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label></center>
                            </div>
                        </div>
                        <input type="hidden" runat="server" id="hidSort" /></td>
                </tr>
                <tr>
                    <td>
                        <uc1:Footer ID="Footer1" runat="server" />
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
