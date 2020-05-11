<%@ Page Language="C#" AutoEventWireup="true"  EnableEventValidation="false"  CodeFile="CategoryBuyReport.aspx.cs" Inherits="CatBuyReport" %>
<%@ Register Src="../PrintUtility/Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage2.ascx" TagName="Footer" TagPrefix="uc2" %>
<%-- <%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <script language="javascript">  
        function ToggleDetail(LineCell)
        { 
            var CurLine = LineCell.parentNode.parentNode;
            var CurGroup = CurLine.childNodes[0].innerText;
            var NextLine = CurLine.nextSibling;
            if (CurGroup!='')
            {
                for (i = 0; i<10; i++)
                {
                    NextGroup = NextLine.childNodes[0].innerText
                    if (NextGroup == CurGroup && NextGroup!='')
                    {
                        if (NextLine.style.display == "inline")
                        {
                            NextLine.style.display = "none";
                        }
                        else
                        {
                            NextLine.style.display = "inline";
                        }
                    }
                    NextLine = NextLine.nextSibling;
                }
            }
            //alert(NextLine.childNodes[3].innerText);
            return false;
        }
        
        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //take out room for headers and footers
            yh = yh - 52;
            // we resize differently according to quote recall or review quote
            if (document.getElementById("WorkProcessResults") != null)
            {
                var DetailPanel = document.getElementById("WorkProcessResults");
                DetailPanel.style.height = yh;  
                DetailPanel.style.width = xw;  
                /*var DetailGridPanel = $get("DetailGridPanel");
                DetailGridPanel.style.height = (yh * DetailRatio) - 55;  
                var DetailGridHeightHid = $get("DetailGridHeightHidden");
                DetailGridHeightHid.value = (yh * DetailRatio) - 55;
                var DetailGridHeightHid = $get("DetailGridWidthHidden");
                DetailGridHeightHid.value = xw - 25;*/
            }
            else
            {
                /*if (document.getElementById("DetailPanel") != null)        
                {    
                    var DetailPanel = $get("DetailPanel");
                    DetailPanel.style.height = yh - 25;  
                    var DetailGridPanel = $get("DetailGridPanel");
                    DetailGridPanel.style.height = yh - 85;  
                    DetailGridPanel.style.width = xw - 25;  
                    var DetailGridHeightHid = $get("DetailGridHeightHidden");
                    DetailGridHeightHid.value = yh - 85;
                    var DetailGridHeightHid = $get("DetailGridWidthHidden");
                    DetailGridHeightHid.value = xw - 25;
                }*/
            }
        }
    </script>
    <title>Category Buy Report</title>
    <script src="../Common/JavaScript/Common.js" type="text/javascript"></script>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
    .bottomBorder {
    	border-bottom-width: 1px;
	    border-bottom-style: solid;
	    border-bottom-color: black;
    }
    .link
    {
	    text-decoration: underline;
    }
    .gridTop
    {
        position:relative;
        top:0px;
    }
    </style>
