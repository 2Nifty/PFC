<%@ Control Language="C#" AutoEventWireup="true" CodeFile="minipager.ascx.cs" Inherits="PFC.SOE.UserControls.minipager" %>
<script language="javascript">
function CheckText(chk)
{
    var textChk=chk;    
    textChk= document.getElementById("Pager1_txtGotoPage").value;
    if(textChk=='0')
    {
       
        return false;
    }
    else
    {
        return true;
    }
}
</script>

<table class="PageBg"  id="Table1" height="1" cellspacing="0" cellpadding="0"
    border="0">
    <tr>
        <td style="height: 50%">
            <table id="Table2" cellspacing="0" height="1" cellpadding="0" width="100%" border="0">
                <tr>
                    <td width="10%">
                        <table id="Table3" cellspacing="0" cellpadding="2" width="50%" border="0">
                            <tr>
                                <td>
                                    <asp:ImageButton ID="ibtnFirst" runat="server"  ImageUrl="~/Common/Images/btnlast.jpg" OnClick="ibtnFirst_Click"></asp:ImageButton></td>
                                <td>
                                    <asp:ImageButton ID="ibtnPrevious" runat="server"  ImageUrl="~/Common/Images/btnback.jpg" OnClick="ibtnPrevious_Click"></asp:ImageButton></td>
                                <td>
                                    <asp:DropDownList ID="ddlPages" runat="server" AutoPostBack="True" CssClass="formCtrl"
                                        Width="50px" OnSelectedIndexChanged="ddlPages_SelectedIndexChanged">
                                        <asp:ListItem Value="-1" Selected="True">--Choose Page--</asp:ListItem>
                                    </asp:DropDownList></td>
                                <td>
                                    <asp:ImageButton ID="btnNext" runat="server" ImageUrl="~/Common/Images/btnforward.jpg" OnClick="ImageButton1_Click" ></asp:ImageButton></td>
                                <td>
                                    <asp:ImageButton ID="btnLast" runat="server"  ImageUrl="~/Common/Images/btnfirst.jpg" OnClick="btnLast_Click" ></asp:ImageButton></td>
                            </tr>
                        </table>
                    </td>
                    <td>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>  
                        <td align="center" style="width: 231px">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>                             
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
                
                </tr>
            </table>
        </td>
    </tr>
</table>
