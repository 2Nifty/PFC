<%@ Page Language="C#" AutoEventWireup="true" CodeFile="QuoteAnalysisReport.aspx.cs"
    Inherits="QuoteAnalysisReport" %>


<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager"  TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quote Analysis Report</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    
    
    <script type=text/javascript>
        var markerHTML = "<div style='margin-left:10px;display:inline;'> &raquo;</div>";
        var minWidth = 80;
        var dragingColumn = null;
        var startingX = 0;
        var currentX = 0;
       
        function getNewWidth () {
            var newWidth = minWidth;
            if (dragingColumn != null) {
                newWidth = parseInt (dragingColumn.parentNode.style.width);
                if (isNaN (newWidth)) {
                    newWidth = 0;
                }
                newWidth += currentX - startingX;
                if (newWidth < minWidth) {
                    newWidth = minWidth;
                }
            }
            return newWidth;
        }

        function columnMouseDown (event) {
            if (!event) {
                event = window.event;
            }
            if (dragingColumn != null) {
                ColumnGrabberMouseUp ();
            }
            startingX = event.clientX;
            currentX = startingX;
            dragingColumn = this;
            return true;
        }

        function columnMouseUp () {
            if (dragingColumn != null) {
                dragingColumn.parentNode.style.width = getNewWidth ();
                dragingColumn = null;
            }
			return true;
        }

        function columnMouseMove (event) {
            if (!event) {
                event = window.event;
            }
            if (dragingColumn != null) {
			    currentX = event.clientX;
                dragingColumn.parentNode.style.width = getNewWidth ();
                startingX = event.clientX;
                currentX = startingX;
			}
			return true;
        }

        function installTable (tableId,columnIds) {
        
            var columns = columnIds;
			var table = document.getElementById (tableId);
            // Test if there is such element in the document
            if (table != null) {
                // Test is this element a table
                if (table.nodeName.toUpperCase () == "TABLE") {
                    document.body.onmouseup = columnMouseUp;
                    document.body.onmousemove = columnMouseMove;
                        
                        var tableHead = table.childNodes[0];
                            fixMarkers(tableHead,columns,table);
                            table.style.tableLayout = "fixed";
                            // Once we have found THEAD element and updated it
                            // there is no need to go through rest of the table
                            i = table.childNodes.length;
                }                
            }
        }
		function fixMarkers(tableHead,columns,table)
		{
			var tableHeadNode = tableHead.childNodes[0];
			// Handles IE style THEAD with TR
			if (tableHeadNode.nodeName.toUpperCase () == "TR") {
				for (k = 0; k < tableHeadNode.childNodes.length; k++) {
					var column = tableHeadNode.childNodes[k];
					var recolumn = tableHeadNode.childNodes[3];
					var marker = document.createElement ("span");
					
					//var shrinkMarker = document.createElement ("span");
				   if (columns.indexOf("~"+column.childNodes[0].innerHTML+"~") != -1)
				   {
						//shrinkMarker.innerHTML = markerHTML;					
						//shrinkMarker.style.cursor = "move";
						//shrinkMarker.onmousedown = columnMouseDown;
						
						marker.innerHTML = markerHTML;
						marker.style.cursor = "move";
						marker.onmousedown = columnMouseDown;
						column.appendChild (marker);
					
						
						
						if (column.offsetWidth < minWidth) {
						recolumn.style.width= "150px";
							column.style.width = minWidth;
							
							
						}
						else {
						recolumn.style.width= "150px";
							column.style.width = column.offsetWidth;
							
						}
					}
				}
			}
			// Handles Mozilla style THEAD
			else if (tableHeadNode.nodeName.toUpperCase () == "TH") {
			for (k = 0; k < tableHeadNode.childNodes.length; k++) {
					
					var recolumn = tableHeadNode.childNodes[3];
					}
				var column = tableHeadNode;
				var marker = document.createElement ("span");
				marker.innerHTML = markerHTML;
				marker.style.cursor = "move";
				marker.onmousedown = columnMouseDown;
				column.appendChild (marker);
				if (column.offsetWidth < minWidth) {
				recolumn.style.width= "150px";
					column.style.width = minWidth;
					
				}
				else {
				recolumn.style.width= "150px";
					column.style.width = column.offsetWidth;
					
				}
			}
		}
    </script>
 
