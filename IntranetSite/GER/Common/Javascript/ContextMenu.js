// JScript File

function xstooltip_show(tooltipId, parentId, posX, posY) 
{ 

    it = document.getElementById(tooltipId); 

    // need to fixate default size (MSIE problem) 
    img = document.getElementById(parentId); 
     
    x = xstooltip_findPosX(img); 
    y = xstooltip_findPosY(img); 
    
//    if(y<400)
//        it.style.top =  (y+15) + 'px'; 
//    else
//        it.style.top =  (y-50) + 'px'; 
    alert(e.clientY);
    it.style.top =  (y+15) + 'px';  
    it.style.left =(x+30)+ 'px';

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

function xstooltip_hide(id)
{
    it = document.getElementById(id); 
    it.style.display = 'none'; 
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