<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PhoneNumber.ascx.cs" Inherits="PhoneNumber" %>
<script type="text/javascript">
//--------------------------------------------------------------------------
function ValidateKeyPress(e)
{
    if((navigator.appName == 'Netscape' || navigator.appName =='Mozilla Firefox'))
    {
        
        if ((e.which != 13) && (parseInt(e.which) < 47 || parseInt(e.which)> 57))
        {
            switch(parseInt(e.which))
            {
                case 45:
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
      if ((window.event.keyCode != 13) && (window.event.keyCode < 47 || window.event.keyCode > 57)) 
     {
         switch(window.event.keyCode)
        {
            case 45:
            case 40:
            case 41:
            break;
            default:
                window.event.keyCode = 0;
            break;
        }
      }
   
}
//--------------------------------------------------------------------------
function ValidatePhone(ctrl)
{
    
    var sender=document.getElementById(ctrl);
    var strPhoneValue=document.getElementById(ctrl).value;
    strPhoneValue=strPhoneValue.replace(/\s/g,'');
    strPhoneValue=strPhoneValue.replace(/\)/g,'');
    strPhoneValue=strPhoneValue.replace(/\(/g,'');
    strPhoneValue=strPhoneValue.replace(/\-/g,'');
    
    if(IsNumeric(strPhoneValue))
    {            
        switch(strPhoneValue.length)
        {
            case 10:
                 document.getElementById(ctrl).value=FormatPhone(strPhoneValue);
                 return true;
                 break;
            case 11:
                
                if(strPhoneValue.substring(0,1)=="1" || strPhoneValue.substring(0,1)=="0")
                {
                   document.getElementById(ctrl).value=FormatPhone(strPhoneValue);
                   return true;
                }
                else
                {
                    document.getElementById(ctrl).value=FormatPhone(strPhoneValue);
                    return true;
                }
                
            break;
            case 0:
                return true;
            break;
            default:
                document.getElementById(ctrl).value=FormatPhone(strPhoneValue);
                return true;
            break;
        }
    }
}
//--------------------------------------------------------------------------
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
//                    else
//                        args.IsValid=true;
                    
                break;
                case 0:
                    args.IsValid=true;
                break;
   
                default:
                    args.IsValid=true;
                break;
            }
        }
    else
        args.IsValid=false;
        
}
//--------------------------------------------------------------------------
function FormatPhone(strValue)
{
    if(strValue.length==10)
        strValue="("+strValue.substring(0,3)+")"+ " "+strValue.substring(3,6)+"-"+strValue.substring(6,strValue.length);
    else if(strValue.length==11)
    {
        if (strValue.substring(0,1) == "0" || strValue.substring(0,1) == "1")
            strValue=strValue.substring(0,1)+"-"+strValue.substring(1,4)+"-"+strValue.substring(4,7)+"-"+strValue.substring(7,strValue.length);
        else
            strValue=strValue;
    }
    else
        strValue=strValue;
        
    return strValue;
}
//--------------------------------------------------------------------------
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
            <asp:TextBox ID=txtPhone onkeypress="Javascript:ValidateKeyPress(event); if(window.event.keyCode ==13){DisplayConfirmMessage();}" runat=server CssClass=FormCtrl MaxLength="18" onblur="javascript:ValidatePhone(this.id);"></asp:TextBox>
           
        </td>
        <td>
            <asp:CustomValidator ID="cvPhone" ControlToValidate=txtPhone runat="server" CssClass="FormCtrl" Display="Dynamic"
                ErrorMessage="Invalid Data" ClientValidationFunction=ValidatePhoneNumber></asp:CustomValidator></td>
               
    </tr>
</table>