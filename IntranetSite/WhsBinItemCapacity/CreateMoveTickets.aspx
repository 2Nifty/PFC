<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CreateMoveTickets.aspx.cs"
	Inherits="CreateMoveTickets" %>

<%@ Register Src="~/Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/FooterImage.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title>Move Forward</title>
	<link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

	<script language="javascript">
    <!--
		var HeaderRatio = 0.4;
		var DetailRatio = 0.6;
		function SetFileName(filename)
		{
			document.getElementById("SingleFileName").innerText = filename;
			//alert(filename);
		}  
		function ShowPrinter(ctl)
		{
			//alert(ctl.checked);
			var printerCell = document.getElementById("ddlPrinterName");
			if (ctl.checked)
			{
				printerCell.disabled = false;
			}
			else
			{
				printerCell.disabled = true;
			}
		}  
			function PreviewReport(Ticket)
			{
				//alert(url); 
				var hwin= window.open("MoveTicketExport.aspx?TicketNo="+Ticket,"MoveTicketExport" ,'scrollbars=no,status=no,resizable=YES',"");
				hwin.focus();
			}
		
    
    -->
	</script>

</head>
<body>
	<form id="MainForm" runat="server">
		<asp:ScriptManager ID="ScriptManager1" runat="server" />
		<div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2" style="height: 25px;">
						<uc1:Header ID="Header1" runat="server" />
					</td>
				</tr>
			</table>
			<asp:UpdatePanel ID="updCommandPanel" runat="server" UpdateMode="Conditional">
				<ContentTemplate>
					<asp:Panel ID="pnlCommand" runat="server">
					<table cellpadding="0" cellspacing="0" width="100%" style="height: 60px;">
						<tr>
							<td class="shadeBgDown rightBorder" valign="top">
								<span class="redtitle2">Load Facing Bin Data File</span><br />
								<center>
									<asp:ImageButton ID="btnLoadExcel" runat="server" ImageUrl="../Common/Images/ok.gif"
										OnClick="btnLoadExcel_Click" /></center>
							</td>
							<td class="shadeBgDown rightBorder" valign="top">
								<span class="redtitle2">View Current Excel Data</span><br />
								<center>
									<asp:ImageButton ID="btnShowExcel" runat="server" ImageUrl="../Common/Images/ok.gif"
										OnClick="btnShowExcel_Click" /></center>
							</td>
							<td class="shadeBgDown rightBorder" valign="top">
								<span class="redtitle2">Create Move Tickets</span><br />
								<center>
									<asp:ImageButton ID="btnCreateTickets" runat="server" ImageUrl="../Common/Images/ok.gif"
										OnClick="btnCreateTickets_Click" />
								</center>
							</td>
							<td class="shadeBgDown rightBorder" valign="top">
								<span class="redtitle2">Review/Print Move Tickets</span><br />
								<center>
									<asp:ImageButton ID="btnReview" runat="server" ImageUrl="../Common/Images/ok.gif"
										OnClick="btnReview_Click" />
								</center>
							</td>
							<td align="right" class="shadeBgDown">
								<asp:ImageButton ID="CloseButton" runat="server" ImageUrl="../common/Images/close.gif"
									PostBackUrl="javascript:window.close();" CausesValidation="false" />
								&nbsp; &nbsp;
								<asp:HiddenField ID="hidSecurityGroup" runat="server" />
							</td>
						</tr>
						<tr>
						<td colspan="5" class="shadeBgDown rightBorder" valign="top">
								<span class="LeftPadding">File Processed:
									<asp:Label ID="FileProcessed" runat="server"></asp:Label></span>
						</td>
						</tr>
					</table>
					</asp:Panel>
				</ContentTemplate>
			</asp:UpdatePanel>
			<asp:Panel ID="pnlOptions" runat="server" Height="580px" Width="100%">
				<asp:UpdatePanel ID="updOptions" runat="server" UpdateMode="Conditional">
					<ContentTemplate>
						<asp:Panel ID="pnlWorking" runat="server">
							<br />
							<br />
							<br />
							<div class="redtitle2 Left5pxPadd">
								The file has been loaded.
							</div>
						</asp:Panel>
						<asp:Panel ID="pnlNoAccess" runat="server">
							<br />
							<br />
							<br />
							<div class="redtitle2 Left5pxPadd">
								You do not have sufficient securty to use this page.
							</div>
						</asp:Panel>
						<asp:Panel ID="pnlExcelDir" runat="server">
							<asp:UpdatePanel ID="updDirPanel" runat="server" UpdateMode="Conditional">
								<ContentTemplate>
									<table cellspacing="0" width="100%">
										<tr>
											<td class="Left5pxPadd">
												<div class="readtxt">
													Select file to upload
												</div>
												<input id="SingleFileSelector" type="file" size="80" onchange="SetFileName(this.value);" />
												<asp:HiddenField ID="SingleFileName" runat="server" />
												&nbsp; &nbsp;
											</td>
										</tr>
										<tr class="BluBg">
											<td class="Left5pxPadd" valign="middle">
												<asp:ImageButton ID="btnLoadFile" runat="server" ImageUrl="../Common/Images/ok.gif"
													OnClick="btnLoadFile_Click" />
												&nbsp; &nbsp; Facing Bin Data. Create TAB delimited files from Excel. First 4 columns
												are Location, Item, Bim, Capacity. &nbsp; &nbsp;
											</td>
										</tr>
										<tr>
											<td class="Left5pxPadd">
												<asp:UpdateProgress ID="prgExcel" runat="server" AssociatedUpdatePanelID="updDirPanel">
													<ProgressTemplate>
														<div class="redtitle2">
															&nbsp; &nbsp; Processing Excel File. One Moment...
														</div>
													</ProgressTemplate>
												</asp:UpdateProgress>
											</td>
										</tr>
									</table>
									<table width="100%">
										<tr>
											<td class="Left5pxPadd">
												<div class="readtxt">
													Files in default folder
													<asp:Label ID="DefaultDirLabel" runat="server" Text=""></asp:Label></div>
												<asp:Panel ID="FilesPanel" runat="server" Height="300px" ScrollBars="Vertical">
													<asp:GridView ID="FilesGridView" runat="server" HeaderStyle-HorizontalAlign="Left"
														AutoGenerateColumns="false" OnRowEditing="UpdateFromGrid" BorderStyle="NotSet">
														<AlternatingRowStyle CssClass="Left5pxPadd" BackColor="#DCF3FB" BorderColor="#DAEEEF"
															HorizontalAlign="Left" />
														<Columns>
															<asp:CommandField ShowEditButton="True" EditText="LOAD" />
															<asp:BoundField DataField="Ready For Review" HeaderText="Ready For Review" SortExpression="Ready For Review" />
															<asp:BoundField DataField="Date Modified" HeaderText="Date Modified" SortExpression="Date Modified" />
														</Columns>
													</asp:GridView>
												</asp:Panel>
											</td>
										</tr>
									</table>
								</ContentTemplate>
							</asp:UpdatePanel>
						</asp:Panel>
						<asp:Panel ID="pnlExcelData" runat="server">
							<asp:UpdatePanel ID="updExcelData" runat="server" UpdateMode="Conditional">
								<ContentTemplate>
									<div style="height: 550px;">
										<asp:DataGrid ID="dgExcelData" runat="server" GridLines="both" BorderWidth="1px"
											AllowSorting="true" AutoGenerateColumns="false" BorderColor="#DAEEEF" AllowPaging="true"
											PageSize="16" PagerStyle-Visible="false" OnPageIndexChanged="dgExcelData_PageIndexChanged"
											OnSortCommand="dgExcelData_SortCommand">
											<HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
												HorizontalAlign="Center" />
											<ItemStyle CssClass="Left5pxPadd GridItem" BackColor="White" BorderColor="White"
												Height="20px" HorizontalAlign="Left" />
											<AlternatingItemStyle CssClass="Left5pxPadd GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
												HorizontalAlign="Left" />
											<Columns>
												<asp:BoundColumn HeaderStyle-Width="50" ItemStyle-HorizontalAlign="center" HeaderText="Branch"
													DataField="Location" DataFormatString="{0:00}" SortExpression="Location" ItemStyle-Wrap="false"
													ItemStyle-Width="50" HeaderStyle-Wrap="false"></asp:BoundColumn>
												<asp:BoundColumn HeaderStyle-Width="120" ItemStyle-HorizontalAlign="center" HeaderText="Item"
													DataField="ItemNo" SortExpression="ItemNo" ItemStyle-Wrap="false" ItemStyle-Width="120"
													HeaderStyle-Wrap="false"></asp:BoundColumn>
												<asp:BoundColumn DataField="BinLabel" HeaderStyle-Width="80" HeaderStyle-Wrap="false"
													HeaderText="Bin " ItemStyle-HorizontalAlign="center" ItemStyle-Width="80" ItemStyle-Wrap="false"
													SortExpression="BinLabel"></asp:BoundColumn>
												<asp:BoundColumn HeaderStyle-Width="50" ItemStyle-HorizontalAlign="right" HeaderText="Cap."
													DataField="BinCapacity" DataFormatString="{0:#,##0}" ItemStyle-CssClass="gridItem"
													SortExpression="BinCapacity" ItemStyle-Wrap="false" ItemStyle-Width="50" HeaderStyle-Wrap="false">
												</asp:BoundColumn>
												<asp:BoundColumn DataField="BinStatus" HeaderStyle-Width="80" HeaderStyle-Wrap="false"
													HeaderText="Status" ItemStyle-HorizontalAlign="center" ItemStyle-Width="80" ItemStyle-Wrap="false"
													SortExpression="BinStatus"></asp:BoundColumn>
												<asp:BoundColumn DataField="pPFCBinItemCapacityID" HeaderStyle-Width="80" HeaderStyle-Wrap="false"
													HeaderText="ID" ItemStyle-HorizontalAlign="center" ItemStyle-Width="80" ItemStyle-Wrap="false"
													SortExpression="pPFCBinItemCapacityID"></asp:BoundColumn>
											</Columns>
										</asp:DataGrid></div>
									<uc3:pager ID="ExcelPager" runat="server" OnBubbleClick="ExcelPager_PageChanged" />
									<input type="hidden" runat="server" id="hidExcelSort" />
								</ContentTemplate>
							</asp:UpdatePanel>
						</asp:Panel>
						<asp:Panel ID="pnlProcess" runat="server" Height="580px" Width="100%">
							<asp:UpdatePanel ID="updProcess" runat="server" UpdateMode="Conditional">
								<ContentTemplate>
									<table cellpadding="0" cellspacing="0">
										<tr>
											<td colspan="3" class="redtitle2">
												Move Ticket Creation Filters
											</td>
											<td rowspan="7" style="width: 200px;" valign="top" class="LeftPadding">
												<asp:Label ID="lblProcessStatus" runat="server"></asp:Label>
												<asp:UpdateProgress ID="prgProcess" runat="server" AssociatedUpdatePanelID="updProcess">
													<ProgressTemplate>
														<span class="redtitle2">Processing Records. One moment.....</span>
													</ProgressTemplate>
												</asp:UpdateProgress>
											</td>
										</tr>
										<tr>
											<td class="LeftPadding">
												Branch:
											</td>
											<td colspan="2">
												<asp:DropDownList ID="ddlLocation" runat="server" DataTextField="Location" DataValueField="Location">
												</asp:DropDownList>
											</td>
										</tr>
										<tr>
											<td class="LeftPadding">
												&nbsp;
											</td>
											<td>
												Beginning
											</td>
											<td>
												Ending
											</td>
										</tr>
										<tr>
											<td class="LeftPadding">
												Item Range:
											</td>
											<td>
												<asp:TextBox ID="txtBegItem" runat="server"></asp:TextBox>
											</td>
											<td>
												<asp:TextBox ID="txtEndItem" runat="server"></asp:TextBox>
											</td>
										</tr>
										<%--										<tr>
											<td class="LeftPadding">
												From Bin Range:
											</td>
											<td>
												<asp:TextBox ID="txtBegFrom" runat="server"></asp:TextBox>
											</td>
											<td>
												<asp:TextBox ID="txtEndFrom" runat="server"></asp:TextBox>
											</td>
										</tr>
