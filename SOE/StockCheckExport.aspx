<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StockCheckExport.aspx.cs" Inherits="StockCheck" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Customer Stock Check </title>
     <link href="http://206.72.71.194/SOE/Common/StyleSheet/printstyles.css" rel="stylesheet" type="text/css" />
     <script >
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
        var Desc = document.getElementById("lblDesc").innerText;
         
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
                         
                itemDetails=StockCheck.GetPFCItemNumbers(itemSearch).value;
                    
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
        else if(event.keyCode==13)
        {
            LoadItemCard();
        }
        
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
        <table border="0" cellpadding="0" cellspacing="0" class="PageBg">
        <tr>
                <td bgcolor="white" style="padding-right: 0px; padding-left: 0px; padding-bottom: 0px;
                    height: 70px; padding-top: 0px">
                    <asp:Image ID="imglogo" runat="server" ImageUrl="http://206.72.71.194/SOE/Common/Images/PFC_logo.gif" /></td>
            </tr>
             <tr>
                <td style="padding-right: 5px; padding-left: 5px; padding-bottom: 5px; padding-top: 5px">
                </td>
            </tr>
            <tr>
                <td  >
                    <asp:UpdatePanel ID="upnlStock" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" width ="100%">
                                <tr>
                                    <td  class="SubHeaderPanels" style="padding-left: 4px; " valign="top" >
                                        <asp:Panel ID="pnlSearch" runat="server">
                                            <table border="0" cellpadding="0" cellspacing="0" >
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
                                                        <asp:Label ID="lblItemNo" runat="server" Text="Item Number" Font-Bold="True" Width="90px"></asp:Label>
                                                    </td>
                                                    <td style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px;" valign="top">
                                                        <asp:TextBox ID="txtItemNumber"  runat="server" CssClass="lbl_whitebox" Width="114px"
                                                        onkeydown="javascript:if(event.keyCode==9){ItemZItem(this.value); return false;}"  onkeyup="javascript:BindItemNumber(this);" >
                                                        </asp:TextBox>
                                                        <asp:HiddenField ID="hidItemNumber" runat="server" />
                                                        <div id="divSearch" style="position: absolute; display: none;" runat="server">
                                                            <asp:ListBox ID="lstItemNumber" onkeypress="javascript:if(event.keyCode==13){LstItemNumberClick(this.id);}"
                                                                onclick="Javascript:LstItemNumberClick(this.id);" runat="server" CssClass="FormCtrl list"
                                                                Width="125px" Height="150px" Style="left: -128px; top: 20px"></asp:ListBox>
                                                            <asp:Button ID="btnLoadItem" runat="server"  Style="display: none"
                                                                Text="Load Item" OnClick="btnLoadItem_Click" />
                                                        </div>
                                                    </td>
                                                    <td valign="top">
                                                    
                                                        </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                    
                                    <td style="padding-left: 4px; " class="SubHeaderPanels" width="70%" >
                                    
                                    <table border="0" cellpadding="3" cellspacing="0" width="100%" >
                                        <tr>
                                            <td colspan ="3"  >
                                                <table cellpadding="0" cellspacing="0">
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
                                                        <td style="padding-left :20px">
                                                            <asp:Label ID="lblItem" runat="server" CssClass="lbl_whitebox" Width="150px"></asp:Label>
                                                        </td>
                                                        <td >
                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td>
                                                                        &nbsp;</td>
                                                                    <td style ="padding-left :15px">
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
                                                        </tr>
                                                         <tr  >
                                                <td style="font-weight:bold ;height :15px" >
                                                     Description :</td>
                                                <td colspan ="2" align="left" style="height :15px ;padding-left :15px">
                                                       
                                                    <asp:Label ID="lblDesc" runat="server" CssClass="lbl_whitebox"></asp:Label></td>
                                            </tr>
                                             <tr height ="15px">
                                                <td style="font-weight:bold; height:15px" >
                                                     Vendor :</td>
                                                <td colspan ="2" align="left" style="height :15px;padding-left:15px " >
                                                    <asp:Label ID="lblVendor" runat="server" CssClass="lbl_whitebox"></asp:Label></td>
                                                   
                                            </tr>
                                                        </table>
                                            </td>
                                        </tr>
                                        
                                            <tr>
                                             <td valign="bottom" align="right" colspan ="3" >
                                                    <%--<td style="padding-left: 5px; height: 16px;">--%>
                                                    <asp:ImageButton ID="imgHelp" runat="server" ImageUrl="~/Common/Images/help.gif" />
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
                <td style="vertical-align: top;"
                    class="commandLine splitborder_t_v splitborder_b_v" colspan="2" >
                    <asp:UpdatePanel ID="upnlVendor" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table cellpadding="2" cellspacing="0" >
                                <tr>
                                    <td height="20">
                                        <asp:Label ID="Label1" runat="server" Text="Vendor Codes:" Font-Bold="True" Width="80px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblVendorCode" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td style="width: 15px">
                                    </td>
                                    <td >
                                        <asp:Label ID="Label2" runat="server" Text="Mo Avg Sales:" Font-Bold="True" Width="100px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblMoAvGSales" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label>
                                    </td>
                                    <td style="width: 15px">
                                    </td>
                                    <td > 
                                        <asp:Label ID="Label11" runat="server" Text=" Replace Cost:" Font-Bold="True" Width="100px"></asp:Label>
                                    </td>
                                    <td >
                                        <asp:Label ID="lblReplaceCost" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td style="width: 15px">
                                    </td>
                                    <td rowspan ="4" colspan ="2" valign ="top" >
                                    <table cellpadding ="1" cellspacing ="0"   >
                                    <tr>
                                    <td align ="center" >
                                       <asp:Label ID="Label3" runat="server" Text="Warnings" Font-Bold="True" Width="60px"></asp:Label>
                                    </td>
                                    </tr>
                                    <tr>
                                    <td>
                                        <asp:Label ID="lblWarnings1" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                               
                                   
                                    </tr>
                                    </table>
                                     </td>
                                      </tr>
                            <tr>
                                    <td >
                                        <asp:Label ID="Label4" runat="server" Text=" Cat:" Font-Bold="True" Width="80px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblCat" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label5" runat="server" Text="Cur Usage:" Font-Bold="True" Width="100px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblCurUsage" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label>
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label6" runat="server" Text="DD:" Font-Bold="True" Width="100px"></asp:Label>
                                    </td>
                                    <td >
                                        <asp:Label ID="lblDD" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <%--<%--<td>
                                    </td>
                                    <td>
                                   
                                    </td>
                                    <td>
                                  </td>--%>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label8" runat="server" Text="Corp:" Font-Bold="True" Width="80px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblCorp" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label9" runat="server" Text="Last Mo Usage:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblLastMoUsage" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label10" runat="server" Text="LT:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblLT" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td>
                                    </td>
                                 <%--   <td>
                                    </td>
                                    <td>
                                    </td>--%>
                                </tr>
                                <tr>
                                    <td style="width: 74px" class="splitborder_b_v" height="30" valign="top">
                                        <asp:Label ID="Label13" runat="server" Text="Sales:" Font-Bold="True" Width="80px"></asp:Label></td>
                                    <td class="splitborder_b_v" valign="top">
                                        <asp:Label ID="lblSales" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td class="splitborder_b_v">
                                        &nbsp;</td>
                                    <td valign="top">
                                        <asp:Label ID="Label14" runat="server" Text="Buyer:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td valign="top">
                                        <asp:Label ID="lblBuyer" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    <%--</td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>--%>
                                </tr>
                                <tr>
                                    <td class="splitborder_t_v " style="width: 74px; height: 26px;">
                                        <asp:Label ID="Label15" runat="server" Text="Sell UM:" Font-Bold="True" Width="80px"></asp:Label></td>
                                    <td class="splitborder_t_v " style="height: 26px">
                                        <asp:Label ID="lblSellUM" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td class="splitborder_t_v " style="height: 26px">
                                        &nbsp;</td>
                                    <td class="splitborder_t_v " style="height: 26px">
                                        <asp:Label ID="Label16" runat="server" Text="Cost Per UM:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td class="splitborder_t_v " style="height: 26px">
                                        <asp:Label ID="lblCostUM" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td class="splitborder_t_v  " style="height: 26px">
                                    </td>
                                    <td class="splitborder_t_v  " style="height: 26px">
                                        <asp:Label ID="Label17" runat="server" Text="OAQ:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td class="splitborder_t_v " style="height: 26px">
                                        <asp:Label ID="lblOAQ" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td class="splitborder_t_v " style="height: 26px">
                                    </td>
                                    <td class="splitborder_t_v " style="height: 26px">
                                        <asp:Label ID="Label18" runat="server" Text="EDQ:" Font-Bold="True" Width="60px"></asp:Label></td>
                                    <td class="splitborder_t_v " style="height: 26px">
                                        <asp:Label ID="lblEDQ" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td style="width: 74px">
                                        <asp:Label ID="Label19" runat="server" Text="Price:" Font-Bold="True" Width="80px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblPrice" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label20" runat="server" Text=" Std Cost:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblStdCost" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label21" runat="server" Text=" Mstr Ctrn:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblMstrCtrn" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label22" runat="server" Text="MOQ:" Font-Bold="True" Width="60px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblMOQ" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td style="width: 74px">
                                        <asp:Label ID="Label12" runat="server" Text="Sell Basis:" Font-Bold="True" Width="80px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblSellBasis" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label25" runat="server" Text=" Cost Basis:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblCostBasis" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label27" runat="server" Text="OPQ:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblOPQ" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label29" runat="server" Text="BrkPt:" Font-Bold="True" Width="60px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblBrkPt" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td colspan="5">
                                       
                                        &nbsp;</td>
                                    <td>
                                        &nbsp;</td>
                                   
                                   
                                    <td>
                                        <asp:Label ID="Label31" runat="server" Text="Planner:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblPlanner" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label33" runat="server" Text="O/R Rev Dt:" Font-Bold="True" Width="60px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblORRevDt" runat="server" CssClass="lbl_whitebox" Width="90px"></asp:Label></td>
                                
                                    
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="commandLine splitborder_t_v splitborder_b_v"  colspan ="2">
                    <table cellpadding="2" cellspacing="0" >
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="upnlStockGrid" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div class="Sbar" oncontextmenu="Javascript:return false;" id="div-datagrid" style="overflow-x: hidden;
                                            overflow-y: auto; position: relative; top: 0px; left: 0px; height: 220px; border: 1px solid #88D2E9;
                                            width: 650px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                            scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                            scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94">
                                            <asp:GridView  UseAccessibleHeader="true" ID="gvStock" PagerSettings-Visible="false"
                                                Width="650" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="true"
                                                AutoGenerateColumns="false"    ShowFooter="True" OnSorting="gvStock_Sorting">
                                                <HeaderStyle HorizontalAlign="Center" CssClass="GridHead" Font-Bold="True" BackColor="#DFF3F9" Height="20px" />
                                                <FooterStyle Font-Bold="True" VerticalAlign="Top" HorizontalAlign="Right" />
                                                <RowStyle CssClass="item" Wrap="False" BackColor="White" Height="25px" BorderWidth="1px" />
                                                <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="25px" BorderWidth="1px" />
                                                <Columns>
                                                <%--    <asp:TemplateField HeaderText="ASN/LPN No" >
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblControlId" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"pASNControlID") %>'></asp:Label>
                                                            <asp:HiddenField ID="hidControlId" runat="server" />
                                                            <asp:LinkButton ID="lnlASNNo" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                                 Style="padding-left: 5px"
                                                                runat="server" CommandName="BindDetails" ></asp:LinkButton>
                                                        </ItemTemplate>
                                                         <FooterStyle HorizontalAlign="Right" />
                                                        <ItemStyle Width="90px" />
                                                    </asp:TemplateField>--%>
                                                    <asp:BoundField HeaderText="Loc" DataField="Location" SortExpression="Location">
                                                        <ItemStyle HorizontalAlign="Left" Width="70px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="On Hand" DataField="On Hand" SortExpression="On Hand">
                                                        <ItemStyle HorizontalAlign="Left" Width="90px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Allocated" DataField="Allocated" SortExpression="Allocated">
                                                        <ItemStyle HorizontalAlign="Left" Width="90px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Back Order" DataField="Back Order" SortExpression="Back Order">
                                                        <ItemStyle HorizontalAlign="Left" Width="90px" CssClass="Left5pxPadd" />
                                                        <FooterStyle HorizontalAlign="Right" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Available" DataField="Available" SortExpression="Available">
                                                        <ItemStyle HorizontalAlign="Left" Width="60px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                     <asp:BoundField HeaderText="On Order" DataField="On Order" SortExpression="On Order">
                                                        <ItemStyle HorizontalAlign="Left" Width="70px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                     <asp:BoundField HeaderText="In Transist" DataField="Transist" SortExpression="Transist">
                                                        <ItemStyle HorizontalAlign="Left" Width="70px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Avail/Order" DataField="Avail/Order" SortExpression="Avail/Order">
                                                        <ItemStyle HorizontalAlign="Left" Width="80px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    
                                                     <asp:BoundField HeaderText="90" DataField="" SortExpression="">
                                                        <ItemStyle HorizontalAlign="Left" Width="70px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    
                                                </Columns>
                                                <PagerSettings Visible="False" />
                                            </asp:GridView>
                                            <input id="hidSortStockGrid" type="hidden" name="Hidden1" runat="server">
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdatePanel ID="upnlLocationGrid" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div class="Sbar" oncontextmenu="Javascript:return false;" id="div1" style="overflow-x: hidden;
                                            overflow-y: scroll; position: relative; top: 0px; left: 0px; height: 220px; border: 1px solid #88D2E9;
                                            width: 163px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                            scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                            scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94" >
                                            <table cellpadding="0" cellspacing="0" class="blueBorder" style="border-collapse: collapse">
                                                <tr>
                                                    <td style="height: 22px" class="lightBlueBg">
                                                        <asp:CheckBox ID="chkSelectAll" runat="server" Text="Locations" Width="140px" AutoPostBack="True"
                                                             CssClass="GridHead" Font-Bold="True" BackColor="#DFF3F9"
                                                             OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="blueBorder" style="padding-top: 1px; height: 138px;" valign ="top" >
                                                        <asp:CheckBoxList ID="chkSelection" runat="server" Width ="140px" CssClass="item"  AutoPostBack="True" RepeatColumns ="1" OnSelectedIndexChanged="chkSelection_SelectedIndexChanged">
                                                        </asp:CheckBoxList>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            </table>
    </form>
</body>
</html>
