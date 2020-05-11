<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SKUAnalysis.aspx.cs" Inherits="SKUAnalysis" %>

<%@ Register Src="Common/UserControls/FileUploadControl.ascx" TagName="FileUploadControl"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <script>
    function OpenHelp(topic)
    {
            //alert(document.documentElement.clientHeight);

        window.open('SKUAnalysisHelp.aspx#' + topic + '','BSAHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
    }
    function ZItem(itemSect, sectLen, nextControl)
    {
        var sectVal = itemSect.value;
        if (sectVal.length >= 1)
        {
            var section = "00000" + sectVal;
            itemSect.value = section.substr(section.length-sectLen,sectLen);
        }
        document.getElementById(nextControl).focus();
        document.getElementById(nextControl).select();
        event.keyCode=0;
        return false;
    }
    function PrintBSA()
    {   
            var prtContent = "<html><head>";
            prtContent = prtContent + "<link href=../Common/StyleSheet/Styles.css rel=stylesheet type=text/css />" ;
            prtContent = prtContent + "<link href=BSAStyles.css rel=stylesheet type=text/css />" ;
            prtContent = prtContent + "</head><body>" ;
            prtContent = prtContent + document.getElementById("WorkTable").outerHTML ;
            prtContent = prtContent.replace(/100px/g, "150px");
            prtContent = prtContent + "</body></html>";        
            var WinPrint = window.open('','','left=0,top=0,width=1000,height=10,toolbar=0,scrollbars=0,status=0');        
            WinPrint.document.write(prtContent);
            WinPrint.document.close();
            WinPrint.focus();
            WinPrint.print();
            WinPrint.close();
            return false;
        
    }
    function CPRReport(ItemNo)
    {
        if (document.getElementById('CPRFactor').value == "" || document.getElementById('CPRFactor').value == null || document.getElementById('CPRFactor').value.search(/\d+/) == -1 || document.getElementById('CPRFactor').value.search(/[a-zA-Z]/) != -1)
        {
            alert("To run the CPR report you must enter a numeric factor");
            document.getElementById('CPRFactor').focus();
        }
        else
        {
            CPRWin = window.open("../CPR/CPRReport.aspx?Item=" + ItemNo + "&Factor=" + document.getElementById('CPRFactor').value,"CPRReport","height=768,width=1024,scrollbars=yes,location=no,status=no,top="+((screen.height/2) - (760/2))+",left=0,resizable=YES","");
        }
    }
    function SetHeight()
    { 
    var ele = document.getElementById("yh")
    ele.value = document.documentElement.clientHeight;  
    }
    </script>

    <title>BSA</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="BSAStyles.css" rel="stylesheet" type="text/css" />
</head>
<body id="MainBody" onload="SetHeight();">
    <form id="form1" runat="server" defaultbutton="ItemSearchButton">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div id="MainDiv">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td valign="middle" class="PageHead">
                        <span class="Left5pxPadd">
                            <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Branch Stocking Analysis"></asp:Label></span>
                    </td>
                    <td align="right" class="PageHead">
                        <img src="../Common/Images/close.gif" style="cursor: hand" onclick="javascript:window.close();"
                            title="Click Here to Close&#013;the BSA window">&nbsp;&nbsp;
                    </td>
                </tr>
            </table>
            <asp:Panel ID="MainPanel" runat="server" Width="100%">
                <asp:UpdatePanel ID="FindUpdatePanel" runat="server">
                    <ContentTemplate>
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<b>Cat:</b>&nbsp;</td>
                                            <td>
                                                <asp:TextBox ID="CatBegTextBox" runat="server" Width="45" MaxLength="5" onkeypress="javascript:if(event.keyCode==13){ZItem(this, 5, 'CatEndTextBox');}"></asp:TextBox>-
                                                <asp:TextBox ID="CatEndTextBox" runat="server" Width="45" MaxLength="5" onkeypress="javascript:if(event.keyCode==13){ZItem(this, 5, 'PkgBegTextBox');}"></asp:TextBox>
                                            </td>
                                            <td>
                                                <b>&nbsp;&nbsp;<a onclick="OpenHelp('Selecting');" style="cursor: hand" title="Click Here for Help on Selecting Items">?</a></b>
                                            </td>
                                            <td>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<b>Pkg:</b>&nbsp;</td>
                                            <td>
                                                <asp:TextBox ID="PkgBegTextBox" runat="server" Width="20" MaxLength="2" onkeypress="javascript:if(event.keyCode==13){ZItem(this, 2, 'PkgEndTextBox');}"></asp:TextBox>-
                                                <asp:TextBox ID="PkgEndTextBox" runat="server" Width="20" MaxLength="2" onkeypress="javascript:if(event.keyCode==13){ZItem(this, 2, 'PlateBegTextBox');}"></asp:TextBox>
                                            </td>
                                            <td>
                                                &nbsp;&nbsp;&nbsp;&nbsp;<b>Plt:</b>&nbsp;</td>
                                            <td>
                                                <asp:TextBox ID="PlateBegTextBox" runat="server" Width="10" MaxLength="1" onkeypress="javascript:if(event.keyCode==13){ZItem(this, 1, 'PlateEndTextBox');}"></asp:TextBox>-
                                                <asp:TextBox ID="PlateEndTextBox" runat="server" Width="10" MaxLength="1" onkeypress="javascript:if(event.keyCode==13){ZItem(this, 1, 'ItemSearchButton');}"></asp:TextBox>
                                            </td>
                                            <td>
                                                &nbsp;<asp:ImageButton ID="ItemSearchButton" runat="server" ImageUrl="../Common/images/search.gif"
                                                    OnClick="ItemSearchButt_Click" ToolTip="Use the Search button to filter&#013;Items by the Category, Package and&#013;Plating ranges you have entered" />
                                            </td>
                                            <td>
                                                &nbsp;<asp:ImageButton ID="BranchListButt" runat="server" ImageUrl="../Common/images/list.gif"
                                                    OnClick="BranchListButt_Click" ToolTip="Use the List button to show the&#013;Branches To Report and&#013;the Branch List" />
                                            </td>
                                            <td>
                                                &nbsp;<img src="../Common/images/help.gif" style="cursor: hand" alt="Click here for Help"
                                                    onclick="OpenHelp('PageTop');" />
                                            </td>
                                            <td>
                                                <asp:Panel ID="FactorPrompt" runat="server">
                                                    &nbsp; <b>Factor:
                                                        <asp:TextBox ID="CPRFactor" runat="server" Width="30px" ToolTip="Enter the FACTOR for the CPR Report"></asp:TextBox>
                                                    </b><b>&nbsp;&nbsp;<a onclick="OpenHelp('CPR');" style="cursor: hand" title="Click Here for Help on getting a CPR report">?</a></b>&nbsp;&nbsp;
                                                </asp:Panel>
                                            </td>
                                            <td>
                                                <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                                                    <ProgressTemplate>
                                                        &nbsp;&nbsp;Processing....
                                                        <asp:Image ID="ProgressImage" ImageUrl="../Common/Images/PFCYellowBall.gif" runat="server" />
                                                    </ProgressTemplate>
                                                </asp:UpdateProgress>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    &nbsp;&nbsp;
                                    <asp:ImageButton ID="btnAccept" runat="server" ImageUrl="../Common/Images/accept.jpg"
                                        OnClick="AcceptButt_Click" ToolTip="Use the Accept button to verify#013;the update(s) you want to#013;make to the SKU table" />
                                    <asp:ImageButton ID="ActionSubmitButt" runat="server" ImageUrl="../Common/Images/update.gif"
                                        OnClick="UpdateButt_Click" ToolTip="Use the Update button to &#013;Update the SKU table with&#013;the Actions listed below" />
                                    <asp:Image ID="PrintButt" ImageUrl="../Common/Images/print.gif" Style="cursor: hand"
                                        onclick="javascript:PrintBSA();" runat="server" />
                                    <asp:TextBox ID="yh" runat="server" Width="60" ForeColor="white" BorderStyle="None"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3" class="Left5pxPadd">
                                    <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>
                                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                    <Triggers>
                        <asp:PostBackTrigger ControlID="btnAccept" />
                        <asp:PostBackTrigger ControlID="ActionSubmitButt" />
                    </Triggers>
                </asp:UpdatePanel>
            </asp:Panel>
            <asp:UpdatePanel ID="ResultsUpdatePanel" UpdateMode="Conditional" runat="server">
                <ContentTemplate>
                    <table border="0" cellpadding="1" cellspacing="0" width="100%">
                        <tr>
                            <td valign="top" class="Left5pxPadd">
                                <asp:Panel ID="BranchPanel" runat="server" BorderColor="black" BorderWidth="1" ScrollBars="auto">
                                    <table border="0" cellpadding="1" cellspacing="5">
                                        <tr>
                                            <td valign="top">
                                                <center>
                                                    <b>&nbsp;&nbsp;<a onclick="OpenHelp('Branches');" style="cursor: hand" title="Click Here for Help on Selecting Branches">?</a></b>
                                                    &nbsp;&nbsp;<b>Branches To Report</b>&nbsp;&nbsp;
                                                    <asp:LinkButton ID="ClearAllLink" runat="server" OnClick="ClearBranches">Clear All</asp:LinkButton></center>
                                                <asp:GridView ID="BranchGrid" runat="server" AutoGenerateColumns="false" OnRowCommand="BranchCommand"
                                                    OnRowDataBound="BranchGrid_RowDataBound" AlternatingRowStyle-BorderStyle="None"
                                                    RowStyle-BorderStyle="None" CellPadding="0" RowStyle-Wrap="false" BorderStyle="Solid"
                                                    BorderWidth="1px" BorderColor="Black">
                                                    <Columns>
                                                        <asp:BoundField HeaderText="Loc" DataField="Code" SortExpression="Code" ItemStyle-Wrap="false"
                                                            ItemStyle-Width="40" ItemStyle-HorizontalAlign="center" ItemStyle-CssClass="rightBorder"
                                                            HeaderStyle-Wrap="false"></asp:BoundField>
                                                        <asp:BoundField HeaderText="Name" DataField="Name" SortExpression="Name" ItemStyle-Wrap="false"
                                                            ItemStyle-Width="100" ItemStyle-HorizontalAlign="left" ItemStyle-CssClass="rightBorder"
                                                            HeaderStyle-Wrap="false"></asp:BoundField>
                                                        <asp:BoundField HeaderText="Hub" DataField="IsHub" SortExpression="IsHub" ItemStyle-Wrap="false"
                                                            ItemStyle-Width="40" ItemStyle-HorizontalAlign="center" ItemStyle-CssClass="rightBorder"
                                                            HeaderStyle-Wrap="false"></asp:BoundField>
                                                        <asp:ButtonField ButtonType="link" Text="&nbsp;Hub&nbsp;" HeaderText="" ItemStyle-CssClass="rightBorder"
                                                            CommandName="Hub" />
                                                        <asp:ButtonField ButtonType="link" Text="&nbsp;&nbsp;Delete&nbsp;&nbsp;" HeaderText=""
                                                            ItemStyle-CssClass="rightBorder" CommandName="Del" />
                                                        <asp:ButtonField ButtonType="link" Text="&nbsp;&nbsp;Up&nbsp;&nbsp;" HeaderText=""
                                                            ItemStyle-CssClass="rightBorder" CommandName="MoveUp" />
                                                        <asp:ButtonField ButtonType="link" Text="&nbsp;&nbsp;Down&nbsp;&nbsp;" HeaderText=""
                                                            ItemStyle-CssClass="rightBorder" CommandName="MoveDown" />
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                            <td valign="top">
                                                <center>
                                                    <b>Branch List</b>&nbsp;&nbsp;
                                                    <asp:LinkButton ID="LoadAllLink" runat="server" OnClick="AddAllBranches">Load All</asp:LinkButton></center>
                                                <asp:GridView ID="LoaderGrid" runat="server" AutoGenerateColumns="false" OnRowCommand="BranchCommand"
                                                    OnRowDataBound="BranchGrid_RowDataBound" AlternatingRowStyle-BorderStyle="None"
                                                    Height="100%" RowStyle-BorderStyle="None" CellPadding="0" RowStyle-Wrap="false"
                                                    BorderStyle="Solid" BorderWidth="1px" BorderColor="Black">
                                                    <Columns>
                                                        <asp:BoundField HeaderText="Loc" DataField="Code" SortExpression="Code" ItemStyle-Wrap="false"
                                                            ItemStyle-Width="40" ItemStyle-HorizontalAlign="center" ItemStyle-CssClass="rightBorder"
                                                            HeaderStyle-Wrap="false"></asp:BoundField>
                                                        <asp:BoundField HeaderText="Name" DataField="Name" SortExpression="Name" ItemStyle-Wrap="false"
                                                            ItemStyle-Width="100" ItemStyle-HorizontalAlign="left" ItemStyle-CssClass="rightBorder"
                                                            HeaderStyle-Wrap="false"></asp:BoundField>
                                                        <asp:BoundField HeaderText="Hub" DataField="IsHub" SortExpression="IsHub" ItemStyle-Wrap="false"
                                                            ItemStyle-Width="40" ItemStyle-HorizontalAlign="center" ItemStyle-CssClass="rightBorder"
                                                            HeaderStyle-Wrap="false"></asp:BoundField>
                                                        <asp:ButtonField ButtonType="link" HeaderText="" ItemStyle-CssClass="rightBorder"
                                                            CommandName="AddToList" Text="Add" ItemStyle-Width="40" ItemStyle-HorizontalAlign="center" />
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </td>
                            <td class="Left5pxPadd" valign="top">
                                <asp:Panel ID="ProcessPanel" runat="server" BorderColor="black" BorderWidth="1">
                                    &nbsp;&nbsp;&nbsp;&nbsp;<b>Process Log</b>&nbsp;&nbsp;
                                    <asp:LinkButton ID="AllProcessLink" runat="server" OnClick="ShowFullLog">Show All Changes Made this Session</asp:LinkButton>
                                    <asp:TextBox ID="ProcessLogTextBox" runat="server" Height="490" Width="700" TextMode="MultiLine"
                                        Wrap="false"></asp:TextBox>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" colspan="2">
                                <asp:Panel ID="SKUPanel" runat="server" BorderColor="black" BorderWidth="1" ScrollBars="auto">
                                    <asp:Table ID="WorkTable" runat="server" CellSpacing="0" CellPadding="0" Height="100%"
                                        BackColor="#f4fbfd">
                                    </asp:Table>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td class="Left5pxPadd" valign="top" colspan="2">
                                <asp:Panel ID="ActionPanel" runat="server" Width="100%" BorderColor="black" BorderWidth="1"
                                    ScrollBars="auto">
                                    <asp:Table ID="ActionTable" runat="server" CellSpacing="0" CellPadding="0" CssClass="GridItem"
                                        BackColor="#f4fbfd">
                                    </asp:Table>
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </form>
</body>
</html>
