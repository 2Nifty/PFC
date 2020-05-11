// JScript File
var parentMouseOverFlag = false;
var toolTipMouseOverFalg = false;

function showHideCorporateTooltip(parentControl,e,mode)
{
	try
	{		
	    switch (mode)
	    {
		    case "show":
                document.getElementById("Tooltip").style.top =document.body.offsetHeight-45+ 'px';//(e.clientY - 10) + 'px';  
                document.getElementById("Tooltip").style.left =(xstooltip_findPosX(document.getElementById(parentControl)))+ 'px';
		        document.getElementById("Tooltip").style.display = "block";
		        parentMouseOverFlag = true;
		    break;
		    case "hide":			    
	            HideTooltip();
		    break;
	    }
	}
	catch(err)
	{
		alert("exception : " + err);
	}
}

function HideTooltip()
{
    if(toolTipMouseOverFalg == false)	
        document.getElementById("Tooltip").style.display = "none";	
}

function DisplayToolTip(flag)
{
    if(flag == 'true')
    {
        toolTipMouseOverFalg = true;
        document.getElementById("Tooltip").style.display = "block";
    }
    else 
    {
        toolTipMouseOverFalg = false;
        HideTooltip()
    }
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