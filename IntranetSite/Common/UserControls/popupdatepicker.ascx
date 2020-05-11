<%@ Control Language="C#" AutoEventWireup="true" CodeFile="popupdatepicker.ascx.cs" Inherits="Novantus.Umbrella.UserControls.popupdatepicker" %>


<%--OpenDatePicker function is now included in DatePicker.js
    Include DatePicker.js in your main page to make this work--%>

<%--<script language=javascript>
        function OpenDatePicker(controlID)
        {
            //alert("datepicker");

            // Get the Site Url from Codebehind function        
            var PageName = <%=GetSiteURL() %>;
            var url = PageName  + '?txtID=' + controlID;
            //alert(url);
            var hWnd=window.open(url, 'DatePicker', 'width=320,height=157,top='+((screen.height/2) - (310/2))+' ,left='+((screen.width/2) - (310/2))+'');
            
            hWnd.opener = self;	
	        if (window.focus) {hWnd.focus()}
            return false;
        }
</script>--%>

<table id="tblDatePicker" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <td>
            <asp:TextBox ID="txtDatePicker" runat="server" Width="70px" CssClass="FormCtrl" OnFocus="javascript:this.select();"
                OnKeyPress="javascript:if(event.keyCode!=45&&event.keyCode!=47&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;"
                OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;" OnBlur="ValidateDate(this.value, this.id);"></asp:TextBox>
        </td>
        <td align="right" style="padding-left: 4px;">
            <asp:ImageButton id="ibtnDatePicker" CausesValidation="False" runat="server" ImageUrl="../Images/datepicker.gif" 
                OnClientClick="javascript:return OpenDatePicker(this.id);" ></asp:ImageButton>

        </td>
        <%--<td colspan="2" style="padding-left: 7px;">
        <asp:RegularExpressionValidator ID="rfvDate" runat="server" ControlToValidate="txtDatePicker"
                ValidationGroup="EmpData" ErrorMessage="Valid date format is MM/DD/YYYY" SetFocusOnError="True"
                ValidationExpression="^(((((0[1-9])|([1-9])|(1[02]))[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9])|(3[01])))|((([469])|(11))[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9])|(30)))|((02|2)[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9]))))[\-\/\s]?\d{4})(\s(((0[1-9])|([0-9])|(1[0-2]))\:(([0-5][0-9])|([0-9]))((\s)|(\:(([0-5][0-9])|([0-9]))\s))([AM|PM|am|pm]{2,2})))?$"
                CssClass="Required" Display="Dynamic"></asp:RegularExpressionValidator>
        </td>--%>
    </tr>
    <%--<tr></tr>--%>
    <asp:HiddenField ID="hidParentErrCtl" runat="server" Value="" />
</table>
