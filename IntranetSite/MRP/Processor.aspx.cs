using System;
using System.IO;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Services;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class Processor : System.Web.UI.Page 
{
    DataTable dt = new DataTable();
    MRPCalc mrpCalc = new MRPCalc();
    IAsyncResult MRPStarter;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadProcessDDL();
            LoadPreviousDDL();
            LoadChildROP();
            if (ProcessRunning())
            {
                AllowProcess(false);
                ShowPageMessage("A Process is currently running (" + dt.Rows[0]["ProcessNo"].ToString() + ").", 2);
            }
            else
                ShowPageMessage("Select a Process the click on Submit.", 0);
            ResultEditUpdatePanel.Visible = false;
            ExcelUpdatePanel.Visible = false;
        }
    }

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

    protected void LoadPreviousDDL()
    {
        PreviousDropDownList.DataSource = CheckError(mrpCalc.WorkProcessResults("0", "Prev"));
        PreviousDropDownList.DataBind();
    }

    protected void LoadChildROP()
    {
        dt = CheckError(mrpCalc.WorkProcessResults("0", "ROP"));
        ChildROPTextBox.Text = dt.Rows[0]["ChildROP"].ToString();
    }

    protected bool ProcessRunning()
    {
        dt = CheckError(mrpCalc.CheckForRunningProcess(Session["UserName"].ToString()));
        if (dt != null)
            return true;
        else
            return false;
    }

    protected void AllowProcess(bool ProcessOK)
    {
        ProcessDropDown.Visible = ProcessOK;
        RunButton.Visible = ProcessOK;
    }

    public void RunButton_Click(Object sender, ImageClickEventArgs e)
    {
        Boolean RunOK = false;
        try
        {
            // validate the process before running.
            dt = CheckError(mrpCalc.MstrConfigValidate(ProcessDropDown.SelectedItem.Value));
            if (dt != null)
            {
                RunOK = true;
                if ((int)dt.Rows[0]["FilterCount"] == 0)
                {
                    ShowPageMessage("This Process does not have a Category Filter. Process Run Aborted.", 2);
                    RunOK = false;
                }
                if ((int)dt.Rows[0]["StepCount"] == 0)
                {
                    ShowPageMessage("This Process does not have a Process Step. Process Run Aborted.", 2);
                    RunOK = false;
                }
            }
            if (RunOK)
            {
                dt = CheckError(mrpCalc.CreateMRPProcess(
                    ProcessDropDown.SelectedItem.Value
                    ,Session["UserName"].ToString()
                    ,RTSBCheckBox.Checked
                    ,OTWCheckBox.Checked
                    ,ChildROPTextBox.Text.ToString()
                    ));
                if (dt != null)
                {
                    AllowProcess(false);
                    ShowPageMessage("The Current Process is " + ProcessDropDown.SelectedItem.Value.ToString(), 0);
                    ProcessID.Value = dt.Rows[0]["MRPProcessID"].ToString();
                    RunService();
                    //Session["MRPChecker"] = MRPStarter;
                }
            }
        }
        catch (Exception e2)
        {
            ShowPageMessage("Run Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    public void DisplayPreviousButton_Click(Object sender, ImageClickEventArgs e)
    {
        ProcessID.Value = PreviousDropDownList.SelectedItem.Value;
        FillGrid();
        FillStats();
    }

    protected void RunService()
    {
        DateTime RunStartTime;
        String StatLabel;
        ResultPanel.Visible = false;
        MainUpdatePanel.Update();
        RunStatPanel.Visible = true;
        MRPTimer.Enabled = true;
        ExecuteGrid.DataBind();
        ProcessLabel.Text = "MRP now starting. Your Process is number " + ProcessID.Value + ".";
        RunStatLabel.Text = "Running MRP Process.......";
        RunStatUpdatePanel.Update();
        Session["RunStartTime"] = DateTime.Now;
        MRPWebReference.MRPWebService mrpWebService = new MRPWebReference.MRPWebService();
        MRPStarter = mrpWebService.BeginStartMRPProcess(ProcessID.Value, null, null);
        //RunStatLabel.Text = MRPStarter.IsCompleted.ToString();
        //RunStatLabel.Text = mrpWebService.StartMRPProcess(ProcessID.Value);
        RunStatUpdatePanel.Update();
    }

    protected void MRPTimer_Tick(Object sender, EventArgs e)
    {
        UpdateRunStat();
    }

    protected void UpdateRunStat()
    {
        String StatLabel;
        try
        {
            //IAsyncResult MRPStarter;
            //MRPStarter = (IAsyncResult)Session["MRPChecker"];
            DateTime RunStartTime = (DateTime)Session["RunStartTime"];
            if (StatusCd.Value.ToString() == "XX")
            {
                AllowProcess(true);
                MRPTimer.Enabled = false;
                RunStatPanel.Visible = false;
                StatLabel = "Process complete.";
                RunStatLabel.Text = StatLabel;
                RunStatUpdatePanel.Update();
                FillGrid();
                FillStats();
                LoadPreviousDDL();
                MainUpdatePanel.Update();
            }
            else
            {
                DateTime.Now.Subtract(RunStartTime);
                StatLabel = "Process '" + ProcessID.Value + "' started at " + RunStartTime.ToString();
                StatLabel += ". Process is still running (" + StatusCd.Value.ToString() +").";
                ExecuteLabel.Text = " Process has been executing " + DateTime.Now.Subtract(RunStartTime).Minutes.ToString() + " minutes and " +
                DateTime.Now.Subtract(RunStartTime).Seconds.ToString() + " seconds. ";
                dt = CheckError(mrpCalc.GetProcessStatus(ProcessID.Value));
                if (dt != null)
                {
                    StatusCd.Value = dt.Rows[0]["StatusCd"].ToString();
                    ExecuteGrid.Visible = true;
                    ExecuteGrid.DataSource = dt;
                    ExecuteGrid.DataBind();
                }
                RunStatLabel.Text = StatLabel;
                RunStatUpdatePanel.Update();
            }
        }
        catch (Exception ex)
        {
            StatLabel = "Process Error " + ex.Message.ToString();
            MRPTimer.Enabled = false;
        }
    }

    private void FillGrid()
    {
        try
        {
            ResultPanel.Visible = true;
            ResultEditUpdatePanel.Visible = false;
            DisableEdit.Value = "0";
            ShowPageMessage("Results for process " + ProcessID.Value + ".", 0);
            dt = CheckError(mrpCalc.WorkProcessResults(ProcessID.Value.ToString(), "Fed"));
            if ((dt != null) && (dt.Rows.Count > 0))
            {
                ResultsGrid.Visible = true;
                ResultsGrid.DataSource = dt;
                ResultsGrid.DataBind();
                Session["MRPResults"] = dt;
                MainUpdatePanel.Update();
            }
            else
                ShowPageMessage("No Results were produced", 0);
        }
        catch (Exception ex)
        {
            ShowPageMessage("Fill Error " + ex.Message.ToString(), 0);
        }

    }

    public void ResultsGridView_RowDataBound(Object sender, GridViewRowEventArgs e)
    {
            // dibale edit command column
            if (DisableEdit.Value == "1")
            {
                e.Row.Cells[0].Visible = false;
            }
    }
    private void FillStats()
    {
        try
        {
            dt = CheckError(mrpCalc.WorkProcessResults(ProcessID.Value.ToString(), "Stats"));
            if ((dt != null) && (dt.Rows.Count > 0))
            {
                StatGrid.DataSource = dt;
                StatGrid.DataBind();
                ExcelUpdatePanel.Visible = true;
                MainUpdatePanel.Update();
            }
            else
                ShowPageMessage("No Stats on file", 0);
        }
        catch (Exception ex)
        {
            ShowPageMessage("Stats Error " + ex.Message.ToString(), 0);
        }

    }

    public void EditResultsGrid(Object sender, GridViewEditEventArgs e)
    {
        try
        {
            ResultEditUpdatePanel.Visible = true;
            EditItemLabel.Text = ResultsGrid.Rows[e.NewEditIndex].Cells[1].Text;
            EditToPackTextBox.Text = ResultsGrid.Rows[e.NewEditIndex].Cells[5].Text;
            EditIDHidden.Value = ResultsGrid.Rows[e.NewEditIndex].Cells[11].Text;
            ResultEditUpdatePanel.Update();
            ScriptManager1.SetFocus("EditToPackTextBox");
        }
        catch (Exception e2)
        {
            ShowPageMessage("Edit Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    public void EditSaveButt_Click(Object sender, ImageClickEventArgs e)
    {
        int ToPack;
        if (int.TryParse(EditToPackTextBox.Text, out ToPack))
        {
            if (ToPack >=0)
            {
                dt = CheckError(mrpCalc.UpdateProcessResults(EditIDHidden.Value, "Upd", ToPack));
                FillGrid();
            }
            else
            {
                ShowPageMessage("Quantity To Pack is cannot be less than zero.", 2);
            }
        }
        else
        {
            ShowPageMessage("Quantity To Pack is invalid. A number is required.", 2);
        }

    }

    public void EditDoneButt_Click(Object sender, ImageClickEventArgs e)
    {
        FillGrid();
    }

    public void SortResultsGrid(Object sender, GridViewSortEventArgs e)
    {
        try
        {
            // Create a DataView from the Results DataTable.
            DataView dv = new DataView((DataTable)Session["MRPResults"]);
            dv.Sort = e.SortExpression;
            ResultsGrid.DataSource = dv;
            ResultsGrid.DataBind();
            //ResultsGrid.Height = new Unit(double.Parse(ResultsGridHeightHidden.Value), UnitType.Pixel);
            //ResultsGrid.Width = new Unit(double.Parse(ResultsGridWidthHidden.Value), UnitType.Pixel);
        }
        catch (Exception e2)
        {
            ShowPageMessage("Sort Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    protected void ExcelExportButton_Click(object sender, ImageClickEventArgs e)
    {
        // 
        CreateExcelFile();
    }

    protected void ShowHungryButton_Click(object sender, ImageClickEventArgs e)
    {
        ShowOtherData("AllHungry", "No Hungry, UnLinked or Zero Need Items were produced");
    }

    protected void FedLinkButton_Click(object sender,  EventArgs e)
    {
        FillGrid();
    }

    protected void HungryLinkButtonn_Click(object sender, EventArgs e)
    {
        ShowOtherData("Hungry", "No Hungry Items were produced");
    }

    protected void NoLinkLinkButton_Click(object sender, EventArgs e)
    {
        ShowOtherData("NoLink", "No Items without Parnets were selected");
    }

    protected void NoNeedLinkButton_Click(object sender, EventArgs e)
    {
        ShowOtherData("NoNeed", "No Items without need were selected");
    }

    protected void ShowOtherData(string DataArg, string DataMessage)
    {
        ClearPageMessages();
        try
        {
            ResultPanel.Visible = true;
            ResultEditUpdatePanel.Visible = false;
            DisableEdit.Value = "1";
            dt = CheckError(mrpCalc.WorkProcessResults(ProcessID.Value.ToString(), DataArg));
            if ((dt != null) && (dt.Rows.Count > 0))
            {
                ResultsGrid.Visible = true;
                ResultsGrid.DataSource = dt;
                Session["MRPResults"] = dt;
            }
            else
                ShowPageMessage(DataMessage, 1);
            ResultsGrid.DataBind();
            MainUpdatePanel.Update();
        }
        catch (Exception ex)
        {
            ShowPageMessage("OtherData Error " + ex.Message.ToString(), 2);
        }
    }

    private void CreateExcelFile()
    {
        //
        // Create the results detail spreadsheet
        //
        // Convert a virtual path to a fully qualified physical path.
        string ExcelFileName = @"../Common/ExcelUploads/MRP" + Session["UserName"].ToString() + ".xls";
        string fullpath = Request.MapPath(ExcelFileName);
        using (StreamWriter sw = new StreamWriter(fullpath))
        {
            sw.Write("Item\tPack Branch\tVelocity Code\tNeed\tNeed ROP Factor\tItem Avail.\tParent Avail\tParent ROP Factor\tStep");
            sw.WriteLine();
            DataView dv = new DataView((DataTable)Session["MRPResults"]);
            //if (LastSortHiddenField.Value.Trim() != "")
            //{
            //    dv.Sort = LastSortHiddenField.Value;
            //}
            foreach (DataRow row in dv.ToTable().Rows)
            {
                sw.Write(row["ItemNo"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["PackBranch"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["PackageVelocity"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["NeedQty"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["ROPNeedFactor"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["NeedAvl"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["ParentAvl"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["ParentROPProtectionFactor"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["StepID"].ToString().Trim());
                sw.Write("\t");
                sw.WriteLine();
            }
        }
        // now open it.
        //
        // Downloading Process
        //
        FileStream fileStream = File.Open(fullpath, FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        //
        // Download Process
        //
        Response.AddHeader("Content-disposition", "attachment; filename=" + fullpath);
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }

    #region Page Messages
    protected void ClearPageMessages()
    {
        MessageLabel.Text = "";
        MainUpdatePanel.Update();
    }

    protected void ShowPageMessage(string PageMessage, int MessageType)
    {
        ShowPageMessage(PageMessage, MessageType, MessageLabel, MainUpdatePanel);
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

    protected void garbage()
    {
         /*    
       DataTable dtFilter = new DataTable();
        dtFilter.Columns.Add("Item", typeof(string));
        dtFilter.Columns.Add("PackBranch", typeof(string));
        dtFilter.Columns.Add("PackageVelocity", typeof(string));
        dtFilter.Columns.Add("NeedQty", typeof(string));
        dtFilter.Columns.Add("QtyToPack", typeof(string));
        dtFilter.Columns.Add("NeedFactor", typeof(string));
        dtFilter.Columns.Add("NeedAvl", typeof(string));
        //dtFilter.Columns.Add("NeedFactor", typeof(string));
        dtFilter.Columns.Add("ParentAvl", typeof(string));
        dtFilter.Columns.Add("ParentProtectionFactor", typeof(string));
        dtFilter.Columns.Add("Process", typeof(string));
        dtFilter.Columns.Add("Step", typeof(string));
        DataRow Filterrow;
        Filterrow = dtFilter.NewRow();
        Filterrow["Item"] = "00200-2400-401";
        Filterrow["PackBranch"] = "01";
        Filterrow["PackageVelocity"] = "B";
        Filterrow["NeedQty"] = "250";
        Filterrow["QtyToPack"] = "250";
        Filterrow["NeedFactor"] = "1.66";
        Filterrow["NeedAvl"] = "50";
        Filterrow["ParentAvl"] = "15";
        Filterrow["ParentProtectionFactor"] = "1.00";
        Filterrow["Process"] = "MAIN";
        Filterrow["Step"] = "OVER150";
        dtFilter.Rows.Add(Filterrow);
        ResultsGrid.DataSource = dtFilter;
        ResultsGrid.DataBind();

        DataTable dtSteps = new DataTable();
        dtSteps.Columns.Add("StepCode", typeof(string));
        dtSteps.Columns.Add("ItemCount", typeof(int));
        dtSteps.Columns.Add("ItemsHungry", typeof(int));
        dtSteps.Columns.Add("FedItemCount", typeof(int));
        DataRow Steprow;
        Steprow = dtSteps.NewRow();
        Steprow["StepCode"] = "OVER150";
        Steprow["ItemCount"] = 1;
        Steprow["ItemsHungry"] = 0;
        Steprow["FedItemCount"] = 1;
        dtSteps.Rows.Add(Steprow);
        StatGrid.DataSource = dtSteps;
        StatGrid.DataBind();
          */

    }
}