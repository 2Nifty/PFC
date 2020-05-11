<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InvoiceRecall.aspx.cs" Inherits="InvoiceRecall" %>


<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc5" %>
<%@ Register Src="~/Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Invoice Recall</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>

    <script type="text/javascript">
     
    function OpenInvoice(InvoiceNo,CustNo)
    {
       
//        var url="http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232c4%3BNoUI%3D1%3BF0%3D"+value+"P;style=abc123;";
//        var popup= window.open(url,"Invoice",'height=550,width=950,scrollbars=no,status=no,top='+((screen.height/2) - (600/2))+',left='+((screen.width/2) - (950/2))+',resizable=NO',"");
//          
           var popup= window.open("GetInvoice.aspx?InvoiceNo="+InvoiceNo+"&CustomerNo="+CustNo,"Invoice",'height=720,width=690,toolbar=0,scrollbars=no,status=0,resizable=YES,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (690/2))+'','');
          
    //        var queryString="InvoiceNo="+value;
    //        var popup= window.open ("GetInvoicePDF.aspx?"+queryString,"Maximize",'height=750,width=600,scrollbars=no,status=no,top='+((screen.height/2) - (650/2))+',left='+((screen.width/2) - (800/2))+',resizable=NO',"");
             popup.focus(); 
    }
    </script>

</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';" onmouseup="divToolTips.style.display='none';"
    onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table border="0" class="HeaderPanels" cellpadding="0" cellspacing="0">
            <tr>
                <td class="lightBg" width="100%">
                    <asp:UpdatePanel ID="upnlBillInfo" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="SubHeaderPanels" style="padding-left: 4px;" valign="top">
                                        <asp:Panel ID="pnlSearch" runat="server">
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="height: 15px; padding-bottom: 5px; padding-left: 5px; padding-right: 5px;">
                                                        <asp:Label ID="lblInvoiceNo" runat="server" Text="Invoice No: " Font-Bold="True"
                                                            Width="80px"></asp:Label>
                                                        <asp:HiddenField ID="hidCust" runat="server" />
                                                        <asp:HiddenField ID="hidInvoice" runat="server" />
                                                    </td>
                                                    <td style="height: 15px; padding-bottom: 5px; padding-left: 2px; padding-right: 5px;">
                                                        <asp:TextBox ID="txtInvoiceNumber" runat="server" CssClass="lbl_whitebox" Width="114px"
                                                            OnTextChanged="txtInvoiceNumber_TextChanged" MaxLength="15" > </asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtInvoiceNumber"
                                                            Display="Dynamic" ErrorMessage="*Required" Width="52px"></asp:RequiredFieldValidator>--%>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px; height :20px;font-weight:bold " valign="top">
                                                        <asp:LinkButton ID="lnkBillTo" runat="server" Font-Underline="True" Text="Bill To:"
                                                                    TabIndex="13" Font-Bold="True"></asp:LinkButton>
                                                                <div id="divToolTips" class="list" style="display: none; position: absolute;" onmouseup="return false;">
                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td>
                                                                                <span class="boldText">Change ID: </span>
                                                                                <asp:Label ID="lblChangeID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                            <td>
                                                                                <span class="boldText" style="padding-left: 5px;">Change Date: </span>
                                                                                <asp:Label ID="lblChangeDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <span class="boldText">Entry ID: </span>
                                                                                <asp:Label ID="lblEntryID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                            <td>
                                                                                <span class="boldText" style="padding-left: 5px;">Entry Date: </span>
                                                                                <asp:Label ID="lblEntryDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                        </tr>
                                                                    </table>
                                                    </td>
                                                    <td style="padding-bottom: 5px; padding-left: 2px; padding-right: 5px; height:20px" valign="top">
                                                       <asp:Label ID="lblBillCustNo" runat="server" Font-Bold ="True"  ></asp:Label>
                                                       <asp:Label ID="lblCustCom" runat="server"  Font-Bold ="true" Text ="/" Visible ="false" ></asp:Label>
                                                       <asp:Label ID="lblBillCustName" runat="server" Font-Bold ="true"  ></asp:Label>
                                                    </td>
                                                    <td valign="top" style="width: 78px">
                                                    </td>
                                                </tr>
                                <tr>
                                    <td style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px; height: 15px; font-weight:bold"
                                        valign="top">
                                        Bill To Fax:
                                    </td>
                                    <td style="padding-bottom: 5px; padding-right: 5px; height: 15px" valign="top">
                                        <asp:Label ID="lblBillToFax" runat="server" CssClass="lbl_whitebox" Width="180px"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px; height: 15px; font-weight:bold "
                                        valign="top">
                                        Bill To EMail:
                                    </td>
                                    <td style="padding-bottom: 5px; padding-right: 5px; height: 15px" valign="top">
                                        <asp:Label ID="lblBillToMail" runat="server" CssClass="lbl_whitebox" Width="180px"></asp:Label>
                                    </td>
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
                    <asp:UpdatePanel ID="upnlInvoiceGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <div class="Sbar" oncontextmenu="Javascript:return false;" id="div-datagrid" style="overflow-x: hidden;
                                overflow-y: auto; position: relative; top: 0px; left: 0px; height: 220px; border: 1px solid #88D2E9;
                                width: 565px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94">
                                <asp:GridView UseAccessibleHeader="true" ID="gvInvoice" PagerSettings-Visible="false"
                                    Width="550" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="true"
                                    AutoGenerateColumns="false" ShowFooter="false" OnRowCommand="gvInvoice_RowCommand" OnSorting="gvInvoice_Sorting">
                                    <HeaderStyle HorizontalAlign="Center" CssClass="GridHead" Font-Bold="True" BackColor="#DFF3F9"
                                        Height="20px" />
                                    <FooterStyle Font-Bold="True" VerticalAlign="Top" HorizontalAlign="Right" />
                                    <RowStyle CssClass="item" Wrap="False" BackColor="White" Height="25px" BorderWidth="1px" />
                                    <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="25px" BorderWidth="1px" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Invoice No" SortExpression="InvoiceNo">
                                            <ItemTemplate >
                                            
                                                <asp:LinkButton ID="lnkInvoiceNo" CausesValidation="false" Font-Underline="true"
                                                    ForeColor="#006600" Style="padding-left: 5px" Text='<%#DataBinder.Eval(Container.DataItem,"InvoiceNo") %>'
                                                    runat="server" CommandName="BindInvoice" ></asp:LinkButton>
                                            </ItemTemplate>
                                            <FooterStyle HorizontalAlign="Right" />
                                            <ItemStyle Width="100px" HorizontalAlign ="Center"  />
                                        </asp:TemplateField>
                                        <asp:BoundField HeaderText="Cust No" DataField="SellToCustNo" SortExpression="SellToCustNo">
                                            <ItemStyle HorizontalAlign="Center" Width="110px" CssClass="Left5pxPadd" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Invioce Date" DataField="InvoiceDt" SortExpression="InvoiceDt">
                                            <ItemStyle HorizontalAlign="Center" Width="110px" CssClass="Left5pxPadd" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Cust PO No" DataField="CustPONo" SortExpression="CustPONo">
                                            <ItemStyle HorizontalAlign="Center" Width="110px" CssClass="Left5pxPadd" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Invoice Amt" DataField="TotalOrder" SortExpression="TotalOrder"
                                            DataFormatString="{0:$ #,##0.00}">
                                            <ItemStyle HorizontalAlign="Right " Width="110px" CssClass="Left5pxPadd" />
                                            <FooterStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                    </Columns>
                                    <PagerSettings Visible="False" />
                                </asp:GridView>
                                <input id="hidSortInvoice" type="hidden" name="Hidden1" runat="server">
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="right" width="100%" id="tdButton" class="commandLine splitborder_t_v splitborder_b_v"
                    style="height: 18px; background-position: -80px  left;">
                    <asp:UpdatePanel ID="upMessage" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="padding-left: 5px;" align="left" width="89%">
                                        <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="true">
                                            <ProgressTemplate>
                                                <span class="TabHead">Loading...</span></ProgressTemplate>
                                        </asp:UpdateProgress>
                                        <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                    </td>
                                    <td>
                                        <uc5:PrintDialogue ID="PrintDialogue1" runat="server"></uc5:PrintDialogue>
                                    </td>
                                    <td>
                                        <input type="hidden" id="hidPrintURL" runat="server" /></td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="right" style="padding-right: 5px;" colspan="2">
                    <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" /></td>
                <td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="Footer1" Title="Invoice Recall" runat="server"></uc2:Footer>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
