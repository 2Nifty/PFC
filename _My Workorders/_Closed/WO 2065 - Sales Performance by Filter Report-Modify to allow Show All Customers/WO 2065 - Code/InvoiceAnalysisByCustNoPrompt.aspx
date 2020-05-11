<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InvoiceAnalysisByCustNoPrompt.aspx.cs" Inherits="PFC.Intranet.InvoiceAnalysisPrompt" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Sales Performance by Filter</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script language="javascript">
    function ViewReport()
    {
        var orderType = document.form1.ddlOrderType.value; 
        var orderIndex = document.form1.ddlOrderType.selectedIndex;
        selected_text = document.form1.ddlOrderType.options[orderIndex].text;    
        if(selected_text.toUpperCase() == "ALL")
            orderType = "";

        var branchID =document.form1.ddlBranch.value;    
        var branchIndex = document.form1.ddlBranch.selectedIndex;
        var selected_text = document.form1.ddlBranch.options[branchIndex].text;    
        if(selected_text.toUpperCase() == "ALL")
            branchID = "";
         
        var chain = document.form1.ddlChain.value; 
        var chainIndex = document.form1.ddlChain.selectedIndex;
        selected_text = document.form1.ddlChain.options[chainIndex].text;    
        if(selected_text.toUpperCase() == "ALL")
            chain = "";
        
        var shipMethod = document.form1.ddlShipMethod.value;
        var shipMethodIndex = document.form1.ddlShipMethod.selectedIndex;
        var shipMethodName = document.form1.ddlShipMethod.options[shipMethodIndex].text;    
        if(shipMethod.toUpperCase() == "ALL")
            shipMethod = "";
        if(shipMethodName.toUpperCase() == "ALL")
            shipMethodName = "";

        var salesPersonNo = document.form1.ddlInsideSalesRep.value; 
        var salesPersonIndex = document.form1.ddlInsideSalesRep.selectedIndex;
        var salesPerson = document.form1.ddlInsideSalesRep.options[salesPersonIndex].text;    
        if(salesPersonNo.toUpperCase() == "ALL")
            salesPersonNo = "";
        if(salesPerson.toUpperCase() == "ALL")
            salesPerson = "";

        var priceCd = document.form1.ddlPriceCd.value; 
        if(priceCd.toUpperCase() == "ALL")
            priceCd = "";

        var orderSource = document.form1.ddlOrderSource.value; 
        var orderSourceIndex = document.form1.ddlOrderSource.selectedIndex;
        var orderSourceDesc = document.form1.ddlOrderSource.options[orderSourceIndex].text;    
        if(orderSource.toUpperCase() == "ALL")
            orderSource = "";
        if (orderSourceDesc.substr(0,1) != "*")
            orderSourceDesc = "";

//        var subTotal = document.form1.ddlSubTot.value; 
//        var subTotalIndex = document.form1.ddlSubTot.selectedIndex;
//        var subTotalDesc = document.form1.ddlSubTot.options[subTotalIndex].text;  
//        var subTotalFlag = document.form1.chkSubTot.checked;

        var territory = document.form1.ddlTerritory.value; 
        var territoryIndex = document.form1.ddlTerritory.selectedIndex;
        selected_text = document.form1.ddlTerritory.options[territoryIndex].text;    
        if(selected_text.toUpperCase() == "ALL")
            territory = "";
            
        var csrNo = document.form1.ddlOutsideSalesRep.value; 
        var csrIndex = document.form1.ddlOutsideSalesRep.selectedIndex;
        selected_text = document.form1.ddlOutsideSalesRep.options[csrIndex].text;    
        if(selected_text.toUpperCase() == "ALL")
            csrNo = "";

        var allCustFlag = document.form1.chkAllCust.checked;

        if(document.getElementById("hidEndDt").value == "1/1/0001" ||  document.getElementById("hidStartDt").value == "1/1/0001")
        {
            alert('Select beginning & end date');
        }
        else
        { 
            var hwnd, Url;

            Url = "InvoiceAnalysisByCustNo.aspx" +
                  "?StartDate=" + document.getElementById("hidStartDt").value + 
                  "&EndDate=" + document.getElementById("hidEndDt").value + 
                  "&OrderType=" + orderType + 
                  "&Branch=" + branchID + 
                  "&CustNo=" + document.form1.txtCustNo.value +
                  "&Chain="+ chain +
                  "&WeightFrom=" + "" +
                  "&WeightTo=" + "" + 
                  "&ShipToState=" + "" +
                  "&BranchDesc=" + document.form1.ddlBranch.options[branchIndex].text +
                  "&OrderTypeDesc=" + document.form1.ddlOrderType.options[orderIndex].text + 
                  "&SalesPerson=" + salesPerson + 
                  "&SalesRepNo=" + salesPersonNo +
                  "&PriceCd=" + priceCd +
                  "&OrderSource=" + orderSource +
                  "&OrderSourceDesc=" + orderSourceDesc +
                  "&ShipMethod=" + shipMethod + 
                  "&ShipMethodName=" + shipMethodName +
                  "&SubTotal=" + "0" +
                  "&SubTotalDesc=" + "" +
                  "&SubTotalFlag=" + "false" + 
                  "&TerritoryCd=" + territory +
                  "&TerritoryDesc=" + document.form1.ddlTerritory.options[territoryIndex].text  +
                  "&CSRName=" + document.form1.ddlOutsideSalesRep.options[csrIndex].text +
                  "&CSRNo=" + csrNo + 
                  "&AllCustFlag=" + allCustFlag;
            hwnd=window.open(Url,"InvoiceAnalysisbycustomer" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
            hwnd.focus();
        }
    }

    function LoadHelp()
    {
        window.open("../Help/HelpFrame.aspx?Name=InvoiceReport",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
    }
    </script>

</head>
<body scroll="auto">
    <form id="form1" runat="server">
        <table width="100%">
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td valign="top">
                                <uc1:PageHeader ID="PageHeader1" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="height: 100%;">
                                <asp:ScriptManager runat="server" ID="scmPostBack">
                                </asp:ScriptManager>
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td class="PageHead" style="height: 40px" width="75%">
                                            <div class="LeftPadding">
                                                <div align="left" class="BannerText">
                                                    Sales Performance by Filter Report</div>
                                            </div>
                                        </td>
                                        <td class="PageHead" style="height: 40px; width: 275px;">
                                            <div class="LeftPadding">
                                                <div align="right" class="BannerText">
                                                    <img src="../Common/images/close.gif" onclick="javascript:history.back();" style="cursor: hand" /></div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table border="0" cellspacing="0" cellpadding="3">
                                                <tr id="tdRange" runat="server">
                                                    <td colspan="2" style="width: 400px; height: 20px">
                                                        <asp:UpdatePanel runat="server" ID="pnlDate">
                                                            <ContentTemplate>
                                                                <table>
                                                                    <tr>
                                                                        <td style="height: 12px; width: 165px;">
                                                                            <asp:Label ID="lblStartDt" runat="server" Text="Beginning Date" Width="93px" Font-Bold="True"
                                                                                ForeColor="Red"></asp:Label></td>
                                                                        <td>
                                                                            &nbsp;</td>
                                                                        <td>
                                                                            <asp:Label ID="lblEndDt" runat="server" Text="Ending Date" Width="67px" Font-Bold="True"
                                                                                ForeColor="Red"></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 165px; height: 12px">
                                                                            <asp:Calendar ID="cldStartDt" runat="server" Visible="true" OnSelectionChanged="cldStartDt_SelectionChanged"
                                                                                Width="150px"></asp:Calendar>
                                                                            <input type="hidden" id="hidStartDt" runat="server" /></td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Calendar ID="cldEndDt" runat="server" Visible="true" OnSelectionChanged="cldEndDt_SelectionChanged"
                                                                                Width="150px"></asp:Calendar>
                                                                            <input type="hidden" id="hidEndDt" runat="server" /></td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                    <td colspan="1" style="width: 560px; height: 20px">
                                                        <table border="0" cellpadding="5" cellspacing="0">
                                                            <tr>
                                                                <td style="width: 110px">
                                                                    <asp:Label ID="lblOrdType" runat="server" Text="Order Type"></asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList ID="ddlOrderType" runat="server" CssClass="FormCtrl" Width="209px">
                                                                        <asp:ListItem Text="ALL" Value=""></asp:ListItem>
                                                                        <asp:ListItem Text="Mill" Value="1"></asp:ListItem>
                                                                        <asp:ListItem Text="Warehouse" Value="0"></asp:ListItem>
                                                                        <asp:ListItem Text="StockRelease" Value="4"></asp:ListItem>
                                                                    </asp:DropDownList></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="lblBranch" runat="server" Text="Branch"></asp:Label></td>
                                                                <td>
                                                                    <asp:UpdatePanel runat="server" ID="pnlBranch" UpdateMode="Conditional">
                                                                        <ContentTemplate>
                                                                            <asp:DropDownList ID="ddlBranch" runat="server" CssClass="FormCtrl" Width="209px"
                                                                                AutoPostBack="True" OnSelectedIndexChanged="ddlBranch_SelectedIndexChanged">
                                                                            </asp:DropDownList>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="lblChain" runat="server" Text="Chain"></asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList ID="ddlChain" runat="server" CssClass="FormCtrl" Width="209px">
                                                                    </asp:DropDownList></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="lblCust" runat="server" Text="Customer #"></asp:Label></td>
                                                                <td>
                                                                    <asp:UpdatePanel runat="server" ID="pnlCustNo" UpdateMode="Conditional">
                                                                        <ContentTemplate>
                                                                            <asp:TextBox ID="txtCustNo" runat="server" CssClass="FormCtrl" MaxLength="20" Width="202px" AutoPostBack="true" OnTextChanged="txtCustNo_TextChanged"></asp:TextBox>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="lblTerr" runat="server" Text="Territory"></asp:Label></td>
                                                                <td>
                                                                    <asp:UpdatePanel runat="server" ID="pnlTerritory" UpdateMode="Conditional">
                                                                        <ContentTemplate>
                                                                            <asp:DropDownList ID="ddlTerritory" runat="server" CssClass="FormCtrl" Width="209px">
                                                                            </asp:DropDownList>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="lblOutsideSls" runat="server" Text="Outside Sales Rep"></asp:Label></td>
                                                                <td>
                                                                    <asp:UpdatePanel runat="server" ID="pnlCSR" UpdateMode="Conditional">
                                                                        <ContentTemplate>
                                                                            <asp:DropDownList ID="ddlOutsideSalesRep" runat="server" CssClass="FormCtrl" Width="209px">
                                                                            </asp:DropDownList>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="lblShipMeth" runat="server" Font-Bold="False" Text="Shipment Method"></asp:Label></td>
                                                                <td>
                                                                    <asp:UpdatePanel runat="server" ID="pnlShipMeth" UpdateMode="Conditional">
                                                                        <ContentTemplate>
                                                                        <%--<asp:DropDownList ID="ddlShipMethod" AutoPostBack="true" runat="server" CssClass="FormCtrl"
                                                                                Width="209px" OnSelectedIndexChanged="ddlShipMethod_SelectedIndexChanged">
                                                                            </asp:DropDownList>--%>
                                                                            <asp:DropDownList ID="ddlShipMethod" runat="server" CssClass="FormCtrl" Width="209px">
                                                                            </asp:DropDownList>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="lblInsideSls" runat="server" Font-Bold="False" Text="Inside Sales Rep"></asp:Label></td>
                                                                <td>
                                                                    <asp:UpdatePanel runat="server" ID="pnlSalesRep" UpdateMode="Conditional">
                                                                        <ContentTemplate>
                                                                            <asp:DropDownList ID="ddlInsideSalesRep" runat="server" CssClass="FormCtrl" Width="209px">
                                                                            </asp:DropDownList>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="lblPriceCd" runat="server" Font-Bold="False" Text="Price Code"></asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList ID="ddlPriceCd" runat="server" CssClass="FormCtrl" Width="209px">
                                                                    </asp:DropDownList></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="lblOrdSrc" runat="server" Font-Bold="False" Text="Order Source"></asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList ID="ddlOrderSource" runat="server" CssClass="FormCtrl" Width="209px">
                                                                    </asp:DropDownList></td>
                                                            </tr>
                                                        <%--<tr>
                                                                <td>
                                                                    <asp:Label ID="lblSubTots" runat="server" Text="Sub-Totals" Visible="False"></asp:Label></td>
                                                                <td>
                                                                    <asp:UpdatePanel runat="server" ID="pnlSubTot" UpdateMode="Conditional" Visible="False">
                                                                        <ContentTemplate>
                                                                            <asp:DropDownList ID="ddlSubTot" AutoPostBack="true" runat="server" CssClass="FormCtrl"
                                                                                Width="209px" OnSelectedIndexChanged="ddlSubTot_SelectedIndexChanged">
                                                                                <asp:ListItem Text="None" Value="0"></asp:ListItem>
                                                                                <asp:ListItem Text="By Customer" Value="1"></asp:ListItem>
                                                                                <asp:ListItem Text="By Customer/Order Source" Value="2"></asp:ListItem>
                                                                                <asp:ListItem Text="By Date/Branch/City" Value="9"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="lblTotFlg" runat="server" Text="Sub-Totals Only" Visible="False"></asp:Label></td>
                                                                <td>
                                                                    <asp:UpdatePanel runat="server" ID="pnlCheckbox" UpdateMode="Conditional" Visible="False">
                                                                        <ContentTemplate>
                                                                            <asp:CheckBox ID="chkSubTot" runat="server" Enabled="false" />
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </td>
                                                            </tr>--%>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="lblAllCust" runat="server" Font-Bold="False" Text="Show All Customers"></asp:Label></td>
                                                                <td>
                                                                    <asp:UpdatePanel runat="server" ID="pnlAllCust" UpdateMode="Conditional">
                                                                        <ContentTemplate>
                                                                            <asp:CheckBox ID="chkAllCust" Title="This will display all customers, based on the filters above, regardless of Sales History" runat="server" AutoPostBack="true" OnCheckedChanged="chkAllCust_CheckedChanged" />
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 100%" valign="top">
                                <asp:UpdatePanel runat="server" ID="pnlStatus">
                                    <ContentTemplate>
                                        <asp:Label ID="lblError" runat="server" Font-Bold="True" ForeColor="Red" Text=""
                                            Visible="false" Width="67px"></asp:Label></td>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                        </tr>
                        <tr>
                            <td class="BluBg" style="">
                                <div class="LeftPadding">
                                    <span class="LeftPadding" style="vertical-align: middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <img id="Img1" src="../common/images/viewReport.gif" style="cursor: hand" onclick="javascript:ViewReport();" />&nbsp;<img
                                            src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />&nbsp;
                                    </span>
                                </div>
                            </td>
                            <td class="BluBg">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
