<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WOFind.aspx.cs" Inherits="WOFind" %>

<%@ Register Src="Common/UserControls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/popupdatepicker.ascx" TagName="popupdatepicker" TagPrefix="uc4" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>WO Find</title>

    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
<%--    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />--%>

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>
    <script src="Common/Javascript/ContextMenu.js" type="text/javascript"></script>
    <script src="Common/Javascript/DatePicker.js" type="text/javascript"></script>

    <style type="text/css">
        .zebra td
            {padding-right: 0px;}

        .gridItem
            {padding-right: 0px;}

        .txtCenter
            {horizontal-align: center;}
    </style>
    
    <script type="text/javascript" language="javascript">
        function OpenWO(OrderNo)
        {        
            //alert("WOE");
            var win = window.open("Frame.aspx?UserID=" + '<%= Session["UserID"].ToString().Trim() %>&UserName=<%= Session["UserName"].ToString().Trim() %>&WOOrderNo=' + OrderNo ,'WOE','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
            win.focus();
        }

        function OpenSO(SORefNo)
        {        
            //alert("SOE");
            win = window.open ("../../SOE/SoRecall/ProgressBar.aspx?destPage=SORecall.aspx?UserID=" + '<%= Session["UserID"].ToString().Trim() %>~UserName=<%= Session["UserName"].ToString().Trim() %>' + "~DocNo=" + SORefNo + "~DocType=S" ,'SORecall','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');
            win.focus();
        }

        function UnloadPage(uid)
        {
            //alert ('Unload');
            WOFind.DeleteExcel('WOFind'+uid).value;
            //alert ('WOFind'+uid);
            WOFind.UnloadPage().value;
            //alert ('End Unload');
        }
        
        // Change the checkbox
        function ChangeMassPrint(PrintBox)
        {
            // get the WO number from the row
            var LineParent = PrintBox.parentNode.parentNode;
            // also get the Item, Loc, and UOM
            var status = WOFind.UpdMassprint(
                LineParent.childNodes[1].childNodes[0].innerHTML
                ,PrintBox.checked.toString()
                ).value;
            //alert(status);
            if (status.substr(0,2)=="!!")
            {
                alert(status);
            }
        }

        function ViewMassPrint()
        {
            var status = WOFind.GetMassprint().value;
            //alert(status);
            if (status.substr(0,2)=="!!")
            {
                alert(status);
            }
            else 
            {
                if(status == "NoRecs")
                {
                    alert('You must use the Print check box to select WOs for printing.');
                }
                else
                {
                    var hwnd;
                    //Url = "WOPrinting/WorkOrderExport.aspx?WorkOrder=[DocNo]"
    var Url = "WOPrinting/PrintUtility.aspx?pageURL=WorkOrderExport.aspx?WorkOrder=[DocNo]&CustomerNumber=&SoeNo=Work Orders&Mode=Print&FormName=WorkOrderExport";   
    hwnd=window.open(Url,"PrintUtility" ,'height=320,width=650,scrollbars=yes,status=no,top='+((screen.height/2) - (320/2))+',left='+((screen.width/2) - (650/2))+',resizable=No',"");
                    //hwnd=window.open(Url,"WOMassPrint" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
                    hwnd.focus();
                }
            }
            return false;
        }
    
    
    </script>

</head>
<body onunload="javascript:UnloadPage('<%=Session["UserID"].ToString() %>');">
    <form id="form1" runat="server" defaultfocus="ddlUserId">
        <asp:ScriptManager ID="smWOFind" AsyncPostBackTimeout="360000" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table border="0" cellpadding="0" cellspacing="2" style="width: 100%; height: 100%" class="HeaderPanels">
            <tr>
                <td width="100%">
                    <asp:UpdatePanel ID="pnlFind" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td valign="bottom" class="SOFindHeaderPanels" style="padding-left: 4px; padding-top: 5px" width="100%">
                                        <asp:Panel ID="pnlFilter" runat="server" Width="100%" DefaultButton="ibtnFind">
                                            <table border="0" cellpadding="2" cellspacing="0">
                                                <tr>
                                                    <td colspan="2">&nbsp;</td>
                                                    <td colspan="2" align="center" style="padding-bottom: 8px; font-weight: bold;">
                                                        ----- Order Status Date Range -----
                                                    </td>
                                                    <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblUserId" runat="server" Text="User Id:" Font-Bold="True" Width="80px"></asp:Label>
                                                    </td>
                                                    <td width="200px">
                                                        <asp:DropDownList ID="ddlUserId" CssClass="lbl_whitebox" Height="20px" Width="140px" runat="server" TabIndex="1" />
                                                    </td>
                                                    <td width="75px" style="font-weight: bold;">
                                                        Description
                                                    </td>
                                                    <td width="160px">
                                                        <asp:DropDownList ID="ddlStatusDesc" CssClass="lbl_whitebox" Height="20px" Width="140px" runat="server" TabIndex="4" />
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblPrinted" runat="server" Text="Printed:" Font-Bold="True" Width="80px"></asp:Label>
                                                    </td>
                                                    <td width="200px">
                                                        <asp:DropDownList ID="ddlPrinted" CssClass="lbl_whitebox" Height="20px" Width="190px" runat="server" TabIndex="1" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblWOType" runat="server" Text="WO Type:" Font-Bold="True" Width="80px"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlWOType" CssClass="lbl_whitebox" Height="20px" Width="140px" runat="server" TabIndex="2" />
                                                    </td>
                                                    <td style="font-weight: bold;">
                                                        Start Date
                                                    </td>
                                                    <td>
                                                        <uc4:popupdatepicker ID="dtStartDt" runat="server" TabIndex="5" ParentErrCtl="lblMessage" />
                                                    </td>
                                                    <td style="font-weight: bold;">
                                                        Routing
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlRouting" CssClass="lbl_whitebox" Height="20px" Width="140px" runat="server" TabIndex="4" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblSalesLocation" runat="server" Text="Mfg Location:" Font-Bold="True" Width="80px"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlMfgLoc" CssClass="lbl_whitebox" Height="20px" Width="140px" runat="server" TabIndex="3" />
                                                    </td>
                                                    <td style="font-weight: bold;">
                                                        End Date
                                                    </td>
                                                    <td>
                                                        <uc4:popupdatepicker ID="dtEndDt" runat="server" TabIndex="6" ParentErrCtl="lblMessage" />
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="ibtnFind" runat="server" ImageUrl="common/images/ShowButton.gif" OnClick="ibtnFind_Click" TabIndex="7" />
                                                    </td>
                                                    <td align="right">
                                                        <asp:ImageButton ID="ibtnCancel" runat="server" ImageUrl="common/images/cancel.gif" OnClick="ibtnCancel_Click" TabIndex="8" />
                                                        <asp:ImageButton ID="ibtnHelp" runat="server" ImageUrl="common/images/help.gif" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="pnlWOGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <div class="Sbar" id="div-datagrid" style="position: relative; top: 0px; left: 0px; height: 363px; border: 1px solid #88D2E9; width: 740px; background-color: White;">
                                            <asp:DataGrid ShowFooter="false" UseAccessibleHeader="true" ID="dgFind" PagerStyle-Visible="false"
                                                Width="1150px" runat="server" AllowPaging="true" ShowHeader="true" AllowSorting="true"
                                                OnItemDataBound ="dgFind_ItemDataBound" AutoGenerateColumns="false" OnSortCommand="dgFind_SortCommand">
                                                <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" BackColor="#DFF3F9" />
                                                <ItemStyle CssClass="GridItem" />
                                                <AlternatingItemStyle CssClass="zebra" />
                                                <Columns>
                                                    <asp:TemplateColumn HeaderText="Print" SortExpression="MassPrint">
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chkPrint" runat="server" onclick="ChangeMassPrint(this);"></asp:CheckBox>
                                                            <asp:HiddenField ID="hidMassPrint" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"MassPrint") %>' />
                                                        </ItemTemplate>
                                                        <ItemStyle Width="35px" HorizontalAlign="Center" Wrap="False" />
                                                    </asp:TemplateColumn>

                                                    <asp:TemplateColumn HeaderText="Order No" SortExpression="POOrderNo">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnkOrderNo" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"POOrderNo") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="70px" HorizontalAlign="Center" Wrap="False" />
                                                    </asp:TemplateColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="50px" HeaderText="PO Type"
                                                                     ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="POType" SortExpression="POType">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="20px" HeaderText="Loc"
                                                                     ItemStyle-Width="20px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="LocationCd" SortExpression="LocationCd">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="90px" HeaderText="Item No"
                                                                     ItemStyle-Width="90px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="ItemNo" SortExpression="ItemNo">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="300px" HeaderText="Item Desc"
                                                                     ItemStyle-Width="300px" ItemStyle-HorizontalAlign="Left"
                                                                     DataField="ItemDesc" SortExpression="ItemDesc">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="60px" HeaderText="Mfg Qty"
                                                                     ItemStyle-Width="60px" ItemStyle-HorizontalAlign="Right"
                                                                     DataField="QtyOrdered" SortExpression="QtyOrdered" DataFormatString="{0:#,##0}">
                                                    </asp:BoundColumn>
                                                    
                                                    <asp:BoundColumn HeaderStyle-Width="30px" HeaderText="UM"
                                                                     ItemStyle-Width="30px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="BaseQtyUM" SortExpression="BaseQtyUM">
                                                    </asp:BoundColumn>

                                                    <asp:TemplateColumn HeaderText="SO Ref No" SortExpression="SORefNo">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnkRefNo" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"SORefNo") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="65px" HorizontalAlign="Center" Wrap="False" />
                                                    </asp:TemplateColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="120px" HeaderText="User Id"
                                                                     ItemStyle-Width="120px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="UserId" SortExpression="UserId">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="75px" HeaderText="Order Dt"
                                                                     ItemStyle-Width="75px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="OrderDt" SortExpression="OrderDt" DataFormatString="{0:MM/dd/yyyy}">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="75px" HeaderText="Pick Sheet Dt"
                                                                     ItemStyle-Width="75px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="PickSheetDt" SortExpression="PickSheetDt" DataFormatString="{0:MM/dd/yyyy}">
                                                    </asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="75px" HeaderText="Due Dt"
                                                                     ItemStyle-Width="75px" ItemStyle-HorizontalAlign="Center"
                                                                     DataField="RequestedReceiptDt" SortExpression="RequestedReceiptDt" DataFormatString="{0:MM/dd/yyyy}">
                                                    </asp:BoundColumn>
                                                    
                                                    <asp:BoundColumn DataField="RoutingNo" 
                                                                    HeaderStyle-Width="70px" HeaderText="Route" ItemStyle-HorizontalAlign="Left"
                                                                    ItemStyle-Width="70px" SortExpression="RoutingNo">
                                                    </asp:BoundColumn>
                                                </Columns>
                                            </asp:DataGrid>
                                            <input id="hidSort" type="hidden" name="hidSort" runat="server" />
                                            <asp:HiddenField ID="hidSecurity" runat="server" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <uc1:pager id="Pager1" onbubbleclick="Pager1_PageChanged" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="right" width="100%" id="tdButton" class="commandLine splitborder_t_v splitborder_b_v"
                    style="height: 20px; background-position: -80px  left;">
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="left">
                                    <asp:UpdateProgress ID="pnlProgress" runat="server" DynamicLayout="true">
                                        <ProgressTemplate>
                                            <span class="TabHead">Loading...</span></ProgressTemplate>
                                    </asp:UpdateProgress>
                                </td>
                                <td align="left" width="89%">
                                    <asp:UpdatePanel ID="pnlStatus" runat="server" UpdateMode="conditional">
                                        <ContentTemplate>
                                            <asp:Label ID="lblMessage" ForeColor="green" CssClass="TabHead" runat="server" Text=""></asp:Label>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td align="right" valign="bottom" width="35px">
                                    <asp:ImageButton ID="DoMassPrint" ImageUrl="Common/Images/Shipper.jpg" 
                                        ToolTip="Click here to PRINT WOs for the CHECKED LINES"
                                        runat="server" OnClientClick="javascript:return ViewMassPrint();" />
                                </td>
                                <td width="30px" align="right" valign="bottom">
                                    <asp:ImageButton ID="btnExport" Style="cursor: hand;" Height="18px" Width="18px" CausesValidation="false" ImageUrl="~/Common/Images/ExcelIcon.jpg"
                                        ToolTip="Export To Excel" ImageAlign="Bottom" runat="server" OnClick="btnExport_Click" />
                                </td>
                                <td>
                                    <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlExport">
                                        <ContentTemplate>
                                            <uc2:PrintDialogue ID="PrintDialogue1" PageTitle="WO Find Report" EnableEmail="true" runat="server" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                        </table>
                </td>
            </tr>
            <tr>
                <td align="right" style="padding-right: 5px;">
                    <table cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td>
                                <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <uc3:Footer ID="Footer1" LeftText="" Title="Work Order Find" CopyRight="" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
