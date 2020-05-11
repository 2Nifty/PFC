<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerNoConfirm.aspx.cs" Inherits="CustomerActivitySheet_CustomerNoConfirm" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <link href="../CustomerActivitySheet/Styles/Styles.css" rel="stylesheet" type="text/css" />
    <script>
    function OpenCAS()
    {
        var url='<%=Request.QueryString["URL"] %>';
        url=url.replace(/~/g,"&");
        
        if(document.getElementById("txtCustomerNo").value!='')
        {
            if(IsNumeric(document.getElementById("txtCustomerNo").value))
            {
                url=url+"&CustNo=" +document.getElementById("txtCustomerNo").value.replace('&','||');
                window.open(url,"CustomerActivitySheet" ,'height=700,width=965,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (970/2))+',resizable=YES',"");
                window.close();
            }
            else
                document.getElementById("divMessage").innerHTML="Invalid Customer #";
        }
        else
            document.getElementById("divMessage").innerHTML="Customer # Required";
    }
    
    
    function IsNumeric(strString)
    {
       var strValidChars = "0123456789";
       var strChar;
       var blnResult = true;

       if (strString.length != 6) return false;

        //  test strString consists of valid characters listed above
        for (i = 0; i < strString.length && blnResult == true; i++)
        {
          strChar = strString.charAt(i);
          if (strValidChars.indexOf(strChar) == -1){blnResult = false;}
        }
       return blnResult;
    }
    </script>
</head>
<body style="margin:5px" >
    <form id="form1" runat="server" defaultfocus="txtCustomerNo">
        <table  border="0" cellspacing="0" cellpadding="0" class="BlueBorder" width="365">
            <tr><td  valign="middle" align=left class="HeadeBG" >
            <div align="left" style="padding-right:10px;"><img src="Images/PFCCAS.gif" width="294" height="15"  vspace="5"> </div></td></tr>
            <tr valign=middle class="SheetHead">
                <td  align=center >
                   <table width=80% >
                        <tr><td colspan=2><div  class="cnt" style="color:Red;height:20px;" id=divMessage></div></td></tr>
                        <tr valign=Top><td><div class=cnt>Enter Customer #</div></td><td><asp:TextBox ID=txtCustomerNo runat=server CssClass="FormControlsNopadding"></asp:TextBox></td></tr>
                        <tr><td></td><td><img ID=btnOk onclick="Javascript:OpenCAS();" src="../Common/Images/ok.gif" style="cursor:hand;" />&nbsp;&nbsp;<img id=imgClose src="../Common/Images/cancel.gif" style="cursor:hand;" onclick="Javascript:window.close();" /></td></tr>
                   </table>
                </td>
            </tr>
            <tr bgcolor="#DFF3F9"><td align=right><a href="http://www.novantus.com" target="_blank"><img src="../Common/Images/umbrellaPower.gif" border="0Px" alt="Powered By www.novantus.com"/></a></td></tr>
        </table>
    </form>
</body>
</html>
