<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="ItemCard.aspx.cs"
    Inherits="ItemCard" %>

<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SOE Item Card</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script src="Common/JavaScript/Common.js"></script>

    <script>
//---------------------------------------------------------------------------------
var completeItem=1;

function ItemZItem(itemNo)
{
    if(itemNo!="")
    {
        var section="";        
        switch(itemNo.split('-').length)
        {
        case 1:
       
            event.keyCode=0;
            itemNo = "00000" + itemNo;
            itemNo = itemNo.substr(itemNo.length-5,5);
            document.getElementById("txtItemNumber").value=itemNo+"-"; 
            completeItem=0;     
            break;
        case 2:
            // close if they are entering an empty part
            if (itemNo.split('-')[0] == "00000") {ClosePage()};
            event.keyCode=0;
            section = "0000" + itemNo.split('-')[1];
            section = section.substr(section.length-4,4);
            document.getElementById("txtItemNumber").value=itemNo.split('-')[0]+"-"+section+"-";  
            completeItem=0;
            break;
        case 3:
            event.keyCode=0;
            section = "000" + itemNo.split('-')[2];
            section = section.substr(section.length-3,3);
            document.getElementById("txtItemNumber").value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
            completeItem=1;
            break;
        
        }
         if (completeItem==1) LoadItemCard();
    }
   
}

function BindItemNumber(txtItemNumber)
    {
        var itemNubmer = txtItemNumber.value;
        
        if(itemNubmer.substring(itemNubmer.length-1,itemNubmer.length) == "%") // Only after % symbol we need to display suggester
        {            
            if(event.keyCode==13)
            {
                document.getElementById("divSearch").style.display='none';
            }
            else
            {
                var ddlItemNumber = document.getElementById("lstItemNumber");
                var itemDetails=" ";
                var itemSearch=txtItemNumber.value;
               
                if(event.keyCode==40)
                    if(document.getElementById("divSearch").style.display=="")
                        ddlItemNumber.focus();
                         
                itemDetails=ItemCard.GetPFCItemNumbers(itemSearch).value;
                    
                var splitValue=itemDetails.split('`');
                ddlItemNumber.options.length = 0;
                
                if(splitValue.length>0 && itemDetails!="" && txtItemNumber.value !="")
                {
                    for(var i=0;i<splitValue.length-1;i++)
                    {
                        ddlItemNumber.options[ddlItemNumber.options.length] =  new Option(splitValue[i].toString(),splitValue[i].toString());
                    }
                    document.getElementById("divSearch").style.display="";
                }
                else
                    document.getElementById("divSearch").style.display='none';
            }
        }
        else if(event.keyCode==13 && completeItem == 1)
        {
            LoadItemCard();
            //ItemZItem(document.getElementById("txtItemNumber").value);
        }
        
    }

//---------------------------------------------------------------------------------
    function ShowDetail(ctrlID)
    {
        xstooltip_show('divToolTips',ctrlID);
        return false;
    }
//---------------------------------------------------------------------------------
    function xstooltip_show(tooltipId, parentId) 
    { 

        it = document.getElementById(tooltipId); 

        // need to fixate default size (MSIE problem) 
        img = document.getElementById(parentId); 
         
        x = xstooltip_findPosX(img); 
        y = xstooltip_findPosY(img); 
        
        if(y<469)
            it.style.top =  (y+15) + 'px'; 
        else
            it.style.top =  (y-50) + 'px'; 
            
        it.style.left =(x+10)+ 'px';

        // Show the tag in the position
          it.style.display = '';
     
    }
//---------------------------------------------------------------------------------
    function xstooltip_findPosY(obj) 
    {
        var curtop = 0;
        if (obj.offsetParent) 
        {
            while (obj.offsetParent) 
            {
                curtop += obj.offsetTop
                obj = obj.offsetParent;
            }
        }
        else if (obj.y)
            curtop += obj.y;
        return curtop;
    }

