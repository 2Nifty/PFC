<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CatBuyGroupMaint.aspx.cs" Inherits="CatBuyGroupMaint" %>

<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage2.ascx" TagName="BottomFooter" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Category Buy Groups Maintenance</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

<script language="javascript">
    function ValidateInteger()
    {
        if(event.keyCode != 45 && (event.keyCode<48 || event.keyCode>57))
            event.keyCode=0;
    }

    function ValidateDecimal()
    {
        if(event.keyCode != 45 && event.keyCode != 46 && (event.keyCode<48 || event.keyCode>57))
            event.keyCode=0;
    }

    function Close()
    {
        window.close();
    }

    function Unload()
    {
       CatBuyGroupMaint.ReleaseLock().value;
    }
</script>

</head>
<body onunload="javascript:Unload();">
    <form id="frmCatBuyGroupMaint" runat="server">
        <asp:ScriptManager runat="server" ID="smCatBuyGroupMaint">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="tblMain">
            <tr>
                <td height="5%" id="tdHeader" >
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="lightBlueBg">
                    <asp:Label ID="lblInfo" CssClass="BanText" runat="server" Text="Category Buy Groups Maintenance"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="padding-top: 1px;" >
                    <asp:UpdatePanel ID="pnlSearchCat"  runat="server" UpdateMode="conditional">
                        <ContentTemplate>  
                        <asp:Panel ID="pnlSearch" runat="server" Width="100%" DefaultButton="btnSearch">
                            <table width="100%" class="shadeBgDown">
                                <tr>
                                    <td style="padding-left: 15px;" class="boldText" width="105px">
                                        <asp:Label ID="lblSch" runat="server" Text="Category Number"></asp:Label>
                                    </td>
                                    <td valign="middle">
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:TextBox AutoCompleteType="disabled" MaxLength="5" ID="txtCatNo" runat="server" CssClass="FormCtrl2" Width="75px" TabIndex="1" AutoPostBack="true"
                                                        OnFocus="javascript:this.select();" onkeypress="javascript:ValidateInteger();" OnTextChanged="txtCatNo_TextChanged"></asp:TextBox><br />
                                                </td>
                                                <td></td>
                                                <td>
                                                    <asp:Label ID="lblCatDesc" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                        <asp:HiddenField ID="hidCatId" runat="server" />
                                    </td>
                                    <td align="right" valign="middle">
                                        <table>
                                            <tr>
                                                <td style="padding-top: 2px;">
                                                    <asp:ImageButton ID="btnSearch" runat="server" ImageUrl="../Common/images/search.gif" OnClick="btnSearch_Click" TabIndex="2" />&nbsp;&nbsp;&nbsp;
                                                    <img id="btnClose" src="../Common/images/close.gif" style="cursor:hand" onclick="javascript:Close();" />&nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="padding-top: 10px;">
                    <div class="Sbar" oncontextmenu="Javascript:return false;" id="divdatagrid1" style="overflow-x: auto;
                                            overflow-y: auto; position: relative; top: 0px; left: 0px; height: 547px;
                                            border: 0px solid; vertical-align: top;">  
                    <asp:UpdatePanel ID="pnlCatData" runat="server"  UpdateMode="conditional">
                        <ContentTemplate>
                        <table cellpadding="3" cellspacing="0">
                            <tr>
                                <td style="padding-left: 15px;">
                                    Category Desc
                                </td>
                                <td class="Left2pxPadd Right2pxPadd">
                                    <asp:TextBox AutoCompleteType="disabled" MaxLength="80" ID="txtCatDesc" runat="server" CssClass="FormCtrl2" Width="250px" TabIndex="3"
                                        OnFocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox><br />
                                </td>
                                <td width="619px" align="right">
                                    <asp:ImageButton ID="btnSave" runat="server" Visible="false" TabIndex="11" ImageUrl="../Common/images/BtnSave.gif" OnClick="btnSave_Click" />
                                    &nbsp;&nbsp;
                                    <asp:ImageButton ID="btnDel" runat="server" Visible="false" TabIndex="11" ImageUrl="../Common/images/BtnDelete.gif" OnClick="btnDel_Click" />
                                    <asp:ImageButton ID="btnAdd" runat="server" Visible="false" TabIndex="11" ImageUrl="../Common/images/newadd.gif" OnClick="btnAdd_Click" />
                                    &nbsp;&nbsp;
                                    <asp:ImageButton ID="btnCancel" runat="server" Visible="false" ImageUrl="../Common/images/cancel.gif" OnClick="btnCancel_Click" />
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 15px;">
                                    Buy Group No
                                </td>
                                <td class="Left2pxPadd Right2pxPadd">
                                    <asp:TextBox AutoCompleteType="disabled" MaxLength="4" ID="txtBuyGroup" runat="server" CssClass="FormCtrl2" Width="75px" TabIndex="4"
                                        OnFocus="javascript:this.select();" onkeypress="javascript:ValidateInteger();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox><br />
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 15px;">
                                    Reporting Group No
                                </td>
                                <td class="Left2pxPadd Right2pxPadd">
                                    <asp:TextBox AutoCompleteType="disabled" MaxLength="4" ID="txtRptGroupNo" runat="server" AutoPostBack="true" CssClass="FormCtrl2" Width="75px" TabIndex="5" 
                                        OnFocus="javascript:this.select();" onkeypress="javascript:ValidateInteger();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"
                                        OnTextChanged="txtRptGroupNo_TextChanged"></asp:TextBox><br />
                                </td>
                                <td style="padding-left: 5px;">
                                    Category Standard Comments&nbsp;&nbsp;<i>(4000 char max)</i>
                                </td>
                            </tr>
                                <td style="padding-left: 15px;">
                                    Reporting Group Desc
                                </td>
                                <td class="Left2pxPadd Right2pxPadd">
                                    <asp:TextBox AutoCompleteType="disabled" MaxLength="30" ID="txtRptGroupDesc" runat="server" CssClass="FormCtrl2" Width="200px" TabIndex="6"
                                        OnFocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox><br />
                                </td>
                                <td rowspan="5" style="vertical-align:top;">
                                    <asp:TextBox ID="txtCmntText" runat="server" Wrap="true" MaxLength="4000" TextMode="MultiLine" Width="550px" Height="115px" onfocus="javascript:this.select();" />
                                </td>
                            <tr>
                                <td style="padding-left: 15px;">
                                    Reporting Sort
                                </td>
                                <td class="Left2pxPadd Right2pxPadd">
                                    <asp:TextBox AutoCompleteType="disabled" MaxLength="4" ID="txtRptSort" runat="server" CssClass="FormCtrl2" Width="75px" TabIndex="7"
                                        OnFocus="javascript:this.select();" onkeypress="javascript:ValidateInteger();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox><br />
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 15px;">
                                    Months Buy Factor
                                </td>
                                <td class="Left2pxPadd Right2pxPadd">
                                    <asp:TextBox AutoCompleteType="disabled" MaxLength="4" ID="txtBuyFct" runat="server" CssClass="FormCtrl2" Width="75px" TabIndex="8"
                                        OnFocus="javascript:this.select();" onkeypress="javascript:ValidateInteger();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox><br />
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 15px;">
                                    Expense Per Lb
                                </td>
                                <td class="Left2pxPadd Right2pxPadd">
                                    <asp:TextBox AutoCompleteType="disabled" MaxLength="10" ID="txtLbExp" runat="server" AutoPostBack="true" CssClass="FormCtrl2" Width="75px" TabIndex="9"
                                        OnFocus="javascript:this.select();" onkeypress="javascript:ValidateDecimal();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"
                                        OnTextChanged="txtLbExp_TextChanged"></asp:TextBox><br />
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 15px;">
                                    Usage Forecast %
                                </td>
                                <td class="Left2pxPadd Right2pxPadd">
                                    <asp:TextBox AutoCompleteType="disabled" MaxLength="8" ID="txtForecastPct" runat="server" AutoPostBack="true" CssClass="FormCtrl2" Width="75px" TabIndex="10"
                                        OnFocus="javascript:this.select();" onkeypress="javascript:ValidateDecimal();" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"
                                        OnTextChanged="txtForecastPct_TextChanged"></asp:TextBox><br />
                                </td>
                            </tr>
                        </table>
                        <asp:HiddenField ID="hidSecurity" runat="server" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    </div>
                </td>
            </tr>
            <tr>
                <td  class="BluBg buttonBar" colspan="1" height="20px">
                    <asp:UpdateProgress ID="pnlProgress" runat="server" DisplayAfter="1">
                        <ProgressTemplate>
                            <span style="padding-left: 5px" class="boldText">Loading...</span>                         
                        </ProgressTemplate>
                    </asp:UpdateProgress>
                    <asp:UpdatePanel ID="pnlStatus"  runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="green" Font-Bold="true"
                                runat="server" Text=""></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:BottomFooter ID="BottomFrame2" FooterTitle="Category Buy Groups Maintenance" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
