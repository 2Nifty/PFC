<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CASFrameSet.aspx.cs" Inherits="CASFrameSet" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Activity Sheet</title>
    <link href="../Styles/Styles.css" type="text/css" rel="stylesheet">
</head>
<frameset rows="50,*,25" border="0">
    <frame name="banner" scrolling="no" noresize src="TopFrame.aspx">
    <frameset cols="250,*" id="frameSet2" border="0">
      <%if (Request.QueryString["CASMode"] == null)
        {%>
        <frame name="MenuFrame" id="MenuFrame" src="RightFrame.aspx?Month=<%= Request.QueryString["Month"].ToString() %>&CustNo=<%= Request.QueryString["CustNo"].ToString()%>&Year=<%=Request.QueryString["Year"].ToString() %>&Branch=<%=Request.QueryString["Branch"].ToString() %>&BranchName=<%=StrBranch %>&MonthName=<%= Request.QueryString["MonthName"].ToString()%>"
 scrolling="no" noresize>
      <%}
                else
          { %>
                 <frame name="MenuFrame" id="Frame2" src="RightFrame.aspx?Month=<%= Request.QueryString["Month"].ToString() %>&CustNo=<%= Request.QueryString["CustNo"].ToString()%>&Year=<%=Request.QueryString["Year"].ToString() %>&Branch=<%=Request.QueryString["Branch"].ToString() %>&BranchName=<%=StrBranch %>&MonthName=<%= Request.QueryString["MonthName"].ToString()%>&Chain=<%= Request.QueryString["Chain"].ToString()%>&CASMode=<%= Request.QueryString["CASMode"].Trim()%>"
 scrolling="no" noresize>
   <%} %>
                
        <!--<frame name="bodyframe" scrolling="auto" src="">-->
        <frameset rows="35,*" id="frameSet1" border="0">
         <%if (Request.QueryString["CASMode"] == null)
        {%>
            <frame name="mainmenus" id="Frame1" src="PrintPanel.aspx?Month=<%= Request.QueryString["Month"].ToString() %>&CustNo=<%= Request.QueryString["CustNo"].ToString()%>&Year=<%=Request.QueryString["Year"].ToString() %>&Branch=<%=Request.QueryString["Branch"].ToString() %>&BranchName=<%=StrBranch %>&MonthName=<%= Request.QueryString["MonthName"].ToString()%>"
                     
                scrolling="no" noresize>
                   <%}
                else
          { %>
          <frame name="mainmenus" id="Frame3" src="PrintPanel.aspx?Month=<%= Request.QueryString["Month"].ToString() %>&CustNo=<%= Request.QueryString["CustNo"].ToString()%>&Year=<%=Request.QueryString["Year"].ToString() %>&Branch=<%=Request.QueryString["Branch"].ToString() %>&BranchName=<%=StrBranch %>&MonthName=<%= Request.QueryString["MonthName"].ToString()%>&Chain=<%= Request.QueryString["Chain"].ToString()%>&CASMode=<%= Request.QueryString["CASMode"].Trim()%>"
                     
                scrolling="no" noresize>
                   <%} %>
          
            <%if (Request.QueryString["CASMode"] == null)
            {%>
            <frame name="bodyframe" scrolling="auto" src="../CustomerData.aspx?Month=<%= Request.QueryString["Month"].ToString() %>&CustNo=<%= Request.QueryString["CustNo"].ToString()%>&Year=<%=Request.QueryString["Year"].ToString() %>&Branch=<%=Request.QueryString["Branch"].ToString() %>&BranchName=<%=StrBranch %>&MonthName=<%= Request.QueryString["MonthName"].ToString()%>"
                class="Sbar">
            <%}
                else
                { %>
            <frame name="bodyframe" scrolling="auto" src="../CustomerData.aspx?Month=<%= Request.QueryString["Month"].ToString() %>&CustNo=<%= Request.QueryString["CustNo"].ToString()%>&Year=<%=Request.QueryString["Year"].ToString() %>&Branch=<%=Request.QueryString["Branch"].ToString() %>&BranchName=<%=StrBranch %>&MonthName=<%= Request.QueryString["MonthName"].ToString()%>&Chain=<%= Request.QueryString["Chain"].ToString()%>&CASMode=<%= Request.QueryString["CASMode"].Trim()%>"
                class="Sbar">
            <%} %>
        </frameset>
    </frameset>
    <frame name="footer" scrolling="no" noresize src="FooterFrame.aspx">
</frameset>
</html>
