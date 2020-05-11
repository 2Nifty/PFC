<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" ValidateRequest="false"   CodeFile="FinReview.aspx.cs" Inherits="FinReview" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>GER Fin. Review</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css">
    <link href="../SalesAnalysisReport/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet"
        type="text/css" />
    <link href="../GER/Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
   
    <style>
    .PageBg 
    {
	    background-color: #B3E2F0;
	    padding: 1px;
    }    
    </style>

    <script language="javascript" src="Common/Javascript/ger.js"></script>

    <script language="javascript" src="Common/Javascript/ContextMenu.js"></script>
    

    <script language="javascript">
    <!--
    var strDeleteFlag=false;
    var deleteRowId='';
    var ctlID='';
    
function ShowToolTip(e,ctlIDVal)
{
    var list=document.getElementById("hidList").value;
    if (list != null)
    {
       if(list !="Processed")
        {
            if(navigator.appName == 'Microsoft Internet Explorer' && event.button==2)
            {
                ctlID= ctlIDVal;
                xstooltip_show('divToolTip',ctlID,289, 49);
                return false;
            }
            if ((navigator.appName == 'Netscape' || navigator.appName =='Mozilla Firefox') && e.which==3)
            {
                ctlID= ctlIDVal;
                xstooltip_show('divToolTip',ctlID,289, 49);
                return false;
            }
         }
      }
} 


-->
    </script>

