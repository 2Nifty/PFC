// JScript File

function ShowHide(SHMode)
{    
    if (SHMode.id == "Show") 
    {
        top.document.getElementById("soeFrame").setAttribute("cols", "120, *");
		document.getElementById("HideLabel").style.display = "block";
		document.getElementById("LeftMenu").style.display = "block";
		document.getElementById("LeftMenuContainer").style.width = "120";
		if(top.parent.document.frames["bodyFrame"].document.getElementById("divdatagrid"))
		    top.parent.document.frames["bodyFrame"].document.getElementById("divdatagrid").style.width  = "860";
		document.getElementById("SHButton").innerHTML = "<img ID='Hide' style='cursor:hand' src='Common/Images/HidButton.gif' width='22' height='21' onclick='ShowHide(this)'>";				
	}
	if (SHMode.id == "Hide") 
	{   
	    top.document.getElementById("soeFrame").setAttribute("cols", "30, *");
		document.getElementById("HideLabel").style.display = "none";
		document.getElementById("LeftMenu").style.display = "none";
		document.getElementById("LeftMenuContainer").style.width = "1";
		if(top.parent.document.frames["bodyFrame"].document.getElementById("divdatagrid"))
		    top.parent.document.frames["bodyFrame"].document.getElementById("divdatagrid").style.width  = "970";
		document.getElementById("SHButton").innerHTML = "<img ID='Show' style='cursor:hand' src='Common/Images/ShowButton.gif' width='22' height='21' onclick='ShowHide(this)'>";		
	}		
}


function PopulatePODetail()
{   
    if(itemNo!="")
    {
        var section="";
        var completeItem=0;
        var itemNo = document.getElementById("txtPODItemNo").value;
        
        switch(itemNo.split('-').length)
        {
        case 1:
            event.keyCode=0;
            itemNo = "00000" + itemNo;
            itemNo = itemNo.substr(itemNo.length-5,5);
            document.getElementById("txtPODItemNo").value=itemNo+"-";             
            return ;
            break;
        case 2:                        
            event.keyCode=0;
            section = "0000" + itemNo.split('-')[1];
            section = section.substr(section.length-4,4);
            document.getElementById("txtPODItemNo").value=itemNo.split('-')[0]+"-"+section+"-";               
            return ;
            break;
        case 3:
            event.keyCode=0;
            section = "000" + itemNo.split('-')[2];
            section = section.substr(section.length-3,3);
            document.getElementById("txtPODItemNo").value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
            completeItem=1;
            break;        
        }
        
        if (completeItem==1) 
        {    
            var result = "";
            result = WorkOrderEntry.CheckItem(document.getElementById("txtPODItemNo").value).value; 
            //alert(result);
            if (result.toUpperCase() == "FALSE")
            {
                alert('Invalid item number.')
                document.getElementById("txtPODItemNo").focus();
                return;
            }
            result = WorkOrderEntry.CheckItemBOM(document.getElementById("txtPODItemNo").value).value; 
            //alert(result);
            if (result.toUpperCase() == "FALSE")
            {
                if (confirm('BOM does not exist for this item. Do you want to proceed?'))
                {
                    document.getElementById('hidOneTimeBOM').value='true';
                    CallServerButtonClick('btnPopulatePODetail');      
                }
                else
                {
                    document.getElementById('hidOneTimeBOM').value='false';
                    document.getElementById("txtPODItemNo").focus();
                }
            }
            else
            {
                document.getElementById('hidOneTimeBOM').value='false';
                CallServerButtonClick('btnPopulatePODetail');      
            }
        }
    }
}

