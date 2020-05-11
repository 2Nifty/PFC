<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" ValidateRequest="false"   CodeFile="ChargesMaint.aspx.cs" Inherits="ChargesMaint" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Charge Maintenance</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css"/>
    <style>
    .PageBg 
    {
	    background-color: #B3E2F0;
	    padding: 1px;
    }    
    </style>

    <script language="javascript">
    <!--
    function PrintCharges()
    {   
        var prtContent = "<html><head><link href=Common/StyleSheet/Styles.css rel=stylesheet type=text/css /></head><body>";
            var WinPrint = window.open('','GERChargePrint','left=0,top=0,width=1,height=1,toolbar=0,scrollbars=0,status=0');        
            prtContent = prtContent + document.getElementById("PrintDetail").innerHTML ;
            prtContent = prtContent + "</body></html>";        
            WinPrint.document.write(prtContent);
            WinPrint.document.close();
            WinPrint.focus();
            WinPrint.print();
            WinPrint.close();
            return false;
        
    }
    -->
    </script>

</head>
<body >
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="BranchList" runat="server"></asp:SqlDataSource>
        <asp:SqlDataSource ID="ReceiptTypeList" runat="server"></asp:SqlDataSource>
        <asp:SqlDataSource ID="GERPOLds" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnect %>" 
        ProviderName="<%$ ConnectionStrings:PFCReportsConnect.ProviderName %>" 
        SelectCommand="SELECT [Dsc] FROM [Tables] WHERE ([TableType] = 'GERPORT') ORDER BY [Dsc]"></asp:SqlDataSource>
        <asp:SqlDataSource ID="GERAdderTypes" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnect %>" 
        ProviderName="<%$ ConnectionStrings:PFCReportsConnect.ProviderName %>" 
        SelectCommand="SELECT [Dsc], [ShortDsc] FROM [Tables] WHERE ([TableType] = 'GERADDERTYP') ORDER BY [Dsc]">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="GERAdderFuncs" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnect %>" 
        ProviderName="<%$ ConnectionStrings:PFCReportsConnect.ProviderName %>" 
        SelectCommand="SELECT [Dsc], [ShortDsc] FROM [Tables] WHERE ([TableType] = 'GERADDERFUNC') ORDER BY [Dsc]">
        </asp:SqlDataSource>
        <table width=100% cellspacing="0" cellpadding="0">
            <tr>
                <td valign=middle class=PageHead colspan=2>
                       <span class=Left5pxPadd>
                       <asp:Label ID="lblParentMenuName" CssClass=BannerText runat="server" Text="GER Charges Maintenance"></asp:Label>
                       </span>
                </td>
            </tr>
            <tr>
                <td colspan=2>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                    <td width="100" class="PageBg">
                    <asp:Label ID="BranchLabel" runat="server" Text="Branch"></asp:Label>
                    </td>
                    <td width="100" class="PageBg">
                        <asp:DropDownList ID="BranchFilter" runat="server" >
                        </asp:DropDownList>
                        <input id="PrintHide" name="PrintHide" type="hidden"  value="Print"/>
                        <asp:HiddenField ID="PageFunc" runat="server" />
                    </td>
                    <td width="100" class="PageBg">
                    <asp:Label ID="ReceiptTypeFilterLabel" runat="server" Text="Receipt Type"></asp:Label>
                    </td>
                    <td width="100" class="PageBg">
                        <asp:DropDownList ID="ReceiptTypeFilter" runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="PageBg">
                        <asp:ImageButton ID="FindButt" runat="server" ImageUrl="common/Images/search.gif"  OnClick="FindButt_Click" CausesValidation="False"/>
                        <asp:ImageButton ID="AddButt" runat="server" ImageUrl="common/Images/btnadd.jpg" OnClick="AddButt_Click" CausesValidation="False" />
                    </td>
                    <td align="right" class="PageBg" valign="bottom">
                        <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                        <td style="padding-left: 5px">
                            <img runat="server" src="common/Images/Print.gif" alt="Print"
                                onclick="javascript:PrintCharges();" />
                            <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="common/Images/close.jpg" 
                                PostBackUrl="javascript:window.close();"  CausesValidation="false"/>
                        </td>
                        </tr>
                        </table>
                    </td>
                    </tr>
                    <tr class="PageBg">
                    <td width="100">
                    <asp:Label ID="PortOfLadingFilterLabel" runat="server" Text="Port Of Lading"></asp:Label>
                    </td>
                    <td width="100" class="PageBg">
                            <asp:DropDownList ID="PortOfLadingFilter" runat="server">
                            </asp:DropDownList>
                    </td>
                    <td width="100">
                    <asp:Label ID="ChargeTypeLabel" runat="server" Text="Charge Type"></asp:Label>
                    </td>
                    <td width="100" class="PageBg">
                            <asp:DropDownList ID="ChargeTypeFilter" runat="server">
                            </asp:DropDownList>
                    </td>
                   <td align="left" class="PageBg">
                    <asp:Label ID="lblErrorMessage" runat="server" CssClass="txtError"></asp:Label>
                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen" Width="240px"></asp:Label></td>
                    <td>
                    </td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr><td>
                <asp:Panel ID="UpdPanel" runat="server" Height="250px" Width="100%" Visible="false" BorderColor="black" BorderWidth="1">
                    <table cellspacing="0">
                        <tr>
                            <td>Branch<asp:HiddenField ID="UpdFunction" runat="server" />
                                <asp:HiddenField ID="HiddenGERID" runat="server" />
                            </td>
                            <td>  
                                <asp:DropDownList ID="BranchUpd" runat="server" >
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>Receipt Type
                            </td>
                            <td>
                            <asp:DropDownList ID="ReceiptTypeUpd" runat="server">
                            </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>Port of Lading
                            </td>
                            <td>
                                <asp:DropDownList ID="POLUpd" runat="server">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>Charge Type
                            </td>
                            <td>
                                <asp:DropDownList ID="ChargeTypeUpd" runat="server">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>Adder
                            </td>
                            <td>
                                <asp:TextBox ID="AdderUpd" runat="server"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="AdderAmtValidator" runat="server" ErrorMessage="Adder Amount is required" ControlToValidate="AdderUpd"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>Minimum
                            </td>
                            <td>
                                <asp:TextBox ID="MinUpd" runat="server"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="MinValidator" runat="server" ErrorMessage="Minimum Qty/Amount is required (Zero [0] is OK)." ControlToValidate="MinUpd"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>Maximum
                            </td>
                            <td>
                                <asp:TextBox ID="MaxUpd" runat="server"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="MaxValidator" runat="server" ErrorMessage="Maximum Qty/Amount is required." ControlToValidate="MaxUpd"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>Adder Function
                            </td>
                            <td>
                                <asp:DropDownList ID="AdderFuncUpd" runat="server" DataSourceID="GERAdderFuncs" DataTextField="ShortDsc" DataValueField="Dsc">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>Adder Type
                            </td>
                            <td>
                                <asp:DropDownList ID="AdderTypeUpd" runat="server" DataSourceID="GERAdderTypes" DataTextField="ShortDsc" DataValueField="Dsc">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr class="PageBg">
                            <td style="padding-left: 5px"> 
                            <asp:ImageButton ID="SaveButt" runat="server" ImageUrl="common/Images/accept.jpg"  OnClick="SaveButt_Click"/>
                            <asp:ImageButton ID="DoneButt" runat="server" ImageUrl="common/Images/done.gif" CausesValidation="False" OnClick="DoneButt_Click"/>
                           </td>
                            <td colspan="2"  style="padding-left: 5px">
                            Accept will save your changes. Done will close this panel (without saving your changes).
                            </td>
                        </tr>
                     </table>
                </asp:Panel>
            </td></tr>
            <tr><td id="DetailSection">
                <asp:Panel ID="DetailPanel" runat="server" width="1000" Height="550" ScrollBars="Auto">
                <div id="PrintDetail">
                <asp:GridView ID="ChargeDetailGrid" runat="server" AllowSorting="true" AutoGenerateColumns="false" 
                OnSorting="SortGrid" AutoGenerateDeleteButton="true" AutoGenerateEditButton="true"  OnRowDeleting="GridDeleteHandler" 
                datakeynames="pGERChargesID" OnRowEditing="GridEditHandler" >
                    <AlternatingRowStyle CssClass="GridItem" BackColor="#DCF3FB" BorderColor="#DAEEEF" Height="20px" />
                    <Columns>
                        <asp:TemplateField HeaderText="Br." SortExpression="DestBranch">
                            <ItemTemplate>
                                <%# Eval("DestBranch")%>
                            </ItemTemplate>
                            <ItemStyle height="10px" width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Receipt Type" SortExpression="RcptTypeDesc">
                            <ItemTemplate>
                                <%# Eval("RcptTypeDesc")%>
                            </ItemTemplate>
                            <ItemStyle height="10px" width="80px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Port of Lading" SortExpression="PortofLading">
                            <ItemTemplate>
                                <%# Eval("PortofLading")%>
                            </ItemTemplate>
                            <ItemStyle height="10px" width="120px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Type" SortExpression="ChrgType">
                            <ItemTemplate>
                                <%# Eval("ChrgType")%>
                            </ItemTemplate>
                            <ItemStyle height="10px" width="150px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Adder" SortExpression="ChrgAdder">
                            <ItemTemplate>
                                <%# Eval("ChrgAdder", "{0,-15:#,###,##0.00000}")%>
                            </ItemTemplate>
                            <ItemStyle height="10px" width="80px" HorizontalAlign="Right" />
                            <HeaderStyle HorizontalAlign="Right" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Min." SortExpression="QtyMin">
                            <ItemTemplate>
                                <%# Eval("QtyMin", "{0,-10:#,###,##0}")%>
                            </ItemTemplate>
                            <ItemStyle height="10px" width="60px" HorizontalAlign="Right" />
                            <HeaderStyle HorizontalAlign="Right" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Max." SortExpression="QtyMax">
                            <ItemTemplate>
                                <%# Eval("QtyMax", "{0,-10:#,###,##0}")%>
                            </ItemTemplate>
                            <ItemStyle height="10px" width="60px" HorizontalAlign="Right" />
                            <HeaderStyle HorizontalAlign="Right" />
                       </asp:TemplateField>
                        <asp:TemplateField HeaderText="Function" SortExpression="AdderFunc">
                            <ItemTemplate>
                                <%# Eval("AdderFunc")%>
                            </ItemTemplate>
                            <ItemStyle height="10px" width="70px" />
                       </asp:TemplateField>
                        <asp:TemplateField HeaderText="Adder Type" SortExpression="AdderType">
                            <ItemTemplate>
                                <%# Eval("AdderType")%>
                            </ItemTemplate>
                            <ItemStyle height="10px" width="60px" />
                        </asp:TemplateField>
                        <asp:BoundField HeaderText="ID"  DataField="pGERChargesID" ReadOnly="True" >
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                    </Columns>
                </asp:GridView>
                </div>
                </asp:Panel>
           </td>
            </tr>
        </table>
    </form>
</body>

</html>
