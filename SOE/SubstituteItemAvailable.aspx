<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SubstituteItemAvailable.aspx.cs"
    Inherits="SubstituteItemAvailable" EnableEventValidation="false" %>

<%@ Register Src="Common/UserControls/minipager.ascx" TagName="minipager" TagPrefix="uc1" %>
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
    var parentWindHandler;
    
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
        //alert(event.keyCode);
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
            var QtyData = SubstituteItemAvailable.ParseQty($get("ItemNoTextBox").value, CurQty.value, PageUOM).value;
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
            if($get("hidPageMode").value != "selloutitem") // User Dont enter requested qty in Sell Out Item Mode 
            {
                if (TotQty >= parseInt($get("ReqQtyHidden").value.replace(/,/g,""),10))
                {
                    alert('QUANTITY FILLED');
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
            }
            // go through the lines
            if (curLine < RemBrCount)
            {
                event.keyCode=9;
                return true;
            }
            else
            {
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
                            
                            noOfLocSelected++;
                        }
                    }
                }
            }
            parentWindHandler.parent.document.getElementById('RemoteDataTextBox').value=ComsumedData;            
        }
    }
   

    function ReturnToQuoteRecall()
    {       
        window.opener.document.getElementById('RemoteDetailRefreshButton').click();
        window.close();
    }
    
    var noOfLocSelected = 0;
    function SubmitQtys()
    {
        // New Code added for Substitute item
        document.getElementById("SubmitButt").style.display = 'none';
        // Step 1: First load the pricing work sheet with new itemno & req qty
        parentWindHandler.parent.document.getElementById("CustomerItemTextBox").value = $get("ItemNoTextBox").value;
        parentWindHandler.parent.document.getElementById('RequestedQtyTextBox').value = $get('FilledQtyLabel').innerText;
        parentWindHandler.parent.document.getElementById("btnSubsItem").click()
        
        //step 2: once pricing work sheet loaded with new value write the branch split data to hidden variable
        var loopexecuted = false;
        do
        { 
            loopexecuted = true;
        }
        while ( parentWindHandler.parent.document.getElementById('RemoteDataTextBox') != null && 
                parentWindHandler.parent.document.getElementById('UseRemoteQtys') != null && 
                loopexecuted== false );
                
        // Old code copied from branch avail pop-up
        WriteBack();
        
        // This variable used in Pricing worksheet to handle split location logic
        // We need this delay to assign the value correctly to the Qty hidden control
        pausecomp(1000);             
        parentWindHandler.parent.document.getElementById('UseRemoteQtys').value = "1";
        
        if ($get("CallingPage").value == "PriceWorksheet")
        {
            // user has entered sufficient qty
            parentWindHandler.parent.document.getElementById('FilledQtyHidden').value= 
                $get('FilledQtyLabel').innerText;
            if ($get("NoSKUOnFile").value == "2")
            {
                // there was no SKU so update the costs on the page
                parentWindHandler.parent.document.getElementById("ReplCostHidden").value = FoundSKUReplCost.value;
                parentWindHandler.parent.document.getElementById("AvgCostHidden").value = FoundSKUStdCost.value;
                parentWindHandler.parent.document.getElementById("StdCostHidden").value = FoundSKUAvgCost.value;
                parentWindHandler.parent.document.getElementById("NoSKUReplCostHidden").value = FoundSKUReplCost.value;
                parentWindHandler.parent.document.getElementById("NoSKUAvgCostHidden").value = FoundSKUStdCost.value;
                parentWindHandler.parent.document.getElementById("NoSKUStdCostHidden").value = FoundSKUAvgCost.value;                
                parentWindHandler.parent.document.getElementById('CostUpdButt').click();
                parentWindHandler.focus();
            }
            else
            {           
                parentWindHandler.focus();
                if (parentWindHandler.parent.document.getElementById('SellPriceTextBox').disabled)
                {
                    parentWindHandler.parent.document.getElementById('AddItemImageButton').focus();
                }
                else
                {
                    //alert($get('FilledQtyLabel').innerText);
                    parentWindHandler.parent.document.getElementById('SellPriceTextBox').focus();
                }
            }
        }
        
        if($get("hidPageMode").value != 'selloutitem')
            window.opener.close();
            
       //window.close();
       document.getElementById("hidCloseWindow").value = "true";
       __doPostBack("__Page","ibtnServerCloseOnClick");
    
    }
    
    function pausecomp(millis) 
    {
        var date = new Date();
        var curDate = null;

        do { curDate = new Date(); } 
        while(curDate-date < millis);
    } 

    
    function LoadOpenerData()
    {
        parentWindHandler = window.opener;
        
        if ($get("CallingPage").value == "PriceWorksheet")
        {
            if($get("hidPageMode").value == 'selloutitem')
                parentWindHandler = window.opener;
            else             
               parentWindHandler = window.opener.opener;
            
            parentWindHandler.parent.document.getElementById('NoSKUOnFile').value;
        }    
    }
    </script>

    <title>Substitute Item Availability</title>

    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>

    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/PriceSheetStyles.css" rel="stylesheet" type="text/css" />
    <style>
    .FormCtrl {	
	border: 1px solid #cccccc;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	color: #003366;
	width: 120px;
	height: 15px;
	
}
    </style>
