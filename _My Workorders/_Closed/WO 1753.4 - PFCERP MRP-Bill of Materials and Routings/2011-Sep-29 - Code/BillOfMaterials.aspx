<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BillOfMaterials.aspx.cs" Inherits="BillOfMaterials" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="../Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc4" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head2" runat="server">
    <title>Bill of Materials</title>

    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        .zebra td {padding-left: 5px;}
        .gridItem td {padding-left: 5px;}
    </style>

    <script type="text/javascript">
        function LoadHelp()
        {
            window.open('BillOfMaterialsHelp.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
        }

        function WriteBOM()
        {
//alert('WriteBOM');
            document.getElementById('btnHidWriteBOM').click();
//alert('Added');
            return false;
        }

        function DelBOM()
        {
//alert('DelBOM');
            document.getElementById('btnHidDelBOM').click();
//alert('deleted');
            return false;
        }

        function ZItem(itemNo, itemCtl)
        {
//alert(  itemCtl  );

            var section="";
            var completeItem=0;
//            var ZItemInd=$get("ItemPromptInd");
            event.keyCode=0;
        
//            alert(ZItemInd.value);
//            if (ZItemInd.value != 'Z')
//            {
//                event.keyCode=9;
//                return false;
//            }

            if (itemNo.length >= 14)
            {
//alert('complete' + itemCtl);
                if (itemCtl == 'txtItemSearch')
                    document.frmBOM.btnHidItemSearch.click();

                if (itemCtl == 'txtItemInsert')
                    document.frmBOM.btnHidItemInsert.click();
            }

            if (itemNo.length == 0)
            {
                return false;
            }
            
            //process ZItem
            switch(itemNo.split('-').length)
            {
                case 1:
                    itemNo = "00000" + itemNo;
                    itemNo = itemNo.substr(itemNo.length-5,5);
                    $get(itemCtl).value=itemNo+"-";  
                break;
                case 2:
                     if (itemNo.split('-')[0] == "00000") {ClosePage()};
                        section = "0000" + itemNo.split('-')[1];
                    section = section.substr(section.length-4,4);
                    $get(itemCtl).value=itemNo.split('-')[0]+"-"+section+"-";  
                break;
                case 3:
                     section = "000" + itemNo.split('-')[2];
                    section = section.substr(section.length-3,3);
                    $get(itemCtl).value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
                    completeItem=1;
                break;
            }
        
            if (completeItem==1)
            {
//alert('complete' + itemCtl);
                if (itemCtl == 'txtItemSearch')
                    document.frmBOM.btnHidItemSearch.click();

                if (itemCtl == 'txtItemInsert')
                    document.frmBOM.btnHidItemInsert.click();
            }
            return false;
        }

        function Close()
        {
            //WebCatDiscMaint.DeleteExcel('WebCatDiscMaint'+session).value;
            if (document.getElementById('txtItemSearch').value == '')
            {
//alert('Close');
                document.getElementById('btnHidClose').click();
                window.close();
            }
            else
            {
//alert('clear');
                document.getElementById('btnHidClose').click();
            }
            return false;
        }
    </script>

</head>
<body>
    <form id="frmBOM" runat="server">
        <asp:ScriptManager runat="server" ID="smBOM" EnablePageMethods="true" />
        <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse;">
            <tr>
                <td style="height:5%;">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>

            <tr>
                <td>
                    <table id="tblMain" style="width: 100%; height: 620px;" class="blueBorder" cellpadding="0" cellspacing="0">
                        <tr style="vertical-align:top;">
                            <td>
                                <%--BEGIN BODY--%>

                                <%--TOP BUTTONS--%>
                                <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse;">
                                    <tr class="PageHead shadeBgDown">
                                        <td class="Left2pxPadd DarkBluTxt boldText blueBorder shadeBgDown">
                                            <asp:UpdatePanel ID="pnlTop" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table style="width:100%;">
                                                        <tr>
                                                            <td align="right" style="padding-right: 5px;" width="28%">
                                                                <img id="imgHelp" alt="Help" src="../Common/images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                                                                <img id="imgClose" alt="Close" src="Common/images/close.jpg" style="cursor:hand" onclick="javascript:return Close();" />
                                                                <asp:Button ID="btnHidClose" runat="server" Style="display: none;" CausesValidation="false" OnClick="btnHidClose_Click" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
            
                                <%--FILTER INPUT--%>
                                <asp:UpdatePanel ID="pnlInput" UpdateMode="Conditional" runat="server">
                                    <ContentTemplate>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="lightBlueBg">
                                                    <table style="height:50px;">
                                                        <tr>
                                                            <td style="padding-left: 15px; font-weight: bold; width: 100px;">
                                                                Item Number
                                                            </td>
                                                            <td style="width: 85px">
                                                                <asp:TextBox ID="txtItemSearch" runat="server" Width="90px" CssClass="FormCtrl"
                                                                    TabIndex="1" onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==13 || event.keyCode==9){return ZItem(this.value, this.id);}"></asp:TextBox>
                                                                <asp:Button ID="btnHidItemSearch" runat="server" Style="display: none;" CausesValidation="false" OnClick="btnHidItemSearch_Click" />
                                                                <asp:HiddenField ID="hidBOMParent" runat="server" />
                                                            </td>
                                                            <td style="padding-left: 15px; font-weight: bold; width: 59px;">
                                                                Bill Type
                                                            </td>
                                                            <td style="width: 110px;">
                                                                <asp:DropDownList ID="ddlParentBillType" TabIndex="2" Height="20px" Width="95px" CssClass="FormCtrl" runat="server" />
                                                            </td>
                                                            <td align="right">
                                                                <asp:ImageButton ID="ibtnCreateBOM" TabIndex="3" runat="server" Visible="false" ImageUrl="../Common/Images/CreateBOM.gif"
                                                                    CausesValidation="false" OnClick="ibtnCreateBOM_Click" />
                                                                <asp:HiddenField ID="hidBOMCreated" runat="server" Value="false" />
                                                                <asp:ImageButton runat="server" ID="ibtnDelete" TabIndex="10" Visible="false" ImageUrl="../common/images/btndelete.gif"
                                                                    CausesValidation="false" OnClientClick="javascript:if(confirm('Are you sure you want to delete?')==true){return DelBOM();}" />
                                                                <asp:Button ID="btnHidDelBOM" runat="server" Style="display: none;" CausesValidation="false" OnClick="btnHidDelBOM_Click" />
                                                            </td>
                                                            <td align="right">
                                                                <asp:Label ID="lblReadOnly" Style="padding-left: 5px" Visible="false" ForeColor="red" Font-Bold="true" runat="server" Text="** Read Only **" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                
                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
            
                                <%--ITEM INFO--%>
                                <asp:UpdatePanel ID="pnlItemInfo" UpdateMode="Conditional" runat="server">
                                    <ContentTemplate>
                                        <table width="100%" border="0" cellspacing="2" cellpadding="1" class="lightBlueBg">
                                            <colgroup>
                                                <col width="75px" />
                                                <col width="215px" />
                                                <col width="70px" />
                                                <col width="60px" />
                                                <col width="72px" />
                                                <col width="60px" />
                                                <col width="104px" />
                                                <col width="60px" />
                                                <col width="70px" />
                                                <col width="90px" />
                                                <col width="88px" />
                                                <col width="55px" />
                                            </colgroup>
                                            <tr style="padding-top:15px;">
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Description:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblItemDesc" runat="server" Width="210px" Text="Item Descr 1/4-20 Finished Hex Nut" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Weight/100:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lbl100Wght" runat="server" Width="55px" Text="0.99" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Sell Stock:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblSellStk" runat="server" Width="55px" Text="99999/xx" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Std Cost:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblStdCost" runat="server" Width="55px" Text="0.99/xx" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    UPC Code:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblUPCCd" runat="server" Width="85px" Text="082893425719" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Web Enabled:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblWebEnabled" runat="server" Width="50px" Text="Yes" />
                                                </td>
                                            </tr>
                                            <tr style="padding-top:5px;">
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Category:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblCatDesc" runat="server" Width="210px" Text="xxxxx Finished Hex Nut NC" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Net LB:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblNetWght" runat="server" Width="55px" Text="9999.999" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Super Eqv:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblSupEqv" runat="server" Width="55px" Text="99999/xx" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    List Price:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblListPrice" runat="server" Width="55px" Text="999.99" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Tariff:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblTarrif" runat="server" Width="85px" Text="7318.16.0085" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Pkg Grp:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblPkgGrp" runat="server" Width="50px" Text="99" />
                                                </td>
                                            </tr>
                                            <tr style="padding-top:5px;">
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Plating Type:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblPltTyp" runat="server" Width="55px" Text="PLAT" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Gross LB:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblGrossWght" runat="server" Width="55px" Text="9999.999" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Price UM:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblPriceUM" runat="server" Width="55px" Text="xx" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Corp Fixed Vel:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblCFV" runat="server" Width="55px" Text="xx" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    PPI Code:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblPPI" runat="server" Width="85px" Text="?? xx ??" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Low Profile:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblLowProfile" runat="server" Width="50px" Text="?? xx ??" />
                                                </td>
                                            </tr>
                                            <tr style="padding-top:5px; padding-bottom:15px;">
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Parent Item:
                                                </td>
                                                <td>
                                                    <a id="ParentLink" onclick="OpenParent();">
                                                        <asp:Label ID="lblParentItem" runat="server" Width="100px" Text="xxxxx-xxxx-xxx" />
                                                    </a>
                                                    <asp:HiddenField ID="hidParentItem" runat="server" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Stock Ind:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblStockInd" runat="server" Width="55px" Text="?? xx ??" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Cost UM:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblCostUM" runat="server" Width="55px" Text="xx" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Category Vel:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblCVC" runat="server" Width="55px" Text="xx" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Created:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblCreateDt" runat="server" Width="85px" Text="mm/dd/yyyy" />
                                                </td>
                                                <td class="Left2pxPadd DarkBluTxt boldText">
                                                    Pkg Vel:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblPVC" runat="server" Width="50px" Text="xx" />
                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>

                                <%--BOM GRID--%>
                                <asp:UpdatePanel ID="pnlBOMGrid" UpdateMode="conditional" runat="server">
                                    <ContentTemplate>
                                        <div id="divdatagrid" class="Sbar" runat="server" visible="false" style="overflow: auto; width: 1020px; 
                                            position: relative; top: 0px; left: 0px; height: 302px; border: 0px; vertical-align: top;">
                                            <asp:DataGrid ID="dgBOM" Width="1000px" runat="server" GridLines="both" BorderWidth="1px" 
                                                ShowFooter="false" AllowSorting="true" AllowPaging="true" PageSize="18" CssClass="grid" Style="height: auto"
                                                UseAccessibleHeader="true" AutoGenerateColumns="false" BorderColor="#DAEEEF" PagerStyle-Visible="false"
                                                OnSortCommand="dgBOM_SortCommand">
                                                <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" Wrap="false" />
                                                <ItemStyle CssClass="gridItem" Wrap="false" />
                                                <AlternatingItemStyle CssClass="zebra" Wrap="false" />
                                                <FooterStyle CssClass="lightBlueBg" HorizontalAlign="right" />
                                                <Columns>
                                                    <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Item Number" DataField="BOMItem" SortExpression="BOMItem"
                                                        ItemStyle-HorizontalAlign="Center" ItemStyle-Width="100"></asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="285" HeaderText="Item Description" DataField="BOMItemDesc" SortExpression="BOMItemDesc"
                                                        ItemStyle-HorizontalAlign="Left" ItemStyle-Width="290"></asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="60" HeaderText="Qty Per" DataField="BOMQtyPer" SortExpression="BOMQtyPer"
                                                        ItemStyle-HorizontalAlign="Right" ItemStyle-Width="60" DataFormatString="{0:0.000}"></asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="30" HeaderText="UM" DataField="BOMUM" SortExpression="BOMUM"
                                                        ItemStyle-HorizontalAlign="Right" ItemStyle-Width="30"></asp:BoundColumn>
                                                        
                                                    <asp:BoundColumn HeaderStyle-Width="375" HeaderText="Remarks" DataField="BOMRemarks" SortExpression="BOMRemarks"
                                                        ItemStyle-HorizontalAlign="Left" ItemStyle-Width="390"></asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="70" HeaderText="Seq No" DataField="BOMSeqNo" SortExpression="BOMSeqNo"
                                                        ItemStyle-HorizontalAlign="Right" ItemStyle-Width="70"></asp:BoundColumn>

                                                    <asp:BoundColumn HeaderStyle-Width="80" HeaderText="Bill Type" DataField="BOMBillType" SortExpression="BOMBillType"
                                                        ItemStyle-HorizontalAlign="Left" ItemStyle-Width="80"></asp:BoundColumn>

                                                </Columns>
                                            </asp:DataGrid>
                                            <input type="hidden" id="hidSort" runat="server" />
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>

                                <%--BOM INPUT--%>
                                <asp:UpdatePanel ID="pnlBottom" UpdateMode="conditional" runat="server">
                                    <ContentTemplate>
                                        <table id="tblBottom" runat="server" width="100%" border="0" cellspacing="0" cellpadding="0" class="lightBlueBg" style="height:105px;" visible="false">
                                            <tr>
                                                <td>
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">

                                                        <tr>
                                                            <td style="width:50px;">&nbsp;</td>
                                                            <td class="DarkBluTxt TabHead" style="text-align:center; width:100px;;">
                                                                Item Number
                                                            </td>
                                                            <td class="DarkBluTxt TabHead" style="text-align:center; width:100px;">
                                                                Qty Per
                                                            </td>
                                                            <td class="DarkBluTxt TabHead" style="text-align:center; width:100px;">
                                                                U/M
                                                            </td>
                                                            <td class="DarkBluTxt TabHead" style="text-align:center; width:400px;">
                                                                Remarks
                                                            </td>
                                                            <td class="DarkBluTxt TabHead" style="text-align:center; width:100px;">
                                                                Seq No.
                                                            </td>
                                                            <td class="DarkBluTxt TabHead" style="text-align:center; width:100px;">
                                                                Bill Type
                                                            </td>
                                                            <td style="width:50px;">&nbsp;</td>
                                                        </tr>

                                                        <tr>
                                                            <td style="width:50px;">&nbsp;</td>
                                                            <td style="text-align:center; width:100px;">
                                                                <asp:TextBox ID="txtItemInsert" runat="server" Width="90px" CssClass="FormCtrl"
                                                                    TabIndex="4" onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==13 || event.keyCode==9){return ZItem(this.value, this.id);}"></asp:TextBox>
                                                                <asp:Button ID="btnHidItemInsert" runat="server" Style="display: none;" CausesValidation="false" OnClick="btnHidItemInsert_Click" />
                                                                <asp:HiddenField ID="hidBOMChild" runat="server" />
                                                            </td>
                                                            <td style="text-align:center; width:100px;">
                                                                <asp:TextBox ID="txtQtyPer" TabIndex="5" Width="40px" onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==13){return WriteBOM();}" CssClass="FormCtrl" runat="server" />
                                                            </td>
                                                            <td style="text-align:center; width:100px;">
                                                                <asp:DropDownList ID="ddlUM" TabIndex="6" Height="20px" Width="90px" onkeydown="javascript:if(event.keyCode==13){return WriteBOM();}" CssClass="FormCtrl" runat="server" />
                                                            </td>
                                                            <td style="text-align:center; width:400px;">
                                                                <asp:TextBox ID="txtRemark" TabIndex="7" Width="350px" onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==13){return WriteBOM();}" CssClass="FormCtrl" runat="server" />
                                                            </td>
                                                            <td style="text-align:center; width:100px;">
                                                                <asp:TextBox ID="txtSeqNo" TabIndex="8" Width="55px" onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==13){return WriteBOM();}" CssClass="FormCtrl" runat="server" />
                                                                <asp:HiddenField ID="hidNextSeqNo" runat="server" Value="100" />
                                                            </td>
                                                            <td style="text-align:center; width:100px;">
                                                                <asp:DropDownList ID="ddlBOMBillType" TabIndex="9" Height="20px" Width="90px" onkeydown="javascript:if(event.keyCode==13 || event.keyCode==9){return WriteBOM();}" CssClass="FormCtrl" runat="server" />
                                                            </td>
                                                            <td style="width:50px;">&nbsp;</td>
                                                        </tr>
                                                        <tr style="padding-top:5px;">
                                                            <td style="width:50px;">&nbsp;</td>
                                                            <td colspan="6" style="padding-left:10px;">
                                                                <asp:Label ID="lblInsertItemDesc" runat="server" Text=""></asp:Label></td>
                                                            <td style="width:50px;">
                                                                <asp:Button ID="btnHidWriteBOM" runat="server" Style="display: none;" CausesValidation="false" OnClick="btnHidWriteBOM_Click" /></td>
                                                    </table>
                                                    <asp:HiddenField ID="hidSecurity" runat="server" />
                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <%--END BODY--%>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="BluBg buttonBar" height="20px">
                    <table>
                        <tr>
                            <td style="width:300px">
                                <asp:UpdatePanel ID="pnlStatus" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true" runat="server" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>

                            <td style="width:300px">
                                <asp:UpdateProgress ID="pnlProgress" runat="server" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>

                            <td style="text-align: right; width:419px">
                                <asp:ImageButton ID="ibtnExport" runat="server" ImageUrl="../Common/Images/ExcelIcon.jpg" CausesValidation="false" OnClick="ibtnExport_Click" />
                            </td>

                            <td style="text-align: right;">
                                <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlExport">
                                    <ContentTemplate>
                                        <uc4:PrintDialogue ID="PrintDialogue1" EnableFax="false" EnableEmail="false" runat="server" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="Footer1" Title="Bill Of Materials" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
