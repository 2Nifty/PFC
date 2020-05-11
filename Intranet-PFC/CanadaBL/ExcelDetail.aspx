<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ExcelDetail.aspx.vb" Inherits="ExcelDetail" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Canada B/L Detail Excel Export</title>
</head>
<frameset rows="50,*">
<frame src="DetailTop.htm" id=TitleBar />
<frame src="<%= ExcelFile %>" id=EBody  />
</frameset>
</html>