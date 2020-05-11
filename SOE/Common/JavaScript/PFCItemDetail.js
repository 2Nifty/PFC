// JScript File fetch the item details
function GetItemDetail(event)
{
    if(event.keyCode==13)
    {    
        CheckCrossReferenceNumber(document.getElementById("txtINo1").value);
        
    }
    else if(event.keyCode==9)
    {
        document.form1.btnCustItem.click();
    }
}


function CheckCrossReferenceNumber(itemNo)
{
    if(itemNo!="")
    {
        var section="";
        var completeItem=0;
       
        switch(itemNo.split('-').length)
        {
        case 1:
            event.keyCode=0;
            itemNo = "00000" + itemNo;
            itemNo = itemNo.substr(itemNo.length-5,5);
            document.getElementById("txtINo1").value=itemNo+"-"; 
            // document.getElementById("lblMessage").innerText ="Item not found";
            return ;
            break;
        case 2:
            // close if they are entering an empty part
            if (itemNo.split('-')[0] == "00000") {ClosePage()};
            event.keyCode=0;
            section = "0000" + itemNo.split('-')[1];
            section = section.substr(section.length-4,4);
            document.getElementById("txtINo1").value=itemNo.split('-')[0]+"-"+section+"-";  
             //document.getElementById("lblMessage").innerText ="Item not found";
             return ;
            break;
        case 3:
            event.keyCode=0;
            section = "000" + itemNo.split('-')[2];
            section = section.substr(section.length-3,3);
            document.getElementById("txtINo1").value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
            completeItem=1;
            break;
        
        }
        if (completeItem==1) document.form1.btnPFCItem.click();        
    }   
}

function IsNumeric(strString)
{
   var strValidChars = "0123456789";
   var strChar;
   var blnResult = true;

   if (strString.length < 1) return false;

    //  test strString consists of valid characters listed above
    for (i = 0; i < strString.length && blnResult == true; i++)
    {
      strChar = strString.charAt(i);
      if (strValidChars.indexOf(strChar) == -1){blnResult = false;}
    }
   return blnResult;
}
function AddZero(inct,value)
{
    var itemValue=value;
    
    for(var i=0;i<inct;i++)
    {
        itemValue="0"+itemValue;
    }
    
    return itemValue;
}

function FillItemDetail(arItemDetails)
{
    //document.getElementById("txtItemNo").value=arItemDetails[0];
    //document.getElementById("txtINo1").value=arItemDetails[0].split('-')[0];
    //document.getElementById("txtINo2").value=arItemDetails[0].split('-')[1];
    //document.getElementById("txtINo3").value=arItemDetails[0].split('-')[2];
    if(document.getElementById("hidItem").value!="")
    {
        document.getElementById("txtINo1").value=document.getElementById("hidItem").value=arItemDetails[0];
        document.getElementById("txtUnitPrice").value=arItemDetails[5];
        //document.getElementById("lnkUnitPrice").innerText=arItemDetails[5];
        document.getElementById("txtMarginPct").value=arItemDetails[12];
        document.getElementById("txtPriceLb").value=arItemDetails[6];
        document.getElementById("hidTotalAvQty").value=arItemDetails[9];
        document.getElementById("txtReqQty").focus();
        document.getElementById("lblDesription").innerHTML=arItemDetails[1];
        document.getElementById("lblBuom").innerHTML=arItemDetails[3];
        document.getElementById("lblSupEquiv").innerHTML=arItemDetails[4];
    }
}

function ClearItemDetails()
{
    //document.getElementById("txtINo2").value="";
    //document.getElementById("txtINo3").value="";
    
    //document.getElementById("lnkUnitPrice").innerText="";
    document.getElementById("txtINo1").value="";
    document.getElementById("hidItem").value="";
    document.getElementById("txtUnitPrice").value="";
    document.getElementById("txtMarginPct").value="";
    document.getElementById("txtPriceLb").value="";
    document.getElementById("hidTotalAvQty").value="";
    document.getElementById("lblDesription").innerHTML="";
}


function CheckAvailQty(requestQty)
{
  
    
     btnGetPrice
}


