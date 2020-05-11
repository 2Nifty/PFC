<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FastItemMaint.aspx.cs" Inherits="FastItemMaint" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Fast Item Maintnenace</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script src="../Common/Javascript/Utility.js" type="text/javascript"></script>
    
    <script language="javascript" type="text/javascript">
    //Text input validation
        function ValidateNum() //This allows only 0 thru 9
        {
            if (event.keyCode<48 || event.keyCode>57)
                event.keyCode=0;
        }

        function ValidateNum1() //This allows only 0 thru 9 plus comma (as list delimiter)
        {
            if (event.keyCode != 44 && (event.keyCode<48 || event.keyCode>57))
                event.keyCode=0;
        }

        function ValidateNum2() //This allows only 0 thru 9 plus question mark & asterik (as wildcard)
        {
            if (event.keyCode != 42 && event.keyCode != 63 && (event.keyCode<48 || event.keyCode>57))
                event.keyCode=0;
        }

        function ValidateDateNum() //This allows only 0 thru 9 plus dash [-] or slash [/] (as date delimiter)
        {
            if (event.keyCode != 45 && event.keyCode != 47 && (event.keyCode<48 || event.keyCode>57))
                event.keyCode=0;
        }

        function ValidateAlpha() //This allows only A thru Z (upper & lowercase) plus comma (as list delimiter)
        {
            if (event.keyCode != 44 && (event.keyCode<65 || event.keyCode>122 || (event.keyCode<97 && event.keyCode>90)))
                event.keyCode=0;
        }
    </script>

    <script language="javascript" type="text/javascript">
        function LoadHelp()
        {
            window.open("FastItemMaintHelp.mht",'Help','height=710,width=1020,scrollbars=yes,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
        }
        
        function Close()
        {
            parent.bodyframe.location.href = "../InvMaintDashboard/InvMaintDashBoard.aspx";	
        }
    </script>

</head>
<body>
    <form id="frmMain" runat="server">
    <asp:ScriptManager ID="smFastIM" EnablePartialRendering="true" runat="server"></asp:ScriptManager>

        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="100%" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td valign="middle">
                                <%--Banner & Title Header--%>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td valign="top" colspan="3">
                                            <uc1:PageHeader ID="PageHeader1" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="PageHead" style="height: 40px;">
                                            <table width="840px">
                                                <tr>
                                                    <td>
                                                        <div class="LeftPadding BannerText" align="left">
                                                            Fast Item Maintenance  v1.0</div>
                                                    </td>
                                                    <td align="right" valign="middle">
                                                        <asp:ImageButton runat="server" ID="btnExport" ImageUrl="../Common/Images/ExportToExcel.gif" OnClick="btnExport_Click" Visible="false" />
                                                        <asp:ImageButton runat="server" ID="btnSubmit" ImageUrl="../Common/Images/Submit.gif" OnClick="btnSubmit_Click" Visible="false" />&nbsp;&nbsp;
                                                        <img src="../Common/images/close.gif" onclick="javascript:Close();" style="cursor: hand" />&nbsp;&nbsp;
                                                        <img src="../Common/images/help.gif" onclick="javascript:LoadHelp();" style="cursor: hand" />&nbsp;&nbsp;
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="middle">

                                <%--User Prompts--%>
                                <table width="840px" border="0" cellspacing="0" cellpadding="3" class="LeftPadding" style="height:100%; padding-top:5px; padding-bottom:5px;">
                                    <tr valign="top">
                                        <td>
                                            <table>
                                                <tr>
                                                    <td style="width:300px;" class="TabHead">
                                                        <asp:RadioButtonList ID="rdoMode" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdoMode_SelectedIndexChanged">
                                                            <asp:ListItem>Download File&nbsp;&nbsp;</asp:ListItem>
                                                            <asp:ListItem>Upload Changes</asp:ListItem>
                                                        </asp:RadioButtonList>
                                                    </td>
                                                    <td style="padding-top:7px;" class="TabHead">
                                                        <asp:Label ID="lblFastFields" runat="server" Text="Select Field" Visible="false" />
                                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                                        <asp:DropDownList ID="ddlFastFields" CssClass="FormCtrl2" Width="280px" Height="20px" runat="server" Visible="false" />
                                                    </td>
                                                </tr>
                                            </table>
                                            <div class="Sbar" id="divPrompt" style=" overflow: auto; position: relative; top: 0px; left: 0px; height: 305px; border: 0px solid;">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <%--Download Params--%>
                                                            <asp:UpdatePanel runat="server" ID="pnlDownload" UpdateMode="Conditional" Visible="false">
                                                                <ContentTemplate>
                                                                    <table>
                                                                        <tr>
                                                                            <td>
                                                                                <%--Start & End Category--%>
                                                                                <asp:UpdatePanel runat="server" ID="pnlCat" UpdateMode="Conditional">
                                                                                    <ContentTemplate>
                                                                                        <table>
                                                                                            <col style="width:100px;" />
                                                                                            <col style="width:135px;" />
                                                                                            <col style="width:65px;" />
                                                                                            <col style="width:200px;" />
                                                                                            <tr>
                                                                                                <td class="TabHead">
                                                                                                    Start Category
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:TextBox ID="txtStrCat" runat="server" MaxLength="5" CssClass="FormCtrl2" Text="txtStrCat"
                                                                                                        OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum();" />
                                                                                                </td>
                                                                                                <td align="center" valign="middle" rowspan="2" class="TabHead">
                                                                                                    or
                                                                                                </td>
                                                                                                <td class="TabHead">
                                                                                                    <asp:CheckBox ID="chkCatList" runat="server" AutoPostBack="true" OnCheckedChanged="chkCatList_CheckedChanged" />&nbsp;Category List
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="TabHead">
                                                                                                    End Category
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:TextBox ID="txtEndCat" runat="server" MaxLength="5" CssClass="FormCtrl2" Text="txtEndCat"
                                                                                                        OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum();" />
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:TextBox ID="txtCatList" runat="server" MaxLength="3000" CssClass="FormCtrl2" Enabled="false" Width="350px" Text="txtCatList"
                                                                                                        ToolTip="Comma delimited list of Categories" OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum1();" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </ContentTemplate>
                                                                                </asp:UpdatePanel>
                                                                            </td>
                                                                        </tr>
                                                                        
                                                                        <tr>
                                                                            <td>
                                                                                <%--Start & End Size--%>
                                                                                <asp:UpdatePanel runat="server" ID="pnlSize" UpdateMode="Conditional">
                                                                                    <ContentTemplate>
                                                                                        <table>
                                                                                            <col style="width:100px;" />
                                                                                            <col style="width:135px;" />
                                                                                            <col style="width:65px;" />
                                                                                            <col style="width:200px;" />
                                                                                            <tr>
                                                                                                <td class="TabHead">
                                                                                                    Start Size
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:TextBox ID="txtStrSize" runat="server" MaxLength="4" CssClass="FormCtrl2" Text="txtStrSize"
                                                                                                        OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum();" />
                                                                                                </td>
                                                                                                <td align="center" valign="middle" rowspan="2" class="TabHead">
                                                                                                    or
                                                                                                </td>
                                                                                                <td class="TabHead">
                                                                                                    <asp:CheckBox ID="chkSizeList" runat="server" AutoPostBack="true" OnCheckedChanged="chkSizeList_CheckedChanged" />&nbsp;Size List
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="TabHead">
                                                                                                    End Size
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:TextBox ID="txtEndSize" runat="server" MaxLength="4" CssClass="FormCtrl2" Text="txtEndSize"
                                                                                                        OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum();" />
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:TextBox ID="txtSizeList" runat="server" MaxLength="3000" CssClass="FormCtrl2" Enabled="false" Width="350px" Text="txtSizeList"
                                                                                                        ToolTip="Comma delimited list of Sizes" OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum1();" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </ContentTemplate>
                                                                                </asp:UpdatePanel>
                                                                            </td>
                                                                        </tr>

                                                                        <tr>
                                                                            <td>
                                                                                <%--Start & End Variance--%>
                                                                                <asp:UpdatePanel runat="server" ID="pnlVar" UpdateMode="Conditional">
                                                                                    <ContentTemplate>
                                                                                        <table>
                                                                                            <col style="width:100px;" />
                                                                                            <col style="width:135px;" />
                                                                                            <col style="width:65px;" />
                                                                                            <col style="width:200px;" />
                                                                                            <tr>
                                                                                                <td class="TabHead">
                                                                                                    Start Variance
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:TextBox ID="txtStrVar" runat="server" MaxLength="3" CssClass="FormCtrl2" Text="txtStrvar"
                                                                                                        OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum2();" />
                                                                                                </td>
                                                                                                <td align="center" valign="middle" rowspan="2" class="TabHead">
                                                                                                    or
                                                                                                </td>
                                                                                                <td class="TabHead">
                                                                                                    <asp:CheckBox ID="chkVarList" runat="server" AutoPostBack="true" OnCheckedChanged="chkVarList_CheckedChanged" />&nbsp;Variance List
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="TabHead">
                                                                                                    End Variance
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:TextBox ID="txtEndVar" runat="server" MaxLength="3" CssClass="FormCtrl2" Text="txtEndVar"
                                                                                                        OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum();" />
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:TextBox ID="txtVarList" runat="server" MaxLength="3000" CssClass="FormCtrl2" Enabled="false" Width="350px" Text="txtVarList"
                                                                                                        ToolTip="Comma delimited list of Variances" OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum1();" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </ContentTemplate>
                                                                                </asp:UpdatePanel>
                                                                            </td>
                                                                        </tr>

                                                                        <tr>
                                                                            <td>
                                                                                <%--Start & End Harmonizing Code--%>
                                                                                <asp:UpdatePanel runat="server" ID="pnlHarmCd" UpdateMode="Conditional">
                                                                                    <ContentTemplate>
                                                                                        <table>
                                                                                            <col style="width:100px;" />
                                                                                            <col style="width:135px;" />
                                                                                            <col style="width:65px;" />
                                                                                            <col style="width:200px;" />
                                                                                            <tr>
                                                                                                <td class="TabHead">
                                                                                                    Start Harm Cd
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:DropDownList ID="ddlStrHarmCd" CssClass="FormCtrl2" Width="125px" Height="20px" runat="server" />
                                                                                                </td>
                                                                                                <td align="center" valign="middle" rowspan="2" class="TabHead">
                                                                                                    or
                                                                                                </td>
                                                                                                <td class="TabHead">
                                                                                                    <asp:CheckBox ID="chkHarmCdList" runat="server" AutoPostBack="true" OnCheckedChanged="chkHarmCdList_CheckedChanged" />&nbsp;HarmCd List
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="TabHead">
                                                                                                    End Harm Cd
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:DropDownList ID="ddlEndHarmCd" CssClass="FormCtrl2" Width="125px" Height="20px" runat="server" />
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:TextBox ID="txtHarmCdList" runat="server" MaxLength="3000" CssClass="FormCtrl2" Enabled="false" Width="350px" Text="txtHarmCdList"
                                                                                                        ToolTip="Comma delimited list of Harmonizing Codes" OnFocus="javascript:this.select();" onkeypress="javascript:ValidateAlpha();" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </ContentTemplate>
                                                                                </asp:UpdatePanel>
                                                                            </td>
                                                                        </tr>

                                                                        <tr>
                                                                            <td>
                                                                                <%--Start & End Sales Velocity Code--%>
                                                                                <asp:UpdatePanel runat="server" ID="pnlPPI" UpdateMode="Conditional">
                                                                                    <ContentTemplate>
                                                                                        <table>
                                                                                            <col style="width:100px;" />
                                                                                            <col style="width:135px;" />
                                                                                            <col style="width:65px;" />
                                                                                            <col style="width:200px;" />
                                                                                            <tr>
                                                                                                <td class="TabHead">
                                                                                                    Start PPI
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:DropDownList ID="ddlStrPPI" CssClass="FormCtrl2" Width="125px" Height="20px" runat="server" />
                                                                                                </td>
                                                                                                <td align="center" valign="middle" rowspan="2" class="TabHead">
                                                                                                    or
                                                                                                </td>
                                                                                                <td class="TabHead">
                                                                                                    <asp:CheckBox ID="chkPPIList" runat="server" AutoPostBack="true" OnCheckedChanged="chkPPIList_CheckedChanged" />&nbsp;PPI List
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="TabHead">
                                                                                                    End PPI
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:DropDownList ID="ddlEndPPI" CssClass="FormCtrl2" Width="125px" Height="20px" runat="server" />
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:TextBox ID="txtPPIList" runat="server" MaxLength="3000" CssClass="FormCtrl2" Enabled="false" Width="350px" Text="txtPPIList"
                                                                                                        ToolTip="Comma delimited list of PPI Codes" OnFocus="javascript:this.select();" onkeypress="javascript:ValidateAlpha();" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </ContentTemplate>
                                                                                </asp:UpdatePanel>
                                                                            </td>
                                                                        </tr>
                                                                        
                                                                        <tr>
                                                                            <td>
                                                                                <%--Start & End Setup Date--%>
                                                                                <asp:UpdatePanel runat="server" ID="pnlDate" UpdateMode="Conditional">
                                                                                    <ContentTemplate>
                                                                                        <table>
                                                                                            <col style="width:100px;" />
                                                                                            <col style="width:135px;" />
                                                                                            <col style="width:65px;" />
                                                                                            <col style="width:200px;" />
                                                                                            <tr>
                                                                                                <td valign="top" class="TabHead">
                                                                                                    Start Setup Date
                                                                                                </td>
                                                                                                <td valign="top">
                                                                                                    <asp:UpdatePanel ID="pnlStartDt" runat="server" UpdateMode="conditional">
                                                                                                        <ContentTemplate>
                                                                                                            <asp:TextBox ID="txtStrDt" runat="server" AutoPostBack="true" MaxLength="10" CssClass="FormCtrl2" OnTextChanged="txtStrDt_TextChanged" onkeypress="javascript:ValidateDateNum();" Text="txtStrDt" />
                                                                                                        </ContentTemplate>
                                                                                                    </asp:UpdatePanel>
                                                                                                </td>
                                                                                                <td valign="top">
                                                                                                    <asp:ImageButton runat="server" ID="ibtnStartDt" ImageUrl="../Common/Images/datepicker.gif" OnClick="ibtnStartDt_Click" Enabled="true" />
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:UpdatePanel ID="pnlStartPick" runat="server" UpdateMode="conditional">
                                                                                                        <ContentTemplate>
                                                                                                            <asp:Calendar ID="cldStartDt" runat="server" Visible="false" OnSelectionChanged="cldStartDt_SelectionChanged" Width="150px" />
                                                                                                        </ContentTemplate>
                                                                                                    </asp:UpdatePanel>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td valign="top" class="TabHead">
                                                                                                    End Setup Date
                                                                                                </td>
                                                                                                <td valign="top" class="TabHead">
                                                                                                    <asp:UpdatePanel ID="pnlEndDt" runat="server" UpdateMode="conditional">
                                                                                                        <ContentTemplate>
                                                                                                            <asp:TextBox ID="txtEndDt" runat="server" AutoPostBack="true" MaxLength="10" CssClass="FormCtrl2" OnTextChanged="txtEndDt_TextChanged" onkeypress="javascript:ValidateDateNum();" Text="txtEndDt" />
                                                                                                        </ContentTemplate>
                                                                                                    </asp:UpdatePanel>
                                                                                                </td>
                                                                                                <td valign="top">
                                                                                                    <asp:ImageButton runat="server" ID="ibtnEndDt" ImageUrl="../Common/Images/datepicker.gif" OnClick="ibtnEndDt_Click" Enabled="true" />
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:UpdatePanel ID="pnlEndPick" runat="server" UpdateMode="conditional">
                                                                                                        <ContentTemplate>
                                                                                                            <asp:Calendar ID="cldEndDt" runat="server" Visible="false" OnSelectionChanged="cldEndDt_SelectionChanged" Width="150px" />
                                                                                                        </ContentTemplate>
                                                                                                    </asp:UpdatePanel>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    &nbsp;
                                                                                                </td>
                                                                                                <td valign="top" colspan="3" class="TabHead">
                                                                                                    <asp:UpdatePanel ID="pnlDateParam" runat="server" UpdateMode="conditional">
                                                                                                        <ContentTemplate>
                                                                                                            <asp:RadioButtonList id="rdoDateCtl" runat="server">
                                                                                                               <asp:ListItem Selected="True" Text="On or after Start Date" Value="AFTER" />
                                                                                                               <asp:ListItem Text="On or before End Date" Value="BEFORE" />
                                                                                                               <asp:ListItem Text="Between Start & End Date" Value="BETWEEN" />
                                                                                                            </asp:RadioButtonList>
                                                                                                        </ContentTemplate>
                                                                                                    </asp:UpdatePanel>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </ContentTemplate>
                                                                                </asp:UpdatePanel>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </td>
                                                    </tr>
                                                </table>
                                                
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <%--Upload Params--%>
                                                            <asp:UpdatePanel runat="server" ID="pnlUpload" UpdateMode="Conditional" Visible="false">
                                                                <ContentTemplate>
                                                                    <table>
                                                                        <tr>
                                                                            <td valign="middle" align="left" style="width:350px;">
                                                                                <asp:FileUpload ID="uplXLS" CssClass="FormCtrl" runat="server" Width="345px" />
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td valign="middle" align="left" style="width:350px;">
                                                                                <asp:Label ID="lblXLSFile" runat="server" ForeColor="#b0c4de" Text="~your file~"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td valign="middle" align="left" style="width:350px;">
                                                                                <asp:Label ID="lblNewFile" runat="server" ForeColor="#b0c4de" Text="~saved as~"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td valign="middle" align="left" style="width:350px;">
                                                                                <asp:Label ID="lblTempTable" runat="server" ForeColor="#b0c4de" Text="~temp table~"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td valign="middle" align="left" style="width:350px;">
                                                                                <asp:Label ID="lblFastField" runat="server" ForeColor="#b0c4de" Text="~field name~"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlInfo" runat="server" UpdateMode="conditional" Visible="true">
                                    <ContentTemplate>
                                        <asp:Label ID="lblInfo" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Width="500px" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlBottom" runat="server" UpdateMode="conditional" Visible="false">
                                    <ContentTemplate>
                                        <table width="100%" class="lightBlueBg buttonBar" style="border-top:solid 1px #CDECF6; height:20px;">
                                            <tr>
                                                <td>
                                                    <asp:UpdatePanel ID="pnlStatus" runat="server" UpdateMode="conditional">
                                                        <ContentTemplate>
                                                            <asp:Label ID="lblStatus" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                                                runat="server" Width="500px" Text=""></asp:Label>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </td>
                                                <td>
                                                    <asp:UpdateProgress ID="pnlProgress" runat="server" DisplayAfter="1" DynamicLayout="false">
                                                        <ProgressTemplate>
                                                            <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                                        </ProgressTemplate>
                                                    </asp:UpdateProgress>
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
    </form>
</body>
</html>
