<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="RTSRecommendations.aspx.cs"	Inherits="RTSRecommendations" %>

<%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/newfooter.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
	<title>Goods En Route Ready to Ship V1.0.0</title>
	<link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
	<link href="../ReadyToShip/Common/StyleSheet/RTS_Styles.css" rel="stylesheet" type="text/css" />
	<link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

	<script type="text/javascript" language="javascript">
        var status= false;

        // Function to allow the numeric value only
        function ValdateNumber()
        {
            if(event.keyCode<47 || event.keyCode>58) event.keyCode=0;
        }
        
        function ActionEnter(txtAction)
        {
            if(event.keyCode==13)
            {
                document.getElementById('imgClose').focus();
                return false;
            }
            else
                ValdateNumber();
        }
        
        function CallClick(txtAction)
        {
            var currValue=parseInt((txtAction.value.replace(/\s/g,'')!='')?txtAction.value:0);
            var prevValue=parseInt(document.getElementById(txtAction.id.replace('txtActQty','hidCurrentQty')).value);
           
            if(prevValue!=currValue || (currValue==0 && prevValue==0 && txtAction.value.replace(/\s/g,'')==''))
            {
                document.getElementById(txtAction.id.replace('txtActQty','btnAction')).click();
                return false;
            }
            else
                status =true;
           
            return false;
        }   
         
        function GetStatus()
        {
            if(status)
            {
                status = false;
                return false;
            }
            else
                return true;
        }
        
        function AdjustHeight()
        {
            
        }
       
        function CPRReport()
        {
            if (document.getElementById('CPRFactor').value == "" || document.getElementById('CPRFactor').value == null || document.getElementById('CPRFactor').value.search(/\d+/) == -1 || document.getElementById('CPRFactor').value.search(/[a-zA-Z]/) != -1)
            {
                alert("To run the CPR report you must enter a numeric factor");
                document.getElementById('CPRFactor').focus();
            }
            else
            {
                CPRWin = window.open("../CPR/CPRReport.aspx?Item=" + document.getElementById('ddlItemNo').value + "&Factor=" + document.getElementById('CPRFactor').value,"CPRReport","height=768,width=1024,scrollbars=yes,location=no,status=no,top="+((screen.height/2) - (760/2))+",left=0,resizable=YES","");
            }
        }
	</script>

