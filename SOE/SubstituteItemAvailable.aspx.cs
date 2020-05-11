using System;
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

public partial class SubstituteItemAvailable : Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    string RBConnectionString = ConfigurationManager.ConnectionStrings["PFCRBConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    GridViewRow row;
    int PriQtyAvaliable;
    private string Num0Format = "{0:#,###,###,##0} ";

    // Page control variables
    private int gotoPageNumber;
    private int defaultPageSize = 1;

    #region Page Events

    protected void Page_Init(object sender, EventArgs e)
    {
        
        OKButt.Visible = false;
        UpdQuoteButt.Visible = false;
        SubmitButt.Visible = false;
        
        if (Request.QueryString["ItemNumber"] != null)
        {
            hidPageMode.Value = Request.QueryString["Mode"].ToString().ToLower();

            if (hidPageMode.Value == "subitem")
            {
                lblHeading.Text = "Substitute Item";
                
            }
            else
            {
                lblHeading.Text = "Sell Out Substitute Item";
                lblHeading.ForeColor = System.Drawing.Color.Red;
            }

            DataTable dtItem = GetSubstituteItems(hidPageMode.Value,Request.QueryString["ItemNumber"].ToString());
            if (dtItem != null && dtItem.Rows.Count >0)
            {
                //LoadItemNumber(dtItem.Rows[0]["AliasItemNo"].ToString());
                Session["SubstituteItems"] = dtItem;
                BindPager();
            }

        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // Initializing AJAX.NET Library 
        Ajax.Utility.RegisterTypeForAjax(typeof(SubstituteItemAvailable));       

        if (!IsPostBack)
        {
            Response.Expires = -1;
            gotoPageNumber = 0;
            Session["GotoPageNumber"] = "0";
        }
        else
        {
            gotoPageNumber = Convert.ToInt32(Session["GotoPageNumber"].ToString());

            if (hidCloseWindow.Value == "true")
            {
                hidCloseWindow.Value = "";
                ibtnServerClose_Click(ibtnServerClose, new ImageClickEventArgs(0, 0));
            }
        }
    }

    protected void Page_LoadComplete(object sender, EventArgs e)
    {
        QtyFilledLabel.Text = QtyFilledHidden.Value;
        SubItemScriptManager.SetFocus("BranchQOHGrid");
    }

    protected void AvailableSubmit_Click(object sender, EventArgs e)
    {
        GetAvailableData(ItemNoTextBox.Text, ReqLocTextBox.Text);
        ReqQtyLabel.Text = ReqQtyHidden.Value;
        AltQtyLabel.Text = AltQtyHidden.Value;
        ReqAvailLabel.Text = ReqAvailHidden.Value;
        SubItemScriptManager.SetFocus("BranchQOHGrid");
    }

    protected void ibtnServerClose_Click(object sender, ImageClickEventArgs e)
    {
        ScriptManager.RegisterClientScriptBlock(ibtnServerClose, ibtnServerClose.GetType(), "CloseSubForm", "window.top.close();", true);
    }

    protected void QuoteFilledButt_Click(object sender, EventArgs e)
    {
        int RemoteQty = 0;
        string CloneQuoteNo = "";
        HiddenField hid;
        // flag all lines as deleted for quote/item combo
        // then add new lines for lines that have a remote qty > 0
        SqlHelper.ExecuteNonQuery(connectionString, "UGEN_SP_Update",
            new SqlParameter("@tableName", "DTQ_CustomerQuotation"),
            new SqlParameter("@columnNames", "DeleteFlag=1, DeleteDt=getdate()"),
            new SqlParameter("@whereClause", "SessionID='" + QuoteNumber.Value.Trim() + "' and PFCItemNo='" + ItemNoTextBox.Text.Trim() + "'"));

        foreach (TableRow tr in BranchQOHGrid.Rows)
        {
            RemoteQty = 0;
            // get remote qty
            TextBox tb = (TextBox)tr.Cells[4].Controls[1];
            if (int.TryParse(tb.Text, out RemoteQty))
            {
                if (RemoteQty > 0)
                {
                    // clone each line with a remote qty to a new line
                    SqlHelper.ExecuteNonQuery(connectionString, "pSOECloneQuoteLine",
                        new SqlParameter("@SessionID", QuoteNumber.Value),
                        new SqlParameter("@ItemNumber", ItemNoTextBox.Text),
                        new SqlParameter("@LocCode", tr.Cells[0].Text),
                        new SqlParameter("@LocName", tr.Cells[1].Text),
                        new SqlParameter("@UserName", Session["UserName"].ToString()),
                        new SqlParameter("@NewReqQty", RemoteQty.ToString()),
                        new SqlParameter("@NewQOH", tr.Cells[3].Text));
                }
            }
        }
        // updates to the table are complete, fire the javascript to refresh quote recall and close
        //BranchAvailableScriptManager.
        ScriptManager.RegisterClientScriptBlock(ItemNoTextBox, ItemNoTextBox.GetType(), "DetUpdate", "ReturnToQuoteRecall();", true);

    }

    #endregion
    
    #region Developer Method

    protected void GetAvailableData(string ItemNo, string Loc)
    {
        try
        {
            PriQtyAvaliable = 0;
            // set the z-item on the location
            CheckZItemBranch(Loc);
            // parse the input for possible UOM strings
            string QtyEntered = ReqQtyHidden.Value.Replace(",", "").Trim().ToUpper();
            char[] QtyArray = QtyEntered.ToCharArray();
            string UOMText = "";
            string Qtytext = "";
            foreach (char c in QtyArray)
            {
                if (c.Equals('-')) Qtytext += c;
                if (char.IsDigit(c)) Qtytext += c;
                if (c.Equals('.')) Qtytext += c;
                if (char.IsLetter(c)) UOMText += c;
            }
            // get the data.
            ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetBrAvail",
                      new SqlParameter("@SearchItemNo", ItemNo),
                      new SqlParameter("@QtyRequested", Qtytext),
                      new SqlParameter("@QtyUOM", UOMText),
                      new SqlParameter("@PrimaryBranch", Loc));
            if (ds.Tables.Count >= 1)
            {
                if (ds.Tables.Count == 1)
                {
                    // We only go one table back, something is wrong
                    dt = ds.Tables[0];
                    if (dt.Rows.Count > 0)
                    {
                        lblErrorMessage.Text = "Branch Availability problem " + ItemNo.ToString() + Loc.ToString();
                        MessageUpdatePanel.Update();
                        SubmitButt.Visible = false;
                    }
                }
                else
                {
                    dt = ds.Tables[1];
                    if (dt.Rows.Count == 0)
                    {
                        lblErrorMessage.Text = "There is no Availability for " + ItemNo.ToString();
                        MessageUpdatePanel.Update();
                        SubmitButt.Visible = false;
                    }
                    else
                    {
                        dt.Columns.Add("RemoteQty", typeof(int));
                        dt.Columns.Add("RemotePieces", typeof(int), "RemoteQty * SellStkUMQty");
                        dt.Columns.Add("QuoteNumber", typeof(string));
                        // work the qty. first see if there is enough in the shipping branch
                        DataView dv = new DataView(dt, "", "Location", DataViewRowState.CurrentRows);
                        int PrimaryRowIndex = dv.Find(Loc);
                        if (PrimaryRowIndex != -1)
                        {
                            // we found something
                            PriQtyAvaliable = int.Parse(dv[PrimaryRowIndex]["QOH"].ToString());
                            //if (PriQtyAvaliable > 0)
                            //{
                            //    dv[PrimaryRowIndex]["RemoteQty"] = PriQtyAvaliable;
                            //}
                            ReqAvailLabel.Text = PriQtyAvaliable.ToString();
                            ReqAvailHidden.Value = PriQtyAvaliable.ToString();
                        }
                        else
                        {
                            PriQtyAvaliable = 0;
                            ReqAvailLabel.Text = "0";
                        }
                        dv.Sort = "SortKey";
                        BranchQOHGrid.DataSource = dv;
                        BranchQOHGrid.DataBind();
                        if (dt.Rows.Count > 0)
                        {
                            SellStkQty.Value = dt.Rows[0]["SellStkUMQty"].ToString();
                            SellStkUOM.Value = dt.Rows[0]["SellStkUM"].ToString();
                        }

                        // Convert the substitute item pieces qty to req qty item piece qty
                        if (AltQtyHidden.Value != "" && AltQtyHidden.Value != "0")
                        {                            
                            int custReqQty = Convert.ToInt32(AltQtyHidden.Value.Replace(",", ""));
                            int qtyPerBox = Convert.ToInt32(SellStkQty.Value);
                            int newReqQty = 1;
                            if (custReqQty > qtyPerBox)
                                newReqQty = custReqQty / qtyPerBox;

                            ReqQtyHidden.Value = newReqQty.ToString();
                            AltQtyHidden.Value = String.Format("{0:###,###}", newReqQty * qtyPerBox); // Total pcs requested                            
                            ReqQtyLabel.Text = ReqQtyHidden.Value;
                            AltQtyLabel.Text = AltQtyHidden.Value;                            
                        }
                        else
                            ReqQtyHidden.Value = ds.Tables[2].Rows[0]["QtyToSell"].ToString();

                        //FilledQtyLabel.Text = ReqAvailHidden.Value;
                        //FilledQtyHidden.Value = ReqAvailHidden.Value;
                        //FilledPcsLabel.Text = String.Format(Num0Format, int.Parse(ReqAvailHidden.Value.Replace(",", "")) * int.Parse(SellStkQty.Value.Replace(",", "")));
                        //FilledPcsHidden.Value = String.Format(Num0Format, int.Parse(ReqAvailHidden.Value.Replace(",", "")) * int.Parse(SellStkQty.Value.Replace(",", "")));
                        AltAvailLabel.Text = String.Format(Num0Format, int.Parse(ReqAvailHidden.Value.Replace(",", "")) * int.Parse(SellStkQty.Value.Replace(",", "")));
                        AltQtyHidden.Value = String.Format(Num0Format, int.Parse(ReqQtyHidden.Value.Replace(",", "")) * int.Parse(SellStkQty.Value.Replace(",", "")));
                        AltQtyLabel.Text = AltQtyHidden.Value;
                        SubmitButt.Visible = true;



                    }
                    BranchUpdatePanel.Update();
                }
            }
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "GetAvailableData Error " + e3.Message + ", " + e3.ToString();
            MessageUpdatePanel.Update();
        }
    }

    protected void GetQuoteData()
    {
        int AltQtyReq = 0;
        // get the matching quote data.
        ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetQuotes",
            new SqlParameter("@Organization", ""),
            new SqlParameter("@QuoteFilterField", ItemNoTextBox.Text),
            new SqlParameter("@QuoteFilterValue", QuoteFilterValueHidden.Value),
            new SqlParameter("@FreshQOH", QOHCommandHidden.Value));
        if (ds.Tables.Count <= 1)
        {
            // We only go one table back, something is wrong
            lblErrorMessage.Text = "Quote Recall Quote Lines problem " + QuoteNumber.Value;
            MessageUpdatePanel.Update();
            return;
        }
        dt = ds.Tables[1];
        if (dt.Rows.Count > 0)
        {
            SellStkQty.Value = dt.Rows[0]["SellStkUMQty"].ToString();
            SellStkUOM.Value = dt.Rows[0]["SellStkUM"].ToString();
            object sumObjectRemote;
            sumObjectRemote = dt.Compute("Sum(RemoteQty)", "1 = 1");
            // if there is more than one line for the same item, override the requested qtys
            if (int.Parse(sumObjectRemote.ToString()) > int.Parse(ReqQtyHidden.Value))
            {
                ReqQtyHidden.Value = string.Format("{0:#########0}", sumObjectRemote);
                AltQtyReq = int.Parse(dt.Rows[0]["SellStkUMQty"].ToString());
                AltQtyReq = AltQtyReq * int.Parse(sumObjectRemote.ToString());
                AltQtyHidden.Value = AltQtyReq.ToString();
                ReqQtyLabel.Text = ReqQtyHidden.Value;
                AltQtyLabel.Text = AltQtyHidden.Value;
            }
            AltQtyHidden.Value = String.Format(Num0Format, int.Parse(ReqQtyHidden.Value) * int.Parse(SellStkQty.Value));
            AltQtyLabel.Text = AltQtyHidden.Value;
            object sumObjectAvail;
            sumObjectAvail = dt.Compute("Sum(QOH)", "1 = 1");
            ReqAvailHidden.Value = string.Format("{0:#########0}", sumObjectAvail);
            ReqAvailLabel.Text = ReqAvailHidden.Value;
            AltAvailLabel.Text = String.Format(Num0Format, int.Parse(ReqAvailHidden.Value) * int.Parse(SellStkQty.Value));
        }
        else
        {
            //lblErrorMessage.Text = "Error " + ItemNoTextBox.Text + ":" + QuoteFilterValueHidden.Value + ":" + QOHCommandHidden.Value;
            lblErrorMessage.Text = "No Availability at any Branch";
            MessageUpdatePanel.Update();
        }
        BranchQOHGrid.DataSource = ds.Tables[1];
        BranchQOHGrid.DataBind();
        BranchUpdatePanel.Update();
    }

    protected void GetVirtualData(string ItemNo, string Loc)
    {
        try
        {
            // get the data.
            ds = SqlHelper.ExecuteDataset(RBConnectionString, "pGetVirtualQtys",
                      new SqlParameter("@Loc", Loc),
                      new SqlParameter("@Item", ItemNo));
            if (ds.Tables.Count == 1)
            {
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    BranchQOHGrid.Width = Unit.Pixel(250);
                    dt.Columns.Add("Location", typeof(string));
                    dt.Columns.Add("LocName", typeof(string));
                    dt.Columns.Add("RemoteQty", typeof(string));
                    dt.Columns.Add("StdCost", typeof(string));
                    dt.Columns.Add("AvgCost", typeof(string));
                    dt.Columns.Add("ReplCost", typeof(string));
                    dt.Columns.Add("QuoteNumber", typeof(string));
                    BranchQOHGrid.Columns[2].Visible = false;
                    BranchQOHGrid.Columns[4].Visible = false;
                    BranchQOHGrid.Columns[5].Visible = false;
                    BranchQOHGrid.Columns[6].Visible = false;
                    BranchQOHGrid.Columns[7].Visible = false;
                    BranchQOHGrid.Columns[8].Visible = false;
                    BranchQOHGrid.Columns[9].Visible = false;
                    BranchQOHGrid.Columns[10].Visible = false;
                    BranchQOHGrid.Columns[11].Visible = false;
                    BranchQOHGrid.Columns[12].Visible = false;
                    BranchQOHGrid.Columns[13].Visible = false;
                    BranchQOHGrid.DataSource = dt;
                    foreach (DataRow dr in dt.Rows)
                    {
                        ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetLocMaster",
                                 new SqlParameter("@LocNo", dr["VirtualBinZone"].ToString()));
                        if (ds.Tables.Count > 1)
                        {
                            if (ds.Tables[1].Rows.Count > 0)
                            {
                                dr["Location"] = ds.Tables[1].Rows[0]["LocID"];
                                dr["LocName"] = ds.Tables[1].Rows[0]["LocName"];
                            }
                        }
                    }
                    BranchQOHGrid.DataBind();
                    BranchUpdatePanel.Update();
                }
                else
                {
                    //lblErrorMessage.Text = "Error " + ItemNoTextBox.Text + ":" + QuoteFilterValueHidden.Value + ":" + QOHCommandHidden.Value;
                    lblErrorMessage.Text = "No Availabililty in Virtual Branch " + Loc;
                    MessageUpdatePanel.Update();
                }
            }
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "pGetVirtualQtys Error " + e3.Message + ", " + e3.ToString();
            MessageUpdatePanel.Update();
        }
    }

    protected void DetailRowBound(Object sender, GridViewRowEventArgs e)
    {
        try
        {
            // show availability link on Branch 40
            row = e.Row;
            if (row.RowType == DataControlRowType.DataRow)
            {
                // line formatting
                if (row.Cells[0].Text == "40")
                {
                    row.Cells[0].Text = "<span class='QOHLink' onClick='OpenVirtualAvailability(40);' style='cursor: hand;'>" + row.Cells[0].Text + "</span>";
                    row.Cells[1].Text = "<span class='QOHLink' onClick='OpenVirtualAvailability(40);' style='cursor: hand;'>" + row.Cells[1].Text + "</span>";
                }
                else if (row.Cells[0].Text.ToUpper() == "V")
                {
                    row.Font.Bold = true;
                    TextBox txtReqQty = row.FindControl("BranchQtyTextBox") as TextBox;
                    txtReqQty.Visible = false;
                }
            }
        }
        catch (Exception e2)
        {
            lblErrorMessage.Text = "DetailRowBound Error " + e2.Message;
            MessageUpdatePanel.Update();
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

    #endregion

    #region Pager Events

    protected void BindPager()
    {

        DataTable dtSource = Session["SubstituteItems"] as DataTable;
        //dgNewQuote.CurrentPageIndex = gridPager.GotoPageNumber;
        //BindDataGrid();
        InitPager(dtSource, gotoPageNumber);
        string itemNo = dtSource.Rows[gotoPageNumber]["AliasItemNo"].ToString();
        LoadItemNumber(itemNo);
    }

    public void InitPager(DataTable dtDatasource, int currentIndex)
    {
        try
        {
            int currentPageIndex = currentIndex;
            int pageSize = defaultPageSize;
            //int totalNoOfRec=((DataTable)dataGrid.DataSource).Rows.Count;
            int totalNoOfRec;

            totalNoOfRec = dtDatasource.Rows.Count;
            if (totalNoOfRec > 0)
            {
                int totalNumberOfPages = 0;

                if (totalNoOfRec <= pageSize && totalNoOfRec > 0)
                {
                    totalNumberOfPages = 1;
                }
                else
                {
                    if (totalNoOfRec % pageSize == 0)
                        totalNumberOfPages = totalNoOfRec / pageSize;
                    else
                        totalNumberOfPages = totalNoOfRec / pageSize + 1;
                }

                if (currentPageIndex > 0 && currentPageIndex >= totalNumberOfPages)
                    gotoPageNumber = totalNumberOfPages - 1;

                // Hide the default Pager                   
                lblTotalNoOfRec.Text = totalNoOfRec.ToString();
                lblCurrentTotalRec.Text = (currentPageIndex + 1).ToString();
                InitPager(currentPageIndex, totalNumberOfPages, pageSize);
            }
            else
            {
                ddlPages.Items.Clear();                
                lblTotalNoOfRec.Text = totalNoOfRec.ToString();
                lblCurrentTotalRec.Text = totalNoOfRec.ToString();
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
        }
    }

    public void InitPager(int currentPageIndex, int totalPages, int pageSize)
    {
        bool isValidPage = (currentPageIndex >= 0 && currentPageIndex <= totalPages - 1);
        bool canMoveBack = (currentPageIndex > 0);
        bool canMoveForward = (currentPageIndex < totalPages - 1);

        try
        {
            Session["TotalPages"] = totalPages;
            ddlPages.Items.Clear();
            ibtnFirst.Enabled = isValidPage && canMoveBack;
            ibtnPrevious.Enabled = isValidPage && canMoveBack;
            btnNext.Enabled = isValidPage && canMoveForward;
            btnLast.Enabled = isValidPage && canMoveForward;
            
            for (int i = 0; i < totalPages; i++)
            { ddlPages.Items.Add((i + 1).ToString()); }
            if (gotoPageNumber > totalPages)
            {
                ddlPages.SelectedValue = totalPages.ToString();
                gotoPageNumber = totalPages;
                Session["GotoPageNumber"] = totalPages.ToString();
            }
            else
                ddlPages.SelectedValue = (currentPageIndex + 1).ToString();            
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    protected void ddlPages_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (gotoPageNumber != (Convert.ToInt32(ddlPages.SelectedItem.Value) - 1) && ddlPages.SelectedItem.Value != "-1")
        {
            gotoPageNumber = Convert.ToInt32(ddlPages.SelectedItem.Value) - 1;
            Session["GotoPageNumber"] = gotoPageNumber;
            BindPager();
        }
    }

    protected void ImageButton1_Click(object sender, System.EventArgs e)
    {
        gotoPageNumber++;
        Session["GotoPageNumber"] = gotoPageNumber;
        BindPager();
    }

    protected void btnLast_Click(object sender, System.EventArgs e)
    {
        try
        {
            gotoPageNumber = Convert.ToInt32(Session["TotalPages"].ToString()) - 1;
            Session["GotoPageNumber"] = gotoPageNumber;
            BindPager();
        }
        catch (Exception ex)
        { }
    }

    protected void btnLast_Click1(object sender, System.EventArgs e)
    {
        gotoPageNumber = Convert.ToInt32(Session["TotalPages"].ToString()) - 1;
        Session["GotoPageNumber"] = gotoPageNumber;
        BindPager();
    }

    protected void ibtnPrevious_Click(object sender, System.EventArgs e)
    {
        try
        {
            if (ddlPages.Visible == true && ddlPages.SelectedItem.Text != "")
            {
                gotoPageNumber--;
                Session["GotoPageNumber"] = gotoPageNumber;
                BindPager();
            }
            else
            {
                gotoPageNumber--;
                Session["GotoPageNumber"] = gotoPageNumber;
                BindPager();
            }
        }
        catch (Exception ex)
        { }
    }

    protected void ibtnFirst_Click(object sender, System.EventArgs e)
    {
        gotoPageNumber = 0;
        Session["GotoPageNumber"] = gotoPageNumber;
        BindPager();
    }

    #endregion

    #region Ajax Methods

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string DelQuoteLines(string QuoteNo, string ItemNo)
    {
        string status = "";
        HiddenField hid;
        // flag all lines as deleted for quote/item combo
        SqlHelper.ExecuteNonQuery(connectionString, "UGEN_SP_Update",
            new SqlParameter("@tableName", "DTQ_CustomerQuotation"),
            new SqlParameter("@columnNames", "DeleteFlag=1, DeleteDt=getdate()"),
            new SqlParameter("@whereClause", "SessionID='" + QuoteNo.Trim() + "' and PFCItemNo='" + ItemNo.Trim() + "'"));
        status = "true";
        return status;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdQuoteLine(string QuoteNo, string ItemNo, string LocCd, string LocName, string RemQty, string QOH)
    {
        string status = "";
        // clone each line with a remote qty to a new line
        SqlHelper.ExecuteNonQuery(connectionString, "pSOECloneQuoteLine",
            new SqlParameter("@SessionID", QuoteNo.Trim()),
            new SqlParameter("@ItemNumber", ItemNo.Trim()),
            new SqlParameter("@LocCode", LocCd),
            new SqlParameter("@LocName", LocName),
            new SqlParameter("@UserName", Session["UserName"].ToString()),
            new SqlParameter("@NewReqQty", RemQty),
            new SqlParameter("@NewQOH", QOH));
        status = "true";
        return status;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string ParseQty(string searchItemNo, string enteredQty, string pageUOM)
    {
        string DataReturned = "0";
        try
        {
            // parse the input for possible UOM strings
            char[] QtyArray = enteredQty.ToCharArray();
            string UOMText = "";
            string Qtytext = "0";
            foreach (char c in QtyArray)
            {
                if (c.Equals('-')) Qtytext += c;
                if (char.IsDigit(c)) Qtytext += c;
                if (c.Equals('.')) Qtytext += c;
                if (char.IsLetter(c)) UOMText += c;
            }
            //RequestedQtyTextBox.Text = Qtytext+"X";
            if (Qtytext.Length == 0 && UOMText.Length != 0)
            {
                return "Error: A Qty is required";
            }
            else
            {
                if (UOMText.Length == 0)
                {
                    UOMText = pageUOM;
                }
                // get the uom
                ds = SqlHelper.ExecuteDataset(connectionString, "[pSOEGetItemUOM]",
                          new SqlParameter("@SearchItemNo", searchItemNo),
                          new SqlParameter("@SearchUOM", UOMText));
                if (ds.Tables.Count <= 1)
                {
                    // We only go one table back, something is wrong
                    return "Error: Invalid UOM";
                }
                else
                {
                    // the data returned in the table is the CT qty factor
                    return Qtytext + "," + UOMText + "," + ds.Tables[1].Rows[0][1].ToString();
                }
            }
        }
        catch (Exception ex)
        {
            return "Error: " + ex.ToString();
        }
    }

    #endregion

    #region New Method for Substitute Item & Sell out Item
    
    private void LoadItemNumber(string itemNo)
    {
        //Get the reference data
        //http://10.1.36.34/SOE/packingandplating.aspx?ItemNumber=00200-2400-021&ShipLoc=10&RequestedQty=5&AltQty=50&AvailableQty=33
        HasProcessed.Value = "1";
        ItemNoTextBox.Text = itemNo;
        ReqLocTextBox.Text = Request.QueryString["ShipLoc"].ToString();
        ReqQtyHidden.Value = Request.QueryString["RequestedQty"].ToString();
        AltQtyHidden.Value = Request.QueryString["AltQty"].ToString();
        ReqAvailHidden.Value = Request.QueryString["AvailableQty"].ToString();
        SellStkQty.Value = "0";
        ReqQtyLabel.Text = ReqQtyHidden.Value;
        AltQtyLabel.Text = AltQtyHidden.Value;
        ReqAvailLabel.Text = ReqAvailHidden.Value;
        SubItemScriptManager.SetFocus("ItemNoTextBox");
        // see if there was a UOM in the passed qty. If so, use it qtys entered
        char[] QtyArray = ReqQtyHidden.Value.ToCharArray();
        string UOMText = "";
        foreach (char c in QtyArray)
        {
            if (char.IsLetter(c)) UOMText += c;
        }
        EntryUOM.Value = UOMText;
        // passed variables indicate the calling page
        if (Request.QueryString["PriceWorksheet"] != null)
        {
            CallingPage.Value = "PriceWorksheet";
            GetAvailableData(ItemNoTextBox.Text, ReqLocTextBox.Text);
        }
        //if (Request.QueryString["QuoteRecall"] != null)
        //{
        //    CallingPage.Value = "QuoteRecall";
        //    QuoteNumber.Value = Request.QueryString["QuoteRecall"].ToString();
        //    QuoteFilterFieldHidden.Value = Request.QueryString["FilterField"].ToString();
        //    QuoteFilterValueHidden.Value = Request.QueryString["FilterValue"].ToString();
        //    if (QuoteFilterFieldHidden.Value == "QuotationDate")
        //    {
        //        QOHCommandHidden.Value = "3";
        //    }
        //    else
        //    {
        //        QOHCommandHidden.Value = "2";
        //    }
        //    UpdQuoteButt.Visible = true;
        //    GetQuoteData();
        //}
        //if (Request.QueryString["Virtual"] != null)
        //{
        //    CallingPage.Value = "BranchAvailable";
        //    GetVirtualData(ItemNoTextBox.Text, Request.QueryString["Virtual"]);
        //}
        // set the button to click to update the calling page
        if (Request.QueryString["ParentButton"] != null)
        {
            ParentButton.Value = Request.QueryString["ParentButton"].ToString();
        }
        // set the parent field to get the focus on the way out
        if (Request.QueryString["ParentFocus"] != null)
        {
            ParentFocusField.Value = Request.QueryString["ParentFocus"].ToString();
        }
    }

    private DataTable GetSubstituteItems(string mode, string itemNo)
    {
        try
        {
            DataSet _dsItemInfo = SqlHelper.ExecuteDataset(connectionString, "[pSOEGetSubstituteItems]",
                                  new SqlParameter("@itemType", mode),
                                  new SqlParameter("@itemNo", itemNo));

            if (_dsItemInfo != null)
                return _dsItemInfo.Tables[0];

            return null;
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    #endregion

}
