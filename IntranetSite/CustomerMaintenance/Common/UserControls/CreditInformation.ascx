<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CreditInformation.ascx.cs" Inherits="PFC.Intranet.Maintenance.CreditInformation" %>
<%@ Register Src="novapopupdatepicker.ascx" TagName="novapopupdatepicker" TagPrefix="uc1" %>
<%@ Register src="~/CustomerMaintenance/Common/UserControls/PhoneNumber.ascx" TagName="PhoneNumber"
    TagPrefix="uc2" %>

 <script>
    //------------------------------------------------------------- 
    function callTaxExempt(obj)
    {
         var custID= document.getElementById(obj.id.replace('imgTaxExempt','hidCustomerID')).value;
    var Url = "TaxExempt.aspx?CustomerID="+ custID ;
    var hwind=window.open(Url,"TaxExempt" ,'height=520,width=715,scrollbars=no,status=no,top='+((screen.height/2) - (565/2))+',left='+((screen.width/2) - (715/2))+',resizable=NO',"");
hwind.focus();
return false;
    }
    //------------------------------------------------------------- 
    function callNotes(obj)
    {
     var custID= document.getElementById(obj.id.replace('imgviewNotes','hidCustomerID')).value;
     var Url = "CustomerNotes.aspx?CustomerID="+ custID ;
     var hwind=window.open(Url,"Notes" ,'height=520,width=715,scrollbars=no,status=no,top='+((screen.height/2) - (565/2))+',left='+((screen.width/2) - (715/2))+',resizable=NO',"");
     hwind.focus();
     return false;
    }
    //------------------------------------------------------------- 
    </script> 
    <script>
   
   function CheckCtrl(id)
   {
        var txtVendNo=document.getElementById(id+"txtVendNo").value.replace(/\s/g,'');
        var txtVendName=document.getElementById(id+"txtVenName").value.replace(/\s/g,'');
        var txtCode=document.getElementById(id+"txtVenCode").value.replace(/\s/g,'');
        var txtLocName=document.getElementById(id+"txtAddressName").value.replace(/\s/g,'');
        
        if(txtVendNo!="" && txtVendName!="" && txtCode!="" && txtLocName!="")
            return true;
        else
        {
            alert("'*' Marked fields are mandatory")
            return false;;
        }
    }
    
    
   </script>