//---------------------------------------------------------------------------------
    function xstooltip_findPosX(obj) 
    {
      var curleft = 0;
      if (obj.offsetParent) 
      {
        while (obj.offsetParent) 
            {
                curleft += obj.offsetLeft
                obj = obj.offsetParent;
            }
        }
        else if (obj.x)
            curleft += obj.x;
        return curleft;
    }
//---------------------------------------------------------------------------------    
    function ShowPartImage()
    { 
      var PartSpecWindow;
      
        if (PartSpecWindow != null) {PartSpecWindow.close();}
        
        var Itemno = document.getElementById("lblItem").innerText;
        var Desc = document.getElementById("lblDescription").innerText;
         
        var queryString="ItemNumber="+Itemno+"&Itemdesc="+Desc;
        PartSpecWindow=window.open("EnlargePartImage.aspx?"+queryString,"PartImages",'height=300,width=600,toolbar=0,scrollbars=0,status=0,resizable=YES,top='+((screen.height/2) - (300/2))+',left='+((screen.width/2) - (600/2))+'','');    
    }
//---------------------------------------------------------------------------------    
    function LstItemNumberClick(ctrlID)
    {
        //document.getElementById("divSearch").style.display=="";
        //alert(ctrlID);
        var lstItemNumber=document.getElementById(ctrlID);
        var txtItemNumber=document.getElementById("txtItemNumber");
        txtItemNumber.value=lstItemNumber.options[lstItemNumber.selectedIndex].text;
       
        document.getElementById('divSearch').style.display='none';
        document.getElementById("hidItemNumber").value=lstItemNumber.value;       
        //alert(
        txtItemNumber.focus();

    }
//---------------------------------------------------------------------------------    
    
    
    function GetItemValues()
    { 
        ItemCard.GetItemLabelValues();
    
    }
    
    function LoadItemCard()
    {
       // var preValue=document.getElementById('CustDet_hidPreviousValue').value;
        //if(preValue!=SOEid)
        
        var str = document.getElementById("txtItemNumber").value;
        var pos=str.indexOf("%");
        if (pos ==-1)
        {
            var btnid=document.getElementById("btnLoadItem");
           
            if (typeof btnid == 'object')
            { 
                btnid.click();
                return false; 
            } 
            return;
        }
    }


    </script>

