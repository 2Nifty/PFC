<%@ Control Language="C#" AutoEventWireup="false" CodeFile="Pager.ascx.cs" Inherits="Novantus.Umbrella.UserControls.Pager" %>

<script language="javascript">
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

<table class="PageHd" id="Table1" height="1" cellspacing="0" cellpadding="0" width="100%"
    border="0">
    <tr>
        <td colspan="2" height="50%">
            <table id="Table2" cellspacing="0" height="1" cellpadding="0" width="100%" border="0">
                <tr>
                    <td width="10%">
                        <table id="Table3" cellspacing="0" cellpadding="2" width="40%" border="0">
                            <tr>
                                <td>
                                    <asp:ImageButton ID="ibtnFirst" alt="Go to first page" runat="server"  ImageUrl="~/Common/Images/btnlast.jpg" OnClick="ibtnFirst_Click"></asp:ImageButton></td>
                                <td>
                                    <asp:ImageButton ID="ibtnPrevious" alt="Go to previous page" runat="server"  ImageUrl="~/Common/Images/btnback.jpg" OnClick="ibtnPrevious_Click"></asp:ImageButton></td>
                                <td>
                                    <asp:DropDownList ID="ddlPages" alt="Select page #" runat="server" AutoPostBack="True" CssClass="cnt"
                                        Width="50px" OnSelectedIndexChanged="ddlPages_SelectedIndexChanged">
                                        <asp:ListItem Value="-1" Selected="True">--Choose Page--</asp:ListItem>
                                    </asp:DropDownList></td>
                                <td>
                                    <asp:ImageButton ID="btnNext" alt="Go to next page" runat="server" ImageUrl="~/Common/Images/btnforward.jpg" OnClick="ImageButton1_Click" ></asp:ImageButton></td>
                                <td>
                                    <asp:ImageButton ID="btnLast" alt="Go to last page" runat="server"  ImageUrl="~/Common/Images/btnfirst.jpg" OnClick="btnLast_Click" ></asp:ImageButton></td>
                            </tr>
                        </table>
                    </td>
                    <td align="center">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="50%" align="left">
                                    <table id="Table6" cellspacing="0" cellpadding="0" border="0" height="1">
                                        <tbody>
                                            <tr>
                                                <td align="center">
                                                    &nbsp;&nbsp;
                                                    <asp:Label ID="lblPage" runat="server" CssClass="HeaderText">Page(s):</asp:Label>&nbsp;
                                                </td>
                                                <td align="center" style="width: 9px">
                                                    <asp:Label ID="lblCurrentPage" runat="server" CssClass="HeaderText">1</asp:Label></td>
                                                <td align="center">
                                                    &nbsp;<asp:Label ID="lblOf" runat="server" CssClass="HeaderText">of</asp:Label></td>
                                                <td align="center">
                                                    &nbsp;<asp:Label ID="lblTotalPage" runat="server" CssClass="HeaderText">100</asp:Label></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                                <td width="50%" align="right">
                                    <table id="Table5" cellspacing="0" cellpadding="0" border="0" height="1">
                                        <tr>
                                            <td style="height: 19px">
                                                <asp:Label ID="lblRecords" runat="server" CssClass="HeaderText">Record(s):</asp:Label></td>
                                            <td style="height: 19px">
                                                &nbsp;<asp:Label ID="lblCurrentPageRecCount" runat="server" CssClass="HeaderText">100</asp:Label></td>
                                            <td style="height: 19px">
                                                &nbsp;<asp:Label ID="Label1" runat="server" CssClass="HeaderText">-</asp:Label></td>
                                            <td style="height: 19px">
                                                &nbsp;<asp:Label ID="lblCurrentTotalRec" runat="server" CssClass="HeaderText">100</asp:Label></td>
                                            <td style="height: 19px">
                                                &nbsp;<asp:Label ID="lblOf1" runat="server" CssClass="HeaderText">of</asp:Label></td>
                                            <td style="height: 19px">
                                                &nbsp;<asp:Label ID="lblTotalNoOfRec" runat="server" CssClass="HeaderText">100</asp:Label></td>
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
                                        Type="Integer"></asp:CompareValidator><div>
                                        </div>
                                    <asp:RangeValidator Style="display: none" ID="rnvGotoPage" runat="server" ErrorMessage="Value is out of range"
                                        CssClass="Required" ForeColor=" " ControlToValidate="txtGotoPage" Type="Integer"
                                        MinimumValue="0" MaximumValue="0"></asp:RangeValidator></td>
                            </tr>
                            <tr>
                                <td class="HeaderText" align="right">
                                    <asp:Label ID="lblGotoPAge" runat="server">Go to Page # :</asp:Label></td>
                                <td>
                                    <asp:TextBox ID="txtGotoPage" runat="server" CssClass="cnt" Width="25px">0</asp:TextBox></td>
                                <td>
                                    <asp:ImageButton ID="btnGo" alt="Go to page" runat="server"  ImageUrl="~/Common/Images/Go.gif" OnClick="btnGo_Click" ></asp:ImageButton>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
