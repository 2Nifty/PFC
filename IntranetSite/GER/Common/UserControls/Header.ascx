<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Header.ascx.cs" Inherits="Common_UserControls_Header" %>
<%@ Register Src="HeaderImage.ascx" TagName="HeaderImage" TagPrefix="uc1" %>

<script language="javascript">
function GetVendName(VendName,lblName)
{
    if(VendName!='0')
        document.getElementById("BOLHeader_"+lblName).innerHTML=VendName;
    else
        document.getElementById("BOLHeader_"+lblName).innerHTML="";
}
function BindList()
{
    
    var bt = document.getElementById("btnList");
      if (bt){ 
            if(navigator.appName.indexOf("Netscape")>(-1)){ 
                        bt.click(); 
                        return false; 
                 
            } 
            if (navigator.appName.indexOf("Microsoft Internet Explorer")>(-1)){ 
                 
                        bt.click(); 
                        return false; 
                
            } 
      } 
}
function UpdHeader()
{
    
    var bt = document.getElementById("btnUpdate");
      if (bt){ 
            if(navigator.appName.indexOf("Netscape")>(-1)){ 
                        bt.click(); 
                        return false; 
                 
            } 
            if (navigator.appName.indexOf("Microsoft Internet Explorer")>(-1)){ 
                 
                        bt.click(); 
                        return false; 
                
            } 
      } 
}

</script>
<tr>
    <td>
        <uc1:HeaderImage ID="HeaderImage1" runat="server" />
    </td>
