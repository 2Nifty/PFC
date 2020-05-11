<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerActivityRpt.aspx.cs" Inherits="CustomerActivityRpt" %>

<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage2.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="../PrintUtility/Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc3" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Customer Activity Report</title>

    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <script src="../Common/Javascript/Common.js" type="text/javascript"></script>

    <style type="text/css">
        .tdPadTop2
        {
            padding-top:2px; 
            padding-bottom:2px;
        }

        .tdPadTop5
        {
            padding-top:5px; 
            padding-bottom:2px;
        }

        .tdPadBtm5
        {
            padding-top:2px; 
            padding-bottom:5px;
        }
        
        .tdPadLeft
        {
            padding-left:20px; 
        }

        .tdPadRight20
        {
            padding-right:20px; 
        }

        .tdPadRight10
        {
            padding-right:10px; 
        }
        
        .tdBordRight
        {
            border-right:solid 1px Gray;
        }

        .tdBordTop
        {
            border-top:solid 1px Gray;
        }

        .tdBordBtm
        {
            border-Bottom:solid 1px Gray;
        }   
    </style>


    <script language="javascript" type="text/javascript">
        function Close(session)
        {
            CustomerActivityRpt.Close('CASRpt'+session).value;
            window.close();
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server" ID="smCAS" AsyncPostBackTimeout="360000"></asp:ScriptManager>
        <table id="tblMain" cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse;">
            <tr>
                <td height="5%" id="tdHeaders" align="center">
                    <uc1:Header ID="HeaderID" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="lightBlueBg" style="border-top:solid 1px #88D2E9; border-bottom:solid 1px #88D2E9; width:100%;">
                    <table>
                        <tr>
                            <td>
                                <asp:Label CssClass="BanText" style="padding-left: 5px;" Text="Customer Activity Report" runat=server ID="lblRepHeader" Height="34px" Width="221px"></asp:Label>                                
                            </td>
                        <%--<td align="right" width="650px" class="TabHead">
                                <span class=LeftPadding>Run Date: <%=DateTime.Now.Month%>/<%=DateTime.Now.Day%>/<%=DateTime.Now.Year%></span>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <span class=LeftPadding>Run By: <%=Session["UserName"].ToString() %></span>
                            </td>--%>
                            <td width="75%" align="right">
                                <%--<img src="../Common/images/help.gif" onclick="javascript:LoadHelp();" style="cursor: hand" />&nbsp;&nbsp;&nbsp;--%>
                                <img id="btnClose" alt="Close" src="../Common/images/close.gif" style="cursor:hand" onclick="javascript:Close('<%=Session["SessionID"].ToString() %>');"/>
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
                            <td align="left" class="tdPadTop2 tdPadLeft" style="font-weight:bold; width:35%">
                                <asp:Label ID="lblCustParam" runat="server" Text="Cust Param"></asp:Label>
                            </td>
                            <td align="center" class="tdPad" style="font-weight:bold; width:25%">
                                <asp:RadioButtonList ID="rdoVersion" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="rdoVersion_Changed" AutoPostBack="true">
                                    <asp:ListItem value="Customer" />
                                    <asp:ListItem value="PFC Employee" />
                                </asp:RadioButtonList>
                            </td>
                            <td align="center" valign="middle" class="tdPad" style="font-weight:bold; width:30%; padding-left:5px; vertical-align:middle;">
                                <asp:Label ID="lblRptGroup" runat="server" Text="Summary by " />
                                <asp:DropDownList ID="ddlRptGroup" runat="server" CssClass="FormCtrl" Width="125px" AutoPostBack="true" OnSelectedIndexChanged="ddlRptGroup_SelectedIndexChanged" />
<%--                            <asp:RadioButtonList ID="rdoGroup" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="rdoGroup_Changed" AutoPostBack="true">
                                    <asp:ListItem value="Category" />
                                    <asp:ListItem value="Buy Group" />
                                </asp:RadioButtonList>--%>
                            </td>
                            <td align="right" class="tdPadTop2 tdPadLeft" style="font-weight:bold; width:10%">
                                <asp:Label ID="lblPerParam" runat="server" Text="Per Param"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <%--Main Report Panel--%>
                    <asp:Panel ID="pnlScroll" ScrollBars="Vertical" Height="545px" Width="100%" runat="server">                    
                        <table cellpadding="0" cellspacing="0" width="98%">
                            <tr>
                                <td valign="top">
                                    <table cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td style="width:100%;">
                                                <%--Customer Info--%>
                                                <asp:UpdatePanel ID="pnlCustTop" runat="server" UpdateMode="Conditional">
                                                    <ContentTemplate>
                                                        <%--Customer Info--%>
                                                        <table id="tblCust" runat="server" width="825px" cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop" style="font-weight:bold; width:255px;">
                                                                    <asp:Label ID="lblCustNo" runat="server" Text="Cust Info1"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop" style="font-weight:bold; width:255px;">
                                                                    <asp:Label ID="lblCustName" runat="server" Text="Cust Addr1"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop" style="font-weight:bold; width:255px;">
                                                                    <asp:Label ID="lblSlsBrn" runat="server" Text="Sales Info1"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblChain" runat="server" Text="Cust Info2"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblAddr1" runat="server" Text="Cust Addr2"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblInsideSls" runat="server" Text="Sales Info2"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblCustType" runat="server" Text="Cust Info3"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblCityStZip" runat="server" Text="Cust Addr3"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblSlsRep" runat="server" Text="Sales Info3"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblBuyGrp" runat="server" Text="Cust Info4"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblPhone" runat="server" Text="Cust Addr4"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblHub" runat="server" Text="Sales Info4"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblKeyCust" runat="server" Text="Cust Info5"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblFax" runat="server" Text="Cust Addr5"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblTerms" runat="server" Text="Sales Info5"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="tdPadBtm5 tdPadLeft tdBordRight tdBordBtm">
                                                                    <asp:Label ID="lblCommRep" runat="server" Text="Cust Info6"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadBtm5 tdPadLeft tdBordRight tdBordBtm">
                                                                    <asp:Label ID="lblContact" runat="server" Text="Cust Addr6"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadBtm5 tdPadLeft tdBordRight tdBordBtm">
                                                                    <asp:Label ID="lblCreditLmt" runat="server" Text="Sales Info6"></asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        
                                                        <%--Customer Info (PFC Employee Data)--%>
                                                        <table id="tblCustPFC" runat="server" width="825px" cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight" style="width:255px;">
                                                                    <asp:Label ID="lblSched1" runat="server" Text="ContractSchd1"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight" style="width:255px;">
                                                                    <asp:Label ID="lblSched5" runat="server" Text="ContractSchd5"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadTop5 tdPadLeft" style="width:85px;">
                                                                    Web Disc Pct:
                                                                </td>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight" style="width:150px;">
                                                                    <asp:Label ID="lblWebDisc" runat="server" Text="Web Disc %"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblSched2" runat="server" Text="ContractSchd2"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblSched6" runat="server" Text="ContractSchd6"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadTop2 tdPadLeft">
                                                                    Enable Web Disc:
                                                                </td>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblWebEnabled" runat="server" Text="Web Disc Enabled"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblSched3" runat="server" Text="ContractSchd3"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblSched7" runat="server" Text="ContractSchd7"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadTop2 tdPadLeft">
                                                                    Cust Def Price: 
                                                                </td>
                                                                <td align="left" class="tdPadTop2 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblDefPrice" runat="server" Text="Cust Def Price"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="tdPadBtm5 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblSched4" runat="server" Text="ContractSchd4"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadBtm5 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblDefGrossMgn" runat="server" Text="Def Gross Mgn"></asp:Label>
                                                                </td>
                                                                <td align="left" class="tdPadBtm5 tdPadLeft">
                                                                    Cust Price Ind:
                                                                </td>
                                                                <td align="left" class="tdPadBtm5 tdPadLeft tdBordRight">
                                                                    <asp:Label ID="lblPriceInd" runat="server" Text="Cust Price Ind"></asp:Label>
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
                                <td>
                                    <table cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td style="width:100%;">
                                                <%--A/R Aging--%>
                                                <asp:UpdatePanel ID="pnlAging" runat="server" UpdateMode="Conditional">
                                                    <ContentTemplate>
                                                        <table id="tblAging" width="825px" cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td align="center" rowspan="3" class="tdPadTop5 tdBordRight tdBordTop" style="font-weight:bold; width:90px;">
                                                                    A/R Aging
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop" style="font-weight:bold; width:70px;">
                                                                    Period
                                                                </td>
                                                                <td align="center" class="tdPadTop5 tdBordRight tdBordTop" style="font-weight:bold; width:110px;">
                                                                    Current
                                                                </td>
                                                                <td align="center" class="tdPadTop5 tdBordRight tdBordTop" style="font-weight:bold; width:110px;">
                                                                    >30
                                                                </td>
                                                                <td align="center" class="tdPadTop5 tdBordRight tdBordTop" style="font-weight:bold; width:110px;">
                                                                    >60
                                                                </td>
                                                                <td align="center" class="tdPadTop5 tdBordRight tdBordTop" style="font-weight:bold; width:110px;">
                                                                    >90
                                                                </td>
                                                                <td align="center" class="tdPadTop5 tdBordRight tdBordTop" style="font-weight:bold; width:125px;">
                                                                    Total
                                                                </td>
                                                                <td align="center" class="tdPadTop5 tdBordRight tdBordTop" style="font-weight:bold; width:90px;">
                                                                    DSO
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop" style="font-weight:bold;">
                                                                    Amount
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblAmtCur" runat="server" Text="lblAmtCur"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblAmt30" runat="server" Text="lblAmt30"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblAmt60" runat="server" Text="lblAmt60"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblAmt90" runat="server" Text="lblAmt90"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblAmtTot" runat="server" Text="lblAmtTot"></asp:Label>
                                                                </td>
                                                                <td align="center" rowspan="2" class="tdPadTop5 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblDSO" runat="server" Text="lblDSO"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop" style="font-weight:bold;">
                                                                    % of AR
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblARCur" runat="server" Text="lblARCur"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblAR30" runat="server" Text="lblAR30"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblAR60" runat="server" Text="lblAR60"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblAR90" runat="server" Text="lblAR90"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10" style="background-color:Gray">
                                                                    <asp:Label ID="lblARTot" runat="server" Text=""></asp:Label>
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
                                <td>
                                    <table cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td style="width:100%;">
                                                <%--Sales History--%>
                                                <asp:UpdatePanel ID="pnlHist" runat="server" UpdateMode="Conditional">
                                                    <ContentTemplate>
                                                        <table id="tblHist" width="825px" cellpadding="0" cellspacing="0" border="0">

                                                            <tr class="BluBg">
                                                                <td align="center" class="tdPadTop5 tdBordRight" style="border-top:solid 2px Gray; font-weight:bold;">
                                                                    <asp:Label ID="lblPerHist" runat="server" Text="Per Param"></asp:Label>
                                                                </td>
                                                                <td align="center" colspan="2" class="tdPadTop5 tdBordRight" style="border-top:solid 2px Gray; font-weight:bold;">
                                                                    Fiscal Month
                                                                </td>
                                                                <td align="center" colspan="2" class="tdPadTop5 tdBordRight" style="border-top:solid 2px Gray; font-weight:bold;">
                                                                    Fiscal Year
                                                                </td>
                                                            </tr>
                                                            
                                                            <tr style="background:#ECF9FB;">
                                                                <td class="tdPadTop5 tdBordRight tdBordTop" style="width:185px;">
                                                                    &nbsp;
                                                                </td>
                                                                <td align="center" class="tdPadTop5 tdBordRight tdBordTop" style="width:160px;">
                                                                    <u>Current Year</u>
                                                                </td>
                                                                <td align="center" class="tdPadTop5 tdBordRight tdBordTop" style="width:160px;">
                                                                    <u>Last Year</u>
                                                                </td>
                                                                <td align="center" class="tdPadTop5 tdBordRight tdBordTop" style="width:160px;">
                                                                    <u>Current Year</u>
                                                                </td>
                                                                <td align="center" class="tdPadTop5 tdBordRight tdBordTop" style="width:160px;">
                                                                    <u>Last Year</u>
                                                                </td>
                                                            </tr>

                                                            <tr id="trCustRank" runat="server">
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    Cust Rank
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblCustRankCurMth" runat="server" Text="CustRank CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblCustRankLastMth" runat="server" Text="CustRank LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblCustRankCurYr" runat="server" Text="CustRank CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblCustRankLastYr" runat="server" Text="CustRank LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr id="trTerrRank" runat="server">
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    Territory Rank
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblTerrRankCurMth" runat="server" Text="TerrRank CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblTerrRankLastMth" runat="server" Text="TerrRank LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblTerrRankCurYr" runat="server" Text="TerrRank CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblTerrRankLastYr" runat="server" Text="TerrRank LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    Fiscal Sales
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblFiscalSlsCurMth" runat="server" Text="FiscalSls CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblFiscalSlsLastMth" runat="server" Text="FiscalSls LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblFiscalSlsCurYr" runat="server" Text="FiscalSls CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblFiscalSlsLastYr" runat="server" Text="FiscalSls LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    Sales Dollar % Change
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblDlrPctChgCurMth" runat="server" Text="DlrPctChg CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop" style="background-color:Gray;">
                                                                    <asp:Label ID="lblDlrPctChgLastMth" runat="server" Text=""></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblDlrPctChgCurYr" runat="server" Text="DlrPctChg CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop" style="background-color:Gray;">
                                                                    <asp:Label ID="lblDlrPctChgLastYr" runat="server" Text=""></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr id="trMgnDlrPct" runat="server">
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    Margin Dollars / G.M. %
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMgnDlrPctCurMth" runat="server" Text="MgnDlrPct CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMgnDlrPctLastMth" runat="server" Text="MgnDlrPct LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMgnDlrPctCurYr" runat="server" Text="MgnDlrPct CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMgnDlrPctLastYr" runat="server" Text="MgnDlrPct LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr id="trDlrPerLb" runat="server">
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    Dollars Per Lb
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblDlrPerLbCurMth" runat="server" Text="DlrPerLb CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblDlrPerLbLastMth" runat="server" Text="DlrPerLb LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblDlrPerLbCurYr" runat="server" Text="DlrPerLb CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblDlrPerLbLastYr" runat="server" Text="DlrPerLb LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr id="trGMDlrPerLb" runat="server">
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    GM Dollars Per Lb
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblGMDlrPerLbCurMth" runat="server" Text="GMDlrPerLb CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblGMDlrPerLbLastMth" runat="server" Text="GMDlrPerLb LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblGMDlrPerLbCurYr" runat="server" Text="GMDlrPerLb CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblGMDlrPerLbLastYr" runat="server" Text="GMDlrPerLb LastYr"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            
                                                            <tr id="trAvgDlrPerOrd" runat="server">
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    Avg Dollars Per Order
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblAvgDlrPerOrdCurMth" runat="server" Text="AvgDlrPerOrd CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblAvgDlrPerOrdLastMth" runat="server" Text="AvgDlrPerOrd LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblAvgDlrPerOrdCurYr" runat="server" Text="AvgDlrPerOrd CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblAvgDlrPerOrdLastYr" runat="server" Text="AvgDlrPerOrd LastYr"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            
                                                            <tr id="trAvgDlrPerLine" runat="server">
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    Avg Dollars Per Line
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblAvgDlrPerLineCurMth" runat="server" Text="AvgDlrPerLine CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblAvgDlrPerLineLastMth" runat="server" Text="AvgDlrPerLine LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblAvgDlrPerLineCurYr" runat="server" Text="AvgDlrPerLine CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblAvgDlrPerLineLastYr" runat="server" Text="AvgDlrPerLine LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr id="trSlsHist" runat="server">
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    Historical Sales
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop" style="background-color:Gray;">
                                                                    <asp:Label ID="lblSlsHistCurMth" runat="server" Text=""></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop" style="background-color:Gray;">
                                                                    <asp:Label ID="lblSlsHistLastMth" runat="server" Text=""></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSlsHistCurYr" runat="server" Text="SlsHist CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSlsHistLastYr" runat="server" Text="SlsHist LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr id="trLbsHist" runat="server">
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    Historical Lbs
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop" style="background-color:Gray;">
                                                                    <asp:Label ID="lblLbsHistCurMth" runat="server" Text=""></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop" style="background-color:Gray;">
                                                                    <asp:Label ID="lblLbsHistLastMth" runat="server" Text=""></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblLbsHistCurYr" runat="server" Text="LbsHist CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblLbsHistLastYr" runat="server" Text="LbsHist LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr id="trCurWkGoal" runat="server">
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    Current Weekly Goal $
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblCurWkGoalCurMth" runat="server" Text="CurWkGoal CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordTop" style="background-color:Gray;">
                                                                    <asp:Label ID="lblCurWkGoalLastMth" runat="server" Text=""></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblCurWkGoalCurYr" runat="server" Text="CurWkGoal CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop" style="background-color:Gray;">
                                                                    <asp:Label ID="lblCurWkGoalLastYr" runat="server" Text=""></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    SOE Sales Dollars
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOESalesDlrCurMth" runat="server" Text="SOESalesDlr CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOESalesDlrLastMth" runat="server" Text="SOESalesDlr LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOESalesDlrCurYr" runat="server" Text="SOESalesDlr CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOESalesDlrLastYr" runat="server" Text="SOESalesDlr LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    eCommerce Sales Dollars
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECSalesDlrCurMth" runat="server" Text="ECSalesDlr CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECSalesDlrLastMth" runat="server" Text="ECSalesDlr LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECSalesDlrCurYr" runat="server" Text="ECSalesDlr CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECSalesDlrLastYr" runat="server" Text="ECSalesDlr LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    Mill Sales Dollars
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMillSalesDlrCurMth" runat="server" Text="MillSalesDlr CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMillSalesDlrLastMth" runat="server" Text="MillSalesDlr LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMillSalesDlrCurYr" runat="server" Text="MillSalesDlr CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMillSalesDlrLastYr" runat="server" Text="MillSalesDlr LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    SOE Sales Lbs
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOESalesLbsCurMth" runat="server" Text="SOESalesLbs CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOESalesLbsLastMth" runat="server" Text="SOESalesLbs LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOESalesLbsCurYr" runat="server" Text="SOESalesLbs CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOESalesLbsLastYr" runat="server" Text="SOESalesLbs LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    eCommerce Sales Lbs
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECSalesLbsCurMth" runat="server" Text="ECSalesLbs CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECSalesLbsLastMth" runat="server" Text="ECSalesLbs LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECSalesLbsCurYr" runat="server" Text="ECSalesLbs CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECSalesLbsLastYr" runat="server" Text="ECSalesLbs LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    Mill Sales Lbs
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMillSalesLbsCurMth" runat="server" Text="MillSalesLbs CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMillSalesLbsLastMth" runat="server" Text="MillSalesLbs LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMillSalesLbsCurYr" runat="server" Text="MillSalesLbs CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMillSalesLbsLastYr" runat="server" Text="MillSalesLbs LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    SOE Order Count
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOEOrdCountCurMth" runat="server" Text="SOEOrdCount CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOEOrdCountLastMth" runat="server" Text="SOEOrdCount LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOEOrdCountCurYr" runat="server" Text="SOEOrdCount CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOEOrdCountLastYr" runat="server" Text="SOEOrdCount LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    eCommerce Order Count
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECOrdCountCurMth" runat="server" Text="ECOrdCount CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECOrdCountLastMth" runat="server" Text="ECOrdCount LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECOrdCountCurYr" runat="server" Text="ECOrdCount CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECOrdCountLastYr" runat="server" Text="ECOrdCount LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    Mill Order Count
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMillOrdCountCurMth" runat="server" Text="MillOrdCount CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMillOrdCountLastMth" runat="server" Text="MillOrdCount LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMillOrdCountCurYr" runat="server" Text="MillOrdCount CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMillOrdCountLastYr" runat="server" Text="MillOrdCount LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    SOE Line Count
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOELineCountCurMth" runat="server" Text="SOELineCount CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOELineCountLastMth" runat="server" Text="SOELineCount LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOELineCountCurYr" runat="server" Text="SOELineCount CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOELineCountLastYr" runat="server" Text="SOELineCount LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    eCommerce Line Count
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECLineCountCurMth" runat="server" Text="ECLineCount CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECLineCountLastMth" runat="server" Text="ECLineCount LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECLineCountCurYr" runat="server" Text="ECLineCount CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECLineCountLastYr" runat="server" Text="ECLineCount LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    Mill Line Count
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMillLineCountCurMth" runat="server" Text="MillLineCount CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMillLineCountLastMth" runat="server" Text="MillLineCount LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMillLineCountCurYr" runat="server" Text="MillLineCount CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblMillLineCountLastYr" runat="server" Text="MillLineCount LastYr"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            
                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    SOE Quote $
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOEQuoteDlrCurMth" runat="server" Text="SOEQuoteDlr CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOEQuoteDlrLastMth" runat="server" Text="SOEQuoteDlr LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOEQuoteDlrCurYr" runat="server" Text="SOEQuoteDlr CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOEQuoteDlrLastYr" runat="server" Text="SOEQuoteDlr LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    eCommerce Quote $
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECQuoteDlrCurMth" runat="server" Text="ECQuoteDlr CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECQuoteDlrLastMth" runat="server" Text="ECQuoteDlr LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECQuoteDlrCurYr" runat="server" Text="ECQuoteDlr CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECQuoteDlrLastYr" runat="server" Text="ECQuoteDlr LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    SOE Quote Order Count
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOEQuoteCountCurMth" runat="server" Text="SOEQuoteCount CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOEQuoteCountLastMth" runat="server" Text="SOEQuoteCount LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOEQuoteCountCurYr" runat="server" Text="SOEQuoteCount CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOEQuoteCountLastYr" runat="server" Text="SOEQuoteCount LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    eCommerce Quote Order Count
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECQuoteCountCurMth" runat="server" Text="ECQuoteCount CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECQuoteCountLastMth" runat="server" Text="ECQuoteCount LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECQuoteCountCurYr" runat="server" Text="ECQuoteCount CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECQuoteCountLastYr" runat="server" Text="ECQuoteCount LastYr"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            
                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    SOE Quote Line Count
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOEQuoteLineCountCurMth" runat="server" Text="SOEQuoteLineCount CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOEQuoteLineCountLastMth" runat="server" Text="SOEQuoteLineCount LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOEQuoteLineCountCurYr" runat="server" Text="SOEQuoteLineCount CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblSOEQuoteLineCountLastYr" runat="server" Text="SOEQuoteLineCount LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    eCommerce Quote Line Count
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECQuoteLineCountCurMth" runat="server" Text="ECQuoteLineCount CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECQuoteLineCountLastMth" runat="server" Text="ECQuoteLineCount LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECQuoteLineCountCurYr" runat="server" Text="ECQuoteLineCount CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblECQuoteLineCountLastYr" runat="server" Text="ECQuoteLineCount LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    RGA Count Per Dollar
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblRGACountPerDlrCurMth" runat="server" Text="RGACountPerDlr CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblRGACountPerDlrLastMth" runat="server" Text="RGACountPerDlr LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblRGACountPerDlrCurYr" runat="server" Text="RGACountPerDlr CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblRGACountPerDlrLastYr" runat="server" Text="RGACountPerDlr LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td align="left" class="tdPadTop5 tdPadLeft tdBordRight tdBordTop">
                                                                    Credit Count Per Dollar
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblCreditCountPerDlrCurMth" runat="server" Text="CreditCountPerDlr CurMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblCreditCountPerDlrLastMth" runat="server" Text="CreditCountPerDlr LastMth"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblCreditCountPerDlrCurYr" runat="server" Text="CreditCountPerDlr CurYr"></asp:Label>
                                                                </td>
                                                                <td align="right" class="tdPadTop5 tdPadRight10 tdBordRight tdBordTop">
                                                                    <asp:Label ID="lblCreditCountPerDlrLastYr" runat="server" Text="CreditCountPerDlr LastYr"></asp:Label>
                                                                </td>
                                                            </tr>

                                                            <tr style="background:#ECF9FB;">
                                                                <td class="tdPadTop5 tdBordRight tdBordTop" style="width:185px;">
                                                                    &nbsp;
                                                                </td>
                                                                <td align="center" class="tdPadTop5 tdBordRight tdBordTop" style="width:160px;">
                                                                    <u>Current Year</u>
                                                                </td>
                                                                <td align="center" class="tdPadTop5 tdBordRight tdBordTop" style="width:160px;">
                                                                    <u>Last Year</u>
                                                                </td>
                                                                <td align="center" class="tdPadTop5 tdBordRight tdBordTop" style="width:160px;">
                                                                    <u>Current Year</u>
                                                                </td>
                                                                <td align="center" class="tdPadTop5 tdBordRight tdBordTop" style="width:160px;">
                                                                    <u>Last Year</u>
                                                                </td>
                                                            </tr>
                                                            
                                                            <tr class="BluBg">
                                                                <td align="center" class="tdPadTop5 tdBordRight tdBordTop" style="font-weight:bold;">
                                                                    <asp:Label ID="lblPerHistBot" runat="server" Text="Per Param"></asp:Label>
                                                                </td>
                                                                <td align="center" colspan="2" class="tdPadTop5 tdBordRight tdBordTop" style="font-weight:bold;">
                                                                    Fiscal Month
                                                                </td>
                                                                <td align="center" colspan="2" class="tdPadTop5 tdBordRight tdBordTop" style="font-weight:bold;">
                                                                    Fiscal Year
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
                                <td>
                                    <table cellpadding="0" cellspacing="0" width="825px">
                                        <tr class="BluBg">
                                            <td align="center" class="tdPadTop5 tdBordRight" style="border-top:solid 2px Gray; font-weight:bold; font-size:medium;">
                                                <asp:Label ID="lblGridHdr" runat="server" Text="Customer Sales Group Summary"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width:100%;">
                                                <%--Group Summary Grid--%>
                                                <asp:UpdatePanel ID="pnlGrid" runat="server" UpdateMode="conditional">
                                                    <ContentTemplate>
                                                        <div id="divdatagrid" class="Sbar" align="left" runat="server" style="overflow:auto; width:825px; height:515px; border:0px solid; vertical-align:top; overflow-y:scroll;">
                                                            <asp:DataGrid ID="dgSummary" runat="server" BackColor="#F4FBFD" BorderWidth="1px" AllowPaging="false" PagerStyle-Visible="false"
                                                                ShowFooter="true" AutoGenerateColumns="False" AllowSorting="true" OnItemDataBound="dgSummary_ItemDataBound" Width="1425px" OnSortCommand="dgSummary_Sort">
                                                            <HeaderStyle CssClass="GridHead" Wrap="false" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Center" />
                                                            <ItemStyle CssClass="Left5pxPadd GridItem" BackColor="White" BorderColor="White" />
                                                            <AlternatingItemStyle CssClass="Left5pxPadd Zebra" BackColor="#F4FBFD" BorderColor="#DAEEEF" />
                                                            <FooterStyle CssClass="GridHead" Wrap="false" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Right" />
                                                                <Columns>

                                                                <%--<asp:BoundColumn DataField="GroupNo" HeaderText="No">
                                                                        <ItemStyle Width="20px" HorizontalAlign="Left" Wrap="False" />
                                                                    </asp:BoundColumn>--%>

                                                                    <asp:BoundColumn DataField="GroupDesc" HeaderText="Group">
                                                                        <ItemStyle Width="225px" HorizontalAlign="Left" Wrap="False" />
                                                                        <FooterStyle HorizontalAlign="Left" />
                                                                    </asp:BoundColumn>
                                                                    
                                                                    <asp:BoundColumn DataField="SalesCurYTD" HeaderText="YTD Sales $" DataFormatString="{0:$#,#0}" SortExpression="SalesCurYTD">
                                                                        <ItemStyle Width="80px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="SalesCurMTD" HeaderText="MTD Sales $" DataFormatString="{0:$#,#0}" SortExpression="SalesCurMTD">
                                                                        <ItemStyle Width="80px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn> 

                                                                    <asp:BoundColumn DataField="SalesLastYTD" HeaderText="Last YTD Sales $" DataFormatString="{0:$#,#0}" SortExpression="SalesLastYTD">
                                                                        <ItemStyle Width="80px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="SalesPrevYTD" HeaderText="Prev YTD Sales $" DataFormatString="{0:$#,#0}" SortExpression="SalesPrevYTD">
                                                                        <ItemStyle Width="80px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn> 

                                                                    <asp:BoundColumn DataField="WghtCurYTD" HeaderText="YTD Lbs" DataFormatString="{0:n1}" SortExpression="WghtCurYTD">
                                                                        <ItemStyle Width="80px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="WghtCurMTD" HeaderText="MTD Lbs" DataFormatString="{0:n1}" SortExpression="WghtCurMTD">
                                                                        <ItemStyle Width="80px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn> 

                                                                    <asp:BoundColumn DataField="SalesCurYTD" HeaderText="% of Sales $" SortExpression="SalesCurYTD">
                                                                        <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn> 
                                                                    
                                                                    <asp:BoundColumn DataField="GMDlrCurYTD" HeaderText="YTD GM$" DataFormatString="{0:$#,#0}" SortExpression="GMDlrCurYTD">
                                                                        <ItemStyle Width="80px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="GMDlrCurMTD" HeaderText="MTD GM$" DataFormatString="{0:$#,#0}" SortExpression="GMDlrCurMTD">
                                                                        <ItemStyle Width="80px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn> 

                                                                    <asp:BoundColumn DataField="AvgGMPctYTD" HeaderText="YTD Avg GM %" DataFormatString="{0:0.0%}" SortExpression="AvgGMPctYTD">
                                                                        <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn> 

                                                                    <asp:BoundColumn DataField="AvgGMPctMTD" HeaderText="MTD Avg GM %" DataFormatString="{0:0.0%}" SortExpression="AvgGMPctMTD">
                                                                        <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn> 

                                                                    <asp:BoundColumn DataField="PriceGMPctYTD" HeaderText="YTD Price GM %" DataFormatString="{0:0.0%}" SortExpression="PriceGMPctYTD">
                                                                        <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn> 

                                                                    <asp:BoundColumn DataField="PriceGMPctMTD" HeaderText="MTD Price GM %" DataFormatString="{0:0.0%}" SortExpression="PriceGMPctMTD">
                                                                        <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn> 

                                                                    <asp:BoundColumn HeaderText="Target GM %" DataField="DefaultGMPct">
                                                                        <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="DlrPerLbCurYTD" HeaderText="YTD $/Lb" DataFormatString="{0:c}" SortExpression="DlrPerLbCurYTD">
                                                                        <ItemStyle Width="65px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="DlrPerLbCurMTD" HeaderText="MTD $/Lb" DataFormatString="{0:c}" SortExpression="DlrPerLbCurMTD">
                                                                        <ItemStyle Width="65px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn> 

                                                                    <asp:BoundColumn DataField="GMPerLbCurYTD" HeaderText="YTD GM/Lb" DataFormatString="{0:c}" SortExpression="GMPerLbCurYTD">
                                                                        <ItemStyle Width="65px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn>

                                                                    <asp:BoundColumn DataField="GMPerLbCurMTD" HeaderText="MTD GM/Lb" DataFormatString="{0:c}" SortExpression="GMPerLbCurMTD">
                                                                        <ItemStyle Width="65px" HorizontalAlign="Right" Wrap="False" />
                                                                    </asp:BoundColumn> 

                                                                </Columns>
                                                            </asp:DataGrid>
                                                        </div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                        </tr>
                                    </table>
                                </td>      
                            </tr>
                        </table>
                    </asp:Panel>
                </td>
            </tr>

            <%--Status Bar--%>
            <tr>
                <td class="lightBlueBg buttonBar" style="border-top:solid 1px #CDECF6">
                    <table width="825px">
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
                                            runat="server" Width="500px" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td width="92%" align="right">
                                <asp:ImageButton ID="btnExport" Style="cursor: hand;" Height="18px" Width="18px" CausesValidation="false" ImageUrl="~/Common/Images/ExcelIcon.jpg"
                                    ToolTip="Export To Excel" runat="server" OnClick="btnExport_Click" />
                            </td>
                            <td style="padding-left: 3px">
                                <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlExport">
                                    <ContentTemplate>
                                        <uc3:PrintDialogue ID="PrintDialogue1" PageTitle="POAgingRpt" FormName="CustomerActivityRptPreview" EnableFax="false" EnableEmail="false" runat="server"></uc3:PrintDialogue>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <%--Footer--%>
            <tr>
                <td>
                    <uc2:Footer ID="BottomFooterID" LeftText="Best in 1024x768" FooterTitle="Customer Activity Report" runat="server" />
                </td>
            </tr>

            <input type="hidden" runat="server" id="hidSort" /> 
            <asp:HiddenField ID="hidDefaultGrossMarginPct" runat="server" Value="0" />

        </table>
    </form>
</body>
</html>
