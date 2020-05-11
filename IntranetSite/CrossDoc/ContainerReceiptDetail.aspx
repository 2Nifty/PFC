<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ContainerReceiptDetail.aspx.cs" Inherits="ContainerRcptDetail" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage2.ascx" TagName="Footer2" TagPrefix="uc2" %>
<%@ Register Src="../PrintUtility/Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script>
        function pageUnload() 
        {
            var status = ContainerRcptDetail.ReleaseSoftLock(document.getElementById('LPNLabel').innerText).value;
            if (status != "Released")
            {
                alert(status);
            }
            else
            {
                window.opener.document.getElementById('RefreshSubmit').click();
            }
        }

        function ClosePage()
        {
            window.close();	
        }

        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //take out room for bottom panel
            yh = yh - 140;
            xw = xw - 5
            // size the grid
            var DetailGridPanel = $get("DetailGridPanel");
            DetailGridPanel.style.height = yh;  
            DetailGridPanel.style.width = xw;  
            var DetailGridHeightHid = $get("DetailGridHeightHidden");
            DetailGridHeightHid.value = yh;
            var DetailGridHeightHid = $get("DetailGridWidthHidden");
            DetailGridHeightHid.value = xw;
        }
        
        function HideThis(ctl)
        {
            ctl.style.display = 'none';
        }
    </script>
    <style type="text/css">
    /* Styles */
    .blackLink
    {
	    cursor: hand;
	    font-weight: bold;
	    color: #000000;
	    text-decoration: underline;
    }

    .ws_whitebox 
    {
	    font-family:  Helvetica, Arial, sans-serif;
	    font-size: 11px;
	    color: #003366;	
	    background:#ffffff;	
	    border: 1px solid Gray;
	    font-weight:normal;
	    height: 12px;
	    padding-top: 2px;
	    padding-right: 2px;
	    padding-bottom: 3px;
	    padding-left: 2px;
	    text-align: right;
    }
    .noDisplay
    {
	    display: none;
    }
    </style>

    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <title>License Plate Detail</title>
