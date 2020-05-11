<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>POE</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet"  type="text/css" />
    <script>
    
    var offX = 5;
    var offY = 10;
    function ToolTip(Item,evt)
    {	   
	    document.getElementById("ToolTip").style.top = evt.clientY+offY;
	    document.getElementById("ToolTip").style.left = evt.clientX+offX;
	    if(evt.type == "mouseover") {
		    document.getElementById("ToolTip").innerText = Item.alt;
		    document.getElementById("ToolTip").style.display = 'block';
	    }
	    if(evt.type == "mouseout") {
		    document.getElementById("ToolTip").style.display = 'none';
	    }
    }
   
    function LoadPage(report)
    {
   	    window.open("http://pfcintranet/POE/frame.aspx?UserID="+'<%= Session["UserID"].ToString().Trim() %>'+"&UserName="+'<%= Session["UserName"].ToString().Trim() %>' ,'POE','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");	
    }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="ToolTip" style="font-family:arial; size:11px; display:none;position:absolute;background-color: #ffffcc; border:1px solid #666666; padding: 0px 5px 0px 5px;layer-background-color: #ffffcc;" zindex=1 >&nbsp;</div>
    <table width="100%"  border="0" cellspacing="2" cellpadding="0" id="table1">
      <tr>        
        <td>
            <uc1:PageHeader ID="PageHeader1" runat="server" />
        </td>
      </tr>
      <tr>
        <td valign="top" class="LoginFormBk" >
          <table width="100%"  border="0" cellspacing="2" cellpadding="2" id="table2" >
              <tr valign="top">
                  <td class="BlueBorder" style="width:100%">
                  <table width="100%"  border="0" cellpadding="0" cellspacing="0" >
                  <tr>
                    <td class="TabHeadBk" width="100%" style="height: 30px"><table width="100%"  border="0" cellspacing="0" cellpadding="3">
                        <tr>
                          <td width="16"><img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                          <td ><strong class="redtitle2">Purchase Order Entry System</strong></td>
                        </tr>
                    </table></td>
                  </tr>
                  
                  <tr>
                    <td id="5TD" class="blackTxt" style="height: 92px" width="100%">
                             <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SOE');">&nbsp;&nbsp;
                                                <a style="cursor: hand; color: Black;" onclick="LoadPage('POE');" id="A2" alt="Purchase Order Entry System"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Purchase Order Entry System</a></p>
                             <p class="10pxPadding">
                                 &nbsp;</p>
                              <p class="10pxPadding">
                                  &nbsp;</p>
                    </td>
                  </tr>
                </table>
                  
                  </td>
                 
              </tr>
        </table></td>
        </tr>
    </table> 
   
    </form>
</body>
</html>
