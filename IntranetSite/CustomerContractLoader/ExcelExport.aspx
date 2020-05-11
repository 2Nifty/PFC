<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ExcelExport.aspx.vb" Inherits="ExcelExport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Customer Contract Price Export</title>
</head>
<frameset rows="50,*">
<frame src="ExcelTop.htm" id=TitleBar />
<frame src="<%= ExcelFile %>" id=EBody  />
</frameset>
</html>