function PopulateItemDetail()
{   
    if(itemNo!="")
    {
        var section="";
        var completeItem=0;
        var itemNo = document.getElementById("txtCmdItemNo").value;
        
        switch(itemNo.split('-').length)
        {
        case 1:
            event.keyCode=0;
            itemNo = "00000" + itemNo;
            itemNo = itemNo.substr(itemNo.length-5,5);
            document.getElementById("txtCmdItemNo").value=itemNo+"-";             
            return ;
            break;
        case 2:                        
            event.keyCode=0;
            section = "0000" + itemNo.split('-')[1];
            section = section.substr(section.length-4,4);
            document.getElementById("txtCmdItemNo").value=itemNo.split('-')[0]+"-"+section+"-";               
            return ;
            break;
        case 3:
            event.keyCode=0;
            section = "000" + itemNo.split('-')[2];
            section = section.substr(section.length-3,3);
            document.getElementById("txtCmdItemNo").value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
            completeItem=1;
            break;        
        }
        if (completeItem==1) 
            CallServerButtonClick('btnGetItemInfo');      
    }
}

function UpdatePODetail()
{
    CallServerButtonClick('btnUpdatePODetail');   
}

function CheckUOM()
{
    CallServerButtonClick('btnGetUOMInfo');   
}

function CallServerButtonClick(btnName)
{
    document.getElementById(btnName).click();
}

// Grid Methods
var scrollPosition = 0;
function StoreScrollValue(divControl)    
{
    //document.getElementById('divGridContextMenu').style.display='none';
    scrollPosition = divControl.scrollTop;
}

function UpdateWOLine(fieldType,ctlValue,ctlId)
{   

    var inputCtlPrefix = '';    
    if(fieldType == 'UnitCost')
            inputCtlPrefix = 'txtUnitCost';
            
    var _pCompId= document.getElementById(ctlId.replace(inputCtlPrefix,"hidpWoCompId")).value; 
    var _hidPreviousQtyPer = document.getElementById(ctlId.replace(inputCtlPrefix,"hidPreviousQtyPer"));
    var _hidPreviousQtyUOM = document.getElementById(ctlId.replace(inputCtlPrefix,"hidPreviousQtyPerUM"));
    var _hidPreviousUnitCost = document.getElementById(ctlId.replace(inputCtlPrefix,"hidPreviousUnitCost"));
    var _hidPreviousLineNotes = document.getElementById(ctlId.replace(inputCtlPrefix,"hidPreviousLineNotes"));
    var result;
    var _lblExtendQty = document.getElementById(ctlId.replace(inputCtlPrefix,"lblExtendedQty"));
    var _lblExtendCost = document.getElementById(ctlId.replace(inputCtlPrefix,"lblExtendedCost"));
    var _lblPickQty = document.getElementById(ctlId.replace(inputCtlPrefix,"lblPickQty"));
            
    if(fieldType == 'UnitCost' && _hidPreviousUnitCost.value != ctlValue)
    {
        result = WorkOrderEntry.UpdateWOLines(fieldType,_pCompId,ctlValue).value;
        _hidPreviousUnitCost.value = ctlValue;
    }
    //alert(result);
    if(result)
    {
        _lblExtendQty.innerHTML = result[0];
        _lblExtendCost.innerHTML = result[1];
        _lblPickQty.innerHTML = result[4];
        document.getElementById("lblTotCost").innerHTML = result[2];
        document.getElementById("lblTotWght").innerHTML = result[3];
    }   
}

function UpdatePOHeader(ctlType,ctl)
{
    if(document.getElementById("txtWONo").value !="")
    {
        if(ctlType == "WOType")
        {
            WorkOrderEntry.UpdatePOHeader(ctlType,ctl.value,"");            
        }
        else if(ctlType == 'Expedite')
        {
            WorkOrderEntry.UpdatePOHeader(ctlType,"",ctl.options[ctl.selectedIndex].text);
        }
         
    }
}


function ShowContactForm(contactName)
{
    if(document.getElementById("txtWONo").value !="")
    {
        document.getElementById("lblPckContact").style.display = "none";
        document.getElementById("txtPckContact").style.display = "block";
        document.getElementById("txtPckContact").value = document.getElementById("lblPckContact").innerText;        
        document.getElementById("txtPckContact").select();    
    }
}

