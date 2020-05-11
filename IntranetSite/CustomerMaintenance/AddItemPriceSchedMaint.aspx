<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddItemPriceSchedMaint.aspx.cs" Inherits="AddItemPriceSchedMaint" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<%@ Register Src="~/Common/UserControls/popupdatepicker.ascx" TagName="popupdatepicker" TagPrefix="uc3" %>
<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc4" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Customer Price Schedule Maintenance</title>
    <link href="../MaintenanceApps/Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    
    <script src="../Common/Javascript/DatePicker.js" type="text/javascript"></script>

    <style type="text/css">
	    .TabHead
	    {
        	font-family: Arial, Helvetica, sans-serif;
	        font-size: 11px;
	        font-weight: bold;
	        color: #003366;	
        }
        
        .PageCombo
        {
        	background-color: #f8f8f8;
	        border: 1px solid #cccccc;
	        font-family: Arial, Helvetica, sans-serif;
	        font-size: 11px;
	        color: #000000;
	        width: 55px;
	        height: 22px;
        }
        
        .LeftPadding
        {
        	padding-left: 20px;
        }

        .txtCenter
        {
	        text-align: center;
        }

        .txtRight
        {
	        text-align: right;
        }
    </style>

    <script language="javascript">
        function zItem(itemNo)
        {
            document.getElementById("hidSellUM").value = "";
            document.getElementById("hidSellStkUM").value = "";
            document.getElementById("hidAltSellStkUMQty").value = "1";

            document.getElementById("txtAltPrice").innerText = "";
            document.getElementById("txtAltPriceFut").innerText = "";
            document.getElementById("lblSellPrice").innerText = "";
            document.getElementById("lblSellPriceFut").innerText = "";
            document.getElementById("lblAltPriceUM").innerText = "";
            document.getElementById("lblAltPriceFutUM").innerText = "";
            document.getElementById("lblSellPriceUM").innerText = "";
            document.getElementById("lblSellPriceFutUM").innerText = "";
            document.getElementById("lblMessage").innerText = "";
            document.getElementById("hidMode").value = "Add";
           
            if(itemNo != "")
            {
                var section = "";
                var completeItem = 0;
                var result = "";
                var status = "";

                switch(itemNo.split('-').length)
                {
                    case 1:
                        event.keyCode = 0;
                        itemNo = "00000" + itemNo;
                        itemNo = itemNo.substr(itemNo.length-5,5);
                        document.getElementById("txtItem").value = itemNo + "-"; 
                        break;
                    case 2:
                        ////close if they are entering an empty part
                        //if (itemNo.split('-')[0] == "00000") {ClosePage()};
                        event.keyCode = 0;
                        section = "0000" + itemNo.split('-')[1];
                        section = section.substr(section.length-4,4);
                        document.getElementById("txtItem").value = itemNo.split('-')[0] + "-" + section + "-";  
                        break;
                    case 3:
                        event.keyCode = 0;
                        section = "000" + itemNo.split('-')[2];
                        section = section.substr(section.length-3,3);
                        document.getElementById("txtItem").value = itemNo.split('-')[0] + "-" + itemNo.split('-')[1] + "-" + section;  
                        completeItem = 1;
                        break;
                }

                if (completeItem == 1)
                {
                    itemNo = document.getElementById("txtItem").value;
                    result = AddItemPriceSchedMaint.ValidateItem(itemNo).value;
                    if(result[0] != "true")    //Item not valid
                    {
                        document.getElementById("txtItem").value = "";
                        document.getElementById("lblMessage").innerText = "Item " + itemNo + " not on file";
                        document.getElementById("lblMessage").style.color = "red";
                        window.document.frmCustPriceSched.txtItem.focus();
                    }
                    else
                    {
                        document.getElementById("hidSellUM").value = result[1];
                        document.getElementById("hidSellStkUM").value = result[2];
                        document.getElementById("hidAltSellStkUMQty").value = result[3];
                        document.getElementById("dtEffDt_txtDatePicker").value = result[4];
                        document.getElementById("lblDesc").innerHTML = result[5];
                        document.getElementById("lblPcs").innerHTML = result[6];
                        document.getElementById("lblUOM").innerHTML = result[2];                        
                        document.getElementById("hidDesc").value = result[5];
                        document.getElementById("hidPcs").value = result[6];
                        document.getElementById("dpEffEndDt_txtDatePicker").value = result[7];
                        
                        document.getElementById("lblAltPriceUM").innerText = " / " + document.getElementById("hidSellUM").value;
                        document.getElementById("lblAltPriceFutUM").innerText = " / " + document.getElementById("hidSellUM").value;                        

                        // Check for dup
                        var contractName = document.getElementById("lblContract").innerHTML;
                        status = AddItemPriceSchedMaint.CheckDup(contractName, itemNo).value;
                        
                        if (status == "true")   //Duplicate found
                        {
//                          document.getElementById("txtItem").value = "";
//                          document.getElementById("lblMessage").innerText = "Item " + itemNo + " already exists on Contract " + contractName;
//                          document.getElementById("lblMessage").style.color = "red";
                            //window.document.frmCustPriceSched.txtItem.focus();
                            document.getElementById("btnReloadItem").click();
                        }
                        else
                        {
                            window.document.frmCustPriceSched.txtPriceMeth.focus();
                        }
                       
                    }
                }
            }
            else
            {
                event.keyCode = 0;
                window.document.frmCustPriceSched.txtPriceMeth.focus();
            }
        }

        function SetCoord()
        {
            document.getElementById('hidScroll').value = document.getElementById("divdatagrid").scrollLeft;
        }

        function ScrollIt()
        {
            document.getElementById("divdatagrid").scrollLeft = document.getElementById("hidScroll").value;
        }

        function Close()
        {
            AddItemPriceSchedMaint.UnloadPage().value;
            window.close();
        }

    </script>
