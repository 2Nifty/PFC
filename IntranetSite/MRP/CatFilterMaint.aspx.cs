using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;

public partial class CatFilterMaint : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataRow dtrow;
    GridViewRow gvrow;
    Label GridLineLabel;
    decimal ParentFactor;
    int BegCat;
    int EndCat;
    private string Num2Format = "{0:####,###,##0.00} ";
    MRPCalc mrpCalc = new MRPCalc();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dt = CheckError(mrpCalc.CatRngDataGetParentLimit());
            if (dt != null)
            {
                DefParentRoundLimit.Value = dt.Rows[0]["ParentLimit"].ToString();
                ParentRoundingLimitTextBox.Text = DefParentRoundLimit.Value;
            }
            RefreshGrid();
            MRPScriptManager.SetFocus("SearchTextBox");
        }
        else
        {
        }
        // Initializing AJAX.NET Library 
        Ajax.Utility.RegisterTypeForAjax(typeof(CatFilterMaint));

    }

    protected void RefreshGrid()
    {
        SaveButton.Visible = false;
        CommandUpdatePanel.Update();
        ClearPageMessages();
        Session["MRPMaintCatRng"] = CheckError(mrpCalc.CatRngDataGetAll());
        MaintGrid.DataSource = (DataTable)Session["MRPMaintCatRng"];
        MaintGrid.DataBind();
        MaintUpdatePanel.Update();
    }

    public void SearchData(Object sender, ImageClickEventArgs e)
    {
        LoadEntryData(SearchTextBox.Text);
    }

    public void LoadEntryData(string CatRngCode)
    {
        ClearPageMessages();
        dt = CheckError(mrpCalc.CatRngDataGetStep(CatRngCode));
        if (dt != null)
        {
            ClearEntry();
            CatRngCodeTextBox.Text = dt.Rows[0]["FilterCode"].ToString();
            CatRngCodeTextBox.Enabled = false;
            CatRngNameTextBox.Text = dt.Rows[0]["FilterName"].ToString();
            BegCatTextBox.Text = dt.Rows[0]["BegCategory"].ToString();
            EndCatTextBox.Text = dt.Rows[0]["EndCategory"].ToString();
            PackRngTextBox.Text = dt.Rows[0]["PackageRange"].ToString();
            PlatingRngTextBox.Text = dt.Rows[0]["PlateRange"].ToString();
            ParentRoundingLimitTextBox.Text = dt.Rows[0]["ParentRoundLimit"].ToString();
            HiddenID.Value = dt.Rows[0]["pCategoryRangeID"].ToString();
            AddEditUpdatePanel.Update();
            SaveButton.Visible = true;
            AddButt.Visible = false;
            CommandUpdatePanel.Update();
            MRPScriptManager.SetFocus("CatRngNameTextBox");
        }
    }

    public bool ValidData()
    {
        if (CatRngCodeTextBox.Text.Trim().Length == 0)
        {
            ShowPageMessage("A Category Filter Code is required.", 2);
            MRPScriptManager.SetFocus("CatRngCodeTextBox");
            return false;
        }
        if (CatRngNameTextBox.Text.Trim().Length == 0)
        {
            ShowPageMessage("A Category Filter Name is required.", 2);
            MRPScriptManager.SetFocus("CatRngNameTextBox");
            return false;
        }
        if (BegCatTextBox.Text.Trim().Length != 5)
        {
            ShowPageMessage("A Beginning Category is required and must be five digits long.", 2);
            MRPScriptManager.SetFocus("BegCatTextBox");
            return false;
        }
        if (!int.TryParse(BegCatTextBox.Text.Trim(),out BegCat))
        {
            ShowPageMessage("The beginning category is not numeric.", 2);
            MRPScriptManager.SetFocus("BegCatTextBox");
            return false;
        }
        if (EndCatTextBox.Text.Trim().Length == 0)
        {
            ShowPageMessage("An Ending Category is required.", 2);
            MRPScriptManager.SetFocus("EndCatTextBox");
            return false;
        }
        if (!int.TryParse(EndCatTextBox.Text.Trim(), out EndCat))
        {
            ShowPageMessage("The ending category is not numeric.", 2);
            MRPScriptManager.SetFocus("EndCatTextBox");
            return false;
        }
        if (BegCat > EndCat)
        {
            ShowPageMessage("The ending category must be after the beginning category.", 2);
            MRPScriptManager.SetFocus("EndCatTextBox");
            return false;
        }
        if (PackRngTextBox.Text.Trim().Length == 0)
        {
            ShowPageMessage("A Package Range is required.", 2);
            MRPScriptManager.SetFocus("PackRngTextBox");
            return false;
        }
        if (PlatingRngTextBox.Text.Trim().Length == 0)
        {
            ShowPageMessage("A Plating Range is required.", 2);
            MRPScriptManager.SetFocus("PlatingRngTextBox");
            return false;
        }
        if (!decimal.TryParse(ParentRoundingLimitTextBox.Text, out ParentFactor))
        {
            ShowPageMessage("Parent Need Rounding Limit is invalid. A number is required.", 2);
            MRPScriptManager.SetFocus("ParentRoundingLimitTextBox");
            return false;
        }
        return true;
    }

    public void SaveData(Object sender, ImageClickEventArgs e)
    {
        if (ValidData())
        {
            dt = CheckError(mrpCalc.WorkCatRngData("Update", 0, CatRngCodeTextBox.Text, CatRngNameTextBox.Text, BegCatTextBox.Text, EndCatTextBox.Text,
                PackRngTextBox.Text, PlatingRngTextBox.Text, ParentRoundingLimitTextBox.Text, Session["UserName"].ToString()));
            if (dt != null)
            {
                RefreshGrid();
                ClearEntry();
                ShowPageMessage("Category Filter updated.", 0);
                CatRngCodeTextBox.Enabled = true;
            }
        }
    }

    public void AddData(Object sender, ImageClickEventArgs e)
    {
        if (ValidData())
        {
            dt = CheckError(mrpCalc.WorkCatRngData("Add", 0, CatRngCodeTextBox.Text, CatRngNameTextBox.Text, BegCatTextBox.Text, EndCatTextBox.Text,
                PackRngTextBox.Text, PlatingRngTextBox.Text, ParentRoundingLimitTextBox.Text, Session["UserName"].ToString()));
            if (dt != null)
            {
                RefreshGrid();
                ClearEntry();
                ShowPageMessage("Category Filter added.", 0);
            }
        }
    }

    public void DeleteData(Object sender, EventArgs e)
    {
        //ScriptManager.RegisterClientScriptBlock(MaintGridPanel, MaintGridPanel.GetType(), "PostDeletePrompt", "alert('test');", true);
        //ShowPageMessage("Deleting " + HiddenID.Value.ToString(), 2);
        dt = CheckError(mrpCalc.WorkCatRngData("Delete", 0, HiddenID.Value.ToString(), "", "", "", "", "", "0", ""));
        //if (dt != null)
        //{
        RefreshGrid();
        ClearEntry();
        ShowPageMessage("Category Filter deleted.", 0);
        //}
    }

    public void EditHandler(Object sender, GridViewEditEventArgs e)
    {
        try
        {
            gvrow = MaintGrid.Rows[e.NewEditIndex];
            LoadEntryData(gvrow.Cells[1].Text.ToString());
        }
        catch (Exception e2)
        {
            ShowPageMessage("Edit Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    public void DeleteHandler(Object sender, GridViewDeleteEventArgs e)
    {
        gvrow = MaintGrid.Rows[e.RowIndex];
        ScriptManager.RegisterClientScriptBlock(MaintGridPanel, MaintGridPanel.GetType(), "DeletePrompt", "ConfirmDelete('" + gvrow.Cells[1].Text.ToString() + "','" + gvrow.Cells[2].Text.ToString() + "');", true);
        //ScriptManager.RegisterClientScriptBlock(MaintGridPanel, MaintGridPanel.GetType(), "DeletePrompt", "alert('test');", true);

    }

    public void SortHandler(Object sender, GridViewSortEventArgs e)
    {
        try
        {
            // Create a DataView from the Quote Detail DataTable.
            DataView dv = new DataView((DataTable)Session["MRPMaintCatRng"]);
            dv.Sort = e.SortExpression;
            MaintGrid.DataSource = dv;
            MaintGrid.DataBind();
            MaintGridPanel.Height = new Unit(double.Parse(MaintGridHeightHidden.Value), UnitType.Pixel);
            MaintGridPanel.Width = new Unit(double.Parse(MaintGridWidthHidden.Value), UnitType.Pixel);
        }
        catch (Exception e2)
        {
            ShowPageMessage("Sort Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    protected void ClearEntry()
    {
        CatRngCodeTextBox.Text = "";
        CatRngNameTextBox.Text = "";
        BegCatTextBox.Text = "";
        EndCatTextBox.Text = "";
        PackRngTextBox.Text = "";
        PlatingRngTextBox.Text = "";
        ParentRoundingLimitTextBox.Text = DefParentRoundLimit.Value;
        AddEditUpdatePanel.Update();
        SaveButton.Visible = false;
        AddButt.Visible = true;
        CommandUpdatePanel.Update();
        MRPScriptManager.SetFocus("SearchTextBox");
    }

    protected void ClearPageMessages()
    {
        MessageLabel.Text = "";
        AddEditUpdatePanel.Update();
    }
    protected void ShowPageMessage(string PageMessage, int MessageType)
    {
        switch (MessageType)
        {
            case 1:
                MessageLabel.CssClass = "warn";
                break;
            case 2:
                MessageLabel.CssClass = "error";
                break;
            default:
                MessageLabel.CssClass = "success";
                break;
        }
        //MessageLabel.CssClass = "error";
        MessageLabel.Text = PageMessage;
        AddEditUpdatePanel.Update();
    }

    public DataTable CheckError(DataTable NewData)
    {
        if ((NewData != null) && (NewData.Columns.Contains("ErrorType")))
        {
            ShowPageMessage(NewData.Rows[0]["ErrorText"].ToString(), 2);
            return null;
        }
        else
        {
            return NewData;
        }
    }
    

}