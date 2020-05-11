<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HTIUnreceivedItems.aspx.cs"
    Inherits="UnReceivedItemsFrm" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>HTI Unreceived Product</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    
    <style>  
    
    .FormCtrl 
    {	
	    border: 1px solid #cccccc;
	    font-family: Arial, Helvetica, sans-serif;
	    font-size: 11px;
	    color: #000000;
	    width: 110px;
	    height: 18px;
    }
    
    </style>
    
    <script>
    function ValidateForm()
    {
        
        if(document.getElementById("txtBinLabel").value == "")
        {
            alert("' * ' Marked fields are mandatory")
             document.getElementById("txtBinLabel").focus();
             return false;
        }
        else if(document.getElementById("txtItemNo").value == "")
        {
             alert("' * ' Marked fields are mandatory")
             document.getElementById("txtItemNo").focus();
             return false;
        }
        
        // Do numeric validations
        if(document.getElementById("txtQty").value != "")
        {
            var _Qty = document.getElementById("txtQty").value;
            if(!((parseFloat(_Qty) == parseInt(_Qty)) && !isNaN(_Qty)))
            {
                alert("Invalid Quantity.");
                document.getElementById("txtQty").focus();
                return false;
            }
        }
        if(document.getElementById("txtPcsPer").value != "")
        {
            var _PcsPer = document.getElementById("txtPcsPer").value;
            if(!((parseFloat(_PcsPer) == parseInt(_PcsPer)) && !isNaN(_PcsPer)))
            {
                alert("Invalid Pieces Per.");
                document.getElementById("txtPcsPer").focus();
                return false;
            }
        }        
         
        return true;
    }
    

    function clickButton(e, txtBoxId)
    {
        var evt = e ? e : window.event;        
        if (evt.keyCode == 13)
        {
            // If item number field scanned fill the description from DB
            if( txtBoxId == 'txtItemNo' &&
                document.getElementById("txtItemNo").value != "")
            {
                if(document.getElementById("txtBinLabel").value == "")
                {
                    alert("Please enter Bin Label and then scan item number.");
                    document.getElementById("txtBinLabel").focus();
                    return false;
                }                    
            
                //if the item was scanned using gun it comes with "P" (we need to remove it)
                var firstChar = document.getElementById("txtItemNo").value.substring(0,1);
                if(firstChar.toLowerCase() == "p")
                    document.getElementById("txtItemNo").value = document.getElementById("txtItemNo").value.substring(1);
                
                // Get Item Description  
                document.getElementById("hidMode").value = "add";
                var result = UnReceivedItemsFrm.GetGTIItemDesc(document.getElementById("txtItemNo").value, document.getElementById("txtBinLabel").value ).value; 
                
                if(result != null && result[0] == "update")
                {
                    document.getElementById("hidMode").value =  result[0];
                    document.getElementById("txtDesc").value = result[1];
                    document.getElementById("txtQty").value = result[2];
                    document.getElementById("txtPcsPer").value = result[3];
                    document.getElementById("txtPackLabel").value = result[4];  
                    document.getElementById("hidPkId").value = result[5];                                       
                }
                else if(result != null)
                {
                    document.getElementById("txtDesc").value = result[1];
                }
                
                if(document.getElementById("txtDesc").value == "")
                    document.getElementById("txtDesc").focus();
                else
                    document.getElementById("txtQty").focus();
                    
                return false;
            }
        
            // If Qty field scanned we need to remove Q from first field
            if( txtBoxId == 'txtQty' &&
                document.getElementById("txtQty").value != "")
            {
                //if the item was scanned using gun it comes with "P" (we need to remove it)
                var firstChar = document.getElementById("txtQty").value.substring(0,1);
                if(firstChar.toLowerCase() == "q")
                    document.getElementById("txtQty").value = document.getElementById("txtQty").value.substring(1);
            }
        
            // If txtPcsPer field scanned we need to remove Q from first field
            if( txtBoxId == 'txtPcsPer' &&
                document.getElementById("txtPcsPer").value != "")
            {
                //if the item was scanned using gun it comes with "P" (we need to remove it)
                var firstChar = document.getElementById("txtPcsPer").value.substring(0,1);
                if(firstChar.toLowerCase() == "q")
                    document.getElementById("txtPcsPer").value = document.getElementById("txtPcsPer").value.substring(1);
            }
            
            if(document.getElementById("txtBinLabel").value == "")
            {
                document.getElementById("txtBinLabel").focus();
                return false;
            }
            else if(document.getElementById("txtItemNo").value == "")
            {
                document.getElementById("txtItemNo").focus();
                return false;
            }
            else if(document.getElementById("txtDesc").value == "")
            {
                document.getElementById("txtDesc").focus();
                return false;
            }
            else if(document.getElementById("txtQty").value == "")
            {
                document.getElementById("txtQty").focus();
                return false;
            }
            else if(document.getElementById("txtPcsPer").value == "")
            {
                document.getElementById("txtPcsPer").focus();
                return false;
            }    
            else
            {
                document.getElementById("btnSave").click();
            }
            return false;      
        }
        
    }
    
    function ClearForm()
    {
        document.getElementById("txtBinLabel").value = "";
        document.getElementById("txtItemNo").value = "";
        document.getElementById("txtDesc").value = "";
        document.getElementById("txtQty").value = "";
        document.getElementById("txtPcsPer").value = "";     
        
        document.getElementById("txtBinLabel").focus();   
        return false;         
    }
    
    </script>