function OnDropDownClick(ctrlID)
{
    if(document.getElementById(ctrlID))
    {
        var ddlCurrent=document.getElementById(ctrlID);
        if(ddlCurrent.value!="")
        {
            if(document.getElementById(ctrlID.replace('ddl','hid')).value=='1')
            {
                document.getElementById(ctrlID.replace('ddl','hid')).value='0';
                document.getElementById("UCItemLookup_hidControlName").value=ctrlID+"`"+ddlCurrent.options[ddlCurrent.selectedIndex].value;
                var btnBind=document.getElementById("UCItemLookup_btnPost");
                document.getElementById(ctrlID.replace('UCItemLookup_ddl','div')).style.display='none';
               
               if (typeof btnBind == 'object'){
                     btnBind.click(); return false; }
            }
            else
                document.getElementById(ctrlID.replace('UCItemLookup_ddl','div')).style.display='none';
       }
       else
            document.getElementById(ctrlID.replace('UCItemLookup_ddl','div')).style.display='none';
    }
}


function UpdateQuote(reqQty,ctrlId)
{
    var previousQty=document.getElementById(ctrlId.replace("txtQty","hidTotAvailableQty")).value;
    if(eval(reqQty)<=eval(previousQty))
        SetValue(reqQty,ctrlId,'Valid');   
    else 
        SetValue(reqQty,ctrlId,'In Valid');
}

function SetValue(reqQuantity,ctlID,setFlag)
{
    
    document.body.style.cursor = 'wait';
    
    // Get the value for Request Quantity
    reqQuantity=((setFlag=="Valid")?reqQuantity:document.getElementById(ctlID.replace("txtQty","hidTotAvailableQty")).value);
    reqQuantity=((reqQuantity.indexOf('.')==-1)?reqQuantity:reqQuantity.split('.')[0]);
    
    //
    // Code to indicate the user to choose other location 
    // when stock is not available in current location    
    //
    document.getElementById(ctlID).value=reqQuantity;
    document.getElementById(ctlID.replace("txtQty","hidReqQty")).value=reqQuantity;
    document.getElementById(ctlID.replace("txtQty","lblAvailQty")).innerHTML=((setFlag=='In Valid')?"See Other Loc.":reqQuantity);
    document.getElementById(ctlID.replace("txtQty","lblAvailQty")).style.color=((setFlag=='In Valid')?"blue":"black");
    document.getElementById(ctlID.replace("txtQty","lblAvailQty")).style.cursor=((setFlag=='In Valid')?"Hand":"Default");
    
    // 
    // Code to set values to the control
    //
    var unitPrice=document.getElementById(ctlID.replace("txtQty","hidUnitPrice")).value;
    var unitWeight=document.getElementById(ctlID.replace("txtQty","hidGrossWt")).value;
    var extAmt=(eval(unitPrice)*eval(reqQuantity)).toFixed(2);
    var extWt=(eval(unitWeight)*eval(reqQuantity)).toFixed(2);
    document.getElementById(ctlID.replace("txtQty","lblExtAmount")).innerHTML='$'+extAmt;                    
    document.getElementById(ctlID.replace("txtQty","hidExtAmount")).value=extAmt;
    document.getElementById(ctlID.replace("txtQty","lblExtWt")).innerHTML=extWt;                    
    document.getElementById(ctlID.replace("txtQty","hidExtWt")).value=extWt;
    document.getElementById(ctlID.replace("txtQty","chkSelect")).parentElement.disabled=false; 
    
    
    if(setFlag=="Valid" && reqQuantity.toString()!=document.getElementById(ctlID.replace("txtQty","hidPreviousValue")).value)
    {
        // Call the server side function to update the quote detail
        UpdateQuoteValue(document.getElementById(ctlID),"Quote");
        
        //
        // Open the available stock window to choose the item from other locations
        //
        if(document.getElementById(ctlID.replace("txtQty","lblLocCode")).innerHTML.indexOf(',')!=-1)
        {
            var url="AvailableStock.aspx?Type=Selected&mode=newquote&CustomerItemNo="+document.getElementById(ctlID.replace("txtQty","lblCustItem")).innerHTML+"&QuoteNo="+document.getElementById(ctlID.replace("txtQty","lblQuoteNo")).innerHTML+"&Quantity="+document.getElementById(ctlID).value+"&Control="+ctlID.replace("txtQty","lblAvailQty")+"&Base="+document.getElementById(ctlID.replace("txtQty","lblBaseUOM")).innerHTML.replace("/","~");
            window.open(url,"AvailableStock" ,'height=410px,width=480,scrollbars=no,status=no,top=300,left=500,resizable=no',"");
        }
    }
    
    document.body.style.cursor ="arrow";
}