</head>
<body onload="SetHeight();" onresize="SetHeight();">
    <form id="form1" runat="server">
    <asp:HiddenField ID="AltLine" runat="server" />
    <div id="userInfo" style="color:#ffffff;"  class="HeaderImagebg" >
    <table width="100%" border="0" cellspacing="0" cellpadding="0"  >
    <col width="25%" /><col width="50%" /><col width="25%" />
    <tr>
        <td>&nbsp;
        </td>
        <td align="center">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                <tr >
                    <td align="right">                        
                        <asp:Image ID="imgHeaderLeft" runat=server ImageUrl="~/Common/Images/userinfo_left.gif" Width="11" Height="25" />
                    </td>
                    <td class="userinfobg" style="padding-right:5px">
                        <asp:Image ID="lblDate" runat=server ImageUrl="~/Common/Images/clock.gif" ></asp:Image>
                    </td>
                    <td class="userinfobg" style="padding-left:1px">                        
                        <asp:Label ID="lblUserInfo" runat="server"></asp:Label>
                    </td>
                    <td align="left">
                     <asp:Image ID="Image1" runat=server ImageUrl="~/Common/Images/userinfo_right.gif" Width="11" Height="25" />
                     </td>
                </tr>
            </table>
        </td>
        <td align="right">
        <table border="0" cellspacing="0" cellpadding="0" >
          <tr >
            <td>
                <uc1:PrintDialogue id="Print" runat="server">
                </uc1:PrintDialogue>
            </td>
            <td>
                <%--<asp:ImageButton ID="ExcelImageButton" runat="server"  ImageUrl="~/Common/Images/Excel.gif" OnClick="ExcelExportButton_Click" />
                 --%>&nbsp;
            </td>
            <td><asp:ImageButton ID="CloseButton" runat="server" ImageUrl="~/Common/Images/Close.gif" 
            PostBackUrl="javascript:window.close();"  CausesValidation="false"
            ToolTip="Close the Report Window"/>&nbsp;&nbsp;
            <asp:LinkButton ID="LinkButton1" runat="server"></asp:LinkButton>
            </td></tr></table>
        </td>
    </tr>
    </table>
    </div>
    <table width="100%" cellpadding="0" cellspacing="0" id="KahunaTable">
        <tr>
            <td>
            <asp:Panel ID="WorkProcessResults" runat="server" Width="100%" ScrollBars="both" BorderWidth="0">
            <asp:Table ID="CatBuyHeadingTable" runat="server" CellPadding="0" CellSpacing="0" Width="1000px" CssClass="gridTop">
                <asp:TableRow BackColor="#f4fbfd">
                    <asp:TableCell Width="200px" HorizontalAlign="center" CssClass="bottomBorder"  ColumnSpan="2" RowSpan="2">Category Group</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" Width="40px" RowSpan="2">Buy<br />Factor</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" Width="65px" RowSpan="2">AvgUse<br  />LBS</asp:TableCell>
                    <asp:TableCell CssClass="" Font-Bold="true" HorizontalAlign="center" Width="100px" ColumnSpan="2">Available</asp:TableCell>
                    <asp:TableCell CssClass="" Font-Bold="true" HorizontalAlign="center" Width="105px" ColumnSpan="2">On The Water</asp:TableCell>
                    <asp:TableCell CssClass="" Font-Bold="true" HorizontalAlign="center" Width="110px" ColumnSpan="2">On Order</asp:TableCell>
                    <asp:TableCell CssClass="" Font-Bold="true" HorizontalAlign="center" Width="110px" ColumnSpan="2">Total (Avl,OW,OO)</asp:TableCell>
                    <asp:TableCell CssClass="" Font-Bold="true" HorizontalAlign="center" Width="105px" ColumnSpan="2">Buy</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" RowSpan="2">Grand<br  />Total<br  />Months</asp:TableCell>
                </asp:TableRow>
                <asp:TableRow BackColor="#f4fbfd">
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" Width="65px">LBS</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" Width="35px">Months</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" Width="65px">LBS</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" Width="35px">Months</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" Width="65px">LBS</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" Width="35px">Months</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" Width="70px">LBS</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" Width="40px">Months</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" Width="65px">LBS</asp:TableCell>
                    <asp:TableCell CssClass="bottomBorder" HorizontalAlign="center" Width="35px">Months</asp:TableCell>
                </asp:TableRow>
            </asp:Table>
            <asp:GridView ID="CatBuyGridView" runat="server" AutoGenerateColumns="false" BorderWidth="0"  BackColor="#f4fbfd"
            GridLines="None" RowStyle-BorderStyle="None" RowStyle-BorderWidth="0" OnRowDataBound="CatBuyLineFormat" CssClass="GridItem" 
            HeaderStyle-VerticalAlign="Bottom" AlternatingRowStyle-BorderWidth="0" Width="1000px" ShowHeader="false">
            <Columns>
            <asp:TemplateField ItemStyle-Width="35px" ItemStyle-HorizontalAlign="Center" ItemStyle-CssClass="link">
            <ItemTemplate>
                <asp:LinkButton ToolTip="CLICK HERE to toggle CVC Totals" CssClass="link" ID="GrpLabelLink" OnClientClick="return ToggleDetail(this);"  CausesValidation="false"  PostBackUrl="#" runat="server" Text='<%# Eval("GrpNo") %>' ></asp:LinkButton>
            </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ItemStyle-Width="265px" ItemStyle-CssClass="rightBorder">
            <ItemTemplate >
                <asp:LinkButton ToolTip="CLICK HERE to toggle CVC Totals" CssClass="link" ID="GrpNameLink" OnClientClick="return ToggleDetail(this);"  CausesValidation="false"  PostBackUrl="#" runat="server" Text='<%# Eval("GrpName") %>' ></asp:LinkButton>
                <asp:Label ID="CVCLabel" runat="server" Text='<%# Eval("CVC") %>'></asp:Label>
            </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField HeaderText="Buy Factor" DataField="MonthsBuyFactor" SortExpression="MonthsBuyFactor" ItemStyle-Wrap="false"  HtmlEncode="false"
                ItemStyle-Width="30px" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="false"></asp:BoundField>
            <asp:BoundField HeaderText="AvgUse Lbs" DataField="AvgUseLbs" SortExpression="AvgUseLbs" ItemStyle-Wrap="false" HtmlEncode="false"  ItemStyle-CssClass="rightBorder"
                ItemStyle-Width="70px" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="false" HeaderStyle-CssClass="rightBorder"></asp:BoundField>

            <asp:BoundField HeaderText="Avail Wght" DataField="Avail_Wgt" SortExpression="Avail_Wgt" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="65px" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="true"></asp:BoundField>
            <asp:BoundField HeaderText="Mnths" DataField="AvailMonths" SortExpression="AvailMonths" ItemStyle-Wrap="false" HeaderStyle-CssClass="rightBorder" HtmlEncode="false" 
                ItemStyle-Width="35px" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>
            
            <asp:BoundField HeaderText="OW Wght" DataField="OW_Wgt" SortExpression="OW_Wgt" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="65px" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="true"></asp:BoundField>
            <asp:BoundField HeaderText="Mnths" DataField="OWMonths" SortExpression="OWMonths" ItemStyle-Wrap="false" HeaderStyle-CssClass="rightBorder" HtmlEncode="false" 
                ItemStyle-Width="35px" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>
            
            <asp:BoundField HeaderText="OO Wght" DataField="OO_Wgt" SortExpression="OO_Wgt" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="65px" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="true"></asp:BoundField>
            <asp:BoundField HeaderText="OO Mnths" DataField="OOMonths" SortExpression="OOMonths" ItemStyle-Wrap="false" HeaderStyle-CssClass="rightBorder" HtmlEncode="false" 
                ItemStyle-Width="35px" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>
            
            <asp:BoundField HeaderText="Total Wght" DataField="TotalLbs" SortExpression="TotalLbs" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="70px" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="true"></asp:BoundField>
            <asp:BoundField HeaderText="Mnths" DataField="TotalMonths" SortExpression="TotalMonths" ItemStyle-Wrap="false" HeaderStyle-CssClass="rightBorder" HtmlEncode="false" 
                ItemStyle-Width="40px" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>
            
            <asp:BoundField HeaderText="Buy Wght" DataField="BuyLbs" SortExpression="BuyLbs" ItemStyle-Wrap="false" HtmlEncode="false" 
                ItemStyle-Width="60px" DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="true"></asp:BoundField>
            <asp:BoundField HeaderText="Mnths" DataField="BuyMonths" SortExpression="BuyMonths" ItemStyle-Wrap="false" HeaderStyle-CssClass="rightBorder" HtmlEncode="false" 
                ItemStyle-Width="40px" DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>
            
            <asp:BoundField HeaderText="Total Mnths" DataField="GrandTotalMonths" SortExpression="GrandTotalMonths" ItemStyle-Wrap="false" HeaderStyle-CssClass="rightBorder" HtmlEncode="false" 
                DataFormatString="{0:N1}" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="true"></asp:BoundField>
            
            </Columns>
            </asp:GridView>
            </asp:Panel>
            </td>
        </tr>
    </table>
    <uc2:Footer ID="BottomFrame1" runat="server" FooterTitle="Category Buy Report" />
    </form>
</body>
</html>