</head>
<body scroll=no>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="scmHTIItems" runat="server" AsyncPostBackTimeout="360000"
            EnablePartialRendering="true">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="pnlPageContent" UpdateMode="conditional" runat="server">
            <ContentTemplate>
                <table class="HeaderPanels BluBordAll" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td class="PageHead" style="height:10px;">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td align="left" class="Left5pxPadd ">
                                        <asp:Label ID="lblHeader" ForeColor="#CC0000" runat="server" Text="HTI Unreceived Product"
                                            Font-Size="X-Small"></asp:Label></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align: top; padding-bottom: 5px; padding-top: 5px; padding-left: 5px;
                            background-color: White;">
                            <table cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <asp:Label CssClass="LabelCtl" ID="Label1" runat="server" Font-Bold="True" Text="Bin Label:" Width="100px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtBinLabel" runat="server" MaxLength="30" 
                                            onfocus="javascript:this.select();"
                                            onkeypress="return clickButton(event, 'txtBinLabel');"
                                            Width="120px" CssClass="FormCtrl"></asp:TextBox>
                                    <td style="padding-left: 5px;">
                                        <asp:Label ID="Label6" runat="server" ForeColor="Red" Text="*"></asp:Label></td>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Item Number:" Width="105px"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtItemNo" runat="server" CssClass="FormCtrl" Width="120px" MaxLength="30"
                                                onfocus="javascript:this.select();"
                                                
                                                onkeypress="return clickButton(event, 'txtItemNo');"></asp:TextBox>
                                        </td>
                                        <td style="padding-left: 5px;">
                                            <asp:Label ID="Label7" runat="server" ForeColor="Red" Text="*"></asp:Label></td>
                                    </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Description:" Width="100px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDesc" runat="server" CssClass="FormCtrl" Width="120px" MaxLength="20"
                                            onfocus="javascript:this.select();"
                                            onkeypress="return clickButton(event, 'txtDesc');"></asp:TextBox>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="Quantity:" Width="80px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtQty" runat="server" CssClass="FormCtrl" Width="120px" MaxLength="30"
                                            onfocus="javascript:this.select();"
                                            onkeypress="return clickButton(event, 'txtQty');"></asp:TextBox>
                                    </td>
                                    <td>
                                    </td>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Pieces per:" Width="80px"></asp:Label></td>
                                        <td>
                                            <asp:TextBox ID="txtPcsPer" runat="server" CssClass="FormCtrl" MaxLength="30" Width="120px"
                                                onfocus="javascript:this.select();"
                                                onkeypress="return clickButton(event, 'txtPcsPer');"></asp:TextBox></td>
                                        <td>
                                        </td>
                                    </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label8" runat="server" Font-Bold="True" Text="Package Label:" Width="90px"></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtPackLabel" runat="server" CssClass="FormCtrl" MaxLength="30"
                                            onfocus="javascript:this.select();" onkeypress="return clickButton(event, 'txtPcsPer');"
                                            Width="120px"></asp:TextBox></td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        </td>
                                    <td colspan="1">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 10px;padding-top:0px;padding-bottom:0px;" class="BluBg buttonBar Left5pxPadd">
                            <table cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="padding-left: 5px; padding-right: 3px" valign="top">
                                        <asp:ImageButton ImageUrl="~/WarehouseMgmt/Common/Images/BtnSave.gif" runat="server"
                                            ID="btnSave" OnClick="btnSave_Click" OnClientClick="javascript:return ValidateForm();" /></td>
                                    <td style="padding-left: 5px;" valign="top">                                        
                                        <asp:ImageButton ImageUrl="~/WarehouseMgmt/Common/Images/btnClear.gif" runat="server"
                                            ID="btnClear" OnClientClick="javascript:return ClearForm();" />
                                        <asp:HiddenField ID="hidMode" runat=server Value="" />
                                        <asp:HiddenField ID="hidPkId" runat=server Value="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>
<script>
document.getElementById("txtBinLabel").focus();
</script>
