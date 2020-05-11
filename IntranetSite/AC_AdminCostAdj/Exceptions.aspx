<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Exceptions.aspx.vb" Inherits="Exceptions" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/newfooter.ascx" TagName="BottomFooter" TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Existing Exceptions</title>

    <script type="text/javascript">
    function LoadHelp()
    {
     window.open("Common/Help/ExcpHelp.htm",'HelpWindow','height=710,width=1020,scrollbars=yes,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
       
    }  
     // Function to allow the numeric value only
    function ValdateNumber()
    {

        if(event.keyCode<47 || event.keyCode>58)
            event.keyCode=0;
    }
     // Function to allow the numeric value only
    function ValdateNumberCost()
    {

        if(event.keyCode<46 || event.keyCode>58 )
            event.keyCode=0;
    }
    
    function DisplayLoss()
    {         
        document.getElementById("btnFindLoss").click();
    }
    </script>

    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../ReadyToShip/Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <asp:SqlDataSource ID="SqlHeaderlData" runat="server" ConnectionString="<%$ ConnectionStrings:ACAdminAdj %>">
    </asp:SqlDataSource>
 <%--<asp:SqlDataSource ID="TunnelData" DataSourceMode=DataSet runat="server" ConnectionString="<%$ ConnectionStrings:ACAdminAdj %>"
        SelectCommand="SELECT CurDate AS Date, Location AS Loc, ItemNo AS [Item No], BegOH AS [Cur OH], BegAC AS [Cur AC], RecQty AS [Rec Qty], CalcAC AS [New AC], pExceptionID AS EXID FROM AvgCstExceptionLog WHERE (CurDate >= CONVERT (DATETIME, @Param1)) AND Resolution IS NULL AND Location <> '99' ORDER BY Location, ItemNo, CurDate DESC">
        <SelectParameters>
            <asp:ControlParameter ControlID="LimitDate" DefaultValue="01/01/2008" Name="Param1"
                PropertyName="Value" />
        </SelectParameters>
    </asp:SqlDataSource>--%>
    <asp:SqlDataSource ID="Reasons" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnectionString %>"
        SelectCommand="SELECT [ShortDsc] FROM [Tables] WHERE ([TableType] = @TableType)">
        <SelectParameters>
            <asp:Parameter DefaultValue="RESAC" Name="TableType" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="ReceiptHistory" runat="server" ConnectionString="<%$ ConnectionStrings:ACAdminAdj %>"
        SelectCommand="SELECT  Branch, ItemNo, CONVERT(VARCHAR(10),RecDate,101)  as RecDate,QtyRec,&#13;&#10;UC, CONVERT(DECIMAL(10,5),Multiplier_Landed_Cost) [Landing UC],&#13;&#10;XfrPerLbUC [PerLb UC], &#13;&#10;CASE WHEN QtyRec = 0 THEN 0 ELSE CONVERT(DECIMAL(10,5),(RecValue / QtyRec)) END AS TotLandCost_UC,&#13;&#10;RecValue, CONVERT(DECIMAL(8,2),ExtendNetWgt) AS [Ext Wgt],&#13;&#10;DocNo, ParentDocNo, CONVERT(VARCHAR(10),Entry_Date,101) AS Entry_Date, TransferFromCode, TransferToCode,&#13;&#10;CostSrc,RecDate as SortRecDate  FROM AvgCst_Rec WHERE&#13;&#10;Branch=@Param1 AND ItemNo=@Param2&#13;&#10;UNION&#13;&#10;SELECT Branch, ItemNo, CONVERT(VARCHAR(10),RecDate,101)  as RecDate,QtyRec,&#13;&#10;UC, CONVERT(DECIMAL(10,5),Multiplier_Landed_Cost) [Landing UC],&#13;&#10;XfrPerLbUC [PerLb UC], &#13;&#10;CASE WHEN QtyRec = 0 THEN 0 ELSE CONVERT(DECIMAL(10,5),(RecValue / QtyRec)) END AS TotLandCost_UC,&#13;&#10;RecValue, CONVERT(DECIMAL(8,2),ExtendNetWgt) AS [Ext Wgt],&#13;&#10;DocNo, ParentDocNo, CONVERT(VARCHAR(10),Entry_Date,101) AS Entry_Date, TransferFromCode, TransferToCode,&#13;&#10;CostSrc,RecDate as SortRecDate  FROM AvgCst_RecHist WHERE&#13;&#10;Branch=@Param1 AND ItemNo=@Param2&#13;&#10;ORDER BY RecDate DESC&#13;&#10;">
        <SelectParameters>
            <asp:ControlParameter ControlID="hidLoc" Name="Param1" PropertyName="Value" />
            <asp:ControlParameter ControlID="ExcpItem" Name="Param2" PropertyName="Text" />
        </SelectParameters>
    </asp:SqlDataSource>
    <form id="form1" runat="server" method="post">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <uc1:Header ID="Header1" runat="server" />
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional" RenderMode=Inline>
            <ContentTemplate>
                <table cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td id="tblEdit" runat="server" class="blueBorder TabCntBk">
                         
                                <table cellspacing="0" cellpadding="4" width="53%" >
                                    <tr>
                                        <td class="LeftPadding" style="font-weight:bold;">
                                            Exception Item:</td>
                                        <td style="font-weight:bold;">
                                            <asp:Label style="font-size:9pt;" ID="ExcpItem" runat="server" /></td>
                                              <td class="LeftPadding" style="font-weight:bold;">
                                            Current On Hand:</td>
                                        <td style="font-weight:bold;">
                                            <asp:Label ID="lblcuronHand" runat="server" /></td>
                                    </tr>
                                    <tr>
                                        <td class="LeftPadding" style="font-weight:bold;">
                                            Location:</td>
                                        <td style="font-weight:bold;">
                                            <asp:HiddenField ID="hidLoc" runat="server" />
                                            <asp:Label ID="ExcpLoc" runat="server"></asp:Label></td>
                                              <td class="LeftPadding" style="font-weight:bold;">
                                            Current Avg Cost:</td>
                                        <td style="font-weight:bold;">
                                            <asp:Label ID="lblCurAvgCost" runat="server" /></td>
                                    </tr>
                                    <tr >
                                        <td class="LeftPadding" style="font-weight:bold;">
                                            Resolution:</td>
                                        <td>
                                            <asp:DropDownList TabIndex="1" CssClass="FormControls" ID="SelResolutionDropDownList" DataSourceID="Reasons" runat="server"
                                                DataTextField="ShortDsc" DataValueField="ShortDsc" AutoPostBack="true" Enabled="True" Width="122px">
                                            </asp:DropDownList>
                                        </td>
                                         <td class="LeftPadding" style="font-weight:bold;">
                                            Recpt Quantity:</td>
                                        <td style="font-weight:bold;">
                                            <asp:Label  ID="lblRecptQuantity" runat="server" /></td>
                                    </tr>
                                    <tr >
                                        <td class="LeftPadding" style="font-weight:bold;">
                                            New Average Cost:</td>
                                        <td style="font-weight:bold;">
                                            <asp:TextBox ID="NewAC" TabIndex="2"  CssClass="FormControls" onkeypress="ValdateNumberCost(); " MaxLength="20"  runat="server" OnTextChanged="NewAC_TextChanged" AutoPostBack="True" Width="115px"></asp:TextBox>  <asp:RegularExpressionValidator ID="RegularExpressionValidator2" ControlToValidate="NewAC" SetFocusOnError="true" Font-Bold="false" runat="server" ValidationExpression="^\d{0,5}(\.\d{1,5})?$" ErrorMessage=" Enter Valid Cost"></asp:RegularExpressionValidator></td>
                                            
                                             <td class="LeftPadding" style="font-weight:bold;">                                             
                                                 <asp:Label ID="lblLossCaption" runat="server" Width="47px" Visible="False"></asp:Label></td>
                                        <td style="font-weight:bold;"><asp:Label  ID="lblLossValue" runat="server" Visible="False" /></td>
                                    </tr>
                                    <tr>
                                        <td class="LeftPadding" style="font-weight:bold;">
                                            Exception Date:</td>
                                        <td style="font-weight:bold;">
                                            <asp:Label ID="ExcpDate" runat="server" /></td>
                                              <td class="LeftPadding" style="font-weight:bold;">
                                                  <asp:Label ID="lblBegAC" runat="server" Visible="False"></asp:Label></td>
                                        <td style="font-weight:bold;">
                                            <asp:Button ID="btnFindLoss" runat="server" OnClick="btnFindLoss_Click"  Style="display: none;" /></td>
                                    </tr>
                                </table>
                           
                        </td>
                    </tr>
                    <tr>
                        <td id="tblAdd" style="display:none;" runat="server"  class="blueBorder TabCntBk">
                            <table  cellspacing="0" cellpadding="0" width="40%">
                                <tr>
                                    <td class="LeftPadding" style="font-weight:bold;">
                                        Exception Item:</td>
                                    <td>
                                        <asp:TextBox CssClass="FormControls" TabIndex="1"  ID="txtItem" AutoPostBack="true" runat="server" OnTextChanged="txtItem_TextChanged" /></td>
                                </tr>
                                
                                <tr>
                                    <td class="LeftPadding" style="font-weight:bold;">
                                        Location:</td>
                                    <td>
                                        <asp:TextBox CssClass="FormControls"  TabIndex="2"  onkeypress="javascript:ValdateNumber();" MaxLength="2"  ID="txtLoc" runat="server"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td class="LeftPadding" style="font-weight:bold;">
                                        New Average Cost:</td>
                                    <td>
                                        <asp:TextBox  CssClass="FormControls" MaxLength="20"  TabIndex="3" ID="txtAveCost" runat="server" onkeypress="javascript:ValdateNumberCost();" onfocus="javascript:this.select();"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" ControlToValidate="txtAveCost" SetFocusOnError="true" Font-Bold="false" runat="server" ValidationExpression="^\d+(\.\d{1,10})?" ErrorMessage="Enter Valid Cost"></asp:RegularExpressionValidator>
                                        </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td width="100%" runat="server" id="gridHeaders" class="GridHead" style="padding-left: 22px;
                            font-size: 11pt; color: #003366; background-color: #DFF3F9;"> Receipt History</td>
                    </tr>
                    <tr>
                        <td>
                            <div id="div-datagrid" class="Sbar" align="left" style="overflow-x: hidden; overflow-y: auto;
                                position: relative; top: 0px; left: 0px; height: 400px; width: 100%; border: 0px solid;">
                                <asp:GridView ID="ReceivingHist" CssClass="grid" runat="server" Width="100%" Style="height: auto;"
                                    UseAccessibleHeader="true" AllowSorting="true" AllowPaging="false" AutoGenerateColumns="False" DataSourceID="ReceiptHistory"
                                    EmptyDataText="No History" EmptyDataRowStyle-ForeColor="#CC0000"   EmptyDataRowStyle-HorizontalAlign="center" ToolTip="Display Receipt History for the Exception">
                                    <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                    <RowStyle CssClass="gridItem Left5pxPadd " />
                                    <AlternatingRowStyle CssClass="zebra Left5pxPadd " />
                                    <FooterStyle CssClass="lightBlueBg" />
                                    <Columns>
                                        <asp:BoundField DataField="Branch" HeaderText="Branch" SortExpression="Branch" />
                                        <asp:BoundField DataField="ItemNo" HeaderText="Item No" SortExpression="ItemNo" ItemStyle-Width="90" />
                                        <asp:BoundField DataField="RecDate" HeaderText="RecDate" ReadOnly="True" SortExpression="RecDate" />
                                        <asp:BoundField DataField="QtyRec" HeaderText="Qty" SortExpression="QtyRec" />
                                        <asp:BoundField DataField="UC" HeaderText="UC" SortExpression="UC" />
                                        <asp:BoundField DataField="Landing UC" HeaderText="Landing UC" ReadOnly="True" SortExpression="Landing UC" />
                                        <asp:BoundField DataField="PerLb UC" HeaderText="PerLb UC" SortExpression="PerLb UC" />
                                        <asp:BoundField DataField="TotLandCost_UC" HeaderText="Landed UC" ReadOnly="True"
                                            SortExpression="TotLandCost_UC" />
                                        <asp:BoundField DataField="RecValue" HeaderText="Rec Value" SortExpression="RecValue" />
                                        <asp:BoundField DataField="Ext Wgt" HeaderText="Ext Wgt" ReadOnly="True" SortExpression="Ext Wgt" />
                                        <asp:BoundField DataField="DocNo" HeaderText="DocNo" SortExpression="DocNo" />
                                        <asp:BoundField DataField="ParentDocNo" HeaderText="Parent Doc" SortExpression="ParentDocNo" />
                                        <asp:BoundField DataField="Entry_Date" HeaderText="Entry" SortExpression="Entry_Date" />
                                        <asp:BoundField DataField="TransferFromCode" HeaderText="Xfr From" SortExpression="TransferFromCode" />
                                        <asp:BoundField DataField="TransferToCode" HeaderText="Xfr To" SortExpression="TransferToCode" />
                                        <asp:BoundField DataField="CostSrc" HeaderText="Cost Src" SortExpression="CostSrc" />
                                        <asp:BoundField ItemStyle-Width="30px"  />
                                        
                                    </Columns>
                                    <EmptyDataRowStyle Font-Bold="True" Font-Italic="True" />
                                </asp:GridView>
                            </div>
                        </td>
                    </tr>
        <%--   <tr>
                        <td>
                            <table cellspacing="0" cellpadding="2" width="500">
                                <tr>
                                    <td>
                                        <asp:DetailsView ID="HeaderView" runat="server" Height="50px" DataSourceID="TunnelData"
                                            AllowPaging="True" Width="210px">
                                        </asp:DetailsView>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>--%><tr>
                        <td >
                            <table class="BluBg" id="tblPager" runat="server" height="1" cellspacing="0" cellpadding="0" width="100%"
                                border="0">
                                <tr>
                                    <td colspan="2" height="8px">
                                        <table  cellspacing="0" height="1" cellpadding="0" width="100%" border="0">
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
                                                                        <td >
                                                                            <asp:Label ID="lblRecords" runat="server" CssClass="TabHead">Record(s):</asp:Label></td>
                                                                        <td class="LeftPadding">
                                                                            <asp:Label ID="lblCurrentPageRecCount" runat="server" CssClass="TabHead">100</asp:Label></td>
                                                                        <td  class="LeftPadding">
                                                                            <asp:Label ID="Label1" runat="server" CssClass="TabHead">-</asp:Label></td>
                                                                        <td  class="LeftPadding">
                                                                            <asp:Label ID="lblCurrentTotalRec" runat="server" CssClass="TabHead">100</asp:Label></td>
                                                                        <td class="LeftPadding">
                                                                            <asp:Label ID="lblOf1" runat="server" CssClass="TabHead">of</asp:Label></td>
                                                                        <td class="LeftPadding">
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
                                                                <asp:CompareValidator Style="display: none" ID="cpvGotoPage" runat="server" ErrorMessage="Enter Integer values 

alone" CssClass="Required" ForeColor=" " ControlToValidate="txtGotoPage" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator><div>
</div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right" class="Left2pxPadd">
                                                                <asp:Label ID="lblGotoPAge" runat="server" CssClass="TabHead">Go to Page # :</asp:Label></td>
                                                            <td class="Left2pxPadd">
                                                                <asp:TextBox ID="txtGotoPage" onkeypress="javascript:if(event.keyCode==13){if(this.value!=''){document.getElementById('btnGo').click();return false;}}else{ValdateNumber();}"
                                                                    runat="server" CssClass="FormControls" Width="25px">0</asp:TextBox></td>
                                                            <td class="Left2pxPadd" style="padding-right:3px;">
                                                                <asp:ImageButton ID="btnGo" runat="server" ImageUrl="~/Common/Images/Go.gif" OnClick="btnGo_Click" /></td>
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
                    <tr>
                        <td class="BluBg" width="100%" style="border-top:solid 2px #DAEEEF">
                            <table width="100%">
                                <tr>
                                    <td style="width:auto;" >
                                        <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                                            <ProgressTemplate>
                                                <span style="padding-left: 5px" class="TabHead">Loading...</span></ProgressTemplate>
                                        </asp:UpdateProgress>
                                    </td>
                                    <td>
                                            <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                                runat="server" Text=""></asp:Label>
                                           </td>
                                    <td align="right">
                                        <img src="Common/images/help.gif" TabIndex="4" alt="" onclick="LoadHelp();" style="cursor: hand" />&nbsp;<asp:ImageButton
                                            ID="NewAdj" runat="server"  TabIndex="5" ImageUrl="Common/Images/new.gif" CausesValidation="false" ToolTip="Create an Adjustment with no Exception Reference" />
                                        <asp:ImageButton ID="OK_Excp" TabIndex="6"  runat="server" CausesValidation="true" ImageUrl="Common/images/ok.gif" />
                                        <asp:ImageButton ID="CloseButton" TabIndex="7"  CausesValidation="false" runat="server" ImageUrl="Common/Images/Close.jpg"
                                            PostBackUrl="javascript:window.close();" /></td>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <uc3:BottomFooter ID="BottomFrame2" Title="Average Cost Exception Resolution" runat="server" />
                        </td>
                    </tr>
                </table>
              
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>
