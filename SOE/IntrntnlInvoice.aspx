<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IntrntnlInvoice.aspx.cs"
    Inherits="IntrntnlInvoice" %>

<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <script>
        var DocWindow;
        function pageUnload() {
            CloseChildren();
        }
        function ClosePage()
        {
            window.close();	
        }
        function CloseChildren()
        {
            SetScreenPos("IntrntnlInvoice");
        }
        /*function OpenHelp(topic)
        {
            window.open('SOEHelp.aspx#' + topic + '','WorkSheetHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
        }
        function SetHeight()
        {  onload="SetHeight();" onresize="SetHeight();"
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //take out room for entry, header, and bottom panel
            yh = yh - 235;
            var DetailPanel = $get("DetailPanel")
            DetailPanel.style.height = yh;  
            var DetailGridPanel = $get("DetailGridPanel")
            DetailGridPanel.style.height = yh - 35;  
            DetailGridPanel.style.width = xw - 25;  
            
        }*/
    </script>

    <title>International Invoice V1.0.0</title>

    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>

    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>

    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/PriceSheetStyles.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 0px" bgcolor="#b5e7f7">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="IntrntnlInvoiceScriptManager" runat="server" EnablePartialRendering="true" />
        <div>
            <asp:UpdatePanel ID="EntryUpdatePanel" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <table width="100%">
                        <tr>
                            <td class="Left5pxPadd">
                                <asp:Panel ID="EntryPanel" runat="server" Style="border: 1px solid #88D2E9; display: block;"
                                    Height="130px">
                                    <table>
                                        <tr>
                                            <td style="width:280px;">
                                                <b>Released Order Number for International Invoice:</b>
                                            </td>
                                            <td style="width:90px;">
                                                &nbsp;
                                                <asp:TextBox CssClass="ws_whitebox_left" ID="SONumberTextBox" runat="server" Text=""
                                                    Width="60px" TabIndex="1" onfocus="javascript:this.select();" 
                                                    onkeypress="javascript:if(event.keyCode==13){event.keycode=0;document.form1.HiddenSubmit.click();return false;}">
                                                </asp:TextBox>&nbsp;
                                                <asp:Button ID="HiddenSubmit" name="HiddenSubmit" OnClick="Search" runat="server"
                                                    Text="Button" Style="display: none;" />
                                                <asp:HiddenField ID="OrderIDHidden" runat="server" />
                                                <asp:HiddenField ID="DocType" runat="server" />
                                                <asp:HiddenField ID="LineSort" runat="server" />
                                                <asp:HiddenField ID="HeaderTable" runat="server" />
                                            </td>
                                            <td align="left" style="width:50px;">
                                                <asp:ImageButton ID="GoImageButton" ImageUrl="~/Common/Images/ShowButton.gif" OnClick="Search"
                                                    CausesValidation="false" runat="server" />
                                            </td>
                                            <td style="width:140px;">
                                                <asp:UpdateProgress ID="HeaderUpdateProgress" runat="server">
                                                    <ProgressTemplate>
                                                        Loading....
                                                    </ProgressTemplate>
                                                </asp:UpdateProgress>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="width:280px;">
                                                Customer
                                            </td>
                                            <td class="Left5pxPadd" colspan="3" style="width:280px;">
                                                <asp:Label ID="CustNameLabel" runat="server" Text=""></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="width:280px;">
                                                Date
                                            </td>
                                            <td class="Left5pxPadd" colspan="3" style="width:280px;">
                                                <asp:Label ID="OrderDateLabel" runat="server" Text=""></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td class="Left5pxPadd">
                                <table width="100%" style="border: 1px solid #88D2E9; height: 25px; display: block;">
                                    <tr>
                                        <td>
                                            <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:Label ID="MessageLabel" runat="server"></asp:Label>&nbsp;
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                        <td align="right">
                                            <div style="width: 70px;">
                                                <asp:UpdatePanel ID="PrintUpdatePanel" runat="server" UpdateMode="Conditional">
                                                    <ContentTemplate>
                                                        <uc1:PrintDialogue id="Print" runat="server" EnableFax="true">
                                                        </uc1:PrintDialogue>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </div>
                                        </td>
                                        <td align="right">
                                            <img src="Common/Images/close.gif" style="cursor: hand" onclick="ClosePage();" alt="Close Page">
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
