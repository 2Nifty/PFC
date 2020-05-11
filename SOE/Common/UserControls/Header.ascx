<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Header.ascx.cs" Inherits="Common_UserControls_Header" %>
<%@ Register Src="CommonLink.ascx" TagName="CommonLink" TagPrefix="uc4" %>
<asp:UpdatePanel ID="pnlCustomer" runat="server" UpdateMode="conditional">
    <ContentTemplate>
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td valign="top" class="HeaderPanels" style="padding-left: 4px; height: 110px;" width="30%">
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <strong>
                                    <asp:LinkButton ID="lblCustomerCaption" CssClass="TabHead" OnClientClick="javascript:return OpenOrganisationComments(this);"
                                        runat="server" Text="Customer Number" Width="124px"></asp:LinkButton></strong></td>
                            <td>
                                <asp:TextBox ID="txtCustNo" TabIndex="1" runat="server" CssClass="lbl_whitebox" AutoPostBack="true"
                                    Width="80px" OnTextChanged="txtCustNo_TextChanged"></asp:TextBox><asp:Button ID="btnLoadCustomer"
                                        runat="server" Style="display: none" Text="Sold To" />
                                <asp:HiddenField ID="hidCust" runat="server" />
                                <asp:HiddenField ID="hidCreditInd" runat="server" />
                                <asp:HiddenField ID="hidOrderID" runat="server" />
                                <asp:HiddenField ID="hidTableName" runat="server" />
                                <asp:HiddenField ID="hidSOFindSOid" Value="" runat="server" />
                                <asp:RequiredFieldValidator ID="rqvCustNo" runat="server" ControlToValidate="txtCustNo"
                                    CssClass="cnt" Display="Dynamic" ErrorMessage="* Required"></asp:RequiredFieldValidator></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="lblSON0Caption" runat="server" Text="Sales Order Number" Font-Bold="True"
                                    Width="139px"></asp:Label></td>
                            <td>
                                <asp:TextBox ID="txtSONumber" TabIndex="2" runat="server" CssClass="lbl_whitebox"
                                    onkeydown="javascript:if(event.keyCode == 9){document.getElementById('CustDet_hidPreviousValue').value='';LoadDetails(this.value);}"
                                    onfocus="javascript:document.getElementById('CustDet_hidPreviousValue').value=this.value;"
                                    onkeypress="javascript:if(event.keyCode == 13){document.getElementById('CustDet_hidPreviousValue').value='';return LoadDetails(this.value);return false;}"
                                    Width="80px"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td height="23px" valign="middle">
                                <asp:Label ID="lblChain" runat="server" CssClass="TabHead" Font-Bold="True" Text="Chain"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblChainValue" runat="server" CssClass="lblbox" Text="" Width="40px"></asp:Label></td>
                        </tr>
                        <tr>
                            <td height="23px" valign="middle">
                                <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="SO Date"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblSoDate" runat="server" CssClass="lblbox"></asp:Label></td>
                        </tr>
                    </table>
                </td>
                <td valign="top" class="HeaderPanels" width="35%" style="padding-left: 4px">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%" height="90%">
                        <tr>
                            <td width="50px" valign="top">
                                <table cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <asp:LinkButton ID="lnkSoldTo" runat="server" CssClass="TabHead" OnClientClick="Javascript:document.getElementById('CustDet_hidCurrentControl').value=this.id;OpenSoldToForm();return false;"
                                                Text="Sold To:" Font-Bold="True" Width="45px"></asp:LinkButton></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblCusNum" runat="server" CssClass="lblbox"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top">
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblSold_Name" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblSoldTo_Address" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="lblSold_Address2" runat="server" CssClass="lblColor"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblSold_City" runat="server" CssClass="lblColor"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblSoldCom" runat="server" CssClass="lblColor" Text=",&nbsp;"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblSold_Territory" runat="server" CssClass="lblColor"></asp:Label></td>
                                        <td>
                                            &nbsp;<asp:Label ID="lblSold_Pincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                        <td>
                                            &nbsp;<asp:Label ID="lblSoldCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="lblSold_Phone" runat="server" CssClass="lblColor"></asp:Label>
                                <asp:Label ID="lblSold_Contact" runat="server" CssClass="lblColor" Visible="False"></asp:Label></td>
                        </tr>
                        <tr>
                            <td rowspan="3" valign="bottom">
                                <table cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <asp:LinkButton ID="lnkBillTo" runat="server" CssClass="TabHead" Text="Bill To:"
                                                OnClientClick="Javascript:document.getElementById('CustDet_hidCurrentControl').value=this.id;OpenBillToForm();return false;"
                                                Font-Bold="True" Width="45px"></asp:LinkButton></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblBillCustNo" runat="server" CssClass="lblbox"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                            <td rowspan="3" valign="top" style="padding-left: 2px;">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td>
                                            <asp:HyperLink Target="_blank" runat="server" ID="lblTermDesc" Text="" CssClass="lblColor"
                                                Style="cursor: hand; text-decoration: underline" ToolTip="View Customer Activity Sheet"></asp:HyperLink>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblBill_To" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
                <td valign="top" class="HeaderPanels" style="padding-left: 4px" width="35%">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td width="55px">
                                <asp:LinkButton ID="lnkShipTo" runat="server" CssClass="TabHead" OnClientClick="Javascript:document.getElementById('CustDet_hidCurrentControl').value=this.id;OpenShipToForm();return false;"
                                    Text="Ship To:" Font-Bold="True"></asp:LinkButton></td>
                            <td>
                                <asp:Label ID="lblShip_Name" runat="server" CssClass="lblColor"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="lblCustNum" runat="server" CssClass="lblbox"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblShip_Address" runat="server" CssClass="lblColor"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="lblShip_Address2" runat="server" CssClass="lblColor"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblShip_City" runat="server" CssClass="lblColor"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblShipCom" runat="server" CssClass="lblColor" Text=",&nbsp;"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblShip_Territory" runat="server" CssClass="lblColor"></asp:Label></td>
                                        <td>
                                            &nbsp;<asp:Label ID="lblShip_Pincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                        <td>
                                            &nbsp;<asp:Label ID="lblShipCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="lblShip_Phone" runat="server" CssClass="lblColor"></asp:Label></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            &nbsp;<asp:LinkButton ID="lnkOrderContact" runat="server" CssClass="TabHead" Font-Bold="True"
                                                OnClientClick="Javascript:document.getElementById('CustDet_hidCurrentControl').value=this.id;ShowContactForm(document.getElementById('lblOrderContact'));return false;"
                                                Text="Order Contact:" Width="80px"></asp:LinkButton>
                                        </td>
                                        <td style="padding-left: 5px; word-break: keep-all; word-wrap: normal;">
                                            <asp:Label ID="lblOrderContact" Style="word-wrap: normal; display: block;" Text=""
                                                Width="100px" runat="server"></asp:Label>
                                            <asp:TextBox ID="txtOrderContact" runat="server" Width="80px" MaxLength="25" onkeypress="javascript:if(event.keyCode ==13)HideContactForm();"
                                                onblur="javascript:HideContactForm();" Style="display: none;"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-top:5px;">
                                            &nbsp;<asp:HyperLink ID="lnkeComm" runat="server" CssClass="TabHead" Font-Bold="True"  Visible="false"                                               
                                                onmouseover="javascript:return ShowECommTooltip('CustDet_eCommToolTips');"
                                                onmouseout = "javascript:document.getElementById('CustDet_eCommToolTips').style.display='none';"
                                                Text="eComm." Width="80px" NavigateUrl="#" onclick="javascript:return false;" ></asp:HyperLink>
                                                
                                            <div id="eCommToolTips" class="list" runat="server" style="display:none; position: absolute;
                                                z-index: 99;" onmouseup="return false;">
                                                <table border="0" cellpadding="0" cellspacing="0" style="z-index: 99;">
                                                    <tr>
                                                        <td style="z-index: 99;">
                                                            <span class="boldText"><b>Contact Name: </b></span>
                                                            <asp:Label ID="lbleCommContactName" runat="server" Text=""
                                                                Font-Bold="false"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding-right: 10px;" style="z-index: 99;">
                                                            <span class="boldText"><b>Phone: </b></span>
                                                            <asp:Label ID="lbleCommContactPhone" runat="server" Text=""
                                                                Font-Bold="false"></asp:Label></td>
                                                        
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span class="boldText" style="z-index: 99;"><b>Email: </b></span>
                                                            <asp:Label ID="lbleCommContactEmail" runat="server" Text=""
                                                                Font-Bold="false"></asp:Label></td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="upContext" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div id="divTool" class="MarkItUp_ContextMenu_MenuTable" style="display: none; word-break: keep-all;
                                position: absolute">
                                <table border="0" bordercolor="#000099" cellpadding="0" cellspacing="0" class="MarkItUp_ContextMenu_Outline"
                                    width="20%">
                                    <tr>
                                        <td class="bgmsgboxtile">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td class="txtBlue" width="90%">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td>
                </td>
                <td>
                    <asp:HiddenField ID="hidCurrentControl" runat="server" Value="" />
                    <asp:HiddenField ID="hidPreviousValue" runat="server" />
                    <asp:Button ID="btnLoadAll" runat="server" CausesValidation="false" OnClick="btnLoadAll_Click"
                        Style="display: none" /></td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>

