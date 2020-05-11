<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {                
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

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
        switch (report)
        {
		    case "LM": 
			    window.open('ListMaintenance.aspx' ,'ListMaintenance','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;	
		    
		    
		    default : alert("Out of range");	
		}
    
    } 
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="ToolTip" style="font-family: arial; size: 11px; display: none; position: absolute;
            background-color: #ffffcc; border: 1px solid #666666; padding: 0px 5px 0px 5px;
            layer-background-color: #ffffcc;" zindex="1">
            &nbsp;</div>
        <table width="100%" border="0" cellspacing="2" cellpadding="0" id="table1">
            <tr>
                <!-- <td valign="middle" background="../Common/Images/inbannerbk.jpg"><img src="../Common/Images/dashboardBanner.jpg"  ></td>-->
                <td>
                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                </td>
            </tr>
            <tr>
                <td valign="top" class="LoginFormBk" style="height: 200px">
                    <table width="100%" border="0" cellspacing="2" cellpadding="2" id="table2">
                        <tr valign="top">
                            <td class="BlueBorder" height=30px colspan="2">
                                <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="TabHeadBk" colspan="2" >
                                            <table border="0" cellpadding="3" cellspacing="0" width="100%">
                                                <tr>
                                                    <td width="16">
                                                        <img height="23" hspace="4" src="../Common/Images/DragBullet.gif" width="8" /></td>
                                                    <td>
                                                        <strong class="redtitle2">IT Tables</strong></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td class="TabHeadBk" colspan="1">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="blackTxt" style="padding-bottom: 20px;width:250px;" valign=top>
                                        <br />                                            
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('LM');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('LM');"
                                                    href="#" id="x"
                                                    alt="Setup List Master" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;List Maintenance</a>
                                                <br />
                                            </p>                                            
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9">&nbsp;&nbsp;
                                                <a href=supportTableDashBoard.aspx id="A6" alt="View Support Tables" onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">&nbsp;Support Tables</a>
                                                <br />
                                            </p>                                            
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
