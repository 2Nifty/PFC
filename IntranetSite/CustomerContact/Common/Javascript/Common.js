// Function to allow the numeric value only
function ValdateNumber()
{

    if((event.keyCode !=13) && (event.keyCode<47 || event.keyCode>58))
        event.keyCode=0;
}

function CheckMasterRequiredField()
{
    var txtListName=document.getElementById('txtListName').value;
    
    if(txtListName.replace(/\s/g,'')!='')
        return true;
    else
    {
        alert("' * ' Marked fields are mandatory")
        return false;
    }
}
function CheckDetailRequiredField()
{
    var txtListName=document.getElementById('txtItem').value;
    
    if(txtListName.replace(/\s/g,'')!='')
        return true;
    else
    {
        alert("' * ' Marked fields are mandatory")
        return false;
    }
}


function ShowDetail(ctrlID)
{
    xstooltip_show('divToolTips',ctrlID);
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

function MaintenaceAppsRequiredField()
{
    var txtCode=document.getElementById('txtName').value;
     
    if(txtCode.replace(/\s/g,'')!='')
        return true;
    else
    {
        alert("' * ' Marked fields are mandatory")
        document.getElementById('txtName').focus();
        return false;
    }
}

// Show Tool tip for Standard Comments(above Dropdown control)
function ShowToolTipAtTop(ctrlID)
{
    xstooltipatTop_show('divToolTips',ctrlID);
    return false;
}

function xstooltipatTop_show(tooltipId, parentId) 
{ 

    it = document.getElementById(tooltipId); 

    // need to fixate default size (MSIE problem) 
    img = document.getElementById(parentId); 
     
    x = xstooltip_findPosX(img); 
    y = xstooltip_findPosY(img); 
    
    if(y<469)
        it.style.top =  (y-25) + 'px'; 
    else
        it.style.top =  (y-50) + 'px'; 
        
    it.style.left =(x+20)+ 'px';

    // Show the tag in the position
      it.style.display = '';
 
}

        
function DisplayConfirmMessage()
{
  if(!confirm('Would you like to update contact information?'))            
    event.keyCode = 0; 
}