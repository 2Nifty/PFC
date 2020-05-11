<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CreditRGA.aspx.cs" Inherits="CreditRGA" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <script>
        var DocWindow;
        function pageUnload() {
            CloseChildren();
        }
        function ClosePage()
        {
            window.close();	
        }
        function CloseChildren()
        {
            SetScreenPos("CreditRGA");
        }
        function OpenHelp(topic)
        {
            window.open('SOEHelp.aspx#' + topic + '','WorkSheetHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
        }
        function ShowDoc(DocNo)
        {
            var txtSONumber = window.opener.parent.bodyFrame.document.getElementById("CustDet_txtSONumber"); 
            window.opener.parent.bodyFrame.document.getElementById("CustDet_hidPreviousValue").value = ""; 
            txtSONumber.value = DocNo;
            window.opener.parent.bodyFrame.LoadDetails(txtSONumber.value);
            window.close();
            txtSONumber.focus(); 
            return false;
        }
        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //take out room for entry, header, and bottom panel
            yh = yh - 235;
            var DetailPanel = $get("DetailPanel")
            DetailPanel.style.height = yh;  
            var DetailGridPanel = $get("DetailGridPanel")
            DetailGridPanel.style.height = yh - 35;  
            DetailGridPanel.style.width = xw - 25;  
            
        }
    </script>

    <title>Credit/RGA V1.0.0</title>
    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/PriceSheetStyles.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 0px" bgcolor="#b5e7f7" onload="SetHeight();" onresize="SetHeight();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="CreditRGAScriptManager" runat="server" EnablePartialRendering="true" ScriptMode="Debug" />
        <div id="maindiv">
            <table width="100%">
                <tr>
                    <td class="Left5pxPadd">
                        <asp:Panel ID="EntryPanel" runat="server" style="border: 1px solid #88D2E9; display: block;" Height="130px">
                        <asp:UpdatePanel ID="EntryUpdatePanel" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                            <table>
                                <tr>
                                    <td>
                                        <b>Invoice Number:</b>
                                    </td>
                                    <td>&nbsp; &nbsp;
                                        <asp:TextBox CssClass="ws_whitebox_left" ID="InvoiceNoTextBox" runat="server" Text=""
                                            Width="60px" TabIndex="1"
                                            onfocus="javascript:this.select();"></asp:TextBox>&nbsp;
                                        <asp:HiddenField ID="OrderIDHidden" runat="server" />
                                        <asp:HiddenField ID="ShipLocHidden" runat="server" />
                                    </td>
                                    <td rowspan="3">
                                        <asp:UpdateProgress ID="HeaderUpdateProgress" runat="server">
                                            <ProgressTemplate>
                                                Loading....
                                                <asp:Image ID="ProgressImage" ImageUrl="Common/Images/PFCYellowBall.gif" runat="server" />
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Sales Order Number:</b></td>
                                    <td>&nbsp; &nbsp;
                                        <asp:TextBox CssClass="ws_whitebox_left" ID="SONumberTextBox" runat="server" Text=""
                                            Width="60px" TabIndex="1"
                                            onfocus="javascript:this.select();"></asp:TextBox>&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Order Type:</b></td>
                                    <td>&nbsp; &nbsp;
                                        <asp:DropDownList ID="OrderTypeDropDownList" runat="server" Style="font-size: 11px;" AutoPostBack="true"
                                         DataTextField="ListDtlDesc" DataValueField="ListValue" OnTextChanged="OrderType_Changed">
                                        </asp:DropDownList>
                                        
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Reason Code:</b></td>
                                    <td>&nbsp; &nbsp;
                                        <asp:DropDownList ID="ReasonCodeDropDownList" runat="server" Style="font-size: 11px;"
                                         DataTextField="ReasonDesc" DataValueField="ReasonCode">
                                        </asp:DropDownList>
                                        &nbsp; &nbsp;
                                    </td>
                                    <td align="left">
                                        <asp:ImageButton ID="GoImageButton" ImageUrl="~/Common/Images/ShowButton.gif" 
                                            OnClick="Search" CausesValidation="false" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>External Document #:</b>
                                    </td>
                                    <td>&nbsp; &nbsp;
                                        <asp:TextBox ID="ExternalDocTextBox" runat="server" CssClass="ws_whitebox_left" style="width: 157px"></asp:TextBox>
                                        &nbsp;&nbsp;
                                    </td>
                                </tr>
                            </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td valign="top" class="Left5pxPadd">
                        <asp:Panel ID="HeaderPanel" runat="server" style="border: 1px solid #88D2E9; display: block;" Height="40px">
                        <asp:UpdatePanel ID="HeaderUpdatePanel" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                            <div class="Left5pxPadd">
                            <asp:GridView ID="HeaderGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                                RowStyle-CssClass="priceDarkLabel" >
                                <AlternatingRowStyle CssClass="priceLightLabel" />
                                <Columns>
                                    <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No." ItemStyle-Width="80"
                                        SortExpression="InvoiceNo" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="left" />
                                    <asp:BoundField DataField="OrderNo" HeaderText="Order No." ItemStyle-Width="80"
                                        SortExpression="OrderNo" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="left" />
                                    <asp:BoundField DataField="OrderLoc" HeaderText="Order Loc" ItemStyle-Width="60"
                                        SortExpression="OrderLoc" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="ShipLoc" HeaderText="Ship Loc" ItemStyle-Width="60"
                                        SortExpression="ShipLoc" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="center" />
                                    <asp:BoundField DataField="CustNo" HeaderText="Customer&nbsp;No" 
                                        ItemStyle-Width="60" SortExpression="CustNo" ItemStyle-HorizontalAlign="Right"
                                        HeaderStyle-HorizontalAlign="left" />
                                    <asp:BoundField DataField="CustName" HeaderText="Customer Name" ItemStyle-Width="250"
                                        SortExpression="CustName" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="left" />
                                    <asp:BoundField DataField="LineCount" HeaderText="Lines" ItemStyle-Width="50" DataFormatString="{0:#,##0} "
                                        SortExpression="LineCount" ItemStyle-HorizontalAlign="right" HeaderStyle-HorizontalAlign="center" />
                                    <asp:BoundField DataField="TotWgt" HeaderText="&nbsp;&nbsp;Total Weight" DataFormatString="{0:#,##0.00} "
                                        ItemStyle-Width="90" SortExpression="TotWgt" ItemStyle-HorizontalAlign="Right"
                                        HeaderStyle-HorizontalAlign="center" />
                                    <asp:BoundField DataField="TotAmt" HeaderText="&nbsp;&nbsp;Total Amount" DataFormatString="{0:#,##0.00} "
                                        ItemStyle-Width="90" SortExpression="TotAmt" ItemStyle-HorizontalAlign="Right"
                                        HeaderStyle-HorizontalAlign="center" />
                                    <asp:BoundField DataField="DocStatus" HeaderText="&nbsp;&nbsp;Status" ItemStyle-Width="60"
                                        SortExpression="DocStatus" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="left" />
                                </Columns>
                           </asp:GridView>
                           </div>
                           </ContentTemplate>
                        </asp:UpdatePanel>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td class="Left5pxPadd" align="left" valign="middle" >
                        <table style="border: 1px solid #88D2E9; display: block;" width="100%">
                            <tr>
                                <td class="Left5pxPadd">
                                    <asp:Panel ID="DetailPanel" runat="server" Width="100%">
                                    <asp:UpdatePanel ID="DetailUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:Panel ID="MakePanel" runat="server" width="99%" style="border: 1px solid #88D2E9; display: block;" HorizontalAlign="Right">
                                            <table >
                                                <tr>
                                                    <td>&nbsp;&nbsp;&nbsp;
                                                        <asp:Label ID="RGAReturnToLabel" runat="server" Text="Return To Location:"></asp:Label>&nbsp;&nbsp;
                                                        <asp:DropDownList ID="RGAReturnToDropDown" runat="server" DataTextField="Name" DataValueField="Code" >
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>&nbsp;&nbsp;&nbsp;
                                                        <asp:ImageButton ID="MakeCreditButt" runat="server"  OnClick="MakeOrder_Click" 
                                                        ImageUrl="Common/Images/MakeCredit.gif"  AlternateText="Make Credit"
                                                        CausesValidation="true"/>
                                                        <asp:ImageButton ID="MakeRGAButt" runat="server"  OnClick="MakeOrder_Click" 
                                                        ImageUrl="Common/Images/MakeRGA.gif" AlternateText="Make RGA" 
                                                        CausesValidation="true"/>
                                                        &nbsp;&nbsp;&nbsp;
                                                    </td>
                                                    <td colspan="5" align="right">
                                                        <img alt="E-Mail" onclick="" src="Common/Images/mail.gif" style="cursor: hand">&nbsp;&nbsp;
                                                        <img src="Common/Images/pdf.gif" style="cursor: hand" onclick="" alt="Export to PDF">&nbsp;&nbsp;
                                                        <img alt="Print" onclick="" src="Common/Images/printer.gif" style="cursor: hand">&nbsp;&nbsp;
                                                    </td>
                                                                        
                                                </tr>
                                            </table>
                                            </asp:Panel>
                                            <asp:Panel ID="DetailGridPanel" runat="server"  ScrollBars="both" >
                                            <asp:GridView ID="DetailGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                                                RowStyle-CssClass="priceDarkLabel" style="width: 900px" AllowSorting="true" OnSorting="SortDetailGrid"
                                                >
                                                <AlternatingRowStyle CssClass="priceLightLabel" />
                                                    <Columns>
                                                        <asp:TemplateField ItemStyle-Width="40" HeaderText="Select" HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-HorizontalAlign="center" >
                                                            <ItemTemplate>
                                                                <asp:CheckBox ID="SelectCheckBox" runat="server" />
                                                                <asp:HiddenField ID="LineNumberHidden" runat="server" Value='<%# Eval("LineNumber") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="CustItemNo" HeaderText="Customer &nbsp;Item&nbsp;#&nbsp;" ItemStyle-Width="90"
                                                            SortExpression="CustItemNo" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="center" />
                                                
                                                        <asp:BoundField DataField="ItemNo" HeaderText="PFC Item #" ItemStyle-Width="90"
                                                            SortExpression="ItemNo" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="center" />
                                                
                                                        <asp:BoundField DataField="ItemDsc" HeaderText="Description" ItemStyle-Width="250"
                                                            SortExpression="ItemDsc" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="center" />
                                                
                                                        <asp:BoundField DataField="Qty" HeaderText="Qty" ItemStyle-Width="40" DataFormatString="{0:#,##0} "
                                                            SortExpression="Qty" ItemStyle-HorizontalAlign="right" HeaderStyle-HorizontalAlign="center" />
                                                
                                                        <asp:BoundField DataField="SellGlued" HeaderText="Base Qty/UOM" ItemStyle-Width="60"
                                                            SortExpression="SellStkQty" ItemStyle-HorizontalAlign="right" HeaderStyle-HorizontalAlign="center" />
                                                
                                                        <asp:BoundField DataField="PriceGlued" HeaderText="Price/UOM" ItemStyle-Width="70"
                                                            SortExpression="UnitPrice" ItemStyle-HorizontalAlign="right" HeaderStyle-HorizontalAlign="center" />
                                                
                                                        <asp:BoundField DataField="LineAmount" HeaderText="Extended Amount" DataFormatString="{0:#,##0.00} "
                                                            ItemStyle-Width="80" SortExpression="LineAmount" ItemStyle-HorizontalAlign="Right"
                                                            HeaderStyle-HorizontalAlign="center" />

                                                        <asp:BoundField DataField="LineWeight" HeaderText="Extended Weight" DataFormatString="{0:#,##0.00} "
                                                            ItemStyle-Width="80" SortExpression="LineWeight" ItemStyle-HorizontalAlign="Right"
                                                            HeaderStyle-HorizontalAlign="center" />
                                                
                                                        <asp:BoundField DataField="IMLoc" HeaderText="Loc." ItemStyle-Width="35"
                                                            SortExpression="IMLoc" ItemStyle-HorizontalAlign="center" HeaderStyle-HorizontalAlign="center" />
                                                
                                                    </Columns>
                                            </asp:GridView>
                                            </asp:Panel>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                    </asp:Panel>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="Left5pxPadd">
                        <table width="100%" style="border: 1px solid #88D2E9; height: 25px; display: block;">
                            <tr>
                                <td>
                                    <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:Label ID="MessageLabel" runat="server"></asp:Label>&nbsp;
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td align="right">
                                    <img src="Common/images/help.gif" style="cursor: hand" alt="Click here for Help"
                                        onclick="OpenHelp('CreditRGA');" />&nbsp;&nbsp;
                                    <img src="Common/Images/close.gif" style="cursor: hand" onclick="ClosePage();" alt="Close Page">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
