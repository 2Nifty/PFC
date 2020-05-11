<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="PriceCostMaint.aspx.cs"
    Inherits="PriceCostMaint" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/Pager.ascx" TagName="Pager" TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="PageHeader" runat="server">
    <title>Price Cost Overlay Maintenance</title>
    <link href="Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />
    <link href="../MaintenanceApps/Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
       
    function zItem(itemNo, ctlId)
    {
        document.getElementById("lblMessage").innerText = "";

        if(itemNo != "")
        {
            var section = "";
            var completeItem = 0;
            var result = "";
            var status = "";

            switch(itemNo.split('-').length)
            {
                case 1:
                    event.keyCode = 0;
                    itemNo = "00000" + itemNo;
                    itemNo = itemNo.substr(itemNo.length-5,5);
                    document.getElementById(ctlId).value = itemNo + "-"; 
                    break;
                case 2:
                    ////close if they are entering an empty part
                    //if (itemNo.split('-')[0] == "00000") {ClosePage()};
                    event.keyCode = 0;
                    section = "0000" + itemNo.split('-')[1];
                    section = section.substr(section.length-4,4);
                    document.getElementById(ctlId).value = itemNo.split('-')[0] + "-" + section + "-";  
                    break;
                case 3:
                    event.keyCode = 0;
                    section = "000" + itemNo.split('-')[2];
                    section = section.substr(section.length-3,3);
                    document.getElementById(ctlId).value = itemNo.split('-')[0] + "-" + itemNo.split('-')[1] + "-" + section;  
                    completeItem = 1;
                    break;
            }

            if (completeItem == 1)
            {
                itemNo = document.getElementById(ctlId).value;
                if(ctlId == "txtSearchItemNo")
                     document.getElementById("btnSearch").click();
                else
                    document.getElementById("btnGetItem").click();
            }
        }
        else
        {
            event.keyCode = 0;
            document.getElementById(ctlId).focus();
        }
    }
    
    
    function UnloadPage()
    {
        PriceCostMaint.DeleteExcel();
    }
    
    function BindValue(sortExpression)
    {     
        if(document.getElementById("hidSortExpression") !=null)
            document.getElementById("hidSortExpression").value= sortExpression;
        document.getElementById("btnSort").click();
    }
    
    function SetPreviousValue(PreviousValue,CtrlTxtID)
    {
        if(PreviousValue !="")
        {
            if(CtrlTxtID == "txtAltPriceCost") // Header Price Cost Control
            {
                document.getElementById("hidPrivousValue").value = PreviousValue;
            }
            else // Detail Price Cost Control
            {
                var _hidPreviousValue = document.getElementById(CtrlTxtID.replace("_txtAltPriceCost","_hidPrivousValue")); 
                _hidPreviousValue.value = PreviousValue;
            }
        }
    }
    
    function RecalculateHeaderBasePriceCost(txtAltPriceCtlId)
    {
        if(txtAltPriceCtlId == "txtAltPriceCost") // Header update
        {
            var _txtAltPriceCost = document.getElementById(txtAltPriceCtlId); 
            var _lblBasePriceCost = document.getElementById("lblBasePriceCost"); 
            var _txtPFCItemNo = document.getElementById("txtPFCItemNo"); 
            var _hidBasePriceCost = document.getElementById("hidBasePriceCost"); 
            var _hidSellStockUM = document.getElementById("hidSellStockUM"); 
            var _hidPrivousValue = document.getElementById("hidPrivousValue"); 
            
            if(_hidPrivousValue.value != _txtAltPriceCost.value)
            {
                var _basePrice = PriceCostMaint.CalculateBasePriceCost(_txtPFCItemNo.value,_txtAltPriceCost.value).value;                                 
                if(_basePrice != "")
                {
                    _lblBasePriceCost.innerHTML = _basePrice + " / " + _hidSellStockUM.value;
                    _hidBasePriceCost.value = _basePrice;
                }
                else
                {
                    alert("Overlay Base Price Cost Calculation Failed. Please Try Again.");  
                    _hidBasePriceCost.value = "";              
                    return;
                }
            }
        }
        else // Grid lines update
        {
            var _hidPreviousValue = document.getElementById(txtAltPriceCtlId.replace("_txtAltPriceCost","_hidPrivousValue")); 
            var _txtAltPriceCtlId = document.getElementById(txtAltPriceCtlId);
            var _lblPFCItemNo =  document.getElementById(txtAltPriceCtlId.replace("_txtAltPriceCost","_lblPFCItemNo"));  
            var _lblChangeId =  document.getElementById(txtAltPriceCtlId.replace("_txtAltPriceCost","_lblChangeId"));  
            var _lblChangeDt =  document.getElementById(txtAltPriceCtlId.replace("_txtAltPriceCost","_lblChangeDt"));  
            var _lblOverlayPriceCost = document.getElementById(txtAltPriceCtlId.replace("_txtAltPriceCost","_lblOverlayPriceCost"));
            var _hidpCostId = document.getElementById(txtAltPriceCtlId.replace("_txtAltPriceCost","_hidPriceCostId"));
            var currentTxtCtlId = txtAltPriceCtlId.replace("_txtAltPriceCost","").replace("dgPriceCost_ctl","");   
            var _basePriceCost ;
            
            if(_hidPreviousValue.value != _txtAltPriceCtlId.value)
            {
                _basePriceCost = PriceCostMaint.UpdateGridAltPrice(_lblPFCItemNo.innerHTML,_txtAltPriceCtlId.value, _hidpCostId.value).value;   
                
                if( _basePriceCost[0] != "")
                {
                     _lblOverlayPriceCost.innerHTML = _basePriceCost[0];
                     _lblChangeId.innerHTML = _basePriceCost[1];
                     _lblChangeDt.innerHTML = _basePriceCost[2];
                     
                }
                else
                {
                    alert('Overlay alt. price cost update failed.');
                    document.getElementById(currentTxtCtlId).focus();  
                }
            }                       
            
//            if( _basePriceCost != "")
//            {                
//                // Set focus to next text box 
//                var nextTxtCtlId = parseInt(currentTxtCtlId) + 1;
//                var nextCtl;
//                
//                if(nextTxtCtlId <= 9)                
//                    nextCtl = txtAltPriceCtlId.replace(currentTxtCtlId, "0" + nextTxtCtlId);
//                else
//                    nextCtl = txtAltPriceCtlId.replace(currentTxtCtlId, nextTxtCtlId);
//                    
//                if(document.getElementById(nextCtl) != null)
//                    document.getElementById(nextCtl).focus();  
//            }
//            else
//            {
//                alert('Overlay alt. price cost update failed.');
//                document.getElementById(currentTxtCtlId).focus();  
//            }
                
            return false; 
           
            
        }
    }
     
    function EnterToTab(e,ctlId)
    {
        if(event.keyCode ==13)
        {    
            event.keyCode = 9; 
            return event.keyCode;
        }
    }
    </script>

