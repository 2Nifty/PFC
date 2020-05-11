<%@ Page Language="C#" AutoEventWireup="true" CodeFile="QuoteRecall.aspx.cs" Inherits="QuoteRecall" %>

<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <script>
        var RecallAvailabilityWindow;
        var RecallAddLineWindow;
        var RecallFixLineWindow;
        var RecallCommentWindow;
        var ReviewAvailabilityWindow;
        var ReviewAddLineWindow;
        var ReviewFixLineWindow;
        var ReviewCommentWindow;
        var HeaderRatio = 0.4;
        var DetailRatio = 0.6;
        var LineDelPop = window.createPopup();
        function pageUnload() {
            SetScreenPos("QuoteRecall");
            CloseChildren();
        }
        function ClosePage()
        {
            window.close();	
        }
        function CloseChildren()
        {
             if (document.getElementById("RecallPageMode").value=="Recall")
             {
                if ((RecallAvailabilityWindow != null) && (!RecallAvailabilityWindow.closed)) {RecallAvailabilityWindow.close();RecallAvailabilityWindow=null;}
                if ((RecallAddLineWindow != null) && (!RecallAddLineWindow.closed)) {RecallAddLineWindow.close();RecallAddLineWindow=null;}
                if ((RecallCommentWindow != null) && (!RecallCommentWindow.closed)) {RecallCommentWindow.close();RecallCommentWindow=null;}
                if ((RecallFixLineWindow != null) && (!RecallFixLineWindow.closed)) {RecallFixLineWindow.close();RecallFixLineWindow=null;}
             }
             if (document.getElementById("RecallPageMode").value=="Review")
             {
                //SetScreenPos("ReviewQuote");
                if ((ReviewAvailabilityWindow != null) && (!ReviewAvailabilityWindow.closed)) {ReviewAvailabilityWindow.close();ReviewAvailabilityWindow=null;}
                if ((ReviewAddLineWindow != null) && (!ReviewAddLineWindow.closed)) {ReviewAddLineWindow.close();ReviewAddLineWindow=null;}
                if ((ReviewCommentWindow != null) && (!ReviewCommentWindow.closed)) {ReviewCommentWindow.close();ReviewCommentWindow=null;}
                if ((ReviewFixLineWindow != null) && (!ReviewFixLineWindow.closed)) {ReviewFixLineWindow.close();ReviewFixLineWindow=null;}
             }
             var status = QuoteRecall.ClearSessionTables(document.getElementById("DetailTableName").value, document.getElementById("HeaderTableName").value).value;
             //alert(status);
        }
        function OpenHelp(topic)
        {
            window.open('SOEHelp.aspx#' + topic + '','WorkSheetHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
        }
        
        function OpenSOE()
        {
            var SOEUrl = $get("SOELink").value;
   	        var hwd = window.open(SOEUrl ,'Order','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO',"");
        }
        
        /*function CreateCommentLinks(OrderNumbers)
        {
            // once the user has made an order, we allow them to do various things via links:
            // They can add comments to the order.
            // They can allocate and hold.
            // They can allocate and release.
            // They can allocate, release and hold the invoice.
            RestoreHeader();
            var LinkPanel = $get("CommentsPanel");
            var LinkTable = document.createElement("TABLE");
            LinkTable.cellSpacing="0";
            LinkTable.cellPadding="0";
            LinkTable.border="0";
            var Orders = OrderNumbers.split(" ");
            for (var i = 0, il = Orders.length; i < il; i++)
            {
                var OrderData = Orders[i].split(":");
                var Order = OrderData[0];
                var Lines = OrderData[1];
                var rx = LinkTable.insertRow(i);
                var LinkRow = document.createElement("TR");
                var LinkSeparator = document.createElement("TD");
                LinkSeparator.className = "priceLightLabel";
                LinkSeparator.style.height = "18px";
                LinkSeparator.style.width = "95%";
                LinkSeparator.style.fontWeight = "bold";
                LinkSeparator.id = "AllLinks" + Order;
                // build the cell
                var Spacer0 = document.createTextNode('Order '+Order+' Line(s): '+Lines+'  ');
                LinkSeparator.appendChild(Spacer0);
                // add a link to bring up comment entry with this order number
                var OrderLink = document.createElement("A");
                OrderLink.innerHTML="Add Comments ";
                OrderLink.href="JavaScript:DoCommentEntry('"+Order+"','"+Lines+"');";
                OrderLink.id = "CommentLink" + Order;
                LinkSeparator.appendChild(OrderLink);
                var Spacer1 = document.createTextNode('   ');
                LinkSeparator.appendChild(Spacer1);
                // add a link to allocate and hold
                var AllocLink = document.createElement("A");
                AllocLink.innerHTML="Allocate and Hold ";
                AllocLink.href="JavaScript:Alloc('"+Order+"', 'WH');";
                AllocLink.id = "Hold" + Order;
                LinkSeparator.appendChild(AllocLink);
                var Spacer2 = document.createTextNode('   ');
                LinkSeparator.appendChild(Spacer2);
                // add a link to allocate and release
                var ReleaseLink = document.createElement("A");
                ReleaseLink.innerHTML="Allocate and Release to Warehouse ";
                ReleaseLink.href="JavaScript:Alloc('"+Order+"', '');"
                ReleaseLink.id = "Release" + Order;
                LinkSeparator.appendChild(ReleaseLink);
                var Spacer3 = document.createTextNode('   ');
                LinkSeparator.appendChild(Spacer3);
                // add a link to allocate, release and hold invoice
                var HoldInvoiceLink = document.createElement("A");
                HoldInvoiceLink.innerHTML="Allocate, Release and Hold Invoice ";
                HoldInvoiceLink.href="JavaScript:Alloc('"+Order+"', 'HI');";
                HoldInvoiceLink.id = "Invoice" + Order;
                LinkSeparator.appendChild(HoldInvoiceLink);
                var Spacer4 = document.createTextNode('   ');
                LinkSeparator.appendChild(Spacer4);
                var c1 = rx.insertCell(0);
                c1.appendChild(LinkSeparator);
               // add div with order status
                var StatusDiv = document.createElement("TD");
                StatusDiv.className = "priceLightLabel";
                StatusDiv.style.height = "18px";
                StatusDiv.id = "Stat" + Order;
                StatusDiv.innerHTML="Order is being held for comments. ";
                var c2 = rx.insertCell(1);
                c2.appendChild(StatusDiv);
                //rx.appendChild(LinkRow);

            }
            LinkPanel.appendChild(LinkTable);
        }
        function Alloc(Order, HoldStat)
        {
            var LinkGroup = $get("AllLinks" + Order);
            var status = QuoteRecall.OrderAllocate(Order, HoldStat).value; 
            var StatusField = $get("Stat" + Order);
            if (status == 'true')
            {
                if (HoldStat == 'WH')
                {
                    StatusField.innerText = Order + " Allocated and HELD for Release to Warehouse.";
                }
                if (HoldStat == 'HI')
                {
                    StatusField.innerText = Order + " Allocated, RELEASED to Warehouse, Invoice Held.";
                }
                if (HoldStat == '')
                {
                    StatusField.innerText = Order + " Allocated and RELEASED to Warehouse.";
                }
                if (document.getElementById("RecallPageMode").value=="Recall")
                {
                    StatusField.style.fontWeight = "bold";
                    LinkGroup.removeChild(LinkGroup.firstChild);
                    LinkGroup.removeChild(LinkGroup.firstChild);
                    LinkGroup.removeChild(LinkGroup.firstChild);
                    LinkGroup.removeChild(LinkGroup.firstChild);
                    LinkGroup.removeChild(LinkGroup.firstChild);
                    LinkGroup.removeChild(LinkGroup.firstChild);
                    LinkGroup.removeChild(LinkGroup.firstChild);
                    LinkGroup.removeChild(LinkGroup.firstChild);
                }
                if (document.getElementById("RecallPageMode").value=="Review")
                {
                    // allocating the order causes a close page when reviewing
                    window.close();	
                }
            }
            else
            {
                StatusField.innerHTML = "Allocation failed.";
            }
        }
        function DoCommentEntry(Order, LineCount)
        {
            var LinkGroup = $get("AllLinks" + Order);
            var status = QuoteRecall.SetCommentSessionVars(LineCount).value; 
            var StatusField = $get("Stat" + Order);
            if (status == 'true')
            {
                // session variables have been set, so open comment entry
                if (document.getElementById("RecallPageMode").value=="Recall")
                {
                    RecallCommentWindow = window.open('CommentEntry.aspx?SONumber='+Order+'&LineNo=','QuoteComment','height=600,width=900,toolbar=0,scrollbars=0,status=0,resizable=YES',''); 
                }
                if (document.getElementById("RecallPageMode").value=="Review")
                {
                    ReviewCommentWindow = window.open('CommentEntry.aspx?SONumber='+Order+'&LineNo=','QuoteComment','height=600,width=900,toolbar=0,scrollbars=0,status=0,resizable=YES',''); 
                }
            }
            else
            {
                StatusField.innerHTML = "Comment process failed.";
            }
        }*/
        // Open Customer look up
        function LoadCustomerLookup(_custNo)
        {   
            var Url = "CustomerList.aspx?Customer=" + _custNo + "&ctrlName=QuoteRecall";
            window.open(Url,'CustomerList' ,'height=485,width=855,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (855/2))+',resizable=NO,scrollbars=YES','');
        }
        // Open Excel file
        function OpenExcel(ExcelFileName)
        {   
            window.open(ExcelFileName,'QRExcel' ,
            'height=700,width=1000,menubar=1,titlebar=1,toolbar=1,top='+((screen.height/2) - (700/2))+',left='+((screen.width/2) - (1000/2))+',resizable=YES,scrollbars=YES','');
            return false;
        }
    
        function RestoreHeader()
        { 
            HeaderRatio = 0.4;
            DetailRatio = 1 - HeaderRatio;
            SetHeight();
            return false;
        }
        function ToggleHeader()
        { 
            if (HeaderRatio == 0.4)
            {
                HeaderRatio = 0.1;
            }
            else
            {
                HeaderRatio = 0.4;
            }
            DetailRatio = 1 - HeaderRatio;
            SetHeight();
            return false;
        }
        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //take out room for bottom panel
            yh = yh - 100;
            // we resize differently according to quote recall or review quote
            if (document.getElementById("HeaderPanel") != null)
            {
                var HeaderPanel = $get("HeaderPanel");
                HeaderPanel.style.height = yh * HeaderRatio;  
                var QuoteDatePanel = $get("DatePanel");
                QuoteDatePanel.style.height = Math.max((yh * HeaderRatio) - 40, 10);  
                var QuoteGridPanel = $get("QuoteGridPanel");
                QuoteGridPanel.style.height = Math.max((yh * HeaderRatio) - 55, 10);  
                var DetailPanel = $get("DetailPanel");
                DetailPanel.style.height = yh * DetailRatio;  
                var DetailGridPanel = $get("DetailGridPanel");
                DetailGridPanel.style.height = (yh * DetailRatio) - 55;  
                DetailGridPanel.style.width = xw - 25;  
                var DetailGridHeightHid = $get("DetailGridHeightHidden");
                DetailGridHeightHid.value = (yh * DetailRatio) - 55;
                var DetailGridHeightHid = $get("DetailGridWidthHidden");
                DetailGridHeightHid.value = xw - 25;
            }
            else
            {
                if (document.getElementById("DetailPanel") != null)        
                {    
                    var DetailPanel = $get("DetailPanel");
                    DetailPanel.style.height = yh - 25;  
                    var DetailGridPanel = $get("DetailGridPanel");
                    DetailGridPanel.style.height = yh - 85;  
                    DetailGridPanel.style.width = xw - 25;  
                    var DetailGridHeightHid = $get("DetailGridHeightHidden");
                    DetailGridHeightHid.value = yh - 85;
                    var DetailGridHeightHid = $get("DetailGridWidthHidden");
                    DetailGridHeightHid.value = xw - 25;
                }
            }
        }
        function ShowAvailability(Quote, Item, Loc, Req, QOH)
        {
            if (RecallAvailabilityWindow != null) {RecallAvailabilityWindow.close();RecallAvailabilityWindow=null;}
            var AvailURL = 'BranchAvailable.aspx?ItemNumber=' + Item + '&ShipLoc=' + Loc + '&RequestedQty=' + 
                Req + '&AltQty=0&AvailableQty=' + QOH + '&QuoteRecall=' + Quote + 
                '&FilterField=' + $get("DetailFilterFieldHidden").value + '&FilterValue=' + $get("DetailFilterValueHidden").value;
            //alert(AvailURL);
            //RecallAvailabilityWindow=window.open(AvailURL,'RecallQOHWin','height=600,width=600,toolbar=0,scrollbars=0,status=1,resizable=YES','');  
            if (document.getElementById("RecallPageMode").value=="Recall")
            {
                RecallAvailabilityWindow = OpenAtPos('BranchAvail', AvailURL, 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 600, 600); 
            }
            if (document.getElementById("RecallPageMode").value=="Review")
            {
                ReviewAvailabilityWindow = OpenAtPos('BranchAvail', AvailURL, 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 600, 600); 
            }
            SetHeight();   
            return false;  
        }
        function ZItem(itemNo)
        {
            var section="";
            var completeItem=0;
            event.keyCode=0;
            //var ZItemInd=$get("ItemPromptInd");
            //if (ZItemInd.value != 'Z')
            //{
            //    event.keyCode=9;
            //    return false;
            //}
            // check the search type and see if it is an item search
            var searchType=$get("ddlSearchColumn");
            //alert(searchType.options[searchType.selectedIndex].value);
            if (searchType.options[searchType.selectedIndex].value == "PFCItemNo")
            {
                // process ZItem
                switch(itemNo.split('-').length)
                {
                case 1:
                    // this is actually taken care of by the item alias search
                    itemNo = "00000" + itemNo;
                    itemNo = itemNo.substr(itemNo.length-5,5);
                    $get("txtSearchText").value=itemNo+"-";  
                    break;
                case 2:
                    // close if they are entering an empty part
                    if (itemNo.split('-')[0] == "00000") {ClosePage()};
                    section = "0000" + itemNo.split('-')[1];
                    section = section.substr(section.length-4,4);
                    $get("txtSearchText").value=itemNo.split('-')[0]+"-"+section+"-";  
                    break;
                case 3:
                    section = "000" + itemNo.split('-')[2];
                    section = section.substr(section.length-3,3);
                    $get("txtSearchText").value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
                    completeItem=1;
                    break;
                }
                if (completeItem==1) $get("FindImageButton").focus();
                return false;
            }
        }
        function addLine(quoteLink)
        {
            var AddLineURL = 'PriceWorksheet.aspx?QuickQuote=1&QuoteRecall=' + $get("QuoteNoHidden").value + 
                '&CustNo=' + $get("CustNoTextBox").value + '&NextLineNo=' + $get("NextLineNo").value
            if (document.getElementById("RecallPageMode").value=="Recall")
            {
                if (RecallAddLineWindow != null) {RecallAddLineWindow.close();RecallAddLineWindow=null;}
                RecallAddLineWindow = OpenAtPos('QuoteAdd', AddLineURL, 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 1000, 560); 
            }
            if (document.getElementById("RecallPageMode").value=="Review")
            {
                if (ReviewAddLineWindow != null) {ReviewAddLineWindow.close();ReviewAddLineWindow=null;}
                ReviewAddLineWindow = OpenAtPos('QuoteAdd', AddLineURL, 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 1000, 560); 
            }
        }
        /*function ShowLine(ItemNo)
        {
             if (ItemNo.parentNode.tagName == "TD")
            {
                var LineParent = ItemNo.parentNode.parentNode;
            }
            else
            {
                var LineParent = ItemNo.parentNode.parentNode.parentNode;
            }
            var QuoteLine = LineParent.firstChild.getElementsByTagName("INPUT")[1].value;
            alert(QuoteLine);
            var FixLineURL = 'PriceWorksheet.aspx?QuickQuote=1&QuoteRecall=' + $get("QuoteNoHidden").value + 
                '&CustNo=' + $get("CustNoTextBox").value + '&QuoteLine=' + QuoteLine;
            if (document.getElementById("RecallPageMode").value=="Recall")
            {
                if (RecallFixLineWindow != null) {RecallFixLineWindow.close();RecallFixLineWindow=null;}
                RecallFixLineWindow = OpenAtPos('RecallQuoteFix', FixLineURL, 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 1000, 560); 
            }
            if (document.getElementById("RecallPageMode").value=="Review")
            {
                if (ReviewFixLineWindow != null) {ReviewFixLineWindow.close();ReviewFixLineWindow=null;}
                ReviewFixLineWindow = OpenAtPos('ReviewQuoteFix', FixLineURL, 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 1000, 560); 
            }
        }*/
        function delLine(quoteItem, quoteLineNo)
        {
            var ItemControl = $get(quoteItem.id);
            var HeaderPanel = $get("HeaderPanel");
            $get("LineToDelHidden").value = quoteLineNo;
            var fieldparent = ItemControl.parentElement;
            if (event.button==2)
            {
                // Right mouse clicked. Allow line delete
                var posx = parseInt(fieldparent.getAttribute('offsetLeft'), 10)+80;
                if (HeaderPanel == null)
                {
                    var posy = parseInt(fieldparent.getAttribute('offsetTop'), 10)+50;
                }
                else
                {
                    var posy = parseInt(fieldparent.getAttribute('offsetTop'), 10)+parseInt(HeaderPanel.style.height, 10)+50;
                }
                var oPopBody = LineDelPop.document.body;
                var BodyContents = '<SPAN style="cursor:hand" onclick="parent.window.document.form1.LineDeleteButton.click();">';
                //document.LineDeleteButton.click();
                BodyContents += '<img src="Common/images/delete.jpg" alt="Click here delete this line"  />';
                BodyContents += 'Delete</SPAN><br />';
                BodyContents += '<SPAN style="cursor:hand" onclick="parent.window.document.form1.LinePopClose.click();">'
                //BodyContents += '<SPAN onclick="document.hide();">';
                BodyContents += '<img src="Common/images/cancelrequest.gif" alt="Click here Cancel this action"  />'
                BodyContents += 'Cancel</SPAN>'
                oPopBody.style.backgroundColor = "azure";
                oPopBody.style.border = "solid aquamarine 3px";
                oPopBody.style.font = 'bold 10pt Arial, sans-serif';
                oPopBody.innerHTML = BodyContents;
                LineDelPop.show(posx, posy, 100, 48, document.body);
            }
            else
            {
                // left mouse clicked, edit the line
                if (document.getElementById("RecallPageMode").value=="Recall")
                {
                    var FixLineURL = 'PriceWorksheet.aspx?QuickQuote=1&QuoteRecall=' + $get("QuoteNoHidden").value + 
                        '&CustNo=' + $get("CustNoTextBox").value + '&QuoteLine=' + quoteLineNo;
                    if (RecallFixLineWindow != null) {RecallFixLineWindow.close();RecallFixLineWindow=null;}
                    RecallFixLineWindow = OpenAtPos('RecallQuoteFix', FixLineURL, 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 1000, 560); 
                }
                if (document.getElementById("RecallPageMode").value=="Review")
                {
                    var FixLineURL = 'PriceWorksheet.aspx?QuickQuote=1&QuoteRecall=' + $get("QuoteNoHidden").value + 
                        '&CustNo=' + $get("ReviewCustNoLabel").innerText + '&QuoteLine=' + quoteLineNo;
                    if (ReviewFixLineWindow != null) {ReviewFixLineWindow.close();ReviewFixLineWindow=null;}
                    ReviewFixLineWindow = OpenAtPos('ReviewQuoteFix', FixLineURL, 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 1000, 560); 
                }
            }
            return false;
        }
        function closeFixWindow()
        {
            if (document.getElementById("RecallPageMode").value=="Recall")
            {
                if (RecallFixLineWindow != null) {RecallFixLineWindow.close();RecallFixLineWindow=null;}
            }
            if (document.getElementById("RecallPageMode").value=="Review")
            {
                if (ReviewFixLineWindow != null) {ReviewFixLineWindow.close();ReviewFixLineWindow=null;}
            }
        }
        function delLineHide()
        {
            LineDelPop.hide();
        }
        function CheckAll()
        {
            ChangeLineCheck(true);
        }
        function UnCheckAll()
        {
            ChangeLineCheck(false);
        }
        /*function ChangeLineCheck(newState)
        {
            TBLControl = $get("DetailGridView");
            if (TBLControl != null)
            {
                TotQty = 0;
                RemBrCount = 0;
                var MakeBoxes = TBLControl.getElementsByTagName("INPUT");
                for (var i = 0, il = MakeBoxes.length; i < il; i++)
                {
                    var tinput = MakeBoxes[i];
                    // ignore the hidden cost fields
                    if (tinput.getAttribute("type")=="checkbox" && !tinput.disabled)
                    {
                        tinput.checked = newState;
                        if (tinput.parentNode.tagName == "TD")
                        {
                            var cellInputs = tinput.parentNode.getElementsByTagName("INPUT");
                        }
                        else
                        {
                            var cellInputs = tinput.parentNode.parentNode.getElementsByTagName("INPUT");
                        }
                        //alert(cellInputs.length);
                        var status = QuoteRecall.SetLineCheckBoxData(cellInputs[1].value, newState).value;
                    }
                }
            }
        }*/
        function ShowLoc(LocCode)
        {
            // replace the value with the drop down box
            var LocDropDown = document.getElementById("LocationDropDownList").cloneNode(true);
            LocDropDown.id = LocCode.id;
            LocDropDown.className = "ws_ddl";
            LocDropDown.style.display = "inline";
            for (i=0;i<LocDropDown.length;i++)
            {
                if (LocCode.innerText == LocDropDown.options[i].text.substring(0,2))
                {
                    LocDropDown.selectedIndex=i;
                }
            }
            LocCode.parentNode.replaceChild(LocDropDown,LocCode);
            var DetailGridView = $get("DetailGridView");
            DetailGridView.style.width = 1350;  
            
            //alert(status);
        }
        function ChangeLoc(LocDropDown)
        {
            // get the line
            var LineParent = LocDropDown.parentNode.parentNode;
            //alert(LocDropDown.parentNode.parentNode.firstChild.getElementsByTagName("INPUT")[1].value);
            //alert(LocDropDown.options[LocDropDown.selectedIndex].value);
            //alert(LocDropDown.options[LocDropDown.selectedIndex].text);
            //alert(document.getElementById("DetailTableName").value);
            var status = QuoteRecall.UpdLineLoc(
                LocDropDown.parentNode.parentNode.firstChild.getElementsByTagName("INPUT")[1].value
                ,LocDropDown.options[LocDropDown.selectedIndex].text.split(" - ")[0]
                ,LocDropDown.options[LocDropDown.selectedIndex].text.split(" - ")[1]
                ,document.getElementById("DetailTableName").value).value;
           //alert(status);
           var QOH = new Number(status.split(":")[0]);
           var Qty = new Number(LineParent.childNodes[5].firstChild.value.replace(/,/,""));
           if ( Qty <= QOH)          
           {
               LineParent.childNodes[7].firstChild.nextSibling.style.display = "none"; 
               LineParent.childNodes[7].firstChild.style.display = "inline"; 
               LineParent.childNodes[7].firstChild.innerText = QOH.format("n0");
           }
           else
           {
               LineParent.childNodes[7].firstChild.style.display = "none"; 
               LineParent.childNodes[7].firstChild.nextSibling.style.display = "inline"; 
               LineParent.childNodes[7].firstChild.nextSibling.className = "QOHLink";
               LineParent.childNodes[7].firstChild.nextSibling.innerText = QOH.format("n0");
           }
        }
        function ShowCarrier(CarrierCode)
        {
            // replace the value with the drop down box
            var CarDropDown = document.getElementById("CarrierDropDownList").cloneNode(true);
            CarDropDown.id = CarrierCode.id;
            CarDropDown.className = "ws_ddl";
            CarDropDown.style.display = "inline";
            for (i=0;i<CarDropDown.length;i++)
            {
                if (CarrierCode.innerText == CarDropDown.options[i].text)
                {
                    CarDropDown.selectedIndex=i;
                }
            }
            CarrierCode.parentNode.replaceChild(CarDropDown,CarrierCode);
            //alert(status);
        }
        function ChangeCarrier(CarrierDropDown)
        {
            // get the quote number from the front of the row
            //alert(CarrierDropDown.parentNode.parentNode.firstChild.getElementsByTagName("INPUT")[1].value);
            //alert(CarrierDropDown.options[CarrierDropDown.selectedIndex].value);
            //alert(CarrierDropDown.options[CarrierDropDown.selectedIndex].text);
            //alert(document.getElementById("DetailTableName").value);
            var status = QuoteRecall.UpdLineCarrier(
                CarrierDropDown.parentNode.parentNode.firstChild.getElementsByTagName("INPUT")[1].value
                ,CarrierDropDown.options[CarrierDropDown.selectedIndex].value
                ,CarrierDropDown.options[CarrierDropDown.selectedIndex].text
                ,document.getElementById("DetailTableName").value).value;
            //alert(status);
        }
        function ShowFreight(FreightCode)
        {
            // replace the value with the drop down box
            var FreightDropDown = document.getElementById("FreightDropDownList").cloneNode(true);
            FreightDropDown.id = FreightCode.id;
            FreightDropDown.className = "ws_ddl";
            FreightDropDown.style.display = "inline";
            for (i=0;i<FreightDropDown.length;i++)
            {
                if (FreightCode.innerText == FreightDropDown.options[i].text)
                {
                    FreightDropDown.selectedIndex=i;
                }
            }
            FreightCode.parentNode.replaceChild(FreightDropDown,FreightCode);
            //alert(status);
        }
        function ChangeFreight(FreightDropDown)
        {
            // get the quote number from the front of the row
            //alert(FreightDropDown.parentNode.parentNode.firstChild.getElementsByTagName("INPUT")[1].value);
            var status = QuoteRecall.UpdLineFreight(
                FreightDropDown.parentNode.parentNode.firstChild.getElementsByTagName("INPUT")[1].value
                ,FreightDropDown.options[FreightDropDown.selectedIndex].value
                ,FreightDropDown.options[FreightDropDown.selectedIndex].text
                ,document.getElementById("DetailTableName").value).value;
            //alert(status);
        }
        function ChangeQty(QtyBox)
        {
            // get the quote number from the front of the row
            var LineParent = QtyBox.parentNode.parentNode;
           // also get the Item, Loc, and UOM
            var status = QuoteRecall.UpdLineQty(
                LineParent.firstChild.getElementsByTagName("INPUT")[1].value
                ,QtyBox.value
                ,LineParent.childNodes[3].innerText
                ,GetLineLoc(LineParent)
                ,LineParent.childNodes[6].innerText.split("/")[1]
                ,document.getElementById("DetailTableName").value
                ,document.getElementById("HeaderTableName").value
                ).value;
           //alert(status);
           $get("ExtendedWeightLabel").innerText = status.split(":")[3];
           var QOH = new Number(status.split(":")[0]);
           var Qty = new Number(QtyBox.value);
           var Price = new Number(LineParent.firstChild.getElementsByTagName("INPUT")[5].value)
           var Weight = new Number(LineParent.firstChild.getElementsByTagName("INPUT")[6].value)
           var Cost = new Number(LineParent.firstChild.getElementsByTagName("INPUT")[7].value)
           Price = Qty * Price
           Weight = Qty * Weight
           Cost = Qty * Cost
           LineParent.childNodes[10].innerText = Price.format("n");
           LineParent.childNodes[13].innerText = Weight.format("n");
           LineParent.childNodes[11].innerText = (Price-Cost).format("n");
           // if we still have enough, update the line. Otherwise refresh the line so the link will show
           if ( Qty <= QOH)          
           {
               LineParent.childNodes[7].firstChild.nextSibling.style.display = "none"; 
               LineParent.childNodes[7].firstChild.style.display = "inline"; 
               LineParent.childNodes[7].firstChild.innerText = QOH.format("n0");
           }
           else
           {
               LineParent.childNodes[7].firstChild.style.display = "none"; 
               LineParent.childNodes[7].firstChild.nextSibling.style.display = "inline"; 
               LineParent.childNodes[7].firstChild.nextSibling.className = "QOHLink";
               LineParent.childNodes[7].firstChild.nextSibling.innerText = QOH.format("n0");
           }
           // update the header grid if needed
           if (document.getElementById("QuoteGridView") != null)
            {
                var HeaderPanel = $get("QuoteGridView").firstChild;
                // find the line for the quote we are working on
                for (r = 1; r < HeaderPanel.childNodes.length; r++)
                {
                    if (LineParent.childNodes[1].innerText == HeaderPanel.childNodes[r].childNodes[0].innerText)
                    {
                        HeaderPanel.childNodes[r].childNodes[3].innerText = status.split(":")[1];
                        HeaderPanel.childNodes[r].childNodes[4].innerText = status.split(":")[2];
                        HeaderPanel.childNodes[r].childNodes[2].innerText = status.split(":")[3];
                        //alert(HeaderPanel.childNodes[r].childNodes[0].innerText);
                    }
                }
            }
           LineParent.childNodes[14].firstChild.focus();
        }
        function ChangePrice(PriceBox)
        {
            // get the quote number from the front of the row
            var LineParent = PriceBox.parentNode.parentNode;
           // also get the Item, Loc, and UOM
            var status = QuoteRecall.UpdLinePrice(
                LineParent.firstChild.getElementsByTagName("INPUT")[1].value
                ,PriceBox.value
                ,LineParent.childNodes[3].innerText
                ,GetLineLoc(LineParent)
                ,LineParent.childNodes[6].innerText.split("/")[1]
                ,document.getElementById("DetailTableName").value
                ,document.getElementById("HeaderTableName").value
                ).value;
           if (status.substr(0,2)=="!!")
           {
               alert(status);
           }
           var Qty = new Number(LineParent.childNodes[5].getElementsByTagName("INPUT")[0].value);
           var Price = new Number(status.split(":")[0]);
           LineParent.firstChild.getElementsByTagName("INPUT")[5].value = Price;
           var Cost = new Number(LineParent.firstChild.getElementsByTagName("INPUT")[7].value)
           Price = Qty * Price
           Cost = Qty * Cost
           LineParent.childNodes[10].innerText = Price.format("n");
           LineParent.childNodes[11].innerText = (Price-Cost).format("n");
           LineParent.childNodes[12].innerText = (100*(Price-Cost)/Price).format("n");
           // update the header grid if needed
           if (document.getElementById("QuoteGridView") != null)
            {
                var HeaderPanel = $get("QuoteGridView").firstChild;
                // find the line for the quote we are working on
                for (r = 1; r < HeaderPanel.childNodes.length; r++)
                {
                    if (LineParent.childNodes[1].innerText == HeaderPanel.childNodes[r].childNodes[0].innerText)
                    {
                        HeaderPanel.childNodes[r].childNodes[3].innerText = status.split(":")[1];
                        HeaderPanel.childNodes[r].childNodes[4].innerText = status.split(":")[2];
                        //alert(HeaderPanel.childNodes[r].childNodes[0].innerText);
                    }
                }
            }
           LineParent.childNodes[14].firstChild.focus();
        }
        // Make order check box
        function FlipMakeOrder(CurCheckBox)
        {
            if (CurCheckBox.parentNode.tagName == "TD")
            {
                var cellInputs = CurCheckBox.parentNode.getElementsByTagName("INPUT");
                var LineParent = CurCheckBox.parentNode.parentNode;
            }
            else
            {
                var cellInputs = CurCheckBox.parentNode.parentNode.getElementsByTagName("INPUT");
                var LineParent = CurCheckBox.parentNode.parentNode.parentNode;
            }
            //alert(LineParent.firstChild.nextSibling.nextSibling.nextSibling.innerText);
            //alert(cellInputs[1].value);
            //alert(CurCheckBox.checked);
            //alert(LineParent.childNodes[3].innerText);
            //alert(LocValue);
            //alert(LineParent.childNodes[6].innerText.split("/")[1]);
            var status = QuoteRecall.SetLineCheckBoxData(
                cellInputs[1].value
                ,CurCheckBox.checked
                ,LineParent.childNodes[3].innerText
                ,GetLineLoc(LineParent)
                ,LineParent.childNodes[6].innerText.split("/")[1]
                ,document.getElementById("DetailTableName").value
                ).value;
           // alert(status);
           if (CurCheckBox.checked)
           {
                // if they have selected the line, check it
               var QOH = new Number(status);
               //alert(QOH);
               var Qty = new Number(LineParent.childNodes[5].firstChild.value.replace(/,/,""));
               //alert(Qty);
               // if we still have enough, update the line. Otherwise refresh the line so the link will show
               if ( Qty <= QOH)          
               {
                   LineParent.childNodes[7].firstChild.nextSibling.style.display = "none"; 
                   LineParent.childNodes[7].firstChild.style.display = "inline"; 
                   LineParent.childNodes[7].firstChild.innerText = QOH.format("n0");
               }
               else
               {
                   LineParent.childNodes[7].firstChild.style.display = "none"; 
                   LineParent.childNodes[7].firstChild.nextSibling.style.display = "inline"; 
                   LineParent.childNodes[7].firstChild.nextSibling.className = "QOHLink";
                   LineParent.childNodes[7].firstChild.nextSibling.innerText = QOH.format("n0");
               }
           }
        }
        function GetLineLoc(Line)
        {
            // find out if the location drop down is showing or  just text
            var LocNode = Line.childNodes[8].firstChild;
            var LocInputs = LocNode.getElementsByTagName("INPUT");
            var LocValue = "";
            if (LocNode.tagName == "SELECT")
            {
                LocValue = LocNode.options[LocNode.selectedIndex].text.split(" - ")[0];
            }
            else
            {
                LocValue = LocNode.innerText;
            }
            return LocValue
        }
        
        function CheckModal()
        {
            if (document.getElementById("RecallPageMode").value=="Review")
            {
                // when reviewing, we keep the focus on this page   onblur="CheckModal();"
                alert("You must complete Quote Review");
                document.getElementById("POTextBox").focus();	
            }
        }
    </script>

    <title>Quote Recall V1.0.0</title>

    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>

    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>

    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/PriceSheetStyles.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 0px" bgcolor="#b5e7f7" onload="SetHeight();" onresize="SetHeight();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="QuoteRecallScriptManager" runat="server" EnablePartialRendering="true"
            AsyncPostBackTimeout="36000" />
        <asp:SqlDataSource ID="LocationCodes" runat="server" ConnectionString="<%$ ConnectionStrings:PFCERPConnectionString %>"
            SelectCommand="select LocID as Code, LocID+' - '+LocName as Name from [LocMaster] with (NOLOCK) where LocType IN ('B', 'S') order by LocID">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="CarrierCodes" runat="server" ConnectionString="<%$ ConnectionStrings:PFCERPConnectionString %>"
            SelectCommand="select TableCd as Code, ShortDsc as Name from [Tables] with (NOLOCK) where TableType='CAR' order by TableCd">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="FreightCodes" runat="server" ConnectionString="<%$ ConnectionStrings:PFCERPConnectionString %>"
            SelectCommand="select TableCd as Code, ShortDsc as Name from [Tables] with (NOLOCK) where TableType='FGHT' and SOApp='Y' order by TableCd">
        </asp:SqlDataSource>
        <div id="maindiv">
            <asp:HiddenField ID="RecallPageMode" runat="server" />
            <asp:HiddenField ID="ReadOnly" runat="server" />
            <asp:HiddenField ID="DetailTableName" runat="server" />
            <asp:HiddenField ID="HeaderTableName" runat="server" />
            <asp:HiddenField ID="SOELink" runat="server" />
            <asp:DropDownList ID="LocationDropDownList" runat="server" DataTextField="Name" DataValueField="Code"
                CssClass="noDisplay" DataSourceID="LocationCodes" onChange="ChangeLoc(this);">
            </asp:DropDownList>
            <asp:DropDownList ID="CarrierDropDownList" runat="server" DataTextField="Name" DataValueField="Code"
                CssClass="noDisplay" DataSourceID="CarrierCodes" onChange="ChangeCarrier(this);">
            </asp:DropDownList>
            <asp:DropDownList ID="FreightDropDownList" runat="server" DataTextField="Name" DataValueField="Code"
                CssClass="noDisplay" DataSourceID="FreightCodes" onChange="ChangeFreight(this);">
            </asp:DropDownList>
            <asp:UpdatePanel ID="RefreshButtonUpdatePanel" runat="server" RenderMode="inline">
                <ContentTemplate>
                    <asp:Button ID="RemoteDetailRefreshButton" name="RemoteDetailRefreshButton" OnClick="RemoteDetailRefresh_Click"
                        OnClientClick="closeFixWindow();" runat="server" Text="Button" Style="display: none;"
                        CausesValidation="false" />
                    <asp:Button ID="DetailRefreshButton" name="DetailRefreshButton" OnClick="DetailRefresh_Click"
                        runat="server" Text="Button" Style="display: none;" CausesValidation="false" />
                </ContentTemplate>
            </asp:UpdatePanel>
            <table width="100%">
                <tr>
                    <td class="Left5pxPadd">
                        <asp:Panel ID="HeaderPanel" runat="server" Style="border: 1px solid #88D2E9; display: block;">
                            <asp:UpdatePanel ID="HeaderUpdatePanel" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <table width="100%">
                                        <tr>
                                            <td class="Left5pxPadd" valign="top" colspan="5">
                                                <table width="100%">
                                                    <tr>
                                                        <td class="bold">
                                                            Customer:
                                                        </td>
                                                        <td>
                                                            <asp:TextBox CssClass="ws_whitebox_cntr" ID="CustNoTextBox" runat="server" Text=""
                                                                OnTextChanged="WorkCustomerNumber" AutoPostBack="true" Width="60px" TabIndex="1"
                                                                onfocus="javascript:this.select();"></asp:TextBox>&nbsp;
                                                            <asp:Button ID="CustNoSubmit" name="CustNoSubmit" OnClick="WorkCustomerNumber" runat="server"
                                                                Text="Button" Style="display: none;" CausesValidation="false" />
                                                        </td>
                                                        <td align="right">
                                                            <asp:Label CssClass="ws_whitebox_left" ID="CustNameLabel" runat="server" Text=""
                                                                Width="200"></asp:Label>
                                                        </td>
                                                        <td>
                                                            &nbsp;&nbsp;&nbsp;</td>
                                                        <td>
                                                            <asp:Label ID="lblSearchBy" runat="server" Text="Search By"></asp:Label>
                                                            &nbsp;
                                                        </td>
                                                        <td>
                                                            <asp:DropDownList ID="ddlSearchColumn" runat="server" Style="font-size: 11px;">
                                                            </asp:DropDownList>
                                                            &nbsp; &nbsp;
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="Label1" runat="server" Text="Find"></asp:Label>
                                                            &nbsp;&nbsp;
                                                        </td>
                                                        <td style="width: 157px">
                                                            <asp:TextBox ID="txtSearchText" runat="server" CssClass="ws_whitebox_left" onfocus="javascript:this.select();"
                                                                onkeypress="javascript:if(event.keyCode==13){ZItem(this.value);}"></asp:TextBox>
                                                            &nbsp;&nbsp;
                                                        </td>
                                                        <td align="left">
                                                            <asp:ImageButton ID="FindImageButton" ImageUrl="~/Common/Images/searchBig.gif" OnClick="SearchQuotes"
                                                                CausesValidation="false" runat="server" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <asp:Panel ID="DatePanel" runat="server" Width="320px" ScrollBars="Vertical">
                                                    <asp:GridView ID="DateGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                                                        RowStyle-CssClass="priceDarkLabel" OnRowCommand="QuoteDaysCommand" >
                                                        <AlternatingRowStyle CssClass="priceLightLabel" />
                                                        <Columns>
                                                            <asp:BoundField DataField="QuoteDate" HeaderText="&nbsp;&nbsp;Quote Date" ItemStyle-Width="80"
                                                                DataFormatString="{0:MM/dd/yyyy}" SortExpression="QuoteDate" ItemStyle-HorizontalAlign="center"
                                                                HeaderStyle-HorizontalAlign="left" />
                                                            <asp:BoundField DataField="QuoteCount" HeaderText="&nbsp;&nbsp;Quotes" ItemStyle-Width="60"
                                                                SortExpression="QuoteNumber" ItemStyle-HorizontalAlign="right" HeaderStyle-HorizontalAlign="center" />
                                                            <asp:ButtonField CommandName="ShowDay" ButtonType="Link" Text="Show Day" ItemStyle-Width="80"
                                                                ItemStyle-HorizontalAlign="center" />
                                                            <asp:ButtonField CommandName="ShowLines" ButtonType="Link" Text="Show Lines" ItemStyle-Width="80"
                                                                ItemStyle-HorizontalAlign="center" />
                                                            <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:CheckBox runat="server" />
                                                                </ItemTemplate>
                                                                <HeaderTemplate>
                                                                    <asp:LinkButton runat="server" Text="Select" CausesValidation="false" ForeColor="Blue" CommandName="SelectDays" ></asp:LinkButton>
                                                                </HeaderTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </asp:Panel>
                                            </td>
                                            <td valign="top">
                                                <asp:UpdateProgress DisplayAfter="50" ID="HeaderUpdateProgress" runat="server">
                                                    <ProgressTemplate>
                                                        Loading....<br />
                                                        <asp:Image ID="ProgressImage" ImageUrl="Common/Images/PFCYellowBall.gif" runat="server" />
                                                    </ProgressTemplate>
                                                </asp:UpdateProgress>
                                            </td>
                                            <td valign="top">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td valign="top">
                                                Quotes on File for
                                                <asp:Label ID="FilterShowingLabel" runat="server" Text=""></asp:Label><br />
                                                <asp:Panel ID="QuoteGridPanel" runat="server" ScrollBars="Vertical" EnableViewState="true">
                                                    <asp:GridView ID="QuoteGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                                                        RowStyle-CssClass="priceDarkLabel" AllowSorting="true" OnSorting="QuoteGridViewSortCommand"
                                                        OnRowCommand="QuoteSummCommand">
                                                        <AlternatingRowStyle CssClass="priceLightLabel" />
                                                        <Columns>
                                                            <asp:BoundField DataField="Quote" HeaderText="&nbsp;&nbsp;Quote #" ItemStyle-Width="70"
                                                                SortExpression="Quote" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="left" />
                                                            <asp:BoundField DataField="QuoteLines" HeaderText="&nbsp;&nbsp;Lines" DataFormatString="{0:#,##0} "
                                                                ItemStyle-Width="40" SortExpression="QuoteLines" ItemStyle-HorizontalAlign="Right"
                                                                HeaderStyle-HorizontalAlign="left" />
                                                            <asp:BoundField DataField="QuoteWeight" HeaderText="&nbsp;&nbsp;Total Weight" DataFormatString="{0:#,##0.00} "
                                                                ItemStyle-Width="90" SortExpression="QuoteWeight" ItemStyle-HorizontalAlign="Right"
                                                                HeaderStyle-HorizontalAlign="left" />
                                                            <asp:BoundField DataField="QuoteAmount" HeaderText="&nbsp;&nbsp;Total Amount" DataFormatString="{0:#,##0.00} "
                                                                ItemStyle-Width="90" SortExpression="QuoteAmount" ItemStyle-HorizontalAlign="Right"
                                                                HeaderStyle-HorizontalAlign="left" />
                                                            <asp:BoundField DataField="QuoteMarginDols" HeaderText="Margin $&nbsp;&nbsp;" DataFormatString="{0:#,##0.00} "
                                                                ItemStyle-Width="70" SortExpression="QuoteMarginDols" ItemStyle-HorizontalAlign="Right"
                                                                HeaderStyle-HorizontalAlign="right" />
                                                            <asp:BoundField DataField="QuoteMarginPcnt" HeaderText="&nbsp;&nbsp;%" DataFormatString="{0:#,##0.00%} "
                                                                ItemStyle-Width="50" SortExpression="QuoteMarginPcnt" ItemStyle-HorizontalAlign="Right"
                                                                HeaderStyle-HorizontalAlign="center" />
                                                            <asp:BoundField DataField="UserID" HeaderText="&nbsp;&nbsp;User" ItemStyle-Width="60"
                                                                SortExpression="UserID" ItemStyle-HorizontalAlign="right" HeaderStyle-HorizontalAlign="center" />
                                                            <asp:ButtonField CommandName="ShowDetail" ButtonType="Link" Text="Quote Detail" ItemStyle-Width="85"
                                                                ItemStyle-HorizontalAlign="center" />
                                                            <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="SumSelectQuote" runat="server" />
                                                                </ItemTemplate>
                                                                <HeaderTemplate>
                                                                    <asp:LinkButton ID="SumShowQuotes" runat="server" Text="Select" ForeColor="Blue" CommandName="ShowQuotes" ></asp:LinkButton>
                                                                </HeaderTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                    <asp:GridView ID="ItemGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                                                        RowStyle-CssClass="priceDarkLabel" AllowSorting="true" OnSorting="QuoteGridViewSortCommand"
                                                        OnRowCommand="QuoteSummCommand">
                                                        <AlternatingRowStyle CssClass="priceLightLabel" />
                                                        <Columns>
                                                            <asp:BoundField DataField="Quote" HeaderText="&nbsp;&nbsp;Quote #" ItemStyle-Width="80"
                                                                SortExpression="Quote" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="left" />
                                                            <asp:BoundField DataField="QuoteDate" HeaderText="&nbsp;&nbsp;Quote Date" ItemStyle-Width="80"
                                                                DataFormatString="{0:MM/dd/yyyy}" SortExpression="QuoteDate" ItemStyle-HorizontalAlign="center"
                                                                HeaderStyle-HorizontalAlign="left" />
                                                            <asp:BoundField DataField="QuoteQty" HeaderText="&nbsp;&nbsp;Qty" DataFormatString="{0:#,##0} "
                                                                ItemStyle-Width="40" SortExpression="QuoteQty" ItemStyle-HorizontalAlign="Right"
                                                                HeaderStyle-HorizontalAlign="left" />
                                                            <asp:BoundField DataField="QuotePrice" HeaderText="&nbsp;&nbsp;Price" DataFormatString="{0:#,##0.00} "
                                                                ItemStyle-Width="60" SortExpression="QuotePrice" ItemStyle-HorizontalAlign="Right"
                                                                HeaderStyle-HorizontalAlign="left" />
                                                            <asp:BoundField DataField="QuoteAmount" HeaderText="&nbsp;&nbsp;Total Amount" DataFormatString="{0:#,##0.00} "
                                                                ItemStyle-Width="90" SortExpression="QuoteAmount" ItemStyle-HorizontalAlign="Right"
                                                                HeaderStyle-HorizontalAlign="left" />
                                                            <asp:BoundField DataField="UserID" HeaderText="&nbsp;&nbsp;User" ItemStyle-Width="60"
                                                                SortExpression="UserID" ItemStyle-HorizontalAlign="right" HeaderStyle-HorizontalAlign="center" />
                                                            <asp:ButtonField CommandName="ShowItemDetail" ButtonType="Link" Text="Quote Detail"
                                                                ItemStyle-Width="85" ItemStyle-HorizontalAlign="center" />
                                                        </Columns>
                                                    </asp:GridView>
                                                </asp:Panel>
                                            </td>
                                        </tr>
                                    </table>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </asp:Panel>
                        <asp:Panel ID="ReviewHeaderPanel" runat="server" Style="border: 1px solid #88D2E9;
                            display: block;">
                            <table>
                                <tr>
                                    <td class="bold">
                                        Customer:
                                    </td>
                                    <td>
                                        <asp:Label ID="ReviewCustNoLabel" runat="server" Text=""></asp:Label>
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;&nbsp;</td>
                                    <td align="right">
                                        <asp:Label CssClass="ws_whitebox_left" ID="ReviewCustNameLabel" runat="server" Text=""
                                            Width="200"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td class="Left5pxPadd" align="left" valign="middle">
                        <table style="border: 1px solid #88D2E9; display: block;" width="100%">
                            <tr>
                                <td>
                                    <asp:Panel ID="DetailPanel" runat="server" Width="100%">
                                        <asp:UpdatePanel ID="QuoteDetailUpdatePanel" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <asp:Panel ID="POPanel" runat="server" Width="99%" Style="border: 1px solid #88D2E9;
                                                    display: block;">
                                                    <table>
                                                        <tr>
                                                            <td class="Left5pxPadd">
                                                                <b>Purchase Order #</b>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="POTextBox" runat="server" MaxLength="20" onkeypress="javascript:if(event.keyCode==13){event.keyCode=0;}"></asp:TextBox>
                                                                <asp:HiddenField ID="QuoteNoHidden" runat="server" />
                                                                <asp:HiddenField ID="DetailFilterFieldHidden" runat="server" />
                                                                <asp:HiddenField ID="DetailFilterValueHidden" runat="server" />
                                                            </td>
                                                            <td>
                                                                &nbsp;&nbsp;&nbsp;<b>Order Extended Weight</b>&nbsp;&nbsp;
                                                                <asp:Label ID="ExtendedWeightLabel" runat="server" Text=""></asp:Label>
                                                                <asp:HiddenField ID="NextLineNo" runat="server" />
                                                            </td>
                                                            <td>
                                                                &nbsp;&nbsp;&nbsp;
                                                                <asp:ImageButton ID="MakeOrderButt" runat="server" OnClick="MakeOrder_Click" ImageUrl="Common/Images/makeorder.gif"
                                                                    CausesValidation="true" />
                                                                &nbsp;&nbsp;&nbsp;
                                                            </td>
                                                            <td align="right">
                                                                <div style="width: 70px;">
                                                                    <asp:UpdatePanel ID="PrintUpdatePanel" runat="server" UpdateMode="Conditional">
                                                                        <ContentTemplate>
                                                                            <uc1:PrintDialogue ID="PrintControl" runat="server" EnableFax="true"></uc1:PrintDialogue>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:ImageButton ID="WeightButt" runat="server" alt="Weight" ImageUrl="Common/Images/truck.jpg"
                                                                    Style="cursor: hand" Height="20px" Width="20px" />
                                                            </td>
                                                            <td>
                                                                <asp:ImageButton ID="HideHeaderButt" ImageUrl="Common/Images/TV.gif" ToolTip="Click here to Shrink/Grow Header"
                                                                    runat="server" OnClientClick="javascript:return ToggleHeader();" />
                                                                <asp:ImageButton ID="ToggleDeletedButt" ImageUrl="Common/Images/expand.gif" ToolTip="Click here to Show/Hide Deleted Lines"
                                                                    OnClick="ToggleDeleted_Click" runat="server" CausesValidation="false" />
                                                                <asp:Button ID="LineDeleteButton" OnClick="LineDelete_Click" OnClientClick="delLineHide();"
                                                                    runat="server" Text="Button" Style="display: none;" CausesValidation="false" />
                                                                <asp:Button ID="LinePopClose" OnClientClick="delLineHide();" runat="server" Text="Button"
                                                                    Style="display: none;" CausesValidation="false" />
                                                                <asp:HiddenField ID="LineToDelHidden" runat="server" />
                                                                <asp:HiddenField ID="ShowDeletedHidden" runat="server" />
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="DeletedLineStateLabel" runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="7">
                                                                &nbsp;&nbsp;&nbsp;
                                                                <asp:LinkButton ID="CheckAllLinkButton" runat="server" CausesValidation="false" OnClick="DetailCheckAll_Click">Check All</asp:LinkButton>
                                                                &nbsp;&nbsp;&nbsp;
                                                                <asp:LinkButton ID="UnCheckAllLinkButton" runat="server" CausesValidation="false"
                                                                    OnClick="DetailClearAll_Click">Clear All</asp:LinkButton>&nbsp;&nbsp;&nbsp;
                                                                <asp:LinkButton ID="AddLineLink" runat="server" CausesValidation="false" Text=""
                                                                    OnClientClick="addLine(this);"></asp:LinkButton>
                                                                &nbsp;&nbsp;&nbsp; <b>
                                                                    <asp:Label ID="ContactLabel" runat="server"></asp:Label></b>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </asp:Panel>
                                                <asp:Panel ID="CommentsPanel" runat="server" Height="100px" Width="95%">
                                                </asp:Panel>
                                                <asp:Panel ID="DetailGridPanel" runat="server" ScrollBars="both" Height="190px" Width="980px">
                                                    <asp:HiddenField ID="DetailGridHeightHidden" runat="server" />
                                                    <asp:HiddenField ID="DetailGridWidthHidden" runat="server" />
                                                    <asp:HiddenField ID="DetailSortField" runat="server" />
                                                    <asp:GridView ID="DetailGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                                                        RowStyle-CssClass="priceDarkLabel" Style="width: 1250px" AllowSorting="true"
                                                        OnSorting="SortDetailGrid" PagerSettings-Position="TopAndBottom" PageSize="10"
                                                        OnPageIndexChanging="DetailGridView_PageIndexChanging" OnRowDataBound="DetailRowBound"
                                                        AllowPaging="true" PagerSettings-Visible="true" PagerSettings-Mode="Numeric">
                                                        <AlternatingRowStyle CssClass="priceLightLabel" />
                                                        <Columns>
                                                            <asp:TemplateField ItemStyle-Width="40" HeaderText="Select" HeaderStyle-HorizontalAlign="Center"
                                                                ItemStyle-HorizontalAlign="center" SortExpression="MakeOrder">
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="SelectCheckBox" runat="server" onclick="FlipMakeOrder(this);" Checked='<%# Eval("MakeOrder") %>' />
                                                                    <asp:HiddenField ID="QuoteNumberHidden" runat="server" Value='<%# Eval("QuoteNumber") %>' />
                                                                    <asp:HiddenField ID="DeleteFlagHidden" runat="server" Value='<%# Eval("DeleteFlag") %>' />
                                                                    <asp:HiddenField ID="MakeOrderDateHidden" runat="server" Value='<%# Eval("MakeOrderDt") %>' />
                                                                    <asp:HiddenField ID="MakeOrderByHidden" runat="server" Value='<%# Eval("MakeOrderID") %>' />
                                                                    <asp:HiddenField ID="UnitPriceHidden" runat="server" Value='<%# Eval("UnitPrice") %>' />
                                                                    <asp:HiddenField ID="UnitWeightHidden" runat="server" Value='<%# Eval("NetWeight") %>' />
                                                                    <asp:HiddenField ID="UnitCostHidden" runat="server" Value='<%# Eval("UnitCost") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="SessionID" HeaderText="Quote #" ItemStyle-Width="50" SortExpression="QuoteNumber"
                                                                ItemStyle-HorizontalAlign="center" HeaderStyle-HorizontalAlign="center" />
                                                            <asp:BoundField DataField="UserItemNo" HeaderText="Customer &nbsp;Item&nbsp;#&nbsp;"
                                                                ItemStyle-Width="100" SortExpression="UserItemNo" ItemStyle-HorizontalAlign="left"
                                                                HeaderStyle-HorizontalAlign="center" />
                                                            <asp:TemplateField ItemStyle-Width="95" HeaderText="PFC Item" HeaderStyle-HorizontalAlign="Center"
                                                                ItemStyle-HorizontalAlign="left" SortExpression="PFCItemNo">
                                                                <ItemTemplate>
                                                                    <asp:Label CssClass="QOHLink" ID="PFCItem" runat="server" Text='<%# Eval("PFCItemNo") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-Width="225"
                                                                SortExpression="Description" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="center" />
                                                            <asp:TemplateField ItemStyle-Width="50px" HeaderText="Req'd Qty" HeaderStyle-HorizontalAlign="Center"
                                                                ItemStyle-HorizontalAlign="right" SortExpression="RequestQuantity">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="ReqQtyText" runat="server" Text='<%# Eval("RequestQuantity", "{0:###,##0} ") %>'
                                                                        Width="45px" CssClass="ws_whitebox" onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==13){return event.keyCode=9;}"
                                                                        onChange="ChangeQty(this);" />
                                                                    <asp:Label ID="ReqQtyLabel" runat="server" Text='<%# Eval("RequestQuantity", "{0:###,##0} ") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="BaseQtyGlued" HeaderText="Base Qty/UOM" ItemStyle-Width="60"
                                                                SortExpression="BaseUOMQty" ItemStyle-HorizontalAlign="right" HeaderStyle-HorizontalAlign="center" />
                                                            <asp:TemplateField ItemStyle-Width="45" HeaderText="Avail. Qty" HeaderStyle-HorizontalAlign="Center"
                                                                ItemStyle-HorizontalAlign="right" SortExpression="AvailableQuantity">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="QOHLabel" runat="server" Text='<%# Eval("AvailableQuantity", "{0:###,##0} ") %>' />
                                                                    <asp:LinkButton ID="QOHLink" CssClass="QOHLink" runat="server" Text='<%# Eval("AvailableQuantity", "{0:#,##0} ") %>'
                                                                        CausesValidation="false" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Loc." ItemStyle-HorizontalAlign="center"
                                                                ItemStyle-Width="30" SortExpression="LocationCode">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="LocLabel" runat="server" Text='<%# Eval("LocationCode") %>' ToolTip='<%# Eval("LocationName") %>'
                                                                        onClick="ShowLoc(this);" CssClass="QOHLink">
                                                                    </asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ItemStyle-Width="90px" HeaderText="Price/UOM" HeaderStyle-HorizontalAlign="Center"
                                                                ItemStyle-HorizontalAlign="right" SortExpression="AltPrice">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="AltPriceText" runat="server" Text='<%# Eval("AltPrice", "{0:###,##0.00} ") %>'
                                                                        Width="50px" CssClass="ws_whitebox" onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==13){return event.keyCode=9;}"
                                                                        onChange="ChangePrice(this);" />
                                                                    <asp:Label ID="AltUMLabel" runat="server" Text='<%# Eval("AltPriceUOM", "{0}") %>'
                                                                        Style="text-align: left;" Width="25px" />
                                                                    <asp:Label ID="PriceGluedLabel" runat="server" Text='<%# Eval("PriceGlued") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="TotalPrice" HeaderText="Extended Amount" DataFormatString="{0:#,##0.00} "
                                                                ItemStyle-Width="80" SortExpression="TotalPrice" ItemStyle-HorizontalAlign="Right"
                                                                HeaderStyle-HorizontalAlign="center" />
                                                            <asp:BoundField DataField="MarginDollars" HeaderText="Mrgn $" DataFormatString="{0:#,##0.00} "
                                                                ItemStyle-Width="50" SortExpression="MarginDollars" ItemStyle-HorizontalAlign="Right"
                                                                HeaderStyle-HorizontalAlign="center" />
                                                            <asp:BoundField DataField="MarginPcnt" HeaderText="%" DataFormatString="{0:#,##0.00} "
                                                                ItemStyle-Width="40" SortExpression="MarginPcnt" ItemStyle-HorizontalAlign="Right"
                                                                HeaderStyle-HorizontalAlign="center" />
                                                            <asp:BoundField DataField="LineWeight" HeaderText="Extended Weight" DataFormatString="{0:#,##0.00} "
                                                                ItemStyle-Width="80" SortExpression="LineWeight" ItemStyle-HorizontalAlign="Right"
                                                                HeaderStyle-HorizontalAlign="center" />
                                                            <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Carrier" ItemStyle-HorizontalAlign="center"
                                                                ItemStyle-Width="75" SortExpression="OrderCarName">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="CarrierCdLabel" runat="server" Text='<%# Eval("OrderCarName") %>'
                                                                        onClick="ShowCarrier(this);" CssClass="QOHLink">
                                                                    </asp:Label>
                                                                    <asp:HiddenField ID="CarrierCodeHidden" runat="server" Value='<%# Eval("OrderCarrier") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Freight Cd" ItemStyle-HorizontalAlign="center"
                                                                ItemStyle-Width="75" SortExpression="OrderFreightName">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="FreightCdLabel" runat="server" Text='<%# Eval("OrderFreightName") %>'
                                                                        onClick="ShowFreight(this);" CssClass="QOHLink">
                                                                    </asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <%--                                                        <asp:TemplateField ItemStyle-Width="45" HeaderText="Carrier" HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-HorizontalAlign="left" SortExpression="OrderCarrier">
                                                            <ItemTemplate>
                                                                <asp:DropDownList ID="CarrierDropDownList" runat="server" DataTextField="Name" DataValueField="Code" CssClass="ws_ddl"
                                                                 DataSourceID="CarrierCodes" onChange="ChangeCarrier(this);">
                                                                </asp:DropDownList>
                                                                <asp:HiddenField ID="CarrierCodeHidden" runat="server" Value='<%# Eval("OrderCarrier") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField ItemStyle-Width="45" HeaderText="Freight Cd" HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-HorizontalAlign="left" SortExpression="OrderFreightCd">
                                                            <ItemTemplate>
                                                                <asp:DropDownList ID="FreightDropDownList" runat="server" DataTextField="Name" DataValueField="Code" CssClass="ws_ddl"
                                                                 DataSourceID="FreightCodes" onChange="ChangeFreight(this);">
                                                                </asp:DropDownList>
                                                                <asp:HiddenField ID="FreightCodeHidden" runat="server" Value='<%# Eval("OrderFreightCd") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
