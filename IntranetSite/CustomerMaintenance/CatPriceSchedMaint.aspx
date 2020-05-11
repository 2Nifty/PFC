<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CatPriceSchedMaint.aspx.cs" Inherits="CatPriceSchedMaint" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer2" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../Common/Javascript/ContextMenu.js"></script>
    <style type="text/css">
        .ws_whitebox 
        {
	        font-family:  Helvetica, Arial, sans-serif;
	        font-size: 11px;
	        color: #003366;	
	        background:#ffffff;	
	        border: 1px solid Gray;
	        font-weight:normal;
	        height: 12px;
	        padding-top: 2px;
	        padding-right: 2px;
	        padding-bottom: 3px;
	        padding-left: 2px;
	        text-align: right;
        }
        
        .NoShow
        {
            display:none;
        }
        
        .ws_whitebox_left 
        {
	        font-family:  Helvetica, Arial, sans-serif;
	        font-size: 11px;
	        color: #003366;	
	        background:#ffffff;	
	        border: 1px solid Gray;
	        font-weight:normal;
	        height: 12px;
	        padding-top: 2px;
	        padding-right: 2px;
	        padding-bottom: 3px;
	        padding-left: 2px;
	        text-align: left;	        
        }
        
        .splitBorder{border-bottom:1px Solid #A0A0A0;}
        .splitBorder_l_h {border-left:1px solid #A0A0A0;}
        .splitBorder_r_h {border-right:1px solid #A0A0A0;}        
        .splitborder_t_v {border-top:1px solid #A0A0A0;}
        
    </style>

    <script>
        var CPSMDetailWindow;
        function pageUnload() 
        {
            if (CPSMDetailWindow != null) {CPSMDetailWindow.close();CPSMDetailWindow=null;}
        }
        function ClosePage()
        {
            window.close();	
        }

        function OpenDetail(CPSM)
        {
            if (CPSMDetailWindow != null) {CPSMDetailWindow.close();CPSMDetailWindow=null;}
            var Loc = $get("LocationDropDownList")
            var DetailURL = 'RBReceiptsLPDetail.aspx?CPSMumber=' + CPSM + '&Loc=' + Loc.options[Loc.selectedIndex].text;
            //alert(DetailURL);
            CPSMDetailWindow=window.open(DetailURL,'CPSMDetailWin','height=750,width=1000,toolbar=0,scrollbars=0,status=1,resizable=YES','');  
            SetHeight();   
            return false;  
        }

        function ChangeTarget(TargetBox)
        {
            //alert('ChangeTarget');
            //Get the group number from the front of the row
            var LineParent = TargetBox.parentNode.parentNode;
            var status = CatPriceSchedMaint.UpdTarget(LineParent.firstChild.innerText, TargetBox.value).value;
            //alert('GroupNo='+LineParent.firstChild.innerText+' - Target='+TargetBox.value);
            //alert(status);
        }

        function ChangeApproved(ApprovedBox)
        {
            //alert('ChangeApproved');
            //Get the group number from the front of the row
            var LineParent = ApprovedBox.parentNode.parentNode.parentNode;
            var status = CatPriceSchedMaint.UpdApproved(LineParent.firstChild.innerText, ApprovedBox.checked).value;
            //alert('GroupNo='+LineParent.firstChild.innerText+' - Approved='+ApprovedBox.checked);
            //alert(status);
        }

        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //take out room for bottom panel
            yh = yh - 345;
            xw = xw
            // size the grid
            if ($get("DetailGridPanel")!=null)
            {
                var DetailGridPanel = $get("DetailGridPanel");
                DetailGridPanel.style.height = yh;  
                DetailGridPanel.style.width = xw;  
                var DetailGridHeightHid = $get("DetailGridHeightHidden");
                DetailGridHeightHid.value = yh;
                var DetailGridHeightHid = $get("DetailGridWidthHidden");
                DetailGridHeightHid.value = xw;
            }
        }
        
        var addNewItemURL = "";
        var ItemsByCategoryURL = "";
        var ItemsByCustomerURL = "";
        var LLLContractsURL = "";
        var PriceAnlaysisURL = "";
        
        function ShowToolTip(event,strNewItemURL, strItemsByCategoryURL, strItemsByCustomerURL,strLLLContractsURL,strPriceAnalysisURL, ctlID)
        {
            if(event.button==2)
            {
                addNewItemURL=strNewItemURL;
                ItemsByCategoryURL = strItemsByCategoryURL;
                ItemsByCustomerURL = strItemsByCustomerURL;
                LLLContractsURL = strLLLContractsURL;
                PriceAnlaysisURL = strPriceAnalysisURL;
                
                ShowDiv('divToolTip',ctlID,event);
                return false;
            }
        }
   
        function ShowAddNewItemScreen()
        {
            window.open(addNewItemURL,'AddNewItem' ,'height=340,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (350/2))+',left='+((screen.width/2) - (970/2))+',resizable=no',"");
            xstooltip_hide('divToolTip');
        }
        
        function ShowItemsByCategory()
        {
            window.open(ItemsByCategoryURL,'ItemsByCat' ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (970/2))+',resizable=no',"");
            xstooltip_hide('divToolTip');
        }
        
        function ShowItemsByCustomer()
        {
            window.open(ItemsByCustomerURL,'ItemByCust' ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (970/2))+',resizable=no',"");
            xstooltip_hide('divToolTip');
        }
        
        function ShowLLLContracts()
        {
            window.open(LLLContractsURL,'LLLContract' ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (970/2))+',resizable=no',"");
            xstooltip_hide('divToolTip');
        }        
        
        
        function ShowOrdCustomer()
        {
            window.open(OrdCustomerURL, 'Customer', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no');
            xstooltip_hide('divToolTip');
        }

        function OpenCostBasisWindow()
        {
            if(document.getElementById("txtCustNo").value == "")
                alert('Invalid Customer Number.');
            else
            {
                var pageURL = 'CostBasis.aspx?CustNo=' + document.getElementById("txtCustNo").value;
                window.open(pageURL, 'setbasiswindow', 'height=160,width=400,scrollbars=no,status=no,top='+((screen.height/2) - (160/2))+',left='+((screen.width/2) - (400/2))+',resizable=no');
            }
                
            return false;
        }

        function ShowPriceAnalysisForCategory()
        {
            window.open(PriceAnlaysisURL,'PriceAnalysis' ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (700/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
            xstooltip_hide('divToolTip');
        }
        
        function OpenPriceAnalysisReport()
        {
            if(document.getElementById("txtCustNo").value == "")
                alert('Invalid Customer Number.');
            else
            {
                var pageURL = 'PriceAnalysisReport.aspx?CustNo=' + document.getElementById("txtCustNo").value;
                window.open(pageURL, 'PriceAnalysis', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (700/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no');
            }
                
            return false;
        }
        
        function ShowDiv(divCtlId,parentCtlId,event)
        {
            it = document.getElementById(divCtlId);                  
            var scrollBarPosistion = document.getElementById("divdatagrid").scrollTop;
            var mouseYPoint = (event.clientY + scrollBarPosistion ) - 290 ;
            it.style.top =  mouseYPoint + 'px';         
            it.style.left = event.clientX + 'px'; 
            it.style.display = '';
        }
            
        function HideToolTip(ctlID)
        {
            if(ctlID=='imgDivClose')
              xstooltip_hide('divToolTip');
            else 
            {
                if(ctlID=='divToolTip')
                    hid='true';
                else 
                    hid='';
            }
        }
    </script>

    <title>Category Price Schedules Maintenance</title>
</head>
<body onload="SetHeight();" onresize="SetHeight();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="CPSMScriptManager" runat="server" EnablePartialRendering="true" />
        <div>
            <asp:UpdatePanel ID="MainUpdatePanel" runat="server">
                <ContentTemplate>
                    <table width="100%" cellspacing="0" cellpadding="0" border="0">
                        <tr>
                            <td>
                                <uc1:Header id="Pageheader" runat="server">
                                </uc1:Header>
                            </td>
                        </tr>
                        <tr>
                            <td class="lightBlueBg">
                                <span class="BanText">Category Price Schedules Maintenance</span>
                            </td>
                        </tr>
                        <tr>
                            <td class="BluBg">
                                <asp:Panel ID="SelectorPanel" runat="server" Height="215px" Width="100%">
                                    <asp:UpdatePanel ID="SelectorUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <table width="100%" class="shadeBgDown" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td align="left" valign=middle>
                                                        <table cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td width="115px" style="padding-left: 15px; font-weight: bold;">
                                                                    Customer Number
                                                                </td>
                                                                <td width="85px">
                                                                    <asp:TextBox ID="txtCustNo" runat="server" Width="70px" CssClass="FormCtrl" TabIndex="1"
                                                                        onkeypress="javascript:if(event.keyCode==13){document.getElementById('btnSearch').click();return false;}"
                                                                        onfocus="javascript:this.select();" ></asp:TextBox>
                                                                </td>
                                                                <td width="60px" style="padding-left: 15px; font-weight: bold;">
                                                                    <asp:RadioButton ID="rdoBulk" Checked=true runat="server" Text="Bulk" GroupName="options" /></td>
                                                                <td>
                                                                    <asp:RadioButton ID="rdoPackage" runat="server" Font-Bold="True" Text="Package" GroupName="options" Width="80px" /></td>
                                                                <td width="75px" style="padding-top:3px;">
                                                                    <asp:ImageButton ID="btnSearch" OnClick="btnSearch_Click" AlternateText="Show Price History for Customer"
                                                                        runat="server" ImageUrl="../Common/Images/search.gif" CausesValidation="false" TabIndex="3" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td align="right" width="35%" valign="middle"  style="padding-top:3px;">
                                                        <table cellpadding="0" cellspacing="0" width="100%">
                                                            <tr>
                                                                <td width=85px style="padding-right:5px;">
                                                                    <asp:ImageButton ID="btnPriceAnalysis" Visible=false runat="server" 
                                                                    OnClientClick="javascript:return OpenPriceAnalysisReport();"
                                                                    ImageUrl="../Common/Images/priceanalysis.gif" ToolTip="Click here to view price analysis report" CausesValidation="false" />
                                                                </td>
                                                                <td width=85px style="padding-right:5px;">
                                                                    <asp:ImageButton ID="ibtnSetBasis" Visible=false runat="server" 
                                                                    OnClientClick="javascript:return OpenCostBasisWindow();"
                                                                    ImageUrl="Common/Images/setbasis.gif" ToolTip="Click here to set cost basis" CausesValidation="false" />
                                                                </td>
                                                                <td align="center" width=85px >
                                                                    <asp:UpdatePanel ID="SubmitUpdatePanel" runat="server" UpdateMode="Conditional">
                                                                        <ContentTemplate>
                                                                            <asp:ImageButton style="padding-right:5px;" ID="btnSubmit" runat="server"  ImageUrl="Common/Images/submit.gif" OnClick="btnSubmit_Click" ToolTip="Click here to submit you targets" CausesValidation="false" />
                                                                        </ContentTemplate>
                                                                        <Triggers>
                                                                            <asp:PostBackTrigger ControlID="btnSubmit" />
                                                                        </Triggers>
                                                                    </asp:UpdatePanel>
                                                                    <asp:UpdatePanel ID="ApproveUpdatePanel" runat="server" UpdateMode="Conditional">
                                                                        <ContentTemplate>
                                                                            <asp:ImageButton style="padding-right:5px;" ID="btnApprove" runat="server" ImageUrl="Common/Images/Approve.gif" OnClick="btnApprove_Click" CausesValidation="false" />
                                                                        </ContentTemplate>
                                                                        <Triggers>
                                                                            <asp:PostBackTrigger ControlID="btnApprove" />
                                                                        </Triggers>
                                                                    </asp:UpdatePanel>
                                                                </td>
                                                                <td align="center" width=75px>
                                                                    <asp:UpdatePanel ID="ExcelUpdatePanel" runat="server" UpdateMode="Conditional">
                                                                        <ContentTemplate>
                                                                            <asp:ImageButton ID="btnExcel" style="padding-right:5px;"  runat="server" ImageUrl="Common/Images/Excel.gif" OnClick="btnExcel_Click"   CausesValidation="false" />
                                                                        </ContentTemplate>
                                                                        <Triggers>
                                                                            <asp:PostBackTrigger ControlID="btnExcel" />
                                                                        </Triggers>
                                                                    </asp:UpdatePanel>
                                                                </td>
                                                                <td align="right" width=70px>
                                                                    <img src="Common/Images/close.gif" style="cursor: hand" onclick="ClosePage();" alt="Close Page">&nbsp;
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" align="left">
                                                        <table cellpadding="0" cellspacing="0" width="100%">
                                                            <tr>
                                                                <td width="475px" style="padding-left: 15px;">
                                                                    <b>Customer Name</b>&nbsp;&nbsp;&nbsp;<asp:Label ID="lblCustName" runat="server" Text=""></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    <b>Branch</b>&nbsp;&nbsp;&nbsp;<asp:Label ID="lblBranch" runat="server" Text=""></asp:Label>
                                                                </td>
                                                                <td>
                                                                    <asp:Label ID="lblRecType" runat="server" Text=""></asp:Label>
                                                                    <asp:UpdateProgress ID="UpdateProgress2" runat="server" AssociatedUpdatePanelID="MainUpdatePanel" DisplayAfter="15">
                                                                        <ProgressTemplate>
                                                                            The Customer Price History you requested is being retrieved. One Moment....
                                                                        </ProgressTemplate>
                                                                    </asp:UpdateProgress>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr><td>&nbsp;</td></tr>
                                            </table>
                                            <table cellpadding="3" cellspacing="0">
                                                <tr>
                                                    <td width="115px" height="30px" style="padding-left: 15px; font-weight: bold;">
                                                        Contract Schedule 1
                                                    </td>
                                                    <td width="70" class="Left2pxPadd Right2pxPadd">
                                                        <asp:Label ID="lblSched1" runat="server"></asp:Label>
                                                    </td>
                                                    <td width="125px" style="padding-left: 30px; font-weight: bold;">
                                                        Contract Schedule 5
                                                    </td>
                                                    <td width="60" class="Left2pxPadd Right2pxPadd">
                                                        <asp:Label ID="lblSched5" runat="server"></asp:Label>
                                                    </td>
                                                    <td width="130px" style="padding-left: 30px; font-weight: bold;">
                                                        Customer Default Price</td>
                                                    <td width="130px" class="Left2pxPadd Right2pxPadd">
                                                        &nbsp;<asp:Label ID="lblCustDefPrice" runat="server"></asp:Label></td>
                                                    <td width="120" style="padding-left: 30px; font-weight: bold;">
                                                        Credit Indicator
                                                    </td>
                                                    <td width="60" class="Left2pxPadd Right2pxPadd">
                                                        <asp:Label ID="lblCreditInd" runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="115px" height="30px" style="padding-left: 15px; font-weight: bold;">
                                                        Contract Schedule 2
                                                    </td>
                                                    <td class="Left2pxPadd Right2pxPadd">
                                                        <asp:Label ID="lblSched2" runat="server"></asp:Label>
                                                    </td>
                                                    <td width="125px" style="padding-left: 30px; font-weight: bold;">
                                                        Contract Schedule 6
                                                    </td>
                                                    <td class="Left2pxPadd Right2pxPadd">
                                                        <asp:Label ID="lblSched6" runat="server"></asp:Label>
                                                    </td>
                                                    <td width="130px" style="padding-left: 30px; font-weight: bold;">
                                                        Default Gross Mgn Pct
                                                    </td>
                                                    <td width="130px" class="Left2pxPadd Right2pxPadd" valign="middle">
                                                        &nbsp;<asp:Label ID="lblTargetGross" runat="server"></asp:Label></td>
                                                    <td style="padding-left: 30px; font-weight: bold;" valign="middle">
                                                        Enable Web Discount
                                                    </td>
                                                    <td class="Left2pxPadd Right2pxPadd" valign="middle">
                                                        <asp:CheckBox ID="chkWebDiscInd" runat="server" Enabled="false" Text="" /></td>
                                                </tr>
                                                <tr>
                                                    <td width="115px" height="30px" style="padding-left: 15px; font-weight: bold;">
                                                        Contract Schedule 3
                                                    </td>
                                                    <td class="Left2pxPadd Right2pxPadd">
                                                        <asp:Label ID="lblSched3" runat="server"></asp:Label>
                                                    </td>
                                                    <td width="125px" style="padding-left: 30px; font-weight: bold;">
                                                        Contract Schedule 7
                                                    </td>
                                                    <td class="Left2pxPadd Right2pxPadd">
                                                        <asp:Label ID="lblSched7" runat="server"></asp:Label>
                                                    </td>
                                                    <td width="130px" style="padding-left: 30px; font-weight: bold;">
                                                        Actual Gross Mgn Pct</td>
                                                    <td width="130px" class="Left2pxPadd Right2pxPadd">
                                                        &nbsp;<asp:Label ID="lblActGrossMgnPct" runat="server"></asp:Label></td>
                                                    <td  style="padding-left: 30px; font-weight: bold;">
                                                        Customer Price Ind</td>
                                                    <td class="Left2pxPadd Right2pxPadd">
                                                        <asp:Label ID="lblCustPriceInd" runat="server"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td width="115px" height="30px" style="padding-left: 15px; font-weight: bold;">
                                                        Contract Schedule 4
                                                    </td>
                                                    <td class="Left2pxPadd Right2pxPadd">
                                                        <asp:Label ID="lblSched4" runat="server"></asp:Label>
                                                    </td>
                                                    <td width="125px" style="padding-left: 30px; font-weight: bold;">
                                                    </td>
                                                    <td class="Left2pxPadd Right2pxPadd">
                                                        &nbsp;</td>
                                                    <td width="130px" style="padding-left: 30px; font-weight: bold;">
                                                        Default Cost Plus Pct</td>
                                                    <td width="130px" class="Left2pxPadd Right2pxPadd">
                                                        &nbsp;<asp:Label ID="lblDefaultCostPct" runat="server"></asp:Label></td>
                                                    <td  style="padding-left: 30px; font-weight: bold;">
                                                        Web Discount Pct
                                                    </td>
                                                    <td class="Left2pxPadd Right2pxPadd">
                                                        <asp:Label ID="lblWebDiscPct" runat="server"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td valign="top">
                                            <asp:Panel ID="DetailGridPanel" runat="server" ScrollBars="none">
                                                <asp:HiddenField ID="DetailGridHeightHidden" runat="server" />
                                                <asp:HiddenField ID="DetailGridWidthHidden" runat="server" />
                                                <asp:UpdatePanel ID="DetailUpdatePanel" runat="server" UpdateMode="Conditional">
                                                    <ContentTemplate>
                                                        <div id="divdatagrid" class="Sbar" align="left" runat="server" style="overflow: auto; position: relative; width: 1019px; height: 370px; top: 0px; left: 0px; border: 0px solid; vertical-align: top;">
                                                            <asp:GridView ID="CPSMGridView" runat="server" HeaderStyle-CssClass="GridHead" AutoGenerateColumns="false"
                                                                RowStyle-BackColor="#FFFFFF" RowStyle-CssClass="Left5pxPadd" AllowSorting="true" Width="1480px"
                                                                OnSorting="SortDetailGrid" OnRowDataBound="DetailRowBound">
                                                                <AlternatingRowStyle CssClass="Left5pxPadd" BackColor="#DCF3FB" BorderColor="#DAEEEF" />
                                                                <Columns>
                                                                    <asp:BoundField DataField="GroupNo" HeaderText="Group" SortExpression="GroupNo" HeaderStyle-HorizontalAlign="Center"
                                                                        ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-HorizontalAlign="center" ItemStyle-Width="50px" />

                                                                    <asp:BoundField DataField="GroupDesc" HeaderText="Description" SortExpression="GroupDesc" HeaderStyle-HorizontalAlign="Center"
                                                                        ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-HorizontalAlign="left" ItemStyle-Width="280px" />

                                                                   <%-- <asp:BoundField DataField="SalesHistory" HeaderText="3 Mo Sales" ItemStyle-HorizontalAlign="right"
                                                                        DataFormatString="{0:c}" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="80px"
                                                                        SortExpression="SalesHistory" HeaderStyle-HorizontalAlign="Center" />

                                                                    <asp:BoundField DataField="GMPctPriceCost" DataFormatString="{0:N2}" HeaderStyle-HorizontalAlign="Center"
                                                                        HeaderText="Mgn @ Price" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-HorizontalAlign="right"
                                                                        ItemStyle-Width="80px" SortExpression="GMPctPriceCost" />

                                                                    <asp:BoundField DataField="GMPctAvgCost" DataFormatString="{0:N2}" HeaderStyle-HorizontalAlign="Center"
                                                                        HeaderText="Mgn @ Avg" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-HorizontalAlign="right"
                                                                        ItemStyle-Width="80px" SortExpression="GMPctAvgCost" /> --%>
                                                                        
                                                                    <asp:BoundField DataField="SalesHistory" HeaderText="3 Mo Sales (Total)" ItemStyle-HorizontalAlign="right"
                                                                        DataFormatString="{0:c}" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="80px"
                                                                        SortExpression="SalesHistory" HeaderStyle-HorizontalAlign="Center" />
                                                                        
                                                                    <asp:BoundField DataField="GMPctSmthAvgCost" DataFormatString="{0:N2}" HeaderStyle-HorizontalAlign="Center"
                                                                        HeaderText="GM% @ Sug" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-HorizontalAlign="right"
                                                                        ItemStyle-Width="85px" SortExpression="GMPctSmthAvgCost" />

                                                                    <asp:BoundField DataField="GMPctAvgCost" DataFormatString="{0:N2}" HeaderStyle-HorizontalAlign="Center"
                                                                        HeaderText="GM% @ Avg" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-HorizontalAlign="right"
                                                                        ItemStyle-Width="80px" SortExpression="GMPctAvgCost" />
                                                                        
                                                                    <asp:BoundField DataField="GMPctReplCost" DataFormatString="{0:N2}" HeaderStyle-HorizontalAlign="Center"
                                                                        HeaderText="GM% @ Rpl" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-HorizontalAlign="right"
                                                                        ItemStyle-Width="80px" SortExpression="GMPctReplCost" />
   
                                                                    <asp:BoundField DataField="NonContractSales" HeaderText="Non-Cont $" ItemStyle-HorizontalAlign="right"
                                                                        DataFormatString="{0:c}" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="80px"
                                                                        SortExpression="NonContractSales" HeaderStyle-HorizontalAlign="Center" />
                                                                        
                                                                    <asp:TemplateField ItemStyle-Width="60px" HeaderText="Target" HeaderStyle-HorizontalAlign="Center"
                                                                        ItemStyle-HorizontalAlign="right" SortExpression="TargetGMPct">
                                                                        <ItemTemplate>
                                                                            <asp:TextBox ID="TargetTextBox" runat="server" Text='<%# Eval("TargetGMPct", "{0:##0.00} ") %>'
                                                                                Width="55px" CssClass="ws_whitebox" onfocus="javascript:this.select();" onChange="ChangeTarget(this);"
                                                                                onkeydown="javascript:if(event.keyCode==13){return event.keyCode=9;}" />
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    
                                                                    
                                                                    
                                                                    
                                                                    <asp:BoundField DataField="ExistingCustPricePct" DataFormatString="{0:N2}" HeaderStyle-HorizontalAlign="Center"
                                                                        HeaderText="Existing" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-HorizontalAlign="right"
                                                                        ItemStyle-Width="60px" SortExpression="ExistingCustPricePct" />

                                                                    <asp:TemplateField ItemStyle-Width="70px" HeaderText="Approved" HeaderStyle-HorizontalAlign="Center"
                                                                        ItemStyle-HorizontalAlign="center" SortExpression="Approved">
                                                                        <ItemTemplate>
                                                                            <asp:CheckBox ID="ApprovedCheckBox" runat="server" onClick="ChangeApproved(this);"
                                                                                onkeydown="javascript:if(event.keyCode==13){return event.keyCode=9;}" />
                                                                            <asp:Label ID="ApprovedLabel" runat="server" Text='<%# Eval("Approved") %>' />
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    
                                                                    
                                                                    
                                                                    
                                                                    <asp:BoundField DataField="ContractGMPct" DataFormatString="{0:N2}" HeaderStyle-HorizontalAlign="Center"
                                                                        HeaderText="Cont. GM%" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-HorizontalAlign="right"
                                                                        ItemStyle-Width="70px" SortExpression="ContractGMPct" />
                                                                        
                                                                    <asp:BoundField DataField="ContractSales" HeaderText="3 Mo Sales (Cont. $)" ItemStyle-HorizontalAlign="right"
                                                                        DataFormatString="{0:c}" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="70px"
                                                                        SortExpression="ContractSales" HeaderStyle-HorizontalAlign="Center" />


                                                                  
                                                                    <asp:BoundField DataField="SalesHistoryEComm" HeaderText="3 Mo Sales (EComm)" ItemStyle-HorizontalAlign="right"
                                                                        DataFormatString="{0:c}" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="80px"
                                                                        SortExpression="SalesHistoryEComm" HeaderStyle-HorizontalAlign="Center" />
                                                                        
                                                                    <asp:BoundField DataField="GMPctPriceCostEComm" DataFormatString="{0:N2}" HeaderStyle-HorizontalAlign="Center"
                                                                        HeaderText="Mgn @ Price" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-HorizontalAlign="right"
                                                                        ItemStyle-Width="80px" SortExpression="GMPctPriceCostEComm" />

                                                                    <asp:BoundField DataField="GMPctAvgCostEComm" DataFormatString="{0:N2}" HeaderStyle-HorizontalAlign="Center"
                                                                        HeaderText="Mgn @ Avg" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-HorizontalAlign="right"
                                                                        ItemStyle-Width="80px" SortExpression="GMPctAvgCostEComm" />

                                                                    <asp:BoundField DataField="SalesHistory12Mo" HeaderText="12 Mo Sales" ItemStyle-HorizontalAlign="right"
                                                                        DataFormatString="{0:c}" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="80px"
                                                                        SortExpression="SalesHistory12Mo" HeaderStyle-HorizontalAlign="Center" />

                                                                    <asp:BoundField DataField="GMPctPriceCost12Mo" DataFormatString="{0:N2}" HeaderStyle-HorizontalAlign="Center"
                                                                        HeaderText="Mgn @ Price" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-HorizontalAlign="right"
                                                                        ItemStyle-Width="80px" SortExpression="GMPctPriceCost12Mo" />

                                                                    <asp:BoundField DataField="GMPctAvgCost12Mo" DataFormatString="{0:N2}" HeaderStyle-HorizontalAlign="Center"
                                                                        HeaderText="Mgn @ Avg" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-HorizontalAlign="right"
                                                                        ItemStyle-Width="80px" SortExpression="GMPctAvgCost12Mo" />

                                                                    <asp:BoundField DataField="pUnprocessedCategoryPriceID" HeaderText="ID" ItemStyle-CssClass="NoShow"
                                                                        HeaderStyle-CssClass="NoShow" />
                                                                </Columns>
                                                            </asp:GridView>
                                                            
                                                            
                                                    <div id="divToolTip" oncontextmenu="Javascript:return false;" class="MarkItUp_ContextMenu_MenuTable"
                                                    style="display: none; word-break: keep-all;" onmousedown="HideToolTip(this.id)">
                                                    <table width="290" border="0" cellpadding="0" cellspacing="0" bordercolor="#000099"
                                                        class="MarkItUp_ContextMenu_Outline">
                                                        <tr>
                                                            <td class="bgmsgboxtile">
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td width="90%" class="txtBlue">
                                                                            <b>Customer Item Price Schedule Maintenance</b></td>
                                                                        <td width="10%" align="center" valign="middle">
                                                                            <div align="right">
                                                                                <span class="bgmsgboxtile1">
                                                                                    <img src="../Common/Images/closeicon.gif" id="imgDivClose" style="cursor: hand;"
                                                                                        onmousedown="HideToolTip(this.id)" alt="Close"></span></div>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <table width="100%" border="0" cellspacing="2" >
                                                                    <tr onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onclick="ShowOrdHeader();"
                                                                        onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'">
                                                                        <td width="10%" valign="middle">
                                                                            <img src="../Common/Images/email.gif" /></td>
                                                                        <td width="90%" valign="middle">
                                                                            <div id="divCAS" style="vertical-align: middle;"
                                                                                onclick="ShowAddNewItemScreen();">
                                                                                Add New Item Price</div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onclick="ShowOrdCustomer();"
                                                                        onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'" class="MarkItUp_ContextMenu_MenuItem">
                                                                        <td width="10%" valign="middle">
                                                                            <img src="../Common/Images/email.gif" /></td>
                                                                        <td width="90%" valign="middle">
                                                                            <div id="divReport" style="vertical-align: middle;" onclick="ShowItemsByCategory();">
                                                                                See All Items in this Category</div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onclick="ShowOrdCustomer();"
                                                                        onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'" class="MarkItUp_ContextMenu_MenuItem">
                                                                        <td width="10%" valign="middle">
                                                                            <img src="../Common/Images/email.gif" /></td>
                                                                        <td width="90%" valign="middle">
                                                                            <div id="div1" style="vertical-align: middle;" onclick="ShowItemsByCustomer();">
                                                                                See All Items in this Customer</div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onclick="ShowOrdCustomer();"
                                                                        onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'" class="MarkItUp_ContextMenu_MenuItem">
                                                                        <td width="10%" valign="middle">
                                                                            <img src="../Common/Images/email.gif" /></td>
                                                                        <td width="90%" valign="middle">
                                                                            <div id="div2" style="vertical-align: middle;" onclick="ShowLLLContracts();">
                                                                                See LLL Contract Items for this Category</div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onclick="ShowOrdCustomer();"
                                                                        onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'" class="MarkItUp_ContextMenu_MenuItem">
                                                                        <td width="10%" valign="middle">
                                                                            <img src="../Common/Images/email.gif" /></td>
                                                                        <td width="90%" valign="middle">
                                                                            <div id="div3" style="vertical-align: middle;" onclick="ShowPriceAnalysisForCategory();">
                                                                                See Price Analysis for this Category</div>
                                                                        </td>
                                                                    </tr>                                                                    
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                        </div>
                                                        <asp:HiddenField ID="CPSMRecTypeHidden" runat="server" />
                                                        <asp:HiddenField ID="ApprovalOKHidden" runat="server" />
                                                         <asp:HiddenField ID="hidShowCostBasis" runat="server" />
                                                         <asp:HiddenField ID="hidPriceAnalysis" runat="server" />
                                                        <asp:HiddenField ID="hidRowFilter" runat="server" />
                                                        <input type="hidden" id="hidSort" runat="server" />
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="BluBg">
                                <table width="100%" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td align="left">
                                            &nbsp;&nbsp;&nbsp;
                                            <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>&nbsp;
                                                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen" Font-Bold="true"></asp:Label>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                                <uc2:Footer2 id="PageFooter2"  Title="Category Price Schedules Maintenance" runat="server">
                                </uc2:Footer2>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </form>
</body>
</html>
