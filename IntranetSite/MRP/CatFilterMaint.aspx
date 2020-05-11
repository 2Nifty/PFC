<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CatFilterMaint.aspx.cs" Inherits="CatFilterMaint"  %>
<%----%>
<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage2.ascx" TagName="BottomFooter" TagPrefix="uc2" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <script type="text/javascript">
    function SetHeight()
    { 
        var yh = document.documentElement.clientHeight;  
        var xw = document.documentElement.clientWidth;  
        //take out room for entry aread, header and footer
        yh = yh - 360;
        // we resize the data grid
        if (document.getElementById("MaintUpdatePanel") != null)        
        {    
            //var DetailPanel = $get("DetailPanel");
            //DetailPanel.style.height = yh - 25;  
            var MaintPanel = $get("MaintGridPanel");
            MaintPanel.style.height = yh;  
            MaintPanel.style.width = xw - 5;  
            var MaintGridHeightHid = $get("MaintGridHeightHidden");
            MaintGridHeightHid.value = yh - 85;
            var MaintGridWidthHid = $get("MaintGridWidthHidden");
            MaintGridWidthHid.value = xw - 5;
        }
    }

    function ConfirmDelete(FilterCode, FilterName)
    { 
        var ConfirmPrompt = "Press OK to delete this step.\n\nCategory Filter Code : " + FilterCode + "\nCategory Filter Name : " + FilterName + "\n\nPress Cancel if you do NOT want to delete this step.";
        if (confirm(ConfirmPrompt))
        {
            var ID = document.getElementById("HiddenID");
            ID.value = FilterCode;
            //alert('deleting ' + FilterCode);
            document.form1.DeleteButton.click();
        }
    }
    </script>
   <title>MRP Category Filter</title>
    <link href="../common/StyleSheet/Styles.css" rel="stylesheet"  type="text/css" />
