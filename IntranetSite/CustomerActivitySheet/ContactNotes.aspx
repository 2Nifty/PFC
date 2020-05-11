<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ContactNotes.aspx.cs" Inherits="CustomerActivitySheet_ContactNotes" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Customer Contact Notes</title>
    <link href="../CustomerActivitySheet/Styles/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body scroll="yes" >
    <form id="form1" runat="server">
        <div id=SheetContainer~|>
         <table id="master" class=DashBoardBk   width=100% style="page-break-after:always">
            <tr>
                <td valign=top>
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="SheetHolder" style="border-collapse:collapse;">
          <tr>
            <td valign=top>
              <table width="100%" border="0" align="center" cellpadding="1" cellspacing="1" class="PageBorder" style="border-collapse:collapse;">
                <tr>
                  <td valign=top><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="SheetHead" style="border-collapse:collapse;">
                    <tr class="tdBorder">
                      <td class="redhead">Run Date: <%=DateTime.Now.ToString() %></td>
                      <td class="redhead">CUSTOMER CONTACT NOTES</td>
                      <td class="redhead">PAGE 5</td>
                    </tr>
                  </table></td>
                  </tr>
                  <tr><td>
                  <asp:DataGrid ID=dgCas runat=server Width=100% PageSize=1 AllowPaging=false BorderWidth=0 ShowHeader=false PagerStyle-Visible=false AutoGenerateColumns=false>
                  <Columns><asp:TemplateColumn>
                  <ItemTemplate>
                  <table width=100% style="border-collapse:collapse;" border=1 bordercolor="#c9c6c6">
                <tr class="tdBorder">
                  <td width="50%">
                      <div align="left" class="cnt"><strong>Customer # <%#DataBinder.Eval(Container.DataItem, "CustNo")%></strong><br>
                        Chain Name: <%#DataBinder.Eval(Container.DataItem, "Chain")%><br>
                        Cust Type:  <%#DataBinder.Eval(Container.DataItem, "CustType")%>
                        </div>
                    </td>
                  <td width="50%" rowspan="2" valign="top"  style="border-left:solid 1px #c9c6c6;">
                    <div align="left" class="cnt">
                          <strong>Sales Brn: <%#DataBinder.Eval(Container.DataItem,"BranchDesc") %></strong><br>
                          Inside Sales: <%#DataBinder.Eval(Container.DataItem,"InsideSls") %><br>
                          Sales Rep: <%#DataBinder.Eval(Container.DataItem,"SalesRep") %><br>
                          Buying Grp: <%#DataBinder.Eval(Container.DataItem,"BuyGrp") %><br>
                          Commission Rep: <%#DataBinder.Eval(Container.DataItem,"SalesPerson") %><br>
                          Hub: <%#DataBinder.Eval(Container.DataItem,"HubSatellites") %><br>
                          Terms: <%#DataBinder.Eval(Container.DataItem,"Terms") %><br>
                          DSO: <%#DataBinder.Eval(Container.DataItem,"DSO") %>&nbsp;Days<br>
                      </div>
                    </td>
                </tr>
                <tr class="tdBorder">
                  <td width="50%" class="tdBorder">
                        <div align="left" class="cnt"><strong><%#DataBinder.Eval(Container.DataItem,"CustName") %></strong><br>
                        <%#DataBinder.Eval(Container.DataItem,"CustAddress") %><br>
                        <%#DataBinder.Eval(Container.DataItem,"CustCity") %>, <%#DataBinder.Eval(Container.DataItem,"CustState") %> <%#DataBinder.Eval(Container.DataItem,"CustZip") %><br>
                        Ph: <%#DataBinder.Eval(Container.DataItem,"CustPhone") %><br>
                        Fx: <%#DataBinder.Eval(Container.DataItem,"CustFax") %><br>
                        <%--Contact: <%#DataBinder.Eval(Container.DataItem,"CustContact") %>--%></div>
                    </td>
                  </tr>
                
                </table></ItemTemplate></asp:TemplateColumn></Columns></asp:DataGrid></td></tr>
                
                <tr>
                    <td>
                        <asp:DataGrid ID=dgContactNotes BorderColor=#c9c6c6 runat=server Width=100% AutoGenerateColumns=false ShowHeader=false>
                            <Columns>
                                <asp:TemplateColumn>
                                    <ItemTemplate>
                                        <table width=100%>
                                            <tr><td align=left class=cnt><span><u>Previous Visit Notes</u></span></td></tr>
                                            <tr height=20px><td>&nbsp;</td></tr>
                                            <tr><td class="Left2pxPadd" align=left><div class="Left2pxPadd"><span class=cnt><p align=justify><%#DataBinder.Eval(Container.DataItem, "PreviousNote")%></p></span></div></td></tr>
                                            
                                            <tr><td align=left class=cnt><span><u>Last Outside Sales Rep Notes</u></span></td></tr>
                                            <tr height=20px><td>&nbsp;</td></tr>
                                            <tr><td class="Left2pxPadd" align=left><div class="Left2pxPadd"><span class=cnt><p align=justify><%#DataBinder.Eval(Container.DataItem, "LastOutRepNote")%></p></span></div></td></tr>
                                            
                                            <tr><td align=left class=cnt><span><u>Last Inside Sales Rep Notes</u></span></td></tr>
                                            <tr height=20px><td>&nbsp;</td></tr>
                                            <tr><td class="Left2pxPadd" align=left><div class="Left2pxPadd"><span class=cnt><p align=justify><%#DataBinder.Eval(Container.DataItem, "LastInRepNote")%></p></span></div></td></tr>
                                        </table>                                    
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                            </Columns>
                        </asp:DataGrid>
                    </td>
                </tr>
              </table>
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