--%>
                                                            <asp:BoundField DataField="UserID" HeaderText="User" ItemStyle-Width="60" SortExpression="UserID"
                                                                ItemStyle-HorizontalAlign="right" HeaderStyle-HorizontalAlign="center" />
                                                            <asp:BoundField DataField="Notes" SortExpression="Notes" ItemStyle-HorizontalAlign="left"
                                                                ItemStyle-CssClass="noDisplay" />
                                                        </Columns>
                                                        <PagerStyle HorizontalAlign="Left" />
                                                    </asp:GridView>
                                                </asp:Panel>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="Left5pxPadd">
                        <table width="100%" style="border: 1px solid #88D2E9; height: 25px; display: block;">
                            <tr>
                                <td valign="middle">
                                    <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:Label ID="MessageLabel" runat="server"></asp:Label>&nbsp;
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td align="center" style="width: 75px;">
                                    <asp:UpdatePanel ID="ExcelUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:ImageButton ID="ExcelExportButton" runat="server" ImageUrl="Common/Images/Excel.gif"
                                                OnClick="ExcelExportButton_Click" CausesValidation="false" />
                                        </ContentTemplate>
                                        <Triggers>
                                            <asp:PostBackTrigger ControlID="ExcelExportButton" />
                                        </Triggers>
                                    </asp:UpdatePanel>
                                </td>
                                <td align="center" style="width: 75px;">
                                    <img src="Common/images/help.gif" style="cursor: hand" alt="Click here for Help"
                                        onclick="OpenHelp('QuoteRecall');" />
                                </td>
                                <td align="center" style="width: 75px;">
                                    <asp:ImageButton ID="CloseButt" runat="server" CausesValidation="false" OnClientClick="ClosePage();return false;"
                                        ImageUrl="Common/Images/close.gif" AccessKey="c" onkeyDown="javascript:if(event.keyCode==13){this.click();return false;}" />
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
