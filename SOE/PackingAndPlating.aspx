<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PackingAndPlating.aspx.cs" Inherits="ShowPackingAndPlating" %>

<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <script>
    function pageUnload() {
        SetScreenPos("PkgPlt");
    }
    function ClosePage()
    {
        window.close();	
    }
    function OpenHelp(topic)
    {
        window.open('WorkSheetHelp.aspx#' + topic + '','WorkSheetHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
    }
    function LoadRefData()
    {
        // process once
        if (document.getElementById('HasProcessed').value != '1') 
        {
            document.getElementById('HasProcessed').value = '1';
            // set the fields from the pricing worksheet if called form there
            if (window.opener.document.title == 'Worksheet')
            {
                document.getElementById('ItemNoTextBox').value = 
                    window.opener.parent.document.getElementById('InternalItemLabel').innerText;
                document.getElementById('ReqLocTextBox').value = 
                    window.opener.parent.document.getElementById('ShippingBranch').value;
                document.getElementById('ReqQtyHidden').value = 
                    window.opener.parent.document.getElementById('RequestedQtyTextBox').value;
                document.getElementById('AltQtyHidden').value = 
                    window.opener.parent.document.getElementById('AltQtyLabel').innerText;
                document.getElementById('ReqAvailHidden').value = 
                    window.opener.parent.document.getElementById('AvailableQtyLabel').innerText;
                // show the data
                document.form1.PackPlateSubmit.click();
            }
        }
    }

    function ZItem(itemNo)
    {
        var section="";
        var completeItem=0;
        var ZItemInd=$get("ItemPromptInd");
        event.keyCode=0;
        //alert(ZItemInd.value);
        if (ZItemInd.value != 'Z')
        {
            event.keyCode=9;
            return false;
        }
        // process ZItem
        switch(itemNo.split('-').length)
        {
        case 1:
            // this is actually taken care of by the item alias search
            itemNo = "00000" + itemNo;
            itemNo = itemNo.substr(itemNo.length-5,5);
            $get("ItemNoTextBox").value=itemNo+"-";  
            break;
        case 2:
            // close if they are entering an empty part
            if (itemNo.split('-')[0] == "00000") {ClosePage()};
            section = "0000" + itemNo.split('-')[1];
            section = section.substr(section.length-4,4);
            $get("ItemNoTextBox").value=itemNo.split('-')[0]+"-"+section+"-";  
            break;
        case 3:
            section = "000" + itemNo.split('-')[2];
            section = section.substr(section.length-3,3);
            $get("ItemNoTextBox").value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
            completeItem=1;
            break;
        }
        if (completeItem==1) $get("ReqLocTextBox").focus();
        return false;
    }
    function SetHeight()
    { 
        var yh = document.documentElement.clientHeight;  
        var xw = document.documentElement.clientWidth;  
        //take out room for header bottom panel
        yh = yh - 175;
        var DetailPanel = $get("ImagePanel");
        DetailPanel.style.height = yh;  
    }

    </script>
    <title>Packing & Plating Options V1.0.0</title>
    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>
    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/PriceSheetStyles.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 0px" bgcolor="#b5e7f7" onload="LoadRefData();SetHeight();" onresize="SetHeight();">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="PackPlateScriptManager" runat="server" EnablePartialRendering="true"/>
    <div>
        <table width="400px">
            <tr>
                <td class="Left5pxPadd">
                    <asp:UpdatePanel ID="HeaderUpdatePanel" runat="server">
                    <ContentTemplate>
                    <table width="395px" style="border:1px solid #88D2E9; ">
                        <tr>
                            <td class="Left5pxPadd" valign="top">
                                <table>
                                    <tr>
                                        <td class="bold">Requested Item:
                                        </td>
                                        <td colspan="2">
                                            <asp:TextBox CssClass="ws_whitebox_left" ID="ItemNoTextBox" runat="server" Text="" Width="100px"
                                            TabIndex=1 onfocus="javascript:this.select();"
                                            onkeypress="javascript:if(event.keyCode==13){ZItem(this.value);}"
                                            ></asp:TextBox>&nbsp;
                                            <asp:HiddenField ID="ItemPromptInd" runat="server" />
                                        </td>
                                        <td rowspan="2">
                                            <asp:UpdateProgress ID="HeaderUpdateProgress" runat="server">
                                            <ProgressTemplate>
                                            Loading....
                                            <asp:Image ID="ProgressImage" ImageUrl="Common/Images/PFCYellowBall.gif" runat="server" />
                                            </ProgressTemplate>
                                            </asp:UpdateProgress>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bold" >
                                            Requested Location:
                                        </td>
                                        <td align="right">
                                            <asp:TextBox CssClass="ws_whitebox_left" ID="ReqLocTextBox" runat="server" Text="" Width="60"
                                            TabIndex=2 onfocus="javascript:this.select();"
                                            onkeypress="javascript:if(event.keyCode==13){event.keyCode=0;document.form1.PackPlateSubmit.click();}"
                                            ></asp:TextBox>
                                            <asp:Button id="PackPlateSubmit" name="PackPlateSubmit" OnClick="PackPlateSubmit_Click"
                                                runat="server" Text="Button" style="display:none;"/>
                                            <asp:HiddenField ID="HasProcessed" runat="server" />
                                        </td>
                                        <td>&nbsp;&nbsp;&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td class="bold">
                                            Requested Quantity:
                                        </td>
                                        <td align="right">
                                            <asp:Label CssClass="ws_whitebox" ID="ReqQtyLabel" runat="server" Text="" Width="60"></asp:Label>
                                            <asp:HiddenField ID="ReqQtyHidden" runat="server" />
                                        </td>
                                        <td>&nbsp;&nbsp;&nbsp;</td>
                                        <td class="bold">
                                            Alt Qty:
                                        </td>
                                        <td align="right">
                                            <asp:Label CssClass="ws_whitebox" ID="AltQtyLabel" runat="server" Text="" Width="60"></asp:Label>
                                            <asp:HiddenField ID="AltQtyHidden" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bold">
                                            Requested Available:
                                        </td>
                                        <td align="right">
                                            <asp:Label CssClass="ws_whitebox" ID="ReqAvailLabel" runat="server" Text="" Width="60"></asp:Label>
                                            <asp:HiddenField ID="ReqAvailHidden" runat="server" />
                                        </td>
                                        <td>&nbsp;&nbsp;&nbsp;</td>
                                        <td class="bold">
                                            Alt Available:
                                        </td>
                                        <td align="right">
                                            <asp:Label CssClass="ws_whitebox" ID="AltAvailLabel" runat="server" Text="" Width="60"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    </ContentTemplate>
                    <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="PackPlateSubmit" />
                    </Triggers>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="Left5pxPadd" align="left" valign="middle">
                    <asp:Panel ID="ImagePanel" runat="server" Height="250px" Width="380px" style="border:1px solid #88D2E9; background-color:#FFFFFF" 
                     ScrollBars="Vertical" >
                        <asp:UpdatePanel ID="PackPlateUpdatePanel" UpdateMode="Conditional" runat="server">
                        <ContentTemplate>
                        <asp:GridView ID="PackPlateGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                         Width="90%" RowStyle-CssClass="priceDarkLabel">
                        <AlternatingRowStyle CssClass="priceLightLabel" />
                        <Columns>
                        <asp:BoundField DataField="SubItem" HeaderText="Item #" 
                            ItemStyle-HorizontalAlign="center" HeaderStyle-HorizontalAlign="Center"/>
                        <asp:BoundField DataField="QOH" HeaderText="Available" DataFormatString="{0:#,##0} " 
                            ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="70"/>
                        <asp:BoundField DataField="AltQOH" HeaderText="Total Pcs" DataFormatString="{0:#,##0} " 
                            ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="70"/>
                        <asp:BoundField DataField="SellGlued" HeaderText="Qty/Unit"  ItemStyle-Width="70"
                            ItemStyle-HorizontalAlign="center" HeaderStyle-HorizontalAlign="Center"/>
                        <asp:BoundField DataField="Plate" HeaderText="Plate" 
                            ItemStyle-HorizontalAlign="center" HeaderStyle-HorizontalAlign="Center"/>
                        </Columns>
                        </asp:GridView>
                        </ContentTemplate>
                        </asp:UpdatePanel>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td>
                    <table width="390px">
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="WebEnabledUpdatePanel" runat="server">
                                <ContentTemplate>
                                    <asp:LinkButton class="bold" runat="server" Text="Show All Packages" ID="WebEnabledLinkButton" 
                                    OnClick="WebEnabledLinkButton_Click" ToolTip="Click here to Show All Packages or Only Web Enabled"></asp:LinkButton>
                                    <asp:HiddenField ID="WebEnabledHidden" runat="server" />
                                </ContentTemplate></asp:UpdatePanel>
                            </td>
                            <td align="right">
                                <div style="width:70px;">
                                <asp:UpdatePanel ID="PrintUpdatePanel" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <uc1:PrintDialogue id="Print" runat="server">
                                        </uc1:PrintDialogue>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional"><ContentTemplate>
                                <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>&nbsp;
                                <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                                </ContentTemplate></asp:UpdatePanel>
                            </td>
                            <td align="right">
                            <asp:ImageButton ID="OKButt" runat="server"  OnClick="PackPlateSubmit_Click" ImageUrl="Common/Images/ok.gif"
                            TabIndex=4 />
                            <img src="Common/images/help.gif" style="cursor:hand" alt="Click here for Help"
                                            onclick="OpenHelp('ItemHistory');" />&nbsp;&nbsp;
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
