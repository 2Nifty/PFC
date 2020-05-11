// Function to allow the numeric value only
function ValdateNumber()
{

    if(event.keyCode<47 || event.keyCode>58)
        event.keyCode=0;
}

// Function to allow the numeric value & dot symbol only
function ValdatePercentage()
{
    if(event.keyCode<46 || event.keyCode>58)
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

function CountryRequiredField()
{
    var txtCode=document.getElementById('txtCode').value;
      var txtName=document.getElementById('txtName').value;
    
    if(txtCode.replace(/\s/g,'')!='' && txtName.replace(/\s/g,'')!='')
        return true;
    else
    {
        alert("' * ' Marked fields are mandatory")
        return false;
    }
}
function CheckMandatory()
{
    if( document.getElementById("txtCode").value.replace(/\s/g,'') != "" &&  document.getElementById("txtDescription").value.replace(/\s/g,'')  != "" &&  document.getElementById("txtVendorID").value.replace(/\s/g,'')  != "" &&  document.getElementById("txtVendorNo").value.replace(/\s/g,'')  != "")
        return true;
    
    alert("' * ' Marked fields are mandatory");
    return false;
            
} 
function MaintenaceAppsRequiredField()
{
    var txtCode=document.getElementById('txtCode').value;
      var txtName=document.getElementById('txtDescription').value;
    
    if(txtCode.replace(/\s/g,'')!='' && txtName.replace(/\s/g,'')!='')
        return true;
    else
    {
        alert("' * ' Marked fields are mandatory")
        return false;
    }
}

function FormMessagesRequiredField()
{
    var txtCode=document.getElementById('ddlLocation').selectedIndex;
      var txtName=document.getElementById('txtComments').value;
    
    if(txtCode != 0 && txtName.replace(/\s/g,'')!='')
        return true;
    else
    {
        alert("' * ' Marked fields are mandatory")
        return false;
    }
}

function StandardMessageRequiredField()
{
    var txtCode=document.getElementById('txtCode').value;     
    
    if(txtCode.replace(/\s/g,'')!='')
        return true;
    else
    {
        alert("' * ' Marked fields are mandatory")
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

function GLPostingRequiredField()
{
    var txtCode=document.getElementById('ddlAppType').selectedIndex;
    
    
    if(txtCode != 0 )
        return true;
    else
    {
        alert("' * ' Marked fields are mandatory")
        return false;
    }
}

