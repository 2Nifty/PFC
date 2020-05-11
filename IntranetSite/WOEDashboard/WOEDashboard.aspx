<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>WOE</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

	<script language="C#" runat="server">
	
		private void Page_Load(object sender, System.EventArgs e)
		{
            //string url = "http://PFCIntranet/WOE/WOProcessingDashboard.aspx?UserID=" + Session["UserID"].ToString().Trim() + "&UserName=" + Session["UserName"].ToString().Trim();
            string url = ConfigurationSettings.AppSettings["WOESiteURL"] + "WOProcessingDashboard.aspx?UserID=" + Session["UserID"].ToString().Trim() + "&UserName=" + Session["UserName"].ToString().Trim();
            Response.Redirect(url, true);
        }
	</script>

</head>
<body onload="javascript:LoadPage();">
    <form id="form1" runat="server">
    </form>
</body>
</html>
