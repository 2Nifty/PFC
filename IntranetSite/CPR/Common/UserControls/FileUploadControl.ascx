<%@ Control Language="C#" AutoEventWireup="true" CodeFile="FileUploadControl.ascx.cs" Inherits="FileUploadControl" %>
 <style type="text/css">
        body{font-family:arial;font-size:11px;}
        .msg {font-size:11px; font-weight:bold; color: #cc0000; font-family:arial;}
        .hide {display:none;}
        .compilerError {padding:5px; background: #ffffcc; color:#000000;}
    </style>
    
 
    
    <asp:Label ID="confirmMsg" runat="server" Text="Label" Visible="false" CssClass="msg"></asp:Label>
     <div>        
    Select a file: 
     <asp:FileUpload ID="hidFileUpload"   runat="server"  />
       <%--<input type="file" CssClass="hide" id=hidupd runat="server" onchange="OnChange(this);" />--%>
     </div>
        <input id="txtFilePath" type="text" runat="server"  />   
      <asp:ImageButton ID="ibtnBrowse" runat="server" ImageUrl="~/Common/Images/Browse.gif" OnClientClick="OnClick(this);" OnClick="ibtnBrowse_Click" />
      
 <asp:ImageButton ID="ibtnUpload" OnClick="ibtnUpload_Click" runat="server" ImageUrl="~/Common/Images/upload.gif" ></asp:ImageButton>
 <asp:Button ID="btnClick" runat="server" style="display:none;" OnClick="btnClick_Click"  />
   
  
 
 <script type="text/javascript">
 function OnChange(obj)
 {
 alert(obj.value);
var txtFilePath = obj.id.replace('hidFileUpload','txtFilePath');
 var fd =  obj.value;
document.getElementById(txtFilePath).value =fd;
 //obj.value =  fd;
 //document.getElementById(obj.id.replace('ibtnBrowse','btnClick')).click();
 }
 function OnClick(obj)
 {
 var hidFileUpload= obj.id.replace('ibtnBrowse','hidFileUpload') ;
 document.getElementById(hidFileUpload).click();
 return true;
 }
 </script>