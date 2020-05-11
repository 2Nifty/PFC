<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ProgressBarold.aspx.cs" Inherits="SalesAnalysisReport_ProgressBar" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
	<title>Loading, please wait...</title>
	<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
	<meta name="CODE_LANGUAGE" Content="C#">
	<meta name="vs_defaultClientScript" content="JavaScript">
	<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	<script> 
	var ctr = 1;
	var ctrMax = 50; // how many is up to you-how long does your end page take?
	var intervalId;  
	function Begin() 
	{
		//set this page's window.location.href to the target page
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
	    //window.location.href = newURL; 
	
	    // but make it wait while we do our progress...
	    intervalId = window.setInterval("ctr=UpdateIndicator(ctr, ctrMax)", 4400);
	} 
	function End() 
	{
	// once the interval is cleared, we yield to the result page (which has been running)
	//window.clearInterval(intervalId);   
	}
	 
	function UpdateIndicator(curCtr, ctrMaxIterations) 
	{  
//	curCtr += 1;   
//	if (curCtr <= ctrMaxIterations) {
//		indicator.style.width =curCtr*10 +"px";
//		return curCtr;
//	}
//	else 
//	{
//		indicator.style.width =0;
//		return 1;
//	}
	    document.getElementById("imgStatusBar").src ="../Common/Images/preloader.gif";	       
	}
	



</script>
<body onload="Begin()" onunload="End()">
		<form id="Form1" method="post" runat="server">
			<div align="center"><h3>
					<BR>
					<BR>
					<BR>
					<BR>
					<BR>
					<BR>
					<BR>
					<BR>
					<BR>
					<BR>
					<BR>
					<BR>
					<BR>
					Loading Data, please wait...</h3>
			</div>
			<table id="indicator" border="0" cellpadding="0" cellspacing="0" width="0" height="18"
				align="center">
				<tr>
					<td><img id="imgStatusBar" src="../Common/Images/preloader.gif"/></td>
				</tr>
			</table>
		</form>
	</body>
</html>