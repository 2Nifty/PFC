        var markerHTML = "<div style='margin-left:10px;display:inline;'> &raquo;</div>";
        var minWidth = 80;
        var dragingColumn = null;
        var startingX = 0;
        var currentX = 0;
//--------------------------------------------------------------------------       
function getNewWidth () 
{
    var newWidth = minWidth;
    if (dragingColumn != null) {
        newWidth = parseInt (dragingColumn.parentNode.style.width);
        if (isNaN (newWidth)) {
            newWidth = 0;
        }
        newWidth += currentX - startingX;
        if (newWidth < minWidth) {
            newWidth = minWidth;
        }
    }
    return newWidth;
}
//--------------------------------------------------------------------------       
function columnMouseDown (event) 
{
    if (!event) {
        event = window.event;
    }
    if (dragingColumn != null) {
        ColumnGrabberMouseUp ();
    }
    startingX = event.clientX;
    currentX = startingX;
    dragingColumn = this;
    return true;
}
//--------------------------------------------------------------------------       
function columnMouseUp () 
{
    if (dragingColumn != null) {
        dragingColumn.parentNode.style.width = getNewWidth ();
        dragingColumn = null;
    }
	return true;
}
//--------------------------------------------------------------------------       
function columnMouseMove (event) 
{
    if (!event) 
    {
        event = window.event;
    }
    if (dragingColumn != null) {
	    currentX = event.clientX;
        dragingColumn.parentNode.style.width = getNewWidth ();
        startingX = event.clientX;
        currentX = startingX;
	}
	return true;
}
//--------------------------------------------------------------------------       
        function installTable (tableId,columnIds) {
        
            var columns = columnIds;
			var table = document.getElementById (tableId);
            // Test if there is such element in the document
            if (table != null) {
                // Test is this element a table
                if (table.nodeName.toUpperCase () == "TABLE") {
                    document.body.onmouseup = columnMouseUp;
                    document.body.onmousemove = columnMouseMove;
                        
                        var tableHead = table.childNodes[0];
                            fixMarkers(tableHead,columns,table);
                            table.style.tableLayout = "fixed";
                            // Once we have found THEAD element and updated it
                            // there is no need to go through rest of the table
                            i = table.childNodes.length;
                }                
            }
        }
//--------------------------------------------------------------------------               
		function fixMarkers(tableHead,columns,table)
		{
			var tableHeadNode = tableHead.childNodes[0];
			// Handles IE style THEAD with TR
			
			if (tableHeadNode.nodeName.toUpperCase () == "TR") {
				for (k = 0; k < tableHeadNode.childNodes.length; k++) {
					var column = tableHeadNode.childNodes[k];
					var recolumn = tableHeadNode.childNodes[3];
					var marker = document.createElement ("span");
					
					//var shrinkMarker = document.createElement ("span");
				   //if (columns.indexOf("~"+column.childNodes[0].innerHTML+"~") != -1)
				   if (columns.indexOf("~"+column.childNodes[0].innerHTML+"~") != -1)
				   {
						//shrinkMarker.innerHTML = markerHTML;					
						//shrinkMarker.style.cursor = "move";
						//shrinkMarker.onmousedown = columnMouseDown;
						
						marker.innerHTML = markerHTML;
						marker.style.cursor = "move";
						marker.onmousedown = columnMouseDown;
						column.appendChild (marker);
					
						
						
						if (column.offsetWidth < minWidth) {
						recolumn.style.width= "150px";
							column.style.width = minWidth;
							
							
							
						}
						else {
						recolumn.style.width= "150px";
							column.style.width = column.offsetWidth;
							
						}
					}
				}
			}
			// Handles Mozilla style THEAD
			else if (tableHeadNode.nodeName.toUpperCase () == "TH") {
			for (k = 0; k < tableHeadNode.childNodes.length; k++) {
					
					var recolumn = tableHeadNode.childNodes[3];
					}
				var column = tableHeadNode;
				var marker = document.createElement ("span");
				marker.innerHTML = markerHTML;
				marker.style.cursor = "move";
				marker.onmousedown = columnMouseDown;
				column.appendChild (marker);
				if (column.offsetWidth < minWidth) {
				recolumn.style.width= "150px";
					column.style.width = minWidth;
					
				}
				else {
				recolumn.style.width= "150px";
					column.style.width = column.offsetWidth;
					
				}
			}
		}
//--------------------------------------------------------------------------       
