<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ECommQuoteRecall.aspx.cs" Inherits="ECommQuoteRecall" %>
<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script>
        var ECQRStockStatusWindow;
        var HeaderRatio = 0.4;
        var DetailRatio = 0.6;
        var LineDelPop = window.createPopup();
        function pageUnload() {
            CloseChildren();
        }
        function ClosePage()
        {
            window.close();	
        }
        function CloseChildren()
        {
            if ((ECQRStockStatusWindow != null) && (!ECQRStockStatusWindow.closed)) {ECQRStockStatusWindow.close();ECQRStockStatusWindow=null;}
        }
        function OpenHelp(topic)
        {
            window.open('SOEHelp.aspx#' + topic + '','WorkSheetHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
        }
        
        function ShowStockStatus(ItemNo, UserOK)
        {
            var URL="";
            //alert(UserOK);
            // if we don't have the session variables, we shunt to a page that will give them to us
            if (UserOK == "No" )
            {
                URL = "http://localhost/IntranetWindowsAuthentication/IWAStockStatus.aspx?ItemNo="+ItemNo;
            }
            else
            {
                URL = "StockStatus.aspx?ItemNo="+ItemNo;
            }
            ECQRStockStatusWindow=window.open (URL,"ECQRStockStatus",'height=690,width=1014,scrollbars=no,status=no,top='+((screen.height/2) - (690/2))+',left='+((screen.width/2) - (1014/2))+',resizable=NO',"");
            ECQRStockStatusWindow.focus();
            return false;
        }
        
        // Open Customer look up
        function LoadCustomerLookup(_custNo)
        {   
            var Url = "CustomerList.aspx?Customer=" + _custNo + "&ctrlName=QuoteRecall";
            window.open(Url,'CustomerList' ,'height=485,width=855,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (855/2))+',resizable=NO,scrollbars=YES','');
        }
        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //take out room for bottom panel
            yh = yh - 60;
            // we resize differently according to quote recall or review quote
            if (document.getElementById("HeaderPanel") != null)
            {
                var HeaderPanel = $get("HeaderPanel");
                HeaderPanel.style.height = Math.floor(yh * HeaderRatio);  
                var QuoteDatePanel = $get("DatePanel");
                QuoteDatePanel.style.height = Math.floor(Math.max((yh * HeaderRatio) - 40, 10));  
                var QuoteGridPanel = $get("QuoteGridPanel");
                QuoteGridPanel.style.height = Math.floor(Math.max((yh * HeaderRatio) - 55, 10));  
                var DetailPanel = $get("DetailPanel");
                DetailPanel.style.height = Math.floor(yh * DetailRatio);  
                var DetailGridPanel = $get("DetailGridPanel");
                DetailGridPanel.style.height = Math.floor((yh * DetailRatio) - 0);  
                DetailGridPanel.style.width = Math.floor(xw - 15);  
                var DetailGridHeightHid = $get("DetailGridHeightHidden");
                DetailGridHeightHid.value = Math.floor((yh * DetailRatio) - 0);
                var DetailGridWidthHid = $get("DetailGridWidthHidden");
                DetailGridWidthHid.value = Math.floor(xw - 15);
            }
            else
            {
                if (document.getElementById("DetailPanel") != null)        
                {    
                    var DetailPanel = $get("DetailPanel");
                    DetailPanel.style.height = Math.floor(yh - 25);  
                    var DetailGridPanel = $get("DetailGridPanel");
                    DetailGridPanel.style.height = Math.floor(yh - 85);  
                    DetailGridPanel.style.width = Math.floor(xw - 25);  
                    var DetailGridHeightHid = $get("DetailGridHeightHidden");
                    DetailGridHeightHid.value = Math.floor(yh - 85);
                    var DetailGridHeightHid = $get("DetailGridWidthHidden");
                    DetailGridHeightHid.value = Math.floor(xw - 25);
                }
            }
        }
        function ShowAvailability(Quote, Item, Loc, Req, QOH)
        {
            if (RecallAvailabilityWindow != null) {RecallAvailabilityWindow.close();RecallAvailabilityWindow=null;}
            var AvailURL = 'BranchAvailable.aspx?ItemNumber=' + Item + '&ShipLoc=' + Loc + '&RequestedQty=' + 
                Req + '&AltQty=0&AvailableQty=' + QOH + '&QuoteRecall=' + Quote + 
                '&FilterField=' + $get("DetailFilterFieldHidden").value + '&FilterValue=' + $get("DetailFilterValueHidden").value;
            //alert(AvailURL);
            //RecallAvailabilityWindow=window.open(AvailURL,'RecallQOHWin','height=600,width=600,toolbar=0,scrollbars=0,status=1,resizable=YES','');  
            if (document.getElementById("RecallPageMode").value=="Recall")
            {
                RecallAvailabilityWindow = OpenAtPos('BranchAvail', AvailURL, 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 600, 600); 
            }
            if (document.getElementById("RecallPageMode").value=="Review")
            {
                ReviewAvailabilityWindow = OpenAtPos('BranchAvail', AvailURL, 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 600, 600); 
            }
            SetHeight();   
            return false;  
        }
        function closeFixWindow()
        {
            if (document.getElementById("RecallPageMode").value=="Recall")
            {
                if (RecallFixLineWindow != null) {RecallFixLineWindow.close();RecallFixLineWindow=null;}
            }
            if (document.getElementById("RecallPageMode").value=="Review")
            {
                if (ReviewFixLineWindow != null) {ReviewFixLineWindow.close();ReviewFixLineWindow=null;}
            }
        }
        
        // Change the price
        function ChangePrice(PriceBox)
        {
            var num = new Number(PriceBox.value);
            if (isNaN(num))
            {
                alert("Please enter a number.");
                return;
            }
            // get the quote number from the front of the row
            var LineParent = PriceBox.parentNode.parentNode;
            // also get the Item, Loc, and UOM
            var status = ECommQuoteRecall.UpdLinePrice(
                LineParent.childNodes[12].getElementsByTagName("INPUT")[1].value
                ,PriceBox.value
                ,LineParent.childNodes[8].childNodes[2].innerText
                ,document.getElementById("DetailTableName").value
                ,document.getElementById("HeaderTableName").value
                ).value;
            //alert(status);
            if (status.substr(0,2)=="!!")
            {
                alert(status);
            }
            else
            {
                PriceBox.value = status.split(":")[0];
                LineParent.childNodes[9].innerText = status.split(":")[1];
                LineParent.childNodes[10].innerText = status.split(":")[2];
                LineParent.childNodes[11].getElementsByTagName("INPUT")[0].value = status.split(":")[3];
                LineParent.childNodes[12].getElementsByTagName("INPUT")[0].checked = true;
            }
        }

        // Change the Margin
        function ChangeMarginPcnt(MarginBox)
        {
            var num = new Number(MarginBox.value);
            if (isNaN(num))
            {
                alert("Please enter a number.");
                return;
            }
            // get the quote number from the front of the row
            var LineParent = MarginBox.parentNode.parentNode;
            // also get the Item, Loc, and UOM
            var status = ECommQuoteRecall.UpdLineMargin(
                LineParent.childNodes[12].getElementsByTagName("INPUT")[1].value
                ,MarginBox.value
                ,LineParent.childNodes[8].childNodes[2].innerText
                ,document.getElementById("DetailTableName").value
                ,document.getElementById("HeaderTableName").value
                ).value;
            //alert(status);
            if (status.substr(0,2)=="!!")
            {
                alert(status);
            }
            else
            {
                LineParent.childNodes[8].getElementsByTagName("INPUT")[0].value = status.split(":")[0];
                LineParent.childNodes[9].innerText = status.split(":")[1];
                LineParent.childNodes[10].innerText = status.split(":")[2];
                MarginBox.value = status.split(":")[3];
                LineParent.childNodes[12].getElementsByTagName("INPUT")[0].checked = true;
            }
        }

    </script>

    <title>Ecommerce Quote Recall V1.0.0</title>
    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>
    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/PriceSheetStyles.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 0px" bgcolor="#ECF9FB" onload="SetHeight();" onresize="SetHeight();" >
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ECommQuoteRecallScriptManager" runat="server" EnablePartialRendering="true" AsyncPostBackTimeout="36000" />
        <div id="maindiv">
            <asp:HiddenField ID="RecallPageMode" runat="server" />
            <asp:HiddenField ID="ReadOnly" runat="server" />
            <asp:HiddenField ID="DetailTableName" runat="server" />
            <asp:HiddenField ID="HeaderTableName" runat="server" />
            <asp:HiddenField ID="SOELink" runat="server" />
            <asp:HiddenField ID="CurShowDate" runat="server" />
            <asp:HiddenField ID="CurShowQuote" runat="server" />
            <asp:UpdatePanel ID="RefreshButtonUpdatePanel" runat="server" RenderMode="inline" >
            <ContentTemplate>
                <asp:Button id="DetailRefreshButton" name="DetailRefreshButton" 
                    OnClick="DetailRefresh_Click"
                    runat="server" Text="Button" style="display:none;" CausesValidation="false" />
            </ContentTemplate>
            </asp:UpdatePanel>
            <table width="100%">
                <tr>
                    <td class="Left5pxPadd">
                        <asp:Panel ID="HeaderPanel" runat="server" style="border: 1px solid #88D2E9; display: block;">
                        <asp:UpdatePanel ID="HeaderUpdatePanel" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table width="100%">
                                    <tr>
                                        <td class="Left5pxPadd" valign="top" colspan="5">
                                            <table >
                                                <tr>
                                                    <td class="bold">
                                                        Customer:
                                                    </td>
                                                    <td>
                                                        <asp:TextBox CssClass="ws_whitebox_cntr" ID="CustNoTextBox" runat="server" Text=""
                                                            OnTextChanged="WorkCustomerNumber" AutoPostBack="true" Width="60px" TabIndex="1"
                                                            onfocus="javascript:this.select();"></asp:TextBox>&nbsp;
                                                        <asp:Button id="CustNoSubmit" name="CustNoSubmit" OnClick="WorkCustomerNumber"
                                                            runat="server" Text="Button" style="display:none;" CausesValidation="false" />
                                                    </td>
                                                    <td align="right">
                                                        <asp:Label CssClass="ws_whitebox_left" ID="CustNameLabel" runat="server" 
                                                            Width="200"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <asp:Panel ID="DatePanel" runat="server"  Width="320px" ScrollBars="Vertical">
                                                <asp:GridView ID="DateGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                                                    RowStyle-CssClass="priceDarkLabel" OnRowCommand="QuoteDaysCommand">
                                                    <AlternatingRowStyle CssClass="priceLightLabel" />
                                                    <Columns>
                                                        <asp:BoundField DataField="QuoteDate" HeaderText="&nbsp;&nbsp;Quote Date" ItemStyle-Width="80"
                                                            DataFormatString="{0:MM/dd/yyyy}" SortExpression="QuoteDate" ItemStyle-HorizontalAlign="center"
                                                            HeaderStyle-HorizontalAlign="left" />
                                                        <asp:BoundField DataField="QuoteCount" HeaderText="&nbsp;&nbsp;Quotes" ItemStyle-Width="60"
                                                            SortExpression="QuoteNumber" ItemStyle-HorizontalAlign="right" HeaderStyle-HorizontalAlign="center" />
                                                        <asp:ButtonField CommandName="ShowDay" ButtonType="Link" Text="Show Day" ItemStyle-Width="80"
                                                            ItemStyle-HorizontalAlign="center" />
                                                        <asp:ButtonField CommandName="ShowLines" ButtonType="Link" Text="Show Lines" ItemStyle-Width="80"
                                                            ItemStyle-HorizontalAlign="center" />
                                                    </Columns>
                                                </asp:GridView>
                                            </asp:Panel>
                                        </td>
                                        <td valign="top">
                                            <asp:UpdateProgress DisplayAfter="50" ID="HeaderUpdateProgress" runat="server">
                                                <ProgressTemplate>
                                                Loading....<br />
                                                <asp:Image ID="ProgressImage" ImageUrl="Common/Images/PFCYellowBall.gif" runat="server" />
                                                </ProgressTemplate>
                                            </asp:UpdateProgress>
                                        </td>
                                        <td valign="top" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        </td>
                                        <td valign="top">
                                            Quotes on File for <asp:Label ID="FilterShowingLabel" runat="server" Text=""></asp:Label><br />
                                            <asp:Panel ID="QuoteGridPanel" runat="server" ScrollBars="Vertical" EnableViewState="true">
                                                <asp:GridView ID="QuoteGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                                                    RowStyle-CssClass="priceDarkLabel" AllowSorting="true" OnSorting="QuoteGridViewSortCommand"
                                                    OnRowCommand="QuoteSummCommand">
                                                    <AlternatingRowStyle CssClass="priceLightLabel" />
                                                    <Columns>
                                                        <asp:BoundField DataField="Quote" HeaderText="&nbsp;&nbsp;Quote #" ItemStyle-Width="70"
                                                            SortExpression="Quote" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="left" />
                                                        <asp:BoundField DataField="QuoteLines" HeaderText="&nbsp;&nbsp;Lines" DataFormatString="{0:#,##0} "
                                                            ItemStyle-Width="40" SortExpression="QuoteLines" ItemStyle-HorizontalAlign="Right"
                                                            HeaderStyle-HorizontalAlign="left" />
                                                        <asp:BoundField DataField="QuoteWeight" HeaderText="&nbsp;&nbsp;Total Weight" DataFormatString="{0:#,##0.00} "
                                                            ItemStyle-Width="90" SortExpression="QuoteWeight" ItemStyle-HorizontalAlign="Right"
                                                            HeaderStyle-HorizontalAlign="left" />
                                                        <asp:BoundField DataField="QuoteAmount" HeaderText="&nbsp;&nbsp;Total Amount" DataFormatString="{0:#,##0.00} "
                                                            ItemStyle-Width="90" SortExpression="QuoteAmount" ItemStyle-HorizontalAlign="Right"
                                                            HeaderStyle-HorizontalAlign="left" />
                                                        <asp:BoundField DataField="ECommUserName" HeaderText="Contact Name"
                                                            ItemStyle-Width="100" SortExpression="ECommUserName" ItemStyle-HorizontalAlign="left"
                                                            HeaderStyle-HorizontalAlign="center" />
                                                        <asp:BoundField DataField="ECommPhoneNo" HeaderText="Phone"
                                                            ItemStyle-Width="100" SortExpression="ECommPhoneNo" ItemStyle-HorizontalAlign="left"
                                                            HeaderStyle-HorizontalAlign="center" />
                                                        <asp:ButtonField CommandName="ShowDetail" ButtonType="Link" Text="Quote Detail" ItemStyle-Width="85"
                                                            ItemStyle-HorizontalAlign="center" />
                                                    </Columns>
                                                </asp:GridView>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td class="Left5pxPadd" align="left" valign="middle" >
                        <table style="border: 1px solid #88D2E9; display: block;" width="100%">
                            <tr>
                                <td>
                                    <asp:Panel ID="DetailPanel" runat="server" Width="100%">
                                    <asp:UpdatePanel ID="QuoteDetailUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:Panel ID="DetailGridPanel" runat="server"  ScrollBars="both" Height="210px" Width="980px">
                                                <asp:HiddenField ID="DetailGridHeightHidden" runat="server" />
                                                <asp:HiddenField ID="DetailGridWidthHidden" runat="server" />
                                            <asp:HiddenField ID="DetailSortField" runat="server" />
                                            <asp:GridView ID="DetailGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                                                RowStyle-CssClass="priceDarkLabel" style="width: 970px" AllowSorting="true" OnSorting="SortDetailGrid"
                                                PagerSettings-Position="TopAndBottom" PageSize="10" onpageindexchanging="DetailGridView_PageIndexChanging"
                                                OnRowDataBound="DetailRowBound" AllowPaging="true" PagerSettings-Visible="true" PagerSettings-Mode="Numeric">
                                                <AlternatingRowStyle CssClass="priceLightLabel" />
                                                    <Columns>
                                                        <asp:BoundField DataField="SessionID" HeaderText="Quote #" ItemStyle-Width="50" SortExpression="QuoteNumber"
                                                            ItemStyle-HorizontalAlign="center" HeaderStyle-HorizontalAlign="center" />
                                                        <asp:BoundField DataField="UserItemNo" HeaderText="Customer &nbsp;Item&nbsp;#&nbsp;" ItemStyle-Width="100"
                                                            SortExpression="UserItemNo" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="center" />
                                                        <asp:TemplateField ItemStyle-Width="90" HeaderText="PFC Item" HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-HorizontalAlign="center" SortExpression="PFCItemNo">
                                                            <ItemTemplate>
                                                                <asp:LinkButton CssClass="QOHLink" ID="PFCItem" runat="server" CausesValidation="false" Text='<%# Eval("PFCItemNo") %>'/>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-Width="180"
                                                            SortExpression="Description" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="center" />
                                                        <asp:TemplateField ItemStyle-Width="45px" HeaderText="Req'd<BR>Qty" HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-HorizontalAlign="right" SortExpression="RequestQuantity">
                                                            <ItemTemplate>
<%--                                                                <asp:TextBox ID="ReqQtyText" runat="server"  Text='<%# Eval("RequestQuantity", "{0:###,##0} ") %>' Width="45px" 
                                                                CssClass="ws_whitebox" onfocus="javascript:this.select();"
                                                                onkeydown="javascript:if(event.keyCode==13){return event.keyCode=9;}"
                                                                onChange="ChangeQty(this);"/>
--%>                                                                <asp:Label ID="ReqQtyLabel" runat="server"  Text='<%# Eval("RequestQuantity", "{0:###,##0} ") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="BaseQtyGlued" HeaderText="Base Qty/UOM" ItemStyle-Width="60"
                                                            SortExpression="BaseUOMQty" ItemStyle-HorizontalAlign="right" HeaderStyle-HorizontalAlign="center" />
                                                        <asp:TemplateField ItemStyle-Width="40" HeaderText="Avail. Qty" HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-HorizontalAlign="right" SortExpression="AvailableQuantity">
                                                            <ItemTemplate>
                                                                <asp:Label ID="QOHLabel" runat="server"  Text='<%# Eval("AvailableQuantity", "{0:###,##0} ") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Loc." ItemStyle-HorizontalAlign="center"
                                                            ItemStyle-Width="30" SortExpression="LocationCode">
                                                            <ItemTemplate>
                                                                <asp:Label ID="LocLabel" runat="server" Text='<%# Eval("LocationCode") %>' ToolTip='<%# Eval("LocationName") %>'>
                                                                </asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField ItemStyle-Width="80px" HeaderText="Price/UOM" HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-HorizontalAlign="right" SortExpression="AltPrice">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="AltPriceText" runat="server"  Text='<%# Eval("AltPrice", "{0:###,##0.00} ") %>' Width="50px" 
                                                                CssClass="ws_whitebox" onfocus="javascript:this.select();"
                                                                onkeydown="javascript:if(event.keyCode==13){return event.keyCode=9;}"
                                                                onChange="ChangePrice(this);"/>
                                                                <asp:Label ID="AltUMLabel" runat="server" Text='<%# Eval("AltPriceUOM", "{0}") %>' style="text-align:left;" Width="20px" />
                                                                <asp:Label ID="PriceGluedLabel" runat="server"  Text='<%# Eval("PriceGlued") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="TotalPrice" HeaderText="Extended Amount" DataFormatString="{0:#,##0.00} "
                                                            ItemStyle-Width="60" SortExpression="TotalPrice" ItemStyle-HorizontalAlign="Right"
                                                            HeaderStyle-HorizontalAlign="center" />
                                                        <asp:BoundField DataField="MarginDollars" HeaderText="Mrgn $" DataFormatString="{0:#,##0.00} "
                                                            ItemStyle-Width="40" SortExpression="MarginDollars" ItemStyle-HorizontalAlign="Right"
                                                            HeaderStyle-HorizontalAlign="center" />
                                                        <asp:TemplateField ItemStyle-Width="55px" HeaderText="%" HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-HorizontalAlign="right" SortExpression="MarginPcnt">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="MarginPcntText" runat="server"  Text='<%# Eval("MarginPcnt", "{0:###,##0.00} ") %>' Width="50px" 
                                                                CssClass="ws_whitebox" onfocus="javascript:this.select();"
                                                                onkeydown="javascript:if(event.keyCode==13){return event.keyCode=9;}"
                                                                onChange="ChangeMarginPcnt(this);"/>
                                                                <asp:Label ID="MarginPcntLabel" runat="server"  Text='<%# Eval("MarginPcnt", "{0:###,##0.00} ") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField ItemStyle-Width="40" HeaderText="Update" HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-HorizontalAlign="center">
                                                            <ItemTemplate>
                                                                <asp:CheckBox ID="SelectCheckBox" runat="server" />
                                                                <asp:HiddenField ID="QuoteNumberHidden" runat="server" Value='<%# Eval("QuoteNumber") %>' />
                                                                <asp:HiddenField ID="UpdatedHidden" runat="server" Value='<%# Eval("Checked") %>' />
                                                                <asp:HiddenField ID="OrderSourceHidden" runat="server" Value='<%# Eval("OrderSource") %>' />
                                                                <asp:HiddenField ID="MakeOrderByHidden" runat="server" Value='<%# Eval("MakeOrderID") %>' />
                                                                <asp:HiddenField ID="UnitPriceHidden" runat="server" Value='<%# Eval("UnitPrice") %>' />
                                                                <asp:HiddenField ID="UnitCostHidden" runat="server" Value='<%# Eval("UnitCost") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                    <PagerStyle HorizontalAlign="Left" />
                                             </asp:GridView>
                                            </asp:Panel>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                    </asp:Panel>
                                    </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="Left5pxPadd">
                        <table width="100%" style="border: 1px solid #88D2E9; height: 25px; display: block;">
                            <tr>
                                <td valign="middle">
                                    <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:Label ID="MessageLabel" runat="server"></asp:Label>&nbsp;
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
<%--                                <td align="center" style="width: 75px;">
                                    <asp:UpdatePanel ID="UpdateUpdatePanel" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:ImageButton ID="UpdateButton" runat="server" ImageUrl="Common/Images/Update.gif" 
                                        OnClick="UpdateButton_Click"  CausesValidation="false" />
                                    </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
--%>                                <td align="center" style="width: 75px;">
                                    <img src="Common/images/help.gif" style="cursor: hand" alt="Click here for Help"
                                        onclick="OpenHelp('QuoteRecall');" />
                                </td>
                                <td align="center" style="width: 75px;">
                                    <asp:ImageButton ID="CloseButt" runat="server" CausesValidation="false" OnClientClick="ClosePage();return false;" 
                                    ImageUrl="Common/Images/close.gif" AccessKey="c" 
                                    onkeyDown="javascript:if(event.keyCode==13){this.click();return false;}"/>
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
