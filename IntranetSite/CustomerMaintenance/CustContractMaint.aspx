<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustContractMaint.aspx.cs" Inherits="CustContractMaint" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Customer Contract Maintenance</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

<script language="javascript">
    function ValidateNumber()
    {
        //if(event.keyCode<47 || event.keyCode>58)
        if(event.keyCode != 46 && (event.keyCode<48 || event.keyCode>57))
            event.keyCode=0;
    }

    function Close()
    {
        window.close();
    }

    function Unload()
    {
       CustContractMaint.ReleaseLock().value;
    }
</script>

</head>
<body onunload="javascript:Unload();">
    <form id="frmCustContMaint" runat="server">
        <asp:ScriptManager runat="server" ID="smCustContMaint">
        </asp:ScriptManager>

        <table cellpadding="0" cellspacing="0" width="100%" id="tblMain">
            <tr>
                <td height="5%" id="tdHeader" >
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="lightBlueBg">
                    <asp:Label ID="lblInfo" CssClass="BanText" runat="server" Text="Customer Contract Maintenance"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="padding-top: 1px;" >
                    <asp:UpdatePanel ID="pnlSearchCust"  runat="server" UpdateMode="conditional">
                        <ContentTemplate>  
                        <asp:Panel ID="pnlSearch" runat="server" Width="100%" DefaultButton="btnSearch">
                            <table width="100%" class="shadeBgDown">
                                <tr>
                                    <td class="Left2pxPadd boldText" width="12%">
                                        <asp:Label ID="lblSch" runat="server" Text="Customer Number"></asp:Label>
                                    </td>
                                    <td valign="middle">
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:TextBox AutoCompleteType="disabled" MaxLength="10" ID="txtCustomer" runat="server" CssClass="FormCtrl" Width="150px"
                                                        OnFocus="javascript:this.select();"  OnTextChanged="txtCustomer_TextChanged"></asp:TextBox><br />
                                                </td>
                                                <td></td>
                                                <td>
                                                    <asp:ImageButton ID="btnSearch" runat="server" ImageUrl="Common/images/search.jpg" OnClick="btnSearch_Click" />
                                                </td>
                                            </tr>
                                        </table>
                                        <asp:HiddenField ID="hidCustId" runat="server" />
                                    </td>
                                    <td align="right" valign="middle">
                                        <table>
                                            <tr>
                                                <td style="padding-top: 2px;">
                                                    <%--<asp:ImageButton ID="btnHelp" runat="server" ImageUrl="Common/images/help.gif" />--%>
                                                    <img id="btnClose" src="Common/images/close.jpg" style="cursor:hand" onclick="javascript:Close();" />
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
                <td>
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                        <tr>
                            <td valign="top" class="blueBorder shadeBgDown">
                                <asp:UpdatePanel ID="pnlCustDetails" runat="server"  UpdateMode="conditional">
                                    <ContentTemplate>
                                    <table cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td id="tdCustInfo" runat="server" style="padding-top: 5px;">
                                                <table width="100%">
                                                    <tr>
                                                        <td>
                                                            <table cellpadding="2" cellspacing="0" id="tblCustInfo" runat="server">
                                                                <tr>
                                                                    <td class="Left2pxPadd boldText" nowrap="nowrap" align="left">
                                                                        <asp:Label ID="lblCustNo" runat="server">CustNo</asp:Label></td>
                                                                    <td valign="top">
                                                                        <asp:Label ID="lblCustName" runat="server">Customer Name</asp:Label></td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>&nbsp;</td>
                                                                    <td nowrap="nowrap">
                                                                        <asp:Label ID="lblCustLine1" runat="server">Addr Line1</asp:Label></td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>&nbsp;</td>
                                                                    <td nowrap="nowrap">
                                                                        <asp:Label ID="lblCustLine2" runat="server">Addr Line2</asp:Label></td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>&nbsp;</td>
                                                                    <td nowrap="nowrap">
                                                                        <asp:Label ID="lblCustCity" runat="server">City, State, Zip</asp:Label></td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>&nbsp;</td>
                                                                    <td nowrap="nowrap">
                                                                        <span class="boldText">Phone:&nbsp;</span><asp:Label ID="lblCustPhone" runat="server">Phone</asp:Label></td>
                                                                    <td nowrap="nowrap">
                                                                        <span class="boldText">Fax:&nbsp;</span><asp:Label ID="lblCustFax" runat="server">Fax</asp:Label></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td valign="bottom" align="right">
                                                            <asp:ImageButton ID="btnSave" runat="server" ImageUrl="Common/images/btnSave.gif" OnClick="btnSave_Click" />&nbsp;&nbsp;
                                                            <asp:ImageButton ID="btnCancel" runat="server" ImageUrl="Common/images/cancel.png" OnClick="btnCancel_Click" />
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
                    </table>
                </td>
            </tr>
            <tr>
                <td style="padding-top: 5px;">
                    <div class="Sbar" oncontextmenu="Javascript:return false;" id="divdatagrid1" style="overflow-x: auto;
                                            overflow-y: auto; position: relative; top: 0px; left: 0px; height: 250px; width: 790px;
                                            border: 0px solid; vertical-align: top;">  
                    <asp:UpdatePanel ID="pnlCustData" runat="server"  UpdateMode="conditional">
                        <ContentTemplate>
                        <table cellpadding="3" cellspacing="0">
                            <tr>
                                <td style="padding-left: 15px;">
                                    Contract Schedule 1
                                </td>
                                <td class="Left2pxPadd Right2pxPadd" style="width:130px;" >
                                    <asp:Label ID="lblSched1" runat="server"></asp:Label></td>
                                <td style="height: 26px;padding-left: 15px;">
                                    Target Gross Mgn Pct
                                </td>
                                <td class="Left2pxPadd Right2pxPadd" style="height: 26px">
                                    <asp:TextBox MaxLength="10" CssClass="FormCtrl" ID="txtTargetGross" runat="server" AutoPostBack="true" TabIndex="8" onkeypress="javascript:ValidateNumber();" OnTextChanged="txtTargetGross_TextChanged"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 15px;">
                                    Contract Schedule 2
                                </td>
                                <td class="Left2pxPadd Right2pxPadd">
                                    <asp:Label ID="lblSched2" runat="server"></asp:Label>
                                </td>
                                <td style="height: 26px;padding-left: 15px;">
                                    Target Cost Plus Pct
                                </td>
                                <td class="Left2pxPadd Right2pxPadd" style="height: 26px">
                                    <asp:TextBox ID="txtTargetCostPlus" runat="server" AutoPostBack="true" CssClass="FormCtrl"
                                        MaxLength="10" onkeypress="javascript:ValidateNumber();" OnTextChanged="txtTargetGross_TextChanged"
                                        TabIndex="8"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td style="padding-left: 15px;">
                                    Contract Schedule 3
                                </td>
                                <td class="Left2pxPadd Right2pxPadd">
                                    <asp:Label ID="lblSched3" runat="server"></asp:Label></td>
                                <td style="height: 26px;padding-left: 15px;">Web Discount Pct
                                </td>
                                <td class="Left2pxPadd Right2pxPadd" style="height: 26px" valign="top">
                                    <asp:TextBox MaxLength="10" CssClass="FormCtrl" ID="txtWebDiscPct" runat="server" AutoPostBack="true" TabIndex="9" onkeypress="javascript:ValidateNumber();" OnTextChanged="txtWebDiscPct_TextChanged"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td style="padding-left: 15px;">
                                    Contract Schedule 4
                                </td>
                                <td class="Left2pxPadd Right2pxPadd">
                                    <asp:Label ID="lblSched4" runat="server"></asp:Label>
                                </td>
                                <td style="padding-left: 15px;">
                                    </td>
                                <td class="Left2pxPadd Right2pxPadd">
                                    <asp:CheckBox ID="chkWebDiscInd" runat="server" TabIndex="10" Text="Enable Web Discount" /></td>
                            </tr>
                            <tr>
                                <td style="padding-left: 15px;">
                                    Contract Schedule 5
                                </td>
                                <td class="Left2pxPadd Right2pxPadd">
                                    <asp:Label ID="lblSched5" runat="server"></asp:Label>
                                </td>
                                <td style="height: 26px;padding-left: 15px;">
                                    Customer Default Price</td>
                                <td class="Left2pxPadd Right2pxPadd" style="height: 26px">
                                    <%--<asp:CheckBox ID="chkCustDefInd" runat="server" TabIndex="12" Text="Enable Default Pricing" />--%>
                                    <asp:DropDownList Width="128px" ID="ddlCustDefPrice" CssClass="FormCtrl" runat="server" Height="20px" TabIndex="11"></asp:DropDownList></td>
                            </tr>
                            <tr>
                                <td style="padding-left: 15px;">
                                    Contract Schedule 6
                                </td>
                                <td class="Left2pxPadd Right2pxPadd">
                                    <asp:Label ID="lblSched6" runat="server"></asp:Label>
                                </td>
                                <td style="padding-left: 15px;">
                                    Customer Price Ind</td>
                                <td class="Left2pxPadd Right2pxPadd">
                                    <asp:DropDownList Width="128px" ID="ddlCustPriceInd" CssClass="FormCtrl" runat="server" Height="20px" TabIndex="12"></asp:DropDownList></td>
                            </tr>
                            <tr>
                                <td style="padding-left: 15px;">
                                    Contract Schedule 7
                                </td>
                                <td class="Left2pxPadd Right2pxPadd">
                                    <asp:Label ID="lblSched7" runat="server"></asp:Label>
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
                    <asp:UpdateProgress ID="upPanel" runat="server" DisplayAfter=1>
                        <ProgressTemplate>
                            <span style="padding-left: 5px" class="boldText">Loading...</span>                         
                        </ProgressTemplate>
                    </asp:UpdateProgress><asp:UpdatePanel ID="pnlMessage"  runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="green" Font-Bold="true"
                                runat="server" Text=""></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel></td>
            </tr>
            <tr>
                <td>
                    <uc2:BottomFooter ID="BottomFrame2" Title="Customer Contract Maintenance" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
