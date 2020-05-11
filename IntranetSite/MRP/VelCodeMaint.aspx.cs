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

public partial class VelCodeMaint : System.Web.UI.Page 
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataRow dtrow;
    GridViewRow gvrow;
    Label GridLineLabel;
    decimal ROPCartons;
    decimal NeedFactor;
    int ParentIsBulk;
    int BOMRequired;
    private string Num2Format = "{0:####,###,##0.00} ";
    MRPCalc mrpCalc = new MRPCalc();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            RefreshGrid();
            ClearEntry();
        }
        else
        {
        }
        // Initializing AJAX.NET Library 
        Ajax.Utility.RegisterTypeForAjax(typeof(VelCodeMaint));

    }

    protected void RefreshGrid()
    {
        SaveButton.Visible = false;
        CommandUpdatePanel.Update();
        ClearPageMessages();
        Session["MRPMaintVelocity"] = CheckError(mrpCalc.VelocityDataGetAll());
        MaintGrid.DataSource = (DataTable)Session["MRPMaintVelocity"];
        MaintGrid.DataBind();
        MaintUpdatePanel.Update();
    }

    public void SearchData(Object sender, ImageClickEventArgs e)
    {
        LoadEntryData(SearchTextBox.Text);
        MRPScriptManager.SetFocus("VelocityCodeTextBox");
    }

    public void LoadEntryData(string VelocityCode)
    {
        ClearPageMessages();
        dt = mrpCalc.VelocityDataGetVelocity(VelocityCode);
        if (dt != null)
        {
            ClearEntry();
            VelocityCodeTextBox.Text = dt.Rows[0]["VelocityCode"].ToString();
            VelocityCodeTextBox.Enabled = false;
            VelCodeDescTextBox.Text = dt.Rows[0]["VelocityCdDesc"].ToString();
            ROPCartonsTextBox.Text = string.Format(Num2Format, dt.Rows[0]["ROPCartons"]);
            if (dt.Rows[0]["ParentBulk0"].ToString() == "True")
            {
                ParentItemIsBulkRadioButton.Checked = true;
                ParentItemIsNotBulkRadioButton.Checked = false;
            }
            else
            {
                ParentItemIsBulkRadioButton.Checked = false;
                ParentItemIsNotBulkRadioButton.Checked = true;
            }
            if (dt.Rows[0]["BOMReqd"].ToString() == "True")
            {
                BomIsRequiredRadioButton.Checked = true;
                BomIsNotRequiredRadioButton.Checked = false;
            }
            else
            {
                BomIsRequiredRadioButton.Checked = false;
                BomIsNotRequiredRadioButton.Checked = true;
            }
            NeedFactorTextBox.Text = string.Format(Num2Format, dt.Rows[0]["ROPNeedFactor"]);
            HiddenID.Value = dt.Rows[0]["pVelocityCodeID"].ToString();
            AddEditUpdatePanel.Update();
            SaveButton.Visible = true;
            AddButt.Visible = false;
            CommandUpdatePanel.Update();
        }
    }

    public bool ValidData()
    {
        if (VelocityCodeTextBox.Text.Trim().Length == 0)
        {
            ShowPageMessage("A Velocity Code is required.", 2);
            MRPScriptManager.SetFocus("VelocityCodeTextBox");
            return false;
        }
        if (VelCodeDescTextBox.Text.Trim().Length == 0)
        {
            ShowPageMessage("A Velocity Code Description is required.", 2);
            MRPScriptManager.SetFocus("VelocityCodeTextBox");
            return false;
        }
        if (!decimal.TryParse(ROPCartonsTextBox.Text, out ROPCartons))
        {
            ShowPageMessage("Minimum ROP Cartons is invalid. A number is required.", 2);
            MRPScriptManager.SetFocus("ROPCartonsTextBox");
            return false;
        }
        if (!decimal.TryParse(NeedFactorTextBox.Text, out NeedFactor))
        {
            ShowPageMessage("Need Factor is invalid. A number is required.", 2);
            MRPScriptManager.SetFocus("NeedFactorTextBox");
            return false;
        }
        ParentIsBulk = 0;
        if (ParentItemIsBulkRadioButton.Checked) ParentIsBulk = 1;
        BOMRequired = 0;
        if (BomIsRequiredRadioButton.Checked) BOMRequired = 1;
        return true;
    }

    public void SaveData(Object sender, ImageClickEventArgs e)
    {
        if (ValidData())
        {
            dt = mrpCalc.WorkVelocityData("Update", 0, VelocityCodeTextBox.Text, VelCodeDescTextBox.Text, ROPCartons, NeedFactor, ParentIsBulk, BOMRequired, Session["UserName"].ToString(), "Unable to update record");
            if (dt != null)
            {
                RefreshGrid();
                ClearEntry();
                ShowPageMessage("Velocity updated.", 0);
                VelocityCodeTextBox.Enabled = true;
            }
        }
    }

    public void AddData(Object sender, ImageClickEventArgs e)
    {
        if (ValidData())
        {
            dt = mrpCalc.WorkVelocityData("Add", 0, VelocityCodeTextBox.Text, VelCodeDescTextBox.Text, ROPCartons, NeedFactor, ParentIsBulk, BOMRequired, Session["UserName"].ToString(), "Unable to add record");
            if (dt != null)
            {
                RefreshGrid();
                ClearEntry();
                ShowPageMessage("Velocity added.", 0);
            }
        }
    }

    public void DeleteData(Object sender, EventArgs e)
    {
        //ScriptManager.RegisterClientScriptBlock(MaintGridPanel, MaintGridPanel.GetType(), "PostDeletePrompt", "alert('test');", true);
        //ShowPageMessage("Deleting " + HiddenID.Value.ToString(), 2);
        dt = mrpCalc.WorkVelocityData("Delete", 0, HiddenID.Value.ToString(), "", 0, 0, 0, 0, Session["UserName"].ToString(), "Unable to delete record");
        //if (dt != null)
        //{
        RefreshGrid();
        ClearEntry();
        ShowPageMessage("Velocity deleted.", 0);
        //}
    }

    public void EditHandler(Object sender, GridViewEditEventArgs e)
    {
        try
        {
            gvrow = MaintGrid.Rows[e.NewEditIndex];
            LoadEntryData(gvrow.Cells[1].Text.ToString());
            MRPScriptManager.SetFocus("VelCodeDescTextBox");
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
            DataView dv = new DataView((DataTable)Session["MRPMaintVelocity"]);
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
        VelocityCodeTextBox.Text = "";
        VelCodeDescTextBox.Text = "";
        ROPCartonsTextBox.Text = "";
        ParentItemIsBulkRadioButton.Checked = false;
        ParentItemIsNotBulkRadioButton.Checked = true;
        BomIsRequiredRadioButton.Checked = false;
        BomIsNotRequiredRadioButton.Checked = true;
        NeedFactorTextBox.Text = "";
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