--%>
										<tr>
											<td class="LeftPadding">
												To Bin Range:
											</td>
											<td>
												<asp:TextBox ID="txtBegTo" runat="server"></asp:TextBox>
											</td>
											<td>
												<asp:TextBox ID="txtEndTo" runat="server"></asp:TextBox>
											</td>
										</tr>
										<tr>
											<td colspan="3" class="LeftPadding">
												Print Move Tickets when they are created tonight?&nbsp;
												<asp:CheckBox ID="chkAutoPrint" runat="server" onclick="javascript:ShowPrinter(this);" />
											</td>
										</tr>
										<tr>
											<td id="PrinterCell" colspan="3" class="LeftPadding">
												Move Ticket Printer:&nbsp;
												<asp:DropDownList ID="ddlPrinterName" runat="server" CssClass="FormCtrl" Width="170px">
												</asp:DropDownList>
											</td>
										</tr>
										<tr>
											<td colspan="3" align="center">
												<asp:ImageButton ID="btnProcessSubmit" runat="server" ImageUrl="../Common/Images/submit.gif"
													OnClick="btnProcessSubmit_Click" />
											</td>
										</tr>
									</table>
								</ContentTemplate>
							</asp:UpdatePanel>
						</asp:Panel>
						<asp:Panel ID="pnlTicketsData" runat="server" Height="580px" Width="100%" ScrollBars="auto"
							BorderColor="black" BorderStyle="Solid" BorderWidth="1">
							<asp:UpdatePanel ID="updTicketsPanel" runat="server" UpdateMode="Conditional">
								<ContentTemplate>
									<table cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td rowspan="3" valign="top">
												<table cellpadding="0" cellspacing="0" width="180px">
													<tr>
														<tr>
															<td align="center" colspan="2">
																&nbsp;
															</td>
														</tr>
														<td class="LeftPadding">
															Branch To Review:
														</td>
														<td>
															<asp:DropDownList ID="ddlReviewLoc" runat="server" DataTextField="Location" DataValueField="Location">
															</asp:DropDownList>
														</td>
													</tr>
													<tr>
														<td colspan="2" align="center">
															<asp:ImageButton ID="btnReviewSelect" runat="server" ImageUrl="../Common/Images/submit.gif"
																OnClick="btnReviewSelect_Click" />
														</td>
													</tr>
													<tr>
														<td colspan="2" align="center">
															&nbsp;
														</td>
													</tr>
													<tr>
														<td class="LeftPadding redtitle2" colspan="2">
															View Tickets in Grid
														</td>
													</tr>
													<tr>
														<td colspan="2" align="center">
															<asp:DataGrid ID="dgSummary" runat="server" GridLines="both" BorderWidth="1px" AutoGenerateColumns="false"
																BorderColor="#DAEEEF" OnItemCommand="dgSummary_ItemCommand">
																<HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
																	HorizontalAlign="Center" />
																<ItemStyle CssClass="Left5pxPadd GridItem" BackColor="White" BorderColor="White"
																	Height="20px" HorizontalAlign="Left" />
																<AlternatingItemStyle CssClass="Left5pxPadd GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
																	HorizontalAlign="Left" />
																<Columns>
																	<asp:ButtonColumn CommandName="View" ButtonType="LinkButton" Text="View" ItemStyle-HorizontalAlign="center"
																		ItemStyle-Width="40px" />
																	<asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="center" HeaderText="Status"
																		DataField="BinStatus" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
																	</asp:BoundColumn>
																</Columns>
															</asp:DataGrid>
														</td>
													</tr>
													<tr>
														<td colspan="2" align="center">
															&nbsp;
														</td>
													</tr>
													<tr>
														<td colspan="2">
															<asp:UpdatePanel ID="updTicketPrint" runat="server" UpdateMode="Conditional">
																<ContentTemplate>
																	<asp:Panel ID="pnlTicketPrint" runat="server">
																		<table>
																			<tr>
																				<td class="LeftPadding redtitle2">
																					Print Grid Tickets
																				</td>
																			</tr>
																			<tr>
																				<td class="LeftPadding">
																					Printer:
																				</td>
																			</tr>
																			<tr>
																				<td>
																					&nbsp;<asp:DropDownList ID="ddlReviewPrinter" runat="server" CssClass="FormCtrl"
																						Width="170px">
																					</asp:DropDownList>
																				</td>
																			</tr>
																			<tr>
																				<td colspan="2" align="center">
																					<asp:ImageButton ID="btnReviewPrint" runat="server" ImageUrl="../Common/Images/print.gif"
																						OnClick="btnReviewPrint_Click" />
																				</td>
																			</tr>
																		</table>
																	</asp:Panel>
																</ContentTemplate>
															</asp:UpdatePanel>
														</td>
													</tr>
												</table>
											</td>
											<td class="LeftPadding redtitle2">
												Current Move Tickets for Selected Branch
											</td>
											<td>
											</td>
										</tr>
										<tr>
											<td class="LeftPadding" style="height: 535px;" valign="top">
												<asp:DataGrid ID="dgTicketData" Width="100%" runat="server" GridLines="both" BorderWidth="1px"
													AllowSorting="true" AutoGenerateColumns="false" BorderColor="#DAEEEF" AllowPaging="true"
													PageSize="16" PagerStyle-Visible="false" OnPageIndexChanged="dgTicketData_PageIndexChanged"
													OnSortCommand="dgTicketData_SortCommand" OnItemCommand="dgTicketData_ItemCommand"
													OnItemDataBound="dgTicketData_ItemDataBound">
													<HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
														HorizontalAlign="Center" />
													<ItemStyle CssClass="GridItem" BackColor="White" BorderColor="White" Height="20px"
														HorizontalAlign="Left" />
													<AlternatingItemStyle CssClass="GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
														HorizontalAlign="Left" />
													<Columns>
														<asp:HyperLinkColumn DataNavigateUrlFormatString="MoveTicketExport.aspx?TicketNo={0}"
															DataNavigateUrlField="TicketNo" Target="_blank" Text="Preview" ItemStyle-Width="40px"
															ItemStyle-HorizontalAlign="center"></asp:HyperLinkColumn>
														<asp:BoundColumn HeaderStyle-Width="50" ItemStyle-HorizontalAlign="center" HeaderText="Branch"
															DataField="Location" DataFormatString="{0:00}" SortExpression="Location" ItemStyle-Wrap="false"
															ItemStyle-Width="50" HeaderStyle-Wrap="false"></asp:BoundColumn>
														<asp:BoundColumn DataField="TicketNo" HeaderStyle-Width="100" HeaderStyle-Wrap="false"
															HeaderText="Ticket" ItemStyle-HorizontalAlign="center" ItemStyle-Width="100" ItemStyle-Wrap="false"
															SortExpression="TicketNo"></asp:BoundColumn>
														<asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="center" HeaderText="Item"
															DataField="ItemNo" SortExpression="ItemNo" ItemStyle-Wrap="false" ItemStyle-Width="100"
															HeaderStyle-Wrap="false"></asp:BoundColumn>
														<asp:BoundColumn DataField="FromBin" HeaderStyle-Width="80" HeaderStyle-Wrap="false"
															HeaderText="From Bin" ItemStyle-HorizontalAlign="center" ItemStyle-Width="80" ItemStyle-Wrap="false"
															SortExpression="FromBin"></asp:BoundColumn>
														<asp:BoundColumn DataField="FromQty" DataFormatString="{0:#,##0}" HeaderStyle-Width="60"
															HeaderStyle-Wrap="false" HeaderText="Qty" ItemStyle-HorizontalAlign="right" ItemStyle-Width="60"
															ItemStyle-Wrap="false" SortExpression="FromQty"></asp:BoundColumn>
														<asp:BoundColumn DataField="BinLabel" HeaderStyle-Width="80" HeaderStyle-Wrap="false"
															HeaderText="To Bin" ItemStyle-HorizontalAlign="center" ItemStyle-Width="80" ItemStyle-Wrap="false"
															SortExpression="BinLabel"></asp:BoundColumn>
														<asp:BoundColumn HeaderStyle-Width="60" ItemStyle-HorizontalAlign="right" HeaderText="Cap."
															DataField="BinCapacity" DataFormatString="{0:#,##0}" SortExpression="BinCapacity"
															ItemStyle-Wrap="false" ItemStyle-Width="60" HeaderStyle-Wrap="false"></asp:BoundColumn>
														<asp:BoundColumn DataField="BinStatus" HeaderStyle-Width="80" HeaderStyle-Wrap="false"
															HeaderText="Status" ItemStyle-HorizontalAlign="center" ItemStyle-Width="80" ItemStyle-Wrap="false"
															SortExpression="BinStatus"></asp:BoundColumn>
													</Columns>
												</asp:DataGrid>
											</td>
											<td>
											</td>
										</tr>
										<tr>
											<td class="LeftPadding">
												<uc3:pager ID="TicketPager" runat="server" OnBubbleClick="TicketPager_PageChanged" />
												<input id="hidTicketSort" runat="server" type="hidden" />
												<input id="hidTicketStatus" runat="server" type="hidden" />
											</td>
											<td>
											</td>
										</tr>
									</table>
								</ContentTemplate>
							</asp:UpdatePanel>
						</asp:Panel>
					</ContentTemplate>
				</asp:UpdatePanel>
			</asp:Panel>
			<asp:UpdatePanel ID="updMessage" runat="server" UpdateMode="Conditional">
				<ContentTemplate>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr class="BluBg">
							<td class="Left5pxPadd">
								&nbsp; &nbsp;
								<asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>
								<asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
							</td>
						</tr>
					</table>
				</ContentTemplate>
			</asp:UpdatePanel>
			<uc2:Footer ID="pagefoot" runat="server" />
		</div>
	</form>
</body>
</html>
