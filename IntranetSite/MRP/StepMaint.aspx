<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StepMaint.aspx.cs" Inherits="StepMaint" %>

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
        yh = yh - 310;
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

    function ConfirmDelete(StepCode, StepName)
    { 
        var ConfirmPrompt = "Press OK to delete this step.\n\nStep Code : " + StepCode + "\nStep Name : " + StepName + "\n\nPress Cancel if you do NOT want to delete this step.";
        if (confirm(ConfirmPrompt))
        {
            var ID = document.getElementById("HiddenID");
            ID.value = StepCode;
            //alert('deleting ' + StepCode);
            document.form1.DeleteButton.click();
        }
    }
    </script>

    <title>MRP Steps</title>
    <link href="../common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body onload="SetHeight();" onresize="SetHeight();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MRPScriptManager" runat="server" />
        <uc1:header id="Header1" runat="server" /><%----%>
        <div>
            <asp:Button ID="DeleteButton" runat="server" Text="Delete" Style="display: none;"
                OnClick="DeleteData" CausesValidation="false" UseSubmitBehavior="false" />
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
                                    <asp:Label ID="lblParentMenuName" CssClass="BanText" runat="server" Text="Enter MRP Process Step Information"></asp:Label>
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
                                <table cellspacing="5" width="600">
                                    <tr>
                                        <td class="Left5pxPadd boldText">
                                            Step Code
                                            <asp:HiddenField ID="UpdFunction" runat="server" />
                                            <asp:HiddenField ID="HiddenID" runat="server" />
                                        </td>
                                        <td>
                                            <asp:TextBox ID="StepCodeTextBox" CssClass="ws_whitebox_left" runat="server" Style="width: 100px;"></asp:TextBox>
                                            &nbsp;<span style=" color:Red;">*</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left5pxPadd boldText">
                                            Step Name</td>
                                        <td>
                                            <asp:TextBox ID="StepNameTextBox" CssClass="ws_whitebox_left" runat="server" Style="width: 250px;"></asp:TextBox>
                                            &nbsp;<span style=" color:Red;">*</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left5pxPadd boldText">
                                            Parent ROP Protection Factor</td>
                                        <td>
                                            <asp:TextBox ID="ParentFactorBox" CssClass="ws_whitebox_left" runat="server" Style="width: 50px;"></asp:TextBox>
                                            &nbsp;<span style=" color:Red;">*</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left5pxPadd boldText">
                                            Step Order</td>
                                        <td>
                                            <asp:TextBox ID="StepOrderTextBox" CssClass="ws_whitebox_left" runat="server" Style="width: 50px;"></asp:TextBox>
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
                            <asp:Label ID="Label2" CssClass="BanText" runat="server" Text="MRP Process Steps"></asp:Label>
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
                                        DataKeyNames="pScanStepID" OnRowEditing="EditHandler" OnRowDeleting="DeleteHandler"
                                        OnSorting="SortHandler" Width="990px" HeaderStyle-CssClass="gridHeader" CssClass="grid">
                                        <Columns>
                                            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" HeaderText="Actions"
                                                ItemStyle-HorizontalAlign="center" ItemStyle-Width="60" />
                                            <asp:BoundField DataField="StepCode" HeaderText="Code" SortExpression="StepCode"
                                                ReadOnly="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                                ItemStyle-Width="100" />
                                            <asp:BoundField DataField="StepName" HeaderText="Name" SortExpression="StepName"
                                                ReadOnly="true" ItemStyle-VerticalAlign="Middle" ItemStyle-Width="250" HeaderStyle-HorizontalAlign="Center"
                                                ItemStyle-HorizontalAlign="Left" ItemStyle-CssClass="Left5pxPadd" />
                                            <asp:BoundField DataField="ParentROPProtectionFactor" HeaderText="ROP Prot." ReadOnly="true"
                                                SortExpression="ParentROPProtectionFactor" ItemStyle-HorizontalAlign="Center"
                                                HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:N2}" ItemStyle-Width="70" />
                                            <asp:BoundField DataField="RunOrder" HeaderText="Order" SortExpression="RunOrder"
                                                ReadOnly="true" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                ItemStyle-Width="50" />
                                            <asp:BoundField DataField="EntryID" HeaderText="Entry ID" SortExpression="EntryID"
                                                ReadOnly="true" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                ItemStyle-Width="60" />
                                            <asp:BoundField DataField="EntryDt" HeaderStyle-HorizontalAlign="Center" HeaderText="Entry Date"
                                                ReadOnly="true" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="130" SortExpression="EntryDt" />
                                            <asp:BoundField DataField="ChangeID" HeaderStyle-HorizontalAlign="Center" HeaderText="Change ID"
                                                ReadOnly="true" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="60" SortExpression="ChangeID" />
                                            <asp:BoundField DataField="ChangeDt" HeaderStyle-HorizontalAlign="Center" HeaderText="Change Date"
                                                ReadOnly="true" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="130" SortExpression="ChangeDt" />
                                            <asp:BoundField DataField="pScanStepID" HeaderText="ID" SortExpression="DetailRecID"
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
        <uc2:bottomfooter id="BottomFrame2" footertitle="MRP Step Maintenance" runat="server" /><%----%>
    </form>
</body>
</html>
