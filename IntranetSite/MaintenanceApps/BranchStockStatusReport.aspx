<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BranchStockStatusReport.aspx.cs" Inherits="BranchStockStatusReport" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer2" TagPrefix="uc2" %>
<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc4" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    
    <script src="Common/Javascript/Common.js" type="text/javascript"></script>
  
    <script type="text/javascript">
   
        function Close(session)
        {
            UnloadPage(session);
            window.close();
        }
        
        function UnloadPage(session)
        {
           BranchStockStatusReport.DeleteExcel('BSS'+session).value;
           BranchStockStatusReport.UnloadPage().value;
        }
    
        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //take out room for bottom panel
            yh = yh - 220;
            xw = xw
            // size the grid
            if ($get("DetailGridPanel")!=null)
            {
                var DetailGridPanel = $get("DetailGridPanel");
                DetailGridPanel.style.height = yh;  
                DetailGridPanel.style.width = xw;  
                var DetailGridHeightHid = $get("DetailGridHeightHidden");
                DetailGridHeightHid.value = yh;
                var DetailGridHeightHid = $get("DetailGridWidthHidden");
                DetailGridHeightHid.value = xw;
            }
        }
    </script>

    <title>Branch Stock Status Report</title>
</head>
<body onunload="javascript:UnloadPage('<%=Session["SessionID"].ToString() %>');" onload="SetHeight();">
    <form id="frmMain" runat="server">
        <asp:ScriptManager ID="smBranchStockStatus" AsyncPostBackTimeOut="26000" runat="server" EnablePartialRendering="true" />
        <div>
            <asp:UpdatePanel ID="MainUpdatePanel" runat="server">
                <ContentTemplate>
                    <table width="100%" cellspacing="0" cellpadding="0" border="0">
                        <tr>
                            <td>
                                <uc1:Header id="Pageheader" runat="server">
                                </uc1:Header>
                            </td>
                        </tr>
                      <%--  <tr>
                            <td class="lightBlueBg">
                                <span class="BanText">Branch Stock Status Report</span>
                            </td>
                        </tr>--%>
                        <tr>
                            <td class="BluBg">
                                <asp:Panel ID="SelectorPanel" runat="server" Height="100px" Width="100%">
                                    <asp:UpdatePanel ID="SelectorUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <table width="100%" class="shadeBgDown" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td align="left">
                                                        <asp:UpdatePanel ID="pnlFilter" UpdateMode="Conditional" runat="server">
                                                            <ContentTemplate>
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td>
                                                                            <table>
                                                                                <tr>
                                                                                    <td width="45px">&nbsp;</td>
                                                                                    <td width="45px">&nbsp;</td>
                                                                                    <td width="10px">&nbsp;</td>
                                                                                    <td width="50px">&nbsp;</td>
                                                                                    <td class="Left2pxPadd boldText" align="center" width="55px">
                                                                                        Category
                                                                                    </td>
                                                                                    <td class="Left2pxPadd boldText" align="center" width="55px">
                                                                                        Size
                                                                                    </td>
                                                                                    <td class="Left2pxPadd boldText" align="center" width="60px">
                                                                                        Variance
                                                                                    </td>
                                                                                    <td width="25px">&nbsp;</td>
                                                                                    <td>&nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td style="padding-left: 15px; font-weight: bold;">
                                                                                        Branch
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtBranchNo" runat="server" Width="35px" CssClass="FormCtrl txtRight" MaxLength="4" TabIndex="1"
                                                                                            OnFocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>&nbsp;</td>
                                                                                    <td style="padding-left: 15px; font-weight: bold;">
                                                                                        Start
                                                                                    </td>
                                                                                    <td class="Left2pxPadd Right2pxPadd" align="center">
                                                                                        <asp:TextBox CssClass="FormCtrl txtRight" runat="server" ID="txtStrCat" Width="50px"
                                                                                            MaxLength="5" TabIndex="2" AutoPostBack="true" OnTextChanged="txtStrCat_TextChanged"
                                                                                            OnFocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox>
                                                                                    </td>
                                                                                    <td class="Left2pxPadd Right2pxPadd" align="center">
                                                                                        <asp:TextBox CssClass="FormCtrl txtRight" runat="server" ID="txtStrSize" Width="40px"
                                                                                            MaxLength="4" TabIndex="3" AutoPostBack="true" OnTextChanged="txtStrSize_TextChanged"
                                                                                            OnFocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox>
                                                                                    </td>
                                                                                    <td class="Left2pxPadd Right2pxPadd" align="center">
                                                                                        <asp:TextBox CssClass="FormCtrl txtRight" runat="server" ID="txtStrVar" Width="30px"
                                                                                            MaxLength="3" TabIndex="4" AutoPostBack="true" OnTextChanged="txtStrVar_TextChanged"
                                                                                            OnFocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>&nbsp;</td>
                                                                                    <td rowspan="2" valign="middle">
                                                                                        <table>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:ImageButton ID="btnSearch" OnClick="btnSearch_Click" AlternateText="Show Branch Stock Status"
                                                                                                        runat="server" ImageUrl="../Common/Images/search.gif" CausesValidation="false" TabIndex="8" />
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:ImageButton ImageUrl="common/images/refresh.gif" ID="ibtnRefresh" runat="server"
                                                                                                        CausesValidation="false" OnClick="ibtnRefresh_Click" />
                                                                                                </td>
                                                                                                <td width="285px"></td>
                                                                                                <td>
                                                                                                    <asp:UpdatePanel ID="ExcelUpdatePanel" runat="server" UpdateMode="Conditional">
                                                                                                        <ContentTemplate>
                                                                                                            <asp:ImageButton ID="btnExcel" runat="server" ImageUrl="../Common/Images/Excel.gif"
                                                                                                                OnClick="btnExcel_Click" CausesValidation="false" />
                                                                                                        </ContentTemplate>
                                                                                                        <Triggers>
                                                                                                            <asp:PostBackTrigger ControlID="btnExcel" />
                                                                                                        </Triggers>
                                                                                                    </asp:UpdatePanel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <img id="btnClose" alt="Close" style="cursor: hand" src="common/images/Close.gif" onclick="javascript:Close('<%=Session["SessionID"].ToString() %>');" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td colspan="3">&nbsp;</td>
                                                                                    <td style="padding-left: 15px; font-weight: bold;">
                                                                                        End
                                                                                    </td>
                                                                                    <td class="Left2pxPadd Right2pxPadd" align="center">
                                                                                        <asp:TextBox CssClass="FormCtrl txtRight" runat="server" ID="txtEndCat" Width="50px"
                                                                                            MaxLength="5" TabIndex="5" AutoPostBack="true" OnTextChanged="txtEndCat_TextChanged"
                                                                                            OnFocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox>
                                                                                    </td>
                                                                                    <td class="Left2pxPadd Right2pxPadd" align="center">
                                                                                        <asp:TextBox CssClass="FormCtrl txtRight" runat="server" ID="txtEndSize" Width="40px"
                                                                                            MaxLength="4" TabIndex="6" AutoPostBack="true" OnTextChanged="txtEndSize_TextChanged"
                                                                                            OnFocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox>
                                                                                    </td>
                                                                                    <td class="Left2pxPadd Right2pxPadd" align="center">
                                                                                        <asp:TextBox CssClass="FormCtrl txtRight" runat="server" ID="txtEndVar" Width="30px"
                                                                                            MaxLength="3" TabIndex="7" AutoPostBack="true" OnTextChanged="txtEndVar_TextChanged"
                                                                                            OnFocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox>
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
                                                    <td colspan="2" align="left" style="height: 20px">
                                                        <table cellpadding="0" cellspacing="0" width="100%">
                                                            <tr>
                                                               <%-- <td width="475px" style="padding-left: 15px;">
                                                                    <b>Branch Name</b>&nbsp;&nbsp;&nbsp;<asp:Label ID="lblCustName" runat="server" Text=""></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    <asp:Label ID="lblBranch" runat="server" Text=""></asp:Label>
                                                                </td>--%>
                                                                <td>
                                                                   <%-- <asp:Label ID="lblRecType" runat="server" Text=""></asp:Label>--%>
                                                                    <asp:UpdateProgress ID="UpdateProgress2" runat="server" AssociatedUpdatePanelID="MainUpdatePanel" >
                                                                        <ProgressTemplate>
                                                                            The Branch Status Report requested is being retrieved. One Moment....
                                                                        </ProgressTemplate>
                                                                    </asp:UpdateProgress>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>                                                
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td valign="top">
                                            <asp:Panel ID="DetailGridPanel" runat="server" ScrollBars="none">
                                                <asp:HiddenField ID="DetailGridHeightHidden" runat="server" />
                                                <asp:HiddenField ID="DetailGridWidthHidden" runat="server" />
                                                <asp:UpdatePanel ID="DetailUpdatePanel" runat="server" UpdateMode="Conditional">
                                                    <ContentTemplate>
                                                        <div id="divdatagrid" class="Sbar" align="left" runat="server" style="overflow: auto; position: relative; width: 1000px; height: 490px; top: 0px; left: 0px; border: 0px solid; vertical-align: top;">
                                                            <asp:GridView ID="BSSGridView" runat="server" HeaderStyle-CssClass="GridHead" AutoGenerateColumns="False"
                                                                RowStyle-BackColor="#FFFFFF" RowStyle-CssClass="Left5pxPadd" AllowSorting="True" Width="980px" OnSorting="SortDetailGrid">
                                                                
                                                                <AlternatingRowStyle CssClass="Left5pxPadd" BackColor="#DCF3FB" BorderColor="#DAEEEF" />
                                                                <Columns>
                                                                    <asp:BoundField DataField="ItemNo" HeaderText="Item No" SortExpression="ItemNo" >
                                                                        <HeaderStyle HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Center" Width="90px" />
                                                                    </asp:BoundField>
                                                                    
                                                                     <asp:BoundField DataField="CatDesc" HeaderText="Cat Description" SortExpression="CatDesc" >
                                                                         <HeaderStyle HorizontalAlign="Center" />
                                                                         <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Left" Width="150px" />
                                                                     </asp:BoundField>

                                                                    <asp:BoundField DataField="ItemSize" HeaderText="Item Size"                                                                       
                                                                        SortExpression="ItemSize" >
                                                                        <HeaderStyle HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Right" Width="100px" />
                                                                    </asp:BoundField>
                                                                        
                                                                     <asp:BoundField DataField="Finish" HeaderText="Finish" SortExpression="Finish" >
                                                                         <HeaderStyle HorizontalAlign="Center" />
                                                                         <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Right" Width="25px" />
                                                                     </asp:BoundField>    
                                                                        
                                                                    <asp:BoundField DataField="UPCCd" HeaderText="UPC Code"                                                                       
                                                                        SortExpression="UPCCd" >
                                                                        <HeaderStyle HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Right" Width="50px" />
                                                                    </asp:BoundField>   
                                                                     
                                                                    <asp:BoundField DataField="BoxSize" HeaderText="Box Size"
                                                                        DataFormatString="{0:c}"
                                                                        SortExpression="BoxSize" >
                                                                        <HeaderStyle HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Right" Width="30px" />
                                                                    </asp:BoundField>   
                                                                     
                                                                    <asp:BoundField DataField="SellStkUMQty" HeaderText="Sell Stk UM Qty"                                                                        
                                                                        SortExpression="SellStkUMQty" >
                                                                        <HeaderStyle HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Right" Width="40px" />
                                                                    </asp:BoundField>   
                                                                        
                                                                    <asp:BoundField DataField="SellStkUM" HeaderText="Sell Stk UM"
                                                                        DataFormatString="{0:c}"
                                                                        SortExpression="SellStkUM" >
                                                                        <HeaderStyle HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Right" Width="30px" />
                                                                    </asp:BoundField>   
                                                                        
                                                                    <asp:BoundField DataField="PcsPerPallet" HeaderText="Pcs Per Pallet"                                                                      
                                                                        SortExpression="PcsPerPallet" >
                                                                        <HeaderStyle HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Right" Width="40px" />
                                                                    </asp:BoundField>                      

                                                                    <asp:BoundField DataField="SuperUM" HeaderText="Super UM"
                                                                        DataFormatString="{0:c}"
                                                                        SortExpression="SuperUM" >
                                                                        <HeaderStyle HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Right" Width="30px" />
                                                                    </asp:BoundField>  
                                                                                                                         
                                                                    <asp:BoundField DataField="SVC" HeaderText="SVC"                                                                        
                                                                        SortExpression="SVC" >
                                                                        <HeaderStyle HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Right" Width="20px" />
                                                                    </asp:BoundField>
                                                                        
                                                                     <asp:BoundField DataField="ROP" HeaderText="ROP"                                                                       
                                                                        SortExpression="ROP" >
                                                                         <HeaderStyle HorizontalAlign="Center" />
                                                                         <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Right" Width="30px" />
                                                                     </asp:BoundField>    
                                                                        
                                                                    <asp:BoundField DataField="ROPDays" HeaderText="ROP Days"                                                                       
                                                                        SortExpression="ROPDays" >
                                                                        <HeaderStyle HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Right" Width="30px" />
                                                                    </asp:BoundField>   
                                                                     
                                                                    <asp:BoundField DataField="AvlQty" HeaderText="Avl Qty"                                                                      
                                                                        SortExpression="AvlQty" >
                                                                        <HeaderStyle HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Right" Width="30px" />
                                                                    </asp:BoundField>   
                                                                     
                                                                    <asp:BoundField DataField="OHQty" HeaderText="OH Qty"                                                                       
                                                                        SortExpression="OHQty" >
                                                                        <HeaderStyle HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Right" Width="30px" />
                                                                    </asp:BoundField>   
                                                                        
                                                                    <asp:BoundField DataField="WOQty" HeaderText="WO Qty"                                                                       
                                                                        SortExpression="WOQty" >
                                                                        <HeaderStyle HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Right" Width="30px" />
                                                                    </asp:BoundField>   
                                                                        
                                                                    <asp:BoundField DataField="OpenMRPNo" HeaderText="Open MRP No"                                                                      
                                                                        SortExpression="OpenMRPNo" >
                                                                        <HeaderStyle HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Right" Width="50px" />
                                                                    </asp:BoundField>  
                                                                </Columns>
                                                                <RowStyle BackColor="White" CssClass="Left5pxPadd" />
                                                                <HeaderStyle CssClass="GridHead" />
                                                            </asp:GridView>
                                                        </div>                                                       
                                                        <asp:HiddenField ID="ApprovalOKHidden" runat="server" />
                                                        <asp:HiddenField ID="hidRowFilter" runat="server" />
                                                        <input type="hidden" id="hidSort" runat="server" />
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="BluBg">
                                <table width="100%" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td align="left">
                                            &nbsp;&nbsp;&nbsp;
                                            <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>&nbsp;
                                                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen" Font-Bold="true"></asp:Label>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
       <%--                 <tr>
                            <td class="BluBg">
                                <asp:UpdatePanel ID="pnlPager" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <table width="100%" id="tPager" runat="server" visible="false">
                                            <tr>
                                                <td>
                                                    <uc4:pager id="Pager1" onbubbleclick="Pager_PageChanged" runat="server" visible="true" />
                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>   --%>                         
                        <tr>
                            <td align="center">
                                <uc2:Footer2 id="PageFooter2"  Title="Branch Stock Status Report" runat="server">
                                </uc2:Footer2>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </form>
</body>
</html>
