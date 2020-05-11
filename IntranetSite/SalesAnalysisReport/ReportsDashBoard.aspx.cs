using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;

public partial class SalesAnalysisReport_ReportsDashBoard : System.Web.UI.Page
{
    string erpConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
    protected void Page_Load(object sender, EventArgs e)
    {
        ForecastLink.Visible = false;
        try
        {
            DataSet dsData = SqlHelper.ExecuteDataset(erpConnectionString, "pDashboardCustNextYearBudgetFrm",
                              new SqlParameter("@source", "getForecastingOK"),
                              new SqlParameter("@searchFilter", ""));

            if ((dsData.Tables[0] != null) && (dsData.Tables[0].Rows.Count > 0) && (dsData.Tables[0].Rows[0]["AppOptionValue"].ToString() == "1"))
            {
                ForecastLink.Visible = true;
            }
        }
        catch (Exception ex)
        {
        }

    }
}
