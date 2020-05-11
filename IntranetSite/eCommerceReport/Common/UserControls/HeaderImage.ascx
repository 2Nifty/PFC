<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HeaderImage.ascx.cs" Inherits="GER_Common_UserControls_HeaderImage" %>
<%@ OutputCache Duration="3600" VaryByparam = "none" %>
<tr>
    <td  id="tdHeaderSection1">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" onclick="javascript:document.getElementById('BOLHeader_lblProcDt').innerText='';">
        <tr>
             <td class="bgheaderbartile" >
               <table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td><div align="right" class="bgtime">
                  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="38%" height="28" align="left"><img src="Common/images/pfcger.gif" height="27"></td>
                      <td width="24%"><div align="center" class="txtTime">
                          <div align="center"><%=DateTime.Now.ToLongDateString() %></div>
                      </div></td>
                      <td width="35%" align="right" class="txtLogin">User Login</td>
                      <td width="3%" align="right"><div align="right"><img src="Common/images/exit.gif" style="cursor:hand" onclick="javascript: parent.window.close();" width="28" height="25"></div></td>
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