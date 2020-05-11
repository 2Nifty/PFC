<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Frame.aspx.cs" Inherits="PFC.Intranet.Frame" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>PFC Intranet Site</title>
     <!-- <LINK href="../Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet">
      <style>
        .frame {
	            margin-left: 0px;
	            margin-top: 0px;
	            margin-right: 0px;
	            margin-bottom: 0px;
	            background-color: #F9FDFE;
	            scrollbar-face-color: #9EDEEC;
	            scrollbar-shadow-color: #28AFCC;
	            scrollbar-highlight-color: #ECF8FB;
	            scrollbar-3dlight-color: #ffffff;
	            scrollbar-darkshadow-color: #B1E7F1;
	            scrollbar-track-color: #E4F7FA;
	            scrollbar-arrow-color: #1D7E94;
	            font-family: Arial, Helvetica, sans-serif;
	            font-size: 11px;
	            color: #3A3A56;
            }
        
      </style>-->
      <script>
        if(window.history.forward(1) != null)
                 window.history.forward(1);        
      </script>
</head>
<frameset rows="158,*,29" border="0" id="Frame1">
    <frame name="banner" scrolling="no" noresize src="TopFrame.aspx">
    <frameset cols="232,*" id="frameSet2" border="0">
        <frame name="mainmenus"  id="mainmenus" src="" noresize scrolling="no"  /> 
           
        <frame name="bodyframe" class="frame"  src="DashBoard.aspx" noresize >
      
    </frameset>
    <frame name="footer" scrolling="no" noresize src="FooterFrame.aspx">
    
</frameset>
  
</html>