</head>
<body scroll="no" onclick="javascript:document.getElementById('lblMessage').innerText='';"
    onunload="javascript:UnloadPage();" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';if(document.getElementById('divToolTips')!=null)document.getElementById('divToolTips').style.display = 'none';">
    <form id="form1" runat="server" defaultfocus="txtSearchItemNo">
        <asp:ScriptManager ID="scmPriceCost" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable" class="blueBorder"
            style="border-collapse: collapse;">
            <tr>
                <td style="border-bottom: 1px solid #88D2E9;">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="Left2pxPadd boldText lightBlueBg">
                    <asp:UpdatePanel ID="upnlbtnSearch" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
                                <table width="100%" border="0">
                                    <tr>
                                        <td>
                                            <table id="tblSearchBar" border="0" cellpadding="0" cellspacing="0" runat="server">
                                                <tr>
                                                    <td style="padding-left: 5px;">
                                                        <asp:Label ID="Label1" runat="server" Text="Item Number:" Width="75px" Font-Bold="True"></asp:Label></td>
                                                    <td>
                                                    </td>
                                                    <td style="padding-right: 10px;" align="left">
                                                        <asp:TextBox ID="txtSearchItemNo" runat="server" CssClass="FormCtrl" Width="100px"
                                                            OnFocus="javascript:this.select();" OnKeyPress="javascript:if(event.keyCode==13)zItem(this.value,this.id);"
                                                            TabIndex="1"></asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Location:" Width="51px"></asp:Label></td>
                                                    <td style="padding-right: 10px;">
                                                        <asp:DropDownList ID="ddlSearchLocation" runat="server" CssClass="FormCtrl" Height="20px"
                                                            Width="125px" TabIndex="2">
                                                        </asp:DropDownList></td>
                                                    <td>
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td>
                                                                    Category:
                                                                </td>
                                                                <td style="padding-right: 10px;" align="left">
                                                                    <asp:TextBox ID="txtCategory" TabIndex="3" runat="server" Width="35px" CssClass="FormCtrl"
                                                                        Text=""></asp:TextBox>
                                                                </td>
                                                                <td style="padding-right: 2px;">
                                                                    Size:</td>
                                                                <td style="padding-right: 10px;">
                                                                    <asp:TextBox ID="txtSize" TabIndex="4" runat="server" Width="35px" CssClass="FormCtrl"
                                                                        Text=""></asp:TextBox>
                                                                </td>
                                                                <td style="padding-right: 2px;">
                                                                    Variance:</td>
                                                                <td style="padding-right: 10px;">
                                                                    <asp:TextBox ID="txtVar" TabIndex="5" runat="server" Width="35px" CssClass="FormCtrl"
                                                                        Text=""></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td style="padding-left: 10px;">
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td style="width: 80px">
                                                                    <asp:ImageButton ID="btnSearch" runat="server" ImageUrl="~/MaintenanceApps/Common/images/BtnSearch.gif"
                                                                        OnClick="btnSearch_Click" CausesValidation="False" TabIndex="6" /></td>
                                                            </tr>
                                                        </table>
                                                        <asp:HiddenField ID="hidPrimaryKey" runat="server" />
                                                        <asp:HiddenField ID="hidFileName" Value="" runat="server" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <table id="tblVendorMaint" runat="server" width="100%" border="0" cellpadding="0"
                        cellspacing="0">
                        <tr>
                            <td>
                                <table id="tblPriceMaintHeader" runat="server" style="border-top: 0px solid #88D2E9;
                                    padding-right: 0px solid #88D2E9;" width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="lightBlueBg">
                                            <asp:Label ID="lblHeading" runat="server" Text="Price Cost Overlay Maintenance" CssClass="BanText"></asp:Label></td>
                                        <td align="right" class="lightBlueBg" valign="middle">
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="padding-right: 10px;">
                                                        <asp:ImageButton ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            runat="server" CausesValidation="False" OnClick="ibtnExcelExport_Click" TabIndex="12" /></td>
                                                    <td style="padding-right: 10px;">
                                                        <asp:UpdatePanel ID="pnlVendorMaint" runat="server" UpdateMode="Conditional">
                                                            <ContentTemplate>
                                                                <asp:ImageButton ID="btnAdd" ImageUrl="~/MaintenanceApps/Common/images/newadd.gif"
                                                                    runat="server" CausesValidation="False" OnClick="btnAdd_Click" TabIndex="13" style="padding-top:3px;" />
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                    <td style="padding-right: 10px;">
                                                        <img id="CloseButton" src="Common/images/close.jpg" onclick="javascript:parent.window.close();"
                                                            tabindex="14" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="padding-top: 0px; padding-left: 5px;">
                                            <asp:UpdatePanel ID="upnlEntry" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:Panel ID="Panel1" runat="server">
                                                        <table border="0" cellpadding="2" cellspacing="2" id="tblDataEntry" runat="server">
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Item Number:" Width="77px"></asp:Label></td>
                                                                <td style="width: 100px">
                                                                    <asp:TextBox ID="txtPFCItemNo" runat="server" CssClass="FormCtrl" TabIndex="7" OnKeyPress="javascript:if(event.keyCode==13)zItem(this.value,this.id);"
                                                                        Width="125px"></asp:TextBox>
                                                                    <asp:Button ID="btnGetItem" runat="server" Style="display: none;" OnClick="btnGetItem_Click"
                                                                        CausesValidation="false" />
                                                                </td>
                                                                <td style="width: 20px; height: 16px;">
                                                                </td>
                                                                <td>
                                                                    <asp:Label ID="Label10" runat="server" Font-Bold="True" Text="Overlay Base Price Cost:"
                                                                        Width="136px"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label ID="lblBasePriceCost" runat="server" Font-Bold="False" Width="80px"></asp:Label>
                                                                    <asp:HiddenField ID="hidBasePriceCost" runat="server" />
                                                                    <asp:HiddenField ID="hidSellStockUM" runat="server" />
                                                                </td>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                    <asp:Label ID="Label7" runat="server" Font-Bold="True" Text="Smooth Avg:" Width="74px"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label ID="lblSmoothAvg" runat="server" Font-Bold="False" Width="80px"></asp:Label></td>
                                                                <td style="width: 20px">
                                                                </td>
                                                                <td style="width: 20px">
                                                                    <asp:Label ID="Label14" runat="server" Font-Bold="True" Text="Average:" Width="59px"></asp:Label></td>
                                                                <td style="width: 20px">
                                                                    <asp:Label ID="lblAvgCost" runat="server" Font-Bold="False" Width="80px"></asp:Label></td>
                                                                <td style="width: 20px">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Location:" Width="73px"></asp:Label></td>
                                                                <td style="width: 100px">
                                                                    <asp:DropDownList ID="ddlLocation" runat="server" CssClass="FormCtrl" Height="20px"
                                                                        Width="125px" TabIndex="8">
                                                                    </asp:DropDownList></td>
                                                                <td>
                                                                </td>
                                                                <td align="left" colspan="1">
                                                                    <asp:Label ID="Label12" runat="server" Font-Bold="True" Text="Overlay Alt. Price Cost:"
                                                                        Width="129px"></asp:Label></td>
                                                                <td align="left" colspan="1">
                                                                    <asp:TextBox ID="txtAltPriceCost" runat="server" CssClass="FormCtrl" onfocus="javascript:this.select();SetPreviousValue(this.value,this.id);"
                                                                        onkeydown="javascript:if((event.keyCode==13 )&& (this.value != '')){ EnterToTab(event,this.id); }"
                                                                        onblur="javascript:return RecalculateHeaderBasePriceCost(this.id); return false;"
                                                                        TabIndex="9" Width="81px"></asp:TextBox>
                                                                    <asp:HiddenField ID="hidPrivousValue" runat="server" Value="" />
                                                                </td>
                                                                <td align="left" colspan="1">
                                                                </td>
                                                                <td align="left" colspan="1">
                                                                    <asp:Label ID="Label11" runat="server" Font-Bold="True" Text="Replacement:" Width="71px"></asp:Label></td>
                                                                <td align="left" colspan="1">
                                                                    <asp:Label ID="lblRplCost" runat="server" Font-Bold="False" Width="80px"></asp:Label></td>
                                                                <td align="left" colspan="1">
                                                                </td>
                                                                <td align="left" colspan="1">
                                                                    <asp:Label ID="Label15" runat="server" Font-Bold="True" Text="Pirce Cost:" Width="62px"></asp:Label></td>
                                                                <td align="left" colspan="1">
                                                                    <asp:Label ID="lblPriceCost" runat="server" Font-Bold="False" Width="80px"></asp:Label></td>
                                                                <td align="left" colspan="1">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;<asp:Label ID="Label8" runat="server" Font-Bold="True" Text="Description:"
                                                                        Width="68px"></asp:Label></td>
                                                                <td colspan="4">
                                                                    <asp:Label ID="lblPFCItemDesc" runat="server" Width="258px"></asp:Label></td>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                    <asp:Label ID="Label16" runat="server" Font-Bold="True" Text="Entry ID:" Width="48px"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label ID="lblEntryId" runat="server" Font-Bold="False" Width="80px"></asp:Label></td>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                    <asp:Label ID="Label19" runat="server" Font-Bold="True" Text="Change ID:" Width="62px"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label ID="lblChangeId" runat="server" Font-Bold="False" Width="80px"></asp:Label></td>
                                                                <td>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label6" runat="server" Font-Bold="True" Text="Sell UM:" Width="73px"></asp:Label></td>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="lblSellUM" runat="server" Width="126px"></asp:Label></td>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                    <asp:Label ID="Label17" runat="server" Font-Bold="True" Text="Entry Dt:" Width="51px"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label ID="lblEntryDt" runat="server" Font-Bold="False" Width="80px"></asp:Label></td>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                    <asp:Label ID="Label21" runat="server" Font-Bold="True" Text="Change Dt:" Width="64px"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label ID="lblChangeDt" runat="server" Font-Bold="False" Width="80px"></asp:Label></td>
                                                                <td>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="height: 16px">
                                                                    <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="Sell Stock:" Width="73px"></asp:Label></td>
                                                                <td style="width: 100px; height: 16px">
                                                                    <asp:Label ID="lblSellStock" runat="server" Width="126px"></asp:Label></td>
                                                                <td>
                                                                </td>
                                                                <td style="height: 16px">
                                                                </td>
                                                                <td style="height: 16px">
                                                                </td>
                                                                <td style="height: 16px">
                                                                </td>
                                                                <td style="height: 16px">
                                                                </td>
                                                                <td style="height: 16px">
                                                                </td>
                                                                <td style="height: 16px">
                                                                </td>
                                                                <td style="height: 16px">
                                                                </td>
                                                                <td style="height: 16px">
                                                                </td>
                                                                <td style="height: 16px">
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="lightBlueBg blueBorder" align="left" colspan="2" style="border-right: medium none;
                                            border-top: medium none; border-left: medium none; padding-top: 1px; border-bottom: 1px solid #88D2E9;
                                            height: 25px;">
                                            <asp:UpdatePanel ID="upnlButtons" UpdateMode="conditional" runat="server">
                                                <ContentTemplate>
                                                    <table border="0">
                                                        <tr>
                                                            <td width="80px">
                                                                &nbsp;
                                                            </td>
                                                            <td class="lightBlueBg" style="padding-top: 1px; height: 25px; text-align: left;
                                                                border: none;">
                                                                <asp:ImageButton ID="btnSave" ImageUrl="~/MaintenanceApps/Common/images/BtnSave.gif"
                                                                    runat="server" OnClick="btnSave_Click" Visible="false" TabIndex="10" OnClientClick="javascript:return DisplayRankingWarning();" /></td>
                                                            <td class="lightBlueBg" style="padding-top: 1px; height: 25px; text-align: right;
                                                                border: none; padding-left: 0px; padding-right: 10px;">
                                                                <asp:ImageButton ID="btnCancel" ImageUrl="~/MaintenanceApps/Common/images/cancel.png"
                                                                    runat="server" TabIndex="11" Visible="false" OnClick="btnCancel_Click1" /></td>
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
                                <asp:UpdatePanel ID="upnlGrid" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <table id="tblGrid" runat="server" width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="padding-top: 1px; height: 7px;" colspan="2">
                                                    <div id="divdatagrid" runat="server" class="Sbar" style="overflow-x: auto; overflow-y: auto;
                                                        position: relative; top: 0px; left: 0px; height: 360px; width: 1020px; border: 0px solid;"
                                                        align="left">
                                                        <asp:DataGrid CssClass="grid" ID="dgPriceCost" GridLines="both" Width="1020" runat="server"
                                                            AutoGenerateColumns="false" AllowSorting="True" ShowFooter="False" OnItemCommand="dgPriceCost_ItemCommand"
                                                            OnSortCommand="dgPriceCost_SortCommand" OnItemDataBound="dgPriceCost_ItemDataBound"
                                                            TabIndex="-1" AllowPaging="true">
                                                            <HeaderStyle CssClass="GridHead" Height="19px" BackColor="#DFF3F9" HorizontalAlign="Center" />
                                                            <ItemStyle CssClass="item" />
                                                            <FooterStyle CssClass="lightBlueBg" />
                                                            <Columns>
                                                                <asp:TemplateColumn HeaderText="Actions">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                                            Style="padding-left: 5px" runat="server" CommandName="Edit" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pCostCalcPriceCostOverlayID")%>'>Edit</asp:LinkButton>
                                                                        <asp:LinkButton ID="lnlDelete" CausesValidation="false" Font-Underline="true" ForeColor="#cc0000"
                                                                            Style="padding-left: 5px" runat="server" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                                            CommandName="Delete" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pCostCalcPriceCostOverlayID")%>'>Delete</asp:LinkButton>
                                                                    </ItemTemplate>
                                                                    <ItemStyle Width="80px" Height="20px" />
                                                                </asp:TemplateColumn>
                                                                <asp:TemplateColumn HeaderText="Item #" SortExpression="ItemNo">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblPFCItemNo" Text='<%#DataBinder.Eval(Container,"DataItem.ItemNo")%>'
                                                                            Width="100px" runat="server"></asp:Label>
                                                                    </ItemTemplate>
                                                                    <ItemStyle Width="100px" HorizontalAlign="Left" />
                                                                    <HeaderStyle Width="100px" />
                                                                </asp:TemplateColumn>
                                                                <asp:BoundColumn DataField="Branch" HeaderText="Location" SortExpression="Branch">
                                                                    <ItemStyle Width="40px" HorizontalAlign="Center" />
                                                                    <HeaderStyle Width="50px" />
                                                                </asp:BoundColumn>
                                                                <asp:TemplateColumn HeaderText="Base PriCost" SortExpression="OverlayPriceCost">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblOverlayPriceCost" Text='<%#DataBinder.Eval(Container,"DataItem.OverlayPriceCost")%>'
                                                                            Width="76px" runat="server"></asp:Label>
                                                                    </ItemTemplate>
                                                                    <ItemStyle Width="76px" HorizontalAlign="Right" />
                                                                    <HeaderStyle Width="76px" />
                                                                </asp:TemplateColumn>
                                                                <asp:TemplateColumn HeaderText="Base Alt. PriCost">
                                                                    <ItemTemplate>
                                                                        <asp:TextBox ID="txtAltPriceCost" CssClass="FormCtrl" Text='<%#DataBinder.Eval(Container,"DataItem.OverlayPriceCostAlt")%>'
                                                                            onfocus="javascript:this.select();SetPreviousValue(this.value,this.id);" 
                                                                            onkeydown="javascript:if((event.keyCode==13 )&& (this.value != '')){ EnterToTab(event,this.id); }"
                                                                            onblur="javascript:RecalculateHeaderBasePriceCost(this.id);" Width="67px" Style="text-align: right;"
                                                                            runat="server"></asp:TextBox>
                                                                        <asp:HiddenField ID="hidPrivousValue" runat="server" Value="" />
                                                                        <asp:HiddenField ID="hidPriceCostId" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.pCostCalcPriceCostOverlayID")%>' />
                                                                    </ItemTemplate>
                                                                    <ItemStyle Width="67px" HorizontalAlign="Right" />
                                                                    <HeaderStyle Width="67px" />
                                                                </asp:TemplateColumn>
                                                                <asp:BoundColumn DataField="SmoothAvgCost" HeaderText="IB Smooth Avg Cost" SortExpression="SmoothAvgCost">
                                                                    <ItemStyle Width="60px" HorizontalAlign="Right" />
                                                                    <HeaderStyle Width="60px" />
                                                                </asp:BoundColumn>
                                                                <asp:BoundColumn DataField="RplCost" HeaderText="IB RplCost" SortExpression="RplCost">
                                                                    <ItemStyle Width="60px" HorizontalAlign="Right" />
                                                                    <HeaderStyle Width="60px" />
                                                                </asp:BoundColumn>
                                                                <asp:BoundColumn DataField="AvgCost" HeaderText="IB AvgCost" SortExpression="AvgCost">
                                                                    <ItemStyle Width="60px" HorizontalAlign="Right" />
                                                                    <HeaderStyle Width="60px" />
                                                                </asp:BoundColumn>
                                                                <asp:BoundColumn DataField="IBPriceCostAlt" HeaderText="IB PriceCost" SortExpression="IBPriceCostAlt">
                                                                    <ItemStyle Width="60px" HorizontalAlign="Right" />
                                                                    <HeaderStyle Width="60px" />
                                                                </asp:BoundColumn>
                                                                <asp:BoundColumn DataField="EntryID" HeaderText="Entry ID" SortExpression="EntryID">
                                                                    <ItemStyle Width="80px" HorizontalAlign="Left" />
                                                                    <HeaderStyle Width="80px" />
                                                                </asp:BoundColumn>
                                                                <asp:BoundColumn DataField="EntryDt" HeaderText="Enter Date" DataFormatString="{0:MM/dd/yyyy}"
                                                                    SortExpression="EntryDt">
                                                                    <ItemStyle Width="80px" HorizontalAlign="Left" />
                                                                    <HeaderStyle Width="80px" />
                                                                </asp:BoundColumn>
                                                                <asp:TemplateColumn HeaderText="Change ID" SortExpression="ChangeID">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblChangeId" Text='<%#DataBinder.Eval(Container,"DataItem.ChangeID")%>'
                                                                            Width="80px" runat="server"></asp:Label>
                                                                    </ItemTemplate>
                                                                    <ItemStyle Width="80px" HorizontalAlign="Left" />
                                                                    <HeaderStyle Width="80px" />
                                                                </asp:TemplateColumn>
                                                                <asp:TemplateColumn HeaderText="Change Dt" SortExpression="ChangeDt">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblChangeDt" Text='<%#DataBinder.Eval(Container,"DataItem.ChangeDt")%>'
                                                                            Width="80px" runat="server"></asp:Label>
                                                                    </ItemTemplate>
                                                                    <ItemStyle Width="80px" HorizontalAlign="Left" />
                                                                    <HeaderStyle Width="80px" />
                                                                </asp:TemplateColumn>
                                                            </Columns>
                                                            <PagerStyle Visible="False" />
                                                        </asp:DataGrid>
                                                        <input type="hidden" id="hidSort" runat="server" tabindex="12" />
                                                        <input type="hidden" id="hidpVedorItemsID" runat="server" />
                                                        <input type="hidden" id="hidPageMode" runat="server" />
                                                        <input type="hidden" id="hidLeftMenuMode" runat="server" />
                                                        <input type="hidden" runat="server" id="hidSortExpression" />
                                                        <asp:Button ID="btnSort" runat="server" Text="" Style="display: none;" OnClick="btnSort_Click" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="lightBlueBg" width="100%" colspan="2">
                                                    <uc5:Pager ID="Pager1" runat="server" OnBubbleClick="Pager_PageChanged" />
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
                <td colspan="2" class="lightBlueBg buttonBar" height="20px">
                    <table width="100%">
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="false" DisplayAfter="0">
                                    <ProgressTemplate>
                                        <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                            <td align="right">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="width: 1253px">
                    <uc2:Footer ID="PageFooter" Title="Price Cost Overlay Maintenance" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
