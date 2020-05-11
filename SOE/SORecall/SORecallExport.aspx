<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SORecallExport.aspx.cs" Inherits="SORecall" %>

<%@ Register Src="../Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc5" %>
<%@ Register Src="UserControls/Header.ascx" TagName="Header1" TagPrefix="uc1" %>
<%@ Register Src="UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sales Order Recall</title>
    <link href="http://10.1.36.34/SOE/Common/StyleSheet/printstyles.css" rel="stylesheet"
        type="text/css" />
    <%= PFC.SOE.DataAccessLayer.Global.PrintStyleSheet %>
    <script type="text/javascript" src="../Common/JavaScript/Common.js"></script>

    <script>
function Close()
{
    parent.window.close();
}

function LoadHelp()
{
    window.open('Help.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
}

function NewDocument()
{
    javascript:window.parent.document.getElementById('Progress').style.display='';

    if (document.getElementById("tHeader1") != null)
        document.getElementById("tHeader1").style.visibility = "hidden";

    if (document.getElementById("tHeader2") != null)
        document.getElementById("tHeader2").style.visibility = "hidden";

    if (document.getElementById("tShipStatus1") != null)
        document.getElementById("tShipStatus1").style.visibility = "hidden";

    if (document.getElementById("tDetail") != null)
        document.getElementById("tDetail").style.visibility = "hidden";
}

function OpenSoldToForm()
{
    if(document.getElementById("txtOrderNo").value !="")
    {
        popUp=window.open ("../SoldToAddress.aspx?SONumber="+document.getElementById("txtOrderNo").value +"&Mode=SORecall","SoldToForm",'height=565,width=715,scrollbars=no,status=no,top='+((screen.height/2) - (565/2))+',left='+((screen.width/2) - (715/2))+',resizable=NO',"");
        popUp.focus();
    }
}
function OpenShipToForm()
{
    if(document.getElementById("txtOrderNo").value !="")
    {
        popUp=window.open ("../OneTimeShipToContact.aspx?SONumber="+document.getElementById("txtOrderNo").value +"&Mode=SORecall","ShipToForm",'height=585,width=715,scrollbars=no,status=no,top='+((screen.height/2) - (585/2))+',left='+((screen.width/2) - (715/2))+',resizable=NO',"");
        popUp.focus();
    }
}
function OpenBillToForm()
{
    if(document.getElementById("txtOrderNo").value !="")
    {
        popUp=window.open ("../BillToAddress.aspx?SONumber="+document.getElementById("txtOrderNo").value +"&CustNumber="+document.getElementById("hidBillToCustNo").value +"&Mode=SORecall","BillToForm",'height=520,width=715,scrollbars=no,status=no,top='+((screen.height/2) - (565/2))+',left='+((screen.width/2) - (715/2))+',resizable=NO',"");
        popUp.focus();
    }
}
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table runat="server" cellpadding="0" cellspacing="0"  id="mainTable">
            <tr>
                <td bgcolor="white" style="padding-right: 0px; padding-left: 0px; padding-bottom: 0px;
                    padding-top: 0px; height: 70px;">
                    <asp:Image ID="imglogo" runat="server" ImageUrl="/SOE/Common/Images/PFC_logo.gif" /></td>
            </tr>
            <tr>
                <td style="padding-right: 5px; padding-left: 5px; padding-bottom: 5px; padding-top: 5px">
                </td>
            </tr>
            <tr>
                <td width="100%" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="PageHead" style="height: 30px">
                                <table border="0" class="GridHead" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td valign="middle" height="25px;" align="left" width="25%" class="TabHead" style="padding-left: 10px;">
                                            Sales Order No:
                                            <asp:Label ID="txtOrderNo" runat="server" CssClass="lblColor"></asp:Label>
                                        </td>
                                        <td valign="middle" align="left" width="21%" class="TabHead">
                                            Invoice No:
                                            <asp:Label ID="txtInvoiceNo" runat="server" CssClass="lblColor"></asp:Label>
                                        </td>
                                        <td valign="middle" align="left" width="25%" class="TabHead">
                                            Orig Order No:
                                            <asp:Label ID="txtOrigOrderNo" runat="server" CssClass="lblColor"></asp:Label>
                                        </td>
                                        <td width="5%">
                                        </td>
                                        <td align="right" style="width: 250px; padding-right: 3px;">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="border-bottom: solid thin LightGrey;">
                    <table id="tStatus" runat="server" visible="false" height="600px" border="0" cellspacing="0"
                        cellpadding="0">
                        <tr>
                            <td valign="top" style="padding-top: 10px; padding-left: 10px; padding-bottom: 10px;
                                font-size: large; font-weight: bold; color: Red;">
                                <asp:Label ID="lblStatus" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </table>
                    <table id="tHeader1" runat="server" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="TabHead" style="padding-left: 10px; width: 80px;">
                                Order No:</td>
                            <td width="110px">
                                <asp:Label ID="lblOrderNo" runat="server" Text="~Order No~"></asp:Label></td>
                            <td width="70px" style="padding-left: 5px; border-left: solid thin LightGrey;">
                                <asp:Label ID="lnkSoldTo" runat="server" CssClass="TabHead" Text="Sold To:" Font-Bold="True"></asp:Label>
                            </td>
                            <td width="240px">
                                <asp:Label ID="lblSellToName" runat="server" Text="~Sell To Name~"></asp:Label>
                            </td>
                            <td width="70px" style="padding-left: 5px; border-left: solid thin LightGrey;">
                                <asp:Label ID="lnkShipTo" runat="server" CssClass="TabHead" Text="Ship To:" Font-Bold="True"></asp:Label>
                            </td>
                            <td width="240px">
                                <asp:Label ID="lblShipToName" runat="server" Text="~Ship To Name~"></asp:Label>
                            </td>
                            <td class="TabHead" width="100px" style="padding-left: 5px; border-left: solid thin LightGrey;">
                                Total Sales:
                            </td>
                            <td align="right" style="padding-right: 10px;">
                                <asp:Label ID="lblTotSales" runat="server" Text="~$999.99~"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TabHead" style="padding-left: 10px; width: 80px;">
                                Order Source:
                            </td>
                            <td>
                                <asp:Label ID="lblOrderSource" runat="server" Text="~Order Source~"></asp:Label></td>
                            <td style="padding-left: 5px; border-left: solid thin LightGrey;">
                                <asp:Label ID="lblSellToNo" runat="server" Text="~999999~"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblSellToAddress1" runat="server" Text="~Sell To Address1~"></asp:Label>
                            </td>
                            <td style="padding-left: 5px; border-left: solid thin LightGrey;">
                                <asp:Label ID="lblShipToNo" runat="server" Text="~999999~"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblShipToAddress1" runat="server" Text="~Ship To Address1~"></asp:Label>
                            </td>
                            <td class="TabHead" style="padding-left: 5px; border-left: solid thin LightGrey;">
                                Total GM$/Lb:
                            </td>
                            <td align="right" style="padding-right: 10px;">
                                <asp:Label ID="lblTotMgnPerLb" runat="server" Text="~$9.99~"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TabHead" style="padding-left: 10px; width: 80px;">
                                Order Type:
                            </td>
                            <td>
                                <asp:Label ID="lblOrderType" runat="server" Text="~Order Type~"></asp:Label></td>
                            <td style="padding-left: 5px; border-left: solid thin  LightGrey;">&nbsp;
                                </td>
                            <td>
                                <asp:Label ID="lblSellToAddress2" runat="server" Text="~Sell To Address2~"></asp:Label>
                            </td>
                            <td style="padding-left: 5px; border-left: solid thin LightGrey;">&nbsp;
                                </td>
                            <td>
                                <asp:Label ID="lblShipToAddress2" runat="server" Text="~Ship To Address2~"></asp:Label>
                            </td>
                            <td class="TabHead" style="padding-left: 5px; border-left: solid thin LightGrey;">
                                Total Weight:
                            </td>
                            <td align="right" style="padding-right: 10px;">
                                <asp:Label ID="lblTotWght" runat="server" Text="~999.99~"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TabHead" style="padding-left: 10px; width: 80px;">
                                Order Date:
                            </td>
                            <td>
                                <asp:Label ID="lblOrderDt" runat="server" Text="~Order Date~"></asp:Label></td>
                            <td style="padding-left: 5px; border-left: solid thin LightGrey;">&nbsp;
                                </td>
                            <td>
                                <asp:Label ID="lblSellToPhone" runat="server" Text="~Sell To Phone~"></asp:Label>
                            </td>
                            <td style="padding-left: 5px; border-left: solid thin LightGrey;">&nbsp;
                                </td>
                            <td>
                                <asp:Label ID="lblShipToPhone" runat="server" Text="~Ship To Phone~"></asp:Label>
                            </td>
                            <td class="TabHead" style="padding-left: 5px; border-left: solid thin LightGrey;">
                                Expenses
                            </td>
                            <td align="right" style="padding-right: 10px;">
                                <asp:Label ID="lblTotExp" runat="server" Text="~999.99~"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TabHead" style="padding-left: 10px; width: 80px;">
                                Cust
                                Ship Loc:
                            </td>
                            <td>
                                <asp:Label ID="lblCustShipLoc" runat="server" Text="~Cust Ship~"></asp:Label></td>
                            <td style="padding-left: 5px; border-left: solid thin LightGrey;">&nbsp;
                                </td>
                            <td>
                                Order Contact:
                                <asp:Label ID="lblSellToContact" runat="server" Text="~Sell To Contact~"></asp:Label>
                            </td>
                            <td style="padding-left: 5px; border-left: solid thin LightGrey;">&nbsp;
                                </td>
                            <td>
                                Contact:
                                <asp:Label ID="lblShipToContact" runat="server" Text="~Ship To Contact~"></asp:Label>
                            </td>
                            <td class="TabHead" style="padding-left: 5px; border-left: solid thin LightGrey;">
                                Taxes
                            </td>
                            <td align="right" style="padding-right: 10px; width: 82px;">
                                <asp:Label ID="lblTotTax" runat="server"></asp:Label>
                            </td>
                        </tr>
<%--                    <tr>
                            <td colspan="2">
                            </td>
                            <td style="padding-left: 5px; border-left: solid thin LightGrey;">&nbsp;
                                </td>
                            <td>
                            </td>
                            <td style="padding-left: 5px; border-left: solid thin LightGrey;">&nbsp;
                                </td>
                            <td>
                            </td>
                            <td style="padding-left: 5px; border-left: solid thin LightGrey;">&nbsp;
                                </td>
                            <td>
                            </td>
                        </tr>
--%>
                        <tr>
                            <td class="TabHead" style="padding-left: 10px; width: 80px;">
                                Ship Loc:
                            </td>
                            <td>
                                <asp:Label ID="lblShipLoc" runat="server" Text="~Ship Loc~"></asp:Label></td>
                            <td style="padding-left: 5px; border-left: solid thin LightGrey;">
                                <asp:Label ID="lnkBillTo" runat="server" CssClass="TabHead" Text="Bill To:" Font-Bold="True"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblBillToName" runat="server" Text="~Bill To Name~"></asp:Label>
                            </td>
                            <%--<td>
                                <asp:Label ID="lblBillToTerms" runat="server" Text="~Bill To Terms~"></asp:Label>
                            </td>--%>
                            <td style="padding-left: 5px; border-left: solid thin LightGrey;">&nbsp;
                                </td>
                            <td>
                            </td>
                            <td class="TabHead" style="padding-left: 5px; border-left: solid thin LightGrey;">&nbsp;
                                </td>
                            <td align="right" style="padding-right: 10px;">
                            </td>
                        </tr>
                        <tr>
                            <td class="TabHead" style="padding-left: 10px; width: 80px;">
                                Usage Loc:
                            </td>
                             <td>
                                <asp:Label ID="lblUsageLoc" runat="server" Text="~Usage Loc~"></asp:Label></td>
                            <td style="padding-left: 5px; border-left: solid thin LightGrey;">
                                <asp:Label ID="lblBillToNo" runat="server" Text="~999999~"></asp:Label>
                            </td>
                            <td>
                            </td>
                            <td style="padding-left: 5px; border-left: solid thin LightGrey;">&nbsp;
                                </td>
                            <td>
                            </td>
                            <td style="padding-left: 5px; border-left: solid thin LightGrey;">&nbsp;
                                </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="border-bottom: solid thin LightGrey;">
                    <table id="tHeader2" runat="server"
                        cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="8">
                                </td>
                        </tr>
                        <tr>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                PO No:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblPONumber" runat="server" Text="~PO Number~"></asp:Label>
                            </td>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                Invoice No:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblInvoiceNo" runat="server" Text="~InvoiceNo~"></asp:Label>
                            </td>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                Freight:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblFreight" runat="server" Text="~Freight~"></asp:Label>
                            </td>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                Suggested Dt:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblSuggDt" runat="server" Text="~SuggDt~"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                Cust Req Dt:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblReqDt" runat="server" Text="~ReqDt~"></asp:Label>
                            </td>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                <asp:Label ID="lblInvoiceDtLbl" runat="server" Text="Invoice Dt:"></asp:Label>
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblInvoiceDt" runat="server" Text="~InvDt~"></asp:Label>
                            </td>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                Priority:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblPriority" runat="server" Text="~Priority~"></asp:Label>
                            </td>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                Allocated Dt:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblAllocDt" runat="server" Text="~AllocDt~"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                Ship Dt:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblShipDt" runat="server" Text="~ShipDt~"></asp:Label>
                            </td>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                Carrier:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblCarrier" runat="server" Text="~Carrier~"></asp:Label>
                            </td>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                Hold Reason:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblHoldRsn" runat="server" Text="~Hold Rsn~"></asp:Label>
                            </td>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                Pick Print Dt:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblPickPrDt" runat="server" Text="~PickPrDt~"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                Expedite:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblExpedite" runat="server" Text="~Expedite~"></asp:Label>
                            </td>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                Carrier Pro:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblCarrierPro" runat="server" Text="~CarrierPro~"></asp:Label>
                            </td>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                Min Charge:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblMinChg" runat="server" Text="~Min Chg~"></asp:Label>
                            </td>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                Contract No:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblContract" runat="server" Text="~ContractNo~"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TabHead" width="10%" style="padding-left:5px;">
                                NaVision No:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblRefSO" runat="server" Text="~RefSONo~"></asp:Label>
                            </td>
                            <td class="TabHead" width="10%" style="padding-left:5px;">
                                Reference No:
                            </td>
                            <td width="15%">
                                <asp:Label ID="lblRefNo" runat="server" Text="~Reference~"></asp:Label>
                            </td>
                            <td colspan="4">&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="8">
                                </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table id="tShipStatus1" visible="true" runat="server" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="TabHead" width="10%" style="padding-left: 5px;">
                                Shipping Status
                            </td>
                        </tr>
                        <tr id="trShipStatus1" runat="server">
                            <td>
                                </td>
                        </tr>
                    </table>
                    <table id="tShipStatus2" visible="true" runat="server" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="TabHead" width="90px" style="padding-left: 15px;">
                                Mark 1:
                            </td>
                            <td width="200px">
                                <asp:Label ID="lblMark1" runat="server" Text="~~~~~~~~~~~~~~~~~~Mark1~~~~~~~~~~~~~~~~~~"></asp:Label>
                            </td>
                            <td class="TabHead" width="90px" style="padding-left: 15px;">
                                UPS/Pro No:
                            </td>
                            <td width="200px">
                                <asp:Label ID="lblUPSNo" runat="server" Text="~UPS/Pro#~"></asp:Label>
                            </td>
                            <td class="TabHead" width="80px" style="padding-left: 15px;">
                                Flag ID:
                            </td>
                            <td width="200px">
                                <asp:Label ID="lblFlagID" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TabHead" width="90px" style="padding-left: 15px;">
                                Mark 2:
                            </td>
                            <td width="200px">
                                <asp:Label ID="lblMark2" runat="server" Text="~~~~~~~~~~~~~~~~~~Mark2~~~~~~~~~~~~~~~~~~"></asp:Label>
                            </td>
                            <td class="TabHead" width="90px" style="padding-left: 15px;">
                                # of Cartons:
                            </td>
                            <td width="200px">
                                <asp:Label ID="lblNoCtn" runat="server" Text="~# of Ctn~"></asp:Label>
                            </td>
                            <td class="TabHead" width="80px" style="padding-left: 15px;">
                                Ship Dates:
                            </td>
                            <td width="200">
                                <asp:Label ID="Label1" runat="server" Text="Orig: " Font-Bold="true"></asp:Label>
                                <asp:Label ID="lblOrigShipDt" runat="server" Text="mm/dd/yyy"></asp:Label>
                                <asp:Label ID="Label2" runat="server" Text="Act: " Font-Bold="true"></asp:Label>
                                <asp:Label ID="lblActShipDt" runat="server" Text="mm/dd/yyy"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TabHead" width="90px" style="padding-left: 15px;">
                                Mark 3:
                            </td>
                            <td width="200px">
                                <asp:Label ID="lblMark3" runat="server" Text="~~~~~~~~~~~~~~~~~~Mark3~~~~~~~~~~~~~~~~~~"></asp:Label>
                            </td>
                            <td class="TabHead" width="90px" style="padding-left: 15px;">
                                Ship Weight:
                            </td>
                            <td width="200px">
                                <asp:Label ID="lblShipWght" runat="server" Text="~Ship Weight~"></asp:Label>
                            </td>
                            <td class="TabHead" width="80px" style="padding-left: 15px;">
                                # of Resch:
                            </td>
                            <td width="200px">
                                <asp:Label ID="lblResch" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TabHead" width="90px" style="padding-left: 15px;">
                                Mark 4:
                            </td>
                            <td width="200px">
                                <asp:Label ID="lblMark4" runat="server" Text="~~~~~~~~~~~~~~~~~~Mark4~~~~~~~~~~~~~~~~~~"></asp:Label>
                            </td>
                            <td class="TabHead" width="90px" style="padding-left: 15px;">
                                Freight Cost:
                            </td>
                            <td width="200px">
                                <asp:Label ID="lblFrtCost" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </table>
                    <table id="tShipStatus3" visible="false" runat="server" width="100%" style="border-bottom: solid thin LightGrey;"
                        cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="TabHead" width="80px" style="padding-left: 15px;">
                                Shipping Instr:
                            </td>
                            <td width="770px">
                                <asp:Label ID="lblShipInstr" runat="server" Text="xxxx - ~~~~~ShippingInstructions~~~~~"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TabHead" width="80px" style="padding-left: 15px;">
                                Remark:
                            </td>
                            <td width="770px">
                                <asp:Label ID="lblRemark" runat="server" Text="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ R e m a r k ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            </table>
                </td>
            </tr>
            <tr>
                <td>
                <table runat="server" cellpadding="0" cellspacing="0" width="100%" id="Table1">
            
                 <tr>
                <td>
                    <table id="tDetail" runat="server" width="100%" cellspacing="0" cellpadding="0">
                        <%--<tr>
                            <td style="padding-top:5px; padding-left:50px;">
                                <asp:LinkButton ID="linkComment" runat="server" CssClass="blackTxt" OnClick="linkComment_OnClick" Text="Show Comments"></asp:LinkButton>
                                &nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="linkDeleted" runat="server" CssClass="blackTxt" OnClick="linkDeleted_OnClick" Text="Show Deleted Lines"></asp:LinkButton>
                            </td>
                        </tr>--%>
                        <tr>
                            <td>
                                <asp:DataList ID="dlCommentTop" runat="server" Visible="true" Style="background-color: White;
                                    padding-top: 3px; padding-bottom: 3px; font-style: italic; font-weight: bold;">
                                    <ItemTemplate>
                                        <%# DataBinder.Eval(Container, "DataItem.CommText") %>
                                    </ItemTemplate>
                                    <ItemStyle Width="1865px" CssClass="lock" BackColor="white" />
                                </asp:DataList>
                                <asp:DataGrid ID="GridViewDtl1" UseAccessibleHeader="true" BackColor="#F4FBFD" runat="server"
                                    BorderWidth="0px" ShowFooter="False" AutoGenerateColumns="False" AllowPaging="false"
                                    Width="1865px" PagerStyle-Visible="false" OnItemDataBound="GridViewDtl1_ItemDataBound">
                                    <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                    <ItemStyle CssClass="Left5pxPadd" BackColor="White" BorderColor="White" VerticalAlign="Top" />
                                    <AlternatingItemStyle CssClass="itemShade" />
                                    <Columns>
                                        <asp:BoundColumn HeaderText="Cust. Item No" DataField="CustItemNo">
                                            <HeaderStyle CssClass="GridHead" Width="95px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Center" Width="95px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn HeaderText="Item No" DataField="ItemNo">
                                            <HeaderStyle CssClass="GridHead" Width="95px" Font-Bold="True" />
                                            <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Center" Width="95px" />
                                        </asp:BoundColumn>
                                        <asp:TemplateColumn HeaderText="Description">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDesc" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.ItemDsc") %>'></asp:Label>
                                                <div style="padding-top: 3px; padding-bottom: 3px; padding-left: 10px; padding-right: 5px;
                                                    font-style: italic; font-weight: bold;">
                                                    <asp:DataList ID="dlComment" runat="server" Visible="true">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblComment" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.CommText") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:DataList>
                                                </div>
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="GridHead" Width="275px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Left" VerticalAlign="Top" Width="275px" />
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="QtyShipped" HeaderText="Qty Shipped" DataFormatString="{0:N0}">
                                            <HeaderStyle CssClass="GridHead" Width="40px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="40px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="IMLoc" HeaderText="Ship Loc">
                                            <HeaderStyle CssClass="GridHead" Width="20px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="20px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="QtyOrdered" HeaderText="Req'd Qty" DataFormatString="{0:N0}">
                                            <HeaderStyle CssClass="GridHead" Width="40px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="40px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="QtyAvail1" HeaderText="Avail Qty" DataFormatString="{0:N0}">
                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="BaseUOM" HeaderText="Base Qty/UOM">
                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="TotalPcs" HeaderText="Total Pcs" DataFormatString="{0:N0}">
                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="AlternatePrice" HeaderText="Sell Price" DataFormatString="{0:C}">
                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="ExtendedPrice" HeaderText="Extended Price">
                                            <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="100px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="ExtendedNetWght" HeaderText="Extended Weight" DataFormatString="{0:N3}">
                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="LocName" HeaderText="Location Name">
                                            <HeaderStyle CssClass="GridHead" Width="160px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="160px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="LineNumber" HeaderText="Line No">
                                            <HeaderStyle CssClass="GridHead" HorizontalAlign="Right" Width="45px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="45px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="Remark" HeaderText="Line Note">
                                            <HeaderStyle CssClass="GridHead" Width="275px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="275px" />
                                        </asp:BoundColumn>
                                        
                                        <%--<asp:BoundColumn DataField="AlternateUMQty" HeaderText="Alt Qty" DataFormatString="{0:0}">
                                            <HeaderStyle CssClass="GridHead" Width="40px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="40px" />
                                        </asp:BoundColumn>                                        
                                        <asp:BoundColumn DataField="AlternateUM" HeaderText="Alt UOM">
                                            <HeaderStyle CssClass="GridHead" Width="40px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="40px" />
                                        </asp:BoundColumn>--%>
 <%-- which field --%>
                                        <%--<asp:BoundColumn HeaderText="Alt Price" DataFormatString="{0:C}">
                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                        </asp:BoundColumn>--%>
                                        <asp:BoundColumn DataField="AlternateUM" HeaderText="Sell Unit">
                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="50px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="PricePerLb" HeaderText="Price/Lb" DataFormatString="{0:C}">
                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="MarginPct" HeaderText="Margin %" DataFormatString="{0:N1}%">
                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="MarginPerLb" HeaderText="Margin/Lb" DataFormatString="{0:C}">
                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                        </asp:BoundColumn> 
                                        <asp:BoundColumn DataField="SuperEQV" HeaderText="Super Eqv">
                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="50px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="RqstdShipDt" HeaderText="Scheduled Ship Date" DataFormatString="{0:MM/dd/yyyy}">
                                            <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="80px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="DeleteDt" HeaderText="Delete Date" DataFormatString="{0:MM/dd/yyyy}">
                                            <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" />
                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="80px" />
                                        </asp:BoundColumn>
                                    </Columns>
                                </asp:DataGrid>
                                <table id="tTotals" class="BluBordAll" border="0" cellspacing="0" cellpadding="0"
                                    style="position: relative; top: 0px; left: 0px; height: 30px; width: 1865px;">
                                        <tr>
                                            <td width="180px" class="locked" bgcolor="white" style="border-right-width:0px;"></td>
                                            <td width="252px" style="border-right:1px solid #e1e1e1;"></td>
                                            <td width="35px" align="right" style="font-weight: bold; border-right:1px solid #e1e1e1; padding-left: 10px; padding-top: 5px; padding-right: 2px;">
                                                <asp:Label ID="lblMerchTotShpQty" runat="server" Text="Shp"></asp:Label>
                                            </td>
                                            <td width="26px" style="border-right:1px solid #e1e1e1;"></td>
                                            <td width="32px" align="right" style="font-weight: bold; border-right:1px solid #e1e1e1; padding-left: 10px; padding-top: 5px; padding-right: 2px;">
                                                <asp:Label ID="lblMerchTotReqQty" runat="server" Text="Req"></asp:Label>
                                            </td>
                                            <td width="245px" align="right" valign="bottom" style="font-weight: bold; border-right:0px;">Merchandise Total</td>
                                            <td width="87px" align="right" style="font-weight: bold; border-right:1px solid #e1e1e1; padding-left: 10px; padding-top: 5px; padding-right: 2px;">
                                                <asp:Label ID="lblMerchTotExtPrice" runat="server" Text="MExtPrc"></asp:Label>
                                            </td>
                                            <td></td>
                                        </tr>
                                        <tr id="trExpense" visible="false" runat="server">
                                            <td width="180px" class="locked" bgcolor="white" style="border:0px;"></td>
                                            <td width="252px" style="border-right:1px solid #e1e1e1;"></td>
                                            <td width="35px" style="border-right:1px solid #e1e1e1;"></td>
                                            <td width="26px" style="border-right:1px solid #e1e1e1;"></td>
                                            <td width="32px" style="border-right:1px solid #e1e1e1;"></td>                                            
                                            <td width="332px" align="right" colspan="2" style="font-weight: bold; border-right:1px solid #e1e1e1; padding-left: 10px;">
                                                <asp:DataList ID="dlExpense" runat="server" Width="100%" Style="padding-right: 0;" BorderWidth="0">
                                                    <ItemTemplate>
                                                        <table ID="tExpense" width="100%" cellpadding="0" cellspacing="0" align="right">
                                                            <tr>
                                                                <td width="245px" align="right" style="font-weight: bold; border: 0px; padding-left: 0px;">
                                                                    <%# DataBinder.Eval(Container, "DataItem.ExpenseDesc")%>
                                                                </td>
                                                                <td width="87px" align="right" style="font-weight: bold; border: 0px;">
                                                                    <%# string.Format("{0:c}", DataBinder.Eval(Container, "DataItem.Amount"))%>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="right" />
                                                </asp:DataList>
                                            </td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td width="180px" class="locked" bgcolor="white" style="border-right-width:0px;"></td>
                                            <td width="252px" style="border-right:1px solid #e1e1e1;"></td>
                                            <td width="35px" style="border-right:1px solid #e1e1e1;"></td>
                                            <td width="26px" style="border-right:1px solid #e1e1e1;"></td>
                                            <td width="32px" style="border-right:1px solid #e1e1e1;"></td>  
                                            <td width="245px" align="right" valign="bottom" style="font-weight: bold; border: 0px;">Total</td>
                                            <td width="87px" align="right" style="font-weight: bold; border-right: 1px solid #e1e1e1; padding-left: 10px; padding-top: 5px; padding-right: 2px;">
                                                <asp:Label ID="lblTotExtPrice" runat="server" Text="ExtPrc"></asp:Label>
                                            </td>
                                            <td></td>
                                        </tr>
                                </table>
                                <asp:DataList ID="dlCommentBtm" runat="server" Visible="true" Style="background-color: White;
                                    padding-top: 3px; padding-bottom: 3px; font-style: italic; font-weight: bold;">
                                    <ItemTemplate>
                                        <%# DataBinder.Eval(Container, "DataItem.CommText") %>
                                    </ItemTemplate>
                                    <ItemStyle Width="1865px" CssClass="locked" />
                                </asp:DataList>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <input type="hidden" runat="server" id="hidSort" />
                    <asp:HiddenField ID="hidShipStatus" Value="closed" runat="server" />
                    <asp:HiddenField ID="hidBillToCustNo" runat="server" />
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
