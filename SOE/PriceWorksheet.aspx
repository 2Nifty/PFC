  <%@ Page Language="C#" AutoEventWireup="true" AsyncTimeout="300" EnableEventValidation="false"
    ValidateRequest="false" CodeFile="PriceWorksheet.aspx.cs" Inherits="SOEPriceWorksheet" %>

<%--<%@ OutputCache Duration="3600" VaryByParam="Instance" %>
--%>
<%@ Register Src="Common/UserControls/ItemControl.ascx" TagName="ItemControl" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/ItemFamily.ascx" TagName="ItemFamily" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Profitometer.ascx" TagName="Profitometer" TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <script language="javascript">
    var PartSpecWindow;
    var ItemHistoryWindow;
    var PackPlateWindow;
    var AvailabilityWindow;
    var QuickQuoteWindow;
    var QuoteRecallWindow;
    var ReviewQuoteWindow;
    var CreditRGAWindow;
    var WeightWindow;
    var StockStatusWindow;
    var DocWindow;
    var DoRefresh;
    var TotQty = 0;
    var RemBrCount = 0;
    var TBLControl;
    var PiecePopup = window.createPopup();
    function UnitQtyMouseOver(UnitQtyTxtBox)
    {
        if (parent.$get("PieceQty").value != "")
        {
            var BoxParent = UnitQtyTxtBox.parentElement;
            var posx = parseInt(BoxParent.getAttribute('offsetLeft'), 10);
            var posy = parseInt(BoxParent.getAttribute('offsetTop'), 10) + 100;
            var PiecePopBody = PiecePopup.document.body;
            PiecePopBody.style.backgroundColor = "white";
            PiecePopBody.style.border = "solid blue 3px";
            PiecePopBody.style.font = 'bold 10pt Arial, sans-serif';
            PiecePopBody.innerHTML = 'Pieces per Container is ' + parent.$get("PieceQty").value
                + "<br>Total Pieces is " + parent.$get("TotPieceQty").value;
            PiecePopup.show(posx, posy, 190, 40, document.body);
        }
    }
    function UnitQtyMouseOut()
    {
        PiecePopup.hide();
    }
    
    // Called when new item added using worksheet       
    function pageUnload() 
    {
        RefreshAndCloseChildren();
    }
    
    // Called only whe user hits close button
    function ClosePage()
    {
        RefereshMainOrderEntry();
        window.close();	
    }
    
    function RefereshMainOrderEntry()
    {
        if (
        ($get("QuickQuote").value == "0") && 
        ($get("QuoteRecall").value == "0") &&
        (window.opener != null) && 
        (window.opener.parent.bodyFrame != null) && 
        (window.opener.parent.bodyFrame.document.getElementById("btnGrid") != null)        
        )
        {
            RefreshMainPage();
        }  
    }
    
    function RefreshAndCloseChildren()
    {
        if (
        ($get("QuickQuote").value == "0") && 
        ($get("QuoteRecall").value == "0") &&
        (window.opener != null) && 
        (window.opener.parent.bodyFrame != null) && 
        (window.opener.parent.bodyFrame.document.getElementById("btnGrid") != null) &&
        ($get("chkFastEntry") == null || $get("chkFastEntry").checked == false) // Only fast entry is checked refresh main order entry
        )
        {
            RefreshMainPage();
        }        
        
        if ((PartSpecWindow != null) && (!PartSpecWindow.closed)) {PartSpecWindow.close();}
        if ((ItemHistoryWindow != null) && (!ItemHistoryWindow.closed)) {ItemHistoryWindow.close();}
        if ((PackPlateWindow != null) && (!PackPlateWindow.closed)) {PackPlateWindow.close();}
        if ((AvailabilityWindow != null) && (!AvailabilityWindow.closed)) {AvailabilityWindow.close();}
        if ((QuickQuoteWindow != null) && (!QuickQuoteWindow.closed)) {QuickQuoteWindow.close();}
        if ((QuoteRecallWindow != null) && (!QuoteRecallWindow.closed)) {QuoteRecallWindow.close();}
        if ((ReviewQuoteWindow != null) && (!ReviewQuoteWindow.closed)) {ReviewQuoteWindow.close();}
        if ((StockStatusWindow != null) && (!StockStatusWindow.closed)) {StockStatusWindow.close();}
        if ((DocWindow != null) && (!DocWindow.closed)) {DocWindow.close();}
        if ($get("QuickQuote").value == "1" && $get("QuoteRecall").value == "0")
        {
            SetScreenPos("QuickQuote");
        }
        if ($get("QuickQuote").value == "1" && $get("QuoteRecall").value == "1")
        {
            SetScreenPos("QuoteAdd");
        }
    }
    function RefreshMainPage()
    {
        if (
        ($get("QuickQuote").value == "0") && 
        ($get("QuoteRecall").value == "0") &&
        (window.opener != null) && 
        (window.opener.parent.bodyFrame != null) && 
        (window.opener.parent.bodyFrame.document.getElementById("btnGrid") != null)        
        )
        {
            window.opener.parent.bodyFrame.CallBtnClick('btnGrid');
            if ($get("LineFix").value == "1") window.close();
        }
    }
    function DoQuickQuote()
    {
        if (PartSpecWindow != null) {PartSpecWindow.close();}
        if (ItemHistoryWindow != null) {ItemHistoryWindow.close();}
        if (PackPlateWindow != null) {PackPlateWindow.close();}
        //window.open('PriceWorksheet.aspx?QuickQuote=1','QuickQuote','height=560,width=1000,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
        QuickQuoteWindow = OpenAtPos('QuickQuote', 'PriceWorksheet.aspx?QuickQuote=1', 'toolbar=0,scrollbars=0,status=0,resizable=YES', 0, 0, 1000, 560);    
    }
    function DoReviewQuote()
    {
        var ReviewURL = 'QuoteRecall.aspx?' +
            'Cust=' + $get("CustNoTextBox").value + '&' +
            'QuoteNo=' + $get("QuoteNumberLabel").innerText;
        ReviewQuoteWindow = OpenAtPos('ReviewQuote', ReviewURL, 'toolbar=0,scrollbars=0,status=0,resizable=YES', 0, 0, 1000, 740);    
        //window.showModalDialog(ReviewURL,"",'dialogHeight:700px;dialogWidth:1000px;resizable:yes')
    }
    function DoQuoteRecall()
    {
        if (QuoteRecallWindow != null) {QuoteRecallWindow.close();QuoteRecallWindow=null;}
        var CustNo=$get("CustNoTextBox").value;
        //window.open('QuoteRecall.aspx?Cust='+CustNo,'QuoteRecall','height=560,width=1000,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
        QuoteRecallWindow = OpenAtPos('QuoteRecall', 'QuoteRecall.aspx?Cust='+CustNo, 'toolbar=0,scrollbars=0,status=0,resizable=YES', 0, 0, 1000, 560);    
    }
    function DoStockStatus()
    {
        if (StockStatusWindow != null) {StockStatusWindow.close();StockStatusWindow=null;}
        StockStatusWindow = OpenAtPos('StockStatus', 'StockStatus.aspx?ItemNo='+$get("InternalItemLabel").innerText, 'toolbar=0,scrollbars=0,status=0,resizable=YES', 0, 0, 1024, 560);    
    }
    function DoCreditRGA()
    {
        if (CreditRGAWindow != null) {CreditRGAWindow.close();CreditRGAWindow=null;}
        CreditRGAWindow = OpenAtPos('CreditRGA', 'CreditRGA.aspx', 'toolbar=0,scrollbars=0,status=0,resizable=YES', 0, 0, 1000, 600);    
    }
    function OpenHelp(topic)
    {
        window.open('WorkSheetHelp.aspx#' + topic + '','WorkSheetHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
    }
    function ShowCustItemHist(topic)
    {
        if (ItemHistoryWindow != null) {ItemHistoryWindow.close();}
        //ItemHistoryWindow=window.open('ItemSalesHistory.aspx','ItemHistory','height=410,width=800,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
        ItemHistoryWindow = OpenAtPos('ItemHistory', 'ItemSalesHistory.aspx', 'toolbar=0,scrollbars=0,status=0,resizable=YES', 0, 0, 800, 410);    
    }
    function ShowDoc(DocNo, DocType)
    {
        // the user has requested to see the originating document
        // these links are at the top of the various data columns
        if (DocWindow != null) {DocWindow.close();DocWindow=null;}
        //alert(location.hostname);
        
        // Get orginal Doc No         
        DocNo = SOEPriceWorksheet.GetOrginalDocNo(DocNo, DocType).value;
        
        switch (DocType)
        {
            case 'RQ' :
                var ReviewURL = 'QuoteRecall.aspx?' +
                    'Cust=' + $get("CustNoTextBox").value + '&ReadOnly=1&' +
                    'QuoteNo=' + DocNo;
                ReviewQuoteWindow = OpenAtPos('ReviewQuote', ReviewURL, 'toolbar=0,scrollbars=0,status=0,resizable=YES', 0, 0, 1000, 740);    
                break;
            case 'WQ' :
                var ReviewURL = 'ECommQuoteRecall.aspx?' +
                    'Cust=' + $get("CustNoTextBox").value + '&ReadOnly=1&' +
                    'QuoteNo=' + DocNo + '&IsEcomm=True';
                ReviewQuoteWindow = OpenAtPos('ReviewQuote', ReviewURL, 'toolbar=0,scrollbars=0,status=0,resizable=YES', 0, 0, 1000, 740);    
                break;
            case 'IV' :
                DocWindow = OpenAtPos('MetricDoc', 
                    'SORecall/SORecall.aspx?DocNo='+DocNo+'&DocType=I', 'toolbar=0,scrollbars=0,status=0,resizable=0', 0, 0, 1024, 660);    
                break;
            default :
                DocWindow = OpenAtPos('MetricDoc', 
                    'SORecall/SORecall.aspx?DocNo='+DocNo+'&DocType=R', 'toolbar=0,scrollbars=0,status=0,resizable=0', 0, 0, 1024, 660);    
        }
    }
    function ShowPackPlate()
    {
        if (PackPlateWindow != null) {PackPlateWindow.close();}
        //PackPlateWindow=window.open('PackingAndPlating.aspx','PackPlateWin','height=450,width=400,toolbar=0,scrollbars=0,status=1,resizable=YES','');    
        PackPlateWindow = OpenAtPos('PkgPlt', 'PackingAndPlating.aspx', 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 400, 450);    
    }
    function ShowAvailability()
    {
        if ($get("InternalItemLabel").innerText != "" && $get("AvailableQtyLabel").innerText != "")
        {
            if (AvailabilityWindow != null) {AvailabilityWindow.close();}
            //AvailabilityWindow=window.open('BranchAvailable.aspx','AvailableWin','height=600,width=600,toolbar=0,scrollbars=0,status=1,resizable=YES','');    
            var AvailURL = 'BranchAvailable.aspx?' +
                'ItemNumber=' + $get("InternalItemLabel").innerText + '&' +
                'ShipLoc=' + $get("ShippingBranch").value + '&' +
                'RequestedQty=' + $get("RequestedQtyTextBox").value + '&' +
                'AltQty=' + $get("AltQtyLabel").innerText + '&' +
                'AvailableQty=' + $get("Qty1").value + '&' +
                'PriceWorksheet=1&ParentButton=CostUpdButt&ParentFocus=SellPriceTextBox&SubsItemInd=' +  $get("hidSubItemInd").value ;
            AvailabilityWindow = OpenAtPos('BranchAvail', AvailURL, 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 600, 600);    
        }
        else
        {
            alert('Please enter an Item Number and a Quantity to see Availability');
        }
    }
    function ShowWeight()
    {
        if ($get("CustNoTextBox").value != "")
        {
            if (WeightWindow != null) {WeightWindow.close();WeightWindow=null;}
            //AvailabilityWindow=window.open('BranchAvailable.aspx','AvailableWin','height=600,width=600,toolbar=0,scrollbars=0,status=1,resizable=YES','');    
            WeightWindow = OpenAtPos('CustWeight', 'CustWeight.aspx?CustNumber='+$get("CustNoTextBox").value, 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 400, 600);    
        }
        else
        {
            alert('Please enter a Customer Number to see Weight');
        }
    }
    
    var pendingECommQuotes;
    function ShowWebQueue()
    {
        if (pendingECommQuotes != null) {pendingECommQuotes.close();pendingECommQuotes=null;}            
            pendingECommQuotes = OpenAtPos('pendingECommQuotes', 'PendingECommQuotes.aspx?UserName=<%= Session["UserName"].ToString().Trim() %>', 'toolbar=0,scrollbars=0,status=0,resizable=YES', 0, 0, 700, 600);    
        
        //alert(document.getElementById("ibtnWebQueue").src);
            document.getElementById("ibtnWebQueue").src = 'Common/Images/Q_OFF.gif';
    }
    function ShowPartImage()
    {
        if (PartSpecWindow != null) {PartSpecWindow.close();}
        PartSpecWindow=window.open('ShowPartImage.aspx','PartImages','height=460,width=900,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
    }
    
    function CustNoEntry()
    {
        $get("CustValid").value="0";
    }

    function ZItem(itemNo)
    {
        var section="";
        var completeItem=0;
        var AddXref=$get("AddXrefCheckBox");
        var ZItemInd=$get("ItemPromptInd");
        //alert(ZItemInd.value);
        if (ZItemInd.value != 'Z' || itemNo.length >= 14)
        {
            document.form1.ItemSubmit.click();
            event.keyCode=0;
            return false;
        }
        // comment entry mode for quotes
        if (itemNo.toUpperCase()=="C" && document.getElementById("QuickQuote").value == "1")
        {
            document.getElementById("CommentEntry").value="1";
            document.form1.CommentEntryButt.click();
            event.keyCode=0;
            return false;
        }
        // two periods alone to close
        if (itemNo=="..")
        {
            ClosePage();
            return false;
        }
        if (!AddXref.checked)
        {
            // process ZItem
            switch(itemNo.split('-').length)
            {
            case 1:
                // this is actually taken care of by the item alias search
                itemNo = "00000" + itemNo;
                itemNo = itemNo.substr(itemNo.length-5,5);
                $get("CustomerItemTextBox").value=itemNo+"-";  
                break;
            case 2:
                // close if they are entering an empty part
                if (itemNo.split('-')[0] == "00000") {ClosePage()};
                section = "0000" + itemNo.split('-')[1];
                section = section.substr(section.length-4,4);
                $get("CustomerItemTextBox").value=itemNo.split('-')[0]+"-"+section+"-";  
                break;
            case 3:
                section = "000" + itemNo.split('-')[2];
                section = section.substr(section.length-3,3);
                $get("CustomerItemTextBox").value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
                completeItem=1;
                break;
            }
            if (completeItem==1) 
                document.form1.ItemSubmit.click()
            else
            {
                var txtRange = $get("CustomerItemTextBox").createTextRange();
                txtRange.moveStart( "character", $get("CustomerItemTextBox").value.length );
                txtRange.select();
            };
        }
        else
        {
            $get("RequestedQtyTextBox").focus();
        }
        event.keyCode=0;
        return false;
    }

    /* GotoEnd(this);
    function GotoEnd( x ) {
        var txtRange = x.createTextRange();
        txtRange.moveStart( "character", x.value.length );
        txtRange.select();
    }*/
    

    function VerifyRemote(RemoteInput)
    {
    alert('Verify');
        if (parseInt($get("QtyToSellLabel").innerText,10) > parseInt($get("FilledQtyHidden").value,10))
        {
            //$get("BranchQOHGrid").focus();
            RemoteInput.focus();
        }
    }

   function clickAndGo(buttonToClick)
    {
        if(event.keyCode==13 || event.keyCode==9)
            {$get(buttonToClick).click();return false;}
        else
            {
            if ($get("PriceOriginHidden").value != "E")
                {
                if (event.srcElement.id == "SellPriceTextBox" || 
                    event.srcElement.id == "AltPriceTextBox" || 
                    event.srcElement.id == "DiscPcntTextBox" || 
                    event.srcElement.id == "DiscPriceTextBox" )
                    {
                    $get("PriceOriginHidden").value = "E";
                    //SOEPriceWorksheet.SetPriceOrigin("E",GenericCallBack);
                    }
                }
            };
        
    }

    function NavUpDown(prevControl, nextControl, buttonToClick)
    {
        // 38 = uparrow, 40 = downarrow
        //alert(event.keyCode);
        if(event.keyCode==38)
        {
            $get(prevControl).focus();
            return false;
        };
        if(event.keyCode==40)
        {
            $get(nextControl).focus();
            return false;
        };
        // enter or tab    
        if(event.keyCode==13 || event.keyCode==9)
        {
            if (arguments.length == 2 ) $get(nextControl).focus();    
            if (arguments.length == 3 ) $get(buttonToClick).click();    
            return false;
        };
    }
    //document.getElementById("OrderType").value = window.opener.parent.bodyFrame.document.getElementById('ucOrderType_lblValue').innerText;

    function CheckAddLine(AddButt)
    {
        //var CustNoPattern = /\d{6}/;
        if ($get("CustValid").value!="1")
        {
            $get("CustNoTextBox").focus();
            var MessLabel = $get("MessageLabel");
            MessLabel.innerHTML = "Customer number is not valid";
            MessLabel.className = "error";
            return false;
        }
        if ($get("CustomerItemTextBox").value=="")
        {
            $get("CustomerItemTextBox").focus();
            return false;
        }
        if ($get("RequestedQtyTextBox").value=="" && ($get("QuickQuote").value != "1") && ($get("QuoteRecall").value != "1"))
        {
            $get("RequestedQtyTextBox").focus();
            return false;
        }
        if ($get("CommentEntry").value=="1")
        {
            if (AvailabilityWindow != null) {AvailabilityWindow.close();}
            AddButt.style.display='none';
            return true;
        }
        if ((parseInt($get("QtyToSellLabel").innerText,10) == 0 || parseInt($get("FilledQtyHidden").value,10)==0 || parseInt($get("RequestedQtyTextBox").value,10)==0) 
            && ($get("QuickQuote").value != "1") && ($get("QuoteRecall").value != "1"))
        {
            $get("RequestedQtyTextBox").focus();
            return false;
        }
        // make sure the qty is loaded correctly and user has not moused the fields
        var ReqQty = SOEPriceWorksheet.AjaxGetLineQty(
            $get("RequestedQtyTextBox").value
            ,$get("QuickQuote").value
            ,$get("QuoteRecall").value
            ,$get("InternalItemLabel").innerText).value;
        //alert(ReqQty);
        //alert(parseInt($get("QtyToSellLabel").innerText,10));
        //alert(parseInt($get("CurQty").value,10));
        if ((parseInt(ReqQty,10) != parseInt($get("CurQty").value,10)) && (parseInt(ReqQty,10) > parseInt($get("AvailableQtyLabel").innerText,10)))
        {
            document.form1.QtySubmit.click()
            $get("RequestedQtyTextBox").focus();
            return false;
        }
        //if (parseInt(ReqQty,10) != parseInt($get("CurQty").value,10))
        //{
        //    document.form1.QtySubmit.click()
        //}
        /*
        if (RefreshNeeded == 1)
        {
            document.form1.SellPriceSubmit.click()
        }
        if (parseInt($get("QtyToSellLabel").innerText,10) > parseInt($get("FilledQtyHidden").value,10))
        {
            var MessLabel = $get("MessageLabel");
            MessLabel.innerHTML = "Qty from Remote Branches is less than the Requested Qty.";
            MessLabel.className = "error";
            $get("RequestedQtyTextBox").focus();
            return false;
        }
        */
        var MinMrgn = 100*parseFloat($get("MinMargin").value);
        var MaxMrgn = 100*parseFloat($get("MaxMargin").value);
        var CurMrgn = parseFloat($get("MgnCostTextBox").value);
        if ((CurMrgn >=MinMrgn && CurMrgn<=MaxMrgn) || ($get("HeadingPriceCodeLabel").innerText=="Z") 
            || (document.getElementById("QuickQuote").value == "1") || (document.getElementById("QuoteRecall").value == "1"))
        {
            if (AvailabilityWindow != null) {AvailabilityWindow.close();}
            AddButt.style.display='none';
            return true;
        };
        // See if user want to override
        if (ShowOkCancel('Margin (' + $get("MgnCostTextBox").value + '%) is out of range.\n\nThe range is ' + MinMrgn.toString() + '% to ' + MaxMrgn.toString() +'%\n\nDo you want to add the line?' ))
        {
            if (AvailabilityWindow != null) {AvailabilityWindow.close();}
            AddButt.style.display='none';
            return true;
        }
        else
        {
            $get("SellPriceTextBox").focus();
            return false;
        }
    }

    function SetProfitPrice()
    {
        document.form1.ContPriceSubmit.click();
    }   

    // Open Customer look up
    function LoadCustomerLookup(_custNo)
    {   
        var Url = "CustomerList.aspx?Customer=" + _custNo + "&ctrlName=SOPrice";
        window.open(Url,'CustomerList' ,'height=485,width=855,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (855/2))+',resizable=NO,scrollbars=YES','');
    }

    var SellOutWindow;
    function ShowSellOutItems()
    {
        if (SellOutWindow != null) {SellOutWindow.close();}
        
        var subItemURL =  'SubstituteItemAvailable.aspx?' +
                        'ItemNumber=' + $get("InternalItemLabel").innerHTML + '&' +
                        'ShipLoc=' +  $get("ShippingBranch").value + '&' +
                        'RequestedQty=' + $get("RequestedQtyTextBox").value + '&' +
                        'AltQty=' + $get("AltQtyLabel").innerHTML + '&' +
                        'AvailableQty=' + '0' + '&' +
                        'PriceWorksheet=1&ParentButton=CostUpdButt&ParentFocus=SellPriceTextBox&Mode=SellOutItem';
        SellOutWindow = OpenAtPos('SellOutItemsAvail', subItemURL, 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 600, 600);    
    }
    
    function OpenPromoDetail()
    {
        var custNo = $get("CustNoTextBox").value;
        if( custNo == "")
        {
            alert('Invalid customer number');
        }
        else
        {
            var promoURL =  'ActivePromos.aspx?CustNo=' + custNo ;
            var hndPromo = window.open(promoURL,'custPromo' ,'height=300,width=475,scrollbars=no,status=no,top='+((screen.height/2) - (485/2))+',left='+((screen.width/2) - (450/2))+',resizable=NO,scrollbars=NO','');              
        }    
        
    }
    
    var compPriceHandle;
    function OpenCompPriceMaint(mode, pageURL)
    {
        var custNo = $get("CustNoTextBox").value;
        if( custNo == "")
        {
            alert('Invalid customer number.');
        }
        else
        {     
            pageURL += "&CustNo=" + custNo ;
         
            if (compPriceHandle != null) {compPriceHandle.close();compPriceHandle=null;}  
            
            if(mode == 'listitems' ||mode == 'itemhistory')                          
                compPriceHandle = window.open(pageURL,'compPrice' ,'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO','');
            else if (mode == 'price')  
                compPriceHandle = window.open(pageURL,'compPrice' ,'height=330,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (340/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO','');
        }
    }
    
    function DetectShortCutKeys()
    {  
        if(event.keyCode==107)
        {
            DoQuoteRecall();  
            return false;          
        }
        else if(($get("ReviewQuoteButton") != null && window.event.altKey==true && event.keyCode==109))
        {
            DoReviewQuote();
            return false;
        }
        
    }
    
    </script>

    <script language="vbscript">
    Function ShowOkCancel(strMsg)
    Dim intBtnClick
    intBtnClick=msgbox(strMsg,vbOKCancel,"Pricing WorkSheet")
    if intBtnClick=1 then 
        ShowOkCancel= true 
    else 
        ShowOkCancel= false
     end if
    end Function
    </script>

    <script src="Common/JavaScript/wsItemBuilder.js" type="text/javascript"></script>

    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>

    <title>Worksheet</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/PriceSheetStyles.css" rel="stylesheet" type="text/css" />
</head>
<body onkeydown="javascript:return DetectShortCutKeys();"  style="margin: 0px" bgcolor="#ECF9FB">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="SOEPriceWorksheetScriptManager" runat="server" EnablePartialRendering="true"
            AsyncPostBackTimeout="36000" EnableScriptGlobalization="true" />
        <div>
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td valign="middle">
                        <asp:UpdatePanel ID="CustomerUpdatePanel" runat="server">
                            <ContentTemplate>
                                <table width="100%" style="border: 1px solid #88D2E9;">
                                    <tr class="bold">
                                        <td align="right">
                                            <div style="color: Blue;">
                                                Cust. #</div>
                                        </td>
                                        <td>
                                            <asp:TextBox CssClass="lbl_whitebox" ID="CustNoTextBox" runat="server" Width="100px"
                                                onkeypress="javascript:CustNoEntry();" onfocus="javascript:this.select();" OnTextChanged="WorkCustomerNumber"
                                                AutoPostBack="true"></asp:TextBox>
                                            <asp:Button ID="CustNoSubmit" name="CustNoSubmit" OnClick="WorkCustomerNumber" runat="server"
                                                Text="Button" Style="display: none;" CausesValidation="false" />
                                        </td>
                                        <td align="right">
                                            <div style="color: Blue;">
                                                <asp:Label ID="lblName" runat="server" Font-Underline="True" Style="color: blue"
                                                    Text="Name:"></asp:Label>&nbsp;</div>
                                        </td>
                                        <td>
                                            <table border=0 cellpadding=0 cellspacing=0>
                                                <tr>
                                                    <td>
                                                        <asp:Label CssClass="lbl_whitebox" ID="CustNameLabel" runat="server" Text=" " Width="200px"></asp:Label>        
                                                    </td> 
                                                    <td style="padding-left:10px;">
                                                        <asp:CheckBox ForeColor="blue" ID="chkFastEntry" runat=server Checked=false Text="Fast Entry Mode" />
                                                    </td>                                               
                                                </tr>                                            
                                            </table>                                            
                                        </td>
                                        <td>
                                            <asp:Label Style="color: Blue;" ID="TermsNameLabel" runat="server" Text="Terms"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label CssClass="lbl_whitebox" ID="TermsDescLabel" runat="server" Text="" Width="100px"></asp:Label>
                                        </td>
                                        <td align="right">
                                            <div style="color: Blue;">
                                                Ship From:</div>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="LocationDropDownList" runat="server" DataTextField="Name" DataValueField="Code"
                                                CssClass="ws_whitebox" onChange="document.form1.ShipLocSubmit.click();" Height="20px">
                                            </asp:DropDownList>
                                            <asp:Button ID="ShipLocSubmit" name="ShipLocSubmit" OnClick="ShipLocSubmit_Click"
                                                runat="server" Text="Button" Style="display: none;" CausesValidation="false" />
                                            <asp:Label CssClass="lbl_whitebox" ID="ShipFromLabel" runat="server" Text=" " Width="20px"></asp:Label>
                                        </td>
                                        <td align="right">
                                            <div style="color: Blue;">
                                                Price Code:</div>
                                        </td>
                                        <td>
                                            <asp:Label CssClass="lbl_whitebox" ID="HeadingPriceCodeLabel" runat="server" Text=" "
                                                Width="15px"></asp:Label>
                                        </td>
                                        <td align="right">
                                            <img src="Common/images/help.gif" style="cursor: hand" alt="Click here for Help"
                                                onclick="OpenHelp('PageTop');" />&nbsp;&nbsp;&nbsp;
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Panel ID="ItemPanel" runat="server">
                            <asp:UpdatePanel ID="ItemUpdatePanel" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td style="padding-left: 4px; padding-right: 4px">
                                                <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlQuoteDetail">
                                                    <ContentTemplate>
                                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                            <tr class="bold">
                                                                <td>
                                                                    Customer Item #
                                                                    <asp:HiddenField ID="ShippingBranch" runat="server" />
                                                                    <asp:HiddenField ID="ShippingBranchName" runat="server" />
                                                                    <asp:HiddenField ID="LocName" runat="server" />
                                                                    <asp:HiddenField ID="OrderNumber" runat="server" />
                                                                    <asp:HiddenField ID="OrderType" runat="server" />
                                                                    <asp:HiddenField ID="LineReasonCode" runat="server" />
                                                                    <asp:HiddenField ID="LineReasonCodeDesc" runat="server" />
                                                                    <asp:HiddenField ID="LineExpediteCode" runat="server" />
                                                                    <asp:HiddenField ID="LineExpediteCodeDesc" runat="server" />
                                                                    <asp:HiddenField ID="RequestedShipDate" runat="server" />
                                                                    <asp:HiddenField ID="ShipDate" runat="server" />
                                                                    <asp:HiddenField ID="LineFix" runat="server" />
                                                                    <asp:HiddenField ID="LineNumber" runat="server" />
                                                                    <asp:HiddenField ID="LineRecID" runat="server" />
                                                                    <asp:HiddenField ID="QuickQuote" runat="server" />
                                                                    <asp:HiddenField ID="QuoteRecall" runat="server" />
                                                                    <asp:HiddenField ID="QuoteFix" runat="server" />
                                                                    <asp:HiddenField ID="QuoteNumber" runat="server" />
                                                                    <asp:HiddenField ID="QuoteLineNo" runat="server" />
                                                                    <asp:HiddenField ID="Loc1" runat="server" />
                                                                    <asp:HiddenField ID="Qty1" runat="server" />
                                                                    <asp:HiddenField ID="Loc2" runat="server" />
                                                                    <asp:HiddenField ID="Qty2" runat="server" />
                                                                    <asp:HiddenField ID="Loc3" runat="server" />
                                                                    <asp:HiddenField ID="Qty3" runat="server" />
                                                                    <asp:HiddenField ID="SellStkQty" runat="server" />
                                                                    <asp:HiddenField ID="ContUOM" runat="server" />
                                                                    <asp:HiddenField ID="AltUOMQty" runat="server" />
                                                                    <asp:HiddenField ID="SuperQty" runat="server" />
                                                                    <asp:HiddenField ID="PieceQty" runat="server" />
                                                                    <asp:HiddenField ID="TotPieceQty" runat="server" />
                                                                    <asp:HiddenField ID="SuperUOM" runat="server" />
                                                                    <asp:HiddenField ID="SoldToAddr1" runat="server" />
                                                                    <asp:HiddenField ID="SoldToAddr2" runat="server" />
                                                                    <asp:HiddenField ID="SoldToCity" runat="server" />
                                                                    <asp:HiddenField ID="SoldToState" runat="server" />
                                                                    <asp:HiddenField ID="SoldToZip" runat="server" />
                                                                    <asp:HiddenField ID="SoldToCountry" runat="server" />
                                                                    <asp:HiddenField ID="SoldToPhone" runat="server" />
                                                                    <asp:HiddenField ID="ShipToNo" runat="server" />
                                                                    <asp:HiddenField ID="ShipToName" runat="server" />
                                                                    <asp:HiddenField ID="ShipToAddr1" runat="server" />
                                                                    <asp:HiddenField ID="ShipToAddr2" runat="server" />
                                                                    <asp:HiddenField ID="ShipToCity" runat="server" />
                                                                    <asp:HiddenField ID="ShipToState" runat="server" />
                                                                    <asp:HiddenField ID="ShipToZip" runat="server" />
                                                                    <asp:HiddenField ID="ShipToCountry" runat="server" />
                                                                    <asp:HiddenField ID="ShipToPhone" runat="server" />
                                                                    <asp:HiddenField ID="RepNo" runat="server" />
                                                                    <asp:HiddenField ID="RepName" runat="server" />
                                                                    <asp:HiddenField ID="ContractNo" runat="server" />
                                                                    <asp:HiddenField ID="OrderTableName" runat="server" />
                                                                    <asp:HiddenField ID="DetailTableName" runat="server" />
                                                                    <asp:HiddenField ID="CustDesc" runat="server" />
                                                                    <asp:HiddenField ID="TargetMargin" runat="server" />
                                                                    <asp:HiddenField ID="TotalCost" runat="server" />
                                                                    <asp:HiddenField ID="OECost" runat="server" />
                                                                    <asp:HiddenField ID="CostMethod" runat="server" />
                                                                    <asp:HiddenField ID="PriceOriginHidden" runat="server" />
                                                                    <asp:HiddenField ID="OriginalPrice" runat="server" />
                                                                    <asp:HiddenField ID="UseRemoteQtys" runat="server" />
                                                                    <asp:HiddenField ID="ItemColor" runat="server" />
                                                                    <asp:HiddenField ID="MinMargin" runat="server" />
                                                                    <asp:HiddenField ID="MaxMargin" runat="server" />
                                                                    <asp:HiddenField ID="ShowPartImages" runat="server" />
                                                                    <asp:HiddenField ID="ItemPromptInd" runat="server" />
                                                                    <asp:HiddenField ID="FilledQtyHidden" runat="server" />
                                                                    <asp:HiddenField ID="NoSKUOnFile" runat="server" />
                                                                    <asp:HiddenField ID="NoSKUStdCostHidden" runat="server" />
                                                                    <asp:HiddenField ID="NoSKUAvgCostHidden" runat="server" />
                                                                    <asp:HiddenField ID="NoSKUReplCostHidden" runat="server" />
                                                                    <asp:HiddenField ID="ReplCostHidden" runat="server" />
                                                                    <asp:HiddenField ID="AvgCostHidden" runat="server" />
                                                                    <asp:HiddenField ID="StdCostHidden" runat="server" />
                                                                    <asp:HiddenField ID="ListPriceHidden" runat="server" />
                                                                    <asp:HiddenField ID="CommentEntry" runat="server" />
                                                                    <asp:HiddenField ID="PriceFixed" runat="server" />
                                                                    <asp:HiddenField ID="ItemRecID" runat="server" />
                                                                    <asp:HiddenField ID="RefreshNeeded" runat="server" />
                                                                    <asp:HiddenField ID="LineAdded" runat="server" />
                                                                    <asp:HiddenField ID="CurQty" runat="server" />
                                                                    <asp:HiddenField ID="CurAltPrice" runat="server" />
                                                                    <asp:HiddenField ID="CurDiscPrice" runat="server" />
                                                                    <asp:HiddenField ID="CurDiscPcnt" runat="server" />
                                                                    <asp:HiddenField ID="CurWorkPrice" runat="server" />
                                                                    <asp:HiddenField ID="CurAvgMrgn" runat="server" />
                                                                    <asp:HiddenField ID="CurStdMrgn" runat="server" />
                                                                    <asp:HiddenField ID="CurReplMrgn" runat="server" />
                                                                    <asp:HiddenField ID="CurDolrLB" runat="server" />
                                                                    <asp:HiddenField ID="CurMrgnLB" runat="server" />
                                                                    <asp:HiddenField ID="CustValid" runat="server" />
                                                                    <asp:HiddenField ID="PricingCalled" runat="server" />
                                                                    <asp:HiddenField ID="SuperDisc" runat="server" />
                                                                    <asp:HiddenField ID="CustCertRequiredInd" runat="server" />
                                                                    <asp:HiddenField ID="ItemCertRequiredInd" runat="server" />
                                                                    <asp:HiddenField ID="hidSubstituteItemData" runat="server" />
                                                                    <asp:HiddenField ID="hidSubItemInd" Value="N" runat="server" />
                                                                    <asp:HiddenField ID="hidSellOutItemInd" Value="N" runat="server" />
                                                                </td>
                                                                <td align="center">
                                                                    Add
                                                                </td>
                                                                <td align="center">
                                                                    Internal Item #
                                                                </td>
                                                                <td align="center">
                                                                    Requested Qty
                                                                </td>
                                                                <td align="center" onclick="ShowAvailability();">
                                                                    <span style="color: Red; cursor: hand">Avail. Qty</span>
                                                                </td>
                                                                <td align="center">
                                                                    Sell Qty
                                                                </td>
                                                                <td width="75px" align="center">
                                                                    Sell Price
                                                                </td>
                                                                <td width="75px" align="center">
                                                                    Sell Unit
                                                                </td>
                                                                <td>
                                                                    Cert
                                                                </td>
                                                                <td width="70px">
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:TextBox CssClass="ws_whitebox_left" ID="CustomerItemTextBox" runat="server"
                                                                        onDblClick="javascript:ClosePage();" onClick="javascript:this.select();" onkeydown="javascript:if(event.keyCode==9){document.form1.AliasSubmit.click();}"
                                                                        onkeypress="javascript:if(event.keyCode==13){return ZItem(this.value)};" onfocus="javascript:this.select();"></asp:TextBox>
                                                                    <asp:Button ID="ItemSubmit" name="ItemSubmit" OnClick="ItemButt_Click" runat="server"
                                                                        Text="Button" Style="display: none;" CausesValidation="false" />
                                                                    <asp:Button ID="AliasSubmit" name="AliasSubmit" OnClick="AliasButt_Click" runat="server"
                                                                        Text="Button" Style="display: none;" CausesValidation="false" />
                                                                    <asp:Button ID="CommentEntryButt" name="ItemSubmit" OnClick="StartCommentEntry_Click"
                                                                        runat="server" Text="Button" Style="display: none;" CausesValidation="false" />
                                                                    <asp:Button ID="btnSubsItem" name="SubmitSubstituteItem" OnClick="btnSubsItem_Click"
                                                                        runat="server" Text="Button" Style="display: none;" CausesValidation="false" />
                                                                </td>
                                                                <td align="center">
                                                                    <asp:CheckBox ID="AddXrefCheckBox" ToolTip="Check this box to add a&#013;cross reference part number"
                                                                        runat="server" />
                                                                </td>
                                                                <td align="center">
                                                                    <asp:Label CssClass="ws_data_left" Width="100px" ID="InternalItemLabel" runat="server"
                                                                        Text=""></asp:Label>
                                                                </td>
                                                                <td align="center">
                                                                    <asp:TextBox CssClass="ws_whitebox" ID="RequestedQtyTextBox" runat="server" Style="width: 80px;"
                                                                        onfocus="javascript:this.select();" onchange="javascript:document.form1.QtySubmit.click();return false;"
                                                                        onkeydown="return NavUpDown('CustomerItemTextBox','SellPriceTextBox','QtySubmit');"></asp:TextBox>
                                                                    <asp:Button ID="QtySubmit" name="QtySubmit" OnClick="QtyButt_Click" runat="server"
                                                                        Text="Button" Style="display: none;" CausesValidation="false" />
                                                                    <asp:Button ID="CostUpdButt" name="CostUpdButt" OnClick="CostUpdButt_Click" runat="server"
                                                                        Text="Button" Style="display: none;" CausesValidation="false" />
                                                                </td>
                                                                <td align="center" onclick="ShowAvailability();">
                                                                    <asp:Label CssClass="ws_data_right" Width="50px" ID="AvailableQtyLabel" runat="server"
                                                                        Text=""></asp:Label>
                                                                </td>
                                                                <td align="center">
                                                                    <asp:Label CssClass="ws_data_right" Width="80px" ID="QtyToSellLabel" runat="server"
                                                                        Text=""></asp:Label>
                                                                </td>
                                                                <td width="75px" align="center">
                                                                    <asp:TextBox CssClass="ws_whitebox" ID="SellPriceTextBox" runat="server" Style="width: 60px;"
                                                                        onfocus="javascript:this.select();" onchange="javascript:document.form1.SellPriceSubmit.click();"
                                                                        onkeydown="return NavUpDown('RequestedQtyTextBox','AddItemImageButton','SellPriceSubmit');"
                                                                        OnTextChanged="SellPriceChanged"></asp:TextBox>
                                                                    <asp:Button ID="SellPriceSubmit" name="SellPriceSubmit" OnClick="BuyPriceButt_Click"
                                                                        runat="server" Text="Button" Style="display: none;" />
                                                                </td>
                                                                <td width="75px" align="center">
                                                                    <asp:Label CssClass="ws_data_center" Width="50px" ID="SellUOMLabel" runat="server"
                                                                        Text=""></asp:Label>
                                                                </td>
                                                                <td>
                                                                    <asp:CheckBox ID="ItemCertsReqdCheckBox" runat="server" />
                                                                </td>
                                                                <td>
                                                                    <asp:UpdateProgress DisplayAfter="25" ID="ItemUpdateProgress" runat="server" DynamicLayout="false"
                                                                        AssociatedUpdatePanelID="pnlQuoteDetail">
                                                                        <ProgressTemplate>
                                                                            <span style="color: Red;"><b>Processing.....</b></span>
                                                                        </ProgressTemplate>
                                                                    </asp:UpdateProgress>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding-left: 4px; padding-right: 4px">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr class="bold">
                                                        <td>
                                                            <asp:Label ID="LastItemLabel" runat="server"></asp:Label>&nbsp;
                                                        </td>
                                                        <td align="center">
                                                            Price/Unit
                                                        </td>
                                                        <td align="center">
                                                            Qty/Unit
                                                        </td>
                                                        <td align="center">
                                                            Total
                                                            <asp:Label ID="PieceUOMLabel" runat="server"></asp:Label>
                                                        </td>
                                                        <td align="center">
                                                            Origin
                                                        </td>
                                                        <td align="right">
                                                            <asp:Label ID="MillCostLabel" runat="server" Text="Mill Cost"></asp:Label>
                                                        </td>
                                                        <td width="45px" align="center">
                                                            Excl.
                                                        </td>
                                                        <td width="65px" align="right">
                                                            Repl. Cost
                                                        </td>
                                                        <td width="65px" align="right">
                                                            Avg. Cost
                                                        </td>
                                                        <td  align="right">
                                                            <div style="display:none;">Std. Cost</div>
                                                        </td>
                                                        <td align="center" width="65">
                                                            % Diff</td>
                                                    </tr>
                                                    <tr>
                                                        <td align="left">
                                                            <i><b>
                                                                <asp:Label ID="ItemDescLabel" runat="server" Text="" CssClass="ws_data_left" Width="280px">
                                                                </asp:Label></b></i>
                                                        </td>
                                                        <td align="center">
                                                            <asp:Label CssClass="ws_data_right" Width="70px" ID="ContPriceLabel" runat="server"
                                                                Text=""></asp:Label>
                                                            <%-- used by the profitometer --%>
                                                            <asp:Button ID="ContPriceSubmit" name="ContPriceSubmit" OnClick="ContPriceButt_Click"
                                                                runat="server" Text="Button" Style="display: none;" CausesValidation="false" />
                                                            <%--                                                <asp:TextBox  CssClass="ws_whitebox" ID="SellPriceTextBox" runat="server"  style="width:60px;" AccessKey="S"
                                                 onfocus="javascript:this.select();"
                                                 onkeydown="javascript:NavUpDown('RequestedQtyTextBox','WorkSellPriceTextBox','SellPriceSubmit');" 
                                                 ></asp:TextBox>
                                                <asp:Button id="SellPriceSubmit" name="SellPriceSubmit" OnClick="SellPriceButt_Click"
                                                    runat="server" Text="Button" style="display:none;" CausesValidation="false" />
--%>
                                                        </td>
                                                        <td align="center">
                                                            <asp:Label CssClass="ws_data_right" Width="75px" ID="QtyUnitLabel" runat="server"
                                                                Text=""></asp:Label>
                                                        </td>
                                                        <td align="center">
                                                            <asp:Label CssClass="ws_data_right" Width="70px" ID="AltQtyLabel" runat="server"
                                                                Text="" onmouseover="UnitQtyMouseOver(this);" onmouseout="UnitQtyMouseOut();"></asp:Label>
                                                        </td>
                                                        <td align="center">
                                                            <asp:Label CssClass="ws_data_center" Width="30px" ID="PriceOriginLabel" runat="server"
                                                                Text="" ToolTip="Price Origin"></asp:Label>
                                                        </td>
                                                        <td align="right">
                                                            <asp:TextBox CssClass="ws_whitebox" ID="MillCostInput" runat="server" Text="0" Width="50px"></asp:TextBox>
                                                        </td>
                                                        <td width="45px" align="center">
                                                            <asp:CheckBox ID="XFUCheck" ToolTip="Exclude From Usage" runat="server" />
                                                        </td>
                                                        <td width="65px" align="right">
                                                            <asp:TextBox CssClass="ws_data_right" Width="50px" ID="ReplCostText" runat="server"
                                                                Text="" ReadOnly="true"></asp:TextBox>
                                                        </td>
                                                        <td width="65px" align="right">
                                                            <asp:TextBox CssClass="ws_data_right" Width="50px" ID="AvgCostText" runat="server"
                                                                Text="" ReadOnly="true"></asp:TextBox>
                                                        </td>
                                                        <td align="right">
                                                            <asp:TextBox CssClass="ws_data_right" Width="50px" ID="StdCostText" runat="server" Text="" ReadOnly="true" Visible="False"></asp:TextBox></td>
                                                        <td align="center" width="65">
                                                            <asp:TextBox ID="txtPctDiff" runat="server" CssClass="ws_data_right" ReadOnly="true"
                                                                Text="" Width="40px"></asp:TextBox></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding-left: 4px; padding-right: 4px">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr class="bold">
                                                        <td>
                                                            List Price
                                                        </td>
                                                        <td>
                                                            Disc. %
                                                        </td>
                                                        <td>
                                                            Disc. Price
                                                        </td>
                                                        <td>
                                                            &nbsp;&nbsp;Line Item Comment
                                                        </td>
                                                        <td align="center" width="65px">
                                                            S E
                                                        </td>
                                                        <td align="center" width="65px">
                                                            S E Price
                                                        </td>
                                                        <td width="45px" align="center">
                                                            <asp:Label ID="Label6" runat="server" Width="47px">Adder %</asp:Label></td>
                                                        <td width="45px" align="center">
                                                            CorpV
                                                        </td>
                                                        <td align="center" width="45">
                                                            SVC</td>
                                                    </tr>
                                                    <tr>
                                                        <td align="left">
                                                            <asp:Label CssClass="ws_data_right" Width="70px" ID="ListPriceLabel" runat="server"
                                                                Text=""></asp:Label><asp:Label ID="DummyListPriceLabel" runat="server" CssClass="ws_data_right"
                                                                    Width="70px" Visible="False"></asp:Label></td>
                                                        <td>
                                                            <asp:TextBox CssClass="ws_whitebox" Width="40px" ID="DiscPcntTextBox" runat="server"
                                                                onClick="javascript:this.select();" onchange="javascript:document.form1.DiscPcntSubmit.click();return false;"
                                                                onkeypress="javascript:return clickAndGo('DiscPcntSubmit');" OnTextChanged="SellPriceChanged"></asp:TextBox><asp:Button ID="DiscPcntSubmit" name="DiscPcntSubmit" OnClick="DiscPcntSubmit_Click"
                                                                runat="server" Text="Button" Style="display: none;" CausesValidation="false" /><asp:TextBox
                                                                    ID="DummyDiscPcntTextBox" runat="server" CssClass="ws_whitebox" onchange="javascript:document.form1.DiscPcntSubmit.click();return false;"
                                                                    onclick="javascript:this.select();" onkeypress="javascript:return clickAndGo('DiscPcntSubmit');"
                                                                    OnTextChanged="SellPriceChanged" ReadOnly="True" Width="40px" Visible="False"></asp:TextBox>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox CssClass="ws_whitebox" Width="60px" ID="DiscPriceTextBox" runat="server"
                                                                onClick="javascript:this.select();" onchange="javascript:document.form1.DiscPriceSubmit.click();return false;"
                                                                onkeypress="javascript:return clickAndGo('DiscPriceSubmit');" OnTextChanged="SellPriceChanged"></asp:TextBox><asp:Button ID="DiscPriceSubmit" name="DiscPriceSubmit" OnClick="DiscPriceSubmit_Click"
                                                                runat="server" Text="Button" Style="display: none;" CausesValidation="false" /><asp:TextBox
                                                                    ID="DummyDiscPriceTextBox" runat="server" CssClass="ws_whitebox" onchange="javascript:document.form1.DiscPriceSubmit.click();return false;"
                                                                    onclick="javascript:this.select();" onkeypress="javascript:return clickAndGo('DiscPriceSubmit');"
                                                                    OnTextChanged="SellPriceChanged" ReadOnly="True" Width="60px" Visible="False"></asp:TextBox>&nbsp;
                                                        </td>
                                                        <td>
                                                            &nbsp;
                                                            <asp:TextBox CssClass="ws_whitebox_left" Width="390px" ID="LineItemCommentTextBox"
                                                                runat="server" onkeydown="return NavUpDown('CustomerItemTextBox','AddItemImageButton');"
                                                                onfocus="javascript:this.select();" MaxLength="80">
                                                            </asp:TextBox>&nbsp;
                                                        </td>
                                                        <td width="65px" align="center">
                                                            <asp:Label CssClass="ws_data_right" ID="SuperLabel" runat="server" Text="" Width="50px"></asp:Label>
                                                        </td>
                                                        <td align="center" width="65px">
                                                            <asp:Label ID="SuperPriceLabel" runat="server" CssClass="ws_data_right" Text="" Width="50px"></asp:Label>
                                                        </td>
                                                        <td width="45px" align="center">
                                                            <asp:Label ID="lblAdderPct" runat="server" CssClass="ws_data_center" ToolTip="Adder %"
                                                                Width="20px"></asp:Label></td>
                                                        <td width="45px" align="center">
                                                            <asp:Label CssClass="ws_data_center" ID="CorpVLabel" runat="server" Text="" Width="20px"
                                                                ToolTip="Corporate Velocity Code"></asp:Label>
                                                        </td>
                                                        <td align="center" width="45">
                                                            <asp:Label CssClass="ws_data_center" ID="WorkSVCLabel" runat="server" Text=" " Width="20px"></asp:Label></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Panel ID="QQInfoPanel" runat="server" BorderWidth="0">
                                                    <table width="100%" bgcolor="#b5e7f7">
                                                        <tr class="bold">
                                                            <td align="right">
                                                                Quote
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="QuoteNumberLabel" runat="server" CssClass="ws_data_center" Width="60px"></asp:Label>
                                                            </td>
                                                            <td align="right">
                                                                Contact
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="QuoteContactTextBox" runat="server" CssClass="ws_whitebox_left"
                                                                    Width="100px"></asp:TextBox>
                                                            </td>
                                                            <td align="right">
                                                                Wgt
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="CustWeightLabel" runat="server" Text="0.00" CssClass="ws_data_right"
                                                                    Width="55px"></asp:Label>
                                                            </td>
                                                            <td align="right">
                                                                Amt
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="QuoteAmountLabel" runat="server" Text="0.00" CssClass="ws_data_right"
                                                                    Width="55px"></asp:Label>
                                                            </td>
                                                            <td align="right">
                                                                Lines
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="QuoteLinesLabel" runat="server" Text="0" CssClass="ws_data_right"
                                                                    Width="20px"></asp:Label>
                                                            </td>
                                                            <td align="right">
                                                                Carrier
                                                            </td>
                                                            <td>
                                                                <asp:DropDownList ID="CarrierDropDownList" runat="server" DataTextField="Name" DataValueField="Code"
                                                                    CssClass="ws_whitebox" Height="20px" AutoPostBack="True" OnSelectedIndexChanged="CarrierDropDownList_SelectedIndexChanged">
                                                                </asp:DropDownList>
                                                            </td>
                                                            <td align="right">
                                                                Freight
                                                            </td>
                                                            <td>
                                                                <asp:DropDownList ID="FreightDropDownList" runat="server" DataTextField="Name" DataValueField="Code"
                                                                    CssClass="ws_whitebox" Height="20px">
                                                                </asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </asp:Panel>
                                            </td>
                                        </tr>
                                    </table>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="ItemSubmit" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td class="lightBg">
                        <table cellpadding="0" cellspacing="0" id="tblGrid" height="height: 320px" width="100%">
                            <tr>
                                <td valign="top" align="left" id="TDFamily" runat="server" style="display: none;">
                                    <asp:UpdatePanel UpdateMode="Conditional" ID="FamilyPanel" runat="server">
                                        <ContentTemplate>
                                            <uc1:ItemFamily ID="UCItemFamily" runat="server" OnItemClick="UpdateItemLookup" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td valign="top" width="100%">
                                    <table cellpadding="0" border="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td valign="top" id="TDItem" runat="server" style="display: none;">
                                                <asp:UpdatePanel UpdateMode="Conditional" ID="ControlPanel" runat="server">
                                                    <ContentTemplate>
                                                        <uc2:ItemControl ID="UCItemLookup" OnPackageChange="ItemControl_OnPackageChange"
                                                            OnChange="ItemControl_OnChange" runat="server" />
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="#ECF9FB" width="100%">
                                                <div class="Sbar" oncontextmenu="Javascript:return false;" id="divdatagrid" style="overflow-x: auto;
                                                    overflow-y: auto; position: relative; top: 0px; left: 0px; border: 1px solid #88D2E9;
                                                    width: 1000px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                                    scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                                    scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94" runat="server">
                                                    <asp:UpdatePanel ID="WorkSheetUpdatePanel" runat="server" UpdateMode="Conditional">
                                                        <ContentTemplate>
                                                            <table width="100%" cellpadding="0" cellspacing="0" border="0" id="tblInnerGrid">                                                                
                                                                <col width="9%" id="Col02" />
                                                                <col width="6%" id="ColLastInvoice" />
                                                                <col width="6%" id="ColLastQuote" />
                                                                <col width="6%" id="ColLastEComm" />
                                                                <col width="7%" id="ColOpenOrder" />
                                                                <col width="6%" id="ColWS" />
                                                                <col width="6%" id="ColSuggest" />
                                                                <col width="6%" id="ColCurrentEComm" />
                                                                <col width="7%" id="ColRegionLastQuote" />
                                                                <col width="7%" id="ColRegionLastOrder" />
                                                                <col width="6%" id="ColComp1" />
                                                                <col width="6%" id="ColComp2" />                                                                
                                                                <col width="8%" id="ColRefLabel" />
                                                                <col width="8%" id="ColRefData" />
                                                                <col width="6%" id="ColTots" />
                                                                <tr class="GridHead">
                                                                    <td class="r_border">
                                                                        <div class="errTxt">
                                                                            &nbsp;&nbsp;Work Sheet</div>
                                                                    </td>
                                                                    <td align="center" class="r_border">
                                                                        <asp:Label ID="LastInvoiceLabel" runat="server" Text="Last<br />Invoice"></asp:Label>
                                                                    </td>
                                                                    <td align="center" class="r_border">
                                                                        <asp:Label ID="LastQuoteLabel" runat="server" Text="Last<br />Quote"></asp:Label>&nbsp;
                                                                    </td>
                                                                    <td align="center" class="r_border">
                                                                        <asp:Label ID="LastECommLabel" runat="server" Text="Last<br />eComm"></asp:Label>&nbsp;
                                                                    </td>
                                                                    <td align="center" class="r_border">
                                                                        <asp:Label ID="OpenOrderLabel" runat="server" Text="Open Ord<br />Not Shipped"></asp:Label>&nbsp;
                                                                    </td>
                                                                    <td align="center" class="r_border">
                                                                        Suggested
                                                                    </td>
                                                                    <td align="center" class="r_border">
                                                                        Ecommerce&nbsp;</td>
                                                                    <td align="center" class="r_border">&nbsp;
                                                                        <asp:Label ID="RegionLastQuoteLabel" runat="server" Height="25px" Text="Region <br />Last Quote"
                                                                            Width="60px"></asp:Label></td>
                                                                    <td align="center" class="r_border">&nbsp;
                                                                        <asp:Label ID="RegionLastOrderLabel" runat="server" Height="25px" Text="Region <br />Last Order"
                                                                            Width="60px"></asp:Label></td>
                                                                    <td align="center" class="r_border" valign=middle>&nbsp;
                                                                        <asp:Label ID="CompNameHeader" runat="server" Height="25px" Text="Comp" Width="60px" ></asp:Label></td>
                                                                    <td align="center" class="r_border"  valign=middle>&nbsp;
                                                                        <asp:Label ID="CompPriceHeader" runat="server" Height="25px" Text="Price" Width="60px" Style="cursor:hand;" 
                                                                            Onclick="javascript:OpenCompPriceMaint('listitems','MaintenanceApps/CompetitorPriceMaint.aspx?PageMode=competitormode');"
                                                                            ToolTip="Add/Edit Competitor Pricing."></asp:Label>
                                                                        <asp:Button ID="btnRefreshCompPrice" name="CostUpdButt" OnClick="btnRefreshCompPrice_Click" runat="server"
                                                                        Text="Button" Style="display: none;" CausesValidation="false" /></td>                                                                    
                                                                    <td align="right" colspan="3">
                                                                        <table cellpadding=0 cellspacing=0 border=0> 
                                                                            <tr>
                                                                                <td style="padding-right:3px;">                                                                                    
                                                                                <asp:ImageButton runat=server id="ibtnWebQueue" ImageUrl="~/Common/Images/Q_OFF.GIF" style="cursor: hand;height:20px;"  
                                                                                CausesValidation=false 
                                                                                OnClick="ibtnWebQueue_Click" OnClientClick="ShowWebQueue();"/>
                                                                                </td>
                                                                                <td style="padding-right:3px;">
                                                                                    <img height="20px" width="20px" alt="Weight" src="Common/Images/truck.jpg" style="cursor: hand"
                                                                            onclick="ShowWeight();">
                                                                                </td>
                                                                                <td  style="padding-right:3px;">
                                                                                    <asp:Image ID="PackPlateButt" runat="server" Style="cursor: hand" onclick="javascript:ShowPackPlate();"
                                                                            alt="Show Packing and Plating" ImageUrl="Common/Images/PackPlate.gif" />
                                                                                </td>
                                                                                <td style="padding-right:3px;">
                                                                                    <asp:Image ID="HistoryButt" runat="server" Style="cursor: hand" onclick="javascript:ShowCustItemHist();"
                                                                            alt="Show Customer History" ImageUrl="Common/Images/History.gif" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr class="priceLightLabel">                                                                    
                                                                    <td class="r_border">
                                                                        <b>Date</b>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="DateLastInvoiceLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="DateLastQuoteLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="DateLastECommLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="DateOpenOrderLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td align="right" class="r_border" id="tdPromoTitle" runat=server>
                                                                        <asp:HyperLink ID="hplPromo" runat="server" ToolTip="Click here to view active promotions for this customer." style="cursor:hand;" onclick="javascript:OpenPromoDetail();" Font-Bold="True" Font-Underline="True">Promo:</asp:HyperLink>
                                                                    </td>
                                                                    <td class="r_border " align=left>
                                                                        &nbsp;<asp:Label ID="lblPromo" runat="server" Text=" " Font-Bold=true ToolTip=""></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;                                                                             
                                                                        <asp:Label ID="DateRegionLastQuote" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                     &nbsp;
                                                                     <asp:Label ID="DateRegionLastOrder" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                     &nbsp;<asp:Label ID="Comp1Name" runat="server" Text=" " style="cursor:hand;" ToolTip="Click here to view competitor history."></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                     &nbsp;<asp:Label ID="Comp1Price" runat="server" Text=" " style="cursor:hand;" ToolTip="Edit Competitor Price."></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td colspan="2" style="padding-right:5px;height:19px;">
                                                                        <asp:LinkButton ID="lnkCalcFreight" runat="server" Font-Bold="True" ToolTip="Click here to calculate freight." style="cursor:hand;" CausesValidation=false OnClick="lnkCalcFreight_Click">FREIGHT $0.00</asp:LinkButton>                                                                        
                                                                    </td>
                                                                </tr>
                                                                <tr class="priceDarkLabel">
                                                                    <td class="r_border">
                                                                        <b>Quantity</b>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="QtyLastInvoiceLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="QtyLastQuoteLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="QtyLastECommLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="QtyOpenOrderLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                         <asp:Label ID="QtyLastRegionQuoteLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                     &nbsp;
                                                                     <asp:Label ID="QtyLastRegionOrderLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;<asp:Label ID="Comp2Name" runat="server" Text=" " style="cursor:hand;" ToolTip="Click here to view competitor history."></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;<asp:Label ID="Comp2Price" runat="server" Text=" " style="cursor:hand;" ToolTip="Edit Competitor Price."></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td class="r_border" style="width: 7%;height:19px;">
                                                                        <strong>Item</strong>&nbsp;
                                                                    </td>
                                                                    <td>
                                                                        <strong>Total Order</strong> &nbsp;
                                                                    </td>
                                                                </tr>
                                                                <tr class="priceLightLabel">                                                                   
                                                                    <td class="r_border"  id="tdPrice" runat=server>
                                                                        <b>Price</b>
                                                                    </td>
                                                                    <td class="r_border bold">
                                                                        &nbsp;
                                                                        <asp:Label ID="SellLastInvoiceLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border bold">
                                                                        &nbsp;
                                                                        <asp:Label ID="SellLastQuoteLabel" runat="server" Text=" "></asp:Label>
                                                                        </td>
                                                                    <td class="r_border bold">
                                                                        &nbsp;
                                                                        <asp:Label ID="SellLastECommLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border bold">
                                                                        &nbsp;
                                                                        <asp:Label ID="SellOpenOrderLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border" align="center">
                                                                        <asp:TextBox CssClass="ws_whitebox" ID="WorkSellPriceTextBox" runat="server" Style="font-weight: bold;"
                                                                            onkeydown="return NavUpDown('SellPriceTextBox','MgnCostTextBox','WsSellPriceSubmit');"
                                                                            onchange="javascript:document.form1.WsSellPriceSubmit.click();return false;"
                                                                            onfocus="javascript:this.select();" OnTextChanged="SellPriceChanged"></asp:TextBox>
                                                                        <asp:Button ID="WsSellPriceSubmit" name="WsSellPriceSubmit" OnClick="WsSellPriceButt_Click"
                                                                            runat="server" Text="Button" Style="display: none;" CausesValidation="true" />
                                                                    </td>
                                                                    <td class="r_border bold" align="right" id="tdPromoPrice" runat=server>
                                                                        &nbsp;
                                                                        <asp:Label ID="SellSuggestLabel1" runat="server" Text=" "></asp:Label>
                                                                        <asp:Label ID="WebPriceLabel" runat="server" Text=" " Style="color: Green;"></asp:Label>
                                                                        </td>
                                                                    <td align="right" class="r_border bold">
                                                                        &nbsp;
                                                                        <asp:Label ID="SellLastRegionQuoteLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td align="right" class="r_border bold">
                                                                     &nbsp;
                                                                     <asp:Label ID="SellLastRegionOrderLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;<asp:Label ID="Comp3Name" runat="server" Text=" " style="cursor:hand;" ToolTip="Click here to view competitor history."></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;<asp:Label ID="Comp3Price" runat="server" Text=" " style="cursor:hand;" ToolTip="Edit Competitor Price."></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        <strong>Amount $</strong>&nbsp;</td>
                                                                    <td class="r_border" align="right" style="width: 6%">
                                                                        &nbsp;
                                                                        <asp:Label ID="ItemAmtLabel" runat="server" Text=" " Visible=false></asp:Label>
                                                                        <asp:Label ID="TotAmtLabel" runat="server"  Text=" "></asp:Label>
                                                                    </td>
                                                                    <td valign="middle" align="Right">                                                                        
                                                                        <asp:Label ID="TotOrdAmtLabel" runat="server" Text=" "></asp:Label>&nbsp;
                                                                    </td>
                                                                </tr>
                                                                <tr class="priceDarkLabel">
                                                                    <td class="r_border"  id="tdMgnPctAtAvg" runat=server>
                                                                        <b>Mgn% @ Avg</b>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="MgnCostLastInvoiceLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="MgnCostLastQuoteLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="MgnCostLastECommLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="MgnCostOpenOrderLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border" align="center">
                                                                        <asp:TextBox CssClass="ws_whitebox" ID="MgnCostTextBox" runat="server" onkeydown="return NavUpDown('WorkSellPriceTextBox','MgnStdTextBox','WsMgnCostSubmit');"
                                                                            onchange="javascript:document.form1.WsMgnCostSubmit.click();return false;" onfocus="javascript:this.select();"
                                                                            OnTextChanged="SellPriceChanged"></asp:TextBox>
                                                                        <asp:Button ID="WsMgnCostSubmit" name="WsMgnCostSubmit" OnClick="WsMgnCostSubmit_Click"
                                                                            runat="server" Text="Button" Style="display: none;" CausesValidation="true" />
                                                                    </td>
                                                                    <td class="r_border" align="right">
                                                                        &nbsp;
                                                                        <asp:Label ID="MgnCostSuggestLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td align="right" class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="MgnCostLastRegionQuoteLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td align="right" class="r_border">
                                                                     &nbsp;
                                                                        <asp:Label ID="MgnCostLastRegionOrdLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;<asp:Label ID="Comp4Name" runat="server" Text=" " style="cursor:hand;" ToolTip="Click here to view competitor history."></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;<asp:Label ID="Comp4Price" runat="server" Text=" " style="cursor:hand;" ToolTip="Edit Competitor Price."></asp:Label>
                                                                    </td>
                                                                    <td class="r_border" align="right">
                                                                        <strong>&nbsp;Mgn%</strong></td>
                                                                    <td class="r_border" style="width: 6%">
                                                                        &nbsp;
                                                                        <asp:Label ID="ItemMgnPctLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td align="right">                                                                        
                                                                        &nbsp;
                                                                        <asp:Label ID="TotOrdMgnPctLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr class="priceLightLabel">
                                                                    <td class="r_border"  id="tdMgnPctAtRepl" runat=server>
                                                                        <b>Mgn% @ Repl</b>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="MgnReplLastInvoiceLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="MgnReplLastQuoteLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="MgnReplLastECommLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="MgnReplOpenOrderLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border" align="center">
                                                                        <asp:TextBox CssClass="ws_whitebox" ID="MgnReplTextBox" runat="server" onkeydown="return NavUpDown('MgnStdTextBox','SellLBTextBox','WsReplCostSubmit');"
                                                                            onchange="javascript:document.form1.WsReplCostSubmit.click();return false;" onfocus="javascript:this.select();"
                                                                            OnTextChanged="SellPriceChanged"></asp:TextBox>
                                                                        <asp:Button ID="WsReplCostSubmit" name="WsReplCostSubmit" OnClick="WsReplCostSubmit_Click"
                                                                            runat="server" Text="Button" Style="display: none;" CausesValidation="true" />
                                                                    </td>
                                                                    <td class="r_border" align="right">
                                                                        &nbsp;
                                                                        <asp:Label ID="MgnReplSuggestLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td align="right" class="r_border">
                                                                     &nbsp;
                                                                     <asp:Label ID="MgnReplLasRegionQuoteLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td align="right" class="r_border">
                                                                     &nbsp;
                                                                     <asp:Label ID="MgnReplLasRegionOrdLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;<asp:Label ID="Comp5Name" runat="server" Text=" " style="cursor:hand;" ToolTip="Click here to view competitor history."></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;<asp:Label ID="Comp5Price" runat="server" Text=" " style="cursor:hand;" ToolTip="Edit Competitor Price."></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        <strong>&nbsp;Mgn$</strong></td>
                                                                    <td class="r_border" style="width: 6%">
                                                                        &nbsp; 
                                                                        <asp:Label ID="ItemMgnDolLabel" runat="server" Text=" "></asp:Label>
                                                                        </td>
                                                                    <td valign="middle" align="right">
                                                                        &nbsp;
                                                                        <asp:Label ID="TotOrdMgnDolLabel" runat="server" Text=" "></asp:Label></td>
                                                                </tr>
                                                                <tr class="priceDarkLabel">
                                                                    <td class="r_border">
                                                                        <b>Price / LB</b>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="SellLBLastInvoiceLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="SellLBLastQuoteLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="SellLBLastECommLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="SellLBOpenOrderLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border" align="center">
                                                                        <asp:TextBox CssClass="ws_whitebox" ID="SellLBTextBox" runat="server" onkeydown="return NavUpDown('MgnReplTextBox','MarginLBTextBox','WsSellLBSubmit');"
                                                                            onchange="javascript:document.form1.WsSellLBSubmit.click();return false;" onfocus="javascript:this.select();"
                                                                            OnTextChanged="SellPriceChanged"></asp:TextBox>
                                                                        <asp:Button ID="WsSellLBSubmit" name="WsSellLBSubmit" OnClick="WsSellLBSubmit_Click"
                                                                            runat="server" Text="Button" Style="display: none;" CausesValidation="true" />
                                                                    </td>
                                                                    <td class="r_border" align="right">
                                                                        &nbsp;
                                                                        <asp:Label ID="SellLBSuggestLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td align="right" class="r_border">
                                                                     &nbsp;
                                                                     <asp:Label ID="SellLBLastRegionQuoteLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td align="right" class="r_border">
                                                                     &nbsp;                              
                                                                     <asp:Label ID="SellLBLastRegionOrdLabel" runat="server" Text=" "></asp:Label>                                      
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;<asp:Label ID="Comp6Name" runat="server" Text=" " style="cursor:hand;" ToolTip="Click here to view competitor history."></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;<asp:Label ID="Comp6Price" runat="server" Text=" " style="cursor:hand;" ToolTip="Edit Competitor Price."></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        <strong><asp:Label ID="lblGrossWghtDesc" runat=server Text="Gross Wgt" Width="60px"></asp:Label></strong></td>
                                                                    <td class="r_border" align="right" style="width: 6%">
                                                                        &nbsp;<asp:Label ID="WorkItemWeightLabel" runat="server" Text=" "></asp:Label>
                                                                        </td>
                                                                    <td align="right">
                                                                        &nbsp;
                                                                         <asp:Label ID="TotOrdGrossWghtLabel" runat="server" Text=" "></asp:Label>                                                                    
                                                                    </td>
                                                                </tr>
                                                                <tr  class="priceLightLabel">
                                                                    <td class="r_border">
                                                                        <b>Mgn $ / LB</b>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="MarginLBLastInvoiceLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="MarginLBLastQuoteLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="MarginLBLastECommLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;
                                                                        <asp:Label ID="MarginLBOpenOrderLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border" align="center">
                                                                        <asp:TextBox CssClass="ws_whitebox" ID="MarginLBTextBox" runat="server" onkeydown="return NavUpDown('SellLBTextBox','AddItemImageButton','WsMgnLBSubmit');"
                                                                            onchange="javascript:document.form1.WsMgnLBSubmit.click();return false;" onfocus="javascript:this.select();"
                                                                            OnTextChanged="SellPriceChanged"></asp:TextBox>
                                                                        <asp:Button ID="WsMgnLBSubmit" name="WsMgnLBSubmit" OnClick="WsMgnLBSubmit_Click"
                                                                            runat="server" Text="Button" Style="display: none;" CausesValidation="true" />
                                                                    </td>
                                                                    <td class="r_border" align="right">
                                                                        &nbsp;
                                                                        <asp:Label ID="MarginLBSuggestLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td align="right" class="r_border">
                                                                     &nbsp;
                                                                     <asp:Label ID="MarginLBLastRegionQuoteLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td align="right" class="r_border">
                                                                     &nbsp;
                                                                     <asp:Label ID="MarginLBLastRegionOrderLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;<asp:Label ID="Comp7Name" runat="server" Text=" " style="cursor:hand;" ToolTip="Click here to view competitor history."></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;<asp:Label ID="Comp7Price" runat="server" Text=" " style="cursor:hand;" ToolTip="Edit Competitor Price."></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        <b>Net Wgt</b>
                                                                    </td>
                                                                    <td class="r_border" align="right" style="width: 6%">
                                                                        &nbsp;
                                                                        <asp:Label ID="WorkNetWeightLabel" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td align="right">
                                                                        &nbsp;<asp:Label ID="TotOrdNetWghtLabel" runat="server" Text=" "></asp:Label>
                                                                        </td>
                                                                </tr>
                                                                <tr class="priceDarkLabel">
                                                                    <td class="r_border" style="height:20px;">
                                                                        <strong>Target</strong></td>
                                                                    <td class="r_border">
                                                                        &nbsp;</td>
                                                                    <td class="r_border">
                                                                    &nbsp;
                                                                    </td>
                                                                    <td class="r_border">
                                                                    &nbsp;
                                                                    </td>
                                                                    <td class="r_border">
                                                                    &nbsp;<asp:Label ID="lblTargetPrice" runat=server Text="" Font-Bold=true></asp:Label>
                                                                    </td>
                                                                    <td align="right" class="r_border">
                                                                    &nbsp;<asp:Label ID="lblTargetDisc" runat=server Text="" Font-Bold=true></asp:Label>
                                                                    </td>
                                                                    <td align="right" class="r_border">
                                                                    &nbsp;
                                                                    </td>
                                                                    <td align="right" class="r_border">
                                                                    &nbsp;
                                                                    </td>
                                                                    <td align="right" class="r_border">
                                                                    &nbsp;
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;<asp:Label ID="Comp8Name" runat="server" Text=" " style="cursor:hand;" ToolTip="Click here to view competitor history."></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        &nbsp;<asp:Label ID="Comp8Price" runat="server" Text=" " style="cursor:hand;" ToolTip="Edit Competitor Price."></asp:Label>
                                                                    </td>
                                                                    <td class="r_border">
                                                                        <strong>Wght/100</strong>&nbsp;
                                                                    </td>
                                                                    <td align="right" class="r_border" style="width: 6%">
                                                                    &nbsp;<asp:Label ID="WorkWght100Label" runat="server" Text=" "></asp:Label>
                                                                    </td>
                                                                    <td align="right">
                                                                    &nbsp;
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </div>
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
                        <table width="100%">
                            <tr>
                                <td class="bold">
                                    <asp:UpdatePanel ID="CategoryUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            &nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="CategorySpecLabel" runat="server"></asp:Label>&nbsp;
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td>
                                    <asp:TextBox ID="RemoteDataTextBox" runat="server" TextMode="MultiLine" Style="display: none;"></asp:TextBox>
                                </td>
                                <td align="right">
                                    <asp:UpdatePanel ID="CameraUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:Image ID="CameraButt" runat="server" Style="cursor: hand" onclick="javascript:ShowPartImage();"
                                                AlternateText="Show Part Image" ImageUrl="Common/Images/camera.gif" />&nbsp;&nbsp;
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%">
                            <tr>
                                <td align="left">
                                    <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:Label ID="MessageLabel" runat="server"></asp:Label>&nbsp;
                                            <asp:RequiredFieldValidator ID="ItemNoRequiredFieldValidator" runat="server" ErrorMessage="Item Number is Required. "
                                                ControlToValidate="CustomerItemTextBox" Display="Dynamic" SetFocusOnError="true"
                                                CssClass="ValidationError"></asp:RequiredFieldValidator>
                                            <asp:RequiredFieldValidator ID="QtyRequiredFieldValidator" runat="server" ErrorMessage="Qty is Required. "
                                                ControlToValidate="RequestedQtyTextBox" Display="Dynamic" SetFocusOnError="true"
                                                CssClass="ValidationError"></asp:RequiredFieldValidator>
                                            <asp:RequiredFieldValidator ID="PriceRequiredFieldValidator" runat="server" ErrorMessage="Price is Required. "
                                                ControlToValidate="SellPriceTextBox" Display="Dynamic" SetFocusOnError="true"
                                                CssClass="ValidationError"></asp:RequiredFieldValidator>
                                            <asp:RequiredFieldValidator ID="WSAltPriceRequiredFieldValidator" runat="server"
                                                ErrorMessage="Worksheet Price is required. " Display="Dynamic" CssClass="ValidationError"
                                                SetFocusOnError="true" ControlToValidate="WorkSellPriceTextBox"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="WSAltPriceRegularExpressionValidator" runat="server"
                                                ErrorMessage="Worksheet Price is invalid. " ControlToValidate="WorkSellPriceTextBox"
                                                Display="Dynamic" SetFocusOnError="true" CssClass="ValidationError" ValidationExpression="-?\d*,?\d+\.?\d*\s*"></asp:RegularExpressionValidator>
                                            <asp:RequiredFieldValidator ID="MgnCostRequiredFieldValidator" runat="server" ErrorMessage="Worksheet Margin at Average Cost is required. "
                                                Display="Dynamic" CssClass="ValidationError" SetFocusOnError="true" ControlToValidate="MgnCostTextBox"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="MgnCostRegularExpressionValidator" runat="server"
                                                ErrorMessage="Worksheet Margin at Average Cost is invalid. " ControlToValidate="MgnCostTextBox"
                                                Display="Dynamic" SetFocusOnError="true" CssClass="ValidationError" ValidationExpression="-?\d*,?\d+\.?\d*\s*|-?\d*,?\d*\.?\d+\s*"></asp:RegularExpressionValidator>
                                            <asp:RequiredFieldValidator ID="SellLBRequiredFieldValidator" runat="server" ErrorMessage="Worksheet Price per LB is required. "
                                                Display="Dynamic" CssClass="ValidationError" SetFocusOnError="true" ControlToValidate="SellLBTextBox"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="SellLBRegularExpressionValidator" runat="server"
                                                ErrorMessage="Worksheet Price per LB is invalid. " ControlToValidate="SellLBTextBox"
                                                Display="Dynamic" SetFocusOnError="true" CssClass="ValidationError" ValidationExpression="-?\d*,?\d+\.?\d*\s*|-?\d*,?\d*\.?\d+\s*"></asp:RegularExpressionValidator>
                                            <asp:RequiredFieldValidator ID="MarginLBRequiredFieldValidator" runat="server" ErrorMessage="Worksheet Margin per LB is required. "
                                                Display="Dynamic" CssClass="ValidationError" SetFocusOnError="true" ControlToValidate="MarginLBTextBox"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="MarginLBRegularExpressionValidator" runat="server"
                                                ErrorMessage="Worksheet Margin per LB is invalid. " ControlToValidate="MarginLBTextBox"
                                                Display="Dynamic" SetFocusOnError="true" CssClass="ValidationError" ValidationExpression="-?\d*,?\d+\.?\d*\s*|-?\d*,?\d*\.?\d+\s*"></asp:RegularExpressionValidator>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td align="right">
                                    <asp:UpdatePanel ID="ActionUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <table>
                                                <tr>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:HiddenField ID="hidShowHide" runat="server" />
                                                        <asp:ImageButton ID="imgShowItemBuilder" ImageUrl="~/Common/Images/showitembuilder.gif"
                                                            runat="server" AlternateText="Show Item Builder" OnClick="imgShowItemBuilder_Click"
                                                            OnClientClick="Javascript:document.getElementById('TDFamily').style.display='';SetGridHeight('ItemFamily');return true;" />&nbsp;
                                                        <asp:ImageButton ID="ibtnHide" ImageUrl="~/Common/Images/hideitembuilder.gif" runat="server"
                                                            AlternateText="Hide Item Builder" OnClick="ibtnHide_Click" OnClientClick="Javascript:document.getElementById('TDFamily').style.display='none';SetGridHeight('ItemFamily');return true;"
                                                            Visible="false" />
                                                    </td>
                                                    <td>
                                                        <img src="Common/Images/quote.gif" style="cursor: hand" onclick="DoQuickQuote();"
                                                            alt="Quick Quote">&nbsp;
                                                        <asp:ImageButton ID="ReviewQuoteButton" runat="server" ImageUrl="~/Common/Images/ReviewQuote.gif"
                                                            CausesValidation="false" OnClientClick="DoReviewQuote();" ToolTip="Review Quote (Quick Access: - Sign)" />
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="QuoteRecallButton" runat="server" ImageUrl="~/Common/Images/QuoteRecall.gif"
                                                            CausesValidation="false" OnClientClick="DoQuoteRecall();" ToolTip="Recall Quote (Quick Access: + Sign)"/>
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="StockStatButt" runat="server" CausesValidation="false" ImageUrl="~/Common/Images/StockStatus.gif"
                                                            OnClientClick="DoStockStatus();" />
                                                    </td>
                                                    <%--                                            <td>
                                                <asp:ImageButton ID="CreditRGAButton" runat="server" ImageUrl="~/Common/Images/CreditRGA.gif" 
                                                CausesValidation="false" OnClientClick="DoCreditRGA();" />
                                            </td>
                                                onfocus="javascript:if(RefreshNeeded == 1){document.form1.SellPriceSubmit.click()};"
                                                onkeyDown="javascript:if(event.keyCode==9){this.click();return false;}"
--%>
                                                    <td>
                                                        <asp:ImageButton ID="AddItemImageButton" ImageUrl="~/Common/Images/additem.gif" onkeydown="return NavUpDown('SellPriceTextBox','WorkSellPriceTextBox','AddItemImageButton');"
                                                            OnClientClick="return CheckAddLine(this);" OnClick="AddItemImageButton_Click"
                                                            runat="server" AlternateText="Add Item" AccessKey="A" ToolTip="Add Line. Alt-A is a shortcut." />
                                                        <asp:Button ID="RefreshButton" name="RefreshButton" OnClientClick="javascript:RefreshMainPage();"
                                                            Style="display: none;" runat="server" Text="Button" CausesValidation="false" />
                                                    </td>
                                                    <td>
                                                        <img src="Common/Images/close.gif" style="cursor: hand" onclick="ClosePage();">&nbsp;&nbsp;
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                        <Triggers>
                                            <asp:PostBackTrigger ControlID="AddItemImageButton" />
                                        </Triggers>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                                <td align="right">
                                    <asp:UpdatePanel ID="CustExtraUpdatePanel" UpdateMode="Conditional" runat="server">
                                        <ContentTemplate>
                                            <asp:Label ID="CustExtraLabel" Style="color: Red; font-size: 36px;" runat="server"
                                                Text=""></asp:Label>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign=top>
                        <asp:UpdatePanel ID="MainImagePanel" runat="server">
                            <ContentTemplate>
                                <table>
                                    <tr>
                                        <td>
                                            <asp:UpdatePanel ID="HeadImageUpdatePanel" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:Image ID="HeadImage" runat="server" Height="75" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td>
                                            <asp:UpdatePanel ID="BodyImageUpdatePanel" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:Image ID="BodyImage" runat="server" Height="75" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:UpdatePanel UpdateMode="Conditional" ID="TestPanel" runat="server" Visible="false">
                            <ContentTemplate>
                                <asp:TextBox ID="BigTextBox" runat="server" Rows="30" TextMode="MultiLine" Width="800"></asp:TextBox>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>

<script>
    //alert(window.opener.parent.bodyFrame.document.getElementById('CustDet_lblSold_City').innerText);
    if (window.opener.parent.bodyFrame != null)
    {
        // get various header data
        document.form1.OrderType.value = window.opener.parent.bodyFrame.document.getElementById('ucOrderType_lblValue').innerText;
        document.form1.ShipDate.value = window.opener.parent.bodyFrame.document.getElementById('dtqShdate$textBox').innerText;
        document.form1.RequestedShipDate.value = window.opener.parent.bodyFrame.document.getElementById('dtpReqdShipDate_textBox').value;
        document.form1.CustCertRequiredInd.value = window.opener.parent.bodyFrame.document.getElementById('CertsReqdCheckBox').checked;
        // get the sold to info
        document.form1.SoldToCity.value = window.opener.parent.bodyFrame.document.getElementById('CustDet_lblSold_City').innerText;
        document.form1.SoldToState.value = window.opener.parent.bodyFrame.document.getElementById('CustDet_lblSold_Territory').innerText;
        document.form1.SoldToZip.value = window.opener.parent.bodyFrame.document.getElementById('CustDet_lblSold_Pincode').innerText;
        document.form1.SoldToCountry.value = window.opener.parent.bodyFrame.document.getElementById('CustDet_lblSoldCountry').innerText;
        document.form1.SoldToPhone.value = window.opener.parent.bodyFrame.document.getElementById('CustDet_lblSold_Phone').innerText;
        // get the ship to info
        document.form1.ShipToNo.value = window.opener.parent.bodyFrame.document.getElementById('CustDet_lblCustNum').innerText;
        document.form1.ShipToName.value = window.opener.parent.bodyFrame.document.getElementById('CustDet_lblShip_Name').innerText;
        document.form1.ShipToCity.value = window.opener.parent.bodyFrame.document.getElementById('CustDet_lblShip_City').innerText;
        document.form1.ShipToState.value = window.opener.parent.bodyFrame.document.getElementById('CustDet_lblShip_Territory').innerText;
        document.form1.ShipToZip.value = window.opener.parent.bodyFrame.document.getElementById('CustDet_lblShip_Pincode').innerText;
        document.form1.ShipToCountry.value = window.opener.parent.bodyFrame.document.getElementById('CustDet_lblShipCountry').innerText;
        document.form1.ShipToPhone.value = window.opener.parent.bodyFrame.document.getElementById('CustDet_lblShip_Phone').innerText;
    }
</script>

</html>
