//********************************************* Validate Date ************************************************************************************************************************************************************************************************************************************************************// 
// To validate the Date

var dtCh= "/";
var minYear=1900;
var maxYear=2100;

function isInteger(s){
	var i;
    for (i = 0; i < s.length; i++){   
        // Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}

function stripCharsInBag(s, bag){
	var i;
    var returnString = "";
    // Search through string's characters one by one.
    // If character is not in bag, append to returnString.
    for (i = 0; i < s.length; i++){   
        var c = s.charAt(i);
        if (bag.indexOf(c) == -1) returnString += c;
    }
    return returnString;
}

function daysInFebruary (year){
	// February has 29 days in any year evenly divisible by four,
    // EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
}
function DaysArray(n) {
	for (var i = 1; i <= n; i++) {
		this[i] = 31
		if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
		if (i==2) {this[i] = 29}
   } 
   return this
}

function isDate(dtStr){
	var daysInMonth = DaysArray(12)
	var pos1=dtStr.indexOf(dtCh)
	// If dashes aren't there, add them
	if (pos1==-1 ){
		dtStr=dtStr.substring(0,2) + dtCh + dtStr.substring(2,4) + dtCh + dtStr.substring(4)
		pos1=dtStr.indexOf(dtCh)
	}
	var pos2=dtStr.indexOf(dtCh,pos1+1)
	var strMonth=dtStr.substring(0,pos1)
	var strDay=dtStr.substring(pos1+1,pos2)
	var strYear=dtStr.substring(pos2+1)
	var curDate = new Date()
	var curYear = new String(curDate.getFullYear())
	if (strYear.length == 2 ){
	    strYear=curYear.substring(0,2) + strYear
		dtStr=dtStr.substring(0,6) + strYear
	}
	strYr=strYear
	if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
	if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
	for (var i = 1; i <= 3; i++) {
		if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
	}
	month=parseInt(strMonth)
	day=parseInt(strDay)
	year=parseInt(strYr)
	if (pos1==-1 || pos2==-1){
		alert("The date format should be : mm/dd/yyyy")
		return false
	}
	if (strMonth.length<1 || month<1 || month>12){
		alert("Please enter a valid month")
		return false
	}
	if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
		alert("Please enter a valid day")
		return false
	}
	if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){
		alert("Please enter a valid year ")
		return false
	}
	if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false){
		alert("Please enter a valid date")
		return false
	}
return dtStr
}
function ValidateDate(txtDate,txtID){
	
	if(txtDate!="")
	{
	    if (isDate(txtDate.replace(/\s/g,''))==false){
	        document.getElementById(txtID).value="";
		    document.getElementById(txtID).focus()
		    return false
	    }
	    // If the date is good, call it again to get it back formatted
	    document.getElementById(txtID).value=isDate(txtDate.replace(/\s/g,''))
        return true
    }
 }

//**********************************************BOL Header***********************************************************************************************************************************************************************************************************************************************************// 

 //
 // Bind the Processed date in header
 //
 
  function BindValue(date)
  {        
    document.getElementById("BOLHeader_lblProcDt").innerText = date; 
    document.getElementById("BOLHeader_txtVesselName").value = "";
    document.getElementById("BOLHeader_txtBOLDt").value = "" ;
    document.getElementById("BOLHeader_txtRefNo").value = "";
    document.getElementById("BOLHeader_txtBrokerIAmt").value = "";
    document.getElementById("BOLHeader_txtBOLCount").value = "";
    document.getElementById("BOLHeader_ddlPort").selectedIndex = 0;
    document.getElementById("BOLHeader_ddlReceipt").selectedIndex = 0;
    document.getElementById("BOLHeader_ddlLocation").selectedIndex = 0;
    document.getElementById("BOLHeader_ddlOrder").selectedIndex = 0;       
    document.getElementById("BOLHeader_lblVendName").innerText = "";
    document.getElementById("BOLHeader_lblBranch").innerText = "";       
    document.getElementById("BOLHeader_txtCustomsEntryNo").innerText = "";       
    document.getElementById("BOLHeader_txtPortOfEntry").innerText = "";       
    document.getElementById("BOLHeader_txtCustomsDate").innerText = "";       
    document.getElementById("lblErrorMessage").innerText = "";       
       
  }  
  
  //
  // Validate the BOL Header
  //
  
  function validateBOLHeader()
    {
        var status = true;
        
        if(document.getElementById("BOLHeader_txtBOLDt").value == "" || document.getElementById("BOLHeader_txtRefNo").value == "")
        {      
          status= false;
        }            
        if(document.getElementById("BOLHeader_ddlReceipt").selectedIndex == 0 || document.getElementById("BOLHeader_ddlLocation").selectedIndex == 0 || document.getElementById("BOLHeader_ddlOrder").selectedIndex == 0)
        {       
          status= false;
        }             
        if(!status)
        {
            document.getElementById("BOLHeader_ddlOrder").focus(); 
            document.getElementById("lblErrorMessage").innerText = "BOL Header incomplete";
        }
        else
        {
           document.getElementById("BOLHeader_lblProcDt").innerText = "";
           document.getElementById("lblErrorMessage").innerText = "";
           document.getElementById("txtInvNo").focus();       
        }
    } 
    
