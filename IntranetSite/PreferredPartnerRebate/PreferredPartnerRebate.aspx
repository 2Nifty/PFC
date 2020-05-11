<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="PreferredPartnerRebate.aspx.cs"
    Inherits="PreferredPartnerRebate" %>

<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/PreferredPartnerRebate/Common/UserControls/MinFooter.ascx" TagName="Footer"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Preferred Partner Rebate</title>
    <link href="Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />
    <link href="../PreferredPartnerRebate/Common/StyleSheet/SOEStyles.css" rel="stylesheet"
        type="text/css" />

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>

    <style>
    .FormCtrls {
	/*background-color: #f8f8f8;*/
	border: 1px solid #cccccc;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	color: #003366;
	width: 120px;
	height: 22px;
}
    </style>

    <script language="vbscript">
    
           Function ShowYesorNo(strMsg)
           Dim intBtnClick
           intBtnClick=msgbox(strMsg,vbyesno," Sales History")
           if intBtnClick=6 then
               ShowYesorNo= true
           else
               ShowYesorNo= false
            end if
            end Function
    </script>

    <script>
    
     function PrintReport(queryString)
    {
       var Url="RebateExport.aspx?"+queryString;
       var hwin=window.open(Url, 'PrintRebate', 'height=505,width=800,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (505/2))+',left='+((screen.width/2) - (800/2))+',resizable=no','');
       hwin.focus();
    }
     function GetCustName()
    {
    var name=document.getElementById("ddlChainCust").value;
    
    document.getElementById("lblCustName").innerText =name;
    }
    
    function ValidateLine(obj)
    {
    
        var baseLine=document.getElementById(obj).value;
         var salesHist=document.getElementById(obj.replace('txtBaseLine','hidHistory')).value;
           // var salesHist=document.getElementById("hidHistory").value
        var status =PreferredPartnerRebate.ValidateBase(baseLine,salesHist).value;
        
        if(status =='false' && document.getElementById(obj).value !='')
        { 
            if(ShowYesorNo('BaseLine is lesser than Sales History.Do you want to proceed?'))
            { 
                document.getElementById("hidErrorStatus").value="true";
                document.getElementById(obj.replace("txtBaseLine","txtGoal")).focus();
               document.getElementById(obj.replace("txtBaseLine","txtGoal")).select();
                
            }
            else
            {
             document.getElementById("hidErrorStatus").value="";
               document.getElementById(obj).focus();
               document.getElementById(obj).select();
           }
        //alert('BaseLine must be Greater than Sales History');
//       document.getElementById(obj).focus();
//       document.getElementById(obj).select();
        }
        else
        {
            document.getElementById("hidErrorStatus").value="";
            document.getElementById(obj.replace('txtBaseLine','txtGoal')).focus();
            document.getElementById(obj.replace('txtBaseLine','txtGoal')).select();
        }
        
        
    }
    
    function GetSalesHist(obj)
    {
        var ddl=document.getElementById(obj);
        var categoryVal=document.getElementById(obj).value;
              
        var category= ddl.options[ddl.selectedIndex].text;
        var salesHistVal=PreferredPartnerRebate.GetSalesHist(category).value;
        var salesHistVal=eval(salesHistVal).toFixed(2); 
        var histVal=PreferredPartnerRebate.GetHistValue(salesHistVal).value;
          
        document.getElementById (obj.replace('ddlCategory','lblEDescription')).innerText =categoryVal;
        document.getElementById("hidHistory").value=salesHistVal;
        document.getElementById(obj.replace('ddlCategory','hidHistory')).value=salesHistVal;
        document.getElementById(obj.replace('ddlCategory','lblEHistory')).innerText=histVal;
        document.getElementById (obj.replace('ddlCategory','txtBaseLine')).disabled=false;
       
    }
    
     function ValdateNumberWithDot(value)
    {
        if(event.keyCode<46 || event.keyCode>58)
            event.keyCode=0;
            
        if(event.keyCode==46 && value.indexOf('.')!=-1)
             event.keyCode=0;
         
    }
    
    function xstooltip_showTest(tooltipId, parentId, e) 
    { 

        it = document.getElementById(tooltipId); 

        // need to fixate default size (MSIE problem) 
        img = document.getElementById(parentId); 
         
        x = xstooltip_findPosX(img); 
        y = xstooltip_findPosY(img); 
        
        it.style.top =  (e.clientY + 10) + 'px';  
        it.style.left =(x+30)+ 'px';

        // Show the tag in the position
          it.style.display = '';
     
    }
    function ShowDelete(ctrlID,e)
    {
      xstooltip_showTest('divDelete',ctrlID,e);
      return false;       
    }
    
    function CallBtnClick(id)
    {
        var btnBind=document.getElementById(id);
            
           if (typeof btnBind == 'object')
           { 
                btnBind.click();
                return false; 
           } 
          return;
    }
    
    function DeleteRebate(salesId,ctrlID,e)
    {
      if(event.button ==2)
      {  
      ShowDelete(ctrlID,e);
        document.getElementById("hidDelete").value=salesId;
       
      }    
    }
    </script>

</head>
<body onclick="javascript:document.getElementById('divDelete').style.display='none';if(document.getElementById('hidRowID').value != '')document.getElementById(document.getElementById('hidRowID').value).style.fontWeight='normal';document.getElementById('lblMessage').innerText='';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="SMPreferred" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr class="lightBlueBg" style="padding-top: 1px;">
                <td id="tdHeader" style="padding-top: 1px; width: 1253px;">
                    <uc1:Header ID="Header1" runat="server"></uc1:Header>
                </td>
            </tr>
            <tr>
                <td style="padding-top: 1px;">
                    <asp:Panel ID="Panel1" runat="server">
                        <table style="width: 100%" class="blueBorder lightBlueBg" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <table style="width: 100%">
                                        <tr>
                                            <td class="Left2pxPadd " style="padding-left: 30px" colspan="3">
                                            </td>
                                            <td class="Left2pxPadd " colspan="1" style="padding-left: 30px">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 12px">
                                                <asp:Label ID="lblProgramName" runat="server" Height="16px" Text="Program Name" Width="120px"></asp:Label>
                                            </td>
                                            <td style="width: 300px; height: 30px" colspan="2">
                                                <asp:DropDownList ID="ddlProgram" Width="220px" CssClass="FormCtrls" runat="server"
                                                    TabIndex="1"  >
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="rfvProgram" runat="server" ControlToValidate="ddlProgram"
                                                    Display="Dynamic" ErrorMessage=" *Required"></asp:RequiredFieldValidator>
                                            </td>
                                            <td colspan="1" style="width: 300px; height: 30px">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 5px;">
                                                <asp:RadioButtonList ID="rdoCustChain" runat="server" RepeatDirection="Horizontal"
                                                    AutoPostBack="true" OnSelectedIndexChanged="rdoCustChain_SelectedIndexChanged"
                                                    TabIndex="2">
                                                    <asp:ListItem Value="Chain" Selected="True">Chain #</asp:ListItem>
                                                    <asp:ListItem Value="Cust">Cust #</asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                            <td colspan="2">
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td style="width: 100px">
                                                            <asp:DropDownList ID="ddlChainCust" Width="98px" CssClass="FormCtrls" runat="server"
                                                                AutoPostBack="true" OnSelectedIndexChanged="ddlChainCust_SelectedIndexChanged"
                                                                TabIndex="4" >
                                                            </asp:DropDownList>
                                                            <asp:RequiredFieldValidator ID="rfvChainCust" runat="server" ControlToValidate="ddlChainCust"
                                                                ErrorMessage=" *Required " Display="Dynamic"></asp:RequiredFieldValidator>
                                                        </td>
                                                        <td style="padding-left: 10px;">
                                                            <asp:Label ID="lblCustName" runat="server" Height="16px" Width="250px"></asp:Label></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td colspan="1">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                                <asp:Label ID="Label4" runat="server" Height="16px" Text="Start Date" Width="111px"></asp:Label></td>
                                            <td style="width: 100%" colspan="2">
                                                <uc3:novapopupdatepicker ID="dtpStartDate" runat="server" TabIndex="5" />
                                            </td>
                                            <td colspan="1" style="width: 150px">
                                            </td>
                                        </tr>
                                        <tr>
                                                      <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 12px;" valign="top">
                                                <asp:Label ID="Label5" runat="server" Height="16px" Text="End Date" Width="111px"></asp:Label></td>
                                            <td colspan="2">
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td style="width: 50%">
                                                            <uc3:novapopupdatepicker ID="dtpEndDate" runat="server" TabIndex="6" />
                                                            <asp:HiddenField ID="hidHistory" runat="server" />
                                                        </td>
                                                        <td style="width: 50%; padding-left: 10px;">
                                                            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                                                                <ContentTemplate>
                                                                    <asp:ImageButton ID="ibtnSearch" runat="server" ImageUrl="~/PreferredPartnerRebate/Common/images/pfc_load.gif"
                                                                        OnClick="ibtnSearch_Click" CausesValidation="true" />
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td colspan="1" align="right" style="padding-right: 0px;">
                                                <asp:ImageButton runat="server" Style="cursor: hand" ID="ibtnPrint" ImageUrl="~/Common/Images/Print.gif"
                                                    ImageAlign="middle" CausesValidation="false" OnClick="ibtnPrint_Click" TabIndex="13" /></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td>
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="padding-top: 1px; height: 7px;" colspan="2">
                                <asp:UpdatePanel ID="upnlgrid" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div id="div-datagrid" oncontextmenu="Javascript:return false;" class="Sbar" style="overflow-x: hidden;
                                            overflow-y: auto; position: relative; top: 0px; left: 0px; height: 285px; width: 800px;
                                            border: 0px solid;" align="left">
                                            <asp:DataGrid CssClass="grid" BackColor="#f4fbfd" Style="height: auto" ID="gvRebate"
                                                Width="785px" GridLines="both" runat="server" AutoGenerateColumns="false" UseAccessibleHeader="true"
                                                AllowSorting="True" ShowFooter="true" TabIndex="9" DataKeyField="" OnItemDataBound="gvRebate_ItemDataBound"
                                                OnSortCommand="gvRebate_SortCommand" OnItemCommand="gvRebate_ItemCommand">
                                                <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                <ItemStyle CssClass="GridItem" />
                                                <AlternatingItemStyle CssClass="zebra Left5pxPadd" />
                                                <FooterStyle CssClass="lightBlueBg" Font-Bold="true" ForeColor="#003366" VerticalAlign="Middle"
                                                    HorizontalAlign="Right" />
                                                <Columns>
                                                    <asp:TemplateColumn>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnkEdit" Text="Edit" OnClientClick="javascript:document.getElementById('hidScrollTop').value =document.getElementById('div-datagrid').scrollTop;"
                                                                CommandName="Edits" CausesValidation="false" ForeColor="green" runat="server"
                                                                Font-Bold="true"></asp:LinkButton>
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <asp:LinkButton ID="lnkUpdate" runat="server" Font-Bold="true" Text="Update" CommandName="Update"
                                                                CausesValidation="false" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.SalesID") %>'
                                                                ForeColor="green"></asp:LinkButton>
                                                            <asp:LinkButton ID="lnkCancel" Text="Cancel" Font-Bold="true" CausesValidation="false"
                                                                CommandName="Cancel" ForeColor="Red" runat="server"></asp:LinkButton>
                                                        </EditItemTemplate>
                                                        <ItemStyle Width="100px" HorizontalAlign="Center" />
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderText="Category" SortExpression="Category">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblCategory" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.Category" ) %>'></asp:Label>
                                                            <asp:HiddenField ID="hidSalesID" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.SalesID") %>' />
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <asp:DropDownList ID="ddlCategory" CssClass="FormCtrls" Width="80px" runat="server"
                                                                onchange="javascript:GetSalesHist(this.id);" TabIndex="7">
                                                            </asp:DropDownList>
                                                            <asp:Label ID="lblECategory" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.Category" ) %>'>
                                                            </asp:Label>
                                                            <asp:HiddenField ID="hidESalesID" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.SalesID") %>' />
                                                            <%-- <asp:RequiredFieldValidator ID="rfvCategory" runat="server" ControlToValidate="ddlCategory"
                                                                Display="Dynamic" ErrorMessage=" *Required">*</asp:RequiredFieldValidator>--%>
                                                        </EditItemTemplate>
                                                        <ItemStyle Width="80px" />
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderText="Description">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblDescription" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.Description") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <asp:Label ID="lblEDescription" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.Description") %>'></asp:Label>
                                                        </EditItemTemplate>
                                                        <ItemStyle Width="285px" />
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderText="History $" SortExpression="SalesHistory">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblHistory" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.SalesHistory","{0:#,##0.00}") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <asp:Label ID="lblEHistory" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.SalesHistory","{0:#,##0.00}") %>'></asp:Label>
                                                            <asp:HiddenField ID="hidHistory" runat="server" Value='<%# DataBinder.Eval(Container,"DataItem.SalesHistory","{0:###0.00}") %>'>
                                                            </asp:HiddenField>
                                                        </EditItemTemplate>
                                                        <ItemStyle Width="100px" HorizontalAlign="Right" />
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderText="BaseLine $" SortExpression="SalesBaseline">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblBaseLine" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.SalesBaseline","{0:#,##0.00}") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <asp:TextBox ID="txtBaseLine" CssClass="FormCtrl" Text='<%# DataBinder.Eval(Container,"DataItem.SalesBaseline","{0:###0.00}") %>'
                                                                Enabled="false" onblur="javascript:ValidateLine(this.id);" TabIndex="8" MaxLength="12"
                                                                runat="server" Width="90px" Style="text-align: right" onkeypress="javascript:ValdateNumberWithDot(this.value);">
                                                            </asp:TextBox></EditItemTemplate>
                                                        <ItemStyle Width="100px" HorizontalAlign="Right" />
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderText="Goal $" SortExpression="SalesGoal">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblGoal" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.SalesGoal","{0:#,##0.00}") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <asp:TextBox ID="txtGoal" Text='<%# DataBinder.Eval(Container,"DataItem.SalesGoal","{0:0.00}") %>'
                                                                CssClass="FormCtrl" Width="90px" runat="server" MaxLength="12" Style="text-align: right"
                                                                onkeypress="javascript:ValdateNumberWithDot(this.value);" TabIndex="9">
                                                            </asp:TextBox></EditItemTemplate>
                                                        <ItemStyle Width="100px" HorizontalAlign="Right" />
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderText="Rebate %" SortExpression="RebatePct">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblRebate" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.RebatePct","{0:#,##0.00}") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <asp:TextBox ID="txtRebate" CssClass="FormCtrl" Text='<%# DataBinder.Eval(Container,"DataItem.RebatePct") %>'
                                                                Width="90px" runat="server" MaxLength="12" Style="text-align: right" onkeypress="javascript:ValdateNumberWithDot(this.value);"
                                                                TabIndex="10">
                                                            </asp:TextBox></EditItemTemplate>
                                                        <ItemStyle Width="100px" HorizontalAlign="Right" />
                                                    </asp:TemplateColumn>
                                                </Columns>
                                            </asp:DataGrid>
                                            <input type="hidden" id="hidSort" runat="server" />
                                            <input type="hidden" id="hidErrorStatus" runat="server" />
                                            <asp:HiddenField ID="hidDelete" runat="server" />
                                            <asp:HiddenField ID="hidProgramName" runat="server" />
                                            <asp:HiddenField ID="hidCustName" runat="server" />
                                            <asp:HiddenField ID="hidCustChain" runat="server" />
                                            <asp:HiddenField ID="hidStDate" runat="server" />
                                            <asp:HiddenField ID="hidEndDate" runat="server" />
                                            <asp:HiddenField ID="hidScrollTop" runat="server" />
                                            <asp:Button ID="btnDelete" runat="server" Style="display: none;" CausesValidation="false"
                                                OnClick="btnDelete_Click" />
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="BluBg buttonBar" height="20px" style="width: 930px" width="45%">
                    <table>
                        <tr>
                            <td width="40%">
                                <asp:UpdatePanel ID="upMessage" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <table width="100%" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="padding-left: 5px;" align="left" width="89%">
                                                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="true">
                                                        <ProgressTemplate>
                                                            <span class="TabHead">Loading...</span></ProgressTemplate>
                                                    </asp:UpdateProgress>
                                                    <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td style="width: 45%; height: 5px">
                            </td>
                            <td style="width: 15%; height: 5px" align="right">
                                <asp:UpdatePanel ID="upAdd" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <table width="50%">
                                            <tr>
                                                <td style="height: 26px">
                                                    <img id="btnHelp" src="../Common/Images/help.gif" tabindex="12" />
                                                </td>
                                                <td style="height: 26px">
                                                    <asp:ImageButton ID="btnAdd" ImageUrl="~/PreferredPartnerRebate/Common/images/btn_addline.gif"
                                                        runat="server" TabIndex="11" OnClick="btnAdd_Click" />
                                                </td>
                                                <td style="height: 26px">
                                                    <img id="btnClose" src="Common/images/close.jpg" onclick="javascript:window.close();"
                                                        tabindex="14" />
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
                <td style="width: 1253px">
                    <uc2:Footer ID="Footer1" runat="server" Title="Preferred Partner Rebate" />
                </td>
            </tr>
        </table>
        <div id="divDelete" class="MarkItUp_ContextMenu_MenuTable" style="display: none;
            word-break: keep-all; position: absolute;">
            <table border="0" cellpadding="0" cellspacing="0" class="MarkItUp_ContextMenu_Outline"
                width="100">
                <tr>
                    <td>
                        <table border="0" cellspacing="0" width="100">
                            <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                onmouseover="this.className='GridHead'">
                                <td class="" width="20">
                                    <img src="Common/Images/delete.jpg" /></td>
                                <td align="left" class="" style="cursor: hand;" onclick="Javascript:return CallBtnClick('btnDelete');">
                                    <strong>Delete</strong></td>
                            </tr>
                            <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                onmouseover="this.className='GridHead'">
                                <td class="" width="20">
                                    <img src="Common/Images/cancelrequest.gif" /></td>
                                <td align="left" class="" style="cursor: hand;" onclick="Javascript:document.getElementById('divDelete').style.display='none';document.getElementById(hidRowID.value).style.fontWeight='normal';">
                                    <strong>Cancel</strong><input type="hidden" value="" id="hidRowID" /></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </form>
   </body>
</html>
