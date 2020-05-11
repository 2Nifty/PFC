<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TradingPartner.aspx.cs" Inherits="Partner" %>

<%@ Register Src="~/EDITradingPartners/UserControl/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="~/EDITradingPartners/UserControl/Footer.ascx" TagName="BottomFooter"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>EDI Trading Partner</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
    function GetTradingInformation(TradingID,CustNo)
    {
  
        document.getElementById("hidCustNo").value=CustNo;
        document.getElementById("hidTradingID").value=TradingID;
        document.getElementById("hidLeftFrameBindMode").value="Click";     
        document.getElementById("ibtnSearch").click();   
   }   
   
   function CheckCustomerNo(ctrlValue)
   {
        //   alert(ctrlValue);
        //   Partner.CheckCustomerNumber(ctrlValue);
        ////   alert();
        //   if(check)
        //   return true;
        //   else
        //   return false;
   }
    </script>
<script>

function ShowDetail(ctrlID)
{
    xstooltip_show('divToolTips',ctrlID);
    return false;
}

function xstooltip_show(tooltipId, parentId) 
{ 

    it = document.getElementById(tooltipId); 

    // need to fixate default size (MSIE problem) 
    img = document.getElementById(parentId); 
     
    x = xstooltip_findPosX(img); 
    y = xstooltip_findPosY(img); 
    
    if(y<469)
        it.style.top =  (y+15) + 'px'; 
    else
        it.style.top =  (y-50) + 'px'; 
        
    it.style.left =(x+10)+ 'px';

    // Show the tag in the position
      it.style.display = '';
 
}

function xstooltip_findPosY(obj) 
{
    var curtop = 0;
    if (obj.offsetParent) 
    {
        while (obj.offsetParent) 
        {
            curtop += obj.offsetTop
            obj = obj.offsetParent;
        }
    }
    else if (obj.y)
        curtop += obj.y;
    return curtop;
}