<table width="100%" height=100% cellpadding="0" cellspacing="0">
<tr><td> <div id="divCredit" runat="server">
    <asp:Panel ID="pnlDetails" runat="server" DefaultButton="ibtnSave" >  
    <table cellpadding="0" cellspacing="0" width="100%" height=401px class="blueBorder">
                <tr>
                    <td class="lightBlueBg">
                        <asp:Label ID="lblInfo" CssClass="BanText" runat="server" Text="Credit Information"></asp:Label>
                        <asp:HiddenField ID="hidCustomerID" runat="server" />
                    </td>
                    <td class="lightBlueBg" align="right">
                        <table>
                            <tr>
                                <td>
                                    <asp:ImageButton ID="imgTaxExempt" OnClientClick="javascript:return callTaxExempt(this);"
                                        ImageUrl="~/customerMaintenance/common/images/TaxExempt.gif" runat="server" /></td>
                                <td>
                                    <asp:ImageButton ID="imgviewNotes" OnClientClick="javascript:return callNotes(this);"
                                        ImageUrl="~/customerMaintenance/common/images/viewnotes.gif" runat="server" /></td>
                                <td>
                                    <asp:Button ID="ibtnSave" Width="73px" OnClientClick="Javascript:return CheckCtrl(this.id.replace('ibtnSave',''));"
                                        Height="23" runat="server" Text="" Style="background-image: url(Common/images/btnsave.gif);
                                        background-color: Transparent; border: none; cursor: hand;" OnClick="ibtnSave_Click"
                                        CausesValidation="true" /></td>
                                <td>
                                    <asp:ImageButton ID="ibtnCancel" runat="server" ImageUrl="~/customerMaintenance/Common/images/cancel.png"
                                        OnClick="ibtnCancel_Click" /></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="padding-top: 3px;">
                        <table width="75%" cellpadding="3" cellspacing="0">
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt ">
                                </td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" colspan="3">
                                    &nbsp;<%-- <span style="color:Red;">* Marked fields are required</span>--%> </td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt ">
                                    Credit Limit</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox MaxLength=2 ID="txtCreditLimeit"  onkeypress="javascript:ValidateNumber();"  CssClass="FormCtrl" runat="server"></asp:TextBox>                                
                                </td>
                                <td class="Left2pxPadd DarkBluTxt ">
                                    Trade Term</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:DropDownList  ID="ddlTradeTerm"   CssClass="FormCtrl" runat="server" Height=20px></asp:DropDownList>
               
                                </td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt ">
                                    Credit Application</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:DropDownList  ID="ddlCreditApp"   CssClass="FormCtrl" runat="server" Height=20px>
                                   
                                    </asp:DropDownList>
               
                                </td>
                               <td class="Left2pxPadd DarkBluTxt ">
                                    Cycle Billing</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:DropDownList  ID="ddlCycleBilling"   CssClass="FormCtrl" runat="server" Height=20px></asp:DropDownList>
               
                                </td>
                            </tr>
                            <tr>
                             <td class="Left2pxPadd DarkBluTxt ">
                                    Credit Indicator</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox ID="txtCreditIndicator" MaxLength="2" CssClass="FormCtrl" runat="server"></asp:TextBox></td>
                              
                              <td class="Left2pxPadd DarkBluTxt ">
                                    Cash Discount</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:DropDownList  ID="ddlCashDiscount"   CssClass="FormCtrl" runat="server" Height=20px></asp:DropDownList>
               
                                </td>
                            </tr>
                            <tr>
                                 <td class="Left2pxPadd DarkBluTxt ">
                                     Credit Review</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:DropDownList  ID="ddlCreditReview"  CssClass="FormCtrl" runat="server" Height=20px>
                                  
                                    </asp:DropDownList>
                                        
                                </td>
                                <td class="Left2pxPadd DarkBluTxt ">
                                   Late Charge %</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox ID="txtLateCharge" MaxLength="19" onkeypress="javascript:ValidateNumber();" CssClass="FormCtrl" runat="server"></asp:TextBox></td>
                            </tr>
                            <tr>
                                 <td class="Left2pxPadd DarkBluTxt ">
                                     Credit Review Date</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                     <uc1:novapopupdatepicker ID="dpCreditReviewdt" runat="server" />
                                        
                                </td>
                                <td class="Left2pxPadd DarkBluTxt ">
                                    Duns No.</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox ID="txtDunsNo" MaxLength="15" CssClass="FormCtrl" runat="server"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt ">
                                     Write Off Date</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">                                     
                                    <uc1:novapopupdatepicker ID="dpWriteOffDate" runat="server" /> 
                                </td>
                               <td class="Left2pxPadd DarkBluTxt ">
                                     Duns Rating</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox MaxLength="10" CssClass="FormCtrl" ID="txtDunsRating" runat="server"></asp:TextBox>
                                    
                                </td>
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt  " style="height: 26px">
                                     Service Charge Mo.</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="height: 26px">
                                    <asp:TextBox MaxLength="18" onkeypress="javascript:ValidateNumber();" CssClass="FormCtrl" ID="txtServiceCharge" runat="server"></asp:TextBox></td>
                                    <td>&nbsp;</td>
                                <td class="Left2pxPadd DarkBluTxt  " style="height: 26px" rowspan=6 colspan=1>
                                    <asp:CheckBoxList ID="chkList" runat="server">
                                   <asp:ListItem Value="SB" Text="Summary Billing"></asp:ListItem>
                                   <asp:ListItem Value="DE" Text="Delinquency"></asp:ListItem>
                                   <asp:ListItem Value="TS" Text="Tax Status"></asp:ListItem>
                                   <asp:ListItem Value="CB" Text="Charge Back"></asp:ListItem>
                                   <asp:ListItem Value="FC" Text="Finance Charge"></asp:ListItem>
                                   <asp:ListItem Value="RE" Text="Rebate"></asp:ListItem>                              
                                   </asp:CheckBoxList>
                                  
                                </td>
                                
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt  ">
                                    Zero Balance Mo.</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox  onkeypress="javascript:ValidateNumber();" MaxLength=19 CssClass="FormCtrl" ID="txtZeroBalance" runat="server"></asp:TextBox></td>
                                
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt  ">
                                     GL Posting Code</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:DropDownList    CssClass="FormCtrl"  ID="ddlGLPosting" runat="server" Height=20px></asp:DropDownList></td>
                               
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt  ">
                                    Multi Tax Code</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:TextBox  ID="txtMultiTaxCd" runat="server" CssClass="FormCtrl" MaxLength=10 ></asp:TextBox>
                                </td>
                                
                            </tr>
                            <tr>
                                <td class="Left2pxPadd DarkBluTxt  ">
                                    Tax Code</td>
                                <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                    <asp:DropDownList  CssClass="FormCtrl"  ID="ddlTaxCode"  runat="server" Height=20px></asp:DropDownList>
                                    </td>
                            </tr>
                            <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                        </table>
                    </td>
                </tr>
            </table>
    </asp:Panel></div></td>
        </tr>
</table>
       
   