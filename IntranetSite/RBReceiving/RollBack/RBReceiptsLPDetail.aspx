<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RBReceiptsLPDetail.aspx.cs" Inherits="RBReceiptsLPDetail" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage.ascx" TagName="Footer" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script>
        function ClosePage()
        {
            window.close();	
        }

        function FlipAll(newState)
        {
            var CheckValue = true;
            CheckValue = newState;
            TBLControl = $get("LPNGridView");
            if (TBLControl != null)
            {
                TotQty = 0;
                RemBrCount = 0;
                var MakeBoxes = TBLControl.getElementsByTagName("INPUT");
                for (var i = 0, il = MakeBoxes.length; i < il; i++)
                {
                    var tinput = MakeBoxes[i];
                    // ignore the hidden cost fields
                    if (tinput.getAttribute("type")=="checkbox" && !tinput.disabled)
                    {
                        tinput.checked = CheckValue;
                        if (CheckValue)
                        {
                            // set the qty to recieve
                            if (tinput.parentNode.tagName == "TD")
                            {
                                var LineParent = tinput.parentNode.parentNode;
                            }
                            else
                            {
                                var LineParent = tinput.parentNode.parentNode.parentNode;
                            }
                            var ToRecQty = LineParent.childNodes[4].firstChild;
                            //alert(ToRecQty.value);
                            ToRecQty.value = parseInt(LineParent.childNodes[5].innerText, 10) - (parseInt(LineParent.childNodes[6].innerText, 10) + parseInt(LineParent.childNodes[7].firstChild.value, 10));
                        }
                    }
                }
                var status = RBReceiptsLPDetail.SetAllCheckBoxData(
                    CheckValue
                    ).value;
            }
        }
        // Adjustment check box
        function FlipAdjust(CurCheckBox)
        {
            if (CurCheckBox.parentNode.tagName == "TD")
            {
                var cellInputs = CurCheckBox.parentNode.getElementsByTagName("INPUT");
                var LineParent = CurCheckBox.parentNode.parentNode;
            }
            else
            {
                var cellInputs = CurCheckBox.parentNode.parentNode.getElementsByTagName("INPUT");
                var LineParent = CurCheckBox.parentNode.parentNode.parentNode;
            }
            //alert(CurCheckBox.checked);
            //alert(LineParent.childNodes[1].innerText);
            // Update the field in the session data table
            var status = RBReceiptsLPDetail.SetLineCheckBoxData(
                LineParent.childNodes[1].innerText
                ,CurCheckBox.checked
                ).value;
            //alert(status);
        }
        function ShowAdjust(AdjustDesc)
        {
            // replace the value with the drop down box
            var AdjustDropDown = document.getElementById("AdjustDropDownList").cloneNode(true);
            AdjustDropDown.id = AdjustDesc.id;
            AdjustDropDown.style.display = "inline";
            AdjustDropDown.style.width = "130px";
            for (i=0;i<AdjustDropDown.length;i++)
            {
                if (AdjustDesc.innerText == AdjustDropDown.options[i].text)
                {
                    AdjustDropDown.selectedIndex=i;
                }
            }
            AdjustDesc.parentNode.replaceChild(AdjustDropDown,AdjustDesc);
            //alert(status);
        }
        function ChangeAdjust(AdjustDropDown)
        {
            //alert(AdjustDropDown.parentNode.parentNode.childNodes[1].innerText);
            // get the item number from the front of the row
            var status = RBReceiptsLPDetail.UpdAdjust(
                AdjustDropDown.parentNode.parentNode.childNodes[1].innerText
                ,AdjustDropDown.options[AdjustDropDown.selectedIndex].value
                ,AdjustDropDown.options[AdjustDropDown.selectedIndex].text
                ).value;
            //alert(status);
        }
        function ChangeRcvQty(RcvQty)
        {
            // get the item number from the front of the row
            var status = RBReceiptsLPDetail.UpdRcvQty(
                RcvQty.parentNode.parentNode.childNodes[1].innerText
                ,RcvQty.value
                ).value;
            //alert(status);
        }

        function ChangeAdjQty(AdjQty)
        {
            // get the item number from the front of the row
            var status = RBReceiptsLPDetail.UpdAdjQty(
                AdjQty.parentNode.parentNode.childNodes[1].innerText
                ,AdjQty.value
                ).value;
            //alert(status);
        }


        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //take out room for bottom panel
            yh = yh - 135;
            xw = xw - 5
            // size the grid
            var DetailGridPanel = $get("DetailGridPanel");
            DetailGridPanel.style.height = yh;  
            DetailGridPanel.style.width = xw;  
            var DetailGridHeightHid = $get("DetailGridHeightHidden");
            DetailGridHeightHid.value = yh;
            var DetailGridHeightHid = $get("DetailGridWidthHidden");
            DetailGridHeightHid.value = xw;
        }
    </script>
    <style type="text/css">
    /* Styles */
    .blackLink
    {
	    cursor: hand;
	    font-weight: bold;
	    color: #000000;
	    text-decoration: underline;
    }

    .ws_whitebox 
    {
	    font-family:  Helvetica, Arial, sans-serif;
	    font-size: 11px;
	    color: #003366;	
	    background:#ffffff;	
	    border: 1px solid Gray;
	    font-weight:normal;
	    height: 12px;
	    padding-top: 2px;
	    padding-right: 2px;
	    padding-bottom: 3px;
	    padding-left: 2px;
	    text-align: right;
    }
    .noDisplay
    {
	    display: none;
    }
    </style>

    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <title>License Plate Detail</title>
