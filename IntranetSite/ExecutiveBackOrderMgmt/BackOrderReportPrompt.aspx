<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BackOrderReportPrompt.aspx.cs"
    Inherits="BackOrderReportPrompt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Back Order Report Prompt</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
    function OpenReport(strItemNo,strType,location)
    {
        var Url =  "BackOrderReport.aspx?Type="+strType+"&ItemNo="+ strItemNo +"&Location="+location;  
        window.open(Url,"ReceiveReport" ,'height=650,width=958,scrollbars=yes,status=no,top='+((screen.height/2) - (625/2))+',left='+((screen.width/2) - (1038/2))+',resizable=No',"");
        //window.close();
    }
    
   
    </script>

    <style type="text/css">
.trHeight{height:30px;}

.BannerText1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;	
	font-weight:700;
	color: #ff0000;
	padding-right: 20px;
	padding-bottom: 5px;
}
</style>

    <script>
function CheckCrossReferenceNumber(itemNo,strCtrl)
{      
    if(itemNo!="")
    {
       var status =BackOrderReportPrompt.Getreference(itemNo).value;
       if(status !="true")
        {
            //document.getElementById("lblItemValid").innerText ="Requested item is not in the catalog1. Please reenter your request";
            switch(itemNo.split('-').length)
            {
               case 1:
                    event.keyCode=0;
                    itemNo = "00000" + itemNo;
                    itemNo = itemNo.substr(itemNo.length-5,5);
                    document.getElementById(strCtrl).value=itemNo+"-"; 
                    break;
                case 2:
                    // close if they are entering an empty part
                    //if (itemNo.split('-')[0] == "00000") {};
                    event.keyCode=0;
                    section = "0000" + itemNo.split('-')[1];
                    section = section.substr(section.length-4,4);
                    document.getElementById(strCtrl).value=itemNo.split('-')[0]+"-"+section+"-";  
                    break;
                case 3:
                    event.keyCode=0;
                    section = "000" + itemNo.split('-')[2];
                    section = section.substr(section.length-3,3);
                    document.getElementById(strCtrl).value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
                    completeItem=1;
                     //btnPFCItem.click();
                    break;
            }
        }    
    }
}    
    </script>

    <script>
function check(strValue,ctrlID)
{
    var status =BackOrderReportPrompt.chkItemNo(strValue).value;
    
       if(status =="false")
        {
          
          document.getElementById("lblmsg").style.display='block';
          document.getElementById(ctrlID).focus();
        }
        else
        {
         document.getElementById("lblmsg").style.display='none';
        }
}
    </script>

</head>
<body>
    <form id="form1" runat="server" defaultbutton="btnPrompt" defaultfocus="txtLPNNo">
        <table class="HeaderPanels" border="0" cellpadding="0" cellspacing="0" style="width: 100%;
            height: 200">
            <tr>
                <td class="PageHead" style="padding: 5px;">
                    <table border="0" cellpadding="3" cellspacing="0" width="100%">
                        <tr>
                            <td align="left" class="Left5pxPadd BannerText1">
                                Back Ordered Item Report - Summary
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr height="135px">
                <td style="vertical-align: top; padding-bottom: 5px; padding-top: 5px; padding-left: 10px;
                    background-color: White;">
                    <table cellpadding="0" cellspacing="0">
                        <tr>
                        <td></td>
                            <td >
                                <asp:Label ID="lblmsg" Font-Bold="true" Visible=false ForeColor="red" runat="server"></asp:Label></td>
                        </tr>
                        <tr class="trHeight">
                            <td>
                                <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Item Selection" Width="150px"></asp:Label>
                            </td>
                            <td>
                                <asp:DropDownList AutoPostBack="true" ID="ddlItemSelection" runat="server" Width="157px"
                                    CssClass="FormCtrl" OnSelectedIndexChanged="ddlItemSelection_SelectedIndexChanged">
                                    <asp:ListItem Text="-- ALL --" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Number Range" Value="2"></asp:ListItem>
                                    <asp:ListItem Text="Number" Value="3"></asp:ListItem>
                                </asp:DropDownList>
                               
                            </td>
                        </tr>
                        <tr class="trHeight" id="tblrange" runat="server" visible="false">
                            <td align="center" style="padding-left: 50px;">
                                <span style="color: Red;">* Item Number
                                    <br />
                                    -to-
                                    <br />
                                    * Item Number </span>
                            </td>
                            <td>
                                <asp:TextBox ID="txtItemRange1" runat="server" CssClass="FormCtrl" Width="150px"
                                    MaxLength="30"></asp:TextBox>
                                <asp:TextBox ID="txtItemRange2" runat="server" CssClass="FormCtrl" Width="150px"
                                    MaxLength="30"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="trHeight" id="tblItem" runat="server" visible="false">
                            <td align="center" style="padding-left: 50px;">
                                <span style="color: Red;">*Enter Item Number </span>
                            </td>
                            <td>
                                <asp:TextBox ID="txtItem" runat="server" CssClass="FormCtrl" Width="150px" MaxLength="30"></asp:TextBox>
                               
                                </td>
                        </tr>
                        <tr class="trHeight">
                            <td>
                                <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Ship Branch " Width="150px"></asp:Label>
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlLocation" runat="server" Width="157px" CssClass="FormCtrl">
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="padding-left: 10px" class="BluBg buttonBar Left5pxPadd">
                    <table cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="padding-left: 5px; padding-right: 3px" valign="top">
                                <img align="right" src="Common/Images/help.gif" style="cursor: hand;" />
                            </td>
                            <td style="padding-left: 5px;" valign="top">
                                <asp:ImageButton ImageUrl="~/WarehouseMgmt/Common/Images/btnClear.gif" runat="server"
                                    ID="btnClear" OnClick="btnClear_Click" />
                            </td>
                            <td width="40%">
                            </td>
                            <td style="padding-right: 5px;" valign="top" align="right">
                                <asp:ImageButton CausesValidation=false ImageUrl="~/WarehouseMgmt/Common/Images/ok.gif" runat="server" ID="btnPrompt"
                                    OnClick="btnPrompt_Click" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
