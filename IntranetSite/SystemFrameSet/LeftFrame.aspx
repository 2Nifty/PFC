<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LeftFrame.aspx.cs" Inherits="System_FrameSet_LeftFrame" %>

<%@ Register Src="../Common/UserControls/LeftFrame.ascx" TagName="LeftFrame" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet" />
</head>

<script>
function ShowHide(SHMode)
{
    if (SHMode.id == "Show") {
		document.getElementById("HideLabel").style.display = "block";
		document.getElementById("LeftMenu").style.display = "block";
		document.getElementById("LeftMenuContainer").style.width = "230";
		document.getElementById("SHButton").innerHTML = "<img ID='Hide' style='cursor:hand' src='../Common/Images/HidButton.gif' width='22' height='21' onclick='ShowHide(this)'>";		
	}
	if (SHMode.id == "Hide") {
		document.getElementById("HideLabel").style.display = "none";
		document.getElementById("LeftMenu").style.display = "none";
		document.getElementById("LeftMenuContainer").style.width = "1";
		document.getElementById("SHButton").innerHTML = "<img ID='Show' style='cursor:hand' src='../Common/Images/ShowButton.gif' width='22' height='21' onclick='ShowHide(this)'>";
		
	}	
		var framecols="232,*";
	    if(framecols ==top.frameSet2.cols)
	    {
		    top.frameSet2.cols='28,*';		   
	    }
	    else
	    {
		    top.frameSet2.cols='232,*';		  
	    }
	
}
function ShowLeftMenu()
{
top.frameSet2.cols='232,*';
}
function ShowRight()
{
     parent.bodyframe.location.href="TabDashBoard.aspx";
}


</script>

<body topmargin="0" bottommargin="0" rightmargin="0" class="LeftBg">
    <form id="form1" runat="server">
        <table id="Table1" height="100%" cellspacing="0" cellpadding="0" border="0">
            <tr>
                <td height="1000" class="LeftBg">
                    <uc1:LeftFrame ID="LeftFrame" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
