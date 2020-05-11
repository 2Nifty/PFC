<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" ValidateRequest="false"   CodeFile="SupportTableMaint.aspx.cs" Inherits="SupportTableMaint" %>
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
    function PrintPage()
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
                       <asp:Label ID="lblParentMenuName" CssClass=BannerText runat="server" Text="GER Support Table Maintenance"></asp:Label>
                       </span>
                </td>
            </tr>
            <tr>
                <td colspan=2>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                    <td width="100" class="PageBg">
                    <asp:Label ID="TableFilterLabel" runat="server" Text="Support Table"></asp:Label>
                    </td>
                    <td width="100" class="PageBg">
                        <asp:DropDownList ID="TableFilter" runat="server" >
                        </asp:DropDownList>
                        <input id="PrintHide" name="PrintHide" type="hidden"  value="Print"/>
                        <asp:HiddenField ID="PageFunc" runat="server" />
                    </td>
                    <td class="PageBg">
                        <asp:ImageButton ID="FindButt" runat="server" ImageUrl="common/Images/search.gif"  OnClick="FindButt_Click" CausesValidation="False"/>
                         <asp:ImageButton ID="AddButt" runat="server" ImageUrl="common/Images/btnadd.jpg" OnClick="AddButt_Click" 
                         CausesValidation="False" Visible="false"/>
                       <asp:Label ID="lblErrorMessage" runat="server" CssClass="txtError"></asp:Label>
                        <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen" Width="240px"></asp:Label>
                    </td>
                    <td align="right" class="PageBg" valign="bottom">
                        <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                        <td style="padding-left: 5px">
                            <img runat="server" src="common/Images/Print.gif" alt="Print"
                                onclick="javascript:PrintPage();" />
                            <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="common/Images/close.jpg" 
                                PostBackUrl="javascript:window.close();"  CausesValidation="false"/>
                        </td>
                        </tr>
                        </table>
                    </td>
                    </tr>
                </table>
                </td>
            </tr>
            <tr><td>
                <asp:Panel ID="UpdPanel" runat="server" Height="250px" Width="100%" Visible="false" BorderColor="black" BorderWidth="1">
                    <table cellspacing="0">
                        <tr>
                            <td>Key<asp:HiddenField ID="UpdFunction" runat="server" />
                                <asp:HiddenField ID="HiddenGERID" runat="server" />
                            </td>
                            <td>  
                                <asp:TextBox ID="KeyUpd" runat="server"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td><asp:Label ID="DescLabel" runat="server"></asp:Label>
                            </td>
                            <td>  
                                <asp:TextBox ID="DescUpd" runat="server"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Col1Label" runat="server"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="Col1TextBox" runat="server"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td><asp:Label ID="Col2Label" runat="server"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="Col2TextBox" runat="server"></asp:TextBox>
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
                <asp:GridView ID="DetailGrid" runat="server" AllowSorting="true" AutoGenerateColumns="true" 
                OnSorting="SortGrid" AutoGenerateDeleteButton="true" AutoGenerateEditButton="true"  OnRowDeleting="GridDeleteHandler" 
                datakeynames="pTableID" OnRowEditing="GridEditHandler" OnRowDataBound="DetailGrid_RowDataBound">
                    <AlternatingRowStyle CssClass="GridItem" BackColor="#DCF3FB" BorderColor="#DAEEEF" Height="20px" />
                </asp:GridView>
                </div>
                </asp:Panel>
           </td>
            </tr>
        </table>
    </form>
</body>

</html>
