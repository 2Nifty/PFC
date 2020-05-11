<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SideMenu.aspx.cs" Inherits="SideMenu" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title></title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
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
                                                    <asp:MenuItem Text="<div onclick='return OpenPopups(09);'>Bill Of Materials Maintenance</div>" Value="Bill Of Materials Maintenance" />
                                                    <asp:MenuItem Text="<div onclick='return OpenPopups(11);'>Branch Stock Analysis</div>" Value="Branch Stock Analysis" />
                                                    <asp:MenuItem Text="<div onclick='return OpenPopups(21);'>CPR</div>" Value="CPR" />
                                                    <asp:MenuItem Text="<div onclick='return OpenPopups(31);'>Item Builder</div>" Value="Item Builder" />
                                                    <asp:MenuItem Text="<div onclick='return OpenPopups(41);'>Item Card</div>" Value="Item Card" />
                                                    <asp:MenuItem Text="<div onclick='return OpenPopups(51);'>Item Notes</div>" Value="Item Notes" />
                                                    <asp:MenuItem Text="<div onclick='return OpenPopups(61);'>Selected SKU</div>" Value="Selected SKU" />
                                                    <asp:MenuItem Text="<div onclick='return OpenPopups(71);'>Stock Status</div>" Value="Stock Status" />
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
        <asp:HiddenField ID="hidSOESiteURL" runat="server" />
    </form>
</body>
</html>

<script src="JavaScript/InventoryMgmt.js" type="text/javascript"></script>
<script type="text/javascript">
        function OpenPopups(formName)
        {
            var popUp;

            var itemNo="";
            if (parent.BodyFrame.form1.document.getElementById('lblItemNo') != null)
                itemNo = parent.BodyFrame.form1.document.getElementById('lblItemNo').innerText;
            var userID = '<%= Session["UserID"] %>';
            var userName = '<%= Session["UserName"] %>';
            //alert(userID + ' - ' + userName + ' - ' + itemNo);

            switch(formName)
            {
                case 09:
                    popUp=window.open ("../MaintenanceApps/BillOfMaterials.aspx?ItemNo=" + itemNo,"BOM",'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (600/2))+',left='+((screen.width/2) - (750/2))+',resizable=NO',"");
                    popUp.focus();
                    break;
                    
                case 11:
                    popUp=window.open ("../CPR/SKUAnalysis.aspx","BSA",'height=500,width=850,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                    popUp.focus();
                    break;

                case 21:
                    //TMD: Pass the itemNo directly to the CPRReport ?
                    //popUp=window.open ("../CPR/CPRReport.aspx?Item=" + itemNo + "&Factor=1","CPR",'height=500,width=850,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                    popUp=window.open ("../CPR/FrontEnd.aspx","CPR",'height=500,width=850,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                    popUp.focus();
                    break;
                    
                case 31:
                    popUp=window.open (document.getElementById("hidSOESiteURL").value + "SSItemBuilder.aspx","ItemBuilder",'height=750,width=950,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                    popUp.focus();
                    break;

                case 41:
                    //TMD: Pass the Loc ?
                    popUp=window.open (document.getElementById("hidSOESiteURL").value + "ItemCard.aspx?ItemNumber=" + itemNo + "&ShipLoc=","ItemCard",'height=375,width=750,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                    popUp.focus();
                    break;
                    
                case 51:
                    //alert('Item Notes application is currently under construction');
                    popUp=window.open ("ItemStandardComments.aspx?ItemNo=" + itemNo,"NOTES",'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (600/2))+',left='+((screen.width/2) - (750/2))+',resizable=NO',"");
                    popUp.focus();
                    break;
                    
                case 61:
                    popUp=window.open ("../SelectedSKU/SelectedSKUAnalysisPrompt.aspx","SelSKU",'height=700,width=900,scrollbars=yes,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                    popUp.focus();
                    break;

                case 71:
                    popUp=window.open (document.getElementById("hidSOESiteURL").value + "StockStatus.aspx?ItemNo=" + itemNo + "&UserID=" + userID + "&UserName=" + userName,"StkSts",'height=600,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                    popUp.focus();
                    break;
            }
            
            if (popUp !="undefined")
                return false;
        }  
    </script>