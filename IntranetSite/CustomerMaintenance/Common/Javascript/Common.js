// JScript File

//function BindDDLVendor(txtVendor)
//{

//    if(event.keyCode==13)
//        document.getElementById("divSearch").style.display='none';
//    else
//        {
//            var ddlVendor= document.getElementById(txtVendor.id.replace('txtVendor','lstVendor'));
//            var vendDetails="";
//            var vendSearch=txtVendor.value;
//            
//            if(event.keyCode==40)
//                if(document.getElementById("divSearch").style.display=="")
//                    ddlVendor.focus();
//             
//            if(IsNumeric(txtVendor.value)==false)
//                 document.getElementById(txtVendor.id.replace("txtVendor","hidSearchMode")).value = "Alpha";     
//            else
//                 document.getElementById(txtVendor.id.replace("txtVendor","hidSearchMode")).value = "Vendor";   
//                  
//            vendDetails=VendorMaintenance.VendorDetails(vendSearch).value;
//                
//            var splitValue=vendDetails.split('`');
//            ddlVendor.options.length = 0;
//                
//            if(splitValue.length>0 && vendDetails!="" && txtVendor.value !="")
//            {
//                for(var i=0;i<splitValue.length-1;i++)
//                {
//                    var splitField=splitValue[i].toString().split('~');
//                    ddlVendor.options[ddlVendor.options.length] =  new Option(splitField[0].toString(), splitField[1].toString());
//                }
//                document.getElementById("divSearch").style.display="";
//            }
//            else
//                document.getElementById("divSearch").style.display='none';
//        }
//}

function ValidateFax()
{
    if(event.keyCode<47 ||event.keyCode>57)
    {
        if(event.keyCode==40 || event.keyCode==45 || event.keyCode==41)
        {}
        else
           event.keyCode=0; 
    }
}

function ValidateZip()
{
    if(event.keyCode<47 ||event.keyCode>57)
    {
        if(event.keyCode==45)
        {}
        else
           event.keyCode=0; 
    }
}

function CollapseNode(ctrlID,divID)
{
    
    var imgSrc=document.getElementById(ctrlID).src.split('/')[document.getElementById(ctrlID).src.split('/').length-1];
    if(imgSrc=="expand.gif")
    {
        document.getElementById(ctrlID).src=document.getElementById(ctrlID).src.replace(document.getElementById(ctrlID).src.split('/')[document.getElementById(ctrlID).src.split('/').length-1],'contract.gif');
        document.getElementById(divID).style.display='';
    }
    else
    {
        document.getElementById(ctrlID).src=document.getElementById(ctrlID).src.replace(document.getElementById(ctrlID).src.split('/')[document.getElementById(ctrlID).src.split('/').length-1],'expand.gif');
         document.getElementById(divID).style.display='none';
    }
    
    return false;
}

function LstVendorClick(ctrlID)
{
    var lstVendor=document.getElementById(ctrlID);
    var txtVendor=document.getElementById(ctrlID.replace('lstVendor','txtVendor'));
    txtVendor.value=lstVendor.options[lstVendor.selectedIndex].text.split('-')[0];
    txtVendor.value=txtVendor.value.substring(0,txtVendor.value.length-1);
    document.getElementById('divSearch').style.display='none';
    document.getElementById(ctrlID.replace('lstVendor','hidVendor')).value=lstVendor.value;
    
    document.getElementById(ctrlID.replace("txtVendor","hidSearchMode")).value = "Vendor"; 
    txtVendor.focus();
}

// Function to check the given value is numeric or not
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



function Hide()
{
   divBillToolTips.style.display='none';
   divSoldToolTips.style.display='none';
   divToolTips.style.display='none';
}
function ShowSoldDetail(event,ctrlID)
{
xstooltip_show('divSoldToolTips',ctrlID);
return false;
}

function ShowBillDetail(event,ctrlID)
{
xstooltip_show('divBillToolTips',ctrlID);
return false;
}
//-------------for Tool tip---------------------------------
function ShowDetail(event,ctrlID)
{
    if(document.getElementById("divToolTips"))
    {
        detail = document.getElementById("divToolTips");
        detail.style.top = event.y + 10 + 'px';
        detail.style.left = event.x + 'px';
        detail.style.display = 'block';
    }
    
    return false;
}


function xstooltip_show(tooltipId, parentId) 
{ 

    it = document.getElementById(tooltipId); 

    // need to fixate default size (MSIE problem) 
    img = document.getElementById(parentId); 
     
    x = xstooltip_findPosX(img); 
    y = xstooltip_findPosY(img); 
    
    if(y<469)
        it.style.top =  (y+15) + 'px'; 
    else
        it.style.top =  (y-50) + 'px'; 
        
    it.style.left =(x+10)+ 'px';

    // Show the tag in the position
      it.style.display = '';
 
}
function xstooltip_findPosY(obj) 
{
    var curtop = 0;
    if (obj.offsetParent) 
    {
        while (obj.offsetParent) 
        {
            curtop += obj.offsetTop
            obj = obj.offsetParent;
        }
    }
    else if (obj.y)
        curtop += obj.y;
    return curtop;
}


function xstooltip_findPosX(obj) 
{
  var curleft = 0;
  if (obj.offsetParent) 
  {
    while (obj.offsetParent) 
        {
            curleft += obj.offsetLeft
            obj = obj.offsetParent;
        }
    }
    else if (obj.x)
        curleft += obj.x;
    return curleft;
}


// Function to allow the numeric value only
function ValdateNumber()
{

    if(event.keyCode<47 || event.keyCode>58)
        event.keyCode=0;
}



//function ReleaseLock()
//{
// document.getElementById("form1").defaultbutton ="ucSearchVendor_btnSearch";
//    VendorMaintenance.ReleaseVendorLock();
//}


