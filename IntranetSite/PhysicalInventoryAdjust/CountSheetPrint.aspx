<%@ Page Language="C#" AutoEventWireup="true" Trace="false" CodeFile="CountSheetPrint.aspx.cs"
    EnableEventValidation="false" ValidateRequest="false" Inherits="PhysicalInventoryAdjustPage" %>

<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="~/InvoiceRegister/Common/UserControls/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="~/InvoiceRegister/Common/UserControls/Footer.ascx" TagName="BottomFooter"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Physical Inventory Adjustment </title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <style>
    .lightBlueBg 
{
	background:#ECF9FB;
	border-bottom:1px solid #88D2E9;
	padding-right: 5px;
}
    </style>

    <script>
    function PrintReport()
    {  
        var WinPrint = window.open('print.aspx','Print','height=10,width=10,scrollbars=no,status=no,top=0,left=0,resizable=NO',"");       
    }   
    
    function BindValue(sortExpression)
    {     
        if(document.getElementById("hidSortExpression") !=null)
            document.getElementById("hidSortExpression").value= sortExpression;
        document.getElementById("btnSort").click();
    }
    // Javascript Function To Call Server Side Function Using Ajax
    function DeleteFiles(session)
    {
        //QuoteMetricsReport.DeleteExcel('QuoteMetricsReport'+session).value
        parent.window.close();           
    }
    
    function CheckPFCItemNo(e, cntrlType)
    {
        if(cntrlType == 'Category')
        {
            var _txtCategory = document.getElementById("txtCategory")            
            var itemNo = "00000" + _txtCategory.value;
            itemNo = itemNo.substr(itemNo.length - 5, 5);
            _txtCategory.value = itemNo ; 
            document.getElementById("txtSize").focus();            
        }    
        else if(cntrlType == 'Size')
        {
            var _txtSize = document.getElementById("txtSize")            
            var itemNo = "0000" + _txtSize.value;
            itemNo = itemNo.substr(itemNo.length - 4, 4);
            _txtSize.value = itemNo ; 
            document.getElementById("txtPlating").focus();            
        }
        else
        {
            var _txtPlating = document.getElementById("txtPlating")            
            var itemNo = "000" + _txtPlating.value;
            itemNo = itemNo.substr(itemNo.length - 3, 3);
            _txtPlating.value = itemNo ; 
            document.getElementById("txtPlating").focus();            
        }
        
        if( document.getElementById("txtCategory").value.length == 5 &&
            document.getElementById("txtSize").value.length == 4 &&
            document.getElementById("txtPlating").value.length == 3)
        {            
            document.getElementById("btnGetItemDetail").click();
        }
    }
    
    function ClearMessages()
    {
        if(document.getElementById('lblMsg')!=null)document.getElementById('lblMsg').innerHTML = '';
        if(document.getElementById('lblHeaderMsg')!=null)document.getElementById('lblHeaderMsg').innerHTML = '';
    }   
    
    </script>