</head>
<body style="margin: 0px" bgcolor="#b5e7f7" onload="LoadOpenerData();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="SubItemScriptManager" runat="server" EnablePartialRendering="true"
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
                                            <table width="100%">
                                                <tr>
                                                    <td class="bold" style="width: 120px">
                                                        Requested Item:
                                                    </td>
                                                    <td colspan="3">
                                                        <asp:TextBox CssClass="ws_whitebox_left" ID="ItemNoTextBox" runat="server" Text="" ReadOnly="true"
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
                                                        <asp:HiddenField ID="hidPageMode" runat="server" Value="" />
                                                    </td>
                                                    <td colspan="1" style="width: 60px">
                                                    </td>
                                                    <td align="right" colspan="4">
                                                        <asp:Label ID="lblHeading" runat="server" Font-Bold="True" Font-Size="12pt"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td class="bold" style="width: 120px">
                                                        Requested Location:
                                                    </td>
                                                    <td align="left">
                                                        <asp:TextBox CssClass="ws_whitebox_left" ID="ReqLocTextBox" runat="server" Text=""
                                                            Width="60" TabIndex="2" onfocus="javascript:this.select();" onkeypress="javascript:if(event.keyCode==13){document.form1.AvailableSubmit.click();}"></asp:TextBox>
                                                        <asp:Button ID="AvailableSubmit" name="AvailableSubmit" OnClick="AvailableSubmit_Click"
                                                            runat="server" Text="Button" Style="display: none;" />
                                                    </td>
                                                    <td>
                                                       <asp:UpdateProgress DisplayAfter="50" ID="HeaderUpdateProgress" runat="server">
                                                            <ProgressTemplate>
                                                                Loading....
                                                            </ProgressTemplate>
                                                        </asp:UpdateProgress>
                                                        &nbsp;&nbsp;&nbsp;</td>
                                                    <td colspan="3" align="right">
                                                        <div style="color: Blue; font-size: 16px; font-weight: bold;">
                                                            <asp:Label ID="QtyFilledLabel" runat="server"></asp:Label></div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="bold" style="width: 120px">
                                                        Requested Quantity:
                                                    </td>
                                                    <td align="left" style="width: 80px">
                                                        <asp:Label CssClass="ws_whitebox" ID="ReqQtyLabel" runat="server" Text="" Width="60"></asp:Label>
                                                    </td>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;</td>
                                                    <td class="bold" style="width: 70px">
                                                        Pieces:
                                                    </td>
                                                    <td align="left" style="width: 60px">
                                                        <asp:Label CssClass="ws_whitebox" ID="AltQtyLabel" runat="server" Text="" Width="60"></asp:Label>
                                                    </td>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;</td>
                                                    <td class="bold" style="width: 71px">
                                                        Remote Qty:
                                                    </td>
                                                    <td align="left">
                                                        &nbsp;
                                                        <asp:Label CssClass="ws_whitebox" Width="60px" ID="FilledQtyLabel" name="FilledQtyLabel"
                                                            runat="server"></asp:Label>
                                                    </td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="bold" style="width: 120px">
                                                        Requested Available:
                                                    </td>
                                                    <td align="left">
                                                        <asp:Label CssClass="ws_whitebox" ID="ReqAvailLabel" runat="server" Text="" Width="60"></asp:Label>
                                                    </td>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;</td>
                                                    <td class="bold" style="width: 70px">
                                                        Alt Available:
                                                    </td>
                                                    <td align="left" style="width: 60px">
                                                        <asp:Label CssClass="ws_whitebox" ID="AltAvailLabel" runat="server" Text="" Width="60"></asp:Label>
                                                    </td>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;</td>
                                                    <td class="bold" style="width: 71px">
                                                        Remote Pcs:
                                                    </td>
                                                    <td align="left">
                                                        &nbsp;
                                                        <asp:Label CssClass="ws_whitebox" Width="60px" ID="FilledPcsLabel" runat="server"></asp:Label>
                                                    </td>
                                                    <td style="width: 40px">
                                                        &nbsp;</td>
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
                                            <asp:TemplateField HeaderText="Remote" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="r_border" HeaderStyle-HorizontalAlign="center"
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
                        <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table width="590px">
                                    <tr>
                                        <td valign="top">
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <table id="Table1" height="1" cellspacing="0" cellpadding="0" border="0">
                                                            <tr>
                                                                <td style="height: 50%">
                                                                    <table id="Table2" cellspacing="0" height="1" cellpadding="0" width="100%" border="0">
                                                                        <tr>
                                                                            <td width="10%">
                                                                                <table id="Table3" cellspacing="0" cellpadding="2" width="50%" border="0">
                                                                                    <tr>
                                                                                        <td>
                                                                                            <asp:ImageButton ID="ibtnFirst" runat="server" ImageUrl="~/Common/Images/btnlast.jpg"
                                                                                                OnClick="ibtnFirst_Click"></asp:ImageButton></td>
                                                                                        <td>
                                                                                            <asp:ImageButton ID="ibtnPrevious" runat="server" ImageUrl="~/Common/Images/btnback.jpg"
                                                                                                OnClick="ibtnPrevious_Click"></asp:ImageButton></td>
                                                                                        <td valign="middle">
                                                                                            <asp:DropDownList ID="ddlPages" runat="server" AutoPostBack="True" Style="height: 20px;"
                                                                                                CssClass="ws_whitebox" Width="50px" OnSelectedIndexChanged="ddlPages_SelectedIndexChanged">
                                                                                                <asp:ListItem Value="-1" Selected="True">--Choose Page--</asp:ListItem>
                                                                                            </asp:DropDownList></td>
                                                                                        <td>
                                                                                            <asp:ImageButton ID="btnNext" runat="server" ImageUrl="~/Common/Images/btnforward.jpg"
                                                                                                OnClick="ImageButton1_Click"></asp:ImageButton></td>
                                                                                        <td>
                                                                                            <asp:ImageButton ID="btnLast" runat="server" ImageUrl="~/Common/Images/btnfirst.jpg"
                                                                                                OnClick="btnLast_Click"></asp:ImageButton></td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                            <td>
                                                                                &nbsp;&nbsp;&nbsp;
                                                                            </td>
                                                                            <td align="center" style="width: 120px">
                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="50%" align="right">
                                                                                            <table id="Table5" cellspacing="0" cellpadding="0" border="0" height="1">
                                                                                                <tr>
                                                                                                    <td style="height: 19px">
                                                                                                        <asp:Label ID="lblRecords" runat="server" CssClass="HeaderText">Record(s):</asp:Label></td>
                                                                                                    <td style="height: 19px">
                                                                                                        &nbsp;<asp:Label ID="lblCurrentTotalRec" runat="server" CssClass="HeaderText">100</asp:Label></td>
                                                                                                    <td style="height: 19px">
                                                                                                        &nbsp;<asp:Label ID="lblOf1" runat="server" CssClass="HeaderText">of</asp:Label></td>
                                                                                                    <td style="height: 19px">
                                                                                                        &nbsp;<asp:Label ID="lblTotalNoOfRec" runat="server" CssClass="HeaderText">100</asp:Label></td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
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
                                                        <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>
                                                        <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label></td>
                                                </tr>
                                            </table>                                            
                                        </td>
                                        <td align="right" valign="top">
                                            <asp:ImageButton ID="OKButt" runat="server" OnClick="AvailableSubmit_Click" ImageUrl="Common/Images/NextItem.gif"
                                                TabIndex="4" />
                                            <asp:ImageButton ID="SubmitButt" runat="server" CausesValidation="false" OnClientClick="SubmitQtys();" ImageUrl="Common/Images/Submit.gif"
                                                onkeyDown="javascript:if(event.keyCode==9 || event.keyCode==13){this.click();return false;}"
                                                TabIndex="5" />
                                            <asp:ImageButton ID="UpdQuoteButt" runat="server" ImageUrl="Common/Images/UpdateQuote.gif"
                                                OnClick="QuoteFilledButt_Click" TabIndex="20" CausesValidation="false" />
                                            <img src="Common/images/help.gif" style="cursor: hand" alt="Click here for Help"
                                                onclick="OpenHelp('BranchAvailability');" />&nbsp;&nbsp;
                                            <img src="Common/Images/close.gif" style="cursor: hand" onclick="ClosePage();" alt="Close Page">
                                            <asp:HiddenField ID="hidCloseWindow" runat=server Value="" />
                                            <asp:ImageButton ID="ibtnServerClose" CausesValidation=false runat="server" Style="display:none;padding-right: 10px;" ImageUrl="../common/images/close.gif"
                                                OnClick="ibtnServerClose_Click" />
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
