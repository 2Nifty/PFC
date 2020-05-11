<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UserSettings.ascx.cs"
    Inherits="UserSettingData" %>
<table cellpadding="0" cellspacing="0" border="0" width="100%" height=100%>
    <tr>
        <td>
            <table cellpadding="0" cellspacing="0" border="0" width="100%" >
                <tr >
                    <td>
                        <table cellpadding="0" cellspacing="0" width="100%" class=" Left5pxPadd Search">
                            <tr>
                                <td class=" BannerText " width="70%">
                                    User Settings 
                                </td>
                                <td align ="right" style="padding-top:6px"  >
                                
                                        
                                </td>
                                <td align="center">
                                   
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:UpdatePanel ID="upnlUser" UpdateMode="conditional" runat="server">
                            <ContentTemplate>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td width="80" class="Left5pxPadd DarkBluTxt boldText" height="18" style="padding-left: 20px;
                                            padding-right: 2px; padding-top: 10px;">
                                            <asp:Label ID="Label2" runat="server" Text="User's Name:" Width="75px" Font-Underline="true"></asp:Label>
                                        </td>
                                        <td width="120" style=" height: 18px;padding-top: 10px;">
                                            <asp:Label ID="lblUserName" runat="server" Width="150px" Text="User"></asp:Label>
                                            <asp:HiddenField ID="hidUserID" runat ="server" />
                                          
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="Left5pxPadd DarkBluTxt boldText" height="18" style="padding-left: 20px;
                                            padding-right: 2px; padding-top: 10px;">
                                            <asp:Label ID="Label3" runat="server" Text="Location:" Width="60px"></asp:Label>
                                        </td>
                                        <td style=" height: 18px;padding-top: 10px;">
                                            <asp:Label ID="lblLocation" runat="server" Width="100px"></asp:Label>
                                            <asp:HiddenField ID="hidLocation" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <br />
                    </td>
                </tr>
                
                <tr>
                    <td>
                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                            <tr>
                            <td width="31%">
                            </td>
                                <td align="right" width="50px" >
                                    <hr color="red" />
                                </td>
                                <td class=" DarkBluTxt boldText" height="20px" width="120px" style="padding-left:10px;"  >
                                    <asp:Label ID="Label5" runat="server" Text="Login Information" ></asp:Label>
                                </td>
                                <td align="left"  width="50px">
                                    <hr align="center" color="red" />
                                </td>
                                <td width="40%"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:UpdatePanel ID="upnlMSAD" UpdateMode="conditional" runat="server">
                            <ContentTemplate>
                                <table cellpadding="0" cellspacing="0" border="0" class="Left5pxPadd">
                                    <tr class="Left5pxPadd">
                                        <td class="Left5pxPadd DarkBluTxt boldText" height="15" style="padding-left: 20px;
                                            padding-right: 2px; padding-top: 10px;">
                                            <asp:Label ID="Label6" runat="server" Text="User Interface:" Width="100px"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlUserInterface" runat="server" Width="150px" CssClass="FormCtrl" TabIndex="1">
                                            </asp:DropDownList>
                                        </td>
                                        <td rowspan="6" valign="bottom" style="padding-left: 30px;
                                            height: 80px">
                                            <table cellpadding="0" cellspacing="0" border="0" class="BlueBorder" style="border-collapse: collapse">
                                                <tr class="PageBg">
                                                    <td colspan="2" height="20"  style="border:1px solid;border-collapse:collapse; ">
                                                    </td>
                                                </tr>
                                                <tr height="18" style="padding-right: 5px">
                                                    <td class="Left5pxPadd DarkBluTxt boldText"  >
                                                        <asp:Label ID="Label12" runat="server" Text="Username" Width="80px"></asp:Label>
                                                    </td>
                                                    <td style="padding-top:5px">
                                                        <asp:TextBox ID="txtUserName" runat="server" Width=140px CssClass="FormCtrl" MaxLength="30" TabIndex="3"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="rfvUserName" ControlToValidate="txtUserName" ErrorMessage="UserName is required"
                                                            Display="dynamic" runat="server" ValidationGroup="UserSetting">*</asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr height="18">
                                                    <td class="Left5pxPadd DarkBluTxt boldText" height="15">
                                                        <asp:Label ID="Label13" runat="server" Text="Password" Width="80px"></asp:Label>
                                                    </td>
                                                    <td style="padding-right: 5px">
                                                        <asp:TextBox ID="txtPassword" runat="server" Width=140px CssClass="FormCtrl" TextMode="Password" TabIndex="4"
                                                            MaxLength="20" ></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="rfvPassword" ControlToValidate="txtPassword" ErrorMessage="Password is required"
                                                            Display="dynamic" runat="server" ValidationGroup="UserSetting">*</asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr height="18" style="padding-right: 5px; padding-bottom: 5px">
                                                    <td class="Left5pxPadd DarkBluTxt boldText">
                                                        <asp:Label ID="Label14" runat="server" Text="Domain" Width="80px"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtDomain" runat="server" Width=140px CssClass="FormCtrl" MaxLength="30" TabIndex="5"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="rfvDomain" ControlToValidate="txtDomain" ErrorMessage="Domain is required"
                                                            Display="dynamic" runat="server" ValidationGroup="UserSetting">*</asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr height="18" class="Left5pxPadd">
                                        <td class="Left5pxPadd DarkBluTxt boldText" style="padding-left: 20px; padding-right: 2px;
                                            padding-top: 10px;">
                                            <asp:Label ID="Label7" runat="server" Text="MSAD Username:" Width="100px"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtMSADUserName" runat="server" Width="143px" CssClass="FormCtrl" TabIndex="2"
                                                MaxLength="30"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfvMSADUser" ControlToValidate="txtMSADUserName" ValidationGroup="UserSetting"
                                                ErrorMessage="MSADUserName is required" Display="dynamic" runat="server">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr height="18" class="Left5pxPadd">
                                        <td class="Left5pxPadd DarkBluTxt boldText " style="padding-left: 20px; padding-right: 2px;
                                            padding-top: 10px;">
                                            <asp:Label ID="Label8" runat="server" Text="Last Login:" Width="100px"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblLastLogin" runat="server" Width="100px"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr height="18">
                                        <td class="Left5pxPadd DarkBluTxt boldText" style="padding-left: 20px; padding-right: 2px;
                                            padding-top: 10px;">
                                            <asp:Label ID="Label9" runat="server" Text="No. of Logins:" Width="100px"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblNoLogins" runat="server" Width="100px"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr height="18">
                                        <td class="Left5pxPadd DarkBluTxt boldText" style="padding-left: 20px; padding-right: 2px;
                                            padding-top: 10px;">
                                            <asp:Label ID="Label10" runat="server" Text="Log on Status:" Width="100px"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblLogStatus" runat="server" Width="100px"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <br />
                        <br />
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                            <tr>
                            <td width="31%">
                            </td>
                                <td align="right" width="70px" >
                                    <hr color="red" />
                                </td>
                                <td class=" DarkBluTxt boldText" height="20px" width="90px" style="padding-left:10px;"  >
                                    <asp:Label ID="Label15" runat="server" Text="User Options"></asp:Label>
                                </td>
                                <td align="left"  width="70px">
                                    <hr align="center" color="red" />
                                </td>
                                <td width="40%"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
               
                <tr>
                    <td>
                        <asp:UpdatePanel ID="upnlBuyer" UpdateMode="conditional" runat="server">
                            <ContentTemplate>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr class="Left5pxPadd">
                                        <td class="Left5pxPadd DarkBluTxt boldText" style="padding-left: 20px; padding-right: 2px;
                                            padding-top: 10px;">
                                            <asp:Label ID="Label16" runat="server" Text="Buyer"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlBuyer" runat="server" CssClass="FormCtrl" Width="150px" TabIndex="6">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left5pxPadd DarkBluTxt boldText " style="padding-top: 10px; padding-left: 15px;">
                                            <asp:Label ID="Label17" runat="server" Text="Primary Bin Prompt"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlPrompt" runat="server" CssClass="FormCtrl" Width="150px" TabIndex="7">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr class="Left5pxPadd">
                                        <td class="Left5pxPadd DarkBluTxt boldText" style="padding-left: 20px; padding-right: 2px;
                                            padding-top: 10px;">
                                            <asp:Label ID="Label18" runat="server" Text="Approve Orders"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlApproveOrders" runat="server" CssClass="FormCtrl" Width="150px" TabIndex="8">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left5pxPadd DarkBluTxt boldText" style="padding-top: 10px; padding-left: 15px;">
                                            <asp:Label ID="Label19" runat="server" Text="PO Dollar Limit"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtDollarLimit" runat="server" CssClass="FormCtrl" Width="143px"  TabIndex="9"
                                            MaxLength="18" onkeypress="javascript:ValdateNumberWithDot(this.value);"  onfocus="this.select();"></asp:TextBox>
                                            <asp:RegularExpressionValidator ID ="rfvDollarLimit" ControlToValidate="txtDollarLimit" ValidationGroup="UserSetting" SetFocusOnError="true"
                                               ValidationExpression="^\d{1,13}(\.\d{1,4})?" runat="server" Display ="dynamic " ErrorMessage="Valid amount format is 9999999999999.9999"></asp:RegularExpressionValidator>
                                        </td>
                                    </tr>
                                    <tr class="Left5pxPadd">
                                        <td class="Left5pxPadd DarkBluTxt boldText" style="padding-left: 20px; padding-right: 2px;
                                            padding-top: 10px;">
                                            <asp:Label ID="Label20" runat="server" Text="AR Clerk"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlARClerk" runat="server" CssClass="FormCtrl" Width="150px" TabIndex="10">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Left5pxPadd DarkBluTxt boldText" style="padding-top: 10px; padding-left: 15px;">
                                            <asp:Label ID="Label21" runat="server" Text="Consumables Amt"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtConsumable" runat="server" CssClass="FormCtrl" Width="143px" TabIndex="11"
                                                MaxLength="18" onkeypress="javascript:ValdateNumberWithDot(this.value);" onfocus="this.select();"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID ="rfvConsumable" ControlToValidate="txtConsumable" SetFocusOnError="true"
                                               ValidationExpression="^\d{1,13}(\.\d{1,4})?" runat="server" Display ="dynamic " ErrorMessage=" Valid amount format is 9999999999999.9999" ValidationGroup="UserSetting"></asp:RegularExpressionValidator>
                                        
                                                
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr height="135px">
                <td>
                &nbsp;
                </td>
                </tr>
                 <tr>
                    <td class="BluBg buttonBar Left5pxPadd"  style="border-top: solid 1px #DAEEEF" >
                        <table cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="78%">
                                </td>
                                <td align="right" style="padding-right:5px;height: 28px;" valign="top">
                                   <asp:ImageButton runat="server" ID="ibtnSave" ImageUrl="~/EmployeeData/Common/images/BtnSave.gif"
                                                 OnClick="ibtnSave_Click" CausesValidation="true" ValidationGroup="UserSetting" />
                                </td>
                                <td width="70px" style="padding-right:3px;height: 28px;" valign="top">
                                    <img id="btnClose" src="../images/close.jpg" onclick="javascript:window.close();"
                                        runat="server" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
