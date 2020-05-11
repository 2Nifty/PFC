<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MoveTicketExport.aspx.cs"
	Inherits="MoveTicketExport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title>Move Ticket</title>

	<script language="javascript">
    <!--
    -->
	</script>

	<style type="text/css">
	body {
		margin-left: 0px;
		margin-top: 0px;
		margin-right: 0px;
		margin-bottom: 0px;
		font-family: Arial, Helvetica, sans-serif;
		font-size: 12pt;
	padding-left: 2px;
	}
	.Title {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 16pt;
	font-weight: bold;
	padding-top: 5px;
	padding-bottom: 5px;
	padding-left: 20px;
	}
	.Header {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14pt;
	padding-top: 5px;
	padding-bottom: 5px;
	padding-left: 10px;
	}
	.Bold {
	font-weight: bold;
	}
	.Border {
	border: 1px solid black;
	}
	.GridItem {
	border: 1px solid black;
	}

	</style>
</head>
<body>
	<form id="MainForm" runat="server">
		<div>
			<table cellpadding="0" cellspacing="0" width="100%" style="height: 60px;">
				<tr>
					<td valign="top">
						<span class="Title">MOVE TICKET</span><br />
					</td>
					<td valign="top">
						<table>
							<tr>
								<td class="Header">
									Ticket Number:
								</td>
								<td class="Header Bold">
									<asp:Label ID="lblTicketNo" runat="server"></asp:Label>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td class="Header">
									Location:
								</td>
								<td class="Header Bold">
									<asp:Label ID="lblBranch" runat="server"></asp:Label>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td class="Header">
									Generated:
								</td>
								<td class="Header Bold">
									<asp:Label ID="lblGenerated" runat="server"></asp:Label>
								</td>
								<td>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<%--				<table cellspacing="0">
					<tr>
						<td>
							<div class="Header">
								Items
							</div>
							&nbsp; &nbsp;
						</td>
						<td class="Header Bold">
							<asp:Label ID="lblItemCount" runat="server"></asp:Label>
						</td>
					</tr>
				</table>
--%>
			<table cellpadding="0" cellspacing="0" width="600PX">
				<tr>
					<td align="center" class="Header Border">
						Ticket Moves
					</td>
				</tr>
				<tr>
					<td class="Border" valign="top">
						<asp:DataGrid ID="dgPickData" runat="server" AutoGenerateColumns="false" BorderColor="#FFFFFF"
							Width="600px" BorderStyle="Solid" BorderWidth="1px" CssClass="GridItem" GridLines="both"
							OnItemDataBound="dgPickData_ItemDataBound">
							<HeaderStyle CssClass="GridItem" BorderColor="#FFFFFF" Height="20px" HorizontalAlign="Center" />
							<ItemStyle BorderColor="#FFFFFF" CssClass="GridItem" Height="20px" />
							<Columns>
								<asp:BoundColumn DataField="FromBin" HeaderStyle-Width="100" HeaderStyle-Wrap="false"
									HeaderText="From Bin" ItemStyle-HorizontalAlign="center" ItemStyle-Width="100"
									ItemStyle-Wrap="false"></asp:BoundColumn>
								<asp:BoundColumn HeaderStyle-Width="150" ItemStyle-HorizontalAlign="center" HeaderText="Item"
									DataField="ItemNo" ItemStyle-Wrap="false" ItemStyle-Width="150" HeaderStyle-Wrap="false">
								</asp:BoundColumn>
								<asp:BoundColumn DataField="OnHand" DataFormatString="{0:#,##0}" HeaderStyle-Width="60"
									HeaderStyle-Wrap="false" HeaderText="On Hand" ItemStyle-HorizontalAlign="right"
									ItemStyle-Width="60" ItemStyle-Wrap="false"></asp:BoundColumn>
								<asp:BoundColumn DataField="ToBin" HeaderStyle-Width="100" HeaderStyle-Wrap="false"
									HeaderText="To Bin" ItemStyle-HorizontalAlign="center" ItemStyle-Width="100" ItemStyle-Wrap="false">
								</asp:BoundColumn>
								<asp:BoundColumn DataField="BinCapacity" DataFormatString="{0:#,##0}" HeaderStyle-Width="60"
									HeaderStyle-Wrap="false" HeaderText="Capacity" ItemStyle-HorizontalAlign="right"
									ItemStyle-Width="60" ItemStyle-Wrap="false"></asp:BoundColumn>
								<%--								<asp:BoundColumn DataField="PickStatus" HeaderStyle-Width="100" HeaderStyle-Wrap="false"
									HeaderText="Status" ItemStyle-HorizontalAlign="center" ItemStyle-Width="100" ItemStyle-Wrap="false"
									></asp:BoundColumn>
								<asp:BoundColumn HeaderStyle-Width="60" ItemStyle-HorizontalAlign="right" HeaderText="Over Pick"
									DataField="OverPickQty" DataFormatString="{0:#,##0}"
									ItemStyle-Wrap="false" ItemStyle-Width="60" HeaderStyle-Wrap="false"></asp:BoundColumn>
								<asp:BoundColumn DataField="MoveQty" DataFormatString="{0:#,##0}" HeaderStyle-Width="60"
									HeaderStyle-Wrap="false" HeaderText="Min. Pick" ItemStyle-HorizontalAlign="right"
									ItemStyle-Width="60" ItemStyle-Wrap="false"></asp:BoundColumn>
--%>
							</Columns>
						</asp:DataGrid>
					</td>
				</tr>
				<tr>
					<td align="center" class="Header Border">
						Pick Total:&nbsp; &nbsp;<asp:Label ID="lblTotal" runat="server" ></asp:Label>
					</td>
				</tr>
				<tr>
					<td align="center" class="Header">
						&nbsp;
					</td>
				</tr>
			</table>
			<%--				<table cellpadding="0" cellspacing="0" width="400PX">
				<tr>
					<td align="center" class="Header Border">
						PUTS
					</td>
				</tr>
				<tr>
					<td class="Border" valign="top">
						<asp:DataGrid ID="dgPutData" runat="server" AutoGenerateColumns="false" BorderColor="#FFFFFF"
							BorderStyle="Solid" BorderWidth="1px" GridLines="both" Width="400px">
							<HeaderStyle BorderColor="#FFFFFF" CssClass="GridHead" Height="20px" HorizontalAlign="Center" />
							<ItemStyle BorderColor="#FFFFFF" CssClass="GridItem" Height="20px" />
							<Columns>
								<asp:BoundColumn DataField="ItemNo" HeaderStyle-Width="150" HeaderStyle-Wrap="false"
									HeaderText="Item" ItemStyle-HorizontalAlign="center" ItemStyle-Width="150" ItemStyle-Wrap="false"
									></asp:BoundColumn>
								<asp:BoundColumn DataField="PickStatus" HeaderStyle-Width="80" HeaderStyle-Wrap="false"
									HeaderText="Status" ItemStyle-HorizontalAlign="center" ItemStyle-Width="80" ItemStyle-Wrap="false">
								</asp:BoundColumn>
							</Columns>
						</asp:DataGrid>
					</td>
				</tr>
			</table>
--%>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="Left5pxPadd">
						<asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>
					</td>
				</tr>
			</table>
		</div>
	</form>
</body>
</html>
