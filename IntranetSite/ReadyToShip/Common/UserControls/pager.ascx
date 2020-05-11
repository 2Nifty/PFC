<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Pager.ascx.cs" Inherits="Novantus.Umbrella.UserControls.Pager" %>
<script language=javascript>
function CheckText(chk)
{
    var textChk=chk;
    alert(textChk);
    textChk= document.getElementById("Pager1_txtGotoPage").value;
    if(textChk=='0')
    {
        alert(textChk);
        return false;
    }
    else
    {
        return true;
    }
}
//
// Function to Preform action on Enter Keypress Event
//
function ClickButton(e, buttonid)
{ 
    var bt = document.getElementById(buttonid); 
    if (typeof bt == 'object'){ 
        if(navigator.appName.indexOf("Netscape")>(-1)){ 
                if (e.keyCode == 13){ 
                    bt.click(); 
                    return false; 
                } 
        } 
        if (navigator.appName.indexOf("Microsoft Internet Explorer")>(-1)){ 
                if (event.keyCode == 13){ 
                    bt.click(); 
                    return false; 
                } 
        } 
    } 
} 
</script>
<TABLE class="lightBlueBg" id="Table1" height="1" cellSpacing="0" cellPadding="0" width="100%"
	border="0">
	<TR>
		<TD colSpan="2" height="50%">
			<TABLE id="Table2" cellSpacing="0" height="1" cellPadding="0" width="100%" border="0">
				<TR>
					<TD width="10%" >
						<TABLE id="Table3" cellSpacing="0" cellPadding="2" width="40%" border="0">
							<TR>
								<TD><asp:ImageButton ID="ibtnFirst" runat="server" ImageUrl="../Images/PageFirst.jpg" OnClick="ibtnFirst_Click" /></TD>
								<TD><asp:ImageButton ID="ibtnPrevious" runat="server" ImageUrl="../Images/PagePrev.jpg" OnClick="ibtnPrevious_Click"  /></TD>
                                <td ><div class=TabHead><strong>&nbsp;&nbsp;&nbsp;GoTo</strong></div></td>
								<TD>
									<asp:DropDownList id="ddlPages" runat="server" AutoPostBack="True" CssClass="PageCombo" Width="50px" OnSelectedIndexChanged="ddlPages_SelectedIndexChanged" >
									<asp:ListItem Value="-1" Selected="True">--Choose Page--</asp:ListItem>
									</asp:DropDownList></TD>
								<TD><asp:ImageButton ID="btnNext" runat="server" ImageUrl="../Images/PageNext.jpg" OnClick="ImageButton1_Click" /></TD>
								<TD><asp:ImageButton ID="btnLast" runat="server" ImageUrl="../Images/PageLast.jpg" OnClick="btnLast_Click" /></TD>
							</TR>
						</TABLE>
					</TD>
					<TD align="center" >
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="40%" align="left">
									<TABLE id="Table6" cellSpacing="0" cellPadding="0" border="0" height="1">
										<TBODY>
											<TR>
												<TD align="center"><asp:Label id="lblPage" runat="server" CssClass="TabHead">Page(s):</asp:Label></TD>
												<TD align="center" style="width: 9px" class=LeftPadding><asp:Label id="lblCurrentPage" runat="server" CssClass="TabHead">1</asp:Label></TD>
												<TD align="center" class=LeftPadding><asp:Label id="lblOf" runat="server" CssClass="TabHead">of</asp:Label></TD>
												<TD align="center" class=LeftPadding><asp:Label id="lblTotalPage" runat="server" CssClass="TabHead">100</asp:Label></TD>
											</TR>
										</TBODY>
									</TABLE>
								</td>
								<td width="60%" align="right">
									<TABLE id="TblPagerRecord" cellSpacing="0" cellPadding="0" border="0" height="1">
										<tr>
											<td style="height: 17px"><asp:Label id="lblRecords" runat="server" CssClass="TabHead">Record(s):</asp:Label></td>
											<td style="height: 17px" class=LeftPadding><asp:Label id="lblCurrentPageRecCount" runat="server" CssClass="TabHead">100</asp:Label></td>
											<td style="height: 17px" class=LeftPadding><asp:Label id="Label1" runat="server" CssClass="TabHead">-</asp:Label></td>
											<td style="height: 17px" class=LeftPadding><asp:Label id="lblCurrentTotalRec" runat="server" CssClass="TabHead">100</asp:Label></td>											
											<td style="height: 17px" class=LeftPadding><asp:Label id="lblOf1" runat="server" CssClass="TabHead">of</asp:Label></td>
											<td style="height: 17px" class=LeftPadding><asp:Label id="lblTotalNoOfRec" runat="server" CssClass="TabHead">100</asp:Label></td>
										</tr>
									</TABLE>
								</td>
							</tr>
						</table>
					</TD>
					<TD align="right" width="35%" >
						<TABLE id="Table4" height="0%" cellSpacing="0" cellPadding="2" border="0">
							<tr>
								<td colspan="3">
									<asp:CompareValidator style="DISPLAY:none" id="cpvGotoPage" runat="server" ErrorMessage="Enter Integer values alone"
										CssClass="Required" ForeColor=" " ControlToValidate="txtGotoPage" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator><div></div>
									<asp:RangeValidator style="DISPLAY:none" id="rnvGotoPage" runat="server" ErrorMessage="Value is out of range"
										CssClass="Required" ForeColor=" " ControlToValidate="txtGotoPage" Type="Integer" MinimumValue="0"
										MaximumValue="0"></asp:RangeValidator></td>
							</tr>
							<TR>
								<TD  align="right" class="Left2pxPadd">
									<asp:Label id="lblGotoPAge" runat="server" CssClass="TabHead">Go to Page # :</asp:Label></TD>
								<TD class="Left2pxPadd">
									<asp:TextBox id="txtGotoPage" runat="server" CssClass="FormControls" Width="25px">0</asp:TextBox></TD>
								<TD class="Left2pxPadd">
                                    <asp:ImageButton ID="btnGo" runat="server" ImageUrl="~/Common/Images/Go.gif" OnClick="btnGo_Click" /></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
            </TD>
	</TR>
</TABLE>
