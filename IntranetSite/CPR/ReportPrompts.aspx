<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReportPrompts.aspx.cs" Inherits="CPRReportPrompts" %>

<%@ Register Src="Common/UserControls/FileUploadControl.ascx" TagName="FileUploadControl"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <script>
    function ClosePage()
    {
        if(parent.bodyframe!=null)
        {
            var PrevPage = "FrontEnd.aspx";
            if (document.getElementById("ReportType").value != "")
            {
                PrevPage = PrevPage + "?Type=" + document.getElementById("ReportType").value;
            }
            parent.bodyframe.location.href=PrevPage;	
        }
    }
    function OpenHelp(topic)
    {
        window.open('CPRHelp.aspx#' + topic + '','CPRHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
    }
    </script>

    <title>CPR Report Prompts</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server" defaultbutton="RunReportButt">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div>
            <table border="0" cellpadding="0" width="100%">
                <tr>
                    <td valign="middle" class="PageHead">
                        <span class="Left5pxPadd">
                            <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="CPR Web Report Options"></asp:Label></span>
                        <asp:HiddenField ID="ReportType" runat="server" />
                        <asp:HiddenField ID="CurItemsName" runat="server" />
                    </td>
                    <td align="right" class="PageHead">
                        <img src="../Common/Images/close.gif" style="cursor: hand" onclick="ClosePage();"
                            title="Click Here to Return to&#013;the CPR Select Items page">&nbsp;&nbsp;
                    </td>
                </tr>
            </table>
            <asp:Panel ID="MainPanel" runat="server" Height="180px" Width="100%">
                <asp:UpdatePanel ID="MainUpdatePanel" runat="server">
                    <ContentTemplate>
                        <table border="0" cellpadding="0" cellspacing="1">
                            <tr>
                                <td class="Left5pxPadd" valign="top">
                                    <table border="0">
                                        <tr>
                                            <td class="Left5pxPadd">
                                                <table class="LightBluBg" width="250">
                                                    <tr>
                                                        <td class="Left5pxPadd">
                                                            <b>CPR Factor:&nbsp;</b></td>
                                                        <td align="right">
                                                            <asp:TextBox ID="CPRFactor" runat="server" Width="40"></asp:TextBox></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="Left5pxPadd">
                                                <table class="LightBluBg" width="250">
                                                    <tr>
                                                        <td class="Left5pxPadd" style="width:40px" >
                                                            <b>Report Format:</b>
                                                        </td>
                                                        <td align="right" style="width:205px">
                                                            <b>
                                                                <asp:RadioButton ID="LongReport" GroupName="GridLength" Text="Long" runat="server"
                                                                    Checked="true" />
                                                                <asp:RadioButton ID="ShortReport" GroupName="GridLength" Text="Short" runat="server" />
                                                                <asp:RadioButton ID="TransferReport" GroupName="GridLength" Text="Transfer" runat="server" />
                                                                </b>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="Left5pxPadd">
                                                <table class="LightBluBg" width="250">
                                                    <tr>
                                                        <td class="Left5pxPadd">
                                                            <b>Report Sort:</b>
                                                        </td>
                                                        <td align="left">
                                                            <b>
                                                                <asp:RadioButton ID="SortPlating" GroupName="ItemSort" Text="Plating" runat="server" Checked="true" /><br />
                                                                <asp:RadioButton ID="SortItem" GroupName="ItemSort" Text="Item" runat="server"/><br />
                                                                <asp:RadioButton ID="SortVariance" GroupName="ItemSort" Text="Variance" runat="server" /><br />
                                                                <asp:RadioButton ID="SortNetBuyBucks" GroupName="ItemSort" Text="Net Buy Dollars" runat="server" /><br />
                                                                <asp:RadioButton ID="SortNewBuyLBS" GroupName="ItemSort" Text="Net Buy Weight" runat="server" /><br />
                                                                <asp:RadioButton ID="SortCFVC" GroupName="ItemSort" Text="CFVC, Item" runat="server" /></b>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="Left5pxPadd">
                                                <table class="LightBluBg" width="250">
                                                    <tr>
                                                        <td class="Left5pxPadd">
                                                            <b>Include Summary Quantities - HTI:</b>
                                                        </td>
                                                        <td align="left">
                                                            <b>
                                                                <asp:CheckBox ID="IncludeSummQtys" runat="server" />
                                                            </b>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="Left5pxPadd">
                                                <table width="250" class="redtitle2">
                                                    <tr>
                                                        <td class="Left5pxPadd">
                                                            <b><asp:Label ID="RecCountLabel" runat="server" Text="0"></asp:Label>
                                                                record(s) selected.</b>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td valign="top">
                                    <table cellspacing="1" class="BluBg">
                                        <tr>
                                            <td align="center">
                                                <b>Optional Filters</b> &nbsp;&nbsp;<b><a onclick="OpenHelp('Definitions');" style="cursor: hand"
                                                    title="Click Here for&#013;Filter Definitions">?</a></b>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center">
                                                <table class="LightBluBg" width="450">
                                                    <tr>
                                                        <td align="center">
                                                            <b>Exception Filters</b></td>
                                                        <td align="right">
                                                            &nbsp;&nbsp;<asp:ImageButton ID="ExceptionButton" runat="server" ImageUrl="../Common/images/ok.gif"
                                                                OnClick="ExceptionButt_Click" ToolTip="Use this button to&#013;show only records that&#013;match the selected exception" /></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" align="left">
                                                            <b>
                                                                <asp:RadioButton ID="Exception1" GroupName="Exceptions" Text="Branch Required < Company Excess"
                                                                    runat="server" /><br />
                                                                <asp:RadioButton ID="Exception3" GroupName="Exceptions" Text="Hub Required > Company Excess; 100% Hub Required < Company Excess"
                                                                    runat="server" /><br />
                                                                <asp:RadioButton ID="Exception2" GroupName="Exceptions" Text="Branch Required > Company Excess; Hub Required < Company Excess"
                                                                    runat="server" /><br />
                                                                <asp:RadioButton ID="Exception4" GroupName="Exceptions" Text="Hub Required > Company Excess; 100% Hub Required < Carson & NJ Excess"
                                                                    runat="server" /></b>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center">
                                                <table class="LightBluBg" width="450">
                                                    <tr>
                                                        <td align="left">
                                                            <b>
                                                                <asp:RadioButton ID="DeleteEmpties" GroupName="Empties" Text="Remove" runat="server" />
                                                                or
                                                                <asp:RadioButton ID="KeepEmpties" GroupName="Empties" Text="Keep Only" runat="server" />
                                                                Items Out at all branches:</b></td>
                                                        <td align="right">
                                                            &nbsp;&nbsp;<asp:ImageButton ID="RemoveEmptyButton" runat="server" ImageUrl="../Common/images/ok.gif"
                                                                OnClick="RemoveEmptyButt_Click" ToolTip="Use this button to remove or&#013;keep only 'Empty Pantry' items&#013;that have no availability at any branch" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center">
                                                <table class="LightBluBg" width="450">
                                                    <tr>
                                                        <td align="left">
                                                            <b>
                                                                <asp:RadioButton ID="RemoveNoAction" runat="server" Text="Remove Items where all Branches are Shaded:" />
                                                            </b>
                                                        </td>
                                                        <td align="right">
                                                            &nbsp;&nbsp;<asp:ImageButton ID="RemoveNoActionButton" runat="server" ImageUrl="../Common/images/ok.gif"
                                                                OnClick="RemoveNoActionButt_Click" ToolTip="Use this button to remove&#013;items that have no requirements&#013;(all shaded) at any branch" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center">
                                                <table class="LightBluBg" width="450">
                                                    <tr>
                                                        <td align="left" style="width:90px">
                                                            <b>
                                                                Net Buy Range
                                                            </b>
                                                        </td>
                                                        <td align="right" style="width:85px">
                                                            <asp:TextBox ID="BuyLowerTextBox" runat="server" Width="80"
                                                            onkeydown="if (event.keyCode==13){document.getElementById('BuyUpperTextBox').focus(); return false;}" ></asp:TextBox>
                                                        </td>
                                                        <td align="center" style="width:20px">
                                                            <b>to</b>
                                                        </td>
                                                        <td align="left">
                                                            <asp:TextBox ID="BuyUpperTextBox" runat="server" Width="80"
                                                            onkeydown="if (event.keyCode==13){document.getElementById('FilterBuyRangeButton').click(); return false;}" ></asp:TextBox>
                                                        </td>
                                                        <td align="right" rowspan="2">
                                                            &nbsp;&nbsp;<asp:ImageButton ID="FilterBuyRangeButton" runat="server" ImageUrl="../Common/images/ok.gif"
                                                                OnClick="FilterBuyRangeButt_Click" ToolTip="Use this button to remove&#013;items that do not fall&#013;within the range" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4">
                                                            <b>Filter On:&nbsp;Total Net Buy&nbsp;
                                                            <asp:RadioButton GroupName="NetBuyChoice" ID="NetBuyTotRadioButton" Checked="true" runat="server" />
                                                            &nbsp;&nbsp;&nbsp;Positive Net Buy&nbsp;
                                                            <asp:RadioButton GroupName="NetBuyChoice" ID="NetBuyPosRadioButton" runat="server" /></b>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center">
                                                <table class="LightBluBg" width="450">
                                                    <tr>
                                                        <td align="left">
                                                            <b>
                                                                <asp:RadioButton ID="IgnoreChild" runat="server" Text="Ignore Child Data in Calculation:" />
                                                            </b>
                                                        </td>
                                                        <td align="right">
                                                            &nbsp;&nbsp;<%--<asp:ImageButton ID="IgnoreChildButton" runat="server" ImageUrl="../Common/images/ok.gif"
                                                                OnClick="IgnoreChildButt_Click" ToolTip="Use this button to ignore &#013;Child totals when filtering" />--%>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center">
                                                <table class="LightBluBg" width="450">
                                                    <tr>
                                                        <td align="left">
                                                            <b>
                                                                <asp:RadioButton ID="RemoveNoStock" runat="server" Text="Remove Non stock Items (SVC:N,S):" style="display:none;" />
                                                                <asp:Label ID="RemoveNoStockLabel" runat="server" Text="Remove Non stock Items (SVC:N,S):" />

                                                            </b>
                                                        </td>
                                                        <td align="right">
                                                            &nbsp;&nbsp;<asp:ImageButton ID="RemoveNoStockButt" runat="server" ImageUrl="../Common/images/ok.gif"
                                                                OnClick="RemoveNoStockButt_Click" ToolTip="Use this button to remove&#013;items that are non stock&#013; at any branch" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="Left5pxPadd" colspan="3">
                                    <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>&nbsp;
                                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                                </td>
                            </tr>
                        </table>
                        <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                            <ProgressTemplate>
                                <div class="Left5pxPadd">
                                    Processing Request. One Moment.......</div>
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <table border="0" cellpadding="0" width="100%" cellspacing="0">
                    <tr class="BluBg">
                        <td>
                            &nbsp;
                        </td>
                        <td valign="top">
                            <img src="../Common/images/help.gif" alt="Click here for Help&#013;on Report Options"
                                onclick="OpenHelp('Filtering');" style="cursor: hand" />
                        </td>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td align="right">
                                        <b>Show Item List</b>&nbsp;&nbsp;
                                    </td>
                                    <td>
                                        <asp:ImageButton ID="ItemButt" runat="server" ImageUrl="../Common/images/ok.gif"
                                            OnClick="ItemButt_Click" ToolTip="Click here to see the list of Items.&#013;You can copy this list and paste into Excel" />
                                        <asp:LinkButton ID="ItemListLinkButt" runat="server"></asp:LinkButton>
                                    </td>
                                    <td valign="middle">
                                        &nbsp;&nbsp;<b><a onclick="OpenHelp('Showing');" style="cursor: hand" title="Click Here for Help&#013;on Showing Items">?</a></b>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td align="right" valign="middle">
                            <asp:ImageButton ID="ManualXFerButt" runat="server" AlternateText="Manual Transfers" ImageUrl="../Common/images/ManualXFer.gif"
                                OnClick="ManualXFerButt_Click" ToolTip="Display the CPR Manual Transfers page" />
                            <asp:ImageButton ID="RunReportButt" ImageUrl="../Common/images/viewReport.gif" AlternateText="View Report"
                                runat="server" OnClick="RunReportButt_Click" ToolTip="View the CPR .Net Report" />
                            <asp:Label ID="RunByLabel" runat="server" Text=""></asp:Label>
                            <asp:LinkButton ID="ReportLinkButt" runat="server"></asp:LinkButton>
                            <asp:LinkButton ID="ManualXFerLinkButt" runat="server"></asp:LinkButton>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
