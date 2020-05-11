<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddressEntry.ascx.cs"
    Inherits="PFC.Intranet.VendorMaintenance.LocationAdd" %>
<%@ Register Src="PhoneNumber.ascx" TagName="PhoneNumber" TagPrefix="uc1" %>
<asp:UpdatePanel ID="pnlAddressEntry" runat="server">
    <ContentTemplate>
        <div>
            <asp:Panel ID="Panel1" runat="server" DefaultButton="ibtnUpdate">
              <table width="100%" cellpadding="0" cellspacing="0" class="blueBorder" style="border-collapse: collapse;">
                <tr>
                    <td class="lightBlueBg" colspan="2" style="height: 35px">
                        <asp:Label ID="lblCaption" CssClass="BanText" runat="server" Text="Buy From Information"></asp:Label>
                    </td>
                    <td class="lightBlueBg" colspan="2" align="right">
                        <asp:ImageButton ID="btnClose" ImageUrl="~/VendorMaintenance/Common/images/close.jpg"
                            runat="server" OnClick="btnClose_Click" CausesValidation="false" />
                            
                            </td>
                </tr>
                <tr>
                    <td style="padding-top: 10px; padding-bottom: 10px;">
                        <table width="70%">
                          <%--  <tr>
                                <td class="Left2pxPadd DarkBluTxt boldText">
                                    Address Type</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" colspan="3">
                                    <asp:RadioButtonList RepeatDirection="Horizontal" CssClass="Left2pxPadd DarkBluTxt boldText"
                                        ID="RadioButtonList1" runat="server">
                                        <asp:ListItem Selected="true" Text="Buy From"></asp:ListItem>
                                        <asp:ListItem Text="Buy From / Ship From"></asp:ListItem>
                                    </asp:RadioButtonList></td>
                            </tr>--%>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt">
                                    Address Name</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox MaxLength="50" CssClass="FormCtrl" ID="txtAddressName" runat="server"></asp:TextBox> 
                                    <span style="color:Red;">*</span>
                                </td>
                                <td class="Left2pxPadd DarkBluTxt">
                                    Code</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox MaxLength="10"  CssClass="FormCtrl" ID="txtCode" runat="server"></asp:TextBox> 
                                     <%--<asp:TextBox MaxLength="10" onblur="javascript:ValidateFirstText(this.id);" CssClass="FormCtrl" ID="TextBox1" runat="server"></asp:TextBox> --%>
                                    
                                    <asp:Label runat="server" id="lblCodeStatus" ForeColor="red" ></asp:Label>
                                    <span style="color:Red;">*</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt">
                                    Line 1</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox MaxLength="40" CssClass="FormCtrl" ID="txtLine1" runat="server"></asp:TextBox></td>
                                <td class="Left2pxPadd DarkBluTxt">
                                    Line 2</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox MaxLength="40" CssClass="FormCtrl" ID="txtLine2" runat="server"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt">
                                    City</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox MaxLength="20" CssClass="FormCtrl" ID="txtCity" runat="server"></asp:TextBox></td>
                                <td class="Left2pxPadd DarkBluTxt">
                                    State</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox MaxLength="2" ID="txtState" runat="server" CssClass="FormCtrl"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt" style="height: 22px">
                                    Zip Code</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="height: 22px">
                                    <asp:TextBox MaxLength="10" CssClass="FormCtrl" onkeypress="javascript:ValidateZip();" ID="txtZipCode" runat="server"></asp:TextBox></td>
                                <td class="Left2pxPadd DarkBluTxt" style="height: 22px">
                                    Country</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="height: 22px">
                                    <asp:DropDownList ID="ddlCountry" CssClass="FormCtrl" runat="server" Width="130px"  Height="20px" >
                                    </asp:DropDownList></td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt" colspan="4" style="height: 22px">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt">
                                    Phone</td>
                                <td class="splitBorder_r_h Right2pxPadd">
                                    <uc1:PhoneNumber ID="phAdddress" runat="server" />
                                </td>
                                <td class="Left2pxPadd DarkBluTxt">
                                    Fax</td>
                                <td class="splitBorder_r_h Right2pxPadd">
                                    <uc1:PhoneNumber ID="fxAddress" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt">
                                    Email</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" colspan="3">
                                    <asp:TextBox MaxLength="80" CssClass="FormCtrl" ID="txtEmail" Width="200px" runat="server"></asp:TextBox> <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail"
                                        Display="Dynamic" ErrorMessage="* Invalid Email" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator></td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt">
                                    Web Page Address</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" colspan="3">
                                    <asp:TextBox MaxLength="100" ID="txtUrl" runat="server" CssClass="FormCtrl" Width="200px"></asp:TextBox> 
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtUrl"
                                        ErrorMessage="* Invalid URL" ValidationExpression="([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?"></asp:RegularExpressionValidator><%--<asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtUrl"
                                        Display="Dynamic" ErrorMessage="* Invalid URL" ValidationExpression="([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?"></asp:RegularExpressionValidator>--%></td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt" colspan="4" style="height: 22px">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt">
                                    Transit Days</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" colspan="3">
                                    <asp:TextBox MaxLength="5"  ID="txtTransitAddres" onkeypress="javascript:ValdateNumber();" runat="server" CssClass="FormCtrl" Width="100px"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt">
                                    Product Type</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" colspan="3">
                                    <asp:DropDownList ID="ddlProductType" CssClass="FormCtrl" runat="server" Width="130px" Height="20px">
                                    </asp:DropDownList></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr height="36" valign="middle">
                    <td class="lightBlueBg" colspan="4" style="padding-left: 120px; vertical-align: middle;
                        border-collapse: collapse;">
                        <asp:ImageButton ID="ibtnUpdate" OnClientClick="javascript:return CheckRequired(this.id);"  runat="server" CausesValidation="true" ImageUrl="~/VendorMaintenance/Common/images/update.gif" OnClick="ibtnUpdate_Click" />
                        
                        <asp:ImageButton ID="ibtnCancel" runat="server" CausesValidation="false" ImageUrl="~/VendorMaintenance/Common/images/cancel.png" OnClick="ibtnCancel_Click" />
                        <asp:HiddenField ID=hidVendor runat=server />
                        <asp:HiddenField ID=hidShipID runat=server />
                        <asp:HiddenField ID=hidBuyID runat=server />
                        <asp:HiddenField ID=hidType runat=server />
                        <asp:HiddenField ID=hidMode runat=server />
                    </td>
                </tr>
            </table>
            </asp:Panel>
        
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<script language=javascript>

function CheckRequired(ctrlId)
{
    var locName=document.getElementById(ctrlId.replace('ibtnUpdate','txtAddressName')).value//.replace(/\s/g,'');
    var locCode=document.getElementById(ctrlId.replace('ibtnUpdate','txtCode')).value//.replace(/\s/g,'');
    if(locName.replace(/\s/g,'')!='' && locCode.replace(/\s/g,'')!='')
        return true;
    else
    {
        alert("' * ' Marked fields are mandatory")
        return false;;
    }
}
function ValidateFirstText(ctrlID)
    {
        var codeValue=document.getElementById(ctrlID).value;
        var strChar;
        var numString="0123456789"; 
        if(codeValue.replace(/\s/g,'')!="")
        {
            strChar=codeValue.charAt(0);
            //alert(strChar)
            if(numString.indexOf(strChar)!=-1)
            {
                alert('First letter should be an alphabet');
                document.getElementById(ctrlID).focus();
            }
            
        }
    }
</script>