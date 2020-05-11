<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GERReconcileReport.aspx.cs" Inherits="GERReconcileReport" %>
<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <script language="javascript">  
    function PrintRecon()
    {   
        var prtContent = "<html><head><link href=Common/StyleSheet/Styles.css rel=stylesheet type=text/css /><style>.GridItem {	font-family: Arial, Helvetica, sans-serif;	font-size: 11px;	color: #000000;	text-decoration:none;}</style></head><body>";
            var WinPrint = window.open('','ReconPrint','left=0,top=0,width=1,height=1,toolbar=0,scrollbars=0,status=0');        
            prtContent = prtContent + document.getElementById("PrintArea").innerHTML ;
            prtContent = prtContent + "</body></html>";        
            WinPrint.document.write(prtContent);
            WinPrint.document.close();
            WinPrint.focus();
            WinPrint.print();
            WinPrint.close();
            return false;
        
    }
    </script>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <title>GER Reconciliation</title>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div>
        <uc1:Header ID="Header1" runat="server" />
        <div id="PrintArea">
            <table width="100%" border="0" cellspacing="0" cellpadding="0"  >
            <tr class="BluBg">
                <td class="Left5pxPadd"><b>Run Type:&nbsp;
                    <asp:Label ID="RunTypeLabel" runat="server" Text=""></asp:Label></b>
                </td>
                <td class="Left5pxPadd"><b>Begin Date:&nbsp;
                    <asp:Label ID="BegDateLabel" runat="server" Text=""></asp:Label></b>
                </td>
                <td class="Left5pxPadd"><b>End Date:&nbsp;
                    <asp:Label ID="EndDateLabel" runat="server" Text=""></asp:Label></b>
                </td>
                <td class="Left5pxPadd"><b>Run By:&nbsp;
                    <asp:Label ID="RunByLabel" runat="server" Text=""></asp:Label></b>
                </td>
                <td class="Left5pxPadd"><b>Run Date:&nbsp;
                    <asp:Label ID="RunDateLabel" runat="server" Text=""></asp:Label>
                    <asp:HiddenField ID="ExcelPath" runat="server" />
                </b>
                </td>
            </tr>
            <tr>
                <td colspan="5">
                <asp:Panel ID="ReportPanel" runat="server" Height="555px" Width="100%">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                    <tr class="LightBluBg">
                      <td colspan="11" >
                      <table border="0" cellspacing="0" cellpadding="0" >
                         <tr class="LightBluBg">
                            <td colspan="4" align="center" class="rightBorder">
                            <br /><b>Goods En Route</b>
                            </td>
                            <td colspan="2" align="center" class="rightBorder">
                            <br /><b>Accounts Payable</b>
                            </td>
                            <td colspan="5" >
                            &nbsp;G/L Variance Accounts&nbsp;<asp:Label ID="GLVariance" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                     <tr>
                        <td class="rightBorder" align="center" width="80">
                        <b>BOL #</b>
                        </td>
                        <td class="rightBorder" align="center" width="80">
                        <b>Date</b>
                        </td>
                        <td class="rightBorder" align="center" width="80">
                        <b>Matl Amt</b>
                        </td>
                        <td class="rightBorder" align="center" width="80">
                        <b>Land Amt</b>
                        </td>
                        <td class="rightBorder" align="center" width="80">
                        <b>Matl Amt</b>
                        </td>
                        <td class="rightBorder" align="center" width="80">
                        <b>Land Amt</b>
                        </td>
                        <td class="rightBorder" align="center" width="80">
                        <b>GER vs AP</b>
                        </td>
                        <td class="rightBorder" align="center" width="80">
                        <b>AP Var Amt</b>
                        </td>
                        <td class="rightBorder" align="center" width="80">
                        <b>GER Total</b>
                        </td>
                        <td class="rightBorder" align="center" width="80">
                        <b>AP Total</b>
                        </td>
                        <td align="center" width="80">
                        <b>Total Var</b>
                        </td>
                        </tr>
                        </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="11" >
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                        <asp:DataGrid ID="ReconGrid" runat="server"  BackColor="#f4fbfd" AutoGenerateColumns="false" 
                        PageSize="16" AllowPaging="true" PagerStyle-Visible="false" ShowHeader="false"
                        BorderWidth="0" >
                        <AlternatingItemStyle CssClass="GridItem"  BackColor="#FFFFFF" />
                        <Columns>
                        <asp:BoundColumn HeaderText="BOL #" DataField="BOLNo" SortExpression="BOLNo" ItemStyle-Wrap="false" 
                            ItemStyle-Width="78" ItemStyle-HorizontalAlign="center" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false"></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="Date" DataField="BOLDate" SortExpression="BOLDate" ItemStyle-Wrap="false" 
                            ItemStyle-Width="78" ItemStyle-HorizontalAlign="center" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false" DataFormatString="{0:d}"></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="Matl Amt" DataField="BOLMatl" SortExpression="BOLMatl" ItemStyle-Wrap="false" 
                            ItemStyle-Width="78" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false" DataFormatString="{0:N2}"></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="Land Amt" DataField="BOLLanded" SortExpression="BOLLanded" ItemStyle-Wrap="false" 
                            ItemStyle-Width="78" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false" DataFormatString="{0:N2}"></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="Matl Amt" DataField="APMatl" SortExpression="APMatl" ItemStyle-Wrap="false" 
                            ItemStyle-Width="78" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false" DataFormatString="{0:N2}"></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="Land Amt" DataField="APLanded" SortExpression="APLanded" ItemStyle-Wrap="false" 
                            ItemStyle-Width="78" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false" DataFormatString="{0:N2}"></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="GER vs AP" DataField="GERvsAP" SortExpression="GERvsAP" ItemStyle-Wrap="false" 
                            ItemStyle-Width="78" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false" DataFormatString="{0:N2}"></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="AP Var Amt" DataField="APVariance" SortExpression="APVariance" ItemStyle-Wrap="false" 
                            ItemStyle-Width="78" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false" DataFormatString="{0:N2}"></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="GER Total" DataField="GERTot" SortExpression="GERTot" ItemStyle-Wrap="false" 
                            ItemStyle-Width="78" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false" DataFormatString="{0:N2}"></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="AP Total" DataField="APTot" SortExpression="APTot" ItemStyle-Wrap="false" 
                            ItemStyle-Width="78" ItemStyle-HorizontalAlign="right" ItemStyle-CssClass="rightBorder" HeaderStyle-Wrap="false" DataFormatString="{0:N2}"></asp:BoundColumn>
                        <asp:BoundColumn HeaderText="Total Var " DataField="TotalVariance" SortExpression="TotalVariance" ItemStyle-Wrap="false" 
                            ItemStyle-Width="78" ItemStyle-HorizontalAlign="right" HeaderStyle-Wrap="false" DataFormatString="{0:N2}"></asp:BoundColumn>
                        </Columns>
                       </asp:DataGrid>
                        <asp:UpdateProgress runat="server">
                        <ProgressTemplate>Loading data.... One Moment.</ProgressTemplate>
                        </asp:UpdateProgress>
                       </ContentTemplate>
                        </asp:UpdatePanel>
                       </td>
                    </tr>
                </table>
                </asp:Panel>
                </td>
            </tr>
            <tr class="LightBluBg">
                <td class="Left5pxPadd" colspan="5">
                <b>Grand Total</b>
                </td>
            </tr>
       </table>    
       </div>
       <table width="100%" border="0" cellspacing="0" cellpadding="0" >
              <tr>
                <td colspan="2" class="BluBg">
                    <table width="100%" id="tblPager" runat="SERVER">
                        <tr>
                            <td>
                                <uc3:pager ID="Pager1" runat="server" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
             <tr class="BluBg">
                <td class="Left5pxPadd">
                    <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>
                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                </td>
                <td  align="right" >
                    <asp:ImageButton ID="ExcelButton" runat="server" ImageUrl="../Common/Images/ExporttoExcel.gif" OnClick="ExcelButton_Click" />
                    <img id="Img1" runat="server" src="../Common/Images/print.gif" alt="Print"
                        onclick="javascript:PrintRecon();" />
                    <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="common/Images/close.jpg" 
                                PostBackUrl="javascript:window.close();"  CausesValidation="false"/>
                    &nbsp; &nbsp;
                </td>
            </tr>
       </table>    
        <uc2:Footer ID="BottomFrame1" runat="server" />
    </div>
    </form>
</body>
</html>
