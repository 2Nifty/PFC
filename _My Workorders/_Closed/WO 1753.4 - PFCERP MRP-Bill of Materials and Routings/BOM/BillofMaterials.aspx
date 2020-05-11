<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BillofMaterials.aspx.cs" Inherits="BillofMaterials" %>  

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer2" TagPrefix="uc2" %>

<%@ Register Src="../Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc4" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title>Bill of Materials</title>
    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>
    <script src="/Common/JavaScript/Common.js" type="text/javascript"></script>
     <link href="Common/StyleSheet/SSStyle.css" rel="stylesheet" type="text/css" />
  
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
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
        
        .NoShow
        {
            display:none;
        }
        
        .ws_whitebox_left 
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
	        text-align: left;
        }
    </style>

    <script>
        
        var ParentWindow;        
        var BOMDetailWindow;
                
        function pageUnload() 
        {
            if (BOMDetailWindow != null) {BOMDetailWindow.close();BOMDetailWindow=null;}
        }
        
        function OpenDetail(BOM)
        {
            if (BOMDetailWindow != null) {BOMDetailWindow.close();BOMDetailWindow=null;}      
            BOMDetailWindow=window.open(DetailURL,'BOMDetailWin','height=750,width=1000,toolbar=0,scrollbars=0,status=1,resizable=YES','');  
            SetHeight();   
            return false;  
        }

        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //take out room for bottom panel
            yh = yh - 500;
            xw = xw - 5
            // size the grid
            if ($get("DetailGridPanel")!=null)
            {
                var DetailGridPanel = $get("DetailGridPanel");
                DetailGridPanel.style.height = yh;  
                DetailGridPanel.style.width = xw;  
                var DetailGridHeightHid = $get("DetailGridHeightHidden");
                DetailGridHeightHid.value = yh;
                var DetailGridHeightHid = $get("DetailGridWidthHidden");
                DetailGridHeightHid.value = xw;
            }
        }
        
              
        function ZItem(itemNo)
        {
        var section="";
        var completeItem=0;
        var ZItemInd=$get("ItemPromptInd");
        event.keyCode=0;
        //alert(ZItemInd.value);
        if (ZItemInd.value != 'Z')
        {
            event.keyCode=9;
            return false;
        }
        if (itemNo.length >= 14)
        {
            document.form1.btnHidSearch.click();
            return false;
        }
        if (itemNo.length == 0)
        {
            return false;
        }
        // process ZItem
        switch(itemNo.split('-').length)
        {
        case 1:
            // this is actually taken care of by the item alias search
            itemNo = "00000" + itemNo;
            itemNo = itemNo.substr(itemNo.length-5,5);
            $get("txtItemSearch").value=itemNo+"-";  
            break;
        case 2:
            // close if they are entering an empty part
            if (itemNo.split('-')[0] == "00000") {ClosePage()};
            section = "0000" + itemNo.split('-')[1];
            section = section.substr(section.length-4,4);
            $get("txtItemSearch").value=itemNo.split('-')[0]+"-"+section+"-";  
            break;
        case 3:
            section = "000" + itemNo.split('-')[2];
            section = section.substr(section.length-3,3);
            $get("txtItemSearch").value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
            completeItem=1;
            break;
        }
        if (completeItem==1) document.form1.btnHidSearch.click();
        return false;
        }
        
        
        function OpenParent()
        {
            if ($get("ParentCall").value == "0")
            {
            ParentWindow = OpenAtPos('SSParent', '/SOE/StockStatus.aspx?ItemNo='+$get("ParentItemHidden").value+'&ParentCall=1', 'toolbar=0,scrollbars=0,status=0,resizable=YES', 0, 0, 1100, 560);    
            }
        }
                
        
        function ClosePage()
        {
            window.close();	
        }
        
        function LoadHelp()
        {
            window.open('BillofMaterialsHelp.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
        }
        
//        function GetItem(ItemNo, UserName)
//        {
//           document.getElementById("btnHidSearch").click();  
//        }
        
    </script>
</head>


<body scroll="yes" onload="SetHeight();" onresize="SetHeight();">
    <form id="frmBOM" runat="server">
        <asp:ScriptManager ID="smBOM" runat="server" />
        <div>
            <asp:UpdatePanel ID="MainUpdatePanel" runat="server">
                <ContentTemplate>
                    <table width="100%" cellspacing="0" cellpadding="2" border="0">
                        <tr>
                            <td>
                                <uc1:Header id="Pageheader"  runat="server">
                                </uc1:Header>
                            </td>
                        </tr>
                        <tr>
                       <%--     <td class="lightBlueBg">
                                <span class="BanText">Bill of Materials</span>
                            </td>--%>
                            <tr>
                                <td class="lightBlueBg" style="padding-right: 10px">
                                    <img id="btnHelp" src="../common/images/help.gif" runat="server" align="right" onclick="LoadHelp();" style="cursor: hand" />
                                </td>              
                            </tr>  
                        </tr>
                        <tr>
                            <td class="lightBlueBg">
                                <asp:Panel ID="SelectorPanel" runat="server" Height="34px" Width="100%" class="lightBlueBg"> <%--added by Pete--%>
                                    <asp:UpdatePanel  ID="SelectorUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate >
                                            <table  width="100%" >
                                                <tr >
                                                    <td  align="left">
                                                        <table  >
                                                            <tr>
                                                               <td style="padding-left: 15px; font-weight: bold; width: 100px;">
                                                                   Item Number
                                                               </td>
                                                               <td style="width: 85px">
                                                                   <asp:TextBox ID="txtItemSearch" runat="server" Width="115px" CssClass="FormCtrl" TabIndex="1"
                                                                           onfocus="javascript:this.select();"                                                                           
                                                                           onkeydown="javascript:if(event.keyCode==13 || event.keyCode==9){return ZItem(this.value);}"></asp:TextBox>
                                                               <td>      
                                                                   <asp:Button ID="btnHidSearch" OnClick="ItemButt_Click" runat="server"
                                                                        Text="hidButton" Style="display: none;" CausesValidation="false" />
                                                                         <asp:HiddenField ID="ItemPromptInd" runat="server" Value="Z"/>
                                                                        
                                                                         <asp:HiddenField ID="CalledBy" runat="server" />
                                                                         <asp:HiddenField ID="ParentCall" runat="server" />
                                                                         <asp:HiddenField ID="ParentItemHidden" runat="server" />
                                                               </td>           
                                                                       
                                                               </td>
                                                               <td style="padding-left: 15px; font-weight: bold; width: 59px;">
                                                                   Bill Type
                                                               </td>
                                                               <td width="110px">
                                                                   <asp:DropDownList ID="ddlBillType" TabIndex="2" Height="20px" Width="95px" CssClass="FormCtrl" runat="server"> </asp:DropDownList>
                                                               </td>   
                                                               <td align="right" style="width: 155px;">
                                                                   <asp:ImageButton ID="ibtnGetBOM" TabIndex="3" runat="server" ImageUrl="../Common/Images/GetBOM.gif"
                                                                   CausesValidation="false"  OnClick="ItemButt_Click"  ToolTip="Get BOM" />&nbsp;
                                                               </td>                                                            
                                                               <td align="right" style="width: 155px;">
                                                                   <asp:ImageButton ID="ibtnCreateBOM" TabIndex="4" runat="server" ImageUrl="../Common/Images/CreateBOM.gif"
                                                                   CausesValidation="false" ToolTip="Create BOM" />&nbsp;
                                                               </td>
                                                                
                                                                <td colspan="2">
                                                                    <asp:UpdateProgress ID="SearchUpdateProgress" runat="server">
                                                                        <ProgressTemplate>
                                                                            Loading....
                                                                        </ProgressTemplate>
                                                                    </asp:UpdateProgress>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>                                                    
                                                </tr>                                             
                                          </table>
                                       </ContentTemplate>
                                      </asp:UpdatePanel>                                            
                                </asp:Panel>  
                                
                                    <asp:DataGrid ID="ItemGrid" runat="server" AutoGenerateColumns="false" PageSize="1"
                                        AllowPaging="true" PagerStyle-Visible="false" ShowHeader="false" BorderWidth="0" >
                                        <AlternatingItemStyle CssClass="GridItem" BackColor="#FFFFFF" />
                                        <Columns>
                                            <asp:BoundColumn DataField="ItemNo" DataFormatString="Item {0:G}" ItemStyle-Font-Size="14"
                                                ItemStyle-Width="300" ItemStyle-HorizontalAlign="left"></asp:BoundColumn>
                                        </Columns>
                                    </asp:DataGrid>                                
                                          
                                    <asp:Panel ID="HeaderPanel" runat="server" Height="100px" Width="100%">
                                    <asp:UpdatePanel ID="HeaderUpdatePanel" UpdateMode="Conditional" runat="server"><ContentTemplate>
                                            <table width="100%" border="0" cellspacing="2" cellpadding="1" >
                                                <colgroup>
                                                <col width="9%" />
                                                <col width="16%" />
                                                <col width="8%" />
                                                <col width="6%" />
                                                <col width="9%" />
                                                <col width="7%" />
                                                <col width="10%" />
                                                <col width="6%" />
                                                <col width="8%" />
                                                <col width="8%" />
                                                <col width="8%" />
                                                <col width="5%" />
                                                </colgroup>
                                                <tr>
                                                    <td class="bold">
                                                        Description:
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="ItemDescLabel" runat="server" Text="" CssClass="ws_data_left" Width="180px">
                                                        </asp:Label>
                                                    </td>
                                                    
                                                    <td class="bold">
                                                        Weight/100:
                                                    </td>
                                                    <td>
                                                        <asp:Label CssClass="ws_data_right bold" ID="Wgt100Label" runat="server" Text="" Width="50px"></asp:Label>
                                                    </td>
                                                    
                                                    <td class="bold">
                                                        Sell Stock:
                                                    </td>
                                                    <td>
                                                        <asp:Label CssClass="ws_data_right bold" ID="QtyUOMLabel" runat="server" Text="" Width="50px"></asp:Label>
                                                    </td>
                                                    
                                                    <td class="bold">
                                                        Std Cost:
                                                    </td>
                                                    <td>
                                                        <asp:Label CssClass="ws_data_right bold" ID="StdCostLabel" runat="server" Text="" Width="50px"></asp:Label>
                                                    </td>
                                                    
                                                    <td class="bold">
                                                        UPC Code:
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="UPCLabel" runat="server" CssClass="ws_data_right bold" Text="" Width="80px"></asp:Label>
                                                    </td>
                                                    
                                                    <td class="bold">
                                                        Web Enabled:
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="WebLabel" runat="server" CssClass="ws_data_right bold" Text="" Width="30px"></asp:Label>
                                                    </td>
                                                    
                                                </tr>
                                                <tr>
                                                    <td class="bold">
                                                        Category:
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="CategoryLabel" runat="server" Text="" CssClass="ws_data_left" Width="180px">
                                                        </asp:Label>
                                                    </td>
                                                    <td class="bold">
                                                        Net LB:
                                                    </td>
                                                    <td>
                                                        <asp:Label CssClass="ws_data_right bold" ID="NetWghtLabel" runat="server" Text="" Width="50px"></asp:Label>
                                                    </td>
                                                    <td class="bold">
                                                        Super Eqv:
                                                    </td>
                                                    <td class="bold">
                                                        <asp:Label CssClass="ws_data_right" ID="SuperEqLabel" runat="server" Text="" Width="50px"></asp:Label>
                                                    </td>
                                                    <td class="bold">
                                                        List Price:
                                                    </td>
                                                    <td class="bold">
                                                        <asp:Label CssClass="ws_data_right" ID="ListLabel" runat="server" Text="" Width="50px"></asp:Label>
                                                    </td>
                                                    <td class="bold">
                                                        Tariff:
                                                    </td>
                                                    <td class="bold">
                                                        <asp:Label CssClass="ws_data_right" ID="HarmCodeLabel" runat="server" Text="" Width="80px"></asp:Label>
                                                    </td>
                                                    <td class="bold">
                                                        Pkg Grp:
                                                    </td>
                                                    <td class="bold">
                                                        <asp:Label CssClass="ws_data_right" ID="PackGroupLabel" runat="server" Text="" Width="50px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="bold">
                                                        Plating Type:
                                                    </td>
                                                    <td class="bold">
                                                        <asp:Label CssClass="ws_data_left" ID="PlatingLabel" runat="server" Text="" Width="50px"></asp:Label>
                                                    </td>
                                                    <td class="bold">
                                                        Gross LB:
                                                    </td>
                                                    <td class="bold">
                                                        <asp:Label CssClass="ws_data_right" ID="GrossWghtLabel" runat="server" Text="" Width="50px"></asp:Label>
                                                    </td>
                                                    <td class="bold">
                                                        Price UM:
                                                    </td>
                                                    <td class="bold">
                                                        <asp:Label CssClass="ws_data_right" ID="PriceUMLabel" runat="server" Text="" Width="50px"></asp:Label>
                                                    </td>
                                                    <td class="bold">
                                                        Corp Fixed Vel:
                                                    </td>
                                                    <td class="bold">
                                                        <asp:Label ID="CFVLabel" runat="server" CssClass="ws_data_right" Text="" Width="50px"></asp:Label>
                                                    </td>
                                                    <td class="bold">
                                                        PPI Code:
                                                    </td>
                                                    <td class="bold">
                                                        <asp:Label CssClass="ws_data_right" ID="PPILabel" runat="server" Text="" Width="80px"></asp:Label>
                                                    </td>
                                                    <td class="bold">
                                                    Low Profile:
                                                    </td>
                                                    <td class="bold">
                                                        <asp:Label CssClass="ws_data_right" ID="LowProfileLabel" runat="server" Text="" Width="50px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="bold">
                                                        Parent Item:
                                                    </td>
                                                    <td class="bold">
                                                        <a id="ParentLink" onclick="OpenParent();">
                                                        <asp:Label ID="ParentLabel" runat="server" Text="" CssClass="ws_data_left" Width="100px">
                                                        </asp:Label>
                                                        </a>
                                                    </td>
                                                    <td class="bold">
                                                        Stock Ind:
                                                    </td>
                                                    <td class="bold">
                                                        <asp:Label CssClass="ws_data_right" ID="StockLabel" runat="server" Text="" Width="50px"></asp:Label>
                                                    </td>
                                                    <td class="bold">
                                                        Cost UM:
                                                    </td>
                                                    <td class="bold">
                                                        <asp:Label CssClass="ws_data_right" ID="CostUMLabel" runat="server" Text="" Width="50px"></asp:Label>
                                                    </td>
                                                    <td class="bold">
                                                        Category Vel:
                                                    </td>
                                                    <td class="bold">
                                                        <asp:Label ID="CatVelLabel" runat="server" CssClass="ws_data_right" Text="" Width="50px"></asp:Label>
                                                    </td>
                                                    <td class="bold">
                                                        Created:
                                                    </td>
                                                    <td class="bold">
                                                        <asp:Label ID="CreatedLabel" runat="server" CssClass="ws_data_right" Text="" Width="80px"></asp:Label>
                                                    </td>
                                                    <td class="bold">
                                                        Pkg Vel:
                                                    </td>
                                                    <td class="bold">
                                                        <asp:Label ID="PkgVelLabel" runat="server" CssClass="ws_data_right" Text="" Width="50px"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td >
                                <asp:Panel ID="DetailGridPanel" runat="server" ScrollBars = "Vertical" Height="280px" Width="820px" BackColor="White">
                                 <asp:HiddenField ID="DetailGridHeightHidden" runat="server" />
                                    <asp:HiddenField ID="DetailGridWidthHidden" runat="server" />
                                    <asp:UpdatePanel ID="DetailUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                          <%-- <asp:HiddenField ID="BOMRecTypeHidden" runat="server" />--%>
                                          <%--  <asp:HiddenField ID="ApprovalOKHidden" runat="server" />--%>
                                            <asp:HiddenField ID="hidRowFilter" runat="server" />
                                            <input type="hidden" id="hidSort" runat="server" />
                                            <asp:GridView ID="BOMGridView" runat="server" HeaderStyle-CssClass="GridHead" AutoGenerateColumns="False" 
                                                RowStyle-BackColor="#FFFFFF" RowStyle-CssClass="Left5pxPadd" AllowSorting="True" Width="983px">
                                                <AlternatingRowStyle CssClass="Left5pxPadd" BackColor="#DCF3FB" BorderColor="#DAEEEF" />
                                                <Columns>
                                                    <asp:BoundField DataField="ChildNo" HeaderText="Item Number" SortExpression="ChildNo" >
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Center" Width="130px" />
                                                    </asp:BoundField>
                                                    
                                                    <asp:BoundField DataField="ChildDesc" HeaderText="Description " SortExpression="ChildDesc" >
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Center" Width="240px" />
                                                    </asp:BoundField>
                                                    
                                                    <asp:BoundField DataField="QtyPerAssembly" HeaderText="Qty Per " DataFormatString="{0:f3}" SortExpression="QtyPerAssembly" >
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Right" Width="50px" />
                                                    </asp:BoundField>
                                                    
                                                    <asp:BoundField DataField="BuildUM" HeaderText="U/M " SortExpression="BuildUM" >
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Center" Width="50px" />
                                                    </asp:BoundField>
                                                    
                                                    <asp:BoundField DataField="Remarks" HeaderText="Remarks " SortExpression="Remarks" >
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Center" Width="250px" />
                                                    </asp:BoundField>
                                                    
                                                    <asp:BoundField DataField="SeqNo" HeaderText="Seq No " SortExpression="SeqNo" >
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Center" Width="50px" />
                                                    </asp:BoundField>
                                                    
                                                    <asp:BoundField DataField="BillType" HeaderText="Bill Type " SortExpression="BillType" >
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle CssClass="Left5pxPadd rightBorder" HorizontalAlign="Center" Width="50px" />
                                                    </asp:BoundField>

                                                </Columns>
                                                <RowStyle BackColor="White" CssClass="Left5pxPadd" />
                                                <HeaderStyle CssClass="GridHead" />
                                            </asp:GridView>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </asp:Panel>
                            </td>
                        </tr>
                           
                        <tr> 
                            <td  align = "center" valign = "middle" class="lightBlueBg" Height="150px">
                               <asp:UpdatePanel ID="FooterUpdatePanel" runat="server">
                                <ContentTemplate>  
                                <table  cellpadding="0" cellspacing="0" id="trItemText" style="width: 831px" >
                                     <tr id="trItem" >
                                         <td width="100" valign="top" class="TabHead " style="padding-left: 5px; height: 20px;">
                                             <strong>Item Number</strong>
                                         </td>
                                         <td  class="TabHead " valign="top" style="padding-left: 5px; height: 20px;">
                                             <strong>Qty Per</strong>
                                         </td> 
                                         <td class="TabHead"  valign="top" style="padding-left: 5px; height: 20px; width: 67px;">
                                           <strong>U/M</strong>
                                         </td>                                                       
                                         <td class="TabHead " valign="top" style="padding-left: 5px; height: 20px; width: 294px;">
                                             <strong>Remarks</strong>
                                         </td>                                                                
                                         <td class="TabHead"  valign="top" style="padding-left: 5px; height: 20px; width: 65px;">
                                             <strong>Seq No.</strong>
                                         </td>
                                         <td class="TabHead"  valign="top" style="padding-left: 5px; height: 20px; width: 90px;">
                                           <strong>Bill Type</strong>
                                         </td>
                                     </tr>
                                     
                                     <tr>
                                         <td style="padding-left: 3px">
                                             <asp:TextBox AutoCompleteType="Disabled" ID="txtItemInsert" TabIndex="5" MaxLength="30" runat="server"
                                                 onfocus="javascript:this.select();" CssClass="txtBox wide120px" onkeydown="javascript:javascript:if(event.keyCode==9){GetItemDetail(event)};"
                                                 onkeypress="javascript:GetItemDetail(event);" Width="90px"></asp:TextBox>
                                         </td>
                                         <td style="padding-left: 3px; width: 10px;">
                                             <asp:TextBox ID="txtQtyPer" TabIndex="6" onfocus="javascript:this.select();"                                                                        
                                                 CssClass="txtBox" runat="server" Width="40px"></asp:TextBox>
                                         </td>
                                          <td style="padding-left: 3px; width: 97px;">
                                             <asp:DropDownList ID="ddlUM" TabIndex="7" runat="server" Width="92px">
                                             </asp:DropDownList>
                                         </td>
                                         <td style="padding-left: 3px; width: 370px;">
                                             <asp:TextBox ID="txtQuoteRemark" TabIndex="8" onfocus="javascript:this.select();" 
                                                 CssClass="txtBox wide200px" runat="server" Width="360px"></asp:TextBox>
                                         </td>                                                                
                                         <td style="padding-left: 3px; width: 65px;">
                                             <asp:TextBox ID="txtSeqNo" TabIndex="9"  onfocus="javascript:this.select();" 
                                                 CssClass="txtBox wide120px" runat="server" Width="55px"></asp:TextBox>
                                         </td> 
                                         <td style="padding-left: 3px; width: 100px;">
                                             <asp:DropDownList ID="ddlBillType2" TabIndex="10" runat="server" Width="90px">
                                             </asp:DropDownList>
                                         </td>
                                     </tr>
                                </table>
                                 </ContentTemplate>
                               </asp:UpdatePanel>
                               
                            </td>
                        </tr> 
                                
                        
                        <tr>
                            <td class="lightBlueBg">
                                <table width="100%" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <%--<td align="left">
                                            &nbsp;&nbsp;&nbsp;
                                            <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>&nbsp;
                                                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen" Font-Bold="true"></asp:Label>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>--%>
                                        <td align="right" class="splitborder_t_v splitborder_b_v" colspan="12" style="padding-right: 3px"
                                            valign="middle">
                                            <table>
                                                   <tr>
                                                          <td style="padding-left: 4px">
                                                              <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlExport" >
                                                                  <ContentTemplate>
                                                                      <uc4:PrintDialogue ID="PrintDialogue1" EnableFax="true" runat="server">
                                                                      </uc4:PrintDialogue>
                                                                  </ContentTemplate>
                                                              </asp:UpdatePanel>
                                                          </td>
                                                    </tr>

                                            
                                            </table>         
                                            <table cellpadding="0" cellspacing="0" style="margin-top: 5px;">
                                                      <td
                                                          style="padding-right: 5px; height: 28px" valign="top">  
                                                          <asp:ImageButton runat="server" ID="imgExcelExportButton" TabIndex="11" ImageUrl="../Common/Images/ExporttoExcel.gif"
                                                              ImageAlign="middle" OnClick="ibtnExcel_Click"/> 
                                                      </td>
                                                      <td 
                                                          style="padding-right: 5px; height: 28px" valign="top">
                                                          <asp:ImageButton runat="server" ID="imgDeleteButton" TabIndex="12" ImageUrl="../common/images/btndelete.gif"
                                                              ImageAlign="left " CausesValidation="false" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                             />  <%--OnClick="ibtnDelete_Click" --%>
                                                      </td>
                                                      <td>
                                                          <img id="ibtnClose" TabIndex="13" src="../Common/Images/Close.gif" style="padding-left: 5px; padding-right: 3px;"
                                                              onclick="javascript:window.close();" />
                                                      </td>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                    <td align="left">
                                            &nbsp;&nbsp;&nbsp;
                                            <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>&nbsp;
                                                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen" Font-Bold="true"></asp:Label>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>                                    
                                    </tr>
                                    
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <uc2:Footer2 id="PageFooter2"  Title="Bill of Materials" runat="server">
                                </uc2:Footer2>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </form>
</body>
</html>
