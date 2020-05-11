<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WebCatDiscMaint.aspx.cs" Inherits="WebCatDiscMaint" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<%@ Register Src="~/MaintenanceApps/Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc4" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title>Web Category Discount Maintenance</title>
    <link href="Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <script src="Common/Javascript/Common.js" type="text/javascript"></script>    

    <style type="text/css">
        .myFormCtrl
        {
	        font-family: Arial, Helvetica, sans-serif;	
	        font-size: 11px;	
	        font-weight: normal;	
	        color: #000000;	
	    }
	    
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
    </style>

    <script>

        function OpenDatePicker1(controlID)
        {
            //
            // Get the Site Url from Codebehind function
            //
            var PageName = <%=GetSiteURL() %>;
            var url = PageName  + '?txtID='+controlID;
            var hWnd=window.open(url, 'DatePicker', 'width=320,height=157,top='+((screen.height/2) - (310/2))+' ,left='+((screen.width/2) - (310/2))+'');
            
            hWnd.opener = self;	
	        if (window.focus) {hWnd.focus()}
            return false;
        }

        function LoadHelp()
        {
            window.open('WebCatDiscMaintHelp.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
        }

        function Close(session)
        {
            WebCatDiscMaint.DeleteExcel('WebCatDiscMaint'+session).value;
            window.close();
        }
        
        function Unload()
        {
            WebCatDiscMaint.ReleaseLock().value;
        }
       
       function EditConf(CVC, DiscPct, StartDt, StartDtTxt, EndDt, EndDtTxt, Lock)
       {
            if (CVC == "All")
            {
                alert ('All records already on file.')
//                document.getElementById('ddlItemCVC').selectedIndex = 0;
            }
            else
                if(confirm('Already on file.  Do you want to edit the existing record?')) 
                    if (Lock == 'None')
                    {
                        document.getElementById('hidEditMode').value = "Edit";
                        document.getElementById('txtCat').disabled = true;
                        document.getElementById('ddlItemCVC').disabled = true;
                        document.getElementById('txtDisc').value = DiscPct;
                        document.getElementById(StartDtTxt).value = StartDt;
                        document.getElementById(EndDtTxt).value = EndDt;
                    }
                    else
                    {
                        alert('Record Locked By ' + Lock);
                        document.getElementById('ContentTable').style.display = "none";
                        document.getElementById('btnSave').style.visibility = "hidden";
                        document.getElementById('btnCancel').style.visibility = "hidden"; 
                    }
//                else
//                    document.getElementById("ddlItemCVC").selectedIndex = 0;
       }
    </script>
</head>

<body onunload="javascript:Unload();">
    <form id="frmWebCatDisc" runat="server">
        <asp:ScriptManager runat="server" ID="smWebCatDisc">
        </asp:ScriptManager>
        <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse;" id="mainTable">
            <tr>
                <td height="5%" id="tdHeaders">
                    <uc1:Header ID="HeaderID" runat="server" />
                </td>
            </tr>
            <tr class="PageHead shadeBgDown">
                <td class="Left2pxPadd DarkBluTxt boldText blueBorder shadeBgDown">
                    <asp:UpdatePanel ID="pnlTop" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <table height="25" width="100%"style="padding-left: 0px;">
                                <tr id="trTop" runat="server">
                                    <td align="right" style="padding-right: 5px;" width="28%">
                                        <asp:ImageButton ID="btnAdd" Visible="false" runat="server" ImageUrl="common/Images/newAdd.gif"
                                            CausesValidation="false" OnClick="btnAdd_Click" />
                                        <asp:ImageButton ID="ExportRpt" runat="server" Style="cursor: hand" ImageUrl="common/images/ExporttoExcel.gif"
                                            CausesValidation="false" OnClick="ExportRpt_Click" />
                                        <img src="../Common/images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                                        <img id="imgClose" src="Common/images/close.jpg" style="cursor:hand" onclick="javascript:Close('<%=Session["SessionID"].ToString() %>');" />
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
                            <table id="ContentTable" width="100%" border="0" cellspacing="0" cellpadding="0" visible="false" runat="server">
                                <tr>
                                    <td class="lightBlueBg">
                                        <asp:Label ID="lblHeading" runat="server" Text="Web Category Discount Information" CssClass="BanText"
                                            Width="300px"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td style="border-right: solid 1px #c9c6c6; padding-bottom: 5px;">
                                        <asp:Panel ID="pnlWebCatDsc" runat="server">
                                            <table>
                                                <tr><td colspan="4"><br /></td></tr>
                                                <tr>
                                                    <td width="25"></td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" width="100">Category</td>
                                                    <td class="Left2pxPadd">
                                                        <asp:TextBox CssClass="FormCtrl" style="text-align:right" runat="server" ID="txtCat" MaxLength="5" Width="50px"
                                                                OnFocus="javascript:this.select();" OnTextChanged="txtCat_TextChanged" AutoPostBack="True"></asp:TextBox>
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                        <asp:Label ID="lblCatDesc" runat="server"></asp:Label>
                                                    </td>
<%--                                                    <td class="Left2pxPadd">
                                                        <asp:Label ID="lblCatDesc" runat="server" Text="AAAAAAAAAABBBBBBBBBBCCCCCCCCCCDDDDDDDDDDEEEEEEEEEEFFFFFFFFFFGGGGGGGGGGHHHHHHHHHH"></asp:Label>
                                                    </td>--%>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">Item CVC</td>
                                                    <td class="Left2pxPadd">
                                                        <asp:DropDownList ID="ddlItemCVC" runat="server" CssClass="myFormCtrl" AutoPostBack="True"
                                                                OnSelectedIndexChanged="ddlItemCVC_SelectedIndexChanged"></asp:DropDownList>
                                                    </td>
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">Discount</td>
                                                    <td class="Left2pxPadd">
                                                        <asp:TextBox CssClass="FormCtrl" style="text-align:right" runat="server" ID="txtDisc" MaxLength="5" Width="50px"
                                                                OnFocus="javascript:this.select();" OnTextChanged="txtDisc_TextChanged" AutoPostBack="True"></asp:TextBox>
                                                        &nbsp%
                                                    </td>
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">Effective Start</td>
                                                    <td class="Left2pxPadd">
                                                        <uc3:novapopupdatepicker ID="dtEffectiveStart" runat="server" OnFocus="javascript:this.select();" />
                                                    </td>
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">Effective End</td>
                                                    <td class="Left2pxPadd">
                                                        <uc3:novapopupdatepicker ID="dtEffectiveEnd" runat="server" OnFocus="javascript:this.select();" />
                                                    </td>
                                                    <td></td>
                                                </tr>
                                                <tr><td><br /></td></tr>
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
                <td>
                    <asp:UpdatePanel ID="pnlLink" UpdateMode="Conditional" runat="server">
                        <ContentTemplate>
                            <table cellpadding="0" cellspacing="0" width="100%">
                                <tr runat="server" id="tdHeader">
                                    <td class="lightBlueBg">
                                        <asp:Label ID="lblHeader" runat="server" Text="Web Category Discounts" CssClass="BanText"
                                            Width="300px"></asp:Label></td>
                                    <td style="width: 100%; height: 5px" align="right" class="lightBlueBg">
                                        <asp:UpdatePanel ID="pnlHeader" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <table  >
                                                    <tr>
                                                        <td style="height: 16px">
                                                            &nbsp;<asp:ImageButton ID="btnSave" Visible="false" CausesValidation="true" runat="server" ImageUrl="common/Images/BtnSave.gif" OnClick="btnSave_Click" />
                                                            <asp:ImageButton ID="btnCancel" Visible="false" runat="server" ImageUrl="common/Images/cancel.png" CausesValidation="false" OnClick="btnCancel_Click" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                                <tr height="30px">
                                    <td class="lightBlueBg Left2pxPadd DarkBluTxt boldText" colspan=2 valign="middle">
                                        <asp:CheckBox ID="chkDelRec" Text="Show Deleted Records" runat="server" OnCheckedChanged="chkDelRec_CheckedChanged" AutoPostBack="true" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <table cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td valign="top">
                                <asp:UpdatePanel ID="pnlCatGrid" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div runat="server" id="tdWebCatDisc" visible="true">
                                            <div id="divdatagrid" class="Sbar" align="left" runat="server" style="overflow: auto; width: 1020px; 
                                                position: relative; top: 0px; left: 0px; height: 492px; border: 0px solid; vertical-align: top;">
                                                <asp:DataGrid ID="dgWebCatDisc" Width="1055px" runat="server" GridLines="both" BorderWidth="1px" TabIndex="-1" 
                                                    ShowFooter="false" AllowSorting="true" AllowPaging="true" PageSize="18" CssClass="grid" Style="height: auto"
                                                    UseAccessibleHeader="true" AutoGenerateColumns="false" BorderColor="#DAEEEF" PagerStyle-Visible="false"
                                                    OnItemDataBound="dgWebCatDisc_ItemDataBound" OnSortCommand="dgWebCatDisc_SortCommand" OnItemCommand="dgWebCatDisc_ItemCommand">
                                                    <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                    <ItemStyle CssClass="GridItem" />
                                                    <AlternatingItemStyle CssClass="zebra" />
                                                    <FooterStyle CssClass="lightBlueBg" />
                                                    <Columns>
                                                        <asp:TemplateColumn ItemStyle-Width="80px" HeaderText="Actions" HeaderStyle-Width="80px"
                                                            ItemStyle-HorizontalAlign="center">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblNoAction" runat="server" Visible="false" Text="None" Font-Bold="true"></asp:Label>
                                                                <asp:LinkButton ID="lnkEdit" Font-Underline="true" CommandName="Edit" ForeColor="#006600"
                                                                    CausesValidation="false" Style="padding-left: 5px" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.pWebCategoryDiscId")%>'
                                                                    runat="server" Visible="false" Text="Edit"></asp:LinkButton>
                                                                <asp:LinkButton ID="lnkDelete" Font-Underline="true" ForeColor="#cc0000" CausesValidation="false"
                                                                    Style="padding-left: 5px" OnClientClick="javascript:if(confirm('Are you sure you want to delete?')==true){document.getElementById('hidDelConf').value = 'true';} else {document.getElementById('hidDelConf').value = 'false';}"
                                                                    CommandName="Delete" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.pWebCategoryDiscId")%>'
                                                                    runat="server" Visible="false" Text="Delete"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="75" ItemStyle-HorizontalAlign="Center" HeaderText="Category"
                                                            FooterStyle-HorizontalAlign="right" DataField="Category" SortExpression="Category"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="75" HeaderStyle-Wrap="false"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="75" ItemStyle-HorizontalAlign="Center" HeaderText="Item CVC"
                                                            FooterStyle-HorizontalAlign="right" DataField="ItemCVC" SortExpression="ItemCVC"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="75" HeaderStyle-Wrap="false"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="75" ItemStyle-HorizontalAlign="Right" HeaderText="Discount"
                                                            FooterStyle-HorizontalAlign="right" DataField="GridDiscPct" SortExpression="GridDiscPct"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="75" HeaderStyle-Wrap="false" DataFormatString="{0:0.00%}"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="Right" HeaderText="Effective Start"
                                                            FooterStyle-HorizontalAlign="right" DataField="EffectiveStartDt" SortExpression="EffectiveStartDt"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="100" HeaderStyle-Wrap="false" DataFormatString="{0:MM/dd/yyyy}"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="Right" HeaderText="Effective End"
                                                            FooterStyle-HorizontalAlign="right" DataField="EffectiveEndDt" SortExpression="EffectiveEndDt"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="100" HeaderStyle-Wrap="false" DataFormatString="{0:MM/dd/yyyy}"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="125" HeaderText="Entry ID" FooterStyle-HorizontalAlign="right"
                                                            DataField="EntryID" SortExpression="EntryID" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right"
                                                            ItemStyle-Width="125" HeaderStyle-Wrap="false"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Entry Date" FooterStyle-HorizontalAlign="right"
                                                            DataFormatString="{0:MM/dd/yyyy}" DataField="EntryDt" SortExpression="EntryDt"
                                                            ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="100"
                                                            HeaderStyle-Wrap="false"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="125" HeaderText="Change ID" FooterStyle-HorizontalAlign="right"
                                                            DataField="ChangeID" SortExpression="ChangeID" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right"
                                                            ItemStyle-Width="125" HeaderStyle-Wrap="false"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Change Date" FooterStyle-HorizontalAlign="right"
                                                            DataFormatString="{0:MM/dd/yyyy}" DataField="ChangeDt" SortExpression="ChangeDt"
                                                            ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="100"
                                                            HeaderStyle-Wrap="false"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="100" HeaderText="Delete Date" FooterStyle-HorizontalAlign="right"
                                                            DataFormatString="{0:MM/dd/yyyy}" DataField="DeleteDt" SortExpression="DeleteDt"
                                                            ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="100"
                                                            HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                            
                                                    </Columns>
                                                </asp:DataGrid>
                                                <%--   *****  Hidden Fields  *****   --%>
                                                    <input type="hidden" id="hidSort" runat="server" />
                                                    <asp:HiddenField ID="hidFocus" runat="server" Value="txtCat" />
                                                    <asp:HiddenField ID="hidSecurity" runat="server" />
                                                    <asp:HiddenField ID="hidEditMode" runat="server" />
                                                    <asp:HiddenField ID="hidRecID" runat="server" />
                                                    <asp:HiddenField ID="hidDelConf" runat="server" />
                                                    <asp:HiddenField ID="hidPageSize" runat="server" Value="18" />
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
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
                    <table width="100%" id="tPager" runat="server">
                        <tr>
                            <td>
                                <uc4:pager ID="Pager1" OnBubbleClick="Pager_PageChanged" runat="server" Visible="true" />
                            </td>
                        </tr>
                    </table>
    </ContentTemplate>
</asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:BottomFooter ID="BottomFooterID" Title="Web Category Discount Maintenance" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
