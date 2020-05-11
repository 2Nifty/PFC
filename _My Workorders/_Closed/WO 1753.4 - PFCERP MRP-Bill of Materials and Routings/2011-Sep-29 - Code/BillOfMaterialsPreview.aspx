<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BillOfMaterialsPreview.aspx.cs" Inherits="BillOfMaterialsPreview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Bill Of Materials Preview</title>

    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .zebra td {padding-left: 5px;}
        .gridItem td {padding-left: 5px;}
    </style>

</head>

<script type="text/javascript">
//alert('Pre-ScriptX');
</script>

    <% if ((Request.QueryString["ScriptX"] != null) && (Request.QueryString["ScriptX"].ToUpper() == "YES"))
       { %>

<script type="text/javascript">
//alert('ScriptX');
</script>

            <!-- #Include virtual="../common/include/ScriptX.inc" -->
            <script src="../Common/JavaScript/ScriptX.js" type="text/javascript"></script>

            <% if (Request.QueryString["Version"].ToUpper() != "EMP")
               { %>
                    <script type="text/javascript">
//alert('Portrait');
                        //Portrait with 1/4 inch margins
                        SetPrintSettings(true, 0.25, 0.25, 0.25, 0.25);
                    </script>
            <% }
               else
               { %>
                    <script type="text/javascript">
//alert('Landscape');
                        //Landscape with 1/4 inch margins
                        SetPrintSettings(false, 0.25, 0.25, 0.25, 0.25);
                    </script>
            <% } %>
    <% } %>


