<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SOFind.aspx.cs" Inherits="SOFind" %>

<%@ Register Src="Common/UserControls/Pager.ascx" TagName="Pager" TagPrefix="uc4" %>
<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/TwoDatePicker.ascx" TagName="TwoDatePicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SO Find</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>

    <script type="text/javascript">
    function LoadCustomerLookup(_custNo)
    {   
        var Url = "CustomerList.aspx?Customer=" + _custNo +"&ctrlName=SOFind";
        window.open(Url,'CustomerList' ,'height=485,width=855,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (855/2))+',resizable=NO,scrollbars=YES','');
    }
    function OpenQuoteWeightForm()
    {
        if(document.getElementById("txtCustomerNumber").value !="")
        {
            var hwnd=window.open('CustWeight.aspx?CustNumber='+document.getElementById("txtCustomerNumber").value ,'CustomerMaintenance','height=600,width=400,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (600/2))+',left='+((screen.width/2) - (400/2))+',resizable=no','');	
	        hwnd.focus();
	    }
	    else
	    {
           alert("Enter Customer Number");
           document.getElementById("txtCustomerNumber").focus();
        }
    }
    function BindOrderEntryForm(soNumber)
    {
        var txtSONumber = window.opener.parent.bodyFrame.document.getElementById("CustDet_txtSONumber"); 
        window.opener.parent.bodyFrame.document.getElementById("CustDet_hidPreviousValue").value = "";          
        if(txtSONumber.value=="")
        {
            window.blur();
            txtSONumber.value = soNumber;
            window.opener.parent.bodyFrame.LoadDetails(txtSONumber.value);
            //window.close();
            txtSONumber.focus();
        } 
        else
        {
            if(ShowYesorNo('Already SO # '+ txtSONumber.value+ ' is opened by this user.Do you want to continue with this order?'))
            {
                window.blur();
                SOFind.ReleaseLock();
                txtSONumber.value = soNumber;
                window.opener.parent.bodyFrame.LoadDetails(txtSONumber.value);
              //  window.close();
                txtSONumber.focus();
            }       
        }
        return false;
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
    <form id="form1" runat="server" defaultfocus="txtCustomerNumber">
        <asp:ScriptManager ID="ScriptManager1" AsyncPostBackTimeout="360000" EnablePartialRendering="true"
            runat="server">
        </asp:ScriptManager>
        <table border="0" cellpadding="0" cellspacing="2" style="width: 100%; height: 100%"
            class="HeaderPanels">
            <tr>
                <td width="100%">
                    <asp:UpdatePanel ID="upCustomerSearch" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td valign="bottom" class="SOFindHeaderPanels" style="padding-left: 4px; padding-top: 5px"
                                        width="50%">
                                        <asp:Panel ID="Panel1" runat="server" Width="100%" DefaultButton="ibtnHeaderFind">
                                            <table border="0" cellpadding="2" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblCuctomerCaption" runat="server" Text="Customer Number:" Font-Bold="True"
                                                            Width="125px"></asp:Label></td>
                                                    <td width="165">
                                                        <asp:TextBox ID="txtCustomerNumber" AutoPostBack="true" runat="server" CssClass="lbl_whitebox"
                                                            Width="130px" OnTextChanged="txtCustomerNumber_TextChanged" onkeydown="javascript:if(event.keyCode ==13)return event.keyCode = 9;"></asp:TextBox></td>
                                                    <td width="165" valign="bottom" style="vertical-align: bottom;">
                                                        <asp:ImageButton ID="ibtnQuoteWeight" ImageUrl="~/Common/Images/truck.jpg" Width="20px"
                                                            Height="18px" OnClientClick="javascript:OpenQuoteWeightForm();" ToolTip="Show Customer Scheduled to Ship Weight"
                                                            runat="server" />
                                                        <asp:Button ID="btnCustomer" runat="server" OnClick="txtCustomerNumber_TextChanged"
                                                            Style="display: none;" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle">
                                                        <asp:DropDownList ID="ddlHeaderType" CssClass="lbl_whitebox" Font-Bold="true" Height="20px"
                                                            AutoPostBack="true" Width="100%" runat="server" OnSelectedIndexChanged="ddlHeaderType_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtSOInvoiceNo" runat="server" CssClass="lbl_whitebox" Width="130px"></asp:TextBox>
                                                    </td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="Label1" runat="server" Text="User Id:" Font-Bold="True" Width="125px"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlUserId" CssClass="lbl_whitebox" Font-Bold="False" Height="20px"
                                                            Width="137px" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="Label2" runat="server" Text="Order Type:" Font-Bold="True" Width="125px"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlOrderType" CssClass="lbl_whitebox" Font-Bold="False" Height="20px"
                                                            Width="137px" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="Label3" runat="server" Text="Sales Location:" Font-Bold="True" Width="125px"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlSalesLocation" CssClass="lbl_whitebox" Font-Bold="False"
                                                            Height="20px" Width="137px" runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="ibtnHeaderFind" runat="server" ImageUrl="common/images/ShowButton.gif"
                                                            OnClick="ibtnHeaderFind_Click" /></td>
                                                </tr>
                                            </table>
                                            <asp:Button ID="btnDummy" runat="server" Visible="false" />
                                        </asp:Panel>
                                    </td>
                                    <td valign="top" class="SOFindHeaderPanels" width="50%" style="padding-left: 4px;
                                        padding-top: 5px">
                                        <table border="0" cellpadding="3" cellspacing="0" width="100%">
                                            <tr>
                                                <td width="120" style="font-weight: bold;">
                                                    Contract Number :</td>
                                                <td>
                                                    <asp:Label ID="lblContractNumber" runat="server" CssClass="lblColor"></asp:Label></td>
                                                <td rowspan="4" valign="bottom" align="right">
                                                    <asp:ImageButton ID="ibtCancel" runat="server" ImageUrl="common/images/cancel.gif"
                                                        OnClick="ibtCancel_Click" />
                                                    <asp:ImageButton ID="ibtnHelp" runat="server" ImageUrl="common/images/help.gif" /></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">
                                                    Price Code :</td>
                                                <td>
                                                    <asp:Label ID="lblPriceCode" runat="server" CssClass="lblColor"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">
                                                    Sales Rep Number :</td>
                                                <td>
                                                    <asp:Label ID="lblSalesRepNumber" runat="server" CssClass="lblColor"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">
                                                    Sales Rep Name :</td>
                                                <td>
                                                    <asp:Label ID="lblSalesRepName" runat="server" CssClass="lblColor"></asp:Label></td>
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
                <td class="lightBg" style="vertical-align: top; padding-bottom: 10px; padding-top: 10px;
                    padding-left: 0px">
                    <asp:UpdatePanel ID="upSOSearch" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td valign="bottom" style="padding-left: 4px;">
                                        <asp:Panel ID="Panel2" runat="server" Width="100%" DefaultButton="ibtnStatusFind">
                                            <table border="0" cellpadding="3" cellspacing="0">
                                                <tr>
                                                    <td colspan="3" align="center" style="padding-bottom: 8px; font-weight: bold;">
                                                        ----- Order Status Date Range -----</td>
                                                </tr>
                                                <tr>
                                                    <td style="font-weight: bold;">
                                                        Description</td>
                                                    <td colspan="2">
                                                        <asp:DropDownList ID="ddlSearchType" onchange="javascript:document.getElementById('dtpStatusStart_textBox').focus();"
                                                            CssClass="lbl_whitebox" Font-Bold="False" Height="20px" Width="100%" runat="server">
                                                        </asp:DropDownList></td>
                                                </tr>
                                                <tr>
                                                    <td style="font-weight: bold;">
                                                        Start Date
                                                    </td>
                                                    <td colspan="2">
                                                        <uc1:novapopupdatepicker ID="dtpStatusStart" runat="server" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="font-weight: bold;">
                                                        End Date
                                                    </td>
                                                    <td>
                                                        <uc1:novapopupdatepicker ID="dtpStatusEnd" runat="server" />
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="ibtnStatusFind" runat="server" ImageUrl="common/images/ShowButton.gif"
                                                            OnClick="ibtnStatusFind_Click" /></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3">
                                                        <asp:CustomValidator ID="cvDatePicker" runat="server" ErrorMessage="Invalid Date Range"
                                                            Display="dynamic" OnServerValidate="cvDatePicker_ServerValidate"></asp:CustomValidator></td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="upSOGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <div class="Sbar" oncontextmenu="Javascript:return false;" id="div-datagrid" style="overflow-x: auto;
                                            overflow-y: auto; position: relative; top: 0px; left: 0px; height: 210px; border: 1px solid #88D2E9;
                                            width: 705px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                            scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                            scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94">
                                            <asp:GridView ShowFooter="true" UseAccessibleHeader="true" ID="gvFind" PagerSettings-Visible="false"
                                                Width="985px" runat="server" AllowPaging="true" ShowHeader="true" AllowSorting="true"
                                                OnRowDataBound="gvFind_RowDataBound" AutoGenerateColumns="false" OnSorting="gvFind_Sorting"
                                                OnRowCommand="gvFind_RowCommand">
                                                <HeaderStyle HorizontalAlign="center" CssClass="GridHead" Font-Bold="true" BackColor="#DFF3F9" />
                                                <FooterStyle HorizontalAlign="Right" BackColor="#F0FFFF" Height="17px" />
                                                <RowStyle CssClass="item" Wrap="False" BackColor="#FFFFFF" Height="20px" BorderWidth="1px" />
                                                <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="20px" BorderWidth="1px" />
                                                <Columns>
                                                    <asp:BoundField HeaderText="Ship Loc" DataField="ShipLoc" SortExpression="ShipLoc"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:TemplateField HeaderText="SO No." SortExpression="SoNo">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#cc0000"
                                                                Style="padding-left: 5px" runat="server" CommandName="Edits" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"OrderID")%>'
                                                                Text='<%# DataBinder.Eval(Container.DataItem,"SoNo") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="30px" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField HeaderText="Inv. No." DataField="InvoiceNo" SortExpression="InvoiceNo"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="30px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="PO Ref" DataField="PORef" SortExpression="PORef" ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="80px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Order Amt" DataField="Amount" SortExpression="Amount"
                                                        HtmlEncode="false" DataFormatString="{0:#,##0.00}" ItemStyle-CssClass="Left5pxPadd"
                                                        ItemStyle-HorizontalAlign="Right">
                                                        <ItemStyle Width="40px" HorizontalAlign="right" Wrap="false" />
                                                    </asp:BoundField>
                                                    <%-- <asp:BoundField HeaderText="Order Wght" DataField="Weight" SortExpression="Weight" HtmlEncode="false" DataFormatString="{0:#,##0.0}"
                                            ItemStyle-CssClass="Left5pxPadd" ItemStyle-HorizontalAlign=Right>
                                            <ItemStyle  Width="40px" HorizontalAlign=right Wrap=false />
                                        </asp:BoundField>--%>
                                                    <asp:TemplateField HeaderText="Order Wght" SortExpression="Weight">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblWeight" Style="padding-left: 5px" runat="server" Text='<%# String.Format("{0:#,##0.0}", DataBinder.Eval(Container.DataItem,"Weight")) %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            <asp:Label Font-Bold="true" ID="lblTotalWeight" Style="padding-left: 5px" runat="server"></asp:Label>
                                                        </FooterTemplate>
                                                        <ItemStyle HorizontalAlign="Right" Width="50px" />
                                                        <FooterStyle HorizontalAlign="Right" Width="50px" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField HeaderText="Type" DataField="Type" SortExpression="Type" ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="30px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Ship Date" DataField="CShipDate" SortExpression="CShipDate"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="center" Width="35px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Sched Ship Date" DataField="SchShipDt" SortExpression="SchShipDt"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="center" Width="35px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Order Date" DataField="OrderDate" SortExpression="OrderDate"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="center" Width="35px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Cust Req'd" DataField="CustReq" SortExpression="CustReq"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="35px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Status" DataField="StatusCd" SortExpression="StatusCd"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="60px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Carrier" DataField="Carrier" SortExpression="Carrier"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="60px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Customer No" DataField="CustomerNo" SortExpression="CustomerNo"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Customer Name" DataField="SellToCustName" SortExpression="SellToCustName"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="150px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Ref SO No" DataField="RefSONo" SortExpression="RefSONo"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                </Columns>
                                            </asp:GridView>
                                            <input id="hidSort" type="hidden" name="Hidden1" runat="server">
                                            <asp:HiddenField ID="hidNetSales" runat="server" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <uc4:Pager ID="GridPager" OnBubbleClick="Pager_PageChanged" runat="server" />
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
                    <asp:UpdatePanel ID="upMessage" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td align="left" width="89%">
                                        <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="true">
                                            <ProgressTemplate>
                                                <span class="TabHead">Loading...</span></ProgressTemplate>
                                        </asp:UpdateProgress>
                                        <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                    </td>
                                    <td>
                                        <td>
                                            &nbsp;</td>
                                        <td colspan="4">
                                            <uc3:PrintDialogue ID="PrintDialogue1" runat="server" />
                                        </td>
                                        <input type="hidden" id="hidPrintURL" runat="server" />
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="right" style="padding-right: 5px;">
                    <table cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td style="padding-right: 10px;">
                                <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                    ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                            </td>
                            <td>
                                <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="Footer1" Title="Find" runat="server"></uc2:Footer>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
