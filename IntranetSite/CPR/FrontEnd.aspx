<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FrontEnd.aspx.cs" Inherits="CPRFrontEnd" %>

<%@ Register Src="Common/UserControls/FileUploadControl.ascx" TagName="FileUploadControl"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <script>
    function ClosePage()
    {
        if(parent.bodyframe!=null)
            parent.bodyframe.location.href="../PMReportDashboard/PMReportsDashBoard.aspx";	
    }
    function OpenHelp(topic)
    {
        window.open('CPRHelp.aspx#' + topic + '','CPRHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
    }
    function ZItem(itemNo)
    {
        var section="";
        document.getElementById("Single").checked = true;
        switch(itemNo.split('-').length)
        {
        case 1:
            event.keyCode=0;
            itemNo = "00000" + itemNo;
            itemNo = itemNo.substr(itemNo.length-5,5);
            document.getElementById("SingleItemNo").value=itemNo+"-";  
            break;
        case 2:
            event.keyCode=0;
            section = "0000" + itemNo.split('-')[1];
            section = section.substr(section.length-4,4);
            document.getElementById("SingleItemNo").value=itemNo.split('-')[0]+"-"+section+"-";  
            break;
        case 3:
            //event.keyCode=0;
            section = "000" + itemNo.split('-')[2];
            section = section.substr(section.length-3,3);
            document.getElementById("SingleItemNo").value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
            break;
        }
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
            if (sectionField.value != "")
            {
                switch(sectionNo)
                {
                case 1:
                    sectionField.value = "00000" + sectionField.value;
                    sectionField.value = sectionField.value.substr(sectionField.value.length-5,5);
                    break;
                case 2:
                    sectionField.value = "0000" + sectionField.value;
                    sectionField.value = sectionField.value.substr(sectionField.value.length-4,4);
                    break;
                case 3:
                    sectionField.value = "000" + sectionField.value;
                    sectionField.value = sectionField.value.substr(sectionField.value.length-3,3);
                    break;
                }
            }
            $get(nextControl).focus();
            event.keyCode=0;
            return false;
        }
    }

    </script>

    <title>CPR Front End</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server" defaultbutton="RunReportButt">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div>
            <table border="0" cellpadding="0" width="100%">
                <tr>
                    <td valign="middle" class="PageHead">
                        <span class="Left5pxPadd">
                            <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="CPR Web Report Item Selection"></asp:Label></span>
                        <asp:HiddenField ID="ReportType" runat="server" />
                        <asp:HiddenField ID="CurItemsName" runat="server" />
                    </td>
                    <td align="right" class="PageHead">
                        <img src="../Common/Images/close.gif" style="cursor: hand" onclick="ClosePage();">&nbsp;&nbsp;
                    </td>
                </tr>
            </table>
            <asp:Panel ID="MainPanel" runat="server" Width="100%">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td class="Left5pxPadd">
                            <asp:RadioButton ID="Excel" GroupName="RunType" Text="Excel Import" runat="server" />
                        </td>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <asp:FileUpload ID="ExcelFileUpload" runat="server" ToolTip="Use the Browse button to find a file to process"
                                            Style="cursor: hand" Width="400" />
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;<asp:ImageButton ID="ExcelLoadButt" runat="server" ImageUrl="../Common/images/submit.gif"
                                            OnClick="ExcelLoadButt_Click" ToolTip="Use the Submit button to process the file you have selected" />
                                    </td>
                                    <td>
                                        <b>&nbsp;&nbsp;<a onclick="OpenHelp('Import');" style="cursor: hand" title="Click Here for Help on Importing Files">?</a></b></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="Left5pxPadd">
                            <asp:RadioButton ID="Static" GroupName="RunType" Text="Static List" runat="server" />
                        </td>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <asp:DropDownList ID="StaticListDDL" runat="server" DataTextField="ListType" DataValueField="ListType">
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;<asp:ImageButton ID="StaticSearchButton" runat="server" ImageUrl="../Common/images/search.gif"
                                            OnClick="StaticSearchButt_Click" ToolTip="Use the Search button to filter the static lists by the list type you have selected" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="Left5pxPadd">
                            <asp:RadioButton ID="Single" GroupName="RunType" Text="Single Item" runat="server"
                                Checked="true" />
                        </td>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <asp:TextBox ID="SingleItemNo" runat="server" onkeypress="javascript:if(event.keyCode==13){ZItem(this.value);}"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="Left5pxPadd">
                            <asp:RadioButton ID="FilteredItems" GroupName="RunType" Text="Filtered Items" runat="server" />
                        </td>
                        <td class="LightBluBg">
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td class="Left5pxPadd">
                                        Cat.
                                    </td>
                                    <td>
                                        <asp:TextBox ID="BegCatTextBox" runat="server" onkeydown="return ZSect(this, 1, '', 'EndCatTextBox');" Width="45px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="EndCatTextBox" runat="server" onkeydown="return ZSect(this, 1, 'BegCatTextBox', 'BegSizeTextBox');" Width="45px"></asp:TextBox>
                                    </td>
                                    <td class="Left5pxPadd">
                                        Size
                                    </td>
                                    <td>
                                        <asp:TextBox ID="BegSizeTextBox" runat="server" onkeydown="return ZSect(this, 2, 'EndCatTextBox', 'EndSizeTextBox');" Width="35px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="EndSizeTextBox" runat="server" onkeydown="return ZSect(this, 2, 'BegSizeTextBox', 'BegVarTextBox');" Width="35px"></asp:TextBox>
                                    </td>
                                    <td class="Left5pxPadd">
                                        Var.
                                    </td>
                                    <td>
                                        <asp:TextBox ID="BegVarTextBox" runat="server" onkeydown="return ZSect(this, 3, 'EndSizeTextBox', 'EndVarTextBox');" Width="25px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="EndVarTextBox" runat="server" onkeydown="return ZSect(this, 3, 'BegVarTextBox', 'BegCFVCTextBox');" Width="25px"></asp:TextBox>
                                    </td>
                                    <td class="Left5pxPadd">
                                        CFVC
                                    </td>
                                    <td>
                                        <asp:TextBox ID="BegCFVCTextBox" runat="server" onkeydown="return ZSect(this, 0, 'EndVarTextBox', 'EndCFVCTextBox');" Width="10px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="EndCFVCTextBox" runat="server" onkeydown="return ZSect(this, 0, 'BegCFVCTextBox', 'GetListButt');" Width="10px"></asp:TextBox>
                                    </td>
                                    <td class="Left5pxPadd">
                                        &nbsp;&nbsp;<asp:ImageButton ID="GetListButt" runat="server" ImageUrl="../Common/images/submit.gif"
                                            OnClick="GetListButt_Click" onkeydown="if(event.keyCode==13) { this.click();event.keyCode=0;return false;};"
                                            ToolTip="Use the Submit button to filter the report items by the criteria you have entered on the left" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="Left5pxPadd">
                            <asp:RadioButton ID="VMI" GroupName="RunType" Text="VMI Contract" runat="server" />
                        </td>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <asp:DropDownList ID="VMIContractDDL" runat="server" DataTextField="ContractCode"
                                            DataValueField="ContractCode">
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;<asp:ImageButton ID="VMILoadButton" runat="server" ImageUrl="../Common/images/submit.gif"
                                            OnClick="VMILoadButt_Click" ToolTip="Use the Submit button to load the items from the contract you have selected" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="Left5pxPadd" colspan="3">
                            <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>&nbsp;
                            <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                        </td>
                    </tr>
                </table>
                <table border="0" cellpadding="0" width="100%" cellspacing="0">
                    <tr class="BluBg">
                        <td align="Left">
                            <table cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td valign="top">
                                        &nbsp;&nbsp;<asp:CheckBox ID="CreateStaticList" runat="server" Style="cursor: hand"
                                            Text="Create Static List from Run" ToolTip="Click Here to Create a Static List from this run" />
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;&nbsp;Static List Name:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="NewStaticListName" runat="server"></asp:TextBox>
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;<b><a onclick="OpenHelp('Static');" style="cursor: hand" title="Click Here for Help with Creating Static Lists">?</a></b>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td valign="top">
                            <img src="../Common/images/help.gif" style="cursor: hand" alt="Click here for Help"
                                onclick="OpenHelp('PageTop');" />
                        </td>
                        <td align="right" valign="middle">
                            <asp:ImageButton ID="RunReportButt" ImageUrl="../Common/images/viewReport.gif" AlternateText="View Report"
                                runat="server" OnClick="RunReportButt_Click" />
                            <asp:Label ID="RunByLabel" runat="server" Text=""></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <table border="0" cellpadding="1" cellspacing="0">
                <tr>
                    <td class="Left5pxPadd" align="left" valign="top" colspan="2">
                        <table border="0" cellpadding="1" cellspacing="0">
                            <tr>
                                <td class="LightBluBg">
                                    &nbsp;&nbsp;<b>Show Static Lists</b>
                                </td>
                                <td class="LightBluBg">
                                    <asp:ImageButton ID="ShowStaticImageButton" runat="server" ImageUrl="../Common/images/ok.gif"
                                        OnClick="ShowStaticList_Click" ToolTip="Click on this button to show the currently defined static lists" />
                                </td>
                                <td>
                                    &nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td class="LightBluBg">
                                    &nbsp;&nbsp;<b>Show AD Exception Lists</b>
                                </td>
                                <td class="LightBluBg">
                                    <asp:ImageButton ID="ShowADExceptionImageButton" runat="server" ImageUrl="../Common/images/ok.gif"
                                        OnClick="ShowADExceptionList_Click" ToolTip="Click on this button to show the currently defined Auto Distribution Exception lists" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="center" valign="bottom">
                        <b>
                            <asp:Label ID="ListPanelLabel" runat="server" Text=""></asp:Label>
                            Lists</b>
                    </td>
                    <td align="left" valign="bottom">
                        &nbsp;&nbsp; <b>Items to Report (<asp:Label ID="ItemCountLabel" runat="server" Text="0"></asp:Label>)</b>
                    </td>
                </tr>
                <tr>
                    <td class="Left5pxPadd" valign="top">
                        <asp:Panel ID="ListsPanel" runat="server" Height="200px" Width="450px" BorderColor="black"
                            BorderWidth="1" ScrollBars="vertical">
                            <asp:GridView ID="StaticListsGrid" runat="server" BackColor="#f4fbfd" AutoGenerateColumns="false"
                                BorderWidth="0" BorderStyle="None" OnRowCommand="StaticListCommand">
                                <AlternatingRowStyle CssClass="GridItem" BackColor="#FFFFFF" />
                                <Columns>
                                    <asp:BoundField HeaderText="Date" DataField="ListDate" SortExpression="ListDate"
                                        ItemStyle-Wrap="false" ItemStyle-Width="160" ItemStyle-HorizontalAlign="center"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
                                    <asp:BoundField HeaderText="User" DataField="UserID" SortExpression="UserID" ItemStyle-Wrap="false"
                                        ItemStyle-Width="100" ItemStyle-HorizontalAlign="center" ItemStyle-CssClass="rightBorder"
                                        HeaderStyle-Wrap="false"></asp:BoundField>
                                    <asp:BoundField HeaderText="List Type" DataField="ListType" SortExpression="ListType"
                                        ItemStyle-Wrap="false" ItemStyle-Width="100" ItemStyle-HorizontalAlign="center"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
                                    <asp:BoundField HeaderText="Recs" DataField="NumRecs" SortExpression="NumRecs"
                                        ItemStyle-Wrap="false" ItemStyle-Width="60" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false" DataFormatString="{0:N0}"></asp:BoundField>
                                    <asp:ButtonField ButtonType="Link" CausesValidation="False" CommandName="ShowStaticListContents"
                                        ShowHeader="False" ItemStyle-Width="50" ItemStyle-HorizontalAlign="center" Text=" Load" />
                                    <asp:TemplateField ItemStyle-Width="50px" HeaderText="" ItemStyle-HorizontalAlign="center">
                                        <ItemTemplate>
                                            <asp:LinkButton CausesValidation="false" CommandName="DelStaticListContents"
                                                CommandArgument='<%#DataBinder.Eval(Container,"RowIndex")%>'
                                                OnClientClick="javascript:if(confirm('Are you sure you want to delete the list?')==true){document.getElementById('hidDelConf').value = 'true';} else {document.getElementById('hidDelConf').value = 'false';}"
                                                runat="server" Text="Del"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <asp:GridView ID="ExceptionListsGrid" runat="server" BackColor="#f4fbfd" AutoGenerateColumns="false"
                                BorderWidth="0" BorderStyle="None" OnRowCommand="ExceptionListCommand">
                                <AlternatingRowStyle CssClass="GridItem" BackColor="#FFFFFF" />
                                <Columns>
                                    <asp:BoundField HeaderText="Date" DataField="RunDate" SortExpression="RunDate" ItemStyle-Wrap="false"
                                        ItemStyle-Width="160" ItemStyle-HorizontalAlign="center" ItemStyle-CssClass="rightBorder"
                                        HeaderStyle-Wrap="false"></asp:BoundField>
                                    <asp:BoundField HeaderText="AD Process" DataField="Process" SortExpression="Process"
                                        ItemStyle-Wrap="false" ItemStyle-Width="100" ItemStyle-HorizontalAlign="center"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
                                    <asp:BoundField HeaderText="User" DataField="RunUserID" SortExpression="RunUserID"
                                        ItemStyle-Wrap="false" ItemStyle-Width="110" ItemStyle-HorizontalAlign="center"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundField>
                                    <asp:BoundField HeaderText="Recs" DataField="NumRecs" SortExpression="NumRecs"
                                        ItemStyle-Wrap="false" ItemStyle-Width="60" ItemStyle-HorizontalAlign="right"
                                        ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false" DataFormatString="{0:N0}"></asp:BoundField>
                                    <asp:ButtonField ButtonType="Link" CausesValidation="False" CommandName="ShowExceptionListContents"
                                        ShowHeader="False" ItemStyle-Width="50" ItemStyle-HorizontalAlign="center" Text=" Load" />

                                    <asp:TemplateField ItemStyle-Width="50px" HeaderText="" ItemStyle-HorizontalAlign="center">
                                        <ItemTemplate>
                                            <asp:LinkButton CausesValidation="false" CommandName="DelExceptionListContents"
                                                CommandArgument='<%#DataBinder.Eval(Container,"RowIndex")%>'
                                                OnClientClick="javascript:if(confirm('Are you sure you want to delete the list?')==true){document.getElementById('hidDelConf').value = 'true';} else {document.getElementById('hidDelConf').value = 'false';}"
                                                runat="server" Text="Del"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                </Columns>
                            </asp:GridView>
                            <asp:HiddenField ID="hidDelConf" runat="server" />
                        </asp:Panel>
                    </td>
                    <td class="Left5pxPadd" valign="top">
                        <asp:Panel ID="CurItemsPanel" runat="server" Height="200px" Width="300px" BorderColor="black"
                            BorderWidth="1" ScrollBars="vertical">
                            <asp:GridView ID="ReportItemsGrid" runat="server" BackColor="#f4fbfd" AutoGenerateColumns="false"
                                BorderWidth="0" BorderStyle="None" AllowSorting="true" OnSorting="SortCurItems">
                                <AlternatingRowStyle CssClass="GridItem" BackColor="#FFFFFF" />
                                <Columns>
                                    <asp:BoundField HeaderText="Item" DataField="Item" SortExpression="Item" ItemStyle-Wrap="false"
                                        ItemStyle-Width="100" ItemStyle-HorizontalAlign="center" HeaderStyle-Wrap="false">
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Cat" DataField="Cat" SortExpression="Cat" ItemStyle-Wrap="false"
                                        ItemStyle-Width="60" ItemStyle-HorizontalAlign="center" HeaderStyle-Wrap="false">
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Pt" DataField="Plate" SortExpression="Plate" ItemStyle-Wrap="false"
                                        ItemStyle-Width="20" ItemStyle-HorizontalAlign="center" HeaderStyle-Wrap="false">
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Var" DataField="Var" SortExpression="Var" ItemStyle-Wrap="false"
                                        ItemStyle-Width="40" ItemStyle-HorizontalAlign="center" HeaderStyle-Wrap="false">
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
