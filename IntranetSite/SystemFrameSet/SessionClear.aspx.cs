using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;

public partial class SystemFrameSet_SessionClear : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string strSessionId = Session["SessionID"].ToString().Trim();
        Session["ItemSale"] = "";
        Session["CustomerSale"] = "";
        Session["DocSale"] = "";
        Session["BranchItem"] = "";
        Session["BranchCustomer"] = "";
        Session["dtReport"] = "";
        Session["dt"] = "";

        DirectoryInfo dirExcel = new DirectoryInfo(Server.MapPath("..\\Common\\ExcelUploads"));
        foreach (FileInfo filExcel in dirExcel.GetFiles())
        {
            if (filExcel.Name.Contains(strSessionId))
                filExcel.Delete();
        }

        RegisterClientScriptBlock("Close", "<script>window.close();</script>");
    }
}
