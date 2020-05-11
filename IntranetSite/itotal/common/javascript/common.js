
    function ShowHide(SHMode)
    {   
        if (SHMode == "Show") 
        {
		    document.getElementById("HideLabel").style.display = "";
		    document.getElementById("LeftMenu").style.display = "";
		    document.getElementById("LeftMenuContainer").style.width = "180px";	
		    document.getElementById('div-datagrid').style.width='830px';
		    document.getElementById('hidShowMode').value='Show';
		    document.getElementById("SHButton").innerHTML = "<img ID='Hide' style='cursor:hand' src='../Common/Images/HidButton.gif' width='22' height='21' onclick=\"javascript:ShowHide('Hide');\">";		
	    }
	    if (SHMode== "Hide") 
	    {
		    document.getElementById("HideLabel").style.display = "none";
		     document.getElementById("LeftMenu").style.display = "none";	
		    document.getElementById("LeftMenuContainer").style.width = "28px";	
		    document.getElementById('div-datagrid').style.width='982px';
		    document.getElementById('hidShowMode').value='HideL';
		    document.getElementById("SHButton").innerHTML = "<img ID='Show' style='cursor:hand' src='../Common/Images/ShowButton.gif' width='22' height='21' onclick=\"javascript:ShowHide('Show');\">";
    		
	    }	
	}
	
	function ShowPanel()
	{
	    if(document.getElementById('leftPanel')!=null)
	    {
	        document.getElementById('leftPanel').style.display='';
	 	    document.getElementById("HideLabel").style.display = "";
		    document.getElementById("LeftMenu").style.display = "";
	        document.getElementById('imgHide').style.display='';
	        document.getElementById('imgShow').style.display='none';
	        document.getElementById('div-datagrid').style.width='830px';	
	        document.getElementById('hidShowMode').value='Show';
	        document.getElementById('LeftMenuContainer').style.width = '180px';
	        document.getElementById("SHButton").innerHTML = "<img ID='Hide' style='cursor:hand' src='../Common/Images/HidButton.gif' width='22' height='21' onclick=\"javascript:ShowHide('Hide');\">";		
	     }
	}
