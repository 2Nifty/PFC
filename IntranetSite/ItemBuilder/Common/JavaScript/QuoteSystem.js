// JScript File
//------------------------------------------------------------------------------------
function ViewReviewQuotes()
{
    var sessionID ="";
    
    sessionID=document.getElementById("txtSessionID").value;
    if(sessionID !="")
    {
    var Url = 'ReviewQuotes.aspx?SessionID='+sessionID + '&ScreenWidth='+screen.width;
    window.open(Url,"QuoteAnalysis" ,'height=600,width=1020,scrollbars=yes,status=no,top='+((screen.height/2) - (600/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
    }
    else
    {
        alert("Quotation Number Required");
        document.getElementById("txtSessionID").focus();        
    }
    return false; 
    
}
//------------------------------------------------------------------------------------
function OpenHelp()
{
    window.open("Help/HelpFrame.aspx?Name=CustomerSales",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
}
//------------------------------------------------------------------------------------
function ViewReview()
{
     if(event.keyCode == 13)    
        ViewReviewQuotes();
  
}
//------------------------------------------------------------------------------------
//function OpenPrint(mode)
//{
//    if(mode=="NewQuote")
//    {
//         var Url = 'Print.aspx?SessionID=<%=Session["sessionID"].ToString()%>';
//        window.open(Url,"QuotePrint" ,'height=600,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (600/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
//    }
//    else
//    {
//     var Url = 'Print.aspx?SessionID=<%=Request.QueryString["SessionID"].ToString()%>';
//     window.open(Url,"QuotePrint" ,'height=600,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (600/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
//    }
//}
//------------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------------
function OnPress(ctlValue,ctlId,mode)
{
    if(event.which || event.keyCode)
    {
        if(event.keyCode==9 || event.keyCode==13)
        {
//            var ctrlID=eval(ctlId.split('ctl')[1].split('_')[0]);
//            var ctrlNewID=document.getElementById(ctlId.replace(ctrlID,ctrlID+1));
//            
//            if(ctrlNewID!=null)
//                ctrlNewID.focus();
//             else
//            {
                //ctrlNewID is null when the NewQuote grid contains one row.so,we need to update the total value
                if(mode=="NewQuotes")
                {
                
        
                   
                    var strQtyWt=document.getElementById(ctlId.replace("txtQty","hidGrossWt")).value;

                // Get the unit price value
                    var strUnitPrice=document.getElementById(ctlId.replace("txtQty","lblUnitPrice")).innerHTML.replace('$','');

                    var strAmount=eval(strUnitPrice)*eval(document.getElementById(ctlId).value);
                  
                    // Set the Extended amount value in the grid
                    var strValue=strAmount.toFixed(2);
                    document.getElementById(ctlId.replace("txtQty","lblExtAmount")).innerHTML='$'+strValue;
                    document.getElementById(ctlId.replace("txtQty","hidExtAmount")).value=strValue;

                 
                    // set the extended weight value in the datagrid
                    var strWeight=strQtyWt*eval(document.getElementById(ctlId).value);
                    document.getElementById(ctlId.replace("txtQty","lblExtWt")).innerHTML=strWeight.toFixed(2);
                    document.getElementById(ctlId.replace("txtQty","hidExtWt")).value=strWeight.toFixed(2);
                    document.getElementById(ctlId.replace("txtQty","chkSelect")).parentElement.disabled=false;
                    document.getElementById(ctlId.replace("txtQty","txtQuoteRemark")).focus();
                }
                else
                {
                    document.getElementById(ctlId.replace("txtQty","txtRemark")).focus();
                }
//            }                
            event.returnValue=false; 
            event.cancel = true;
       }
    }
     else {return true};
    
}
//------------------------------------------------------------------------------------
// Javascript function to set the values in the grid when text value change
function SetValue(ctlValue,ctlId,mode)
{
    document.body.style.cursor = 'wait';
    var strQty=ctlValue;
    var strCtlID=ctlId;
    if(ctlValue.replace(/\s/g,'') =="")
    {
         alert("Quantity Required");
         if(document.getElementById(ctlId.replace("txtQty","hidPrivousValue")) != null && document.getElementById(ctlId.replace("txtQty","hidPrivousValue")).value !="")
            document.getElementById(ctlId).value= document.getElementById(ctlId.replace("txtQty","hidPrivousValue")).value
//         else
//             document.getElementById(ctlId.replace("txtQty","hidPrivousValue")).value = "0";
         
         document.getElementById(ctlId).focus();
         ctlValue=document.getElementById(ctlId).value.replace(/\s/g,'');
         strQty=document.getElementById(ctlId).value.replace(/\s/g,'');
    }
    
    if(ctlValue !="")
    {
        if(IsNumeric(strQty) == true)
        {
           
           var strQtyWt=document.getElementById(strCtlID.replace("txtQty","hidGrossWt")).value;
           var strPQty=document.getElementById(strCtlID.replace("txtQty","hidPrivousValue")).value;
           var strCQty =document.getElementById(strCtlID).value;
           
            // Get the unit price value
            var strUnitPrice=document.getElementById(strCtlID.replace("txtQty","lblUnitPrice")).innerHTML.replace('$','');
           
           
//           // Find Previous Value of extended weight
//                var chkSelect=document.getElementById(strCtlID.replace("txtQty","chkSelect"));
//                if (chkSelect.checked)
//                {
//                    if (strPQty == null || strPQty == "")
//                        strPQty = "0";
//                    var strNwt = ((eval(strCQty) - eval(strPQty)) * eval(strQtyWt));
//                    document.getElementById("lblExWt").innerHTML = (eval(document.getElementById("lblExWt").innerHTML) +  eval(strNwt) ).toFixed(2) ;
//                    var strExAmount=(eval(strUnitPrice)* (eval(strCQty) - eval(strPQty)));
//                    
//                    if(document.getElementById("lblExAmt")!=null)
//                        document.getElementById("lblExAmt").innerHTML = (eval(document.getElementById("lblExAmt").innerHTML) +  eval(strExAmount) ).toFixed(2) ;
//                }
           
            var strAmount=eval(strUnitPrice)*eval(strQty);
           
            // Set the Extended amount value in the grid
            var strValue=strAmount.toFixed(2);
            document.getElementById(strCtlID.replace("txtQty","lblExtAmount")).innerHTML='$'+strValue;
            document.getElementById(strCtlID.replace("txtQty","hidExtAmount")).value=strValue;

            
         
            // set the extended weight value in the datagrid
            var strWeight=strQtyWt*strQty;
            document.getElementById(strCtlID.replace("txtQty","lblExtWt")).innerHTML=strWeight.toFixed(2);
            document.getElementById(strCtlID.replace("txtQty","hidExtWt")).value=strWeight.toFixed(2);

            document.getElementById(strCtlID.replace("txtQty","chkSelect")).parentElement.disabled=false;
           
           if(mode=="NewQuotes" || mode=="NewQuotesOpen")
           {     
                // For Selection stocks
                var strSelectedCode = document.getElementById(strCtlID.replace("txtQty","hidLocationCode")).value;

                if(strSelectedCode.indexOf(',') == -1)
                {
                    var strAvailQty= document.getElementById(strCtlID.replace("txtQty","hidTotAvailableQty")).value;
                    if(eval(strQty)<=eval(strAvailQty))
                    {
                       document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.color="black";
                       document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML=strQty;
                       document.getElementById(strCtlID.replace("txtQty","hidAvailableQty")).value=strQty;
                       if(eval(strQty)==0)DisableCheckBox(strCtlID); else{ EnableCheckBox(strCtlID);}
                     }
                     //when the available quantity is lesser than requested quantity
                     else if(eval(strAvailQty)<eval(strQty))
                    {
                       document.getElementById(strCtlID.replace("txtQty","hidReqQty")).value = ctlValue;                   
                       document.getElementById(strCtlID).value =eval(strAvailQty);
                        
                        var strAmount=eval(strUnitPrice)*eval(document.getElementById(strCtlID).value);           
                        // Set the Extended amount value in the grid
                        var strValue=strAmount.toFixed(2);
                        document.getElementById(strCtlID.replace("txtQty","lblExtAmount")).innerHTML='$'+strValue;                    
                        document.getElementById(strCtlID.replace("txtQty","hidExtAmount")).value=strValue;

                       var strWeight=strQtyWt*eval(document.getElementById(strCtlID).value);
                        document.getElementById(strCtlID.replace("txtQty","lblExtWt")).innerHTML=strWeight.toFixed(2);                    
                        document.getElementById(strCtlID.replace("txtQty","hidExtWt")).value=strWeight.toFixed(2);
                        document.getElementById(strCtlID.replace("txtQty","chkSelect")).parentElement.disabled=false; 
                                         
                       document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.color="blue";
                       document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.cursor="hand";
                       document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML="See Other Loc.";
                       document.getElementById(strCtlID.replace("txtQty","hidAvailableQty")).value="See Other Loc.";
                       DisableCheckBox(strCtlID); 
                    }
                    else
                    {
                       document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.color="blue";
                       document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.cursor="hand";
                       document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML="See Other Loc.";
                       document.getElementById(strCtlID.replace("txtQty","hidAvailableQty")).value="See Other Loc.";
                       DisableCheckBox(strCtlID);
                    }
                }
                else 
                {
                    if(mode == "NewQuotesOpen")
                    {
                        var strAvailQty= document.getElementById(strCtlID.replace("txtQty","hidTotAvailableQty")).value;
                        if(eval(strQty)<=eval(strAvailQty))
                        {
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.color="black";
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML=strQty;
                           document.getElementById(strCtlID.replace("txtQty","hidAvailableQty")).value=strQty;
                           if(eval(strQty)==0)DisableCheckBox(strCtlID); else{ EnableCheckBox(strCtlID);}
                         }
                    }
                
                    if (mode!="NewQuotesOpen")
                    {   
//                         alert('Mode :' +mode);
//                       alert('PV: :' +eval(document.getElementById(strCtlID.replace("txtQty","hidPrivousValue")).value));
//                       alert('CV :' +eval(ctlValue));                
                       if(eval(document.getElementById(strCtlID.replace("txtQty","hidPrivousValue")).value) != eval(ctlValue))
                        {
                            var strAvailQty= document.getElementById(strCtlID.replace("txtQty","hidTotAvailableQty")).value;
                            document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML = "";
                            //alert(eval(ctlValue) + ' - ' + eval(strAvailQty));
                            if(eval(ctlValue) > eval(strAvailQty))
                            {
                                document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.color="blue";
                                document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.cursor="hand";
                                document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML="See Other Loc.";
                                document.getElementById(strCtlID.replace("txtQty","hidAvailableQty")).value="See Other Loc.";
                            }

                            
                            document.getElementById(strCtlID.replace("txtQty","hidReqQty")).value = ctlValue;
                            //DisableCheckBox(strCtlID); 
                            
                            var url="AvailableStock.aspx?Type=Selected&mode=newquote&CustomerItemNo="+document.getElementById(strCtlID.replace("txtQty","lbl1")).innerHTML+"&QuoteNo="+document.getElementById(strCtlID.replace("txtQty","lblQuote")).innerHTML+"&Quantity="+document.getElementById(strCtlID.replace("txtQty","hidReqQty")).value+"&Control="+strCtlID.replace("txtQty","lblAvailQty")+"&Base="+document.getElementById(strCtlID.replace("txtQty","lbl3")).innerHTML.replace("/","~");
                            //alert(url);
                            window.open(url,"AvailableStock" ,'height=410px,width=480,scrollbars=no,status=no,top=300,left=500,resizable=no',"");
                            
                        }
                    }
                }
           }
           else if(mode=="Quotes" || mode=="QuotesOpen" || mode=="OpenQuote" || mode == "ReviewQuote")
           {   
             
		        var strSelectedCode = document.getElementById(strCtlID.replace("txtQty","lblLocationCode")).innerHTML;

                if(strSelectedCode.indexOf(',') == -1 || document.getElementById(strCtlID.replace("txtQty","hidFirstValue")).value == "first")
                {
                    document.getElementById(strCtlID.replace("txtQty","lblLocationCode")).style.color="black";
                    document.getElementById(strCtlID.replace("txtQty","hidFirstValue")).value = "second";
                    if(document.getElementById(strCtlID.replace("txtQty","hidTotAvailableQty")).value =="")
                    {                      
                        var itemNo=document.getElementById(strCtlID.replace("txtQty","hidPFCItemNo")).value; 
                        var itemDetail= ReviewOpenQuote.GetItemQuantity(itemNo,document.getElementById("hidCustno").value).value.toString();
                        var detail=new Array();
                        detail=itemDetail.split('`'); 
                        document.getElementById(strCtlID.replace("txtQty","hidTotAvailableQty")).value =  detail[0];                 
                        document.getElementById(strCtlID.replace("txtQty","lblLocationCode")).innerHTML=detail[1];
                        
                        document.getElementById(strCtlID.replace("txtQty","lblLocationName")).innerHTML=ReviewOpenQuote.GetLocMasterName(detail[1]).value.toString();
                        if(eval(strQty)<=eval(detail[0]))
                        {
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.color="black";
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML=strQty;
                           if(eval(strQty)==0)DisableCheckBox(strCtlID); else{ EnableCheckBox(strCtlID);}
                        }
                        //when the available quantity is lesser than requested quantity
                        else if(eval(detail[0])<eval(strQty))
                        {
                            document.getElementById(strCtlID.replace("txtQty","hidReqQty")).value = ctlValue;
                            document.getElementById(strCtlID).value =eval(detail[0]);
                             
                            var strAmount=eval(strUnitPrice)*eval(document.getElementById(strCtlID).value);           
                            // Set the Extended amount value in the grid
                            var strValue=strAmount.toFixed(2);
                            document.getElementById(strCtlID.replace("txtQty","lblExtAmount")).innerHTML='$'+strValue;                    
                            document.getElementById(strCtlID.replace("txtQty","hidExtAmount")).value=strValue;

                           var strWeight=strQtyWt*eval(document.getElementById(strCtlID).value);
                            document.getElementById(strCtlID.replace("txtQty","lblExtWt")).innerHTML=strWeight.toFixed(2);                    
                            document.getElementById(strCtlID.replace("txtQty","hidExtWt")).value=strWeight.toFixed(2);
                            document.getElementById(strCtlID.replace("txtQty","chkSelect")).parentElement.disabled=false; 
                            
                            document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.color="blue";
                            document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.cursor="hand";
                            document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML="See Other Loc.";
                            DisableCheckBox(strCtlID);
                            
                        }                    
                        else
                        {
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.color="blue";
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.cursor="hand";
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML="See Other Loc.";
                           DisableCheckBox(strCtlID);
                        }
                    }
                    else
                    {
                       var strAvailQty= document.getElementById(strCtlID.replace("txtQty","hidTotAvailableQty")).value;
                        if(eval(strQty)<=eval(strAvailQty))
                        {
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.color="black";
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML=strQty;
                           if(eval(strQty)==0)DisableCheckBox(strCtlID); else{ EnableCheckBox(strCtlID);}
                        }
                        //when the available quantity is lesser than requested quantity
                       else if(eval(strAvailQty)<eval(strQty))
                        {
                           document.getElementById(strCtlID.replace("txtQty","hidReqQty")).value = ctlValue;
                           document.getElementById(strCtlID).value =eval(strAvailQty);
                           
                            var strAmount=eval(strUnitPrice)*eval(document.getElementById(strCtlID).value);           
                            // Set the Extended amount value in the grid
                            var strValue=strAmount.toFixed(2);
                            document.getElementById(strCtlID.replace("txtQty","lblExtAmount")).innerHTML='$'+strValue;                    
                            document.getElementById(strCtlID.replace("txtQty","hidExtAmount")).value=strValue;

                           var strWeight=strQtyWt*eval(document.getElementById(strCtlID).value);
                            document.getElementById(strCtlID.replace("txtQty","lblExtWt")).innerHTML=strWeight.toFixed(2);                    
                            document.getElementById(strCtlID.replace("txtQty","hidExtWt")).value=strWeight.toFixed(2);
                            document.getElementById(strCtlID.replace("txtQty","chkSelect")).parentElement.disabled=false; 
                           
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.color="blue";
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.cursor="hand";
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML="See Other Loc.";                       
                           DisableCheckBox(strCtlID); 
                        }
                        else
                        {
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.color="blue";
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.cursor="hand";
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML="See Other Loc.";
                           DisableCheckBox(strCtlID);
                        }
                    }
                }
              else if (strSelectedCode.indexOf(',') != -1)
                {
                    if(mode == "QuotesOpen")
                    {
                        var strAvailQty= document.getElementById(strCtlID.replace("txtQty","hidTotAvailableQty")).value;
                        if(eval(strQty)<=eval(strAvailQty))
                        {
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.color="black";
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML=strQty;
                           if(eval(strQty)==0)DisableCheckBox(strCtlID); else{ EnableCheckBox(strCtlID);}
                         }
                    }
                    
                    if(mode=="OpenQuote" || mode == "ReviewQuote")
                    {
                        if(document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML == "See Other Loc.")
                        {
                            DisableCheckBox(strCtlID);
                        }
                    }
                    
                    if (mode!="QuotesOpen" && mode!="OpenQuote" && mode != "ReviewQuote")
                    {
//                       alert('Mode :' +mode);
//                       alert('PV: :' +eval(document.getElementById(strCtlID.replace("txtQty","hidPrivousValue")).value));
//                       alert('CV :' +eval(ctlValue));
                       
                       //alert('mode:' +mode );//+ ' PV: ' + eval(document.getElementById(strCtlID.replace("txtQty","hidPrivousValue")).value) + ' CV :' + eval(ctlValue));
                       if(eval(document.getElementById(strCtlID.replace("txtQty","hidPrivousValue")).value) == eval(ctlValue))
                        {
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.color="black";
                           document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML=strQty;
                           if(eval(strQty)==0)DisableCheckBox(strCtlID); else{ EnableCheckBox(strCtlID);}
                        }
                       
                        else if(eval(document.getElementById(strCtlID.replace("txtQty","hidPrivousValue")).value) != eval(ctlValue))
                        {
                            var strAvailQty= document.getElementById(strCtlID.replace("txtQty","hidTotAvailableQty")).value;
                            document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML = "";
                            if(eval(ctlValue) > eval(strAvailQty))
                            {
                                document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.color="blue";
                                document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).style.cursor="hand";
                                document.getElementById(strCtlID.replace("txtQty","lblAvailQty")).innerHTML="See Other Loc.";
                            }
                            document.getElementById(strCtlID.replace("txtQty","hidReqQty")).value = ctlValue;
                            //DisableCheckBox(strCtlID); 
                            var url="AvailableStock.aspx?t1=sen&Type=Selected&mode=reviewquote&CustomerItemNo="+document.getElementById(strCtlID.replace("txtQty","lblCustItemNo")).innerHTML+"&QuoteNo="+document.getElementById(strCtlID.replace("txtQty","lblQuoteNo")).innerHTML+"&Quantity="+document.getElementById(strCtlID.replace("txtQty","hidReqQty")).value+"&Control="+strCtlID.replace("txtQty","lblAvailQty")+"&Base="+document.getElementById(strCtlID.replace("txtQty","lblBase")).innerHTML.replace("/","~");
                            window.open(url,"AvailableStock" ,'height=410px,width=480,scrollbars=no,status=no,top=300,left=500,resizable=no',"");
                           
                        }
                    }
                }
          }
            
        }
        else
        {
            alert("Invalid Quantity");
            document.getElementById(ctlId).focus();
        }
    }
    document.body.style.cursor ="arrow";
}
//-----------------------------------------------------------------------------------------
function DisableCheckBox(ctrlID)
{
    var chkSelect=document.getElementById(ctrlID.replace("txtQty","chkSelect"));
    chkSelect.checked=false;
    chkSelect.disabled=true;
}
//------------------------------------------------------------------------------------
function EnableCheckBox(ctrlId)
{
   
    var chkSelect=document.getElementById(ctrlId.replace("txtQty","chkSelect"));
    chkSelect.disabled=false;    
}
//------------------------------------------------------------------------------------
// function to convert values in to 2 decimal places
function TwoDP(X)
{ 
    var D, C, T // X >= 0
    with (Math) { D = floor(X) ; C = round(100*(X-D)) ; T = C%10 }
    return D + "." + (C-T)/100 + T 
}
//------------------------------------------------------------------------------------
// Function to display the weight in the label
function SetWeightToLabel(chkState,ctlID)
{
    var lblWt=document.getElementById("lblWeight");
    var strValue=document.getElementById("lblWeight").innerHTML;
    var ctlIDLbl=ctlID.replace("chkSelect","lblExtWt");
    var strWt=document.getElementById(ctlIDLbl).innerHTML;
    var strResult=(chkState==true)?(parseFloat(strValue)+parseFloat(strWt)):(parseFloat(strValue)-parseFloat(strWt));

    // Store the result in the label
    lblWt.innerHTML=TwoDP(strResult.toString());
    document.getElementById("hidwt").value=lblWt.innerHTML;
}
//------------------------------------------------------------------------------------
function LoadReviewQuoteImage()
{
    if(document.getElementById("hidButton").value =="Review")
        document.getElementById("imgReviewQuote").src="Common/images/reviewQuotemoslct.gif";
    else
        document.getElementById("imgReviewQuote").src="Common/images/reviewQuote.gif";
}
//------------------------------------------------------------------------------------
function LoadImageReview()
{
    document.getElementById("hidButton").value ="Review";
    document.getElementById("imgNewQuote").src ="Common/images/CreateNewQuote.gif";
    document.getElementById("imgReviewQuote").src ="Common/images/reviewQuotemoslct.gif";
     document.getElementById("imgDisplayList").src="Common/images/DispList.gif"
     document.getElementById("imgOrderHistory").src="Common/images/orderHistoryN.gif";
    document.getElementById("ShowTag").style.display = "none";
}
//------------------------------------------------------------------------------------
function LoadNewQuoteImage()
{
    if(document.getElementById("hidButton").value =="New")
        document.getElementById("imgNewQuote").src="Common/images/CreateNewQuoteslct.gif";
    else
        document.getElementById("imgNewQuote").src="Common/images/CreateNewQuote.gif";
}
//------------------------------------------------------------------------------------
function LoadImageNew()
{
   document.getElementById("hidButton").value ="New";
   document.getElementById("imgNewQuote").src ="Common/images/CreateNewQuoteslct.gif";
   document.getElementById("imgReviewQuote").src ="Common/images/reviewQuote.gif";
   document.getElementById("imgDisplayList").src="Common/images/DispList.gif"
   document.getElementById("imgOrderHistory").src="Common/images/orderHistoryN.gif";
   document.getElementById("ShowTag").style.display = "block";
   document.getElementById("ShowTag").innerHTML = "<img ID='ShowItem' style='cursor:hand' src='Common/Images/ShowType.gif' onclick='ShowItemControl(this)'>";		    	    		
}
//------------------------------------------------------------------------------------
function LoadDisplayList()
{
   document.getElementById("hidButton").value ="DisplayList";
   document.getElementById("imgNewQuote").src ="Common/images/CreateNewQuote.gif";
   document.getElementById("imgReviewQuote").src ="Common/images/reviewQuote.gif";
   document.getElementById("imgDisplayList").src="Common/images/DispListslct.gif";
   document.getElementById("imgOrderHistory").src="Common/images/orderHistoryN.gif";
   document.getElementById("ShowTag").style.display = "none";
}
//------------------------------------------------------------------------------------
function LoadDisplayListImage()
{
    if(document.getElementById("hidButton").value =="DisplayList")
        document.getElementById("imgDisplayList").src="Common/images/DispListslct.gif";
    else
        document.getElementById("imgDisplayList").src="Common/images/DispList.gif";
}       
//------------------------------------------------------------------------------------
function LoadOrderHistory()
{
   document.getElementById("hidButton").value ="OrderHistory";
   document.getElementById("imgNewQuote").src ="Common/images/CreateNewQuote.gif";
   document.getElementById("imgReviewQuote").src ="Common/images/reviewQuote.gif";
   document.getElementById("imgDisplayList").src="Common/images/DispList.gif";
   document.getElementById("imgOrderHistory").src="Common/images/orderHistoryS.gif";
   document.getElementById("ShowTag").style.display = "none";
}
//------------------------------------------------------------------------------------
function LoadOrderHistoryImage()
{
    if(document.getElementById("hidButton").value =="OrderHistory")
        document.getElementById("imgOrderHistory").src="Common/images/orderHistoryS.gif";
    else
        document.getElementById("imgOrderHistory").src="Common/images/orderHistoryN.gif";
}       
//------------------------------------------------------------------------------------