<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="CustomerContact.aspx.cs"
    Inherits="CustomerContact" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/PhoneNumber.ascx" TagName="PhoneNumber" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Contact</title>
    <link href="../CustomerContact/Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>

    <script language="javascript">
    function LoadHelp()
    {
        window.open("../Help/HelpFrame.aspx?Name=CustomerContact",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO',"");
    }
    function LoadReport()
    {
        window.open("../CustomerContactReport/CustomerContactReportPrompt.aspx?Name=CustomerContact",'Prompt','height=500,width=700,scrollbars=no,status=no,top='+((screen.height/2) - (350/2))+',left='+((screen.width/2) - (700/2))+',resizable=NO',"");
    } 
    function ShowSuggester(txtSearch)
    {            
        if(event.keyCode==13)
            document.getElementById("divSearch").style.display='none';
        else
        {
            var ddlCustomerSuggester= document.getElementById("lstCustomer");
            var vendDetails="";
            
            if(event.keyCode==40)
                if(document.getElementById("divSearch").style.display=="")
                    ddlCustomerSuggester.focus();
            
            vendDetails=CustomerContact.SuggestCustomer(txtSearch.value).value;
                
            var splitValue=vendDetails.split('`');
            ddlCustomerSuggester.options.length = 0;
                
            if(splitValue.length>0 && vendDetails!="" && txtSearch.value !="")
            {
                for(var i=0;i<splitValue.length-1;i++)
                {
                    var splitField=splitValue[i].toString().split('~');
                    ddlCustomerSuggester.options[ddlCustomerSuggester.options.length] =  new Option(splitField[0].toString(), splitField[1].toString());
                }
                document.getElementById("divSearch").style.display="";
            }
            else
                document.getElementById("divSearch").style.display='none';
        }
    }
        
    function SelectCustomer()
    {
            
        var ddlCustomerList=document.getElementById("lstCustomer");
        var txtSearch=document.getElementById("txtSearchCode");
            
        if(ddlCustomerList.selectedIndex != -1)
        {
            txtSearch.value=ddlCustomerList.options[ddlCustomerList.selectedIndex].text.split('-')[0];
            txtSearch.value=txtSearch.value.substring(0,txtSearch.value.length-1);
            document.getElementById('divSearch').style.display='none';
            document.getElementById("hidCustNumber").value=txtSearch.value;        
            txtSearch.focus();
        }
    }
    function LoadCustomerLookup(_custNo,_control)
    {   
        var Url = "CustomerList.aspx?ctrlName="+_control+"&Customer=" + _custNo;
        window.open(Url,'CustomerList' ,'height=485,width=855,scrollbars=no,status=no,top='+((screen.height/2) - (465/2))+',left='+((screen.width/2) - (855/2))+',resizable=NO,scrollbars=YES','');
    }
    </script>

</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';if(document.getElementById('divSearch')!=null)document.getElementById('divSearch').style.display = 'none';"
    onmouseup="javascript:if(divToolTips!=null)divToolTips.style.display='none';"
    onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server" defaultfocus="txtSearchCode" defaultbutton="btnSave">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr class="lightBlueBg" style="padding-top: 1px;">
                <td id="tdHeader" style="padding-top: 1px;">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="Left2pxPadd DarkBluTxt boldText" width="12%" style="padding-left: 10px;
                    vertical-align: top;">
                    <asp:UpdatePanel ID="upnlbtnSearch" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
                                <table>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblSch" runat="server" Text="Customer Search" Width="106px"></asp:Label></td>
                                        <td style="width: 100px">
                                            <asp:TextBox ID="txtSearchCode" CssClass="FormCtrl" OnFocus="javascript:this.select();"
                                                runat="server" AutoCompleteType="disabled" MaxLength="10" Width="250px" TabIndex="15"></asp:TextBox>                                            
                                        </td>
                                        <td style="width: 100px">
                                            <asp:ImageButton ID="btnSearch" runat="server" ImageUrl="~/MaintenanceApps/Common/images/BtnSearch.gif"
                                                OnClick="btnSearch_Click" CausesValidation="False" /><asp:HiddenField ID="hidPrimaryKey"
                                                    runat="server" />
                                            <asp:HiddenField ID="hidCustNumber" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="padding-top: 1px; height: 550px; vertical-align: top;">
                    <asp:UpdatePanel ID="pnlCustHeader" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table style="width: 100%; border-bottom: none;" class="blueBorder" cellpadding="0"
                                cellspacing="0">
                                <tr>
                                    <td class="lightBlueBg" style="width: 539px">
                                        <asp:Label ID="lblHeading" runat="server" Text="Customer" CssClass="BanText" Width="284px"></asp:Label></td>
                                    <td style="width: 100%; height: 5px" align="right" class="lightBlueBg">
                                        <asp:UpdatePanel ID="upnlAdd" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <img id="Img2" src="../Common/Images/report menu.gif" onclick="LoadReport();" style="cursor: hand"
                                                                tabindex="17" />
                                                        </td>
                                                        <td>
                                                            <img id="Img1" src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor: hand"
                                                                tabindex="17" />
                                                        </td>
                                                        <td style="height: 16px">
                                                            &nbsp;<img id="CloseButton" src="Common/images/close.jpg" onclick="javascript:window.close();"
                                                                tabindex="17" />&nbsp;
                                                        </td>
                                                    </tr>
                                                </table>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 100px; padding-top: 8px; border-bottom: 1px solid #88D2E9; border-collapse: collapse;"
                                        colspan="0" valign="top">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="cnt" style="height: 8px">
                                                    <asp:Label ID="label50" runat="server" Height="16px" Text="Name :" Width="70px"></asp:Label></td>
                                                <td colspan="3" style="height: 8px">
                                                    <asp:Label ID="lblCustName" runat="server" Height="16px" Width="200px"></asp:Label></td>
                                                <td style="height: 8px">
                                                </td>
                                                <td style="width: 75px; height: 8px">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="cnt" style="height: 25px">
                                                    <asp:Label ID="Label1" runat="server" Height="16px" Text="Address :" Width="70px"></asp:Label></td>
                                                <td colspan="3" style="height: 25px">
                                                    <asp:Label ID="lblAddress" runat="server" Height="16px" Width="200px"></asp:Label></td>
                                                <td style="height: 25px">
                                                </td>
                                                <td style="width: 75px; height: 25px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="cnt" style="height: 25px">
                                                    <asp:Label ID="Label2" runat="server" Height="16px" Text="City :" Width="70px"></asp:Label></td>
                                                <td style="width: 100px; height: 25px;">
                                                    <asp:Label ID="lblCity" runat="server" Height="16px" Width="100px"></asp:Label></td>
                                                <td class="cnt" style="height: 25px">
                                                    <asp:Label ID="Label11" runat="server" Height="16px" Text="State :" Width="50px"></asp:Label></td>
                                                <td style="height: 25px">
                                                    <asp:Label ID="lblState" runat="server" Height="16px" Width="40px"></asp:Label></td>
                                                <td class="cnt" style="height: 25px">
                                                    <asp:Label ID="Label13" runat="server" Height="16px" Text="Post Code :" Width="70px"></asp:Label></td>
                                                <td style="width: 75px; height: 25px">
                                                    <asp:Label ID="lblPostCode" runat="server" Height="16px" Width="50px"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td class="cnt">
                                                    <asp:Label ID="Label6" runat="server" Height="16px" Text="Country :" Width="70px"></asp:Label></td>
                                                <td colspan="3">
                                                    <asp:Label ID="lblCountry" runat="server" Height="16px" Width="80px"></asp:Label></td>
                                                <td>
                                                </td>
                                                <td style="width: 75px">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="right" style="height: 100px; padding-top: 8px; border-bottom: 1px solid #88D2E9; border-collapse: collapse;"
                                        colspan="0" valign="bottom" width="100%">&nbsp;
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 362px" runat=server id="tblBuyingGrp">
                                            <tr>
                                                <td class="cnt" style="padding-right:10px;">
                                                    <asp:Label Height="16px" Style="padding-right: 36px;" ID="Label7" runat="server"
                                                        Text="Price Code" Width="80px"></asp:Label>
                                                    <asp:DropDownList CssClass="FormCtrl" Style="height: 25px" ID="ddlPriceCd" runat="server" Width="180px" AutoPostBack="True" OnSelectedIndexChanged="ddlPriceCd_SelectedIndexChanged">
                                                    </asp:DropDownList></td>
                                            </tr>
                                            <tr>
                                                <td class="cnt" style="padding-right:10px;">
                                                    <asp:Label Height="16px" Style="padding-right: 22px;" ID="Label4" runat="server"
                                                        Text="Buying Group" Width="80px"></asp:Label>
                                                    <asp:DropDownList CssClass="FormCtrl" Style="height: 25px" ID="ddlBuyingGroup" runat="server" Width="180px" AutoPostBack="True" OnSelectedIndexChanged="ddlBuyingGroup_SelectedIndexChanged">
                                                    </asp:DropDownList></td>
                                            </tr>
                                            <tr>
                                                <td class="cnt" style="padding-right:10px;">
                                                    <asp:Label Height="16px" ID="Label5" runat="server" Style="padding-right: 10px;"
                                                        Text="Customer Type"></asp:Label>
                                                    <asp:DropDownList CssClass="FormCtrl" Style="height: 25px" Width="180px"  ID="ddlCustomerType" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlCustomerType_SelectedIndexChanged">
                                                    </asp:DropDownList></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr id="trContent1" runat="server" style="border-top: 1px solid #88D2E9;">
                                    <td style="border-right: 0px solid #88D2E9; width: 539px;" class="lightBlueBg">
                                        &nbsp;
                                        <asp:Label ID="lblEntryCaption" runat="server" CssClass="BanText" Text="Enter Customer Contact Information"
                                            Width="384px"></asp:Label>
                                    </td>
                                    <td class="lightBlueBg" style="border-left: 1px solid #88D2E9;">
                                        <table id="tdContactHead" style="display: none;" runat="server" cellpadding="0" cellspacing="0"
                                            border="0" width="100%">
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label8" runat="server" CssClass="BanText" Text="Contacts" Width="100px"></asp:Label>
                                                </td>
                                                <td align="right" style="padding-right: 5px">
                                                    <asp:ImageButton ID="btnAdd" ImageUrl="~/MaintenanceApps/Common/images/newadd.gif"
                                                        runat="server" CausesValidation="False" OnClick="btnAdd_Click" TabIndex="18" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr id="trContent2" runat="server">
                                    <td valign="top" style="border-right: 0px solid #88D2E9; padding-top: 10px; width: 50%;">
                                        <div id="tdEntry" runat="server" style="display: none; width: 100%;">
                                            <asp:UpdatePanel ID="upnlEntry" runat="server" UpdateMode="conditional">
                                                <ContentTemplate>
                                                    <table width="100%" cellpadding="1" style="border-collapse: collapse;">
                                                        <tr>
                                                            <td class="Left2pxPadd">
                                                                <asp:LinkButton ID="lblNameCaption" runat="server" Font-Underline="true" Text="Name"></asp:LinkButton>
                                                                <div id="divToolTips" class="list" align="left" style="display: none; position: absolute;
                                                                    width: 260px" onmouseup="return false;">
                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td>
                                                                                <span class="boldText">Change ID: </span>
                                                                                <asp:Label ID="lblChangeID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                            <td>
                                                                                <span class="boldText" style="padding-left: 5px;">Change Date: </span>
                                                                                <asp:Label ID="lblChangeDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <span class="boldText">Entry ID: </span>
                                                                                <asp:Label ID="lblEntryID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                            <td>
                                                                                <span class="boldText" style="padding-left: 5px;">Entry Date: </span>
                                                                                <asp:Label ID="lblEntryDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                            </td>
                                                            <td colspan="3" class="Left2pxPadd">
                                                                <asp:TextBox MaxLength="30" CssClass="FormCtrl" ID="txtName" runat="server" onkeypress="javascript:if(window.event.keyCode ==13){DisplayConfirmMessage();}"></asp:TextBox>
                                                                <span style="color: Red;">*</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="Left2pxPadd">
                                                                <asp:Label ID="lblJT" runat="server" Text="Job Title "></asp:Label></td>
                                                            <td class="Left2pxPadd" style="width: 300px">
                                                                <asp:TextBox MaxLength="50" CssClass="FormCtrl" ID="txtJobTitle" onkeypress="javascript:if(window.event.keyCode ==13){DisplayConfirmMessage();}"
                                                                    runat="server"></asp:TextBox></td>
                                                            <td colspan="1" style="padding-left: 50px">
                                                                <asp:Label ID="Label3" runat="server" Text="Contact Type" Width="71px"></asp:Label></td>
                                                            <td colspan="1" class="Left2pxPadd">
                                                                <asp:DropDownList ID="ddlContactType" Style="height: 25px" onkeypress="javascript:if(window.event.keyCode ==13){DisplayConfirmMessage();}"
                                                                    runat="server" CssClass="FormCtrl" Width="125px">
                                                                </asp:DropDownList></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="Left2pxPadd">
                                                                <asp:Label ID="lblPh" runat="server" Text="Phone "></asp:Label></td>
                                                            <td>
                                                                <uc1:PhoneNumber ID="txtHPhone" runat="server" />
                                                            </td>
                                                            <td style="padding-left: 50px">
                                                                <asp:Label ID="lblExtn" runat="server" Text="Ext "></asp:Label></td>
                                                            <td class="Left2pxPadd">
                                                                <asp:TextBox MaxLength="7" CssClass="FormCtrl" onkeypress="javascript:if(window.event.keyCode ==13){DisplayConfirmMessage();} ValdateNumber();"
                                                                    ID="txtExt" runat="server"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="Left2pxPadd">
                                                                <asp:Label ID="lblMp" MaxLength="14" runat="server" Text="Mobile Phone " Width="66px"></asp:Label></td>
                                                            <td>
                                                                <uc1:PhoneNumber ID="txtMPhone" runat="server" />
                                                            </td>
                                                            <td style="padding-left: 50px">
                                                                <asp:Label ID="lblFx" MaxLength="14" runat="server" Text="Fax "></asp:Label></td>
                                                            <td>
                                                                <uc1:PhoneNumber ID="txtFax" runat="server" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="Left2pxPadd">
                                                                <asp:Label ID="lblMail" runat="server" Text="Email "></asp:Label></td>
                                                            <td class="Left2pxPadd" colspan="3">
                                                                <asp:TextBox MaxLength="80" CssClass="FormCtrl" ID="txtEmail" runat="server" onkeypress="javascript:if(window.event.keyCode ==13){DisplayConfirmMessage();}"
                                                                    Width="250px"></asp:TextBox><asp:RegularExpressionValidator ID="RegularExpressionValidator1"
                                                                        runat="server" ErrorMessage="Invalid Email" ControlToValidate="txtEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="Left2pxPadd" style="height: 23px">
                                                                <asp:Label ID="lblDp" MaxLength="20" runat="server" Text="Department "></asp:Label></td>
                                                            <td colspan="3" class="Left2pxPadd" style="height: 23px">
                                                                <asp:TextBox CssClass="FormCtrl" ID="txtDepartment" onkeypress="javascript:if(window.event.keyCode ==13){DisplayConfirmMessage();}"
                                                                    runat="server" Width="250px" MaxLength="20"></asp:TextBox></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="Left2pxPadd" style="height: 23px">
                                                            </td>
                                                            <td colspan="3" style="height: 23px">
                                                                <asp:CheckBox ID="chkPFCMaterial" runat="server" Font-Bold="True" Text="Customer Allows PFC Marketing Materials" Checked="True" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="lightBlueBg" height="25px">
                                                                &nbsp;
                                                            </td>
                                                            <td class="lightBlueBg" colspan="3" align="right" style="padding-right: 30px">
                                                                <asp:UpdatePanel ID="upnlbtnsave" runat="server" UpdateMode="Conditional">
                                                                    <ContentTemplate>
                                                                        <asp:ImageButton ID="btnSave" ImageUrl="~/MaintenanceApps/Common/images/BtnSave.gif"
                                                                            runat="server" OnClientClick="javascript:return MaintenaceAppsRequiredField();"
                                                                            OnClick="btnSave_Click" TabIndex="10" />&nbsp;
                                                                        <asp:ImageButton ID="ibtnCancel" CausesValidation="false" ImageUrl="~/MaintenanceApps/Common/images/cancel.png"
                                                                            runat="server" TabIndex="10" OnClick="ibtnCancel_Click" />
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </div>
                                    </td>
                                    <td style="border-left: 1px solid #88D2E9; width: 50%;">
                                        <div id="tdContact" runat="server" style="display: none;">
                                            <asp:UpdatePanel ID="upnlContactGrid" runat="server" UpdateMode="conditional">
                                                <ContentTemplate>
                                                    <div id="div-datagrid" class="Sbar" align="center" style="overflow-x: hidden; overflow-y: auto;
                                                        position: relative; top: 0px; left: 0px; height: 380px; width: 100%; border: 0px solid;">
                                                        <asp:Label ID="lblNoRecordfound" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                                            runat="server" Text="" Visible="false"></asp:Label>
                                                        <asp:DataList Style="height: auto;" ID="dlContacts" runat="server" Width="95%" RepeatDirection="Horizontal"
                                                            RepeatColumns="2" OnItemCommand="dlContacts_ItemCommand" OnItemDataBound="dlContacts_ItemDataBound">
                                                            <ItemStyle CssClass="grayBorder" Width="240" HorizontalAlign="Left" />
                                                            <ItemTemplate>
                                                                <table cellpadding="1" cellspacing="0" width="240" style="border-collapse: collapse;">
                                                                    <tr>
                                                                        <td nowrap="nowrap">
                                                                            <asp:Label ID="lblCountactName" runat="server" CssClass="grayboldText" Text='<%#DataBinder.Eval(Container,"DataItem.Name") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td nowrap="nowrap">
                                                                            <asp:Label ID="lblJT" runat="server" CssClass="grayboldText" Text="Job Title: "></asp:Label>
                                                                            <asp:Label ID="lblJobTitle" CssClass="grayText" runat="server" Text='<%#DataBinder.Eval(Container,"DataItem.JobTitle") %>'></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td nowrap="nowrap">
                                                                            <asp:Label ID="lblDp" runat="server" CssClass="grayboldText" Text="Department: "></asp:Label>
                                                                            <asp:Label ID="lblDepartment" CssClass="grayText" runat="server" Text='<%#DataBinder.Eval(Container,"DataItem.Department") %>'></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td nowrap="nowrap">
                                                                            <asp:Label ID="lblcontact" runat="server" CssClass="grayboldText" Text="Contact Type: "></asp:Label>
                                                                            <asp:Label ID="lblcontacttype" CssClass="grayText" runat="server" Text='<%#GetContact(DataBinder.Eval(Container,"DataItem.ContactType").ToString()) %>'></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td nowrap="nowrap">
                                                                            <table cellpadding="0" cellspacing="0" width="240">
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label Width="40" ID="lblPh" runat="server" CssClass="grayboldText" Text="Phone: "></asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label Width="120" ID="lblPhone" CssClass="grayText" runat="server" Text='<%#FormatPhoneFax(DataBinder.Eval(Container,"DataItem.Phone").ToString()) %>'></asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label Width="30" ID="lblext1" runat="server" CssClass="grayboldText" Text="Ext: "></asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label Width="50" ID="lblext2" CssClass="grayText" runat="server" Text='<%#FormatPhoneFax(DataBinder.Eval(Container,"DataItem.phoneExt").ToString()) %>'></asp:Label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td nowrap="nowrap">
                                                                            <asp:Label ID="lblMp" runat="server" CssClass="grayboldText" Text="Mobile Phone: "></asp:Label>
                                                                            <asp:Label ID="lblMphone" CssClass="grayText" runat="server" Text='<%#FormatPhoneFax(DataBinder.Eval(Container,"DataItem.MobilePhone").ToString()) %>'></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td nowrap="nowrap">
                                                                            <asp:Label ID="lblFx" runat="server" CssClass="grayboldText" Text="Fax: "></asp:Label>
                                                                            <asp:Label ID="lblFax" CssClass="grayText" runat="server" Text='<%#FormatPhoneFax(DataBinder.Eval(Container,"DataItem.FaxNo").ToString()) %>'></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td nowrap="nowrap">
                                                                            <asp:Label ID="lblMail" runat="server" CssClass="grayboldText" Text="Email: "></asp:Label>
                                                                            <asp:Label ID="lblEmail" CssClass="grayText" runat="server" Text='<%#DataBinder.Eval(Container,"DataItem.EmailAddr") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="right" nowrap="nowrap">
                                                                            <asp:LinkButton ID="lbtnEdit" Font-Underline="true" CausesValidation="false" runat="server"
                                                                                CommandArgument='<%#DataBinder.Eval(Container,"DataItem.pCustContactsID") %>'
                                                                                CssClass="link" CommandName="Edit">Edit</asp:LinkButton>
                                                                            <asp:LinkButton ID="lnkDelete" Font-Underline="true" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.pCustContactsID") %>'
                                                                                CausesValidation="false" runat="server" CssClass="link" CommandName="Delete">Delete</asp:LinkButton></td>
                                                                    </tr>
                                                                </table>
                                                            </ItemTemplate>
                                                        </asp:DataList>
                                                        <input type="hidden" id="hidSort" runat="server" tabindex="12" />
                                                        <input type="hidden" id="hidCustMasterID" runat="server" tabindex="12" />
                                                        <input type="hidden" id="hidCustNo" runat="server" tabindex="12" />
                                                        <input type="hidden" id="hidCustContactID" runat="Server" />
                                                    </div>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="BluBg buttonBar" height="20px">
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
                                <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="false">
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
                <td>
                    <uc2:Footer ID="BottomFrame2" Title="Customer Contacts" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
