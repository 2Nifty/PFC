<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Header.ascx.cs" Inherits="Common_UserControls_Header" %>
<%@ Register Src="Links.ascx" TagName="Links" TagPrefix="uc1" %>
 
 
 
 <tr>
 <td colspan="2"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
        <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="HeadeBG">
            <tr>
                <td width="62%" valign="middle" ><img src="../Common/Images/Logo.gif" width="453" height="50" hspace="25" vspace="10"></td>
                <td width="38%" valign="bottom"><div align="right">
                  <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="1"><img src="../Common/Images/leftTopCut.gif" width="30" height="66"></td>
                      <td valign="bottom" bgcolor="#BCE6F2" class="LeftTopBg"><table width="100%" border="0" cellspacing="2" cellpadding="3">
                        <tr>
                          <td colspan="2"><div align="right">
                              <table>
                                  <tr>
                                      <td class="blackTxt" >
                                      <img  src="../Common/Images/home.gif" /> &nbsp; <a href="#" onclick="Getpage();">Home&nbsp;</a>
                                      </td>
                                      <td class="blackTxt" >
                                      <img  src="../Common/Images/sitemap.gif" /> &nbsp; <a href="#" onclick="DisplaySiteMap();">Site Map&nbsp;</a>
                                      </td>   
                                      <td class="blackTxt" >
                                          <img src="../Common/Images/smallHelp.gif" width="12"  /> &nbsp; <a href="#" onclick="DisplayHelp();">Help&nbsp;</a></td>                                 
                                      <td class="blackTxt" ><img  src="../Common/Images/logout.gif" /> <a href="#"  onclick="LogOut()">Logout&nbsp;</a>
                                      </td>
                                  </tr>
                              </table>
                          </div></td>
                        </tr>
                        <tr>
                          <td colspan="2" class="blackTxt"> <span style="color:#ff0033"><a > Welcome <strong> <%=Session["UserName"].ToString() %> </strong>, <% =DateTime.Now.ToLongDateString() %> </a> </span> </td>
                          </tr>
                      </table></td>
                      <td width="20" bgcolor="#BCE6F2" class="LeftTopBg">&nbsp;</td>
                    </tr>
                  </table>
                </div>
                </td>
            </tr>
        </table>
        </td>     
      </tr>
    </table></td>
  </tr>
  <tr>
    <td colspan="2" valign="top" class="TopMenuBg"><table width="100%"  border="0" cellspacing="0" cellpadding="0" >
        <tr>
            <td width="90%" valign="top">               
                <asp:Table ID="tblTemplates" runat="server" CellPadding="0" CellSpacing="0" Width="100%" class="TopMenuBg">                
                </asp:Table>
                <asp:HiddenField ID="hidTabStatus" runat="server" />  
                <asp:HiddenField ID="hidTabRows" runat="server" />              
            </td>
            <td width="10%">
            <div align="center" id="TopMenuControl">
                &nbsp;<img src="../Common/Images/showmenu.gif" name='ShowTopMenu'  hspace="5" id='ShowTopMenu' onclick='ShowHide(this)' style="cursor:hand"/>  </div>
            </td>
        </tr>
        
</table>
</td>
</tr>

