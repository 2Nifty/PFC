using System;
using System.Collections.Specialized;
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

using PFC.SOE.DataAccessLayer;

public partial class ShowItemSalesHistory : Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    
    protected void ShowHistoryButton_Click(object sender, EventArgs e)
    {
        ItemNoLabel.Text = ItemNoHidden.Value;
        DescriptionLabel.Text = DescriptionHidden.Value;
        GetItemHistory(ItemNoLabel.Text, CustNoHidden.Value);
    }

    protected void GetItemHistory(string ItemNo, string CustNo)
    {
        // get the history data.
        ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetItemHist",
            new SqlParameter("@SearchItemNo", ItemNo),
            new SqlParameter("@Organization", CustNo),
            new SqlParameter("@HistoryType", "Summary"),
            new SqlParameter("@operateMode", ""));
        if (ds.Tables.Count >= 1)
        {
            if (ds.Tables.Count == 1)
            {
                // We only go one table back, something is wrong
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    lblErrorMessage.Text = "History problem " + ItemNo.ToString() + CustNo.ToString();
                    MessageUpdatePanel.Update();
                }
            }
            else
            {
                dt = ds.Tables[1];
                HistoryGridView.DataSource = dt;
                HistoryGridView.DataBind();
                HistoryUpdatePanel.Update();
                if (dt.Rows.Count == 0)
                {
                    lblSuccessMessage.Text = "No History Found.";
                    MessageUpdatePanel.Update();

                }
            }
        }
    }
}
