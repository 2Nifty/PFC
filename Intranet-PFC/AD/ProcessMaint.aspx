<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ProcessMaint.aspx.vb" Inherits="ProcessMaint" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>AD Process Maintenance</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <asp:SqlDataSource ID="ProcessNames" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnectionString %>"
        SelectCommand="SELECT DISTINCT [ProcessCode] FROM [ADProcessConfig] ORDER BY [ProcessCode]">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="StepNames" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnectionString %>"
        SelectCommand="SELECT DISTINCT StepCode FROM ADStepConfig ORDER BY StepCode"></asp:SqlDataSource>
    <form id="MainForm" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div>
            <table width="100%" cellspacing="0" cellpadding="0">
                <tr>
                    <td valign="middle" class="PageHead" colspan="2">
                        <span class="Left5pxPadd">
                            <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Auto Distribution Process Maintenance"></asp:Label>
                        </span>
                    </td>
                </tr>
                <tr>
                    <td valign="top" colspan="2">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="100" class="PageBg">
                                    <asp:Label ID="TableFilterLabel" runat="server" Text="Process"></asp:Label>
                                </td>
                                <td width="100" class="PageBg">
                                    <asp:DropDownList ID="ProcessFilter" runat="server" DataSourceID="ProcessNames" DataTextField="ProcessCode"
                                        DataValueField="ProcessCode">
                                    </asp:DropDownList>
                                    <input id="PrintHide" name="PrintHide" type="hidden" value="Print" />
                                    <asp:HiddenField ID="PageFunc" runat="server" />
                                </td>
                                <td class="PageBg">
                                    <asp:ImageButton ID="FindButt" runat="server" ImageUrl="Images/search.gif" CausesValidation="False" />
                                    <asp:ImageButton ID="AddButt" runat="server" ImageUrl="Images/newadd.gif" CausesValidation="False" />
                                    <asp:Label ID="lblErrorMessage" runat="server" CssClass="txtError"></asp:Label>
                                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen" Width="240px"></asp:Label>
                                </td>
                                <td align="right" class="PageBg" valign="bottom">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="padding-left: 5px">
                                                <img id="Img1" runat="server" src="Images/Print.gif" alt="Print" onclick="javascript:PrintPage();" />
                                                <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="Images/Close.gif" PostBackUrl="javascript:window.close();"
                                                    CausesValidation="false" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td rowspan="4" valign="top" width="350">
                        <asp:Panel CssClass="tree" ID="TreePanel" runat="server" Height="531px" Width="350px"
                            BorderColor="black" BorderWidth="1" Visible="false" ScrollBars="Auto">
                            <asp:TreeView ID="TreeView1" runat="server" OnSelectedNodeChanged="HandleTree" ExpandDepth="FullyExpand">
                            </asp:TreeView>
                        </asp:Panel>
                    </td>
                    <td align="left">
                        <asp:Panel ID="UpdPanel" runat="server" Height="104px" Width="650" Visible="false"
                            BorderColor="black" BorderWidth="1">
                            <table cellspacing="0" width="100%">
                                <tr>
                                    <td>
                                        Process<asp:HiddenField ID="UpdFunction" runat="server" />
                                        <asp:HiddenField ID="HiddenID" runat="server" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="ProcessUpd" runat="server"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:RequiredFieldValidator ID="ProcessValidator" runat="server" ErrorMessage="Process Name is required"
                                            ControlToValidate="ProcessUpd"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Step</td>
                                    <td>
                                        <asp:DropDownList ID="StepList" runat="server" DataSourceID="StepNames" DataTextField="StepCode"
                                            DataValueField="StepCode">
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Run Order</td>
                                    <td>
                                        <asp:TextBox ID="RunOrderUpd" runat="server"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:RequiredFieldValidator ID="RunValidator" runat="server" ErrorMessage="Run Order is required (Zero [0] is OK)."
                                            ControlToValidate="RunOrderUpd"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr class="PageBg">
                                    <td style="padding-left: 5px">
                                        <asp:ImageButton ID="SaveButt" runat="server" ImageUrl="Images/accept.jpg" />
                                        <asp:ImageButton ID="DoneButt" runat="server" ImageUrl="Images/done.gif" CausesValidation="False" />
                                    </td>
                                    <td colspan="2" style="padding-left: 5px">
                                        Accept will save your changes. Done will close this panel (without saving your changes).
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Panel ID="FilterPanel" runat="server" Height="148px" Width="650" Visible="false"
                            ScrollBars="Auto" BorderColor="black" BorderWidth="1">
                            <asp:UpdatePanel ID="FilterUpdatePanel" runat="server">
                                <ContentTemplate>
                                    <table>
                                        <tr>
                                            <td>
                                                Cat:
                                                <asp:TextBox ID="BegCat" runat="server" Width="50"></asp:TextBox>-
                                                <asp:TextBox ID="EndCat" runat="server" Width="50"></asp:TextBox>
                                                Pkg:<asp:TextBox ID="Package" runat="server" Width="20"></asp:TextBox>
                                                Plt:<asp:TextBox ID="Plating" runat="server" Width="15"></asp:TextBox>
                                            </td>
                                            <td rowspan="2" valign="top">
                                                Filters for
                                                <asp:Label ID="MasterLabel" runat="server" Text=""></asp:Label><br />
                                                <asp:ImageButton ID="FilterAddButt" runat="server" ImageUrl="Images/newadd.gif" />
                                                <asp:ImageButton ID="FilterSaveButt" runat="server" ImageUrl="Images/accept.jpg" />
                                                <asp:HiddenField ID="HiddenFilterID" runat="server" />
                                                <br />
                                                <asp:Label ID="FilterStat" runat="server" Text=""></asp:Label>
                                            </td>
                                            <td rowspan="2" valign="top">
                                                <table cellspacing="0" style="background-color: #EFF9FC;">
                                                    <tr>
                                                        <td colspan="3" align="center">
                                                            OverStock Filter for
                                                            <asp:Label ID="MasterLabel2" runat="server" Text=""></asp:Label><br />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">
                                                            OverStock Months:
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="OverMonths" runat="server" Width="50"></asp:TextBox>
                                                        </td>
                                                        <td rowspan="4" valign="bottom">
                                                            <asp:Label ID="OverStockStat" runat="server" Text=""></asp:Label><br />
                                                            <asp:ImageButton ID="OverStockAddButt" runat="server" ImageUrl="Images/newadd.gif" />
                                                            <asp:ImageButton ID="OverStockSaveButt" runat="server" ImageUrl="Images/accept.jpg" />
                                                            <asp:HiddenField ID="HiddenOverStockID" runat="server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">
                                                            Use Transfers?:
                                                        </td>
                                                        <td>
                                                            <asp:CheckBox ID="UseOverXfers" runat="server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">
                                                            Use On The Water?:
                                                        </td>
                                                        <td>
                                                            <asp:CheckBox ID="UseOverOTW" runat="server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">
                                                            Use RTS B?:
                                                        </td>
                                                        <td>
                                                            <asp:CheckBox ID="UseOverRTSB" runat="server" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:GridView ID="FilterGrid" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                                                    DataKeyNames="FilterRecID" OnRowEditing="FilterEditHandler" OnRowDeleting="FilterDeleteHandler"
                                                    OnSorting="SortFilterGrid">
                                                    <Columns>
                                                        <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                                                        <asp:BoundField DataField="BegCat" HeaderText="Beginning" ReadOnly="True" SortExpression="BegCat"
                                                            HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="EndCat" HeaderText="Ending" ReadOnly="True" SortExpression="EndCat"
                                                            HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="Package" HeaderText="Pkg." ReadOnly="True" SortExpression="Package"
                                                            ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="Plating" HeaderText="Plate" ReadOnly="True" SortExpression="Plating"
                                                            ItemStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="FilterRecID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                                                            SortExpression="FilterRecID" />
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
                            <asp:GridView ID="StepGrid" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                                OnSorting="SortStepGrid" DataKeyNames="ProcessRecID" OnRowEditing="GridEditHandler"
                                OnRowDeleting="GridDeleteHandler">
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
        </div>
    </form>
</body>
</html>
