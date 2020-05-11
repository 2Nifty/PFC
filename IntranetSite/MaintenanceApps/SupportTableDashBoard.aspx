<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
            case "BOM": 
			    window.open('BillOfMaterials.aspx' ,'BOM','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
         case "Customer": 
			    window.open('../CustomerMaintenance/CustomerMaintenance.aspx' ,'CustomerMaintenance','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;	
            case "CustCont": 
			    window.open('../CustomerMaintenance/CustContractMaint.aspx' ,'CustContractMaint','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
            case "CatBuyGroupMaint": 
			    window.open('CatBuyGroupMaint.aspx' ,'CatBuyGroupMaint','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=yes','');	
		    break;	
            case "CatPriceSchedMaint": 
			    window.open('../CustomerMaintenance/CatPriceSchedMaint.aspx' ,'CatPriceSchedMaint','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=yes','');	
		    break;	
            case "CustPriceSchedMaint": 
			    window.open('../CustomerMaintenance/CustPriceSchedMaint.aspx' ,'CustPriceSchedMaint','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;	
            case "LOC": 
			    window.open('LocationMaster.aspx' ,'LocationMaster','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "LM": 
			    window.open('ListMaintenance.aspx' ,'ListMaintenance','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;	
		    case "Country": 
			    window.open('CountryCodeMaster.aspx' ,'CountryCode','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;	
		    case "Carrier": 
			    window.open('CarrierCodesMaintenance.aspx' ,'CarrierCode','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;	
		    case "COT":
			    window.open('ClassOfTrade.aspx' ,'ClassOfTrade','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;	
		    case "CT": 
			    window.open('CustomerType.aspx' ,'CustomerType','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;	
		    case "EXC":
			    window.open('ExpediteCodes.aspx' ,'ExpediteCodes','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;	
		    case "PRI": 
			    window.open('PriorityCodes.aspx' ,'PriorityCodes','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "RPCL": 
			    window.open('RepClass.aspx' ,'RepClass','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "SHIP": 
			    window.open('ShipMethod.aspx' ,'ShipMethod','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "SEC": 
			    window.open('SecurityGroupsMaint.aspx' ,'SecurityGroups','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "REAS": 
			    window.open('ReasonCodes.aspx' ,'ReasonCodes','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "FAM": 
			    window.open('FreightAddrMaint.aspx' ,'FreightAdder','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "FGHT": 
			    window.open('FreightTerms.aspx' ,'FGHT','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "FM": 
			    window.open('FormMessage.aspx' ,'FM','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "SC": 
			    window.open('StandardComments .aspx' ,'SC','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		     case "WM": 
			    window.open('WarningMessages.aspx' ,'WM','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "WCD": 
			    window.open('WebCatDiscMaint.aspx' ,'WCD','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "GLPosting": 
			    window.open('GLPosting.aspx' ,'GLPosting','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;	
		    case "GLAccount": 
			    window.open('GLAccount.aspx' ,'GLAccount','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		     case "FP": 
			    window.open('FiscalPeriod.aspx' ,'FiscalPeriod','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "EXP": 
			    window.open('ExpenseCode.aspx' ,'ExpenseCode','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "TRM": 
			    window.open('TermsCodes.aspx' ,'TermsCodes','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "OSC": 
			    window.open('OrganisationStandardComments .aspx' ,'OSC','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "VendorMaint":
		        window.open('../VendorMaintenance/VendorMaintenance.aspx' ,'VendorMaint','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "UserMaster":
		        window.open('../EmployeeData/UserMaster.aspx' ,'UserMaster','height=700,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "Trading":
		        window.open('../EDITradingPartners/TradingPartner.aspx' ,'TradingPartner','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "AppPref":
		        window.open('ApplicationPref.aspx' ,'AppPref','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "CVCAdder":
		        window.open('CVCAdder.aspx' ,'CVCAdder','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "RepMaster":
		        window.open('RepMaster.aspx' ,'CVCAdder','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "IALIAS":
		        window.open('ItemAliasMaint.aspx' ,'IALIAS','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "PRICECOST":
		        window.open('PriceCostMaint.aspx' ,'PRICECOST','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "CustPriceRanking":
		        window.open('CustomerPriceRanking.aspx' ,'CustPriceRanking','height=700,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
		    break;
		    case "VendPortUserMaster":
		        window.open('../Administrator/VendorPortalUserMaster.aspx' ,'CustPriceRanking','height=700,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
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
                            <td class="BlueBorder" height="30px" colspan="2">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="TabHeadBk" colspan="4">
                                            <table border="0" cellpadding="3" cellspacing="0" width="100%">
                                                <tr>
                                                    <td width="16">
                                                        <img height="23" hspace="4" src="../Common/Images/DragBullet.gif" width="8" /></td>
                                                    <td>
                                                        <strong class="redtitle2">Support Tables</strong></td>
                                                    <td align="right">
                                                        <img src="../Common/images/close.gif" onclick="javascript:window.location.href='DashBoard.aspx';"
                                                            style="cursor: hand" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="5TD" class="blackTxt" style="padding-bottom: 20px; width: 200px;" valign="top">
                                            <br />
                                            <p>
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('AppPref');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('AppPref');" href="#" id="A23" alt="Setup Application Preferences"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Application Preferences </a>
                                            </p>
                                            <p>
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('BOM');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('BOM');" href="#" alt="Setup Bill of Materials"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Bill of Materials Maintenance</a>
                                            </p>
                                            <p>
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('CatBuyGroupMaint');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('CatBuyGroupMaint');" href="#" id="A27" alt="Setup Category Buy Groups"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Category Buy Group Maintenance </a>
                                            </p>
                                            <p>
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('CatPriceSchedMaint');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('CatPriceSchedMaint');" href="#" id="A25" alt="Setup Category Price Schedules"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Category Price Sched Maintenance </a>
                                            </p>
                                            <p>
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('Carrier');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('Carrier');" href="#" id="A2" alt="Setup Carrier Codes" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Carrier Codes Maintenance </a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('COT');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('COT');" href="#" id="A3" alt="Setup Class Of Trade" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Class of Trade</a>
                                                <br />
                                            </p>
                                            <p>
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('Country');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('Country');" href="#" id="A1" alt="Setup Country Codes" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Country Codes Maintenance </a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('CustCont');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('CustCont');" href="#" alt="Setup Customer Contracts" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Customer Contract Maintenance</a>
                                                <br />
                                            </p>
                                            <p>
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('Customer');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('Customer');" href="#" id="A20" alt="Setup Customer Maintenance"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Customer Maintenance </a>
                                                <br />
                                            </p>
                                        </td>
                                        <td class="blackTxt" style="padding-bottom: 20px; width: 200px;" valign="top">
                                            <br />                                            <p>
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('CustPriceSchedMaint');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('CustPriceSchedMaint');" href="#" alt="Setup Customer Price Schedules"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Customer Price Sched Maintenance</a>
                                                <br />
                                            </p>

                                            <p>
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('CustPriceRanking');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('CustPriceRanking');" href="#" alt="Setup Customer Price Ranking"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Customer Price Ranking</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('CT');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('CT');" href="#" id="A4" alt="Setup Customer Type" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Customer Type</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('CVCAdder');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('CVCAdder');" href="#" id="A26" alt="Setup CVC Adder" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;CVC Adder</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('Trading');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('Trading');" href="#" id="A22" alt="Setup EDI Trading Type"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;EDI Trading</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('EXC');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('EXC');" href="#" id="A5" alt="Setup Expedite Codes" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Expedite Codes</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('EXP');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('EXP');" href="#" id="A17" alt="Setup Expense Codes" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Expense Codes</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('FP');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('FP');" href="#" id="A16" alt="Setup Fiscal Period" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Fiscal Period</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('FM');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('FM');" href="#" id="A11" alt="Setup Form Messages" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Form Messages</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('FAM');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('FAM');" href="#" alt="Setup Branch Freight Adders" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Freight Adders</a>
                                                <br />
                                            </p>
                                        </td>
                                        <td class="blackTxt" style="padding-bottom: 20px; width: 200px;" valign="top">
                                            <br />
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('FGHT');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('FGHT');" href="#" id="A10" alt="Setup Freight Terms" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Freight Terms</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('GLPosting');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('GLPosting');" href="#" id="A14" alt="Setup GL Posting Table"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;GL Posting Table Maintenance</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('GLAccount');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('GLAccount');" href="#" id="A24" alt="Setup GL Account Table"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;GL Account Master</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('IALIAS');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('IALIAS');" href="#" id="A28" alt="Setup Item Alias" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Item Alias</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('LOC');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('LOC');" href="#" id="A15" alt="Setup Location Master" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Location Master</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SC');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('OSC');" href="#" id="A19" alt="Setup Organization Standard Comments"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Organization Standard Comments</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('PRICECOST');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('PRICECOST');" href="#" id="A29" alt="Setup Priority Codes" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Price Cost Overlay</a>
                                                </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('PRI');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('PRI');" href="#" id="A6" alt="Setup Priority Codes" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Priority Codes</a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('REAS');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('REAS');" href="#" id="A9" alt="Setup Reason Code" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Reason Code</a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('RPCL');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('RPCL');" href="#" id="A7" alt="Setup Rep Class" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Rep Class</a>
                                            </p>                                              
                                        </td>
                                        <td id="Td1" class="blackTxt" style="padding-bottom: 20px; width: 200px;" valign="top">
                                            <br />
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('RepMaster');">
                                                &nbsp; <a onclick="LoadPage('RepMaster');" href="#" alt="View Vendor Maintenance"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Rep Master </a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SEC');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SEC');" href="#" alt="Setup Security Groups" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Security Groups</a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SHIP');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SHIP');" href="#" id="A8" alt="Setup Ship Method" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Ship Method</a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('SC');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('SC');" href="#" id="A12" alt="Setup Standard Comments" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Standard Comments</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('TRM');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('TRM');" href="#" id="A18" alt="Setup Terms Code" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Terms Code</a>
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('UserMaster');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('UserMaster');" href="#" id="A21" alt="Setup Users" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;User Master</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('WM');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('WM');" href="#" id="A13" alt="Setup Warning Messages" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Warning Messages</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('WCD');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('WCD');" href="#" alt="Setup Web Catgory Discounts" onmouseover="ToolTip(this,window.event);"
                                                    onmouseout="ToolTip(this,window.event);">&nbsp;Web Category Discounts</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('VM');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('VendorMaint');" href="#" id="x" alt="View Vendor Maintenance"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Vendor Maintenance</a>
                                                <br />
                                            </p>
                                            <p class="10pxPadding">
                                                <img src="../Common/Images/Bullet.gif" width="10" height="9" onclick="LoadPage('VendPortUserMaster');">&nbsp;&nbsp;
                                                <a onclick="LoadPage('VendPortUserMaster');" href="#" id="A30" alt="View Vendor Portal User Master"
                                                    onmouseover="ToolTip(this,window.event);" onmouseout="ToolTip(this,window.event);">
                                                    &nbsp;Vendor Portal User Master</a>
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
