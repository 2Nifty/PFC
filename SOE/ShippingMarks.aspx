<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShippingMarks.aspx.cs" Inherits="ShippingMarks" %>
<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/SubHeader.ascx" TagName="SoHeader" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="SoFooter" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/CommonLink.ascx" TagName="CommonLink" TagPrefix="uc4" %>
<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc5" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />   

    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>

    <title>Shipping Marks</title>
</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';" >
    <form id="form1" runat="server" style="width:100%;">
        <asp:ScriptManager ID="scmShippingMarks" runat="server">
        </asp:ScriptManager>
        <table border="0" cellpadding="0" cellspacing="1" style="width: 100%; height: 100%"
            class="HeaderPanels">
            <tr>
                <td colspan="2">
                    <uc1:SoHeader ID="SoHeader" runat="server"></uc1:SoHeader>
                </td>
            </tr>
            <tr style="width: 100px">
                <td colspan="2" class="lightBg" style="padding-top:25px;padding-bottom:50px;">
                    <table border="0" cellpadding="0" cellspacing="7" 
                        align="center" width="100%">
                        <tr>
                            <td style="width: 100px;font-weight:bold;" align="left" >
                                <asp:Label ID="lblMark1" runat="server" Text="Shipping Mark1 :" Width="100px"></asp:Label></td>
                            <td style="width: 200px" align="left">
                                <asp:TextBox ID="txtShipMark1" runat="server" Width="200px" CssClass="lbl_whitebox"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 100px;font-weight:bold;" align="left">
                                <asp:Label ID="lblMark2" runat="server" Text="Shipping Mark2 :" Width="100px"></asp:Label></td>
                            <td style="width: 200px" align="left">
                                <asp:TextBox ID="txtShipMark2" runat="server" Width="200px" CssClass="lbl_whitebox"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 100px;font-weight:bold;" align="left">
                                <asp:Label ID="lblMark3" runat="server" Text="Shipping Mark3 :" Width="100px"></asp:Label></td>
                            <td style="width: 200px" align="left">
                                <asp:TextBox ID="txtShipMark3" runat="server" Width="200px" CssClass="lbl_whitebox"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 100px;font-weight:bold;" align="left">
                                <asp:Label ID="lblMark4" runat="server" Text="Shipping Mark4 :" Width="100px"></asp:Label></td>
                            <td style="width: 200px" align="left">
                                <asp:TextBox ID="txtShipMark4" runat="server" Width="200px" CssClass="lbl_whitebox"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 130px;font-weight:bold;" align="left">
                                <asp:Label ID="lblInstruction" runat="server" Text="Shipping Instructions :" Width="130px"></asp:Label></td>
                            <td style="width: 100px" align="left">
                                <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlInstruction">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlShippingInstruction" Height=20 runat="server" Width="205px" CssClass="lbl_whitebox Sbar">
                                        </asp:DropDownList>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100px;font-weight:bold;" align="left">
                                <asp:Label ID="lblRemarks" runat="server" Text="Remarks :" Width="100px"></asp:Label></td>
                            <td style="width: 250px" align="left">
                                <asp:TextBox ID="txtRemarks" TextMode="MultiLine" runat="server" Width="200px" CssClass="lbl_whitebox Sbar" Height=50px></asp:TextBox></td>
                            <input type="hidden" id="hidCustomerNumber" runat="server" />
                            <input type="hidden" id="hidCustomerName" runat="server" />
                           
                           
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="MessageText">
                    <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlMessage">
                        <ContentTemplate>
                            <asp:Label ID="lblMessage" ForeColor="Green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td align="right" width=40%>
                    <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlShipMark">
                        <ContentTemplate>
                            <asp:ImageButton ImageUrl="~/Common/Images/save.jpg" ID="imgsave" CausesValidation="false"
                                runat="server" OnClick="btnSave_Click" />
                            <img src="Common/Images/close.gif" onclick="javascript:parent.window.close();" style="cursor: hand;"
                                id="imgclose" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan = 2 align="right" width="100%" id="td1" class="commandLine splitborder_t_v splitborder_b_v"
                    style="height: 20px; background-position: -80px  left;">
                    <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlExport">
                        <ContentTemplate>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td align="left" width="85%">
                                        <asp:UpdateProgress ID="upPanel" runat="server">
                                            <ProgressTemplate>
                                                <span class="TabHead">Loading...</span></ProgressTemplate>
                                        </asp:UpdateProgress>
                                        <asp:UpdatePanel ID="upProgress" runat="server" UpdateMode="conditional">
                                            <ContentTemplate>
                                                <asp:Label ID="Label1" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                    <td>
                                    <td>
                                        <td></td>
                                            <td colspan = 4><uc5:PrintDialogue id="PrintDialogue1" runat="server"></uc5:PrintDialogue></td>
                                    
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                
            </tr>
            
                          
            <tr>
                <td width="100%" colspan=2>
                <table width="100%"> <uc2:SoFooter ID="Footer" Title="Shipping Marks" runat="server"></uc2:SoFooter></table>
                   
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
