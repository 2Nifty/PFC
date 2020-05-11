// JScript File
var scrollPosition = 0;
var shipToWind;

// Method to clear message & context menus
function ClearControls()
{
    document.getElementById('divGridContextMenu').style.display='none';
    document.getElementById('divToolTip').style.display='none';
    document.getElementById('divTool').style.display='none';
    document.getElementById('divDelete').style.display='none';
    if(document.getElementById('hidRowID') != null && document.getElementById('hidRowID').value != '')
        document.getElementById(document.getElementById('hidRowID').value).style.fontWeight='normal';
    document.getElementById('lblMessage').innerText='';
    document.getElementById('divHoldInvoice').style.display='none';
    
}

// function for open list control for datagrid control
function OpenGridPopupWindow(fSODetailID,popupType,clientControlID)
{
    ctrlID = clientControlID;
    if(fSODetailID != "")
    {
        document.getElementById("hidCurrentControl").value = ctrlID;
        document.getElementById("hidfSOdetailID").value = popupType + '-' + fSODetailID; 
        document.getElementById("btnGridUpdate").click();
    }

    return false;            
}

// Tool tip function
function ShowGridContextMenu()
{
    ShowGridtooltip('divGridContextMenu',ctrlID);
    return false;       
}
    
function StoreScrollValue(divControl)    
{
    document.getElementById('divGridContextMenu').style.display='none';
    scrollPosition = divControl.scrollTop;
}

function ShowGridtooltip(tooltipId, parentId) 
{ 
    it = document.getElementById(tooltipId); 

    // need to fixate default size (MSIE problem) 
    img = document.getElementById(parentId); 
     
    x = xstooltip_findPosX(img); // These methods are in ContextMenu.js file
    y = xstooltip_findPosY(img); 
    y = y - scrollPosition;
    
    if(y<469)
        it.style.top =  (y+15) + 'px'; 
    else
        it.style.top =  (y-50) + 'px'; 
        
    it.style.left =(x+10)+ 'px';

    // Show the tag in the position
      it.style.display = '';
      
      return false;
 
}

// Method to update qty when user change the location in grid line
function UpdateLineAvailability(pSODetailId, newLocation, availQty)
{
    if(ShowYesorNo('Requested Quantity not available.Do you want to continue?'))
    {
        OrderEntryPage.UpdateLocDetail(pSODetailId, newLocation, availQty);
        setTimeout("CallBtnClick('btnGrid');",500); // Need a delay here, because we are loading script manager which is already in use by another event       
    } 
        
    Hide(); 
}


function OpenSplitLineWindow()
{
    var pSODetailID = document.getElementById(document.getElementById('hidRowID').value + '_lblQuoteNo').innerHTML;
    var splitWin =window.open ("SplitItem.aspx?pSODetailId=" + pSODetailID  ,"Delete",'height=235,width=700,scrollbars=no,status=no,top='+((screen.height/2) - (230/2))+',left='+((screen.width/2) - (700/2))+',resizable=NO',"");
    splitWin.focus(); 
}

function DoUnload()
{
    if (pricehwind) pricehwind.close();
    if(shipToWind) shipToWind.close();                
}