<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="XDocRecommendations.aspx.cs" Inherits="XDocRecommendations" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/newfooter.ascx" TagName="BottomFooter" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Container Recommendations</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../ReadyToShip/Common/StyleSheet/RTS_Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" language="javascript">
        var CommitValid = true;
        var ErrCtl = "";
        function pageUnload() 
        {
            var status = XDocRecommendations.ReleaseSoftLock(document.getElementById('lblContainer').innerText).value;
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

        function AdjustHeight()
        {
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //take out room for bottom panel
            yh = yh - 155;
            xw = xw - 5
            // size the grid
            var DetailGridPanel = $get("div1");
            DetailGridPanel.style.height = yh;  
            var OtherGridPanel = $get("div-datagrid");
            OtherGridPanel.style.height = yh - 190;  
        }
       
        function NavigateGrid(ctl)
        {
            if (!CommitValid)
            {
                event.keyCode=0;
                return false;
            }
            var ItemGrid = document.getElementById('dgItemDtl');
            if (ItemGrid != null)
            {
                var BrInputs = ItemGrid.getElementsByTagName("INPUT");
                for (var i = 0, il = BrInputs.length - 1; i < il; i++)
                {
                    // if we found our row, move to the next one
                    if (BrInputs[i].id == ctl.id)
                    {
                        if (i < il)
                        {
                            // jump to get over the hidden item numbers and non displayed inputs
                            if ((BrInputs[i + 1].type != 'hidden') && (BrInputs[i + 1].style.display != 'none')) 
                            {
                                BrInputs[i + 1].focus();
                                il = i;
                            }
                            else if ((i+1 < il) && (BrInputs[i + 2].type != 'hidden') && (BrInputs[i + 2].style.display != 'none'))  
                            {
                                BrInputs[i + 2].focus();
                                il = i;
                            }
                            else if ((i+2 < il) && (BrInputs[i + 3].type != 'hidden') && (BrInputs[i + 3].style.display != 'none'))  
                            {
                                BrInputs[i + 3].focus();
                                il = i;
                            }
                            else if ((i+3 < il) && (BrInputs[i + 4].type != 'hidden') && (BrInputs[i + 4].style.display != 'none'))  
                            {
                                BrInputs[i + 4].focus();
                                il = i;
                            }
                            else if ((i+4 < il) && (BrInputs[i + 5].type != 'hidden') && (BrInputs[i + 5].style.display != 'none'))  
                            {
                                BrInputs[i + 5].focus();
                                il = i;
                            }
                            else if ((i+5 < il) && (BrInputs[i + 6].type != 'hidden') && (BrInputs[i + 6].style.display != 'none'))  
                            {
                                BrInputs[i + 6].focus();
                                il = i;
                            }
                        }
                        else
                        {
                            //document.getElementById('btnAccept').focus();
                        }
                    }
                }
            }
            event.keyCode=0;
            return false;                
            //alert(status);
        }
        
        function CommitQty(ctl)
        {
            CommitValid = false;
            if (ctl.parentNode.tagName == "TD")
            {
                var LineParent = ctl.parentNode.parentNode;
            }
            else
            {
                var LineParent = ctl.parentNode.parentNode.parentNode;
            }
            //alert(LineParent.childNodes[0].innerText);
            var Loc = LineParent.childNodes[0].innerText
            var CurItemQty = document.getElementById('lblContItemQty').innerText
            // Update the field in the session data table
            var status = XDocRecommendations.UpdCommitQty(Loc, ctl.value, CurItemQty).value;
            document.getElementById('lblMessage').innerText = "";
            if (status != "OK")
            {
                ctl.focus();
                document.getElementById('lblMessage').innerText = status;
                document.getElementById('btnAccept').style.display = "none";
                ErrCtl = ctl.id;
            }
            else
            {
                RefreshCommitted();
                CommitValid = true;
                document.getElementById('btnAccept').style.display = "inline";
                ErrCtl = "";
            }
            //alert(status);
        }
        
        function RefreshCommitted()
        {
        /*
            */
            var CurItemQty = document.getElementById('lblContItemQty').innerText        
            // Sum the locations in the session data table
            var CurCommitQty = XDocRecommendations.SumCommitQty().value;
            document.getElementById('lblCommittedQty').innerText = CurCommitQty;
            document.getElementById('CommitTot').innerText = CurCommitQty;
            //alert(CurCommitQty); 
            var CurRemainQty = parseInt(CurItemQty.replace(",",""), 10) - parseInt(CurCommitQty, 10);
            document.getElementById('lblRemainingQty').innerText = CurRemainQty;
            // update the territory totals
            var ItemGrid = document.getElementById('dgItemDtl');
            if (ItemGrid != null)
            {
                var TerrQty = 0;
                var BrRows = ItemGrid.rows;
                for (var i = 1, il = BrRows.length; i < il; i++)
                {
                    var BrRow = BrRows[i];
                    // run a total until we hit a Sum
                    var Col0 = BrRow.childNodes[0].innerText.replace(/\s/g,'');
                    if (Col0.length == 2)
                    {
                        var LineQty = BrRow.childNodes[11].childNodes[0];
                        TerrQty = TerrQty + parseInt(LineQty.value, 10)
                        //alert('T:' + TerrQty + ' L:' + LineQty.value); 
                    }
                    if ((Col0.length != 2) && (Col0.length != 14))
                    {
                        var SumQty = BrRow.childNodes[11];
                        //alert(SumQty.innerText); 
                        SumQty.innerText = TerrQty;
                        TerrQty = 0;
                    }
                }
            }
        }


        function CPRReport()
        {
            if (document.getElementById('CPRFactor').value == "" || document.getElementById('CPRFactor').value == null || document.getElementById('CPRFactor').value.search(/\d+/) == -1 || document.getElementById('CPRFactor').value.search(/[a-zA-Z]/) != -1)
            {
                alert("To run the CPR report you must enter a numeric factor");
                document.getElementById('CPRFactor').focus();
            }
            else
            {
                CPRWin = window.open("../CPR/CPRReport.aspx?Item=" + document.getElementById('ddlItemNo').value + "&Factor=" + document.getElementById('CPRFactor').value,"CPRReport","height=768,width=1024,scrollbars=yes,location=no,status=no,top="+((screen.height/2) - (760/2))+",left=0,resizable=YES","");
            }
        }
    </script>

</head>
<body scroll="no" onLoad="AdjustHeight();" onResize="AdjustHeight();"
    onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <div id="Container" style="height: 100%">
            <uc1:Header ID="Header1" runat="server" />
            <div id="Content">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td valign="top" class="shadeBgDown">
                            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                <tr>
                                    <td valign="top" rowspan="3">
                                        <table border="0" cellpadding="2" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td>
                                                    <asp:UpdatePanel ID="pnlItemDetails" runat="server" UpdateMode="conditional">
                                                        <ContentTemplate>
                                                            <table width="100%" class=" blueBorder ItemHeader" border="0" cellspacing="0" cellpadding="2">
                                                                <tr>
                                                                    <td>
                                                                        <table border="0" cellspacing="0" cellpadding="1">
                                                                            <tr>
                                                                                <td style="width: 40px; padding-left: 10px;">
                                                                                    <strong>
                                                                                        Items</strong></td>
                                                                                <td width="250" colspan="5">
                                                                                    <strong>
                                                                                        <asp:DropDownList ID="ddlItemNo" runat="server" CssClass="FormCtrl" Width="150px"
                                                                                            AutoPostBack="True" OnSelectedIndexChanged="ddlItemNo_SelectedIndexChanged">
                                                                                        </asp:DropDownList></strong>
                                                                                </td>
                                                                                <td align="right">
                                                                                    <a onclick="javascript:CPRReport();" style="cursor: hand" class="redhead" title="CLICK HERE TO RUN A CPR REPORT FOR THIS ITEM">
                                                                                        CPR Report</a> Factor:
                                                                                    <asp:TextBox ID="CPRFactor" runat="server" Width="30px" ToolTip="Enter the FACTOR for the CPR Report"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <%--Branch Item Details Panel width: 540px;--%>
                                                    <asp:UpdatePanel ID="pnlShipDetails" runat="server" UpdateMode="conditional" ChildrenAsTriggers="false" >
                                                        <ContentTemplate>
                                                            <div class="blueBorder">
                                                                <div id="div1" class="Sbar" align="left" style="overflow-x: hidden; overflow-y: auto;
                                                                    position: relative; top: 0px; left: 0px; height: 595px; border: 0px solid;">
                                                                    <asp:DataGrid CssClass="grid BlueBorder" BackColor="white" Width="97%" ID="dgItemDtl"
                                                                        GridLines="both" runat="server" AutoGenerateColumns="false"
                                                                        UseAccessibleHeader="true" OnItemDataBound="dgItemDtl_ItemDataBound" ShowFooter="True">
                                                                        <HeaderStyle CssClass="gridHeader1" Height="18px" HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="gridItem TestRow" Wrap="False" />
                                                                        <AlternatingItemStyle CssClass="zebra TestRow" />
                                                                        <FooterStyle Font-Bold="True" ForeColor="#003366" CssClass="lightBlueBg" VerticalAlign="Top" HorizontalAlign="Right" />
                                                                        <Columns>
                                                                            <asp:TemplateColumn HeaderText="Br" SortExpression="LocationCode">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="LocID" runat="server" Width="65px"
                                                                                    Text='<%#DataBinder.Eval(Container,"DataItem.LocationCode")%>'></asp:Label>    
                                                                                    <asp:HiddenField ID="hidItemNo" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.ItemNo")%>' />
                                                                                </ItemTemplate>
                                                                                <FooterTemplate>
                                                                                    <table cellpadding="0" cellspacing="0" width="100%" align="left" class="noBorder">
                                                                                        <tr>
                                                                                            <td style="height: 15px" align="left" nowrap="nowrap">
                                                                                                <asp:Label Font-Bold="true" ForeColor="#003366" ID="lblItmNo" runat="server"></asp:Label></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </FooterTemplate>
                                                                                <ItemStyle HorizontalAlign="Center" />
                                                                                <HeaderStyle Width="50px" />
                                                                            </asp:TemplateColumn>
                                                                            
                                                                            <asp:BoundColumn DataField="SVCode" SortExpression="SVCode" HeaderText="SV">
                                                                                <ItemStyle HorizontalAlign="Center" />
                                                                                <HeaderStyle Width="15px" HorizontalAlign="center" />
                                                                            </asp:BoundColumn>
                                                                            
                                                                            <asp:BoundColumn DataField="ROPHubCalc" DataFormatString="{0:#,##0.0}" SortExpression="ROPHubCalc"
                                                                                HeaderText="ROP">
                                                                                <HeaderStyle Width="40px" />
                                                                                <ItemStyle HorizontalAlign="Right" />
                                                                            </asp:BoundColumn>
                                                                            
                                                                            <asp:BoundColumn DataField="ROPDays" DataFormatString="{0:#,##0}" SortExpression="ROPDays"
                                                                                HeaderText="Days">
                                                                                <HeaderStyle Width="40px" />
                                                                                <ItemStyle HorizontalAlign="Right" />
                                                                            </asp:BoundColumn>
                                                                            
                                                                            <asp:BoundColumn DataField="AvailQty" DataFormatString="{0:#,##0}" SortExpression="AvailQty"
                                                                                HeaderText="Avl">
                                                                                <ItemStyle HorizontalAlign="Right" />
                                                                                <HeaderStyle Width="40px" />
                                                                            </asp:BoundColumn>
                                                                            
                                                                            <asp:BoundColumn DataField="RTSBQty" DataFormatString="{0:#,##0}" HeaderText="RTSB"
                                                                                SortExpression="RTSBQty">
                                                                                <ItemStyle HorizontalAlign="Right" />
                                                                                <HeaderStyle Width="40px" />
                                                                            </asp:BoundColumn>
                                                                            
                                                                            <asp:BoundColumn DataField="Avail_Mos" DataFormatString="{0:#,##0.0}" HeaderText="Avl Mos">
                                                                                <HeaderStyle Width="50px" />
                                                                                <ItemStyle HorizontalAlign="Right" />
                                                                            </asp:BoundColumn>
                                                                            
                                                                            <asp:BoundColumn DataField="InTransit" DataFormatString="{0:#,##0}" SortExpression="InTransit"
                                                                                HeaderText="Trf OW">
                                                                                <HeaderStyle Width="55px" />
                                                                                <ItemStyle HorizontalAlign="Right" />
                                                                            </asp:BoundColumn>

                                                                            <asp:BoundColumn HeaderText="Alloc" DataField="Allocated" DataFormatString="{0:#,##0}"
                                                                                SortExpression="Allocated">
                                                                                <ItemStyle HorizontalAlign="Right" Width="55px" />
                                                                                <FooterStyle HorizontalAlign="Right" />
                                                                            </asp:BoundColumn>
                                                                            
                                                                            <asp:BoundColumn HeaderText="Req'd" DataField="Need" DataFormatString="{0:#,##0}"
                                                                                SortExpression="Need">
                                                                                <ItemStyle HorizontalAlign="Right" Width="55px" />
                                                                                <FooterStyle HorizontalAlign="Right" />
                                                                            </asp:BoundColumn>
                                                                            
                                                                            <asp:BoundColumn HeaderText="S E" DataField="SuperEquivQty" DataFormatString="{0:#,##0.0}"
                                                                                SortExpression="SuperEquivQty">
                                                                                <ItemStyle HorizontalAlign="Right" Width="55px" />
                                                                                <FooterStyle HorizontalAlign="Right" />
                                                                            </asp:BoundColumn>

                                                                            <asp:TemplateColumn HeaderText="Comm." SortExpression="CommitQty">
                                                                                <HeaderStyle Width="75px" />
                                                                                <ItemStyle HorizontalAlign="Right" />
                                                                                <ItemTemplate>
                                                                                    <asp:TextBox ID="txtCommit" runat="server" onBlur="javascript:if ((CommitValid)||(ErrCtl == this.id)){CommitQty(this);}" 
                                                                                    onkeypress="javascript:if(event.keyCode==13){CommitQty(this); if (CommitValid){return NavigateGrid(this);} else {event.keyCode=0;return false;}}"
                                                                                    onFocus="this.select();CallCount=0;" Width="65px"  
                                                                                    Text='<%#DataBinder.Eval(Container,"DataItem.CommitQty","{0:#,##0}")%>' CssClass="txtRight" ></asp:TextBox>    
                                                                                    <asp:Label ID="lblCommit" runat="server" Width="65px" 
                                                                                    Text='<%#DataBinder.Eval(Container,"DataItem.CommitQty","{0:#,##0}")%>' ></asp:Label>    
                                                                                </ItemTemplate>
                                                                                <FooterStyle VerticalAlign="Top" />
                                                                            </asp:TemplateColumn>
                                                                        </Columns>
                                                                    </asp:DataGrid>
                                                                    <asp:Label ID="lblBrMsg" Font-Bold="true" runat="server" Text="No Records Found"></asp:Label>
                                                                    <asp:HiddenField ID="hidBranch" runat="server" />
                                                                    <input type="hidden" id="hidSortBranch" runat="server" />
                                                                </div>
                                                            </div>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                    <%--End Branch Item Details Panel--%>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" class="blueBorder shadeBgDown">
                                        <asp:UpdatePanel ID="pnlVendorItemDetails" runat="server" UpdateMode="conditional">
                                            <ContentTemplate>
                                                <table width="100%">
                                                    <tr>
                                                        <td width="100%" class="blueBorder TabCntBk" style="padding: 5px">
                                                            <%--Item Details--%>
                                                            <table border="0" cellspacing="0" cellpadding="1" width="100%">
                                                                <tr>
                                                                    <td>Description :
                                                                    </td>
                                                                    <td colspan="5" class="splitBorder_r_h" width="280px">
                                                                        <asp:Label ID="lblDescription" Font-Bold="true" runat="server"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>UOM :
                                                                    </td>
                                                                    <td colspan="5" class="splitBorder_r_h">
                                                                        <asp:Label ID="lblUOM" runat="server"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Qty Per :
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <asp:Label ID="lblQtyPer" runat="server"></asp:Label>
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <div align="right"><asp:Label ID="lblLbs" runat="server" Font-Bold="true" Style="padding-left: 15px;"></asp:Label></div>
                                                                    </td>
                                                                    <td class="splitBorder_r_h">Lbs
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <div align="right"></div>
                                                                    </td>
                                                                    <td class="splitBorder_r_h">&nbsp;
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Super Eq. :
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <asp:Label ID="lblSuperEqu" runat="server"></asp:Label>
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <div align="right"><asp:Label ID="lblPCS" runat="server" Font-Bold="true" Style="padding-left: 15px;"></asp:Label></div>
                                                                    </td>
                                                                    <td class="splitBorder_r_h">Pcs
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <div align="right"><asp:Label ID="lblTotLbs" runat="server" Font-Bold="true" Style="padding-left: 15px;"></asp:Label></div>
                                                                    </td>
                                                                    <td class="splitBorder_r_h">Lbs
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Wgt/100 :
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <asp:Label ID="lbl100Wgt" runat="server"></asp:Label>
                                                                    </td>
                                                                    <td colspan="2">Low Profile Qty :
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <asp:Label ID="lblLowProfileQty" runat="server"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>HarmCode :
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <asp:Label ID="lblHarmCode" runat="server"></asp:Label>
                                                                    </td>
                                                                    <td colspan="2">
                                                                        Corp Fixed Velocity :
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <asp:Label ID="lblVelocity" runat="server"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr></tr>
                                                            </table>
                                                            <%--End Item Details--%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <div class="blueBorder shadeBgDown">
                                                                <table border="0" cellspacing="2" cellpadding="0" width="100%">
                                                                    <tr>
                                                                        <td>
                                                                            <strong>Container:</strong>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="lblContainer" runat="server" Text="Label"></asp:Label>&nbsp;
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <strong>Landing Loc:</strong>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="lblLandingLoc" runat="server" Text="Label"></asp:Label>&nbsp;
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <strong>Container Item Qty:</strong>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="lblContItemQty" runat="server" Text="0"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <strong>Committed Qty:</strong>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="lblCommittedQty" runat="server" Text=""></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <strong>Remaining Qty:</strong>
                                                                        </td>
                                                                        <td>
                                                                            <b><asp:Label ID="lblRemainingQty" CssClass="readtxt" runat="server" Text="0"></asp:Label></b>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="blueBorder">
                                                            <div id="div-datagrid" class="Sbar" align="center" style="overflow-x: hidden; overflow-y: visible;
                                                                position: relative; top: 0px; left: 0px; height: 410px; width: 100%; border: 0px solid;">
                                                                <asp:Panel ID="OtherPanel" runat="server" Width="100%" Height="100%" ScrollBars="Vertical">
                                                                    <asp:DataGrid CssClass="grid" Width="95%" runat="server" ID="dgOther" GridLines="both"
                                                                        AutoGenerateColumns="false" UseAccessibleHeader="true">
                                                                        <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="gridItem" Height="20px" />
                                                                        <AlternatingItemStyle CssClass="zebra" Height="20px" />
                                                                        <FooterStyle CssClass="lightBlueBg" />
                                                                        <Columns>
                                                                            <asp:BoundColumn SortExpression="LandingLocationCode" DataField="LandingLocationCode" HeaderText="From">
                                                                                <ItemStyle CssClass="Left5pxPadd" Width="25px" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn SortExpression="FinalLocationCode" DataField="FinalLocationCode" HeaderText="To">
                                                                                <ItemStyle CssClass="Left5pxPadd" Width="25px" />
                                                                            </asp:BoundColumn>
                                                                            
                                                                            <asp:BoundColumn DataField="ContainerNo" SortExpression="ContainerNo" HeaderText="Container">
                                                                                <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Left" Width="70px" />
                                                                            </asp:BoundColumn>
                                                                            
                                                                            <asp:BoundColumn DataField="Qty" DataFormatString="{0:#,##0}" HeaderText="Qty" SortExpression="Qty">
                                                                                <ItemStyle HorizontalAlign="Right" Width="40px" />
                                                                            </asp:BoundColumn>
                                                                            
                                                                            <asp:BoundColumn DataField="EntryDt" SortExpression="EntryDt"  DataFormatString="{0:MM/dd/yyyy}" HeaderText="Entered">
                                                                                <ItemStyle HorizontalAlign="Right" Width="70px" />
                                                                            </asp:BoundColumn>
                                                                            
                                                                        </Columns>
                                                                    </asp:DataGrid>
                                                                    <asp:Label ID="lblOtherMsg" Font-Bold="true" runat="server" Text="No Other Container Cross Dock Records Found"></asp:Label>
                                                                    <asp:HiddenField ID="hidVendor" runat="server" />
                                                                    <asp:HiddenField ID="hidPO" runat="server" />
                                                                    <asp:HiddenField ID="hidMfgPlant" runat="server" />
                                                                    <input type="hidden" id="hidSortVendor" runat="server" />
                                                                </asp:Panel>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <%--End Vendor Item and Shipment Details Panel--%>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="blueBorder" colspan="2" valign="top">
                            <%--Pager Panel--%>
                            <asp:UpdatePanel ID="pnlPager" runat="server" UpdateMode="conditional">
                                <ContentTemplate>
                                    <table class="BluBg" id="Table1" height="1" cellspacing="0" cellpadding="0" width="100%"
                                        border="0">
                                        <tr>
                                            <td colspan="2" height="8px">
                                                <table id="Table2" cellspacing="0" height="1" cellpadding="0" width="100%" border="0">
                                                    <tr>
                                                        <td width="10%" height="8px">
                                                            <table id="Table3" cellspacing="0" cellpadding="2" width="40%" border="0">
                                                                <tr>
                                                                    <td>
                                                                        <asp:ImageButton ID="ibtnFirst" runat="server" ImageUrl="../Common/Images/PageFirst.jpg"
                                                                            OnClick="ibtnFirst_Click" /></td>
                                                                    <td>
                                                                        <asp:ImageButton ID="ibtnPrevious" runat="server" ImageUrl="../Common/Images/PagePrev.jpg"
                                                                            OnClick="ibtnPrevious_Click" /></td>
                                                                    <td>
                                                                        <div class="TabHead">
                                                                            <strong>&nbsp;&nbsp;&nbsp;GoTo</strong></div>
                                                                    </td>
                                                                    <td>
                                                                        <asp:DropDownList ID="ddlPages" runat="server" AutoPostBack="True" CssClass="PageCombo"
                                                                            Width="50px" OnSelectedIndexChanged="ddlPages_SelectedIndexChanged">
                                                                        </asp:DropDownList></td>
                                                                    <td>
                                                                        <asp:ImageButton ID="btnNext" runat="server" ImageUrl="../Common/Images/PageNext.jpg"
                                                                            OnClick="btnNext_Click" /></td>
                                                                    <td>
                                                                        <asp:ImageButton ID="btnLast" runat="server" ImageUrl="../Common/Images/PageLast.jpg"
                                                                            OnClick="btnLast_Click" /></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td align="center">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td width="40%" align="left">
                                                                        <table id="Table6" cellspacing="0" cellpadding="0" border="0" height="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="center">
                                                                                        <asp:Label ID="lblPage" runat="server" CssClass="TabHead">Page(s):</asp:Label></td>
                                                                                    <td align="center" style="width: 9px" class="LeftPadding">
                                                                                        <asp:Label ID="lblCurrentPage" runat="server" CssClass="TabHead">1</asp:Label></td>
                                                                                    <td align="center" class="LeftPadding">
                                                                                        <asp:Label ID="lblOf" runat="server" CssClass="TabHead">of</asp:Label></td>
                                                                                    <td align="center" class="LeftPadding">
                                                                                        <asp:Label ID="lblTotalPage" runat="server" CssClass="TabHead">100</asp:Label></td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td width="60%" align="right">
                                                                        <table id="TblPagerRecord" cellspacing="0" cellpadding="0" border="0" height="1">
                                                                            <tr>
                                                                                <td style="height: 17px">
                                                                                    <asp:Label ID="lblRecords" runat="server" CssClass="TabHead">Record(s):</asp:Label></td>
                                                                                <td style="height: 17px" class="LeftPadding">
                                                                                    <asp:Label ID="lblCurrentPageRecCount" runat="server" CssClass="TabHead">100</asp:Label></td>
                                                                                <td style="height: 17px" class="LeftPadding">
                                                                                    <asp:Label ID="Label1" runat="server" CssClass="TabHead">-</asp:Label></td>
                                                                                <td style="height: 17px" class="LeftPadding">
                                                                                    <asp:Label ID="lblCurrentTotalRec" runat="server" CssClass="TabHead">100</asp:Label></td>
                                                                                <td style="height: 17px" class="LeftPadding">
                                                                                    <asp:Label ID="lblOf1" runat="server" CssClass="TabHead">of</asp:Label></td>
                                                                                <td style="height: 17px" class="LeftPadding">
                                                                                    <asp:Label ID="lblTotalNoOfRec" runat="server" CssClass="TabHead">100</asp:Label></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td align="right" width="35%">
                                                            <table id="Table4" height="0%" cellspacing="0" cellpadding="2" border="0">
                                                                <tr>
                                                                    <td colspan="3">
                                                                        <asp:CompareValidator Style="display: none" ID="cpvGotoPage" runat="server" ErrorMessage="Enter Integer values alone" CssClass="Required" ForeColor=" " ControlToValidate="txtGotoPage" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="right" class="Left2pxPadd">
                                                                        <asp:Label ID="lblGotoPAge" runat="server" CssClass="TabHead">Go to Page # :</asp:Label></td>
                                                                    <td class="Left2pxPadd">
                                                                        <asp:TextBox ID="txtGotoPage" onkeypress="javascript:if(event.keyCode==13){if(this.value!=''){document.getElementById('btnGo').click();return false;}}else{ValdateNumber();}"
                                                                            runat="server" CssClass="FormControls" Width="25px">0</asp:TextBox></td>
                                                                    <td class="Left2pxPadd">
                                                                        <asp:ImageButton ID="btnGo" runat="server" ImageUrl="~/Common/Images/Go.gif" OnClick="btnGo_Click" /></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            <%--End Pager Panel--%>
                        </td>
                    </tr>
                </table>
                <table width="100%" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <table width="100%" cellpadding="0" cellspacing="0" class="BluBg buttonBar">
                                <tr>
                                    <td width="50%" align="left">
                                        <asp:UpdateProgress ID="upPanel" runat="server" AssociatedUpdatePanelID="pnlItemDetails">
                                            <ProgressTemplate>
                                                <span style="padding-left: 5px" class="TabHead">Loading...</span>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                        <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                            <ContentTemplate>
                                                <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                                    runat="server" Text=""></asp:Label>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                    <td align="right" style="padding-right: 8px;">
                                        <asp:UpdatePanel runat="server" ID="pnlCommit" UpdateMode="conditional">
                                            <ContentTemplate>
                                                <asp:ImageButton ID="btnAccept" runat="server" ImageUrl="Common/Images/accept.jpg"
                                                    OnClick="btnAccept_Click" />
                                                <img src="Common/Images/close.jpg" id="imgClose" onclick="javascript:ClosePage();" />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <uc2:BottomFooter ID="BottomFrame2" Title="Container Cross Dock Recommendations"
                                runat="server" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
