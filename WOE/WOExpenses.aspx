<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WOExpenses.aspx.cs" Inherits="WOExpenses" %>

<%@ Register Src="Common/UserControls/MinFooter.ascx" TagName="MinFooter" TagPrefix="uc3" %>
<%@ Register Src="~/Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc4" %>
<%@ Register Src="~/Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>WOE - Enter Expenses</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script src="Common/JavaScript/WOEValidation.js" type="text/javascript"></script>
    <script src="Common/JavaScript/WorkOrderEntry.js" type="text/javascript"></script>

    <script>
    function CloseForm()
    {
        //parent.bodyFrame.document.getElementById("btnCheckExpComment").click();     
        window.opener.top.window.frames[2].document.location.href='WorkOrderEntry.aspx';           
        window.close();
    }
    
    // Delete Context Menu
    function DeleteExpenseLine(lineNo,ctrlID,e)
    {
        
        if(event.button ==2)
        {  
            ShowDelete(ctrlID,e);
            document.getElementById("hidWoCompId").value = lineNo;    
        }    
    }
    
   
    
    </script>

</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table border="0" cellpadding="0" cellspacing="2" style="width: 100%; height: 100%"
            class="HeaderPanels">
            <tr>
                <td>
                    <asp:UpdatePanel ID="upHeader" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td valign="top" class="SubHeaderPanels" style="padding-left: 4px; padding-top: 4px;"
                                        width="30%">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td height="20" valign="middle">
                                                    <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="Work Order Number:"
                                                        Width="117px"></asp:Label></td>
                                                <td>
                                                    <asp:Label ID="lblWONumber" runat="server" Font-Bold="False" Style="padding-left: 5px"
                                                        Width="50px"></asp:Label></td>
                                            </tr>
                                        </table>
                                        <asp:HiddenField ID="hidPONumber" runat="server" />
                                    </td>
                                    <td valign="top" class="SubHeaderPanels" width="35%" style="padding-left: 4px; padding-top: 4px;">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td>
                                                    <asp:LinkButton ID="lnkMfgGrp" runat="server" Font-Underline="false" CssClass="TabHead"
                                                        OnClientClick="Javascript:return false;" Text="Mfg Group:" Font-Bold="True" Width="62px"></asp:LinkButton></td>
                                                <td>
                                                    <asp:Label ID="lblMfgName" runat="server" CssClass="lblColor"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblMfgCode" runat="server" CssClass="lblColor"></asp:Label></td>
                                                <td>
                                                    <asp:Label ID="lblMfgAddress" runat="server" CssClass="lblColor"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblMfgAddress2" runat="server" CssClass="lblColor"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                </td>
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="lblMfgCity" runat="server" CssClass="lblColor"></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblMfgComma" runat="server" CssClass="lblColor">, </asp:Label></td>
                                                            <td>
                                                                &nbsp;<asp:Label ID="lblMfgState" runat="server" CssClass="lblColor"></asp:Label></td>
                                                            <td>
                                                                &nbsp;<asp:Label ID="lblMfgPincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                                            <td>
                                                                &nbsp;<asp:Label ID="lblMfgCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblMfgPhone" runat="server" CssClass="lblColor"></asp:Label></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td valign="top" class="SubHeaderPanels" style="padding-left: 4px; padding-top: 4px;"
                                        width="35%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td width="55px">
                                                    <asp:LinkButton ID="lnkPackBy" runat="server" CssClass="TabHead" Font-Underline="false"
                                                        OnClientClick="Javascript:return false;" Text="Pack By:" Font-Bold="True" Width="45px"></asp:LinkButton></td>
                                                <td>
                                                    <asp:Label ID="lblPckName" runat="server" CssClass="lblColor"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblPckAddress" runat="server" CssClass="lblColor"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblPckAddress2" runat="server" CssClass="lblColor"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                </td>
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="lblPckCity" runat="server" CssClass="lblColor"></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblPckComma" runat="server" CssClass="lblColor">, </asp:Label></td>
                                                            <td>
                                                                &nbsp;<asp:Label ID="lblPckState" runat="server" CssClass="lblColor"></asp:Label></td>
                                                            <td>
                                                                &nbsp;<asp:Label ID="lblPckPincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                                            <td>
                                                                &nbsp;<asp:Label ID="lblPckCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblPckPhone" runat="server" CssClass="lblColor"></asp:Label></td>
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
                <td class="lightBg" style="vertical-align: top; padding-bottom: 10px; padding-top: 10px;
                    padding-left: 5px">
                    <asp:UpdatePanel ID="upOrderEntry" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table>
                                <tr>
                                    <td style="font-weight: bold;">
                                        WO Number
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtWONo" runat="server"></asp:TextBox>
                                    </td>
                                    <td rowspan="2">
                                        <asp:ImageButton ID="ibtnFind" runat="server" ImageUrl="~/Common/Images/submit.gif"
                                            OnClick="ibtnFind_Click" CausesValidation="False" /></td>
                                    </td>
                                    <td rowspan="4" style="padding-left: 12px; padding-top: 4px; font-weight: bold;"
                                        valign="top">
                                        Item:
                                        <asp:Label ID="lblItemNo" runat="server"></asp:Label><br />
                                        Desc:
                                        <asp:Label ID="lblItemDesc" runat="server"></asp:Label><br />
                                        Qty:
                                        <asp:Label ID="lblQty" runat="server"></asp:Label><br />
                                        Pieces:
                                        <asp:Label ID="lblTotPcs" runat="server"></asp:Label>
                                        Cost Per:
                                        <asp:Label ID="lblPieceCost" runat="server"></asp:Label><br />
                                        Weight:
                                        <asp:Label ID="lblTotWght" runat="server"></asp:Label>
                                        Cost Per:
                                        <asp:Label ID="lblPoundCost" runat="server"></asp:Label><br />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">
                                        PO Number
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtExpPONo" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">
                                        Vendor Number
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtVendorNo" runat="server"></asp:TextBox>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">
                                        Vendor Reference
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtVendorRef" runat="server"></asp:TextBox>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="vertical-align: top; padding-bottom: 10px; padding-top: 10px;
                    padding-left: 5px">
                    <asp:UpdatePanel ID="upExpenseEntry" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table cellpadding="1" cellspacing="0" width="100%" class="data" border="0" bordercolor="#efefef">
                                <tr style="font-weight: bold;">
                                    <td>
                                        Code
                                    </td>
                                    <td>
                                        Description
                                    </td>
                                    <td>
                                        Amount
                                    </td>
                                    <td>
                                        Spread Per
                                    </td>
                                    <td rowspan="2" align="center" valign="middle">
                                        <asp:ImageButton ID="ibtnSave" runat="server" ImageUrl="~/Common/Images/Save.jpg"
                                            OnClick="ibtnSave_Click" CausesValidation="True" /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:DropDownList ID="ddlCode" AutoPostBack="true" CssClass="lbl_whitebox" runat="server"
                                            Height="20" Width="140px" OnSelectedIndexChanged="ddlCode_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblDescription" CssClass="lblbox" runat="server" Text="" Width="140"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtAmount" CssClass="lbl_whitebox" runat="server" Width="50" CausesValidation="false"
                                            OnTextChanged="txtAmount_TextChanged" MaxLength="15" onkeypress="javascript:ValdateNumberWithDot(this.value);"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:RadioButton GroupName="SpreadType" ID="radSpreadPiece" runat="server" Text="Piece"
                                            Checked="true" />
                                        <asp:RadioButton GroupName="SpreadType" ID="radSpreadWeight" runat="server" Text="Pound" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="upExpenseGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <div class="Sbar" oncontextmenu="Javascript:return false;" id="div-datagrid" style="overflow-x: auto;
                                overflow-y: auto; position: relative; top: 0px; left: 0px; height: 237px; border: 1px solid #88D2E9;
                                width: 705px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94">
                                <asp:GridView ShowFooter="false" UseAccessibleHeader="true" ID="gvExpense" PagerSettings-Visible="false"
                                    Width="900" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="true"
                                    AutoGenerateColumns="false" OnSorting="gvExpense_Sorting" OnRowDataBound="gvExpense_RowDataBound">
                                    <HeaderStyle HorizontalAlign="center" CssClass="GridHead" Font-Bold="true" Height="25px"
                                        BackColor="#DFF3F9" />
                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                    <RowStyle CssClass="item" Wrap="False" BackColor="#FFFFFF" Height="20px" BorderWidth="1px" />
                                    <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="20px" BorderWidth="1px" />
                                    <Columns>                                            
                                        <asp:TemplateField  HeaderText="Code" SortExpression="ItemNo" ItemStyle-CssClass="Left5pxPadd">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPFCItemNo" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ItemNo") %>'></asp:Label>
                                                <asp:HiddenField ID="hidpWoCompId" Value='<%#  DataBinder.Eval(Container.DataItem,"pWOComponentID")%>' runat=server/>                                                
                                                <asp:HiddenField ID="hidDeleteDt" Value='<%#  DataBinder.Eval(Container.DataItem,"DeleteDt")%>' runat=server/>                                                
                                                </ItemTemplate>                                                
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:TemplateField> 
                                        <asp:BoundField HeaderText="Description" DataField="ItemDesc" SortExpression="ItemDesc"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="180px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Cost" DataField="UnitCost" SortExpression="UnitCost"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Total" DataField="ExtendedCost" DataFormatString="{0:00.00}"
                                            SortExpression="ExtendedCost" ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="right" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Spread" DataField="BillType" SortExpression="BillType"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="center" Width="30px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Delete Date" DataField="DeleteDt" SortExpression="DeleteDt"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Entry Date" DataField="EntryDt" SortExpression="EntryDt"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Entry ID" DataField="EntryID" SortExpression="EntryID"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Change Date" DataField="ChangeDt" SortExpression="ChangeDt"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Change ID" DataField="ChangeID" SortExpression="ChangeID"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:BoundField>                                        
                                    </Columns>
                                </asp:GridView>
                                <input id="hidSort" type="hidden" name="Hidden1" runat="server">
                                <asp:HiddenField ID="hidNetSales" runat="server" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td>
                    <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlContextMenu">
                        <ContentTemplate>
                            <div id="divDelete" class="MarkItUp_ContextMenu_MenuTable" style="display: none;
                                word-break: keep-all; position: absolute;">
                                <table border="0" cellpadding="0" cellspacing="0" class="MarkItUp_ContextMenu_Outline"
                                    width="100">
                                    <tr>
                                        <td>
                                            <table border="0" cellspacing="5" width="100">
                                                <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                                    onmouseover="this.className='GridHead'">
                                                    <td class="" width="20">
                                                        <img src="Common/Images/edit_icon.gif" style="width:18;height:20px;" /></td>
                                                    <td align="left" class="" style="cursor: hand;" onclick="Javascript:return CallServerButtonClick('btnEdit');">
                                                        <strong>Edit</strong></td>
                                                </tr>
                                                <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                                    onmouseover="this.className='GridHead'">
                                                    <td class="" width="20">
                                                        <img src="Common/Images/delete.jpg" /></td>
                                                    <td align="left" class="" style="cursor: hand;" onclick="Javascript:return CallServerButtonClick('btnDelete');">
                                                        <strong>Delete</strong></td>
                                                </tr>
                                                <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                                    onmouseover="this.className='GridHead'">
                                                    <td class="" width="20">
                                                        <img src="Common/Images/cancelrequest.gif" /></td>
                                                    <td align="left" class="" style="cursor: hand;" onclick="Javascript:document.getElementById('divDelete').style.display='none';document.getElementById(hidRowID.value).style.fontWeight='normal';">
                                                        <strong>Cancel</strong>
                                                        <input type="hidden" value="" id="hidRowID" />
                                                        <input type="hidden" value="" runat="server" id="hidWoCompId" />
                                                        <asp:Button ID="btnDelete" runat="server" Style="display: none;" OnClick="btnDelete_Click" />
                                                        <asp:Button ID="btnEdit" runat="server" Style="display: none;" OnClick="btnEdit_Click" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="right" width="100%" id="tdButton" class="commandLine splitborder_t_v splitborder_b_v"
                    style="height: 20px; background-position: -80px  left;">
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td align="left" width="89%">
                                <asp:UpdateProgress ID="upPanel" runat="server">
                                    <ProgressTemplate>
                                        <span class="TabHead">Loading...</span></ProgressTemplate>
                                </asp:UpdateProgress>
                                <asp:UpdatePanel ID="upProgress" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlExport">
                                    <ContentTemplate>
                                        <uc4:PrintDialogue ID="PrintDialogue1" runat="server"></uc4:PrintDialogue>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="right" style="padding-right: 5px;">
                    <asp:ImageButton ID="btnClose" Style="padding-left: 5px;" runat="server" CausesValidation="false"
                                                            AlternateText="Close" ImageUrl="~/Common/Images/Close.gif" OnClick="btnClose_Click" /></td>
                    
                <td>
            </tr>
            <tr>
                <td>
                    <uc3:MinFooter ID="MinFooter1" runat="server" Title="Enter Expenses" />
                </td>
            </tr>
        </table>
    </form>
    <%-- <script language="javascript">
   
     document.getElementById("hidNetSales").value=window.opener.parent.bodyFrame.form1.document.getElementById("lblSales").innerHTML;    
    </script>--%>
</body>
</html>
