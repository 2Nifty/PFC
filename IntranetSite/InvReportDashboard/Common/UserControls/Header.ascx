<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Header.ascx.cs" Inherits="Common_UserControls_Header" %>

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

</script>
<tr>
    <td>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
             <td class="bgheaderbartile" >
               <table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td><div align="right" class="bgtime">
                  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="38%" height="28" align="left"><img src="Common/images/pfcger.gif" height="27"></td>
                      <td width="24%"><div align="center" class="txtTime">
                          <div align="center"><%=DateTime.Now.ToLongDateString() %></div>
                      </div></td>
                      <td width="35%" align="right" class="txtLogin">User Login</td>
                      <td width="3%" align="right"><div align="right"><img src="Common/images/exit.gif" style="cursor:hand" onclick="javascript:window.close();" width="28" height="25"></div></td>
                    </tr>
                  </table>
              </div></td>
            </tr>
        </table>
            </td> 
        </tr>
        </table>
    </td>   
</tr>
 <tr>
    <td valign=top>
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td class="PageBg" valign=top width="100%">
                <table  border="0" cellspacing="0" cellpadding="0" width="100%">
                        <tr>
                            <td class="splitBorder TabHead" width="16%">
                                &nbsp;
                                <asp:Label ID="Label2" runat="server" Width="100px">Vendor Number</asp:Label>
                            </td>
                            <td style="width: 100px" class="splitBorder TabHead">
                                    <asp:DropDownList Width="133px" CssClass="cnt" ID="ddlOrder" runat="server" onchange="javascript:GetVendName(this.value,'lblVendName');" TabIndex="1" >
                                           
                                            </asp:DropDownList>
                                </td>
                            <td class="splitBorder TabHead" colspan="2">
                                <div class="lblbox" style="width:227px"><asp:Label ID="lblVendName" runat="server" ></asp:Label></div></td>
                            <td style="width: 100%" class="splitBorder TabHead">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td  class="splitBorder TabHead">
                                &nbsp;
                                <asp:Label ID="Label1" runat="server" Width="100px">PFC Location </asp:Label></td>
                            <td style="width: 100px" class="splitBorder TabHead">
                           <asp:DropDownList Width="133px" CssClass="cnt" ID="ddlLocation" runat="server" onchange="javascript:GetVendName(this.value,'lblBranch');" TabIndex="2" >                                           
                                            </asp:DropDownList>
                                </td>
                            <td class="splitBorder TabHead" colspan="2">
                                <div class="lblbox" style="width:227px"><asp:Label ID="lblBranch" runat="server"  Text="&nbsp;"></asp:Label></div></td>
                            <td style="width: 100px" class="splitBorder TabHead">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100px;" class="splitBorder TabHead">&nbsp;
                                <asp:Label ID="Label3" runat="server" Width="70px">BOL Number</asp:Label></td>
                            <td style="width: 100px;" class="splitBorder TabHead">
                                <asp:TextBox CssClass="cnt" ID="txtRefNo" runat="server" MaxLength="50" TabIndex="3"/>&nbsp;
                            </td>
                            <td style="padding-left:16px;" width="16%" class="splitBorder TabHead">                                
                                <asp:Label ID="Label8" runat="server" Width="100px">Port of Lading</asp:Label></td>
                            <td style="width: 100px;" class="splitBorder TabHead"><asp:DropDownList Width="133px" CssClass="cntnopadding" ID="ddlPort" runat="server" TabIndex="6" ></asp:DropDownList>
                                </td>
                            <td style="width: 100px;" class="splitBorder TabHead">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100px" class="splitBorder TabHead">
                                &nbsp;
                                <asp:Label ID="Label4" runat="server" Width="70px">BOL Date</asp:Label></td>
                            <td style="width: 100px" class="splitBorder TabHead">
                                <asp:TextBox CssClass="cnt" ID="txtBOLDt" runat="server" MaxLength="10" onblur="javascript:ValidateDate(this.value,this.id);" TabIndex="4"/>&nbsp;
                            </td>
                            <td style="width: 100px;padding-left:16px" class="splitBorder TabHead" >                                
                                <asp:Label ID="Label9" runat="server" Width="100px">Vessel Name </asp:Label></td>
                            <td style="width: 100px" class="splitBorder TabHead"><asp:TextBox CssClass="cntnopadding" ID="txtVesselName" runat="server" onblur="javascript:validateBOLHeader();" MaxLength="50" TabIndex="7"/>
                                </td>
                            <td style="width: 100px" class="splitBorder TabHead">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100px" class="splitBorder TabHead">
                                &nbsp;
                                <asp:Label ID="Label5" runat="server" Width="82px">Receipt Type</asp:Label></td>
                            <td style="width: 100px" class="splitBorder TabHead">
                            <asp:DropDownList Width="133px" CssClass="cnt" ID="ddlReceipt" runat="server" TabIndex="5">
                                             </asp:DropDownList>                            </td>
                            <td class="splitBorder TabHead" colspan="2" >
                                <div class="lblbox" style="width:227px"><asp:Label ID="lblProcDt" runat="server"/></div>
                            </td>
                             <td align="right"><img id="imgList" src="../../../IntranetSite/Common/Images/list.gif" style="cursor:hand;" onclick="javascript:BindList();"/>
                             
                            </td>
                        </tr>
                    </table>
          </td>                    
        </tr>
     </table>

</td>
</tr>
 