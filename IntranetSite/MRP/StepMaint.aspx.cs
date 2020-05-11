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

public partial class StepMaint : System.Web.UI.Page 
{
    DataTable dt = new DataTable();
    DataRow dtrow;
    GridViewRow gvrow;
    Label GridLineLabel;
    decimal ParentFactor;
    int StepOrder;
    private string Num2Format = "{0:####,###,##0.00} ";
    MRPCalc mrpCalc = new MRPCalc();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            RefreshGrid();
            MRPScriptManager.SetFocus("SearchTextBox");
        }
        else
        {
        }
        // Initializing AJAX.NET Library 
        Ajax.Utility.RegisterTypeForAjax(typeof(StepMaint));

    }

    protected void RefreshGrid()
    {
        SaveButton.Visible = false;
        CommandUpdatePanel.Update();
        ClearPageMessages();
        Session["MRPMaintStep"] = mrpCalc.StepDataGetAll();
        MaintGrid.DataSource = (DataTable)Session["MRPMaintStep"];
        MaintGrid.DataBind();
        MaintUpdatePanel.Update();
    }

    public void SearchData(Object sender, ImageClickEventArgs e)
    {
        LoadEntryData(SearchTextBox.Text);
        //if (dt != null)
        //{
        //    ClearEntry();
        //    ShowPageMessage("Step found.", 0);
        //}
    }

    public void LoadEntryData(string StepCode)
    {
        ClearPageMessages();
        dt = mrpCalc.StepDataGetStep(StepCode);
        if (dt != null)
        {
            ClearEntry();
            StepCodeTextBox.Text = dt.Rows[0]["StepCode"].ToString();
            StepCodeTextBox.Enabled = false;
            StepNameTextBox.Text = dt.Rows[0]["StepName"].ToString();
            ParentFactorBox.Text = string.Format(Num2Format, dt.Rows[0]["ParentROPProtectionFactor"]);
            StepOrderTextBox.Text = dt.Rows[0]["RunOrder"].ToString();
            HiddenID.Value = dt.Rows[0]["pScanStepID"].ToString();
            AddEditUpdatePanel.Update();
            SaveButton.Visible = true;
            AddButt.Visible = false;
            CommandUpdatePanel.Update();
            MRPScriptManager.SetFocus("StepNameTextBox");
        }
    }

    public bool ValidData()
    {
        if (StepCodeTextBox.Text.Trim().Length==0)
        {
            ShowPageMessage("A Step Code is required.", 2);
            MRPScriptManager.SetFocus("StepCodeTextBox");
            return false;
        }
        if (StepNameTextBox.Text.Trim().Length == 0)
        {
            ShowPageMessage("A Step Name is required.", 2);
            MRPScriptManager.SetFocus("StepNameTextBox");
            return false;
        }
        if (!decimal.TryParse(ParentFactorBox.Text, out ParentFactor))
        {
            ShowPageMessage("Parent ROP Factor is invalid. A number is required.", 2);
            MRPScriptManager.SetFocus("ParentFactorBox");
            return false;
        }
        if (!int.TryParse(StepOrderTextBox.Text, out StepOrder))
        {
            ShowPageMessage("Step Order is invalid. A number (no decimals) is required.", 2);
            MRPScriptManager.SetFocus("StepOrderTextBox");
            return false;
        }
        return true;
    }

    public void SaveData(Object sender, ImageClickEventArgs e)
    {
        if (ValidData())
        {
            dt = mrpCalc.WorkStepData("Update", 0, StepCodeTextBox.Text, StepNameTextBox.Text, ParentFactor, StepOrder, Session["UserName"].ToString(), "Unable to update record");
            if (dt != null)
            {
                RefreshGrid();
                ClearEntry();
                ShowPageMessage("Step updated.", 0);
                StepCodeTextBox.Enabled = true;
            }
        }
    }

    public void AddData(Object sender, ImageClickEventArgs e)
    {
        if (ValidData())
        {
            dt = mrpCalc.WorkStepData("Add", 0, StepCodeTextBox.Text, StepNameTextBox.Text, ParentFactor, StepOrder, Session["UserName"].ToString(), "Unable to add record");
            if (dt != null)
            {
                RefreshGrid();
                ClearEntry();
                ShowPageMessage("Step added.", 0);
            }
        }
    }

    public void DeleteData(Object sender, EventArgs e)
    {
        //ScriptManager.RegisterClientScriptBlock(MaintGridPanel, MaintGridPanel.GetType(), "PostDeletePrompt", "alert('test');", true);
        //ShowPageMessage("Deleting " + HiddenID.Value.ToString(), 2);
        dt = mrpCalc.WorkStepData("Delete", 0, HiddenID.Value.ToString(), "", 0, 0, Session["UserName"].ToString(),  "Unable to delete record");
        //if (dt != null)
        //{
            RefreshGrid();
            ClearEntry();
            ShowPageMessage("Step deleted.", 0);
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
            DataView dv = new DataView((DataTable)Session["MRPMaintStep"]);
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
        StepCodeTextBox.Text = "";
        StepNameTextBox.Text = "";
        ParentFactorBox.Text = "";
        StepOrderTextBox.Text = "";
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


}