//
// Bind the header values when recall the BOL Details
//
    
function BindHeader(headerValues)
{  
    if(headerValues.split('~')[5]!="")
        document.getElementById("BOLHeader_ddlPort").value=headerValues.split('~')[5];
    else
        document.getElementById("BOLHeader_ddlPort").selectedIndex= 0;
        
    document.getElementById("BOLHeader_ddlOrder").value=headerValues.split('~')[1];
    document.getElementById("BOLHeader_lblVendName").innerHTML=headerValues.split('~')[1];
    document.getElementById("BOLHeader_ddlLocation").value=headerValues.split('~')[3];
    document.getElementById("BOLHeader_lblBranch").innerHTML=headerValues.split('~')[3];
    document.getElementById("BOLHeader_txtRefNo").value=headerValues.split('~')[4];
    document.getElementById("BOLHeader_txtVesselName").value=headerValues.split('~')[7];        
    document.getElementById("BOLHeader_txtBOLDt").value=headerValues.split('~')[6];
    document.getElementById("BOLHeader_txtBrokerIAmt").value = headerValues.split('~')[8];
    document.getElementById("BOLHeader_ddlReceipt").value=headerValues.split('~')[9];
    document.getElementById("BOLHeader_lblProcDt").innerHTML=headerValues.split('~')[10];
    document.getElementById("BOLHeader_txtBOLCount").value = headerValues.split('~')[11];     
    document.getElementById("BOLHeader_txtCustomsEntryNo").value = headerValues.split('~')[12];     
    document.getElementById("BOLHeader_txtPortOfEntry").value = headerValues.split('~')[13];     
    document.getElementById("BOLHeader_txtCustomsDate").value = headerValues.split('~')[14];     
    
}

//
// Validate the header values when the Command Lines stored into BOL Details
//

function validateBOLHeaderItems()
{
    var status = true;       
    if( document.getElementById("BOLHeader_txtBOLDt").value == "" || document.getElementById("BOLHeader_txtRefNo").value == "")
    {      
      status= false;
    }
    if(document.getElementById("BOLHeader_ddlReceipt").selectedIndex == 0 || document.getElementById("BOLHeader_ddlLocation").selectedIndex == 0 || document.getElementById("BOLHeader_ddlOrder").selectedIndex == 0)
    {       
      status= false;
    }       
    if(!status)
    {
       document.getElementById("lblErrorMessage").innerText = "1BOL Header incomplete (VBHI)";
    }         
    return status;        
}

//**********************************************BOL Detail***********************************************************************************************************************************************************************************************************************************************************// 
    
//
//Bind the Command Line
//
function bindCmdLine(strCmd)
{
    document.getElementById("txtInvNo").value=strCmd.split(',')[0];
    document.getElementById("txtDate").value=strCmd.split(',')[1];
    document.getElementById("txtContainer").value=strCmd.split(',')[2];
    document.getElementById("txtPO").value=strCmd.split(',')[3];
}

//
//Delete the BOL Detail
//   
 
function RowDelete()
{
    if(ctlID!='')
    {
        strDeleteFlag=true;
        document.getElementById(ctlID.replace("lblInv","btnInv")).click();        
        document.getElementById("divToolTip").style.display='none';
    }
    else 
        strDeleteFlag=false;

} 

// Javascript Function To Call Server Side Function Using Ajax
function updateInvoiceCost(currentCtrlID,currentCtrlVal)
{
    var invVal=document.getElementById(currentCtrlID.replace('txtInvCost','lblInv')).innerText;
    var dtVal=document.getElementById(currentCtrlID.replace('txtInvCost','lblVendInvDt')).innerText;
    var containerNo=document.getElementById(currentCtrlID.replace('txtInvCost','lblContainerNo')).innerText;
    var PFCPONo=document.getElementById(currentCtrlID.replace('txtInvCost','lblPFCPONo')).innerText;
    var PFCItemNo=document.getElementById(currentCtrlID.replace('txtInvCost','lblPFCItemNo')).innerText;
    var qtyVal=document.getElementById(currentCtrlID.replace('txtInvCost','lblPOQty')).innerText;
    var bolVal=document.getElementById(currentCtrlID.replace('txtInvCost','hidBOL')).value;
    var extendedAmount = DataEntry.UpdateInvoiceCost(invVal,dtVal,containerNo,PFCPONo,PFCItemNo,qtyVal,currentCtrlVal,bolVal).value;
    
    // Code to display extended amount based on new qty value
    document.getElementById(currentCtrlID.replace('txtInvCost','lblUOMatlAmt')).innerText = extendedAmount;
}
    
