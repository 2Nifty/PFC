<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ItemBuilder.aspx.cs" Inherits="ItemBuilder_Builder" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc4" %>
<%@ Register Src="Common/UserControls/ItemControl.ascx" TagName="ItemControl" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/ItemFamily.ascx" TagName="ItemFamily" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Cross-Reference Builder</title>
    <link href="Common/StyleSheets/StyleSheet.css" rel="stylesheet" type="text/css">

    <script type="text/javascript" src="Common/JavaScript/QuoteSystem.js"></script>

    <script type="text/javascript" src="Common/JavaScript/ItemBuilder.js"></script>

    <script type="text/javascript">
    
    var offX = 5;
    var offY = 10;
    function ToolTip(Item,evt)
    {	   
	    document.getElementById("ToolTip").style.top = evt.clientY+offY;
	    document.getElementById("ToolTip").style.left = evt.clientX+offX;
	    if(evt.type == "mouseover") {
		    document.getElementById("ToolTip").innerText = Item.alt;
		    document.getElementById("ToolTip").style.display = 'block';
	    }
	    if(evt.type == "mouseout") {
		    document.getElementById("ToolTip").style.display = 'none';
	    }
    }
        
    function ConvertKeyPress(txtCustNo)
    {
        if (event.keyCode==40) 
        {
            event.keyCode=9; 
            return event.keyCode 
        }

        if(event.keyCode == 38) 
        {
            var r = txtCustNo.match(/[\d\.]+/g);            
            var currentControlID = r[0];            
            var newControlID = parseInt(r[0],10) - 1;           
                      
            if(newControlID >0)
            {   
                var tempControlID = "";
                if(newControlID.toString().length ==1)
                    tempControlID = '0' + newControlID.toString();
                    
                previousTxtID = txtCustNo.replace(currentControlID,tempControlID)
                
                // If the previous control is label then find the next textbox
                if(document.getElementById(previousTxtID) == null)
                {
                    for(var i = newControlID; i>0; i--)
                    {
                        tempControlID = i;
                        if(i.toString().length == 1)
                            tempControlID ='0' + tempControlID; 
                        
                        previousTxtID = txtCustNo.replace(currentControlID,tempControlID)
                        if(document.getElementById(previousTxtID))
                        {
                            break;
                        }
                    }
                }
                
                if(document.getElementById(previousTxtID))
                    document.getElementById(previousTxtID).focus();                                
            }     
        }            
    }
   
    </script>

    <script language='JavaScript'>
    
    function DeleteCustomerReference(obj)
    {
        if(obj.checked)
        {
           if(ShowYesorNo('Do you want to delete selected Customer No.?'))
           {
              CallBtnClick(obj.id.replace('chkDelete','btnDelete'));
           }
           else
            obj.checked=false;
        }
    }
    //
    // Function to call the server side button click through javascript
    //
    function CallBtnClick(id)
    {
        var btnBind=document.getElementById(id);
            
           if (typeof btnBind == 'object')
           { 
                btnBind.click();
                return false; 
           } 
          return;
    }

    </script>
    
    <script>
    function confirmMsg()
    {   
      var sbool = confirm('Are you sure you want to delete?');
      alert(sbool);
      if (sbool)
      {
      return true;
      }
      else
      return false;
    }
 
    </script>
    
    <script language="vbscript">
    Function ShowYesorNo(strMsg)
    Dim intBtnClick
    intBtnClick=msgbox(strMsg,vbyesno,"Item Builder")
    if intBtnClick=6 then 
        ShowYesorNo= true 
    else 
        ShowYesorNo= false
     end if
    end Function
    </script>
    
    <script>
    function CheckEmpty(lblID,txtboxID)
    {
    
         var lblControl= document.getElementById(lblID);
         var txtControl = document.getElementById(txtboxID); 
         if(txtControl.value !="")     
         {
        
         txtControl.style.display="none";
         lblControl.style.display = "block"; 
         }
         else
         {
         txtControl.style.display="block";
         lblControl.style.display = "block";
         }
    }
    </script>

</head>
<body bgcolor="#ECF9FB">
    <form id="form1" runat="server">
    
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
      
        <table width="100%" border="0" cellspacing="0" cellpadding="0" id="table1">
            <tr>
                <td>
                    <uc4:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" id="table2">
                        <tr valign="top">
                            <td class="BlueBorder" style="width: 100%">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td id="5TD" class="blackTxt" style="height: 92px" width="100%">
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BorderAll"
                                                style="padding: 2px;">
                                                <tr>
                                                    <td class="PageHd"  valign="top" align="left" id="TDFamily">
                                                        <asp:UpdatePanel ID="FamilyPanel" UpdateMode="Conditional" runat="server">
                                                            <ContentTemplate>
                                                                <uc1:ItemFamily ID="UCItemFamily" runat="server" OnItemClick="UpdateItemLookup" />
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                    <td width="100%" valign="top" id="TDItem" border="0px" cellpadding="0" cellspacing="0px"
                                                        runat="server">                                                        
                                                        <asp:UpdatePanel ID="ControlPanel" UpdateMode="Conditional" runat="server">
                                                            <ContentTemplate>
                                                                <uc2:ItemControl ID="UCItemLookup" OnChange="ItemControl_OnChange" runat="server" />
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
