<%@ Page Language="C#" AutoEventWireup="true"  EnableEventValidation="false"  CodeFile="ItemCardExport.aspx.cs" Inherits="ItemCard" %>
<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>SOE Item Card</title>
    
    <link href="http://206.72.71.194/SOE/Common/StyleSheet/printstyles.css" rel="stylesheet" type="text/css" />
    
    
   <script>
   
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
        PartSpecWindow=window.open("ShowPartImage.aspx?"+queryString,"PartImages",'height=300,width=600,toolbar=0,scrollbars=0,status=0,resizable=YES,top='+((screen.height/2) - (300/2))+',left='+((screen.width/2) - (600/2))+'','');    
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
        
        if(event.keyCode == 53) // Only after % symbol we need to display suggester
        {
        
            if(event.keyCode==13)
                document.getElementById("divSearch").style.display='none';
            
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
    }
    
    function GetItemValues()
    { 
        ItemCard.GetItemLabelValues();
    
    }
    
    function CallBtnClick(id)
    {
        
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

<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table class="PageBg" border="1" cellpadding="0" cellspacing="0" style="height: 100%">
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
                <td class="lightBg" >
                    <asp:UpdatePanel ID="pnlItemCard" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td valign="bottom" class="SubHeaderPanels" style="padding-left: 4px; padding-top: 5px"
                                        width="35%">
                                        <asp:Panel ID="pnlSearch" runat="server">
                                            <table border="0" cellpadding="3" cellspacing="0">
                                                <tr>
                                                    <td style="height: 27px; padding-bottom: 5px; padding-left: 5px; padding-right: 5px;">
                                                        <asp:Label ID="lblLocation" runat="server" Text="Location " Font-Bold="True" Width="100px"></asp:Label>
                                                    </td>
                                                    <td style="height: 27px; padding-bottom: 5px; padding-left: 5px; padding-right: 5px;">
                                                        <asp:Label ID="ddlLocation" CssClass="lbl_whitebox" Height="20px" Width="120px" runat="server">
                                                        </asp:Label>
                                                    </td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px;" valign="top">
                                                        <asp:Label ID="lblItemNo" runat="server" Text="Item Number" Font-Bold="True" Width="100px"></asp:Label>
                                                    </td>
                                                    <td style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px;" valign="top">
                                                        <asp:Label ID="txtItemNumber" runat="server" CssClass="lbl_whitebox" Width="114px"></asp:Label>
                                                        <asp:HiddenField ID="hidItemNumber" runat="server" />
                                                    </td>
                                                    <td valign="top">
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                  
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr >
                <td align="Left" valign="top">
                    <asp:UpdatePanel ID="pnlItemCardDisp" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table>
                                <tr>
                                    <td width="75%" style="height: 150px" class="lightBg" valign="top">
                                       
                                                    <table cellpadding="2" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td>
                                                                <asp:Label Font-Bold="True" ID="lnkItemNo" runat="server" Text="Item No" TabIndex="13"></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblItem" runat="server" CssClass="lbl_whitebox" Width="135px"></asp:Label></td>
                                                            <td width="50px">
                                                                <asp:UpdatePanel ID="CameraUpdatePanel" runat="server" UpdateMode="Conditional">
                                                                    <ContentTemplate>
                                                                        <%--<asp:Image ID="CameraButt" runat="server" style="cursor: hand" onclick="javascript:ShowPartImage();" 
                                    alt="Show Part Image" ImageUrl="~/Common/Images/camera.gif"/>&nbsp;&nbsp;--%>
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lbl1" Font-Bold="True" runat="server">  Item Status:</asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblStatus" runat="server" CssClass="lbl_whitebox" Width="135px"></asp:Label>
                                                                <asp:Label ID="lblLoc" runat="server" CssClass="lbl_whitebox" Width="135px" Visible="false"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label1" Font-Bold="True" runat="server"> Description: </asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblDescription" runat="server" CssClass="lbl_whitebox" Width="175px"></asp:Label>
                                                            </td>
                                                            <td width="50px">
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="Label2" Font-Bold="True" runat="server"> Parent Item No: </asp:Label></td>
                                                            <td>
                                                                <asp:Label ID="lblParentItem" runat="server" CssClass="lbl_whitebox" Width="135px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label3" Font-Bold="True" runat="server">  Category: </asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblCategory" runat="server" CssClass="lbl_whitebox" Width="135px"></asp:Label></td>
                                                            <td width="50px">
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="Label4" Font-Bold="True" runat="server">  Customs Traiff:</asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblCustomTraiff" runat="server" CssClass="lbl_whitebox" Width="135px"> </asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label5" Font-Bold="True" runat="server">  Alternate Item:</asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblAltItem" runat="server" CssClass="lbl_whitebox" Width="135px"> </asp:Label></td>
                                                            <td width="50px">
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="Label6" Font-Bold="True" runat="server">  Stock Ind: </asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblStock" runat="server" CssClass="lbl_whitebox" Width="135px"> </asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label7" Font-Bold="True" runat="server">  Sell Stock UM: </asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblSell" runat="server" CssClass="lbl_whitebox" Width="135px"> </asp:Label></td>
                                                            <td width="50px">
                                                            </td>
                                                            <td style="height: 14px">
                                                                <asp:Label ID="Label8" Font-Bold="True" runat="server">  Commodity Code:</asp:Label>
                                                            </td>
                                                            <td style="height: 14px">
                                                                <asp:Label ID="lblCommodity" runat="server" CssClass="lbl_whitebox" Width="135px"> </asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 14px">
                                                                <asp:Label ID="Label9" Font-Bold="True" runat="server">  Price UM: </asp:Label>
                                                            </td>
                                                            <td style="height: 14px">
                                                                <asp:Label ID="lblPriceUM" runat="server" CssClass="lbl_whitebox" Width="135px"> </asp:Label></td>
                                                            <td width="50px" style="height: 14px">
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="Label10" Font-Bold="True" runat="server">  Weight: </asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblWeight" runat="server" CssClass="lbl_whitebox" Width="135px"> </asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label17" Font-Bold="True" runat="server">  List Price: </asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblListPrice" runat="server" CssClass="lbl_whitebox" Width="135px"> </asp:Label></td>
                                                            <td width="50px">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label11" Font-Bold="True" runat="server">   Average Cost: </asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblAvgCost" runat="server" CssClass="lbl_whitebox" Width="135px"> </asp:Label></td>
                                                        </tr>
                                                    </table>
                                         
                                    </td>
                                    <td width="25%" style="height: 150px" valign="top">
                                        <table width="50%" align="center" class="HeaderPanels" border="0" cellpadding="2"
                                            cellspacing="0">
                                            <tr>
                                                <td colspan="2" align="center">
                                                    <asp:Label ID="Label12" Font-Bold="True" runat="server"> Dimensions </asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td width="150px">
                                                    <asp:Label ID="Label13" Font-Bold="True" runat="server"> Height: </asp:Label></td>
                                                <td>
                                                    <asp:Label ID="lblHeight" runat="server" CssClass="lbl_whitebox" Width="100px"> </asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td width="150px">
                                                    <asp:Label ID="Label14" Font-Bold="True" runat="server">  Width: </asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblWidth" runat="server" CssClass="lbl_whitebox" Width="100px"> </asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="150px">
                                                    <asp:Label ID="Label15" Font-Bold="True" runat="server"> Depth: </asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblDepth" runat="server" CssClass="lbl_whitebox" Width="100px"> </asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="150px">
                                                    <asp:Label ID="Label16" Font-Bold="True" runat="server">  Cube: </asp:Label></td>
                                                <td>
                                                    <asp:Label ID="lblCube" runat="server" CssClass="lbl_whitebox" Width="100px"> </asp:Label>
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
                <td class="lightBg" style="border-collapse: collapse;">
                    <div class="blueBorder">
                    </div>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
