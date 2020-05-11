<%@ Page Language="VB" AutoEventWireup="false" EnableEventValidation="false" CodeFile="Processor.aspx.vb"
    Inherits="Processor" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>AD Processor</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
    function ShowExcel()
    {   
        window.open('Excel.aspx','' ,'resizable=YES,menubar','');
    }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="ProcessNames" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnectionString %>"
            SelectCommand="SELECT DISTINCT [ProcessCode] FROM [ADProcessConfig] ORDER BY [ProcessCode]">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="ResultsData" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnectionString %>"
            SelectCommand="SELECT * FROM ADResults" UpdateCommand="Update ADResults SET ShipQty=ShipQty WHERE (pADResultsID = @pADResultsID)">
        </asp:SqlDataSource>
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" AsyncPostBackTimeout="6000"
            runat="server">
        </asp:ScriptManager>
        <div>
            <asp:UpdatePanel ID="MainUpdatePanel" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ShowResultsButton" />
                    <asp:AsyncPostBackTrigger ControlID="CloseButton" />
                </Triggers>
                <ContentTemplate>
                    <table width="100%" cellspacing="0" cellpadding="0">
                        <tr>
                            <td valign="middle" class="PageHead" style="width: 100%;">
                                <span class="Left5pxPadd">
                                    <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Auto Distribution Processor"></asp:Label>
                                </span>
                            </td>
                        </tr>
                        <tr class="PageBg">
                            <td valign="top">
                                <asp:UpdatePanel ID="ControlUpdatePanel" runat="server">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="RunButton" />
                                        <asp:AsyncPostBackTrigger ControlID="ShowResultsButton" />
                                    </Triggers>
                                    <ContentTemplate>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="Left5pxPadd">
                                                    <asp:Label ID="TableFilterLabel" runat="server" Text="Process"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ProcessSelector" runat="server" DataSourceID="ProcessNames"
                                                        DataTextField="ProcessCode" DataValueField="ProcessCode">
                                                    </asp:DropDownList>
                                                    <input id="PrintHide" name="PrintHide" type="hidden" value="Print" />
                                                    <asp:HiddenField ID="PageFunc" runat="server" />
                                                </td>
                                                <td align="right">
                                                    <asp:ImageButton ID="RunButton" runat="server" ImageUrl="Images/submit.gif" CausesValidation="False"
                                                        OnClick="RunButton_Click" />
        <asp:HiddenField ID="RunStartTime" runat="server" />
                                                </td>
                                                <td width="300" align="left" class="Left5pxPadd">
                                                    <asp:Label ID="lblErrorMessage" runat="server" CssClass="txtError"></asp:Label>
                                                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                                                </td>
                                                <td align="right">
                                                    View Results From Last Run&nbsp; &nbsp;</td>
                                                <td align="left">
                                                    <asp:ImageButton ID="ShowResultsButton" runat="server" ImageUrl="Images/ok.gif" OnClick="ShowResults_Click" />
                                                    <asp:HiddenField ID="HiddenID" runat="server" />
                                                </td>
                                                <td>
                                                </td>
                                                <td align="right" valign="bottom">
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
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td class="Left5pxPadd">
                                <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="ControlUpdatePanel">
                                    <ProgressTemplate>
                                        Filling web page with results. Please wait.<br />
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                                <asp:UpdatePanel ID="RunStatUpdatePanel" runat="server" UpdateMode="Conditional">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ADTimer" />
                                    </Triggers>
                                    <ContentTemplate>
                                        <asp:Timer ID="ADTimer" Interval="5000" runat="server" OnTick="ADTimer_Tick" Enabled="false">
                                        </asp:Timer>
                                        <asp:Panel ID="RunStatPanel" runat="server" Height="200px" Width="100%" Visible="false">
                                            <asp:Image ID="GreenLaser" runat="server" ImageUrl="images/BURSTANI.GIF" Visible="false" /><br />
                                            <br />
                                            <asp:Label ID="RunStatLabel" runat="server" Text=""></asp:Label><br />
                                            <br />
                                            <asp:GridView ID="ExecuteGrid" runat="server" AutoGenerateColumns="true" Visible="false">
                                            </asp:GridView>
                                        </asp:Panel>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Panel ID="ResultPanel" runat="server" Height="630px" Width="100%" ScrollBars="Vertical"
                                    Visible="false" BorderWidth="0">
                                    <table cellspacing="0" cellpadding="0" border="0">
                                        <tr>
                                            <td>
                                                <asp:GridView ID="ResultsGrid" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                                                    OnSorting="SortResultsGrid" AlternatingRowStyle-BackColor="#DCF3FB" DataKeyNames="pADResultsID"
                                                    HeaderStyle-CssClass="FreezeHeading" BorderStyle="None" OnRowEditing="Row_Command" Width="800px"
                                                    OnRowUpdating="Update_Command" DataSourceID="ResultsData">
                                                    <Columns>
                                                        <asp:CommandField ShowEditButton="True" />
                                                        <asp:BoundField DataField="Item" HeaderText="Item Number" ReadOnly="True" SortExpression="Item"
                                                            HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="100"
                                                            HeaderStyle-CssClass="FreezeHeading" ItemStyle-Font-Bold="true" />
                                                        <asp:BoundField DataField="FromLoc" HeaderText="From" ReadOnly="True" SortExpression="FromLoc"
                                                            HeaderStyle-CssClass="FreezeHeading" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="CFVC" HeaderText="CFVC" ItemStyle-HorizontalAlign="Center"
                                                            HeaderStyle-CssClass="FreezeHeading" ReadOnly="True" SortExpression="CFVC" />
                                                        <asp:BoundField DataField="ToLoc" HeaderText="To" ReadOnly="True" SortExpression="ToLoc"
                                                            HeaderStyle-CssClass="FreezeHeading" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-Width="40" />
                                                        <asp:BoundField DataField="SVC" HeaderText="SVC" ReadOnly="True" SortExpression="SVC"
                                                            HeaderStyle-CssClass="FreezeHeading" ItemStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="ROP" HeaderText="ROP" ReadOnly="True" SortExpression="ROP"
                                                            HeaderStyle-CssClass="FreezeHeading" ItemStyle-HorizontalAlign="Right" ItemStyle-Font-Bold="true" />
                                                        <asp:BoundField DataField="QOH" HeaderText="QOH" ReadOnly="True" SortExpression="QOH"
                                                            HeaderStyle-CssClass="FreezeHeading" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="QOT" HeaderText="QOT" ReadOnly="True" SortExpression="QOT"
                                                            HeaderStyle-CssClass="FreezeHeading" ItemStyle-HorizontalAlign="Right" />
                                                        <asp:BoundField DataField="Qty" HeaderText="Rcm Qty" ReadOnly="True" SortExpression="Qty"
                                                            HeaderStyle-CssClass="FreezeHeading" ItemStyle-HorizontalAlign="Right" ItemStyle-Font-Bold="true"
                                                            HeaderStyle-Wrap="true" />
                                                        <asp:TemplateField HeaderText="Ship Qty" ShowHeader="True" ItemStyle-HorizontalAlign="Right"
                                                            HeaderStyle-CssClass="FreezeHeading" SortExpression="ShipQty">
                                                            <EditItemTemplate>
                                                                <asp:TextBox ID="ShipQty" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "ShipQty") %>'
                                                                    Width="50"></asp:TextBox>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <%# DataBinder.Eval(Container.DataItem, "ShipQty") %>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="right" />
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="SuperEqvQty" HeaderText="Eqv." ReadOnly="True" SortExpression="SuperEqvQty"
                                                            HeaderStyle-CssClass="FreezeHeading" ItemStyle-HorizontalAlign="Right" />
                                                        <asp:BoundField DataField="LowProfilePalletQty" HeaderText="LPP" ReadOnly="True"
                                                            HeaderStyle-CssClass="FreezeHeading" SortExpression="LowProfilePalletQty" ItemStyle-HorizontalAlign="Right" />
                                                        <asp:BoundField DataField="RDCAvail" HeaderText="RDC" ReadOnly="True" SortExpression="RDCAvail"
                                                            HeaderStyle-CssClass="FreezeHeading" ItemStyle-HorizontalAlign="Right" />
                                                        <asp:BoundField DataField="Priority" HeaderText="Hot" ReadOnly="True" SortExpression="Priority"
                                                            HeaderStyle-CssClass="FreezeHeading" ItemStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="SatisfiedByProcess" HeaderText="Process" ReadOnly="True"
                                                            HeaderStyle-CssClass="FreezeHeading" SortExpression="SatisfiedByProcess" HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="SatisfiedByStep" HeaderText="Step" ReadOnly="True" SortExpression="SatisfiedByStep"
                                                            HeaderStyle-CssClass="FreezeHeading" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                                            ItemStyle-Width="100" />
                                                        <asp:BoundField DataField="pADResultsID" HeaderText="ID" ReadOnly="True" SortExpression="pADResultsID"
                                                            HeaderStyle-CssClass="FreezeHeading" ItemStyle-HorizontalAlign="Right" />
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                            <td class="BluBg Freezer" valign="top" align="left">
                                                <center>
                                                    <table cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td class="Left5pxPadd">
                                                                Show Results in Excel
                                                            </td>
                                                            <td class="Left5pxPadd">
                                                                <asp:ImageButton ID="ResultsButt" runat="server" ImageUrl="Images/ok.gif" OnClick="ExcelResults_Click" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <hr />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="Left5pxPadd">
                                                                Show Hungry in Excel
                                                            </td>
                                                            <td class="Left5pxPadd">
                                                                <asp:ImageButton ID="HungerButt" runat="server" ImageUrl="Images/ok.gif" OnClick="ExcelHungry_Click" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <hr />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="Left5pxPadd">
                                                                Show OverStock Exceptions in Excel
                                                            </td>
                                                            <td class="Left5pxPadd">
                                                                <asp:ImageButton ID="OverButt" runat="server" ImageUrl="Images/ok.gif" OnClick="ExcelOver_Click" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </center>
                                                 <hr />
                                                Statistics<br />
                                                <asp:GridView runat="server" ID="StatGrid" AlternatingRowStyle-BackColor="#DCF3FB"
                                                    AutoGenerateColumns="False">
                                                    <Columns>
                                                        <asp:BoundField DataField="StepCode" HeaderText="Step" ReadOnly="True" SortExpression="StepCode"
                                                            HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                                        <asp:TemplateField HeaderText="From" SortExpression="HubItemCount" HeaderStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:Label ID="Hub" runat="server" Text='<%# Eval("HubItemCount", "{0,-10:###,###,##0}")%>'
                                                                    ToolTip="From Item Count"></asp:Label>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Right" Width="40" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Hungry" SortExpression="ItemsHungry" HeaderStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:Label ID="Hungry" runat="server" Text='<%# Eval("ItemsHungry", "{0,-10:###,###,##0}")%>'
                                                                    ToolTip="To Items with Need"></asp:Label>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Right" Width="40" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Fill" SortExpression="FilllItemCount" HeaderStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:Label ID="Sat" runat="server" Text='<%# Eval("FilllItemCount", "{0,-10:###,###,##0}")%>'
                                                                    ToolTip="To Items with Hub Available Qty"></asp:Label>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Right" Width="40" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Fed" SortExpression="ItemsFed" HeaderStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:Label ID="Fed" runat="server" Text='<%# Eval("ItemsFed", "{0,-10:###,###,##0}")%>'
                                                                    ToolTip="To Items Satisfied"></asp:Label>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Right" Width="40" />
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                                <hr />
                                                Weights<br />
                                                <asp:GridView runat="server" ID="WeightGrid" AlternatingRowStyle-BackColor="#DCF3FB"
                                                    AutoGenerateColumns="False" HorizontalAlign="Left">
                                                    <Columns>
                                                        <asp:BoundField DataField="ToLoc" HeaderText="To" ReadOnly="True" SortExpression="ToLoc"
                                                            HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="30" />
                                                        <asp:BoundField DataField="FromLoc" HeaderText="From" ReadOnly="True" SortExpression="FromLoc"
                                                            HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="30" />
                                                        <asp:BoundField DataField="Lines" HeaderText="Lines" ReadOnly="True" SortExpression="Lines"
                                                            HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="40" />
                                                        <asp:TemplateField HeaderText="LBS" SortExpression="XferLBS" HeaderStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:Label ID="Weight" runat="server" Text='<%# Eval("XferLBS", "{0,-10:###,###,##0}")%>'
                                                                    ToolTip="Weight"></asp:Label>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Right" Width="50" />
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                        </tr>
                                    </table>
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
