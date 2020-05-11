<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GetCertsImg.aspx.cs" Inherits="GetCertsImg" %>

<%@ Register Src="UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>

<%@ Register Src="~/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc5" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>PFC Certificate</title>
    <link href="StyleSheet/styles.css" rel="stylesheet" type="text/css" />
    <script language ="javascript" >
     function OpenPrintDialog(itemNo,pfcLotNo,MfgLotNo)//,printDialogURL)
    {
        var Url = "PrintUtility.aspx?ItemNo="+ itemNo +"&MfgLotNo="+ MfgLotNo+"&PFCLotNo="+ pfcLotNo;
        window.open(Url,"PrintUtility" ,'height=320,width=650,scrollbars=yes,status=no,top='+((screen.height/2) - (320/2))+',left='+((screen.width/2) - (650/2))+',resizable=No',"");
    }
        
    function PrintReport(url)
    {
        var hwin=window.open(url, 'GetCerts', 'left=0,top=0,width=1,height=1,toolbar=0,scrollbars=0,status=0,resizable=NO',"");
        //var hwin=window.open(url, 'GetCerts', 'left=0,top=0,toolbar=0,scrollbars=0,status=0,resizable=yes',"");
        hwin.focus();
    }
     </script>
</head>
<body style="margin:2px">
    <form id="form1" runat="server">
        <div>
            <table cellpadding="2" style="border:1px solid #BAEBF4;" cellspacing="0" >
                <tr>
                    <td>
                        <table cellpadding="2" width="100%" cellspacing="0" style="background: #efefef;
                            font-weight: bold;">
                            <tr>
                                <td width=400px>
                                    <table cellpadding=3 cellspacing=3>
                                        <tr>
                                            <td style="width: 160px; padding-right: 5px;padding-left: 2px" align="left">
                                                <strong>Certification For PFC Part No: </strong>
                                            </td>
                                            <td style="padding-right: 3px; padding-left: 2px">
                                                <asp:Label ID="txtItemNumber" runat="server" Font-Bold="false"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td align="left" style="padding-right: 5px; padding-left: 2px">
                                                PFC Lot No:</td>
                                            <td style="padding-right: 3px; padding-left: 2px">
                                                <asp:Label ID="txtPFCLotNo" runat="server" Font-Bold="False"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td style=" padding-right: 5px; padding-left: 2px" align="left">
                                                <strong>MFG Lot No:</strong></td>
                                            <td style="padding-right: 3px; padding-left: 2px">
                                                <asp:Label ID="txtMfgLotNo" runat="server" Font-Bold="false"></asp:Label></td>
                                        </tr>
                                    </table>
                                </td> 
                                <td align="right" style="padding-right: 10px">
                                    <table>
                                        <tr>
                                            <td style="width: 80px" align="center">
                                                <asp:ImageButton ID="ibtnEmail" runat="server" ImageUrl="~/Common/Images/email.gif"
                                                    ToolTip="Click here to send eMail" OnClick="ibtnEmail_Click" />
                                            </td>
                                            <td style="width: 80px" align="center">
                                                <asp:ImageButton ID="ibtnPrint" runat="server" ImageUrl="~/Common/Images/PRINTImg.gif"
                                                    ToolTip="Click here to Print" OnClick="ibtnPrint_Click" />
                                            </td>
                                            <td align="right" style="padding-right: 10px">
                                                <img src="Common/Images/Close.gif" onclick="javascript:window.close();" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                
                    <td align=center>                        
                        <asp:GridView ID="gvCertificates" ShowHeader=false  AllowPaging=true runat="server" AutoGenerateColumns="False">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:HyperLink NavigateUrl='<%# DataBinder.Eval(Container,"DataItem.ImageURL")%>' Target=_blank ID="hplCertsImage" runat=server >
                                        <asp:Image ID="imgCerts" Width="600px" Height=580px  ImageUrl='<%# DataBinder.Eval(Container,"DataItem.ImageURL")%>' runat="server" /></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <PagerSettings Visible="False" />
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td style="background: #efefef;">
                        <uc1:pager ID="Pager1" OnBubbleClick="Pager_PageChanged" runat="server" />
                    </td>
                </tr>
                
                <tr>
                           
                <td >
                <table width=100%  cellpadding ="3" cellspacing="0"  style="line-height:30px;background:#efefef;">
                <tr>
                    <td colspan="3">
                        <input type="hidden" id="hidPageURL" runat="server" />
                        <input type="hidden" id="hidPageTitle" runat="server" />
                        <input type="hidden" id="hidCustomerNo" runat="server" />
                    </td>
                <td align ="right" valign= bottom style="width:85px;padding-right:10px">
                 <%--<uc5:PrintDialogue ID="PrintDialogue1" runat="server"></uc5:PrintDialogue>--%>
                   
                 </td>
                 </tr>
                 </table>
                </td>
              </tr>
            </table>
        </div>
   </form>
</body>
</html>
