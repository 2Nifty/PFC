// To Change the menu content in left frame when a tab was clicked
function ChangeStatus(ctl,tabID)
{
    var userControlName = ctl.id.split('_')[0];
    document.getElementById(userControlName+"_hidTabStatus").value = ctl.id.replace("lbl","td");
    var clickedTD =  document.getElementById(userControlName+"_hidTabStatus").value;
    
    for(i=0;;i++)
    {
        var tabCell = document.getElementById(userControlName + "_td" + i );
        if(tabCell == undefined || tabCell == null)
		    break;
		else if(tabCell.id == clickedTD)
		     tabCell.className='TopMenuMo';
		else 
	        tabCell.className='TopMenu';
    }
     		  
     if(parent.bodyframe!=null)
	{
        if(tabID!="322")
        {
		    parent.bodyframe.location.href="TabDashBoard.aspx";
		}
		else if(tabID=="322")
		{		
		    top.frameSet2.cols='0,*';
		    parent.bodyframe.location.href="UnderConstruction.aspx";
		}
	}
     
    if(tabID=="323")
    {    
        top.frameSet2.cols='0,*';
        window.open('http://www.companycasuals.com/porteousfastener/start.jsp', '', '',"");        
    }
    else if(tabID =="326")
    {
        top.frameSet2.cols='0,*';
        window.open('http://www.porteousfastener.com', '',' ',"");        
    }
    else if(tabID=="327")
    {
        top.frameSet2.cols='0,*';
        window.open('http://www.porteousfastener.com/pfconline/location.aspx', '', '',"");        
    }
    else
    {
        if(parent.mainmenus!=null)
				    parent.mainmenus.location.href="LeftFrame.aspx?TabID="+tabID;	
    }    
}

// To highlight Selected tab in mouseout event                 
function CheckMenuCicked(ctl)
{
    var mouseoutTD = ctl.id.replace("lbl","td");
    var clickedTD = document.getElementById("Header1_hidTabStatus").value;
    
    for(i=0;;i++)
    {
        var userControlName = ctl.id.split('_')[0];
        var tabCell = document.getElementById(userControlName + "_td" + i );
		
	    if(tabCell == undefined || tabCell == null)
		    break;
		else if(tabCell.id == clickedTD)
		     tabCell.className='TopMenuSelected';
		else 
	        tabCell.className='TopMenu';
    }        
    
}


