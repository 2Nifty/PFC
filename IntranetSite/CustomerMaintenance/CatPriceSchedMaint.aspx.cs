using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;
using PFC.Intranet.BusinessLogicLayer;

public partial class CatPriceSchedMaint : System.Web.UI.Page
{
    string ConnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    string umbrellaConnectionString = ConfigurationManager.AppSettings["UmbrellaConnectionString"].ToString();
    MaintenanceUtility MaintUtil = new MaintenanceUtility();

    bool ProcessError;
    string border = "1";

    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataTable dtSched = new DataTable();
    
    CheckBox ApproveSelector;
    Label ApproveLabel;
    TextBox TargetBox;
    Label TargetLabel;
    Label ExistLabel;
    GridViewRow row;

    protected void Page_Load(object sender, EventArgs e)
    {
        //Initializing AJAX.NET Library 
        Ajax.Utility.RegisterTypeForAjax(typeof(CatPriceSchedMaint));
        CPSMScriptManager.SetFocus("txtCustNo");
        
        if (!IsPostBack)
        {
            SubmitUpdatePanel.Visible = false;
            ApproveUpdatePanel.Visible = false;
            ExcelUpdatePanel.Visible = false;

            ApprovalOKHidden.Value = MaintUtil.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.CatPriceSchedMaintApproval);
            hidShowCostBasis.Value = MaintUtil.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.CatPriceSchedMaintSetCost);
            hidPriceAnalysis.Value = MaintUtil.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.PriceAnalysisReportAccess);
            rdoPackage.Visible = (MaintUtil.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.CatPriceSchedulePKGOption) != "" ? true : false) ;

            if (ApprovalOKHidden.Value.ToString() != "")
            {
                ApprovalOKHidden.Value = "TRUE";
            }

            if (hidShowCostBasis.Value.ToString() != "")
            {
                hidShowCostBasis.Value = "TRUE";
            }
            if (hidPriceAnalysis.Value.ToString() != "")
            {
                hidPriceAnalysis.Value = "TRUE";
            }

            if ((MaintUtil.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.CatPriceSchedMaintAccess) == "") && (ApprovalOKHidden.Value.ToUpper() != "TRUE"))
            {
                txtCustNo.Enabled = false;                
                btnSearch.Visible = false;
                lblErrorMessage.Text = "You do not have sufficient security to access this application.";
                MessageUpdatePanel.Update();
            }

            if (Request.QueryString["CustNo"] != null && Request.QueryString["CustNo"].ToString() != "")
            {
                txtCustNo.Text = Request.QueryString["CustNo"].ToString();
                btnSearch_Click(btnSearch, new EventArgs());
            }
        }
    }
    
    #region Bind Grid
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblErrorMessage.Text = "";
        lblSuccessMessage.Text = "";
        MessageUpdatePanel.Update();
        string Track = "Timer" + DateTime.Now.ToString("mm:ss");
        if (txtCustNo.Text.Trim().Length == 0)
        {
            lblErrorMessage.Text = "You must enter a Customer Number.";
            MessageUpdatePanel.Update();
        }
        else
        {
            try
            {
                lblErrorMessage.Text = "";
                ClearDisplay();                

                //Get the data using pCustPriceGetHist                
                Track += "|DataBeg" + DateTime.Now.ToString("mm:ss");
                ds = SqlHelper.ExecuteDataset(ConnectionString, "pCustPriceGetHist",
                          new SqlParameter("@CustNo", txtCustNo.Text.Trim()),
                          new SqlParameter("@itemType", (rdoBulk.Checked ? "Bulk" : "Package")));
                Track += "|DataEnd" + DateTime.Now.ToString("mm:ss");
                if (ds.Tables.Count == 2)
                {
                    dt = ds.Tables[0];
                    if (dt.Rows.Count > 0)
                    {
                        lblCustName.Text = dt.Rows[0]["CustomerName"].ToString();
                        lblBranch.Text = dt.Rows[0]["Branch"].ToString();
                        lblRecType.Text = "";
                        CPSMRecTypeHidden.Value = dt.Rows[0]["RecType"].ToString();

                        if (CPSMRecTypeHidden.Value.ToString() == "0")
                        {
                            lblRecType.Text = "These are New records wating for Targets.";
                        }
                        if (CPSMRecTypeHidden.Value.ToString() == "1")
                        {
                            lblRecType.Text = "These are Unprocessed waiting for Appproval.";
                        }
                        
                        hidSort.Value = "";
                        hidSort.Attributes["sortType"] = "DESC";
                        hidRowFilter.Value = "GroupType = 'C'";

                        // Change Target column header based on item type
                        CPSMGridView.Columns[7].HeaderText = (rdoBulk.Checked ? "Target" : "Bulk +");
                        
                        DataView dv = new DataView(dt, hidRowFilter.Value.ToString(), hidSort.Value.ToString(), DataViewRowState.CurrentRows);
                        CPSMGridView.DataSource = dv;
                        Session["CPSMData"] = dt;
                        Track += "|Session" + DateTime.Now.ToString("mm:ss");
                        CPSMGridView.DataBind();
                        Track += "|DataBind" + DateTime.Now.ToString("mm:ss");                        

                        if (ApprovalOKHidden.Value.ToUpper() == "TRUE")
                        {
                            ApproveUpdatePanel.Visible = true;
                            SubmitUpdatePanel.Visible = false;
                        }
                        else
                        {
                            ApproveUpdatePanel.Visible = false;
                            SubmitUpdatePanel.Visible = true;
                        }

                        if (hidShowCostBasis.Value == "TRUE")                        
                            ibtnSetBasis.Visible = true;                       
                        else
                            ibtnSetBasis.Visible = false;

                        if(hidPriceAnalysis.Value == "TRUE")
                            btnPriceAnalysis.Visible = true;
                        else
                            btnPriceAnalysis.Visible = false
                                ;
                        ExcelUpdatePanel.Visible = true;
                        SelectorUpdatePanel.Update();
                        DetailUpdatePanel.Update();
                    }
                    else
                    {
                        lblErrorMessage.Text = "No Price Schedule Data For Customer " + txtCustNo.Text.Trim();
                        MessageUpdatePanel.Update();
                        Session["CPSMData"] = null;
                        CPSMGridView.DataBind();
                    }
                    Track += "|HdrBeg" + DateTime.Now.ToString("mm:ss");

                    dtSched = ds.Tables[1];
                    if (dtSched.Rows.Count > 0)
                    {
                        if (string.IsNullOrEmpty(lblCustName.Text.ToString()))
                            lblCustName.Text = dtSched.Rows[0]["CustomerName"].ToString();
                        if (string.IsNullOrEmpty(lblBranch.Text.ToString()))
                            lblBranch.Text = dtSched.Rows[0]["Branch"].ToString();
                        lblSched1.Text = dtSched.Rows[0]["ContractSchd1"].ToString();
                        lblSched2.Text = dtSched.Rows[0]["ContractSchd2"].ToString();
                        lblSched3.Text = dtSched.Rows[0]["ContractSchd3"].ToString();
                        lblSched4.Text = dtSched.Rows[0]["ContractSchedule4"].ToString();
                        lblSched5.Text = dtSched.Rows[0]["ContractSchedule5"].ToString();
                        lblSched6.Text = dtSched.Rows[0]["ContractSchedule6"].ToString();
                        lblSched7.Text = dtSched.Rows[0]["ContractSchedule7"].ToString();
                        lblTargetGross.Text = String.Format("{0:0.0}", dtSched.Rows[0]["TargetGrossMarginPct"]);
                        lblWebDiscPct.Text = String.Format("{0:0.00}", dtSched.Rows[0]["WebDiscountPct"]);
                        chkWebDiscInd.Checked = (dtSched.Rows[0]["WebDiscountInd"].ToString().ToUpper().Trim() == "1");
                        lblCustDefPrice.Text = dtSched.Rows[0]["CustomerDefaultPrice"].ToString();
                        lblCustPriceInd.Text = dtSched.Rows[0]["CustomerPriceInd"].ToString();
                        lblCreditInd.Text = dtSched.Rows[0]["CreditInd"].ToString();
                        lblActGrossMgnPct.Text = dtSched.Rows[0]["ActGrossMgnPct"].ToString();
                        lblDefaultCostPct.Text = dtSched.Rows[0]["TargetCostPlusPct"].ToString();                        
                    }
                    else
                    {
                        lblErrorMessage.Text = "Customer " + txtCustNo.Text.Trim() + " Not On File";
                        MessageUpdatePanel.Update();
                    }                 

                    Track += "|HdrEnd" + DateTime.Now.ToString("mm:ss");
                    lblSuccessMessage.Text = Track;
                    MessageUpdatePanel.Update();
                }
            }
            catch (Exception e3)
            {
                lblErrorMessage.Text = "pCustPriceGetHist Error " + e3.Message + ", " + e3.ToString();
                MessageUpdatePanel.Update();
            }
        }
    }

    protected void DetailRowBound(Object sender, GridViewRowEventArgs e)
    {
        try
        {
            row = e.Row;

            if (row.RowType == DataControlRowType.Header)
            {
                if (dt.DefaultView.RowFilter == "GroupType = 'B'" || hidRowFilter.Value == "GroupType = 'B'")
                    row.Cells[0].Text = "Group";

                if (dt.DefaultView.RowFilter == "GroupType = 'C'" || hidRowFilter.Value == "GroupType = 'C'")
                    row.Cells[0].Text = "CatNo";


                e.Row.Cells[2].ColumnSpan = 5;
                e.Row.Cells[2].Text = "<table border='0' style='font-weight:bold;' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' colspan=5 nowrap style='Height:18px;'><center>3 Month Sales History</center></td></tr><tr><td width='71' class='splitBorder_r_h'><center>" +
                                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('SalesHistory');\">Total $</div></center></td><td width='75' align='center' class='splitBorder_r_h'>" +
                                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('GMPctSmthAvgCost');\">GM% @ SAvg</div></center></td><td width='70' align='center' class='splitBorder_r_h'>" +
                                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('GMPctAvgCost');\">GM% @ Avg</div></center></td><td width='70' align='center' class='splitBorder_r_h'>" +
                                             "<Div style='cursor:hand;' onclick=\"javascript:BindValue('GMPctReplCost');\">GM% @ Rpl</div></center></td><td width='70' align='center'>" +
                                            "<Div onclick=\"javascript:BindValue('NonContractSales');\">Non-Cont. $</div></td></tr></table>";

                e.Row.Cells[3].Visible = false;
                e.Row.Cells[4].Visible = false;
                e.Row.Cells[5].Visible = false;
                e.Row.Cells[6].Visible = false;

                e.Row.Cells[10].ColumnSpan = 2;
                e.Row.Cells[10].Text = "<table border='0' style='font-weight:bold;' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' colspan=5 nowrap style='Height:18px;'><center>3 Month Sales History</center></td></tr><tr><td width='70' class='splitBorder_r_h'><center>" +
                                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ContractGMPct');\">Cont. GM%</div></center></td><td width='70' align='center'>" +
                                            "<Div onclick=\"javascript:BindValue('ContractSales');\">Cont. $</div></td></tr></table>";

                e.Row.Cells[11].Visible = false;


            }
            
            if (row.RowType == DataControlRowType.DataRow)
            {

                row.Cells[10].Style.Value = "border-left-width: 2px;";
                row.Cells[12].Style.Value = "border-left-width: 2px;";
                row.Cells[15].Style.Value = "border-left-width: 2px;";
                
                //Line formatting
                ApproveSelector = (CheckBox)row.FindControl("ApprovedCheckBox");
                ApproveLabel = (Label)row.FindControl("ApprovedLabel");
                TargetBox = (TextBox)row.FindControl("TargetTextBox");
                //ExistLabel = (Label)row.Cells[6].Controls[1];
                if ((CPSMRecTypeHidden.Value.ToString() == "0") && (decimal.Parse(row.Cells[8].Text, NumberStyles.Number) > 0))
                    TargetBox.Text = row.Cells[8].Text;
                if (decimal.Parse(row.Cells[8].Text, NumberStyles.Number) < 0)
                    row.Cells[7].Text = "N/A";
                if (ApproveLabel.Text == "0")
                    ApproveLabel.Text = "N";
                if (CPSMRecTypeHidden.Value.ToString() == "0")
                    ApproveLabel.Text = "New";
                if (ApprovalOKHidden.Value.ToUpper() == "TRUE")
                {
                    ApproveSelector.Visible = true;
                    //if (ApproveLabel.Text == "Y")
                    if (CPSMRecTypeHidden.Value.ToString() == "1")
                    {
                        ApproveSelector.Checked = true;
                        UpdApproved(row.Cells[0].Text.ToString(), ApproveSelector.Checked.ToString());
                    }
                    ApproveLabel.Visible = false;
                }
                else
                {
                    ApproveLabel.Visible = true;
                    ApproveSelector.Visible = false;
                }
                
                // Right click code for category column
                string itemType = (rdoBulk.Checked ? "Bulk" : "Package");
                string custName = lblCustName.Text.Replace("&", "~");
                string addNewItemURL = "AddItemPriceSchedMaint.aspx?Mode=SingleItem&CustNo=" + txtCustNo.Text + "&ItemType=" + itemType + "&CustName=" + custName;
                string ItemsByCategoryURL = "AddItemPriceSchedMaint.aspx?Mode=ItemsByCategory&CustNo=" + txtCustNo.Text + "&ItemType=" + itemType + "&Category=" + row.Cells[0].Text + "&CustName=" + custName;
                string ItemsByCustomerURL = "AddItemPriceSchedMaint.aspx?Mode=ItemsByCustomer&CustNo=" + txtCustNo.Text + "&ItemType=" + itemType + "&CustName=" + custName;
                string LLLContractsURL = "AddItemPriceSchedMaint.aspx?Mode=LLLContracts&CustNo=" + txtCustNo.Text + "&ItemType=" + itemType + "&Category=" + row.Cells[0].Text + "&LLLContractCd=" + ds.Tables[1].Rows[0]["ContractSchd2"].ToString() + "&CustName=" + custName;
                string priceAnalysisURL = "PriceAnalysisReport.aspx?CustNo=" + txtCustNo.Text + "&Category=" + row.Cells[0].Text;

                row.Cells[0].Text = "<div onmouseover=\"title='Right click for more options'\" style='cursor:hand; text-decoration: underline;' oncontextmenu=\"Javascript:return false;\" id=divCategory " +
                                    "onmousedown=\"ShowToolTip(event,'" + addNewItemURL + "','" + ItemsByCategoryURL + "','" + ItemsByCustomerURL + "','" + LLLContractsURL + "','" + priceAnalysisURL + "',this.id);\">" + row.Cells[0].Text + "</div>";
            }
        }
        catch (Exception e2)
        {
            lblErrorMessage.Text = "FillGrid Error " + e2.Message + ", " + e2.ToString();
            MessageUpdatePanel.Update();
        }
    }

    public void SortDetailGrid(Object sender, GridViewSortEventArgs e)
    {
        try
        {
            if (hidSort.Attributes["sortType"] != null)
            {
                if (hidSort.Attributes["sortType"].ToString() == "ASC")
                    hidSort.Attributes["sortType"] = "DESC";
                else
                    hidSort.Attributes["sortType"] = "ASC";
            }
            else
                hidSort.Attributes.Add("sortType", "DESC");

            hidSort.Value = e.SortExpression + " " + hidSort.Attributes["sortType"].ToString();

            dt = (DataTable)Session["CPSMData"];
            DataView dv = new DataView(dt, hidRowFilter.Value.ToString(), hidSort.Value.ToString(), DataViewRowState.CurrentRows);
            CPSMGridView.DataSource = dv;
            CPSMGridView.DataBind();
            DetailGridPanel.Height = new Unit(double.Parse(DetailGridHeightHidden.Value), UnitType.Pixel);
            DetailGridPanel.Width = new Unit(double.Parse(DetailGridWidthHidden.Value), UnitType.Pixel);
        }
        catch (Exception e2)
        {
            lblErrorMessage.Text = "Sort Error " + e2.Message + ", " + e2.ToString();
            MessageUpdatePanel.Update();
        }
    }
    #endregion

    #region Updates
    protected void btnSubmit_Click(object sender, ImageClickEventArgs e)
    {
        //Submit the targets
        ProcessWork("Margin Target Updates Complete","submit");
    }

    protected void btnApprove_Click(object sender, ImageClickEventArgs e)
    {
        //Approve the targets
        ProcessWork("Approval Updates Complete","approve");
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdTarget(string LineGroupNo, string NewTarget)
    {
        try
        {
            string status = LineGroupNo;
            string SessionID;

            //Update the table in the session variable with the new target.
            DataTable tempDt = (DataTable)Session["CPSMData"];
            //tempDt.DefaultView.RowFilter = hidRowFilter.Value;
            //DataRow[] DtRow = tempDt.DefaultView.ToTable().Select("GroupNo = " + LineGroupNo);
            DataRow[] DtRow = tempDt.Select("GroupNo = '" + LineGroupNo + "'");
            status += " now " + NewTarget;
            DtRow[0]["TargetGMPct"] = decimal.Parse(NewTarget, NumberStyles.Number);
            Session["CPSMData"] = tempDt;
            return status;
        }
        catch (Exception e2)
        {
            return e2.ToString();
        }
    } 

    //[Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    //public string UpdExisting(string LineGroupNo, string NewExisting)
    //{
    //    string status = LineGroupNo;
    //    string SessionID;

    //    //Update the table in the session variable with the new target.
    //    DataTable tempDt = (DataTable)Session["CPSMData"];
    //    //tempDt.DefaultView.RowFilter = hidRowFilter.Value;
    //    //DataRow[] DtRow = tempDt.DefaultView.ToTable().Select("GroupNo = " + LineGroupNo);
    //    DataRow[] DtRow = tempDt.Select("GroupNo = " + LineGroupNo);
    //    status += " now " + NewExisting;
    //    DtRow[0]["ExistingCustPricePct"] = decimal.Parse(NewExisting, NumberStyles.Number);
    //    Session["CPSMData"] = tempDt;
    //    return status;
    //}

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdApproved(string LineGroupNo, string NewApproved)
    {
        try
        {
            string status = LineGroupNo;
            string SessionID;

            //Update the table in the session variable with the new target.
            DataTable tempDt = (DataTable)Session["CPSMData"];
            //tempDt.DefaultView.RowFilter = hidRowFilter.Value;
            //DataRow[] DtRow = tempDt.DefaultView.ToTable().Select("GroupNo = " + LineGroupNo);
            DataRow[] DtRow = tempDt.Select("GroupNo = '" + LineGroupNo + "'");
            status += " now " + NewApproved;
            if (bool.Parse(NewApproved))
            {
                DtRow[0]["Approved"] = 'Y';
            }
            else
            {
                DtRow[0]["Approved"] = 'N';
            }
            Session["CPSMData"] = tempDt;
            return status;
        }
        catch (Exception e2)
        {

            lblErrorMessage.Text = e2.ToString();
            MessageUpdatePanel.Update();
            
            return e2.ToString();
        }
    }

    public void ProcessWork(string SuccessText, string source)
    {
        try
        {
            ProcessError = false;
            dt = (DataTable)Session["CPSMData"];
            dt.DefaultView.RowFilter = hidRowFilter.Value;
            foreach (DataRow dr in dt.DefaultView.ToTable().Rows)
            {
                string _Action = "";
                if (CPSMRecTypeHidden.Value.ToString() == "0")
                    _Action = "I";

                if (CPSMRecTypeHidden.Value.ToString() == "1")
                    _Action = "U";

                try
                {
                    if (_Action != "")
                    {
                        ds = SqlHelper.ExecuteDataset(ConnectionString, "pCustPriceWorkUnprocessed",
                                                new SqlParameter("@Action", "I"),
                                                new SqlParameter("@Branch", dr["Branch"].ToString()),
                                                new SqlParameter("@CustomerNo", dr["CustomerNo"].ToString()),
                                                new SqlParameter("@CustomerName", dr["CustomerName"].ToString()),
                                                new SqlParameter("@GroupType", dr["GroupType"].ToString()),
                                                new SqlParameter("@GroupNo", dr["GroupNo"].ToString()),
                                                new SqlParameter("@GroupDesc", dr["GroupDesc"].ToString()),
                                                new SqlParameter("@BuyGroupNo", dr["BuyGroupNo"].ToString()),
                                                new SqlParameter("@BuyGroupDesc", dr["BuyGroupDesc"].ToString()),
                                                new SqlParameter("@SalesHistory", dr["SalesHistory"].ToString()),
                                                new SqlParameter("@GMPctPriceCost", dr["GMPctPriceCost"].ToString()),
                                                new SqlParameter("@GMPctAvgCost", dr["GMPctAvgCost"].ToString()),
                                                new SqlParameter("@SalesHistoryTot", dr["SalesHistoryTot"].ToString()),
                                                new SqlParameter("@GMPctPriceCostTot", dr["GMPctPriceCostTot"].ToString()),
                                                new SqlParameter("@GMPctAvgCostTot", dr["GMPctAvgCostTot"].ToString()),
                                                new SqlParameter("@SalesHistoryEComm", dr["SalesHistoryEComm"].ToString()),
                                                new SqlParameter("@GMPctPriceCostEComm", dr["GMPctPriceCostEComm"].ToString()),
                                                new SqlParameter("@GMPctAvgCostEComm", dr["GMPctAvgCostEComm"].ToString()),
                                                new SqlParameter("@SalesHistory12Mo", dr["SalesHistory12Mo"].ToString()),
                                                new SqlParameter("@GMPctPriceCost12Mo", dr["GMPctPriceCost12Mo"].ToString()),
                                                new SqlParameter("@GMPctAvgCost12Mo", dr["GMPctAvgCost12Mo"].ToString()),
                                                new SqlParameter("@TargetGMPct", dr["TargetGMPct"].ToString()),
                                                new SqlParameter("@ExistingCustPricePct", dr["ExistingCustPricePct"].ToString()),
                                                new SqlParameter("@Approved", dr["Approved"].ToString()),
                                                new SqlParameter("@EntryID", Session["UserName"].ToString()),
                                                new SqlParameter("@priceMethod", (rdoPackage.Checked == true ? "M" : "G" )),
                                                new SqlParameter("@GMPctSmthAvgCost", dr["GMPctSmthAvgCost"].ToString()),
                                                new SqlParameter("@GMPctReplCost", dr["GMPctReplCost"].ToString()),
                                                new SqlParameter("@contractSales", dr["ContractSales"].ToString()),
                                                new SqlParameter("@nonContractSales", dr["NonContractSales"].ToString()),
                                                new SqlParameter("@contractGMPct", dr["ContractGMPct"].ToString()),
                                                new SqlParameter("@nonContractGMPct", dr["NonContractGMPct"].ToString()));
                    }
                }
                catch (SqlException ex)
                {
                    StringBuilder errorMessages = new StringBuilder();
                    for (int i = 0; i < ex.Errors.Count; i++)
                    {
                        errorMessages.Append("Index #" + i + "\n" +
                            "Message: " + ex.Errors[i].Message + "\n" +
                            "LineNumber: " + ex.Errors[i].LineNumber + "\n" +
                            "Source: " + ex.Errors[i].Source + "\n" +
                            "Procedure: " + ex.Errors[i].Procedure + "\n");
                    }
                    lblErrorMessage.Text = "pCustPriceWorkUnprocessed Error " + errorMessages.ToString();
                    MessageUpdatePanel.Update();
                    ProcessError = true;
                    break;
                }
            }
            if (!ProcessError)
            {
                if (source == "submit")
                {
                    bool result = SendCPMAwaitingApprovalEmail();
                }

                lblErrorMessage.Text = "";
                lblSuccessMessage.Text = SuccessText;
                MessageUpdatePanel.Update();

                txtCustNo.Text = "";               
                ClearDisplay();

                CPSMScriptManager.SetFocus("txtCustNo");
                CPSMGridView.DataBind();
            }
        }
        catch (NullReferenceException ex0)
        {
            lblErrorMessage.Text = "Null Reference " + ex0.ToString();
            MessageUpdatePanel.Update();
        }
        catch (Exception ex1)
        {
            lblErrorMessage.Text = ex1.ToString();
            MessageUpdatePanel.Update();
        }
    }
    #endregion

    #region Excel
    protected void btnExcel_Click(object sender, ImageClickEventArgs e)
    {
        CreateExcelFile();
    }

    private void CreateExcelFile()
    {
        string ExcelFileName = @"../Common/ExcelUploads/CPSM" + Session["UserName"].ToString() + ".xls";
        string fullpath = Request.MapPath(ExcelFileName);
        using (StreamWriter sw = new StreamWriter(fullpath))
        {
            sw.Write("Type\tGroup\tDescription\t3 Mo Sales $\t 3 Mo Mgn GM% @ SAvg\t3 Mo Mgn GM% @ Avg \t 3 Mo Mgn GM% @ Rpl \t 3 Mo Non-Cont. $ \t " +
                        "Target\t3Mo Cont. GM%\t3Mo Cont. Cont $\tOn File\t3 Mo Sales (EComm)\tMgn@Price\tMgn@Avg\t12 Mo Sales\tMgn@Price\tMgn@Avg");
            sw.WriteLine();

            dt = (DataTable)Session["CPSMData"];
            if (!string.IsNullOrEmpty(hidSort.Value.Trim()))
                dt.DefaultView.Sort = hidSort.Value;
            dt.DefaultView.RowFilter = hidRowFilter.Value;
            
            foreach (DataRow row in dt.DefaultView.ToTable().Rows)
            {
                sw.Write(row["GroupType"].ToString().Trim());
                sw.Write("\t");
                //if (row["GroupType"].ToString() == "C")
                //    sw.Write(row["GroupNo"].ToString().PadLeft(6, '0').Trim());
                //else
                sw.Write(row["GroupNo"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["GroupDesc"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["SalesHistory"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["GMPctSmthAvgCost"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["GMPctAvgCost"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["GMPctReplCost"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["NonContractSales"].ToString().Trim());
                sw.Write("\t");

                sw.Write(row["TargetGMPct"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["ContractGMPct"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["ContractSales"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["ExistingCustPricePct"].ToString().Trim());
                sw.Write("\t");

                sw.Write(row["SalesHistoryEComm"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["GMPctPriceCostEComm"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["GMPctAvgCostEComm"].ToString().Trim());
                sw.Write("\t");

                sw.Write(row["SalesHistory12Mo"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["GMPctPriceCost12Mo"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["GMPctAvgCost12Mo"].ToString().Trim());
                sw.Write("\t");
                sw.WriteLine();
            }
        }

        // Downloading Process
        //
        FileStream fileStream = File.Open(fullpath, FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        Response.AddHeader("Content-disposition", "attachment; filename=" + fullpath);
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }
    #endregion

    public void ClearDisplay()
    {
        ApproveUpdatePanel.Visible = false;
        SubmitUpdatePanel.Visible = false;
        ExcelUpdatePanel.Visible = false;
        ibtnSetBasis.Visible = false;
        btnPriceAnalysis.Visible = false;

        lblCustName.Text = "";
        lblBranch.Text = "";
        lblRecType.Text = "";

        lblSched1.Text = "";
        lblSched2.Text = "";
        lblSched3.Text = "";
        lblSched4.Text = "";
        lblSched5.Text = "";
        lblSched6.Text = "";
        lblSched7.Text = "";
        lblTargetGross.Text = "";
        lblWebDiscPct.Text = "";
        chkWebDiscInd.Checked = false;
        lblCustDefPrice.Text = "";
        lblCustPriceInd.Text = "";
        lblCreditInd.Text = "";
    }

    #region Send Email Notice

    private bool SendCPMAwaitingApprovalEmail()
    {
        try
        {
            MailSystem mailSystem = new MailSystem();
            string siteURL = ConfigurationManager.AppSettings["IntranetSiteURL"].ToString();
            string fromAddress = ConfigurationManager.AppSettings["FromAddress"].ToString();
            string subject = "";
            string body = "";
            string customerName = txtCustNo.Text + " " + lblCustName.Text;
            string repName = "";            
            string branchId = "";

            //Get the To address
            string toEmailAddress = SqlHelper.ExecuteScalar(ConnectionString, "pSOESelect",
                        new SqlParameter("@tableName", "AppPref"),
                        new SqlParameter("@columnNames", "AppOptionTypeDesc"),
                        new SqlParameter("@whereClause", "ApplicationCd = 'CPM' and AppOptionType='DefaultEMailTo'")).ToString();

            // Get Sales Rep data
            SqlDataReader repReader = SqlHelper.ExecuteReader(ConnectionString, "pSOESelect",
                                               new SqlParameter("@tableName", "SecurityUsers"),
                                               new SqlParameter("@columnNames", "*"),
                                               new SqlParameter("@whereClause", "UserName='"+Session["UserName"].ToString() +"'"));
            if (repReader.Read())
            {
                repName = repReader["UsersFirstName"].ToString() + " " + repReader["UsersLastName"].ToString();
                branchId = repReader["IMLoc"].ToString();
                
            }

            // Get Email Template from Umbrella Database
            SqlDataReader emailReader = SqlHelper.ExecuteReader(umbrellaConnectionString, "UGEN_SP_Select",
                                               new SqlParameter("@tableName", "UEMM_EmailContent"),
                                               new SqlParameter("@columnNames", "*"),
                                               new SqlParameter("@whereClause", "NAME='CPM-Approval'"));



            if (emailReader.Read())
            {
                subject = emailReader["Subject"].ToString().Replace("[customername]", customerName);
                body = emailReader["Content"].ToString();
                body = body.Replace("[SiteURL]", siteURL);
                body = body.Replace("[customername]", customerName);
                body = body.Replace("[salesperson]", repName);
                body = body.Replace("[location]", branchId);
                body = body.Replace("[datetime]", DateTime.Now.ToShortDateString());
            }

            mailSystem.SendMail(fromAddress, toEmailAddress, subject, body);

            return true;
        }
        catch (Exception ex)
        {
            return false;
        }

    }

    #endregion

}