function ItemNoKeyPress()
{
    if(event.keyCode==39)event.keyCode=0;
    if(event.keyCode==13){
    CheckItemNumber(document.getElementById("txtItemNo").value);
    return false;
    };
}



//
// Function to update the quote detail
//
function UpdateQuoteValue(ctrl,flag)
{
    var strUpdateString='';
    // Get the update value in the string
    if(flag=="Quote")
        strUpdateString=document.getElementById(ctrl.id.replace("txtQty","lblQuoteNo")).innerHTML+"`"+
                        ctrl.value+"`"+
                        document.getElementById(ctrl.id.replace("txtQty","lblExtAmount")).innerHTML+"`"+
                        document.getElementById(ctrl.id.replace("txtQty","lblExtWt")).innerHTML+"`"+
                        document.getElementById(ctrl.id.replace("txtQty","txtQuoteRemark")).value;
    else
        strUpdateString=document.getElementById(ctrl.id.replace("txtQuoteRemark","lblQuoteNo")).innerHTML+"`"+ctrl.value;
                        
    // Call the server side function using ajax to update value in the database
    OrderEntryPage.UpdateQuoteDetails(strUpdateString,flag);
    
    // Call the function to update the total
    QuantityTotal();
}

//
// Function to open the available stock window 
//
function WindowOpen(ctrlID)
{
    var strID=document.getElementById(ctrlID).innerText; 
    if(strID=="See Other Loc.")
    {
        var strQty=document.getElementById(ctrlID.replace("lblAvailQty","hidReqQty")).value;
        var strItem=document.getElementById(ctrlID.replace("lblAvailQty","lblCustItem")).innerHTML;
        var strQuote=document.getElementById(ctrlID.replace("lblAvailQty","lblQuoteNo")).innerHTML; 
        var strBase=document.getElementById(ctrlID.replace("lblAvailQty","lblBaseUOM")).innerHTML;
        
        // Open the available stock window
        var url="AvailableStock.aspx?mode=newquote&CustomerItemNo="+strItem+"&QuoteNo="+strQuote+"&Quantity="+strQty+"&Control="+ctrlID+"&Base="+strBase.replace("/","~");
        window.open(url,"AvailableStock" ,'height=410px,width=480,scrollbars=no,status=no,top=300,left=500,resizable=no',"");
    }
     
}

function QuantityTotal()
{
    // Define the ctrl id in varaiables
    var strCtrlPrefix="dgNewQuote__ctl";
    var strCtrlSuffix="_lblReqQty";
    var strTablestring='';
    var ReqQty=0;
    var ExtAmt=0;
    var ExtWgt=0;

    for(var i=2;;i++)
    {
   
        // Get the form Control
        var qtyCtrl=document.getElementById(strCtrlPrefix+i+strCtrlSuffix);
         
        // Check or uncheck the checkbox in the datagrid
        if(qtyCtrl == null || qtyCtrl == 'undefined') 
            break;
        else
        {
       
             var strRequestedQuantity=document.getElementById(qtyCtrl.id).innerHTML;
             if(strRequestedQuantity =="")strRequestedQuantity = 0;
             var strBaseUOM=document.getElementById(qtyCtrl.id.replace("txtQty","lblBaseUOM")).innerHTML;
             var strGrossWeight=TwoDP(document.getElementById(qtyCtrl.id.replace("txtQty","hidGrossWt")).value);
             var strUnitPrice=document.getElementById(qtyCtrl.id.replace("txtQty","txtUnitPrice")).value;
             var strExtendedAmount=document.getElementById(qtyCtrl.id.replace("txtQty","lblExtAmount")).innerHTML;
             var strExtendeWeight=document.getElementById(qtyCtrl.id.replace("txtQty","lblExtWt")).innerHTML;
             
             ReqQty=ReqQty+eval(strRequestedQuantity);
             ExtAmt=ExtAmt+eval(strExtendedAmount.replace("$",""));
             ExtWgt=ExtWgt+eval(strExtendeWeight);
        }
       
      }
      
     document.getElementById("CustDet_lblSales").innerText="$ "+eval(ExtAmt).toFixed(2);
     document.getElementById("lblTotalWeight").innerText=eval(ExtWgt).toFixed(2);
}

