<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TwoDatePicker.ascx.cs"
    Inherits="Common_UserControls_TwoDatePicker" %> 
    <script language=javascript>
function OpenDatePicker(controlID,textBox)
{
    //
    // Get the Site Url from Codebehind function
    //
    var PageName = "Common/DatePicker/DatePicker_ClientInterface.aspx";
  //  var url = PageName  + '?txtID='+controlID+"&soeID="+document.getElementById("CustDet_txtSONumber").value;
    var url = PageName  + '?txtID='+controlID.split("_")[0]+"_"+textBox;
    var hWnd=window.open(url, 'DatePicker', 'width=297,height=157,top='+((screen.height/2) - (250/2))+' ,left='+((screen.width/2) - (280/2))+'');
    
    hWnd.opener = self;	
	if (window.focus) {hWnd.focus()}
    return false;
}
</script>
<tr>
    <td style="font-weight: bold;">
        <asp:Label ID="lblStartLabel" runat="server" Text=""></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtStart" Width="70px" runat="server" CssClass="FormCtrl"></asp:TextBox>&nbsp;<asp:ImageButton
            ID="imgStart" CausesValidation="False" runat="server" ImageUrl="../Images/datepicker.gif"
            OnClientClick="javascript:return OpenDatePicker(this.id,'txtStart')"></asp:ImageButton>
    </td>
</tr>
<tr>
    <td style="font-weight: bold;">
        <asp:Label ID="lblEndLabel" runat="server" Text=""></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtEnd" Width="70px" runat="server" CssClass="FormCtrl"></asp:TextBox>&nbsp;<asp:ImageButton
            ID="imgEnd" CausesValidation="False" runat="server" ImageUrl="../Images/datepicker.gif"
            OnClientClick="javascript:return OpenDatePicker(this.id,'txtEnd')"></asp:ImageButton>
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
            Display="dynamic" OnServerValidate="cvDatePicker_ServerValidate" ControlToValidate="txtEnd" ></asp:CustomValidator></td>
</tr>
