<%@ Page Language="C#"    AutoEventWireup="true"  CodeFile="QuoteEdit.aspx.cs" Inherits="RequestQuote_REFEdit" %>

<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc4" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Request For Quote</title>
    <link href="../RequestQuote/Common/StyleSheets/Quote.css" rel="stylesheet" type="text/css" />

    <script>
   
    
    function checkAmount(strID,strValue)
    {
        if(strValue =="")
        {
            document.getElementById(strID).focus();
        }
        else
        {
            var ctrlID= document.getElementById(strID.replace("txtQty" ,"txtPriceperUOM")).value;
            var ctrlExtAmt= document.getElementById(strID.replace("txtQty" ,"txtExtAmt"));
            var strarr=ctrlID.split("/");
            ctrlExtAmt.innerText=strarr[0] * strValue;
        }
    }
    
    function checkPriceAmount(strID,strValue)
    {
        if(strValue !="")            
        {
            var ctrlID= document.getElementById(strID.replace("txtPriceperUOM" ,"txtQty")).value;
            var ctrlExtAmt= document.getElementById(strID.replace("txtPriceperUOM" ,"txtExtAmt")); 
            var hidExt= document.getElementById(strID.replace("txtPriceperUOM" ,"hidExtAmt")); 
          
            ctrlExtAmt.innerText= roundNumber(ctrlID * strValue,2);
            hidExt.value= ctrlExtAmt.innerText;    
            document.getElementById(strID).value =strValue.toUpperCase();                     
        }
    }
  
    function roundNumber(num, dec) 
    {
	    var result = Math.round( Math.round( num * Math.pow( 10, dec + 1 ) ) / Math.pow( 10, 1 ) ) / Math.pow(10,dec);
	    return result;
    }
    
  function chkValidate(ctrlID,ctrlValue,strType)
  {
        var strarr=ctrlValue.split("/");  
   
    
  }
  
  function isInteger(s)
  {
	var i;
    for (i = 0; i < s.length; i++)
    {   
        // Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}
  
  
  function isAlphabetic(val)
   {
     if(val == null || val == 'undefined') 
          {
           return false;
          }
          
      else
      {
	        if (val.match(/^[a-zA-Z]+$/))
	        {
		        return true;
	        }
	        else
	        {
		        return false;
	        }	
     }
  }

  function checkQtyperUOM(strID,strValue)
  {
        if(strValue !="")           
        {
            var strCheck = (strValue.indexOf("/") > -1);
            if(!strCheck)
            {
                alert('Invalid Qty/UOM');
                document.getElementById(strID).value = '';
                document.getElementById(strID).focus();
           
                return false;
            } 
            document.getElementById(strID).value = strValue.toUpperCase();   
        }
    
  }
    
    
    </script>

</head>
<body bgcolor="#ECF9FB">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" id="table1">
            <tr>
                <td valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" id="table2">
                        <tr valign="top">
                            <td style="width: 100%">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td id="5TD" style="height: 92px" width="100%">
                                            <table class="BorderAll" width="100%" border="0" cellpadding="0" cellspacing="0"
                                                style="padding: 2px;">
                                                <tr>
                                                    <td style="border-right: 1px solid #7ecfe7;"  width="19%" valign="top"
                                                        align="left" id="TDFamily">
                                                        <table>
                                                            <tr>
                                                                <td style="width: 126px;">
                                                                    <table class="BorderAll" id="LeftMenu" border="0" cellspacing="0" cellpadding="0"
                                                                        style="width: 185px;">
                                                                        <tr>
                                                                            <td style="padding-top: 5px; border-bottom: 1px solid #7ecfe7;" bgcolor="#B8E3F3">
                                                                                <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Customer Information"></asp:Label></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td style="padding-top: 5px;" class="gridHeader">
                                                                                <asp:Label ID="lblCustomerName" runat="server" Font-Bold="True" Width="150px"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td style="padding-top: 5px;" class="gridHeader">
                                                                                <asp:Label ID="lblAddress" runat="server" Text="Label" Font-Bold="True"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td style="padding-top: 5px;" class="gridHeader">
                                                                                <asp:Label ID="lblCity" runat="server" Text="Label" Font-Bold="True"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td style="padding-top: 5px;" class="gridHeader">
                                                                                <asp:Label ID="lblState" runat="server" Text="Label" Font-Bold="True"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td style="padding-top: 5px;" class="gridHeader">
                                                                                <asp:Label ID="lblPostCd" runat="server" Text="Label" Font-Bold="True"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align=left style="width: 425px; padding-top: 20px;">
                                                                    <table class="BorderAll" border="0" cellspacing="0" cellpadding="0">
                                                                     <tr>
                                                                            <td style="padding-top: 5px; border-bottom: 1px solid #7ecfe7;" bgcolor="#B8E3F3">
                                                                                <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Quote Information"></asp:Label></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td align=left style="padding-top: 15px;">
                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                    <tr>
                                                                                        <td style="width: 100px">
                                                                                <asp:Label ID="Label1" Font-Bold="True" runat="server" Text="Your Reference # :" Width="120px"></asp:Label></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td style="width: 100px">
                                                                                            <asp:TextBox ID="txtRef" Width="120px" CssClass="formCtrl" runat="server" ReadOnly="True"></asp:TextBox></td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td style="padding-top: 15px;">
                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                    <tr>
                                                                                        <td style="width: 100px">
                                                                                <asp:Label ID="Label2" Font-Bold="True" runat="server" Text="RFQ ID #:"></asp:Label></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td style="width: 100px">
                                                                                <asp:Label ID="lblRFQID" Font-Bold="False" runat="server" Width="120px"></asp:Label></td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td style="padding-top: 15px;padding-bottom:5px;padding-right:3px;">
                                                                                <asp:Label ID="Label4" Font-Bold="True" runat="server" Text="Processed PFC Sales Person:" Width="165px"></asp:Label>
                                                                       
                                                                           
                                                                                <asp:TextBox ID="txtPFCSales" Width="160px" CssClass="formCtrl" runat="server"></asp:TextBox></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td width="100%" valign="top" id="TDItem" runat="server">
                                                        <table width="100%" border="0" height="700px" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td style="margin: 0px;" valign="top">
                                                                    <asp:UpdatePanel ID="ControlPanel" UpdateMode="Conditional" runat="server">
                                                                    <Triggers><asp:PostBackTrigger ControlID="imgExcel" /></Triggers>
                                                                        <ContentTemplate>
                                                                        
                                                                            <div id="divFilterItem" runat="server" style="height: 640px; width: 100%;">
                                                                                <table width="822" border="0" cellspacing="0" cellpadding="0" class="BorderLR">
                                                                                    <tr>
                                                                                        <td rowspan="2" class="tabBk" width="100">
                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <a href=RequestQuote.aspx target=_self>
                                                                                                            <img id="imgHome" src="Common/images/homenormal.gif" runat=server onmouseover="this.src='Common/images/home_over.gif'"
                                                                                                                onmouseout="this.src='Common/images/homenormal.gif'" border="0"></a></td>
                                                                                                    
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                        <td width="1" rowspan="2" class="tabBk" valign="middle">
                                                                                            <div align="right">
                                                                                                <img src="Common/images/tabcut.jpg" width="32" height="45"></div>
                                                                                        </td>
                                                                                        <td colspan="2" class="helpTopBg" valign="top">
                                                                                            <img src="Common/images/helpTopBg.jpg" width="0" height="13"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td align="right" valign="bottom" style="background-image: url(Common/images/helpBG.jpg);"
                                                                                            height="25">
                                                                                            <asp:ImageButton ID="imgExcel" ImageUrl="Common/images/ExporttoExcel.gif" height="22" style="cursor: hand;" runat="server" OnClick="imgExcel_Click" />
                                                                                            <%--<img src="Common/images/ExporttoExcel.gif"  height="22" style="cursor: hand;" runat="server" id="IMG4">--%>
                                                                                            <img id="Img2" height="22" onclick="javascript:PrintQuote();" src="Common/images/Print.gif"  style="cursor: hand;padding-left:5px;" runat="server">
                                                                                            <img id="Img3"  src="Common/images/PE.gif" onclick="javascript:window.close();" style="cursor: hand;padding-left:5px;"
                                                                                                height="22" runat="server">
                                                                                        </td>
                                                                                        <td style="background-image: url(Common/images/helpBG.jpg);">
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td colspan="4">
                                                                                            <img src="Common/images/topBase.jpg" height="3" width="100%"></td>
                                                                                    </tr>
                                                                                </table>
                                                                                <table  width="760" border="0" cellspacing="0"  cellpadding="0" class="BlueBorder">
                                                                                    <tr>
                                                                                        <td class="LoginFormBk">
                                                                                            <asp:UpdatePanel ID="upnlQuote" UpdateMode="Conditional" runat="server">
                                                                                                <ContentTemplate>
                                                                                                    <table >
                                                                                                        <tr id="tblQuote" runat=server>
                                                                                                            <td valign="top">
                                                                                                                <div id="div-datagrid" class="Sbar" style="overflow-x: auto; overflow-y: auto; position: relative;
                                                                                                                    top: 0px; left: 0px; height: 600px; width: 814px;" align="left">
                                                                                                                    <asp:DataGrid ID="dgRequestQuote" Width="814px" CssClass="grid" AllowSorting="True"
                                                                                                                        ShowFooter="False" AutoGenerateColumns="false" GridLines="None" runat="server"
                                                                                                                        OnItemDataBound="dgRequestQuote_ItemDataBound">
                                                                                                                        <HeaderStyle CssClass="gridHeader" ForeColor="black" HorizontalAlign="Center" />
                                                                                                                        <ItemStyle CssClass="GridItem" Height="20px" />
                                                                                                                        <AlternatingItemStyle CssClass="zebra" Height="20px" />
                                                                                                                        <Columns>
                                                                                                                            <asp:BoundColumn DataField="UseritemNo" HeaderText="Customer Item #"></asp:BoundColumn>
                                                                                                                            <asp:BoundColumn HeaderStyle-Width="250px" DataField="CustItemDesc" HeaderText="Size Description">
                                                                                                                            </asp:BoundColumn>
                                                                                                                            <asp:BoundColumn DataField="CustUOM" HeaderText="UOM"></asp:BoundColumn>
                                                                                                                            <asp:BoundColumn DataField="CustBxperQty" HeaderText="Bx/QTY"></asp:BoundColumn>
                                                                                                                            <asp:TemplateColumn HeaderText="PFC Item #" ItemStyle-Width="100">
                                                                                                                                <ItemTemplate>
                                                                                                                                    <asp:TextBox onfocus="javascript:this.select();" ID="txtPFCitem" onkeydown="if (event.keyCode==13) {event.keyCode=9; return event.keyCode }" CssClass="formCtrl"
                                                                                                                                        Width="90px" MaxLength="40" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.PFCItemNo") %>'></asp:TextBox>
                                                                                                                                    <asp:HiddenField ID="hidAltPrice" Value='<%# DataBinder.Eval(Container,"DataItem.AlternateUOM") %>'
                                                                                                                                        runat="server" />
                                                                                                                                    <asp:HiddenField ID="hidAltPriceUOM" Value='<%# DataBinder.Eval(Container,"DataItem.AlternateUOMQty") %>'
                                                                                                                                        runat="server" />
                                                                                                                                    <asp:HiddenField ID="hidBaseUOMQty" Value='<%# DataBinder.Eval(Container,"DataItem.BaseUOMQty") %>'
                                                                                                                                        runat="server" />
                                                                                                                                    <asp:HiddenField ID="hidBaseUOM" Value='<%# DataBinder.Eval(Container,"DataItem.BaseUOM") %>'
                                                                                                                                        runat="server" />
                                                                                                                                    <asp:HiddenField ID="hidID" Value='<%# DataBinder.Eval(Container,"DataItem.ID") %>'
                                                                                                                                        runat="server" />
                                                                                                                                        <asp:HiddenField ID="hidExtAmt" Value='<%# DataBinder.Eval(Container,"DataItem.TotalPrice") %>'
                                                                                                                                        runat="server" />
                                                                                                                                        <asp:HiddenField ID="hidCustNo" Value='<%# DataBinder.Eval(Container,"DataItem.UseritemNo") %>'
                                                                                                                                        runat="server" />
                                                                                                                                        <asp:HiddenField ID="hidDesc" Value='<%# DataBinder.Eval(Container,"DataItem.CustItemDesc") %>'
                                                                                                                                        runat="server" />
                                                                                                                                        <asp:HiddenField ID="hidUOM" Value='<%# DataBinder.Eval(Container,"DataItem.CustUOM") %>'
                                                                                                                                        runat="server" />
                                                                                                                                        <asp:HiddenField ID="hidBXPERUOM" Value='<%# DataBinder.Eval(Container,"DataItem.CustBxperQty") %>'
                                                                                                                                        runat="server" />
                                                                                                                                       
                                                                                                                                </ItemTemplate>
                                                                                                                            </asp:TemplateColumn>
                                                                                                                            <asp:TemplateColumn HeaderText="QTY">
                                                                                                                                <ItemTemplate>
                                                                                                                                    <asp:TextBox onfocus="javascript:this.select();" onkeydown="if (event.keyCode==13) {event.keyCode=9; return event.keyCode }" onkeypress="if (window.event.keyCode < 48 || window.event.keyCode > 58) window.event.keyCode = 0; "
                                                                                                                                        onblur="javascript:checkAmount(this.id,this.value);" ID="txtQty" CssClass="formCtrl"
                                                                                                                                        Width="30px" MaxLength="40" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.AvailableQuantity") %>'></asp:TextBox>
                                                                                                                                </ItemTemplate>
                                                                                                                            </asp:TemplateColumn>
                                                                                                                            <asp:TemplateColumn HeaderText="QTY/UOM">
                                                                                                                                <ItemTemplate>
                                                                                                                                    <asp:TextBox onfocus="javascript:this.select();" onkeydown="if (event.keyCode==13) {event.keyCode=9; return event.keyCode }" onblur="javascript:checkQtyperUOM(this.id,this.value);chkValidate(this.id,this.value,'BaseQty');"
                                                                                                                                        Width="50px" ID="txtQtyperUOM" CssClass="formCtrl" MaxLength="40" runat="server"></asp:TextBox>
                                                                                                                                </ItemTemplate>
                                                                                                                            </asp:TemplateColumn>
                                                                                                                            <asp:TemplateColumn HeaderText="Unit Price">
                                                                                                                                <ItemTemplate>
                                                                                                                                    <asp:TextBox onfocus="javascript:this.select();" onkeydown="if (event.keyCode==13) {event.keyCode=9; return event.keyCode }" onblur="javascript:checkPriceAmount(this.id,this.value);chkValidate(this.id,this.value,'PriceQty');"
                                                                                                                                        ID="txtPriceperUOM" Width="70px" CssClass="formCtrl" MaxLength="40" runat="server"></asp:TextBox>
                                                                                                                                </ItemTemplate>
                                                                                                                            </asp:TemplateColumn>
                                                                                                                            <asp:TemplateColumn HeaderText="Extented Amount">
                                                                                                                                <ItemTemplate>
                                                                                                                                    <%--<asp:TextBox onfocus="javascript:this.select();" ID="txtExtAmt"  Width="70px" CssClass="formCtrl" 
                                                                                                                                        MaxLength="40" runat="server"></asp:TextBox>--%>
                                                                                                                                    <asp:Label ID="txtExtAmt" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.TotalPrice") %>'></asp:Label>
                                                                                                                                </ItemTemplate>
                                                                                                                            </asp:TemplateColumn>
                                                                                                                        </Columns>
                                                                                                                    </asp:DataGrid>
                                                                                                                    <%-- <uc4:pager ID="Pager1" OnBubbleClick="Pager_PageChanged" runat="server" />--%>
                                                                                                                </div>
                                                                                                                <input type="hidden" id="hidSort" runat="server" tabindex="12" />
                                                                                                                <input type="hidden" id="hidFileName" runat="server"  />
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </ContentTemplate>
                                                                                            </asp:UpdatePanel>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                                <table class="PagerBk" width="100%">
                                                                                    <tr>
                                                                                        <td align="right">
                                                                                            <asp:Button CssClass="frmBtn" ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
                                                                                            <asp:Button CssClass="frmBtn" ID="btnCompleted" runat="server" Text="Quote Completed"
                                                                                                OnClick="btnCompleted_Click" />
                                                                                            <asp:Button CssClass="frmBtn" PostBackUrl="~/requestquote/requestquote.aspx" ID="Button1"
                                                                                                runat="server" Text="Close" /></td>
                                                                                    </tr>
                                                                                </table>
                                                                            </div>
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
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
<script type="text/javascript">
    function PrintQuote()
    {
        var prtContent = "<html><head><link href='Common/StyleSheets/Quote.css' rel='stylesheet' type='text/css' /></head><body>"
        prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td style='width:450px;'colspan=3><h3>Request For Quote</h3></td></tr>";
        prtContent = prtContent +"</table><br>"; 
            
        prtContent = prtContent + document.getElementById('div-datagrid').innerHTML;     
        prtContent = prtContent + "</body></html>";
        var WinPrint = window.open('','','letf=0,top=0,width=1,height=1,toolbar=0,scrollbars=0,status=0');
        WinPrint.document.write(prtContent);
        WinPrint.document.close();
        WinPrint.focus();
        WinPrint.print();
        WinPrint.close();
       // window.close();
    }
</script>