</head>
<body>
    <form id="frmCustPriceSched" runat="server">
        <asp:ScriptManager runat="server" ID="smCustPriceSched">
        </asp:ScriptManager>
        <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse;" id="mainTable">
            <tr>
                <td height="5%" id="tdHeaders">
                    <uc1:Header ID="HeaderID" runat="server" />
                </td>
            </tr>
            <tr class="PageHead shadeBgDown">
                <td class="DarkBluTxt boldText blueBorder shadeBgDown">
                    <table width="100%" style="padding-left: 0px;">
                        <tr>
                            <td>
                                <asp:Label ID="lblHeader" runat="server" Text="Customer Price Schedule Maintenance" CssClass="BanText"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="pnlTop" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <table cellpadding="0" cellspacing="0" border=0 height="40px" width="100%">
                                <tr runat="server" id="tdHeader">
                                    <td width="10px" class="lightBlueBg" style="padding-left: 10px">&nbsp;<asp:Label ID="lblHeading" runat="server" Font-Bold="True" Font-Size="10pt" Width="300px"></asp:Label></td>
                                    <td width="100px" class="Left2pxPadd lightBlueBg boldText">&nbsp;</td>
                                    <td width="200px" class="Left2pxPadd lightBlueBg">
                                        &nbsp;
                                    </td>
                                    <td class="Left2pxPadd lightBlueBg">
                                        <asp:ImageButton ID="btnSearch" Visible=false runat="server" ImageUrl="common/Images/Search.jpg" CausesValidation="false" OnClick="btnSearch_Click" TabIndex="-1" />&nbsp;
                                    </td>
                                    <td align="right" valign="middle" style="padding-right: 0px;" class="lightBlueBg">
                                        <asp:ImageButton ID="btnAdd" runat="server" ImageUrl="common/Images/newAdd.gif" CausesValidation="false" OnClick="btnAdd_Click" TabIndex="-1" />
                                        <img id="imgClose" src="Common/images/close.jpg" style="cursor: hand" onclick="javascript:Close();" tabindex="-1" />
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="padding-top: 0px; padding-left: 0px;">
                    <asp:UpdatePanel ID="pnlContent" UpdateMode="Conditional" runat="server">
                        <ContentTemplate>
                            <table id="ContentTable" width="100%" border="0" cellspacing="0" cellpadding="0" visible="false" runat="server" style="padding-top:5px;">
                                <tr>
                                    <td style="border-bottom:1px solid #88D2E9; padding-bottom: 5px;">
                                        <asp:Panel ID="pnlWebCatDsc" runat="server">
                                            <table border=0>
                                                <tr>
                                                    <td width="10"></td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" width="85">
                                                        Contract Name
                                                    </td>
                                                    <td class="Left2pxPadd" width="185">
                                                        <asp:Label ID="lblContract" runat="server" Text="Select a valid Contract above" Width="160px"></asp:Label>
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" width="100">
                                                        Price Method
                                                    </td>
                                                    <td class="Left2pxPadd" width="115">
                                                        <asp:TextBox CssClass="FormCtrl" Style="text-align: right" runat="server" ID="txtPriceMeth"
                                                            TabIndex="6" MaxLength="2" Width="20px" OnFocus="javascript:this.select();"
                                                            OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;"></asp:TextBox>
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" width="125">
                                                        <asp:Label ID="lblFuturePriceMeth" runat="server" Text="Future Price Method" Visible="False"
                                                            Width="120px"></asp:Label>
                                                    </td>
                                                    <td class="Left2pxPadd" width="115">
                                                        <asp:TextBox CssClass="FormCtrl" Style="text-align: right;display:none;" runat="server" ID="txtPriceMethFut"
                                                            TabIndex="10" MaxLength="2" Width="20px" OnFocus="javascript:this.select();"
                                                            OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;"></asp:TextBox>
                                                    </td>
                                                    <td width="55"></td>
                                                    <td align="right" style="width:170;">
                                                        <asp:ImageButton ID="btnSave" Visible="false" CausesValidation="true" runat="server"
                                                            TabIndex="-1" ImageUrl="common/Images/BtnSave.gif" OnClick="btnSave_Click" />
                                                        <asp:ImageButton ID="btnCancel" Visible="false" runat="server" ImageUrl="common/Images/cancel.png"
                                                            TabIndex="-1" CausesValidation="false" OnClick="btnCancel_Click" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        Item No
                                                    </td>
                                                    <td class="Left2pxPadd">
                                                        <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtItem" AutoCompleteType="Disabled"
                                                            TabIndex="5" MaxLength="14" Width="85px" OnFocus="javascript:this.select();"
                                                            OnKeyDown="javascript:if(event.keyCode==9)event.keyCode=13;return event.keyCode;"
                                                            OnKeyPress="javascript:if(event.keyCode==13)zItem(this.value);"></asp:TextBox>
                                                        </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        Effective Date
                                                    </td>
                                                    <td class="Left2pxPadd">
                                                        <uc3:popupdatepicker ID="dtEffDt" runat="server" TabIndex="7" ParentErrCtl="lblMessage" />
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        <asp:Label ID="lblFutureEffDt" runat="server" Text="Future Effective Date" Visible="False"
                                                            Width="120px"></asp:Label></td>
                                                    <td class="Left2pxPadd" style="display:none;">
                                                        <uc3:popupdatepicker ID="dtEffDtFut"  runat="server" TabIndex="12" ParentErrCtl="lblMessage" Visible="true" />
                                                    </td>
                                                    <td colspan="2"></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        Description</td>
                                                    <td>
                                                        <asp:Label ID="lblDesc" runat="server" Width="160px"></asp:Label>
                                                        <asp:HiddenField ID="hidDesc" runat="server" />
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        Effective End Date</td>
                                                    <td class="Left2pxPadd">
                                                        <uc3:popupdatepicker ID="dpEffEndDt" runat="server" TabIndex="7" ParentErrCtl="lblMessage" />
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        <asp:Label ID="Label2" runat="server" Text="Future Eff End Date" Visible="False"
                                                            Width="121px"></asp:Label></td>
                                                    <td class="Left2pxPadd" style="display:none;">
                                                        <uc3:popupdatepicker ID="dpEffEndDatFut" runat="server" TabIndex="7" ParentErrCtl="lblMessage" />
                                                    </td>
                                                    <td colspan="2">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        UOM</td>
                                                    <td>
                                                        <asp:Label ID="lblUOM" runat="server" Width="90px"></asp:Label></td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        Alt Sell Price
                                                    </td>
                                                    <td class="Left2pxPadd">
                                                        <asp:TextBox CssClass="FormCtrl" Style="text-align: right" runat="server" ID="txtAltPrice" AutoPostBack="true"
                                                            TabIndex="8" MaxLength="12" Width="70px" OnFocus="javascript:this.select();" OnTextChanged="txtAltPrice_TextChanged"
                                                            OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;"
                                                            OnKeyPress="javascript:if(event.keyCode!=36&&event.keyCode!=44&&event.keyCode!=45&&event.keyCode!=46&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;"></asp:TextBox>
                                                        <asp:Label ID="lblAltPriceUM" runat="server"></asp:Label>
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        <asp:Label ID="lblFutureAltSellPrice" runat="server" Text="Future Alt Sell Price"
                                                            Visible="False" Width="121px"></asp:Label>
                                                    </td>
                                                    <td class="Left2pxPadd">
                                                        <asp:TextBox CssClass="FormCtrl" Style="text-align: right;display:none;" runat="server" ID="txtAltPriceFut" AutoPostBack="true"
                                                            TabIndex="12" MaxLength="12" Width="70px" OnFocus="javascript:this.select();" OnTextChanged="txtAltPriceFut_TextChanged"
                                                            OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;"
                                                            OnKeyPress="javascript:if(event.keyCode!=36&&event.keyCode!=44&&event.keyCode!=45&&event.keyCode!=46&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;"></asp:TextBox>
                                                        <asp:Label ID="lblAltPriceFutUM" runat="server" Style="display:none;"></asp:Label>
                                                    </td>
                                                    <td colspan="2"></td>
                                                </tr>
                                                <tr>
                                                     <td>
                                                    
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        Pieces</td>
                                                    <td>
                                                        <asp:Label ID="lblPcs" runat="server" Width="90px"></asp:Label>
                                                        <asp:HiddenField ID="hidPcs" runat="server" />
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        Sell Price
                                                    </td>
                                                    <td class="Left2pxPadd">
