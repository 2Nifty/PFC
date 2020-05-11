<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FiscalPeriod.aspx.cs" Inherits="Fiscal" %>

<%@ Register Src="~/MaintenanceApps/Common/UserControls/TwoDatePicker.ascx" TagName="TwoDatePicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Fiscal Period</title>
    <link href="../MaintenanceApps/Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>

    <style>    
    .DarkBluTxt 
    {
	    font-family: Arial, Helvetica, sans-serif;
	    font-size: 11px;
	    color: #003366;
	    padding-left: 10px;
	    font-weight:bold;
	    text-align:left;
	    vertical-align:middle;
    }
    </style>
</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';"
    onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server" defaultfocus="txtSearchCode">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr class="lightBlueBg" style="padding-top: 1px;">
                <td id="tdHeader" style="padding-top: 1px;">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
         
            <tr>
                <td style="padding-top: 1px;">
                    <table style="width: 100%" class="blueBorder" cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="lightBlueBg">
                                <asp:Label ID="lblHeading" runat="server" Text="Enter Fiscal Period Information"
                                    CssClass="BanText" Width="334px"></asp:Label></td>
                            <td style="width: 100%; height: 5px" align="right" class="lightBlueBg">
                                <asp:UpdatePanel ID="upnlAdd" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <table>
                                            <tr>
                                                <td style="height: 16px">                                                                                                    
                                                    <asp:ImageButton ID="btnAdd" ImageUrl="~/MaintenanceApps/Common/images/newadd.gif"
                                                        runat="server" CausesValidation="False" OnClick="btnAdd_Click" TabIndex="12" />
                                                        <img id="CloseButton" src="Common/images/close.jpg" onclick="javascript:window.close();"
                                                        tabindex="13" /> </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align=center>
                                <div style="width: 90%;" align=left>
                                    <asp:UpdatePanel ID="upnlEntry" runat="server" UpdateMode="conditional">
                                        <ContentTemplate>
                                            <table style="padding-left: 10px" align="left" width="100%"  >
                                                <tr>
                                                    <td width=62% style="padding-right:60px;padding-top:10px;padding-bottom:10px;">
                                                        <table cellpadding="2" cellspacing="0" width="100%">
                                                          
                                                            <tr>
                                                                <td class="DarkBluTxt">
                                                                    Period
                                                                </td>
                                                                <td>
                                                                     <asp:HiddenField ID="hidPeriodID" runat="server" />
                                                                    <asp:TextBox ID="txtPeriod" CssClass="FormCtrl" runat="server" TabIndex ="1" onkeypress="javascript:ValdateNumber();" MaxLength="2"></asp:TextBox>
                                                                    <asp:RequiredFieldValidator ID="rfvPeriod" runat="server" ErrorMessage="Period Value is Required" Text ="* Required" ControlToValidate="txtPeriod" ></asp:RequiredFieldValidator>
                                                                    <asp:RangeValidator ID="rvPeriod" runat="server" ControlToValidate="txtPeriod" ErrorMessage="Integer Value is allowed"
                                                                        MaximumValue="12" MinimumValue="1" Type="Integer">* Invalid</asp:RangeValidator></td>
                                                                <td  rowspan = "2" class="DarkBluTxt">
                                                                    <table cellpadding="2" cellspacing="0" width="100%">
                                                                        <tr >
                                                                            <td >
                                                                                <uc3:TwoDatePicker ID="tdpMonth" runat="server" EndLabelText="Period End" StartLabelText="Period Begin" TabIndex="5" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="DarkBluTxt">
                                                                    Year
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtYear" CssClass="FormCtrl" runat="server" TabIndex ="2" onkeypress="javascript:ValdateNumber();" MaxLength="4"></asp:TextBox>
                                                                    <asp:RequiredFieldValidator ID="rfvYear" runat="server" ErrorMessage="Year Value is Required" Text ="* Required" ControlToValidate="txtYear"></asp:RequiredFieldValidator>
                                                                    <asp:RangeValidator ID="rvYear" runat="server" ControlToValidate="txtYear"
                                                                        ErrorMessage="Integer Value alone is  allowed" Type="Integer" MaximumValue="2100" MinimumValue="1900">* Invalid</asp:RangeValidator></td>
                                                            </tr>
                                                            <tr>
                                                                <td class="DarkBluTxt">
                                                                    Notes
                                                                </td>
                                                                <td colspan="2" >
                                                                    <asp:TextBox ID="txtNotes" CssClass ="FormCtrl" runat ="server" TextMode ="MultiLine" Width ="200px"  Height ="50px" TabIndex ="3"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                           
                                                            <tr>
                                                                <td class="DarkBluTxt" >
                                                                    Status
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtStatus" MaxLength=2 CssClass="FormCtrl" runat="server" TabIndex ="4"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                   
                                                    <td valign=top style="padding-left:30px;padding-top:10px;padding-bottom:10px;">
                                                        <table cellpadding="0" cellspacing="0" width="100%">
                                                            <tr>
                                                                <td>
                                                                    <asp:UpdatePanel ID="upnlchkSelectAll" runat="server" UpdateMode="conditional">
                                                                        <ContentTemplate>
                                                                            <table cellpadding="0" cellspacing="0" class="blueBorder" style="border-collapse: collapse">
                                                                                <tr>
                                                                                    <td style="height: 22px" class="lightBlueBg">
                                                                                        <asp:CheckBox ID="chkSelectAll" runat="server" Text="Select / Deselect All" Width="130px"
                                                                                            AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" ForeColor="#CC0000"
                                                                                            TabIndex="7" Font-Bold="True" />
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="blueBorder" style="padding-top: 1px;" valign=top>
                                                                                        <asp:CheckBoxList ID="chkSelection" runat="server" Height="20px" RepeatColumns="1"
                                                                                            RepeatDirection="Horizontal" Width="200px" AutoPostBack="True" TabIndex="8" Font-Bold="True">
                                                                                            <asp:ListItem Value ="PayRoll">Pay Roll Posted</asp:ListItem>
                                                                                            <asp:ListItem Value ="Reclassvariance">Reclass Variance Posted</asp:ListItem>
                                                                                            <asp:ListItem Value ="GLMonthEnd">GL Month End Closed</asp:ListItem>
                                                                                            <asp:ListItem Value ="GLYearEnd" >GL Year End Closed</asp:ListItem>
                                                                                            
                                                                                        </asp:CheckBoxList>
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
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="lightBlueBg" style="padding-top: 1px; height: 28px; padding-left: 200px;
                                text-align: left; border: none;">
                               
                            </td>
                            <td class="lightBlueBg" style="padding-top: 1px; height: 28px; text-align: right;border: none;"> <asp:UpdatePanel ID="upnlbtnsave" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:ImageButton ID="btnSave" ImageUrl="~/MaintenanceApps/Common/Images/btnsave.gif"
                                            runat="server" CausesValidation="true"  TabIndex="10" OnClick="btnSave_Click" />
                                            <asp:ImageButton ID="btnCancel" ImageUrl="~/MaintenanceApps/Common/images/cancel.png"
                                            runat="server" CausesValidation="False" TabIndex="11" OnClick="btnCancel_Click" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="upGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr class="lightBlueBg">
                                    <td class="lightBlueBg" style="padding-top: 1px; height: 7px; width: 4%;">
                                        <span class="BanText">Fiscal Periods &nbsp;</span></td>
                                    <td class="lightBlueBg" style="padding-top: 1px; height: 1px; width: 5%;">
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="padding-top: 1px; height: 7px;" colspan="2">
                                        <div id="div-datagrid" class="Sbar" style="overflow-x: auto; overflow-y: auto; position: relative;
                                            top: 0px; left: 0px; height: 280px; width: 1010px; border: 0px solid;" align="Left">
                                            <asp:DataGrid CssClass="grid"  Style="height: auto" ID="dgFiscalPeriod"
                                                GridLines="both" runat="server" AutoGenerateColumns="false" UseAccessibleHeader="true"
                                                AllowSorting="True" ShowFooter="False" OnItemCommand="dgFiscalPeriod_ItemCommand"
                                                Width="990px" OnSortCommand="dgFiscalPeriod_SortCommand" OnItemDataBound="dgFiscalPeriod_ItemDataBound"
                                                TabIndex="9">
                                                <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                <ItemStyle CssClass="GridItem" />
                                                <AlternatingItemStyle CssClass="zebra" />
                                                <FooterStyle CssClass="lightBlueBg" />
                                                <Columns>
                                                    <asp:TemplateColumn HeaderText="Actions">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                                Style="padding-left: 5px" runat="server" OnClientClick="javascript:document.getElementById('hidScrollTop').value =document.getElementById('div-datagrid').scrollTop;"
                                                                CommandName="Edit" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pFYPeriodID")%>'>Edit</asp:LinkButton>
                                                            <asp:LinkButton ID="lnlDelete" CausesValidation="false" Font-Underline="true" ForeColor="#cc0000"
                                                                Style="padding-left: 5px" runat="server" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                                CommandName="Delete" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pFYPeriodID")%>'>Delete</asp:LinkButton>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="80px" />
                                                    </asp:TemplateColumn>
                                                    <asp:BoundColumn DataField="Year" HeaderText="Year" SortExpression="Year">
                                                        <ItemStyle Width="40px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="Period" HeaderText="Period" SortExpression="Period">
                                                        <ItemStyle Width="40px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="PeriodStart" HeaderText="Period Begin " SortExpression="PeriodStart" DataFormatString="{0:MM/dd/yyyy}">
                                                        <ItemStyle Width="60px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="PeriodEnd" HeaderText="Period End" SortExpression="PeriodEnd" DataFormatString="{0:MM/dd/yyyy}">
                                                        <ItemStyle Width="60px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="StatusCd" HeaderText="Status" SortExpression="StatusCd">
                                                        <ItemStyle Width="50px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>                                                    
                                                    <asp:BoundColumn DataField="EntryID" HeaderText="Entry ID" SortExpression="EntryID">
                                                        <ItemStyle Width="60px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="EntryDt" HeaderText="Enter Date" DataFormatString="{0:MM/dd/yyyy}"
                                                        SortExpression="EntryDt">
                                                        <ItemStyle Width="60px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="ChangeID" HeaderText="Change ID" SortExpression="ChangeID">
                                                        <ItemStyle Width="60px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="ChangeDt" HeaderText="Change Date" DataFormatString="{0:MM/dd/yyyy}"
                                                        SortExpression="ChangeDt">
                                                        <ItemStyle Width="60px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn ></asp:BoundColumn>
                                                   
                                                </Columns>
                                            </asp:DataGrid>
                                            <input type="hidden" id="hidSort" runat="server" tabindex="12" />
                                            <asp:HiddenField ID ="hidScrollTop" runat ="server" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="BluBg buttonBar" height="20px" style="width: 930px">
                    <table>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="BottomFrame2" Title="Fiscal Period Table" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
