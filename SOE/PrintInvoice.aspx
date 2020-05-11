<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PrintInvoice.aspx.cs" Inherits="PrintInvoice" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Print Invoice</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>

    <style>
    .list
    {
	line-height:23px;
	background:#FFFFCC;
	padding:0px 10px;
	border:1px solid #FAEE9A;
	position:absolute;
	z-index:1;
	top:0px;
	}
	.boldText
    {
	font-weight: bold;
    }

    </style>
    <script >
    function AvailInvoice(orderNo)
    {
    var hwin=window.open('AvailableInvoice.aspx?OrderNo='+orderNo,'AvailableInvoice','height=350,width=400,toolbar=0,scrollbars=0,status=0,resizable=YES,top='+((screen.height/2) - (350/2))+',left='+((screen.width/2) - (400/2)));
    hwin.focus();
    }
    
    function GetInvoice(InvoiceNo)
    {
    var popup= window.open("GetInvoice.aspx?InvoiceNo="+InvoiceNo+"&CustomerNo=","Invoice",'height=727,width=890,toolbar=0,scrollbars=no,status=0,resizable=YES,top='+((screen.height/2) - (730/2))+',left='+((screen.width/2) - (890/2))+'','');
    popup.focus();
    }
    
    function LoadInvoice(mode)
    { 
       if(mode=='Order')
       { 
       CallBtnClick("btnOrder"); 
//        var btnid=document.getElementById("btnOrder");        
//            if (typeof btnid == 'object') 
//            {  
//                btnid.click();
//            }
        } 
        else 
        {
       
             CallBtnClick("btnInvoice");
//          var btnInvoiceId=document.getElementById("btnInvoice");
//             if (typeof btnInvoiceId == 'object')
//            { 
//                btnInvoiceId.click();
//            }
        }
        
     }
  
    
   
    </script>
</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="upnlSearch" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <table class="HeaderPanels" border="0" cellpadding="0" cellspacing="0" style="width: 100%;">
                    <tr>
                    
                        <td class="lightBg" style="padding: 5px;">
                            <table border="0" cellpadding="3" cellspacing="0" width="100%">
                                <tr>
                                <td>
                                        <asp:Label ID="lblOrderNo" runat="server" Font-Bold="True" Text="Sales Order Number"
                                            Width="115px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtOrderNo" runat="server" CssClass="lbl_whitebox" Width="114px" MaxLength="15" 
                                             TabIndex="1"> </asp:TextBox>
                                             <asp:Button ID="btnOrder" runat="server"  Style="display: none"
                                                  Text="Order " OnClick="btnOrder_Click" />
                                       
                                    </td>
                                    <td width="35%" align="right" >
                                       
                                            <img id="iclose" src="Common/Images/Close.gif" onclick="javascript:window.close();" />
                                    </td>
                                </tr>
                              
                                <tr class="lightBg">
                                    <td>
                                        <asp:Label ID="lblInvoice" runat="server" Font-Bold="True" Text="Invoice Number"
                                            Width="115px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtInvoiceNumber" runat="server" CssClass="lbl_whitebox" Width="114px"
                                            MaxLength="15"  TabIndex="2" > </asp:TextBox>
                                            
                                            <asp:Button ID="btnInvoice" runat="server"  Style="display: none"
                                                  Text="Invoice" OnClick="btnInvoice_Click"  />
                                    </td>
                                    <td width="35%" align="left">
                                    <asp:ImageButton ID="btnSearch" ImageUrl="~/Common/Images/Searcharrow.gif" runat ="server" OnClick="btnSearch_Click" /> 
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td height="5" width="100%">
                        </td>
                    </tr>
                    <tr>
                        <td>
                        <asp:UpdatePanel ID="upnlMessage" runat="server" UpdateMode="Conditional">
                             <ContentTemplate>
                            <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                            </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <uc2:Footer ID="Footer1" Title="Search for Invoice to Print" runat="server"></uc2:Footer>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>
