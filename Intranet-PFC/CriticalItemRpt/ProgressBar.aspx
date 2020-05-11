<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ProgressBar.aspx.cs" Inherits="ProgressBar" %>

<%@ Register Src="UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Critical Item Report Detail</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script>
    function showProgress()
    {
//        //window.document.getElementById("Progress").zindex = window.document.getElementById("iFrame1").zindex + 1;
//        document.getElementById("Progress").style.left = document.documentElement.clientWidth/2 - document.getElementById("Preloader").width/2;
//        document.getElementById("Progress").style.top = document.documentElement.clientHeight/2 - document.getElementById("Preloader").height/2;
//        document.getElementById("Progress").style.display ="block";
        
        xstooltip_show('Progress','iFrame1',(document.documentElement.clientWidth/2 - document.getElementById("Preloader").width/2),(document.documentElement.clientHeight/2 - document.getElementById("Preloader").height/2));
        
        var url="<%=Request.QueryString["destPage"]%>";
		var secondUrl = url.split('~');
	    var newURL ="";
	    
	    // replace the ~ symbol with & for next page url
	    for(var i=0;i<= secondUrl.length;i++)
	    {
	        if(newURL != "")
	            newURL = newURL + "&"+ secondUrl[i];   
	        else
	            newURL = secondUrl[i];   
	    }	    
	    document.getElementById("iFrame1").src = newURL; 
        
    }
    
function xstooltip_show(tooltipId, parentId, posX, posY) 
{ 

    it = document.getElementById(tooltipId); 

    // need to fixate default size (MSIE problem) 
    img = document.getElementById(parentId); 
   
    it.style.top =  posY + 'px'; 
    it.style.left =posX+ 'px';

    // Show the tag in the position
      it.style.display = '';
 }
    </script>
</head>
<body >
    <form id="form1" runat="server">
    <div>
        <table cellpadding=0 cellspacing=0 width=100% >
             <tr>
                <td width="100%" colspan="2" style="height: 75px">
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="HeadeBG">
                      <tr>
                        <td width="62%" valign="middle" ><img onload="showProgress()" src="Images/Logo.gif" width="453" height="50" hspace="25" vspace="10"></td>
                        <td width="38%" valign="bottom" class="10pxPadding"></td>
                      </tr>
                    </table>
                </td>
              </tr>
              <tr>
                <td height=600 valign=top>
                    <div id="Progress" zindex="100" style="position:absolute;layer-background-color:#000000; text-align=center">
                        <img id="Preloader" src="Images/Preloader.gif" width="214" height="21"/>
                    </div>
                    <iframe id="iFrame1" name="iFrame1"  src="" width="100%" height="602" frameborder=0 marginheight=0 marginwidth=0 ></iframe>
                </td>
              </tr>
            <tr >
                <td >
                    <uc1:BottomFrame ID="BottomFrame1" runat="server" Visible="true" />
                </td>
            </tr>
         </table>
    </div>
    </form>
</body>
</html>
