<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PrintUtilityHistory.aspx.cs"
    Inherits="PrintUtilityHistory" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Pager.ascx" TagName="Pager" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>PFC - Post Request History</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script language="javascript" type="text/javascript">
    
    function PreviewDoc(pageURL)
    {
        window.open(pageURL);
    }
    </script>

    <style>
    .FormControls 
    {
	    font-family: Tahoma, arial;
	    font-size: 11px;
	    font-weight: normal;
	    color: #000000;
	    width: 125px;
	    margin-left: 1px;
    }    
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="scmPrintUtilityHistory" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table border="0" class="HeaderPanels" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <asp:Label ID="Label1" runat="server"></asp:Label></td>
            </tr>
            <tr>
                <td height="70">
                    <asp:UpdatePanel ID="pnlButtons" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="padding-left: 10px; height: 30px">
                                        <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Created By:" Width="73px"></asp:Label></td>
                                    <td style="width: 100px; height: 20px">
                                        <asp:Label ID="lblCreatedBy" runat="server" Width="96px"></asp:Label></td>
                                    <td style="height: 20px">
                                        <asp:Label ID="Label6" runat="server" Font-Bold="True" Text="Document Type:" Width="90px"></asp:Label></td>
                                    <td style="height: 20px">
                                        <asp:DropDownList ID="ddlRecordType" runat="server" CssClass="FormControls" Width="80px">
                                            <asp:ListItem>All</asp:ListItem>
                                            <asp:ListItem>Email</asp:ListItem>
                                            <asp:ListItem>Fax</asp:ListItem>
                                            <asp:ListItem>Print</asp:ListItem>
                                        </asp:DropDownList></td>
                                    <td style="padding-left: 10px; height: 20px">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 10px; height: 30px">
                                        <strong>Start Date:</strong></td>
                                    <td style="width: 100px; height: 20px">
                                        <uc1:novapopupdatepicker ID="dpStartDt" runat="server" />
                                    </td>
                                    <td style="height: 20px">
                                        <strong>End Date:</strong></td>
                                    <td style="height: 20px">
                                        <uc1:novapopupdatepicker ID="dpEndDate" runat="server" />
                                    </td>
                                    <td style="padding-left: 10px; height: 20px">
                                        <asp:ImageButton ID="ibtnSearch" runat="server" ImageUrl="~/Common/Images/searchBig.gif"
                                            OnClick="ibtnSearch_Click" /></td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="pnlRequestGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <div class="Sbar" oncontextmenu="Javascript:return false;" id="div-datagrid" style="overflow-x: visible;
                                            overflow-y: auto; position: relative; top: 0px; left: 0px; border: 1px solid #88D2E9;
                                            width: 845px; height: 395px; background-color: White; scrollbar-3dlight-color: white;
                                            scrollbar-arrow-color: #1D7E94; scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC;
                                            scrollbar-face-color: #9EDEEC; scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94">
                                            <asp:GridView UseAccessibleHeader="true" ID="gvRequest" PagerSettings-Visible="false"
                                                Width="1100" runat="server" AllowPaging="true" ShowHeader="true" AllowSorting="true"
                                                AutoGenerateColumns="false" ShowFooter="False" OnSorting="gvRequest_Sorting" OnRowDataBound="gvRequest_RowDataBound">
                                                <HeaderStyle HorizontalAlign="Center" CssClass="GridHead" Font-Bold="True" BackColor="#DFF3F9"
                                                    Height="20px" />
                                                <FooterStyle Font-Bold="True" VerticalAlign="Top" HorizontalAlign="Right" />
                                                <RowStyle CssClass="item" Wrap="False" BackColor="White" Height="20px" BorderWidth="1px" />
                                                <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="20px" BorderWidth="1px" />
                                                <Columns>
                                                    <asp:BoundField HeaderText="Doc Type" DataField="RecordType" SortExpression="RecordType">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Status" DataField="RecordStatus" SortExpression="RecordStatus">
                                                        <ItemStyle HorizontalAlign="Left" Width="70px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Created Dt" DataField="CreatedDate" SortExpression="CreatedDate">
                                                        <ItemStyle HorizontalAlign="Left" Width="170px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:TemplateField HeaderText="Attachment" SortExpression="CustNo">
                                                        <ItemTemplate>
                                                            <asp:HyperLink ID="hlnkViewDoc" runat="server" NavigateUrl='<%#DataBinder.Eval(Container.DataItem,"PageURL") %>' Target=_blank Text="View Doc" ForeColor="blue"></asp:HyperLink>
                                                            <asp:HiddenField ID="hidProcessCd" Value='<%#DataBinder.Eval(Container.DataItem,"ProcessCd") %>' runat=server />
                                                            <asp:HiddenField ID="hidMutiDocPrint" Value='<%#DataBinder.Eval(Container.DataItem,"MultiDocPrinting") %>' runat=server />
                                                        </ItemTemplate>
                                                        <ItemStyle Width="60px" HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField HeaderText="Subject" DataField="Subject" SortExpression="Subject">
                                                        <ItemStyle HorizontalAlign="Left" Width="330px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Sent To" DataField="SentTo" SortExpression="SentTo">
                                                        <ItemStyle HorizontalAlign="Left" Width="150px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Printer Name" DataField="PrinterName" SortExpression="PrinterName">
                                                        <ItemStyle HorizontalAlign="Left" Width="200px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Body" DataField="Body" SortExpression="Body">
                                                        <ItemStyle HorizontalAlign="Left" Width="250px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Doc Name" DataField="FormName" SortExpression="FormName">
                                                        <ItemStyle HorizontalAlign="Left" Width="120px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                </Columns>
                                                <PagerSettings Visible="False" />
                                            </asp:GridView>
                                            <input id="hidSort" type="hidden" name="Hidden1" runat="server">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <uc2:Pager ID="RequestQueuePager" runat="server" OnBubbleClick="Pager_PageChanged" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td height="10" class="commandLine splitborder_t_v splitborder_b_v">
                    <table width="100%" border="0">
                        <tr>
                            <td width="40%">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="true">
                                                        <ProgressTemplate>
                                                            <span class="TabHead">Loading...</span></ProgressTemplate>
                                                    </asp:UpdateProgress>
                                        </td>
                                        <td>
                                <asp:UpdatePanel ID="pnlMessage" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <table width="100%" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="padding-left: 5px;" align="left" width="89%">
                                                    &nbsp;<asp:Label ID="lblMessage" CssClass="Tabhead" runat="server" Text="" Font-Bold=true ForeColor="red"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                                &nbsp;
                            </td>
                            <td align="right" style="padding-right: 10px" width="10%">
                                <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <uc3:Footer ID="Footer1" runat="server" Title="Post Request History" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
