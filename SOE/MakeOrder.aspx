<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MakeOrder.aspx.cs" Inherits="MakeOrder" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Select Order Type</title>
      <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
</head>
 
 <script type="text/javascript">
        // function to relaod sold to contact information in parent window
        function MakeOrder(mode)
        {        
           window.opener.document.getElementById("hidMOrderType").value=mode;     
           var btnBind= window.opener.document.getElementById("imgMakeOreder");        
           if (typeof btnBind == 'object')
           { 
                btnBind.click();                   
           }     
            window.close();
            return false;            
        } 
    </script>
<body>
    <form id="form1" runat="server">
        <table class="HeaderPanels" border="0" cellpadding="0" cellspacing="0" style="width: 100%;
            height: 200">
            <tr>
                <td class="lightBg" style="padding: 5px;">
                    <table border="0" cellpadding="3" cellspacing="0" width="100%">
                        <tr>
                            <td align="left">
                                <asp:Label ID="lblCaption" runat="server" Font-Bold="True" Text="Make Order type For Order# "
                                    Width="275px"></asp:Label></td>
                            <td width="35%" align="right">
                                &nbsp;<img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top; padding-bottom: 5px; padding-top: 5px; padding-left: 5px;
                    background-color: White;">
                    <div class="Sbar" onclick="javascript:if(document.getElementById('lnkOriginalOrder')){document.getElementById('lnkOriginalOrder').focus();}"
                        oncontextmenu="Javascript:return false;" id="divdatagrid" style="overflow-x: hidden;
                        overflow-y: auto; position: relative; top: 0px; left: 0px; height: 100px; border: 1px solid #88D2E9;
                        width: 98%; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                        scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                        scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94" runat="server">
                        <table border="0" cellpadding="0" cellspacing="3" style="width: 100%;">
                            <tr>
                                <td style="width: 250px; height: 20px; font-weight: bold;" valign="top">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td style="width: 250px; height: 20px; padding-left: 20px;" valign="top">
                                    <asp:LinkButton ID="lnkDefaultOrder" runat="server" Text="Allocate and Release to Warehouse" OnClientClick="javascript:return MakeOrder('');" ></asp:LinkButton></td>
                            </tr>
                            <tr>
                                  <td style="width: 250px; height: 20px; padding-left: 20px;" valign="top">
                                    <asp:LinkButton ID="lnkHoldOrder" runat="server" Text="Allocate and Hold" OnClientClick="javascript:return MakeOrder('HW');" ></asp:LinkButton></td>
                            </tr>   
                            <tr>
                                <td style="padding-left: 20px; width: 250px; height: 20px" valign="top">
                                    <asp:LinkButton ID="lnkHoldInvoice" runat="server" OnClientClick="javascript:return MakeOrder('HI');"
                                        Text="Allocate, Release to Warehouse, <b>Hold Invoice</b>"></asp:LinkButton></td>
                            </tr>                      
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="Footer1" Title="Order Type" runat="server"></uc2:Footer>
                </td>
            </tr>
        </table>
    </form>

    <script>
    self.focus();
    </script>

</body>
</html>
