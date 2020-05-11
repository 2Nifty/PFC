<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UnreceivedPORpt.aspx.cs" Inherits="UnreceivedPORpt" %>

<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage2.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="../Common/UserControls/pager.ascx" TagName="Pager" TagPrefix="uc3" %>
<%@ Register Src="../Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc4" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Unreceived PO Report</title>

    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script src="../Common/Javascript/Common.js" type="text/javascript"></script>

    <script>
        function LoadHelp()
        {
            window.open('UnreceivedPOHelp.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
        }

        function Close(session)
        {
            UnreceivedPORpt.DeleteExcel('UnrcvdPO'+session).value;
            window.close();
        }

        function UnloadPage()
        {
           UnreceivedPORpt.UnloadPage().value;
        }
    </script>

    <style type="text/css">
        /* Locks table header */
        tr.gridHeader th
        {
            position:relative;
            cursor: default; 
            top: expression(document.getElementById("divdatagrid").scrollTop-2); /*IE5+ only*/
            border-bottom:0px;
            border-top:0px;
            border-left:0px;
            border-right:solid 1px #DAEEEF;
        }
    </style>

</head>
<body onunload="javascript:UnloadPage();">
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server" ID="smUnrcvdPO"></asp:ScriptManager>
        <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse;" id="tblMain">
            <tr>
                <td height="5%" id="tdHeaders">
                    <uc1:Header ID="HeaderID" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="lightBlueBg" style="border-top:solid 1px #88D2E9; padding-top:5px; border-bottom:solid 1px #88D2E9; padding-bottom:5px;" width="100%">
                    <span class="BanText" style="padding-left: 5px; color: #CC0000">Unreceived Purchase Orders By Category</span>
                </td>
            </tr>
            <tr>
                <td style="padding-top: 0px; padding-left: 0px;" width="100%">
                    <asp:UpdatePanel ID="pnlFilter" UpdateMode="Conditional" runat="server">
                        <ContentTemplate>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td style="padding-top:5px; padding-bottom:5px; border-bottom:solid 1px #88D2E9;">
                                        <table>
                                            <tr>
                                                <td class="Left2pxPadd boldText" align="center" Width="55px">Category</td>
                                                <td class="Left2pxPadd boldText" align="center" Width="55px">Size</td>
                                                <td class="Left2pxPadd boldText" align="center" Width="60px">Variance</td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd Right2pxPadd" align="center">
                                                    <asp:TextBox CssClass="FormCtrl2 txtRight" runat="server" ID="txtCat" Width="50px" MaxLength="5" TabIndex="1" AutoPostBack="true" OnTextChanged="txtCat_TextChanged"
                                                        OnFocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox>
                                                </td>
                                                <td class="Left2pxPadd Right2pxPadd" align="center">
                                                    <asp:TextBox CssClass="FormCtrl2 txtRight" runat="server" ID="txtSize" Width="40px" MaxLength="4" TabIndex="2" AutoPostBack="true" OnTextChanged="txtSize_TextChanged"
                                                        OnFocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox>
                                                </td>
                                                <td class="Left2pxPadd Right2pxPadd" align="center">
                                                    <asp:TextBox CssClass="FormCtrl2 txtRight" runat="server" ID="txtVar" Width="30px" MaxLength="3" TabIndex="3" AutoPostBack="true" OnTextChanged="txtVar_TextChanged"
                                                        OnFocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox>
                                                </td>
                                                <td align="right" width="10%">
                                                    <asp:ImageButton ID="btnSubmit" runat="server" ImageUrl="../Common/images/Submit.gif" TabIndex="4"
                                                        CausesValidation="false" OnClick="btnSubmit_Click" />
                                                </td>
                                                <td align="right" width="71%">
                                                    <asp:ImageButton ID="btnCancel" runat="server" ImageUrl="../Common/images/cancel.gif" TabIndex="5"
                                                        CausesValidation="false" OnClick="btnCancel_Click" />&nbsp;&nbsp;
                                                    <img src="../Common/images/help.gif" onclick="javascript:LoadHelp();" style="cursor: hand" />&nbsp;&nbsp;
                                                    <img id="btnClose" src="../Common/images/close.gif" style="cursor:hand" onclick="javascript:Close('<%=Session["SessionID"].ToString() %>');" TabIndex="6" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td height="475px" valign="top">
                    <table cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td valign="top">
                                <asp:UpdatePanel ID="pnlRptGrid" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div runat="server" id="divRptGrid" visible="true">
                                            <div id="divdatagrid" class="Sbar" align="left" runat="server" style="overflow:auto; width:1020px; position:relative; top:0px; left:0px; height:475px; border:0px solid; vertical-align:top; overflow-y:scroll;">
                                                <asp:DataGrid ID="dgUnrcvdPOCat" Width="1375px" runat="server" BorderWidth="1px" BorderColor="#DAEEEF" Style="height: auto;" ShowHeader="false" 
                                                    AutoGenerateColumns="False" OnItemDataBound="dgUnrcvdPOCat_ItemDataBound" PagerStyle-Visible="false" AllowPaging="True" PageSize="1">
                                                        <Columns>
                                                            <asp:TemplateColumn>
                                                                <ItemTemplate>
                                                                    <asp:DataGrid ID="dgUnrcvdPODtl" Width="1375px" runat="server" BorderWidth="1px" BorderColor="#DAEEEF" CssClass="grid" Style="height: auto;" 
                                                                        UseAccessibleHeader="True" AutoGenerateColumns="False" ShowHeader="true" ShowFooter="true" OnItemDataBound="dgUnrcvdPODtl_ItemDataBound">
                                                                            <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                                            <ItemStyle CssClass="GridItem" />
                                                                            <AlternatingItemStyle CssClass="zebra" />
                                                                            <FooterStyle CssClass="gridHeader" />
                                                                            <Columns>
                                                                                <asp:BoundColumn HeaderText="Category Description" DataField="CatDesc">
                                                                                    <HeaderStyle Width="315px" />
                                                                                    <ItemStyle Width="315px" HorizontalAlign="Left" Wrap="False" />
                                                                                </asp:BoundColumn>

                                                                                <asp:BoundColumn HeaderText="Item Number" DataField="ItemNo">
                                                                                    <HeaderStyle Width="100px" />
                                                                                    <ItemStyle Width="100px" HorizontalAlign="Center" Wrap="False" />
                                                                                </asp:BoundColumn>

                                                                                <asp:BoundColumn HeaderText="Size" DataField="ItemSize">
                                                                                    <HeaderStyle Width="200px" />
                                                                                    <ItemStyle Width="200px" HorizontalAlign="Left" Wrap="False" />
                                                                                </asp:BoundColumn>

                                                                                <asp:BoundColumn HeaderText="Doc No" DataField="DocNo">
                                                                                    <HeaderStyle Width="70px" />
                                                                                    <ItemStyle Width="70px" HorizontalAlign="Center" Wrap="False" />
                                                                                </asp:BoundColumn>

                                                                                <asp:BoundColumn HeaderText="Status" DataField="POStatusCd">
                                                                                    <HeaderStyle Width="40px" />
                                                                                    <ItemStyle Width="40px" HorizontalAlign="Center" Wrap="False" />
                                                                                </asp:BoundColumn>

                                                                                <asp:BoundColumn HeaderText="Vendor" DataField="VendorCd">
                                                                                    <HeaderStyle Width="45px" />
                                                                                    <ItemStyle Width="45px" HorizontalAlign="Center" Wrap="False" />
                                                                                </asp:BoundColumn>

                                                                                <asp:BoundColumn HeaderText="Loc" DataField="Loc">
                                                                                    <HeaderStyle Width="30px" />
                                                                                    <ItemStyle Width="30px" HorizontalAlign="Center" Wrap="False" />
                                                                                </asp:BoundColumn>

                                                                                <asp:BoundColumn HeaderText="--------- SE" DataField="QtySuperEquiv" DataFormatString="{0:n0}">
                                                                                    <HeaderStyle Width="40px" />
                                                                                    <ItemStyle Width="40px" HorizontalAlign="Right" Wrap="False" />
                                                                                </asp:BoundColumn>

                                                                                <asp:BoundColumn HeaderText="-- Qty -- ORD" DataField="QtyOrdered" DataFormatString="{0:n0}">
                                                                                    <HeaderStyle Width="45px" />
                                                                                    <ItemStyle Width="45px" HorizontalAlign="Right" Wrap="False" />
                                                                                </asp:BoundColumn>

                                                                                <asp:BoundColumn HeaderText="--------- RCVD" DataField="QtyReceived" DataFormatString="{0:n0}">
                                                                                    <HeaderStyle Width="45px" />
                                                                                    <ItemStyle Width="45px" HorizontalAlign="Right" Wrap="False" />
                                                                                </asp:BoundColumn>

                                                                                <asp:BoundColumn HeaderText="--------------- Requested" DataField="RequestedDt" DataFormatString="{0:MM/dd/yyyy}">
                                                                                    <HeaderStyle Width="70px" />
                                                                                    <ItemStyle Width="70px" HorizontalAlign="Center" Wrap="False" />
                                                                                </asp:BoundColumn>

                                                                                <asp:BoundColumn HeaderText="--- Dates --- Planned" DataField="PlannedRcptDt" DataFormatString="{0:MM/dd/yyyy}">
                                                                                    <HeaderStyle Width="70px" />
                                                                                    <ItemStyle Width="70px" HorizontalAlign="Center" Wrap="False" />
                                                                                </asp:BoundColumn>

                                                                                <asp:BoundColumn HeaderText="--------------- Expected" DataField="ExpectedDt" DataFormatString="{0:MM/dd/yyyy}">
                                                                                    <HeaderStyle Width="70px" />
                                                                                    <ItemStyle Width="70px" HorizontalAlign="Center" Wrap="False" />
                                                                                </asp:BoundColumn>

                                                                                <asp:BoundColumn HeaderText="Qty Due" DataField="QtyDue" DataFormatString="{0:n0}">
                                                                                    <HeaderStyle Width="45px" />
                                                                                    <ItemStyle Width="45px" HorizontalAlign="Right" Wrap="False" />
                                                                                </asp:BoundColumn>

                                                                                <asp:TemplateColumn HeaderText="Cost">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label ID="lblCost" Width="80px" runat="server" CssClass="txtRight" Text="Cost"></asp:Label>
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle Width="80px" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                                                </asp:TemplateColumn>

                                                                                <asp:BoundColumn HeaderText="Ext Cost" DataField="ExtendedCost">
                                                                                    <HeaderStyle Width="80px" />
                                                                                    <ItemStyle Width="80px" HorizontalAlign="Right" Wrap="False" />
                                                                                </asp:BoundColumn>
                                                                            </Columns>
                                                                        <PagerStyle Visible="False" />
                                                                    </asp:DataGrid>
                                                                </ItemTemplate>
                                                                <ItemStyle Width="1375px" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    <PagerStyle Visible="False" />
                                                </asp:DataGrid>

<%--                                                <table id="tblGrdTotals" class="BluBordAll" border="0" cellspacing="0" cellpadding="0" runat="server" visible=false
                                                  style="position: relative; top: 0px; left: 0px; height: 30px; border: 1px solid;">
                                                    <tr style="border:1px solid #e1e1e1; background-color:#B3E2F0;">
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF; width:315px;" align="left">Grand Totals for all Categories ... </td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF; width:100px;" align="left">&nbsp</td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF; width:200px;" align="left"><asp:Label ID="lblTotLines" runat="server" Text="n/a"></asp:Label></td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF; width:70px;" align="left">&nbsp</td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF; width:40px;" align="left">&nbsp</td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF; width:45px;" align="left">&nbsp</td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF; width:30px;" align="left">&nbsp</td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF; width:40px;" align="left">&nbsp</td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF; width:40px;" align="right"><asp:Label ID="lblTotQtyOrd" runat="server" Text="n/a"></asp:Label></td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF; width:40px;" align="right"><asp:Label ID="lblTotQtyRcvd" runat="server" Text="n/a"></asp:Label></td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF; width:70px;" align="left">&nbsp</td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF; width:70px;" align="left">&nbsp</td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF; width:70px;" align="left">&nbsp</td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF; width:40px;" align="right"><asp:Label ID="lblTotQtyDue" runat="server" Text="n/a"></asp:Label></td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF; width:80px;" align="left">&nbsp</td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF; width:75px;" align="right"><asp:Label ID="lblTotExtCost" runat="server" Text="n/a"></asp:Label></td>
                                                    </tr>
                                                </table>--%>

                                                <table id="tblGrdTotals" class="BluBordAll" border="0" cellspacing="0" cellpadding="0" runat="server" visible=false
                                                  style="position: relative; top: 0px; left: 0px; height: 30px; border: 1px solid;">
                                                    <tr style="border:1px solid #e1e1e1; background-color:#B3E2F0;">
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="292px"><tr><td>Grand Totals for all Categories ...</td></tr></table></td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="98px"><tr><td>&nbsp</td></tr></table></td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="188px"><tr><td><asp:Label ID="lblTotLines" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="75px"><tr><td>&nbsp</td></tr></table></td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="43px"><tr><td>&nbsp</td></tr></table></td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="50px"><tr><td>&nbsp</td></tr></table></td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="34px"><tr><td>&nbsp</td></tr></table></td>
                                                        <%--<td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="43px"><tr><td>&nbsp</td></tr></table></td>--%>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="93px"><tr><td><asp:Label ID="lblTotQtyOrd" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="48px"><tr><td><asp:Label ID="lblTotQtyRcvd" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="74px"><tr><td>&nbsp</td></tr></table></td>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="74px"><tr><td>&nbsp</td></tr></table></td>
                                                        <%--<td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="74px"><tr><td>&nbsp</td></tr></table></td>--%>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="124px"><tr><td><asp:Label ID="lblTotQtyDue" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                                        <%--<td class="GridHead" style="border-right:1px solid #DAEEEF;" align="left"><table width="86px"><tr><td>&nbsp</td></tr></table></td>--%>
                                                        <td class="GridHead" style="border-right:1px solid #DAEEEF;" align="right"><table width="169px"><tr><td><asp:Label ID="lblTotExtCost" runat="server" Text="n/a"></asp:Label></td></tr></table></td>
                                                    </tr>
                                                </table>
                                                <asp:HiddenField ID="hidFilter" runat="server" />
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="lightBlueBg buttonBar" style="border-top:solid 1px #CDECF6" height="20px">
                    <table>
                        <tr>
                            <td>
                                <asp:UpdateProgress ID="pnlProgress" runat="server" DisplayAfter="1" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                            <td>
                                <asp:UpdatePanel ID="pnlStatus" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Width="300px" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td width="64%" align="right">
                                <asp:ImageButton ID="btnExport" Style="cursor: hand;" Height="18px" Width="18px" CausesValidation="false" ImageUrl="~/Common/Images/ExcelIcon.jpg"
                                    ToolTip="Export To Excel" runat="server" OnClick="btnExport_Click" />
                            </td>
                            <td style="padding-left: 3px">
                                <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlExport">
                                    <ContentTemplate>
                                        <uc4:PrintDialogue ID="PrintDialogue1" PageTitle="UnreceivedPORpt" EnableFax="false" EnableEmail="false" runat="server"></uc4:PrintDialogue>
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
                    <uc2:Footer ID="BottomFooterID" FooterTitle="Unreceived Purchase Orders By Category Report" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
