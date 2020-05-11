<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="ITotalTrend.aspx.cs" Inherits="ITotalTrend" %>
<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>I-Total MTD Trend Report</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script src="../Common/Javascript/Common.js" type="text/javascript"></script>

    <script language="javascript">  
    function OpenHelp(topic)
    {
        window.open('CPRHelp.aspx#' + topic + '','CPRHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
    }
    
    function PrintITotal()
    {    
//        var hwin=window.open('ITotalTrendPreview.aspx','ITotalTrendPreview', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (1010/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
//        hwin.focus();

        var printDialogURL = '<%=ConfigurationManager.AppSettings["IntranetSiteURL"].ToString() %>' + 'PrintUtility/PrintUtility.aspx';

//alert(printDialogURL)
        OpenPrintDialog('ITotal/ITotalTrendPreview.aspx?parm=one','Print','000000','ITotalTrendPreview',printDialogURL)

    }

//    var WinPrint;  
//    function PrintITotal()
//    {   
//            var prtContent = "<html><head>";
//            prtContent = prtContent + "<link href=../Common/StyleSheet/Styles.css rel=stylesheet type=text/css />" ;
//            prtContent = prtContent + "</head><body>" ;
//            prtContent = prtContent + document.getElementById("PrintHeading1").outerHTML ;
//            prtContent = prtContent + document.getElementById("PrintHeading2").outerHTML ;
//            prtContent = prtContent + document.getElementById("KahunaTable").outerHTML ;
//            //prtContent = prtContent.replace(/100px/g, "150px");
//            prtContent = prtContent + "</body></html>";        
//            var WinPrint = window.open('','','left=0,top=0,width=1000,height=100,toolbar=0,scrollbars=0,status=0');        
//            var WinPrint = window.open('print.aspx','','left=0,top=0,width=1000,height=100,toolbar=0,scrollbars=0,status=0');  
//            WinPrint.document.write(prtContent);
//            WinPrint.document.close();
//            WinPrint.focus();
//            WinPrint.print();
//            WinPrint.close();
//            return false;
//    }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <uc1:Header ID="TopFrame1" runat="server" />
        <div id="PrintArea">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td valign="middle" class="PageHead">
                        <span class="Left5pxPadd" id="PrintHeading1">
                            <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Branch Inventory On Hand - Month to Date Trend Report">
                            </asp:Label></span>
                    </td>
                    <td class="PageHead">
                        <span class="Left5pxPadd" id="PrintHeading2">
                        For:
                        <asp:Label ID="PeriodLabel" runat="server" Text=""></asp:Label>
                        </span>
                    </td>
                    <td align="right" class="PageHead">
                        <table border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td>
                                    <asp:ImageButton ID="ExcelButt" runat="server" ImageUrl="../Common/Images/Excel.gif"
                                        OnClick="ExcelExportButton_Click" />
                                    <img src="../Common/Images/print.gif" style="cursor: hand" onclick="javascript:PrintITotal();"
                                        title="Click Here to&#013;Print this window">
                                </td>
                                <td>&nbsp;
                                    <img src="../Common/Images/close.gif" style="cursor: hand" onclick="javascript:window.close();"
                                        title="Click Here to&#013;Close this window">&nbsp;&nbsp;
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <table width="100%" cellpadding="0" cellspacing="0" id="KahunaTable">
                <tr>
                    <td valign="top" width="30%">
                        <asp:Panel ID="Panel1" runat="server" Height=610 ScrollBars="vertical">
                        <div runat="server" style="overflow:auto; width:1010px; height:610px; border:0px solid; vertical-align:top; overflow-y:scroll;">
                            <asp:GridView ID="TrendGrid" runat="server" AutoGenerateColumns="false" BorderWidth="0" Width="1650px">
                                <AlternatingRowStyle CssClass="GridItem" BackColor="#FFFFFF" />
                                <RowStyle CssClass="GridItem" />
                                <Columns>
                                    <asp:BoundField HeaderText="Date" DataField="CurrentDt" SortExpression="CurrentDt"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="70" DataFormatString="{0:MM/dd/yyyy}  " ItemStyle-HorizontalAlign="center"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
                                    <asp:BoundField HeaderText="Brn Cost $" DataField="BrnCost" SortExpression="BrnCost"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="100" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>
                                    <asp:BoundField HeaderText="Brn Weight" DataField="BrnWgt" SortExpression="BrnWgt"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="100" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>
                                    <asp:BoundField HeaderText="Cost $/Lbs" DataField="BrnPerLb" SortExpression="BrnPerLb"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="80" DataFormatString="{0:N3}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>
                                    <asp:BoundField HeaderText="OTW Cost $" DataField="OTWCost" SortExpression="OTWCost"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="100" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>
                                    <asp:BoundField HeaderText="OTW Weight" DataField="OTWWgt" SortExpression="OTWWgt"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="100" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>
                                    <asp:BoundField HeaderText="Cost $/Lbs" DataField="OTWPerLb" SortExpression="OTWPerLb"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="80" DataFormatString="{0:N3}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>

                                    <asp:BoundField HeaderText="OTW Months" DataField="OTWMonths" SortExpression="OTWMonths"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="80" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>

                                    <asp:BoundField HeaderText="Avl Cost $" DataField="AvailCost" SortExpression="AvailCost"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="100" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>

                                    <asp:BoundField HeaderText="Avl Weight" DataField="AvailWght" SortExpression="AvailWght"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="100" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>

                                    <asp:BoundField HeaderText="Avl Months" DataField="AvailMonths" SortExpression="AvailMonths"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="80" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>

                                    <asp:BoundField HeaderText="Trf Cost $" DataField="TrfCost" SortExpression="TrfCost"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="100" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>

                                    <asp:BoundField HeaderText="Trf Weight" DataField="TrfWght" SortExpression="TrfWght"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="100" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>

                                    <asp:BoundField HeaderText="Trf Months" DataField="TrfMonths" SortExpression="TrfMonths"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="80" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>

                                    <asp:BoundField HeaderText="OnOrd Cost $" DataField="OnOrdCost" SortExpression="OnOrdCost"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="100" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>

                                    <asp:BoundField HeaderText="OnOrd Weight" DataField="OnOrdWght" SortExpression="OnOrdWght"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="100" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>

                                    <asp:BoundField HeaderText="OnOrd Months" DataField="OnOrdMonths" SortExpression="OnOrdMonths"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="80" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>

<%--
                                    <asp:BoundField HeaderText="RTSB Cost $" DataField="RTSBCost" SortExpression="RTSBCost"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="100" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>
--%>

                                    <asp:BoundField HeaderText="RTSB Weight" DataField="RTSBWght" SortExpression="RTSBWght"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="100" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>

                                    <asp:BoundField HeaderText="RTSB Months" DataField="RTSBMonths" SortExpression="RTSBMonths"
                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="BluBg" HtmlEncode="false"
                                        ItemStyle-Width="80" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>
                                </Columns>
                            </asp:GridView>
                        </div>
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </div>
        <uc2:Footer ID="BottomFrame1" runat="server" />
    </form>
</body>
</html>