<script> 

function OpenSoldToForm()
{

    if(document.getElementById("CustDet_txtSONumber").value !="" && document.getElementById("hidIsReadOnly").value =="false" && document.getElementById("CustDet_hidTableName").value=="SOHeader")
    {
        popUp=window.open ("SoldToAddress.aspx?SONumber="+parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value +"&Mode=OrderEntry","SoldToForm",'height=565,width=715,scrollbars=no,status=no,top='+((screen.height/2) - (565/2))+',left='+((screen.width/2) - (715/2))+',resizable=NO',"");
         popUp.location.reload(true); 
        popUp.focus();
    }
}
function OpenShipToForm()
{
    if(document.getElementById("CustDet_txtSONumber").value !="" && document.getElementById("hidIsReadOnly").value =="false")
    {
        shipToWind = window.open ("OneTimeShipToContact.aspx?SONumber="+parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value +"&Mode=OrderEntry","SoldToForm",'height=585,width=715,scrollbars=no,status=no,top='+((screen.height/2) - (585/2))+',left='+((screen.width/2) - (715/2))+',resizable=NO',"");
        shipToWind.location.reload(true); 
        shipToWind.focus();
    }
}
function OpenBillToForm()
{
    if(document.getElementById("CustDet_txtSONumber").value !="" && document.getElementById("hidIsReadOnly").value =="false" && document.getElementById("CustDet_hidTableName").value=="SOHeader")
    {
        popUp=window.open ("BillToAddress.aspx?SONumber="+parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value +"&CustNumber="+parent.bodyFrame.form1.document.getElementById("CustDet_txtCustNo").value +"&Mode=OrderEntry","SoldToForm",'height=520,width=715,scrollbars=no,status=no,top='+((screen.height/2) - (565/2))+',left='+((screen.width/2) - (715/2))+',resizable=NO',"");
        popUp.focus();
    }
}

