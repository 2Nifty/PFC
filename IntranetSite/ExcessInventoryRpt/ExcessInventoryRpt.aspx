<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ExcessInventoryRpt.aspx.cs" Inherits="ExcessInventoryRpt" %>

<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage2.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="../Common/UserControls/pager.ascx" TagName="Pager" TagPrefix="uc3" %>
<%@ Register Src="../Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc4" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Excess Inventory Report</title>

    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script src="../Common/Javascript/Common.js" type="text/javascript"></script>

    <script>
        function LoadHelp()
        {
            window.open('ExcessInvHelp.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
        }

        function Close(session)
        {
            ExcessInventoryRpt.DeleteExcel('ExcessInv'+session).value;
            window.close();
        }

        function UnloadPage()
        {
           ExcessInventoryRpt.UnloadPage().value;
        }
    </script>

</head>
<body onunload="javascript:UnloadPage();">
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server" ID="smExcessInv"></asp:ScriptManager>
        <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse;" id="tblMain">
            <tr>
                <td height="5%" id="tdHeaders">
                    <uc1:Header ID="HeaderID" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="lightBlueBg" style="border-top:solid 1px #88D2E9; padding-top:5px; border-bottom:solid 1px #88D2E9; padding-bottom:5px;" width="100%">
                    <span class="BanText" style="padding-left: 5px; color: #CC0000">Excess Inventory Report</span>
                </td>
            </tr>
            <tr>
                <td style="padding-top: 0px; padding-left: 0px;" width="100%">
                    <asp:UpdatePanel ID="pnlFilter" UpdateMode="Conditional" runat="server">
                        <ContentTemplate>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td style="padding-top:5px; padding-bottom:5px; border-bottom:solid 1px #88D2E9;">
                                        <table>
                                            <tr>
                                                <td class="Left2pxPadd boldText">Location</td>
                                                <td class="Left2pxPadd Right2pxPadd">
                                                    <asp:DropDownList Width="150" ID="ddlLocation" Height="20px" TabIndex="1" CssClass="FormCtrl2" runat="server"></asp:DropDownList>
                                                </td>
                                                <td class="Left2pxPadd boldText" align="center" Width="60px">Category</td>
                                                <td class="Left2pxPadd boldText" align="center" Width="60px">Size</td>
                                                <td class="Left2pxPadd boldText" align="center" Width="60px">Variance</td>
                                                <td class="Left2pxPadd boldText" align="center" Width="80px">Min Excess</td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd boldText">Bulk/Pkg</td>
                                                <td class="Left2pxPadd Right2pxPadd">
                                                    <asp:DropDownList Width="150" ID="ddlRecType" Height="20px" TabIndex="2" CssClass="FormCtrl2" runat="server">
                                                        <asp:ListItem Value="ALL" Text="ALL" Selected="True" />
                                                        <asp:ListItem Value="Bulk" Text="Bulk Items" />
                                                        <asp:ListItem Value="Pkg" Text="Pkg Items" />
                                                    </asp:DropDownList>
                                                </td>
                                                <td class="Left2pxPadd Right2pxPadd" align="center">
                                                    <asp:TextBox CssClass="FormCtrl2 txtRight" runat="server" ID="txtCat" Width="50px" MaxLength="5" TabIndex="3" AutoPostBack="true" OnTextChanged="txtCat_TextChanged"
                                                        OnFocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox>
                                                </td>
                                                <td class="Left2pxPadd Right2pxPadd" align="center">
                                                    <asp:TextBox CssClass="FormCtrl2 txtRight" runat="server" ID="txtSize" Width="40px" MaxLength="4" TabIndex="4" AutoPostBack="true" OnTextChanged="txtSize_TextChanged"
                                                        OnFocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox>
                                                </td>
                                                <td class="Left2pxPadd Right2pxPadd" align="center">
                                                    <asp:TextBox CssClass="FormCtrl2 txtRight" runat="server" ID="txtVar" Width="30px" MaxLength="3" TabIndex="5" AutoPostBack="true" OnTextChanged="txtVar_TextChanged"
                                                        OnFocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox>
                                                </td>
                                                <td class="Left2pxPadd Right2pxPadd" align="center">
                                                    <asp:TextBox CssClass="FormCtrl2 txtRight" runat="server" ID="txtMin" Width="75px" MaxLength="12" TabIndex="6" AutoPostBack="true" OnTextChanged="txtMin_TextChanged"
                                                        OnFocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;" onkeypress="javascript:ValidateNumber();"></asp:TextBox>
                                                </td>
                                                <td align="right" width="10%">
                                                    <asp:ImageButton ID="btnSubmit" runat="server" ImageUrl="../Common/images/Submit.gif" TabIndex="7"
                                                        CausesValidation="false" OnClick="btnSubmit_Click" />
                                                </td>
                                                <td align="right" width="40%">
                                                    <asp:ImageButton ID="btnCancel" runat="server" ImageUrl="../Common/images/cancel.gif" TabIndex="8"
                                                        CausesValidation="false" OnClick="btnCancel_Click" />&nbsp;&nbsp;
                                                    <img src="../Common/images/help.gif" onclick="javascript:LoadHelp();" style="cursor: hand" />&nbsp;&nbsp;
                                                    <img id="btnClose" src="../Common/images/close.gif" style="cursor:hand" onclick="javascript:Close('<%=Session["SessionID"].ToString() %>');" TabIndex="9" />
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
                <td height="475px" valign="top">
                    <table cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td valign="top">
                                <asp:UpdatePanel ID="pnlRptGrid" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div runat="server" id="divRptGrid" visible="true">
                                            <div id="divdatagrid" class="Sbar" align="left" runat="server" style="overflow:auto; width:1020px; position:relative; top:0px; left:0px; height:475px; border:0px solid; vertical-align:top; overflow-y:scroll;">

                                                <asp:DataGrid ID="dgExcessInv" Width="1003px" runat="server" BorderWidth="1px" BorderColor="#DAEEEF" CssClass="grid"
                                                    Style="height: auto;" UseAccessibleHeader="True" AutoGenerateColumns="False" AllowSorting="True"
                                                    PagerStyle-Visible="false" OnSortCommand="dgExcessInv_SortCommand" AllowPaging="True" PageSize="18">
                                                        <HeaderStyle CssClass="gridHeader" ForeColor="#003366" Height="20px" HorizontalAlign="Center" />
                                                        <ItemStyle CssClass="GridItem" />
                                                        <AlternatingItemStyle CssClass="zebra" />
                                                        <FooterStyle CssClass="lightBlueBg" HorizontalAlign="Right" />
                                                        <Columns>
                                                            <asp:BoundColumn HeaderText="Item Type" DataField="RecordType" SortExpression="RecordType">
                                                                <HeaderStyle Width="70px" />
                                                                <ItemStyle Width="70px" HorizontalAlign="Center" Wrap="False" />
                                                            </asp:BoundColumn>
                                                            
                                                            <asp:BoundColumn HeaderText="Item Number" DataField="ItemNo" SortExpression="ItemNo">
                                                                <HeaderStyle Width="100px" />
                                                                <ItemStyle Width="100px" HorizontalAlign="Center" Wrap="False" />
                                                            </asp:BoundColumn>
                                                            
                                                            <asp:BoundColumn HeaderText="Loc" DataField="Branch" SortExpression="Branch">
                                                                <HeaderStyle Width="30px" />
                                                                <ItemStyle Width="30px" HorizontalAlign="Center" Wrap="False" />
                                                            </asp:BoundColumn>

                                                            <asp:BoundColumn HeaderText="Size" DataField="ItemSize" SortExpression="ItemSize">
                                                                <HeaderStyle Width="200px" />
                                                                <ItemStyle Width="200px" HorizontalAlign="Left" Wrap="False" />
                                                            </asp:BoundColumn>
                                                            
                                                            <asp:BoundColumn HeaderText="Description" DataField="Description" SortExpression="Description">
                                                                <HeaderStyle Width="315px" />
                                                                <ItemStyle Width="315px" HorizontalAlign="Left" Wrap="False" />
                                                            </asp:BoundColumn>
                                                            
                                                            <asp:BoundColumn HeaderText="UOM" DataField="UOM" SortExpression="UOM">
                                                                <HeaderStyle Width="28px" />
                                                                <ItemStyle Width="28px" HorizontalAlign="Center" Wrap="False" />
                                                            </asp:BoundColumn>

                                                            <asp:BoundColumn HeaderText="Available" DataField="AvailableQty" SortExpression="AvailableQty" DataFormatString="{0:n0}">
                                                                <HeaderStyle Width="70px" />
                                                                <ItemStyle Width="70px" HorizontalAlign="Right" Wrap="False" />
                                                            </asp:BoundColumn>

                                                            <asp:BoundColumn HeaderText="Excess Qty" DataField="ExcessQty" SortExpression="ExcessQty" DataFormatString="{0:n0}">
                                                                <HeaderStyle Width="60px" />
                                                                <ItemStyle Width="60px" HorizontalAlign="Right" Wrap="False" />
                                                            </asp:BoundColumn>

                                                            <asp:BoundColumn HeaderText="Excess Wght" DataField="ExcessWght" SortExpression="ExcessWght" DataFormatString="{0:n3}">
                                                                <HeaderStyle Width="80px" />
                                                                <ItemStyle Width="80px" HorizontalAlign="Right" Wrap="False" />
                                                            </asp:BoundColumn>
                                                            
                                                            <asp:BoundColumn HeaderText="ROP" DataField="ReOrderPoint" SortExpression="ReOrderPoint" DataFormatString="{0:n1}">
                                                                <HeaderStyle Width="50px" />
                                                                <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                            </asp:BoundColumn>
                                                        </Columns>
                                                    <PagerStyle Visible="False" />
                                                </asp:DataGrid>
                                                <asp:HiddenField ID="hidRowCount" runat="server" />
                                                <asp:HiddenField ID="hidPreviewURL" runat="server" />
                                                <input type="hidden" id="hidSort" runat="server" />
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="lightBlueBg buttonBar" style="border-top:solid 1px #CDECF6" height="20px">
                    <table>
                        <tr>
                            <td>
                                <asp:UpdateProgress ID="pnlProgress" runat="server" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                            <td>
                                <asp:UpdatePanel ID="pnlStatus" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Width="300px" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td width="64%" align="right">
                                <asp:ImageButton ID="btnExport" Style="cursor: hand;" Height="18px" Width="18px" CausesValidation="false" ImageUrl="~/Common/Images/ExcelIcon.jpg"
                                    ToolTip="Export To Excel" runat="server" OnClick="btnExport_Click" />
                            </td>
                            <td style="padding-left: 3px">
                                <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlExport">
                                    <ContentTemplate>
                                        <uc4:PrintDialogue ID="PrintDialogue1" PageTitle="ExcessInventory" EnableFax="false" EnableEmail="false" runat="server"></uc4:PrintDialogue>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="BluBg">
                    <asp:UpdatePanel ID="pnlPager" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" id="tPager" runat="server">
                                <tr>
                                    <td>
                                        <uc3:pager ID="Pager1" OnBubbleClick="PageChanged" runat="server" Visible="true" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="BottomFooterID" FooterTitle="Excess Inventory Report" runat="server" />
                </td>
            </tr>
        </table>
        <asp:HiddenField ID="hidSecurity" runat="server" />
        <input type="hidden" id="hidScroll" runat="server" value="0"/>
    </form>
</body>
</html>
