<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ProcessMaint.aspx.cs" Inherits="ProcessMaint" %>

<%----%>
<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage2.ascx" TagName="BottomFooter" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MRP Process</title>

    <script type="text/javascript">
    window.onbeforeunload = confirmExit;
    var IsClosing = false;
    function confirmExit()
    {
        // validate process
        var CurProcess = document.getElementById("CurProcess").value;
        if ((CurProcess != "") && (IsClosing))
        {
            IsClosing = false;
            var status = ProcessMaint.ProcessValidate(
                document.getElementById("CurProcess").value
                ).value;
            if (status.substr(0,2)=="!!")
            {
               //alert(status);
               return status;
            }
            if (status!="true")
            {
               return status;
            }
        }
    }

    function pageUnload() 
    {
        IsClosing = true;
    }
    function ClosePage()
    {
        IsClosing = true;
        window.close();	
    }
    function SetHeight()
    { 
        var yh = document.documentElement.clientHeight;  
        var xw = document.documentElement.clientWidth;  
        //take out room for header and footer
        yh = yh - 287;
        xw = xw - 310;
        // we resize the panels
        if (document.getElementById("TreePanel") != null)        
        {    
            var Tree = $get("TreePanel");
            Tree.style.height = yh + 153;  
            Tree.style.width = 300;  
        }
        if (document.getElementById("ProcessPanel") != null)        
        {    
            var ProcessPnl = $get("ProcessPanel");
            ProcessPnl.style.height = 150;  
            ProcessPnl.style.width = xw;  
        }
        if (document.getElementById("FilterPanel") != null)        
        {    
            //var DetailPanel = $get("DetailPanel");
            //DetailPanel.style.height = yh - 25;  
            var FilterPnl = $get("FilterPanel");
            FilterPnl.style.height = yh * 0.50;  
            FilterPnl.style.width = xw;  
           // var MaintGridHeightHid = $get("MaintGridHeightHidden");
            //MaintGridHeightHid.value = yh - 85;
            //var MaintGridWidthHid = $get("MaintGridWidthHidden");
            //MaintGridWidthHid.value = xw - 5;
        }
        if (document.getElementById("StepPanel") != null)        
        {    
            //var DetailPanel = $get("DetailPanel");
            //DetailPanel.style.height = yh - 25;  
            var StepPnl = $get("StepPanel");
            StepPnl.style.height = yh * 0.50;  
            StepPnl.style.width = xw;  
           // var MaintGridHeightHid = $get("MaintGridHeightHidden");
            //MaintGridHeightHid.value = yh - 85;
            //var MaintGridWidthHid = $get("MaintGridWidthHidden");
            //MaintGridWidthHid.value = xw - 5;
        }
    }

    function ConfirmDelete(FilterCode, FilterName)
    { 
        var ConfirmPrompt = "Press OK to delete this step.\n\nCategory Filter Code : " + FilterCode + "\nCategory Filter Name : " + FilterName + "\n\nPress Cancel if you do NOT want to delete this step.";
        if (confirm(ConfirmPrompt))
        {
            var ID = document.getElementById("HiddenID");
            ID.value = FilterCode;
            //alert('deleting ' + StepCode);
            document.form1.DeleteButton.click();
        }
    }
    </script>

    <link href="../common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body onload="SetHeight();" onresize="SetHeight();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MRPScriptManager" runat="server"  />
        <uc1:header id="Header1" runat="server" /><%----%>
        <div>
            <asp:UpdatePanel ID="MainUpdatePanel" runat="server">
                <ContentTemplate>
                    <table width="100%" cellspacing="0" cellpadding="0">
                        <tr>
                            <td valign="middle" class="PageHead" colspan="2">
                                <span class="Left5pxPadd">
                                    <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="MRP Process Maintenance"></asp:Label>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" colspan="2">
                                <asp:UpdatePanel ID="CommandUpdatePanel" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td width="100" class="PageBg">
                                                    <asp:Label ID="TableFilterLabel" CssClass="boldText Left5pxPadd" runat="server" Text="Select Process"></asp:Label>
                                                </td>
                                                <td width="100" class="PageBg">
                                                    <asp:DropDownList ID="ProcessDropDown" runat="server" Style="width: 120px;" DataTextField="ConfigName"
                                                        DataValueField="ConfigName">
                                                    </asp:DropDownList>
                                                    <input id="PrintHide" name="PrintHide" type="hidden" value="Print" />
                                                    <asp:HiddenField ID="PageFunc" runat="server" />
                                                    <asp:HiddenField ID="HiddenID" runat="server" />
                                                    <asp:HiddenField ID="CurProcess" runat="server" />
                                                </td>
                                                <td class="PageBg">
                                                    <asp:ImageButton ID="FindButt" runat="server" ImageUrl="../common/Images/search.gif"
                                                        CausesValidation="False" OnClick="SearchData" />&nbsp;
                                                    <asp:ImageButton ID="AddButt" runat="server" ImageUrl="../common/Images/newadd.gif"
                                                        CausesValidation="False" OnClick="StartAdd" />&nbsp;&nbsp;
                                                </td>
                                                <td class="PageBg">
                                                    <asp:Label ID="MessageLabel" runat="server"></asp:Label>&nbsp;
                                                </td>
                                                <td align="right" class="PageBg" valign="bottom" width="180">
                                                    <table border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td style="padding-left: 5px">
                                                                <img id="Img1" runat="server" src="../common/Images/Print.gif" alt="Print" onclick="javascript:PrintPage();" style="display:none;"/>
                                                                <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="../common/Images/Close.gif"
                                                                   OnClientClick="javascript:ClosePage();" CausesValidation="false"  />
                                                            </td>
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
                            <td rowspan="4" valign="top" width="300">
                                <asp:Panel CssClass="tree" ID="TreePanel" runat="server" Height="530px" Width="350px"
                                    BorderColor="black" BorderWidth="1" ScrollBars="Auto">
                                    <asp:TreeView ID="ProcessTreeView" runat="server" ExpandDepth="FullyExpand">
                                        <%-- Visible="false"  OnSelectedNodeChanged="HandleTree"--%>
                                        <Nodes>
                                        </Nodes>
                                    </asp:TreeView>
                                </asp:Panel>
                            </td>
                            <td>
                                <asp:Panel ID="ProcessPanel" runat="server" Height="155px" Width="650" ScrollBars="Auto"
                                    BorderColor="black" BorderWidth="1">
                                    <asp:UpdatePanel ID="ProcessUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <table cellspacing="0" width="100%">
                                                <tr class="Left5pxPadd">
                                                    <td colspan="2" class="redtitle2">
                                                        Process Data</td>
                                                </tr>
                                                <tr>
                                                    <td class="Left5pxPadd" style="width:50%;">
                                                        Process Code
                                                    </td>
                                                    <td style="width:50%;">
                                                        <asp:TextBox ID="MstrConfigCodeTextBox" runat="server"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left5pxPadd">
                                                        Process Name
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="MstrConfigNameTextBox" runat="server"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left5pxPadd">
                                                        Packing Branch</td>
                                                    <td>
                                                        <asp:DropDownList ID="PackBranchDropDownList" runat="server" Style="width: 250px;"
                                                            DataTextField="LocGlued" DataValueField="LocID">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left5pxPadd">
                                                        Include Unplated Parents in Need Fulfillment
                                                    </td>
                                                    <td>
                                                        <asp:CheckBox ID="IncUnPlatedCheckBox" runat="server" />
                                                    </td>
                                                </tr>
                                                <tr class="PageBg">
                                                    <td style="padding-left: 5px">
                                                        <asp:ImageButton ID="ProcessSaveButton" runat="server" ImageUrl="../common/Images/accept.jpg"
                                                            OnClick="SaveData" />
                                                        <asp:ImageButton ID="ProcessDoneButton" runat="server" ImageUrl="../common/Images/done.gif"
                                                            OnClick="CloseProcessPane" CausesValidation="False" />
                                                    </td>
                                                    <td style="padding-left: 5px">
                                                        Accept will save your changes. Done will close this panel (without saving your changes).
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Panel ID="FilterPanel" runat="server" Height="171px" Width="650" ScrollBars="Auto"
                                    BorderColor="black" BorderWidth="1">
                                    <asp:UpdatePanel ID="FilterUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <table cellspacing="0" width="100%">
                                                <tr class="Left5pxPadd">
                                                    <td colspan="3" class="redtitle2">
                                                        Filters Linked to Process</td>
                                                </tr>
                                                <tr>
                                                    <td class="Left5pxPadd">
                                                        Filter</td>
                                                    <td>
                                                        <asp:DropDownList ID="FilterDropDown" runat="server" Style="width: 250px;" DataTextField="FilterGlued"
                                                            DataValueField="FilterCode">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="PageBg Left5pxPadd">
                                                        <asp:ImageButton ID="FilterSaveButt" runat="server" ImageUrl="../common/Images/newadd.gif"
                                                            OnClick="FilterSave" />
                                                    </td>
                                                    <td colspan="2" class="PageBg">
                                                        <asp:Label ID="FilterMessage" runat="server"></asp:Label>&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3">
                                                        <asp:HiddenField ID="FilterGridHeightHidden" runat="server" />
                                                        <asp:HiddenField ID="FilterGridWidthHidden" runat="server" />
                                                        <asp:GridView ID="FilterGrid" runat="server" AllowSorting="True" AutoGenerateColumns="False" CssClass="grid" HeaderStyle-CssClass="gridHeader"
                                                        DataKeyNames="pMasterCategoryLinkID" OnRowDeleting="FilterDeleteHandler" OnSorting="SortFilterGrid">
                                                            <Columns>
                                                                <asp:CommandField ShowDeleteButton="True" />
                                                                <asp:BoundField DataField="FilterCode" HeaderText="Code" ReadOnly="True" SortExpression="BegCat"
                                                                    HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="80" />
                                                                <asp:BoundField DataField="FilterName" HeaderText="Name" ReadOnly="True" SortExpression="BegCat"
                                                                    HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="left" ItemStyle-Width="150" />
                                                                <asp:BoundField DataField="BegCategory" HeaderText="Beg." ReadOnly="True" SortExpression="BegCategory"
                                                                    HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                                                <asp:BoundField DataField="EndCategory" HeaderText="End" ReadOnly="True" SortExpression="EndCategory"
                                                                    HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                                                <asp:BoundField DataField="PackageRange" HeaderText="Pkg." ReadOnly="True" SortExpression="PackageRange"
                                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                                                <asp:BoundField DataField="PlateRange" HeaderText="Plate" ReadOnly="True" SortExpression="PlateRange"
                                                                    ItemStyle-HorizontalAlign="Center" />
                                                                <asp:BoundField DataField="EntryID" HeaderText="Entry ID" SortExpression="EntryID"
                                                                    ReadOnly="true" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                    ItemStyle-Width="60" />
                                                                <asp:BoundField DataField="EntryDt" HeaderStyle-HorizontalAlign="Center" HeaderText="Entry Date"
                                                                    ReadOnly="true" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="130" SortExpression="EntryDt" />
                                                                <asp:BoundField DataField="ChangeID" HeaderStyle-HorizontalAlign="Center" HeaderText="Change ID"
                                                                    ReadOnly="true" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="60" SortExpression="ChangeID" />
                                                                <asp:BoundField DataField="ChangeDt" HeaderStyle-HorizontalAlign="Center" HeaderText="Change Date"
                                                                    ReadOnly="true" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="130" SortExpression="ChangeDt" />
                                                                <asp:BoundField DataField="pMasterCategoryLinkID" HeaderText="ID" SortExpression="pMasterCategoryLinkID"
                                                                    ReadOnly="true" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                                            </Columns>
                                                        </asp:GridView>
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <asp:Panel ID="StepPanel" runat="server" Height="200px" Width="650" BorderColor="black"
                                    BorderWidth="1" ScrollBars="Auto">
                                    <asp:UpdatePanel ID="StepUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <table cellspacing="0" width="100%">
                                                <tr class="Left5pxPadd">
                                                    <td colspan="3" class="redtitle2">
                                                        Steps Linked to Process</td>
                                                </tr>
                                                <tr>
                                                    <td class="Left5pxPadd">
                                                        Step</td>
                                                    <td>
                                                        <asp:DropDownList ID="StepDropDown" runat="server" DataTextField="StepGlued" DataValueField="StepCode">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left5pxPadd">
                                                        Run Order</td>
                                                    <td>
                                                        <asp:TextBox ID="StepRunOrder" runat="server" Style="width: 50px;"></asp:TextBox>
                                                    </td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr class="PageBg">
                                                    <td style="padding-left: 5px">
                                                        <asp:ImageButton ID="StepSaveButt" runat="server" ImageUrl="../common/Images/newadd.gif"
                                                            OnClick="StepSave" />
                                                    </td>
                                                    <td colspan="2" style="padding-left: 5px">
                                                        <asp:Label ID="StepMessage" runat="server" CssClass="txtError"></asp:Label>&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3">
                                                        <asp:GridView ID="StepGrid" runat="server" AllowSorting="True" AutoGenerateColumns="False" CssClass="grid" HeaderStyle-CssClass="gridHeader"
                                                            OnRowDeleting="StepDeleteHandler" OnSorting="SortStepGrid">
                                                            <Columns>
                                                                <asp:CommandField ShowDeleteButton="True" />
                                                                <asp:BoundField DataField="RunOrder" HeaderText="Order" ReadOnly="True" SortExpression="RunOrder"
                                                                    HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                                                <asp:BoundField DataField="StepCode" HeaderText="Code" ReadOnly="True" SortExpression="StepCode"
                                                                    HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="left" ItemStyle-Width="80" />
                                                                <asp:BoundField DataField="StepName" HeaderText="Name" ReadOnly="True" SortExpression="StepName"
                                                                    ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="150" />
                                                                <asp:BoundField DataField="ParentROPProtectionFactor" HeaderText="ROP Factor" ReadOnly="True"
                                                                    SortExpression="ParentROPProtectionFactor" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Center" />
                                                                <asp:BoundField DataField="EntryID" HeaderText="Entry ID" SortExpression="EntryID"
                                                                    ReadOnly="true" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                                    ItemStyle-Width="60" />
                                                                <asp:BoundField DataField="EntryDt" HeaderStyle-HorizontalAlign="Center" HeaderText="Entry Date"
                                                                    ReadOnly="true" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="130" SortExpression="EntryDt" />
                                                                <asp:BoundField DataField="ChangeID" HeaderStyle-HorizontalAlign="Center" HeaderText="Change ID"
                                                                    ReadOnly="true" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="60" SortExpression="ChangeID" />
                                                                <asp:BoundField DataField="ChangeDt" HeaderStyle-HorizontalAlign="Center" HeaderText="Change Date"
                                                                    ReadOnly="true" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="130" SortExpression="ChangeDt" />
                                                                <asp:BoundField DataField="pMasterStepLinkID" HeaderText="ID" SortExpression="pMasterStepLinkID"
                                                                    ReadOnly="true" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                                            </Columns>
                                                        </asp:GridView>
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <asp:Panel ID="DetailPanel" runat="server" Width="650" Height="380" ScrollBars="Auto"
                                    Visible="false" BorderColor="black" BorderWidth="1" HorizontalAlign="Left">
                                    <asp:GridView ID="Grid" runat="server" AllowSorting="True" AutoGenerateColumns="False">
                                        <%-- OnSorting="SortStepGrid"
                DataKeyNames="ProcessRecID" OnRowEditing="GridEditHandler" OnRowDeleting="GridDeleteHandler"--%>
                                        <Columns>
                                            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                                            <asp:BoundField DataField="ProcessCode" HeaderText="Process" ReadOnly="True" SortExpression="ProcessCode"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                            <asp:BoundField DataField="StepCode" HeaderText="Step" ReadOnly="True" SortExpression="StepCode"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                            <asp:BoundField DataField="RunOrder" HeaderText="Order" ReadOnly="True" SortExpression="RunOrder"
                                                ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Center" />
                                            <asp:BoundField DataField="EnteredID" HeaderText="Entered By" ReadOnly="True" SortExpression="EnteredID"
                                                ItemStyle-HorizontalAlign="Center" />
                                            <asp:BoundField DataField="EnteredDate" HeaderText="Entered On" ReadOnly="True" SortExpression="EnteredDate"
                                                HeaderStyle-HorizontalAlign="Center" />
                                            <asp:BoundField DataField="ChangedID" HeaderText="Changed By" ReadOnly="True" SortExpression="ChangedID"
                                                ItemStyle-HorizontalAlign="Center" />
                                            <asp:BoundField DataField="ChangedDate" HeaderText="Changed On" ReadOnly="True" SortExpression="ChangedDate"
                                                HeaderStyle-HorizontalAlign="Center" />
                                            <asp:BoundField DataField="ProcessRecID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                                                SortExpression="ProcessRecID" />
                                        </Columns>
                                    </asp:GridView>
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <uc2:bottomfooter id="BottomFrame2" footertitle="MRP Process Maintenance" runat="server" /><%----%>
    </form>
</body>
</html>
