<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SideMenu.aspx.cs" Inherits="SideMenu" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title></title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script src="JavaScript/InventoryMgmt.js" type="text/javascript"></script>


<script>
    function OpenPopups(formName)
    {
        var popUp;
        switch(formName)
        {

            case 11:
                var itemno = "";
                var shipfrom = "";
                if(parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value !="")
                {
                    var ctrlId=parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value;
                    itemno = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblPFCItemNo')).innerText;
                    shipfrom = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblLocCode')).innerText;
                        
                }
                var queryString="ItemNumber="+itemno+"&ShipLoc="+shipfrom;
                popUp=window.open ("ItemCard.aspx?"+queryString,"Maximize",'height=380,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                popUp.focus();
                break;

             case 31:
                var itemno = "";
                var shipfrom = "";
                if(parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value !="")
                {
                    var ctrlId=parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value;
                    itemno = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblPFCItemNo')).innerText;
                    shipfrom = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblLocCode')).innerText;                        
                }
                var queryString="ItemNo="+itemno;
                popUp=window.open ("StockStatus.aspx?"+queryString,"Maximize",'height=650,width=1014,scrollbars=no,status=no,top='+((screen.height/2) - (560/2))+',left='+((screen.width/2) - (1014/2))+',resizable=NO',"");
                popUp.focus();
                break;
        }
        if(popUp !="undefined")
            
        return false;
    }    
</script>


</head>

<body class="LeftBg" onkeydown="return MenuShortCuts();">
    <form id="frmSideMenu" runat="server">
        <table id="tblTop" cellspacing="0" cellpadding="0" border="0">
            <tr>
                <td>
                    <table cellspacing="0" cellpadding="0">
                        <tr>
                            <td valign="top">
                                <table id="LeftMenuContainer" width="180" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td class="ShowHideBarBk" id="HideLabel">
                                            <div align="right">Click to hide this menu</div>
                                        </td>
                                        <td width="1" class="ShowHideBarBk">
                                            <div align="right" id="SHButton">
                                                <img id="Hide" style="cursor: hand" src="../Common/Images/HidButton.gif" width="22" height="21" onclick="ShowHide(this.value)">
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <table id="LeftMenu" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top">
                                        <td width="100%" valign="top">
                                            <asp:Menu Width="100%" ID="Menu1" runat="server" ItemWrap="true" MaximumDynamicDisplayLevels="25">
                                                <StaticHoverStyle CssClass="leftMenuItemMo" />
                                                <StaticMenuStyle CssClass="leftMenuItem" Height="25px" />
                                                <StaticMenuItemStyle CssClass="leftMenuItemBorder" Height="25px" HorizontalPadding="20px" />
                                                <Items>
                                                    <asp:MenuItem Text="<div onclick='return OpenPopups(1);'>Branch Maintenance</div>" Value="Branch Maintenance" />
                                                    <asp:MenuItem Text="<div onclick='return OpenPopups(11);'>Item Card</div>" Value="Item Card" />
                                                    <asp:MenuItem Text="<div onclick='return OpenPopups(21);' >Item Copy</div>" Value="Item Copy" />
                                                    <asp:MenuItem Text="<div onclick='return OpenPopups(31);' >Stock Status</div>" Value="Stock Status" />
                                                </Items>
                                                <StaticSelectedStyle />
                                            </asp:Menu>
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
