<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BranchAvailable.aspx.cs"
    Inherits="BranchAvailable" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <script>
    var VirtualAvailabilityWindow;
    var FoundSKUStdCell;
    var FoundSKUStdCost;
    var FoundSKUAvgCell;
    var FoundSKUAvgCost;
    var FoundSKUReplCell;
    var FoundSKUReplCost;
    var ShowSubstituteWindow;
    
    function pageUnload() {
        SetScreenPos("BranchAvail");
        if ((VirtualAvailabilityWindow != null) && (!VirtualAvailabilityWindow.closed)) 
            {VirtualAvailabilityWindow.close();VirtualAvailabilityWindow=null;}
    }
    function ClosePage()
    {
        window.close();	
    }
    function OpenHelp(topic)
    {
        window.open('WorkSheetHelp.aspx#' + topic + '','WorkSheetHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
    }
    function OpenVirtualAvailability(VirtualLoc)
    {
        var VirtualURL = 'BranchAvailable.aspx?ItemNumber=' + $get("ItemNoTextBox").value + '&Virtual=' + VirtualLoc
         + '&ShipLoc=' + $get("ReqLocTextBox").value + '&RequestedQty=' + $get("ReqQtyHidden").value
          + '&AltQty=' + $get("AltQtyHidden").value + '&AvailableQty=' + $get("ReqAvailHidden").value;
        VirtualAvailabilityWindow = OpenAtPos('VirtualAvail', VirtualURL, 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 600, 600); 
    }
    function ZItem(itemNo)
    {
        var section="";
        var completeItem=0;
        var ZItemInd=$get("ItemPromptInd");
        event.keyCode=0;
        //alert(ZItemInd.value);
        if (ZItemInd.value != 'Z')
        {
            event.keyCode=9;
            return false;
        }
        // process ZItem
        switch(itemNo.split('-').length)
        {
        case 1:
            // this is actually taken care of by the item alias search
            itemNo = "00000" + itemNo;
            itemNo = itemNo.substr(itemNo.length-5,5);
            $get("ItemNoTextBox").value=itemNo+"-";  
            break;
        case 2:
            // close if they are entering an empty part
            if (itemNo.split('-')[0] == "00000") {ClosePage()};
            section = "0000" + itemNo.split('-')[1];
            section = section.substr(section.length-4,4);
            $get("ItemNoTextBox").value=itemNo.split('-')[0]+"-"+section+"-";  
            break;
        case 3:
            section = "000" + itemNo.split('-')[2];
            section = section.substr(section.length-3,3);
            $get("ItemNoTextBox").value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
            completeItem=1;
            break;
        }
        if (completeItem==1) $get("ReqLocTextBox").focus();
        return false;
    }

    function RemoteQty(CurQty)
    {
        var curLine = parseInt(CurQty.id.split("_")[1].substr(3), 10)-1;
        //alert(prevControl);
        if (event.keyCode==9 || event.keyCode==32 || event.keyCode==110 || event.keyCode==107 || event.keyCode==40) {event.keyCode=13;}
        if (event.keyCode==38 && curLine > 1) 
        {
            var prevControl = "";
            if (curLine < 10) {prevControl = CurQty.id.split("_")[0]+"_ctl0"+curLine+"_"+CurQty.id.split("_")[2];}
            if (curLine >= 10) {prevControl = CurQty.id.split("_")[0]+"_ctl"+curLine+"_"+CurQty.id.split("_")[2];}
            $get(prevControl).focus();
        }
        if (event.keyCode==13) 
        {
            var TDControl = CurQty.parentElement;
            var TRControl = TDControl.parentElement;
            var SKUMissing = $get("NoSKUOnFile").value;
            TBLControl = TRControl.parentElement;
            var PageUOM = $get("EntryUOM").value;
            if (PageUOM == "") PageUOM = $get("SellStkUOM").value;
            var QtyData = BranchAvailable.ParseQty($get("ItemNoTextBox").value, CurQty.value, PageUOM).value;
            if (QtyData.substr(0,5)=="Error")
            {
                alert(QtyData);
                event.keyCode=0;
                return false; 
            }
            else
            {
                var qtyEntered = Math.ceil(parseInt(QtyData.split(",")[0],10) * parseFloat(QtyData.split(",")[2],10));
                CurQty.value = qtyEntered;
            }
            //alert(SKUMissing);
            if (SKUMissing == "1" && !isNaN(qtyEntered) && qtyEntered>0)
            {
                // there was no sku on file
                FoundSKUStdCell = TDControl.nextSibling.nextSibling.nextSibling.nextSibling.nextSibling;
                FoundSKUStdCost = FoundSKUStdCell.firstChild;
                $get("NoSKUStdCostHidden").value = FoundSKUStdCost.value;
                FoundSKUAvgCell = FoundSKUStdCell.nextSibling;
                FoundSKUAvgCost = FoundSKUAvgCell.firstChild;
                $get("NoSKUAvgCostHidden").value = FoundSKUAvgCost.value;
                FoundSKUReplCell = FoundSKUAvgCell.nextSibling;
                FoundSKUReplCost = FoundSKUReplCell.firstChild;
                $get("NoSKUReplCostHidden").value = FoundSKUReplCost.value;
                $get("NoSKUOnFile").value = "2";
            }
            SetTotQty();
            //alert(parseInt(CurQty.id.split("_")[1].substr(3,2))-1);
            if (TotQty >= parseInt($get("ReqQtyHidden").value.replace(/,/g,""),10))
            {
                $get("QtyFilledHidden").value = "QUANTITY FILLED";
                $get("QtyFilledLabel").innerText = "QUANTITY FILLED";
                if ($get("CallingPage").value == "PriceWorksheet")
                {
                    $get("SubmitButt").focus();
                }
                if ($get("CallingPage").value == "QuoteRecall")
                {
                    $get("UpdQuoteButt").focus();
                }
                event.keyCode=0;
                return false; 
            }
            else
            {
                $get("QtyFilledHidden").value = "";
                $get("QtyFilledLabel").innerText = "";
            }
            // go through the lines
            if (curLine < RemBrCount)
            {
                event.keyCode=9;
                return true;
            }
            else
            {
                event.keyCode=0;
                return false; 
            }
        }
    }

    function SetTotQty()
    {
        TBLControl = $get("BranchQOHGrid");
        if (TBLControl != null)
        {
            TotQty = 0;
            RemBrCount = 0;
            var RemoteQtys = TBLControl.getElementsByTagName("INPUT");
            for (var i = 0, il = RemoteQtys.length; i < il; i++)
            {
                var tinput = RemoteQtys[i];
                // ignore the hidden cost fields
                if (tinput.getAttribute("type")=="text")
                {
                    var curVal =parseInt(tinput.value,10);
                    RemBrCount++;
                    if (!isNaN(curVal))
                    {
                        //alert ('We got '+tinput.getAttribute("type"));
                        TotQty += curVal;
                    }
                }
            }
            $get("FilledQtyLabel").innerHTML=TotQty.format("N0");
            $get("FilledQtyHidden").value = TotQty;
            var TotPcs = TotQty * parseInt($get("SellStkQty").value, 10)
            $get("FilledPcsLabel").innerHTML=TotPcs.format("N0");
            $get("FilledPcsHidden").value = TotPcs;
        }
    }
    
    function WriteBack()
    {
        TBLControl = $get("BranchQOHGrid");
        var ComsumedData = "";
        if (TBLControl != null)
        {
            var RemoteQtys = TBLControl.getElementsByTagName("INPUT");
            for (var i = 0, il = RemoteQtys.length; i < il; i++)
            {
                var tinput = RemoteQtys[i];
                var col;
                // ignore the hidden cost fields
                if (tinput.getAttribute("type")=="text")
                {
                    var curVal =parseInt(tinput.value,10);
                    if (!isNaN(curVal))
                    {
                        if (curVal > 0)
                        {
                            //alert ('We got '+tinput.getAttribute("type"));
                            col = tinput.parentElement.parentElement.firstChild;
                            ComsumedData += col.innerText;
                            ComsumedData += ";";
                            col = col.nextSibling;
                            ComsumedData += col.innerText;
                            ComsumedData += ";";
                            col = col.nextSibling.nextSibling;
                            ComsumedData += col.innerText;
                            ComsumedData += ";";
                            ComsumedData += tinput.value;
                            ComsumedData += ";";
                            col = col.nextSibling.nextSibling.nextSibling.nextSibling.nextSibling.nextSibling;
                            ComsumedData += col.firstChild.value;
                            ComsumedData += ";";
                            col = col.nextSibling;
                            ComsumedData += col.firstChild.value;
                            ComsumedData += ";";
                            col = col.nextSibling;
                            ComsumedData += col.firstChild.value;
                            ComsumedData += "|";
                        }
                    }
                }
            }
            window.opener.parent.document.getElementById('RemoteDataTextBox').value=ComsumedData;
        }
    }
    
    /*function ReturnToWorksheet()
    {
 
        parentWin.document.getElementById('FilledQtyLabel').innerText= 
            $get('FilledQtyLabel').innerText;
        parentWin.document.getElementById('FilledQtyHidden').value= 
            $get('FilledQtyLabel').innerText;
        parentWin.document.getElementById('SellPriceTextBox').focus();
        
    }*/

    function ReturnToQuoteRecall()
    {
        // update lines and return to calling page
        // delete the old lines first
        /*var status = BranchAvailable.DelQuoteLines($get("QuoteNumber").value, $get("ItemNoTextBox").value).value; 
        // now add the new ones
        TBLControl = $get("BranchQOHGrid");
        if (TBLControl != null)
        {
            var RemoteQtys = TBLControl.rows;
            for (var i = 1, il = TBLControl.rows.length; i < il; i++)
            {
                var tinput = TBLControl.rows[i].cells[4].firstChild;
                // ignore the hidden cost fields
                if (tinput.getAttribute("type")=="text")
                {
                    var curVal =parseInt(tinput.value,10);
                    if (!isNaN(curVal))
                    {
                        // we got a number, so do the update
                        if (curVal > 0)
                        {
                            //alert ('We got '+TBLControl.rows[i].cells[3].innerText);
                            var status = BranchAvailable.UpdQuoteLine($get("QuoteNumber").value, 
                            $get("ItemNoTextBox").value,
                            TBLControl.rows[i].cells[0].innerText,
                            TBLControl.rows[i].cells[1].innerText,
                            tinput.value,
                            TBLControl.rows[i].cells[3].innerText
                            ).value; 
                        }
                    }
                }
            }
        }*/
        window.opener.document.getElementById('RemoteDetailRefreshButton').click();
        window.close();
    }
    
    function SubmitQtys()
    {
        WriteBack();
        if ($get("CallingPage").value == "PriceWorksheet")
        {
            // user has entered sufficient qty
            window.opener.parent.document.getElementById('FilledQtyHidden').value= 
                $get('FilledQtyLabel').innerText;
            if ($get("NoSKUOnFile").value == "2")
            {
                // there was no SKU so update the costs on the page
                window.opener.parent.document.getElementById("ReplCostHidden").value = FoundSKUReplCost.value;
                window.opener.parent.document.getElementById("AvgCostHidden").value = FoundSKUStdCost.value;
                window.opener.parent.document.getElementById("StdCostHidden").value = FoundSKUAvgCost.value;
                window.opener.parent.document.getElementById("NoSKUReplCostHidden").value = FoundSKUReplCost.value;
                window.opener.parent.document.getElementById("NoSKUAvgCostHidden").value = FoundSKUStdCost.value;
                window.opener.parent.document.getElementById("NoSKUStdCostHidden").value = FoundSKUAvgCost.value;
                //alert(FoundSKUStdCost.value);
                window.opener.parent.document.getElementById('CostUpdButt').click();
                window.opener.focus();
            }
            else
            {
                window.opener.focus();
                if (window.opener.parent.document.getElementById('SellPriceTextBox').disabled)
                {
                    window.opener.parent.document.getElementById('AddItemImageButton').focus();
                }
                else
                {
                    window.opener.parent.document.getElementById('SellPriceTextBox').focus();
                }
            }
        }
        window.close();
    
    }
    function LoadOpenerData()
    {
        if ($get("CallingPage").value == "PriceWorksheet")
        {
            $get("NoSKUOnFile").value = window.opener.parent.document.getElementById('NoSKUOnFile').value;
        }    
    }
    
    function ShowSubstituteItems()
    {
        if (ShowSubstituteWindow != null) {ShowSubstituteWindow.close();}
        
        var subItemURL =  'SubstituteItemAvailable.aspx?' +
                        'ItemNumber=' + $get("ItemNoTextBox").value + '&' +
                        'ShipLoc=' + $get("ReqLocTextBox").value + '&' +
                        'RequestedQty=' + $get("ReqQtyLabel").innerHTML + '&' +
                        'AltQty=' + $get("AltQtyHidden").value + '&' +
                        'AvailableQty=' + '0' + '&' +
                        'PriceWorksheet=1&ParentButton=CostUpdButt&ParentFocus=SellPriceTextBox&Mode=SubItem';
        ShowSubstituteWindow = OpenAtPos('SubItemAvail', subItemURL, 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 600, 600);    
    }
    </script>

    <title>Availability V1.0.0</title>

    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>

    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/PriceSheetStyles.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 0px" bgcolor="#b5e7f7" onload="LoadOpenerData();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="BranchAvailableScriptManager" runat="server" EnablePartialRendering="true"
            AsyncPostBackTimeout="36000" />
        <div>
            <table width="600px">
                <tr>
                    <td class="Left5pxPadd">
                        <asp:UpdatePanel ID="HeaderUpdatePanel" runat="server">
                            <ContentTemplate>
                                <table width="595px" style="border: 1px solid #88D2E9;">
                                    <tr>
                                        <td class="Left5pxPadd" valign="top">
                                            <table>
                                                <tr>
                                                    <td class="bold">
                                                        Requested Item:
                                                    </td>
                                                    <td colspan="3">
                                                        <asp:TextBox CssClass="ws_whitebox_left" ID="ItemNoTextBox" runat="server" Text=""
                                                            Width="100px" TabIndex="1" onfocus="javascript:this.select();" onkeypress="javascript:if(event.keyCode==13){ZItem(this.value);}"></asp:TextBox>&nbsp;
                                                        <asp:HiddenField ID="ItemPromptInd" runat="server" />
                                                        <asp:HiddenField ID="SellStkQty" runat="server" />
                                                        <asp:HiddenField ID="SellStkUOM" runat="server" />
                                                        <asp:HiddenField ID="EntryUOM" runat="server" />
                                                        <asp:HiddenField ID="NoSKUOnFile" runat="server" />
                                                        <asp:HiddenField ID="NoSKUStdCostHidden" runat="server" />
                                                        <asp:HiddenField ID="NoSKUAvgCostHidden" runat="server" />
                                                        <asp:HiddenField ID="NoSKUReplCostHidden" runat="server" />
                                                        <asp:HiddenField ID="QuoteNumber" runat="server" />
                                                        <asp:HiddenField ID="QuoteLineNo" runat="server" />
                                                        <asp:HiddenField ID="CallingPage" runat="server" />
                                                        <asp:HiddenField ID="ParentButton" runat="server" />
                                                        <asp:HiddenField ID="ParentFocusField" runat="server" />
                                                        <asp:HiddenField ID="QtyFilledHidden" runat="server" />
                                                        <asp:HiddenField ID="HasProcessed" runat="server" />
                                                        <asp:HiddenField ID="ReqQtyHidden" runat="server" />
                                                        <asp:HiddenField ID="AltQtyHidden" runat="server" />
                                                        <asp:HiddenField ID="ReqAvailHidden" runat="server" />
                                                        <asp:HiddenField ID="FilledQtyHidden" runat="server" />
                                                        <asp:HiddenField ID="FilledPcsHidden" runat="server" />
                                                        <asp:HiddenField ID="QuoteFilterFieldHidden" runat="server" />
                                                        <asp:HiddenField ID="QuoteFilterValueHidden" runat="server" />
                                                        <asp:HiddenField ID="QOHCommandHidden" runat="server" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="bold">
                                                        Requested Location:
                                                    </td>
                                                    <td align="right">
                                                        <asp:TextBox CssClass="ws_whitebox_left" ID="ReqLocTextBox" runat="server" Text=""
                                                            Width="60" TabIndex="2" onfocus="javascript:this.select();" onkeypress="javascript:if(event.keyCode==13){document.form1.AvailableSubmit.click();}"></asp:TextBox>
                                                        <asp:Button ID="AvailableSubmit" name="AvailableSubmit" OnClick="AvailableSubmit_Click"
                                                            runat="server" Text="Button" Style="display: none;" />
                                                    </td>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;</td>
                                                    <td colspan="3" align="right">
                                                        <asp:UpdateProgress DisplayAfter="50" ID="HeaderUpdateProgress" runat="server">
                                                            <ProgressTemplate>
                                                                Loading....
                                                                <asp:Image ID="ProgressImage" ImageUrl="Common/Images/PFCYellowBall.gif" runat="server" />
                                                            </ProgressTemplate>
                                                        </asp:UpdateProgress>
                                                        <div style="color: Blue; font-size: 16px; font-weight: bold;">
                                                            <asp:Label ID="QtyFilledLabel" runat="server"></asp:Label></div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="bold">
                                                        Requested Quantity:
                                                    </td>
                                                    <td align="right">
                                                        <asp:Label CssClass="ws_whitebox" ID="ReqQtyLabel" runat="server" Text="" Width="60"></asp:Label>
                                                    </td>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;</td>
                                                    <td class="bold">
                                                        Pieces:
                                                    </td>
                                                    <td align="right">
                                                        <asp:Label CssClass="ws_whitebox" ID="AltQtyLabel" runat="server" Text="" Width="60"></asp:Label>
                                                    </td>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;</td>
                                                    <td class="bold">
                                                        Remote Qty:
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                        <asp:Label CssClass="ws_whitebox" Width="60px" ID="FilledQtyLabel" name="FilledQtyLabel"
                                                            runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="bold">
                                                        Requested Available:
                                                    </td>
                                                    <td align="right">
                                                        <asp:Label CssClass="ws_whitebox" ID="ReqAvailLabel" runat="server" Text="" Width="60"></asp:Label>
                                                    </td>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;</td>
                                                    <td class="bold">
                                                        Alt Available:
                                                    </td>
                                                    <td align="right">
                                                        <asp:Label CssClass="ws_whitebox" ID="AltAvailLabel" runat="server" Text="" Width="60"></asp:Label>
                                                    </td>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;</td>
                                                    <td class="bold">
                                                        Remote Pcs:
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                        <asp:Label CssClass="ws_whitebox" Width="60px" ID="FilledPcsLabel" runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="AvailableSubmit" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td class="Left5pxPadd" align="left" valign="middle">
                        <asp:Panel ID="BranchPanel" runat="server" Height="450px" Width="580px" Style="border: 1px solid #88D2E9;
                            background-color: #FFFFFF" ScrollBars="Vertical">
                            <asp:UpdatePanel ID="BranchUpdatePanel" UpdateMode="Conditional" runat="server" ChildrenAsTriggers="false">
                                <ContentTemplate>
                                    <asp:GridView ID="BranchQOHGrid" runat="server" AutoGenerateColumns="false" Width="550px"
                                        HeaderStyle-CssClass="GridHeads" OnRowDataBound="DetailRowBound" RowStyle-CssClass="priceDarkLabel"
                                        BorderStyle="None" BorderWidth="0" HeaderStyle-BackColor="#B0E0E6">
                                        <AlternatingRowStyle CssClass="priceLightLabel" />
                                        <Columns>
                                            <asp:BoundField DataField="Location" HeaderText="Branch" ItemStyle-HorizontalAlign="center"
                                                ItemStyle-CssClass="r_border" ControlStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" />
                                            <asp:BoundField DataField="LocName" HeaderText="" ItemStyle-HorizontalAlign="left"
                                                ItemStyle-CssClass="r_border" ControlStyle-Width="120px" />
                                            <asp:BoundField DataField="SellGlued" HeaderText="Qty/Unit" ItemStyle-HorizontalAlign="right"
                                                ItemStyle-CssClass="r_border" ControlStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" />
                                            <asp:BoundField DataField="QOH" HeaderText="Avail." ItemStyle-HorizontalAlign="right"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-CssClass="r_border" ControlStyle-Width="100px"
                                                DataFormatString="{0:####,###,##0}" />
                                            <asp:TemplateField HeaderText="Remote" ItemStyle-HorizontalAlign="right"  ItemStyle-CssClass="r_border" HeaderStyle-HorizontalAlign="center"
                                                ControlStyle-Width="65px" ItemStyle-Width="65px">
                                                <ItemTemplate>
                                                    <asp:TextBox ID="BranchQtyTextBox" runat="server" Width="55px" CssClass="ws_whitebox"
                                                        onkeydown='return RemoteQty(this);' onfocus="javascript:this.select();" Text='<%# Eval("RemoteQty") %>'></asp:TextBox>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="SellQtyOH" HeaderText="Pieces" ItemStyle-HorizontalAlign="right"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-CssClass="r_border" ControlStyle-Width="150px"
                                                DataFormatString="{0:####,###,##0}" />
                                            <asp:BoundField DataField="Trans" HeaderText="Trans" ItemStyle-HorizontalAlign="right"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-CssClass="r_border" ControlStyle-Width="100px"
                                                DataFormatString="{0:####,###,##0}" />
                                            <asp:BoundField DataField="OTW" HeaderText="OTW" ItemStyle-HorizontalAlign="right"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-CssClass="r_border" ControlStyle-Width="100px"
                                                DataFormatString="{0:####,###,##0}" />
                                            <asp:BoundField DataField="PO" HeaderText="PO" ItemStyle-HorizontalAlign="right"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-CssClass="r_border" ControlStyle-Width="100px"
                                                DataFormatString="{0:####,###,##0}" />
                                            <asp:TemplateField ControlStyle-CssClass="gridHid" ItemStyle-CssClass="gridHid">
                                                <ItemTemplate>
                                                    <asp:HiddenField ID="RemStdCostHidden" runat="server" Value='<%# Eval("StdCost") %>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField ControlStyle-CssClass="gridHid" ItemStyle-CssClass="gridHid">
                                                <ItemTemplate>
                                                    <asp:HiddenField ID="RemAvgCostHidden" runat="server" Value='<%# Eval("AvgCost") %>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField ControlStyle-CssClass="gridHid" ItemStyle-CssClass="gridHid">
                                                <ItemTemplate>
                                                    <asp:HiddenField ID="RemReplCostHidden" runat="server" Value='<%# Eval("ReplCost") %>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField ControlStyle-CssClass="gridHid" ItemStyle-CssClass="gridHid">
                                                <ItemTemplate>
                                                    <asp:HiddenField ID="RemLocNameHidden" runat="server" Value='<%# Eval("LocName") %>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField ControlStyle-CssClass="gridHid" ItemStyle-CssClass="gridHid">
                                                <ItemTemplate>
                                                    <asp:HiddenField ID="RemQuoteHidden" runat="server" Value='<%# Eval("QuoteNumber") %>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="590px">
                            <tr>
                                <td valign=top>
                                    <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton ID="btnSubItems" runat="server" OnClientClick="ShowSubstituteItems();return false;"
                                                            ImageUrl="Common/Images/substitute.gif" onkeyDown="javascript:if(event.keyCode==9 || event.keyCode==13){this.click();return false;}"
                                                            TabIndex="5" Visible="False" /></td>
                                                    <td>
                                                        <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                                                        <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td align="right">
                                    <asp:ImageButton ID="OKButt" runat="server" OnClick="AvailableSubmit_Click" ImageUrl="Common/Images/NextItem.gif"
                                        TabIndex="4" />
                                    <asp:ImageButton ID="SubmitButt" runat="server" OnClientClick="SubmitQtys();" ImageUrl="Common/Images/Submit.gif"
                                        onkeyDown="javascript:if(event.keyCode==9 || event.keyCode==13){this.click();return false;}"
                                        TabIndex="5" />
                                    <asp:ImageButton ID="UpdQuoteButt" runat="server" ImageUrl="Common/Images/UpdateQuote.gif"
                                        OnClick="QuoteFilledButt_Click" TabIndex="20" CausesValidation="false" />
                                    <img src="Common/images/help.gif" style="cursor: hand" alt="Click here for Help"
                                        onclick="OpenHelp('BranchAvailability');" />&nbsp;&nbsp;
                                    <img src="Common/Images/close.gif" style="cursor: hand" onclick="ClosePage();" alt="Close Page">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
