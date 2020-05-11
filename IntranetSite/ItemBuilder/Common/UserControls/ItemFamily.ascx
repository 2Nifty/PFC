<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ItemFamily.ascx.cs" Inherits="PFC.Intranet.ItemFamily" %>
<table class="LeftBg" border=0 cellspacing="0" cellpadding="0" id="mainTable">
    <tr>
        <td valign="top" class="LeftBg" style="height:650px;" >
            <table id="LeftMenuContainer" width="200" border="0" cellspacing="0">
                <tr>
                    <td  id="HideLabel" class="ShowHideBarBk">
                        <div align="right">
                            Click to hide family menu</div>
                    </td>
                    <td width="1" class="ShowHideBarBk">
                        <div align="right" id="SHButton">
                            <img id="Hide" style="cursor: hand" src="Common/Images/HidButton.gif" width="22"
                                height="21" onclick="ShowHide(this)" onload="LoadSideBar()"></div>
                    </td>
                </tr>
                <tr valign="top">
                </tr>
            </table>
            <table id="LeftMenu" width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr valign="top">
                    <td valign="top">
                        <asp:Menu ID="muItemFamily" runat="server" ItemWrap="true" MaximumDynamicDisplayLevels="25"
                            OnMenuItemClick="muItemFamily_MenuItemClick">
                            <StaticHoverStyle CssClass="MenuItemMo" />
                            <StaticMenuStyle CssClass="leftMenuItem" Height="25px" />
                            <StaticMenuItemStyle CssClass="leftMenuItemBorder" Height="25px" HorizontalPadding="20px" />
                            <StaticSelectedStyle CssClass="leftMenuItemMo" ForeColor="white" />
                        </asp:Menu>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