</head>
<body onload="SetHeight();" onresize="SetHeight();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MRPScriptManager" runat="server" />
        <uc1:header id="Header1" runat="server" /><%----%>
        <div>
            <asp:Button ID="DeleteButton" runat="server" Text="Delete" Style="display: none;"
                OnClick="DeleteData" CausesValidation="false" UseSubmitBehavior="false" />
            <asp:HiddenField ID="DefParentRoundLimit" runat="server" />
            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                <tr>
                    <td colspan="2">
                        <asp:UpdatePanel ID="SearchUpdatePanel" runat="server">
                            <ContentTemplate>
                                <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                    <tr>
                                        <td width="100" align="right">
                                            <asp:Label ID="Label1" runat="server" CssClass="boldText" Text="Search By Code"></asp:Label>
                                        </td>
                                        <td width="100" align="left">
                                            <asp:TextBox ID="SearchTextBox" CssClass="ws_whitebox_left" runat="server" Style="width: 100px;"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:ImageButton ID="SearchButt" runat="server" ImageUrl="../common/Images/search.gif"
                                                CausesValidation="False" OnClick="SearchData" />
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td valign="middle" class="lightBlueBg BluTopBord" colspan="2" style="height: 22px;">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="Left5pxPadd">
                                    <asp:Label ID="lblParentMenuName" CssClass="BanText" runat="server" Text="Enter MRP Category Filter Information"></asp:Label>
                                </td>
                                <td align="right">
                                    <asp:UpdatePanel ID="CommandUpdatePanel" runat="server" UpdateMode="conditional">
                                        <ContentTemplate>
                                            <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="../common/Images/Close.gif"
                                                PostBackUrl="javascript:window.close();" CausesValidation="false" />&nbsp;
                                            <asp:ImageButton ID="SaveButton" runat="server" ImageUrl="../common/Images/BtnSave.gif"
                                                CausesValidation="False" OnClick="SaveData" />&nbsp;
                                            <asp:ImageButton ID="AddButt" runat="server" ImageUrl="../common/Images/newadd.gif"
                                                CausesValidation="False" OnClick="AddData" />&nbsp;
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:UpdatePanel ID="AddEditUpdatePanel" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table cellspacing="5" width="700">
                                    <tr>
                                        <td class="Left5pxPadd boldText">
                                            Category Filter Code
                                            <asp:HiddenField ID="UpdFunction" runat="server" />
                                            <asp:HiddenField ID="HiddenID" runat="server" />
                                        </td>
                                        <td>
                                            <asp:TextBox ID="CatRngCodeTextBox" CssClass="ws_whitebox_left" runat="server" Style="width: 100px;"></asp:TextBox>
                                            &nbsp;<span style=" color:Red;">*</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left5pxPadd boldText">
                                            Category Filter Name</td>
                                        <td>
                                            <asp:TextBox ID="CatRngNameTextBox" CssClass="ws_whitebox_left" runat="server" Style="width: 250px;"></asp:TextBox>
                                            &nbsp;<span style=" color:Red;">*</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left5pxPadd boldText">
                                            Category Range</td>
                                        <td>
                                            <asp:TextBox ID="BegCatTextBox" CssClass="ws_whitebox_left" runat="server" Style="width: 50px;"></asp:TextBox>
                                            &nbsp;-&nbsp;
                                            <asp:TextBox ID="EndCatTextBox" CssClass="ws_whitebox_left" runat="server" Style="width: 50px;"></asp:TextBox>
                                            &nbsp;<span style=" color:Red;">*</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left5pxPadd boldText">
                                            Package Range</td>
                                        <td>
                                            <asp:TextBox ID="PackRngTextBox" CssClass="ws_whitebox_left" runat="server" Style="width: 100px;"></asp:TextBox>
                                            &nbsp;<span style=" color:Red;">*</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left5pxPadd boldText">
                                            Plating Range</td>
                                        <td>
                                            <asp:TextBox ID="PlatingRngTextBox" CssClass="ws_whitebox_left" runat="server" Style="width: 100px;"></asp:TextBox>
                                            &nbsp;<span style=" color:Red;">*</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left5pxPadd boldText">
                                            Parent Need Rounding Limit</td>
                                        <td>
                                            <asp:TextBox ID="ParentRoundingLimitTextBox" CssClass="ws_whitebox_left" runat="server" Style="width: 100px;"></asp:TextBox>
                                            &nbsp;<span style=" color:Red;">*</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left5pxPadd" colspan="2">
                                            <asp:Label ID="MessageLabel" runat="server" CssClass="txtError"></asp:Label>&nbsp;
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td valign="middle" class="lightBlueBg BluTopBord" colspan="2">
                        <span class="Left5pxPadd">
                            <asp:Label ID="Label2" CssClass="BanText" runat="server" Text="MRP Category Filters"></asp:Label>
                        </span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:UpdatePanel ID="MaintUpdatePanel" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:Panel ID="MaintGridPanel" runat="server" ScrollBars="auto">
                                    <asp:HiddenField ID="MaintGridHeightHidden" runat="server" />
                                    <asp:HiddenField ID="MaintGridWidthHidden" runat="server" />
                                    <asp:GridView ID="MaintGrid" runat="server" AllowSorting="true" AutoGenerateColumns="false"
                                        DataKeyNames="pCategoryRangeID" OnRowEditing="EditHandler" OnRowDeleting="DeleteHandler"
                                        OnSorting="SortHandler" Width="1050px" HeaderStyle-CssClass="gridHeader" CssClass="grid">
                                        <Columns>
                                            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" HeaderText="Actions"
                                                ItemStyle-HorizontalAlign="center" ItemStyle-Width="60" />
                                            <asp:BoundField DataField="FilterCode" HeaderText="Code" SortExpression="FilterCode"
                                                ReadOnly="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                                ItemStyle-Width="100" />
                                            <asp:BoundField DataField="FilterName" HeaderText="Name" SortExpression="FilterName"
                                                ReadOnly="true" ItemStyle-VerticalAlign="Middle" ItemStyle-Width="250" HeaderStyle-HorizontalAlign="Center"
                                                ItemStyle-HorizontalAlign="Left" ItemStyle-CssClass="Left5pxPadd" />
                                            <asp:BoundField DataField="BegCategory" HeaderText="Beg" ReadOnly="true"
                                                SortExpression="BegCategory" ItemStyle-HorizontalAlign="Center"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="70" />
                                            <asp:BoundField DataField="EndCategory" HeaderText="End" ReadOnly="true"
                                                SortExpression="EndCategory" ItemStyle-HorizontalAlign="Center"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="70" />
                                            <asp:BoundField DataField="PackageRange" HeaderText="Package" ReadOnly="true"
                                                SortExpression="PackageRange" ItemStyle-HorizontalAlign="Center"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="70" />
                                            <asp:BoundField DataField="PlateRange" HeaderText="Plating" ReadOnly="true"
                                                SortExpression="PlateRange" ItemStyle-HorizontalAlign="Center"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="70" />
                                            <asp:BoundField DataField="ParentRoundLimit" HeaderText="Round" ReadOnly="true"
                                                SortExpression="ParentRoundLimit" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:N2}"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="70" />
                                            <asp:BoundField DataField="EntryID" HeaderText="Entry ID" SortExpression="EntryID"
                                                ReadOnly="true" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                ItemStyle-Width="60" />
                                            <asp:BoundField DataField="EntryDt" HeaderStyle-HorizontalAlign="Center" HeaderText="Entry Date"
                                                ReadOnly="true" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="130" SortExpression="EntryDt" />
                                            <asp:BoundField DataField="ChangeID" HeaderStyle-HorizontalAlign="Center" HeaderText="Change ID"
                                                ReadOnly="true" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="60" SortExpression="ChangeID" />
                                            <asp:BoundField DataField="ChangeDt" HeaderStyle-HorizontalAlign="Center" HeaderText="Change Date"
                                                ReadOnly="true" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="130" SortExpression="ChangeDt" />
                                            <asp:BoundField DataField="pCategoryRangeID" HeaderText="ID" SortExpression="pCategoryRangeID"
                                                ReadOnly="true" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                        </Columns>
                                    </asp:GridView>
                                </asp:Panel>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
            </table>
        </div>
        <uc2:bottomfooter id="BottomFrame2" footertitle="MRP Category Filter Maintenance" runat="server" /><%----%>
    </form>
</body>
</html>
