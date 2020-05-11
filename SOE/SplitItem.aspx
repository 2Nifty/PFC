<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SplitItem.aspx.cs" Inherits="SplitItemGUI" %>

<%@ Register Src="Common/UserControls/Pager.ascx" TagName="Pager" TagPrefix="uc4" %>
<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/TwoDatePicker.ascx" TagName="TwoDatePicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SOE - Split Line</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="Common/JavaScript/ContextMenu.js"></script>

    <script type="text/javascript">
    // Tool tip function
    function ShowContextMenu(tooltipId, parentId)
    {
        it = document.getElementById(tooltipId); 

        // need to fixate default size (MSIE problem) 
        img = document.getElementById(parentId); 
         
        x = xstooltip_findPosX(img); // These methods are in ContextMenu.js file
        y = xstooltip_findPosY(img); 
        //y = y - scrollPosition;
        
        if(y<469)
            it.style.top =  (y+15) + 'px'; 
        else
            it.style.top =  (y-50) + 'px'; 
            
        it.style.left =(x+10)+ 'px';

        // Show the tag in the position
        it.style.display = '';
          
        return false;      
    }
    
    function RefreshParent()
    {
        window.opener.parent.bodyFrame.CallBtnClick('btnGrid');
        alert('New line added Successfully');        
        window.close();
    }
    
    function OnlyNumbers(evt)
    {
        var e = event || evt; // for trans-browser compatibility
        var charCode = e.which || e.keyCode;        
        if  (charCode != 46 && 
            (charCode > 31 && (charCode < 48 || charCode > 57)))
            return false;

        return true;
    }
    
    function GetItemDetail(event)
    {
        if(event.keyCode==13)
        {    
            CheckCrossReferenceNumber(document.getElementById("txtPFCItemNo").value);
            
        }
        else if(event.keyCode==9)
        {
            if(document.getElementById("txtPFCItemNo").value !=  document.getElementById("hiPreviousItemNo").value)
                document.form1.btnCustItem.click();
        }
    }


    function CheckCrossReferenceNumber(itemNo)
    {
        if(itemNo!="")
        {
            var section="";
            var completeItem=0;
           
            switch(itemNo.split('-').length)
            {
            case 1:
                event.keyCode=0;
                itemNo = "00000" + itemNo;
                itemNo = itemNo.substr(itemNo.length-5,5);
                document.getElementById("txtPFCItemNo").value=itemNo+"-"; 
                // document.getElementById("lblMessage").innerText ="Item not found";
                return ;
                break;
            case 2:
                // close if they are entering an empty part
                if (itemNo.split('-')[0] == "00000") {ClosePage()};
                event.keyCode=0;
                section = "0000" + itemNo.split('-')[1];
                section = section.substr(section.length-4,4);
                document.getElementById("txtPFCItemNo").value=itemNo.split('-')[0]+"-"+section+"-";  
                 //document.getElementById("lblMessage").innerText ="Item not found";
                 return ;
                break;
            case 3:
                event.keyCode=0;
                section = "000" + itemNo.split('-')[2];
                section = section.substr(section.length-3,3);
                document.getElementById("txtPFCItemNo").value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
                completeItem=1;
                break;
            
            }
            if (completeItem==1) 
            {
                if(document.getElementById("txtPFCItemNo").value !=  document.getElementById("hiPreviousItemNo").value)
                    document.form1.btnPFCItem.click();        
            }
        }   
    }
    
    function UpdateReqQty()
    {
        if(parseInt(document.getElementById("txtReqQty").value) > parseInt(document.getElementById("lblAvailQty").innerHTML))
        {
            if(!ShowYesorNo('Requested Quantity not available.Do you want to continue?'))
            {
                document.getElementById("txtReqQty").value = "0";
                document.getElementById('btnUpdateReqQty').click();
                document.getElementById("txtReqQty").focus();
                return false;
            }
        }
        
        if( document.getElementById("txtReqQty").value != "")
        {
            document.getElementById('btnUpdateReqQty').click();
        }
            
        
    }
    
    function UpdateSellPrice()
    {
        if(document.getElementById("txtSellPrice").value != document.getElementById("hidPrevPriceValue").value)
        {
            document.getElementById('btnUpdatePrice').click();
        }
        
        return false;
    }
    
    function CheckAvailabilityByLocation()
    {
        if( document.getElementById("txtPFCItemNo").value != "" &&
            document.getElementById("txtReqQty").value != "")
        {
            document.getElementById("btnCheckAvail").click();
        }
    }
    
    function AvailabilityAlter()
    {
        if(ShowYesorNo('Requested Quantity not available.Do you want to continue?'))
        {
            document.getElementById("ddlCarrierCd").focus();
        }
        else
        { 
           document.getElementById("txtReqQty").value = "0";
           document.getElementById('btnUpdateReqQty').click();
           document.getElementById("lblExtAmount").innerHTML = "0.00";
           document.getElementById("lblExtWght").innerHTML = "0.00";
           document.getElementById("txtReqQty").focus();
        }
    }
    </script>

    
    <script language="vbscript">
    Function ShowYesorNo(strMsg)
        Dim intBtnClick
        intBtnClick=msgbox(strMsg,vbyesno,"Sales Order Entry")
        if intBtnClick=6 then 
            ShowYesorNo= true 
        else 
            ShowYesorNo= false
         end if
    end Function
    </script>
