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

public partial class CustWeight : Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();

    protected void Page_Init(object sender, EventArgs e)
    {
        NameValueCollection coll = Request.QueryString;
        if (coll["CustNumber"] != null)
        {
            //Get the reference data
            //http://10.1.36.34/SOE/CustWeight.aspx?CustNumber=004401
            CustNoHid.Value = coll["CustNumber"].ToString();
            GetWeightData();
            CustWeightScriptManager.SetFocus("CloseButt");
        }
    }

    protected void GetWeightData()
    {
        // get the quote weights.
        ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetWeightSummary",
            new SqlParameter("@Organization", CustNoHid.Value));
        if (ds.Tables.Count >= 1)
        {
            if (ds.Tables.Count == 1)
            {
                // We only go one table back, something is wrong
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    lblErrorMessage.Text = "CustWeight problem " + CustNoLabel.Text;
                    MessageUpdatePanel.Update();
                }
            }
            else
            {
                if (ds.Tables[1].Rows.Count == 0)
                {
                    lblErrorMessage.Text = "No Orders Holding for Weight. ";
                    MessageUpdatePanel.Update();
                }
                else
                {
                    dt = ds.Tables[2];
                    CustNoLabel.Text = CustNoHid.Value + " - " + dt.Rows[0]["CustName"].ToString();
                    AddressLabel.Text = dt.Rows[0]["AddrLine1"].ToString()
                        + " " + dt.Rows[0]["AddrLine2"].ToString() + ", " + dt.Rows[0]["City"].ToString()
                        + ",  " + dt.Rows[0]["State"].ToString() + ".  " + dt.Rows[0]["PostCd"].ToString();
                    AddressLabel.Text = AddressLabel.Text.Trim();
                    ShipLocLabel.Text = dt.Rows[0]["CustShipLocation"].ToString();
                    dt = ds.Tables[1];
                    WeightsGridView.DataSource = dt;
                    WeightsGridView.DataBind();
                    WeightsUpdatePanel.Update();
                }
            }
        }
    }

}