function xstooltip_findPosX(obj) 
{
  var curleft = 0;
  if (obj.offsetParent) 
  {
    while (obj.offsetParent) 
        {
            curleft += obj.offsetLeft
            obj = obj.offsetParent;
        }
    }
    else if (obj.x)
        curleft += obj.x;
    return curleft;
}
</script>
</head>
<body  scroll=no onclick="javascript:document.getElementById('lblMessage').innerText='';" onmouseup="divToolTips.style.display='none';"
    onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" UpdateMode="conditional" runat="server">
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
                                    <td>
                                        <asp:ImageButton runat="server" ID="ibtnAdd" ImageUrl="~/EmployeeData/Common/images/newadd.gif"
                                            ImageAlign="right" CausesValidation="false" OnClick="ibtnAdd_Click" />
                                    </td>
                                    <td style="padding-right: 10px">
                                        <img id="imgHelp" src="images/help.gif" runat="server" align="right" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr width="28%">
                        <td class="PageHead " valign="middle" style="height: 35px; padding-left: 10px;">
                            <asp:Label ID="Label1" runat="server" CssClass="DarkBluText" Text="EDI Trading Partners"> </asp:Label>
                            <asp:Button ID="ibtnSearch" Style="display: none;" runat="server" Width="20px" CausesValidation="false"
                                OnClick="ibtnSearch_Click" Text="Button" /></td>
                        <td class="PageHead " rowspan="1" style="height: 35px; padding-left: 10px;">
                            <asp:Label ID="Label2" runat="server" CssClass="BannerText" Text="Enter Partner Information"></asp:Label></td>
                    </tr>
                    <tr width="28%">
                        <td valign="top">
                            <asp:Panel ID="pnlSearch" runat="server" Height="30px" DefaultButton="ibtnSearchByButton">
                                <table cellpadding="0" cellspacing="0" border="0" class="Search BlueBorder" width="100%">
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt boldText">
                                            <asp:DropDownList ID="ddlSearch" runat="server" Width="120px" CssClass="FormCtrl">
                                                <asp:ListItem Text="Customer Number" Selected="True" Value="LocationCustomerNo"></asp:ListItem>
                                                <asp:ListItem Text="Vendor Number" Value="AssignedVendorNo"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtSearch" runat="server" Width="120px" MaxLength="40" TabIndex="6"
                                                CssClass="FormCtrl"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:ImageButton runat="server" ID="ibtnSearchByButton" ImageUrl="~/EmployeeData/Common/images/lens.gif"
                                                ImageAlign="Left" TabIndex="7" CausesValidation="false" Width="20px" OnClick="ibtnSearchByButton_Click" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </td>
                        <td rowspan="3" valign="top">
                            <asp:UpdatePanel ID="upnlData" UpdateMode="conditional" runat="server">
                                <ContentTemplate>
                                    <div id="divEmployee" runat="server">
                                        <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr class="DarkBluTxt boldText">
                                                            <td valign="top" align=left style="padding-left: 10px; padding-top: 25px; width: 321px;">
                                                                <table cellpadding="2" cellspacing="0" border="0">
                                                                    <tr>
                                                                        <td class="DarkBluTxt boldText"  width="110">                                                                            
                                                                              <asp:LinkButton ID="lnkCustNo"  CssClass="DarkBluTxt boldText" runat="server" Font-Underline="true" Text="Customer Number"  ></asp:LinkButton>
                                                                            </td>
                                                                            <td >                                                                              
                                                                                <div id="divToolTips" class="list" style="display: none; position: absolute;" onmouseup="return false;">
                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td>
                                                                                                <span class="boldText">Change ID: </span>
                                                                                                <asp:Label ID="lblChangeID" runat="server"  Font-Bold="false"></asp:Label></td>
                                                                                            <td>
                                                                                                <span class="boldText" style="padding-left: 5px;">Change Date: </span>
                                                                                                <asp:Label ID="lblChangeDate" runat="server"  Font-Bold="false"></asp:Label></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <span class="boldText">Entry ID: </span>
                                                                                                <asp:Label ID="lblEntryID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                                            <td>
                                                                                                <span class="boldText" style="padding-left: 5px;">Entry Date: </span>
                                                                                                <asp:Label ID="lblEntryDate" runat="server"  Font-Bold="false"></asp:Label></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </div>
                                                                            </td> 
                                                                        <td>
                                                                            <asp:TextBox TabIndex="1" AutoPostBack="true" onfocus="javascript:this.select();"
                                                                                ID="txtCustNo" CssClass="FormCtrl" runat="server" OnTextChanged="txtCustNo_TextChanged"></asp:TextBox><asp:RequiredFieldValidator
                                                                                    ControlToValidate="txtCustNo" ID="RequiredFieldValidator1" runat="server">*</asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="DarkBluTxt boldText">
                                                                        </td>
                                                                        <td colspan="2" style="padding-left: 8px">
                                                                            <asp:Label ID="lblCustName" runat="server" Text="Label" Font-Bold="False"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="DarkBluTxt boldText">
                                                                        </td>
                                                                        <td colspan="2" style="padding-left: 8px">
                                                                            <asp:Label ID="lblAddress" runat="server" Text="Label" Font-Bold="False"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="DarkBluTxt boldText">
                                                                        </td>
                                                                        <td colspan="2" style="padding-left: 8px">
                                                                            <asp:Label ID="lblCity" runat="server" Text="Label" Font-Bold="False"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="DarkBluTxt boldText">
                                                                        </td>
                                                                        <td colspan="2" style="padding-left: 8px">
                                                                            <asp:Label ID="lblPhone" runat="server" Text="Label" Font-Bold="False"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td valign="top" style="padding-top: 25px;" rowspan="2" >
                                                                <table cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td valign="top" style="padding-left: 10px; width: 116px;">
                                                                            <asp:Label ID="Label6" runat="server" Text="EDI Trading Code " Width="100px"></asp:Label>
                                                                        </td>
                                                                        <td valign="top" style="padding-left: 10px;">
                                                                            <asp:DropDownList CssClass="FormCtrl" TabIndex="2" ID="ddlTradingCode" Width="160px"
                                                                                runat="server">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td valign="top" style="padding-left: 10px; padding-top: 20px; width: 116px;">
                                                                            <asp:Label ID="Label3" runat="server" Text="EDI Trading Type " Width="100px"></asp:Label>
                                                                        </td>
                                                                        <td valign="top" style="padding-left: 10px; padding-top: 20px">
                                                                            <asp:DropDownList CssClass="FormCtrl" TabIndex="3" Width="160px" ID="ddlTradingType"
                                                                                runat="server">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td valign="top" style="padding-left: 10px; padding-top: 20px; height: 58px; width: 116px;">
                                                                            <asp:Label ID="Label4" runat="server" Text="Assigned Vendor No " Width="130px"></asp:Label>
                                                                        </td>
                                                                        <td valign="top" style="padding-left: 10px; padding-top: 20px; height: 58px;">
                                                                            <asp:TextBox Width="150px" CssClass="FormCtrl" TabIndex="4" ID="txtAssignedVendNo"
                                                                                runat="server"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtAssignedVendNo"
                                                                                runat="server">*</asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                        <tr>
                                                            <td style="padding-left: 10px; padding-bottom: 5px;" colspan="3">
                                                                <table cellpadding="2" cellspacing="0" border="0" class="Left2pxPadd">
                                                                    <tr class="DarkBluTxt boldText">
                                                                        <td style="width: 115px">
                                                                            <asp:Label ID="Label5" runat="server" Text="Customer Email" Width="100px"></asp:Label>
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtEmail" runat="server" Width="340px" CssClass="FormCtrl" MaxLength="50"
                                                                                TabIndex="5"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="rfvDescription" runat="server" Display="dynamic"
                                                                                ControlToValidate="txtEmail">*</asp:RequiredFieldValidator>
                                                                            <asp:RegularExpressionValidator ControlToValidate="txtEmail" ID="RegularExpressionValidator1"
                                                                                ErrorMessage="Invalid Email Format" runat="server" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 321px">
                                                            </td>
                                                        </tr>
                                                    </table>                                                
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" width="28%" class="BlueBorder">
                            <asp:UpdatePanel ID="upnlMenu" UpdateMode="conditional" runat="server">
                                <ContentTemplate>
                                    <table id="LeftMenu" width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr valign="top">
                                            <td width="97%" valign="top">
                                                <div style="overflow-y: auto; overflow-x: auto; height: 445px; position: relative;
                                                    width: 300px" class="Sbar">
                                                    <asp:TreeView ID="MenuFrameTV" runat="server" Width="280px" ExpandDepth="0" ExpandImageToolTip="Expand"
                                                        CollapseImageToolTip="Collapse">
                                                        <RootNodeStyle CssClass=" DarkBluTxt boldText LeafStyle" />
                                                        <HoverNodeStyle BackColor="#E0F0FF" />
                                                        <LeafNodeStyle CssClass="Left2pxPadd DarkBluTxt boldText LeafStyle" VerticalPadding="2px" />
                                                        <ParentNodeStyle CssClass=" DarkBluTxt boldText" />
                                                        <SelectedNodeStyle BackColor="#E0F0FF" />
                                                    </asp:TreeView>
                                                    <asp:HiddenField ID="HiddenField2" runat="server" />
                                                </div>
                                                <asp:HiddenField ID="hidLeftFrameBindMode" runat="server" />
                                                <asp:HiddenField ID="hidCustNo" runat="server" />
                                                <asp:HiddenField ID="hidTradingID" runat="server" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:HiddenField ID="hidUser" runat="server" />
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
                                        <asp:UpdateProgress ID="upPanel" runat="server" DisplayAfter="1" DynamicLayout="false">
                                            <ProgressTemplate>
                                                <span style="padding-left: 5px; font-weight: bold; color: Red;">Loading...</span>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:UpdatePanel ID="upnlMessage" runat="server" UpdateMode="conditional">
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
                            <table cellpadding="0" cellspacing="0" style="margin-top: 5px;">
                                <tr>
                                    <td width="70%">
                                        <asp:HiddenField ID="HiddenField1" runat="server" />
                                    </td>
                                    <td style="padding-right: 5px; height: 28px" valign="top">
                                        <asp:ImageButton runat="server" ID="ibtnDelete" ImageUrl="~/EDITradingPartners/images/btndelete.gif"
                                            ImageAlign="left " CausesValidation="false" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                            OnClick="ibtnDelete_Click" />
                                    </td>
                                    <td align="right" style="padding-right: 5px; height: 28px;" valign="top">
                                        <asp:ImageButton runat="server" ID="ibtnSave" ImageUrl="~/EDITradingPartners/images/BtnSave.gif"
                                            ValidationGroup="EmpData" ImageAlign="Right" CausesValidation="true" OnClick="ibtnSave_Click" />
                                    </td>
                                    <td width="70" style="padding-right: 3px; height: 28px;" valign="top">
                                        <img id="btnClose" src="../Common/Images/Close.gif" onclick="javascript:window.close();"
                                            runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" valign="top">
                            <table width="100%">
                                <uc2:BottomFooter ID="ucFooter" Title="EDI Trading Partners" runat="server" />
                            </table>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>
