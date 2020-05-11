<%@ Control Language="C#" AutoEventWireup="true" CodeFile="novapopupdatepicker.ascx.cs" Inherits="Novantus.Umbrella.UserControls.novapopupdatepicker" %>

<script language=javascript>
function OpenDatePicker1(controlID,textBox)
{
    //
    // Get the Site Url from Codebehind function
    //
    var PageName = <%=GetSiteURL() %>;
  //  var url = PageName  + '?txtID='+controlID+"&soeID="+document.getElementById("CustDet_txtSONumber").value;
    var url = PageName  + '?txtID='+controlID.replace('Image1',textBox);
    var hWnd=window.open(url, 'DatePicker', 'width=293,height=157,top='+((screen.height/2) - (250/2))+' ,left='+((screen.width/2) - (280/2))+'');
    
    hWnd.opener = self;	
	if (window.focus) {hWnd.focus()}
    return false;
}
</script>
<asp:TextBox id="textBox" Width="55px"  runat="server" CssClass="FormCtrl"></asp:TextBox>&nbsp;<asp:ImageButton id="Image1" CausesValidation="False" runat="server" ImageUrl="~/Common/Images/datepicker.gif" OnClientClick="javascript:return OpenDatePicker1(this.id,'textBox')" ></asp:ImageButton>
<asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="textBox"
                ErrorMessage="Valid date format is MM/DD/YYYY" SetFocusOnError="True" ValidationExpression="^(((((0[1-9])|([1-9])|(1[02]))[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9])|(3[01])))|((([469])|(11))[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9])|(30)))|((02|2)[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9]))))[\-\/\s]?\d{4})(\s(((0[1-9])|([0-9])|(1[0-2]))\:(([0-5][0-9])|([0-9]))((\s)|(\:(([0-5][0-9])|([0-9]))\s))([AM|PM|am|pm]{2,2})))?$" CssClass="Required" Display="Dynamic"></asp:RegularExpressionValidator>
    
