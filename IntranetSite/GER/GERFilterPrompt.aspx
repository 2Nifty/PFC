<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GERFilterPrompt.aspx.cs" Inherits="PFC.Intranet.CustPriceMatrixPrompt" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Matrix Prompt</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script language="javascript">

    function ViewReport()
    {
        var pfcItemNo = document.getElementById("txtPFCItemNo").value;
        var containerNo = document.getElementById("txtContainerNo").value;
        var poNo =  document.getElementById("txtPONo").value;
        var locId = document.getElementById("ddlLocation").options[document.getElementById("ddlLocation").selectedIndex].value;
        var locDesc = (document.getElementById("ddlLocation").selectedIndex == 0 ? "" : document.getElementById("ddlLocation").options[document.getElementById("ddlLocation").selectedIndex].text);
        var startDt = document.getElementById("txtStartDt").value;
        var endDt = document.getElementById("txtEndDt").value;
        
        if (pfcItemNo != "" || containerNo != "" || poNo != "" || locId != "")
        {
            var Url =   "GERFilter.aspx?" +
                        "PFCItemNo=" + pfcItemNo +  
                        "&ContainerNo=" + containerNo +
                        "&PONo=" + poNo +
                        "&LocID=" + locId +
                        "&LocDesc=" + locDesc +
                        "&StartDt=" + startDt +
                        "&EndDt=" + endDt;
        
            var hwnd=window.open(Url,"GERFilter" ,'height=700,width=950,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
            hwnd.focus();         
        }
        else
        {
            alert('Please enter valid search filter.');
        }       
    }
    
    function LoadHelp()
    {
        window.open("../Help/HelpFrame.aspx?Name=InvoiceReport",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
    }
    </script>

</head>
<body scroll="auto">
    <form id="form1" runat="server">
    <asp:ScriptManager runat="server" ID="smGER" />
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="top">
                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                </td>
            </tr>
            <tr>
                <td valign="top" style="height: 100%;">
                    <table width="100%" border="0" cellspacing="0" cellpadding="2">
                        <tr>
                            <td class="PageHead" style="height: 40px" width="75%">
                                <div class="LeftPadding">
                                    <div align="left" class="BannerText">
                                        GER BOL Search</div>
                                </div>
                            </td>
                            <td class="PageHead" style="height: 40px; width: 275px;">
                                <div class="LeftPadding">
                                    <div align="right" class="BannerText">
                                        <img src="../Common/images/close.gif" onclick="javascript:history.back();" style="cursor: hand" /></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                                <table border="0" cellpadding="5" cellspacing="0">
                                    <col style="width:125px;" />
                                    <col style="width:150px;" />
                                    <col style="width:25px;" />
                                    <col style="width:250px;" />
                                    <tr>
                                        <td>
                                            <b>Item Number:</b></td>
                                        <td colspan="2">
                                            <asp:TextBox ID="txtPFCItemNo" runat="server" CssClass="cnt" Width="150px" TabIndex="1"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <b>Container Number:</b></td>
                                        <td colspan="2">
                                            <asp:TextBox ID="txtContainerNo" runat="server" CssClass="cnt" Width="150px" TabIndex="2"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <b>PO Number:</b></td>
                                        <td colspan="2">
                                            <asp:TextBox ID="txtPONo" runat="server" CssClass="cnt" Width="150px" TabIndex="3"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <b>Branch:</b></td>
                                        <td colspan="2">
                                            <asp:DropDownList ID="ddlLocation" runat="server" CssClass="FormCtrl" TabIndex="4" Width="155px" /></td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <b>Start Date:</b></td>
                                        <td valign="top">
                                            <asp:UpdatePanel ID="pnlStartDt" runat="server" UpdateMode="conditional">
                                                <ContentTemplate>
                                                    <asp:TextBox ID="txtStartDt" runat="server" AutoPostBack="true" CssClass="cnt" OnTextChanged="txtStartDt_TextChanged" Width="150px" TabIndex="5"></asp:TextBox>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td valign="top">
                                            <asp:ImageButton runat="server" ID="ibtnStartDt" ImageUrl="../Common/Images/datepicker.gif" OnClick="ibtnStartDt_Click" Enabled="true" /></td>
                                        <td>
                                            <asp:UpdatePanel ID="pnlStartPick" runat="server" UpdateMode="conditional">
                                                <ContentTemplate>
                                                    <asp:Calendar ID="cldStartDt" runat="server" Visible="false" OnSelectionChanged="cldStartDt_SelectionChanged" Width="150px" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <b>End Date:</b></td>
                                        <td valign="top">
                                            <asp:UpdatePanel ID="pnlEndDt" runat="server" UpdateMode="conditional">
                                                <ContentTemplate>
                                                    <asp:TextBox ID="txtEndDt" runat="server" AutoPostBack="true" CssClass="cnt" OnTextChanged="txtEndDt_TextChanged" Width="150px" TabIndex="6"></asp:TextBox>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td valign="top">
                                            <asp:ImageButton runat="server" ID="ibtnEndDt" ImageUrl="../Common/Images/datepicker.gif" OnClick="ibtnEndDt_Click" Enabled="true" /></td>
                                        <td>
                                            <asp:UpdatePanel ID="pnlEndPick" runat="server" UpdateMode="conditional">
                                                <ContentTemplate>
                                                    <asp:Calendar ID="cldEndDt" runat="server" Visible="false" OnSelectionChanged="cldEndDt_SelectionChanged" Width="150px" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td colspan="3">
                                            <asp:UpdatePanel ID="pnlError" runat="server" UpdateMode="conditional">
                                                <ContentTemplate>
                                                    <asp:Label ID="lblError" runat="server" Font-Bold="True" ForeColor="red" Text=""></asp:Label>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="BluBg" style="">
                    <div class="LeftPadding" style="height: 33px;">
                        <span class="LeftPadding" style="vertical-align: middle;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <img id="btnSearch" src="common/images/search.gif" style="cursor: hand; padding-top: 5px;"
                                onclick="javascript:ViewReport();" />&nbsp;&nbsp;&nbsp;
                            <img src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />&nbsp;
                        </span>
                    </div>
                </td>
                <td class="BluBg">
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
