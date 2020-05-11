<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CriticalItemDet.aspx.vb"
    Inherits="CriticalItemDet" %>

<%@ Register Src="UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>BULK Critical Item Report Detail</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />

    <script language="javascript" src="javascript/ContextMenu.js"></script>

    <script language="javascript" src="javascript/browsercompatibility.js"></script>

    <script language="javascript">

function PrintReport(Critical, VelocityType, VelocityCode, LocNum)
        {
            var URL = "CriticalItemDetPreview.aspx?Critical=" + Critical + "&VelocityType=" + VelocityType + "&VelocityCode=" + VelocityCode + "&LocNum=" + LocNum + "&LocDesc=" + document.getElementById("LocDesc").innerText
            window.open(URL,'Preview','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
        }

function LoadHelp()
    {
    window.open('Help.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
    }

    </script>

</head>
<body bottommargin="0" onmouseup="Hide();" onload="LoadWindow();">
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" runat="server" id="BodyTable">
            <tr>
                <td colspan="2" valign="middle" style="height: 98px">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr>
                            <td colspan="2" class="PageHead">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td style="height: 20px;" valign="middle">
                                            <div align="left" class="LeftPadding">
                                                BULK Critical Item Report Detail</div>
                                        </td>
                                        <td align="right" valign="middle">
                                            &nbsp;<asp:ImageButton ID="ExportRpt" runat="server" Style="cursor: hand" ImageUrl="images/ExporttoExcel.gif" />
                                            <img src="images/Print.gif" onclick="Javascript:PrintReport('<%=Request.QueryString("Critical") %>', '<%=Request.QueryString("VelocityType") %>', '<%=Request.QueryString("VelocityCode") %>', '<%=Request.QueryString("LocNum") %>');"
                                                style="cursor: hand" />
                                            <img src="Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                                            <img src="images/close.gif" onclick="javascript:parent.window.close();;" style="cursor: hand" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" class="PageBg">
                                <table width="100%" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td height="20px" width="400px" class="TabHead">
                                            <span>
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                <asp:Label ID="lblVelocityType" runat="server" Text="Label"></asp:Label>
                                            </span>
                                        </td>
                                        <td height="20px" class="TabHead">
                                            <span>Location: 
                                                <asp:Label ID="LocDesc" runat="server" Text=""></asp:Label>
                                            </span>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td valign="top" width="100%" style="height: 450px">
                                            <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px;
                                                left: 0px; height: 485px; border: 0px solid;">
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td colspan="10">
                                                            <asp:DataGrid ID="GridView1" PageSize="22" AllowPaging="true" PagerStyle-Visible="false"
                                                                BackColor="#F4FBFD" runat="server" ShowFooter="True" BorderWidth="1px" AutoGenerateColumns="False">
                                                                <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                                                <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD" />
                                                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                                <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                                                <Columns>

                                                                    <%-- Column 00 --%>
                                                                    <asp:BoundColumn DataField="ItemNo" HeaderText="Item No" SortExpression="ItemNo">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="100px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <%-- Column 01 --%>
                                                                    <asp:BoundColumn DataField="Description" HeaderText="Description" SortExpression="Description">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="250px" />
                                                                        <FooterStyle CssClass="GridHead" HorizontalAlign="Left" />
                                                                        <HeaderStyle CssClass="GridHead" Width="250px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <%-- Column 02 --%>
                                                                    <asp:BoundColumn DataField="AvailQty" HeaderText="Available Qty" SortExpression="AvailQty">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="100px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <%-- Column 03 --%>
                                                                    <asp:BoundColumn DataField="TotUse30" HeaderText="30 Day Usage" SortExpression="TotUse30">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="100px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <%-- Column 04 --%>
                                                                    <asp:BoundColumn DataField="MonthsOnHand" HeaderText="Months On-Hand" SortExpression="MonthsOnHand">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="100px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <%-- Column 05 --%>
                                                                    <asp:BoundColumn DataField="ExtSoldWght" HeaderText="30D Usage Lbs" SortExpression="ExtSoldWght">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="100px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <%-- Column 06 --%>
                                                                    <asp:BoundColumn DataField="CriticalWght" HeaderText="Critical Pounds" SortExpression="CriticalWght">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="100px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <%-- Column 07 --%>
                                                                    <asp:BoundColumn DataField="CriticalWghtPct" HeaderText="% Critical (Pounds)" SortExpression="CriticalWghtPct"
                                                                        DataFormatString="{0:0.0%}">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <%-- Column 08 --%>
                                                                    <asp:BoundColumn DataField="NonCriticalWghtPct" HeaderText="% Non Critical (Pounds)" SortExpression="NonCriticalWghtPct"
                                                                        DataFormatString="{0:0.0%}">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>

                                                                    <%-- Column 09 --%>
                                                                    <asp:BoundColumn DataField="TargetPct" HeaderText="Target %" SortExpression="TargetPct"
                                                                        DataFormatString="{0:0.0%}">
                                                                        <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                                        <FooterStyle CssClass="GridHead" />
                                                                        <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>
                                                                    
                                                                    <%-- Column 10 --%>
                                                                    <asp:BoundColumn DataField="NetWgt" Visible="False" />
                                                                
                                                                </Columns>
                                                            </asp:DataGrid></td>
                                                    </tr>
                                                    <tr style="border:1px solid #e1e1e1; background-color:#B3E2F0;">
                                                        <td style="width: 100px">
                                                        </td>
                                                        <td class="GridHead" align="left" style="border:1px solid #e1e1e1; width:250px">Grand Totals:
                                                        </td>
                                                        <td class="GridHead" align="right" style="border:1px solid #e1e1e1; width:100px">
                                                            <asp:Label ID="lblTotQty" runat="server" Text="n/a"></asp:Label></td>
                                                        <td class="GridHead" align="right" style="border:1px solid #e1e1e1; width:100px">
                                                            <asp:Label ID="lblTotUse" runat="server" Text="n/a"></asp:Label></td>
                                                        <td class="GridHead" align="right" style="border:1px solid #e1e1e1; width:100px">
                                                            <asp:Label ID="lblTotMonths" runat="server" Text="n/a"></asp:Label></td>
                                                        <td class="GridHead" align="right" style="border:1px solid #e1e1e1; width:100px">
                                                            <asp:Label ID="lblTotLbs" runat="server" Text="n/a"></asp:Label></td>
                                                        <td class="GridHead" align="right" style="border:1px solid #e1e1e1; width:100px">
                                                            <asp:Label ID="lblTotCriticalLbs" runat="server" Text="n/a"></asp:Label></td>
                                                        <td class="GridHead" align="right" style="border:1px solid #e1e1e1; width:76px">
                                                            <asp:Label ID="lblCriticalPct" runat="server" Text="n/a"></asp:Label></td>
                                                        <td class="GridHead" align="right" style="border:1px solid #e1e1e1; width:76px">
                                                            <asp:Label ID="lblNonCriticalPct" runat="server" Text="n/a"></asp:Label></td>
                                                        <td class="GridHead" align="right" style="border:1px solid #e1e1e1; width:76px">
                                                            <asp:Label ID="lblTargetPct" runat="server"></asp:Label></td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 2px" valign="top" width="100%">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="BluBg">
                                <table width="100%" id="tblPager" runat="SERVER">
                                    <tr>
                                        <td>
                                            <uc1:pager ID="Pager1" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                                <asp:HiddenField runat="server" ID="hidSort" />
                                <asp:HiddenField runat="server" ID="hidSortField" />
<%--                            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:csPFCReports %>"
                                                    SelectCommand="SELECT ItemNo, CorpFixedVelCode as VelocityCode, ExtSoldWght, AvailQty, TotUse30, CriticalQty, CriticalFlag, NonCriticalFlag, CriticalWght, NonCriticalWght, CriticalWghtPct, LocationCode, Description FROM CriticalItemDetail WHERE (LocationCode = @LocationCode) AND (CorpFixedVelCode = @VelCode) AND (CriticalFlag >= @CriticalFlag) ORDER BY ItemNo">
                                                    <SelectParameters>
                                                        <asp:QueryStringParameter Name="LocationCode" QueryStringField="LocNum" Type="Int32" />
                                                        <asp:QueryStringParameter Name="VelocityCode" QueryStringField="VelocityCode"
                                                            Type="String" />
                                                        <asp:QueryStringParameter Name="CriticalFlag" QueryStringField="Critical" Type="Int32" />
                                                    </SelectParameters>
                                                </asp:SqlDataSource>--%>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>

    <script>window.parent.document.getElementById("Progress").style.display='none';</script>

</body>
</html>