</head>
<body scroll="no" onclick="javascript:ClearMessages();" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="360000"
            EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr>
                <td height="5%" id="tdHeader" colspan="2">
                    <uc1:Header ID="ucHeader" runat="server" />
                </td>
            </tr>
            <tr>
                <td width="100%" valign="top" colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="lightBlueBg" colspan="4" style="height: 30px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td class="Left5pxPadd BannerText" width="70%">
                                            Physical Inventory Adjustment</td>
                                        <td align="right" style="width: 30%; padding-right: 5px; padding-bottom: 3px;">
                                            <asp:UpdatePanel ID="pnlButton" runat="server">
                                                <ContentTemplate>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        </td>
                                                    <td>
                                                        <asp:ImageButton ID="ibtnPrint" runat="server" ImageAlign="middle" ImageUrl="~/InvoiceRegister/Common/Images/Print.gif"
                                                            Style="cursor: hand" OnClick="ibtnPrint_Click" />&nbsp;</td>
                                                    <td style="padding-left: 10px; margin-bottom: 5px;">
                                                        <img align="right" src="Common/Images/Close.gif" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
                                                            style="cursor: hand; padding-right: 2px;" />
                                                    </td>
                                                </tr>
                                            </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="lightBlueBg" colspan="3" style="padding-left: 10px; height: 30px; width: 902px;" valign="middle">
                                <asp:UpdatePanel ID="pnlSubmit" runat="server">
                                    <ContentTemplate>
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td style="width: 58px">
                                            <strong>Location:</strong></td>
                                        <td style="width: 100px">
                                            <asp:DropDownList ID="ddlLocation" runat="server" CssClass="FormCtrl" Width="168px">
                                            </asp:DropDownList></td>
                                        <td style="padding-left: 10px;">
                                            <asp:ImageButton ID="btnGetItem" runat="server" CausesValidation="False" ImageUrl="~/PhysicalInventoryAdjust/Common/Images/getitems.gif"
                                                TabIndex="16" OnClick="btnGetItem_Click" /></td>
                                    </tr>
                                </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td align="right" style="padding-right: 10px;" class="lightBlueBg">
                                <asp:UpdateProgress ID="upPanel" runat="server" DisplayAfter="10" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <span style="padding-left: 5px; font-weight: bold; padding-top: 0px; color: Red;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                                &nbsp;
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr id="trHead" class="PageBg">
                <td class="Left5pxPadd lightBlueBg" style="height: 10px" colspan="2">
                    <asp:Label ID="Label1" runat="server" CssClass="BannerText" Text="Existing Adjustment Records"></asp:Label></td>
            </tr>
            <tr>
                <td colspan="2" align="left" valign="top">
                    <asp:UpdatePanel ID="pnlGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <div class="Sbar" id="divdatagrid" runat="server" style="overflow-x: auto; overflow-y: auto; position: relative;
                                top: 0px; left: 0px; height: 500px; width: 1010px; border: 0px solid;">
                                <asp:GridView UseAccessibleHeader="true" PagerSettings-Visible="false" Width="700px"
                                    ID="gvPhysicalInv" runat="server" ShowHeader="true" AllowSorting="false"
                                    AutoGenerateColumns="false" OnRowDataBound="gvPhysicalInv_RowDataBound" OnSorting="gvPhysicalInv_Sorting"
                                    AllowPaging="true">
                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" />
                                    <RowStyle CssClass="GridItem " BackColor="White" BorderColor="White" Height="30px" VerticalAlign=top
                                        HorizontalAlign="Left" />
                                    <AlternatingRowStyle CssClass="GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                        HorizontalAlign="Left" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" />
                                    <EmptyDataRowStyle VerticalAlign="Top" BorderWidth="0px" CssClass="GridHead" BackColor="#DFF3F9"
                                        HorizontalAlign="Center" />
                                    <Columns>                                          
                                        <asp:BoundField HeaderText="Bin Loc" DataField="BinLoc" SortExpression="BinLoc">
                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" HeaderText="Category" DataField="Category" SortExpression="Category">
                                            <ItemStyle HorizontalAlign="Left" Width="35px" Wrap="False" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="35px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="Size" HeaderText="Size" SortExpression="Size">
                                            <ItemStyle HorizontalAlign="Left" Wrap="False" Width="60px" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="PackPlate" HeaderText="Pack/Plate"
                                            SortExpression="PackPlate">
                                            <ItemStyle HorizontalAlign="Left" Width="35px" Wrap="False" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="35px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="ItemDesc" HeaderText="Description"
                                            SortExpression="ItemDesc">
                                            <ItemStyle HorizontalAlign="Left" />
                                            <HeaderStyle Wrap="True" HorizontalAlign="Center"/>
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="Pack" HeaderText="Pack" SortExpression="Pack">
                                            <ItemStyle HorizontalAlign="Left" Width="35px" Wrap="True" />
                                            <HeaderStyle Wrap="True" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="False" DataField="BeforeQty" HeaderText="Before Qty"
                                            SortExpression="BeforeQty" >
                                            <ItemStyle HorizontalAlign="Right" Width="50px" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
                                        </asp:BoundField>                                        
                                        <asp:TemplateField HeaderText="New Qty" SortExpression="DispAfterQty">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtAfterQty" style="text-align:right;" runat="server" CssClass="FormCtrl" MaxLength="15" TabIndex="2"
                                                    Width="50px" Text=""></asp:TextBox>
                                                <asp:HiddenField ID="hidItemNo" Value='<%#DataBinder.Eval(Container,"DataItem.ItemNo")%>' runat=server />
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Center" Width="50px"/>
                                        </asp:TemplateField>
                                    </Columns>
                                    <PagerSettings Visible="False" />
                                </asp:GridView>
                                <div align="center">
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label></div>
                                <input type="hidden" runat="server" id="hidSortExpression" />
                                <asp:Button ID="btnSort" runat="server" Text="" Style="display: none;" OnClick="btnSort_Click" />
                                <input type="hidden" runat="server" id="hidSort" />
                            </div>
                            <div id="divPager" runat="server">
                                <uc3:pager ID="pager" runat="server" Visible="false" OnBubbleClick="Pager_PageChanged" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" valign="top">
                    <uc2:BottomFooter ID="ucFooter" Title="Physical Inventory Adjustment" runat="server" />
                    <asp:HiddenField ID="hidShowMode" runat="server" />
                    <asp:HiddenField ID="hidFileName" Value="" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
