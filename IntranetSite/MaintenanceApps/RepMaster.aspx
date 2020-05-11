<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RepMaster.aspx.cs" Inherits="RepMaster" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="BottomFooter"
    TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/RepTree.ascx" TagName="RepTree"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/LocTree.ascx" TagName="LocTree"
    TagPrefix="uc4" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Rep Master</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        .txtCenter
        {
	        text-align: center;
        }

        .txtRight
        {
	        text-align: right;
        }
    </style>

    <script type="text/javascript">
        function Unload()
        {
           RepMaster.ReleaseLock().value;
        }

        function LoadHelp()
        {
            window.open('RepMasterHelp.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
        }

        function GetRep(repNode, repNo)
        {
            document.getElementById("hidRepNode").value = repNode;
            document.getElementById("txtSearch").value = repNo;
            document.getElementById("btnHidSearch").click();  
        }
    </script>

</head>
<body scroll="yes" onunload="javascript:Unload();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="smRepMaster" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="pnlTop" UpdateMode="conditional" runat="server">
            <ContentTemplate>
                <table cellpadding="0" cellspacing="0" border="0" width="100%" id="mainTable">
                    <tr>
                        <td height="5%" id="tdHeader" colspan="2">
                            <uc1:Header ID="ucHeader" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-top: 1px;" width="100%" colspan="2">
                            <table class="shadeBgDown" width="100%">
                                <tr>
                                    <td class="Left2pxPadd DarkBluTxt boldText" width="84%">
                                    </td>
                                    <td align="right" style="padding-right: 5px; height: 28px;" valign="top">
                                        <asp:ImageButton runat="server" ID="ibtnAdd" ImageUrl="common/images/newadd.gif" ImageAlign="right"
                                            OnClick="ibtnAdd_Click" CausesValidation="false" />
                                    </td>
                                    <td align="right" style="padding-right: 5px; height: 28px;" valign="top">
                                        <img id="btnClose" style="cursor: hand" src="common/images/Close.gif" runat="server" onclick="javascript:window.close();" />
                                    </td>
                                    <td align="right" style="padding-right: 10px; height: 28px;" valign="top">
                                        <img id="btnHelp" src="common/images/help.gif" runat="server" align="right" onclick="LoadHelp();" style="cursor: hand" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr width="28%">
                        <td class="PageHead" colspan="2" style="height: 10px; padding-left: 8px;">
                            <table>
                                <tr align="center">
                                    <td>
                                        <asp:Label ID="lblViewBy" runat="server" CssClass="DarkBluTxt" Text="View By" Width="60px"></asp:Label></td>
                                    <td style="width: 100px">
                                        <asp:DropDownList ID="ddlViewOption" runat="server" CssClass="FormCtrl" Width="100px"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddlViewOption_SelectedIndexChanged">
                                            <asp:ListItem>Rep</asp:ListItem>
                                            <asp:ListItem>Location</asp:ListItem>
                                        </asp:DropDownList></td>
                                    <td>
                                        &nbsp;<asp:ImageButton ImageUrl="common/images/refresh.gif" ID="ibtnRefresh" ImageAlign="middle"
                                            runat="server" CausesValidation="false" OnClick="ibtnRefresh_Click"  />&nbsp;
                                    </td>
                                    <td>
                                        <asp:Button ID="btnHidSearch" Width="20" Style="display: none;" runat="server" OnClick="btnHidSearch_Click" />&nbsp;
                                        <asp:HiddenField ID="hidSearch" runat="server" />
                                        <asp:HiddenField ID="hidSearchBy" runat="server" />
                                        <asp:HiddenField ID="hidSearchTxt" runat="server" />
                                        <asp:HiddenField ID="hidRepNode" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>

                    <tr width="28%">
                        <td valign="top">
                            <asp:Panel ID="pnlSearch" runat="server" Height="30px" DefaultButton="ibtnFindRep">
                                <table cellpadding="0" cellspacing="0" border="0" class="Search BlueBorder" width="100%">
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt boldText">
                                            <asp:DropDownList ID="ddlSearch" runat="server" Width="120px" CssClass="FormCtrl">
                                                <asp:ListItem Text="Rep Name" Selected="True" Value="RepName"></asp:ListItem>
                                                <asp:ListItem Text="Rep No." Value="RepNo"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtSearch" runat="server" OnFocus="javascript:this.select();" Width="120px" MaxLength="40" CssClass="FormCtrl"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:ImageButton runat="server" ID="ibtnFindRep" ImageUrl="common/images/lens.gif" ImageAlign="Left"
                                                CausesValidation="false" Width="20px" OnClick="ibtnFindRep_Click" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </td>
                        <td rowspan="3" valign="top">
                            <table id="tblContent" runat="server" cellpadding="0" cellspacing="0" border="0" width="100%">
                                <tr class="Search BlueBorder" height="26">
                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                        <strong class="redtitle2">Sales Rep Information</strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:UpdatePanel ID="upnlData" UpdateMode="conditional" runat="server">
                                                        <ContentTemplate>
                                                            <div id="divData" runat="server">
                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                    <tr class="DarkBluTxt boldText">
                                                                        <td valign="top" align="left" style="padding-left: 10px; width: 321px; height: 47px;">
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td style="width: 99px">
                                                                                        <asp:Label ID="lblLocation" runat="server" Text="Location"></asp:Label></td>
                                                                                    <td style="width: 100px">
                                                                                        <asp:DropDownList ID="ddlLocation" runat="server" Width="120px" TabIndex="1" />
                                                                                    </td>
                                                                                    <td style="width: 60px" align="left">
                                                                                        <asp:Label ID="lblRepNo" runat="server" Text="Rep No." Width="50px"></asp:Label></td>
                                                                                    <td style="width: 110px">
                                                                                        <asp:TextBox ID="txtRepNo" OnFocus="javascript:this.select();" runat="server" Width="100px" TabIndex="2"></asp:TextBox>
                                                                                    </td>
                                                                                    <td style="width: 100px">
                                                                                    </td>
<%--                                                                                    <td style="width: 99px" align="right">
                                                                                        <asp:Label ID="lblEmployeeNo" runat="server" Text="Employee No." Width="120px"></asp:Label></td>--%>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td style="width: 99px" align="left">
                                                                                        <asp:Label ID="lblName" runat="server" Text="Name"></asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <asp:TextBox ID="txtName" OnFocus="javascript:this.select();" runat="server" Width="283px" TabIndex="3"></asp:TextBox></td>
                                                                                    <td style="width: 100px" align="left">
                                                                                        <asp:Label ID="lblStatus" runat="server" Text="Status:" Width="60px"></asp:Label></td>
                                                                                    <td style="width: 100px">
                                                                                        <asp:DropDownList ID="ddlStatus" runat="server" Width="120px" TabIndex="4" />
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td style="width: 99px">
                                                                                        <asp:Label ID="lblPhone" runat="server" Text="Phone No." Width="60px"></asp:Label></td>
                                                                                    <td style="width: 100px">
                                                                                        <asp:TextBox ID="txtPhone" OnFocus="javascript:this.select();" runat="server" Width="114px" TabIndex="5"></asp:TextBox></td>
                                                                                    <td style="width: 60px" align="left">
                                                                                        <asp:Label ID="lblFax" runat="server" Text="Fax No." Width="50px"></asp:Label></td>
                                                                                    <td style="width: 110px">
                                                                                        <asp:TextBox ID="txtFax" OnFocus="javascript:this.select();" runat="server" Width="100px" TabIndex="6"></asp:TextBox></td>
                                                                                    <td style="width: 100px" align="left">
                                                                                        <asp:Label ID="lblContact" runat="server" Text="Contact:" Width="60px"></asp:Label></td>
                                                                                    <td style="width: 100px">
                                                                                        <asp:TextBox ID="txtContact" OnFocus="javascript:this.select();" runat="server" Width="110px" TabIndex="7"></asp:TextBox></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td style="width: 99px">
                                                                                        <asp:Label ID="lblEmail" runat="server" Text="Email"></asp:Label></td>
                                                                                    <td colspan="3" style="height: 27px">
                                                                                        <asp:TextBox ID="txtEmail" OnFocus="javascript:this.select();" runat="server" Width="275px" TabIndex="8"></asp:TextBox></td>
                                                                                    <td colspan="2" style="height: 27px">
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="DarkBluTxt boldText">
                                                                        <td valign="top" align="left" style="padding-left: 10px; padding-top: 25px; width: 321px; height: 39px;">
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td style="width: 99px;" align="left">
                                                                                        <asp:Label ID="lblTerritory" runat="server" Text="Territory" Width="60px"></asp:Label></td>
                                                                                    <td style="width: 100px;">
                                                                                        <asp:DropDownList ID="ddlTerritory" runat="server" Width="120px" TabIndex="9" />
                                                                                    </td>
                                                                                    <td style="width: 100px;" align="left">
                                                                                        <asp:Label ID="lblSalesOrganization" runat="server" Text="Sales Organization" Width="110px"></asp:Label></td>
                                                                                    <td style="width: 100px; height: 16px">
                                                                                        <asp:DropDownList ID="ddlSalesOrganization" runat="server" Width="120px" TabIndex="10" />
                                                                                    </td>
                                                                                    <td style="width: 100px; height: 16px" align="left">
                                                                                        <asp:Label ID="lblManager" runat="server" Text="Manager" Width="55px"></asp:Label></td>
                                                                                    <td style="width: 100px; height: 16px">
                                                                                        <asp:DropDownList ID="ddlManager" runat="server" Width="120px" TabIndex="11" />
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td style="width: 99px;" align="left">
                                                                                        <asp:Label ID="lblRegion" runat="server" Text="Region"></asp:Label></td>
                                                                                    <td style="width: 100px; height: 16px">
                                                                                        <asp:DropDownList ID="ddlRegion" runat="server" Width="120px" TabIndex="12" />
                                                                                    </td>
                                                                                    <td style="width: 100px; height: 16px" align="left">
                                                                                        <asp:Label ID="lblVendorNo" runat="server" Text="Vendor No."></asp:Label></td>
                                                                                    <td style="width: 100px; height: 16px">
                                                                                        <asp:DropDownList ID="ddlVendorNo" runat="server" Width="120px" Enabled="False" TabIndex="13" />
                                                                                     </td>
                                                                                    <td style="width: 100px; height: 16px" align="left">
                                                                                        <asp:Label ID="lblClass" runat="server" Text="Class"></asp:Label></td>
                                                                                    <td style="width: 100px; height: 16px">
                                                                                        <asp:DropDownList ID="ddlClass" runat="server" Width="120px" TabIndex="14" />
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="DarkBluTxt boldText">
                                                                        <td valign="top" align="left" style="padding-left: 10px; padding-top: 25px;">
                                                                            <table border="0" width="100%">
                                                                                <tr>
                                                                                    <td style="width: 44px; height: 128px;" valign="top">
                                                                                        <asp:Label ID="lblNotes" runat="server" Text="Notes" Width="60px"></asp:Label></td>
                                                                                    <td style="width: 118px; height: 128px;">
                                                                                        <asp:TextBox ID="txtNotes" OnFocus="javascript:this.select();" runat="server" Height="120px" Width="190px" TabIndex="15"></asp:TextBox></td>
                                                                                    <td style="width: 33px; height: 128px;">
                                                                                        &nbsp;</td>
                                                                                    <td valign="top" style="width: 375px; height: 128px;">
                                                                                        <table border="0" cellspacing="0" frame="border">
                                                                                            <tr>
                                                                                                <td colspan="2" style="border-right: 1px solid; border-top: 1px solid; padding-left: 5px;
                                                                                                    border-left: 1px solid; border-bottom: 1px solid; border-collapse: collapse;
                                                                                                    height: 20px;" class="BluBg buttonBar" align="center">
                                                                                                        <asp:Label ID="lblZipCodeRange" runat="server" Text="Zip Code Range" Width="90px"></asp:Label></td>
                                                                                                <td class="BluBg buttonBar" style="width: 100px; height: 20px;">
                                                                                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                                                                                        <asp:Label ID="lblCommision" runat="server" Text="Commision" Width="60px"></asp:Label></td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td style="width: 35px; border-left: 1px solid; padding-left: 5px;">
                                                                                                    <asp:Label ID="lblFromZip" runat="server" Text="From"></asp:Label></td>
                                                                                                <td style="width: 100px">
                                                                                                    <asp:TextBox ID="txtFromZip" OnFocus="javascript:this.select();" runat="server" Width="80px" TabIndex="16"></asp:TextBox></td>
                                                                                                <td style="width: 100px; border-left: 1px solid; border-right: 1px solid; padding-left: 5px;">
                                                                                                    <asp:TextBox ID="txtCommPct" OnFocus="javascript:this.select();" runat="server" CssClass="txtRight" Width="80px"
                                                                                                        OnKeyPress="javascript:if(event.keyCode!=45&&event.keyCode!=46&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;" TabIndex="18"></asp:TextBox>&nbsp;%
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td style="height: 26px; border-left: 1px solid; border-bottom: 1px solid; padding-left: 5px;">
                                                                                                    <asp:Label ID="lblToZip" runat="server" Text="To"></asp:Label></td>
                                                                                                <td style="height: 26px; border-bottom: 1px solid;">
                                                                                                    <asp:TextBox ID="txtToZip" OnFocus="javascript:this.select();" runat="server" Width="80px" TabIndex="17"></asp:TextBox></td>
                                                                                                <td style="height: 26px; border-left: 1px solid; border-bottom: 1px solid; border-right: 1px solid;">
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
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
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" width="28%" class="BlueBorder">
                            <asp:UpdatePanel ID="upnlTree" UpdateMode="conditional" runat="server">
                                <ContentTemplate>
                                    <table id="LeftMenu" width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr valign="top">
                                            <td width="97%" valign="top">
                                                <div id="divRep" runat="server">
                                                    <uc3:RepTree ID="ucRep" runat="server" />
                                                </div>
                                                <div id="divLocation" runat="server" style="display: none;">
                                                    <uc4:LocTree ID="ucLocation" runat="server" />
                                                </div>
                                                <asp:HiddenField ID="hidRepNo" runat="server" />
                                                <asp:HiddenField ID="hidRepMasterID" runat="server" Value="none" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:HiddenField ID="hidSecurity" runat="server" />
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" width="28%" class="Search BlueBorder">
                            <asp:UpdatePanel ID="upnlSearchResult" UpdateMode="conditional" runat="server">
                                <ContentTemplate>
                                    <table cellpadding="0" cellspacing="0" border="0" class="Search " width="100%">
                                        <tr>
                                            <td class="Left2pxPadd DarkBluTxt boldText" width="86px">
                                                Search Results:
                                            </td>
                                            <td align="left">
                                                <asp:Label ID="lblSearch" runat="server" CssClass="lbl_whitebox" Font-Bold="true"
                                                    Width="120px"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>

                    <tr>
                        <td class="BluBg buttonBar" height="30" width="28%">
                            <table cellpadding="0" cellspacing="0" style="padding-top: 1px;">
                                <tr>
                                    <td>
                                        <asp:UpdateProgress ID="pnlProgress" runat="server" DisplayAfter="1" DynamicLayout="false">
                                            <ProgressTemplate>
                                                <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:UpdatePanel ID="pnlStatus" runat="server" UpdateMode="conditional">
                                            <ContentTemplate>
                                                <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                                    runat="server" Text=""></asp:Label>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td class="BluBg buttonBar" rowspan="1" valign="middle">
                            <table cellpadding="0" runat="server" id="tblFooter" cellspacing="0" style="margin-top: 5px;">
                                <tr>
                                    <td style="padding-left: 10px; height: 28px" width="90%" align="left" valign="top">
                                        <asp:ImageButton runat="server" ID="ibtnDelete" ImageUrl="common/images/btndelete.gif"
                                            ImageAlign="Left" CausesValidation="false" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                            OnClick="ibtnDelete_Click" />
                                    </td>
                                    <td align="right" style="padding-right: 10px; height: 28px;" valign="top">
                                        <asp:ImageButton runat="server" ID="ibtnSave" ImageUrl="common/images/BtnSave.gif"
                                            ValidationGroup="EmpData" ImageAlign="Right" CausesValidation="true" OnClick="ibtnSave_Click" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" valign="top">
                            <table width="100%">
                                <uc2:BottomFooter ID="ucFooter" Title="Rep Master" runat="server" />
                            </table>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>
