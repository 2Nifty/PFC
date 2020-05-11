<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RBReceiptsSumm.aspx.cs" Inherits="RBReceiptsSumm" %>
<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage2.ascx" TagName="Footer2" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script>
        var LPNDetailWindow;
        function pageUnload() 
        {
            if (LPNDetailWindow != null) {LPNDetailWindow.close();LPNDetailWindow=null;}
        }
        function ClosePage()
        {
            window.close();	
        }

        function OpenDetail(LPN)
        {
            if (LPNDetailWindow != null) {LPNDetailWindow.close();LPNDetailWindow=null;}
            var LocFilter = $get("LocFilter").value
            var Loc = $get("LocationDropDownList")
            var DetailURL = 'RBReceiptsLPDetail.aspx?LPNumber=' + LPN + '&Loc=' + Loc.options[Loc.selectedIndex].text;
            if (LocFilter == '')
            {
                DetailURL = DetailURL + '&Prog=BinRec';
            }
            //alert(DetailURL);
            LPNDetailWindow=window.open(DetailURL,'LPNDetailWin','height=750,width=1000,toolbar=0,scrollbars=0,status=1,resizable=YES','');  
            SetHeight();   
            return false;  
        }

        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //take out room for bottom panel
            yh = yh - 140;
            xw = xw - 5
            // size the grid
            var DetailGridPanel = $get("DetailGridPanel");
            DetailGridPanel.style.height = yh;  
            DetailGridPanel.style.width = xw;  
            var DetailGridHeightHid = $get("DetailGridHeightHidden");
            DetailGridHeightHid.value = yh;
            var DetailGridHeightHid = $get("DetailGridWidthHidden");
            DetailGridHeightHid.value = xw;
        }
    </script>

    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <title>License Plate Summary</title>
</head>
<body onload="SetHeight();" onresize="SetHeight();" >
    <asp:SqlDataSource ID="LocationCodes" runat="server" ConnectionString="<%$ ConnectionStrings:PFCERPConnectionString %>"  
        SelectCommand="select LocID as Code, LocID+' - '+LocName as Name from [LocMaster] with (NOLOCK) where ShipMethCd like @LocFilter order by LocID" >
        <SelectParameters>
        <asp:ControlParameter ControlID="LocFilter" Name="LocFilter" PropertyName="Value" DefaultValue="%" />
        </SelectParameters>
        </asp:SqlDataSource>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="LPNSummScriptManager" runat="server" EnablePartialRendering="true" />
    <div>
        <table width="100%" cellspacing="0" cellpadding="0" border="0">
            <tr>
                <td>
                    <uc1:Header id="Pageheader" runat="server">
                    </uc1:Header>

                </td>
            </tr>
            <tr>
                <td  class="BluBg bottombluebor" style="height:20px;">
                <span class="BannerText">&nbsp;&nbsp;&nbsp;&nbsp;License Plate Summary</span>
                <asp:HiddenField ID="LocFilter" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="BluBg">
                    <asp:UpdatePanel ID="SelectorUpdatePanel" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                    <table>
                        <tr>
                            <td>&nbsp;&nbsp;&nbsp;<b>PFC Location</b>&nbsp;&nbsp;&nbsp;&nbsp; 
                            </td>
                            <td>
                                <asp:DropDownList ID="LocationDropDownList" runat="server" DataTextField="Name" DataValueField="Code"
                                DataSourceID="LocationCodes">
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:ImageButton id="LocSubmit" name="LocSubmit" OnClick="LocSubmit_Click" AlternateText="Show LPNs for Branch"
                                    runat="server" ImageUrl="../Common/Images/ShowButton.gif" CausesValidation="false" />
                            </td>
                        </tr>
                    </table>
                    </ContentTemplate></asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="BluBg">
                    <asp:Panel ID="DetailGridPanel" runat="server"  ScrollBars="both" Height="500px" Width="980px">
                        <asp:HiddenField ID="DetailGridHeightHidden" runat="server" />
                        <asp:HiddenField ID="DetailGridWidthHidden" runat="server" />
                    <asp:UpdatePanel ID="DetailUpdatePanel" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                    <asp:GridView ID="LPNGridView" runat="server" HeaderStyle-CssClass="GridHead"  AutoGenerateColumns="false"
                    RowStyle-BackColor="#FFFFFF" RowStyle-CssClass="Left5pxPadd" AllowSorting="true" OnSorting="SortDetailGrid"
                    PagerSettings-Position="TopAndBottom" PageSize="25" onpageindexchanging="DetailGridView_PageIndexChanging"
                    OnRowDataBound="DetailRowBound" AllowPaging="true" PagerSettings-Visible="true" PagerSettings-Mode="Numeric"
                    >
                    <AlternatingRowStyle CssClass="Left5pxPadd" BackColor="#DCF3FB" BorderColor="#DAEEEF" />
                    <Columns>
                         <asp:TemplateField ItemStyle-Width="130" HeaderText="LP Number" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="left"  ItemStyle-CssClass="Left5pxPadd rightBorder"  SortExpression="LICENSE_PLATE">
                            <ItemTemplate>
                                <asp:LinkButton ID="LPNLink" runat="server" Text='<%# Eval("LICENSE_PLATE") %>' 
                                 CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="BINLABEL" HeaderText="Bin Location" ItemStyle-HorizontalAlign="center" 
                            ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="110px" HeaderStyle-HorizontalAlign="Center"
                            SortExpression="BINLABEL" />
                        <asp:BoundField DataField="DateCreate" HeaderText="Create Date" ItemStyle-HorizontalAlign="center" 
                            DataFormatString="{0:MM/dd/yyyy}" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="100px" 
                            SortExpression="DateCreate" HeaderStyle-HorizontalAlign="Center"/>
                    </Columns>
                    </asp:GridView>
                    </ContentTemplate></asp:UpdatePanel>
                    </asp:Panel>
               </td>
            </tr>
            <tr>
                <td class="BluBg">
                    <table width="100%">
                        <tr>
                            <td align="left">&nbsp;&nbsp;&nbsp;
                            <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>&nbsp;
                                <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                            </ContentTemplate></asp:UpdatePanel>
                            </td>
                            <td>&nbsp;
                            </td>
                            <td align="right">
                                <img src="../Common/Images/close.gif" style="cursor: hand" onclick="ClosePage();" alt="Close Page">
                            </td>
                        </tr>
                    </table>
                    

                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer2 id="PageFooter2" runat="server">
                    </uc2:Footer2>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