function ShowContactForm(contactName)
{
    if(document.getElementById("CustDet_txtSONumber").value !="" && document.getElementById("hidIsReadOnly").value =="false" && document.getElementById("CustDet_hidTableName").value=="SOHeader")
    {
        document.getElementById("CustDet_lblOrderContact").style.display = "none";
        document.getElementById("CustDet_txtOrderContact").style.display = "block";
        document.getElementById("CustDet_txtOrderContact").value = document.getElementById("CustDet_lblOrderContact").innerText;        
        document.getElementById("CustDet_txtOrderContact").select();    
    }
}

function HideContactForm()
{
    document.getElementById("CustDet_lblOrderContact").style.display = "block";
    document.getElementById("CustDet_txtOrderContact").style.display = "none";
    OrderEntryPage.UpdateOrderContact("",document.getElementById("CustDet_txtOrderContact").value);
    document.getElementById("CustDet_lblOrderContact").innerText = document.getElementById("CustDet_txtOrderContact").value;
    if(document.getElementById("CustDet_lbleCommContactName"))
        document.getElementById("CustDet_lbleCommContactName").innerText = document.getElementById("CustDet_lblOrderContact").innerText;
}

function ShowECommTooltip(tooltipId) 
{   
    it = document.getElementById(tooltipId); 

    // need to fixate default size (MSIE problem) 
    img = document.getElementById("CustDet_lnkeComm"); 
           
    it.style.top =  event.clientY + 'px'; 
    it.style.left = event.clientX+ 'px';
   
    // Show the tag in the position
    it.style.display = '';
  
    return false; 
}

</script>