function HideContactForm()
{
    document.getElementById("lblPckContact").style.display = "block";
    document.getElementById("txtPckContact").style.display = "none";
    WorkOrderEntry.UpdateOrderContact(document.getElementById("txtPckContact").value);
    document.getElementById("lblPckContact").innerText = document.getElementById("txtPckContact").value;
}

function OpenMfgAddressForm()
{
    if(document.getElementById("txtWONo").value !="")
    {
        popUp=window.open ("MfgAddress.aspx?WONumber="+ parent.bodyFrame.form1.document.getElementById("txtWONo").value +"&LocID=" + parent.bodyFrame.form1.document.getElementById("ddlLocation").value,"MfgGroupForm",'height=310,width=715,scrollbars=no,status=no,top='+((screen.height/2) - (310/2))+',left='+((screen.width/2) - (715/2))+',resizable=NO',"");
        popUp.location.reload(true); 
        popUp.focus();
    }
}

function OpenPackByForm()
{
    if(document.getElementById("txtWONo").value !="")
    {
        popUp=window.open ("PackByAddress.aspx?WONumber="+ parent.bodyFrame.form1.document.getElementById("txtWONo").value +"&LocID=" + parent.bodyFrame.form1.document.getElementById("ddlLocation").value,"PackByForm",'height=565,width=715,scrollbars=no,status=no,top='+((screen.height/2) - (565/2))+',left='+((screen.width/2) - (715/2))+',resizable=NO',"");
        popUp.location.reload(true); 
        popUp.focus();
    }

}


