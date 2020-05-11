<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderEntrydatepicker.ascx.cs" Inherits="Novantus.Umbrella.UserControls.OrderEntrydatepicker" %>

<script language=javascript>
function OpenDatePicker1(controlID,textBox)
{
    //
    // Get the Site Url from Codebehind function
    //
    var PageName = <%=GetSiteURL() %>;
  //  var url = PageName  + '?txtID='+controlID+"&soeID="+document.getElementById("CustDet_txtSONumber").value;
    var url = PageName  + '?txtID='+controlID.split("_")[0]+"_"+textBox;
    var hWnd=window.open(url, 'DatePicker', 'width=293,height=157,top='+((screen.height/2) - (250/2))+' ,left='+((screen.width/2) - (280/2))+'');
    
    hWnd.opener = self;	
	if (window.focus) {hWnd.focus()}
    return false;
}
//-------------------------------------------------------------------------------
function LoadDate(ctrlID,dtvalue)
{
        if(document.getElementById(ctrlID).value != "" &&
           document.getElementById(ctrlID.replace('textBox',"hidPreviousvalue")).value !=  document.getElementById(ctrlID).value)
        {
            if(document.getElementById(ctrlID).value != "")
                document.getElementById(ctrlID.replace('textBox','btnUpdate')).click();                
            
            document.getElementById("dpReqDt_textBox").focus();               
            return false;            
        }  
        
        document.getElementById(ctrlID.replace('textBox',"hidPreviousvalue")).value = document.getElementById(ctrlID).value; 
}

function trim(stringToTrim) 
{
	return stringToTrim.replace(/^\s+|\s+$/g,"");
}


function SetItemFocus(ctrlID)
{
    if(ctrlID=="dtqShdate_Image1")
    {
        document.getElementById("txtINo1").focus();
        document.getElementById("txtINo1").select();
    }
        
}
//-------------------------------------------------------------------------------
</script>
<asp:TextBox id="textBox" onclick="this.focus();" Width="55px" onblur="javascript:LoadDate(this.id,this.value); return false;"  runat="server"  CssClass="lbl_whitebox"></asp:TextBox>&nbsp;<asp:ImageButton id="Image1" CausesValidation="False" runat="server" ImageUrl="~/Common/Images/datepicker.gif" OnClientClick="javascript:return OpenDatePicker1(this.id,'textBox')" onfocusout="javascript:SetItemFocus(this.id);" ></asp:ImageButton>
<asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="textBox"
    ErrorMessage="Valid date format is MM/DD/YYYY" SetFocusOnError="True" ValidationExpression="^(((((0[1-9])|([1-9])|(1[02]))[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9])|(3[01])))|((([469])|(11))[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9])|(30)))|((02|2)[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9]))))[\-\/\s]?\d{4})(\s(((0[1-9])|([0-9])|(1[0-2]))\:(([0-5][0-9])|([0-9]))((\s)|(\:(([0-5][0-9])|([0-9]))\s))([AM|PM|am|pm]{2,2})))?$" CssClass="Required" Display="Dynamic"></asp:RegularExpressionValidator>
<asp:Button ID="btnUpdate" runat="server" Text="" Style="display:none;" OnClick="btnUpdate_Click" />
<asp:HiddenField ID="Hidname" runat="server"  />
<asp:HiddenField ID="hidPreviousvalue" runat="server"  />
 
