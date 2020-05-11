<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PhoneNumber.ascx.cs" Inherits="PhoneNumber" %>
<script>

function ValidateKeyPress(e)
{
    if((navigator.appName == 'Netscape' || navigator.appName =='Mozilla Firefox'))
    {
    
        if (parseInt(e.which) < 44 || parseInt(e.which)> 58)
        {
            switch(parseInt(e.which))
            {
                case 32:
                case 40:
                case 41:
                case 0:
                case 8:
                break;
                default:
                    e.preventDefault();
               break;
            }
          }
    }
    else
      if (window.event.keyCode < 44 || window.event.keyCode > 58) 
     {
         switch(window.event.keyCode)
        {
            case 32:
            case 40:
            case 41:
            break;
            default:
                window.event.keyCode = 0;
            break;
        }
      }
   
}
function ValidatePhone(ctrl)
{
    if (navigator.appName == 'Netscape' || navigator.appName =='Mozilla Firefox') 
    {
        var sender=document.getElementById("ucPhone_cvPhone");
        var strPhoneValue=document.getElementById("ucPhone_txtPhone").value;
        strPhoneValue=strPhoneValue.replace(/\s/g,'');
        strPhoneValue=strPhoneValue.replace(/\)/g,'');
        strPhoneValue=strPhoneValue.replace(/\(/g,'');
        strPhoneValue=strPhoneValue.replace(/\-/g,'');
        
        if(IsNumeric(strPhoneValue))
        {
            //document.getElementById(sender.id.replace("cvPhone","hidPhone")).value=strPhoneValue;
            
                switch(strPhoneValue.length)
                {
                    case 10:
                         document.getElementById(sender.id.replace("cvPhone","txtPhone")).value=FormatPhone(strPhoneValue);
                         return true;
                         break;
                    case 11:
                        
                        if(strPhoneValue.substring(0,1)=="1" || strPhoneValue.substring(0,1)=="0")
                        {
                           document.getElementById(sender.id.replace("cvPhone","txtPhone")).value=FormatPhone(strPhoneValue);
                           return true;
                        }
                        else
                        {
                            document.getElementById("ucPhone_txtPhone").value="";
                            document.getElementById(ctrl).focus();
                           
                        }
                        
                    break;
                    case 0:
                        return true;
                    break;
                    default:
                        document.getElementById("ucPhone_txtPhone").value="";
                        document.getElementById(ctrl).focus();
                    break;
                }
            }
        else
            {
                document.getElementById("ucPhone_txtPhone").value="";
                            document.getElementById(ctrl).focus();
            }
     
     }
        
}

function ValidatePhoneNumber(sender,args)
{
    
    var strPhoneValue=args.Value;
    strPhoneValue=strPhoneValue.replace(/\s/g,'');
    strPhoneValue=strPhoneValue.replace(/\)/g,'');
    strPhoneValue=strPhoneValue.replace(/\(/g,'');
    strPhoneValue=strPhoneValue.replace(/\-/g,'');
    
    if(IsNumeric(strPhoneValue))
    {
        //document.getElementById(sender.id.replace("cvPhone","hidPhone")).value=strPhoneValue;
        
            switch(strPhoneValue.length)
            {
                case 10:
                     document.getElementById(sender.id.replace("cvPhone","txtPhone")).value=FormatPhone(strPhoneValue);
                     args.IsValid=true;
                     break;
                case 11:
                    
                    if(strPhoneValue.substring(0,1)=="1" || strPhoneValue.substring(0,1)=="0")
                    {
                       document.getElementById(sender.id.replace("cvPhone","txtPhone")).value=FormatPhone(strPhoneValue);
                       args.IsValid=true;
                    }
                    else
                        args.IsValid=false;
                    
                break;
                case 0:
                    args.IsValid=true;
                break;
                default:
                    args.IsValid=false;
                break;
            }
        }
    else
        args.IsValid=false;
        
}

function FormatPhone(strValue)
{
    if(strValue.length==10)
        strValue="("+strValue.substring(0,3)+")"+ " "+strValue.substring(3,6)+"-"+strValue.substring(6,strValue.length);
    else
        strValue=strValue.substring(0,1)+"-"+strValue.substring(1,4)+"-"+strValue.substring(4,7)+"-"+strValue.substring(7,strValue.length);
    
    return strValue;
}

function IsNumeric(strString)
{
   var strValidChars = "0123456789";
   var strChar;
   var blnResult = true;

   if (strString.length < 1) return false;

    //  test strString consists of valid characters listed above
    for (i = 0; i < strString.length && blnResult == true; i++)
    {
      strChar = strString.charAt(i);
      if (strValidChars.indexOf(strChar) == -1){blnResult = false;}
    }
   return blnResult;
}
</script>
<table>
    <tr>
        <td>
            <asp:TextBox ID=txtPhone onkeypress="Javascript:ValidateKeyPress(event);" runat=server CssClass=cnt MaxLength="18" TabIndex="17" onblur="javascript:ValidatePhone('txtPhone');"></asp:TextBox>
           
        </td>
        <td>
            <asp:CustomValidator ID="cvPhone" ControlToValidate=txtPhone runat="server" CssClass="cnt" Display="Dynamic"
                ErrorMessage="Invalid Phone" ClientValidationFunction=ValidatePhoneNumber></asp:CustomValidator></td>
               
    </tr>
</table>