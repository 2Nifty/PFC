<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LeftFrame.ascx.cs" Inherits="PFC.Intranet.UserControls.LeftFrame" %>
<table class=LeftBg" cellspacing="0" cellpadding="0" height="100%">
<tr>
<td valign="top" class="LeftBg">
<table id="LeftMenuContainer" width="230" border="0" cellspacing="0" cellpadding="2">
      <tr>
        <td class="ShowHideBarBk" id="HideLabel"><div align="right">Click to 
			hide this menu</div></td>
        <td width="1" class="ShowHideBarBk"><div align="right" id="SHButton"><img ID="Hide" style="cursor:hand" src="../Common/Images/HidButton.gif" width="22" height="21" onclick="ShowHide(this)"></div></td>
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
                </asp:Menu>    
           </td>       
       </tr>		 
      </table>
</td>
</tr>
</table>

      
      
      
      