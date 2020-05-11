<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GetCertsExport.aspx.cs" Inherits="GetCertsImg" %>

<%@ Register Src="UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>

<%@ Register Src="~/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc5" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>PFC Certificate</title>
    <link href="StyleSheet/styles.css" rel="stylesheet" type="text/css" />
     <script src="JavaScript/Common.js"></script>
     <script language ="javascript" >
     
     
     </script>
</head>
<body style="margin:2px" onload="window.print();window.close();">
    <form id="form1" runat="server">
        <div>
            <table cellpadding="2" style="border:1px solid #BAEBF4;" cellspacing="0" >
                <tr>
                    <td>
                        <table cellpadding="2" width=100% cellspacing="0" style="line-height:35px;background:#efefef;font-weight:bold;">
                            <tr>
                                <td colspan="2" style="padding-right: 3px; padding-left: 2px; height: 26px">
                                    <strong>Certification For PFC Part No: </strong>
                                </td>
                                <td style="padding-right: 3px; padding-left: 2px; width: 80px; height: 26px">
                                    <asp:Label ID="txtItemNumber" runat="server" Font-Bold="False" Width="83px"></asp:Label></td>
                                <td style="height: 26px ;width:70px;padding-right:3px;padding-left:2px" align="center" > </td> 
                                    
                                <td >
                                    </td>
                                <td align=right style="padding-right:10px">
                                    
                                </td>
                            </tr>
                            <tr>
                                <td align="center" style="padding-right: 5px; width: 78px; height: 26px">
                                    PFC Lot No:</td>
                                <td style="padding-right: 3px; padding-left: 2px; width: 80px; height: 26px">
                                    <asp:Label ID="txtPFCLotNo" runat="server" Font-Bold="False" Width="80px"></asp:Label></td>
                                <td style="padding-right: 3px; padding-left: 2px; width: 80px; height: 26px">
                                    MFG Lot No:</td>
                                <td align="center" style="padding-right: 3px; padding-left: 2px; width: 70px; height: 26px">
                                    <asp:Label ID="txtMfgLotNo" runat="server" Font-Bold="False" Width="81px"></asp:Label></td>
                                <td>
                                </td>
                                <td align="right" style="padding-right: 10px">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                
                    <td style="width:500px;" >                        
                        <asp:GridView ID="gvCertificates" ShowHeader=false  AllowPaging=false runat="server" AutoGenerateColumns="False">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:Image ID="imgCerts" Width="800px" Height=500px  ImageUrl='<%# DataBinder.Eval(Container,"DataItem.ImageURL")%>' runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <PagerSettings Visible="False" />
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
   </form>   
</body>
</html>
