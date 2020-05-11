<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PendingECommQuotes.aspx.cs" EnableViewState="true" Inherits="PendingECommQuotes" %>

<%@ Register Src="Common/UserControls/Pager.ascx" TagName="GridPager" TagPrefix="uc1"  %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker" TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>EComm Quotes Queue</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="Common/JavaScript/Common.js"></script>

    <script type="text/javascript">
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
        
        function ShowECommRecall(CustNo)
        {
            PECQQuoteRecallWindow=window.open ("ECommQuoteRecall.aspx?Cust="+CustNo,"PECQQuoteRecall",'height=690,width=1000,scrollbars=no,status=no,top='+((screen.height/2) - (690/2))+',left='+((screen.width/2) - (1000/2))+',resizable=NO',"");
            PECQQuoteRecallWindow.focus();
            return false;
        }
        
        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //take out room for bottom panel
            yh = yh - 145;
            // we resize differently according to quote recall or review quote
            if (document.getElementById("DetailPanel") != null)        
            {    
                var DetailPanel = $get("DetailPanel");
                DetailPanel.style.height = yh - 25;  
                var DetailGridPanel = $get("DetailGridPanel");
                DetailGridPanel.style.height = yh - 35;  
                DetailGridPanel.style.width = xw - 15;  
                var DetailGridHeightHid = $get("DetailGridHeightHidden");
                DetailGridHeightHid.value = yh - 85;
                var DetailGridHeightHid = $get("DetailGridWidthHidden");
                DetailGridHeightHid.value = xw - 25;
            }
        }
    </script>

    <script language="vbscript">
    Function ShowYesorNo(strMsg)
    Dim intBtnClick
    intBtnClick=msgbox(strMsg,vbyesno,"EComm Quotes Queue")
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
                    <asp:UpdatePanel ID="pnlPendingQuoteEntry" runat="server" UpdateMode="conditional">
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
                                                        Display="Dynamic" ErrorMessage="*Required" Width="52px"></asp:RequiredFieldValidator>--%>
                                                </td>
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
                                                    <asp:UpdatePanel runat="server" ID="pnlInsideRep" UpdateMode="Conditional">
                                                        <ContentTemplate>
                                                            <asp:DropDownList ID="ddlInsideRep" runat="server" CssClass="lbl_whitebox" Height="20" Width="150px">
                                                            </asp:DropDownList>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
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
                <td class="lightBg" style="padding: 2PX; height:400px" valign="top">
                        <asp:UpdatePanel ID="pnlPendingQuotesGrid" runat="server" UpdateMode="conditional">
                            <ContentTemplate>
                                <input id="hidSort" type="hidden" runat="server" />
                                <input id="hidPrintURL" type="hidden" name="hidPrintURL" runat="server" />
                                    <asp:GridView ShowFooter="false" ID="gvPendingOrders" PagerSettings-Visible="false"
                                        Width="690" runat="server" AllowPaging="true" ShowHeader="true" AllowSorting="true"
                                        AutoGenerateColumns="false" OnRowDataBound="DetailRowBound" OnSorting="gvPendingOrders_Sorting">
                                        <HeaderStyle HorizontalAlign="center" Height="20px" CssClass="GridHead" Font-Bold="true"
                                            BackColor="#DFF3F9" />
                                        <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                        <RowStyle CssClass="item" Wrap="False" BackColor="#FFFFFF" Height="20px" BorderWidth="1px" />
                                        <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="20px" BorderWidth="1px" />
                                        <Columns>
                                            <asp:BoundField HeaderText="CSR Name" DataField="UserName" SortExpression="UserName"
                                                ItemStyle-CssClass="Left5pxPadd">
                                                <ItemStyle HorizontalAlign="Left" Width="150px" />
                                            </asp:BoundField>
                                            <asp:BoundField HeaderText="Source" DataField="OrderSource" SortExpression="OrderSource"
                                                ItemStyle-CssClass="Left5pxPadd">
                                                <ItemStyle HorizontalAlign="Center" Width="40px" />
                                            </asp:BoundField>
                                            <asp:BoundField HeaderText="Location" DataField="CustShipLocation" SortExpression="CustShipLocation"
                                                ItemStyle-CssClass="Left5pxPadd">
                                                <ItemStyle HorizontalAlign="Center" Width="50px" />
                                            </asp:BoundField>
                                            <asp:TemplateField ItemStyle-Width="70" HeaderText="Customer No." HeaderStyle-HorizontalAlign="Center"
                                                ItemStyle-HorizontalAlign="center" SortExpression="CustNo">
                                                <ItemTemplate>
                                                    <asp:LinkButton Font-Underline="true" ForeColor="red" ID="CustNo" runat="server"
                                                        CausesValidation="false" Text='<%# Eval("CustNo") %>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField HeaderText="Customer Name" DataField="CustName" SortExpression="CustName"
                                                ItemStyle-CssClass="Left5pxPadd">
                                                <ItemStyle HorizontalAlign="Left" Width="230px" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="QuoteValue" HeaderText="Quote $ Value" DataFormatString="{0:#,##0.00} "
                                                ItemStyle-Width="100" SortExpression="QuoteValue" ItemStyle-HorizontalAlign="Right"
                                                HeaderStyle-HorizontalAlign="center" ItemStyle-CssClass="Right5pxPadd" />
                                        </Columns>
                                    </asp:GridView>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="height: 32px">
                    <asp:UpdatePanel ID="PagerUpdatePanel" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <uc1:GridPager ID="GPager" runat="server"  OnBubbleClick="ddlPages_SelectedIndexChanged" />
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
                                        </asp:UpdateProgress>&nbsp;
                                        <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                    </td>
                                    <td>
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
                    <uc2:Footer ID="FooterC" Title="ECommerce Quotes Queue" runat="server"></uc2:Footer>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
