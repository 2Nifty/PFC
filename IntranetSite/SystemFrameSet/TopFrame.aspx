<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TopFrame.aspx.cs" Inherits="PFC.Intranet.TopFrame" %>

<%@ Register Src="../Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Header</title>
    <link href="../Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet">

    <script type="text/javascript" src="../Common/Javascript/Header.js"></script>
    <script>
        if(window.history.forward(1) != null)
                 window.history.forward(1);
    </script>
</head>

<script language="javascript">
    function ShowHide(SHMode)
    { 
   
        if (SHMode.id == "ShowTopMenu") 
        {
		    document.getElementById("Header1_tblTemplates").style.display = "block";
            document.getElementById("TopMenuControl").innerHTML ="<img  src='../Common/Images/hidemenu.gif' name='HideTopMenu' id='HideTopMenu' onclick='ShowHide(this)' style='cursor:hand'>";          
    		
	    }
	    if (SHMode.id == "HideTopMenu") 
	    {
	   
		    document.getElementById("Header1_tblTemplates").style.display = "none";
		    document.getElementById("TopMenuControl").innerHTML = "<img src='../Common/Images/showmenu.gif' name='ShowTopMenu'  id='ShowTopMenu' onclick='ShowHide(this)' style='cursor:hand' />";   			
    		
	    }
	    
	   if(document.getElementById("Header1_hidTabRows").value != "Single")
	   {
	            var framerows="138,*,29";
	            if(framerows ==top.Frame1.rows)
	            {
		            top.Frame1.rows='103,*,29';
	            }
	            else
	            {
		            top.Frame1.rows='138,*,29';
	            }
	    }
	    else
	    {
	        top.Frame1.rows='103,*,29';
	    }
	
	    //
	    // Check VMI div height
	    //
	    ChangeEAUDivHeight(SHMode);
    }
    function Getpage()    
    {
       document.getElementById("Header1_tblTemplates").style.display = "none";
	  document.getElementById("TopMenuControl").innerHTML = "<img src='../Common/Images/showmenu.gif' name='ShowTopMenu'  id='ShowTopMenu' onclick='ShowHide(this)' style='cursor:hand' />";   			
         top.frameSet2.cols='0,*';         
      top.Frame1.rows='103,*,29';   
      parent.bodyframe.location.href="Dashboard.aspx";
          
    }
   function HideMenu()
   {
       if(document.getElementById("Header1_tblTemplates") !=null)
       {
       document.getElementById("Header1_tblTemplates").style.display = "none";
       top.frameSet2.cols='0,*'; 
       top.Frame1.rows='103,*,29';        
        }
   }
    function DisplayHelp()
    {
    
      window.open('../Help/HelpFrame.aspx?Name=','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
    }
    //
    // Logout
    //
    function LogOut()
    {
        parent.window.location.href="Userlogin.aspx";
    }
    
    //
    // SiteMap
    //
    function DisplaySiteMap()
    {
     document.getElementById("Header1_tblTemplates").style.display = "none";
		    document.getElementById("TopMenuControl").innerHTML = "<img src='../Common/Images/showmenu.gif' name='ShowTopMenu'  id='ShowTopMenu' onclick='ShowHide(this)' style='cursor:hand' />";   			
        top.frameSet2.cols='0,*'; 
        top.Frame1.rows='103,*,29';  
        parent.bodyframe.location.href="SiteMap.aspx";
    }
    
     // Javascript Function To Call Server Side Function Using Ajax
    function DeleteFiles(session)
    {
        var str=TopFrame.DeleteExcel(session).value.toString();
    }
    
	
    //
    // Function to change div size in VMI report
    //
    function ChangeEAUDivHeight(SHMode)
    {
        if(parent.bodyframe != null && window.parent.bodyframe.document.getElementById("div-datagrid") != null)
        {
            var bodyFrame = parent.document.getElementById('bodyframe');
            var newHeight;
            if (SHMode.id == "ShowTopMenu") 
            {   
		        newHeight = eval(window.parent.bodyframe.document.getElementById("div-datagrid").style.height.replace('px','')) - 33;		    
		    }
	        if (SHMode.id == "HideTopMenu") 
	        {
	            newHeight = eval(window.parent.bodyframe.document.getElementById("div-datagrid").style.height.replace('px','')) + 33;		    		 
		    }
		    window.parent.bodyframe.document.getElementById("div-datagrid").style.height = newHeight + "px";
        }
    }

</script>

<body bottommargin="0" topmargin="0"  >
    <form id="topform" runat="server">
        <table id="Table1" height="100%" cellspacing="0" cellpadding="0" width="100%" border="0">
            <tr>
                <td>
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <input id="Hid8" type="hidden" value="test" runat="server" /><input runat="server" id="Hid4" type="hidden" value="" /><input id="Hid10"
        type="hidden" value="" runat="server" /><input id="Hid2" type="hidden" value="" runat="server" /><input runat="server" id="Hid5" type="hidden" value="" />
    <input id="Hid3" type="hidden" value="" runat="server" /><input id="Hid6" type="hidden" value=""  runat="server"/>
        </table>

        <script>HideMenu();</script>

    </form>
</body>
</html>
