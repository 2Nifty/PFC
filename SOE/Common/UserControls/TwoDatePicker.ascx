<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TwoDatePicker.ascx.cs"
    Inherits="Common_UserControls_TwoDatePicker" %>
<%@ Register Src="novapopupdatepicker.ascx" TagName="novapopupdatepicker" TagPrefix="uc1" %>

<tr>
    <td style="font-weight: bold;">
        Start Date
    </td>
    <td>
        <asp:TextBox ID="txtStart" Width="55px" runat="server" CssClass="lbl_whitebox"></asp:TextBox>&nbsp;<asp:ImageButton
            ID="imgStart" CausesValidation="False" runat="server" ImageUrl="~/Common/Images/datepicker.gif"
            OnClientClick="javascript:return OpenDatePicker1(this.id,'txtStart')"></asp:ImageButton>
    </td>
</tr>
<tr>
    <td style="font-weight: bold;">
        End Date
    </td>
    <td>
        <asp:TextBox ID="txtEnd" Width="55px" runat="server" CssClass="lbl_whitebox"></asp:TextBox>&nbsp;<asp:ImageButton
            ID="imgEnd" CausesValidation="False" runat="server" ImageUrl="~/Common/Images/datepicker.gif"
            OnClientClick="javascript:return OpenDatePicker1(this.id,'txtEnd')"></asp:ImageButton>
    </td>
</tr>
<tr>
    <td colspan="2">
        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtEnd"
            ErrorMessage="Valid date format is MM/DD/YYYY" SetFocusOnError="True" ValidationExpression="^(((((0[1-9])|([1-9])|(1[02]))[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9])|(3[01])))|((([469])|(11))[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9])|(30)))|((02|2)[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9]))))[\-\/\s]?\d{4})(\s(((0[1-9])|([0-9])|(1[0-2]))\:(([0-5][0-9])|([0-9]))((\s)|(\:(([0-5][0-9])|([0-9]))\s))([AM|PM|am|pm]{2,2})))?$"
            CssClass="Required" Display="Dynamic"></asp:RegularExpressionValidator>
        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtStart"
            ErrorMessage="Valid date format is MM/DD/YYYY" SetFocusOnError="True" ValidationExpression="^(((((0[1-9])|([1-9])|(1[02]))[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9])|(3[01])))|((([469])|(11))[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9])|(30)))|((02|2)[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9]))))[\-\/\s]?\d{4})(\s(((0[1-9])|([0-9])|(1[0-2]))\:(([0-5][0-9])|([0-9]))((\s)|(\:(([0-5][0-9])|([0-9]))\s))([AM|PM|am|pm]{2,2})))?$"
            CssClass="Required" Display="Dynamic"></asp:RegularExpressionValidator>
        <asp:CustomValidator ID="cvDatePicker" runat="server" ErrorMessage="Invalid Date Range"
            Display="dynamic" OnServerValidate="cvDatePicker_ServerValidate"></asp:CustomValidator></td>
</tr>
