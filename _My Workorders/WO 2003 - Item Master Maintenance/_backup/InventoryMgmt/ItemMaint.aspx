<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ItemMaint.aspx.cs" Inherits="ItemMaint" %>

<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage2.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head2" runat="server">
    <title>Item Master Maintenance</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script src="../Common/JavaScript/WorkSheet.js" type="text/javascript"></script>
    <script src="JavaScript/InventoryMgmt.js" type="text/javascript"></script>

    <style type="text/css">.DarkBluTxt
        {
	        font-family: Arial, Helvetica, sans-serif;
	        font-size: 15px;
            font-weight: bold;
	        color: #003366;
        }
        
        .LabelCtrl2
        {
	        font-family: Arial, Helvetica, sans-serif;
	        font-size: 11px;
	        color: #003366;
        }
        .middle
        {
            vertical-align: middle;
        }
        .txtRight
        {
            horizontal-align: right;
        }
    </style>

    <script language="javascript" type="text/javascript">
    //Text input validation
        function ValidateNum() //This allows only 0 thru 9 plus decimal point
        {
            if (event.keyCode != 46 && (event.keyCode < 48 || event.keyCode > 57))
                event.keyCode=0;
        }
        
        function FormatDollar(txtVal, txtCtl)
        {
            //alert("FormatDollar");
            $get(txtCtl).value = '$'+ parseFloat(txtVal).toFixed(2);
        }
        
