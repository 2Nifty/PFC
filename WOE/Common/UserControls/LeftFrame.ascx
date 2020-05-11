<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LeftFrame.ascx.cs" Inherits="PFC.SOE.UserControls.LeftFrame" %>
<table class=LeftBg" cellspacing="0" cellpadding="0" height="100%">
<tr>
<td valign="top" class="LeftBg">
<table id="LeftMenuContainer" width="180" border="0" cellspacing="0" cellpadding="2">
      <tr>
        <td class="ShowHideBarBk" id="HideLabel"><div align="right">Click to 
			hide this menu</div></td>
        <td width="1" class="ShowHideBarBk"><div align="right" id="SHButton"><img ID="Hide" style="cursor:hand" src="Common/Images/HidButton.gif" width="22" height="21" onclick="ShowHide(this)" onload="ShowHide(this)"></div></td>
      </tr>
      <tr valign="top">   
        </tr>
    </table>
    <table id="LeftMenu" width="100%"  border="0" cellspacing="0" cellpadding="0">
       <tr valign="top">
           <td width="100%" valign="top" >            
               <asp:Menu Width="100%" ID="Menu1" runat="server" ItemWrap=true MaximumDynamicDisplayLevels=25 >               
                <StaticHoverStyle CssClass="leftMenuItemMo" />
                   <StaticMenuStyle CssClass="leftMenuItem" Height="25px" />
                   <StaticMenuItemStyle CssClass="leftMenuItemBorder" Height="25px" HorizontalPadding="20px" />
                   <Items>
                       <asp:MenuItem Text="<div onclick='return OpenPopups(0);'>Comment Entry</div>" Value="Comment Entry" ></asp:MenuItem>                                               
                       <asp:MenuItem Text="<div onclick='return OpenPopups(1);'>Enter Expenses</div>" Value="Enter Expenses"></asp:MenuItem>                       
                       <asp:MenuItem Text="<div onclick='return OpenPopups(2);'>Item Card</div>" Value="Item Card"></asp:MenuItem>                       
                       <asp:MenuItem Text="<div onclick='return OpenPopups(3);'>PO Recall</div>" Value="PO Recall" ></asp:MenuItem>
                       <asp:MenuItem Text="<div onclick='return OpenPopups(4);'>SO Recall(WO)</div>" Value="SORecall(WO)"></asp:MenuItem>                       
                       <asp:MenuItem Text="<div onclick='return OpenPopups(5);'>Stock Status</div>" Value="Stock Status"></asp:MenuItem>
                       <asp:MenuItem Text="<div onclick='return OpenPopups(6);'>Vendor Card</div>" Value="Vendor Card"></asp:MenuItem>
                       <asp:MenuItem Text="<div onclick='return OpenPopups(7);'>Vendor Price Comparison</div>" Value="VendorPriceComp" ></asp:MenuItem>
                       <asp:MenuItem Text="<div onclick='return ChangeTo(0);'>WO Entry</div>" Value="WO Entry"></asp:MenuItem>
                       <asp:MenuItem Text="<div onclick='return OpenPopups(8);'>WO Find</div>" Value="WO Find"></asp:MenuItem>
                       <asp:MenuItem Text="<div onclick='return ChangeTo(1);'>WO Receipt</div>" Value="WO Receipt"></asp:MenuItem>
                   </Items>
                   <StaticSelectedStyle />
                </asp:Menu>    
           </td>       
       </tr>		 
      </table>
</td>
</tr>
</table>

<script>
    var QuickQuoteInstance = 1;
    
    function OpenPopups(formName)
    {
        var popUp;
        switch(formName)
        {
            case 0:
                LoadComment();           
            break;
            case 1:
                LoadExpense();		
            break;
            case 2:
                //popUp=window.open ("http://10.1.36.34/SOE/ItemCard.aspx","itemCard",'height=380,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                //popUp.focus();                
            break;
            case 5:
                LoadPage('StockStatus');		
            break;
            case 8:
                popUp=window.open ("WOFind.aspx","WOFind",'height=600,width=750,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                popUp.focus();                
            break;
        }
        if(popUp !="undefined")
            
        return false;
    }    
    
    function ChangeTo(option)
    {
        switch(option)
        {
            case 0:
                top.window.frames[0].document.getElementById("header").firstChild.innerHTML = "Work Order Entry"; 
                top.window.frames[2].document.location.href='WorkOrderEntry.aspx?UserName=' + parent.bodyFrame.form1.document.getElementById("hidStockStatusUser").value;           
            break;
            case 1:
                //alert(top.window.frames[0].document.getElementById("header")firstChild.innerHTML); 
                top.window.frames[0].document.getElementById("header").firstChild.innerHTML = "Work Order Receiving"; 
                top.window.frames[2].document.location.href='WorkOrderEntry.aspx?ProgMode=receiving&UserName=' + parent.bodyFrame.form1.document.getElementById("hidStockStatusUser").value;           
            break;
        }
        ShowHide(document.getElementById("SHButton").firstChild);          
        return false;
    }    
</script>