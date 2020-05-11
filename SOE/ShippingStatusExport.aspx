<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShippingStatusExport.aspx.cs"
    Inherits="shippingStatusExport" %>

<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/PrintHeader.ascx" TagName="PrintHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SOE Shipping Status</title>
    <%= PFC.SOE.DataAccessLayer.Global.PrintStyleSheet %>
</head>
<body>
    <form id="form1" runat="server">
        <table border="0" cellpadding="0" cellspacing="2" class="PageBg">
            <tr>
                <td bgcolor="white" style="padding-right: 0px; padding-left: 0px; padding-bottom: 0px;
                    height: 70px; padding-top: 0px">
                    <uc1:PrintHeader ID="printHeader" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="padding-right: 5px; padding-left: 5px; padding-bottom: 5px; padding-top: 5px">
                </td>
            </tr>
            <tr>
                <td>
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td valign="top" class="SubHeaderPanels" style="padding-left: 4px; padding-top: 5px"
                                width="30%">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblSON0Caption" runat="server" Text="Sales Order Number :" Font-Bold="True"
                                                Width="130px"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="txtSONumber" runat="server" Text="" Font-Bold="True" Width="100px"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" class="SubHeaderPanels" style="padding-left: 4px; padding-top: 5px"
                                width="35%">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td width="50px">
                                            <asp:Label ID="lnkSoldTo" runat="server" CssClass="TabHead" Text="Sold To:" Font-Bold="True"
                                                Width="45px"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblSold_Name" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblSoldCustNum" runat="server" CssClass="lblbox"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblSold_Contact" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblSold_City" runat="server" CssClass="lblColor"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblSoldCom" runat="server" CssClass="lblColor" Text=",&nbsp;"></asp:Label></td>
                                                    <td>
                                                        <asp:Label ID="lblSold_State" runat="server" CssClass="lblColor"></asp:Label></td>
                                                    <td>
                                                        &nbsp;<asp:Label ID="lblSold_Pincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                                    <td>
                                                        &nbsp;<asp:Label ID="lblSoldCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblSold_Phone" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" class="SubHeaderPanels" style="padding-left: 4px; padding-top: 5px"
                                width="35%">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td width="55px">
                                            <asp:Label ID="lnkShipTo" runat="server" CssClass="TabHead" Text="Ship To:" Font-Bold="True"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblShip_Name" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblShipCustNum" runat="server" CssClass="lblbox"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblShip_Contact" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblShip_City" runat="server" CssClass="lblColor"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblShipCom" runat="server" CssClass="lblColor" Text=",&nbsp;"></asp:Label></td>
                                                    <td>
                                                        <asp:Label ID="lblShip_State" runat="server" CssClass="lblColor"></asp:Label></td>
                                                    <td>
                                                        &nbsp;<asp:Label ID="lblShip_Pincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                                    <td>
                                                        &nbsp;<asp:Label ID="lblShipCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblShip_Phone" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="right" style="padding-right: 5px;">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top;" class="commandLine splitborder_t_v splitborder_b_v">
                    <table cellpadding="2" cellspacing="0">
                        <tr>
                            <td height="20">
                                <asp:Label ID="Label1" runat="server" Text="Order No:" Font-Bold="True" Width="80px"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblOrderNo" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                            <td style="width: 15px">
                            </td>
                            <td>
                                <asp:Label ID="Label2" runat="server" Text="Invoice No:" Font-Bold="True" Width="100px"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblInvoiceNo" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label>
                            </td>
                            <td style="width: 15px">
                            </td>
                            <td>
                                <asp:Label ID="Label11" runat="server" Text=" Minimum Charge:" Font-Bold="True" Width="100px"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblMinCharge" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                            <td style="width: 15px">
                            </td>
                            <td>
                                <asp:Label ID="Label3" runat="server" Text="PrintDt:" Font-Bold="True" Width="60px"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblPrintDt" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label4" runat="server" Text=" Order Type:" Font-Bold="True" Width="80px"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblOrderType" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label5" runat="server" Text="Master Order No:" Font-Bold="True" Width="100px"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblMasterordNo" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label6" runat="server" Text="Hold Reason:" Font-Bold="True" Width="100px"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblReason" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label7" runat="server" Text="Reprints:" Font-Bold="True" Width="60px"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblReprints" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label8" runat="server" Text="Order Date:" Font-Bold="True" Width="80px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblOrderDt" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label9" runat="server" Text="Carrier:" Font-Bold="True" Width="100px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblCarrier" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label10" runat="server" Text="Verify Method:" Font-Bold="True" Width="100px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblVerify" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label12" runat="server" Font-Bold="True" Text="Ref SO No:" Width="60px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblRefSONo" runat="server" Width="90px"></asp:Label></td>
                        </tr>
                        <tr>
                            <td style="width: 74px" class="splitborder_b_v" valign="top">
                                <asp:Label ID="Label13" runat="server" Text="Ship Loc:" Font-Bold="True" Width="80px"></asp:Label></td>
                            <td class="splitborder_b_v" valign="top">
                                <asp:Label ID="lblShipLoc" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                            <td class="splitborder_b_v">
                                &nbsp;</td>
                            <td valign="top">
                                <asp:Label ID="Label14" runat="server" Text="BOL/UPS:" Font-Bold="True" Width="100px"></asp:Label></td>
                            <td valign="top">
                                <asp:Label ID="lblCarrierPro" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td valign="top">
                                <asp:Label ID="Label24" runat="server" Font-Bold="True" Text="Orig Order No:" Width="80px"></asp:Label></td>
                            <td valign="top">
                                <asp:Label ID="lblOrgOrderNo" runat="server" Width="90px"></asp:Label></td>
                        </tr>
                        <tr>
                            <td class="splitborder_b_v" height="30" style="width: 74px" valign="top">
                            </td>
                            <td class="splitborder_b_v" valign="top">
                            </td>
                            <td class="splitborder_b_v">
                            </td>
                            <td valign="top">
                                <asp:Label ID="Label26" runat="server" Font-Bold="True" Text="Pro Number:" Width="100px"></asp:Label></td>
                            <td valign="top">
                                <asp:Label ID="lblProNo" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td valign="top">
                            </td>
                            <td valign="top">
                            </td>
                        </tr>
                        <tr>
                            <td class="splitborder_t_v " style="width: 74px">
                                <asp:Label ID="Label15" runat="server" Text="Ack Print Dt:" Font-Bold="True" Width="80px"></asp:Label></td>
                            <td class="splitborder_t_v ">
                                <asp:Label ID="lblAckDt" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                            <td class="splitborder_t_v ">
                                &nbsp;</td>
                            <td class="splitborder_t_v ">
                                <asp:Label ID="Label16" runat="server" Text="Begin Pick Dt:" Font-Bold="True" Width="100px"></asp:Label></td>
                            <td class="splitborder_t_v ">
                                <asp:Label ID="lblBeginDt" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                            <td class="splitborder_t_v  ">
                            </td>
                            <td class="splitborder_t_v  ">
                                <asp:Label ID="Label17" runat="server" Text="Confirm Ship Dt:" Font-Bold="True" Width="100px"></asp:Label></td>
                            <td class="splitborder_t_v ">
                                <asp:Label ID="lblShipDt" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                            <td class="splitborder_t_v ">
                            </td>
                            <td class="splitborder_t_v ">
                                <asp:Label ID="Label18" runat="server" Text="Invoice Dt:" Font-Bold="True" Width="60px"></asp:Label></td>
                            <td class="splitborder_t_v ">
                                <asp:Label ID="lblInvoiceDt" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                        </tr>
                        <tr>
                            <td style="width: 74px">
                                <asp:Label ID="Label19" runat="server" Text=" Suggested Dt:" Font-Bold="True" Width="80px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblSuggestDt" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label20" runat="server" Text=" End Pick Dt:" Font-Bold="True" Width="100px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblEndPickDt" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label21" runat="server" Text=" Shipped Dt:" Font-Bold="True" Width="100px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblShippedDt" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label22" runat="server" Text="A/R Dt:" Font-Bold="True" Width="60px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblARDt" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                        </tr>
                        <tr>
                            <td colspan="4">
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td style="width: 100px">
                                            <asp:Label ID="Label23" runat="server" Text="Shipping Instructions:" Font-Bold="True"
                                                Width="125px"></asp:Label></td>
                                        <td style="width: 100px">
                                            <asp:Label ID="lblShipInstructions" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    </tr>
                                </table>
                                &nbsp;</td>
                            <td>
                                &nbsp;</td>
                            <td>
                            </td>
                            <td>
                                &nbsp;</td>
                            <td colspan="5">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <div id="divControlDisp" runat="server" visible="false">
                        <table cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <asp:GridView UseAccessibleHeader="true" ID="gvControl" PagerSettings-Visible="false"
                                        Width="350" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="false"
                                        AutoGenerateColumns="false" OnSorting="gvControl_Sorting" ShowFooter="True">
                                        <HeaderStyle HorizontalAlign="center" Height="20px" CssClass="GridHead" Font-Bold="true" />
                                        <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                        <RowStyle CssClass="item" Wrap="False" BackColor="#FFFFFF" Height="20px" BorderWidth="1px" />
                                        <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="20px" BorderWidth="1px" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="Carton">
                                                <ItemTemplate>
                                                    <%--<asp:Label ID="lblControlId" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"pASNControlID") %>'></asp:Label>--%>
                                                    <asp:HiddenField ID="hidControlId" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"pASNControlID") %>' />
                                                    <asp:LinkButton ID="lnlASNNo" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                        Text='<%#DataBinder.Eval(Container.DataItem,"CartonNo") %>' Style="padding-left: 5px"
                                                        runat="server" CommandName="BindDetails" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"pASNControlID") %>'></asp:LinkButton>
                                                </ItemTemplate>
                                                <FooterStyle HorizontalAlign="Right" />
                                                <ItemStyle Width="90px" />
                                            </asp:TemplateField>
                                            <asp:BoundField HeaderText="EDI" DataField="EDIStatus" SortExpression="EDIStatus">
                                                <ItemStyle HorizontalAlign="Left" Width="70px" CssClass="Left5pxPadd" />
                                            </asp:BoundField>
                                            <asp:BoundField HeaderText="Package Type" DataField="PackageType" SortExpression="PackageType">
                                                <ItemStyle HorizontalAlign="Left" Width="120px" CssClass="Left5pxPadd" />
                                            </asp:BoundField>
                                        </Columns>
                                        <PagerSettings Visible="False" />
                                    </asp:GridView>
                                    <input id="hidSortControl" type="hidden" name="Hidden1" runat="server">
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div id="divDetailDisp" runat="server" visible="false">
                        <table cellpadding="0" cellspacing="0">
                            <tr>
                                <td colspan="6">
                                    <table border="0" cellpadding="0" cellspacing="5">
                                        <tr>
                                            <td class="splitborder_t_v " style="width: 74px">
                                                <asp:Label ID="Label123" runat="server" Text="Carton No:" Font-Bold="True" Width="80px"></asp:Label></td>
                                            <td class="splitborder_t_v " style="width: 74px">
                                                <asp:Label ID="lblASN" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                            <td class="splitborder_t_v " style="width: 74px">
                                                <asp:Label ID="Label25" runat="server" Text="EDI:" Font-Bold="True" Width="100px"></asp:Label></td>
                                            <td class="splitborder_t_v " style="width: 74px">
                                                <asp:Label ID="lblEDI" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                            <td class="splitborder_t_v " style="width: 74px">
                                                <asp:Label ID="Label27" runat="server" Text="Package Type:" Font-Bold="True" Width="80px"></asp:Label></td>
                                            <td class="splitborder_t_v " style="width: 74px">
                                                <asp:Label ID="lblPackage" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6">
                                    <asp:GridView ShowFooter="false" UseAccessibleHeader="true" ID="gvDetail" PagerSettings-Visible="false"
                                        Width="700" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="false"
                                        AutoGenerateColumns="false" OnRowDataBound="gvDetail_RowDataBound">
                                        <HeaderStyle HorizontalAlign="center" Height="20px" CssClass="GridHead" Font-Bold="true" />
                                        <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                        <RowStyle CssClass="item" Wrap="False" BackColor="#FFFFFF" Height="20px" BorderWidth="1px" />
                                        <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="20px" BorderWidth="1px" />
                                        <Columns>
                                            <asp:BoundField HeaderText="Quantity" DataField="TotalQty" SortExpression="TotalQty"
                                                ItemStyle-CssClass="Left5pxPadd">
                                                <ItemStyle HorizontalAlign="right" Width="50px" />
                                            </asp:BoundField>
                                            <asp:BoundField HeaderText="Item No" DataField="ItemNo" SortExpression="ItemNO" ItemStyle-CssClass="Left5pxPadd">
                                                <ItemStyle HorizontalAlign="Left" Width="100px" />
                                            </asp:BoundField>
                                            <asp:BoundField HeaderText="Description" DataField="ItemDesc" SortExpression="ItemDesc"
                                                ItemStyle-CssClass="Left5pxPadd">
                                                <ItemStyle HorizontalAlign="Left" Width="300px" />
                                            </asp:BoundField>
                                            <asp:BoundField HeaderText="Weight" DataField="TotalWeight" SortExpression="TotalWeight"
                                                ItemStyle-CssClass="Left5pxPadd">
                                                <ItemStyle HorizontalAlign="right" Width="50px" />
                                            </asp:BoundField>
                                            <asp:BoundField HeaderText="UM" DataField="SellUM" SortExpression="SellUM" ItemStyle-CssClass="Left5pxPadd">
                                                <ItemStyle HorizontalAlign="Left" Width="60px" />
                                            </asp:BoundField>
                                            <asp:BoundField HeaderText="Tracking No" DataField="TrackingNo" SortExpression="TrackingNo">
                                                <ItemStyle HorizontalAlign="Left" Width="110px" CssClass="Left5pxPadd" />
                                            </asp:BoundField>
                                        </Columns>
                                    </asp:GridView>
                                    <input id="hidSortDetail" type="hidden" name="Hidden1" runat="server">
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="border-collapse: collapse;">
                    <div class="blueBorder">
                    </div>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
