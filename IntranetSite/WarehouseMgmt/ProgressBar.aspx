<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ProgressBar.aspx.cs" Inherits="ProgressBar" %>

<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame"
    TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Report Home Page</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script>
    function showProgress()
    {        
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
<body onload="showProgress()">
    <form id="form1" runat="server">
    <div>
        <table cellpadding=0 cellspacing=0 width=100% >             
              <tr>
                <td height=600 valign=top>
                    <div id="Progress" zindex="100" style="position:absolute;layer-background-color:#000000; text-align=center;top:250px;left:400px;">
                        <img id="Preloader" src="../Common/Images/Preloader.gif" width="214" height="21"/>
                    </div>
                                       
                    <iframe id="iFrame2" name="iFrame1"  src="" width="100%" height="700" frameborder=0 marginheight=0 marginwidth=0 scrolling=no ></iframe>
                </td>
              </tr>
         </table>
    </div>
    </form>
</body>
</html>