</head>
<body onload="SetHeight();" onresize="SetHeight();" >
    <form id="form1" runat="server">
    <asp:ScriptManager ID="LPNSummScriptManager" runat="server" EnablePartialRendering="true" AsyncPostBackTimeout="600" />
    <div>
        <table width="100%" cellspacing="0" cellpadding="0" border="0">
            <tr>
                <td>
                    <uc1:Header id="Pageheader" runat="server">
                    </uc1:Header>

                </td>
            </tr>
            <tr>
                <td  class="BluBg bottombluebor" style="height:20px;">
                <span class="BannerText">&nbsp;&nbsp;&nbsp;&nbsp;Warehouse Container Detail</span>
                </td>
            </tr>
            <tr>
                <td class="BluBg bottombluebor">
                    <table width="100%">
                        <tr>
                            <td align="right">
                            </td>
                            <td align="left">
                            </td>
                            <td>
                            </td>
                            <td>&nbsp;<b>Location:
                                &nbsp;<asp:Label ID="LocLabel" runat="server"></asp:Label></b>
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>License Plate Number
                                &nbsp;<asp:Label ID="LPNLabel" runat="server"></asp:Label></b>
                            </td>
                            <td style="width:75px;">
															<asp:UpdatePanel ID="PrintUpdatePanel" runat="server" UpdateMode="Conditional">
																	<contenttemplate>
																					<uc3:PrintDialogue id="Print" runat="server" EnableFax="true">
																					</uc3:PrintDialogue>
																			</contenttemplate>
															</asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Panel ID="DetailGridPanel" runat="server"  ScrollBars="both" Height="500px" Width="980px">
                        <asp:HiddenField ID="DetailGridHeightHidden" runat="server" />
                        <asp:HiddenField ID="DetailGridWidthHidden" runat="server" />
										<asp:UpdatePanel ID="DetailGridUpdatePanel" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                    <asp:GridView ID="LPNGridView" runat="server" HeaderStyle-CssClass="GridHead"  AutoGenerateColumns="false"
                    RowStyle-BackColor="#FFFFFF" RowStyle-CssClass="Left5pxPadd" AllowSorting="true" OnSorting="SortDetailGrid"
                    PagerSettings-Position="TopAndBottom" PageSize="22" onpageindexchanging="DetailGridView_PageIndexChanging"
                    AllowPaging="true" PagerSettings-Visible="true" PagerSettings-Mode="Numeric"
                    >
                    <AlternatingRowStyle CssClass="Left5pxPadd" BackColor="#DCF3FB" BorderColor="#DAEEEF" />
                    <Columns>
                        <asp:BoundField DataField="FinalLocationCode" HeaderText="XFer To" ItemStyle-HorizontalAlign="center" 
                            ItemStyle-CssClass="rightBorder" ItemStyle-Width="110px" HeaderStyle-HorizontalAlign="Center"
                            SortExpression="FinalLocationCode" />
                        <asp:BoundField DataField="ItemNo" HeaderText="Item Number" ItemStyle-HorizontalAlign="center" 
                            ItemStyle-CssClass="rightBorder" ItemStyle-Width="110px" HeaderStyle-HorizontalAlign="Center"
                            SortExpression="ItemNo" />
                        <asp:BoundField DataField="DateCreate" HeaderText="Create Date" ItemStyle-HorizontalAlign="center" 
                            DataFormatString="{0:MM/dd/yyyy}" ItemStyle-CssClass="rightBorder" ItemStyle-Width="70px" 
                            SortExpression="DateCreate" HeaderStyle-HorizontalAlign="Center"/>
                        <asp:BoundField DataField="ToRcvQty" HeaderText="To Receive" DataFormatString="{0:###,##0} "
                            ItemStyle-Width="80" SortExpression="ToRcvQty" ItemStyle-HorizontalAlign="Right"
                            HeaderStyle-HorizontalAlign="center" />
                        <asp:BoundField DataField="BOLNo" HeaderText="BOL Number" ItemStyle-HorizontalAlign="left" 
                            ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="110px" HeaderStyle-HorizontalAlign="Center"
                            SortExpression="BOLNo" />
                        <asp:BoundField DataField="ContainerNo" HeaderText="Container Number" ItemStyle-HorizontalAlign="left" 
                            ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="110px" HeaderStyle-HorizontalAlign="Center"
                            SortExpression="ContainerNo" />
                    </Columns>
                    </asp:GridView>
                    </ContentTemplate>
                    </asp:UpdatePanel>
                    </asp:Panel>
               </td>
            </tr>
            <tr>
                <td class="BluBg">
                    <table width="100%">
                        <tr>
                            <td align="left">&nbsp;&nbsp;&nbsp;
                            <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>&nbsp;
                                <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                            </ContentTemplate></asp:UpdatePanel>
                            </td>
                            <td>&nbsp;
                                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="ActionUpdatePanel">
                                    <ProgressTemplate>
                                    <span style="color:ForestGreen; font-weight:bold;">CROSS DOCK TRANSFER ORDERS GENERATING, DO NOT CLOSE PAGE!!!</span>
                                    </ProgressTemplate>
                                    </asp:UpdateProgress>
                            </td>
                            <td align="right">
                                <asp:UpdatePanel ID="ActionUpdatePanel" runat="server">
                                <ContentTemplate>
                                <asp:ImageButton id="ApproveSubmit" name="ApproveSubmit" OnClick="ApproveSubmit_Click" AlternateText="Make the Transfers shown Above"
                                    runat="server" ImageUrl="../Common/Images/Approve.gif" CausesValidation="false" onClientClick="HideThis(this);"/>
                                <img src="../Common/Images/close.gif" style="cursor: hand" onclick="ClosePage();" alt="Close Page">
                                </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                    

                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer2 id="PageFooter2" runat="server">
                    </uc2:Footer2>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