// Delete Context Menu
function DeleteWOLine(lineNo,ctrlID,e)
{
  if(event.button ==2)
  {  
    ShowDelete(ctrlID,e);
    document.getElementById("hidDeleteWoCompId").value=lineNo;    
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

// end of context menu methods

function ClearControls()
{
    if(document.getElementById('divDelete'))
    {
        document.getElementById('divDelete').style.display = 'none';      
        if(document.getElementById('hidRowID') && document.getElementById('hidRowID').value != "")
        {
            document.getElementById(document.getElementById('hidRowID').value).style.fontWeight='normal';
        }
    }
}

// Show grid header search textbox
function HideHeader()
{
    if(document.getElementById("trItemText").style.display !="none")
    {    
         document.getElementById("trItemText").style.display="none";
         document.getElementById("tdWoDetail").style.display="none";
         document.getElementById("tdUsage").style.display="none";
         document.getElementById("divdatagrid").style.height="350px"; 
    }
    else
    {   
         document.getElementById("trItemText").style.display="";
         document.getElementById("tdWoDetail").style.display="";
         document.getElementById("tdUsage").style.display="";
         document.getElementById("divdatagrid").style.height="250px";       
    }
    
    return false;
}


function ShowSearch(id)
{
    var height = document.getElementById("divdatagrid").style.height.replace('px','');
    
    if(document.getElementById(id).style.display !="none")
    {
        document.getElementById(id).style.display="none";
        document.getElementById("divdatagrid").style.height=Number(height)+Number(20);            
    }
    else
    {   
        document.getElementById("divdatagrid").style.height= Number(height)-Number(20);
        document.getElementById(id).style.display="";  
        document.getElementById("txt_Item").select();   
        document.getElementById("txt_Item").focus();   
    } 
}


function LoadExpense()
{    
    popUp=window.open ("WOExpenses.aspx?WONumber=" + parent.bodyFrame.form1.document.getElementById("txtWONo").value,"WOExpenses",'height=600,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (500/2))+',left='+((screen.width/2) - (714/2))+',resizable=YES',"");
    popUp.focus();
    return false;    
}

function LoadPage(PageID)
{    
    switch(PageID)
    {
        case 'StockStatus':
            var SOEURL = parent.bodyFrame.form1.document.getElementById("hidSOEURL").value;
            SOEURL = SOEURL + "StockStatus.aspx?UserName=" + parent.bodyFrame.form1.document.getElementById("hidStockStatusUser").value;
            if (parent.bodyFrame.form1.document.getElementById("hidStockStatusItem").value != "")
                SOEURL = SOEURL + "&ItemNo=" + parent.bodyFrame.form1.document.getElementById("hidStockStatusItem").value
            //alert(SOEURL);
            popUp=window.open(SOEURL,"WOStockStatus",'height=740,width=1014,scrollbars=no,status=no,top='+((screen.height/2) - (500/2))+',left='+((screen.width/2) - (714/2))+',resizable=YES',"");
            popUp.focus();
        break;
    }
    return false;    
}

function BorderWipItem(BorderStyle)
{
    //alert("Border");
    $get("chkCmdWipItem").style.borderStyle=BorderStyle
}

function SetStockStatusItem(ItemCtl)
{
    if (ItemCtl == null)
    {    
        $get("hidStockStatusItem").value=$get("txtPODItemNo").value;
    }   
    else
    {
        // get the item number from the front of the line
        var LineParent = ItemCtl.parentNode.parentNode;
        //alert(LineParent.firstChild.firstChild.innerText);
        $get("hidStockStatusItem").value=LineParent.firstChild.firstChild.innerText;
    } 
}

function LoadComment()
{
    if(parent.bodyFrame.form1.document.getElementById("txtWONo").value !="")
    { 
        var itemno = '';
        var lineNo = '';
        
        //
        // If user selected any item fromm the grid pass it to comments page
        //        
        if(parent.bodyFrame.form1.document.getElementById('hidShowLineComments').value == 'true' && parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value !="")
        {
            var ctrlId=parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value;
            lineNo = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','hidLineNumber')).value;
            itemno = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblPFCItemNo')).innerText;
            parent.bodyFrame.form1.document.getElementById('hidShowLineComments').value = 'false';                                       
        }
               
        var pageUrl =   "CommentEntry.aspx?PONumber=" + parent.bodyFrame.form1.document.getElementById("txtWONo").value +                        
                        "&ItemNo=" + itemno +"&LineNo=" +lineNo;
                        
        popUp=window.open (pageUrl,"commentsPage",'height=540,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (540/2))+',left='+((screen.width/2) - (714/2))+',resizable=YES',"");
        popUp.focus();
    }
    else
        alert("Enter WO Number");
        
    return false;
}


function DeleteConfirmation() 
{
	var answer = confirm("Are you sure you want delete this order?");
	if (answer){
		return true;
	}
	else{
		return false;
	}
}

// Receiving

function CheckWipOverReceipt(TotRec, WIPQty) 
{
    var pageUrl = "WipOverReceiptChoice.aspx?TotalRecQty=" + TotRec + '&WIPQty=' + WIPQty;
    window.open(pageUrl,'WipOverReceiptChoice','height=150,width=400,toolbar=0,scrollbars=0,status=0,resizable=0,top='+((screen.height/2) - (150/2))+',left='+((screen.width/2) - (400/2))+'','');    
}

function GetReceiptType() 
{
    window.open('ReceiptChoice.aspx','ReceiptChoice','height=150,width=400,toolbar=0,scrollbars=0,status=0,resizable=0,top='+((screen.height/2) - (150/2))+',left='+((screen.width/2) - (400/2))+'','');    
}

function ShowSubPOs() 
{
    var SubPOWin = window.open('SubPOs.aspx','SubPOs','height=400,width=400,toolbar=0,scrollbars=0,status=0,resizable=0,top='+((screen.height/2) - (400/2))+',left='+((screen.width/2) - (400/2))+'','');    
    SubPOWin.focus();
}

// This method used to delete the WO if it has no WO lines[Ref# WO2283.5]
function DoWorkOrderValidation()
{
    if(document.getElementById("txtPODItemNo").value == "" 
       && document.getElementById("txtWONo").value != "")
    {
       document.getElementById("btnClose").click();
    }
}