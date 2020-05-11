using System;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class PrevMthSalesPopup : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblPrevSls1.Text = Request.QueryString["Mth1Sales"].ToString().Trim();
        lblPrevSls2.Text = Request.QueryString["Mth2Sales"].ToString().Trim();
        lblPrevSls3.Text = Request.QueryString["Mth3Sales"].ToString().Trim();

        lblPrevGM1.Text = Request.QueryString["Mth1GMPct"].ToString().Trim();
        lblPrevGM2.Text = Request.QueryString["Mth2GMPct"].ToString().Trim();
        lblPrevGM3.Text = Request.QueryString["Mth3GMPct"].ToString().Trim();
    }
}
