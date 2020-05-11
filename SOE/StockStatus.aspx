<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StockStatus.aspx.cs" Inherits="StockStatus" %>

<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <script>
    var HeaderRatio = 0.2;
    var DetailRatio = 0.8;
    var ListWindow;
    var CPRWindow;
    var ParentWindow;
    var DocSOWindow;
    var DocTOWindow;
    var DocBOWindow;
    var DocPOWindow;
    var DocOWWindow;
    var DocWOWindow;
    var DocREWindow;
    var ItemBuilderWindow;

    function pageUnload() {
        if ($get("CalledBy").value == "SSList")
        {
            SetScreenPos("SSList");
        }
        if ($get("CalledBy").value == "SSParent")
        {
            SetScreenPos("SSParent");
        }
        if ($get("CalledBy").value == "")
        {
            SetScreenPos("StockStatus");
        }
        if (ListWindow != null) ListWindow.close();
        if (CPRWindow != null) CPRWindow.close();
        if (ParentWindow != null) ParentWindow.close();
    }
    function ClosePage()
    {
        window.close();	
    }
    function OpenHelp(topic)
    {
        window.open('WorkSheetHelp.aspx#' + topic + '','WorkSheetHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
    }
    function DoList()
    {
        if (ListWindow != null) {ListWindow.close();ListWindow=null;}
        ListWindow = OpenAtPos('SSItems', 'SSItemList.aspx?Cat='+$get("CatTextBox").value+'&Size='+$get("SizeTextBox").value+'&Var='+$get("VarTextBox").value, 'toolbar=0,scrollbars=0,status=0,resizable=YES', 0, 0, 700, 800);    
        return false;
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
        if (itemNo.length >= 14)
        {
            document.form1.ItemSubmit.click();
            return false;
        }
        if (itemNo.length == 0)
        {
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
        if (completeItem==1) document.form1.ItemSubmit.click();
        return false;
    }

    function ZSect(sectionField, sectionNo, prevControl, nextControl)
    {
        // 38 = uparrow, 40 = downarrow
        //alert(event.keyCode);
        if(event.keyCode==38 && sectionNo > 1)
        {
            $get(prevControl).focus();
            return false;
        };
        if(event.keyCode==40 && sectionNo < 3)
        {
            $get(nextControl).focus();
            return false;
        };
        // process category, size, variance sections
        // % is full field wildcard, ? is single character wildcard
        if(event.keyCode==13 || event.keyCode==9)
        {
            if (sectionField.value != "%")
            {
                switch(sectionNo)
                {
                case 1:
                    sectionField.value = "00000" + sectionField.value;
                    sectionField.value = sectionField.value.substr(sectionField.value.length-5,5);
                    // if there is a wilcard, go to the GetList button
                    if (sectionField.value.search(/\?/) == -1)
                    {
                        $get("ItemNoTextBox").value = sectionField.value + '-' + $get("ItemNoTextBox").value.substr(6);
                        $get(nextControl).focus();
                    }
                    else
                    {
                        $get("GetListButt").focus();
                    }
                    break;
                case 2:
                    sectionField.value = "0000" + sectionField.value;
                    sectionField.value = sectionField.value.substr(sectionField.value.length-4,4);
                    if (sectionField.value.search(/\?/) == -1)
                    {
                        $get("ItemNoTextBox").value = $get("ItemNoTextBox").value.substr(0,6) +  sectionField.value + '-' +  $get("ItemNoTextBox").value.substr(11);
                        $get(nextControl).focus();
                    }
                    else
                    {
                        $get("GetListButt").focus();
                    }
                    break;
                case 3:
                    sectionField.value = "000" + sectionField.value;
                    sectionField.value = sectionField.value.substr(sectionField.value.length-3,3);
                    if (sectionField.value.search(/\?/) == -1)
                    {
                        $get("ItemNoTextBox").value = $get("ItemNoTextBox").value.substr(0,11) +  sectionField.value;
                        $get("ItemNoTextBox").focus();
                    }
                    else
                    {
                        $get("GetListButt").focus();
                    }
                    break;
                }
                event.keyCode=0;
                return false;
            }
            else
            {
                $get("GetListButt").focus();
            
            }
        }
    }

    function CPRReport()
    {
        if (document.getElementById('CPRFactor').value == "" || document.getElementById('CPRFactor').value == null || document.getElementById('CPRFactor').value.search(/\d+/) == -1 || document.getElementById('CPRFactor').value.search(/[a-zA-Z]/) != -1)
        {
            alert("To run the CPR report you must enter a numeric factor");
            $get('CPRFactor').focus();
        }
        else
        {
            CPRWindow = window.open("/Intranetsite/CPR/CPRReport.aspx?Item=" + $get('ItemNoTextBox').value + "&Factor=" + $get('CPRFactor').value,"CPRReport","height=768,width=1024,scrollbars=yes,location=no,status=no,top="+((screen.height/2) - (760/2))+",left=0,resizable=YES","");
        }
        return false;
    }

    function ItemBuilder()
    {
        if (ItemBuilderWindow != null) {ItemBuilderWindow.close();ItemBuilderWindow=null;}
        ItemBuilderWindow = OpenAtPos('SSItemBuild', 'SSItemBuilder.aspx', 'toolbar=0,scrollbars=0,status=0,resizable=YES', 0, 0, 1000, 750);    
        return false;
    }

    function OpenParent()
    {
        if ($get("ParentCall").value == "0")
        {
            ParentWindow = OpenAtPos('SSParent', 'StockStatus.aspx?ItemNo='+$get("ParentItemHidden").value+'&ParentCall=1', 'toolbar=0,scrollbars=0,status=0,resizable=YES', 0, 0, 1100, 560);    
        }
    }
    
    function SetHeight()
    { 
        var yh = document.documentElement.clientHeight;  
        var xw = document.documentElement.clientWidth;  
        var xwHid = $get("xwHid");
        xwHid.value = xw;
        //take out room for bottom panel
        yh = yh - 160;
        //var maindiv = $get("maindiv")
        //maindiv.style.height = document.documentElement.clientHeight;  
        //var HeaderPanel = $get("HeaderPanel");
        //HeaderPanel.style.height = yh * HeaderRatio;  
        var DetailPanel = $get("DetailPanel");
        //DetailPanel.style.height = yh * DetailRatio;  
        DetailPanel.style.height = yh;  
        // set the column widths
        //var colwid = parseInt(parseInt(document.documentElement.clientWidth * 0.93, 10) / 21, 10);
        //alert(colwid);
        //var DetailGridPanel = $get("SSGridView")

        //var DetailGridPanel = $get("SSGridView")
        //DetailGridPanel.style.height = (yh * DetailRatio) - 35;  
        //DetailGridPanel.style.width = xw - 25;  
        //var DetailGridHeightHid = $get("DetailGridHeightHidden");
        //DetailGridHeightHid.value = (yh * DetailRatio) - 35;
    }

    function ShowDocs(Loc, DocType)
    {
        //if (DocType == 'SO')
        //{
            if (DocSOWindow != null) {DocSOWindow.close();DocSOWindow=null;}
            DocSOWindow = OpenAtPos('SSDocSO', 'SSDocs.aspx?ItemNo='+$get("ItemNoTextBox").value+'&Loc='+Loc+'&Type='+DocType+'&ItemDesc='+$get("ItemDescLabel").innerText, 'toolbar=0,scrollbars=0,status=0,resizable=YES', 0, 0, 800, 700);    
        //}
    }
    </script>
    <title>Stock Status</title>
    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>
    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>
    <link href="Common/StyleSheet/SSStyle.css" rel="stylesheet" type="text/css" />
</head>
<body onload="SetHeight();" onresize="SetHeight();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="StockStatusScriptManager" runat="server" />
        <div>
            <asp:UpdatePanel ID="SearchUpdatePanel" runat="server"><ContentTemplate>
            <table cellspacing="0" cellpadding="2" width="100%" class="panelborder">
                <tr>
                    <td align="right" class="bold">
                        Item Number
                    </td>
                    <td>
                        <asp:TextBox CssClass="ws_whitebox_left" ID="ItemNoTextBox" runat="server"
                            Width="100px" TabIndex="1" onfocus="javascript:this.select();" 
                            onkeydown="javascript:if(event.keyCode==13 || event.keyCode==9){return ZItem(this.value);}"></asp:TextBox>&nbsp;
                        <asp:Button ID="ItemSubmit" name="ItemSubmit" OnClick="ItemButt_Click" runat="server"
                            Text="Button" Style="display: none;" CausesValidation="false" />
                        <asp:HiddenField ID="ItemPromptInd" runat="server" Value="Z"/>
                        <asp:HiddenField ID="xwHid" runat="server" />
                        <asp:HiddenField ID="CalledBy" runat="server" />
                        <asp:HiddenField ID="ParentCall" runat="server" />
                        <asp:HiddenField ID="ParentItemHidden" runat="server" />
                        <asp:HiddenField ID="SmoothOK" runat="server" />
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td align="right" class="bold">
                        Category
                    </td>
                    <td>
                        <asp:TextBox CssClass="ws_whitebox_left" ID="CatTextBox" runat="server" Width="50px"
                        onkeydown="return ZSect(this, 1, '', 'SizeTextBox');"
                        onfocus="this.select();" ></asp:TextBox>
                    </td>
                    <td align="right" class="bold">
                        Size
                    </td>
                    <td>
                        <asp:TextBox CssClass="ws_whitebox_left" ID="SizeTextBox" runat="server" Width="40px" 
                        onkeydown="return ZSect(this, 2, 'CatTextBox', 'VarTextBox');"
                        onfocus="this.select();"></asp:TextBox>
                    </td>
                    <td align="right" class="bold">
                        Variance
                    </td>
                    <td>
                        <asp:TextBox CssClass="ws_whitebox_left" ID="VarTextBox" runat="server" Width="30px"
                        onkeydown="return ZSect(this, 3, 'SizeTextBox', '');"
                        onfocus="this.select();"></asp:TextBox>
                    </td>
                    <td align="left">
                        <asp:ImageButton ID="GetListButt" runat="server" AlternateText="Get List" ImageUrl="~/Common/Images/GetList.gif" 
                        OnClientClick="return DoList();" onkeydown="if(event.keyCode==13){this.click(); return false;};"/>
                    </td>
                    <td colspan="2">
                        <asp:UpdateProgress ID="SearchUpdateProgress" runat="server">
                            <ProgressTemplate>
                                Loading....
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </td>
                    <td style="width: 150px;" align="right">
                        <asp:ImageButton ID="ItemBuilderButt" ImageUrl="~/Common/Images/ItemBuilder.gif"
                            runat="server" AlternateText="Show Item Builder" 
                            onkeydown="if(event.keyCode==13){this.click(); return false;};"
                             OnClientClick="return ItemBuilder();"/>
                        <asp:ImageButton ID="RunCPRButt" ImageUrl="~/Common/Images/RunCPR.gif" runat="server"
                            AlternateText="Run CPR" OnClientClick="return CPRReport();"/>
                    </td>
                    <td align="left" style="width: 80px;">
                        <asp:TextBox ID="CPRFactor" runat="server" Width="30px" CssClass="cpr_box" ToolTip="Enter the FACTOR for the CPR Report"
                        onfocus="this.select();">></asp:TextBox>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td align="right">
                        <div style="width: 70px;">
                            <asp:UpdatePanel ID="PrintUpdatePanel" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <uc1:PrintDialogue id="Print" runat="server">
                                    </uc1:PrintDialogue>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </td>
                    <td align="right" style="width: 155px;">
                        <img src="Common/images/help.gif" style="cursor: hand" alt="Click here for Help"
                            onclick="OpenHelp('StockStatus');" />&nbsp;
                        <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="~/Common/Images/Close.gif"
                            PostBackUrl="javascript:window.close();" CausesValidation="false" ToolTip="Close the Report Window" />&nbsp;
                    </td>
                </tr>
            </table>
            </ContentTemplate>
            </asp:UpdatePanel>
            <asp:DataGrid ID="ItemGrid" runat="server" AutoGenerateColumns="false" PageSize="1"
                AllowPaging="true" PagerStyle-Visible="false" ShowHeader="false" BorderWidth="0">
                <AlternatingItemStyle CssClass="GridItem" BackColor="#FFFFFF" />
                <Columns>
                    <asp:BoundColumn DataField="ItemNo" DataFormatString="Item {0:G}" ItemStyle-Font-Size="14"
                        ItemStyle-Width="300" ItemStyle-HorizontalAlign="left"></asp:BoundColumn>
                </Columns>
            </asp:DataGrid>
            <asp:Panel ID="HeaderPanel" runat="server" Height="100px" Width="100%">
                <asp:UpdatePanel ID="HeaderUpdatePanel" UpdateMode="Conditional" runat="server"><ContentTemplate>
                <table width="100%" border="0" cellspacing="2" cellpadding="1">
                    <col width="9%" />
                    <col width="16%" />
                    <col width="8%" />
                    <col width="6%" />
                    <col width="9%" />
                    <col width="7%" />
                    <col width="10%" />
                    <col width="6%" />
                    <col width="8%" />
                    <col width="8%" />
                    <col width="8%" />
                    <col width="5%" />
                    <tr>
                        <td class="bold">
                            Description:
                        </td>
                        <td>
                            <asp:Label ID="ItemDescLabel" runat="server" Text="" CssClass="ws_data_left" Width="180px">
                            </asp:Label>
                        </td>
                        <td class="bold">
                            Weight/100:
                        </td>
                        <td>
                            <asp:Label CssClass="ws_data_right bold" ID="Wgt100Label" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold">
                            Sell Stock:
                        </td>
                        <td>
                            <asp:Label CssClass="ws_data_right bold" ID="QtyUOMLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold">
                            Std Cost:
                        </td>
                        <td>
                            <asp:Label CssClass="ws_data_right bold" ID="StdCostLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold">
                            UPC Code:
                        </td>
                        <td>
                            <asp:Label ID="UPCLabel" runat="server" CssClass="ws_data_right bold" Text="" Width="80px"></asp:Label>
                        </td>
                        <td class="bold">
                            Web Enabled:
                        </td>
                        <td>
                            <asp:Label ID="WebLabel" runat="server" CssClass="ws_data_right bold" Text="" Width="30px"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="bold">
                            Category:
                        </td>
                        <td>
                            <asp:Label ID="CategoryLabel" runat="server" Text="" CssClass="ws_data_left" Width="180px">
                            </asp:Label>
                        </td>
                        <td class="bold">
                            Net LB:
                        </td>
                        <td>
                            <asp:Label CssClass="ws_data_right bold" ID="NetWghtLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold">
                            Super Eqv:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="SuperEqLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold">
                            List Price:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="ListLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold">
                            Tariff:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="HarmCodeLabel" runat="server" Text="" Width="80px"></asp:Label>
                        </td>
                        <td class="bold">
                            Pkg Grp:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="PackGroupLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="bold">
                            Plating Type:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_left" ID="PlatingLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold">
                            Gross LB:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="GrossWghtLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold">
                            Price UM:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="PriceUMLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold">
                            Corp Fixed Vel:
                        </td>
                        <td class="bold">
                            <asp:Label ID="CFVLabel" runat="server" CssClass="ws_data_right" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold">
                            PPI Code:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="PPILabel" runat="server" Text="" Width="80px"></asp:Label>
                        </td>
                        <td class="bold">
                        Low Profile:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="LowProfileLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="bold">
                            Parent Item:
                        </td>
                        <td class="bold">
                            <a id="ParentLink" onclick="OpenParent();">
                            <asp:Label ID="ParentLabel" runat="server" Text="" CssClass="ws_data_left" Width="100px">
                            </asp:Label>
                            </a>
                        </td>
                        <td class="bold">
                            Stock Ind:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="StockLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold">
                            Cost UM:
                        </td>
                        <td class="bold">
                            <asp:Label CssClass="ws_data_right" ID="CostUMLabel" runat="server" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold">
                            Category Vel:
                        </td>
                        <td class="bold">
                            <asp:Label ID="CatVelLabel" runat="server" CssClass="ws_data_right" Text="" Width="50px"></asp:Label>
                        </td>
                        <td class="bold">
                            Created:
                        </td>
                        <td class="bold">
                            <asp:Label ID="CreatedLabel" runat="server" CssClass="ws_data_right" Text="" Width="80px"></asp:Label>
                        </td>
                        <td class="bold">
                            Pkg Vel:
                        </td>
                        <td class="bold">
                            <asp:Label ID="PkgVelLabel" runat="server" CssClass="ws_data_right" Text="" Width="50px"></asp:Label>
                        </td>
                    </tr>
                </table>
                </ContentTemplate>
                </asp:UpdatePanel>
            </asp:Panel>
            <asp:UpdatePanel ID="SortUpdatePanel" runat="server">
            <ContentTemplate>
            <asp:HiddenField ID="LocSortHidden" runat="server" />
            <asp:Table ID="SSHeadingTable" runat="server" CellPadding="0" CellSpacing="0" Width="100%"
                CssClass="GridHeads">
                <asp:TableRow CssClass="bold" Width="100%">
                      <asp:TableCell Width="4%" HorizontalAlign="center" RowSpan="2">
                    <asp:LinkButton ID="LocSortLinkButton" runat="server" CausesValidation="false" OnClick="LocSortLinkButton_Click">Loc.<br />Code</asp:LinkButton>
                    </asp:TableCell>
                    <asp:TableCell Width="4%" HorizontalAlign="center">30D</asp:TableCell>
                    <asp:TableCell Width="4%" HorizontalAlign="center">Sales</asp:TableCell>
                    <asp:TableCell Width="4%" HorizontalAlign="center"></asp:TableCell>
                    <asp:TableCell Width="4%" HorizontalAlign="center"></asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="23%" ColumnSpan="5">CURRENT QUANTITY</asp:TableCell>
                    <asp:TableCell ColumnSpan="5" HorizontalAlign="center" Width="23%">FUTURE QUANTITY</asp:TableCell>
                    <asp:TableCell ColumnSpan="6" HorizontalAlign="center" Width="25%">COST</asp:TableCell>
                    <asp:TableCell Width="3%" HorizontalAlign="center">Stock</asp:TableCell>
                    <asp:TableCell Width="2%">&nbsp;</asp:TableCell>
                </asp:TableRow>
                <asp:TableRow CssClass="bold" Width="100%">
                    <asp:TableCell HorizontalAlign="center" Width="4%">Usage</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="4%">Vel.</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="4%">ROP</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="4%">Days</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Avail.</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Sales</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="3%">Trans</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Back Ord</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">On Hand</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Purch</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">On Water</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="3%">Prod.</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Return</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Tr. In</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Cap</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">SAvg.</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Last</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Price</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">Replace</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="5%">SAvg.</asp:TableCell>
                    <asp:TableCell HorizontalAlign="center" Width="3%">Ind</asp:TableCell>
                    <asp:TableCell Width="2%">&nbsp;</asp:TableCell>
                </asp:TableRow>
            </asp:Table>
            </ContentTemplate>
            </asp:UpdatePanel>
            <asp:Panel ID="DetailPanel" runat="server" Width="100%" ScrollBars="both" BorderWidth="0">
                <asp:UpdatePanel ID="DetailUpdatePanel" runat="server" UpdateMode="Conditional"><ContentTemplate>
                <asp:GridView ID="SSGridView" runat="server" AutoGenerateColumns="false" BackColor="#f4fbfd" ShowFooter="true"
                    OnRowDataBound="SSLineFormat" OnDataBound="SSTotals" Width="98%" ShowHeader="false" CssClass="bold">
                    <AlternatingRowStyle BackColor="#FFFFFF" />
                    <Columns>
                        <asp:BoundField DataField="LocID" SortExpression="LocID"
                            ItemStyle-CssClass="rightBorder" ItemStyle-Width="4%" ItemStyle-HorizontalAlign="center">
                        </asp:BoundField>
                        <asp:BoundField DataField="Use30D" SortExpression="Use30D" ItemStyle-Wrap="false"
                            HtmlEncode="false" ItemStyle-Width="4%" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="rightBorder"></asp:BoundField>
                        <asp:BoundField DataField="SVCode" SortExpression="SVCode" ItemStyle-Wrap="false"
                            ItemStyle-CssClass="rightBorder" ItemStyle-Width="4%" ItemStyle-HorizontalAlign="center">
                        </asp:BoundField>
                        <asp:BoundField DataField="ROP" SortExpression="ROP" ItemStyle-Wrap="false"
                            HtmlEncode="false" ItemStyle-Width="4%" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="rightBorder"></asp:BoundField>
                        <asp:BoundField DataField="ROPDays" SortExpression="ROPDays" ItemStyle-Wrap="false"
                            HtmlEncode="false" ItemStyle-Width="4%" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="groupBorder"></asp:BoundField>
                        <asp:BoundField DataField="Avail" SortExpression="Avail" ItemStyle-Wrap="false"
                            HtmlEncode="false" ItemStyle-Width="5%" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="rightBorder"></asp:BoundField>
                        <asp:TemplateField ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="Sales" ItemStyle-CssClass="rightBorder">
                            <ItemTemplate>
                                <asp:Label ID="SalesLabel" runat="server"  Text='<%# Eval("Sales", "{0:#,##0} ") %>' />
                                <asp:LinkButton ID="SalesLink" runat="server" Text='<%# Eval("Sales", "{0:#,##0} ") %>' 
                                 CausesValidation="false" CssClass="GridLink" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="TransOut" ItemStyle-CssClass="rightBorder">
                            <ItemTemplate>
                                <asp:Label ID="TransOutLabel" runat="server"  Text='<%# Eval("TransOut", "{0:#,##0} ") %>' />
                                <asp:LinkButton ID="TransOutLink" runat="server" Text='<%# Eval("TransOut", "{0:#,##0} ") %>' 
                                 CausesValidation="false" CssClass="GridLink" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="TransOut" ItemStyle-CssClass="rightBorder">
                            <ItemTemplate>
                                <asp:Label ID="BackLabel" runat="server"  Text='<%# Eval("Back", "{0:#,##0} ") %>' />
                                <asp:LinkButton ID="BackLink" runat="server" Text='<%# Eval("Back", "{0:#,##0} ") %>' 
                                 CausesValidation="false" CssClass="GridLink" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="QOH" SortExpression="QOH" ItemStyle-Wrap="false"
                            HtmlEncode="false" ItemStyle-Width="5%" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="groupBorder"></asp:BoundField>
                        <asp:TemplateField ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="PO" ItemStyle-CssClass="rightBorder">
                            <ItemTemplate>
                                <asp:Label ID="POLabel" runat="server"  Text='<%# Eval("PO", "{0:#,##0} ") %>' />
                                <asp:LinkButton ID="POLink" runat="server" Text='<%# Eval("PO", "{0:#,##0} ") %>' 
                                 CausesValidation="false" CssClass="GridLink" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="OTW" ItemStyle-CssClass="rightBorder">
                            <ItemTemplate>
                                <asp:Label ID="OTWLabel" runat="server"  Text='<%# Eval("OTW", "{0:#,##0} ") %>' />
                                <asp:LinkButton ID="OTWLink" runat="server" Text='<%# Eval("OTW", "{0:#,##0} ") %>' 
                                 CausesValidation="false" CssClass="GridLink" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="WO" ItemStyle-CssClass="rightBorder">
                            <ItemTemplate>
                                <asp:Label ID="WOLabel" runat="server"  Text='<%# Eval("WO", "{0:#,##0} ") %>' />
                                <asp:LinkButton ID="WOLink" runat="server" Text='<%# Eval("WO", "{0:#,##0} ") %>' 
                                 CausesValidation="false" CssClass="GridLink" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="RO" ItemStyle-CssClass="rightBorder">
                            <ItemTemplate>
                                <asp:Label ID="ROLabel" runat="server"  Text='<%# Eval("RO", "{0:#,##0} ") %>' />
                                <asp:LinkButton ID="ROLink" runat="server" Text='<%# Eval("RO", "{0:#,##0} ") %>' 
                                 CausesValidation="false" CssClass="GridLink" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="5%" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="right" SortExpression="TransIn" ItemStyle-CssClass="groupBorder">
                            <ItemTemplate>
                                <asp:Label ID="TransInLabel" runat="server"  Text='<%# Eval("TransIn", "{0:#,##0} ") %>' />
                                <asp:LinkButton ID="TransInLink" runat="server" Text='<%# Eval("TransIn", "{0:#,##0} ") %>' 
                                 CausesValidation="false" CssClass="GridLink" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="AvgGlued" SortExpression="AvgSort"
                            ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-Width="5%" ItemStyle-HorizontalAlign="center"
                            ItemStyle-CssClass="groupBorder"></asp:BoundField>
                        <asp:BoundField DataField="SmoothAltAvgGlued" SortExpression="StdCostAlt"
                            ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-Width="5%" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="rightBorder"></asp:BoundField>
                        <asp:BoundField DataField="SellLastGlued" SortExpression="SellLastCost"
                            ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-Width="5%" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="rightBorder"></asp:BoundField>
                        <asp:BoundField DataField="SellPriceGlued" SortExpression="SellPriceCost"
                            ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-Width="5%" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="rightBorder"></asp:BoundField>
                        <asp:BoundField DataField="SellReplGlued" SortExpression="SellReplCost"
                            ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-Width="5%" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="rightBorder"></asp:BoundField>
                        <asp:BoundField DataField="SmoothAvgGlued" SortExpression="StdCost"
                            ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-Width="5%" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="groupBorder"></asp:BoundField>
                        <asp:BoundField DataField="Stocked" SortExpression="Stocked"
                            ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-Width="3%" ItemStyle-HorizontalAlign="right"
                            ItemStyle-CssClass="rightBorder"></asp:BoundField>
                        <asp:BoundField DataField="IMDisplayColor" SortExpression="IMDisplayColor"
                            ItemStyle-Wrap="false" HtmlEncode="false" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="invsible">
                        </asp:BoundField>
                    </Columns>
                </asp:GridView>
                <table width="98%" id="tblPager" runat="server" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <uc3:pager ID="Pager1" OnBubbleClick="Pager_PageChanged" runat="server" />
                        </td>
                    </tr>
                </table>
                </ContentTemplate>
                </asp:UpdatePanel>
                <table>
                    <tr>
                        <td>
                            <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:Label ID="MessageLabel" runat="server"></asp:Label>&nbsp;
                                    <asp:Label ID="CategorySpecLabel" runat="server" CssClass="bold"></asp:Label>&nbsp;
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                </table>
                <asp:UpdatePanel ID="MainImagePanel" runat="server">
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <asp:UpdatePanel ID="HeadImageUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:Image ID="HeadImage" runat="server" Height="75" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td>
                                    <asp:UpdatePanel ID="BodyImageUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:Image ID="BodyImage" runat="server" Height="75" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