<%--                                                        <asp:TextBox CssClass="FormCtrl" Style="text-align: right" runat="server" ID="txtSellPrice" AutoPostBack="true"
                                                            TabIndex="9" MaxLength="12" Width="70px" OnFocus="javascript:this.select();" OnTextChanged="txtSellPrice_TextChanged"
                                                            OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;"
                                                            OnKeyPress="javascript:if(event.keyCode!=36&&event.keyCode!=44&&event.keyCode!=45&&event.keyCode!=46&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;"></asp:TextBox>--%>
                                                        <asp:Label ID="lblSellPrice" runat="server" CssClass="txtRight" Width="72px"></asp:Label>
                                                        <asp:Label ID="lblSellPriceUM" runat="server"></asp:Label>
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        <asp:Label ID="lblFutureSellPrice" runat="server" Text="Future Sell Price" Visible="False"
                                                            Width="121px"></asp:Label>
                                                    </td>
                                                    <td class="Left2pxPadd">
<%--                                                        <asp:TextBox CssClass="FormCtrl" Style="text-align: right" runat="server" ID="txtSellPriceFut" AutoPostBack="true"
                                                            TabIndex="14" MaxLength="12" Width="70px" OnFocus="javascript:this.select();" OnTextChanged="txtSellPriceFut_TextChanged"
                                                            OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;"
                                                            OnKeyPress="javascript:if(event.keyCode!=36&&event.keyCode!=44&&event.keyCode!=45&&event.keyCode!=46&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;"></asp:TextBox>--%>
                                                        <asp:Label ID="lblSellPriceFut" runat="server" Style="display:none;" CssClass="txtRight" Width="72px"></asp:Label>
                                                        <asp:Label ID="lblSellPriceFutUM" runat="server" Style="display:none;" ></asp:Label>
                                                    </td>
                                                    <td colspan="2"></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3"><asp:HiddenField ID="hidpCustomerPriceID" runat="server" />
                                                        <asp:HiddenField ID="hidMode" runat="server" />
                                                        <asp:Button ID="btnReloadItem" runat="server" CssClass="FormCtrl" Style="display:none;" OnClick="btnReloadItem_Click" /></td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        <asp:Label ID="Label3" runat="server" Text="Discount" Visible="False" Width="121px"></asp:Label></td>
                                                    <td class="Left2pxPadd">
                                                        <asp:TextBox CssClass="FormCtrl" Style="text-align: right" runat="server" ID="txtDisc" AutoPostBack="true"
                                                            TabIndex="9" MaxLength="10" Width="70px" OnFocus="javascript:this.select();" OnTextChanged="txtDisc_TextChanged"
                                                            OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;"
                                                            OnKeyPress="javascript:if(event.keyCode!=37&&event.keyCode!=44&&event.keyCode!=45&&event.keyCode!=46&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;" Enabled="False" Visible="False"></asp:TextBox>
                                                        <asp:Label ID="Label4" runat="server" Visible="False">%</asp:Label></td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        <asp:Label ID="lblFutureDisc" runat="server" Text="Future Discount" Visible="False"
                                                            Width="121px"></asp:Label>
                                                    </td>
                                                    <td class="Left2pxPadd">
                                                        <asp:TextBox CssClass="FormCtrl" Style="display:none;text-align: right" runat="server" ID="txtDiscFut" AutoPostBack="true"
                                                            TabIndex="13" MaxLength="10" Width="70px" OnFocus="javascript:this.select();" OnTextChanged="txtDiscFut_TextChanged"
                                                            OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;"
                                                            OnKeyPress="javascript:if(event.keyCode!=37&&event.keyCode!=44&&event.keyCode!=45&&event.keyCode!=46&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;"></asp:TextBox>&nbsp;<asp:Label
                                                                ID="Label1" runat="server" Visible="False">%</asp:Label></td>
                                                    <td colspan="2"></td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <table cellpadding="0" cellspacing="0" width="100%" runat=server id="tblGrid">
                        <tr>
                            <td valign="top">
                                <asp:UpdatePanel ID="pnlPriceGrid" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div runat="server" id="divCustPriceGrid" visible="true">
                                            <div id="divdatagrid" class="Sbar" align="left" runat="server" onscroll="SetCoord()"
                                                style="overflow: auto; width: 1020px; position: relative; top: 0px; left: 0px; height: 495px; border: 0px solid; vertical-align: top;">
                                                <asp:DataGrid ID="dgCustPriceSched" Width="1050" runat="server" GridLines="both" BorderWidth="1px"
                                                    TabIndex="-1" ShowFooter="false" AllowSorting="true" AllowPaging="true" PageSize="18"
                                                    CssClass="grid" Style="height: auto" UseAccessibleHeader="true" AutoGenerateColumns="false"
                                                    BorderColor="#DAEEEF" PagerStyle-Visible="false" OnItemDataBound="dgCustPriceSched_ItemDataBound"
                                                    OnSortCommand="dgCustPriceSched_SortCommand" OnItemCommand="dgCustPriceSched_ItemCommand">
                                                    <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                    <ItemStyle CssClass="GridItem" />
                                                    <AlternatingItemStyle CssClass="zebra" />
                                                    <FooterStyle CssClass="lightBlueBg" />
                                                    <Columns>
                                                        <asp:TemplateColumn ItemStyle-Width="50px" HeaderText="Actions" HeaderStyle-Width="60px"
                                                            ItemStyle-HorizontalAlign="center">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblNoAction" runat="server" Visible="false" Text="None" Font-Bold="true"></asp:Label>
                                                                <asp:LinkButton ID="lnkDelete" Font-Underline="true" ForeColor="#cc0000" CausesValidation="false"
                                                                    OnClientClick="javascript:if(confirm('Are you sure you want to delete?')==true){document.getElementById('hidDelConf').value = 'true';} else {document.getElementById('hidDelConf').value = 'false';}"
                                                                    CommandName="Delete" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.pCustomerPriceID")%>'
                                                                    runat="server" Visible="false" Text="Delete"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:BoundColumn HeaderStyle-Width="150" ItemStyle-HorizontalAlign="Center" HeaderText="Contract Name"
                                                            FooterStyle-HorizontalAlign="right" DataField="ContractID" SortExpression="ContractID"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="150" Visible=false></asp:BoundColumn>
                                                            
                                                        <asp:BoundColumn HeaderStyle-Width="125" ItemStyle-HorizontalAlign="Center" HeaderText="Item No"
                                                            FooterStyle-HorizontalAlign="right" DataField="ItemNo" SortExpression="ItemNo"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="125"></asp:BoundColumn>

                                                        <asp:TemplateColumn HeaderText="Price Method" SortExpression="PriceMethod">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtPriceMethGrid" Width="20px" MaxLength="2" runat="server" AutoPostBack="true" CssClass="FormCtrl txtCenter" Text='<%#DataBinder.Eval(Container.DataItem,"PriceMethod") %>'
                                                                    OnFocus="javascript:this.select();" OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;" OnTextChanged="txtPriceMethGrid_TextChanged"></asp:TextBox>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="40px" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn HeaderText="Effective Date" SortExpression="EffDt">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtEffDtGrid" Width="60px" MaxLength="10" runat="server" AutoPostBack="true" CssClass="FormCtrl txtCenter" Text='<%#DataBinder.Eval(Container.DataItem,"EffDt") %>'
                                                                    OnFocus="javascript:this.select();" OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;" OnTextChanged="txtEffDtGrid_TextChanged"
                                                                    OnKeyPress="javascript:if(event.keyCode!=45&&event.keyCode!=47&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;"></asp:TextBox>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="75px" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn HeaderText="Effective End Date" SortExpression="EffEndDt">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtEffEndDtGrid" Width="60px" MaxLength="10" runat="server" AutoPostBack="true" CssClass="FormCtrl txtCenter" Text='<%#DataBinder.Eval(Container.DataItem,"EffEndDt") %>'
                                                                    OnFocus="javascript:this.select();" OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;" OnTextChanged="txtEffEndDtGrid_TextChanged"
                                                                    OnKeyPress="javascript:if(event.keyCode!=45&&event.keyCode!=47&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;"></asp:TextBox>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="75px" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn HeaderText="Alt Sell Price" SortExpression="AltSellPrice">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtAltPriceGrid" Width="70px" MaxLength="12" runat="server" AutoPostBack="true" CssClass="FormCtrl txtRight" Text='<%#DataBinder.Eval(Container.DataItem,"AltSellPrice") %>'
                                                                    OnFocus="javascript:this.select();" OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;" OnTextChanged="txtAltPriceGrid_TextChanged"
                                                                    OnKeyPress="javascript:if(event.keyCode!=36&&event.keyCode!=44&&event.keyCode!=45&&event.keyCode!=46&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;"></asp:TextBox>
                                                                &nbsp;/ <%#DataBinder.Eval(Container.DataItem,"SellUm") %>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="115px" HorizontalAlign="Left" VerticalAlign="Middle" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn HeaderText="Sell Price" SortExpression="SellPrice">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblSellPriceGrid" runat="server" CssClass="txtRight" Width="60px" Text='<%#DataBinder.Eval(Container.DataItem,"SellPrice") %>'></asp:Label>
                                                                &nbsp;/ <%#DataBinder.Eval(Container.DataItem,"SellStkUm") %>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="110px" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn HeaderText="Disc %" SortExpression="DiscPct" Visible=false>
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtDiscGrid" Width="65px" MaxLength="10" runat="server" AutoPostBack="true" CssClass="FormCtrl txtRight" Text='<%#DataBinder.Eval(Container.DataItem,"DiscPct") %>'
                                                                    OnFocus="javascript:this.select();" OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;" OnTextChanged="txtDiscGrid_TextChanged"
                                                                    OnKeyPress="javascript:if(event.keyCode!=37&&event.keyCode!=44&&event.keyCode!=45&&event.keyCode!=46&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;"></asp:TextBox>&nbsp;%
                                                            </ItemTemplate>
                                                            <ItemStyle Width="85px" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:BoundColumn HeaderStyle-Width="90" ItemStyle-HorizontalAlign="Right" HeaderText="GM% @ Avg Cost"
                                                            FooterStyle-HorizontalAlign="right" DataFormatString="{0:F2}" DataField="GMPctAvg" SortExpression="GMPctAvg"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="100"></asp:BoundColumn>
                                                            
                                                        <asp:BoundColumn HeaderStyle-Width="90" ItemStyle-HorizontalAlign="Right" HeaderText="GM% @ Rpl Cost"
                                                            FooterStyle-HorizontalAlign="right" DataField="GMPctRpl"  DataFormatString="{0:F2}" SortExpression="GMPctRpl"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="100"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="125" ItemStyle-HorizontalAlign="Center" HeaderText="Entry ID"
                                                            FooterStyle-HorizontalAlign="right" DataField="EntryID" SortExpression="EntryID"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="125"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="75" ItemStyle-HorizontalAlign="Center" HeaderText="Entry Date"
                                                            FooterStyle-HorizontalAlign="right" DataField="EntryDt" SortExpression="EntryDt"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="75" DataFormatString="{0:MM/dd/yyyy}"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="125" ItemStyle-HorizontalAlign="Center" HeaderText="Change ID"
                                                            FooterStyle-HorizontalAlign="right" DataField="ChangeID" SortExpression="ChangeID"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="125"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="75" ItemStyle-HorizontalAlign="Center" HeaderText="Change Date"
                                                            FooterStyle-HorizontalAlign="right" DataField="ChangeDt" SortExpression="ChangeDt"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="75" DataFormatString="{0:MM/dd/yyyy}"></asp:BoundColumn>

                                                        <asp:TemplateColumn HeaderText="Future Price Meth" SortExpression="FutPriceMethod" Visible=false>
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtPriceMethFutGrid" Width="30px" MaxLength="2" runat="server" AutoPostBack="true" CssClass="FormCtrl txtCenter" Text='<%#DataBinder.Eval(Container.DataItem,"FutPriceMethod") %>'
                                                                    OnFocus="javascript:this.select();" OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;" OnTextChanged="txtPriceMethFutGrid_TextChanged"></asp:TextBox>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="75px" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn HeaderText="Future Eff Date" SortExpression="FutEffDt" Visible=false>
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtEffDtFutGrid" Width="60px" MaxLength="10" runat="server" AutoPostBack="true" CssClass="FormCtrl txtCenter" Text='<%#DataBinder.Eval(Container.DataItem,"FutEffDt") %>'
                                                                    OnFocus="javascript:this.select();" OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;" OnTextChanged="txtEffDtFutGrid_TextChanged"
                                                                    OnKeyPress="javascript:if(event.keyCode!=45&&event.keyCode!=47&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;"></asp:TextBox>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="75px" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                        </asp:TemplateColumn>
                                                        
                                                         <asp:TemplateColumn HeaderText="Future Eff End Date" SortExpression="FutEffEndDt" Visible=false>
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtEffEndDtFutGrid" Width="60px" MaxLength="10" runat="server" AutoPostBack="true" CssClass="FormCtrl txtCenter" Text='<%#DataBinder.Eval(Container.DataItem,"FutEffEndDt") %>'
                                                                    OnFocus="javascript:this.select();" OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;" OnTextChanged="txtEffEndDtFutGrid_TextChanged"
                                                                    OnKeyPress="javascript:if(event.keyCode!=45&&event.keyCode!=47&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;"></asp:TextBox>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="75px" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn HeaderText="Future Alt Sell Price" SortExpression="FutAltSellPrice" Visible=false>
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtAltPriceFutGrid" Width="70px" MaxLength="12" runat="server" AutoPostBack="true" CssClass="FormCtrl txtRight" Text='<%#DataBinder.Eval(Container.DataItem,"FutAltSellPrice") %>'
                                                                    OnFocus="javascript:this.select();" OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;" OnTextChanged="txtAltPriceFutGrid_TextChanged"
                                                                    OnKeyPress="javascript:if(event.keyCode!=36&&event.keyCode!=44&&event.keyCode!=45&&event.keyCode!=46&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;"></asp:TextBox>
                                                                &nbsp;/ <%#DataBinder.Eval(Container.DataItem,"SellUm") %>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="115px" HorizontalAlign="Left" VerticalAlign="Middle" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn HeaderText="Future Sell Price" SortExpression="FutSellPrice" Visible=false>
                                                            <ItemTemplate>
