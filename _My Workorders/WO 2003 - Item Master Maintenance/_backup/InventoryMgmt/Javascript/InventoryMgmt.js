// JScript File

function ShowHide(SHMode)
{
    if (SHMode == "Show")
    {
        parent.document.frames["MaintFrame"].setAttribute("cols", "140, *");
	    parent.document.frames["MenuFrame"].document.getElementById("HideLabel").style.display = "block";
	    parent.document.frames["MenuFrame"].document.getElementById("LeftMenu").style.display = "block";
	    parent.document.frames["MenuFrame"].document.getElementById("LeftMenuContainer").style.width = "140";
	    parent.document.frames["MenuFrame"].document.getElementById("SHButton").innerHTML = "<img ID='Hide' style='cursor:hand' src='../Common/Images/HidButton.gif' width='22' height='21' onclick='ShowHide(\"Hide\")'>";
    }
    if (SHMode == "Hide")
    {
        parent.document.frames["MaintFrame"].setAttribute("cols", "30, *");
	    parent.document.frames["MenuFrame"].document.getElementById("HideLabel").style.display = "none";
	    parent.document.frames["MenuFrame"].document.getElementById("LeftMenu").style.display = "none";
	    parent.document.frames["MenuFrame"].document.getElementById("LeftMenuContainer").style.width = "1";
	    parent.document.frames["MenuFrame"].document.getElementById("SHButton").innerHTML = "<img ID='Show' style='cursor:hand' src='../Common/Images/ShowButton.gif' width='22' height='21' onclick='ShowHide(\"Show\")'>";
    }
}