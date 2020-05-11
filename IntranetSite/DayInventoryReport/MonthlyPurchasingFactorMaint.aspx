<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MonthlyPurchasingFactorMaint.aspx.cs"
	Inherits="MonthlyPurchasingFactorMaint" %>

<%@ Register Src="~/Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc4" %>
<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="~/Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame"
	TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
	<title>Monthly Purchasing Factor</title>
	<link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
	<link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

	<script>
    function DeleteFiles()
       {
            //var str=MonthlyPurchasingFactor.DeleteExcel('PurchFactor'+'<%=Session["SessionID"].ToString()%>').value.toString();
            window.close();           
       }
    function PrintReport()
    {
       var url="Sort="+document.getElementById("hidSort").value;           
       var hwin= window.open("MonthlyPurchasingFactorPreview.aspx?"+url,"PurchasingFactorPreview" ,'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width)/2 - (1020/2))+',resizable=no',"");
       hwin.focus();
    }
	</script>

</head>
<body>
	<form id="form1" runat="server">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="100%" height="100%" valign="top" colspan="2">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="4">
								<uc4:Header ID="Header1" runat="server" />
							</td>
						</tr>
						<tr>
							<td class="PageHead" colspan="4" style="height: 40px">
								<table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
									<tr>
										<td style="height: 40px" width="75%">
											<div class="Left5pxPadd">
												<div align="left" class="BannerText">
													<asp:Label ID="lblMenuName" CssClass="BannerText" runat="server" Text=""></asp:Label></div>
											</div>
										</td>
										<td align="right" style="width: 300px; padding-right: 5px;">
											<table border="0" cellpadding="0" cellspacing="0" width="280">
												<tr>
													<td style="width: 100px; padding: 2px;">
														<asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
															ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
													</td>
													<td style="padding: 2px;">
														<asp:ImageButton runat="server" ID="ibtnAdd" ImageUrl="~/Common/Images/newadd.gif"
															ImageAlign="middle" OnClick="ibtnAdd_Click" />
													</td>
													<td style="padding: 2px;">
														<asp:ImageButton runat="server" ID="ibtnChange" ImageUrl="~/Common/Images/update.gif"
															ImageAlign="middle" OnClick="ibtnChange_Click" />
													</td>
													<td style="padding: 2px;">
														<asp:ImageButton runat="server" ID="ibtnDelete" ImageUrl="~/Common/Images/BtnDelete.gif"
															ImageAlign="middle" OnClick="ibtnDelete_Click" />
													</td>
													<td style="width: 100px; padding: 2px;">
														<img style="cursor: hand" src="../common/images/Close.gif" id="Img1" onclick="javascript:DeleteFiles();" /></td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr id="trHead" class="">
							<td class="LeftPadding TabHead BluBordAll" style="width: 100%; height: 95px;">
								<table>
									<tr>
										<td style="width: 120px;">
											Beginning Group
										</td>
										<td style="width: 300px;">
											<asp:DropDownList ID="ddlBegGroup" CssClass="FormCtrl" Height="20px" runat="server"
												Width="280px" TabIndex="8">
											</asp:DropDownList>
										</td>
										<td rowspan="3">
											<table>
												<tr>
													<td>
														Use the add button to add the range on the left
													</td>
												</tr>
												<tr>
													<td>
														Use the update button to update the range on the left with the factor
													</td>
												</tr>
												<tr>
													<td>
														Use the delete button to delete the range on the left
													</td>
												</tr>
												<tr>
													<td class="TabHead" align="left">
														<asp:Label ID="lblCheckMessage" runat="server"></asp:Label>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td>
											Ending Group
										</td>
										<td>
											<asp:DropDownList ID="ddlEndGroup" CssClass="FormCtrl" Height="20px" runat="server"
												Width="280px" TabIndex="8">
											</asp:DropDownList>
										</td>
										<td>
										</td>
									</tr>
									<tr>
										<td>
											Factor
										</td>
										<td>
											<asp:TextBox ID="FactorTextBox" runat="server" Width="50px"></asp:TextBox>
										</td>
										<td>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<div id="PrintDG2">
						<div class="Sbar" id="div-datagrid" style="overflow-x: hidden; overflow-y: auto;
							position: relative; top: 0px; left: 0px; width: 1016px; height: 516px; border: 0px solid;">
							<asp:DataGrid ID="dgPurchFactor" Width="100%" runat="server" GridLines="both" BorderWidth="1px"
								AllowSorting="true" AutoGenerateColumns="false" BorderColor="#DAEEEF" AllowPaging="true"
								PageSize="19" PagerStyle-Visible="false" OnPageIndexChanged="dgPurchFactor_PageIndexChanged"
								OnSortCommand="dgPurchFactor_SortCommand">
								<HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
									HorizontalAlign="Center" />
								<ItemStyle CssClass="Left5pxPadd GridItem" BackColor="White" BorderColor="White"
									Height="20px" HorizontalAlign="Left" />
								<AlternatingItemStyle CssClass="Left5pxPadd GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
									HorizontalAlign="Left" />
								<FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
									HorizontalAlign="Center" />
								<Columns>
									<asp:BoundColumn HeaderStyle-Width="50" ItemStyle-HorizontalAlign="center" HeaderText="Group"
										DataField="GroupNo" DataFormatString="{0:###0}" SortExpression="GrpNoSort" ItemStyle-Wrap="false"
										ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
									<asp:BoundColumn DataField="CPRFactor" DataFormatString="{0:#,##0.0}" FooterStyle-HorizontalAlign="right"
										HeaderStyle-Width="50" HeaderStyle-Wrap="false" HeaderText="Factor " ItemStyle-HorizontalAlign="center"
										ItemStyle-Width="50" ItemStyle-Wrap="false" SortExpression="CPRFactor"></asp:BoundColumn>
									<asp:BoundColumn HeaderStyle-Width="250" ItemStyle-HorizontalAlign="left" HeaderText="Group Description "
										ItemStyle-CssClass="LeftPadding" FooterStyle-HorizontalAlign="left" DataField="GrpDesc"
										SortExpression="GrpDesc" ItemStyle-Wrap="false" ItemStyle-Width="300" HeaderStyle-Wrap="false">
									</asp:BoundColumn>
									<asp:BoundColumn DataField="EntryID" HeaderStyle-Width="80" HeaderStyle-Wrap="false"
										HeaderText="EntryID" ItemStyle-HorizontalAlign="center" ItemStyle-Width="80" ItemStyle-Wrap="false"
										SortExpression="EntryID"></asp:BoundColumn>
									<asp:BoundColumn HeaderStyle-Width="120" ItemStyle-HorizontalAlign="right" HeaderText="EntryDt "
										FooterStyle-HorizontalAlign="right" DataField="EntryDt" SortExpression="EntryDt"
										ItemStyle-Wrap="false" ItemStyle-Width="120" HeaderStyle-Wrap="false"></asp:BoundColumn>
									<asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="center" HeaderText="ChangeID"
										FooterStyle-HorizontalAlign="right" DataField="ChangeID" SortExpression="ChangeID"
										ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
									<asp:BoundColumn HeaderStyle-Width="120" ItemStyle-HorizontalAlign="right" HeaderText="ChangeDt"
										FooterStyle-HorizontalAlign="right" DataField="ChangeDt" SortExpression="ChangeDt"
										ItemStyle-Wrap="false" ItemStyle-Width="120" HeaderStyle-Wrap="false"></asp:BoundColumn>
									<asp:BoundColumn HeaderStyle-Width="50" ItemStyle-HorizontalAlign="right" HeaderText="ID "
										FooterStyle-HorizontalAlign="right" DataField="pPurchaseBudgetFactorsID" SortExpression="pPurchaseBudgetFactorsID"
										ItemStyle-Wrap="false" HeaderStyle-Wrap="false"></asp:BoundColumn>
								</Columns>
							</asp:DataGrid>
						</div>
					</div>
					<center>
						<asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
							Visible="False"></asp:Label></center>
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
</body>
</html>
