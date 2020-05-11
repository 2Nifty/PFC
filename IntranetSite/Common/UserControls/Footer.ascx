<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Footer.ascx.cs" 
Inherits="PFC.Intranet.ListMaintenance.NewFooter" %>
<script type="text/javascript" src="~/Common/Javascript/Global.js"></script>

<tr bgcolor="#DFF3F9">
    <td height="29" class="BluTopBord">
        <div id="Footer" class="Footer">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <asp:Label ID="lblLeftText" runat="server" Text="Best Viewed in 1024 x 768 &amp; above resolutions."></asp:Label></td>
                    <td>
                        <div align="right">
                            <asp:Image ImageUrl="~/vendormaintenance/Common/Images/userinfo_left_rev.gif" runat="server"
                                ID="imgFooterLeftRev" /></div>
                    </td>
                    <td class="userinfobgrev" align="center" style="color: #FFFFFF;width:480px;">
                        <strong>
                            <asp:Label ID="lblHeading" runat="server" Text=""></asp:Label>
                        </strong>
                    </td>
                    <td>
                        <div align="left">
                            <asp:Image ImageUrl="~/vendormaintenance/Common/Images/userinfo_right_rev.gif" runat="server"
                                ID="imgFooterRightRev" /></div>
                    </td>
                    <td>
                        <a href="http://www.porteousfastener.com/" target=_blank class="tooltipAnchor" id="lnkCpyright" onmouseover="showHideCorporateTooltip(this.id,event,'show');"><asp:Label ID="lblCpyright" runat="server" Text="Copyright 2010" Width="110px"></asp:Label></a>
                    </td>
                    <td>
                        <div align="right">
                            <a href="http://www.novantus.com" target="_blank">
                                <asp:Image ImageUrl="~/Common/Images/umbrellaPower.gif" runat="server" alt="Powered By www.novantus.com" 
                                ID="Image1" /> </a></div>
                    </td>
                </tr>
            </table>
        </div>
        <div id="Tooltip" class="Tooltip" onmouseover="DisplayToolTip('true')" style="position:absolute;">
            <asp:HyperLink runat=server ID="lnkCopyRight" NavigateUrl="http://www.porteousfastener.com/" onclick="DisplayToolTip('false')" onmouseover="DisplayToolTip('true')"; onmouseout="DisplayToolTip('false')";  Target=_blank></asp:HyperLink>
        </div>
    </td>
</tr>

<script>
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
</script>