<%--                                                                <asp:TextBox ID="txtSellPriceFutGrid" Width="70px" MaxLength="12" runat="server" AutoPostBack="true" CssClass="FormCtrl txtRight" Text='<%#DataBinder.Eval(Container.DataItem,"FutSellPrice") %>'
                                                                    OnFocus="javascript:this.select();" OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;" OnTextChanged="txtSellPriceFutGrid_TextChanged"
                                                                    OnKeyPress="javascript:if(event.keyCode!=36&&event.keyCode!=44&&event.keyCode!=45&&event.keyCode!=46&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;"></asp:TextBox>--%>
                                                                <asp:Label ID="lblSellPriceFutGrid" runat="server" CssClass="txtRight" Width="70px" Text='<%#DataBinder.Eval(Container.DataItem,"FutSellPrice") %>'></asp:Label>
                                                                &nbsp;/ <%#DataBinder.Eval(Container.DataItem,"SellStkUm") %>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="115px" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn HeaderText="Future Disc %" SortExpression="FutDiscPct" Visible=false>
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtDiscFutGrid" Width="65px" MaxLength="10" runat="server" AutoPostBack="true" CssClass="FormCtrl txtRight" Text='<%#DataBinder.Eval(Container.DataItem,"FutDiscPct") %>'
                                                                    OnFocus="javascript:this.select();" OnKeyDown="javascript:if(event.keyCode==13)event.keyCode=9;return event.keyCode;" OnTextChanged="txtDiscFutGrid_TextChanged"
                                                                    OnKeyPress="javascript:if(event.keyCode!=37&&event.keyCode!=44&&event.keyCode!=45&&event.keyCode!=46&&(event.keyCode<48||event.keyCode>57))event.keyCode=0;return event.keyCode;"></asp:TextBox>&nbsp;%
                                                            </ItemTemplate>
                                                            <ItemStyle Width="85px" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                        </asp:TemplateColumn>
                                                 </Columns>
                                                </asp:DataGrid>
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>                    
                    <%--   *****  Hidden Fields  *****   --%>
                    <input type="hidden" id="hidSort" runat="server" />
                    <input type="hidden" id="hidScroll" runat="server" value="0"/>
                    <asp:HiddenField ID="hidSecurity" runat="server" />
                    <asp:HiddenField ID="hidRecID" runat="server" />
                    <asp:HiddenField ID="hidDelConf" runat="server" />
                    <asp:HiddenField ID="hidRowCount" runat="server" />
                    <asp:HiddenField ID="hidSellUM" runat="server" />
                    <asp:HiddenField ID="hidSellStkUM" runat="server" />
                    <asp:HiddenField ID="hidAltSellStkUMQty" runat="server" Value="1" />
                </td>
            </tr>
            <tr>
                <td class="lightBlueBg buttonBar" height="20px">
                    <table>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdateProgress ID="pnlUpdate" runat="server" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="BluBg">
                    <asp:UpdatePanel ID="pnlPager" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" id="tPager" runat="server" visible="false">
                                <tr>
                                    <td>
                                        <uc4:pager id="Pager1" onbubbleclick="Pager_PageChanged" runat="server" visible="true" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:BottomFooter ID="BottomFooterID" Title="Customer Price Schedule Maintenance" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
