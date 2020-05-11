<%@ Page Language="C#" AutoEventWireup="true" CodeFile="POAgingRpt.aspx.cs" Inherits="POAgingRpt" %>

<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage2.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="../Common/UserControls/pager.ascx" TagName="Pager" TagPrefix="uc3" %>
<%@ Register Src="../Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc4" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>PO Aging Trend Report</title>

    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script src="../Common/Javascript/Common.js" type="text/javascript"></script>

    <script>
        function LoadHelp()
        {
            window.open('POAgingRptHelp.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
        }

        function Close(session)
        {
            POAgingRpt.DeleteExcel('POAging'+session).value;
            window.close();
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server" ID="smPOAging"></asp:ScriptManager>
        <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse;" id="tblMain">
            <tr>
                <td height="5%" id="tdHeaders" align="center">
                    <uc1:Header ID="HeaderID" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="lightBlueBg" style="border-top:solid 1px #88D2E9; padding-top:5px; border-bottom:solid 1px #88D2E9; padding-bottom:5px;" width="100%">
                    <table>
                        <tr>
                            <td>
                                <span class="BanText" style="padding-left: 5px; color: #CC0000">PO Aging Trend Report</span>
                            </td>
                            <td width="79%" align="right">
                                <img src="../Common/images/help.gif" onclick="javascript:LoadHelp();" style="cursor: hand" />&nbsp;&nbsp;&nbsp;
                                <img id="btnClose" src="../Common/images/close.gif" style="cursor:hand" onclick="javascript:Close('<%=Session["SessionID"].ToString() %>');"/>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td height="522px" valign="top">
                    <table cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td valign="top">
                                <asp:UpdatePanel ID="pnlRptGrid" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div id="divdatagrid" class="Sbar" align="left" runat="server" style="overflow:auto; width:1020px; position:relative; top:0px; left:0px; height:522px; border:0px solid; vertical-align:top; overflow-y:scroll;">
                                            <asp:DataGrid ID="dgPOAging" Width="2380px" runat="server" BorderWidth="1px" BorderColor="#DAEEEF" CssClass="grid" Style="height: auto;" AllowPaging="true" PageSize="18"
                                                UseAccessibleHeader="True" AutoGenerateColumns="False" ShowHeader="true" ShowFooter="false" OnItemDataBound="dgPOAging_ItemDataBound">
                                                    <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                    <ItemStyle CssClass="GridItem" />
                                                    <AlternatingItemStyle CssClass="zebra" />
                                                    <FooterStyle CssClass="gridHeader" />
                                                    <Columns>
                                                        <asp:BoundColumn HeaderText="Category Group" DataField="CatGroup">
                                                            <HeaderStyle Width="425px" />
                                                            <ItemStyle Width="425px" HorizontalAlign="Left" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Avg Use Lbs" DataField="AvgUseLbs" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="90px" />
                                                            <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Avl Lbs" DataField="AvlLbs" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="90px" />
                                                            <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>
                                                        
                                                        <asp:BoundColumn HeaderText="Avl Mos" DataField="AvlMos" DataFormatString="{0:n1}">
                                                            <HeaderStyle Width="50px" />
                                                            <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Trf Lbs" DataField="TrfLbs" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="90px" />
                                                            <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Trf Mos" DataField="TrfMos" DataFormatString="{0:n1}">
                                                            <HeaderStyle Width="50px" />
                                                            <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="OTW Lbs" DataField="OTWLbs" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="90px" />
                                                            <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="OTW Mos" DataField="OTWMos" DataFormatString="{0:n1}">
                                                            <HeaderStyle Width="55px" />
                                                            <ItemStyle Width="55px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="RTS Lbs" DataField="RTSLbs" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="90px" />
                                                            <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="RTS Mos" DataField="RTSMos" DataFormatString="{0:n1}">
                                                            <HeaderStyle Width="50px" />
                                                            <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="OO Lbs" DataField="OOLbs" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="90px" />
                                                            <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="OO Mos" DataField="OOMos" DataFormatString="{0:n1}">
                                                            <HeaderStyle Width="50px" />
                                                            <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Tot Lbs" DataField="TotalLbs" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="90px" />
                                                            <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Tot Mos" DataField="TotalMos" DataFormatString="{0:n1}">
                                                            <HeaderStyle Width="50px" />
                                                            <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Month 1 Sales" DataField="ForecastLbs1" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="90px" />
                                                            <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Month 1 Receipts" DataField="Month1RcptLbs" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="100px" />
                                                            <ItemStyle Width="100px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>
                                                        
                                                        <asp:BoundColumn HeaderText="Month 1 Avl" DataField="Month1AvlLbs" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="90px" />
                                                            <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Mth 1 Mos" DataField="Month1Mos" DataFormatString="{0:n1}">
                                                            <HeaderStyle Width="60px" />
                                                            <ItemStyle Width="60px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Month 2 Sales" DataField="ForecastLbs2" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="90px" />
                                                            <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Month 2 Receipts" DataField="Month2RcptLbs" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="100px" />
                                                            <ItemStyle Width="100px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>
                                                        
                                                        <asp:BoundColumn HeaderText="Month 2 Avl" DataField="Month2AvlLbs" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="90px" />
                                                            <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Mth 2 Mos" DataField="Month2Mos" DataFormatString="{0:n1}">
                                                            <HeaderStyle Width="60px" />
                                                            <ItemStyle Width="60px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Month 3 Sales" DataField="ForecastLbs3" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="90px" />
                                                            <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Month 3 Receipts" DataField="Month3RcptLbs" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="100px" />
                                                            <ItemStyle Width="100px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>
                                                        
                                                        <asp:BoundColumn HeaderText="Month 3 Avl" DataField="Month3AvlLbs" DataFormatString="{0:n0}">
                                                            <HeaderStyle Width="90px" />
                                                            <ItemStyle Width="90px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn HeaderText="Mth 3 Mos" DataField="Month3Mos" DataFormatString="{0:n1}">
                                                            <HeaderStyle Width="60px" />
                                                            <ItemStyle Width="60px" HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                            </asp:DataGrid>

                                            <table id="tblGrdTotals" class="BluBordAll" border="0" cellspacing="0" cellpadding="0" runat="server" visible="true" style="position: relative; top: 0px; left: 0px; border: 1px solid;">
                                                <tr style="border:1px solid #e1e1e1; background-color:#B3E2F0;">
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="382px"><tr><td>Grand Totals for all Groups ...</td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="90px"><tr><td><asp:Label ID="lblTotAvgUseLbs" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="90px"><tr><td><asp:Label ID="lblTotAvlLbs" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="52px"><tr><td><asp:Label ID="lblTotAvlMos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="89px"><tr><td><asp:Label ID="lblTotTrfLbs" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="52px"><tr><td><asp:Label ID="lblTotTrfMos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="90px"><tr><td><asp:Label ID="lblTotOTWLbs" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="56px"><tr><td><asp:Label ID="lblTotOTWMos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="90px"><tr><td><asp:Label ID="lblTotRTSLbs" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="52px"><tr><td><asp:Label ID="lblTotRTSMos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="91px"><tr><td><asp:Label ID="lblTotOOLbs" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="52px"><tr><td><asp:Label ID="lblTotOOMos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="91px"><tr><td><asp:Label ID="lblTotalLbs" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="52px"><tr><td><asp:Label ID="lblTotalMos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="91px"><tr><td><asp:Label ID="lblTotMth1Sls" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="99px"><tr><td><asp:Label ID="lblTotMth1Rct" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="90px"><tr><td><asp:Label ID="lblTotMth1Avl" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="61px"><tr><td><asp:Label ID="lblTotMth1Mos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="91px"><tr><td><asp:Label ID="lblTotMth2Sls" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="99px"><tr><td><asp:Label ID="lblTotMth2Rct" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="90px"><tr><td><asp:Label ID="lblTotMth2Avl" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="61px"><tr><td><asp:Label ID="lblTotMth2Mos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="91px"><tr><td><asp:Label ID="lblTotMth3Sls" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="99px"><tr><td><asp:Label ID="lblTotMth3Rct" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="91px"><tr><td><asp:Label ID="lblTotMth3Avl" runat="server" Text="999,999,999,999"></asp:Label></td></tr></table></td>
                                                    <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="60px"><tr><td><asp:Label ID="lblTotMth3Mos" runat="server" Text="999.9"></asp:Label></td></tr></table></td>
                                                </tr>
                                            </table>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="lightBlueBg buttonBar" style="border-top:solid 1px #CDECF6">
                    <table>
                        <tr>
                            <td>
                                <asp:UpdateProgress ID="pnlProgress" runat="server" DisplayAfter="1" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                            <td width="92%" align="right">
                                <asp:ImageButton ID="btnExport" Style="cursor: hand;" Height="18px" Width="18px" CausesValidation="false" ImageUrl="~/Common/Images/ExcelIcon.jpg"
                                    ToolTip="Export To Excel" runat="server" OnClick="btnExport_Click" />
                            </td>
                            <td style="padding-left: 3px">
                                <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlExport">
                                    <ContentTemplate>
                                        <uc4:PrintDialogue ID="PrintDialogue1" PageTitle="POAgingRpt" EnableFax="false" EnableEmail="false" runat="server"></uc4:PrintDialogue>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="BluBg">
                    <asp:UpdatePanel ID="pnlPager" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" id="tPager" runat="server">
                                <tr>
                                    <td>
                                        <uc3:pager ID="Pager1" OnBubbleClick="PageChanged" runat="server" Visible="true" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="BottomFooterID" FooterTitle="PO Aging Trend Report" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
