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

public partial class ShowPackingAndPlating : Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();

    protected void Page_Init(object sender, EventArgs e)
    {
        PackPlateScriptManager.SetFocus("ItemNoTextBox");
        WebEnabledHidden.Value = "1";
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
            PackPlateScriptManager.SetFocus("ItemNoTextBox");
        }
        else
        {
            PackPlateScriptManager.SetFocus("ItemNoTextBox");
            ItemPromptInd.Value = "Z";
        }
    }
    
    protected void PackPlateSubmit_Click(object sender, EventArgs e)
    {
        lblErrorMessage.Text = "";
        MessageUpdatePanel.Update();
        GetPackPlateData(ItemNoTextBox.Text, ReqLocTextBox.Text);
        ReqQtyLabel.Text = ReqQtyHidden.Value;
        AltQtyLabel.Text = AltQtyHidden.Value;
        ReqAvailLabel.Text = ReqAvailHidden.Value;
        PackPlateScriptManager.SetFocus("ItemNoTextBox");
    }

    protected void GetPackPlateData(string ItemNo, string Loc)
    {
        Loc = Loc.PadLeft(2, '0');
        // set the z-item on the location
        CheckZItemBranch(Loc);
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
                    lblErrorMessage.Text = "Package/Plating problem " + ItemNo.ToString() + Loc.ToString();
                    MessageUpdatePanel.Update();
                }
            }
            else
            {
                dt = ds.Tables[1];
                if (dt.Rows.Count > 0)
                {
                    if (WebEnabledHidden.Value == "1")
                    {
                        DataView dvWE = new DataView(dt, "WebEnabled = '" + WebEnabledHidden.Value + "'", "", DataViewRowState.CurrentRows);
                        PackPlateGridView.DataSource = dvWE;
                    }
                    else
                    {
                        PackPlateGridView.DataSource = dt;
                    }
                    PackPlateGridView.DataBind();
                    PackPlateUpdatePanel.Update();
                    DataView dv = new DataView(dt, "SubItem = '" + ItemNo + "'", "", DataViewRowState.CurrentRows);
                    if (dv.Count > 0)
                    {
                        AltAvailLabel.Text = String.Format("{0:#,##0}", dv[0]["AltQOH"]);
                    }
                    else
                    {
                        AltAvailLabel.Text = "0";
                    }
                    BindPrintDialog();
                }
                else
                {
                    AltAvailLabel.Text = "";
                    PackPlateGridView.DataBind();
                    PackPlateUpdatePanel.Update();
                    lblErrorMessage.Text = "Nothing on file.";
                    MessageUpdatePanel.Update();
                }
            }
        }
    }

    protected void CheckZItemBranch(string BranchToCheck)
    {
        // This retrieves whether ZItem should be process using field ItemPromptInd
        DataTable dtLoc = new DataTable();
        DataSet dsLoc = SqlHelper.ExecuteDataset(connectionString, "pSOEGetLocMaster",
            new SqlParameter("@LocNo", BranchToCheck));
        if (dsLoc.Tables.Count >= 1)
        {
            if (dsLoc.Tables.Count == 1)
            {
                // We only go one table back, something is wrong
                dtLoc = dsLoc.Tables[0];
                if (dtLoc.Rows.Count > 0)
                {
                    lblErrorMessage.Text = "ZItem Problem with Branch " + BranchToCheck.ToString();
                    MessageUpdatePanel.Update();
                }
            }
            else
            {
                dtLoc = dsLoc.Tables[1];
                if (dtLoc.Rows.Count > 0)
                {
                    ItemPromptInd.Value = dtLoc.Rows[0]["ItemPromptInd"].ToString();
                }
            }
        }
    }

    public void BindPrintDialog()
    {
        Print.PageTitle = "Package and Plating Options for " + ItemNoTextBox.Text;
        Print.PageUrl = "PackingAndPlatingExport.aspx?ItemNumber=" + ItemNoTextBox.Text +
            "&ShipLoc=" + ReqLocTextBox.Text.Trim().ToString() +
            "&RequestedQty=" + ReqQtyHidden.Value.ToString() +
            "&AltQty=" + AltQtyHidden.Value.ToString() +
            "&AvailableQty=" + ReqAvailHidden.Value.ToString();
        PrintUpdatePanel.Update();
        //lblSuccessMessage.Text = Print.PageUrl;
        //MessageUpdatePanel.Update();
    }

    protected void WebEnabledLinkButton_Click(object sender, EventArgs e)
    {
        WebEnabledHidden.Value = Math.Abs(int.Parse(WebEnabledHidden.Value) - 1).ToString();
        GetPackPlateData(ItemNoTextBox.Text, ReqLocTextBox.Text);
        if (WebEnabledHidden.Value == "1")
        {
            WebEnabledLinkButton.Text = "Show All Packages";
        }
        else
        {
            WebEnabledLinkButton.Text = "Show Web Enabled Only";
        }
    }
}