// Javascript Function To Call Server Side Function Using Ajax
function updateInvoiceQty(currentCtrlID,currentCtrlVal)
{
    var invVal=document.getElementById(currentCtrlID.replace('txtInvQty','lblInv')).innerText;
    var dtVal=document.getElementById(currentCtrlID.replace('txtInvQty','lblVendInvDt')).innerText;
    var containerNo=document.getElementById(currentCtrlID.replace('txtInvQty','lblContainerNo')).innerText;
    var PFCPONo=document.getElementById(currentCtrlID.replace('txtInvQty','lblPFCPONo')).innerText;
    var PFCItemNo=document.getElementById(currentCtrlID.replace('txtInvQty','lblPFCItemNo')).innerText;
    var qtyVal=document.getElementById(currentCtrlID.replace('txtInvQty','lblPOQty')).innerText;
    var bolVal=document.getElementById(currentCtrlID.replace('txtInvQty','hidBOL')).value;
    var extendedAmount = DataEntry.UpdateInvoiceQuantity(invVal,dtVal,containerNo,PFCPONo,PFCItemNo,qtyVal,currentCtrlVal,bolVal).value;
    
    // Code to display extended amount based on new qty value
    document.getElementById(currentCtrlID.replace('txtInvQty','lblUOMatlAmt')).innerText = extendedAmount;
    
}

//********************************************** Accessorial Charges *****************************************************************************************************************************************************************************************************************************************************************************// 
 //
 // Updated Charges grid amount value 
 //
 function UpdateChargesLineAmount(ctlID,totalAmount)
 {
    var lblchargeID = ctlID.replace("txtLineAmt","ChargesID");
    var whereCondition = "pGERChrgDtlID='" + document.getElementById(lblchargeID).value + "'";
    var columnValues = "UOAmt=" + totalAmount.replace(',','') + "";  
    DataEntry.UpdateCharges(columnValues,whereCondition);
 }
 
 //
 // Updated Charges grid remarks field value 
 //
 function UpdateChargesRemarks(ctlID,remarks)
 {
    
    var lblchargeID = ctlID.replace("txtRemark","ChargesID");
    var whereCondition = "pGERChrgDtlID='" + document.getElementById(lblchargeID).value + "'";
    var columnValues = "Remarks='" + remarks + "'";   
    DataEntry.UpdateCharges(columnValues,whereCondition);
 }
    
//**********************************************Container Reconciliation***********************************************************************************************************************************************************************************************************************************************************// 

//
// Calculate the container total
//
  
function fillTotal(ctlID)
{
    var gridCount=document.getElementById("dgContainerCost").rows.length-1;
    var countTot=gridCount+1;
    var grandTotal = 0;   
    var controlName1 = ctlID.split('dgContainerCost_ctl')[1];
    controlName1=controlName1.split('_')[1];
    for(var i=0;i<gridCount-1;i++)
    {
        var ctrIndex=i+2;
        var ctrlID= "dgContainerCost_ctl0" + ctrIndex +"_"+controlName1;
        var txtTotal = document.getElementById(ctrlID);
        if(txtTotal == undefined || txtTotal == null) 
            break;
        else
           grandTotal += (txtTotal.value != "") ? parseFloat(txtTotal.value.replace(/\,/g,'')) : 0;
    }
    document.getElementById("dgContainerCost_ctl0" + countTot +"_"+controlName1).value=grandTotal.toFixed(2);
    roundMoney(document.getElementById("dgContainerCost_ctl0" + countTot +"_"+controlName1).value.replace(/\,/g,''),"dgContainerCost_ctl0" + countTot +"_"+controlName1);

}

//********************************************** Validation ***********************************************************************************************************************************************************************************************************************************************************// 
//
// Validate the commas
//
  
  function commaValidation(ctrlVal,ctrlID)
  {        
    if( ctrlVal != "")
    {
        var strVal=eval(ctrlVal.replace(/\,/g,"")).toFixed(0);
        document.getElementById(ctrlID).value=addCommas(strVal);
    }
  }
//
// round the numbers
//

function roundNumber(number,decimal_points,ctrl)
{
	if(!decimal_points) return Math.round(number.replace(/\,/g,""));
	if(number == 0) {
		var decimals = "";
		for(var i=0;i<decimal_points;i++) decimals += "0";
		return "0."+decimals;
	}

	var exponent = Math.pow(10,decimal_points);
	var num = Math.round((number.replace(/\,/g,"") * exponent)).toString();
	ctrl.value= num.slice(0,-1*decimal_points) + "." + num.slice(-1*decimal_points);
}

  
//
// add the commas
//
    
function addCommas(nStr) 
{
    nStr += '';
    x = nStr.split('.');
    x1 = x[0];
    x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
	    x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2;

}
//
// convert the money format
//
    
function roundMoney(ctrlVal,ctrlID)
{
    if(ctrlVal!=null && ctrlVal!="")
    {
         var strVal=eval(ctrlVal.replace(/\,/g,"")).toFixed(2);
         document.getElementById(ctrlID).value=addCommas(strVal);
    }
} 

//
// control the grid height
//

function Changeheight(count)
{

    document.getElementById("div-datagrid").style.height="400px";
    if(count >= 17)
        document.getElementById("dgList").style.width="98%";
    else
         document.getElementById("dgList").style.width="100%";
}

//
// hide the div
//

function hideDiv()
{
    document.getElementById("BOLHeader_lblProcDt").innerText = ''; 
    document.getElementById("divToolTip").style.display='none';
    document.getElementById("lblSuccessMessage").innerText = '';
}