</head>
<body scroll="no"
	onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
	<form id="form1" runat="server">
		<asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
		</asp:ScriptManager>
		<div id="Container" style="height: 100%">
			<uc1:Header ID="Header1" runat="server" />
			<div id="Content">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td valign="top" class="shadeBgDown">
							<table width="100%" border="0" cellspacing="1" cellpadding="0">
								<tr>
									<td valign="top" rowspan="3">
										<table border="0" cellpadding="2" cellspacing="0" style="width: 100%">
											<tr>
												<td>
													<asp:UpdatePanel ID="pnlItemDetails" runat="server" UpdateMode="conditional">
														<ContentTemplate>
															<table width="100%" class=" blueBorder ItemHeader" border="0" cellspacing="0" cellpadding="2">
																<tr>
																	<td>
																		<table border="0" cellspacing="0" cellpadding="1">
																			<tr>
																				<td style="width: 40px; padding-left: 10px;">
																					<strong>Item</strong></td>
																				<td width="185" colspan="5">
																					<strong>
																						<asp:DropDownList ID="ddlItemNo" runat="server" CssClass="FormCtrl" Width="150px"
																							AutoPostBack="True" OnSelectedIndexChanged="ddlItemNo_SelectedIndexChanged">
																						</asp:DropDownList></strong>
																				</td>
																				<td width="145">
																					<strong>ROP Factor</strong>:&nbsp;<asp:Label ID="lblROPFct" runat="server" Text="ROPFct"></asp:Label>
																				</td>
																				<td align="right" valign="middle">
																					<a onclick="javascript:CPRReport();" style="cursor: hand" class="redhead" title="CLICK HERE TO RUN A CPR REPORT FOR THIS ITEM">
																						CPR Report</a> Factor:&nbsp
																					<asp:TextBox ID="CPRFactor" runat="server" Width="30px" ToolTip="Enter the FACTOR for the CPR Report"></asp:TextBox>
																				</td>
																			</tr>
																		</table>
																	</td>
																</tr>
															</table>
														</ContentTemplate>
													</asp:UpdatePanel>
												</td>
											</tr>
											<tr>
												<td>
													<%--Branch Item Details Panel--%>
													<asp:UpdatePanel ID="pnlShipDetails" runat="server" UpdateMode="conditional">
														<ContentTemplate>
															<div class="blueBorder">
																<div id="div1" class="Sbar" align="center" style="overflow-x: hidden; overflow-y: auto;
																	position: relative; top: 0px; left: 0px; width: 540px; height: 512px; border: 0px solid;">
																	<asp:DataGrid CssClass="grid BlueBorder" BackColor="white" Width="100%" ID="dgItemDtl"
																		GridLines="both" runat="server" AutoGenerateColumns="false" OnItemCommand="dgItemDtl_ItemCommand"
																		UseAccessibleHeader="true" OnItemDataBound="dgItemDtl_ItemDataBound" ShowFooter="True">
																		<HeaderStyle CssClass="gridHeader1" Height="18px" HorizontalAlign="Center" />
																		<ItemStyle CssClass="gridItem TestRow" Wrap="False" />
																		<AlternatingItemStyle CssClass="zebra TestRow" />
																		<FooterStyle Font-Bold="True" ForeColor="#003366" CssClass="lightBlueBg" VerticalAlign="Top"
																			HorizontalAlign="Right" />
																		<Columns>
																			<asp:TemplateColumn HeaderText="Br" SortExpression="LocationCode">
																				<ItemTemplate>
																					<asp:LinkButton ID="lnkLocation" Font-Underline="true" CommandName="Action" runat="server"
																						Text='<%#DataBinder.Eval(Container,"DataItem.LocationCode")%>'></asp:LinkButton>
																					<asp:HiddenField ID="hidItemNo" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.ItemNo")%>' />
																				</ItemTemplate>
																				<FooterTemplate>
																					<table cellpadding="0" cellspacing="0" width="100%" align="left" class="noBorder">
																						<tr>
																							<td style="height: 15px" align="left" nowrap="nowrap">
																								<asp:Label Font-Bold="true" ForeColor="#003366" ID="lblItmNo" runat="server"></asp:Label></td>
																						</tr>
																						<tr>
																							<td style="height: 15px" align="left">
																								<asp:Label ID="lblUnused" Font-Bold="true" ForeColor="#003366" runat="server" Text="Unused Qty :"></asp:Label></td>
																						</tr>
																					</table>
																				</FooterTemplate>
																				<ItemStyle HorizontalAlign="Center" />
																				<HeaderStyle Width="50px" />
																			</asp:TemplateColumn>
																			<asp:BoundColumn DataField="SVCode" SortExpression="SVCode" HeaderText="SV">
																				<ItemStyle HorizontalAlign="Center" />
																				<HeaderStyle Width="15px" HorizontalAlign="center" />
																			</asp:BoundColumn>
																			<asp:BoundColumn DataField="ROPHubCalc" DataFormatString="{0:#,##0.0}" SortExpression="ROPHubCalc"
																				HeaderText="ROP">
																				<HeaderStyle Width="40px" />
																				<ItemStyle HorizontalAlign="Right" />
																			</asp:BoundColumn>
																			<asp:BoundColumn DataField="ROPDays" DataFormatString="{0:#,##0}" SortExpression="ROPDays"
																				HeaderText="Days">
																				<HeaderStyle Width="40px" />
																				<ItemStyle HorizontalAlign="Right" />
																			</asp:BoundColumn>
																			<asp:BoundColumn DataField="AvailQty" DataFormatString="{0:#,##0}" SortExpression="AvailQty"
																				HeaderText="Avl">
																				<ItemStyle HorizontalAlign="Right" />
																				<HeaderStyle Width="40px" />
																			</asp:BoundColumn>
																			<asp:BoundColumn DataField="RTSBQty" DataFormatString="{0:#,##0}" HeaderText="RTSB"
																				SortExpression="RTSBQty">
																				<ItemStyle HorizontalAlign="Right" />
																				<HeaderStyle Width="40px" />
																			</asp:BoundColumn>
																			<asp:BoundColumn DataField="InTransit" DataFormatString="{0:#,##0}" SortExpression="InTransit"
																				HeaderText="Trf OW">
																				<HeaderStyle Width="55px" />
																				<ItemStyle HorizontalAlign="Right" />
																			</asp:BoundColumn>
																			<asp:BoundColumn DataField="Avail_Mos" DataFormatString="{0:#,##0}" HeaderText="Avl Mos">
																				<HeaderStyle Width="50px" />
																				<ItemStyle HorizontalAlign="Right" />
																			</asp:BoundColumn>
																			<asp:BoundColumn HeaderText="Alloc" DataField="Allocated" DataFormatString="{0:#,##0}"
																				SortExpression="Allocated">
																				<ItemStyle HorizontalAlign="Right" Width="55px" />
																				<FooterStyle HorizontalAlign="Right" />
																			</asp:BoundColumn>
																			<asp:BoundColumn HeaderText="Req'd" DataField="Required" DataFormatString="{0:#,##0}"
																				SortExpression="Required">
																				<ItemStyle HorizontalAlign="Right" Width="55px" />
																				<FooterStyle HorizontalAlign="Right" />
																			</asp:BoundColumn>
																			<asp:BoundColumn HeaderText="S E" DataField="SupEqQty" DataFormatString="{0:#,##0.0}"
																				SortExpression="SupEqQty">
																				<ItemStyle HorizontalAlign="Right" Width="55px" />
																				<FooterStyle HorizontalAlign="Right" />
																			</asp:BoundColumn>
																			<%--
                                                                            <asp:TemplateColumn HeaderText="Recom'ed" SortExpression="RecommQty">
                                                                                <ItemStyle HorizontalAlign="Right" Width="55px" />
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="lblRecommend" runat="server" Text='<%#DataBinder.Eval(Container,"DataItem.RecommQty")%>'></asp:Label>
                                                                                </ItemTemplate>
                                                                                <FooterTemplate>
                                                                                    <table cellpadding="0" cellspacing="0" width="100%" align="right" border="0" class="noBorder">
                                                                                        <tr>
                                                                                            <td style="height: 15px" align="right" valign="top" width="100%">
                                                                                                <asp:Label ID="lblRecomm" ForeColor="#003366" runat="server" Text="0"></asp:Label></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td style="height: 15px">
                                                                                                <asp:Label ID="lblUnusedQty" ForeColor="#003366" runat="server" Text="0"></asp:Label></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </FooterTemplate>
                                                                                <FooterStyle VerticalAlign="Top" />
                                                                            </asp:TemplateColumn>
