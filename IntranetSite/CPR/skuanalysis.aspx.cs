using System;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Drawing;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Utility;
using PFC.Intranet.Securitylayer;

public partial class SKUAnalysis : System.Web.UI.Page 
{
    Utility utility = new Utility();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    string connectionString = ConfigurationManager.ConnectionStrings["csNVEnterprise"].ToString();
    int maxCount = 5000;
    string ProcessLogFileName = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        ProcessLogFileName = @"Excel\" + Session["UserName"].ToString() + "ProcessLog.txt";
        if (!Page.IsPostBack)
        {
            //RunByLabel.Text = Session["UserName"].ToString();
            CatBegTextBox.Focus();
            btnAccept.Visible = false;
            ProcessPanel.Visible = false;
            ActionPanel.Visible = false;
            ActionSubmitButt.Visible = false;
            PrintButt.Visible = false;
            SKUPanel.Visible = false;
            FactorPrompt.Visible = false;
            CPRFactor.Text = "1";
            Session["PageOp"] = "";
            string FullFilePath = Server.MapPath(ProcessLogFileName);
            using (StreamWriter sw = new StreamWriter(FullFilePath))
            {
                sw.WriteLine("Branch Stocking Analysis started at " + DateTime.Now.ToLongDateString() + " " + DateTime.Now.ToLongTimeString());
            }
            LoadBranches();
        }
        else
        {
            SKUPanel.Height = int.Parse(yh.Text.ToString()) - 90;
            ActionPanel.Height = int.Parse(yh.Text.ToString()) - 90;
            ResultsUpdatePanel.Update();
        }
        ScriptManager1.AsyncPostBackTimeout = 1200;
        //ScriptManager1.SetFocus(CatBegTextBox);
        ScriptManager1.RegisterAsyncPostBackControl(BranchListButt);
        //lblErrorMessage.Text = Session["PageOp"];
    }
    protected void Page_LoadComplete(object sender, EventArgs e)
    {
        //lblSuccessMessage.Text = "Load Complete." + Session["PageOp"].ToString() + AppAction.Text;
        if (Session["PageOp"].ToString() == "Process")
        {
            ProcessGrid();
        }
        else
        {
            if (Session["PageOp"].ToString() == "Update") UpdateItems();
        }
        Session["PageOp"] = "";
    }

    protected void BindSKUGrid()
    {
        decimal ROP;
        string CBID = "";
        btnAccept.Visible = false;
        ActionSubmitButt.Visible = false;
        SKUPanel.Visible = false;
        ProcessPanel.Visible = false;
        ActionPanel.Visible = false;
        ClearPageMessages();
        try
        {
            dt = FindItems(CatBegTextBox.Text, CatEndTextBox.Text, PkgBegTextBox.Text, PkgEndTextBox.Text, PlateBegTextBox.Text, PlateEndTextBox.Text);
            if (dt.Rows.Count == 0)
            {
                dt = (DataTable)Session["BranchTable"];
                if (dt.Rows.Count == 0)
                {
                    lblErrorMessage.Text = "You must have a least one Branch in the Branches To Report List.";
                }
                else
                {
                    lblErrorMessage.Text = "No Matching Items.";
                }
            }
            else
            {
                if (dt.Rows.Count < maxCount)
                {
                    // create a sting with hub branch numbers for formating the grid
                    DataTable dtLocal = new DataTable();
                    string HubList = "";
                    dtLocal = (DataTable)Session["BranchTable"];
                    DataView dv = new DataView(dtLocal, "IsHub", "SortKey", DataViewRowState.CurrentRows);
                    dtLocal = dv.ToTable();
                    if (dtLocal.Rows.Count > 0)
                    {
                        for (int i = 0; i < dv.Count; i++)
                        {
                            DataRow drow = dtLocal.Rows[i];
                            HubList += drow["Code"].ToString() + ":";
                        }
                    }
                    btnAccept.Visible = true;
                    PrintButt.Visible = true;
                    SKUPanel.Visible = true;
                    BranchPanel.Visible = false;
                    TableRow HdrRow = new TableRow();
                    for (int t = 0; t < dt.Columns.Count; t++)
                    {
                        TableCell Sku01 = new TableCell();
                        Sku01.Text = "<b>" + dt.Columns[t].ColumnName + "</b>";
                        Sku01.HorizontalAlign = HorizontalAlign.Center;
                        if (HubList.Contains(dt.Columns[t].ColumnName))
                        {
                            Sku01.CssClass = "isHub";
                        }
                        HdrRow.Cells.Add(Sku01);
                    }
                    WorkTable.Rows.Add(HdrRow);
                    for (int r = 0; r < dt.Rows.Count; r++)
                    {
                        TableRow SKURow = new TableRow();
                        if (r % 2 == 1) SKURow.BackColor = Color.White;
                        TableCell SkuItem = new TableCell();
                        SkuItem.Text = "<b>" + dt.Rows[r].ItemArray[0].ToString() + "</b>";
                        SkuItem.Width = 100;
                        SkuItem.HorizontalAlign = HorizontalAlign.Center;
                        SkuItem.Wrap = false;
                        SKURow.Cells.Add(SkuItem);
                        TableCell SkuSize = new TableCell();
                        SkuSize.Text = dt.Rows[r].ItemArray[1].ToString();
                        SkuSize.Width = 100;
                        SkuSize.HorizontalAlign = HorizontalAlign.Center;
                        SkuSize.Wrap = false;
                        SKURow.Cells.Add(SkuSize);
                        TableCell SkuCFV = new TableCell();
                        SkuCFV.Text = dt.Rows[r].ItemArray[2].ToString();
                        SkuCFV.Width = 50;
                        SkuCFV.HorizontalAlign = HorizontalAlign.Center;
                        SkuCFV.Wrap = false;
                        SKURow.Cells.Add(SkuCFV);
                        for (int t = 3; t < dt.Columns.Count; t++)
                        {
                            TableCell Sku02 = new TableCell();
                            string SKU = dt.Rows[r].ItemArray[t].ToString();
                            //SKU = ;
                            //Sku02.Text = SKU;
                            CheckBox cb = new CheckBox();
                            cb.Checked = false;
                            CBID = "SK_" + dt.Rows[r].ItemArray[0].ToString() + "_" + dt.Columns[t].ColumnName;
                            if (Decimal.TryParse(SKU, out ROP))
                            {
                                Sku02.CssClass = "nSVC";
                                CBID += "_A_" + SKU;
                            }
                            else
                            {
                                if (SKU.Trim() == "Z")
                                {
                                    SKU = " ";
                                    Sku02.CssClass = "noSKU";
                                    CBID += "_C";
                                }
                                else
                                {
                                    Sku02.CssClass = "hasSKU";
                                    CBID += "_B";
                                }
                            }
                            if (HubList.Contains(dt.Columns[t].ColumnName))
                            {
                                Sku02.CssClass = "isHub";
                            }
                            cb.ID = CBID;
                            cb.Text = SKU;
                            cb.TextAlign = TextAlign.Left;
                            cb.Height = 18;
                            Sku02.HorizontalAlign = HorizontalAlign.Right;
                            Sku02.Wrap = false;
                            Sku02.Controls.Add(cb);
                            SKURow.Cells.Add(Sku02);
                        }
                        WorkTable.Rows.Add(SKURow);
                        if (r % 30 == 29)
                        {
                            TableRow SubHdrRow = new TableRow();
                            for (int t = 0; t < dt.Columns.Count; t++)
                            {
                                TableCell Sku01 = new TableCell();
                                Sku01.Text = "<b>" + dt.Columns[t].ColumnName + "</b>";
                                Sku01.HorizontalAlign = HorizontalAlign.Center;
                                if (HubList.Contains(dt.Columns[t].ColumnName))
                                {
                                    Sku01.CssClass = "isHub";
                                }
                                SubHdrRow.Cells.Add(Sku01);
                            }
                            WorkTable.Rows.Add(SubHdrRow);
                        }
                    }
                    SKUPanel.Controls.Add(WorkTable);
                }
                else
                {
                    lblErrorMessage.Text = "To Many Items. Max items to work a one time is " + maxCount.ToString();
                }
            }
        }
        catch (Exception ex)
        {
            lblErrorMessage.Text = "Problem finding Items.";
        }
    }

    protected void ProcessGrid()
    {
        string ProcessItem = "";
        string ProcessLoc = "";
        string ProcessState = "";
        char[] delimiterChars = { '_' };
        int loop1, loop2, processCtr;
        System.Collections.Specialized.NameValueCollection coll;
        processCtr = 0;
        // Scan for checked boxes.
        coll = Request.Form;
        // Put the names of all keys into a string array.
        String[] arr1 = coll.AllKeys;
        TableRow HdrRow = new TableRow();
        TableCell ActHdr01 = new TableCell();
        ActHdr01.Text = "<b>Item</b>";
        ActHdr01.HorizontalAlign = HorizontalAlign.Center;
        HdrRow.Cells.Add(ActHdr01);
        TableCell ActHdr02 = new TableCell();
        ActHdr02.Text = "<b>Loc</b>";
        ActHdr02.HorizontalAlign = HorizontalAlign.Center;
        HdrRow.Cells.Add(ActHdr02);
        TableCell ActHdr03 = new TableCell();
        ActHdr03.Text = "<b>Current SKU State</b>";
        ActHdr03.HorizontalAlign = HorizontalAlign.Center;
        HdrRow.Cells.Add(ActHdr03);
        TableCell ActHdr04 = new TableCell();
        ActHdr04.Text = "<b>Action to be Apllied to SKU</b>";
        ActHdr04.HorizontalAlign = HorizontalAlign.Center;
        HdrRow.Cells.Add(ActHdr04);
        TableCell ActHdr05 = new TableCell();
        ActHdr05.Text = "<b>ROP</b>";
        ActHdr05.HorizontalAlign = HorizontalAlign.Center;
        HdrRow.Cells.Add(ActHdr05);
        ActionTable.Rows.Add(HdrRow);
        for (loop1 = 0; loop1 < arr1.Length; loop1++)
        {
            TableRow SKURow = new TableRow();
            TableCell SkuItem = new TableCell();
            SkuItem.Width = 100;
            SkuItem.HorizontalAlign = HorizontalAlign.Center;
            HyperLink CPRLink = new HyperLink();
            CPRLink.ToolTip = "Click here to get a CPR report for this item using the Factor at the top of the page";
            TableCell SkuLoc = new TableCell();
            SkuLoc.Width = 50;
            SkuLoc.HorizontalAlign = HorizontalAlign.Center;
            TableCell SkuState = new TableCell();
            SkuState.Width = 200;
            TableCell SkuAction = new TableCell();
            SkuAction.Width = 300;
            CheckBox ActionConfirm = new CheckBox();
            ActionConfirm.Checked = true;
            TableCell SkuROP = new TableCell();
            TextBox ActionNewROP = new TextBox();
            ActionNewROP.Width = 40;
            ActionNewROP.CssClass = "ropBox";
            //processLog += "Key: " + arr1[loop1] + " ";
            if (arr1[loop1].StartsWith("SK"))
            {
                ProcessItem = arr1[loop1].Split(delimiterChars)[1];
                CPRLink.Text = ProcessItem;
                CPRLink.NavigateUrl = "javascript:CPRReport('" + ProcessItem + "');";
                ProcessLoc = arr1[loop1].Split(delimiterChars)[2];
                SkuLoc.Text = ProcessLoc;
                ProcessState = arr1[loop1].Split(delimiterChars)[3];
                ActionNewROP.Text = "";
                switch (ProcessState)
                {
                    case "A":
                        SkuState.Text = "<b>Unstocked</b> : Has SKU : SVC = N";
                        SkuState.CssClass = "nSVCAction";
                        ActionConfirm.Text = "<b>Stock</b> : SVC will be set to K";
                        SkuAction.CssClass = "hasSKU";
                        ActionNewROP.Text = arr1[loop1].Split(delimiterChars)[4].ToString().Trim();
                        break;
                    case "B":
                        SkuState.Text = "<b>Stocked</b> : Has SKU : SVC = A-K";
                        SkuState.CssClass = "hasSKU";
                        ActionConfirm.Text = "<b>Unstock</b> : SVC will be set to N";
                        SkuAction.CssClass = "nSVCAction";
                        break;
                    case "C":
                        SkuState.Text = "<b>Unstocked</b> : No SKU ";
                        SkuState.CssClass = "noSKU";
                        ActionConfirm.Text = "<b>Stock</b> : SKU record will be added";
                        SkuAction.CssClass = "hasSKU";
                        break;
                }
                SkuItem.Controls.Add(CPRLink);
                SKURow.Cells.Add(SkuItem);
                SKURow.Cells.Add(SkuLoc);
                SKURow.Cells.Add(SkuState);
                ActionConfirm.ID = "ACT" + arr1[loop1];
                SkuAction.Controls.Add(ActionConfirm);
                SKURow.Cells.Add(SkuAction);
                ActionNewROP.ID = "ROP" + arr1[loop1];
                SkuROP.Controls.Add(ActionNewROP);
                SKURow.Cells.Add(SkuROP);
                ActionTable.Rows.Add(SKURow);
                processCtr++;
            }
        }
        btnAccept.Visible = false;
        PrintButt.Visible = false;
        if (processCtr > 0)
        {
            SKUPanel.Visible = false;
            ActionPanel.Visible = true;
            ActionSubmitButt.Visible = true;
        }
        else
        {
            lblErrorMessage.Text = "You did not select any items to be processed. ";
        }
        //FindUpdatePanel.Update();
        //ProcessPanel.Visible = true;
        //}
        //catch (Exception ex) { }
    }

    protected void UpdateItems()
    {
        string processLog = "Update results at " + DateTime.Now.ToLongTimeString() + "\n";
        btnAccept.Visible = false;
        ActionSubmitButt.Visible = false;
        PrintButt.Visible = false;
        string ProcessItem = "";
        string ProcessLoc = "";
        string ProcessState = "";
        string ProcessROP = "";
        char[] delimiterChars = { '_' };
        int loop1, loop2, processCtr;
        System.Collections.Specialized.NameValueCollection coll;
        processCtr = 0;
        // Scan for checked boxes.
        coll = Request.Form;
        // Put the names of all keys into a string array.
        String[] arr1 = coll.AllKeys;
        for (loop1 = 0; loop1 < arr1.Length; loop1++)
        {
            if (arr1[loop1].StartsWith("ACTSK"))
            {
                ProcessItem = arr1[loop1].Split(delimiterChars)[1];
                ProcessLoc = arr1[loop1].Split(delimiterChars)[2];
                ProcessState = arr1[loop1].Split(delimiterChars)[3];
                processLog += ProcessItem + " Loc:" + ProcessLoc + " ";
                switch (ProcessState)
                {
                    case "A":
                        processLog += "SVC=K, Stocked=On.";
                        break;
                    case "B":
                        processLog += "SVC=N, Stocked=Off.";
                        break;
                    case "C":
                        processLog += "SKU added, SVC=K, Stocked=On.";
                        break;
                }
                ProcessROP = coll[loop1 + 1];
                if (ProcessROP != "")
                {
                    processLog += " ROP = " + ProcessROP;
                }
                int result = SqlHelper.ExecuteNonQuery(connectionString, "[pSKUAnalysisUpd]",
                    new SqlParameter("@Item", ProcessItem),
                    new SqlParameter("@Loc", ProcessLoc),
                    new SqlParameter("@Action", ProcessState),
                    new SqlParameter("@NewROP", ProcessROP));
                processLog += "\n";
                processCtr++;
            }
        }
        processLog += processCtr.ToString() + " processed.";
        ProcessLogTextBox.Text = processLog;
        // Add to Process log
        string FullFilePath = Server.MapPath(ProcessLogFileName);
        using (StreamWriter sw = new StreamWriter(FullFilePath, true))
        {
            sw.WriteLine(processLog);
        }
        SKUPanel.Visible = false;
        ProcessPanel.Visible = true;
        //BranchPanel.Visible = true;
        ActionPanel.Visible = false;
        ActionSubmitButt.Visible = false;
        Session["PageOp"] = "";
        CatBegTextBox.Focus();
        if (processCtr == 0)
        {
            lblErrorMessage.Text = "You did not select any items for updating.";
        }
        //FindUpdatePanel.Update();
        //}
        //catch (Exception ex) { }
    }

    protected virtual void SortCurItems(object source, GridViewSortEventArgs e)
    {
        //// Retrieve the data source from Session state.
        //dt = (DataTable)Session["CurItems"];

        //// Create a DataView from the DataTable.
        //DataView dv = new DataView(dt);

        //// The DataView provides an easy way to sort. Simply set the
        //// Sort property with the name of the field to sort by.
        //dv.Sort = e.SortExpression;

        //// Re-bind the data source and specify that it should be sorted
        //// by the field specified in the SortExpression property.
        //SKUGrid.DataSource = dv;
        //SKUGrid.DataBind();
    }

    protected void ItemSearchButt_Click(object sender, ImageClickEventArgs e)
    {
        BindSKUGrid();
        ResultsUpdatePanel.Update();
        CatBegTextBox.Focus();
        FactorPrompt.Visible = false;
        //FindUpdatePanel.Update();
    }

    protected void BranchListButt_Click(object sender, ImageClickEventArgs e)
    {
        Session["PageOp"] = "List";
        btnAccept.Visible = false;
        ProcessPanel.Visible = false;
        ActionPanel.Visible = false;
        ActionSubmitButt.Visible = false;
        PrintButt.Visible = false;
        SKUPanel.Visible = false;
        BranchPanel.Visible = true;
        ResultsUpdatePanel.Update();
    }

    protected void AcceptButt_Click(object sender, ImageClickEventArgs e)
    {
        Session["PageOp"] = "Process";
        FactorPrompt.Visible = true;
    }

    protected void UpdateButt_Click(object sender, ImageClickEventArgs e)
    {
        Session["PageOp"] = "Update";
        FactorPrompt.Visible = false;
    }

    public DataTable FindItems(string BegCat, string EndCat, string BegPkg, string EndPkg, string BegPlt, string EndPlt)
    {
        DataTable dtLocal = new DataTable();
        DataTable dtHead = new DataTable();
        string SortString = "";
        //try
        //{
            dt = (DataTable)Session["BranchTable"];
            if (dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow drow = dt.Rows[i];
                    SortString += drow["Code"].ToString();
                    SortString += ";" + drow["SortKey"].ToString() + ":";
                }
            }
            DataSet dsLocal = SqlHelper.ExecuteDataset(connectionString, "[pSKUAnalysisFind]",
                new SqlParameter("@BegCat", BegCat),
                new SqlParameter("@EndCat", EndCat),
                new SqlParameter("@BegPkg", BegPkg),
                new SqlParameter("@EndPkg", EndPkg),
                new SqlParameter("@BegPlt", BegPlt),
                new SqlParameter("@EndPlt", EndPlt),
                new SqlParameter("@SortKeys", SortString));
            if (dsLocal.Tables.Count == 2)
            {
                dtLocal = dsLocal.Tables[0];
                dtHead = dsLocal.Tables[1];
                int ColCount = dtHead.Rows.Count + 3;
                int ColMax = dtLocal.Columns.Count;
                int ColCtr = 3;
                foreach (DataRow drow in dtHead.Rows)
                {
                    dtLocal.Columns[ColCtr].ColumnName = drow[0].ToString();
                    ColCtr++;
                }
                DataColumnCollection columns = dtLocal.Columns;
                for (int i = ColCount; i < ColMax; i++)
                {
                    columns.Remove(dtLocal.Columns[ColCount]);
                }
                DataView dv = new DataView(dtLocal, "", "Item", DataViewRowState.CurrentRows);
                dtLocal = dv.ToTable();
            }
            return dtLocal;
        //}
        //catch (Exception ex)
        //{
        //    return null;
        //}
    }

    public void LoadBranches()
    {
        if (Session["BranchTable"] != null)
        {
            try
            {
                dt = (DataTable)Session["BranchTable"];
                if (dt.Rows.Count == 0)
                {
                    //ResetBranches("Branches");
                }
                else
                {
                    BranchGrid.DataSource = dt;
                    BranchGrid.DataBind();
                }
            }
            catch { };
        }
        else
        {
            //ResetBranches("Branches");
        }
        ResetBranches("Loader");
    }

    public void ClearBranches(Object sender, EventArgs e)
    {
        if (Session["BranchTable"] != null)
        {
            try
            {
                dt = (DataTable)Session["BranchTable"];
                dt.Rows.Clear();
                BranchGrid.DataSource = dt;
                BranchGrid.DataBind();
                Session["BranchTable"] = dt;
            }
            catch { };
        }
        CatBegTextBox.Focus();
    }

    public void AddAllBranches(Object sender, EventArgs e)
    {
        ResetBranches("Branches");
        CatBegTextBox.Focus();
    }

    public void ShowFullLog(Object sender, EventArgs e)
    {
        string FullFilePath = Server.MapPath(ProcessLogFileName);
        string processLog = "";
        using (StreamReader sr = new StreamReader(FullFilePath))
        {
            while (sr.Peek() >= 0)
            {
                processLog += sr.ReadLine() + "\n";
            }
        }
        ProcessLogTextBox.Text = processLog;
    }

    protected void ResetBranches(string GridToLoad)
    {
        DataTable dtLocal = new DataTable();
        //try
        //{
        DataSet dsLocal = SqlHelper.ExecuteDataset(connectionString, "[pSKUAnalysisLocs]");
        if (dsLocal.Tables.Count == 1)
        {
            dtLocal = dsLocal.Tables[0];
            dtLocal.Columns.Add("IsHub", typeof(Boolean));
            dtLocal.Columns.Add("SortKey", typeof(int));
            for (int i = 0; i < dtLocal.Rows.Count; i++)
            {
                DataRow drow = dtLocal.Rows[i];
                if (drow["Hub"].ToString() == "1")
                {
                    drow["IsHub"] = true;
                }
                else
                {
                    drow["IsHub"] = false;
                }
                drow["SortKey"] = i * 10000;
            }
            if (GridToLoad == "Branches")
            {
                BranchGrid.DataSource = dtLocal;
                BranchGrid.DataBind();
                Session["BranchTable"] = dtLocal;
            }
            if (GridToLoad == "Loader")
            {
                LoaderGrid.DataSource = dtLocal;
                LoaderGrid.DataBind();
                if (Session["BranchTable"] == null)
                {
                    dtLocal.Rows.Clear();
                    Session["BranchTable"] = dtLocal;
                }
            }
        }
        //}
        //catch (Exception ex)
        //{
        //    return null;
        //}
    }

    protected void BranchCommand(object source, GridViewCommandEventArgs e)
    {
        ClearPageMessages();
        CatBegTextBox.Focus();
        dt = (DataTable)Session["BranchTable"];
        if (e.CommandName == "Del")
        {
            int index = Convert.ToInt32(e.CommandArgument);
            string BranchToRemove = BranchGrid.Rows[index].Cells[0].Text;
            dt.Rows.RemoveAt(index);
            BranchGrid.DataSource = dt;
            BranchGrid.DataBind();
            Session["BranchTable"] = dt;
        }
        if (e.CommandName == "Hub")
        {
            int index = Convert.ToInt32(e.CommandArgument);
            DataRow drow = dt.Rows[index];
            drow["IsHub"] = !(Boolean)drow["IsHub"];
            BranchGrid.DataSource = dt;
            BranchGrid.DataBind();
            Session["BranchTable"] = dt;
        }
        if (e.CommandName == "MoveUp")
        {
            int index = Convert.ToInt32(e.CommandArgument);
            if (index > 0)
            {
                DataRow drow1 = dt.Rows[index];
                int oldKey = (int)drow1["SortKey"];
                DataRow drow2 = dt.Rows[index - 1];
                drow1["SortKey"] = drow2["SortKey"];
                drow2["SortKey"] = oldKey;
                DataView dv = new DataView(dt, "", "SortKey", DataViewRowState.CurrentRows);
                dt = dv.ToTable();
            }
            BranchGrid.DataSource = dt;
            BranchGrid.DataBind();
            Session["BranchTable"] = dt;
        }
        if (e.CommandName == "MoveDown")
        {
            int index = Convert.ToInt32(e.CommandArgument);
            if (index < dt.Rows.Count - 1)
            {
                DataRow drow1 = dt.Rows[index];
                int oldKey = (int)drow1["SortKey"];
                DataRow drow2 = dt.Rows[index + 1];
                drow1["SortKey"] = drow2["SortKey"];
                drow2["SortKey"] = oldKey;
                DataView dv = new DataView(dt, "", "SortKey", DataViewRowState.CurrentRows);
                dt = dv.ToTable();
            }
            BranchGrid.DataSource = dt;
            BranchGrid.DataBind();
            Session["BranchTable"] = dt;
        }
        if (e.CommandName == "AddToList")
        {
            int index = Convert.ToInt32(e.CommandArgument);
            DataRow workRow = dt.NewRow();
            workRow["Code"] = LoaderGrid.Rows[index].Cells[0].Text;
            workRow["Name"] = LoaderGrid.Rows[index].Cells[1].Text;
            if (dt.Select("Code = '" + workRow["Code"] + "'").Length == 0)
            {
                if (LoaderGrid.Rows[index].Cells[2].Text == "True")
                {
                    workRow["Hub"] = 1;
                    workRow["IsHub"] = true;
                }
                else
                {
                    workRow["Hub"] = 0;
                    workRow["IsHub"] = false;
                }
                if (dt.Rows.Count == 0)
                {
                    workRow["SortKey"] = 10000;
                }
                else
                {
                    workRow["SortKey"] = (int)dt.Rows[dt.Rows.Count - 1]["SortKey"] * 10000;
                }
                dt.Rows.Add(workRow);
                BranchGrid.DataSource = dt;
                BranchGrid.DataBind();
                Session["BranchTable"] = dt;
            }
            else
            {
                lblErrorMessage.Text = "Branch " + workRow["Code"].ToString() + " is already in the list";
            }
        }
    }

    protected void BranchGrid_RowDataBound(Object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // set the hub line shading.
            if (e.Row.Cells[2].Text == "True")
            {
                e.Row.Cells[0].BackColor = Color.Silver;
                e.Row.Cells[1].BackColor = Color.Silver;
                e.Row.Cells[2].BackColor = Color.Silver;
                //e.Row.Cells[3].BackColor = Color.Silver;
            }
        }
    }

    protected void ClearPageMessages()
    {
        lblErrorMessage.Text = "";
        lblSuccessMessage.Text = "";
    }
}