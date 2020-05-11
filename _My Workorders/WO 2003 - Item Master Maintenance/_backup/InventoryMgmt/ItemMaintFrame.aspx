<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ItemMaintFrame.aspx.cs" Inherits="ItemMaintFrame" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server"  >
    <title id="pageCaption" runat="server">Item Master Maintenance Frame</title>
</head>

    <frameset cols="30,*" border="0" name="MaintFrame">
        <frame name="MenuFrame" src="SideMenu.aspx" scrolling="no" />
        <frame id="BodyFrame" name="BodyFrame" src="ItemMaint.aspx">
    </frameset>

</html>