--%>
																			<asp:TemplateColumn HeaderText="Comm." SortExpression="CommitQty">
																				<HeaderStyle Width="45px" />
																				<ItemStyle HorizontalAlign="Center" />
																				<ItemTemplate>
																					<asp:LinkButton ID="lnkCommit" Font-Underline="true" CommandName="Commit" runat="server"
																						Text='<%#DataBinder.Eval(Container,"DataItem.CommitQty")%>'></asp:LinkButton>
																				</ItemTemplate>
																				<FooterStyle HorizontalAlign="Center" VerticalAlign="Top" />
																			</asp:TemplateColumn>
																		</Columns>
																	</asp:DataGrid>
																	<asp:Label ID="lblBrMsg" Font-Bold="true" runat="server" Text="No Records Found"></asp:Label>
																	<asp:HiddenField ID="hidBranch" runat="server" />
																	<input type="hidden" id="hidSortBranch" runat="server" />
																</div>
															</div>
														</ContentTemplate>
													</asp:UpdatePanel>
													<%--End Branch Item Details Panel--%>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td valign="top" class="blueBorder shadeBgDown">
										<%--Vendor Item and Shipment Details Panel--%>
										<asp:UpdatePanel ID="pnlVendorItemDetails" runat="server" UpdateMode="conditional">
											<ContentTemplate>
												<table width="100%">
													<tr>
														<td width="100%" class="blueBorder TabCntBk" style="padding: 5px">
															<%--Item Details--%>
															<table border="0" cellspacing="0" cellpadding="1" width="100%">
																<tr>
																	<td>
																		Description :
																	</td>
																	<td colspan="5" class="splitBorder_r_h" width="280px">
																		<asp:Label ID="lblDescription" Font-Bold="true" runat="server"></asp:Label>
																	</td>
																	<td rowspan="5" class="blueBorder" style="padding: 5px">
																		<b>Show P.O.<br />
																			Lines<br />
																			<asp:UpdatePanel ID="QtyFilterUpdatePanel" runat="server" ChildrenAsTriggers="true">
																				<ContentTemplate>
																					<asp:RadioButton ID="POQtyShowAll" runat="server" GroupName="POLineFilter" Text="All"
																						OnCheckedChanged="SetQtyFilter" AutoPostBack="true" /><br />
																					<asp:RadioButton ID="POQtyShowDone" runat="server" GroupName="POLineFilter" Text="Consumed"
																						OnCheckedChanged="SetQtyFilter" AutoPostBack="true" /><br />
																					<asp:RadioButton ID="POQtyShowRem" runat="server" GroupName="POLineFilter" Text="Qty Rem."
																						OnCheckedChanged="SetQtyFilter" AutoPostBack="true" /></b>
																				</ContentTemplate>
																			</asp:UpdatePanel>
																	</td>
																</tr>
																<tr>
																	<td>
																		UOM :
																	</td>
																	<td colspan="5" class="splitBorder_r_h">
																		<asp:Label ID="lblUOM" runat="server"></asp:Label>
																	</td>
																</tr>
																<tr>
																	<td>
																		Qty Per :
																	</td>
																	<td class="splitBorder_r_h">
																		<asp:Label ID="lblQtyPer" runat="server"></asp:Label>
																	</td>
																	<td class="splitBorder_r_h">
																		<div align="right">
																			<asp:Label ID="lbl_Lbs" runat="server" Font-Bold="true" Style="padding-left: 15px;"></asp:Label></div>
																	</td>
																	<td class="splitBorder_r_h">
																		Lbs
																	</td>
																	<td class="splitBorder_r_h">
																		<div align="right">
																		</div>
																	</td>
																	<td class="splitBorder_r_h">
																		&nbsp;
																	</td>
																</tr>
																<tr>
																	<td>
																		Super Eqv :
																	</td>
																	<td class="splitBorder_r_h">
																		<asp:Label ID="lblSuperEqu" runat="server"></asp:Label>
																	</td>
																	<td class="splitBorder_r_h">
																		<div align="right">
																			<asp:Label ID="lblPCS" runat="server" Font-Bold="true" Style="padding-left: 15px;"></asp:Label></div>
																	</td>
																	<td class="splitBorder_r_h">
																		Pcs
																	</td>
																	<td class="splitBorder_r_h">
																		<div align="right">
																			<asp:Label ID="lblTotLbs" runat="server" Font-Bold="true" Style="padding-left: 15px;"></asp:Label></div>
																	</td>
																	<td class="splitBorder_r_h">
																		Lbs
																	</td>
																</tr>
																<tr>
																	<td>
																		Wgt/100 :
																	</td>
																	<td class="splitBorder_r_h">
																		<asp:Label ID="lblWgt" runat="server"></asp:Label>
																	</td>
																	<td colspan="2">
																		Low Profile Pallet Qty :
																	</td>
																	<td class="splitBorder_r_h">
																		<asp:Label ID="lblLowProfileQty" runat="server"></asp:Label>
																	</td>
																</tr>
																<tr>
																	<td>
																		HarmCode :
																	</td>
																	<td class="splitBorder_r_h">
																		<asp:Label ID="lblHarmCode" runat="server"></asp:Label>
																	</td>
																	<td colspan="2">
																		Corp Fixed Velocity :
																	</td>
																	<td class="splitBorder_r_h">
																		<asp:Label ID="lblVelocity" runat="server"></asp:Label>
																	</td>
																</tr>
																<tr>
																</tr>
															</table>
															<%--End Item Details--%>
														</td>
													</tr>
													<tr>
														<td>
															<div class="blueBorder shadeBgDown">
																<%--Item Shipment Totals--%>
																<table border="0" cellspacing="2" cellpadding="0" style="height: 30px">
																	<tr>
																		<td>
																			<strong>Total PO lines</strong>
																		</td>
																		<td style="width: 40px">
																			:
																			<asp:Label ID="lblTotlaPo" runat="server" Text=""></asp:Label>
																		</td>
																		<td>
																			<strong>Qty Pallet Partner</strong>
																		</td>
																		<td style="width: 40px">
																			:
																			<asp:Label ID="lblPallet" runat="server" Text="0"></asp:Label>
																		</td>
																		<td>
																			<strong>Total Qty</strong>
																		</td>
																		<td style="width: 40px">
																			:
																			<asp:Label ID="lblTotQty" runat="server" Text=""></asp:Label>
																		</td>
																		<td>
																			<strong>Qty [Non PP]</strong>
																		</td>
																		<td style="width: 40px">
																			:
																			<asp:Label ID="lblNonPallet" runat="server" Text="0"></asp:Label>
																		</td>
																		<td>
																			<strong>Other PO Qty</strong>
																		</td>
																		<td style="width: 40px">
																			:
																			<asp:Label ID="lblOther" runat="server" Text="0"></asp:Label>
																		</td>
																	</tr>
																</table>
																<%--End Item Shipment Totals--%>
															</div>
														</td>
													</tr>
													<tr>
														<td class="blueBorder">
															<div id="div-datagrid" class="Sbar" align="center" style="overflow-x: hidden; overflow-y: visible;
																position: relative; top: 0px; left: 0px; height: 257px; width: 100%; border: 0px solid;">
																<%--Vendor Shipment Details Panel--%>
																<asp:Panel ID="VendorPanel" runat="server" Width="100%" Height="100%" ScrollBars="Vertical">
																	<asp:DataGrid CssClass="grid" Width="96%" runat="server" ID="dgVendor" GridLines="both"
																		AutoGenerateColumns="false" UseAccessibleHeader="true" OnItemDataBound="dgVendor_ItemDataBound"
																		OnItemCommand="dgVendor_ItemCommand" OnSortCommand="dgVendor_SortCommand" AllowSorting="True">
																		<HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
																		<ItemStyle CssClass="gridItem" Height="20px" />
																		<AlternatingItemStyle CssClass="zebra" Height="20px" />
																		<FooterStyle CssClass="lightBlueBg" />
																		<Columns>
																			<asp:TemplateColumn HeaderText="Vendor" SortExpression="Vendor">
																				<ItemTemplate>
																					<asp:LinkButton ID="lnkVendor" Font-Underline="true" CommandName="Action" runat="server"
																						Text='<%#DataBinder.Eval(Container,"DataItem.Vendor")%>'></asp:LinkButton>
																					<asp:Label ID="lblVendor" runat="server" Text='<%#DataBinder.Eval(Container,"DataItem.Vendor")%>'></asp:Label>
																					<asp:HiddenField ID="hidItemNo" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.ItemNo")%>' />
																				</ItemTemplate>
																				<ItemStyle HorizontalAlign="Center" Width="50px" />
																			</asp:TemplateColumn>
																			<asp:BoundColumn SortExpression="PO#" DataField="PO#" HeaderText="PO#">
																				<ItemStyle CssClass="Left5pxPadd" Width="50px" />
																			</asp:BoundColumn>
																			<asp:BoundColumn DataField="Qty" DataFormatString="{0:#,##0}" HeaderText="Qty" SortExpression="Qty">
																				<ItemStyle HorizontalAlign="Right" Width="50px" />
																			</asp:BoundColumn>
																			<asp:BoundColumn DataField="Lbs" DataFormatString="{0:#,##0.00}" HeaderText="Lbs"
																				SortExpression="Lbs">
																				<ItemStyle HorizontalAlign="Right" Width="50px" />
																			</asp:BoundColumn>
																			<asp:BoundColumn DataField="Landing Port" SortExpression="[Landing Port]" HeaderText="Lading Port">
																				<ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Left" Width="70px" />
																			</asp:BoundColumn>
																			<asp:BoundColumn DataField="Remaining Qty" SortExpression="[Remaining Qty]" HeaderText="Remain Qty">
																				<ItemStyle HorizontalAlign="Right" Width="70px" />
																			</asp:BoundColumn>
																			<asp:BoundColumn DataField="Sts Code" SortExpression="[Sts Code]" HeaderText="Sts Code">
																				<ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Left" Width="50px" />
																			</asp:BoundColumn>
																			<asp:BoundColumn Visible="False" DataField="PFC Destination" HeaderText="PFC Destination">
																				<ItemStyle HorizontalAlign="Left" Width="100px" />
																			</asp:BoundColumn>
																			<asp:BoundColumn DataField="BrDesc" HeaderText="PFC Dest." SortExpression="BrDesc">
																				<ItemStyle HorizontalAlign="Center" Width="60px" />
																			</asp:BoundColumn>
																			<asp:BoundColumn DataField="MfgPlant" HeaderText="Mfg" SortExpression="MfgPlant">
																				<ItemStyle HorizontalAlign="Center" Width="60px" />
																			</asp:BoundColumn>
																		</Columns>
																	</asp:DataGrid>
																	<asp:Label ID="lblVendormsg" Font-Bold="true" runat="server" Text="No Records Found"></asp:Label>
																	<asp:HiddenField ID="hidVendor" runat="server" />
																	<asp:HiddenField ID="hidPO" runat="server" />
																	<asp:HiddenField ID="hidMfgPlant" runat="server" />
																	<input type="hidden" id="hidSortVendor" runat="server" />
																</asp:Panel>
																<%--End Vendor Shipment Details Panel--%>
															</div>
														</td>
													</tr>
												</table>
											</ContentTemplate>
										</asp:UpdatePanel>
										<%--End Vendor Item and Shipment Details Panel--%>
									</td>
								</tr>
								<tr>
									<td valign="top" style="padding-top: 2px">
										<%--Ready To Ship Action Panel--%>
										<asp:UpdatePanel ID="pnlAction" RenderMode="Block" runat="server" UpdateMode="conditional">
											<ContentTemplate>
												<div class="blueBorder">
													<table width="100%" cellpadding="0" cellspacing="0" border="0" class="blueBorder lightBlueBg"
														style="border-left: none; border-right: none; border-top: none">
														<tr>
															<td>
																<span style="color: #CC0000; font-size: 18px; margin: 0px; padding: 0px; font-weight: normal;
																	line-height: 35px; margin-left: 10px;">Ready To Ship Actions</span></td>
															<td align="right">
																<asp:ImageButton runat="server" ID="ibtnClose" OnClientClick="javascript:return GetStatus();"
																	ImageUrl="~/ReadyToShip/Common/Images/close.jpg" OnClick="ibtnClose_Click" />
															</td>
															<tr>
													</table>
													<div id="div2" class="Sbar" align="left" style="overflow-x: hidden; overflow-y: auto;
														position: relative; top: 0px; left: 0px; height: 70px; width: 100%; border: 0px solid;">
														<asp:Panel ID="pnlActions" runat="server">
															<asp:DataGrid CssClass="grid" Width="98%" ID="dgAction" GridLines="both" runat="server"
																AutoGenerateColumns="false" UseAccessibleHeader="true" OnItemDataBound="dgAction_ItemDataBound"
																OnItemCommand="dgAction_ItemCommand" AllowSorting="True" ShowFooter="False">
																<HeaderStyle CssClass="gridHeader2" HorizontalAlign="center" Wrap="False" />
																<ItemStyle CssClass="gridItem" Wrap="False" />
																<AlternatingItemStyle CssClass="zebra" />
																<FooterStyle CssClass="lightBlueBg" />
																<Columns>
																	<asp:BoundColumn DataField="BrDesc" HeaderText="PFC Loc"></asp:BoundColumn>
																	<asp:BoundColumn DataField="PFCLoc" HeaderText="Br" Visible="false"></asp:BoundColumn>
																	<asp:BoundColumn DataField="Qty" HeaderText="Qty"></asp:BoundColumn>
																	<asp:BoundColumn DataField="Lbs" HeaderText="Lbs"></asp:BoundColumn>
																	<asp:BoundColumn DataField="Status Code" HeaderText="Sts Code"></asp:BoundColumn>
																	<asp:BoundColumn DataField="Vendor" HeaderText="Vendor"></asp:BoundColumn>
																	<asp:BoundColumn DataField="PO #" HeaderText="PO#"></asp:BoundColumn>
																	<asp:BoundColumn DataField="Leading Port" HeaderText="Lading Port"></asp:BoundColumn>
																	<asp:TemplateColumn HeaderText="Action Qty">
																		<ItemTemplate>
																			<asp:TextBox ID="txtActQty" onfocus="javascript:this.select();" onkeypress="javascript:ActionEnter(this);"
																				onblur="javascript:CallClick(this);" runat="server" CssClass="FormControls" Width="60px"
																				Text='<%#DataBinder.Eval(Container,"DataItem.Action Qty") %>'></asp:TextBox>
																			<asp:Button ID="btnAction" CommandName="ActionQty" runat="server" Style="display: none;" />
																			<asp:HiddenField ID="hidId" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.ID") %>' />
																			<asp:HiddenField ID="hidItem" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.ItemNo") %>' />
																			<asp:HiddenField ID="hidCurrentQty" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.Action Qty") %>' />
																			<asp:HiddenField ID="hidGrossWgt" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.GrossWght") %>' />
																		</ItemTemplate>
																	</asp:TemplateColumn>
																	<asp:BoundColumn DataField="Hold" HeaderText="Hold"></asp:BoundColumn>
																</Columns>
															</asp:DataGrid>
														</asp:Panel>
														<asp:HiddenField ID="hidItem" runat="server" />
														<div align="center">
															<asp:Label ID="lblFlag" runat="server" Text="No Record Found" Font-Bold="true" ForeColor="red"></asp:Label></div>
													</div>
												</div>
											</ContentTemplate>
										</asp:UpdatePanel>
										<%--Ready To Ship Action Panel--%>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td class="blueBorder" colspan="2" valign="top">
							<%--Pager Panel--%>
							<asp:UpdatePanel ID="pnlPager" runat="server" UpdateMode="conditional">
								<ContentTemplate>
									<table class="BluBg" id="Table1" height="1" cellspacing="0" cellpadding="0" width="100%"
										border="0">
										<tr>
											<td colspan="2" height="8px">
												<table id="Table2" cellspacing="0" height="1" cellpadding="0" width="100%" border="0">
													<tr>
														<td width="10%" height="8px">
															<table id="Table3" cellspacing="0" cellpadding="2" width="40%" border="0">
																<tr>
																	<td>
																		<asp:ImageButton ID="ibtnFirst" runat="server" ImageUrl="../Common/Images/PageFirst.jpg"
																			OnClick="ibtnFirst_Click" /></td>
																	<td>
																		<asp:ImageButton ID="ibtnPrevious" runat="server" ImageUrl="../Common/Images/PagePrev.jpg"
																			OnClick="ibtnPrevious_Click" /></td>
																	<td>
																		<div class="TabHead">
																			<strong>&nbsp;&nbsp;&nbsp;GoTo</strong></div>
																	</td>
																	<td>
																		<asp:DropDownList ID="ddlPages" runat="server" AutoPostBack="True" CssClass="PageCombo"
																			Width="50px" OnSelectedIndexChanged="ddlPages_SelectedIndexChanged">
																		</asp:DropDownList></td>
																	<td>
																		<asp:ImageButton ID="btnNext" runat="server" ImageUrl="../Common/Images/PageNext.jpg"
																			OnClick="btnNext_Click" /></td>
																	<td>
																		<asp:ImageButton ID="btnLast" runat="server" ImageUrl="../Common/Images/PageLast.jpg"
																			OnClick="btnLast_Click" /></td>
																</tr>
															</table>
														</td>
														<td align="center">
															<table width="100%" border="0" cellspacing="0" cellpadding="0">
																<tr>
																	<td width="40%" align="left">
																		<table id="Table6" cellspacing="0" cellpadding="0" border="0" height="1">
																			<tbody>
																				<tr>
																					<td align="center">
																						<asp:Label ID="lblPage" runat="server" CssClass="TabHead">Page(s):</asp:Label></td>
																					<td align="center" style="width: 9px" class="LeftPadding">
																						<asp:Label ID="lblCurrentPage" runat="server" CssClass="TabHead">1</asp:Label></td>
																					<td align="center" class="LeftPadding">
																						<asp:Label ID="lblOf" runat="server" CssClass="TabHead">of</asp:Label></td>
																					<td align="center" class="LeftPadding">
																						<asp:Label ID="lblTotalPage" runat="server" CssClass="TabHead">100</asp:Label></td>
																				</tr>
																			</tbody>
																		</table>
																	</td>
																	<td width="60%" align="right">
																		<table id="TblPagerRecord" cellspacing="0" cellpadding="0" border="0" height="1">
																			<tr>
																				<td style="height: 17px">
																					<asp:Label ID="lblRecords" runat="server" CssClass="TabHead">Record(s):</asp:Label></td>
																				<td style="height: 17px" class="LeftPadding">
																					<asp:Label ID="lblCurrentPageRecCount" runat="server" CssClass="TabHead">100</asp:Label></td>
																				<td style="height: 17px" class="LeftPadding">
																					<asp:Label ID="Label1" runat="server" CssClass="TabHead">-</asp:Label></td>
																				<td style="height: 17px" class="LeftPadding">
																					<asp:Label ID="lblCurrentTotalRec" runat="server" CssClass="TabHead">100</asp:Label></td>
																				<td style="height: 17px" class="LeftPadding">
																					<asp:Label ID="lblOf1" runat="server" CssClass="TabHead">of</asp:Label></td>
																				<td style="height: 17px" class="LeftPadding">
																					<asp:Label ID="lblTotalNoOfRec" runat="server" CssClass="TabHead">100</asp:Label></td>
																			</tr>
																		</table>
																	</td>
																</tr>
															</table>
														</td>
														<td align="right" width="35%">
															<table id="Table4" height="0%" cellspacing="0" cellpadding="2" border="0">
																<tr>
																	<td colspan="3">
																		<asp:CompareValidator Style="display: none" ID="cpvGotoPage" runat="server" ErrorMessage="Enter Integer values alone"
																			CssClass="Required" ForeColor=" " ControlToValidate="txtGotoPage" Operator="DataTypeCheck"
																			Type="Integer"></asp:CompareValidator>
																	</td>
																</tr>
																<tr>
																	<td align="right" class="Left2pxPadd">
																		<asp:Label ID="lblGotoPAge" runat="server" CssClass="TabHead">Go to Page # :</asp:Label></td>
																	<td class="Left2pxPadd">
																		<asp:TextBox ID="txtGotoPage" onkeypress="javascript:if(event.keyCode==13){if(this.value!=''){document.getElementById('btnGo').click();return false;}}else{ValdateNumber();}"
																			runat="server" CssClass="FormControls" Width="25px">0</asp:TextBox></td>
																	<td class="Left2pxPadd">
																		<asp:ImageButton ID="btnGo" runat="server" ImageUrl="~/Common/Images/Go.gif" OnClick="btnGo_Click" /></td>
																</tr>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</ContentTemplate>
							</asp:UpdatePanel>
							<%--End Pager Panel--%>
						</td>
					</tr>
				</table>
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<table width="100%" cellpadding="0" cellspacing="0" class="BluBg buttonBar">
								<tr>
									<td width="50%" align="left">
										<asp:UpdateProgress ID="upPanel" runat="server">
											<ProgressTemplate>
												<span style="padding-left: 5px" class="TabHead">Loading...</span>
											</ProgressTemplate>
										</asp:UpdateProgress>
										<asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
											<ContentTemplate>
												<asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
													runat="server" Text=""></asp:Label>
											</ContentTemplate>
										</asp:UpdatePanel>
									</td>
									<td align="right" style="padding-right: 8px;">
										<asp:UpdatePanel runat="server" ID="pnlCommit" UpdateMode="conditional">
											<ContentTemplate>
												<asp:ImageButton ID="btnAccept" Style="display: none;" runat="server" ImageUrl="Common/Images/accept.jpg"
													OnClick="btnAccept_Click" />
												<img src="Common/Images/close.jpg" id="imgClose" onclick="javascript:window.close();" />
											</ContentTemplate>
										</asp:UpdatePanel>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<%-- <uc2:BottomFrame ID="BottomFrame1" runat="server" />--%>
							<uc2:BottomFooter ID="BottomFrame2" Title="Review Ready To Ship Recommendations"
								runat="server" />
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
</body>
</html>
