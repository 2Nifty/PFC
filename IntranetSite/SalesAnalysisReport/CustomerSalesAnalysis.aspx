<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerSalesAnalysis.aspx.cs"
    Inherits="CustomerSalesAnalysis" %>

<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Sales Analysis Report</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <script language=javascript src="Javascript/ContextMenu.js"></script>
    <script language=javascript src="Javascript/Browsercompatibility.js"></script>
    <script> 
        var casURL='';
        var reportURL='';
        var hid='';
        
        // Javascript Function To Show The Preview Page
        function PrintReport()
        {
            var version=document.getElementById("hidVersion").value;
            var period=document.getElementById("hidReport").value;
            var url="version="+version+"&Month=" + '<%= (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "" %>' +
                      "&Year=" + '<%= (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "" %>' +
                      "&Branch=" + '<%= (Request.QueryString["Branch"] != null) ? Request.QueryString["Branch"].ToString().Trim() :"" %>' +
                      "&BranchName=" + '<%= (Request.QueryString["BranchName"] != null) ? Request.QueryString["BranchName"].ToString().Trim() :"" %>' +
                      "&Chain=" + '<%=(Request.QueryString["Chain"] != null) ? Request.QueryString["Chain"].ToString().Trim() : "" %>' +
                      "&CustNo=" +'<%=(Request.QueryString["CustNo"] != null) ? Request.QueryString["CustNo"].ToString().Trim() : "" %>'+
                      "&MonthName=" +'<%=(Request.QueryString["MonthName"] != null) ? Request.QueryString["MonthName"].ToString().Trim() : "" %>'+
                      "&SalesRep=" +'<%=(Request.QueryString["SalesRep"] != null) ? Request.QueryString["SalesRep"].ToString().Trim() : "" %>'+
                      "&ZipFrom=" +'<%=(Request.QueryString["ZipFrom"] != null) ? Request.QueryString["ZipFrom"].ToString().Trim() : "" %>'+
                      "&ZipTo=" +'<%=(Request.QueryString["ZipTo"] != null) ? Request.QueryString["ZipTo"].ToString().Trim() : "" %>'+
                      "&OrdType=" +'<%=(Request.QueryString["OrdType"] != null) ? Request.QueryString["OrdType"].ToString().Trim() : "" %>'+
                      "&period="+period;
           
            var a=window.screen.availWidth-60;
            window.open('CustomerSalesAnalysisPreview.aspx?'+url, '', 'height=760,width=1020,scrollbars=yes,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO',"");
        }

         // Javascript Function To Call Server Side Function Using Ajax
       function DeleteFiles(session)
       {
        
           var str=CustomerSalesAnalysis.DeleteExcel('CustomerSalesAnalysis'+session).value.toString();
           parent.window.close();
       }
       
      function ShowToolTip(event,strCASURL,strReportURL,ctlID)
      {
            if(event.button==2)
            {
                //divCAS.style.display=((ctlID.indexOf('CAS')!=-1)?'':'none');
                casURL=strCASURL;
                reportURL=strReportURL;
                xstooltip_show('divToolTip',ctlID,289, 49);
                return false;
            }
      }
      
      function ShowCAS()
      {
            window.open(casURL,"CustomerActivitySheet" ,'height=700,width=965,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (970/2))+',resizable=no',"");
            xstooltip_hide('divToolTip');
      }
      
      function ShowReport()
      {
            window.open(reportURL, 'popupwindow', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no');
            xstooltip_hide('divToolTip');
      }
      
      function Hide()
      {
            if(event.button!=2)
                if(hid!='true')
                    xstooltip_hide('divToolTip');
                else
                    hid='';
      }
      function SetVal(ctlID)
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
</head>
<body bottommargin="0" onmouseup="Hide();">
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" runat="server" id="BodyTable">
            <tr>
                <td colspan="2">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr>
                            <td colspan="2" valign="middle" class="PageHead">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                                    <tr>
                                        <td style="height: 10px" valign=middle><div align="left" class="LeftPadding">Customer Sales Analysis</div></td>
                                        <td class=TabHead valign=middle>
                                            <span class="TabHead" style="vertical-align:middle;"> Period Type :</span> 
                                              <asp:RadioButton ID="rdoDate1" style="vertical-align:middle;"  runat="server"   AutoPostBack=true Text="MTD " GroupName="rdoPeriod"  OnCheckedChanged="rdoDate1_CheckedChanged"/>
                                              <asp:RadioButton ID="rdoDate2" style="vertical-align:middle;" runat="server" AutoPostBack=true Text="YTD " GroupName="rdoPeriod" Checked=true OnCheckedChanged="rdoDate2_CheckedChanged"/>
                                              
                                        </td>
                                              
                                        <td class="TabHead" valign=middle>
                                            <span class="TabHead" style="vertical-align:middle;">Report Version :</span>
                                            <asp:RadioButton style="vertical-align:middle;" ID="rdoReportVersion1" GroupName=rdoReport runat="server"  AutoPostBack=true Checked=true Text="Long Version" OnCheckedChanged="rdoReportVersion1_CheckedChanged"/>
                                            <asp:RadioButton style="vertical-align:middle;" ID="rdoReportVersion2" AutoPostBack=true GroupName=rdoReport Text="Short Version" runat="server" OnCheckedChanged="rdoReportVersion2_CheckedChanged"/>
                                              
                                        </td>
                                              
                                        <td valign=middle>
                                            <a href='<%= GetFileURL() %>'><img  border=0 src="../common/images/ExporttoExcel.gif" /></a>
                                            <img style="cursor:hand" src=../common/images/print.gif   onclick="javascript:PrintReport();"     />
                                            <img style="cursor:hand" src="../common/images/close.gif" id="imgClose" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"/>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" class="PageBg">
                                <table width="100%" cellpadding="0" cellspacing="0" >
                                    <tr>
                                        <td height="15px" class="TabHead">
                                            <span>Period :
                                                <%=Request.QueryString["MonthName"].ToString() + " " + Request.QueryString["Year"].ToString()%>
                                            </span>
                                        </td>
                                        <td height="15px" class="TabHead">
                                            <span>Order Type :
                                                <%=((Request.QueryString["OrdType"] != "Non-Mill") ? Request.QueryString["OrdType"].ToString().Trim() : "Warehouse") %>
                                            </span>
                                        </td>
                                        <td class="TabHead">
                                            <span>Branch :
                                                <%=Request.QueryString["BranchName"].ToString() %>
                                            </span>
                                        </td>
                                        <td class="TabHead">
                                        <span >Sales Rep :
                                                <%=Request.QueryString["SalesRep"].ToString().Replace("|","'")%>
                                            </span>
                                        </td>
                                        <td class=TabHead ><span>Zip :
                    <%=(Request.QueryString["ZipFrom"] == "" && Request.QueryString["ZipTo"] == "") ? "All" : Request.QueryString["ZipFrom"].ToString() + " - " + Request.QueryString["ZipTo"].ToString()%>
                    </span></td>
                                        <td class="TabHead">
                                            <span>Chain :
                                                <%=(Request.QueryString["Chain"] != "") ? Request.QueryString["Chain"].ToString().Trim().Replace('`','&') : "All"%>
                                            </span>
                                        </td>
                                        <td class="TabHead">
                                            <span>Customer :
                                                <%=(Request.QueryString["CustNo"] != "") ? Request.QueryString["CustNo"].ToString().Trim() : "All"%>
                                            </span>
                                        </td>
                                        <td class="TabHead">
                                            <span >Fiscal Year
                                                <% if (Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) %>
                                                <%{ %>
                                                <%=Request.QueryString["Year"].ToString()%>
                                                Vs
                                                <%=Convert.ToInt16(Request.QueryString["Year"].ToString()) - 1%>
                                                <%}
                                                else
                                                {%>
                                                <%=Convert.ToInt16(Request.QueryString["Year"].ToString()) + 1%>
                                                        Vs
                                                <%=Request.QueryString["Year"].ToString()%>
                                                <%} %>
                                                  
                                                   
                                            </span>
                                        </td>
                                        <td align="left" class="TabHead">
                                        
                                        </td>
                                        <td align="Left" class="TabHead">
                                            </td>
                                    </tr>
                                    <tr>
                                        <td class="TabHead" height="15">
                                        <span >Run By : <%= Session["UserName"].ToString()%></span>
                                        </td>
                                        <td class="TabHead" height="15">
                                        <span>Run Date : <%=DateTime.Now.ToShortDateString()%></span>
                                        </td>
                                        <td class="TabHead">
                                        </td>
                                        <td class="TabHead">
                                        </td>
                                        <td class="TabHead">
                                        </td>
                                        <td class="TabHead">
                                        </td>
                                        <td class="TabHead">
                                        </td>
                                        <td class="TabHead">
                                        </td>
                                        <td align="left" class="TabHead">
                                        </td>
                                        <td align="left" class="TabHead">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" bgcolor="#EFF9FC" colspan="2">
                                <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                    Visible="False"></asp:Label></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0" >
                                    <tr>
                                        <td valign="top" width="100%" >
                                            <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px; left: 0px;
                                                width: 1000px; height: 458px; border: 0px solid;">
                                                <asp:DataGrid PageSize="20" ID="dgAnalysis" BackColor="#f4fbfd" AllowPaging="true" GridLines="Both" 
                                                    runat="server" Width="2100px" AutoGenerateColumns="false" PagerStyle-Visible="false"
                                                    OnItemDataBound="dgAnalysis_ItemDataBound" BorderWidth="1" AllowSorting="true"
                                                    OnSortCommand="dgAnalysis_SortCommand" >
                                                    <HeaderStyle HorizontalAlign="right" CssClass="GridHead" BackColor="#dff3f9" />
                                                    <ItemStyle CssClass="GridItem" BorderStyle=Solid Wrap=false BackColor="#f4fbfd" />
                                                    <FooterStyle HorizontalAlign="right" CssClass="GridHead" BackColor="#dff3f9" />
                                                    <AlternatingItemStyle CssClass="GridItem"  BackColor="#FFFFFF" />
                                                    <Columns>
                                                    <asp:BoundColumn HeaderText="Cust #" DataField="CustNo" SortExpression="CustNo" ItemStyle-Wrap=false HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CustName" DataField="CustName" SortExpression="CustName" ItemStyle-Wrap=false HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CustCity" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-Wrap=false ItemStyle-CssClass=GridItem DataField="CustCity" SortExpression="CustCity" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="SalesLoc" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="SalesLoc" SortExpression="SalesLoc" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn ItemStyle-Width=50px FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem HeaderText="Chain" DataField="Chain" SortExpression="Chain" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CMSales" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CMSales" DataFormatString="{0:#,##0}" SortExpression="CMSales" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMSales" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LMSales" DataFormatString="{0:#,##0}" SortExpression="LMSales" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CGM" FooterStyle-CssClass=GridHead    HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CGM" DataFormatString="{0:#,##0}" SortExpression="CGM"  ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CGMPct" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CGMPct" DataFormatString="{0:0.0}" SortExpression="CGMPct" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMGM" FooterStyle-CssClass=GridHead   HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LMGM" DataFormatString="{0:#,##0}" SortExpression="LMGM" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMGMPct" FooterStyle-CssClass=GridHead    HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LMGMPct"  DataFormatString="{0:0.0}"  SortExpression="LMGMPct" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CMWgt" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CMWgt" DataFormatString="{0:#,##0}" SortExpression="CMWgt" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CMDollarLb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CMDollarLb"  DataFormatString="{0:0.00}" SortExpression="CMDollarLb" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMWgt" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LMWgt" DataFormatString="{0:#,##0}" SortExpression="LMWgt" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LMDollarLb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LMDollarLb"  DataFormatString="{0:0.00}" SortExpression="LMDollarLb" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDSales" FooterStyle-CssClass=GridHead   HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="YTDSales" DataFormatString="{0:#,##0}" SortExpression="YTDSales" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDSales" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LYTDSales" DataFormatString="{0:#,##0}" SortExpression="LYTDSales" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDGM" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="YTDGM" DataFormatString="{0:#,##0}" SortExpression="YTDGM" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDGMPct" FooterStyle-CssClass=GridHead   HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="YTDGMPct"  DataFormatString="{0:0.0}" SortExpression="YTDGMPct" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                     <asp:BoundColumn HeaderText="YTDExp" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="YTDExp" DataFormatString="{0:#,##0}" SortExpression="YTDExp" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDNP" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="YTDNP" DataFormatString="{0:#,##0}" SortExpression="YTDNP" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="AccumNP" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="AccumNP" DataFormatString="{0:#,##0}" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDGM" FooterStyle-CssClass=GridHead     HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LYTDGM" DataFormatString="{0:#,##0}" SortExpression="LYTDGM" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDGMPct" FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LYTDGMPct" DataFormatString="{0:0.0}"  SortExpression="LYTDGMPct" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDExp" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LYTDExp" DataFormatString="{0:#,##0}" SortExpression="LYTDExp" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDNP" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LYTDNP" DataFormatString="{0:#,##0}" SortExpression="LYTDNP" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LAccumNP" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LAccumNP" DataFormatString="{0:#,##0}"  ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDWgt" FooterStyle-CssClass=GridHead     HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="YTDWgt" DataFormatString="{0:#,##0}" SortExpression="YTDWgt" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTDDollarLb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="YTDDollarLb" DataFormatString="{0:0.00}"  SortExpression="YTDDollarLb" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDWgt" FooterStyle-CssClass=GridHead     HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LYTDWgt" DataFormatString="{0:#,##0}" SortExpression="LYTDWgt" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="LYTDDollarLb" FooterStyle-CssClass=GridHead HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="LYTDDollarLb" DataFormatString="{0:0.00}"  SortExpression="LYTDDollarLb" ItemStyle-HorizontalAlign="Right" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CustRep" FooterStyle-CssClass=GridHead      HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CustRep" SortExpression="CustRep" ItemStyle-Wrap=false ItemStyle-HorizontalAlign=left></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="CustGroup" FooterStyle-CssClass=GridHead    HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CustGroup" SortExpression="CustGroup"  ItemStyle-Wrap=false ItemStyle-HorizontalAlign=left></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Zip" FooterStyle-CssClass=GridHead          HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CustZip" SortExpression="CustZip" ItemStyle-Wrap=false ItemStyle-HorizontalAlign=left HeaderStyle-HorizontalAlign=left></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="PFC Rep" FooterStyle-CssClass=GridHead          HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="PFCRep" SortExpression="PFCRep" ItemStyle-Wrap=false ItemStyle-HorizontalAlign=center HeaderStyle-HorizontalAlign=left></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="ABC" FooterStyle-CssClass=GridHead          HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="ABC" SortExpression="ABC" ItemStyle-Wrap=false ItemStyle-HorizontalAlign=left HeaderStyle-HorizontalAlign=left></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="YTD Budget $" FooterStyle-CssClass=GridHead          HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="YTDBudget" DataFormatString="{0:#,##0}" SortExpression="YTDBudget" ItemStyle-Wrap=false ItemStyle-HorizontalAlign=right HeaderStyle-HorizontalAlign=right></asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="Ind Type" FooterStyle-CssClass=GridHead     HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem DataField="CustType" SortExpression="CustType" ItemStyle-Wrap=false ItemStyle-HorizontalAlign=left HeaderStyle-HorizontalAlign=left></asp:BoundColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="BluBg">
                                <table width="100%" id="tblPager" runat="SERVER">
                                    <tr>
                                        <td>
                                            <uc1:pager ID="Pager1" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <input type=hidden runat=server id=hidSort/>
                    <asp:HiddenField ID="hidReport" runat="server" />
                    <asp:HiddenField ID="hidVersion" runat="server"/>
                    <div id="divToolTip" class=MarkItUp_ContextMenu_MenuTable style="display:none;word-break:keep-all;" onmousedown="SetVal(this.id)">
                        <table width="20%"  border="0" cellpadding=0 cellspacing=0 bordercolor=#000099 class="MarkItUp_ContextMenu_Outline">
                              <tr>
                                <td class="bgmsgboxtile">
                                    <table width="100%"  border="0" cellspacing="0" cellpadding=0>
                                      <tr>
                                        <td width="90%" class="txtBlue">Customer Analytics</td>
                                        <td width="10%" align="center" valign="middle"><div align="right"><span class="bgmsgboxtile1"><img src="Images/close.gif"  id=imgDivClose style="cursor:hand;" onmousedown="SetVal(this.id)" alt="Close"></span></div></td>
                                      </tr>
                                      
                                    </table>
                                </td>
                              </tr>
                              <tr>
                                <td class="bgtxtbox">
                                    <table width=100% border=0 cellspacing=0>
                                        <tr onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onclick="ShowCAS();" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'" class=MarkItUp_ContextMenu_MenuItem>
                                            <td width=10%  valign=middle><img src= "Images/customerservice.gif" /></td>
                                            <td width=90% valign=middle>
                                                <div id=divCAS  style="vertical-align:middle;" class=MarkItUp_ContextMenu_MenuItem onclick="ShowCAS();">Customer Activity Sheet</div>
                                            </td>
                                        </tr>
                                        <tr onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onclick="ShowReport();" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'" class=MarkItUp_ContextMenu_MenuItem>
                                            <td width=10% valign=middle><img src= "Images/email.gif" /></td>
                                            <td width=90% valign=middle>
                                                <div id=divReport class=MarkItUp_ContextMenu_MenuItem style="vertical-align:middle;" onclick="ShowReport();">Item Sales Analysis Report</div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                              </tr>
                        </table>
                        <%--<table width=200px border=0 cellpadding=0 cellspacing=2 bordercolor=#000099 class="MarkItUp_ContextMenu_Outline">
                            <tr>
                                <td valign=middle align=right>
                                    <div id=div1 align=right onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'" class=MarkItUp_ContextMenu_MenuItem ><img src= "Images/delete.jpg" onclick="divToolTip.style.display='none';" alt="Close" /></div>
                                </td>
                            </tr>
                            <tr>
                                <td valign=middle>
                                    <div id=divCAS onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'" class=MarkItUp_ContextMenu_MenuItem   onclick="ShowCAS();"><img src= "Images/customerservice.gif" />&nbsp;Customer Activity Sheet</div>
                                </td>
                            </tr>
                            <tr>
                                <td valign=middle>
                                    <div id=divReport onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'" class=MarkItUp_ContextMenu_MenuItem  onclick="ShowReport();"><img src= "Images/email.gif" />&nbsp;Item Sales Analysis Report</div>
                                </td>
                            </tr>
                        </table>--%>
                    </div>
                </td>
            </tr>
        </table>
    </form>
    <script language="javascript">
    window.parent.document.getElementById("Progress").style.display='none';</script>
</body>
</html>