//        function Round3(txtVal, txtCtl)
//        {
//            //alert("Round3");
//            $get(txtCtl).value = parseFloat(txtVal).toFixed(3);
//        }
    </script>

    <script language="javascript" type="text/javascript">
    //BEGIN zItem
        function ZItem(itemNo, itemCtl)
        {
            var section="";
            var completeItem=0;
            event.keyCode=0;

            if (itemNo.length >= 14)
            {
                CheckItem(itemCtl);
                return false;
            }

            if (itemNo.length == 0)
            {
                return false;
            }
            
            switch(itemNo.split('-').length)
            {
                case 1:
                    itemNo = "00000" + itemNo;
                    itemNo = itemNo.substr(itemNo.length-5,5);
                    $get(itemCtl).value=itemNo+"-";  
                break;
                case 2:
                    if (itemNo.split('-')[0] == "00000")
                    {
                        ClosePage();
                    }
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
                CheckItem(itemCtl);
            }
            return false;
        }

        function ZCat(catNo, catCtl)
        {
            catNo = "00000" + catNo;
            catNo = catNo.substr(catNo.length-5,5);
            $get(catCtl).value=catNo;
            event.keyCode=9;
        }
        
        function ZSize(sizeNo, sizeCtl)
        {
            sizeNo = "0000" + sizeNo;
            sizeNo = sizeNo.substr(sizeNo.length-4,4);
            $get(sizeCtl).value=sizeNo;
            event.keyCode=9;
        }

        function ZVar(varNo, varCtl)
        {
            varNo = "000" + varNo;
            varNo = varNo.substr(varNo.length-3,3);
            $get(varCtl).value=varNo;
            event.keyCode=9;
        }
    //END zItem
    </script>

    <script language="javascript" type="text/javascript">
    //BEGIN CheckItem - called from zItem upon entry of a complete itemNo
        function CheckItem(itemCtl)
        {
            //Validate the itemNo
            var ItemFound;
            
            if (itemCtl == "txtParent")
            {
                ItemFound = ItemMaint.CheckParent(document.getElementById(itemCtl).value).value;
            }
            else
            {
                ItemFound = ItemMaint.CheckItem(document.getElementById(itemCtl).value).value;
            }

            if (ItemFound == "error")
            {
                //Stored Procedure error
                document.getElementById("hidInsConf").value = "ERROR";
                document.getElementById("hidMaintMode").value = "ERROR";
                return;
            }

            switch (itemCtl)
            {
                case "txtSourceItem":   //INSERT or EDIT
                    document.getElementById("txtCatParam").value = "";
                    document.getElementById("txtSizeParam").value = "";
                    document.getElementById("txtVarParam").value = "";
                    switch (ItemFound)
                    {
                        case "false":
                            if (document.getElementById("hidSecurity").value == "1")
                            {
                                alert("Item does not exist.");
                                document.getElementById("hidInsConf").value = "FALSE";
                                document.getElementById("hidMaintMode").value = "CLEAR";
                            }
                            else
                            {
                                //Item not on file - prompt to add new record
                                if (confirm("Item does not exist. Create new record?") == true)
                                {
                                    document.getElementById("hidInsConf").value = "TRUE";
                                    document.getElementById("hidMaintMode").value = "INS";
                                }
                                else
                                {
                                    document.getElementById("hidInsConf").value = "FALSE";
                                    document.getElementById("hidMaintMode").value = "CLEAR";
                                }
                            }
                        break;
                        case "nocat":
                            //Category does not exist
                            alert("Category does not exist");
                            document.getElementById("hidInsConf").value = "FALSE";
                            document.getElementById("hidMaintMode").value = "CLEAR";
                        break;
                        default:
                            //Item Found - EDIT mode
                            document.getElementById("hidInsConf").value = "";
                            document.getElementById("hidMaintMode").value = "EDIT";
                        break;
                    }
                break;
                case "txtDestItem":     //COPY
                    switch (ItemFound)
                    {
                        case "true":
                            //Item is on file - COPY mode false
                            alert("Item already exists");
                            document.getElementById("hidInsConf").value = "DUPREC";
                            document.getElementById("hidMaintMode").value = "COPY";
                        break;
                        case "nocat":
                            //Category does not exist
                            alert("Category does not exist");
                            document.getElementById("hidInsConf").value = "NOCAT";
                            document.getElementById("hidMaintMode").value = "COPY";
                        break;
                        default:
                            //Item not on file - COPY mode true
                            document.getElementById("hidInsConf").value = "TRUE";
                            document.getElementById("hidMaintMode").value = "COPY";
                        break;
                    }
                break;
                case "txtParent":     //exists?
                    switch (ItemFound)
                    {
                        case "true":
                            //Parent exists
                            //alert("Parent Item VALID");
                            document.getElementById("hidInsConf").value = "PARENT";
                        break;
                        default:
                            //Parent does not exist
                            alert("Parent Item does not exist");
                            document.getElementById("hidInsConf").value = "NOPARENT";
                        break;
                    }
                break;
                default:
                    document.getElementById("hidInsConf").value = "";
                    document.getElementById("hidMaintMode").value = "";
                    return;
                break;
            }

            document.frmMain.btnHidSubmitSource.click();     //fires btnHidSubmitSource_Click
        }
    //END CheckItem
    </script>

    <script language="javascript" type="text/javascript">
        var ListWindow;

        function Cancel()
        {
            var _unload = false;

            if (document.getElementById("hidSecurity").value == "1")
                document.getElementById("hidMaintMode").value = "";
            
            switch(document.getElementById("hidMaintMode").value)
            {
                case "":
                    _unload = true;
                break;
                case "DEL":
                    _unload = true;
                break;
                default:
                    _unload = confirm("Any unsaved changes to this item will be lost");
                break;
            }
        
            if (_unload == true)
            {
                Unload();
                //document.frmMain.btnHidClearSession.click();
            }
        }

        function Close()
        {
            var _unload = false;
        
            switch(document.getElementById("hidMaintMode").value)
            {
                case "":
                    _unload = true;
                break;
                case "DEL":
                    _unload = true;
                break;
                default:
                    _unload = confirm("Any unsaved changes to this item will be lost");
                break;
            }
            
            if (_unload == true)
            {
                Unload();
                //TMD: When I do the parent.close() here, there is no time for the btnHidClearSession.click() to completely process before the window closes. 
                //parent.close();
            }
        }

        function Unload()
        {
            //TMD: Make sure to call from <body> tag also
            //unlock records & clear session variables
            //check for uncommitted new item insert [InsTemp]
            // - We should just clear the whole screen/session and start fresh

//alert("unload");
            
            document.frmMain.btnHidClearSession.click();
            //ItemMaint.ClearSession().value;
            if (ListWindow != null)
            {
                ListWindow.close();
                ListWindow=null;
            }
        }

        function GetList()
        {
            if (ListWindow != null)
            {
                ListWindow.close();
                ListWindow=null;
            }
            ListWindow = OpenAtPos('SSItems', 'http://localhost/SOE/SSItemList.aspx?Cat='+$get("txtCatParam").value+'&Size='+$get("txtSizeParam").value+'&Var='+$get("txtVarParam").value+'&Parent=ItemMaint', 'toolbar=0,scrollbars=0,status=0,resizable=YES', 0, 0, 700, 800);    
            return false;
        }

        function CustLookup(_custNo)
        {   
            var url = "http://localhost/SOE/CustomerList.aspx?ctrlName=ItemMaint&Customer=" + _custNo;
            window.open(url,'CustomerList' ,'height=485,width=855,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (855/2))+',resizable=NO,scrollbars=YES','');
        }
    </script>
</head>
<body>
    <form id="frmMain" runat="server">
        <asp:ScriptManager runat="server" ID="smItemMaint">
        </asp:ScriptManager>
        <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse;">
            <tr>
                <td style="height: 5%;">
                    <%--Header Control--%>
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <%--BEGIN MAIN--%>
                    <table id="tblMain" style="width: 100%; height: 600px;" class="blueBorder" cellpadding="0" cellspacing="0">
                        <tr style="vertical-align: top;">
                            <td>
                                <asp:UpdatePanel ID="pnlPrompt" UpdateMode="conditional" runat="server">
                                    <ContentTemplate>
                                        <%--Prompt & Button Bar--%>
                                        <table id="tblPrompt" border="0" cellpadding="0" cellspacing="0" style="width: 100%; height:40px;" class="lightBlueBg">
                                            <tr>
                                                <td class="TabHead" style="width: 92px; padding-left: 10px">
                                                    <asp:Label ID="lblSourceItem" runat="server" CssClass="LabelCtrl2" Text="Item No" />
                                                </td>
                                                <td style="width: 100px;">
                                                    <asp:TextBox ID="txtSourceItem" runat="server" MaxLength="14" CssClass="FormCtrl2" Width="85px" Text="77777-7777-777"
                                                        TabIndex="1" onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==9 || event.keyCode==13){return ZItem(this.value, this.id);}" />
                                                </td>
                                                <td>
                                                    <table id="tblDestItem" runat="server" visible="false">
                                                        <tr>
                                                            <td class="TabHead" align="right" style="width: 110px;">
                                                                <asp:Label ID="lblDestItem" runat="server" CssClass="LabelCtrl2" Text="To Item No" />
                                                            </td>
                                                            <td align="right" style="width: 100px;">
                                                                <asp:TextBox ID="txtDestItem" runat="server" MaxLength="14" CssClass="FormCtrl2" Width="85px" Text="88888-8888-888"
                                                                    onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==9 || event.keyCode==13){return ZItem(this.value, this.id);}" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table id="tblListParam" runat="server">
                                                        <tr>
                                                            <td align="right" style="width: 175px;">
                                                                    <asp:TextBox ID="txtCatParam" runat="server" MaxLength="5" CssClass="FormCtrl2" Width="30px" Text="88888"
                                                                        onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==9 || event.keyCode==13){return ZCat(this.value, this.id);}" />
                                                                    &nbsp;-&nbsp
                                                                    <asp:TextBox ID="txtSizeParam" runat="server" MaxLength="4" CssClass="FormCtrl2" Width="25px" Text="8888"
                                                                        onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==9 || event.keyCode==13){return ZSize(this.value, this.id);}" />
                                                                    &nbsp;-&nbsp
                                                                    <asp:TextBox ID="txtVarParam" runat="server" MaxLength="3" CssClass="FormCtrl2" Width="20px" Text="888"
                                                                        onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==9 || event.keyCode==13){return ZVar(this.value, this.id);}" />
                                                            </td>
                                                            <td align="right" style="width: 75px;">
                                                                <img id="btnList" alt="Item List" src="../Common/images/GetList.gif" onclick="javascript:GetList();" style="cursor: hand" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td align="right" style="padding-right: 10px;">
                                                    <img id="btnHelp" alt="Help" src="../Common/images/help.gif" onclick="javascript:LoadHelp();" style="cursor: hand" />&nbsp;
                                                    <img id="btnClose" alt="Close" src="../Common/images/Close.gif" onclick="javascript:Close();" style="cursor: hand" />
                                                </td>

                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>

                                <asp:UpdatePanel ID="pnlBody" UpdateMode="conditional" runat="server" Visible="true">
                                    <ContentTemplate>
                                        <%--BEGIN BODY [width: 980px] --%>
                                        <table cellpadding="0" border="0" cellspacing="0">
                                            <col style="width:95px;" />
                                            <col style="width:135px;" />
                                            <col style="width:125px;" />
                                            <col style="width:125px;" />
                                            <col style="width:125px;" />
                                            <col style="width:125px;" />
                                            <col style="width:125px;" />
                                            <col style="width:125px;" />

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-top: 10px; padding-left: 10px; height:25px;">
                                                    Category No
                                                </td>
                                                <td style="padding-top: 10px;">
                                                    <asp:TextBox ID="txtCat" runat="server" MaxLength="5" CssClass="FormCtrl2" Width="33px" Text="88888" Enabled="false" />
                                                </td>
                                                <td class="TabHead" style="padding-top: 10px; padding-left: 10px;">
                                                    Corp Fixed Velocity
                                                </td>
                                                <td style="padding-top: 10px;">
                                                    <asp:DropDownList ID="ddlCFV" CssClass="FormCtrl2" Width="105px" Height="20px" runat="server" />
                                                </td>
                                                <td colspan="4" rowspan="2" align="center">
                                                    <table width="450px">
                                                        <tr class="LightBluBg" style="height: 40px;">
                                                            <td align="left" valign="middle" class="DarkBluTxt" style="padding-left: 10px;">
                                                                Item Details
                                                                &nbsp;&nbsp;&nbsp;
                                                                <asp:DropDownList ID="ddlDetails" CssClass="FormCtrl2" Width="155px" Height="20px" runat="server" Enabled="false" />
                                                            </td>
                                                            <td align="right" style="padding-top: 2px; padding-right: 10px;">
                                                                <asp:ImageButton ID="btnSaveDetails" Visible="false" runat="server" ImageUrl="../Common/images/btnSave.gif" CausesValidation="false" />&nbsp;
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Size No
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtSize" runat="server" MaxLength="4" CssClass="FormCtrl2" Width="25px" Text="8888" Enabled="false" />
                                                </td>

                                                <td class="TabHead" style="padding-left: 10px;">
                                                    PPI Code
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlPPICd" CssClass="FormCtrl2" Width="105px" Height="20px" runat="server" />
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Variance No
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtVar" runat="server" MaxLength="3" CssClass="FormCtrl2" Width="20px" Text="888" Enabled="false" />
                                                </td>
                                                <td class="TabHead" style="padding-left: 10px;">
                                                    Harmonizing Cd
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlHarmTaxCd" CssClass="FormCtrl2" Width="105px" Height="20px" runat="server" />
                                                </td>
                                                <td colspan="4" rowspan="15" align="center" valign="top">
                                                    <asp:UpdatePanel ID="pnlItemDetails" UpdateMode="conditional" runat="server">
                                                        <ContentTemplate>
                                                            <%-- BEGIN: ItemUM table data --%>
                                                            <table id="tblItemUOM" runat="server" cellpadding="0" border="0" cellspacing="0" visible="false">
                                                                <tr>
                                                                    <td align="center">
                                                                        <div id="divUOMGrid" runat="server" style="overflow: auto; position: relative; top: 0px; left: 0px; height: 285px; width: 400px; border: 1px solid #88D2E9; border-bottom-width: 0px;">
                                                                            <br />
                                                                            <asp:GridView ID="gvItemUOM" runat="server" PageSize="10" ShowFooter="false" AutoGenerateColumns="false"
                                                                                BorderWidth="1px" BorderColor="#DAEEEF" UseAccessibleHeader="false" PagerSettings-Visible="false" AllowPaging="false" Visible="false" OnRowDataBound="gvItemUOM_RowDataBound" OnRowDeleting="gvItemUOM_RowDeleting">
                                                                                <HeaderStyle CssClass="GridHead" Wrap="true" BackColor="#ECF9FB" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Center" />
                                                                                <RowStyle CssClass="GridItem" BackColor="White" BorderColor="White" Height="20px" HorizontalAlign="Right" />
                                                                                <AlternatingRowStyle CssClass="GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Right" />
                                                                                <EmptyDataRowStyle CssClass="GridHead" BackColor="#DFF3F9" BorderWidth="0" Height="20px" HorizontalAlign="Right" />
                                                                                <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px" HorizontalAlign="Right" />
                                                                                <Columns>
                                                                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                                                                        <ItemTemplate>
                                                                                            <asp:LinkButton ID="lnkDelete" Font-Underline="true" ForeColor="#cc0000" CausesValidation="false" Width="25px"
                                                                                                OnClientClick="javascript:if(confirm('Are you sure you want to delete this UOM?')==true){document.getElementById('hidDelUOM').value = 'true';} else {document.getElementById('hidDelUOM').value = 'false';}"
                                                                                                CommandName="Delete" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.UOM")%>' runat="server" Text="Del"></asp:LinkButton>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateField>
                                                                                    <asp:BoundField HeaderText="UOM" DataField="UOM" HtmlEncode="false" ItemStyle-HorizontalAlign="center" ItemStyle-Width="40px" />
                                                                                    <asp:BoundField HeaderText="Alt Qty" DataField="AltQty" HtmlEncode="false" ItemStyle-Width="85px" DataFormatString="{0:0.0#####}" />
                                                                                    <asp:BoundField HeaderText="Qty Per" DataField="QtyPer" HtmlEncode="false" ItemStyle-Width="85px" DataFormatString="{0:0.0#####}" />
                                                                                    <asp:BoundField HeaderText="fID" DataField="ItemID" HtmlEncode="false" HeaderStyle-BackColor="Orange" ItemStyle-CssClass="LeftPadding" Visible="true" />
                                                                                    <asp:BoundField HeaderText="Div" DataField="UOMDivisor" HtmlEncode="false" HeaderStyle-BackColor="Orange" Visible="true" />
                                                                                    <asp:BoundField HeaderText="Sts" DataField="UpdStatus" HtmlEncode="false" HeaderStyle-BackColor="Orange" Visible="true" />
                                                                                </Columns>
                                                                            </asp:GridView>
                                                                        </div>
                                                                        <div id="divUOMEdit" runat="server" style="overflow: auto; position: relative; top: 0px; left: 0px; height: 60px; width: 400px; border: 1px solid #88D2E9; border-top-width: 0px;">
                                                                            <table id="tblUOMEdit" runat="server" visible="false" cellpadding="0" border="0" cellspacing="0">
                                                                                 <tr>
                                                                                    <td>
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td align="right" class="TabHead"  style="width:125px;">
                                                                                        Base Qty&nbsp;&nbsp;&nbsp;
                                                                                    </td>
                                                                                    <td align="right" class="TabHead"  style="width:125px;">
                                                                                        Qty Per&nbsp;&nbsp;&nbsp;
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td align="center" style="width:50px; height:25px;">
                                                                                        <asp:Label ID="lblItemUOM" runat="server" CssClass="LabelCtrl2" Text="UOM" />
                                                                                    </td>
                                                                                    <td align="right" style="width:125px; height:25px;">
                                                                                        <asp:TextBox ID="txtDtlBaseQty" runat="server" MaxLength="16" CssClass="FormCtrl2 txtRight" Width="100px" Text="1 234 567 123456"
                                                                                            AutoPostBack="true" onfocus="javascript:this.select();" OnTextChanged="txtDtlBaseQty_TextChanged" onkeypress="javascript:ValidateNum();" />
                                                                                    </td>
                                                                                    <td align="right" style="width:125px; height:25px;">
                                                                                        <asp:Label ID="lblUOMQtyPer" runat="server" CssClass="LabelCtrl2 txtRight" Width="100px" Text="1 234 567 123456" />
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <%-- END: ItemUM table data --%>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>

                                                    <%-- ItemDetails Status Line --%>
                                                    <div id="divDtlStatus" runat="server" visible="false"
                                                         style="overflow: auto; position: relative; top: 0px; left: 0px; width: 400px; height: 15px;
                                                         background-color: #ECF9FB; border: 1px solid #88D2E9; border-top-width: 0px;">
                                                        <asp:UpdatePanel ID="pnlDtlStatus" runat="server" UpdateMode="conditional">
                                                            <ContentTemplate>
                                                                <asp:Label ID="lblDtlStatus" Style="padding-left: 5px;" CssClass="LabelCtrl2" ForeColor="#b0c4de" Font-Italic="true" runat="server" Text="~~ Detail Status Line ~~" />
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </div>
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Item No
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblItemNo" ToolTip="test tip" runat="server" CssClass="LabelCtrl2" Width="100px" Text="88888-8888-888" />
                                                </td>
                                                <td>
                                                    <table>
                                                        <tr>
                                                            <td class="TabHead" style="padding-left: 10px; width: 85px;">
                                                                Web Enabled
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkWebEnabled" runat="server" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td>
                                                    <table>
                                                        <tr>
                                                            <td class="TabHead" style="padding-left: 10px; width: 85px;">
                                                                FQA Item
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkFQA" runat="server" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Length
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtLength" runat="server" MaxLength="15" CssClass="FormCtrl2" Width="100px"
                                                        onfocus="javascript:this.select();" Text="Length Descript" />
                                                </td>
                                                <td>
                                                    <table>
                                                        <tr>
                                                            <td class="TabHead" style="padding-left: 10px; width: 85px;">
                                                                Cert Item
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkCert" runat="server" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td>
                                                    <table>
                                                        <tr>
                                                            <td class="TabHead" style="padding-left: 10px; width: 85px;">
                                                                Pallet Partner
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkPtPartner" runat="server" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Diameter
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtDiameter" runat="server" MaxLength="15" CssClass="FormCtrl2" Width="100px"
                                                        onfocus="javascript:this.select();" Text="Diameter Descrp" />
                                                </td>
                                                <td>
                                                    <table>
                                                        <tr>
                                                            <td class="TabHead" style="padding-left: 10px; width: 85px;">
                                                                Haz Mat
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkHazMat" runat="server" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Cat Desc
                                                </td>
                                                <td colspan="2">
                                                    <asp:TextBox ID="txtCatDesc" runat="server" MaxLength="50" CssClass="FormCtrl2" Width="250px"
                                                        onfocus="javascript:this.select();" Text="Allow 50 & truncate to build ItemDesc field ***~~/" />
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Size Desc
                                                </td>
                                                <td colspan="2">
                                                    <asp:TextBox ID="txtSizeDesc" runat="server" MaxLength="20" CssClass="FormCtrl2" Width="250px"
                                                        onfocus="javascript:this.select();" Text="[20 chars] Size Desc" />
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Plating
                                                </td>
                                                <td colspan="2">
                                                    <table>
                                                        <tr>
                                                            <td align="left">
                                                                <asp:DropDownList ID="ddlPlating" CssClass="FormCtrl2" Height="20px" Width="175px" runat="server" />
                                                            </td>
                                                            <td style="padding-left:16px;">
                                                                <asp:ImageButton ID="btnBuildDesc" runat="server" CausesValidation="false" OnClick="btnBuildDesc_Click" CssClass="middle" Visible="true" ImageUrl="../Common/images/btnBuild.gif" Height="20px" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Item Desc
                                                </td>
                                                <td colspan="2">
                                                    <asp:TextBox ID="txtItemDesc" runat="server" MaxLength="50" CssClass="FormCtrl2" Width="250px"
                                                        onfocus="javascript:this.select();" Text="## [20] Size Desc ##*** [26] Category Desc ***04PL" />
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    UPC Code
                                                </td>
                                                <td colspan="2" valign="middle">
                                                    <asp:Label ID="lblUPCCd" ToolTip="Use buttons to generate new UPC Codes" runat="server" CssClass="LabelCtrl2" Width="85px" Text="082893143040" />
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    <asp:ImageButton ID="btnPkgUPC" runat="server" CausesValidation="false" CssClass="middle" Visible="false" ImageUrl="../Common/images/btnPkgUPC.gif" Height="20px" OnClick="btnPkgUPC_Click" />
                                                    &nbsp;
                                                    <asp:ImageButton ID="btnBulkUPC" runat="server" CausesValidation="false" CssClass="middle" Visible="false" ImageUrl="../Common/images/btnBulkUPC.gif" Height="20px" OnClick="btnBulkUPC_Click" />
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>
                                    
                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Alt Desc
                                                </td>
                                                <td colspan="2">
                                                    <asp:TextBox ID="txtAltDesc" runat="server" MaxLength="40" CssClass="FormCtrl2" Width="250px"
                                                        onfocus="javascript:this.select();" Text="[40 chars] ***** Alt Cat Desc 01 ******/" />
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Alt Desc 2
                                                </td>
                                                <td colspan="2">
                                                    <asp:TextBox ID="txtAltDesc2" runat="server" MaxLength="40" CssClass="FormCtrl2" Width="250px"
                                                        onfocus="javascript:this.select();" Text="[40 chars] ***** Alt Cat Desc 02 ******/" />
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Alt Desc 3
                                                </td>
                                                <td colspan="2">
                                                    <asp:TextBox ID="txtAltDesc3" runat="server" MaxLength="40" CssClass="FormCtrl2" Width="250px"
                                                        onfocus="javascript:this.select();" Text="[40 chars] ***** Alt Cat Desc 03 ******/" />
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Alt Size Desc
                                                </td>
                                                <td colspan="2">
                                                    <asp:TextBox ID="txtAltSize" runat="server" MaxLength="40" CssClass="FormCtrl2" Width="250px"
                                                        onfocus="javascript:this.select();" Text="[40 chars] ****** Alt Size Desc *******/" />
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Customer No
                                                    <%--<asp:LinkButton ID="lnkCustNo" CssClass="TabHead" OnClientClick="javascript:return OpenOrganisationComments(this);"
                                                        runat="server" Text="Customer No" />--%>
                                                </td>
                                                <td colspan="2">
                                                    <asp:TextBox ID="txtCustNo" runat="server" MaxLength="6" CssClass="FormCtrl2" Width="85px" Text="CustNo"
                                                        AutoPostBack="true" onfocus="javascript:this.select();" OnTextChanged="txtCustNo_TextChanged" />
                                                    <%--<asp:Button ID="btnHidLoadCust" runat="server" Style="display: none" />--%>
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td colspan="4" class="TabHead" style="padding-left: 10px; height:25px;">
                                                    &nbsp;
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Routing No
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtRoutingNo" runat="server" MaxLength="10" CssClass="FormCtrl2" Width="85px"
                                                        onfocus="javascript:this.select();" OnTextChanged="txtRoutingNo_TextChanged" Text="8888888888" />
                                                </td>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    List Price
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtListPrice" runat="server" CssClass="FormCtrl2 txtRight" Width="100px" Text="$9,999,999,999.00" AutoPostBack="true"
                                                        onfocus="javascript:this.select();" onkeypress="javascript:ValidateNum();" onchange="javascript:FormatDollar(this.value,this.id);" />
                                                </td>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    PC / LB / FT
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlPCLBFT" CssClass="FormCtrl2" Width="105px" Height="20px" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlPCLBFT_SelectedIndexChanged" />
                                                </td>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Sell UOM
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlSellUOM" CssClass="FormCtrl2" Width="105px" Height="20px" runat="server" />
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Parent Item
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtParent" runat="server" MaxLength="14" CssClass="FormCtrl2" Width="85px" Text="55555-5555-555"
                                                        onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==9 || event.keyCode==13){return ZItem(this.value, this.id);}" />
                                                </td>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Wght / 100 Pcs
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txt100Wgt" runat="server" CssClass="FormCtrl2 txtRight" Width="100px" Text="9,999,999,999.555" AutoPostBack="true"
                                                        onfocus="javascript:this.select();" onkeypress="javascript:ValidateNum();" OnTextChanged="txt100Wgt_TextChanged" />
                                                </td>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Base UOM
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlBaseUOM" CssClass="FormCtrl2" Width="105px" Height="20px" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlBaseUOM_SelectedIndexChanged" />
                                                </td>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Purch UOM
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlPurchUOM" CssClass="FormCtrl2" Width="105px" Height="20px" runat="server" />
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    BOM Exists
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblBOMInd" runat="server" CssClass="LabelCtrl2" Width="25px" Text="Yes" />
                                                </td>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Net Wght
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtNetWght" runat="server" CssClass="FormCtrl2 txtRight" Width="100px" Text="9,999,999,999.555" AutoPostBack="true"
                                                        onfocus="javascript:this.select();" onkeypress="javascript:ValidateNum();" OnTextChanged="txtNetWght_TextChanged" />
                                                </td>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Base UOM Qty
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblBaseUOMQty" runat="server" CssClass="LabelCtrl2 txtRight" Width="100px" Text="9,999,999" />
                                                </td>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Super UOM
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlSuperUOM" CssClass="FormCtrl2" Width="105px" Height="20px" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSuperUOM_SelectedIndexChanged" />
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <tr>
                                                <td colspan="2" class="TabHead" style="padding-left: 10px; height:25px;">
                                                    &nbsp;
                                                </td>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Gross Wght
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblGrossWght" runat="server" CssClass="LabelCtrl2 txtRight" Width="100px" Text="9,999,999,999.555" />
                                                </td>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Pieces / PT
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblPcsPerPT" runat="server" CssClass="LabelCtrl2 txtRight" Width="100px" Text="9,999,999" />
                                                </td>
                                                <td class="TabHead" style="padding-left: 10px; height:25px;">
                                                    Super UOM Qty
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtSuperUOMQty" runat="server" CssClass="FormCtrl2 txtRight" Width="100px" Text="9,999,999"
                                                        AutoPostBack="true" onfocus="javascript:this.select();" OnTextChanged="txtSuperUOMQty_TextChanged" onkeypress="javascript:ValidateNum();" />
                                                </td>
                                            </tr>

                                    <%-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

                                            <%--Hidden Fields--%>
                                            <asp:HiddenField ID="hidSecurity" runat="server" />
                                            <asp:HiddenField ID="hidMaintMode" runat="server" Value="" />
                                            <asp:HiddenField ID="hidScreenMode" runat="server" />
                                            <asp:HiddenField ID="hidItemID" runat="server" />
                                            <asp:HiddenField ID="hidItemNo" runat="server" />
                                            <asp:HiddenField ID="hidCatNo" runat="server" />
                                            <asp:HiddenField ID="hidCatDesc" runat="server" />
                                            <asp:HiddenField ID="hidUPCID" runat="server" />
                                            <asp:HiddenField ID="hidUPCCd" runat="server" />
                                            <asp:HiddenField ID="hidBaseQtyPer" Value="1" runat="server" />
                                            <asp:HiddenField ID="hidPieceQty" Value="1" runat="server" />
                                            <asp:HiddenField ID="hidDelItem" runat="server" />
                                            <asp:HiddenField ID="hidDelUOM" runat="server" />
                                            <asp:HiddenField ID="hidInsConf" runat="server" />
                                            <asp:HiddenField ID="hidStsMsg" runat="server" />
                                            
                                            <asp:HiddenField ID="hidLockStatus" runat="server" />
                                            <asp:HiddenField ID="hidLockUser" runat="server" />

                                        </table>
                                        <%--END BODY--%>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <%--Work Fields--%>
                            <td id="tdWrkFld" runat="server" style="height:20px;" visible="true">
                                <asp:UpdatePanel ID="pnlWrkFld" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div id="divWrkFld" runat="server" style="height:20px; background-color:orange;">
                                            <table cellpadding="0" border="0" cellspacing="0">
                                                <col style="width:95px;" />
                                                <col style="width:135px;" />
                                                <col style="width:125px;" />
                                                <col style="width:125px;" />
                                                <col style="width:125px;" />
                                                <col style="width:125px;" />
                                                <col style="width:125px;" />
                                                <col style="width:125px;" />
                                                <tr>
                                                    <td style="padding-left: 10px;" align="left">
                                                        <asp:Label ID="lblUserInfo" runat="server" Text="~user info~" />
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                    <td style="padding-left: 10px;" align="left">
                                                        Density Factor
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblDensity" runat="server" CssClass="txtRight" Width="100px" Text="nnn.nnnnnn" />
                                                    </td>
                                                    <td style="padding-left: 10px;" align="left">
                                                        PC Qty
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblPCQty" runat="server" CssClass="txtRight" Width="100px" Text="n,nnn,nnn" />
                                                    </td>
                                                    <td colspan="2" style="padding-left: 10px;">
                                                        <asp:Label ID="lblLockInfo" runat="server" Text="~lock info~" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <%--End Work Fields--%>
                        </tr>
                    </table>

                    <%--Hidden Buttons--%>
                    <asp:Button ID="btnHidSubmitSource" runat="server" Style="display: none;" CausesValidation="false" OnClick="btnHidSubmitSource_Click" />
                    <asp:Button ID="btnHidClearSession" runat="server" Style="display: none;" CausesValidation="false" OnClick="btnHidClearSession_Click" />

                    <%--END MAIN--%>
                </td>
            </tr>
            <tr>
                <%--Status Bar--%>
                <td class="lightBlueBg" style="height:20px;">
                    <table>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlStatus" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblStatus" Style="padding-left: 5px" CssClass="LabelCtrl2" ForeColor="#b0c4de" Font-Italic="true" runat="server" Text="~~ Status Line ~~" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdateProgress ID="pnlProgress" runat="server" DynamicLayout="false">
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
                <%--Buttons--%>
                <td class="LightBluBg" align="right" valign="middle" style="height: 30px; padding-top: 2px; padding-right: 10px;">
                    <asp:UpdatePanel ID="pnlButtons" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <asp:ImageButton ID="btnSave" Visible="false" runat="server" ImageUrl="../Common/images/btnSave.gif" CausesValidation="false" OnClick="btnSave_Click" />&nbsp;
                            <asp:ImageButton ID="btnCopy" Visible="false" runat="server" ImageUrl="../Common/images/btnCopy.gif" CausesValidation="false" OnClick="btnCopy_Click" />&nbsp;
                            <asp:ImageButton ID="btnDelete" Visible="false" runat="server" ImageUrl="../Common/images/btnDelete.gif" CausesValidation="false" OnClick="btnDelete_Click"
                                OnClientClick="javascript:if(confirm('Are you sure you want to delete this Item?')==true){document.getElementById('hidDelItem').value = 'true';} else {document.getElementById('hidDelItem').value = 'false';}" />&nbsp;
                            <asp:ImageButton ID="btnCancel" Visible="false" runat="server" ImageUrl="../Common/images/cancel.gif" CausesValidation="false" OnClientClick="javascript:Cancel();" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <%--Footer Control--%>
                <td>
                    <uc2:Footer ID="Footer1" FooterTitle="Item Master Maintenance" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
<script type="text/javascript">
    ShowHide("Hide");
</script>
</html>