<body>
    <form id="frmBOM" runat="server">
        <table cellpadding="0" border="0" cellspacing="0" width="1020px" style="border-collapse: collapse;">


            <tr>
                <td class="lightBlueBg" style="border-top:solid 1px #88D2E9; border-bottom:solid 1px #88D2E9; width:1020px;">
                    <table>
                        <tr>
                            <td>
                                <span class="BanText" style="padding-left: 5px;">
                                    Bill Of Materials Report
                                </span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr>
                <%--Parameters--%>
                <td class="BluBg" style="width:825px; height:20px;" align="center">
                    <table cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td align="left" style="padding-left:15px; font-weight:bold; width:20%">
                                <asp:Label ID="lblSearchItem" runat="server" Text="xxxxx-xxxx-xxx"></asp:Label>
                            </td>
                            <td align="left" style="font-weight:bold;">
                                <asp:Label ID="lblBOMBillType" runat="server" Text="BOM Bill Type"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr style="vertical-align:top;">
                <td>
                    <%--BEGIN BODY--%>

                    <%--ITEM INFO--%>
                    <table width="100%" border="0" cellspacing="2" cellpadding="1" class="lightBlueBg">
                        <colgroup>
                            <col width="75px" />
                            <col width="215px" />
                            <col width="70px" />
                            <col width="60px" />
                            <col width="72px" />
                            <col width="60px" />
                            <col width="104px" />
                            <col width="60px" />
                            <col width="70px" />
                            <col width="90px" />
                            <col width="88px" />
                            <col width="55px" />
                        </colgroup>
                        <tr style="padding-top:15px;">
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Description:
                            </td>
                            <td>
                                <asp:Label ID="lblItemDesc" runat="server" Width="210px" Text="Item Descr 1/4-20 Finished Hex Nut" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Weight/100:
                            </td>
                            <td>
                                <asp:Label ID="lbl100Wght" runat="server" Width="55px" Text="0.99" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Sell Stock:
                            </td>
                            <td>
                                <asp:Label ID="lblSellStk" runat="server" Width="55px" Text="99999/xx" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Std Cost:
                            </td>
                            <td>
                                <asp:Label ID="lblStdCost" runat="server" Width="55px" Text="0.99/xx" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                UPC Code:
                            </td>
                            <td>
                                <asp:Label ID="lblUPCCd" runat="server" Width="85px" Text="082893425719" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Web Enabled:
                            </td>
                            <td>
                                <asp:Label ID="lblWebEnabled" runat="server" Width="50px" Text="Yes" />
                            </td>
                        </tr>
                        <tr style="padding-top:5px;">
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Category:
                            </td>
                            <td>
                                <asp:Label ID="lblCatDesc" runat="server" Width="210px" Text="xxxxx Finished Hex Nut NC" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Net LB:
                            </td>
                            <td>
                                <asp:Label ID="lblNetWght" runat="server" Width="55px" Text="9999.999" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Super Eqv:
                            </td>
                            <td>
                                <asp:Label ID="lblSupEqv" runat="server" Width="55px" Text="99999/xx" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                List Price:
                            </td>
                            <td>
                                <asp:Label ID="lblListPrice" runat="server" Width="55px" Text="999.99" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Tariff:
                            </td>
                            <td>
                                <asp:Label ID="lblTarrif" runat="server" Width="85px" Text="7318.16.0085" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Pkg Grp:
                            </td>
                            <td>
                                <asp:Label ID="lblPkgGrp" runat="server" Width="50px" Text="99" />
                            </td>
                        </tr>
                        <tr style="padding-top:5px;">
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Plating Type:
                            </td>
                            <td>
                                <asp:Label ID="lblPltTyp" runat="server" Width="55px" Text="PLAT" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Gross LB:
                            </td>
                            <td>
                                <asp:Label ID="lblGrossWght" runat="server" Width="55px" Text="9999.999" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Price UM:
                            </td>
                            <td>
                                <asp:Label ID="lblPriceUM" runat="server" Width="55px" Text="xx" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Corp Fixed Vel:
                            </td>
                            <td>
                                <asp:Label ID="lblCFV" runat="server" Width="55px" Text="xx" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                PPI Code:
                            </td>
                            <td>
                                <asp:Label ID="lblPPI" runat="server" Width="85px" Text="?? xx ??" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Low Profile:
                            </td>
                            <td>
                                <asp:Label ID="lblLowProfile" runat="server" Width="50px" Text="?? xx ??" />
                            </td>
                        </tr>
                        <tr style="padding-top:5px; padding-bottom:15px;">
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Parent Item:
                            </td>
                            <td>
                                <a id="ParentLink" onclick="OpenParent();">
                                    <asp:Label ID="lblParentItem" runat="server" Width="100px" Text="xxxxx-xxxx-xxx" />
                                </a>
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Stock Ind:
                            </td>
                            <td>
                                <asp:Label ID="lblStockInd" runat="server" Width="55px" Text="?? xx ??" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Cost UM:
                            </td>
                            <td>
                                <asp:Label ID="lblCostUM" runat="server" Width="55px" Text="xx" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Category Vel:
                            </td>
                            <td>
                                <asp:Label ID="lblCVC" runat="server" Width="55px" Text="xx" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Created:
                            </td>
                            <td>
                                <asp:Label ID="lblCreateDt" runat="server" Width="85px" Text="mm/dd/yyyy" />
                            </td>
                            <td class="Left2pxPadd DarkBluTxt boldText">
                                Pkg Vel:
                            </td>
                            <td>
                                <asp:Label ID="lblPVC" runat="server" Width="50px" Text="xx" />
                            </td>
                        </tr>
                    </table>

                    <%--BOM GRID--%>
                    <div id="divdatagrid" class="Sbar" runat="server" style="overflow: auto; width: 1020px; 
                        position: relative; top: 0px; left: 0px; border: 0px; vertical-align: top;">
                        <asp:DataGrid ID="dgBOM" Width="100%" runat="server" GridLines="both" BorderWidth="1px" 
                            ShowFooter="false" CssClass="grid" Style="height: auto"
                            UseAccessibleHeader="true" AutoGenerateColumns="false" BorderColor="#DAEEEF" PagerStyle-Visible="false">
                            <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" Wrap="false" />
                            <ItemStyle CssClass="gridItem" Wrap="false" />
                            <AlternatingItemStyle CssClass="zebra" Wrap="false" />
                            <FooterStyle CssClass="lightBlueBg" HorizontalAlign="right" />
                            <Columns>
                                <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Item Number" DataField="BOMItem"
                                    ItemStyle-HorizontalAlign="Center" ItemStyle-Width="100"></asp:BoundColumn>

                                <asp:BoundColumn HeaderStyle-Width="285" HeaderText="Item Description" DataField="BOMItemDesc"
                                    ItemStyle-HorizontalAlign="Left" ItemStyle-Width="290"></asp:BoundColumn>

                                <asp:BoundColumn HeaderStyle-Width="60" HeaderText="Qty Per" DataField="BOMQtyPer"
                                    ItemStyle-HorizontalAlign="Right" ItemStyle-Width="60" DataFormatString="{0:0.000}"></asp:BoundColumn>

                                <asp:BoundColumn HeaderStyle-Width="30" HeaderText="UM" DataField="BOMUM"
                                    ItemStyle-HorizontalAlign="Right" ItemStyle-Width="30"></asp:BoundColumn>
                                    
                                <asp:BoundColumn HeaderStyle-Width="375" HeaderText="Remarks" DataField="BOMRemarks"
                                    ItemStyle-HorizontalAlign="Left" ItemStyle-Width="390"></asp:BoundColumn>

                                <asp:BoundColumn HeaderStyle-Width="70" HeaderText="Seq No" DataField="BOMSeqNo"
                                    ItemStyle-HorizontalAlign="Right" ItemStyle-Width="70"></asp:BoundColumn>

                                <asp:BoundColumn HeaderStyle-Width="80" HeaderText="Bill Type" DataField="BOMBillType"
                                    ItemStyle-HorizontalAlign="Left" ItemStyle-Width="80"></asp:BoundColumn>

                            </Columns>
                        </asp:DataGrid>
                    </div>

                    <%--END BODY--%>
                </td>
            </tr>

        </table>
    </form>
</body>
</html>