</head>
<body >
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td valign=middle class=PageHead>
                       <span class=Left5pxPadd>
                       <asp:Label ID="lblParentMenuName" CssClass=BannerText runat="server" Text="Finance Review List - Detail"></asp:Label>
                       </span>
                </td>
            </tr>
            <tr>
                <td valign="top" width="100%">
                    <div id="div1-datagrid" style="vertical-align: top; position: relative; top: 0px;
                        left: 0px; height: 405px; width: 100%; border: 0px solid;">
                        <asp:UpdatePanel UpdateMode="Conditional" ID="plBillLoad" runat="server" RenderMode="inline">
                            <contenttemplate>
                             <div class="Sbar" id="div-datagrid" style="overflow-x:auto; overflow-y:auto; position:relative; top:0px;
                                    left: 0px; width: 100%; height: 500px; border: 0px solid;" >
                                <asp:DataGrid ID="dgFinReview" Width="100%" runat="server" GridLines="both" BorderWidth="1px"
                                    AutoGenerateColumns="false" BorderColor="#DAEEEF" 
                                    OnItemDataBound="dgFinReview_ItemDataBound" 
                                    OnItemCommand="dgFinReview_ItemCommand" >
                                    <HeaderStyle CssClass="GridHead" BackColor="#B6E6F4" BorderColor="#DAEEEF" />
                                    <ItemStyle CssClass="GridItem" BackColor="White" BorderColor="White" />
                                    <AlternatingItemStyle CssClass="GridItem" BackColor="#DCF3FB" BorderColor="#DAEEEF" />
                                    <Columns>
                                        <asp:TemplateColumn HeaderText="Close Line" ItemStyle-Width="80px">
                                            <ItemTemplate>
                                                 <asp:LinkButton ID="btnLineClose" CausesValidation="false" runat="server"
                                                    CommandName="Close" Text="Close Line"  BorderStyle="None" />
                                           </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="LicensePlateNo" SortExpression="LicensePlateNo" HeaderText="LPN #">
                                            <ItemStyle HorizontalAlign="Right"  Width="140px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="ItemNo" SortExpression="ItemNo" HeaderText="Item">
                                            <ItemStyle HorizontalAlign="Right"  Width="140px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="Qty" SortExpression="Qty" HeaderText="Qty Adjusted">
                                            <ItemStyle HorizontalAlign="Right"  Width="40px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="ReasonCd" SortExpression="ReasonCd" HeaderText="Reason">
                                            <ItemStyle HorizontalAlign="Right"  Width="40px" />
                                        </asp:BoundColumn>
                                        <asp:TemplateColumn HeaderText="View " ItemStyle-Width="200px">
                                            <ItemTemplate>
                                            <asp:HyperLink ID="ViewLink" runat="server" Target="_blank"
                                            NavigateUrl='' Text="View Detail" />
                                           </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="ContainerAdjustID" SortExpression="ContainerAdjustID" HeaderText="Adjustment ID">
                                            <ItemStyle HorizontalAlign="Right"  Width="140px" />
                                        </asp:BoundColumn>
                                    </Columns>
                                </asp:DataGrid>
                                </div>
                                <input id="hidSort" type="hidden" name="Hidden1" runat="server">
                                <asp:HiddenField ID="hidList" Value="" runat="server" />
                                <asp:HiddenField ID="hidFlag" runat="server"/>
                            </contenttemplate>
                        </asp:UpdatePanel>
                        
                    </div>
                </td>
            </tr>
            <tr>
                <td id="tdBottom">
                    <asp:UpdatePanel UpdateMode="Conditional" ID="FamilyPanel" runat="server">
                        <contenttemplate>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="PageBg">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                           <td style="width: 100px" class="splitBorder TabHead">
                                                                &nbsp;<asp:HiddenField id="hidPFCLocNo" runat="server" Value=""/>
                                                            </td>
                                                            <td style="width: 100px" class="splitBorder TabHead">
                                                                &nbsp;
                                                            </td>
                                                            <td style="width: 100px" class="splitBorder TabHead">
                                                                &nbsp;
                                                            </td>
                                                            <td style="width: 100px" class="splitBorder TabHead">
                                                                &nbsp;
                                                            </td>
                                                            <td class="splitBorder TabHead" colspan="7">
                                                                <div class="lblboxnopadding" style="width: 99%; padding-left: 5px">
                                                                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td align="left">&nbsp;
                                                                                </td>
                                                                            <td align="right" style="padding-right: 10px;">
                                                                                <asp:UpdateProgress ID="upPanel" runat="server">
                                                                                    <ProgressTemplate>
                                                                                        <span class="TabHead">Loading...</span></ProgressTemplate>
                                                                                </asp:UpdateProgress>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                            </td>
                                                            <td style="width: 100%" class="splitBorder TabHead">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="PageBg">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td align="left" class="splitBorder TabHead">
                                                                <asp:Label ID="lblErrorMessage" runat="server" CssClass="txtError"></asp:Label>
                                                                <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen" Width="240px"></asp:Label></td>
                                                            <td align="right" class="splitBorder TabHead" valign="bottom">
                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                       <td style="padding-left: 5px">
                                                                           <img src="common/Images/close.jpg" style="cursor:hand" 
                                                                           onclick="javascript: parent.window.close();">
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
                        </contenttemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="cmdLine" runat="server" />
                </td>
            </tr>
        </table>
        <div id="divToolTip" class="MarkItUp_ContextMenu_MenuTable" style="display: none;
            word-break: keep-all;" onmouseup='return false;'>
            <table width="125" border="0" cellpadding="0" cellspacing="0" bordercolor="#000099"
                class="MarkItUp_ContextMenu_Outline">
                <tr>
                    <td class="bgtxtbox">
                        <table width="100%" border="0" cellspacing="0">
                            <tr onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onclick="RowDelete();"
                                onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'" class="MarkItUp_ContextMenu_MenuItem">
                                <td valign="middle" style="width: 10%">
                                    <img src="../SalesAnalysisReport/Images/icorowdelete.gif" /></td>
                                <td width="90%" valign="middle">
                                    <div id="divCAS" style="vertical-align: middle;" class="MarkItUp_ContextMenu_MenuItem"
                                        onclick="RowDelete();">
                                        Delete</div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>

<script>
//setTimeout("SetEAUDivHeight()",300);
//window.parent.document.getElementById("Progress").style.display='none';
</script>

</html>
