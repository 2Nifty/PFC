<%@ Control Language="C#" AutoEventWireup="false" CodeFile="Minpager.ascx.cs" Inherits="Novantus.Umbrella.UserControls.Pager" %>
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
</script>
<TABLE class="BluBg" id="Table1" height="1" cellSpacing="0" cellPadding="0" width="100%"
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
								<td width="60%" align="right" style="padding-right:10px">
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
				
				</TR>
			</TABLE>
            </TD>
	</TR>
</TABLE>
