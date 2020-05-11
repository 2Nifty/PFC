<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HeaderImage.ascx.cs" Inherits="GER_Common_UserControls_HeaderImage" %>
<%@ OutputCache Duration="3600" VaryByparam = "none" %>
<tr>
    <td  id="tdHeaderSection1">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" onclick="javascript:document.getElementById('BOLHeader_lblProcDt').innerText='';">
        <tr>
             <td class="bgheaderbartile" >
               <table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td><div align="right">
                  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td align="left" width="200px">
                          <asp:Label ID="Label1" runat="server" CssClass="txtLogin" Text="Main Order Entry"></asp:Label></td>
                      <td  align="left">
                          </td>
                      <td width=197px  valign=top>    
                      <table width=100% height=30 border="0" cellspacing="0" cellpadding="0" background="Common/Images/bgtime.gif">
                        <tr>
                            <td>
                            <asp:Label ID="lblDateTime" style="vertical-align:middle" runat="server" CssClass="txtTime"></asp:Label>  
                            </td>
                        </tr>                      
                      </table>                           
                      </td>
                      <td width="35%" align="right" class="txtLogin">
                          <asp:Label
                              ID="lblUserInfo" runat="server" CssClass="txtLogin"></asp:Label></td>
                    </tr>
                  </table>
              </div></td>
            </tr>
        </table>
            </td> 
        </tr>
        </table>
    </td>   
</tr>