</tr>
<tr>
    <td id="tdHeaderSection2" valign="top">        
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td class="PageBg" valign="top" width="100%">
                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                        <tr>
                            <td class="splitBorder TabHead">
                                &nbsp;
                                <asp:Label ID="Label2" runat="server" Width="100px">Vendor Number</asp:Label>
                            </td>
                            <td class="splitBorder TabHead">
                                <asp:DropDownList Width="133px" CssClass="cnt" ID="ddlOrder" runat="server" onchange="javascript:GetVendName(this.value,'lblVendName');"
                                    TabIndex="1">
                                </asp:DropDownList>
                            </td>
                            <td class="splitBorder TabHead" colspan="2">
                                <div class="lblbox" style="width: 227px">
                                    <asp:Label ID="lblVendName" runat="server"></asp:Label></div>
                            </td>
                            <td  class="splitBorder TabHead" style="padding-left: 10px">
                                <table>
                                    <tr>
                                        <td width="100px">
                                            <asp:Label ID="Label10" runat="server">Customs No. </asp:Label></td>
                                        <td>
                                            <asp:TextBox Width="127px" CssClass="cntnopadding" ID="txtCustomsEntryNo" runat="server"
                                                MaxLength="50" TabIndex="8" /></td>
                                    </tr>
                                </table>
                            </td>
                            <td style="width: 100%" class="splitBorder TabHead">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="splitBorder TabHead">
                                &nbsp;
                                <asp:Label ID="Label1" runat="server" Width="100px">PFC Location </asp:Label></td>
                            <td class="splitBorder TabHead">
                                <asp:DropDownList Width="133px" CssClass="cnt" ID="ddlLocation" runat="server" onchange="javascript:GetVendName(this.value,'lblBranch');"
                                    TabIndex="2">
                                </asp:DropDownList>
                            </td>
                            <td class="splitBorder TabHead" colspan="2">
                                <div class="lblbox" style="width: 227px">
                                    <asp:Label ID="lblBranch" runat="server" Text="&nbsp;"></asp:Label></div>
                            </td>
                            <td  class="splitBorder TabHead" style="padding-left: 10px">
                                <table>
                                    <tr>
                                        <td width="100px">
                                            <asp:Label ID="Label11" runat="server">Port of Entry </asp:Label></td>
                                        <td>
                                            <asp:TextBox Width="127px" CssClass="cntnopadding" ID="txtPortOfEntry" runat="server"
                                                MaxLength="50" TabIndex="9" /></td>
                                    </tr>
                                </table>
                            </td>
                            <td class="splitBorder TabHead" >
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="splitBorder TabHead">
                                &nbsp;
                                <asp:Label ID="Label3" runat="server" Width="70px">BOL Number</asp:Label></td>
                            <td class="splitBorder TabHead">
                    <asp:UpdatePanel ID="pnlBOL" UpdateMode="Conditional" runat="server">
                        <ContentTemplate>
                                <asp:TextBox CssClass="cnt" ID="txtRefNo" runat="server" AutoPostBack="true" MaxLength="50" TabIndex="3" OnTextChanged="txtRefNo_TextChanged" />&nbsp;
                        </ContentTemplate>
                    </asp:UpdatePanel>
                            </td>
                            <td style="padding-left: 16px;" class="splitBorder TabHead" colspan="2" align="left">
                                <table>
                                    <tr>
                                        <td width="100px">
                                            <asp:Label ID="Label8" runat="server">Port of Lading</asp:Label></td>
                                        <td>
                                            <asp:DropDownList Width="133px" CssClass="cntnopadding" ID="ddlPort" runat="server"
                                                TabIndex="6">
                                            </asp:DropDownList></td>
                                    </tr>
                                </table>
                            </td>
                            <td  class="splitBorder TabHead" style="padding-left: 10px">
                                <table>
                                    <tr>
                                        <td width="100px">
                                            <asp:Label ID="Label12" runat="server">Customs Date </asp:Label></td>
                                        <td>
                                            <asp:TextBox Width="127px" CssClass="cntnopadding" ID="txtCustomsDate" runat="server"
                                                MaxLength="12" onblur="javascript:ValidateDate(this.value,this.id);" TabIndex="10" /></td>
                                    </tr>
                                </table>
                            </td>
                            <td class="splitBorder TabHead" colspan="2">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="splitBorder TabHead">
                                &nbsp;
                                <asp:Label ID="Label4" runat="server" Width="70px">BOL Date</asp:Label></td>
                            <td class="splitBorder TabHead">
                                <asp:TextBox CssClass="cnt" ID="txtBOLDt" runat="server" MaxLength="10" onblur="javascript:ValidateDate(this.value,this.id);"
                                    TabIndex="4" />&nbsp;
                            </td>
                            <td style="padding-left: 16px" class="splitBorder TabHead" colspan="2" align="left">
                                <table>
                                    <tr>
                                        <td width="100px">
                                            <asp:Label ID="Label9" runat="server">Vessel Name </asp:Label></td>
                                        <td>
                                            <asp:TextBox Width="127px" CssClass="cntnopadding" ID="txtVesselName" runat="server"
                                                MaxLength="50" TabIndex="7" /></td>
                                    </tr>
                                </table>
                            </td>
                            <td class="splitBorder TabHead" style="padding-left: 10px">
                                <table>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label6" runat="server">Broker Invoice Amt</asp:Label></td>
                                        <td>
                                            <asp:TextBox CssClass="cntnopadding" ID="txtBrokerIAmt" runat="server" MaxLength="50"
                                                TabIndex="11" Width="125px" onblur="javascript:roundNumber(this.value,2,this);this.value=addCommas(this.value);"
                                                onkeypress="if (window.event.keyCode < 45 || window.event.keyCode > 58) window.event.keyCode = 0"
                                                onkeydown='if (event.keyCode==13) {event.keyCode=9; return event.keyCode }' /></td>
                                    </tr>
                                </table>
                            </td>
                            <td class="splitBorder TabHead" colspan="2" align="right">
                                &nbsp; &nbsp;
                                &nbsp;<img id="imgUpdate" name="imgUpdate" src="../../../IntranetSite/Common/Images/update.gif" style="cursor: hand;"
                                    onclick="javascript:UpdHeader();" />
                            </td>
                        </tr>
                        <tr>
                            <td class="splitBorder TabHead" width="12%">
                                &nbsp;
                                <asp:Label ID="Label5" runat="server" Width="82px">Receipt Type</asp:Label></td>
                            <td class="splitBorder TabHead" width="10%">
                                <asp:DropDownList Width="133px" CssClass="cnt" ID="ddlReceipt" runat="server" TabIndex="5">
                                </asp:DropDownList>
                            </td>
                            <td class="splitBorder TabHead" colspan="2" width="15%">
                                <div class="lblbox" style="width: 227px">
                                    <asp:Label ID="lblProcDt" runat="server" /></div>
                            </td>
                            <td class="splitBorder TabHead" style="padding-left: 10px" width="40%">
                                <table>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label7" runat="server">Broker Invoice BOL Count</asp:Label></td>
                                        <td>
                                            <asp:TextBox CssClass="cntnopadding" ID="txtBOLCount" runat="server" onblur="javascript:validateBOLHeader();this.value=addCommas(this.value);"
                                                onkeypress="if (window.event.keyCode < 45 || window.event.keyCode > 58) window.event.keyCode = 0"
                                                onkeydown='if (event.keyCode==13) {event.keyCode=9; return event.keyCode }' MaxLength="50"
                                                TabIndex="12" Width="90px" />
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ErrorMessage="Only numeric values allowed"
                                        ControlToValidate="txtBOLCount"  ValidationExpression="[0-9,]+$" Display="Dynamic" CssClass="Required"></asp:RegularExpressionValidator>
                                                </td>
                                    </tr>
                                </table>
                            </td>
                            <td class="splitBorder TabHead" colspan="2" align="right">
                                &nbsp;<img id="imgList" src="../../../IntranetSite/Common/Images/list.gif" style="cursor: hand;"
                                    onclick="javascript:BindList();" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </td>
</tr>
