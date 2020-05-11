<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DocViewer.aspx.cs" Inherits="AvailableShipper" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Document Viever</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
    //
    function OpenDoc()
    {
        var DocName = $get("DocType").value;
        var DocNo = $get("SONumberTextBox").value;
        //alert(DocNo);
        if (DocName=="Invoice")
        {
            window.open('InvoiceView.aspx?InvoiceNo=' + DocNo + '','InvoiceDocView','height=740,width=900,toolbar=0,scrollbars=1,status=0,resizable=YES,left=0','');    
        }
        if (DocName=="Credit")
        {
            window.open('CreditView.aspx?CreditMemoNo=' + DocNo + '','InvoiceDocView','height=740,width=900,toolbar=0,scrollbars=1,status=0,resizable=YES,left=0','');    
        }
        if (DocName=="RGR")
        {
            window.open('RGRView.aspx?RGRNo=' + DocNo + '','InvoiceDocView','height=740,width=900,toolbar=0,scrollbars=1,status=0,resizable=YES,left=0','');    
        }
    }
    </script>

    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>

</head>
<body>
    <asp:SqlDataSource ID="LocationCodes" runat="server" ConnectionString="<%$ ConnectionStrings:PFCERPConnectionString %>"
        SelectCommand="select LocID as Code, LocID+' - '+LocName as Name from [LocMaster] with (NOLOCK) where ShipMethCd='ERP' order by LocID">
    </asp:SqlDataSource>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="DocViewerScriptManager" runat="server" EnablePartialRendering="true" />
        <div>
            <asp:UpdatePanel ID="MainUpdatePanel" runat="server" UpdateMode="Conditional"><ContentTemplate>
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="middle" class="PageHead" colspan="2">
                        <span class="Left5pxPadd">
                            <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server"></asp:Label>
                        </span>
                    </td>
                </tr>
                <tr>
                    <td class="Left5pxPadd">
                        <asp:Panel ID="EntryPanel" runat="server" Style="border: 1px solid #88D2E9; display: block;"
                            Height="130px">
                            <table>
                                <tr>
                                    <td style="width: 280px;" align="right">
                                        <b>
                                            <asp:Label ID="DocPromptLabel" runat="server" ></asp:Label> Document Number for Reprint:</b>
                                    </td>
                                    <td style="width: 90px;">
                                        &nbsp;
                                        <asp:TextBox CssClass="ws_whitebox_left" ID="SONumberTextBox" runat="server" Text=""
                                            Width="60px" TabIndex="1" onfocus="javascript:this.select();" onkeypress="javascript:if(event.keyCode==13){event.keycode=0;document.form1.HiddenSubmit.click();return false;}">
                                        </asp:TextBox>&nbsp;
                                        <asp:Button ID="HiddenSubmit" name="HiddenSubmit" OnClick="Search" runat="server"
                                            Text="Button" Style="display: none;" />
                                        <asp:HiddenField ID="OrderIDHidden" runat="server" />
                                        <asp:HiddenField ID="DocType" runat="server" />
                                        <asp:HiddenField ID="LineSort" runat="server" />
                                        <asp:HiddenField ID="HeaderTable" runat="server" />
                                    </td>
                                    <td align="left" style="width: 50px;">
                                        <asp:ImageButton ID="GoImageButton" ImageUrl="~/Common/Images/ShowButton.gif" OnClick="Search"
                                            CausesValidation="false" runat="server" />
                                    </td>
                                    <td style="width: 140px;">
                                        <asp:UpdateProgress ID="HeaderUpdateProgress" runat="server">
                                            <ProgressTemplate>
                                                Loading....
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" style="width: 280px;">
                                        Customer
                                    </td>
                                    <td class="Left5pxPadd" colspan="3" style="width: 280px;">
                                        <asp:Label ID="CustNameLabel" runat="server" Text=""></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" style="width: 280px;">
                                        Date
                                    </td>
                                    <td class="Left5pxPadd" colspan="3" style="width: 280px;">
                                        <asp:Label ID="OrderDateLabel" runat="server" Text=""></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td align="left" class="PageBg">
                                    <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:Label ID="MessageLabel" runat="server"></asp:Label>&nbsp;
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td align="center" class="PageBg">
                                    <asp:Panel ID="PreviewPanel" runat="server" Width="100px">
                                    <img src="../Common/Images/viewReport.gif" style="cursor: hand" alt="Click here for To display the report preview"
                                        onclick="OpenDoc();" />
                                    </asp:Panel>
                                </td>
                                <td align="right" class="PageBg" valign="bottom">
                                    <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="../Common/Images/close.gif"
                                        PostBackUrl="DocViewDashBoard.aspx" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </form>
</body>
</html>
