<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="PromptPage.aspx.cs" 
    Inherits="StandardComments" %>
<%@ Register Src="~/MaintenanceApps/Common/UserControls/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc4" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Contract Prompt</title>
    <link href="../MaintenanceApps/Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheets/StyleSheet.css" rel="stylesheet" type="text/css" />
    
        <script language="javascript" type="text/javascript">
        function LoadHelp()
        {
            window.open("../Help/HelpFrame.aspx?Name=SelectedSKU",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
        }
    </script>
<%--
   // <script>
//          function OpenPopup()
//          { 
//              var custNo=document.getElementById("txtCustNo").value;
//              if(custNo!="")
//              {
//                 window.open('CrossRefBuilder.aspx?CustomerNumber='+custNo+'' ,'CrossRefBuilder','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
//              }
//          }
          
//           function CreateCC()
//        {
//alert('CreateCC');
//            document.getElementById('btnHidCreateCC').click();
//alert('deleted');
//            return false;
//        }        
        
  //  </script>--%>

</head>
<body  bgcolor="#ECF9FB">
    <form id="form1" runat="server" defaultfocus="txtCustNo" defaultbutton="btnPush">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <asp:Panel DefaultButton="btnPush" runat=server ID="pnlPrompt">
            <table cellpadding="0" cellspacing="0" width="100%" id="mainTable" bgcolor="#ecf9fb">
            <tr>
                <td width="100%" height="50"  class="BorderAll" style="padding-left:20px;">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode=conditional>
                    <ContentTemplate>
                    <table width="100%" border="0" cellspacing="0" cellpadding="2">
                        <tr>
                            <td class="PageHead" style="height: 40px; width: 585px;">
                                <div class="LeftPadding">
                                    <div align="left" class="BannerText">
                                        Customer Contract Loader </div>
                                </div>
                            </td>
                            <td><asp:ImageButton TabIndex="2"  ID="btnPush" ImageUrl="~/MaintenanceApps/Common/images/Continue.gif"
                                 runat="server"  OnClick="btnPush_Click" />
                                  <asp:Button ID="btnHidCreateCC" runat="server" Style="display: none;" CausesValidation="false" />                                   
                                  <img src="../Common/images/help.gif" onclick="javascript:LoadHelp();" style="cursor: hand" />&nbsp;&nbsp;
                                  <img src="../Common/images/close.gif" onclick="javascript:history.back();" style="cursor: hand" />&nbsp;                            
                             </td>                            
                        </tr>
                    </table>
                    <asp:Panel ID="Panel1" runat="server" DefaultButton="btnPush">
                          <table height="70">                    
                            <tr>
                                <td class="LeftPadding">
                                    <asp:Label ID="Label1" runat="server" Text="Select Upload Option "></asp:Label>
                                </td>                           
                                <td>
                                    <asp:RadioButton ID="rdoReplace" runat="server" Text="Replace " GroupName="Option"
                                        AutoPostBack="True" ToolTip="This option will completly delete all items on the current contract and replace it with your list." OnCheckedChanged="rdoReplace_CheckedChanged"
                                        TabIndex="1" />&nbsp;&nbsp;&nbsp;
                                    <asp:RadioButton ID="rdoUpdate" runat="server" Text="Update " GroupName="Option"
                                        AutoPostBack="True"  ToolTip="This option will only update the items on your list." OnCheckedChanged="rdoUpdate_CheckedChanged" Checked="True" 
                                        TabIndex="2" />&nbsp;&nbsp;&nbsp;
                                    <asp:RadioButton ID="rdoNewContract" runat="server" Text="New Contract" GroupName="Option"
                                        AutoPostBack="True" ToolTip="This option creates a brand new contract." OnCheckedChanged="rdoNewContract_CheckedChanged" 
                                        TabIndex="3" />
                                </td>
                                <td colspan="2">&nbsp;</td>
                            </tr> 
                            <tr id="trNewContract" runat="server">
                                <td class="LeftPadding">
                                    <asp:Label ID="lblCustomerNo" runat="server" Text="New Contract "></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox MaxLength="30" onfocus="javascript:this.select();" onkeypress=" if (window.event.keyCode < 48 || window.event.keyCode > 58) window.event.keyCode = 0; "
                                         ID="txtCustNo" TabIndex="1"  CssClass="formCtrl" runat="server"></asp:TextBox>
                                </td>
                                <td>
                                    &nbsp;</td>                                
                            </tr> 
                            <tr>
                                <td class="LeftPadding">
                                    <asp:Label ID="lblExistingContract" runat="server" Text="Existing Contract "></asp:Label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlContract" runat="server" CssClass="FormCtrl" Width="190px"
                                     AutoPostBack="True" TabIndex="5" />
                                </td>                           
                                <td colspan="2"></td>
                            </tr>                                                       
                            <tr align="center">
                                <td class="blackTxt"  valign="middle" align="center" colspan="2">
                                    
                                <asp:Label ID="lblMessage" Font-Bold=True ForeColor=Red Visible=False runat="server" Text="Customer Contract already exists"></asp:Label></td>
                            </tr> 
                            
                            <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage2" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
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
           <uc4:Footer ID="BottomFrame2" Title="Customer Contract Prompt" runat="server" />
           </td>
           </tr>
        </table>
        </asp:Panel>
    </form>
</body>
</html>
