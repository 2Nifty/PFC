<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Dashboard Drilldown Testing</title>
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
        switch (report){
		case "SDA": 		
			 window.open("ProgressBar.aspx?destPage=SalesRpt.aspx?Location=00~LocName=Corporate~Range=Daily" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;
		case "SMTDA": 		
			 window.open("ProgressBar.aspx?destPage=SalesRpt.aspx?Location=00~LocName=Corporate~Range=MTD" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;
	    case "SDHay": 		
			 window.open("ProgressBar.aspx?destPage=SalesRpt.aspx?Location=02~LocName=Hayward~Range=Daily" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;					
	    case "SMTDHay": 		
			 window.open("ProgressBar.aspx?destPage=SalesRpt.aspx?Location=02~LocName=Hayward~Range=MTD" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;

		case "MDA": 		
			 window.open("ProgressBar.aspx?destPage=MarginRpt.aspx?Location=00~LocName=Corporate~Range=Daily" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;
		case "MMTDA": 		
			 window.open("ProgressBar.aspx?destPage=MarginRpt.aspx?Location=00~LocName=Corporate~Range=MTD" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;
	    case "MDHay": 		
			 window.open("ProgressBar.aspx?destPage=MarginRpt.aspx?Location=02~LocName=Hayward~Range=Daily" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;					
	    case "MMTDHay": 		
			 window.open("ProgressBar.aspx?destPage=MarginRpt.aspx?Location=02~LocName=Hayward~Range=MTD" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;

		case "PDA": 		
			 window.open("ProgressBar.aspx?destPage=ProfitLbRpt.aspx?Location=00~LocName=Corporate~Range=Daily" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;
		case "PMTDA": 		
			 window.open("ProgressBar.aspx?destPage=ProfitLbRpt.aspx?Location=00~LocName=Corporate~Range=MTD" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;
	    case "PDHay": 		
			 window.open("ProgressBar.aspx?destPage=ProfitLbRpt.aspx?Location=02~LocName=Hayward~Range=Daily" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;					
	    case "PMTDHay": 		
			 window.open("ProgressBar.aspx?destPage=ProfitLbRpt.aspx?Location=02~LocName=Hayward~Range=MTD" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;

	    case "SODA": 		
			 window.open("ProgressBar.aspx?destPage=SOHeaderRpt.aspx?Location=00~LocName=Corporate~Customer=******~Invoice=0000000000~Range=Daily" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;
	    case "SODC": 		
			 window.open("ProgressBar.aspx?destPage=SOHeaderRpt.aspx?Location=00~LocName=Corporate~Customer=201320~Invoice=0000000000~Range=Daily" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;
	    case "SODHay": 		
			 window.open("ProgressBar.aspx?destPage=SOHeaderRpt.aspx?Location=02~LocName=02 - Hayward~Customer=******~Invoice=0000000000~Range=Daily" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;

	    case "SOMA": 		
			 window.open("ProgressBar.aspx?destPage=SOHeaderRpt.aspx?Location=00~LocName=Corporate~Customer=******~Invoice=0000000000~Range=MTD" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;
	    case "SOMC": 		
			 window.open("ProgressBar.aspx?destPage=SOHeaderRpt.aspx?Location=00~LocName=Corporate~Customer=201320~Invoice=0000000000~Range=MTD" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;
	    case "SOMHay": 		
			 window.open("ProgressBar.aspx?destPage=SOHeaderRpt.aspx?Location=02~LocName=02 - Hayward~Customer=******~Invoice=0000000000~Range=MTD" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;

	    case "SOCDA": 		
			 window.open("ProgressBar.aspx?destPage=SOCustomerRpt.aspx?Location=00~LocName=Corporate~Customer=000000~Invoice=**********~Range=Daily" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;
	    case "SOCDHay": 		
			 window.open("ProgressBar.aspx?destPage=SOCustomerRpt.aspx?Location=02~LocName=02 - Hayward~Customer=000000~Invoice=**********~Range=Daily" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;
	    case "SOCMA": 		
			 window.open("ProgressBar.aspx?destPage=SOCustomerRpt.aspx?Location=00~LocName=Corporate~Customer=000000~Invoice=**********~Range=MTD" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
		break;
	    case "SOCMHay": 		
			 window.open("ProgressBar.aspx?destPage=SOCustomerRpt.aspx?Location=02~LocName=02 - Hayward~Customer=000000~Invoice=**********~Range=MTD" ,'Sales','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
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
                <td valign="middle" class="PageHead">
                    <span class="Left5pxPadd">
                        <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="">Dashboard Drilldown Testing</asp:Label></span>
                </td>
            </tr>
            <tr>
                <td valign="top" class="LoginFormBk">
                    <table width="100%" border="0" cellspacing="2" cellpadding="2" id="table2">
                        <tr valign="top">
                            <td class="BlueBorder" height=30px colspan="2">
                                <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td id="5TD" class="blackTxt" style="padding-bottom:20px" valign=middle >
                                            <br />
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SDA');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SDA');"
                                                    href="#" id="x"
                                                    alt="Sales Daily All Branches" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Sales Daily All Branches<br /></a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SMTDA');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SMTDA');"
                                                    href="#" id="A2"
                                                    alt="Sales MTD All Branches" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Sales MTD All Branches<br /></a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SDHay');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SDHay');"
                                                    href="#" id="A1"
                                                    alt="Sales Daily Hayward" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Sales Daily Hayward<br /></a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SMTDHay');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SMTDHay');"
                                                    href="#" id="A3"
                                                    alt="Sales MTD Hayward" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Sales MTD Hayward<br /></a>
                                            </p>
                                        </td>
                                        <td id="Td1" class="blackTxt" style="padding-bottom:20px" valign=middle >
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('MDA');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('MDA');"
                                                    href="#" id="A4"
                                                    alt="Margin Daily All Branches" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Margin Daily All Branches<br /></a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('MMTDA');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('MMTDA');"
                                                    href="#" id="A5"
                                                    alt="Margin MTD All Branches" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Margin MTD All Branches<br /></a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('MDHay');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('MDHay');"
                                                    href="#" id="A6"
                                                    alt="Margin Daily Hayward" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Margin Daily Hayward<br /></a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('MMTDHay');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('MMTDHay');"
                                                    href="#" id="A7"
                                                    alt="Margin MTD Hayward" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Margin MTD Hayward<br /></a>
                                            </p>

                                        </td>
                                        <td id="Td2" class="blackTxt" style="padding-bottom:20px" valign=middle >
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('PDA');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('PDA');"
                                                    href="#" id="A8"
                                                    alt="Profit Daily All Branches" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Profit Daily All Branches<br /></a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('PMTDA');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('PMTDA');"
                                                    href="#" id="A9"
                                                    alt="Profit MTD All Branches" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Profit MTD All Branches<br /></a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('PDHay');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('PDHay');"
                                                    href="#" id="A10"
                                                    alt="Profit Daily Hayward" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Profit Daily Hayward<br /></a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('PMTDHay');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('PMTDHay');"
                                                    href="#" id="A11"
                                                    alt="Profit MTD Hayward" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Profit MTD Hayward<br /></a>
                                            </p>

                                        </td>


                                        <td id="Td3" class="blackTxt" style="padding-bottom:20px" valign=middle >
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SODA');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SODA');"
                                                    href="#" id="A12"
                                                    alt="Sales Orders Daily All" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Sales Orders Daily All<br /></a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SODC');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SODC');"
                                                    href="#" id="A13"
                                                    alt="Sales Orders Daily Cust 201320" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Sales Orders Daily Cust 201320<br /></a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SODHay');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SODHay');"
                                                    href="#" id="A14"
                                                    alt="Sales Orders Daily Hay" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Sales Orders Daily Hay<br /></a>
                                            </p>
                                            
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SOMA');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SOMA');"
                                                    href="#" id="A15"
                                                    alt="Sales Orders MTD All" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Sales Orders MTD All<br /></a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SOMC');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SOMC');"
                                                    href="#" id="A16"
                                                    alt="Sales Orders MTD Cust 201320" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Sales Orders MTD Cust 201320<br /></a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SOMHay');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SOMHay');"
                                                    href="#" id="A17"
                                                    alt="Sales Orders MTD Hay" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Sales Orders MTD Hay<br /></a>
                                            </p>

                                        </td>



                                        <td id="Td4" class="blackTxt" style="padding-bottom:20px" valign=middle >
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SOCDA');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SOCDA');"
                                                    href="#" id="A18"
                                                    alt="Sales Orders Daily By Customer All" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Sales Orders Daily By Customer All<br /></a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SOCDHay');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SOCDHay');"
                                                    href="#" id="A19"
                                                    alt="Sales Orders Daily By Customer - Hayward" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Sales Orders Daily By Customer - Hayward<br /></a>
                                            </p>

                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SOCMA');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SOCMA');"
                                                    href="#" id="A20"
                                                    alt="Sales Orders MTD By Customer All" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Sales Orders MTD By Customer All<br /></a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SOCMHay');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SOCMHay');"
                                                    href="#" id="A21"
                                                    alt="Sales Orders MTD By Customer - Hayward" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">Sales Orders MTD By Customer - Hayward<br /></a>
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
