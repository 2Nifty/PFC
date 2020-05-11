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

public partial class ProcessMaint : System.Web.UI.Page 
{
    #region Variables
    //string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    //DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataTable LinkedFilters = new DataTable();
    DataTable LinkedSteps = new DataTable();
    DataRow dtrow;
    GridViewRow gvrow;
    int IncludeUnPlated;
    private string Num2Format = "{0:####,###,##0.00} ";
    MRPCalc mrpCalc = new MRPCalc();
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadProcessDDL();
            LoadFilterDDL();
            LoadStepDDL();
            PackBranchDropDownList.DataSource = CheckError(mrpCalc.GetBranches());
            PackBranchDropDownList.DataBind();
            ClearEntry();
            ShowPageMessage("Select a Process from the Drop Down and Click on Search to work a process. Or Click on the Add button to Add a New Process.", 0);

        }
        else
        {
        }
        // Initializing AJAX.NET Library 
        Ajax.Utility.RegisterTypeForAjax(typeof(ProcessMaint));
    }

    #region Load Drop Down Lists
    protected void LoadProcessDDL()
    {
        dt = CheckError(mrpCalc.MstrConfigDataGetAll());
        if (dt != null)
        {
            ProcessDropDown.DataSource = dt;
            ProcessDropDown.DataBind();
        }
        else
            ShowPageMessage("No Processes are on file.", 2);
    }

    protected void LoadFilterDDL()
    {
        FilterDropDown.DataSource = CheckError(mrpCalc.CatRngDataGetAll());
        FilterDropDown.DataBind();
    }

    protected void LoadStepDDL()
    {
        StepDropDown.DataSource = CheckError(mrpCalc.StepDataGetAll());
        StepDropDown.DataBind();
    }
    #endregion

    #region Work Process Configuration
    public void SearchData(Object sender, ImageClickEventArgs e)
    {
        LoadEntryData(ProcessDropDown.SelectedValue);
    }

    public void LoadEntryData(string MstrConfigCode)
    {
        try
        {
            ClearEntry();
            ClearPageMessages();
            PageFunc.Value = "Upd";
            Session["Process"] = CheckError(mrpCalc.MstrConfigDataGetConfig(MstrConfigCode));
            dt = (DataTable)Session["Process"];
            if (dt != null)
            {
                MstrConfigCodeTextBox.Text = dt.Rows[0]["ConfigName"].ToString();
                MstrConfigCodeTextBox.Enabled = false;
                MRPScriptManager.SetFocus("MstrConfigNameTextBox");
                MstrConfigNameTextBox.Text = dt.Rows[0]["ConfigDesc"].ToString();
                PackBranchDropDownList.SelectedValue = dt.Rows[0]["PackBranch"].ToString().Trim();
                if (dt.Rows[0]["IncludeUnplated"].ToString() == "True")
                {
                    IncUnPlatedCheckBox.Checked = true;
                }
                else
                {
                    IncUnPlatedCheckBox.Checked = false;
                }
                HiddenID.Value = dt.Rows[0]["pMasterConfigID"].ToString();
                CurProcess.Value = dt.Rows[0]["ConfigName"].ToString();
                ProcessUpdatePanel.Visible = true;
                ProcessUpdatePanel.Update();
                ProcessSaveButton.Visible = true;
                AddButt.Visible = false;
                CommandUpdatePanel.Update();
                ShowFilters();
                ShowSteps();
                UpdateTree();
            }
        }
        catch (Exception e2)
        {
            ShowPageMessage("Data Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    protected void ClearEntry()
    {
        // clear process data
        MRPScriptManager.SetFocus("ProcessDropDown");
        MstrConfigCodeTextBox.Text = "";
        MstrConfigNameTextBox.Text = "";
        IncUnPlatedCheckBox.Checked = false;
        ProcessUpdatePanel.Update();
        ProcessUpdatePanel.Visible = false;
        Session["Process"] = null;
        // set buttons
        AddButt.Visible = true;
        CommandUpdatePanel.Update();
        // clear tree
        ProcessTreeView.Visible = false;
        // clear filters
        FilterUpdatePanel.Visible = false;
        Session["LinkedFilters"] = null;
        LinkedFilters = null;
        FilterGrid.DataBind();
        // clear steps
        StepUpdatePanel.Visible = false;
        StepGrid.DataBind();
        Session["LinkedSteps"] = null;
        LinkedSteps = null;
    }

    private void UpdateTree()
    {
        string ProcessData;
        string CurFilter;
        string CurStep;
        ProcessData = "";
        CurFilter = "";
        CurStep = "";
        try
        {
            dt = (DataTable)Session["Process"];
            dtrow = dt.Rows[0];
            ProcessTreeView.Nodes.Clear();
            TreeNode CurNode1 = new TreeNode();
            ProcessData = "Process: <B>" + MstrConfigCodeTextBox.Text.ToString() + " - " + MstrConfigNameTextBox.Text.ToString()
                + "</B><br>  Packing Branch: <B>" + PackBranchDropDownList.SelectedItem.Value.ToString() + "</B>  Include UnPlated is: <B>"
                + IncUnPlatedCheckBox.Checked.ToString() + "</B>";
            CurNode1.SelectAction = TreeNodeSelectAction.None;
            CurNode1.Text = ProcessData;
            ProcessTreeView.Nodes.Add(CurNode1);
            LinkedFilters = (DataTable)Session["LinkedFilters"];
            if ((LinkedFilters != null) && (LinkedFilters.Rows.Count > 0))
            {
                foreach (DataRow LinkRow in LinkedFilters.Rows)
                {
                    TreeNode FilterNode = new TreeNode();
                    CurFilter = "<hr>Filter: <B>" + LinkRow["FilterCode"].ToString() + " - " + LinkRow["FilterName"].ToString()
                        + "</B><br>Categories: <B>" + LinkRow["BegCategory"].ToString() + "</B> - <B>" + LinkRow["EndCategory"].ToString() + "</B><br>"
                        + "Packages: <B>" + LinkRow["PackageRange"].ToString() + "</B><br>"
                        + "Plating: <B>" + LinkRow["PlateRange"].ToString() + "</B>";
                    FilterNode.SelectAction = TreeNodeSelectAction.None;
                    FilterNode.Text = CurFilter;
                    ProcessTreeView.Nodes[0].ChildNodes.Add(FilterNode);
                }
            }
            else
            {
                TreeNode StepNode = new TreeNode();
                CurStep = "<hr>No Category Filters are currently linked.";
                StepNode.SelectAction = TreeNodeSelectAction.None;
                StepNode.Text = CurStep;
                ProcessTreeView.Nodes[0].ChildNodes.Add(StepNode);
            }
            LinkedSteps = (DataTable)Session["LinkedSteps"];
            if ((LinkedSteps != null) && (LinkedSteps.Rows.Count > 0))
            {
                foreach (DataRow StepRow in LinkedSteps.Rows)
                {
                    TreeNode StepNode = new TreeNode();
                    CurStep = "<hr>Step: <B>" + StepRow["StepCode"].ToString() + " - " + StepRow["StepName"].ToString()
                        + "</B><br>  Order: <B>" + StepRow["RunOrder"].ToString() + "</B>  ROP Factor: <B>"
                        + string.Format(Num2Format, StepRow["ParentROPProtectionFactor"]) + "</B><br>";
                    StepNode.SelectAction = TreeNodeSelectAction.None;
                    StepNode.Text = CurStep;
                    ProcessTreeView.Nodes[0].ChildNodes.Add(StepNode);
                }
            }
            else
            {
                TreeNode StepNode = new TreeNode();
                CurStep = "<hr>No Steps are currently linked.";
                StepNode.SelectAction = TreeNodeSelectAction.None;
                StepNode.Text = CurStep;
                ProcessTreeView.Nodes[0].ChildNodes.Add(StepNode);
            }
            ProcessTreeView.ExpandAll();
            ProcessTreeView.Visible = true;
        }
        catch (Exception e2)
        {
            ShowPageMessage("Tree Refresh Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    public bool ValidData()
    {
        if (MstrConfigCodeTextBox.Text.Trim().Length == 0)
        {
            ShowPageMessage("A Process Code is required.", 2);
            return false;
        }
        if (MstrConfigNameTextBox.Text.Trim().Length == 0)
        {
            ShowPageMessage("A Process Name is required.", 2);
            return false;
        }
        IncludeUnPlated = 0;
        if (IncUnPlatedCheckBox.Checked) IncludeUnPlated = 1;
        return true;
    }

    public void SaveData(Object sender, ImageClickEventArgs e)
    {
        if (ValidData())
        {
            if (PageFunc.Value == "Add")
            {
                dt = CheckError(mrpCalc.WorkMstrConfigData("Add", 0, MstrConfigCodeTextBox.Text, MstrConfigNameTextBox.Text, 
                    PackBranchDropDownList.SelectedValue, IncludeUnPlated, "", "", Session["UserName"].ToString()));
                if (dt != null)
                {
                    LoadProcessDDL();
                    ClearEntry();
                    ShowPageMessage("Process added.", 0);
                }
            }
            else
            {
                dt = CheckError(mrpCalc.WorkMstrConfigData("Update", 0, MstrConfigCodeTextBox.Text, MstrConfigNameTextBox.Text, 
                    PackBranchDropDownList.SelectedItem.Value.ToString().Trim(), IncludeUnPlated, "", "", Session["UserName"].ToString()));
                if (dt != null)
                {
                    ClearEntry();
                    ShowPageMessage("Process updated.", 0);
                    MstrConfigCodeTextBox.Enabled = true;
                }
            }
        }
    }

    public void StartAdd(Object sender, ImageClickEventArgs e)
    {
        ProcessUpdatePanel.Visible = true;
        ShowPageMessage("Enter the Process data and click on Accept.", 0);
        PageFunc.Value = "Add";
        MstrConfigCodeTextBox.Enabled = true;
        MRPScriptManager.SetFocus("MstrConfigCodeTextBox");
        //ProcessUpdatePanel.Update();
    }

    public void AddData(Object sender, ImageClickEventArgs e)
    {
        if (ValidData())
        {
            dt = CheckError(mrpCalc.WorkMstrConfigData("Add", 0, MstrConfigCodeTextBox.Text, MstrConfigNameTextBox.Text,
                PackBranchDropDownList.SelectedValue, IncludeUnPlated, "", "", Session["UserName"].ToString()));
            if (dt != null)
            {
                ClearEntry();
                ShowPageMessage("Process added.", 0);
            }
        }
    }

    public void DeleteData(Object sender, EventArgs e)
    {
        //ScriptManager.RegisterClientScriptBlock(MaintGridPanel, MaintGridPanel.GetType(), "PostDeletePrompt", "alert('test');", true);
        //ShowPageMessage("Deleting " + HiddenID.Value.ToString(), 2);
        //dt = WorkMstrConfigData("Delete", 0, HiddenID.Value.ToString(), "", "", 0, "Unable to delete record");
        ////if (dt != null)
        ////{
        //RefreshGrid();
        //ClearEntry();
        //ShowPageMessage("Process deleted.", 0);
        ////}
    }

    public void CloseProcessPane(Object sender, ImageClickEventArgs e)
    {
        ClearEntry();
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string ProcessValidate(string MstrConfigCode)
    {
        string status = "";
        try
        {
            // validate that the process has at least one filter and one step
            dt = CheckError(mrpCalc.MstrConfigValidate(MstrConfigCode));
            if (dt != null)
            {
                if (((int)dt.Rows[0]["FilterCount"] > 0) && ((int)dt.Rows[0]["StepCount"] > 0))
                {
                    status = "true";
                    return status;
                }
                if ((int)dt.Rows[0]["FilterCount"] == 0)
                {
                    status = "You must add at least one Category Filter. ";
                }
                if ((int)dt.Rows[0]["StepCount"] == 0)
                {
                    status = "You must add at least one Process Step. ";
                }
            }
        }
        catch (Exception e2)
        {
            return "!!" + e2.ToString();
        }
        return status;
    }

    #endregion

    #region Work Category Filters
    private void ShowFilters()
    {
        // show linked filters
        FilterUpdatePanel.Visible = true;
        LinkedFilters = CheckError(mrpCalc.MstrConfigDataGetFilters(CurProcess.Value));
        if ((LinkedFilters != null) && (LinkedFilters.Rows.Count > 0))
        {
            Session["LinkedFilters"] = LinkedFilters;
            FilterGrid.DataSource = LinkedFilters;
            FilterGrid.DataBind();
        }
        else
        {
            Session["LinkedFilters"] = null;
            FilterGrid.DataBind();
            ShowPageMessage("No Category Filter are linked. Used the Add button to create a new link", 0, FilterMessage, FilterUpdatePanel);
        }
    }
 
    public void FilterSave(Object sender, ImageClickEventArgs e)
    {
        Boolean AddOK = true;
        try
        {
            if (Session["LinkedFilters"] != null)
            {
                // Create a DataView from the filters already linked.
                DataView dv = new DataView((DataTable)Session["LinkedFilters"]);
                dv.RowFilter = "FilterCode = '" + FilterDropDown.SelectedItem.Value.ToString() + "'";
                if (dv.Count > 0)
                {
                    ShowPageMessage("Filter " + FilterDropDown.SelectedItem.Value.ToString() + " is already linked.", 2, FilterMessage, FilterUpdatePanel);
                    AddOK = false;
                }
            }
            if (AddOK)
            {
                dt = CheckError(mrpCalc.MstrConfigDataAddLink("AddFilter", CurProcess.Value,
                    FilterDropDown.SelectedItem.Value, "", Session["UserName"].ToString()));
                ShowPageMessage("Filter linked", 0, FilterMessage, FilterUpdatePanel);
                ShowFilters();
                UpdateTree();
            }
        }
        catch (Exception e2)
        {
            ShowPageMessage("Filter Add Error " + e2.Message + ", " + e2.ToString(), 2);
        }
   }

    public void SortFilterGrid(Object sender, GridViewSortEventArgs e)
    {
        try
        {
            // Create a DataView from the Linked Category filters.
            DataView dv = new DataView((DataTable)Session["LinkedFilters"]);
            dv.Sort = e.SortExpression;
            FilterGrid.DataSource = dv;
            FilterGrid.DataBind();
            //FilterGridPanel.Height = new Unit(double.Parse(FilterGridHeightHidden.Value), UnitType.Pixel);
            //FilterGridPanel.Width = new Unit(double.Parse(FilterGridWidthHidden.Value), UnitType.Pixel);
        }
        catch (Exception e2)
        {
            ShowPageMessage("Filter Sort Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    public void FilterDeleteHandler(Object sender, GridViewDeleteEventArgs e)
    {
        gvrow = FilterGrid.Rows[e.RowIndex];
        dt = CheckError(mrpCalc.MstrConfigDataDeleteLink("DeleteFilter", CurProcess.Value, gvrow.Cells[1].Text.ToString()));
        ShowPageMessage("Category Filter " + gvrow.Cells[1].Text.ToString() + " deleted.", 0, FilterMessage, FilterUpdatePanel);
        ShowFilters();
        UpdateTree();
    }

    #endregion

    #region Work Steps
    private void ShowSteps()
    {
        // show linked steps
        StepUpdatePanel.Visible = true;
        LinkedSteps = CheckError(mrpCalc.MstrConfigDataGetSteps(CurProcess.Value));
        if ((LinkedSteps != null) && (LinkedSteps.Rows.Count > 0))
        {
            StepGrid.DataSource = LinkedSteps;
            StepGrid.DataBind();
            Session["LinkedSteps"] = LinkedSteps;
        }
        else
        {
            StepGrid.DataBind();
            Session["LinkedSteps"] = null;
            ShowPageMessage("No Steps are linked. Used the Add button to create a new link", 0, StepMessage, StepUpdatePanel);
        }
    }
 
    public void StepSave(Object sender, ImageClickEventArgs e)
    {
        Boolean AddOK = true;
        try
        {
            if (Session["LinkedSteps"] != null)
            {
                // Create a DataView from the filters already linked.
                DataView dv = new DataView((DataTable)Session["LinkedSteps"]);
                dv.RowFilter = "StepCode = '" + StepDropDown.SelectedItem.Value.ToString() + "'";
                if (dv.Count > 0)
                {
                    ShowPageMessage("Step " + StepDropDown.SelectedItem.Value.ToString() + " is already linked.", 2, StepMessage, StepUpdatePanel);
                    AddOK = false;
                }
            }
            if (AddOK)
            {
                dt = CheckError(mrpCalc.MstrConfigDataAddLink("AddStep", CurProcess.Value,
                    StepDropDown.SelectedItem.Value, StepRunOrder.Text, Session["UserName"].ToString()));
                LoadEntryData(CurProcess.Value);
                ShowPageMessage("Step linked", 0, StepMessage, StepUpdatePanel);
            }
        }
        catch (Exception e2)
        {
            ShowPageMessage("Step Save Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    public void SortStepGrid(Object sender, GridViewSortEventArgs e)
    {
        try
        {
            // Create a DataView from the Linked Steps.
            DataView dv = new DataView((DataTable)Session["LinkedSteps"]);
            dv.Sort = e.SortExpression;
            StepGrid.DataSource = dv;
            StepGrid.DataBind();
            //FilterGridPanel.Height = new Unit(double.Parse(FilterGridHeightHidden.Value), UnitType.Pixel);
            //FilterGridPanel.Width = new Unit(double.Parse(FilterGridWidthHidden.Value), UnitType.Pixel);
        }
        catch (Exception e2)
        {
            ShowPageMessage("Step Sort Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    public void StepDeleteHandler(Object sender, GridViewDeleteEventArgs e)
    {
        gvrow = StepGrid.Rows[e.RowIndex];
        dt = CheckError(mrpCalc.MstrConfigDataDeleteLink("DeleteStep", CurProcess.Value, gvrow.Cells[2].Text.ToString()));
        ShowPageMessage("Step " + gvrow.Cells[2].Text.ToString() + " deleted.", 0, StepMessage, StepUpdatePanel);
        ShowSteps();
        UpdateTree();
    }

    public void StepEditHandler(Object sender, GridViewEditEventArgs e)
    {
        //try 
        //{OnRowEditing="StepEditHandler"
        //    gvrow = MaintGrid.Rows[e.NewEditIndex];
        //    LoadEntryData(gvrow.Cells[1].Text.ToString());
        //}
        //catch (Exception e2)
        //{
        //    ShowPageMessage("Edit Error " + e2.Message + ", " + e2.ToString(), 2);
        //}
    }

    #endregion

    #region Page Messages
    protected void ClearPageMessages()
    {
        MessageLabel.Text = "";
        CommandUpdatePanel.Update();
    }
    
    protected void ShowPageMessage(string PageMessage, int MessageType)
    {
        ShowPageMessage(PageMessage, MessageType, MessageLabel, CommandUpdatePanel);
    }

    protected void ShowPageMessage(string PageMessage, int MessageType, Label AlertLabel, UpdatePanel MessagePanel)
    {
        switch (MessageType)
        {
            case 1:
                AlertLabel.CssClass = "warn";
                break;
            case 2:
                AlertLabel.CssClass = "error";
                break;
            default:
                AlertLabel.CssClass = "success";
                break;
        }
        //AlertLabel.CssClass = "error";
        AlertLabel.Text = PageMessage;
        MessagePanel.Update();
    }
    #endregion

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