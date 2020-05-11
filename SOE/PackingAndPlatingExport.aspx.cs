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
using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.DataAccessLayer;

public partial class ShowPackingAndPlatingExport : Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    OrderEntry orderEntry = new OrderEntry();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();

    protected void Page_Init(object sender, EventArgs e)
    {
        NameValueCollection coll = Request.QueryString;
        if (coll["ItemNumber"] != null)
        {
            //Get the reference data
            //http://10.1.36.34/SOE/packingandplating.aspx?ItemNumber=00200-2400-021&ShipLoc=10&RequestedQty=5&AltQty=50&AvailableQty=33
            HasProcessed.Value = "1";
            ItemNoTextBox.Text = coll["ItemNumber"].ToString();
            ReqLocTextBox.Text = coll["ShipLoc"].ToString();
            ReqQtyHidden.Value = coll["RequestedQty"].ToString();
            AltQtyHidden.Value = coll["AltQty"].ToString();
            ReqAvailHidden.Value = coll["AvailableQty"].ToString();
            GetPackPlateData(ItemNoTextBox.Text, ReqLocTextBox.Text);
            ReqQtyLabel.Text = ReqQtyHidden.Value;
            AltQtyLabel.Text = AltQtyHidden.Value;
            ReqAvailLabel.Text = ReqAvailHidden.Value;
        }
    }
    
    protected void GetPackPlateData(string ItemNo, string Loc)
    {
        // get the package and plating data.
        ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetPackPlate",
            new SqlParameter("@SearchItemNo", ItemNo),
            new SqlParameter("@PrimaryBranch", Loc));
        if (ds.Tables.Count >= 1)
        {
            if (ds.Tables.Count == 1)
            {
                // We only go one table back, something is wrong
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    ItemNoTextBox.Text = "Error ";
                }
            }
            else
            {
                dt = ds.Tables[1];
                PackPlateGridView.DataSource = dt;
                PackPlateGridView.DataBind();
                DataView dv = new DataView(dt, "SubItem = '" + ItemNo + "'", "", DataViewRowState.CurrentRows);
                AltAvailLabel.Text = String.Format("{0:#,##0}",dv[0]["AltQOH"]);
            }
        }
    }
}