<script>

    //Javascript function to Show the preview page
    function PrintReport()
    {
        var url= "Sort="+document.getElementById("hidSort").value+"&Month=" + '<%= (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "" %>&Year=<%= (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : ""%>&CustomerNumber=<%= (Request.QueryString["CustomerNumber"] != null) ? Request.QueryString["CustomerNumber"].ToString().Trim() : ""%>&BranchNumber=<%= (Request.QueryString["BranchNumber"] != null) ? Request.QueryString["BranchNumber"].ToString().Trim() : ""%>&StartDate=<%= Request.QueryString["StartDate"].ToString()%>&EndDate=<%= Request.QueryString["EndDate"].ToString()%>&CustomerName=<%= Request.QueryString["CustomerName"].ToString()%>';
        var hwin=window.open('QuoteAnalysisPreview.aspx?'+url, '', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (1010/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
        hwin.focus();
    }
    // Javascript Function To Call Server Side Function Using Ajax
    function DeleteFiles(session)
    {
        var str=QuoteAnalysisReport.DeleteExcel('QuoteAnalysisReport'+session).value.toString();
        parent.window.close();
    }
       
    function ShowGridtooltip(tooltipId, parentId) 
    {   
        it = document.getElementById(tooltipId); 
    
        // need to fixate default size (MSIE problem) 
        img = document.getElementById(parentId); 
               
        it.style.top =  event.clientY - 130 + 'px'; 
        it.style.left = event.clientX+ 'px';
       
        // Show the tag in the position
        it.style.display = '';
      
        return false; 
    }
    
</script>     
</head>
<body>
    <form id="form1" runat="server">        
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="top" colspan="2">
                    <uc1:Header ID="Header1" runat="server" />
                    <div runat=server id="tesxt">
                    </div>
                </td>
            </tr>
            <tr>
                <td width="100%" valign="top" colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="PageHead" colspan="5" style="height: 40px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td class="Left5pxPadd BannerText" width="70%">
                                            Quote Analysis Report
                                        </td>
                                        <td align="right"  style="width: 30%;padding-right:5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td >
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif" ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td> 
                                                         <img style="cursor:hand" src="../common/images/Print.gif" id="btnPrint"  onclick="javascript:PrintReport();" /></td>
                                                    <td >
                                                        <img align="right" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
                                                            src="Common/Images/Buttons/Close.gif" style="cursor: hand;padding-right:2px;" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                         <tr id="trHead" class="PageBg" >
                            <td class="LeftPadding TabHead" style="width:110px">
                                Customer # :
                                <%=Request.QueryString["CustomerNumber"].ToString() %>
                            </td>
                             <td class="LeftPadding TabHead" style="width:300px">
                             Customer Name :
                                <%=Request.QueryString["CustomerName"].ToString() %>
                             </td>
                             <td class="TabHead">
                                &nbsp;
                            </td>
                            <td class="TabHead" style="width:130px">
                                Run By : <%= Session["UserName"].ToString() %>
                            </td>
                            <td class="TabHead" style="width:130px">
                                Run Date : <%=DateTime.Now.ToShortDateString()%>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>            
            <tr>
                <td>
                    <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                        top: 0px; left: 0px; width: 1010px; height: 500px; border: 0px solid;">
                        <div id="PrintDG2">
                            <asp:DataGrid  UseAccessibleHeader=true ID="dgQuoteAnalysis" Width="950" runat="server" GridLines="both" BorderWidth="1px" ShowFooter="true" AllowSorting="true"
                                AutoGenerateColumns="false" BorderColor="#DAEEEF" AllowPaging="true" PageSize="19" PagerStyle-Visible="false" OnItemDataBound="dgQuoteAnalysis_ItemDataBound" OnPageIndexChanged="dgQuoteAnalysis_PageIndexChanged" OnSortCommand="dgQuoteAnalysis_SortCommand">
                                <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                    HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridItem" BackColor="White" BorderColor="White"
                                    Height="20px" />
                                <AlternatingItemStyle CssClass="Left5pxPadd GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                    HorizontalAlign="Left" />
                                <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                    HorizontalAlign="Center" />
                                <Columns>                                    
                                    <asp:BoundColumn HeaderStyle-Width="80" HeaderText="Quote Method" FooterStyle-HorizontalAlign=Center
                                        DataField="QuoteMethod" SortExpression="QuoteMethod" ItemStyle-Wrap="false"
                                        ItemStyle-Width="100" HeaderStyle-Wrap="false"></asp:BoundColumn>                                    
                                    <asp:TemplateColumn HeaderText="Quotation Date">
                                        <ItemTemplate>
                                            <asp:Label Style="cursor:hand;" ID="lblQuoteDate" runat=server Text='<%# DataBinder.Eval(Container.DataItem,"QuotationDate")%>' Font-Underline=true></asp:Label>
                                            <div id="divToolTips" class="list" runat=server style="display: none; position: absolute;z-index:99;" onmouseup="return false;">
                                            <table border="0" cellpadding="0" cellspacing="0" style="z-index:99;">
                                                <tr>
                                                    <td colspan=2 style="z-index:99;">
                                                        <span class="boldText"><b>User Name: </b></span>
                                                        <asp:Label ID="lblUserName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ECommUserName")%>' Font-Bold="false"></asp:Label></td>                                                    
                                                </tr>
                                                <tr>
                                                    <td style="padding-right:10px;" style="z-index:99;">
                                                        <span class="boldText"><b> Phone: </b></span>
                                                        <asp:Label ID="lblPhone" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ECommPhoneNo")%>' Font-Bold="false"></asp:Label></td>
                                                    <td>
                                                        <span class="boldText" style="padding-left: 5px;z-index:99;"><b>IP: </b></span>
                                                        <asp:Label ID="lblIP" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ECommIPAddress")%>' Font-Bold="false"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </div>
                                        </ItemTemplate>    
                                        <HeaderStyle Width="70px" />                                    
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn HeaderStyle-Width="70" ItemStyle-HorizontalAlign="left" HeaderText="Expiry Date" FooterStyle-HorizontalAlign="left"
                                        DataField="ExpiryDate" DataFormatString="{0:MM/dd/yyyy}" SortExpression="ExpiryDate" ItemStyle-Wrap="false"
                                        ItemStyle-Width="70" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn ItemStyle-HorizontalAlign="left" HeaderText="User Item #" DataField="UserItemNo" SortExpression="UserItemNo" DataFormatString="{0:#,##0.00}" ItemStyle-Wrap="false" FooterStyle-HorizontalAlign="right"
                                        ItemStyle-Width="100px" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="left" HeaderText="PFC Item #" FooterStyle-HorizontalAlign="left"
                                        DataField="PFCItemNo" DataFormatString="{0:#,##0.00}" SortExpression="PFCItemNo" ItemStyle-Wrap="false"
                                        ItemStyle-Width="100" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="300" ItemStyle-HorizontalAlign="Left" HeaderText="Description" FooterStyle-HorizontalAlign="Left"
                                        DataField="Description" SortExpression="Description" ItemStyle-Wrap="false"
                                        ItemStyle-Width="300" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="Left" HeaderText="Sales Branch Of Record" FooterStyle-HorizontalAlign="Left"
                                        DataField="SalesBranchofRecord"  SortExpression="SalesBranchofRecord" ItemStyle-Wrap="true"
                                        ItemStyle-Width="80" HeaderStyle-Wrap="true"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="40" ItemStyle-HorizontalAlign="right" HeaderText="Req. Qty" FooterStyle-HorizontalAlign="right"
                                        DataField="RequestQuantity" DataFormatString="{0:#,##0}" SortExpression="RequestQuantity" ItemStyle-Wrap="false"
                                        ItemStyle-Width="40" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="40" ItemStyle-HorizontalAlign="right" HeaderText="Ava. Qty" FooterStyle-HorizontalAlign="right"
                                        DataField="RunningAvalQty" DataFormatString="{0:#,##0}" SortExpression="RunningAvalQty" ItemStyle-Wrap="false"
                                        ItemStyle-Width="40" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="40" ItemStyle-HorizontalAlign="right" HeaderText="Unit Price" FooterStyle-HorizontalAlign="right"
                                        DataField="UnitPrice" DataFormatString="{0:#,##0.00}" SortExpression="UnitPrice" ItemStyle-Wrap="false"
                                        ItemStyle-Width="40" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="40" ItemStyle-HorizontalAlign="right" HeaderText="Margin %" FooterStyle-HorizontalAlign="right"
                                        DataField="MarginPercentage" DataFormatString="{0:#,##0.0}" SortExpression="Margin" ItemStyle-Wrap="false"
                                        ItemStyle-Width="40" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="40" ItemStyle-HorizontalAlign="right" HeaderText="Average Cost" FooterStyle-HorizontalAlign="right"
                                        DataField="AvgCost" DataFormatString="{0:#,##0.00}" SortExpression="AvgCost" ItemStyle-Wrap="false"
                                        ItemStyle-Width="40" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="40" ItemStyle-HorizontalAlign="Left" HeaderText="Price UOM" FooterStyle-HorizontalAlign="Left"
                                        DataField="PriceUOM" DataFormatString="{0:#,##0.00}" SortExpression="PriceUOM" ItemStyle-Wrap="false"
                                        ItemStyle-Width="40" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="70" ItemStyle-HorizontalAlign="right" HeaderText="Total Price" FooterStyle-HorizontalAlign="right"
                                        DataField="TotalPrice" DataFormatString="{0:#,##0.00}" SortExpression="TotalPrice" ItemStyle-Wrap="false"
                                        ItemStyle-Width="70"  HeaderStyle-Wrap="false"></asp:BoundColumn>
                                    <asp:BoundColumn HeaderStyle-Width="70" ItemStyle-HorizontalAlign="right" HeaderText="Total Weight" FooterStyle-HorizontalAlign="right"
                                        DataField="GrossWeight" DataFormatString="{0:#,##0.00}" SortExpression="GrossWeight" ItemStyle-Wrap="false"
                                        ItemStyle-Width="70" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                </Columns>
                            </asp:DataGrid>                            
                            <center><asp:Label ID="lblStatus" runat="server" CssClass="redtitle"  Text="No Records Found"
                                    Visible="False"></asp:Label></center>                            
                        </div>
                    </div>                    
                    <uc3:pager ID="Pager1" runat="server" OnBubbleClick="Pager_PageChanged" />
                    </td>
            </tr>
            <tr>
                <td>
                    <uc2:BottomFrame ID="BottomFrame1" runat="server" />   
                    <asp:HiddenField ID="hidFileName" Value="" runat="server" />  
                    <input type="hidden" runat="server" id="hidSort" />    
                </td>
            </tr>
        </table>
    </form>
<script type="text/javascript" >installTable ("dgQuoteAnalysis","~User Item #~Description~");</script>
</body>
</html>