function ReqQtyKeyPress()
{
    if(event.keyCode==13)
    {
        if(document.getElementById("txtReqQty").value.replace(/\s/g,'')!='')
        {
        document.getElementById("txtAvQty").focus(); 
            return false;
           // CallBtnClick('imgMakeQuotation');
           }
        else
       {
            alert('Invalid Quantity');
            document.getElementById("txtReqQty").focus();
       }
    }
    else
        ValdateNumber();
    
}

function ValidateQuoteDet()
{
    var itemNo=document.getElementById("txtINo1").value;
    if(itemNo.replace(/\s/g,'').replace(/\s/g,'')!='' && document.getElementById("txtReqQty").value.replace(/\s/g,'')!='')
        return true;
    else
    {
        document.getElementById("lblMessage").innerHTML="Check Quotation Details!";
        return false;
    }
}

function DeleteQuote(lineNo,quoteID,ctrlID,e)
{
  if(event.button ==2)
  {  
    ShowDelete(ctrlID,e);
    document.getElementById("hidDelete").value=quoteID;
    document.getElementById("hidLineNo").value=lineNo;
  }    
  // added by slater for line maintenance
  if((event.button ==1) && (document.getElementById("hidIsReadOnly").value=='false'))
  {  
    window.open('PriceWorksheet.aspx?OrderLineID=' + quoteID, 'OrderFix', 'toolbar=0,scrollbars=0,status=1,resizable=YES,height=560,width=1000'); 
  }    
}

function xstooltip_showTest(tooltipId, parentId, e) 
{ 

    it = document.getElementById(tooltipId); 

    // need to fixate default size (MSIE problem) 
    img = document.getElementById(parentId); 
     
    x = xstooltip_findPosX(img); 
    y = xstooltip_findPosY(img); 
    
    it.style.top =  (e.clientY + 10) + 'px';  
    it.style.left =(x+30)+ 'px';

    // Show the tag in the position
      it.style.display = '';
 
}

function ShowDelete(ctrlID,e)
{
  xstooltip_showTest('divDelete',ctrlID,e);
  return false;       
}

function DisplayHoldInvoiceMenu(ctrlID,e)
{
  if(event.button ==2)
  {  
    var tooltipId = 'divHoldInvoice';
    var parentId = ctrlID;    
    
    it = document.getElementById(tooltipId); 

    // need to fixate default size (MSIE problem) 
    img = document.getElementById(parentId); 
     
    x = xstooltip_findPosX(img); 
    y = xstooltip_findPosY(img); 
    
    it.style.top =  (e.clientY + 10) + 'px';  
    it.style.left =(x)+ 'px';

    // Show the tag in the position
    it.style.display = '';
    
    return false;
  }    
}

function MakeOrder()
{
 if(event.keyCode==13)
    {
    
    document.getElementById("imgMakeOreder").click();
    return false;      
    }
}

function OpenCompetitorSheet()
{
    if(document.getElementById('hidGridCurControl').value !="")
    {
        var ctrlId= document.getElementById('hidGridCurControl').value;
        var itemno =  document.getElementById(ctrlId.replace('txtQty','lblPFCItemNo')).innerText;
        var customerNo = document.getElementById("CustDet_txtCustNo").value
                    
        var url="MaintenanceApps/CompetitorPriceMaint.aspx?PageMode=competitormode&CustNo="+ customerNo +"&ItemNo=" + itemno;
        window.open(url,"CompetitorPrice" ,'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (1010/2))+',resizable=no',"");                         
    }
    else
    {
        alert('PFC item number required');
    }
        
}