
// -----------------------------------------
function OpenPrintDialog(Url,Mode,custNo,Title,printDialogURL,pageSetup)
{
    var Url = printDialogURL + "?pageURL="+ Url +"&CustomerNumber="+ custNo +"&SoeNo="+Title+"&Mode="+Mode; 
    
   // if(Mode == "Print")
        Url += "&PageSetup=" + pageSetup;
      
    window.open(Url,"PrintUtility" ,'height=320,width=650,scrollbars=yes,status=no,top='+((screen.height/2) - (320/2))+',left='+((screen.width/2) - (650/2))+',resizable=No',"");
}

function ShowHide(SHMode)
{
    if (SHMode.id == "Show") {top.document.getElementById("poeFrame").setAttribute("cols", "160, *");
		document.getElementById("HideLabel").style.display = "block";
		document.getElementById("LeftMenu").style.display = "block";
		document.getElementById("LeftMenuContainer").style.width = "160";
		document.getElementById("SHButton").innerHTML = "<img ID='Hide' style='cursor:hand' src='Common/Images/HidButton.gif' width='22' height='21' onclick='ShowHide(this)'>";		
		
		}
	if (SHMode.id == "Hide") {top.document.getElementById("poeFrame").setAttribute("cols", "30, *");
		document.getElementById("HideLabel").style.display = "none";
		document.getElementById("LeftMenu").style.display = "none";
		document.getElementById("LeftMenuContainer").style.width = "1";
		document.getElementById("SHButton").innerHTML = "<img ID='Show' style='cursor:hand' src='Common/Images/ShowButton.gif' width='22' height='21' onclick='ShowHide(this)'>";
		//document.getElementById("menuFrame").style.width="1";
		
	}	
	SetGridHeight('Common');
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


//
// Function to call the server side button click through javascript
//
function CallBtnClick(id)
{
    var btnBind=document.getElementById(id);
       if (typeof btnBind == 'object')
       { 
            btnBind.click();
            return false; 
       } 
      return;
}


// Function to allow the numeric value only
function ValdateNumber()
{

    if(event.keyCode<47 || event.keyCode>58)
        event.keyCode=0;
}

// Function to allow the numeric value only with single dot
function ValdateNumberWithDot(value)
{
    
    if(event.keyCode<46 || event.keyCode>58)
        event.keyCode=0;
        
    if(event.keyCode==46 && value.indexOf('.')!=-1)
         event.keyCode=0;
            
}


// function to convert values in to 2 decimal places
function TwoDP(X)
{ 
    var D, C, T // X >= 0
    with (Math) 
    { 
        D = floor(X) ;
         C = round(100*(X-D)) ; 
         T = C%10 
    }
    return D + "." + (C-T)/100 + T;
}

function ExportRpt(mode)
{

    if(document.getElementById("CustDet_txtSONumber").value!="")
    {
        var Url = 'Print_Export.aspx?Mode='+mode + '&SOEID='+document.getElementById("CustDet_txtSONumber").value;
       window.open(Url,"Export" ,'height=10,width=10,scrollbars=yes,status=no,top=100,left=100,resizable=No',"");
    }
}

function SetGridHeight(flag)
{
    var divGrid=((flag=='Common')?top.document.frames["bodyFrame"].document.getElementById("divdatagrid"):document.getElementById("divdatagrid"));
    var mfShowBtn=top.parent.document.frames["menuFrame"].document.getElementById("SHButton");
    var bfShowBtn=((flag=='Common')?top.document.frames["bodyFrame"].document.getElementById("SHButton"):document.getElementById("SHButton"));
    var tblGrid=((flag=='Common')?top.document.frames["bodyFrame"].document.getElementById("tblGrid"):document.getElementById("tblGrid"));
    var tdFamily=((flag=='Common')?top.document.frames["bodyFrame"].document.getElementById("TDFamily"):document.getElementById("TDFamily"));
    var tdItem=((flag=='Common')?top.document.frames["bodyFrame"].document.getElementById("TDItem"):document.getElementById("TDItem"));
    if(divGrid!=null)
	{
	    if(tdFamily.style.display!='none')
	    {
	        if(bfShowBtn.innerHTML.indexOf('Common/Images/HidButton.gif')!=-1 && mfShowBtn.innerHTML.indexOf('Common/Images/HidButton.gif')!=-1)
	        {
	        
	               divGrid.style.width="640px";
                   divGrid.style.height=(tdItem.style.display!='none')?"230px" :"260px";		
	        }
	        else
	        {
	            if(bfShowBtn.innerHTML.indexOf('Common/Images/ShowButton.gif')!=-1 && mfShowBtn.innerHTML.indexOf('Common/Images/ShowButton.gif')!=-1)
	            {
	          
	                   divGrid.style.width="930px";
                       divGrid.style.height=(tdItem.style.display!='none')?"230px" :"260px";	
                       
	            }
	            else
	            {
	            
	                    divGrid.style.width=((bfShowBtn.innerHTML.indexOf('Common/Images/ShowButton.gif')!=-1)?"820px":"785px");
                        divGrid.style.height=(tdItem.style.display!='none')?"230px" :"260px";		
	            }
	        }
	    }
        else
        {      	
            divGrid.style.width=(mfShowBtn.innerHTML.indexOf('Common/Images/HidButton.gif')!=-1)?"850px":"982px";
            divGrid.style.height=(tdItem.style.display!='none')?"230px" :"260px";	           	
            	//"350px";//(mfShowBtn.src=='Common/Images/HidButton.gif')?"980px":"350px";		
        }
        tblGrid.style.height=tdFamily.style.height =divGrid.style.height;
    }
          
}





function insertAtCursor(myField, myValue) {
  //IE support
  if (document.selection) {
    myField.focus();
    sel = document.selection.createRange();
    sel.text = myValue;
  }
  //MOZILLA/NETSCAPE support
  else if (myField.selectionStart || myField.selectionStart == '0') {
    var startPos = myField.selectionStart;
    var endPos = myField.selectionEnd;
    myField.value = myField.value.substring(0, startPos)
                  + myValue
                  + myField.value.substring(endPos, myField.value.length);
  } else {
    myField.value += myValue;
  }
}

//-------------for Tool tip---------------------------------
function ShowDetail(ctrlID)
{
    xstooltip_show('divToolTips',ctrlID);
    return false;
}
//----------------------------------------------
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
//----------------------------------------------
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
//----------------------------------------------
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
//----------------------------------------------    

function OpenQuoteWeightForm()
{
    if(parent.bodyFrame.form1.document.getElementById("CustDet_txtCustNo").value !="")
    {
        var hwnd=window.open('CustWeight.aspx?CustNumber='+parent.bodyFrame.form1.document.getElementById("CustDet_txtCustNo").value ,'CustomerMaintenance','height=600,width=400,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (600/2))+',left='+((screen.width/2) - (400/2))+',resizable=no','');	
	    hwnd.focus();
	}
	else
	{
       alert("Enter Customer Number");
       parent.bodyFrame.form1.document.getElementById("CustDet_txtCustNo").focus();
    }
}