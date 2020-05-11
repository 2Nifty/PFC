<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PendingOrdersAndQuotes.aspx.cs"
    Inherits="PendingOrdersAndQuotes" %>

<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/SubHeader.ascx" TagName="CEHeader" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SOE - Pending Orders</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="Common/JavaScript/Common.js"></script>

    <script type="text/javascript">
// JScript File
function BindOrderEntryForm(soNumber)
{
    var txtSONumber = window.opener.parent.bodyFrame.document.getElementById("CustDet_txtSONumber"); 
    window.opener.parent.bodyFrame.document.getElementById("CustDet_hidPreviousValue").value = "";          
    if(txtSONumber.value=="")
    {
        txtSONumber.value = soNumber;
      window.opener.parent.bodyFrame.LoadDetails(txtSONumber.value);
        window.close();
        txtSONumber.focus();
    } 
    else
    {
        if(ShowYesorNo('Already SO # '+ txtSONumber.value+ ' is opened by this user.Do you want to continue with this order?'))
        {
            PendingOrdersAndQuotes.ReleaseLock();
            txtSONumber.value = soNumber;
            window.opener.parent.bodyFrame.LoadDetails(txtSONumber.value);
            window.close();
            txtSONumber.focus();
        }       
    }
    return false;
}

function LoadCustomerLookup(_custNo)
{   
    var Url = "CustomerList.aspx?Customer=" + _custNo +"&ctrlName=Pending";
    window.open(Url,'CustomerList' ,'height=485,width=855,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (855/2))+',resizable=NO,scrollbars=YES','');
}
    </script>

    <script language="vbscript">
    Function ShowYesorNo(strMsg)
    Dim intBtnClick
    intBtnClick=msgbox(strMsg,vbyesno,"Sales Order Entry")
    if intBtnClick=6 then 
        ShowYesorNo= true 
    else 
        ShowYesorNo= false
     end if
    end Function
    </script>

</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';">
    <form id="form1" runat="server" defaultbutton="ibtnSearch">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table border="0" class="HeaderPanels" cellpadding="0" cellspacing="0" style="width: 100%;
            height: 100%">
            <tr>
                <td class="lightBg" style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px;">
                    <asp:UpdatePanel ID="pnlPendingOrderEntry" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table height="90" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="width: 100px;">
                                        <asp:Label ID="Label1" runat="server" Text="Customer Number" Font-Bold="True" Width="106px"></asp:Label></td>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td>
                                                    <asp:TextBox ID="txtCustomerNumber" CssClass="lbl_whitebox" runat="server" AutoPostBack="True"
                                                        OnTextChanged="txtCustomerNumber_TextChanged"></asp:TextBox>
                                                    <asp:HiddenField ID="hidCustNo" runat="server"></asp:HiddenField>
                                                    <asp:Button runat="server" ID="btnCustNo" OnClick="txtCustomerNumber_TextChanged"
                                                        Style="display: none;" />
                                                </td>
                                                <td>
                                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtCustomerNumber"
                                                        Display="Dynamic" ErrorMessage="*Required" Width="52px"></asp:RequiredFieldValidator>--%></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 50px">
                                    </td>
                                    <td style="width: 30px;">
                                        <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Order Type" Width="70px"></asp:Label></td>
                                    <td colspan="2" style="width: 30px;">
                                        <asp:DropDownList ID="ddlOrderType" CssClass="lbl_whitebox" runat="server" Height="20"
                                            Width="150">
                                        </asp:DropDownList></td>
                                    <td style="width: 50px">
                                        &nbsp;
                                    </td>
                                    <td style="width: 50px">
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Location" Width="106px"></asp:Label></td>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td style="width: 100px">
                                                    <asp:DropDownList ID="ddlLocation" CssClass="lbl_whitebox" runat="server" Height="20"
                                                        Width="130">
                                                    </asp:DropDownList></td>
                                                <td>
                                                   </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="Start Date" Width="70px"></asp:Label></td>
                                    <td>
                                        <uc3:novapopupdatepicker ID="dtpStartDt" runat="server" />
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label6" runat="server" Font-Bold="True" Text="User ID" Width="106px"></asp:Label></td>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td style="width: 100px">
                                                    <asp:DropDownList ID="ddlUserID" CssClass="lbl_whitebox" runat="server" Height="20"
                                                        Width="130">
                                                    </asp:DropDownList></td>
                                                <td>
                                                   </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="height: 16px">
                                    </td>
                                    <td style="height: 16px;">
                                        <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="End Date" Width="70px"></asp:Label></td>
                                    <td style="height: 16px;">
                                        <uc3:novapopupdatepicker ID="dtpEndDt" runat="server" />
                                    </td>
                                    <td style="height: 16px;" align="right">
                                        <asp:ImageButton ID="ibtnSearch" runat="server" ImageUrl="~/Common/Images/Searcharrow.gif"
                                            OnClick="ibtnSearch_Click" /></td>
                                    <td style="height: 16px">
                                    </td>
                                    <td style="height: 16px;">
                                        <asp:ImageButton ID="ibtnCancel" runat="server" CausesValidation="false" ImageUrl="~/Common/Images/cancel.gif"
                                            OnClick="ibtnCancel_Click" /></td>
                                    <td style="padding-left: 5px; height: 16px;">
                                        <asp:ImageButton ID="ibtnHelp" runat="server" ImageUrl="~/Common/Images/help.gif" /></td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="padding: 5PX;">
                    <asp:UpdatePanel ID="pnlPendingOrderGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table cellpadding="0" cellspacing="0" width="100%" align="center">
                                <tr>
                                    <td colspan="2">
                                        <div class="Sbar" oncontextmenu="Javascript:return false;" id="div-datagrid" style="overflow-x: auto;
                                            overflow-y: auto; position: relative; top: 0px; left: 0px; height: 270px; border: 1px solid #88D2E9;
                                            width: 695px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                            scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                            scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94">
                                            <asp:GridView ShowFooter="false" ID="gvPendingOrders" PagerSettings-Visible="false"
                                                Width="850" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="true"
                                                AutoGenerateColumns="false" OnRowCommand="gvPendingOrders_RowCommand" OnSorting="gvPendingOrders_Sorting">
                                                <HeaderStyle HorizontalAlign="center" Height="20px" CssClass="GridHead" Font-Bold="true"
                                                    BackColor="#DFF3F9" />
                                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                                <RowStyle CssClass="item" Wrap="False" BackColor="#FFFFFF" Height="20px" BorderWidth="1px" />
                                                <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="20px" BorderWidth="1px" />
                                                <Columns>
                                                    <asp:BoundField HeaderText="Order Type" DataField="OrderType" SortExpression="OrderType"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Ship Loc" DataField="ShipLoc" SortExpression="ShipLoc"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:TemplateField HeaderText="Order No." SortExpression="OrderNo">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="red"
                                                                Style="padding-left: 5px" runat="server" CommandName="Edits" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"pSOHeaderID") %>'><%# DataBinder.Eval(Container.DataItem,"OrderNo") %></asp:LinkButton>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="50px" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField HeaderText="Customer No." DataField="SellToCustNo" SortExpression="SellToCustNo"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="60px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Customer Name" DataField="SellToCustName" SortExpression="SellToCustName"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="150px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Order Amt." DataField="TotalOrder" SortExpression="TotalOrder"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Order Date" DataField="OrderDt" SortExpression="OrderDt"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Cust Req’d" DataField="CustReqDt" SortExpression="CustReqDt"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Status" DataField="OrderStatus" SortExpression="OrderStatus"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Entry ID" DataField="EntryID" SortExpression="EntryID"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Entry Date" DataField="EntryDt" SortExpression="EntryDt"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Deleted Date" DataField="DeleteDt" SortExpression="DeleteDt"
                                                        ItemStyle-CssClass="Left5pxPadd" Visible="false">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                </Columns>
                                            </asp:GridView>
                                            <input id="hidSort" type="hidden" name="Hidden1" runat="server">
                                            <input id="hidPrintURL" type="hidden" name="hidPrintURL" runat="server">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="right" width="100%" id="tdButton" class="commandLine splitborder_t_v splitborder_b_v"
                    style="height: 20px; background-position: -80px  left;">
                    <asp:UpdatePanel ID="pnlStatusMessage" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" cellpadding="0" cellspacing="0" style="padding-right: 5px; padding-top: 2px;
                                padding-bottom: 2px">
                                <tr>
                                    <td align="left" width="85%">
                                        <asp:UpdateProgress ID="pnlProgress" runat="server">
                                            <ProgressTemplate>
                                                <span class="TabHead">Loading...</span></ProgressTemplate>
                                        </asp:UpdateProgress>
                                        <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                    </td>
                                    <td valign="bottom">
                                        <asp:ImageButton ID="ibtnDeletedItem" ImageUrl="~/Common/Images/expand.gif" ToolTip="Click here to show deleted orders"
                                            runat="server" OnClick="ibtnDeletedItem_Click1" /></td>
                                    <td colspan="3">
                                        <uc3:PrintDialogue ID="PrintDialogue1" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" width="85%">
                                    </td>
                                    <td colspan="4">
                                        <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" /></td>
                                    <td>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="FooterC" Title="Pending Orders & Quotes" runat="server"></uc2:Footer>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