</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';" onmouseup="divToolTips.style.display='none';"  onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server" defaultbutton="btnLoadItem">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table border="0" class="HeaderPanels" cellpadding="0" cellspacing="0">
            <tr>
                <td class="lightBg">
                    <asp:UpdatePanel ID="pnlItemCard" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td valign="middle" class="SubHeaderPanels" style="padding-left: 4px; ">
                                        <asp:Panel ID="pnlSearch" runat="server">
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="height: 15px; padding-bottom: 5px; padding-left: 5px; padding-right: 5px;">
                                                        <asp:Label ID="lblLocation" runat="server" Text="Location " Font-Bold="True" Width="80px"></asp:Label>
                                                    </td>
                                                    <td style="height: 15px; padding-bottom: 5px; padding-left: 5px; padding-right: 5px;">
                                                        <asp:DropDownList ID="ddlLocation" CssClass="lbl_whitebox" Height="20px" Width="120px"
                                                            runat="server">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="ddlLocation"
                                                            Display="Dynamic" ErrorMessage="*Required" Width="52px"></asp:RequiredFieldValidator></td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px;" valign="top">
                                                        <asp:Label ID="lblItemNo" runat="server" Text="Item Number" Font-Bold="True" Width="80px"></asp:Label>
                                                    </td>
                                                    <td style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px;" valign="top">
                                                        <asp:TextBox ID="txtItemNumber"  AutoCompleteType="Disabled" onkeydown="javascript:if(event.keyCode==9 || event.keyCode==13){ItemZItem(this.value); return false;}" runat="server" CssClass="lbl_whitebox" Width="114px"
                                                              onkeyup="javascript:BindItemNumber(this);"></asp:TextBox>
                                                        <asp:HiddenField ID="hidItemNumber" runat="server" />
                                                        <div id="divSearch" style="position: absolute; display: none;" runat="server">
                                                            <asp:ListBox ID="lstItemNumber" onkeypress="javascript:if(event.keyCode==13){LstItemNumberClick(this.id);}"
                                                                onclick="Javascript:LstItemNumberClick(this.id);" runat="server" CssClass="FormCtrl list"
                                                                Width="125px" Height="150px" Style="left: -128px; top: 20px"></asp:ListBox>
                                                            <asp:Button ID="btnLoadItem" runat="server" OnClick="btnLoadItem_Click" Style="display: none"
                                                                Text="Load Item" />
                                                        </div>
                                                    </td>
                                                    <td valign="top">
                                                    
                                                        </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                    <td valign="bottom" class="SubHeaderPanels" width="100%" style="padding-left: 4px;">
                                        <table border="0" cellpadding="3" cellspacing="0" width="100%">
                                            <tr>
                                                <td width="50%">
                                                </td>
                                                <td valign="bottom" align="right">
                                                    <%--<td style="padding-left: 5px; height: 16px;">--%>
                                                    <asp:ImageButton ID="ibtnHelp" runat="server" ImageUrl="~/Common/Images/help.gif" />
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
                <td align="right">
                    <asp:UpdatePanel ID="pnlItemCardDisp" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table align="left">
                                <tr>
                                    <td align="left" class="lightBg">
                                        <table cellpadding="3" cellspacing="0" border="0">
                                            <tr>
                                                <td>
                                                    <table cellpadding="2" cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <asp:LinkButton ID="lnkItemNo" runat="server" Font-Underline="True" Text="Item No"
                                                                    TabIndex="13" Font-Bold="True"></asp:LinkButton>
                                                                <div id="divToolTips" class="list" style="display: none; position: absolute;" onmouseup="return false;">
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
                                                            <td colspan="2">
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td>
                                                                            <asp:Label ID="lblItem" runat="server" CssClass="lbl_whitebox" Width="210px"></asp:Label>
                                                                        </td>
                                                                        <td>
                                                                            <asp:UpdatePanel ID="CameraUpdatePanel" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                                                                <ContentTemplate>
                                                                                    <asp:Image ID="CameraButt" runat="server" Style="cursor: hand" onclick="javascript:ShowPartImage();"
                                                                                        alt="Show Part Image" ImageUrl="~/Common/Images/camera.gif" />
                                                                                </ContentTemplate>
                                                                            </asp:UpdatePanel>
                                                                <asp:Label ID="lblLoc" runat="server" CssClass="lbl_whitebox" Width="135px" Visible="false"></asp:Label></td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td>
                                                            <asp:Label ID="Label9" runat="server" Text="Item Status:" Font-Bold="True"></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblStatus" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label2" runat="server" Text="Description: " Font-Bold="True"></asp:Label></td>
                                                            <td colspan="2">
                                                                <asp:Label ID="lblDescription" runat="server" CssClass="lbl_whitebox" Width="210px"></asp:Label>
                                                            </td>
                                                            <td><asp:Label ID="Label10" runat="server" Text="Parent Item No:" Font-Bold="True"></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblParentItem" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label3" runat="server" Text="Category: " Font-Bold="True"></asp:Label></td>
                                                            <td colspan="2">
                                                                <asp:Label ID="lblCategory" runat="server" CssClass="lbl_whitebox" Width="210px"></asp:Label></td>
                                                            <td>
                                                                &nbsp;<asp:Label ID="Label11" runat="server" Text="Customs Traiff:" Font-Bold="True"></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblCustomTraiff" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label4" runat="server" Text="Alternate Item:" Font-Bold="True" Width="90px"></asp:Label>
                                                            </td>
                                                            <td colspan="2">
                                                                <asp:Label ID="lblAltItem" runat="server" CssClass="lbl_whitebox" Width="210px"></asp:Label></td>
                                                            <td>
                                                                &nbsp;<asp:Label ID="Label12" runat="server" Text="Stock Ind:" Font-Bold="True"></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblStock" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label5" runat="server" Text="Sell Stock UM:" Font-Bold="True"></asp:Label>
                                                            </td>
                                                            <td colspan="2">
                                                                <asp:Label ID="lblSell" runat="server" CssClass="lbl_whitebox" Width="210px"></asp:Label></td>
                                                            <td style="height: 14px">
                                                                &nbsp;<asp:Label ID="Label13" runat="server" Text="Commodity Code:" Font-Bold="True" Width="100px"></asp:Label></td>
                                                            <td style="height: 14px">
                                                                <asp:Label ID="lblCommodity" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 14px">
                                                                <asp:Label ID="Label6" runat="server" Text="Price UM:" Font-Bold="True"></asp:Label>
                                                            </td>
                                                            <td colspan="2" style="height: 14px">
                                                                <asp:Label ID="lblPriceUM" runat="server" CssClass="lbl_whitebox" Width="210px"></asp:Label></td>
                                                            <td>
                                                                &nbsp;<asp:Label ID="Label14" runat="server" Text="Weight:" Font-Bold="True"></asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblWeight" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label7" runat="server" Text="List Price:" Font-Bold="True"></asp:Label>
                                                            </td>
                                                            <td colspan="2">
                                                                <asp:Label ID="lblListPrice" runat="server" CssClass="lbl_whitebox" Width="210px"></asp:Label></td>
                                                            <td width="50">
                                                                </td>
                                                            <td width="50">
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label8" runat="server" Text="Average Cost:" Font-Bold="True"></asp:Label>
                                                            </td>
                                                            <td colspan="2">
                                                                <asp:Label ID="lblAvgCost" runat="server" CssClass="lbl_whitebox" Width="210px"></asp:Label></td>
                                                            <td>
                                                                </td>
                                                            <td>
                                                                </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="height: 220px" align=left>
                                        <table width="50%" align="center" class="HeaderPanels" border="0" cellpadding="2"
                                            cellspacing="0">
                                            <tr>
                                                <td colspan="2" align="center" class="lightBg">
                                                    <strong>
                                                    Dimensions</strong>
                                                </td>
                                            </tr>
                                            <tr>
                                            <td  class="lightBg">
                                                <table border=0 cellpadding=0 cellspacing=5>
                                                <tr>
                                                <td width="150px">
                                                    <strong>
                                                    Height: </strong>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblHeight" runat="server" CssClass="lbl_whitebox" Width="60px"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td width="150px">
                                                    <strong>
                                                    Width: </strong>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblWidth" runat="server" CssClass="lbl_whitebox" Width="60px"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="150px">
                                                    <strong>
                                                    Depth:</strong>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblDepth" runat="server" CssClass="lbl_whitebox" Width="60px"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="150px">
                                                    <strong>
                                                    Cube: </strong>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblCube" runat="server" CssClass="lbl_whitebox" Width="60px"></asp:Label>
                                                </td>
                                            </tr>
                                                </table>
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
                <td align="right" width="100%" id="tdButton" class="commandLine splitborder_t_v splitborder_b_v"
                    style="height: 20px; background-position: -80px  left;">
                    <asp:UpdatePanel ID="upMessage" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="padding-left:5px;" align="left" width="89%">
                                        <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="true">
                                            <ProgressTemplate>
                                                <span class="TabHead">Loading...</span></ProgressTemplate>
                                        </asp:UpdateProgress>
                                        <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                    </td>
                                    <td>
                                        <uc5:PrintDialogue ID="PrintDialogue1" runat="server"></uc5:PrintDialogue>
                                    </td>
                                    <td>
                                        <input type="hidden" id="hidPrintURL" runat="server" /></td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="right" style="padding-right: 5px;">
                    <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" /></td>
                <td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="Footer1" Title="Item Card" runat="server"></uc2:Footer>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
