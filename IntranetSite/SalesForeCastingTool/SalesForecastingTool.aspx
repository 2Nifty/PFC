<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesForecastingTool.aspx.cs"
    Inherits="SalesForeCasting" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Sales Forecasting</title>
    <link href="../SalesForeCastingTool/Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />
    <link href="../SalesForeCastingTool/Common/StyleSheet/Styles.css" rel="stylesheet"
        type="text/css" />
    <link href="../SalesForeCastingTool/Common/StyleSheet/FreezeGrid.css" rel="stylesheet"
        type="text/css" />

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>
    <style>
        .border
        {
            border-right:solid 1px #DAEEEF;
        }
        .diffPadding {padding-right:10px}
        .rightsplit {border-right:1px solid #cccccc;}
        .FormCtrl 
        {
            font-family: Arial, Helvetica, sans-serif;	
            font-size: 11px;	
            font-weight: normal;	
            color: #3A3A56;	
        }
    </style>

    <script >
        //Javascript function to Show the preview page
        function PrintReport()
        {
            var url = "SalesForecastingPreview.aspx?CustNumber="+'<%=Request.QueryString["CustNumber"] %>' +"&Branch=" + '<%=Request.QueryString["Branch"] %>'+ "&OrderType=" + '<%=Request.QueryString["OrderType"] %>';
            window.open(url,'','height=700,width=1000,scrollbars=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (930/2))+',resizable=no','');
        }
                
        function BindValue(sortExpression)
        {
           
            if(document.getElementById("hidSortExpression") !=null)
                document.getElementById("hidSortExpression").value= sortExpression;
                              
            document.getElementById("btnSort").click();
        }
        function clickButton(e, buttonid)
        {   
            if(document.getElementById("hidAnnuTot").value != document.getElementById("AddAnnualTotal").value)
            {
              var bt = document.getElementById(buttonid); 
              if (bt!=null)
              { 
                    if(navigator.appName.indexOf("Netscape")>(-1))
                    {
                        var evObj = document.createEvent('MouseEvents');
                        evObj.initEvent( 'click', true, true );
                        bt.dispatchEvent(evObj);
                        return false;                  
                    }          

                    if (navigator.appName.indexOf("Microsoft Internet Explorer")>(-1))
                    {
                        bt.click(); 
                        return false; 
                    } 
              } 
              }
        }
    </script>
</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';" onkeypress="if(document.getElementById('divdatagrid')){document.getElementById('hidScrollTop').value =document.getElementById('divdatagrid').scrollTop;}" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <div class="page">
            <table id="master" class="GreyBorderAll" width="100%" style="width: 100%; border-collapse: collapse;
                page-break-after: always;">
                <tr>
                    <td id="tdHeader">
                        <uc1:Header ID="Header1" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="PageBorder"
                            style="border-collapse: collapse;">
                            <tr>
                                <td colspan="2" class="PageHead" style="padding-left: 0px;">
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td style="padding-left: 10px; width: 84%; height: 28px;">
                                                <asp:Label ID="lblHeaderBranch" runat="server" CssClass="BannerText"></asp:Label></td>
                                            <td style="height: 28px; width: 74px;" colspan="1" rowspan="">
                                                <img onclick="javascript:PrintReport();" src="../SalesForeCastingTool/Common/images/Print.gif"
                                                    style="cursor: hand" /></td>
                                            <td style="height: 28px;" align="left">
                                                <img src="../SalesForeCastingTool/Common/images/close.gif" onclick="Javascript:window.close();"
                                                    style="cursor: hand" /></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" bgcolor="white">
                                    <asp:DataGrid ID="dgCas" runat="server" BorderWidth="0" BorderColor="#c9c6c6" Width="650"
                                        PageSize="1" AllowPaging="true" ShowHeader="false" PagerStyle-Visible="false"
                                        AutoGenerateColumns="false">
                                        <Columns>
                                            <asp:TemplateColumn>
                                                <ItemTemplate>
                                                    <table width="100%" cellpadding="0" cellspacing="0" style="padding-left: 10px">
                                                        <tr>
                                                            <td width="30%" valign="top">
                                                                <div align="left" style="height: 54px">
                                                                    <strong>Customer # 
                                                                        <%#DataBinder.Eval(Container.DataItem, "CustNo")%>
                                                                    </strong>
                                                                    <br>
                                                                    Chain Name:
                                                                    <%#DataBinder.Eval(Container.DataItem, "Chain")%>
                                                                    <br>
                                                                    Cust Type:
                                                                    <%#DataBinder.Eval(Container.DataItem, "CustType")%>
                                                                </div>
                                                                <br />
                                                                <div align="left">
                                                                    <strong>
                                                                        <%#DataBinder.Eval(Container.DataItem,"CustName") %>
                                                                    </strong>
                                                                    <br>
                                                                    <%#DataBinder.Eval(Container.DataItem,"CustAddress") %>
                                                                    <br>
                                                                    <%#DataBinder.Eval(Container.DataItem,"CustCity") %>
                                                                    ,
                                                                    <%#DataBinder.Eval(Container.DataItem,"CustState") %>
                                                                    <%#DataBinder.Eval(Container.DataItem,"CustZip") %>
                                                                    <br>
                                                                    Ph:
                                                                    <%#DataBinder.Eval(Container.DataItem,"CustPhone") %>
                                                                    <br>
                                                                    Fx:
                                                                    <%#DataBinder.Eval(Container.DataItem,"CustFax") %>
                                                                    <br>
                                                                </div>
                                                            </td>
                                                            <td width="38%" rowspan="2" valign="top">
                                                                <table width="100%" height="140" cellpadding="0" cellspacing="0" class="cntt">
                                                                    <tr>
                                                                        <td>
                                                                            <strong>Customer Profile</strong></td>
                                                                        <td>
                                                                            <strong>
                                                                                <%#DataBinder.Eval(Container.DataItem, "CustProfile").ToString().ToUpper()%>
                                                                            </strong>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 19px">
                                                                            Sales $ Ranking
                                                                        </td>
                                                                        <td style="height: 19px">
                                                                            <%#DataBinder.Eval(Container.DataItem, "SalesDollarVolume")%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            Margin $ Ranking
                                                                        </td>
                                                                        <td>
                                                                            <%#DataBinder.Eval(Container.DataItem, "MarginDollars")%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            Margin %
                                                                        </td>
                                                                        <td>
                                                                            <%# DataBinder.Eval(Container.DataItem, "MarginPercent")%>
                                                                            %&nbsp;/&nbsp;<%# DataBinder.Eval(Container.DataItem, "MarginPctCorpAvg")%>%
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            Price per LB
                                                                        </td>
                                                                        <td>
                                                                            <%#DataBinder.Eval(Container.DataItem, "PricePerLB")%>
                                                                            &nbsp;/&nbsp;<%#DataBinder.Eval(Container.DataItem, "PricePerLBCorpAvg")%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            Order $ per SO
                                                                        </td>
                                                                        <td>
                                                                            <%#DataBinder.Eval(Container.DataItem, "OrderDollarPerSO")%>
                                                                            &nbsp;/&nbsp;<%#DataBinder.Eval(Container.DataItem, "OrdDolPerSoCorpAvg")%></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            Order $ per SO Line
                                                                        </td>
                                                                        <td>
                                                                            <%#DataBinder.Eval(Container.DataItem, "OrderDollarPerSOLine")%>
                                                                            &nbsp;/&nbsp;<%#DataBinder.Eval(Container.DataItem, "OrdDolPerSOLineCorpAvg")%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            Rebate %
                                                                        </td>
                                                                        <td>
                                                                            <%#DataBinder.Eval(Container.DataItem, "RebatePct", "{0:0.0#}")%>
                                                                            /C
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td width="32%" rowspan="2" valign="top">
                                                                <table cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td>
                                                                            <strong>Sales Brn:
                                                                                <%#DataBinder.Eval(Container.DataItem,"BranchDesc") %>
                                                                            </strong>
                                                                            <br>
                                                                            Inside Sales:
                                                                            <%#DataBinder.Eval(Container.DataItem,"InsideSls") %>
                                                                            <br>
                                                                            Sales Rep:
                                                                            <%#DataBinder.Eval(Container.DataItem,"SalesRep") %>
                                                                            <br>
                                                                            Buying Grp:
                                                                            <%#DataBinder.Eval(Container.DataItem,"BuyGrp") %>
                                                                            <br>
                                                                            Key Cust:
                                                                            <%#DataBinder.Eval(Container.DataItem, "KeyCustRebate")%>
                                                                            <br>
                                                                            Annual:
                                                                            <%#DataBinder.Eval(Container.DataItem, "AnnualRebate")%>
                                                                            <br>
                                                                            Commission Rep:
                                                                            <%#DataBinder.Eval(Container.DataItem,"SalesPerson") %>
                                                                            <br>
                                                                            Hub:
                                                                            <%#DataBinder.Eval(Container.DataItem,"HubSatellites") %>
                                                                            <br>
                                                                            Terms:
                                                                            <%#DataBinder.Eval(Container.DataItem,"Terms") %>
                                                                            <br>
                                                                            <%-- DSO: <%#DataBinder.Eval(Container.DataItem,"DSO") %>&nbsp;Days<br>--%>
                                                                            Credit Limit:
                                                                            <%#DataBinder.Eval(Container.DataItem, "CreditLimit")%>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                </ItemTemplate>
                                                <ItemStyle VerticalAlign="Top" />
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <PagerStyle Visible="False" />
                                    </asp:DataGrid>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td valign="top">
                                    <asp:UpdatePanel ID="pnldgrid" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                        <ContentTemplate>
                                            <table id="tblHeader" runat="server" cellpadding="0" border='0' class="GreyBorderAll"
                                                bgcolor='#dff3f9' cellspacing="0">
                                                <tr>
                                                    <td class="rightsplit"  style="width:172px">
                                                       <table cellspacing="0" border="0px" width=100% cellpadding="0">
                                                            <tr>
                                                                <td height="21px" >
                                                                    &nbsp; 
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="21px" >
                                                                    &nbsp; 
                                                                </td>
                                                            </tr>
                                                            <tr align="left">
                                                                <td class="GridHead" width="170px" height="21px"  bgcolor="#ffffff">
                                                                     <asp:Label ID="lblTotal" runat="Server">TOTALS </asp:Label>
                                                                </td>
                                                            </tr>                                                            
                                                       </table>
                                                    </td>
                                                    <td class="GridHead rightsplit"  style="width:146px">
                                                        <table width="100%" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td align="center"  colspan="3" class="GridHead">
                                                                    Q1 
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="GridHead" width="63px" align="Center"><div style="cursor:hand;" onclick="javascript:BindValue('Q1ActualLbs');">Actual</div></td>
                                                                <td class="GridHead" width="20px"align="Center">Add<br />%</td>
                                                                <td class="GridHead"><div style="cursor:hand;" onclick="javascript:BindValue('Q1ForeCastLbs');">Forecast</div></td>
                                                            </tr>
                                                            <tr >
                                                                <td class="GridHead rightsplit" style="padding-right:1px"  bgcolor="#ffffff" align="right">
                                                                    <asp:Label ID="lblQ1ActualTotal" runat="Server"></asp:Label> <asp:HiddenField ID="hidQ1ActualTotal" runat="server" />
                                                                </td>
                                                                <td bgcolor="#ffffff" class="GridHead rightsplit" align="center">
                                                                    <asp:TextBox ID="Q1AddTotal" Style="text-align: right;" runat="Server"  CssClass="FormCtrl" Font-Bold=true MaxLength="6" Text="0.0"
                                                                    onkeypress="if ((window.event.keyCode < 45 || window.event.keyCode > 58) ||  window.event.keyCode == 47) window.event.keyCode = 0;"
                                                                    onkeydown="document.getElementById('hidHeaderTotPct').value=this.value;"
                                                                    Width="25" AutoPostBack="True" OnTextChanged="Q1AddTotal_TextChanged" CausesValidation="true"></asp:TextBox> 
                                                                    <asp:RegularExpressionValidator SetFocusOnError="true" Display=None ControlToValidate="Q1AddTotal" ValidationExpression="^[+-]?\d+(\.\d{1,10})?" ID="RegularExpressionValidator5" runat="server" ErrorMessage="Enter valid data"></asp:RegularExpressionValidator>                                                                     
                                                                </td>                                                            
                                                                <td bgcolor="#ffffff" class="GridHead" style="padding-right:3px"  align="right">
                                                                    <asp:Label ID="Q1ForecastTotal" runat="server"></asp:Label>                                                                    
                                                                </td>
                                                            </tr>
                                                       </table>
                                                    </td>
                                                    <td class="GridHead rightsplit"  style="width:146px">
                                                        <table width="100%"  cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td align="center" class="GridHead" colspan="3">
                                                                    Q2
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="GridHead" width="63px"  align="Center"><div style="cursor:hand;" onclick="javascript:BindValue('Q2ActualLbs');">Actual</div></td>
                                                                <td class="GridHead" width="20px"  align="Center">Add<br /> %</td>
                                                                <td class="GridHead"><div style="cursor:hand;" onclick="javascript:BindValue('Q2ForeCastLbs');">Forecast</div></td>
                                                            </tr>
                                                            <tr>
                                                                <td class="GridHead rightsplit" bgcolor="#ffffff" style="padding-right:1px" align="right">
                                                                    <asp:Label ID="lblQ2ActualTotal" runat="Server" ></asp:Label>
                                                                </td>
                                                                <td bgcolor="#ffffff" class="GridHead rightsplit" align="center">
                                                                    <asp:TextBox ID="Q2AddTotal" Style="text-align: right;" runat="Server"  CausesValidation="true" Font-Bold=true  CssClass="FormCtrl" MaxLength="6"
                                                                    onkeypress="if ((window.event.keyCode < 45 || window.event.keyCode > 58) ||  window.event.keyCode == 47) window.event.keyCode = 0;"
                                                                    onkeydown="document.getElementById('hidHeaderTotPct').value=this.value;"
                                                                    Width="25" AutoPostBack="True" OnTextChanged="Q2AddTotal_TextChanged"></asp:TextBox> 
                                                                    <asp:RegularExpressionValidator SetFocusOnError="true" Display=None ControlToValidate="Q2AddTotal" ValidationExpression="^[+-]?\d+(\.\d{1,10})?" ID="RegularExpressionValidator4" runat="server" ErrorMessage="Enter valid data"></asp:RegularExpressionValidator>                                                                     
                                                                </td>                                                            
                                                                <td bgcolor="#ffffff" class="GridHead"  style="padding-right:3px"  align="right">
                                                                    <asp:Label ID="Q2ForecastTotal" runat="server"></asp:Label>                                                                    
                                                                </td>                                                          
                                                            </tr>
                                                            
                                                       </table>                                                            
                                                    </td>
                                                    
                                                    <td class="GridHead rightsplit"  style="width:146px">
                                                        <table width="100%" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td align="center" class="GridHead" colspan="3">
                                                                    Q3 
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="GridHead" width="63px" align="Center"><div style="cursor:hand;" onclick="javascript:BindValue('Q3ActualLbs');">Actual</div></td>
                                                                <td class="GridHead" width="20px"align="Center">Add<br /> %</td>
                                                                <td class="GridHead"><div  style="cursor:hand;" onclick="javascript:BindValue('Q3ForeCastLbs');">Forecast</div></td>
                                                            </tr>
                                                            <tr>
                                                                <td class="GridHead rightsplit" bgcolor="#ffffff" style="padding-right:1px"  align="right">
                                                                    <asp:Label ID="lblQ3ActualTotal" runat="Server"></asp:Label>
                                                                </td>
                                                                <td bgcolor="#ffffff" class="GridHead rightsplit" align="center">
                                                                    <asp:TextBox ID="Q3AddTotal" Style="text-align: right;" runat="Server"  CausesValidation="true" Font-Bold=true  CssClass="FormCtrl" MaxLength="6"
                                                                    onkeypress="if ((window.event.keyCode < 45 || window.event.keyCode > 58) ||  window.event.keyCode == 47) window.event.keyCode = 0;"
                                                                    onkeydown="document.getElementById('hidHeaderTotPct').value=this.value;"
                                                                     Width="25" AutoPostBack="True" OnTextChanged="Q3AddTotal_TextChanged"></asp:TextBox>&nbsp;
                                                                    <asp:RegularExpressionValidator SetFocusOnError="true" Display=None ControlToValidate="Q3AddTotal" ValidationExpression="^[+-]?\d+(\.\d{1,10})?" ID="RegularExpressionValidator3" runat="server" ErrorMessage="Enter valid data"></asp:RegularExpressionValidator>                                                                                                                                 
                                                                </td>                                                            
                                                                <td bgcolor="#ffffff" class="GridHead"  style="padding-right:3px"  align="right">
                                                                    <asp:Label ID="Q3ForecastTotal" runat="server"></asp:Label>                                                                    
                                                                </td>                                                          
                                                            </tr>
                                                            
                                                       </table>
                                                    </td>    
                                                                                                                                                                                                            
                                                    <td class="GridHead rightsplit"  style="width:146px">
                                                        <table width="100%" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td align="center" class="GridHead" colspan="3">
                                                                    Q4 
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="GridHead" width="63px" align="Center"><div style="cursor:hand;" onclick="javascript:BindValue('Q4ActualLbs');">Actual</div></td>
                                                                <td class="GridHead" width="20px"align="Center">Add<br /> %</td>
                                                                <td class="GridHead"><div style="cursor:hand;" onclick="javascript:BindValue('Q4ForeCastLbs');">Forecast</div></td>
                                                            </tr> 
                                                            <tr>
                                                                <td class="GridHead rightsplit" bgcolor="#ffffff" style="padding-right:1px"  align="right">
                                                                    <asp:Label ID="lblQ4ActualTotal" runat="Server"></asp:Label>
                                                                </td>
                                                                <td bgcolor="#ffffff" class="GridHead rightsplit" align="center">
                                                                    <asp:TextBox ID="Q4AddTotal" Style="text-align: right;" runat="Server"  CausesValidation="true" Font-Bold=true CssClass="FormCtrl" MaxLength="6"
                                                                    onkeypress="if ((window.event.keyCode < 45 || window.event.keyCode > 58) ||  window.event.keyCode == 47) window.event.keyCode = 0;"
                                                                    onkeydown="document.getElementById('hidHeaderTotPct').value=this.value;" 
                                                                    Width="25" AutoPostBack="True" OnTextChanged="Q4AddTotal_TextChanged"></asp:TextBox>        
                                                                    <asp:RegularExpressionValidator SetFocusOnError="true" Display=None ControlToValidate="Q4AddTotal" ValidationExpression="^[+-]?\d+(\.\d{1,10})?" ID="RegularExpressionValidator2" runat="server" ErrorMessage="Enter valid data"></asp:RegularExpressionValidator>                                                                                                                            
                                                                </td>                                                            
                                                                <td bgcolor="#ffffff" class="GridHead"  style="padding-right:3px"  align="right">
                                                                    <asp:Label ID="Q4ForecastTotal" runat="server"></asp:Label>                                                                    
                                                                </td>                                                          
                                                            </tr>
                                                       </table>
                                                    </td>
                                                    
                                                    <td class="GridHead rightsplit"  style="width:161px">
                                                        <table width="100%" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td align="center" class="GridHead" colspan="3">
                                                                    &nbsp;&nbsp;&nbsp;Annual 
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="GridHead" width="73px" align="Center"><div style="cursor:hand;" onclick="javascript:BindValue('AnnualActualLbs');">Actual</div></td>
                                                                <td class="GridHead" width="25px"align="Center">Add<br /> %</td>
                                                                <td class="GridHead"><div style="cursor:hand;" onclick="javascript:BindValue('AnnualForeCastLbs');">Forecast</div></td>
                                                            </tr>   
                                                            <tr>
                                                                <td class="GridHead rightsplit" bgcolor="#ffffff" style="padding-right:1px"  align="right">
                                                                    <asp:Label ID="lblAnnualActualTotal" runat="Server"></asp:Label>
                                                                </td>
                                                                <td bgcolor="#ffffff" class="GridHead rightsplit" align="center">
                                                                    <asp:TextBox ID="AddAnnualTotal" Style="text-align: right;" runat="Server"  CausesValidation="true" Font-Bold=true CssClass="FormCtrl" MaxLength="6"
                                                                    onkeypress="if ((window.event.keyCode < 45 || window.event.keyCode > 58) ||  window.event.keyCode == 47) window.event.keyCode = 0; else if(window.event.keyCode ==13) clickButton(event,'btnAnnPctChg');"
                                                                    onkeydown="document.getElementById('hidHeaderTotPct').value=this.value;if(window.event.keyCode ==13) clickButton(event,'btnAnnPctChg');"
                                                                    Width="23" AutoPostBack="False" OnTextChanged="AddAnnualTotal_TextChanged" onblur="clickButton(event,'btnAnnPctChg');"></asp:TextBox>
                                                                    <asp:Button ID="btnAnnPctChg" runat="server" OnClick="btnAnnPctChg_Click" style="display:none;" />
                                                                    <asp:HiddenField ID="hidAnnuTot" runat=server />
                                                                    <asp:RegularExpressionValidator SetFocusOnError="true" Display=none ControlToValidate="AddAnnualTotal" ValidationExpression="^[+-]?\d+(\.\d{1,10})?" ID="RegularExpressionValidator1" runat="server" ErrorMessage="Enter valid data"></asp:RegularExpressionValidator>                                                                
                                                                </td>                                                            
                                                                <td bgcolor="#ffffff" class="GridHead" style="padding-right:3px"   align="right">
                                                                    <asp:Label ID="AnnualForecastTotal" runat="server"></asp:Label>                                                                    
                                                                </td>                                                          
                                                            </tr>
                                                       </table>
                                                    </td>                                                                                                    
                                                    <td class="GridHead"  style="width:61px">
                                                       <table cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td height="21px" >
                                                                    &nbsp; 
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td height="21px"  align="center">
                                                                    <asp:Label ID="lbl" runat="Server" ForeColor="#3A3A56"><div style="cursor:hand;" onclick="javascript:BindValue('PctDiff');">% Diff</div> </asp:Label> 
                                                                </td>
                                                            </tr>
                                                            <tr valign="bottom">
                                                                <td class="GridHead" width ="60px" height="21px"  bgcolor="#ffffff" align=right valign=middle style="padding-right:10px">
                                                                     <asp:Label ID="lblDiffTotal" ForeColor="#3A3A56" runat="server"></asp:Label> <asp:HiddenField ID="hidHeaderTotPct" runat="server" />
                                                                </td>
                                                            </tr>                                                            
                                                       </table>
                                                    </td>                                                  
                                                
                                                </tr>
                                              </table>
                                               
                                            <div class="Sbar" id="divdatagrid" runat="server" style="overflow-x: hidden; overflow-y: auto;
                                                position: relative; top: 0px; left: 0px; height: 355px; border: 0px solid;">
                                                <asp:DataGrid ID="dgBranchSummary"  BorderWidth="1" runat="server" AllowSorting="True"
                                                    AutoGenerateColumns="False" ShowFooter="false" BorderColor="#DAEEEF" AllowPaging="False"
                                                    PagerStyle-Visible="false" UseAccessibleHeader="true" OnPageIndexChanged="dgBranchSummary_PageIndexChanged"
                                                    ShowHeader="false" OnItemDataBound="dgBranchSummary_ItemDataBound">
                                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                                        HorizontalAlign="Center" />
                                                    <ItemStyle CssClass="Left5pxPadd GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                                        Height="20px" HorizontalAlign="Left" />
                                                    <AlternatingItemStyle CssClass="Left5pxPadd GridItem " BackColor="white" BorderColor="#CCCCCC"
                                                        HorizontalAlign="Left" />
                                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                                        HorizontalAlign="Center" />
                                                    <Columns>
                                                        <asp:BoundColumn DataField="CatGrpNo"   SortExpression="CatGrpNo" Visible="False" ></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText=" " DataField="CatGrpDesc" SortExpression="CatGrpDesc">
                                                            <ItemStyle HorizontalAlign="Left"  width="170px" Wrap="False"  />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn HeaderText="Actual" DataField="Q1ActualLbs" SortExpression="Q1ActualLbs"
                                                            DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                            <HeaderStyle Wrap="False" BorderWidth="0px" />
                                                        </asp:BoundColumn>
                                                        <asp:TemplateColumn HeaderText="Add %">
                                                            <ItemTemplate>
                                                                <div style="display:none">
                                                                    <asp:Label Text='<%# DataBinder.Eval(Container.DataItem, "CatGrpNo") %>' ID="hidCatNo" runat=server></asp:Label>
                                                                </div>
                                                                <asp:TextBox ID="txtQ1Perc" runat="server"  CausesValidation="true" Style="text-align: right;" CssClass="FormCtrl" MaxLength="6"
                                                                    onkeypress=" if ((window.event.keyCode < 45 || window.event.keyCode > 58) ||  window.event.keyCode == 47) window.event.keyCode = 0;" onblur="UpdateCategoryQuoterValue(this,1);" onkeydown='if (event.keyCode==13 || event.keyCode==9) {UpdateCategoryQuoterValue(this,1);event.keyCode=9; return event.keyCode }'
                                                                    Width="25" Text='<%#String.Format("{0:###0.0}", DataBinder.Eval(Container.DataItem, "Q1AddedPct"))%>' ></asp:TextBox>
                                                                    <asp:RegularExpressionValidator SetFocusOnError="true" Display=None ControlToValidate="txtQ1Perc" ValidationExpression="^[+-]?\d+(\.\d{1,10})?" ID="REVQ1" runat="server" ErrorMessage="Enter valid data"></asp:RegularExpressionValidator>  
                                                            </ItemTemplate>
                                                            <ItemStyle Width="25px" />
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="ForeCast">
                                                            <ItemTemplate>
                                                                <asp:TextBox Style="text-align: right;" CausesValidation="true" ID="txtQ1Forecast" runat="server" CssClass="FormCtrl" MaxLength="9"
                                                                    onkeypress="if ((window.event.keyCode < 45 || window.event.keyCode > 58) ||  window.event.keyCode == 47) window.event.keyCode = 0;"
                                                                    Width="45" Text='<%#String.Format("{0:#,##0}", DataBinder.Eval(Container.DataItem, "Q1ForeCastLbs"))%>' onblur="UpdateQuoterForecastValue(this,1);"  onkeydown='if (event.keyCode==13 || event.keyCode==9) {UpdateQuoterForecastValue(this,1);event.keyCode=9; return event.keyCode }' ></asp:TextBox>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn HeaderText="Actual" DataField="Q2ActualLbs" SortExpression="Q2ActualLbs"
                                                            DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:TemplateColumn HeaderText="Add %">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtQ2Perc"  CausesValidation="true" Style="text-align: right;" runat="server" CssClass="FormCtrl" MaxLength="6"
                                                                    onkeypress="if ((window.event.keyCode < 45 || window.event.keyCode > 58) ||  window.event.keyCode == 47) window.event.keyCode = 0;"
                                                                    Width="25" Text='<%#String.Format("{0:###0.0}", DataBinder.Eval(Container.DataItem, "Q2AddedPct"))%>' onblur="UpdateCategoryQuoterValue(this,2);" onkeydown='if (event.keyCode==13 || event.keyCode==9) {UpdateCategoryQuoterValue(this,2);event.keyCode=9; return event.keyCode }'></asp:TextBox>
                                                                    <asp:RegularExpressionValidator SetFocusOnError="true" Display=None ControlToValidate="txtQ2Perc" ValidationExpression="^[+-]?\d+(\.\d{1,10})?" ID="REVQ2" runat="server" ErrorMessage="Enter valid data"></asp:RegularExpressionValidator>  
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="ForeCast">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtQ2Forecast"  CausesValidation="true" Style="text-align: right;" runat="server" CssClass="FormCtrl" MaxLength="9"
                                                                    onkeypress="if ((window.event.keyCode < 45 || window.event.keyCode > 58) ||  window.event.keyCode == 47) window.event.keyCode = 0;"
                                                                    Width="45" Text='<%#String.Format("{0:#,##0}", DataBinder.Eval(Container.DataItem, "Q2ForeCastLbs"))%>' onblur="UpdateQuoterForecastValue(this,2);" onkeydown='if (event.keyCode==13 || event.keyCode==9) {UpdateQuoterForecastValue(this,2);event.keyCode=9; return event.keyCode }'></asp:TextBox>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn HeaderText="Actual" DataField="Q3ActualLbs" SortExpression="Q3ActualLbs"
                                                            DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                                        </asp:BoundColumn>
                                                        <asp:TemplateColumn HeaderText="Add %">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtQ3Perc"  CausesValidation="true" Style="text-align: right;" runat="server" CssClass="FormCtrl" MaxLength="9"
                                                                    onkeypress="if ((window.event.keyCode < 45 || window.event.keyCode > 58) ||  window.event.keyCode == 47) window.event.keyCode = 0;"
                                                                    Width="25" Text='<%#String.Format("{0:###0.0}", DataBinder.Eval(Container.DataItem, "Q3AddedPct"))%>' onblur="UpdateCategoryQuoterValue(this,3);"  onkeydown='if (event.keyCode==13 || event.keyCode==9) {UpdateCategoryQuoterValue(this,3);event.keyCode=9; return event.keyCode }'></asp:TextBox>
                                                                    <asp:RegularExpressionValidator SetFocusOnError="true" Display=None ControlToValidate="txtQ3Perc" ValidationExpression="^(\-)?\d+(\.\d{1,10})?" ID="REVQ3" runat="server" ErrorMessage="Enter valid data"></asp:RegularExpressionValidator>  
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="ForeCast">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtQ3Forecast" CausesValidation="true" Style="text-align: right;" runat="server" CssClass="FormCtrl" MaxLength="9"
                                                                    onkeypress="if ((window.event.keyCode < 45 || window.event.keyCode > 58) ||  window.event.keyCode == 47) window.event.keyCode = 0;"
                                                                    Width="45" Text='<%#String.Format("{0:#,##0}",DataBinder.Eval(Container.DataItem, "Q3ForeCastLbs"))%>'  onblur="UpdateQuoterForecastValue(this,3);" onkeydown='if (event.keyCode==13 || event.keyCode==9) {UpdateQuoterForecastValue(this,3);event.keyCode=9; return event.keyCode }'></asp:TextBox>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn HeaderText="Actual" DataField="Q4ActualLbs" SortExpression="Q4ActualLbs"
                                                            DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="60px" Wrap="False" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:TemplateColumn HeaderText="Add %">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtQ4Perc"  CausesValidation="true" Style="text-align: right;" runat="server" CssClass="FormCtrl" MaxLength="6"
                                                                    onkeypress="if ((window.event.keyCode < 45 || window.event.keyCode > 58) ||  window.event.keyCode == 47) window.event.keyCode = 0;"
                                                                    Width="25" Text='<%#String.Format("{0:###0.0}", DataBinder.Eval(Container.DataItem, "Q4AddedPct"))%>' onblur="UpdateCategoryQuoterValue(this,4);"  onkeydown='if (event.keyCode==13 || event.keyCode==9) {UpdateCategoryQuoterValue(this,4);event.keyCode=9; return event.keyCode }'></asp:TextBox>
                                                                    <asp:RegularExpressionValidator SetFocusOnError="true" Display=None ControlToValidate="txtQ4Perc" ValidationExpression="^[+-]?\d+(\.\d{1,10})?" ID="REVQ4" runat="server" ErrorMessage="Enter valid data"></asp:RegularExpressionValidator>  
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="ForeCast">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtQ4Forecast" CausesValidation="true" Style="text-align: right;" runat="server" CssClass="FormCtrl" MaxLength="9"
                                                                    onkeypress="if ((window.event.keyCode < 45 || window.event.keyCode > 58) ||  window.event.keyCode == 47) window.event.keyCode = 0;"
                                                                    Width="45" Text='<%#String.Format("{0:#,##0}",  DataBinder.Eval(Container.DataItem, "Q4ForeCastLbs"))%>' onblur="UpdateQuoterForecastValue(this,4);" 
                                                                    onkeydown='if (event.keyCode==13 || event.keyCode==9) {UpdateQuoterForecastValue(this,4);event.keyCode=9; return event.keyCode }'></asp:TextBox>
                                                                    
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn HeaderText="Actual" DataField="AnnualActualLbs" SortExpression="AnnualActualLbs"
                                                            DataFormatString="{0:#,##0}">
                                                            <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                                            <FooterStyle HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:TemplateColumn HeaderText="Add %">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtAnnPerc"  CausesValidation="true" Style="text-align: right;" runat="server" CssClass="FormCtrl" MaxLength="6"
                                                                    onkeypress="if ((window.event.keyCode < 45 || window.event.keyCode > 58) ||  window.event.keyCode == 47) window.event.keyCode = 0;"
                                                                     Width="25"  Text='<%#String.Format("{0:###0.0}", DataBinder.Eval(Container.DataItem, "AnnualAddedPct"))%>' onblur="UpdateCategoryAnnualValue(this);" onkeydown='if (event.keyCode==13 || event.keyCode==9) {UpdateCategoryAnnualValue(this);event.keyCode=9; return event.keyCode }'></asp:TextBox>
                                                                    <asp:RegularExpressionValidator SetFocusOnError="true" Display=None ControlToValidate="txtAnnPerc" ValidationExpression="^[+-]?\d+(\.\d{1,10})?" ID="REVAnn" runat="server" ErrorMessage="Enter valid data"></asp:RegularExpressionValidator>  
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>                                                        
                                                        <asp:TemplateColumn HeaderText="ForeCast">
                                                            <ItemTemplate>
                                                                <asp:Label ID="dglblAnnualForecastlbs" style="text-align:right" Width=54px runat=server Text='<%#String.Format("{0:#,##0}", DataBinder.Eval(Container.DataItem, "AnnualForeCastLbs")) %>' ></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn> 
                                                        <asp:TemplateColumn HeaderText="% Diff">
                                                            <ItemTemplate>
                                                                <asp:Label ID="dglblPctDiff" style="text-align:right" Width=50px runat=server Text='<%#String.Format("{0:0.0}", DataBinder.Eval(Container.DataItem, "PctDiff")) %>' ></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>                                                                                                            
                                                    </Columns>
                                                    <PagerStyle Visible="False" />
                                                </asp:DataGrid>
                                            </div>                                                                                        
                                            <asp:HiddenField ID="hidSortExpression" runat="server" />
                                            <asp:HiddenField ID="hidScrollTop" Value="0" runat="server" />
                                            <asp:Button ID="btnSort" runat="server" Style="display: none;" Text="Sort" OnClick="btnSort_Click" />
                                            <input type="hidden" runat="server" id="hidSort" />
                                            <asp:HiddenField ID=hidFocus runat=server />
                                            
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" class="BluBg buttonBar">
                                    <table>
                                        <tr>
                                            <td>
                                                <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                                    <ContentTemplate>
                                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="Green" Font-Bold="True"
                                                            runat="server"></asp:Label>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                           </td>
                                            <td>
                                                <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="false">
                                                    <ProgressTemplate>
                                                        <span style="padding-left: 5px; font-weight: bold;">Forecasting pounds please wait...</span>
                                                    </ProgressTemplate>
                                                </asp:UpdateProgress>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table><asp:ValidationSummary Enabled=true ID="ValidationSummary1"  HeaderText="" DisplayMode=SingleParagraph ShowMessageBox=true runat="server"  ShowSummary=false  /> 
                        <uc2:Footer ID="Footer1" runat="server" Title="Sales Forecasting Tool: Customer Selector" />
                    </td>
                </tr>
            </table>
          
        </div>
    </form>
</body>
</html>
