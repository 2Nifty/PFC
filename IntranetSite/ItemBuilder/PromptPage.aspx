<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="PromptPage.aspx.cs"
    Inherits="StandardComments" %>

<%@ Register Src="~/Common/UserControls/PhoneNumber.ascx" TagName="Phone" TagPrefix="uc3" %>
<%@ Register Src="~/MaintenanceApps/Common/UserControls/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc4" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Number Prompt</title>
    <link href="../MaintenanceApps/Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheets/StyleSheet.css" rel="stylesheet" type="text/css">

    <script>
          function OpenPopup()
          { 
              var custNo=document.getElementById("txtCustNo").value;
              if(custNo!="")
              {
                 window.open('CrossRefBuilder.aspx?CustomerNumber='+custNo+'' ,'CrossRefBuilder','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
              }
          }
    </script>

</head>
<body  bgcolor="#ECF9FB">
    <form id="form1" runat="server" defaultfocus="txtCustNo" defaultbutton="btnPush">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <asp:Panel DefaultButton="btnPush" runat=server ID="pnlPrompt">
            <table cellpadding="0" cellspacing="0" width="100%" id="mainTable" bgcolor="#ECF9FB">
            <tr>
                <td width="100%" height="50px"  class="BorderAll" style="padding-left:20px;">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode=conditional>
                    <ContentTemplate>
                        <asp:Panel ID="Panel1" runat="server" DefaultButton="btnPush">
                          <table height="70px">
                        <tr>
                            <td>
                                <asp:Label ID="lblCustomerNo" runat="server" Text="Customer Number"></asp:Label>
                            </td>
                            <td style="padding-left: 10PX;">
                                <asp:TextBox MaxLength="6" onfocus="javascript:this.select();" onkeypress=" if (window.event.keyCode < 48 || window.event.keyCode > 58) window.event.keyCode = 0; "
                                     ID="txtCustNo" TabIndex="1"  CssClass="formCtrl" runat="server"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtCustNo"
                                    runat="server" ErrorMessage="*"></asp:RequiredFieldValidator></td>
                                    <td><asp:ImageButton TabIndex="2"  ID="btnPush" ImageUrl="~/MaintenanceApps/Common/images/Continue.gif"
                                    runat="server"  OnClick="btnPush_Click" />
                                <img tabindex="3" id="CloseButton" src="../MaintenanceApps/Common/images/close.jpg" onclick="javascript:window.close();" /></td>
                        </tr>
                        <tr align="center">
                            <td class="blackTxt"  valign="middle" align="center" colspan="2">
                                
                                
                            <asp:Label ID="lblMessage" Font-Bold=true ForeColor=red Visible=false runat="server" Text="Invalid Customer Number"></asp:Label></td>
                        </tr>
                        
                    </table>
                        </asp:Panel>
                    
                    </ContentTemplate>
                    </asp:UpdatePanel>
                  
                </td>
            </tr>
            <tr>
                <td>
                    <uc4:Footer ID="BottomFrame2" Title="Customer Number Prompt" runat="server" />
                </td>
            </tr>
        </table>
        </asp:Panel>
    </form>
</body>
</html>
