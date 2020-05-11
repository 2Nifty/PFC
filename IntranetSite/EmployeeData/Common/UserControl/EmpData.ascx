<%@ Control Language="C#" AutoEventWireup="true" CodeFile="EmpData.ascx.cs" Inherits="EmpData" %>
<%@ Register Src="~/EmployeeData/Common/UserControl/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
<table cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td>
            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>
                    <td>
                        <table cellpadding="0" cellspacing="0" width="100%" class=" Left5pxPadd Search">
                            <tr height="20px">
                                <td class=" BannerText " width="70%">
                                    Employee Data
                                </td>
                                <td align="right" style="padding-top: 6px; padding-top: -3px">
                                </td>
                                <td align="center">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="padding-left: 10px; padding-bottom: 10px; padding-top: 10px">
                        <asp:UpdatePanel ID="upnlUser" UpdateMode="conditional" runat="server">
                            <ContentTemplate>
                                <table cellpadding="2" cellspacing="0" border="0">
                                    <tr>
                                        <td class="DarkBluTxt boldText">
                                            <asp:Label ID="Label1" runat="server" Text="User's Name:" Width="75px" Font-Underline="true"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblUserName" runat="server" Width="150px"></asp:Label>
                                            <asp:HiddenField ID="hidUserName" runat="server" />
                                            <asp:HiddenField ID="hidLocation" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr class="DarkBluTxt boldText">
                    <td style="padding-left: 10px; padding-bottom: 5px;">
                        <table cellpadding="2" cellspacing="0" border="0">
                            <tr>
                                <td class="DarkBluTxt boldText">
                                    <asp:Label ID="Label2" runat="server" Text="Hire Location" Width="100px"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlHireLocation" runat="server" Width="175px" AutoPostBack="true"
                                        CssClass="FormCtrl" OnSelectedIndexChanged="ddlHireLocation_SelectedIndexChanged"
                                        TabIndex="1" >
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvHireLocation" runat="server" Display="dynamic"
                                        ControlToValidate="ddlHireLocation" Text="Location is required" ValidationGroup="EmpData">*</asp:RequiredFieldValidator>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="padding-left: 10px; padding-bottom: 5px;">
                        <table cellpadding="2" cellspacing="0" border="0" class="Left2pxPadd">
                            <tr class="DarkBluTxt boldText">
                                <td>
                                    <asp:Label ID="Label3" runat="server" Text="Employee No." Width="100px"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label4" runat="server" Text="Status" Width="100px"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label5" runat="server" Text="Hire Date" Width="100px"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td width="190">
                                    <asp:TextBox ID="txtEmpNo" runat="server" Width="170px" CssClass="FormCtrl" MaxLength="20"
                                        TabIndex="2"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvEmpNo" runat="server" Display="dynamic" ControlToValidate="txtEmpNo"
                                        Text="Employee No is required" ValidationGroup="EmpData">*</asp:RequiredFieldValidator>
                                </td>
                                <td width="165">
                                    <asp:DropDownList ID="ddlStatus" runat="server" Width="150px" CssClass="FormCtrl"
                                       TabIndex="3"  >
                                    </asp:DropDownList>
                                </td>
                                <td width="170px">
                                    <asp:Panel ID="pnlDate" runat="server">
                                        <uc3:novapopupdatepicker ID="dtpHireDate" runat="server" TabIndex="4" />
                                        <%--<asp:TextBox ID="txtHireDate" runat="server" Width="150px"></asp:TextBox>--%>
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="padding-left: 10px; padding-bottom: 5px;">
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td colspan="3" width="365" class=" DarkBluTxt boldText">
                                    <asp:Label ID="Label6" runat="server" Text="Employee Name" Width="150px"></asp:Label>
                                </td>
                                <td width="100px" class=" DarkBluTxt boldText">
                                    <asp:Label ID="Label28" runat="server" Text="Salutation" Width="100px"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class=" DarkBluTxt boldText" colspan="4">
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td>
                                                <asp:TextBox ID="txtFirstName" runat="server" Width="120px" CssClass="FormCtrl" MaxLength="25"
                                                    TabIndex="5"></asp:TextBox></td>
                                            <td style="width: 15px">
                                                <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName"
                                                    Text="*" ValidationGroup="EmpData"></asp:RequiredFieldValidator></td>
                                            <td style="width: 55px">
                                                <asp:TextBox ID="txtMiddleName" runat="server" Width="30px" CssClass="FormCtrl" MaxLength="2"
                                                    TabIndex="6" Text="MI"></asp:TextBox></td>
                                            <td>
                                                <asp:TextBox ID="txtLastName" runat="server" Width="145px" CssClass="FormCtrl" MaxLength="22"
                                                    TabIndex="7" Text="Last"></asp:TextBox></td>
                                            <td style="width: 18px">
                                                <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName"
                                                    Text="LastName is required" ValidationGroup="EmpData">*</asp:RequiredFieldValidator></td>
                                            <td>
                                                <asp:DropDownList ID="ddlSalutation" runat="server" Width="95px" CssClass="FormCtrl"
                                                    TabIndex="8">
                                                </asp:DropDownList></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="padding-left: 10px; padding-bottom: 5px;">
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td width="200px" colspan="2" class="DarkBluTxt boldText">
                                    <asp:Label ID="Label7" runat="server" Text="Email Address" Width="100px"></asp:Label>
                                </td>
                                <td width="100px" class=" DarkBluTxt boldText">
                                    <asp:Label ID="Label8" runat="server" Text="Phone No." Width="125px"></asp:Label>
                                </td>
                                <td class=" DarkBluTxt boldText">
                                    <asp:Label ID="Label9" runat="server" Text="Fax No." Width="80px"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtEmail" runat="server" Width="80px" CssClass="FormCtrl" MaxLength="80"
                                        TabIndex="9"></asp:TextBox>
                                </td>
                                <td width="150px" class="Left2pxPadd DarkBluTxt boldText">
                                    <asp:Label ID="lblEmail" runat="server" Text="@porteousfastener.com" Width="120px"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtPhone" runat="server" Width="100px" CssClass="FormCtrl" MaxLength="15"
                                        TabIndex="10" onkeypress="javascript:ValdateNumber();" AutoPostBack="True" OnTextChanged="txtPhone_TextChanged"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtFax" runat="server" Width="90px" CssClass="FormCtrl" MaxLength="15"
                                        TabIndex="11" onkeypress="javascript:ValdateNumber();" AutoPostBack="True" OnTextChanged="txtFax_TextChanged"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:UpdatePanel ID="upnlDept" UpdateMode="conditional" runat="server">
                            <ContentTemplate>
                                <table cellpadding="0" cellspacing="0" border="0" class="Left5pxPadd">
                                    <tr>
                                        <td width="100px" class=" DarkBluTxt boldText">
                                            <asp:Label ID="Label11" runat="server" Text="Department" Width="100px"></asp:Label>
                                        </td>
                                        <td width="100px" class=" DarkBluTxt boldText">
                                            <asp:Label ID="Label12" runat="server" Text="Position" Width="100px"></asp:Label>
                                        </td>
                                        <td width="70px" class=" DarkBluTxt boldText">
                                            <asp:Label ID="Label13" runat="server" Text="Shift"></asp:Label>
                                        </td>
                                        <td class=" DarkBluTxt boldText" style="padding-left: 10px">
                                            <asp:Label ID="Label14" runat="server" Text="Supervisor" Width="100px"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:DropDownList ID="ddlDepartment" runat="server" Width="110px" CssClass="FormCtrl"
                                                TabIndex="12">
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlPosition" runat="server" Width="140px" CssClass="FormCtrl"
                                                TabIndex="13">
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlShift" runat="server" Width="70px" CssClass="FormCtrl" TabIndex="14">
                                            </asp:DropDownList>
                                        </td>
                                        <td style="padding-left: 10px">
                                            <asp:DropDownList ID="ddlSupervisior" runat="server" Width="120px" CssClass="FormCtrl"
                                                TabIndex="15">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td style="height: 75px">
                        <table cellpadding="0" cellspacing="0" border="0" class="Left5pxPadd">
                            <tr height="20px" class="DarkBluTxt boldText">
                                <td width="100px">
                                    <asp:Label ID="Label15" runat="server" Text="Pay Code" Width="100px"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label16" runat="server" Text="Payroll Employee No." Width="125px"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label17" runat="server" Text="Payroll Location" Width="100px"></asp:Label>
                                </td>
                            </tr>
                            <tr height="20px">
                                <td>
                                    <asp:DropDownList ID="ddlPayCode" runat="server" Width="120px" CssClass="FormCtrl"
                                        TabIndex="16">
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtPayrollEmpNo" runat="server" Width="125px" CssClass="FormCtrl"
                                        TabIndex="17" MaxLength="10"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlPayrollLoc" runat="server" Width="150px" CssClass="FormCtrl"
                                        TabIndex="18">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <%--<tr>
                    <td>
                        <table cellpadding="0" cellspacing="0" border="0" align="center" class="Left5pxPadd PageBg">
                            <tr height="25px" >
                                <td width="150px" colspan="2" style="border: 1px solid; border-collapse: collapse;">
                                    <asp:Label ID="Label29" runat="server" Text="Paid Hours"></asp:Label>
                                </td>
                                <td width="250px" colspan="2" style="border: 1px solid; border-collapse: collapse;">
                                    <asp:Label ID="Label30" runat="server" Text="Leave of Absence Dates "></asp:Label>
                                </td>
                                <td width="200px" colspan="2" style="border: 1px solid; border-collapse: collapse;">
                                    <asp:Label ID="Label31" runat="server" Text="Benefits Amount"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>--%>
                <tr>
                    <td style="padding-left: 10px">
                        <table cellpadding="0" cellspacing="0" border="0" class=" BlueSearch" width="65%">
                            <tr>
                                <td colspan="6">
                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                        <tr height="25px" class="Left5pxPadd DarkBluTxt  boldText PageBg">
                                            <td width="150px" colspan="2" style="border: 1px solid; border-collapse: collapse;
                                                padding-left: 5px">
                                                <asp:Label ID="Label18" runat="server" Text="Paid Hours"></asp:Label>
                                            </td>
                                            <td width="250px" colspan="2" style="border: 1px solid; border-collapse: collapse;
                                                padding-left: 5px">
                                                <asp:Label ID="Label19" runat="server" Text="Leave of Absence Dates "></asp:Label>
                                            </td>
                                            <td width="200px" colspan="2" style="border: 1px solid; border-collapse: collapse;
                                                padding-left: 5px">
                                                <asp:Label ID="Label20" runat="server" Text="Benefits Amount"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="100px" class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px">
                                                <asp:Label ID="Label21" runat="server" Text="Holiday"></asp:Label>
                                            </td>
                                            <td width="50px" style="padding-top: 5px">
                                                <asp:TextBox ID="txtHoliday" runat="server" Width="50px" CssClass="FormCtrl" MaxLength="4"
                                                    TabIndex="19" onkeypress="javascript:ValdateNumber();"></asp:TextBox>
                                            </td>
                                            <td width="100px" class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px">
                                                <asp:Label ID="Label22" runat="server" Text="Begin "></asp:Label>
                                            </td>
                                            <td width="50px" style="padding-top: 5px">
                                                <asp:TextBox ID="txtBegin" runat="server" Width="100px" CssClass="FormCtrl" TabIndex="20"
                                                    onblur="javascript:ValidateDate(this.id);"></asp:TextBox>
                                            </td>
                                            <td width="100px" class=" DarkBluTxt boldText" style="padding-top: 5px">
                                                <asp:Label ID="Label23" runat="server" Text="BALANCE" Style="padding-left: 5px"></asp:Label>
                                            </td>
                                            <td style="padding-top: 5px; padding-right: 3px">
                                                <asp:TextBox ID="txtBalance" runat="server" Width="75px" CssClass="FormCtrl" MaxLength="8"
                                                    TabIndex="21" onkeypress="javascript:ValdateNumberWithDot(this.value);"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="100px" class=" Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px">
                                                <asp:Label ID="Label24" runat="server" Text="Sick"></asp:Label>
                                            </td>
                                            <td style="padding-top: 5px">
                                                <asp:TextBox ID="txtSick" runat="server" Width="50px" CssClass="FormCtrl" MaxLength="4"
                                                    onkeypress="javascript:ValdateNumber();" TabIndex="22"></asp:TextBox>
                                            </td>
                                            <td width="100px" class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px">
                                                <asp:Label ID="Label25" runat="server" Text="End "></asp:Label>
                                            </td>
                                            <td width="100px" style="padding-top: 5px">
                                                <asp:TextBox ID="txtEnd" runat="server" Width="100px" onblur="javascript:ValidateDate(this.id);"
                                                    CssClass="FormCtrl" TabIndex="23"></asp:TextBox>
                                            </td>
                                            <td style="padding-left: 5px; height: 20px; padding-top: 5px" width="100px" colspan="2">
                                            </td>
                                        </tr>
                                        <tr style="padding-bottom: 3px">
                                            <td width="100px" class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px">
                                                <asp:Label ID="Label26" runat="server" Text="Vacation"></asp:Label>
                                            </td>
                                            <td style="padding-top: 5px">
                                                <asp:TextBox ID="txtVacation" runat="server" Width="50px" CssClass="FormCtrl" MaxLength="4"
                                                    onkeypress="javascript:ValdateNumber();" TabIndex="24"></asp:TextBox>
                                            </td>
                                            <td width="100px" class="Left2pxPadd DarkBluTxt boldText" style="padding-top: 5px">
                                                <asp:Label ID="Label27" runat="server" Text="BALANCE"></asp:Label>
                                            </td>
                                            <td width="100px" style="padding-top: 5px">
                                                <asp:TextBox ID="txtAbsenceBal" runat="server" Width="100px" CssClass="FormCtrl"
                                                    onblur="javascript:ValidateDate(this.id);" TabIndex="25"></asp:TextBox>
                                            </td>
                                            <td width="100px" colspan="2">
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr height="35">
                    <td>
                    </td>
                </tr>
                <tr>
                    <td class="BluBg buttonBar Left5pxPadd" style="border-top: solid 1px #DAEEEF">
                        <table cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="85%" style="padding-left: 5px;" valign="top">
                                    <asp:ImageButton runat="server" ID="ibtnDelete" ImageUrl="~/EmployeeData/Common/images/btndelete.gif"
                                        ImageAlign="left " CausesValidation="false" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                        OnClick="ibtnDelete_Click" /></td>
                                <td align="right" style="padding-right: 5px; height: 28px;" valign="top">
                                    <asp:ImageButton runat="server" ID="ibtnSave" ImageUrl="~/EmployeeData/Common/images/BtnSave.gif"
                                        OnClick="ibtnSave_Click" ValidationGroup="EmpData" ImageAlign="Right" CausesValidation="true" />
                                </td>
                                <td width="70px" style="padding-right: 3px; height: 28px;" valign="top">
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