</head>
<body onload="SetHeight();" onresize="SetHeight();" >
    <asp:SqlDataSource ID="AdjustCodes" runat="server" ConnectionString="<%$ ConnectionStrings:PFCERPConnectionString %>"  
        SelectCommand="select * from (select Dsc FROM Tables with (NOLOCK) where ((TableType = 'RES') and (IMApp = 'Y')) union select ' None' as Dsc ) Reasons Order by Dsc" >
        </asp:SqlDataSource>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="LPNSummScriptManager" runat="server" EnablePartialRendering="true" />
    <div>
        <asp:DropDownList ID="AdjustDropDownList" runat="server" DataTextField="Dsc" DataValueField="Dsc" CssClass="noDisplay"
        DataSourceID="AdjustCodes" onChange="ChangeAdjust(this);">
        </asp:DropDownList>
        <table width="100%" cellspacing="0" cellpadding="0" border="0">
            <tr>
                <td>
                    <uc1:Header id="Pageheader" runat="server">
                    </uc1:Header>

                </td>
            </tr>
            <tr>
                <td  class="BluBg bottombluebor" style="height:20px;">
                <span class="BannerText">&nbsp;&nbsp;&nbsp;&nbsp;License Plate Detail</span>
                </td>
            </tr>
            <tr>
                <td class="BluBg bottombluebor">
                    <table width="100%">
                        <tr>
                            <td>&nbsp;&nbsp;&nbsp;
                            <a onclick="FlipAll(true);" class="blackLink">Check All</a>
                            &nbsp;&nbsp;&nbsp;&nbsp; 
                            <a onclick="FlipAll(false);" class="blackLink">Clear All</a>
                            </td>
                            <td>&nbsp;<b>Location:
                                &nbsp;<asp:Label ID="LocLabel" runat="server"></asp:Label></b>
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>License Plate Number
                                &nbsp;<asp:Label ID="LPNLabel" runat="server"></asp:Label></b>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="BluBg">
                    <asp:Panel ID="DetailGridPanel" runat="server"  ScrollBars="both" Height="500px" Width="980px">
                        <asp:HiddenField ID="DetailGridHeightHidden" runat="server" />
                        <asp:HiddenField ID="DetailGridWidthHidden" runat="server" />
                    <asp:UpdatePanel ID="DetailGridUpdatePanel" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                    <asp:GridView ID="LPNGridView" runat="server" HeaderStyle-CssClass="GridHead"  AutoGenerateColumns="false"
                    RowStyle-BackColor="#FFFFFF" RowStyle-CssClass="Left5pxPadd" AllowSorting="true" OnSorting="SortDetailGrid"
                    PagerSettings-Position="TopAndBottom" PageSize="25" onpageindexchanging="DetailGridView_PageIndexChanging"
                    OnRowDataBound="DetailRowBound" AllowPaging="true" PagerSettings-Visible="true" PagerSettings-Mode="Numeric"
                    >
                    <AlternatingRowStyle CssClass="Left5pxPadd" BackColor="#DCF3FB" BorderColor="#DAEEEF" />
                    <Columns>
                        <asp:TemplateField ItemStyle-Width="40" HeaderText="Select" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="center" SortExpression="Adjust">
                            <ItemTemplate>
                                <asp:CheckBox ID="SelectCheckBox" runat="server" onclick="FlipAdjust(this);" Checked='<%# Eval("Adjust") %>'/>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="ItemNo" HeaderText="Item Number" ItemStyle-HorizontalAlign="center" 
                            ItemStyle-CssClass="rightBorder" ItemStyle-Width="110px" HeaderStyle-HorizontalAlign="Center"
                            SortExpression="ItemNo" />
                        <asp:BoundField DataField="Bin" HeaderText="Bin" ItemStyle-HorizontalAlign="center" 
                            ItemStyle-CssClass="rightBorder" ItemStyle-Width="60px" HeaderStyle-HorizontalAlign="Center"
                            SortExpression="Bin" />
                        <asp:BoundField DataField="DateCreate" HeaderText="Create Date" ItemStyle-HorizontalAlign="center" 
                            DataFormatString="{0:MM/dd/yyyy}" ItemStyle-CssClass="rightBorder" ItemStyle-Width="70px" 
                            SortExpression="DateCreate" HeaderStyle-HorizontalAlign="Center"/>
                        <asp:TemplateField ItemStyle-Width="85px" HeaderText="To Receive" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="ToRcvQty">
                            <ItemTemplate>
                                <asp:TextBox ID="RcvQtyText" runat="server"  Text='<%# Eval("ToRcvQty", "{0:###,##0} ") %>' Width="80px" 
                                CssClass="ws_whitebox" onfocus="javascript:this.select();"  onChange="ChangeRcvQty(this);"
                                onkeydown="javascript:if(event.keyCode==13){return event.keyCode=9;}" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="OrigQty" HeaderText="Bin Qty" DataFormatString="{0:#,##0} "
                            ItemStyle-Width="80" SortExpression="OrigQty" ItemStyle-HorizontalAlign="Right"
                            HeaderStyle-HorizontalAlign="center" />
                        <asp:BoundField DataField="RcvdQty" DataFormatString="{0:#,##0} " HeaderStyle-HorizontalAlign="center"
                            HeaderText="Rcvd Qty" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="80" SortExpression="RcvdQty" />
                        <asp:TemplateField ItemStyle-Width="85px" HeaderText="To Adjust" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="AdjustQty">
                            <ItemTemplate>
                                <asp:TextBox ID="AdjQtyText" runat="server" Width="80px"  Text='<%# Eval("AdjustQty") %>'
                                CssClass="ws_whitebox" onfocus="javascript:this.select();"  onChange="ChangeAdjQty(this);"
                                onkeydown="javascript:if(event.keyCode==13){return event.keyCode=9;}"
                                />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Adjust Reason" ItemStyle-HorizontalAlign="center"
                            ItemStyle-Width="130" SortExpression="AdjustDesc">
                            <ItemTemplate>
                                <asp:Label ID="AdjustLabel" runat="server" Text='<%# Eval("AdjustDesc") %>' 
                                onClick="ShowAdjust(this);" CssClass="blackLink">
                                </asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="BOLNo" HeaderText="BOL Number" ItemStyle-HorizontalAlign="left" 
                            ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="110px" HeaderStyle-HorizontalAlign="Center"
                            SortExpression="BOLNo" />
                        <asp:BoundField DataField="ContainerNo" HeaderText="Container Number" ItemStyle-HorizontalAlign="left" 
                            ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="110px" HeaderStyle-HorizontalAlign="Center"
                            SortExpression="ContainerNo" />
                    </Columns>
                    </asp:GridView>
                    </ContentTemplate>
                    </asp:UpdatePanel>
                    </asp:Panel>
               </td>
            </tr>
            <tr>
                <td class="BluBg">
                    <table width="100%">
                        <tr>
                            <td align="left">&nbsp;&nbsp;&nbsp;
                            <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>&nbsp;
                                <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                            </ContentTemplate></asp:UpdatePanel>
                            </td>
                            <td>&nbsp;
                            </td>
                            <td align="right">
                                <asp:UpdatePanel ID="ActionUpdatePanel" runat="server">
                                <ContentTemplate>
                                <asp:ImageButton id="AdjustSubmit" name="AdjustSubmit" OnClick="AdjustSubmit_Click" AlternateText="Make the Adjustments shown Above"
                                    runat="server" ImageUrl="../Common/Images/accept.jpg" CausesValidation="false" />
                                <img src="../Common/Images/close.gif" style="cursor: hand" onclick="ClosePage();" alt="Close Page">
                                </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                    

                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer id="PageFooter" runat="server">
                    </uc2:Footer>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
