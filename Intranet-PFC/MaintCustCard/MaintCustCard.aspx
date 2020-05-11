<%@ Page Language="VB" AutoEventWireup="true"  CodeFile="MaintCustCard.aspx.vb" Inherits="_MaintCustCard" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>PFC Customer Card Maintenance</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script language="javascript" src="javascript/ContextMenu.js"></script>
    <script language="javascript" src="javascript/browsercompatibility.js"></script>
    <script language="javascript">

    function LoadHelp()
        {
        window.open('Help.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
        }
    
    function DispCurVal(field)
        {
            if (document.getElementById('<%=CustLabel.ClientID%>').Value != "Original Value:")
            {
                document.getElementById('<%=CustLabel.ClientID%>').innerHTML = "Original Value:";
            }
            switch (field) {
                case 'ddUseLoc': document.getElementById('<%=Curval.ClientID%>').innerHTML = document.getElementById('<%=OGUseLoc.ClientID%>').value; break;
                case 'ddShipLoc': document.getElementById('<%=Curval.ClientID%>').innerHTML = document.getElementById('<%=OGShipLoc.ClientID%>').value; break;                
                case 'ddShipPayType': document.getElementById('<%=Curval.ClientID%>').innerHTML = document.getElementById('<%=OGPayType.ClientID%>').value; break; 
                case 'ddFreeFrt': document.getElementById('<%=Curval.ClientID%>').innerHTML = document.getElementById('<%=OGFreeFrt.ClientID%>').value; break;                
                case 'ddBackorder': document.getElementById('<%=Curval.ClientID%>').innerHTML = document.getElementById('<%=OGBackorder.ClientID%>').value; break;
                case 'ddShipAgent': document.getElementById('<%=Curval.ClientID%>').innerHTML = document.getElementById('<%=OGShipAgent.ClientID%>').value; break;
                case 'ddEShipAgent': document.getElementById('<%=Curval.ClientID%>').innerHTML = document.getElementById('<%=OGEShip.ClientID%>').value; break;                
                case 'ddShipMeth': document.getElementById('<%=Curval.ClientID%>').innerHTML = document.getElementById('<%=OGShipMeth.ClientID%>').value; break;                
                case 'txtPriceCode': document.getElementById('<%=Curval.ClientID%>').innerHTML = document.getElementById('<%=OGPriceCode.ClientID%>').value; break;
                case 'ddPriceGroup': document.getElementById('<%=Curval.ClientID%>').innerHTML = document.getElementById('<%=OGPriceGroup.ClientID%>').value; break;
                case 'ddDiscGroup': document.getElementById('<%=Curval.ClientID%>').innerHTML = document.getElementById('<%=OGDiscGroup.ClientID%>').value; break;
                case 'ddInsideSales': document.getElementById('<%=Curval.ClientID%>').innerHTML = document.getElementById('<%=OGInsideSales.ClientID%>').value; break;
                case 'ddChain': document.getElementById('<%=Curval.ClientID%>').innerHTML = document.getElementById('<%=OGChain.ClientID%>').value; break;
                default: document.getElementById('<%=Curval.ClientID%>').innerHTML = "";
            }
        }
   
    </script>

</head>
<body>
    <form id="form1" runat="server" defaultbutton="btnNext">
        <table width="100%">
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="5" height="97" valign="top" class="BannerBg">
                                <div width="100%" class="bannerImg">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="100%" valign="top" style="height: 100%">
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td class="PageHead" style="height: 40px" width="75%">
                                            <div class="LeftPadding">
                                                <div align="left" class="BannerText">
                                                    PFC Customer Card Maintenance
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <tr>
                                    <td colspan="2">
                                        <table border="0" cellspacing="0" cellpadding="3" width="600">
                                            <tr>
                                                <td style="width: 75px">
                                                    <span class="LeftPadding" style="width: 100px;">Customer #</span></td>
                                                <td colspan="2">
                                                    <asp:TextBox ID="txtCustNo" runat="server" MaxLength="10" Width="100px" TabIndex="16" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="BluBg">
                    <div class="LeftPadding">
                        <span class="LeftPadding" style="vertical-align: middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:ImageButton ID="btnNext" TabIndex="17" runat="server" Style="cursor: hand" ImageUrl="images/Next.gif" />&nbsp;
                            <img src="Images/help.gif" TabIndex="18" onclick="LoadHelp();" style="cursor: hand" />
                        </span>
                    </div>
                </td>
            </tr>
            <% If IsPostBack Then%>
            <tr>
                <td colspan="2">
                    <br />
                    <asp:Label ID="lblCustNo" Text="Customer Number" runat="server" Font-Bold="True" Font-Size="Medium" /><br />
                    <asp:Label ID="lblCustDesc" Text="Description" runat="server" Font-Bold="True" Font-Size="X-Large" /><br />
                    <% If lblCustDesc.Text <> "Customer Not On File" Then%>
                    <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0"
                        style="height: 100px">
                        <tr>
                            <td valign="top" width="100%" style="height: 150px">
                                <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px;
                                    left: 5px; width: 1000px; height: 335px; border: 0px solid;">
                                    <table border="0" cellspacing="1" style="width: 99%">
                                        <col width="10%" />
                                        <col width="20%" />
                                        <col width="10%" />
                                        <col width="20%" />
                                        <col width="10%" />
                                        <col width="20%" />
                                        <tr>
                                            <td style="width: 7%"></td>
                                            <td style="width: 17%"></td>
                                            <td style="width: 8%"></td>
                                            <td style="width: 32%"></td>
                                            <td style="width: 8%"></td>
                                            <td style="width: 32%"></td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="width: 7%"><br />Use Loc:&nbsp&nbsp&nbsp</td>
                                            <td style="width: 17%"><br /><asp:DropDownList onFocus="DispCurVal('ddUseLoc')" ID="ddUseLoc" Width="150" runat="server" TabIndex="1"></asp:DropDownList></td>
                                            <td align="right" style="width: 8%"><br />Backorder:&nbsp&nbsp&nbsp</td>
                                            <td style="width: 32%"><br /><asp:DropDownList onFocus="DispCurVal('ddBackorder')" ID="ddBackorder" Width="180" runat="server" TabIndex="5">
                                                <asp:ListItem Value=0>(0)  7 - Cancel after 7 days</asp:ListItem>
                                                <asp:ListItem Value=1>(1)  N - Ship & Cancel</asp:ListItem>
                                                <asp:ListItem Value=2>(2)  Y - Backorder</asp:ListItem>
                                                <asp:ListItem Value=3>(3) 14 - Cancel after 14 days</asp:ListItem>
                                                <asp:ListItem Value=4>(4) 21 - Cancel after 21 days</asp:ListItem>
                                            </asp:DropDownList></td>
                                            <td align="right" style="width: 8%"><br />Price Code:&nbsp&nbsp&nbsp</td>
                                            <td style="width: 32%"><br /><asp:TextBox onFocus="DispCurVal('txtPriceCode')" ID="txtPriceCode" Width="40" runat="server" TabIndex="9"></asp:TextBox></td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="width: 7%"><br />Ship Loc:&nbsp&nbsp&nbsp</td>
                                            <td style="width: 17%"><br /><asp:DropDownList onFocus="DispCurVal('ddShipLoc')" ID="ddShipLoc" Width="150" runat="server" TabIndex="2"></asp:DropDownList></td>
                                            <td align="right" style="width: 8%"><br />Ship Agent:&nbsp&nbsp&nbsp</td>
                                            <td style="width: 32%"><br /><asp:DropDownList onFocus="DispCurVal('ddShipAgent')" ID="ddShipAgent" Width="295" runat="server" AutoPostBack="true" TabIndex="6"></asp:DropDownList></td>
                                            <td align="right" style="width: 8%"><br />Price Group:&nbsp&nbsp&nbsp</td>
                                            <td style="width: 32%"><br /><asp:DropDownList onFocus="DispCurVal('ddPriceGroup')" ID="ddPriceGroup" Width="295" runat="server" TabIndex="10"></asp:DropDownList></td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="width: 7%"><br /> Pay Type:&nbsp&nbsp&nbsp</td>
                                            <td style="width: 17%"><br /><asp:DropDownList onFocus="DispCurVal('ddShipPayType')" ID="ddShipPayType" Width="120" runat="server" TabIndex="3">
                                                <asp:ListItem Value=0>0 - Prepaid</asp:ListItem>
                                                <asp:ListItem Value=1>1 - Third Party</asp:ListItem>
                                                <asp:ListItem Value=2>2 - Freight Collect</asp:ListItem>
                                                <asp:ListItem Value=3>3 - Consignee</asp:ListItem>
                                            </asp:DropDownList></td>
                                            <td align="right" style="width: 8%"><br />E-Ship:&nbsp&nbsp&nbsp</td>
                                            <td style="width: 32%"><br /><asp:DropDownList onFocus="DispCurVal('ddEShipAgent')" ID="ddEShipAgent" Width="295" runat="server" TabIndex="7"></asp:DropDownList></td>
                                            <td align="right" style="width: 8%"><br />
                                                Disc Group:&nbsp&nbsp&nbsp</td>
                                            <td style="width: 32%"><br /><asp:DropDownList onFocus="DispCurVal('ddDiscGroup')" ID="ddDiscGroup" Width="295" runat="server" TabIndex="11"></asp:DropDownList></td>                                            
                                        </tr>
                                        <tr>                                            
                                            <td align="right" style="width: 7%; height: 44px;"><br />Free Frt:&nbsp&nbsp&nbsp</td>
                                            <td style="width: 17%; height: 44px;"><br /><asp:DropDownList onFocus="DispCurVal('ddFreeFrt')" ID="ddFreeFrt" Width="80" runat="server" TabIndex="4">
                                                <asp:ListItem Value=0>0 - No</asp:ListItem>
                                                <asp:ListItem Value=1>1 - Yes</asp:ListItem>
                                            </asp:DropDownList></td>                                         
                                            <td align="right" style="width: 8%; height: 44px;"><br />Ship Meth:&nbsp&nbsp&nbsp</td>
                                            <td style="width: 32%; height: 44px;"><br /><asp:DropDownList onFocus="DispCurVal('ddShipMeth')" ID="ddShipMeth" Width="295" runat="server" TabIndex="8"></asp:DropDownList></td>
                                            <td align="right" style="width: 8%; height: 44px"><br />Inside Sales:&nbsp&nbsp&nbsp</td>
                                            <td style="width: 32%; height: 44px;"><br /><asp:DropDownList onFocus="DispCurVal('ddInsideSales')" ID="ddInsideSales" Width="295" runat="server" TabIndex="12"></asp:DropDownList></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 7%"></td>
                                            <td style="width: 17%"></td>
                                            <td style="width: 8%"></td>
                                            <td style="width: 32%"></td>
                                            <td align="right" style="width: 8%"><br />Chain Name:&nbsp&nbsp&nbsp</td>
                                            <td style="width: 32%"><br /><asp:DropDownList onFocus="DispCurVal('ddChain')" ID="ddChain" Width="295" runat="server" TabIndex="13"></asp:DropDownList></td>
                                            <td><br /></td>
                                            <td style="width: 20%"><br /></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <br />
                                                <br />
                                                <br />
                                                <b><asp:Label ID="CustLabel" runat="server" />&nbsp;&nbsp;</b>
                                                <asp:Label ID="CurVal" name="CurVal" runat="server" /></td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="BluBg">
                                <div class="LeftPadding">
                                    <span class="LeftPadding" style="vertical-align: middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <asp:ImageButton ID="btnUpdate" TabIndex="14" OnClientClick="if (event.keyCode==9) {document.getElementById('txtCustNo').focus()}"
                                            runat="server" Style="cursor: hand" ImageUrl="images/Update.gif" />&nbsp;
                                        <asp:ImageButton ID="btnCancel" TabIndex="15" runat="server" Style="cursor: hand" ImageUrl="images/Cancel.gif" />
                                    </span>
                                </div>
                            </td>
                        </tr>
                        </table>
                    <% End If%>
                </td>
            </tr>
            <% End If%>
        </table>
        <asp:HiddenField ID="OGUseLoc" runat="server" />
        <asp:HiddenField ID="OGShipLoc" runat="server" /> 
        <asp:HiddenField ID="OGPayType" runat="server" /> 
        <asp:HiddenField ID="OGFreeFrt" runat="server" /> 
        <asp:HiddenField ID="OGBackorder" runat="server" /> 
        <asp:HiddenField ID="OGShipAgent" runat="server" /> 
        <asp:HiddenField ID="OGEShip" runat="server" /> 
        <asp:HiddenField ID="OGShipMeth" runat="server" /> 
        <asp:HiddenField ID="OGPriceCode" runat="server" /> 
        <asp:HiddenField ID="OGPriceGroup" runat="server" /> 
        <asp:HiddenField ID="OGDiscGroup" runat="server" /> 
        <asp:HiddenField ID="OGInsideSales" runat="server" />  
        <asp:HiddenField ID="OGChain" runat="server" />  
    </form>
</body>
</html>

