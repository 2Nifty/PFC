<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SSItemBuilder.aspx.cs" Inherits="SSItemBuilder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <script>
    var DocWindow;
    var MenuCount;
    function pageUnload() 
    {
        SetScreenPos("SSItemBuild");
    }
    function ClosePage()
    {
        window.close();	
    }
    function OpenHelp(topic)
    {
        window.open('WorkSheetHelp.aspx#' + topic + '','WorkSheetHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
    }
    
    function SetItemNumber(ItemNo)
    {
        window.opener.parent.document.getElementById('ItemNoTextBox').value=ItemNo;
        window.opener.parent.document.getElementById('ItemSubmit').click();
        window.opener.parent.focus();
    }

    function MenuNav(CurOption)
    {
        var curLine = parseInt(CurOption.id.split("_")[1].substr(3), 10)-1;
        //alert(prevControl);
        if (event.keyCode==9 || event.keyCode==32 || event.keyCode==110 || event.keyCode==107 || event.keyCode==40) 
        {
            if (curLine < MenuCount)
            {
                event.keyCode=9;
                return true;
            }
            else
            {
                event.keyCode=0;
                return false; 
            }
        }
        if (event.keyCode==38 && curLine > 1) 
        {
            var prevControl = "";
            if (curLine < 10) {prevControl = CurOption.id.split("_")[0]+"_ctl0"+curLine+"_"+CurOption.id.split("_")[2];}
            if (curLine >= 10) {prevControl = CurOption.id.split("_")[0]+"_ctl"+curLine+"_"+CurOption.id.split("_")[2];}
            $get(prevControl).focus();
        }
        if (event.keyCode==13) 
        {
            //alert(CurOption);
            $get("ChapterHidden").value = CurOption.nextSibling.value;
            $get("ChapterSubmit").click();
        }
    }

    function GetMenuCount()
    {
        TBLControl = $get("dgMenu");
        if (TBLControl != null)
        {
            MenuCount = 0;
            var MenuItems = TBLControl.getElementsByTagName("INPUT");
            MenuCount = MenuItems.length;
        }
    }
    function SetMenuFormat(MenuLink, OnOff)
    {
        MenuCell = MenuLink.parentNode;
        if (OnOff)
        {
            MenuCell.className = 'leftMenuItemMo';
        }
        else
        {
            MenuCell.className = 'leftMenuItem';
        }
    }
    function SetHeight()
    { 
        var yh = document.documentElement.clientHeight;  
        var xw = document.documentElement.clientWidth;  
        //take out room for top panel
        yh = yh - 30;
        var DetailPanel = $get("ItemsPanel");
        DetailPanel.style.height = yh;  
        var PartChapters = $get("ChapterPanel");
        var PartSections = $get("SectionPanel");
        //alert(PartChapters.style.height);
        PartSections.style.height = yh - parseInt(PartChapters.style.height, 10);  
        //DetailGrid.style.height = yh;  
    }
    
    </script>

    <title>Stock Item Builder</title>

    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>

    <link href="Common/StyleSheet/SSStyle.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
    .HeadPlace
        {
	        position:absolute;
	        left: 40%;
	        top: 28px;
        }
    </style>
</head>
<body class="bold" onload="SetHeight();GetMenuCount();" onresize="SetHeight();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="SSItemBuilderScriptManager" runat="server" />
        <div>
            <table cellpadding="0" cellspacing="0" width="100%" class="panelborder">
                <tr>
                    <td class="bold">
                        &nbsp;&nbsp;&nbsp;&nbsp;Stock Status Item Builder&nbsp;
                        <asp:HiddenField ID="hidControlName" runat="server" />
                    </td>
                    <td align="right">
                        <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="~/Common/Images/Close.gif"
                            PostBackUrl="javascript:window.close();" CausesValidation="false" ToolTip="Close the Report Window" />&nbsp;
                    </td>
                </tr>
            </table>
            <asp:UpdatePanel UpdateMode="Conditional" ID="FamilyPanel" runat="server">
                <ContentTemplate>
                    <table cellspacing="0" cellpadding="0" id="mainTable" width="100%">
                        <tr>
                            <td valign="top" width="40%">
                                <table id="LeftMenu" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top">
                                        <td valign="top" class="LeftBg">
            <asp:Panel ID="ChapterPanel" runat="server" Width="100%" Height="400px">
                                            <asp:GridView ID="dgMenu" ShowHeader="false" runat="server" GridLines="Horizontal"
                                                AutoGenerateColumns="false" BorderWidth="1" OnRowDataBound="MenuRowBound" OnRowCommand="dgMenu_Command">
                                                <Columns>
                                                    <asp:TemplateField ItemStyle-Width="310px" HeaderText="Products" HeaderStyle-HorizontalAlign="Center"
                                                        ItemStyle-HorizontalAlign="left" ItemStyle-BorderColor="Blue" ItemStyle-Height="20px">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="LinkButton1" Style="text-decoration: none;" CssClass="link" CausesValidation="false"
                                                                Text='<%#DataBinder.Eval(Container,"DataItem.ChapterDesc") %>' runat="server"
                                                                CommandName="ShowProductLines" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.CHAPTER") %>'
                                                                onkeydown='return MenuNav(this);' onfocus='SetMenuFormat(this, true);' onblur='SetMenuFormat(this, false);'></asp:LinkButton>
                                                            <asp:HiddenField ID="hidValue" Value='<%#DataBinder.Eval(Container,"DataItem.CHAPTER") %>'
                                                                runat="server" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                            <asp:Button ID="ChapterSubmit" OnClick="Chapter_Click" runat="server" Text="Button"
                                                Style="display: none;" CausesValidation="false" />
                                            <asp:HiddenField ID="ChapterHidden" runat="server" />
            </asp:Panel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top" width="100%">
                                            <asp:Panel ID="SectionPanel" runat="server" Height="500px" Width="100%" CssClass="panelborder">
                                                <asp:UpdatePanel UpdateMode="Conditional" ID="ControlPanel" runat="server">
                                                    <ContentTemplate>
                                                        <table border="0" cellpadding="0" cellspacing="0" style="padding-left: 10px;" width="100%">
                                                            <tr>
                                                                <td class="panelborder">
                                                                    <table width="100%" border="0" cellpadding="1" cellspacing="0">
                                                                        <col width="40%" />
                                                                        <col width="40%" />
                                                                        <col width="20%" />
                                                                        <tr>
                                                                            <td valign="middle">&nbsp;Item Section Selectors
                                                                            </td>
                                                                            <td align="left">
                                                                                <asp:Label ID="BuiltItem" runat="server" Text=""></asp:Label>
                                                                            </td>
                                                                            <td align="right">
                                                                                <asp:ImageButton ID="GetItemButton" runat="server" ImageUrl="~/Common/Images/getitem.gif"
                                                                                    OnClick="GetItemsClick" CausesValidation="false" ToolTip="Get the List of items" />&nbsp;
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="lblProductLine" runat="server" Style="padding-left: 10px" CssClass="TabHead"
                                                                        Text="Product Line"></asp:Label>
                                                                    <asp:HiddenField ID="hidResetFlag" runat="server" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:DropDownList EnableViewState="true" ID="ddlProductLine" Width="300" CssClass="cnt"
                                                                        runat="server" onkeyDown="javascript:if(event.keyCode==9 || event.keyCode==13){document.form1.ProductLineSubmit.click();return false;}">
                                                                    </asp:DropDownList>
                                                                    <img src="Common/Images/ShowButton.gif" style="cursor: hand" onclick="document.form1.ProductLineSubmit.click();">
                                                                    <asp:Button ID="ProductLineSubmit" OnClick="ddlProductLine_SelectedIndexChanged"
                                                                        runat="server" CausesValidation="false"  style="display:none;"
                                                                        />
                                                                    <asp:HiddenField ID="hidProductLine" runat="server" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <table cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label ID="lblCategory" CssClass="TabHead" Style="padding-left: 10px" runat="server"
                                                                                    Text="Category"></asp:Label></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:DropDownList ID="ddlCategory" runat="server" Width="300" CssClass="cnt" 
                                                                                onkeyDown="javascript:if(event.keyCode==9 || event.keyCode==13){document.form1.CategorySubmit.click();return false;}">
                                                                                </asp:DropDownList>
                                                                                <img src="Common/Images/ShowButton.gif" style="cursor: hand" onclick="document.form1.CategorySubmit.click();">
                                                                                <asp:Button ID="CategorySubmit" OnClick="ddlCategory_SelectedIndexChanged" runat="server"
                                                                                    Text="Button"  style="display:none;" CausesValidation="false"
                                                                                    ToolTip="Get Diameters"/>
                                                                                <asp:HiddenField ID="hidCategory" runat="server" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <table cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label ID="lblDiameter" CssClass="TabHead" Style="padding-left: 10px" runat="server"
                                                                                    Text="Diameter"></asp:Label></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:DropDownList ID="ddlDiameter" runat="server" Width="300" CssClass="cnt" 
                                                                                onkeyDown="javascript:if(event.keyCode==9 || event.keyCode==13){document.form1.DiameterSubmit.click();return false;}">
                                                                                </asp:DropDownList>
                                                                                <img src="Common/Images/ShowButton.gif" style="cursor: hand" onclick="document.form1.DiameterSubmit.click();">
                                                                                <asp:Button ID="DiameterSubmit" OnClick="ddlDiameter_SelectedIndexChanged" runat="server"
                                                                                    Text="Button"  style="display:none;" CausesValidation="false" 
                                                                                    ToolTip="Get Lengths"/>
                                                                                <asp:HiddenField ID="hidDiameter" runat="server" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <table cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label ID="lblLength" CssClass="TabHead" Style="padding-left: 10px" runat="server"
                                                                                    Text="Length"></asp:Label></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:DropDownList ID="ddlLength" runat="server" Width="300" CssClass="cnt" 
                                                                                onkeyDown="javascript:if(event.keyCode==9 || event.keyCode==13){document.form1.LengthSubmit.click();return false;}">
                                                                                </asp:DropDownList>
                                                                                <img src="Common/Images/ShowButton.gif" style="cursor: hand" onclick="document.form1.LengthSubmit.click();">
                                                                                <asp:Button ID="LengthSubmit" OnClick="ddlLength_SelectedIndexChanged" runat="server"
                                                                                    Text="Button"  style="display:none;" CausesValidation="false" 
                                                                                    ToolTip="Get Platings"/>
                                                                                <asp:HiddenField ID="hidLength" runat="server" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
<%--                                                            <tr>
                                                                <td>
                                                                    <table cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label ID="lblPlating" CssClass="TabHead" Style="padding-left: 10px" runat="server"
                                                                                    Text="Plating"></asp:Label></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:DropDownList ID="ddlPlating" Width="300" runat="server" CssClass="cnt" 
                                                                                onkeyDown="javascript:if(event.keyCode==9 || event.keyCode==13){document.form1.PlatingSubmit.click();return false;}">
                                                                                </asp:DropDownList>
                                                                                <img src="Common/Images/ShowButton.gif" style="cursor: hand" onclick="document.form1.PlatingSubmit.click();">
                                                                                <asp:Button ID="PlatingSubmit" OnClick="ddlPlating_SelectedIndexChanged" runat="server"
                                                                                    Text="Button"  style="display:none;" CausesValidation="false" 
                                                                                    ToolTip="Find Item"/>
                                                                                <asp:HiddenField ID="hidPlating" runat="server" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <table cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label ID="lblPackage" CssClass="TabHead" Style="padding-left: 10px" runat="server"
                                                                                    Text="Package"></asp:Label></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:DropDownList ID="ddlPackage" Width="300" runat="server" CssClass="cnt" 
                                                                                onkeyDown="javascript:if(event.keyCode==9 || event.keyCode==13){document.form1.PlatingSubmit.click();return false;}">
                                                                                </asp:DropDownList>
                                                                                <img src="Common/Images/ShowButton.gif" style="cursor: hand" onclick="document.form1.PlatingSubmit.click();">
                                                                                <asp:Button ID="PackageSubmit" OnClick="ddlPackage_SelectedIndexChanged" runat="server"
                                                                                    Text="Button"  style="display:none;" CausesValidation="false" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
--%>                                                            <tr>
                                                                <td colspan="2">
                                                                    <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                                                                        <ContentTemplate>
                                                                            <asp:Label ID="MessageLabel" runat="server"></asp:Label>&nbsp;
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td width="60%" valign="top">
                                <asp:Panel ID="ItemsPanel" runat="server" Height="700px" CssClass="panelborder" ScrollBars="Vertical">
                                
                                    <div style="height: 17px;">
                                    </div>
                                    <asp:UpdatePanel ID="ItemsUpdatePanel" UpdateMode="Conditional" runat="server">
                                        <ContentTemplate>
                                            <asp:GridView ID="ItemsGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads HeadPlace"
                                                BackColor="#f4fbfd" Width="97%" OnRowDataBound="DetailRowBound">
                                                <AlternatingRowStyle BackColor="#FFFFFF" />
                                                <Columns>
                                                    <asp:TemplateField ItemStyle-Width="20%" HeaderText="Item Number" HeaderStyle-HorizontalAlign="Center"
                                                        ItemStyle-HorizontalAlign="center" SortExpression="ItemNo">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="SSLink" runat="server" Text='<%# Eval("ItemNo") %>' CausesValidation="false" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="ItemDesc" HeaderText="Description" ItemStyle-HorizontalAlign="Left"
                                                        HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="50%" />
                                                    <asp:BoundField DataField="Wght" HeaderText="Weight" ItemStyle-HorizontalAlign="right"
                                                        HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="10%" DataFormatString="{0:N2}" />
                                                    <asp:BoundField DataField="SellGlued" HeaderText="Qty/Unit" ItemStyle-HorizontalAlign="right"
                                                        HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="15%" />
                                                </Columns>
                                            </asp:GridView>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </form>
</body>
</html>
