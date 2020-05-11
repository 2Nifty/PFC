<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ITotalTrendPreview.aspx.cs" Inherits="ITotalTrendPreview" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>I-Total MTD Trend Report Preview</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <% if ((Request.QueryString["ScriptX"] != null) && (Request.QueryString["ScriptX"].ToUpper() == "YES"))
       { %>
            <!-- #Include virtual="../common/include/ScriptX.inc" -->
            <script src="../Common/JavaScript/ScriptX.js" type="text/javascript"></script>
            <script type="text/javascript">
//alert('Landscape');
                //Landscape with 1/4 inch margins
                SetPrintSettings(false, 0.25, 0.25, 0.25, 0.25);
//alert('set');
             </script>

    <% } %>

</head>
<body>
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr valign="top">
                <td>
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
                        </tr>
                    </table>
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td valign="top">
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
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>