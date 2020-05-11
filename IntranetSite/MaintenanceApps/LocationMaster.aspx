<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="true" CodeFile="LocationMaster.aspx.cs"
    Inherits="LocationMasterPage" %>

<%@ Register Src="Common/UserControls/Printer.ascx" TagName="Printer" TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/Warehouse.ascx" TagName="Warehouse" TagPrefix="uc4" %>
<%@ Register Src="Common/UserControls/Option.ascx" TagName="Option" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Location Master</title>
    <link href="Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />

    <script src="Common/javascript/Common.js" type="text/javascript"></script>

    <script>
    function SetAddMode()
    {
        var status = confirm("Would you like to create a new Location?");
        if(status)
            return true;
        else
            return false;
    }

    function CheckMandatory()
    {
        if( document.getElementById("txtSearchName").value.replace(/\s/g,'') != "" &&  document.getElementById("txtSearchCode").value.replace(/\s/g,'')  != "" )
          {
          var status = confirm("Would you like to create a new location?");
                if(status)
                    return true;
                else
                    return false;
          }
          else
          {
        
        alert("Location Name and Location ID are mandatory");
        return false;
        }
    }

    var hid='';

    function ShowToolTip(event,ctlVal,ctlID)
    {   
        Hide();
        document.getElementById('hidFMode').value=ctlVal;
        switch(ctlVal)
        {
            case 'phone':
                document.getElementById('txtFormat').value= document.getElementById('hidPhone').value;
                document.getElementById('lblMode').innerHTML="Phone Format";
                xstooltip_show('divToolTip',ctlID);
            break;
            case 'postcode':
                document.getElementById('txtFormat').value= document.getElementById('hidPostalCode').value;
                document.getElementById('lblMode').innerHTML= "PostCode Format";
                xstooltip_show('divToolTip',ctlID);
            break;
            case 'email':
                document.getElementById('txtLocEmail').value= document.getElementById('hidLocEmail').value;
                document.getElementById('txtBOEmail').value= document.getElementById('hidBOEmail').value;
                document.getElementById('txtBigQuoteEmail').value= document.getElementById('hidBigQuoteEmail').value;
                document.getElementById('txtRGAEmail').value= document.getElementById('hidRGAEmail').value;
                xstooltip_show('divToolTipEmail',ctlID);
            break;
            case 'ship':
                ddlSelectedValue('ddlShpBr1',document.getElementById('hidShipFrom1').value);
                ddlSelectedValue('ddlShpBr2',document.getElementById('hidShipFrom2').value);
                ddlSelectedValue('ddlShpBr3',document.getElementById('hidShipFrom3').value);
                ddlSelectedValue('ddlShpBr4',document.getElementById('hidShipFrom4').value);
                xstooltip_show('divToolTipShip',ctlID);
            break;
        }
        return false;
    }
    
    function ddlSelectedValue(ddlName,value)
    {
        for (var i=0; i<document.getElementById(ddlName).options.length; ++i)
        {
          if (document.getElementById(ddlName).options[i].value == value)
          {
            document.getElementById(ddlName).options[i].selected = true;
            break;
          }
        }
    }
    
    function Hide()
    {
        var mode = document.getElementById('hidFMode').value;
        switch(mode)
        {
            case 'email':
                it = document.getElementById('divToolTipEmail');
            break;
            case 'ship':
                it = document.getElementById('divToolTipShip');
            break;
            default:
                it = document.getElementById('divToolTip'); 
        }
            
            
//        if (document.getElementById('hidFMode').value == 'email')
//        {
//            it = document.getElementById('divToolTipEmail'); 
//        }
//        else
//        {
//            if (document.getElementById('hidFMode').value == 'ship')
//            {
//                it = document.getElementById('divToolTipShip'); 
//            }
//            else
//            {
//                it = document.getElementById('divToolTip');
//            }
//        }
        
        it.style.display = 'none'; 
    }
  
    function SetVisible()
    {
        hid='true';
    }

    function xstooltip_show(tooltipId, parentId) 
    { 
        it = document.getElementById(tooltipId); 

        // need to fixate default size (MSIE problem) 
        img = document.getElementById(parentId); 
         
        x = xstooltip_findPosX(img); 
        y = xstooltip_findPosY(img); 
        
        if(y<469)
        {
            it.style.top = (y+15) + 'px'; 
        }
        else
        {
            it.style.top = (y-50) + 'px'; 
        }
        
        if(tooltipId=='divToolTipShip')
        {
            it.style.left = (x-200)+ 'px';
        }
        else
        {
            it.style.left = (x+30)+ 'px';
        }
        
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
    
    function ValdateFormat()
    {
        if(!(event.keyCode == 45 ||event.keyCode == 35 || event.keyCode == 32 || event.keyCode == 40 || event.keyCode==41))
                event.keyCode=0;
    }

    function GetFormattedValue(mode)
    {
           var locid=document.getElementById('txtSearchCode').value;
           var hidph= document.getElementById('hidPhone').value;
           var hidpc= document.getElementById('hidPostalCode').value;
           var valph= document.getElementById('txtPhone').value;
           var valpc= document.getElementById('txtPostalCode').value;
           if(mode=='phone')
           {
             document.getElementById('txtFormat').value= document.getElementById('hidPhone').value;
             if(document.getElementById('hidPhone').value !="")
             {
                var formattedValue= LocationMasterPage.GetFormattedValue(hidph,valph,mode,locid).value;
                document.getElementById('txtPhone').value =formattedValue;
             }
           }
           else if(mode=='postcode' && hidpc!="")   
           {
             var formattedValue= LocationMasterPage.GetFormattedValue(hidpc,valpc,mode,locid).value;
             document.getElementById('txtPostalCode').value =formattedValue;
           }              
           return false;
    }

    </script>

</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="frmCarrierCode" runat="server">
        <asp:ScriptManager runat="server" ID="smCarrierCode">
        </asp:ScriptManager>
        <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse;"
            id="mainTable">
            <tr>
                <td height="5%" id="tdHeaders" colspan="2">
                    <uc1:Header ID="HeaderID" runat="server" />
                </td>
            </tr>
            <tr class="PageHead shadeBgDown">
                <td class="Left2pxPadd DarkBluTxt boldText blueBorder shadeBgDown" width="12%">
                    <asp:UpdatePanel ID="upnlbtnSearch" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <table height="25" width="100%" style="padding-left: 0px;">
                                <tr id="trsearchText" runat="server">
                                    <td>
                                        <asp:Label ID="lblSch" ForeColor="#CC0000" runat="server" Text="Search by :"></asp:Label>
                                    </td>
                                    <td align="right">
                                        <asp:Label ID="lblLocationName" runat="server" Text="Location Name" Width="100px"></asp:Label>
                                    </td>
                                    <td style="width: 100px">
                                        <asp:TextBox ID="txtSearchName" Text="" CssClass="FormCtrl" runat="server" AutoCompleteType="disabled"
                                            MaxLength="30" Width="150px"></asp:TextBox>
                                    </td>
                                    <td width="140" align="right">
                                        <asp:Label ID="lblOr" runat="server" ForeColor="#CC0000" Text=" -or- " Width="30px"></asp:Label>
                                        <asp:Label ID="lblLocationID" runat="server" Text="Location ID" Width="90px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtSearchCode" CssClass="FormCtrl" onkeypress="javascript:ValdateNumber();"
                                            runat="server" AutoCompleteType="disabled" MaxLength="4" Width="150px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:ImageButton ID="SearchButton" runat="server" ImageUrl="~/MaintenanceApps/Common/images/Search.jpg"
                                            CausesValidation="false" OnClick="SearchButton_Click" />
                                    </td>
                                    <td align="right" style="padding-right: 5px;" width="28%">
                                        <img id="imgClose" src="Common/images/close.jpg" onclick="javascript:Hide();window.close();" />
                                        <asp:ImageButton ID="btnTopAdd" runat="server" ImageUrl="common/Images/newAdd.gif"
                                            CausesValidation="false" OnClientClick="javascript:Hide(); return CheckMandatory();"
                                            OnClick="btnTopAdd_Click" />
                                    </td>
                                </tr>
                                <tr id="trsearchLabel" runat="server" style="display: none;">
                                    <td colspan="3" align="left" width="30%">
                                        <asp:Label ID="Label1" runat="server" Text="Location Name"></asp:Label>
                                        <asp:Label ID="lblSearchName" runat="server" Text=""></asp:Label>
                                    </td>
                                    <td colspan="4" align="left">
                                        <asp:Label ID="Label2" runat="server" Text="Location ID"></asp:Label><asp:Label ID="lblSearchCode"
                                            runat="server" Text=""></asp:Label>
                                    </td>
                                    <td align="right" style="padding-right: 6px;">
                                        <img src="Common/images/close.jpg" onclick="javascript:Hide();window.close();" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="padding-top: 0px; padding-left: 0px;" colspan="2" width="100%">
                    <asp:UpdatePanel ID="pnlContent" UpdateMode="Conditional" runat="server">
                        <ContentTemplate>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="lightBlueBg" width="50%">
                                        <span class="BanText" style="padding-left: 0px; color: #CC0000">Address Information</span>
                                    </td>
                                    <td class="lightBlueBg" width="50%">
                                        <table width="100%" border="0">
                                            <tr>
                                                <td>
                                                    <span class="BanText" style="padding-left: 5px; color: #CC0000">Contact Information</span>
                                                </td>
                                                <td align="right">
                                                    <asp:UpdatePanel ID="pnlAdd" UpdateMode="Conditional" runat="server">
                                                        <ContentTemplate>
                                                            <table border="0px" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td>
                                                                        <asp:ImageButton ID="btnSave" Visible="false" CausesValidation="true" runat="server"
                                                                            OnClientClick="javascript:Hide();" ImageUrl="common/Images/BtnSave.gif" OnClick="SaveButton_Click" />
                                                                        <%-- <img id="iClose" runat="server" src="Common/images/close.jpg" onclick="javascript:window.close();" />--%>
                                                                        <%-- <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="Common/images/close.jpg"
                                                                            CausesValidation="false"   OnClick="AddButton_Click" /> --%>
                                                                        <asp:ImageButton ID="AddButton" runat="server" ImageUrl="common/Images/cancel.png"
                                                                            CausesValidation="false" OnClientClick="javascript:Hide();" OnClick="AddButton_Click" />
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
                                    <td style="border-right: solid 1px #c9c6c6; padding-bottom: 5px;" width="50%">
                                        <asp:Panel ID="pnlAddress" runat="server">
                                            <table>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" width="13%">
                                                        Address 1</td>
                                                    <td colspan="5" class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtAddress1" MaxLength="40" TabIndex="2"
                                                            Width="247"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        Address 2</td>
                                                    <td colspan="5" class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtAddress2" MaxLength="40" TabIndex="3"
                                                            Width="247"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        City</td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtCity" MaxLength="20" TabIndex="4"></asp:TextBox>
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        State</td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <asp:DropDownList Width="80" Height="20px" ID="ddlState" CssClass="FormCtrl" TabIndex="5"
                                                            runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        <asp:HiddenField ID="hidPostalCode" runat="server" />
                                                        <asp:Label ID="lnkPostalCode" Style="cursor: hand;" runat="server" Font-Underline="true"> Postcode</asp:Label>
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <asp:TextBox CssClass="FormCtrl" onkeypress="javascript:ValdateNumber();" onblur="javascript:GetFormattedValue('postcode');"
                                                            runat="server" ID="txtPostalCode" Width="90px" MaxLength="14" TabIndex="6"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        Country</td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <asp:DropDownList Width="125" ID="ddlCountry" Height="20px" TabIndex="7" CssClass="FormCtrl"
                                                            runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td colspan="2">
                                                        <table cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                                    Time Zone</td>
                                                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                                    <asp:DropDownList Width="50" ID="ddlTimeZone" Height="20px" TabIndex="8" CssClass="FormCtrl"
                                                                        runat="server">
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td colspan="2">
                                                        <table cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                                    Server Time Zone</td>
                                                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                                    <asp:DropDownList Width="50" ID="ddlServerTimeZone" Height="20px" TabIndex="9" CssClass="FormCtrl"
                                                                        runat="server">
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                    <td>
                                        <table>
                                            <tr>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Name</td>
                                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" width="70">
                                                    <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtName" MaxLength="30" TabIndex="10"
                                                        Width="270"></asp:TextBox>
                                                </td>
                                                <td align="left">
                                                    <table cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td class="DarkBluTxt boldText">
                                                                Branch Sort</td>
                                                            <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-left: 12px">
                                                                <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtBranchSort" onkeypress="javascript:ValdateNumber();"
                                                                    MaxLength="8" Width="65px" TabIndex="11"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">
                                                    <table cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td class="Left2pxPadd DarkBluTxt boldText">
                                                                <asp:HiddenField ID="hidPhone" runat="server" />
                                                                <asp:Label ID="lnkPhone" runat="server" Style="cursor: hand;" Width="38px" Font-Underline="true">Phone</asp:Label>
                                                            </td>
                                                            <td class="splitBorder_r_h">
                                                                <asp:TextBox CssClass="FormCtrl" runat="server" onblur="javascript:GetFormattedValue('phone');"
                                                                    onkeypress="javascript:ValdateNumber();" ID="txtPhone" MaxLength="14" TabIndex="11"
                                                                    Width="117px"></asp:TextBox>
                                                            </td>
                                                            <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                                                Fax</td>
                                                            <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                                <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtFax" MaxLength="14" Width="115px"
                                                                    TabIndex="13"></asp:TextBox>
                                                            </td>
                                                            <td class="Left2pxPadd DarkBluTxt boldText">
                                                                Branch Color</td>
                                                            <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                                <asp:DropDownList ID="ddlColor" Height="20px" TabIndex="14" Width="70px" CssClass="FormCtrl"
                                                                    runat="server">
                                                                </asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">
                                                    <table cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td class="Left2pxPadd Right2pxPadd DarkBluTxt boldText">
                                                                <asp:HiddenField ID="hidLocEmail" runat="server" />
                                                                <asp:HiddenField ID="hidBOEmail" runat="server" />
                                                                <asp:HiddenField ID="hidBigQuoteEmail" runat="server" />
                                                                <asp:HiddenField ID="hidRGAEmail" runat="server" />
                                                                <asp:Label ID="lnkEmail" runat="server" Style="cursor: hand;" Font-Underline="true">Email</asp:Label>
                                                            </td>
                                                            <td colspan="3" class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                                <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtEmail" MaxLength="50" TabIndex="15"
                                                                    Width="269px"></asp:TextBox>
                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" SetFocusOnError="true"
                                                                    ControlToValidate="txtEmail" Display="Dynamic" ErrorMessage="* Invalid" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                                            </td>
                                                            <td class="Left2pxPadd DarkBluTxt boldText">
                                                                Hub Sort</td>
                                                            <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="padding-left: 28px">
                                                                <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtHubSort" MaxLength="10" TabIndex="16"
                                                                    Width="65"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Type</td>
                                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" colspan="2">
                                                    <%--<asp:TextBox CssClass="FormCtrl" runat="server" ID="txtType" MaxLength="15" TabIndex="5"></asp:TextBox>--%>
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td class="">
                                                                <asp:DropDownList ID="ddlType" Height="20px" TabIndex="17" CssClass="FormCtrl" runat="server">
                                                                </asp:DropDownList>
                                                            </td>
                                                            <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px">
                                                                Warehouse</td>
                                                            <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                                <asp:DropDownList ID="ddlWarehouse" Height="20px" TabIndex="18" CssClass="FormCtrl"
                                                                    runat="server" Width="105px">
                                                                </asp:DropDownList>
                                                            </td>
                                                            <td class="Left2pxPadd DarkBluTxt boldText">
                                                                <asp:HiddenField ID="hidShipFrom1" runat="server" />
                                                                <asp:HiddenField ID="hidShipFrom2" runat="server" />
                                                                <asp:HiddenField ID="hidShipFrom3" runat="server" />
                                                                <asp:HiddenField ID="hidShipFrom4" runat="server" />
                                                                <asp:Label ID="lnkShipFrom" runat="server" Style="cursor: hand;" Font-Underline="true"
                                                                    TabIndex="19">Ship From Support</asp:Label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:UpdatePanel ID="pnlLink" UpdateMode="Conditional" runat="server">
                        <ContentTemplate>
                            <table cellpadding="0" cellspacing="0" width="100%">
                                <tr runat="server" id="tblLink" style="display: none;">
                                    <td class="lightBlueBg" style="padding-left: 20px;" colspan="2" height="25" nowrap="nowrap">
                                        <table width="30%" class="DarkBluTxt boldText">
                                            <tr>
                                                <td>
                                                    <asp:LinkButton ID="lnkPrinters" runat="server" CausesValidation="false" OnClick="lnkOptions_Click">Default Printers</asp:LinkButton></td>
                                                <td>
                                                    <asp:LinkButton ID="lnkOptions" runat="server" CausesValidation="false" OnClick="lnkOptions_Click">Options</asp:LinkButton></td>
                                                <td>
                                                    <asp:LinkButton ID="lnkWarehouse" runat="server" CausesValidation="false" OnClick="lnkOptions_Click">&nbsp;&nbsp;&nbsp;Warehouse Options</asp:LinkButton></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr runat="server" id="tdHeader">
                                    <td colspan="2" class="lightBlueBg" nowrap="nowrap">
                                        <asp:Label ID="lblHeader" CssClass="BanText" runat="server" Text="Locations"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" height="350px" valign="top">
                    <table cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td colspan="2" valign="top">
                                <asp:UpdatePanel ID="pnlLocationGrid" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div runat="server" id="tdLocation" visible="true">
                                            <div id="div-datagrid" class="Sbar" align="center" style="overflow-x: hidden; overflow-y: auto;
                                                position: relative; top: 0px; left: 0px; height: 350px; width: 850px; border: 0px solid;
                                                vertical-align: top;">
                                                <asp:DataGrid ID="dgLocation" Width="99%" runat="server" GridLines="both" BorderWidth="1px"
                                                    TabIndex="-1" ShowFooter="false" AllowSorting="true" CssClass="grid" Style="height: auto"
                                                    UseAccessibleHeader="true" AutoGenerateColumns="false" BorderColor="#DAEEEF"
                                                    PagerStyle-Visible="false" OnItemDataBound="dgLocation_ItemDataBound" OnSortCommand="dgLocation_SortCommand"
                                                    OnItemCommand="dgLocation_ItemCommand">
                                                    <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                    <ItemStyle CssClass="GridItem" />
                                                    <AlternatingItemStyle CssClass="zebra" />
                                                    <FooterStyle CssClass="lightBlueBg" />
                                                    <Columns>
                                                        <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="Left" HeaderText="Code"
                                                            FooterStyle-HorizontalAlign="right" DataField="LocID" ItemStyle-Wrap="false"
                                                            ItemStyle-Width="80" HeaderStyle-Wrap="false" Visible="false"></asp:BoundColumn>
                                                        <asp:TemplateColumn ItemStyle-Width="80px" HeaderText="Actions" HeaderStyle-Width="80px"
                                                            ItemStyle-HorizontalAlign="center">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lnkEdit" Font-Underline="true" CommandName="Edit" ForeColor="#006600"
                                                                    CausesValidation="false" Style="padding-left: 5px" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.LocID")%>'
                                                                    runat="server" Text="Edit"></asp:LinkButton>
                                                                <asp:LinkButton ID="lnkDelete" Font-Underline="true" ForeColor="#cc0000" CausesValidation="false"
                                                                    Style="padding-left: 5px" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                                    CommandName="Delete" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.LocID")%>'
                                                                    runat="server" Text="Delete"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn HeaderStyle-Width="50" ItemStyle-HorizontalAlign="Left" HeaderText="Loc ID"
                                                            FooterStyle-HorizontalAlign="right" DataField="LocID" SortExpression="LocID"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="50" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-Width="200" HeaderText="Location Name" FooterStyle-HorizontalAlign="right"
                                                            DataField="LocName" SortExpression="LocName" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Left"
                                                            ItemStyle-Width="200" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-Width="180" HeaderText="Address 1" FooterStyle-HorizontalAlign="right"
                                                            DataField="LocAdress1" SortExpression="LocAdress1" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Left"
                                                            ItemStyle-Width="180" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-Width="80" HeaderText="Entry ID" FooterStyle-HorizontalAlign="right"
                                                            DataField="EntryID" SortExpression="EntryID" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Left"
                                                            ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-Width="80" HeaderText="Entry Date" FooterStyle-HorizontalAlign="right"
                                                            DataFormatString="{0:MM/dd/yyyy}" DataField="EntryDt" SortExpression="EntryDt"
                                                            ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="80"
                                                            HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-Width="80" HeaderText="Change ID" FooterStyle-HorizontalAlign="right"
                                                            DataField="ChangeID" SortExpression="ChangeID" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Left"
                                                            ItemStyle-Width="80" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                        <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Change Date" FooterStyle-HorizontalAlign="right"
                                                            DataFormatString="{0:MM/dd/yyyy}" DataField="ChangeDt" SortExpression="ChangeDt"
                                                            ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="80"
                                                            HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                                <input type="hidden" id="hidSort" runat="server" />
                                                <asp:HiddenField ID="hidpCar" runat="Server" />
                                                <asp:HiddenField ID="hidMode" runat="server" />
                                                <asp:HiddenField ID="hidScrollTop" runat="server" />
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" valign="top">
                                <asp:UpdatePanel ID="pnlWarehouse" runat="server" RenderMode="inline" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div runat="server" id="tdWarehouse" style="display: none; vertical-align: top;">
                                            <uc4:Warehouse ID="ucWarehouse" runat="server" />
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" valign="top">
                                <asp:UpdatePanel ID="pnlOption" runat="server" RenderMode="inline" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div runat="server" id="tdOption" style="display: none; vertical-align: top;">
                                            <uc3:Option ID="ucOption" runat="server" />
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" valign="top">
                                <asp:UpdatePanel ID="pnlPrinter" runat="server" RenderMode="inline" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div runat="server" id="tdPrinter" style="display: none; vertical-align: top;">
                                            <uc5:Printer ID="ucPrinter" runat="server" />
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="BluBg buttonBar" height="20px">
                    <table>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <uc2:BottomFooter ID="BottomFooterID" Title="Location Master" runat="server" />
                </td>
            </tr>
        </table>
        <div id="divToolTip" class="MarkItUp_ContextMenu_MenuTable" style="display: none;
            word-break: keep-all;" onmouseup="return false;">
            <table width="270px" height="100px" border="0" cellpadding="0" cellspacing="0" bordercolor="#000099"
                class="MarkItUp_ContextMenu_Outline">
                <tr>
                    <td class="bgtxtbox" height="80%">
                        <table width="100%" border="0" cellspacing="0">
                            <tr class="MarkItUp_ContextMenu_MenuItem">
                                <td width="100%" valign="middle">
                                    <%--<div id=divCAS  style="vertical-align:middle;color:#cc0000;" class=MarkItUp_ContextMenu_MenuItem onclick="ShowCAS();">Hold all Pounds for this Branch</div>--%>
                                    <table width="100%">
                                        <tr>
                                            <td class="Left2pxPadd DarkBluTxt boldText">
                                                <asp:Label ID="lblMode" runat="server" Text="Phone Format"></asp:Label>
                                                <asp:HiddenField ID="hidFMode" runat="server" />
                                            </td>
                                            <td colspan="5" class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtFormat" onkeypress="javascript:ValdateFormat();"
                                                    MaxLength="14"></asp:TextBox></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="bgmsgboxtile" height="25px">
                        <asp:UpdatePanel ID="pnlFormat" runat="server">
                            <ContentTemplate>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td width="80%" align="right" valign="middle" style="padding-right: 5px;">
                                            <asp:ImageButton ID="ibtnFSave" runat="server" ImageUrl="common/Images/BtnSave.gif"
                                                OnClick="ibtnFSave_Click" />
                                        </td>
                                        <td width="25%" align="right" valign="middle">
                                            <img src="Common/Images/close.jpg" style="cursor: hand;" onclick="Hide();"
                                                alt="Close">
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
            </table>
        </div>
        <div id="divToolTipEmail" class="MarkItUp_ContextMenu_MenuTable" style="display: none;
            word-break: keep-all;" onmouseup="return false;">
            <table width="400px" height="200px" border="0" cellpadding="0" cellspacing="0" bordercolor="#000099"
                class="MarkItUp_ContextMenu_Outline">
                <tr>
                    <td class="bgtxtbox" height="80%">
                        <table width="100%" border="0" cellspacing="0">
                            <tr class="MarkItUp_ContextMenu_MenuItem">
                                <td width="100%" valign="middle">
                                    <table width="100%">
                                        <tr>
                                            <td class="Left2pxPadd DarkBluTxt boldText">
                                                Contact
                                            </td>
                                            <td colspan="5" class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtLocEmail" MaxLength="50" Width="269px"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" SetFocusOnError="true"
                                                    ControlToValidate="txtLocEmail" Display="Dynamic" ErrorMessage="* Invalid" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="Left2pxPadd DarkBluTxt boldText">
                                                Back Order
                                            </td>
                                            <td colspan="5" class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtBOEmail" MaxLength="50" Width="269px"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" SetFocusOnError="true"
                                                    ControlToValidate="txtBOEmail" Display="Dynamic" ErrorMessage="* Invalid" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="Left2pxPadd DarkBluTxt boldText">
                                                Big Quote
                                            </td>
                                            <td colspan="5" class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtBigQuoteEmail" MaxLength="50"
                                                    Width="269px"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" SetFocusOnError="true"
                                                    ControlToValidate="txtBigQuoteEmail" Display="Dynamic" ErrorMessage="* Invalid"
                                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="Left2pxPadd DarkBluTxt boldText">
                                                RGA
                                            </td>
                                            <td colspan="5" class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtRGAEmail" MaxLength="50" Width="269px"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" SetFocusOnError="true"
                                                    ControlToValidate="txtRGAEmail" Display="Dynamic" ErrorMessage="* Invalid" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="bgmsgboxtile" height="25px">
                        <asp:UpdatePanel ID="pnlEmail" runat="server">
                            <ContentTemplate>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td width="80%" align="right" valign="middle" style="padding-right: 5px;">
                                            <asp:ImageButton runat="server" ImageUrl="common/Images/BtnSave.gif"
                                                OnClick="ibtnFSave_Click" />
                                        </td>
                                        <td width="25%" align="right" valign="middle">
                                            <img src="Common/Images/close.jpg" style="cursor: hand;" onclick="Hide();"
                                                alt="Close">
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
            </table>
        </div>
        <div id="divToolTipShip" class="MarkItUp_ContextMenu_MenuTable" style="display: none;
            word-break: keep-all;" onmouseup="return false;">
            <table width="300px" height="200px" border="0" cellpadding="0" cellspacing="0" bordercolor="#000099"
                class="MarkItUp_ContextMenu_Outline">
                <tr>
                    <td class="bgtxtbox" height="80%">
                        <table width="100%" border="0" cellspacing="0">
                            <tr class="MarkItUp_ContextMenu_MenuItem">
                                <td width="100%" valign="middle">
                                    <table width="100%">
                                        <tr>
                                            <td class="Left2pxPadd DarkBluTxt boldText">
                                                Branch 1
                                            </td>
                                            <td colspan="5" class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                <asp:DropDownList Height="20px" ID="ddlShpBr1" CssClass="FormCtrl" runat="server"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="Left2pxPadd DarkBluTxt boldText">
                                                Branch 2
                                            </td>
                                            <td colspan="5" class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                <asp:DropDownList Height="20px" ID="ddlShpBr2" CssClass="FormCtrl" runat="server"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="Left2pxPadd DarkBluTxt boldText">
                                                Branch 3
                                            </td>
                                            <td colspan="5" class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                <asp:DropDownList Height="20px" ID="ddlShpBr3" CssClass="FormCtrl" runat="server"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="Left2pxPadd DarkBluTxt boldText">
                                                Branch 4
                                            </td>
                                            <td colspan="5" class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                <asp:DropDownList Height="20px" ID="ddlShpBr4" CssClass="FormCtrl" runat="server"></asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="bgmsgboxtile" height="25px">
                        <asp:UpdatePanel ID="pnlShipFrom" runat="server">
                            <ContentTemplate>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td width="80%" align="right" valign="middle" style="padding-right: 5px;">
                                            <asp:ImageButton runat="server" ImageUrl="common/Images/BtnSave.gif"
                                                OnClick="ibtnFSave_Click" />
                                        </td>
                                        <td width="25%" align="right" valign="middle">
                                            <img src="Common/Images/close.jpg" style="cursor: hand;" onclick="Hide();"
                                                alt="Close">
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