</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';">
    <form id="form1" runat="server" defaultfocus="txtCustomerNumber">
        <asp:ScriptManager ID="scmSplitItem" AsyncPostBackTimeout="360000" EnablePartialRendering="true"
            runat="server">
        </asp:ScriptManager>
        <table border="0" cellpadding="0" cellspacing="2" class="HeaderPanels">
            <tr>
                <td width="100%" class="lightBg">
                    <asp:UpdatePanel ID="pnlEntry" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="2" cellspacing="0">
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="1" cellspacing="0">
                                            <tr>
                                                <td class="GridHead" style="padding-left: 5px;">
                                                    <asp:Label ID="Label4" runat="server" Text="Item #" Font-Bold="True" Width="95px"></asp:Label></td>
                                                <td class="GridHead">
                                                    <asp:Label ID="lblCuctomerCaption" runat="server" Font-Bold="True" Text="Customer Item #"
                                                        Width="100px"></asp:Label></td>
                                                <td class="GridHead">
                                                    <asp:Label ID="Label6" runat="server" Font-Bold="True" Text="Req'd Qty" Width="60px"></asp:Label></td>
                                                <td class="GridHead">
                                                    <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Base Qty/UOM" Width="60px"></asp:Label>
                                                </td>
                                                <td class="GridHead">
                                                    <asp:Label ID="Label7" runat="server" Font-Bold="True" Text="Avail. Qty" Width="60px"></asp:Label></td>
                                                <td width="165" class="GridHead">
                                                    <asp:Label ID="Label8" runat="server" Font-Bold="True" Text="Sell Price" Width="60px"></asp:Label></td>
                                                <td width="165" class="GridHead">
                                                    <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="Sell Unit" Width="50px"></asp:Label></td>
                                                <td width="165" class="GridHead">
                                                    <asp:Label ID="Label10" runat="server" Font-Bold="True" Text="PI" Width="30px"></asp:Label></td>
                                                <td width="165" class="GridHead">
                                                    <asp:Label ID="Label11" runat="server" Font-Bold="True" Text="Loc" Width="60px"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 5px;" height="30">
                                                    <asp:TextBox ID="txtPFCItemNo" runat="server" CssClass="lbl_whitebox" Width="85px"
                                                        onkeydown="javascript:javascript:if(event.keyCode==9){GetItemDetail(event)};"
                                                        onkeypress="javascript:GetItemDetail(event);"></asp:TextBox>
                                                    <asp:Button ID="btnPFCItem" runat="server" OnClick="btnPFCItem_Click" Style="display: none"
                                                        Text="" />
                                                    <asp:Button ID="btnCustItem" runat="server" OnClick="btnCustItem_Click" Style="display: none"
                                                        Text="" />
                                                    <asp:Button ID="btnItemNo" runat="server" OnClick="btnItemNo_Click" Style="display: none;"
                                                        Text="" />
                                                    <asp:HiddenField ID="hiPreviousItemNo" runat="server" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblCustItemNo" runat="server" Font-Bold="False" Font-Italic="False"
                                                        Width="90px"></asp:Label></td>
                                                <td valign="middle">
                                                    <asp:TextBox ID="txtReqQty" runat="server" CssClass="lbl_whitebox" Width="50px" AutoCompleteType="disabled"
                                                        onkeydown="javascript:if (event.keyCode==13 && this.value == '') {event.keyCode=9; return event.keyCode }if((event.keyCode==9 || event.keyCode==13 )&& (this.value != '') ){UpdateReqQty();return false;}"></asp:TextBox>
                                                    <asp:Button ID="btnUpdateReqQty" runat="server" Text="ReqQty" Style="display: none;"
                                                        OnClick="btnUpdateReqQty_Click" /></td>
                                                <td>
                                                    <asp:Label ID="lblBaseQtyUM" runat="server" Font-Bold="False" Font-Italic="False"
                                                        Width="60px"></asp:Label></td>
                                                <td>
                                                    <asp:Label ID="lblAvailQty" runat="server" Font-Bold="False" Font-Italic="False"
                                                        Width="60px"></asp:Label></td>
                                                <td valign="middle" width="165">
                                                    <asp:TextBox ID="txtSellPrice" runat="server" CssClass="lbl_whitebox" Width="50px"
                                                        onkeypress="return OnlyNumbers();" onkeydown="javascript:if (event.keyCode==13 && this.value == '') {event.keyCode=9; return event.keyCode }if((event.keyCode==9 || event.keyCode==13 )&& (this.value != '') ){UpdateSellPrice();}"></asp:TextBox>
                                                    <asp:Button ID="btnUpdatePrice" runat="server" Text="SellPrice" Style="display: none;"
                                                        OnClick="btnUpdatePrice_Click" />
                                                    <asp:HiddenField ID="hidPrevPriceValue" runat="server" /></td>
                                                <td width="165">
                                                    <asp:Label ID="lblSellUnit" runat="server" Font-Bold="False" Font-Italic="False"
                                                        Width="40px"></asp:Label></td>
                                                <td width="165">
                                                    <asp:Label ID="lblPriceInd" runat="server" Font-Bold="False" Font-Italic="False"
                                                        Width="30px"></asp:Label></td>
                                                <td valign="middle" width="165">
                                                    <asp:DropDownList ID="ddlShipLoc" CssClass="lbl_whitebox" Font-Bold="False" Height="20px"
                                                        onchange="CheckAvailabilityByLocation();" 
                                                        Width="125px" runat="server">
                                                    </asp:DropDownList>
                                                    <asp:Button ID="btnCheckAvail" runat="server" Text="CheckAvail" Style="display: none;"
                                                        OnClick="btnCheckAvail_Click" /></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" style="padding-top: 0px">
                                                    <asp:Label ID="lblDesc" runat="server" Font-Bold="False" Font-Italic="False" Width="280px"
                                                        Height="20px"></asp:Label>&nbsp;</td>
                                                <td>
                                                    <asp:HiddenField ID="hidItemChanged" runat="server" />
                                                    <asp:HiddenField ID="hidIsDeletedItem" runat="server" />
                                                    <asp:HiddenField ID="hidCostInd" runat="server" />
                                                    <asp:HiddenField ID="hidPriceCd" runat="server" />
                                                    <asp:HiddenField ID="hidNetUnitPrice" runat="server" />
                                                    <asp:HiddenField ID="hidListUnitPrice" runat="server" />
                                                    <asp:HiddenField ID="hidSellStkUM" runat="server" />
                                                    <asp:HiddenField ID="hidAvgCost" runat="server" />
                                                    <asp:HiddenField ID="hidStdCost" runat="server" />
                                                    <asp:HiddenField ID="hidRplCost" runat="server" />
                                                    <asp:HiddenField ID="hidOECost" runat="server" />
                                                    <asp:HiddenField ID="hidNetWght" runat="server" />
                                                    <asp:HiddenField ID="hidGrossWght" runat="server" />
                                                    <asp:HiddenField ID="hidSuperQty" runat="server" />
                                                    <asp:HiddenField ID="hidAltUM" runat="server" />
                                                    <asp:HiddenField ID="hidSuperUM" runat="server" />
                                                    <asp:HiddenField ID="hidSellStkQty" runat="server" />
                                                    <asp:HiddenField ID="hidAltUMQty" runat="server" />
                                                    <asp:HiddenField ID="hidParentDetailId" runat="server" />
                                                    <asp:HiddenField ID="hidItemPriceQty" runat="server" />
                                                    <asp:HiddenField ID="hidCertsReqd" runat="server" />
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="1" cellspacing="0" width="100%">
                                            <tr>
                                                <td class="GridHead" style="padding-left: 5px;">
                                                    <asp:Label ID="Label12" runat="server" Font-Bold="True" Text="Carrier Cd" Width="105px"></asp:Label></td>
                                                <td class="GridHead">
                                                    <asp:Label ID="Label13" runat="server" Font-Bold="True" Text="Freight Cd" Width="145px"></asp:Label></td>
                                                <td class="GridHead">
                                                    <asp:Label ID="Label14" runat="server" Font-Bold="True" Text="Extended Amt" Width="60px"></asp:Label></td>
                                                <td class="GridHead">
                                                    <asp:Label ID="Label15" runat="server" Font-Bold="True" Text="Extended Weight" Width="60px"></asp:Label></td>
                                                <td class="GridHead">
                                                    <asp:Label ID="Label2" runat="server" Text="Super Equiv." Font-Bold="True" Width="50px"></asp:Label></td>
                                                <td class="GridHead">
                                                    <asp:Label ID="Label17" runat="server" Font-Bold="True" Text="Sch Ship Dt" Width="70px"></asp:Label></td>
                                                <td class="GridHead">
                                                    <asp:Label ID="Label16" runat="server" Font-Bold="True" Text="Line Notes" Width="60px"></asp:Label></td>
                                                <td class="GridHead" style="width: 100px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 5px;" height="30">
                                                    <asp:DropDownList ID="ddlCarrierCd" runat="server" CssClass="lbl_whitebox" Width="100px"
                                                        Height="20px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlFreightCd" runat="server" CssClass="lbl_whitebox" Width="140px"
                                                        Height="20px">
                                                    </asp:DropDownList></td>
                                                <td>
                                                    <asp:Label ID="lblExtAmount" runat="server" Font-Bold="False" Font-Italic="False"
                                                        Width="65px" CssClass="lblControl"></asp:Label></td>
                                                <td colspan="1">
                                                    <asp:Label ID="lblExtWght" runat="server" Font-Bold="False" Font-Italic="False" Width="65px"
                                                        CssClass="lblControl"></asp:Label></td>
                                                <td colspan="1">
                                                    <asp:Label ID="lblSuperQty" runat="server" Font-Bold="False" Font-Italic="False"
                                                        Width="50px" CssClass="lblControl"></asp:Label></td>
                                                <td>
                                                    <asp:Label ID="lblSchShipDt" runat="server" Font-Bold="False" Font-Italic="False"
                                                        Width="60px" CssClass="lblControl"></asp:Label></td>
                                                <td colspan="2">
                                                    <asp:TextBox ID="txtLineNotes" runat="server" CssClass="lbl_whitebox" Width="130px"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td height="10">
                                                    </td>
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                                <td colspan="2">
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="right" style="padding-right: 5px;">
                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                        <tr>
                            <td align="left" style="padding-left: 10px">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td style="width: 100px">
                                            <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="true">
                                                <ProgressTemplate>
                                                    <span class="TabHead">Loading...</span></ProgressTemplate>
                                            </asp:UpdateProgress>
                                        </td>
                                        <td>
                                            <asp:UpdatePanel ID="pnlButton" runat="server" UpdateMode="conditional">
                                                <ContentTemplate>
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td width="600px">
                                                                <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label></td>
                                                            <td style="width: 10px;padding-right:5px;" align="right">
                                                                <asp:ImageButton ID="btnAddItem" runat="server" ImageUrl="~/Common/Images/AddItem.gif"
                                                                    OnClick="btnAddItem_Click1" /></td>
                                                            <td>
                                                            </td>
                                                            <td style="width: 10px;">
                                                                <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" /></td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
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
                    <uc2:Footer ID="Footer1" Title="Split Line" runat="server"></uc2:Footer>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
