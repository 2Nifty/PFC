<%@ Page Language="C#" AutoEventWireup="true" CodeFile="eCommerceSalesAnalysisHdrRptPreview.aspx.cs" Inherits="eCommerceSalesAnalysisHdrRptPreview" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Quote and Order Header Report</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
    .5pxLeft
    {
    	padding-left: 5px;
    }
    .Border1
    {
        border-bottom:1px Solid #DAEEEF;
        border-collapse:collapse;
    }
    .Border2
    {
        border-right:1px Solid #DAEEEF;
        border-collapse:collapse;
    }
    .GridPad
    {
        padding-top: 2px;
        padding-bottom: 2px;
    }
    </style>
</head>
<body>
    <form id="frmHdr" runat="server">
        <div id="pagePrint">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td>
                        <table class="PageHead" style="height: 40px" width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="Left5pxPadd BannerText" width="72%">
                                    Quote and Order Header Report
                                </td>

                                <td align="right" width="70%" style="padding:5px;">
                                    <img onclick="javascript:PrintReport('trHead','PrintDG2');" src="../Common/Images/Print.gif" style="cursor: hand" id="IMG1" />
                                </td>
                                <td align="left" width="30%">
                                    <img src="../Common/images/close.gif" style="cursor: hand" onclick="javascript:window.close();" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="trHead" class="PageBg" style="height:20px;">
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="height:20px;">
                            <tr class="PageBg">
                                <td class="LeftPadding TabHead" style="width: 200px">
                                    <asp:Label ID="lblSourceType" runat="server" Text=""></asp:Label>
                                </td>
                                <td class="LeftPadding TabHead" style="width: 150px">
                                    Customer # :
                                    <%=Request.QueryString["CustomerNumber"].ToString() %>
                                </td>
                                <td class="LeftPadding TabHead" style="width: 420px">
                                    Customer Name :
                                    <%=Request.QueryString["CustomerName"].ToString() %>
                                </td>
                                <td class="TabHead" style="width: 125px">
                                    Run By :
                                    <%= Session["UserName"].ToString() %>
                                </td>
                                <td class="TabHead" style="width: 125px">
                                    Run Date :
                                    <%=DateTime.Now.ToShortDateString()%>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                            top: 0px; left: 0px; width: 1010px; height: 610px; border: 0px solid;">
                            <div id="PrintDG2">
                                <asp:DataGrid ID="dgSalesAnalysisHdr" BackColor="#f4fbfd" runat="server" Width="995px"
                                    AutoGenerateColumns="false" ShowFooter="true" PagerStyle-Visible="false" BorderWidth="1"
                                    GridLines="both" BorderColor="#c9c6c6" OnItemDataBound="dgSalesAnalysisHdr_ItemDataBound">
                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Center" Wrap="true" />
                                    <ItemStyle CssClass="GridItem" BackColor="White" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Right" Wrap="false" />
                                    <AlternatingItemStyle CssClass="GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                        Height="20px" HorizontalAlign="Right" Wrap="false" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                        HorizontalAlign="Right" Wrap="false" />
                                    <Columns>
                                        <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Quote Method" ItemStyle-Width="100"
                                            ItemStyle-HorizontalAlign="Left" ItemStyle-CssClass="5pxLeft" DataField="QuoteMethod"
                                            SortExpression="QuoteMethod" />
                                        <asp:BoundColumn HeaderStyle-Width="70" HeaderText="Quote Date" ItemStyle-Width="70"
                                            ItemStyle-HorizontalAlign="Center" DataField="QuotationDate" DataFormatString="{0:MM/dd/yyyy}"
                                            SortExpression="QuotationDate" />
                                        <asp:BoundColumn HeaderStyle-Width="70" HeaderText="Expiry Date" ItemStyle-Width="70"
                                            ItemStyle-HorizontalAlign="Center" DataField="ExpiryDate" DataFormatString="{0:MM/dd/yyyy}"
                                            SortExpression="ExpiryDate" />
                                        <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Quote No" ItemStyle-Width="100"
                                            DataField="QuoteNumber" SortExpression="QuoteNumber" />
                                        <asp:BoundColumn HeaderStyle-Width="30" HeaderText="Brn" ItemStyle-Width="30" ItemStyle-HorizontalAlign="Center"
                                            DataField="SalesBranchofRecord" SortExpression="SalesBranchofRecord" />
                                        <asp:BoundColumn HeaderStyle-Width="50" HeaderText="Lines" ItemStyle-Width="50"
                                            DataField="LineCount" DataFormatString="{0:#,##0}" SortExpression="LineCount" />
                                        <asp:BoundColumn HeaderStyle-Width="75" HeaderText="Tot Req Qty" ItemStyle-Width="75"
                                            DataField="RequestQuantity" DataFormatString="{0:#,##0}" SortExpression="RequestQuantity" />
                                        <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Total Price" ItemStyle-Width="100"
                                            DataField="ExtPrice" DataFormatString="{0:c}" SortExpression="ExtPrice" />
                                        <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Total Weight" ItemStyle-Width="100"
                                            DataField="ExtWeight" DataFormatString="{0:#,##0.00}" SortExpression="ExtWeight" />

                                        <asp:BoundColumn HeaderStyle-Width="50" HeaderText="Lines" ItemStyle-Width="50"
                                            DataField="MissedLineCount" DataFormatString="{0:#,##0}" SortExpression="MissedLineCount" />
                                        <asp:BoundColumn HeaderStyle-Width="75" HeaderText="Tot Req Qty" ItemStyle-Width="75"
                                            DataField="MissedRequestQuantity" DataFormatString="{0:#,##0}" SortExpression="MissedRequestQuantity" />
                                        <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Total Price" ItemStyle-Width="100"
                                            DataField="MissedExtPrice" DataFormatString="{0:c}" SortExpression="MissedExtPrice" />
                                        <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Total Weight" ItemStyle-Width="100"
                                            DataField="MissedExtWeight" DataFormatString="{0:#,##0.00}" SortExpression="MissedExtWeight" />

                                    </Columns>
                                </asp:DataGrid>
                                <center><asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found" Visible="False" /></center>
                            </div>
                        </div>
                    </td>
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

<script>
function PrintReport(strid1,strid2)
{
    var prtContent = "<html><head><link href='common/StyleSheet/stylesheet.css' rel='stylesheet' type='text/css' /></head><body>";
    prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td style='width:350px;'colspan=3><h3>Quote and Order Header Report</h3></td></tr>";
    prtContent = prtContent +"</table><br>"; 
    prtContent = prtContent + document.getElementById(strid1).innerHTML ; 
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
</script>