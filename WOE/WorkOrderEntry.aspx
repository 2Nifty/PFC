<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="WorkOrderEntry.aspx.cs" Inherits="WorkOrderEntry" %>

<%@ Register Src="Common/UserControls/OrderEntrydatepicker.ascx" TagName="OrderEntrydatepicker" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Datepicker.ascx" TagName="Datepicker" TagPrefix="uc6" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script src="Common/JavaScript/Common.js"></script>
    <script src="Common/JavaScript/ContextMenu.js"></script>
    <script src="Common/JavaScript/WorkOrderEntry.js"></script>
    <script src="Common/JavaScript/WOEValidation.js"></script>

    <title>Work Orders</title>
</head>
<body bgcolor="#ECF9FB" scroll="no" onclick="Javascript:ClearControls();" onunload="javascript:DoWorkOrderValidation();">
    <form id="form1" runat="server" defaultbutton="btnEmpty">
        <div>
            <asp:ScriptManager ID="scmWOE" AsyncPostBackTimeout="360000" runat="server" EnablePartialRendering="true">
            <Scripts>
                <asp:ScriptReference Path="Common/JavaScript/WorkOrderEntry.js" />
            </Scripts>
            </asp:ScriptManager>
            <table border="0" cellpadding="0" cellspacing="2" style="width: 100%; height: 100%">
                <tr>
                    <td valign="top">
                        <asp:UpdatePanel ID="pnlHeader" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td valign="top" class="HeaderPanels" style="padding-left: 4px; padding-top: 4px;"
                                            width="30%">
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="Label2" runat="server" Text="Location:" Font-Bold="True" Width="70px"></asp:Label></td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlLocation" runat="server" CssClass="lbl_whitebox" Height="25px"
                                                            Width="130px" AutoPostBack="True" OnSelectedIndexChanged="ddlLocation_SelectedIndexChanged">
                                                        </asp:DropDownList><asp:RequiredFieldValidator ID="rqvCustNo" runat="server" ControlToValidate="ddlLocation"
                                                            CssClass="cnt" Display="Dynamic" ErrorMessage="* Required"></asp:RequiredFieldValidator></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblOrderTypeDesc" runat="server" Text="Order Type:" Font-Bold="True"
                                                            Width="70px"></asp:Label></td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlOrderType" runat="server" CssClass="lbl_whitebox" Height="25px"
                                                            onchange="UpdatePOHeader('WOType',this);" Width="130px">
                                                        </asp:DropDownList></td>
                                                </tr>
                                                <tr>
                                                    <td height="20" valign="middle">
                                                        <asp:Label ID="lblExpedite" runat="server" CssClass="TabHead" Font-Bold="True" Text="Expedite:"></asp:Label></td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlExpeditCd" runat="server" CssClass="lbl_whitebox" Height="25px"
                                                            onchange="UpdatePOHeader('Expedite',this);" Width="130px">
                                                        </asp:DropDownList></td>
                                                </tr>
                                                <tr>
                                                    <td height="20" valign="middle">
                                                        <asp:Label ID="Label22" runat="server" CssClass="TabHead" Font-Bold="True" Text="Entry Date:"></asp:Label></td>
                                                    <td>
                                                        <asp:Label ID="lblEntryDt" runat="server" CssClass="txtBox small50px"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td height="20" valign="middle">
                                                        <asp:Label ID="Label17" runat="server" CssClass="TabHead" Font-Bold="True" Text="Entry ID:"></asp:Label></td>
                                                    <td>
                                                        <asp:Label ID="lblEntryID" runat="server" CssClass="txtBox small50px"></asp:Label></td>
                                                </tr>
                                            </table>
                                            <asp:Button ID="btnEmpty" runat=server Visible=false />
                                            <asp:HiddenField ID="hidReadOnly" runat="server" Value="false" />
                                        </td>
                                        <td valign="top" class="HeaderPanels" width="35%" style="padding-left: 4px; padding-top: 4px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <asp:LinkButton ID="lnkMfgGrp" runat="server" Font-Underline="true" CssClass="TabHead"
                                                            OnClientClick="Javascript:if(getElementById('hidReadOnly').value != 'true'){OpenMfgAddressForm();}return false;"
                                                            Text="Mfg Group:" Font-Bold="True" Width="62px"></asp:LinkButton></td>
                                                    <td>
                                                        <asp:Label ID="lblMfgName" runat="server" CssClass="lblColor"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblMfgCode" runat="server" CssClass="lblColor"></asp:Label></td>
                                                    <td>
                                                        <asp:Label ID="lblMfgAddress" runat="server" CssClass="lblColor"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblMfgAddress2" runat="server" CssClass="lblColor"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td>
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="lblMfgCity" runat="server" CssClass="lblColor"></asp:Label>
                                                                </td>
                                                                <td>
                                                                    <asp:Label ID="lblMfgComma" runat="server" CssClass="lblColor" Visible="false">, </asp:Label></td>
                                                                <td>
                                                                    &nbsp;<asp:Label ID="lblMfgState" runat="server" CssClass="lblColor"></asp:Label></td>
                                                                <td>
                                                                    &nbsp;<asp:Label ID="lblMfgPincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                                                <td>
                                                                    &nbsp;<asp:Label ID="lblMfgCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblMfgPhone" runat="server" CssClass="lblColor"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td style="padding-top: 5px">
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="lblMfgContactDesc" runat="server" CssClass="lblColor" Font-Bold="True"
                                                                        Visible="false" Width="84px">Order Contact:</asp:Label></td>
                                                                <td>
                                                                    <asp:Label ID="lblMfgContact" runat="server" CssClass="lblColor" Width="81px"></asp:Label></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td valign="top" class="HeaderPanels" style="padding-left: 4px; padding-top: 4px;"
                                            width="35%">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td width="55px">
                                                        <asp:LinkButton ID="lnkPackBy" runat="server" CssClass="TabHead" Font-Underline="true"
                                                            OnClientClick="Javascript:if(getElementById('hidReadOnly').value != 'true'){OpenPackByForm();}return false;"
                                                            Text="Pack By:" Font-Bold="True" Width="45px"></asp:LinkButton></td>
                                                    <td>
                                                        <asp:Label ID="lblPckName" runat="server" CssClass="lblColor"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblPckAddress" runat="server" CssClass="lblColor"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblPckAddress2" runat="server" CssClass="lblColor"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td>
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="lblPckCity" runat="server" CssClass="lblColor"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label ID="lblPckComma" runat="server" CssClass="lblColor" Visible="false">, </asp:Label></td>
                                                                <td>
                                                                    &nbsp;<asp:Label ID="lblPckState" runat="server" CssClass="lblColor"></asp:Label></td>
                                                                <td>
                                                                    &nbsp;<asp:Label ID="lblPckPincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                                                <td>
                                                                    &nbsp;<asp:Label ID="lblPckCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblPckPhone" runat="server" CssClass="lblColor"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" style="padding-top: 5px">
                                                        <table cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td>
                                                                    <asp:LinkButton ID="lblPckContactDesc" runat="server" CssClass="TabHead" Font-Bold="True"
                                                                        Visible="false" OnClientClick="Javascript:if(getElementById('hidReadOnly').value != 'true'){ShowContactForm(document.getElementById('lblPckContact'));}return false;"
                                                                        Text="Contact:" Width="50px"></asp:LinkButton>
                                                                </td>
                                                                <td style="padding-left: 5px; word-break: keep-all; word-wrap: normal;">
                                                                    <asp:Label ID="lblPckContact" Style="word-wrap: normal; display: block;" Width="100px"
                                                                        runat="server"></asp:Label>
                                                                    <asp:TextBox ID="txtPckContact" runat="server" Width="80px" MaxLength="25" onkeypress="javascript:if(event.keyCode ==13)HideContactForm();"
                                                                        onblur="javascript:HideContactForm();" Style="display: none;" CssClass="lbl_whitebox"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" style="padding-left: 0px; padding-top: 3px;" valign="top">
                                            <asp:HiddenField ID="hidSOEURL" runat="server" />
                                            <asp:HiddenField ID="hidStockStatusItem" runat="server" />
                                            <asp:HiddenField ID="hidStockStatusUser" runat="server" />
                                            <table border="0" cellpadding="0" cellspacing="0" style="height: 30px;" width="100%">
                                                <tr>
                                                    <td class="lightBg" style="padding-left: 4px">
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="Order Number:" Width="85px"></asp:Label></td>
                                                                <td style="width: 110px">
                                                                    <asp:TextBox ID="txtWONo" runat="server" CssClass="lbl_whitebox" MaxLength="25" Width="90px"
                                                                        onkeydown="javascript:javascript:if(event.keyCode==9 || event.keyCode==13){CallServerButtonClick('btnLoadWO'); return false;} "></asp:TextBox>
                                                                    <asp:Button ID="btnLoadWO" CausesValidation="false" Text="btnloadWO" runat="server"
                                                                        Style="display: none;" OnClick="btnLoadWO_Click" /></td>
                                                                <td>
                                                                    <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Pick Type:" Width="60px"></asp:Label></td>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="lblPickType" runat="server" CssClass="txtBox small50px"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label ID="Label7" runat="server" Font-Bold="True" Text="Reference:" Width="63px"></asp:Label></td>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="lblRefNo" runat="server" CssClass="txtBox small50px"></asp:Label>
                                                                    <asp:HyperLink ID="lnkRefNo" runat="server"></asp:HyperLink>
                                                                </td>
                                                                <td>
                                                                    <asp:Label id="lblClosedDateTitle" runat="server" Font-Bold="True" Text="Closed Date:" visible="false"></asp:Label>
                                                                    <asp:Label id="lblClosedDateData" runat="server" Text="" visible="false"></asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                    <td rowspan="1" valign="top" class="lightBg" id="tdUsage" style="padding-left: 2px;
                        width: 160px;">
                        <asp:UpdatePanel ID="pnlWOSummary" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table border="0" cellpadding="0" cellspacing="2" style="height: 100%; line-height: 19px">
                                    <tr>
                                        <td style="padding-left: 2px;">
                                            <asp:Label ID="lblSalesHead" runat="server" CssClass="TabHead" Text="Total Cost $:"
                                                Font-Bold="True" Width="70px"></asp:Label></td>
                                        <td colspan="2">
                                            <asp:Label ID="lblTotCost" runat="server" CssClass="lblbox"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 2px;">
                                            <asp:Label ID="Label3" runat="server" CssClass="TabHead" Font-Bold="True" Text="Total Weight:"
                                                Width="73px"></asp:Label></td>
                                        <td colspan="2">
                                            <asp:Label ID="lblTotWght" runat="server" CssClass="lblbox"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 3px;">
                                            <asp:Label ID="lnkOrderStsCaption" runat="server" Font-Bold="True" Text="Receipt:"></asp:Label></td>
                                        <td colspan="2">
                                            <asp:HyperLink ID="lblRecipt" runat="server" CssClass="lblbox" Font-Bold="False"></asp:HyperLink>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 3px">
                                            <asp:Label ID="Label6" runat="server" Font-Bold="True" Text="Pick Status:"></asp:Label></td>
                                        <td colspan="2">
                                            <asp:Label ID="lblPickSts" runat="server" CssClass="lblbox"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 3px;">
                                            <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="WO Status:"></asp:Label></td>
                                        <td colspan="2">
                                            <asp:Label ID="lblWOStatus" runat="server" CssClass="lblbox"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 3px;">
                                            <asp:LinkButton ID="lnbtnExpense" runat="server" Font-Underline="false" Font-Bold="True"
                                                OnClientClick="javascript:LoadExpense();" Text="Expenses"></asp:LinkButton></td>
                                        <td colspan="2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 3px">
                                            <asp:LinkButton ID="lnbtnComments" runat="server" Font-Underline="false" Font-Bold="True"
                                                OnClientClick="javascript:LoadComment();" Text="Comments"></asp:LinkButton></td>
                                        <td colspan="2">
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td class="lightBg" colspan="2" rowspan="1" style="padding-left: 0px; padding-top: 3px;"
                        id="tdWoDetail" valign="top">
                        <asp:UpdatePanel ID="pnlWODetail" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                        <asp:HiddenField ID="ProgMode" runat="server" />
                                <table cellpadding="0" cellspacing="0" id="Table1" border="0" width="100%">
                                    <tr id="Tr1">
                                        <td height="20px" valign="top" class="TabHead " style="padding-left: 5px; width: 110px;">
                                            <strong>
                                                <asp:Label ID="Label8" runat="server" Font-Bold="True" Text="Make Item Number" Width="107px"></asp:Label></strong></td>
                                        <td class="TabHead " valign="top" style="padding-left: 5px;">
                                            <strong>
                                                <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="Qty to Mfg" Width="60px"></asp:Label></strong></td>
                                        <td class="TabHead " valign="top" style="padding-left: 5px;">
                                            <strong>
                                                <asp:Label ID="lblQtyToRec" runat="server" Font-Bold="True" Text="Qty to Rec" Width="70px"></asp:Label></strong></td>
                                        <td class="TabHead " valign="top" style="padding-left: 5px;">
                                            <strong>
                                                <asp:Label ID="Label10" runat="server" Font-Bold="True" Text="Qty Received" Width="75px"></asp:Label></strong></td>
                                        <td class="TabHead" valign="top" style="padding-left: 5px;">
                                            <asp:Label ID="Label11" runat="server" Font-Bold="True" Text="Package Qty/UM" Width="98px"></asp:Label></td>
                                        <td class="TabHead " valign="top" style="padding-left: 5px;">
                                            &nbsp;<asp:Label ID="Label12" runat="server" Font-Bold="True" Text="Pallet Qty" Width="55px"></asp:Label></td>
                                        <td class="TabHead" valign="top" style="padding-left: 5px;">
                                            <asp:Label ID="Label13" runat="server" Font-Bold="True" Text="ROP" Width="40px"></asp:Label></td>
                                        <td class="TabHead" style="padding-left: 5px;" valign="top">
                                            <asp:Label ID="Label18" runat="server" Font-Bold="True" Text="Priority" Width="82px"></asp:Label></td>
                                        <td class="TabHead " valign="top" style="padding-left: 5px;">
                                            <strong>
                                                <asp:Label ID="Label14" runat="server" Font-Bold="True" Text="Pick Sheet Dt" Width="75px"></asp:Label></strong></td>
                                        <td class="TabHead " style="padding-left: 5px" valign="top">
                                            <asp:Label ID="Label15" runat="server" Font-Bold="True" Text="Requested Dt" Width="75px"></asp:Label></td>
                                        <td class="TabHead " style="padding-left: 5px" valign="top">
                                            <asp:Label ID="Label16" runat="server" Font-Bold="True" Text="IM Review Dt" Width="70px"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 4px; width: 110px;">
                                            <asp:TextBox ID="txtPODItemNo" runat="server" AutoCompleteType="Disabled" CssClass="lbl_whitebox" 
                                                MaxLength="30" onfocus="javascript:SetStockStatusItem(null);this.select();" onkeydown="javascript:javascript:if(event.keyCode==9 || event.keyCode==13){PopulatePODetail();return false;}"
                                                Width="100px"></asp:TextBox>
                                            <asp:Button ID="btnPopulatePODetail" Text="PoplatePOD" runat="server" Style="display: none;"
                                                OnClick="btnPopulatePODetail_Click" />
                                            <asp:HiddenField id="hidOneTimeBOM" runat="server"></asp:HiddenField>
                                        </td>
                                        <td style="padding-left: 3px">
                                            <asp:TextBox ID="txtQtyToMfg" runat="server" CssClass="lbl_whitebox" MaxLength="10" onkeypress="return ValdateNumberWithDot(this.value)"
                                                onfocus="javascript:SetStockStatusItem(null);this.select();" onkeydown="javascript:javascript:if(event.keyCode==9 || event.keyCode==13){UpdatePODetail();return false;} "
                                                Width="60px"></asp:TextBox>
                                            <asp:Label ID="lblQtyToMfg" runat="server" CssClass="txtBox small50px"></asp:Label>
                                            <asp:Button ID="btnUpdatePODetail" Text="updPODetail" runat="server" Style="display: none;"
                                                OnClick="btnUpdatePODetail_Click" />
                                        </td>
                                        <td style="padding-left: 3px">
                                            <asp:TextBox ID="txtQtyToRec" runat="server" CssClass="lbl_whitebox" MaxLength="10" onkeypress="return ValdateNumberWithDot(this.value)"
                                                onfocus="javascript:SetStockStatusItem(null);this.select();" onkeydown="javascript:javascript:if(event.keyCode==9 || event.keyCode==13){return false;} "
                                                Width="60px"></asp:TextBox>
                                        </td>
                                        <td style="padding-left: 3px">
                                            &nbsp;<asp:Label ID="lblQtyReceived" runat="server" CssClass="txtBox small50px"></asp:Label></td>
                                        <td style="padding-left: 5px">
                                            <asp:Label ID="lblPckQtyUOM" runat="server" CssClass="txtBox small50px"></asp:Label></td>
                                        <td style="padding-left: 3px">
                                            &nbsp;
                                            <asp:Label ID="lblPalletQty" runat="server" CssClass="txtBox small50px"></asp:Label></td>
                                        <td style="padding-left: 5px">
                                            <asp:Label ID="lblReOrdPoint" runat="server" CssClass="txtBox small50px"></asp:Label></td>
                                        <td style="padding-left: 5px">
                                            <asp:DropDownList Width="100" ID="ddlPriorityCd" Height="20px" TabIndex="2" CssClass="FormCtrl" runat="server"
                                            onchange="javascript:UpdatePriority();" ></asp:DropDownList></td>
                                            <asp:Button ID="btnUpdatePriority" Text="btnUpdatePriority" runat="server" Style="display: none;"
                                                OnClick="btnUpdatePriority_Click" />
                                        <td style="padding-left: 5px">
                                            <uc2:OrderEntrydatepicker ID="dpPickShtDt" runat="server" />
                                        </td>
                                        <td style="padding-left: 5px">
                                            <uc2:OrderEntrydatepicker ID="dpReqDt" runat="server" />
                                        </td>
                                        <td style="padding-left: 5px">
                                            &nbsp;<asp:Label ID="lblIMReviewDt" runat="server" CssClass="txtBox small50px"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td colspan="10" style="height: 20px; padding-left: 4px;">
                                            &nbsp;<asp:Label ID="lblHdDesription" runat="server"></asp:Label></td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" width="100%">
                        <div class="Sbar" oncontextmenu="Javascript:return false;" id="divdatagrid" style="overflow-x: auto;
                            overflow-y: auto; position: relative; top: 0px; left: 0px; height: 250px; width: 970px;
                            border: 0px solid; vertical-align: top;" runat="server">
                            <asp:UpdatePanel ID="pnlWOGrid" runat="server" UpdateMode="conditional">
                                <ContentTemplate>
                                    <table id="tblSearch" bgcolor="#ECF9FB" border="0" style="display: none;" width="100%"
                                        cellpadding="0" cellspacing="0">
                                        <tr bgcolor="#ECF9FB">
                                            <th width="80px" align="center">
                                                <asp:TextBox CssClass="Searchcnt" Width="98%" ID="txt_Item" onkeypress="javascript:if(event.keyCode==13){CallServerButtonClick('btnSearch'); return false;}"
                                                    runat="server"></asp:TextBox>
                                            </th>
                                            <th width="180px" align="center">
                                                <asp:TextBox CssClass="Searchcnt" Width="98%" ID="txt_PFCItem" onkeypress="javascript:if(event.keyCode==13){CallServerButtonClick('btnSearch'); return false;}"
                                                    runat="server"></asp:TextBox>
                                            </th>
                                            <th width="55px" align="center">
                                                <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_QtyPer" onkeypress="javascript:if(event.keyCode==13){CallServerButtonClick('btnSearch'); return false;}"
                                                    runat="server"></asp:TextBox>
                                            </th>
                                            <th width="55px" align="center">
                                                <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_QtyPerUOM" onkeypress="javascript:if(event.keyCode==13){CallServerButtonClick('btnSearch'); return false;}"
                                                    runat="server"></asp:TextBox>
                                            </th>
                                            <th width="55px" align="center">
                                                <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_ExtQty" onkeypress="javascript:if(event.keyCode==13){CallServerButtonClick('btnSearch'); return false;}"
                                                    runat="server"></asp:TextBox>
                                            </th>
                                            <th width="55px" align="center">
                                                <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_AvailQty" onkeypress="javascript:if(event.keyCode==13){CallServerButtonClick('btnSearch'); return false;}"
                                                    runat="server"></asp:TextBox>
                                            </th>
                                            <th width="55px" align="center">
                                                <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_NextAvailQty" onkeypress="javascript:if(event.keyCode==13){CallServerButtonClick('btnSearch'); return false;}"
                                                    runat="server"></asp:TextBox>
                                            </th>
                                            <th width="55px" align="center">
                                                <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_NextAvailDt" onkeypress="javascript:if(event.keyCode==13){CallServerButtonClick('btnSearch'); return false;}"
                                                    runat="server"></asp:TextBox>
                                            </th>
                                            <th width="55px" align="center">
                                                <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_UnitCost" onkeypress="javascript:if(event.keyCode==13){CallServerButtonClick('btnSearch'); return false;}"
                                                    runat="server"></asp:TextBox>
                                            </th>
                                            <th width="55px" align="center">
                                                <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_ExtCost" onkeypress="javascript:if(event.keyCode==13){CallServerButtonClick('btnSearch'); return false;}"
                                                    runat="server"></asp:TextBox>
                                            </th>
                                            <th width="120px" align="center">
                                                <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_LineNotes" onkeypress="javascript:if(event.keyCode==13){CallServerButtonClick('btnSearch'); return false;}"
                                                    runat="server"></asp:TextBox>
                                            </th>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="dgWOLines" UseAccessibleHeader="True" BackColor="#ECF9FB" BorderColor="#9AB8C3"
                                        Style="border-collapse: collapse; vertical-align: top; width: 100%;" AllowPaging="True"
                                        PagerStyle-Visible="false" runat="server" AutoGenerateColumns="False" BorderWidth="0px"
                                        AllowSorting="True" GridLines="Both" OnItemDataBound="dgWOLines_ItemDataBound">
                                        <HeaderStyle HorizontalAlign="Right" CssClass="WOGridHead" Font-Bold="True" BackColor="#DFF3F9" />
                                        <FooterStyle HorizontalAlign="Right" CssClass="WOGridHead" />
                                        <ItemStyle CssClass="item" VerticalAlign="Top" BackColor="White" Height="22px" BorderWidth="1px" />
                                        <AlternatingItemStyle CssClass="item" VerticalAlign="Top" BackColor="#ECF9FB" Height="22px"
                                            BorderWidth="1px" />
                                        <Columns>
                                            <asp:TemplateColumn SortExpression="ItemNo" HeaderText="Item #" ItemStyle-BorderColor="#9AB8C3"
                                                ItemStyle-BorderStyle="solid" ItemStyle-BorderWidth="1px">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblPFCItemNo" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ItemNo") %>'></asp:Label>
                                                    <asp:HiddenField ID="hidpWoCompId" Value='<%#DataBinder.Eval(Container.DataItem,"pWOComponentID") %>'
                                                        runat="server" />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="100px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                <ItemStyle HorizontalAlign="Left" Width="100px" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn SortExpression="ItemDesc" HeaderText="Description" ItemStyle-BorderColor="#9AB8C3"
                                                ItemStyle-BorderStyle="solid" ItemStyle-BorderWidth="1px">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblDescription" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ItemDesc") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="225px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                <ItemStyle HorizontalAlign="Left" Width="225px" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn SortExpression="QtyPer" HeaderText="Quantity Per" ItemStyle-BorderColor="#9AB8C3"
                                                ItemStyle-BorderStyle="solid" ItemStyle-BorderWidth="1px">
                                                <ItemTemplate>
                                                    <asp:HiddenField ID="hidPreviousQtyPer" Value='<%#DataBinder.Eval(Container.DataItem,"QtyPer") %>'
                                                        runat="server" />
                                                    <asp:Label ID="lblQtyPer" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"QtyPer") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="70px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                <ItemStyle HorizontalAlign="Right" Width="70px" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn SortExpression="QtyPerUM" HeaderText="UOM" ItemStyle-BorderColor="#9AB8C3"
                                                ItemStyle-BorderStyle="solid" ItemStyle-BorderWidth="1px">
                                                <ItemTemplate>
                                                    <asp:HiddenField ID="hidPreviousQtyPerUM" Value='<%#DataBinder.Eval(Container.DataItem,"QtyPerUM") %>'
                                                        runat="server" />
                                                    <asp:Label ID="lblQtyPerUM" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"QtyPerUM") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="30px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                <ItemStyle HorizontalAlign="Right" Width="30px" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderText="Max Mfg Qty" ItemStyle-BorderColor="#9AB8C3"
                                                ItemStyle-BorderStyle="solid" ItemStyle-BorderWidth="1px">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblMaxQty" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"MaxMfgQty","{0:###,##0}") %>'></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="60px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                <ItemStyle HorizontalAlign="Right" Width="60px" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn SortExpression="ExtendedQty" HeaderText="Extended Qty" ItemStyle-BorderColor="#9AB8C3"
                                                ItemStyle-BorderStyle="solid" ItemStyle-BorderWidth="1px">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblExtendedQty" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ExtendedQty") %>'></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Right" Width="70px" />
                                                <HeaderStyle HorizontalAlign="Center" Width="70px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn SortExpression="PickQty" HeaderText="Pick Qty" ItemStyle-BorderColor="#9AB8C3"
                                                ItemStyle-BorderStyle="solid" ItemStyle-BorderWidth="1px">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblPickQty" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"PickQty") %>'></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                <HeaderStyle HorizontalAlign="Center" Width="60px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn SortExpression="AvailQty" HeaderText="Available Qty" ItemStyle-BorderColor="#9AB8C3"
                                                ItemStyle-BorderStyle="solid" ItemStyle-BorderWidth="1px">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblAvailQty" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"AvailQty") %>'></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                <HeaderStyle HorizontalAlign="Center" Width="60px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn SortExpression="AvailQty" HeaderText="" ItemStyle-BorderColor="#9AB8C3"
                                                ItemStyle-BorderStyle="solid" ItemStyle-BorderWidth="1px">
                                                <HeaderTemplate>
                                                    <asp:Label ID="lblNextAvailQtyHeader" runat="server" Text='Next Avail Qty' Width="60px"></asp:Label>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="lblNextAvailQty" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"NextAvailQty") %>'></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                <HeaderStyle HorizontalAlign="Center" Width="60px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn SortExpression="NextAvailDt" HeaderText="" ItemStyle-BorderColor="#9AB8C3"
                                                ItemStyle-BorderStyle="solid" ItemStyle-BorderWidth="1px">
                                                <HeaderTemplate>
                                                    <asp:Label ID="lblNextAvailDtHeader" runat="server" Text='Next Avail Date' Width="60px"></asp:Label>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="lblNextAvailDt" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"NextAvailDt") %>'></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" Width="70px" />
                                                <HeaderStyle HorizontalAlign="Center" Width="70px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn SortExpression="UnitCost" HeaderText="Unit Cost" ItemStyle-BorderColor="#9AB8C3"
                                                ItemStyle-BorderStyle="solid" ItemStyle-BorderWidth="1px">
                                                <ItemTemplate>
                                                    <asp:TextBox ID="txtUnitCost" Width="60px" runat="server" Style="text-align: right;"  onkeypress="return ValdateNumberWithDot(this.value)"
                                                        CssClass="lbl_whitebox" onblur="Javascript:UpdateWOLine('UnitCost',this.value,this.id);"
                                                        onfocus="Javascript:SetStockStatusItem(this);" 
                                                        Text='<%#DataBinder.Eval(Container.DataItem,"UnitCost") %>' />
                                                    <asp:HiddenField ID="hidPreviousUnitCost" Value='<%#DataBinder.Eval(Container.DataItem,"UnitCost") %>'
                                                        runat="server" />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" Width="70px" />
                                                <HeaderStyle HorizontalAlign="Center" Width="70px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn SortExpression="ExtendedCost" HeaderText="Extended Cost" ItemStyle-BorderColor="#9AB8C3"
                                                ItemStyle-BorderStyle="solid" ItemStyle-BorderWidth="1px">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblExtendedCost" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ExtendedCost") %>'></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Right" Width="70px" />
                                                <HeaderStyle HorizontalAlign="Center" Width="70px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn SortExpression="WIPItemInd" HeaderText="WIP<BR>Item" ItemStyle-BorderColor="#9AB8C3"
                                                ItemStyle-BorderStyle="solid" ItemStyle-BorderWidth="1px">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblWIPItemInd" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"WIPItemInd") %>'></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" Width="30px" />
                                                <HeaderStyle HorizontalAlign="Center" Width="30px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderText="Deleted Date" SortExpression="DeleteDt" Visible="false"
                                                ItemStyle-BorderColor="#9AB8C3" ItemStyle-BorderStyle="solid" ItemStyle-BorderWidth="1px">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblDelDate" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"DeleteDt")%>'></asp:Label>
                                                    <asp:HiddenField ID="hidDelFlag" runat="server" Value=""></asp:HiddenField>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Width="50px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                <ItemStyle Width="50px" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn></asp:BoundColumn>
                                        </Columns>
                                        <PagerStyle HorizontalAlign="Left" Mode="NumericPages" Visible="False" />
                                    </asp:DataGrid>
                                    <asp:HiddenField ID="hidShowLineComments" runat="server" Value="" />
                                    <asp:HiddenField ID="hidGridCurControl" runat="server" Value="" />
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" id="commandLine">
                        <table cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td colspan="10">
                                    <table id="tblItem" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td colspan="12" class="splitborder_b_v">
                                                <asp:UpdatePanel ID="pnlCmdLine" runat="server" UpdateMode="conditional">
                                                    <ContentTemplate>
                                                        <table cellpadding="0" cellspacing="0" id="trItemText">
                                                            <tr id="trItem">
                                                                <td height="20px" width="100" valign="top" class="TabHead " style="padding-left: 5px;">
                                                                    <strong>Item Number</strong></td>
                                                                <td class="TabHead " width="60" valign="top" style="padding-left: 5px;">
                                                                    <strong>Qty Per</strong></td>
                                                                <td class="TabHead " width="60" valign="top" style="padding-left: 5px;">
                                                                    <strong>UOM</strong></td>
                                                                <td class="TabHead " width="55" valign="top" style="padding-left: 5px;">
                                                                    <strong>
                                                                        <asp:Label ID="Label40" runat="server" Font-Bold="True" Text="Cost" Width="69px"></asp:Label></strong></td>
                                                                <td class="TabHead" width="70" valign="top" style="padding-left: 5px;">
                                                                    <asp:Label ID="Label26" runat="server" Font-Bold="True" Text="Cost Unit" Width="69px"></asp:Label></td>
                                                                <td class="TabHead" width="70" valign="top" style="padding-left: 5px;">
                                                                    <asp:Label ID="Label27" runat="server" Font-Bold="True" Text="Cost Origin" Width="69px"></asp:Label></td>
                                                                <td class="TabHead " width="70" valign="top" style="padding-left: 5px;">
                                                                    <strong>
                                                                        <asp:Label ID="Label28" runat="server" Font-Bold="True" Text="WIP Item" Width="69px"></asp:Label></strong></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="padding-left: 3px">
                                                                    <asp:TextBox AutoCompleteType="Disabled" ID="txtCmdItemNo" runat="server" MaxLength="30"
                                                                        onfocus="javascript:SetStockStatusItem(null);BorderWipItem('none');this.select();" 
                                                                        onkeydown="javascript:javascript:if(event.keyCode==9){CallServerButtonClick('btnGetItemInfo')};if(event.keyCode==13){PopulateItemDetail();return false;}"
                                                                        CssClass="lbl_whitebox" Width="100px"></asp:TextBox>
                                                                    <asp:Button ID="btnGetItemInfo" Text="GetItemInfo" runat="server" Style="display: none;"
                                                                        OnClick="btnGetItemInfo_Click" />
                                                                </td>
                                                                <td style="padding-left: 3px">
                                                                    <asp:TextBox ID="txtCmdQtyPer" onfocus="javascript:SetStockStatusItem(null);BorderWipItem('none');this.select();" CssClass="lbl_whitebox"
                                                                        onkeydown="javascript:javascript:if(event.keyCode==13){event.keyCode =9; return; }"
                                                                        runat="server" MaxLength="10" Width="60px"></asp:TextBox></td>
                                                                <td style="padding-left: 3px">
                                                                    <asp:TextBox ID="txtCmdUOM" onfocus="javascript:SetStockStatusItem(null);BorderWipItem('none');this.select();" CssClass="lbl_whitebox"
                                                                         onkeydown="javascript:javascript:if(event.keyCode==9 || event.keyCode==13){CheckUOM();return false;}"
                                                                        runat="server" MaxLength="10" Width="60px"></asp:TextBox></td>
                                                                    <asp:Button ID="btnGetUOMInfo" Text="GetUOMInfo" runat="server" Style="display: none;"
                                                                        OnClick="btnGetUOMInfo_Click" />
                                                                <td style="padding-left: 3px">
                                                                    <asp:TextBox ID="txtCmdUnitCost" runat="server" CssClass="lbl_whitebox" MaxLength="10" AutoPostBack="True"
                                                                        onfocus="javascript:SetStockStatusItem(null);BorderWipItem('none');this.select();" Width="60px" 
                                                                        OnTextChanged="txtCmdUnitCost_TextChanged" 
                                                                        onkeydown="javascript:javascript:if(event.keyCode==13){event.keyCode=9;$get('chkCmdWipItem').focus(); return false;}"></asp:TextBox></td>
                                                                <td style="padding-left: 5px">
                                                                    <asp:Label ID="lblCmdUnitCost" CssClass="txtBox small50px" runat="server"></asp:Label></td>
                                                                <td style="padding-left: 5px">
                                                                    <asp:Label ID="lblCmdCostOrigin" CssClass="txtBox small50px" runat="server"></asp:Label></td>
                                                                <td align="center">
                                                                    <asp:CheckBox ID="chkCmdWipItem" runat="server" BorderWidth="1px" BorderColor="#97CACE" BorderStyle="None"
                                                                    onkeydown="javascript:if(event.keyCode==13){CallServerButtonClick('btnAddCmdLine');return false;}" ></asp:CheckBox>    
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="4" style="height: 20px">
                                                                    &nbsp;<asp:Label ID="lblCmdDesription" runat="server"></asp:Label></td>
                                                                <td>
                                                                    &nbsp;<asp:HiddenField ID="hidBaseUOM" runat="server" />
                                                                    <asp:HiddenField ID="hidAvailQty" runat="server" />
                                                                    <asp:HiddenField ID="hidNextAvailQty" runat="server" />
                                                                    <asp:HiddenField ID="hidNextAvailDt" runat="server" />
                                                                </td>
                                                                <td>
                                                                    &nbsp;<asp:Button ID="btnAddCmdLine" Text="AddCmdLine" runat="server" Style="display: none;"
                                                                        OnClick="btnAddCmdLine_Click" /></td>
                                                            </tr>
                                                        </table>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="9" class="splitborder_t_v splitborder_b_v" style="padding-left: 5px;">
                                                <asp:UpdateProgress ID="upPanel" runat="server">
                                                    <ProgressTemplate>
                                                        <span class="TabHead">Loading...</span></ProgressTemplate>
                                                </asp:UpdateProgress>
                                                <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                                    <ContentTemplate>
                                                        <asp:Label ID="lblMessage" ForeColor="red" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                            <td height="20px" align="right" colspan="5" width="35%" id="tdButton" style="padding-right: 3px;
                                                padding-top: 2px;" class="splitborder_t_v splitborder_b_v">
                                                <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlExport">
                                                    <ContentTemplate>
                                                        <div id="divDelete" class="MarkItUp_ContextMenu_MenuTable" style="display: none;
                                                            word-break: keep-all; position: absolute;">
                                                            <table border="0" cellpadding="0" cellspacing="0" class="MarkItUp_ContextMenu_Outline"
                                                                width="100">
                                                                <tr>
                                                                    <td>
                                                                        <table border="0" cellspacing="0" width="100">
                                                                            <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                                                                onmouseover="this.className='GridHead'">
                                                                                <td class="" width="20">
                                                                                    <img src="Common/Images/delete.jpg" /></td>
                                                                                <td align="left" class="" style="cursor: hand;" onclick="Javascript:return CallServerButtonClick('btnDelete');">
                                                                                    <strong>Delete</strong></td>
                                                                            </tr>
                                                                            <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                                                                onmouseover="this.className='GridHead'">
                                                                                <td class="" width="20">
                                                                                    <img src="Common/Images/cancelrequest.gif" /></td>
                                                                                <td align="left" class="" style="cursor: hand;" onclick="Javascript:document.getElementById('divDelete').style.display='none';document.getElementById(hidRowID.value).style.fontWeight='normal';">
                                                                                    <strong>Cancel</strong>
                                                                                    <input type="hidden" value="" id="hidRowID" />
                                                                                    <input type="hidden" value="" runat="server" id="hidDeleteWoCompId" />
                                                                                    <asp:Button ID="btnDelete" runat="server" Style="display: none;" OnClick="btnDelete_Click" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                        <table cellpadding="0" cellspacing="0" border="0" style="padding-left: 2px">
                                                            <tr>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnHideheader" ImageUrl="Common/Images/TV.gif" ToolTip="Clike here to Show/Hide Header"
                                                                        runat="server" OnClientClick="javascript:return HideHeader();" />
                                                                </td>
                                                                <td>
                                                                    <asp:ImageButton ID="btnShowAll" ImageUrl="~/Common/Images/expand.gif" ToolTip="Click here to Show Deleted Item"
                                                                        runat="server" OnClick="btnShowAll_Click" />
                                                                </td>
                                                                <td>
                                                                    <img src="Common/Images/search.gif" id="imgSearch" onclick="javascript:return ShowSearch('tblSearch');"
                                                                        alt="Click here to Show/Hide search" />
                                                                </td>
                                                                <td style="padding-left: 4px">
                                                                    <uc5:PrintDialogue Visible="false" ID="PrintDialogue1" EnableFax="true" runat="server"
                                                                        EnableEmail="true"></uc5:PrintDialogue>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                    <asp:HiddenField ID="hidShowAll" runat="server" Value="false" />
                                                                </td>
                                                                <td>
                                                                    <asp:Button ID="btnSearch" runat="server" Style="display: none;" CausesValidation="false"
                                                                        OnClick="btnSearch_Click" /></td>
                                                                <td style="padding-left: 4px">
                                                                    &nbsp;</td>
                                                                <td style="padding-left: 4px">
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" class="splitborder_t_v splitborder_b_v" colspan="12" style="padding-right: 3px"
                                    valign="middle">
                                    <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlButtons">
                                        <ContentTemplate>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton ID="btnReceive" Style="padding-left: 5px;" runat="server" CausesValidation="false"
                                                            AlternateText="Receive Order" ImageUrl="~/Common/Images/submit.gif" OnClick="btnReceive_Click" Visible="False" />
                                                        <asp:Button ID="btnProcessChoice"  runat="server" Text="ProcessChoice" style="display: none;"
                                                            OnClick="btnProcessChoice_Click"></asp:Button>
                                                        <asp:Button ID="btnProcessWipOverRcpt"  runat="server" Text="ProcessWipOverRcpt" style="display: none;"
                                                            OnClick="btnProcessWipOverRcpt_Click"></asp:Button>
                                                        <asp:HiddenField ID="hdReceiveMethod" runat="server"></asp:HiddenField>
                                                        <asp:HiddenField ID="hdInsufficientWipInd" runat="server"></asp:HiddenField>
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="btnDeleteOrder" Style="padding-left: 5px;" runat="server" CausesValidation="false"
                                                            AlternateText="Delete Order" ImageUrl="~/Common/Images/btndelete.gif" OnClick="btnDeleteOrder_Click" Visible="False" />
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="btnMakeOrder" runat="server" Style="padding-left: 5px;" Visible="false"
                                                            AlternateText="Make Order" ImageUrl="~/Common/Images/makeorder.gif" OnClick="btnMakeOreder_Click" />
                                                        <asp:ImageButton ID="btnReleaseOrder" runat="server" Style="padding-left: 5px;" Visible="false"
                                                            AlternateText="Release Order" ImageUrl="~/Common/Images/release.gif" OnClick="btnReleaseOrder_Click" />
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="imgHelp" Style="padding-left: 5px;" runat="server" CausesValidation="false"
                                                            AlternateText="Help" ImageUrl="~/Common/Images/help.gif" />
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="btnClose" Style="padding-left: 5px;" runat="server" CausesValidation="false"
                                                            AlternateText="Close" ImageUrl="~/Common/Images/Close.gif" OnClick="btnClose_Click" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </form>
    <script type="text/javascript">
    
    var leftFrame = top.parent.document.frames["menuFrame"];
    if( leftFrame &&
        leftFrame.document.getElementById("LeftMenu").style.display == "block")
    {
		if(document.getElementById("divdatagrid"))
		    document.getElementById("divdatagrid").style.width  = "860";
    }
    </script>
</body>
</html>
