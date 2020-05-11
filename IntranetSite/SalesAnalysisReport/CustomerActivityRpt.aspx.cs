using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using PFC.Intranet;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;

public partial class CustomerActivityRpt : System.Web.UI.Page
{
    SqlConnection cnERp = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
    SqlConnection cnReports = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCReportsConnectionString"].ConnectionString);
    DataSet dsResult = new DataSet();
    DataTable dtCust = new DataTable();
    DataTable dtAging = new DataTable();
    DataTable dtActivity = new DataTable();
    DataTable dtSOHistCat = new DataTable();
    DataTable dtSOHistGrp = new DataTable();
    DataTable dtSOHistFam = new DataTable();
    DataTable dtGrid = new DataTable();
    DataSet dsCustDiscPct = new DataSet();

    FileInfo fnExcel;
    StreamWriter reportWriter;
    string PreviewURL, xlsFile, ExportFile, headerContent, excelContent, footerContent;

    string _Period, strDisp;
    decimal TotSalesCurYTD, TotCostCurYTD, TotAvgCostCurYTD, TotPriceCostCurYTD, TotWghtCurYTD, TotSalesLastYTD, TotSalesPrevYTD,
            TotSalesCurMTD, TotCostCurMTD, TotAvgCostCurMTD, TotPriceCostCurMTD, TotWghtCurMTD;

    #region Page Load
    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(CustomerActivityRpt));
        //smCAS.AsyncPostBackTimeout = 36000;

        if (!IsPostBack)
        {
            if (Request.QueryString["Version"].ToString() == "Emp")
                rdoVersion.SelectedValue = "PFC Employee";
            if (Request.QueryString["Version"].ToString() == "Cus")
                rdoVersion.SelectedValue = "Customer";

            //Bind ddlRptGroup
            ListItem ddlList = new ListItem("Category", "Category", true);
            ddlRptGroup.Items.Add(ddlList);
            ddlList = new ListItem("Category Buy Group", "BuyGroup", true);
            ddlRptGroup.Items.Add(ddlList);
            ddlList = new ListItem("Product Family", "ProdFam", true);
            ddlRptGroup.Items.Add(ddlList);

            ddlRptGroup.SelectedValue = Request.QueryString["Group"].ToString();

            //if (Request.QueryString["Group"].ToString() == "BuyGroup")
            //    rdoGroup.SelectedValue = "Buy Group";
            //if (Request.QueryString["Group"].ToString() == "Category")
            //    rdoGroup.SelectedValue = "Category";

            hidSort.Value = "SalesCurYTD DESC, SalesLastYTD DESC, SalesPrevYTD DESC";
            hidSort.Attributes["sortType"] = "DESC";

            dtGrid = null;

            switch (Request.QueryString["RecType"].ToUpper().ToString().Trim())
            {
                case "CUST":
                    tblCust.Visible = true;
                    tblCustPFC.Visible = true;
                    GetCustHist();
                    break;
                case "CHAIN":
                    tblCust.Visible = false;
                    tblCustPFC.Visible = false;
                    GetChainHist();
                    break;
                case "SUMM":
                    tblCust.Visible = false;
                    tblCustPFC.Visible = false;
                    GetBrSummHist();
                    break;
            }

            LoadRptTables();

            if (dtGrid != null && dtGrid.Rows.Count > 0)
            {
                BindDataGrid();
            }
            else
            {
                lblGridHdr.Text = "No Sales History Found";
                divdatagrid.Visible = false;
                pnlGrid.Update();
            }

            if (rdoVersion.SelectedValue.ToString() != "PFC Employee")
                HidePFCOnly();

            NewPreviewURL();
        }
    }
    #endregion

    #region Get Report Data
    #region GetCustHist
    protected void GetCustHist()
    {
        try
        {
            dsResult = SqlHelper.ExecuteDataset(cnReports, "pCustActivityCustV3",
                                                new SqlParameter("@CustPeriod", Request.QueryString["Period"].ToString()),
                                                new SqlParameter("@CustNo", Request.QueryString["RecID"].ToString()));
        }
        catch (Exception ex)
        {
            DisplayStatusMessage("Error executing stored procedure (pCustActivityCustV3)", "fail");
            return;
        }

        try
        {
            dsCustDiscPct = SqlHelper.ExecuteDataset(cnERp, "pSOESelect",
                                                new SqlParameter("@tableName", "CustomerPrice"),
                                                new SqlParameter("@columnNames", "ItemNo,Cast(DiscPct as Decimal(16,1)) as DiscPct"),
                                                new SqlParameter("@whereClause", "PriceMethod = 'G' and CustNo = '" + Request.QueryString["RecID"].ToString() + "' and isnull(EffEndDt,'') = '' and isnull(DiscPct,0) <> 0"));
        }
        catch (Exception ex)
        {

        }

        //tblCust - Customer Header Info
        if (dsResult.Tables[0].DefaultView.ToTable().Rows.Count > 0)
        {
            dtCust = dsResult.Tables[0].DefaultView.ToTable();
            hidDefaultGrossMarginPct.Value = dtCust.Rows[0]["DefaultGrossMarginPct"].ToString();
            lblCustParam.Text = "Customer # " + dtCust.Rows[0]["CustNo"].ToString() + " : ";
            lblCustParam.Text += dtCust.Rows[0]["CustName"].ToString();
            //test max len
            //lblCustParam.Text += "123456789 123456789 123456789 1234567890";
            LoadCustHdr();
        }

        #region [Commented out - now calls common LoadRptTables() method
        ////tblAging - Customer AR Aging
        //if (dsResult.Tables[1].DefaultView.ToTable().Rows.Count > 0)
        //{
        //    dtAging = dsResult.Tables[1].DefaultView.ToTable();
        //    LoadAR();
        //}

        ////tblHist - Customer Sales Activity
        //if (dsResult.Tables[2].DefaultView.ToTable().Rows.Count > 0)
        //{
        //    dtActivity = dsResult.Tables[2].DefaultView.ToTable();
        //    LoadActivity();
        //    _Period = dtActivity.Rows[0]["MonthName"].ToString().Trim() + " " + Request.QueryString["Period"].ToString().Substring(0, 4);
        //    lblPerHist.Text = _Period;
        //    lblPerHistBot.Text = _Period;
        //    lblPerParam.Text = _Period;
        //}

        ////dtSOHistCat - Customer Sales History By Category
        //if (dsResult.Tables[3].DefaultView.ToTable().Rows.Count > 0)
        //{
        //    dtSOHistCat = dsResult.Tables[3].DefaultView.ToTable();
            
        //    // Add Default GM % to final result
        //    if (dsCustDiscPct != null && dsCustDiscPct.Tables[0].Rows.Count > 0)
        //        DefaultGMPctJoins(ref dtSOHistCat, dsCustDiscPct.Tables[0]);

        //    ViewState["dtSOHistCat"] = dtSOHistCat;
        //}

        ////dtSOHistGrp - Customer Sales History By Buy Group
        //if (dsResult.Tables[4].DefaultView.ToTable().Rows.Count > 0)
        //{
        //    dtSOHistGrp = dsResult.Tables[4].DefaultView.ToTable();
        //    ViewState["dtSOHistGrp"] = dtSOHistGrp;
        //}

        //if (rdoGroup.SelectedValue.ToString() == "Category")
        //{
        //    lblGridHdr.Text = "Sales Summary By Category";
        //    dtGrid = (DataTable)ViewState["dtSOHistCat"];
        //}
        //else
        //{
        //    lblGridHdr.Text = "Sales Summary By Buy Group";
        //    dtGrid = (DataTable)ViewState["dtSOHistGrp"];
        //}
        #endregion
    }
    #endregion

    #region GetChainHist
    protected void GetChainHist()
    {
        try
        {
            dsResult = SqlHelper.ExecuteDataset(cnReports, "pCustActivityChainV3",
                                                new SqlParameter("@ChainPeriod", Request.QueryString["Period"].ToString()),
                                                new SqlParameter("@ChainCd", Request.QueryString["RecID"].ToString()));
        }
        catch (Exception ex)
        {
            DisplayStatusMessage("Error executing stored procedure (pCustActivityChainV3)", "fail");
            return;
        }

        //tblCust - Customer Header Info
        if (dsResult.Tables[0].DefaultView.ToTable().Rows.Count > 0)
        {
            dtCust = dsResult.Tables[0].DefaultView.ToTable();
//          hidDefaultGrossMarginPct.Value = dtCust.Rows[0]["DefaultGrossMarginPct"].ToString();
            lblCustParam.Text = "Chain: " + dtCust.Rows[0]["ChainCd"].ToString() + " - ";
            lblCustParam.Text += dtCust.Rows[0]["ChainName"].ToString();
            //lblCustParam.Text += "123456789 123456789 123456789 1234567890";
        }

        #region [Commented out - now calls common LoadRptTables() method
        ////tblAging - Chain AR Aging
        //if (dsResult.Tables[1].DefaultView.ToTable().Rows.Count > 0)
        //{
        //    dtAging = dsResult.Tables[1].DefaultView.ToTable();
        //    LoadAR();
        //}

        ////tblHist - Chain Sales Activity
        //if (dsResult.Tables[2].DefaultView.ToTable().Rows.Count > 0)
        //{
        //    dtActivity = dsResult.Tables[2].DefaultView.ToTable();
        //    LoadActivity();
        //    _Period = dtActivity.Rows[0]["MonthName"].ToString().Trim() + " '";
        //    _Period += Request.QueryString["Period"].ToString().Substring(0, 4);
        //    lblPerHist.Text = _Period;
        //    lblPerHistBot.Text = _Period;
        //    lblPerParam.Text = _Period;
        //}

        ////dtSOHistCat - Chain Sales History By Category
        //if (dsResult.Tables[3].DefaultView.ToTable().Rows.Count > 0)
        //{
        //    dtSOHistCat = dsResult.Tables[3].DefaultView.ToTable();
        //    ViewState["dtSOHistCat"] = dtSOHistCat;
        //}

        ////dtSOHistGrp - Chain Sales History By Buy Group
        //if (dsResult.Tables[4].DefaultView.ToTable().Rows.Count > 0)
        //{
        //    dtSOHistGrp = dsResult.Tables[4].DefaultView.ToTable();
        //    ViewState["dtSOHistGrp"] = dtSOHistGrp;
        //}

        //if (rdoGroup.SelectedValue.ToString() == "Category")
        //{
        //    lblGridHdr.Text = "Sales Summary By Category";
        //    dtGrid = (DataTable)ViewState["dtSOHistCat"];
        //}
        //else
        //{
        //    lblGridHdr.Text = "Sales Summary By Buy Group";
        //    dtGrid = (DataTable)ViewState["dtSOHistGrp"];
        //}
        #endregion
    }
    #endregion

    #region GetBrSummHist
    protected void GetBrSummHist()
    {
        try
        {
            dsResult = SqlHelper.ExecuteDataset(cnReports, "pCustActivitySummV3",
                                                new SqlParameter("@LocPeriod", Request.QueryString["Period"].ToString()),
                                                new SqlParameter("@Location", Request.QueryString["RecID"].ToString()));
        }
        catch (Exception ex)
        {
            DisplayStatusMessage("Error executing stored procedure (pCustActivitySummV3) - " +
                Request.QueryString["Period"].ToString() + " - " + Request.QueryString["RecID"].ToString(), "fail");
            return;
        }

        //tblCust - Customer Header Info
        if (dsResult.Tables[0].DefaultView.ToTable().Rows.Count > 0)
        {
            dtCust = dsResult.Tables[0].DefaultView.ToTable();
//          hidDefaultGrossMarginPct.Value = dtCust.Rows[0]["DefaultGrossMarginPct"].ToString();
            lblCustParam.Text = dtCust.Rows[0]["ChainCd"].ToString() + " - ";
            lblCustParam.Text += dtCust.Rows[0]["ChainName"].ToString();
            //lblCustParam.Text += "123456789 123456789 123456789 1234567890";
        }

        #region [Commented out - now calls common LoadRptTables() method
        ////tblAging - Chain AR Aging
        //if (dsResult.Tables[1].DefaultView.ToTable().Rows.Count > 0)
        //{
        //    dtAging = dsResult.Tables[1].DefaultView.ToTable();
        //    LoadAR();
        //}

        ////tblHist - Chain Sales Activity
        //if (dsResult.Tables[2].DefaultView.ToTable().Rows.Count > 0)
        //{
        //    dtActivity = dsResult.Tables[2].DefaultView.ToTable();
        //    LoadActivity();
        //    _Period = dtActivity.Rows[0]["MonthName"].ToString().Trim() + " '";
        //    _Period += Request.QueryString["Period"].ToString().Substring(0, 4);
        //    lblPerHist.Text = _Period;
        //    lblPerHistBot.Text = _Period;
        //    lblPerParam.Text = _Period;
        //}

        ////dtSOHistCat - Chain Sales History By Category
        //if (dsResult.Tables[3].DefaultView.ToTable().Rows.Count > 0)
        //{
        //    dtSOHistCat = dsResult.Tables[3].DefaultView.ToTable();
        //    ViewState["dtSOHistCat"] = dtSOHistCat;
        //}

        ////dtSOHistGrp - Chain Sales History By Buy Group
        //if (dsResult.Tables[4].DefaultView.ToTable().Rows.Count > 0)
        //{
        //    dtSOHistGrp = dsResult.Tables[4].DefaultView.ToTable();
        //    ViewState["dtSOHistGrp"] = dtSOHistGrp;
        //}

        //if (rdoGroup.SelectedValue.ToString() == "Category")
        //{
        //    lblGridHdr.Text = "Sales Summary By Category";
        //    dtGrid = (DataTable)ViewState["dtSOHistCat"];
        //}
        //else
        //{
        //    lblGridHdr.Text = "Sales Summary By Buy Group";
        //    dtGrid = (DataTable)ViewState["dtSOHistGrp"];
        //}
        #endregion
    }
    #endregion

    #region Load Report Tables
    
    public void LoadRptTables()
    {

        //tblAging - AR Aging
        if (dsResult.Tables[1].DefaultView.ToTable().Rows.Count > 0)
        {
            dtAging = dsResult.Tables[1].DefaultView.ToTable();
            LoadAR();
        }

        //tblHist - Sales Activity
        if (dsResult.Tables[2].DefaultView.ToTable().Rows.Count > 0)
        {
            dtActivity = dsResult.Tables[2].DefaultView.ToTable();
            LoadActivity();
            _Period = dtActivity.Rows[0]["MonthName"].ToString().Trim() + " " + Request.QueryString["Period"].ToString().Substring(0, 4);
            lblPerHist.Text = _Period;
            lblPerHistBot.Text = _Period;
            lblPerParam.Text = _Period;
        }

        //dtSOHistCat - Sales History By Category
        if (dsResult.Tables[3].DefaultView.ToTable().Rows.Count > 0)
        {
            dtSOHistCat = dsResult.Tables[3].DefaultView.ToTable();

            if (Request.QueryString["RecType"].ToUpper().ToString().Trim() == "CUST")
            {
                // Add Default GM % to final result
                if (dsCustDiscPct != null && dsCustDiscPct.Tables[0].Rows.Count > 0)
                    DefaultGMPctJoins(ref dtSOHistCat, dsCustDiscPct.Tables[0]);
            }

            ViewState["dtSOHistCat"] = dtSOHistCat;
        }

        //dtSOHistGrp - Sales History By Buy Group
        if (dsResult.Tables[4].DefaultView.ToTable().Rows.Count > 0)
        {
            dtSOHistGrp = dsResult.Tables[4].DefaultView.ToTable();
            ViewState["dtSOHistGrp"] = dtSOHistGrp;
        }

        //dtSOHistFam - Sales History By Family
        if (dsResult.Tables[5].DefaultView.ToTable().Rows.Count > 0)
        {
            dtSOHistFam = dsResult.Tables[5].DefaultView.ToTable();
            ViewState["dtSOHistFam"] = dtSOHistFam;
        }

        switch (ddlRptGroup.SelectedValue.ToString())
        {
            case "Category":
                lblGridHdr.Text = "Sales Summary By Category";
                dtGrid = (DataTable)ViewState["dtSOHistCat"];
                break;
            case "BuyGroup":
                lblGridHdr.Text = "Sales Summary By Buy Group";
                dtGrid = (DataTable)ViewState["dtSOHistGrp"];
                break;
            case "ProdFam":
                lblGridHdr.Text = "Sales Summary By Prod Family";
                dtGrid = (DataTable)ViewState["dtSOHistFam"];
                break;
        }

        //if (rdoGroup.SelectedValue.ToString() == "Category")
        //{
        //    lblGridHdr.Text = "Sales Summary By Category";
        //    dtGrid = (DataTable)ViewState["dtSOHistCat"];
        //}
        //else
        //{
        //    lblGridHdr.Text = "Sales Summary By Buy Group";
        //    dtGrid = (DataTable)ViewState["dtSOHistGrp"];
        //}
    }

    #endregion

    #region BindDataGrid
    protected void BindDataGrid()
    {

        
        
        switch (ddlRptGroup.SelectedValue.ToString())
        {
            case "Category":
                lblGridHdr.Text = "Sales Summary By Category";
                dtGrid = (DataTable)ViewState["dtSOHistCat"];
                break;
            case "BuyGroup":
                lblGridHdr.Text = "Sales Summary By Buy Group";
                dtGrid = (DataTable)ViewState["dtSOHistGrp"];
                break;
            case "ProdFam":
                lblGridHdr.Text = "Sales Summary By Prod Family";
                dtGrid = (DataTable)ViewState["dtSOHistFam"];
                break;

            
            //case "Category":
            //    dtGrid = (DataTable)ViewState["dtSOHistCat"];
            //    break;
            //case "BuyGroup":
            //    dtGrid = (DataTable)ViewState["dtSOHistGrp"];
            //    break;
            //case "ProdFam":
            //    dtGrid = (DataTable)ViewState["dtSOHistFam"];
            //    break;
        }
        
        //if (rdoGroup.SelectedValue.ToString() == "Category")
        //    dtGrid = (DataTable)ViewState["dtSOHistCat"];
        //else
        //    dtGrid = (DataTable)ViewState["dtSOHistGrp"];

        if (Request.QueryString["RecType"].ToUpper().ToString().Trim() != "CUST")
            dgSummary.Columns[14].Visible = false;

        dgSummary.Columns[0].HeaderText = ddlRptGroup.SelectedValue.ToString();
        dgSummary.Columns[3].HeaderText = dtGrid.Rows[0]["LastYTDHdr"].ToString();
        dgSummary.Columns[4].HeaderText = dtGrid.Rows[0]["PrevYTDHdr"].ToString();

        TotSalesCurYTD = Convert.ToDecimal(dtGrid.Compute("sum(SalesCurYTD)", ""));
        TotCostCurYTD = Convert.ToDecimal(dtGrid.Compute("sum(CostCurYTD)", ""));
        TotAvgCostCurYTD = Convert.ToDecimal(dtGrid.Compute("sum(AvgCostCurYTD)", ""));
        TotPriceCostCurYTD = Convert.ToDecimal(dtGrid.Compute("sum(PriceCostCurYTD)", ""));
        TotSalesCurMTD = Convert.ToDecimal(dtGrid.Compute("sum(SalesCurMTD)", ""));
        TotCostCurMTD = Convert.ToDecimal(dtGrid.Compute("sum(CostCurMTD)", ""));
        TotAvgCostCurMTD = Convert.ToDecimal(dtGrid.Compute("sum(AvgCostCurMTD)", ""));
        TotPriceCostCurMTD = Convert.ToDecimal(dtGrid.Compute("sum(PriceCostCurMTD)", ""));
        TotSalesLastYTD = Convert.ToDecimal(dtGrid.Compute("sum(SalesLastYTD)", ""));
        TotSalesPrevYTD = Convert.ToDecimal(dtGrid.Compute("sum(SalesPrevYTD)", ""));
        TotWghtCurYTD = Convert.ToDecimal(dtGrid.Compute("sum(WghtCurYTD)", ""));
        TotWghtCurMTD = Convert.ToDecimal(dtGrid.Compute("sum(WghtCurMTD)", ""));

        String sortExpression = (hidSort.Value == "") ? " SalesCurYTD DESC, SalesLastYTD DESC, SalesPrevYTD DESC" : hidSort.Value;
        dtGrid.DefaultView.Sort = sortExpression;
        dgSummary.DataSource = dtGrid.DefaultView.ToTable();
        dgSummary.DataBind();
    }

    protected void dgSummary_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            if (e.Item.Cells[1].Text == "$0")
                e.Item.Cells[1].Text = "";

            if (e.Item.Cells[2].Text == "$0")
                e.Item.Cells[2].Text = "";

            if (e.Item.Cells[3].Text == "$0")
                e.Item.Cells[3].Text = "";

            if (e.Item.Cells[4].Text == "$0")
                e.Item.Cells[4].Text = "";

            if (e.Item.Cells[5].Text == "000")
                e.Item.Cells[5].Text = "";

            if (e.Item.Cells[6].Text == "000")
                e.Item.Cells[6].Text = "";

            decimal PctOfSalesDlr;
            if (TotSalesCurYTD == 0)
                PctOfSalesDlr = 0;
            else
                PctOfSalesDlr = Convert.ToDecimal(e.Item.Cells[7].Text) / TotSalesCurYTD;

            if (PctOfSalesDlr == 0)
                e.Item.Cells[7].Text = "";
            else
                e.Item.Cells[7].Text = String.Format("{0:0.0%}", PctOfSalesDlr).ToString().Trim();

            if (e.Item.Cells[8].Text == "$0")
                e.Item.Cells[8].Text = "";

            if (e.Item.Cells[9].Text == "$0")
                e.Item.Cells[9].Text = "";

            if (e.Item.Cells[10].Text == "0.0%")
                e.Item.Cells[10].Text = "";

            if (e.Item.Cells[11].Text == "0.0%")
                e.Item.Cells[11].Text = "";

            if (e.Item.Cells[12].Text == "0.0%")
                e.Item.Cells[12].Text = "";

            if (e.Item.Cells[13].Text == "0.0%")
                e.Item.Cells[13].Text = "";

            if (e.Item.Cells[15].Text == "$0")
                e.Item.Cells[15].Text = "";

            if (e.Item.Cells[16].Text == "$0")
                e.Item.Cells[16].Text = "";

            if (e.Item.Cells[17].Text == "$0")
                e.Item.Cells[17].Text = "";

            if (e.Item.Cells[18].Text == "$0")
                e.Item.Cells[18].Text = "";
        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].Text = "Totals:";

            e.Item.Cells[1].Text = String.Format("{0:$#,#0}", TotSalesCurYTD);
            e.Item.Cells[2].Text = String.Format("{0:$#,#0}", TotSalesCurMTD);
            e.Item.Cells[3].Text = String.Format("{0:$#,#0}", TotSalesLastYTD);
            e.Item.Cells[4].Text = String.Format("{0:$#,#0}", TotSalesPrevYTD);
            e.Item.Cells[5].Text = String.Format("{0:n1}", TotWghtCurYTD);
            e.Item.Cells[6].Text = String.Format("{0:n1}", TotWghtCurMTD);
            e.Item.Cells[7].Text = "100%";
            e.Item.Cells[8].Text = String.Format("{0:$#,#0}", TotSalesCurYTD - TotCostCurYTD);
            e.Item.Cells[9].Text = String.Format("{0:$#,#0}", TotSalesCurMTD - TotCostCurMTD);

            if (TotSalesCurYTD == 0)
            {
                e.Item.Cells[10].Text = String.Format("{0:0.0%}", 0);
                e.Item.Cells[12].Text = String.Format("{0:0.0%}", 0);
            }
            else
            {
                e.Item.Cells[10].Text = String.Format("{0:0.0%}", (TotSalesCurYTD - TotAvgCostCurYTD) / TotSalesCurYTD);
                e.Item.Cells[12].Text = String.Format("{0:0.0%}", (TotSalesCurYTD - TotPriceCostCurYTD) / TotSalesCurYTD);
            }

            if (TotSalesCurMTD == 0)
            {
                e.Item.Cells[11].Text = String.Format("{0:0.0%}", 0);
                e.Item.Cells[13].Text = String.Format("{0:0.0%}", 0);
            }
            else
            {
                e.Item.Cells[11].Text = String.Format("{0:0.0%}", (TotSalesCurMTD - TotAvgCostCurMTD) / TotSalesCurMTD);
                e.Item.Cells[13].Text = String.Format("{0:0.0%}", (TotSalesCurMTD - TotPriceCostCurMTD) / TotSalesCurMTD);
            }

            if (TotWghtCurYTD == 0)
            {
                e.Item.Cells[15].Text = String.Format("{0:c}", 0);
                e.Item.Cells[17].Text = String.Format("{0:c}", 0);
            }
            else
            {
                e.Item.Cells[15].Text = String.Format("{0:c}", TotSalesCurYTD / TotWghtCurYTD);
                e.Item.Cells[17].Text = String.Format("{0:c}", (TotSalesCurYTD - TotCostCurYTD) / TotWghtCurYTD);
            }

            if (TotWghtCurMTD == 0)
            {
                e.Item.Cells[16].Text = String.Format("{0:c}", 0);
                e.Item.Cells[18].Text = String.Format("{0:c}", 0);
            }
            else
            {
                e.Item.Cells[16].Text = String.Format("{0:c}", TotSalesCurMTD / TotWghtCurMTD);
                e.Item.Cells[18].Text = String.Format("{0:c}", (TotSalesCurMTD - TotCostCurMTD) / TotWghtCurMTD);
            }

            //test max length $9,999,999.00
            //e.Item.Cells[1].Text = "($9 999 999)";
            //e.Item.Cells[2].Text = "($9 999 999)";
            //e.Item.Cells[3].Text = "($9 999 999)";
            //e.Item.Cells[4].Text = "($9 999 999)";

            //e.Item.Cells[5].Text = "(99 999 999)";
            //e.Item.Cells[6].Text = "(99 999 999)";
        }
    }

    protected void dgSummary_Sort(object source, DataGridSortCommandEventArgs e)
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
            BindDataGrid();
            NewPreviewURL();
        }
        catch (Exception ex)
        {
            DisplayStatusMessage("Sort Error " + ex.Message + ", " + ex.ToString(), "fail");
        }
    }
    #endregion
    #endregion

    #region Display Report Data
    #region LoadCustHdr
    protected void LoadCustHdr()
    {
        //Customer Info
        lblCustNo.Text = "Customer # " + dtCust.Rows[0]["CustNo"].ToString();
        lblChain.Text = "Chain Name: " + dtCust.Rows[0]["ChainCd"].ToString();
        lblCustType.Text = "Cust Type: " + dtCust.Rows[0]["CustType"].ToString();
        //test max length 25
        //lblCustType.Text = "Cust Type: 123456789 123456789 12345";
        lblBuyGrp.Text = "Buying Grp: " + dtCust.Rows[0]["BuyGroup"].ToString();
        lblKeyCust.Text = "Key Cust: " + dtCust.Rows[0]["KeyCust"].ToString();
        lblCommRep.Text = "Commision Rep:: " + dtCust.Rows[0]["CommRep"].ToString();

        //Address Info
        lblCustName.Text = dtCust.Rows[0]["CustName"].ToString();
        //test max length 40
        //lblCustName.Text = "123456789 123456789 123456789 1234567890";
        lblAddr1.Text = dtCust.Rows[0]["AddrLine1"].ToString();
        lblCityStZip.Text = dtCust.Rows[0]["City"].ToString();
        if (!string.IsNullOrEmpty(dtCust.Rows[0]["City"].ToString()))
            lblCityStZip.Text += ", ";
        lblCityStZip.Text += dtCust.Rows[0]["State"].ToString() + " ";
        lblCityStZip.Text += dtCust.Rows[0]["PostCd"].ToString();
        lblPhone.Text = "Ph: " + dtCust.Rows[0]["PhoneNo"].ToString();
        lblFax.Text = "Fx: " + dtCust.Rows[0]["FaxPhoneNo"].ToString();
        lblContact.Text = "Contact: " + dtCust.Rows[0]["Contact"].ToString();

        //Sales Info
        lblSlsBrn.Text = "Sales Brn: " + dtCust.Rows[0]["LocName"].ToString();
        lblInsideSls.Text = "Inside Sales: " + dtCust.Rows[0]["InsideRepName"].ToString();
        //test max len 30
        //lblInsideSls.Text = "Inside Sales: 123456789 123456789 1234567890";
        lblSlsRep.Text = "Sales Rep: " + dtCust.Rows[0]["SalesRepName"].ToString();
        lblHub.Text = "Hub: " + dtCust.Rows[0]["Hub"].ToString();
        lblTerms.Text = "Terms: " + dtCust.Rows[0]["Terms"].ToString();
        lblCreditLmt.Text = "Credit Limit: " + String.Format("{0:c}", Convert.ToDecimal(dtCust.Rows[0]["CreditLmt"].ToString()));

        //Customer Info (PFC Employee)
        lblSched1.Text = "Contract Schd1: " + dtCust.Rows[0]["ContractSchd1"].ToString();
        //test max len 25
        //lblSched1.Text = "Contract Schd1: 123456789 123456789 12345";
        lblSched2.Text = "Contract Schd2: " + dtCust.Rows[0]["ContractSchd2"].ToString();
        lblSched3.Text = "Contract Schd3: " + dtCust.Rows[0]["ContractSchd3"].ToString();
        lblSched4.Text = "Contract Schd4: " + dtCust.Rows[0]["ContractSchd4"].ToString();
        lblSched5.Text = "Contract Schd5: " + dtCust.Rows[0]["ContractSchd5"].ToString();
        //test max len 25
        //lblSched5.Text = "Contract Schd5: 123456789 123456789 12345";
        lblSched6.Text = "Contract Schd6: " + dtCust.Rows[0]["ContractSchd6"].ToString();
        lblSched7.Text = "Contract Schd7: " + dtCust.Rows[0]["ContractSchd7"].ToString();
        lblDefGrossMgn.Text = "Default Gross Mgn Pct: " + String.Format("{0:0.0%}", Convert.ToDecimal(dtCust.Rows[0]["DefaultGrossMarginPct"].ToString()) / 100).ToString().Trim();
        lblWebDisc.Text = String.Format("{0:0.0%}", Convert.ToDecimal(dtCust.Rows[0]["WebDiscountPct"].ToString()) / 100).ToString().Trim();
        lblWebEnabled.Text = dtCust.Rows[0]["WebDiscountInd"].ToString();
        lblDefPrice.Text = dtCust.Rows[0]["CustomerDefaultPrice"].ToString();
        //test max len 25
        //lblDefPrice.Text = "123456789 123456789 12345";
        lblPriceInd.Text = dtCust.Rows[0]["CustomerPriceInd"].ToString();

        pnlCustTop.Update();
    }
    #endregion

    #region LoadAR
    protected void LoadAR()
    {
        if (Convert.ToDecimal(dtAging.Rows[0]["CurrentAmt"]) == 0)
            lblAmtCur.Text = "&nbsp;";
        else
            lblAmtCur.Text = String.Format("{0:c}", Convert.ToDecimal(dtAging.Rows[0]["CurrentAmt"].ToString()));
        //test $999,999.99
        //lblAmtCur.Text = "$999,999 99";

        if (Convert.ToDecimal(dtAging.Rows[0]["Over30Amt"]) == 0)
            lblAmt30.Text = "&nbsp;";
        else
            lblAmt30.Text = String.Format("{0:c}", Convert.ToDecimal(dtAging.Rows[0]["Over30Amt"].ToString()));
        //test $999,999.99
        //lblAmt30.Text = "$999,999 99";

        if (Convert.ToDecimal(dtAging.Rows[0]["Over60Amt"]) == 0)
            lblAmt60.Text = "&nbsp;";
        else
            lblAmt60.Text = String.Format("{0:c}", Convert.ToDecimal(dtAging.Rows[0]["Over60Amt"].ToString()));
        //test $999,999.99
        //lblAmt60.Text = "$999,999 99";

        if (Convert.ToDecimal(dtAging.Rows[0]["Over90Amt"]) == 0)
            lblAmt90.Text = "&nbsp;";
        else
            lblAmt90.Text = String.Format("{0:c}", Convert.ToDecimal(dtAging.Rows[0]["Over90Amt"].ToString()));
        //test $999,999.99
        //lblAmt90.Text = "$999,999 99";

        if (Convert.ToDecimal(dtAging.Rows[0]["BalanceDue"]) == 0)
            lblAmtTot.Text = "&nbsp;";
        else
            lblAmtTot.Text = String.Format("{0:c}", Convert.ToDecimal(dtAging.Rows[0]["BalanceDue"].ToString()));
        //test $9,999,999.99
        //lblAmtTot.Text = "$9,999,999 99";

        if (Convert.ToDecimal(dtAging.Rows[0]["CurrentPct"]) == 0)
            lblARCur.Text = "&nbsp;";
        else
            lblARCur.Text = String.Format("{0:0.0%}", Convert.ToDecimal(dtAging.Rows[0]["CurrentPct"].ToString()) / 100).ToString().Trim();

        if (Convert.ToDecimal(dtAging.Rows[0]["Over30Pct"]) == 0)
            lblAR30.Text = "&nbsp;";
        else
            lblAR30.Text = String.Format("{0:0.0%}", Convert.ToDecimal(dtAging.Rows[0]["Over30Pct"].ToString()) / 100).ToString().Trim();

        if (Convert.ToDecimal(dtAging.Rows[0]["Over60Pct"]) == 0)
            lblAR60.Text = "&nbsp;";
        else
            lblAR60.Text = String.Format("{0:0.0%}", Convert.ToDecimal(dtAging.Rows[0]["Over60Pct"].ToString()) / 100).ToString().Trim();

        if (Convert.ToDecimal(dtAging.Rows[0]["Over90Pct"]) == 0)
            lblAR90.Text = "&nbsp;";
        else
            lblAR90.Text = String.Format("{0:0.0%}", Convert.ToDecimal(dtAging.Rows[0]["Over90Pct"].ToString()) / 100).ToString().Trim();

        if (Convert.ToDecimal(dtAging.Rows[0]["DSO"]) == 0)
            lblDSO.Text = "&nbsp;";
        else
            lblDSO.Text = String.Format("{0:n0}", Convert.ToDecimal(dtAging.Rows[0]["DSO"].ToString())) + " Days";
        //test 9999 days
        //lblDSO.Text = "9999 Days";
    }
    #endregion

    #region LoadActivity
    protected void LoadActivity()
    {
        #region CM - Fiscal Month-Current Year
        lblCustRankCurMth.Text = dtActivity.Rows[0]["CMCorpRank"].ToString();
        lblTerrRankCurMth.Text = dtActivity.Rows[0]["CMTerRank"].ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMSales"]) == 0)
            lblFiscalSlsCurMth.Text = "&nbsp;";
        else
            lblFiscalSlsCurMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["CMSales"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMSalesPct"]) == 0)
            lblDlrPctChgCurMth.Text = "&nbsp;";
        else
            lblDlrPctChgCurMth.Text = string.Format("{0:0.0%}", Convert.ToDecimal(dtActivity.Rows[0]["CMSalesPct"]));

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMGM"]) == 0 && Convert.ToDecimal(dtActivity.Rows[0]["CMGMPct"]) == 0)
            lblMgnDlrPctCurMth.Text = "&nbsp;";
        else
            lblMgnDlrPctCurMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["CMGM"]).ToString() + " / " + string.Format("{0:0%}", Convert.ToDecimal(dtActivity.Rows[0]["CMGMPct"])).ToString();
        //test max length $999,999.99/100.00%
        //lblMgnDlrPctCurMth.Text = "$999,999 99/100 00%";
        
        if (Convert.ToDecimal(dtActivity.Rows[0]["CMSalesPerLb"]) == 0)
            lblDlrPerLbCurMth.Text = "&nbsp;";
        else
            lblDlrPerLbCurMth.Text = string.Format("{0:$#,#0.000}", dtActivity.Rows[0]["CMSalesPerLb"]).ToString();
        
        if (Convert.ToDecimal(dtActivity.Rows[0]["CMGMPerLb"]) == 0)
            lblGMDlrPerLbCurMth.Text = "&nbsp;";
        else
            lblGMDlrPerLbCurMth.Text = string.Format("{0:c}", dtActivity.Rows[0]["CMGMPerLb"]).ToString();
        
        if (Convert.ToDecimal(dtActivity.Rows[0]["CMAvgDolPerOrder"]) == 0)
            lblAvgDlrPerOrdCurMth.Text = "&nbsp;";
        else
            lblAvgDlrPerOrdCurMth.Text = string.Format("{0:c}", dtActivity.Rows[0]["CMAvgDolPerOrder"]).ToString();
        
        if (Convert.ToDecimal(dtActivity.Rows[0]["CMAvgDolPerLine"]) == 0)
            lblAvgDlrPerLineCurMth.Text = "&nbsp;";
        else
            lblAvgDlrPerLineCurMth.Text = string.Format("{0:c}", dtActivity.Rows[0]["CMAvgDolPerLine"]).ToString();
        
        if (Convert.ToDecimal(dtActivity.Rows[0]["WeeklyGoal"]) == 0)
            lblCurWkGoalCurMth.Text = "&nbsp;";
        else
            lblCurWkGoalCurMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["WeeklyGoal"]).ToString();
        
        if (Convert.ToDecimal(dtActivity.Rows[0]["CMOESales"]) == 0)
            lblSOESalesDlrCurMth.Text = "&nbsp;";
        else
            lblSOESalesDlrCurMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["CMOESales"]).ToString();
        
        if (Convert.ToDecimal(dtActivity.Rows[0]["CMEComSales"]) == 0)
            lblECSalesDlrCurMth.Text = "&nbsp;";
        else
            lblECSalesDlrCurMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["CMEComSales"]).ToString();
        
        if (Convert.ToDecimal(dtActivity.Rows[0]["CMMillSales"]) == 0)
            lblMillSalesDlrCurMth.Text = "&nbsp;";
        else
            lblMillSalesDlrCurMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["CMMillSales"]).ToString();
        
        if (Convert.ToDecimal(dtActivity.Rows[0]["CMOELbs"]) == 0)
            lblSOESalesLbsCurMth.Text = "&nbsp;";
        else
            lblSOESalesLbsCurMth.Text = string.Format("{0:n1}", dtActivity.Rows[0]["CMOELbs"]).ToString();
        
        if (Convert.ToDecimal(dtActivity.Rows[0]["CMEComLbs"]) == 0)
            lblECSalesLbsCurMth.Text = "&nbsp;";
        else
            lblECSalesLbsCurMth.Text = string.Format("{0:n1}", dtActivity.Rows[0]["CMEComLbs"]).ToString();
        
        if (Convert.ToDecimal(dtActivity.Rows[0]["CMMillLbs"]) == 0)
            lblMillSalesLbsCurMth.Text = "&nbsp;";
        else
            lblMillSalesLbsCurMth.Text = string.Format("{0:n1}", dtActivity.Rows[0]["CMMillLbs"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMOEOrders"]) == 0)
            lblSOEOrdCountCurMth.Text = "&nbsp;";
        else
            lblSOEOrdCountCurMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CMOEOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMEComOrders"]) == 0)
            lblECOrdCountCurMth.Text = "&nbsp;";
        else
            lblECOrdCountCurMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CMEComOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMMillOrders"]) == 0)
            lblMillOrdCountCurMth.Text = "&nbsp;";
        else
            lblMillOrdCountCurMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CMMillOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMOELines"]) == 0)
            lblSOELineCountCurMth.Text = "&nbsp;";
        else
            lblSOELineCountCurMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CMOELines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMEComLines"]) == 0)
            lblECLineCountCurMth.Text = "&nbsp;";
        else
            lblECLineCountCurMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CMEComLines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMMillLines"]) == 0)
            lblMillLineCountCurMth.Text = "&nbsp;";
        else
            lblMillLineCountCurMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CMMillLines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMOEQDol"]) == 0)
            lblSOEQuoteDlrCurMth.Text = "&nbsp;";
        else
            lblSOEQuoteDlrCurMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["CMOEQDol"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMEComQDol"]) == 0)
            lblECQuoteDlrCurMth.Text = "&nbsp;";
        else
            lblECQuoteDlrCurMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["CMEComQDol"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMOEQOrders"]) == 0)
            lblSOEQuoteCountCurMth.Text = "&nbsp;";
        else
            lblSOEQuoteCountCurMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CMOEQOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMEComQOrders"]) == 0)
            lblECQuoteCountCurMth.Text = "&nbsp;";
        else
            lblECQuoteCountCurMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CMEComQOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMOEQLines"]) == 0)
            lblSOEQuoteLineCountCurMth.Text = "&nbsp;";
        else
            lblSOEQuoteLineCountCurMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CMOEQLines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMEComQLines"]) == 0)
            lblECQuoteLineCountCurMth.Text = "&nbsp;";
        else
            lblECQuoteLineCountCurMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CMEComQLines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMRGACount"]) == 0)
            lblRGACountPerDlrCurMth.Text = "&nbsp;";
        else
            lblRGACountPerDlrCurMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CMRGACount"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CMCreditCount"]) == 0)
            lblCreditCountPerDlrCurMth.Text = "&nbsp;";
        else
            lblCreditCountPerDlrCurMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CMCreditCount"]).ToString();
        #endregion

        #region LM - Fiscal Month-Last Year
        lblCustRankLastMth.Text = dtActivity.Rows[0]["LMCorpRank"].ToString();
        lblTerrRankLastMth.Text = dtActivity.Rows[0]["LMTerRank"].ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMSales"]) == 0)
            lblFiscalSlsLastMth.Text = "&nbsp;";
        else
            lblFiscalSlsLastMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["LMSales"]).ToString();

        //lblDlrPctChgLastMth.Text = dtActivity.Rows[0][""].ToString();
        if (Convert.ToDecimal(dtActivity.Rows[0]["LMGM"]) == 0 && Convert.ToDecimal(dtActivity.Rows[0]["LMGMPct"]) == 0)
            lblMgnDlrPctLastMth.Text = "&nbsp;";
        else
            lblMgnDlrPctLastMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["LMGM"]).ToString() + " / " + string.Format("{0:0%}", Convert.ToDecimal(dtActivity.Rows[0]["LMGMPct"])).ToString();
        //test max length $999,999.99/100.00%
        //lblMgnDlrPctLastMth.Text = "$999,999 99/100 00%";
        
        if (Convert.ToDecimal(dtActivity.Rows[0]["LMSalesPerLb"]) == 0)
            lblDlrPerLbLastMth.Text = "&nbsp;";
        else
            lblDlrPerLbLastMth.Text = string.Format("{0:$#,#0.000}", dtActivity.Rows[0]["LMSalesPerLb"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMGMPerLb"]) == 0)
            lblGMDlrPerLbLastMth.Text = "&nbsp;";
        else
            lblGMDlrPerLbLastMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["LMGMPerLb"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMAvgDolPerOrder"]) == 0)
            lblAvgDlrPerOrdLastMth.Text = "&nbsp;";
        else
            lblAvgDlrPerOrdLastMth.Text = string.Format("{0:c}", dtActivity.Rows[0]["LMAvgDolPerOrder"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMAvgDolPerLine"]) == 0)
            lblAvgDlrPerLineLastMth.Text = "&nbsp;";
        else
            lblAvgDlrPerLineLastMth.Text = string.Format("{0:c}", dtActivity.Rows[0]["LMAvgDolPerLine"]).ToString();

        //if (Convert.ToDecimal(dtActivity.Rows[0]["WeeklyGoal"]) == 0)
        //    lblCurWkGoalLastMth.Text = "&nbsp;";
        //else
        //    lblCurWkGoalLastMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["WeeklyGoal"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMOESales"]) == 0)
            lblSOESalesDlrLastMth.Text = "&nbsp;";
        else
            lblSOESalesDlrLastMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["LMOESales"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMEComSales"]) == 0)
            lblECSalesDlrLastMth.Text = "&nbsp;";
        else
            lblECSalesDlrLastMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["LMEComSales"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMMillSales"]) == 0)
            lblMillSalesDlrLastMth.Text = "&nbsp;";
        else
            lblMillSalesDlrLastMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["LMMillSales"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMOELbs"]) == 0)
            lblSOESalesLbsLastMth.Text = "&nbsp;";
        else
            lblSOESalesLbsLastMth.Text = string.Format("{0:n1}", dtActivity.Rows[0]["LMOELbs"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMEComLbs"]) == 0)
            lblECSalesLbsLastMth.Text = "&nbsp;";
        else
            lblECSalesLbsLastMth.Text = string.Format("{0:n1}", dtActivity.Rows[0]["LMEComLbs"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMMillLbs"]) == 0)
            lblMillSalesLbsLastMth.Text = "&nbsp;";
        else
            lblMillSalesLbsLastMth.Text = string.Format("{0:n1}", dtActivity.Rows[0]["LMMillLbs"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMOEOrders"]) == 0)
            lblSOEOrdCountLastMth.Text = "&nbsp;";
        else
            lblSOEOrdCountLastMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LMOEOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMEComOrders"]) == 0)
            lblECOrdCountLastMth.Text = "&nbsp;";
        else
            lblECOrdCountLastMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LMEComOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMMillOrders"]) == 0)
            lblMillOrdCountLastMth.Text = "&nbsp;";
        else
            lblMillOrdCountLastMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LMMillOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMOELines"]) == 0)
            lblSOELineCountLastMth.Text = "&nbsp;";
        else
            lblSOELineCountLastMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LMOELines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMEComLines"]) == 0)
            lblECLineCountLastMth.Text = "&nbsp;";
        else
            lblECLineCountLastMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LMEComLines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMMillLines"]) == 0)
            lblMillLineCountLastMth.Text = "&nbsp;";
        else
            lblMillLineCountLastMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LMMillLines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMOEQDol"]) == 0)
            lblSOEQuoteDlrLastMth.Text = "&nbsp;";
        else
            lblSOEQuoteDlrLastMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["LMOEQDol"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMEComQDol"]) == 0)
            lblECQuoteDlrLastMth.Text = "&nbsp;";
        else
            lblECQuoteDlrLastMth.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["LMEComQDol"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMOEQOrders"]) == 0)
            lblSOEQuoteCountLastMth.Text = "&nbsp;";
        else
            lblSOEQuoteCountLastMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LMOEQOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMEComQOrders"]) == 0)
            lblECQuoteCountLastMth.Text = "&nbsp;";
        else
            lblECQuoteCountLastMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LMEComQOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMOEQLines"]) == 0)
            lblSOEQuoteLineCountLastMth.Text = "&nbsp;";
        else
            lblSOEQuoteLineCountLastMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LMOEQLines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMEComQLines"]) == 0)
            lblECQuoteLineCountLastMth.Text = "&nbsp;";
        else
            lblECQuoteLineCountLastMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LMEComQLines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMRGACount"]) == 0)
            lblRGACountPerDlrLastMth.Text = "&nbsp;";
        else
            lblRGACountPerDlrLastMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LMRGACount"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LMCreditCount"]) == 0)
            lblCreditCountPerDlrLastMth.Text = "&nbsp;";
        else
            lblCreditCountPerDlrLastMth.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LMCreditCount"]).ToString();
        #endregion

        #region CY - Fiscal Year-Current Year
        lblCustRankCurYr.Text = dtActivity.Rows[0]["CYCorpRank"].ToString();
        lblTerrRankCurYr.Text = dtActivity.Rows[0]["CYTerRank"].ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYSales"]) == 0)
            lblFiscalSlsCurYr.Text = "&nbsp;";
        else
            lblFiscalSlsCurYr.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["CYSales"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYSalesPct"]) == 0)
            lblDlrPctChgCurYr.Text = "&nbsp;";
        else
            lblDlrPctChgCurYr.Text = string.Format("{0:0.0%}", Convert.ToDecimal(dtActivity.Rows[0]["CYSalesPct"]));

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYGM"]) == 0 && Convert.ToDecimal(dtActivity.Rows[0]["CYGMPct"]) == 0)
            lblMgnDlrPctCurYr.Text = "&nbsp;";
        else
            lblMgnDlrPctCurYr.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["CYGM"]).ToString() + " / " + string.Format("{0:0%}", Convert.ToDecimal(dtActivity.Rows[0]["CYGMPct"])).ToString();
        //test max length $999,999.99/100.00%
        //lblMgnDlrPctCurYr.Text = "$999,999 99/100 00%";

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYSalesPerLb"]) == 0)
            lblDlrPerLbCurYr.Text = "&nbsp;";
        else
            lblDlrPerLbCurYr.Text = string.Format("{0:$#,#0.000}", dtActivity.Rows[0]["CYSalesPerLb"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYGMPerLb"]) == 0)
            lblGMDlrPerLbCurYr.Text = "&nbsp;";
        else
            lblGMDlrPerLbCurYr.Text = string.Format("{0:c}", dtActivity.Rows[0]["CYGMPerLb"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYAvgDolPerOrder"]) == 0)
            lblAvgDlrPerOrdCurYr.Text = "&nbsp;";
        else
            lblAvgDlrPerOrdCurYr.Text = string.Format("{0:c}", dtActivity.Rows[0]["CYAvgDolPerOrder"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYAvgDolPerLine"]) == 0)
            lblAvgDlrPerLineCurYr.Text = "&nbsp;";
        else
            lblAvgDlrPerLineCurYr.Text = string.Format("{0:c}", dtActivity.Rows[0]["CYAvgDolPerLine"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["Prev3YrSales"]) == 0)
            lblSlsHistCurYr.Text = "&nbsp;";
        else
            lblSlsHistCurYr.Text = dtActivity.Rows[0]["Prev3YrName"].ToString() + " / " + string.Format("{0:$#,#0}", dtActivity.Rows[0]["Prev3YrSales"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["Prev3YrLbs"]) == 0)
            lblLbsHistCurYr.Text = "&nbsp;";
        else
            lblLbsHistCurYr.Text = dtActivity.Rows[0]["Prev3YrName"].ToString() + " / " + string.Format("{0:n1}", dtActivity.Rows[0]["Prev3YrLbs"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["WeeklyGoal"]) == 0)
            lblCurWkGoalCurYr.Text = "&nbsp;";
        else
            lblCurWkGoalCurYr.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["WeeklyGoal"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYOESales"]) == 0)
            lblSOESalesDlrCurYr.Text = "&nbsp;";
        else
            lblSOESalesDlrCurYr.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["CYOESales"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYEComSales"]) == 0)
            lblECSalesDlrCurYr.Text = "&nbsp;";
        else
            lblECSalesDlrCurYr.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["CYEComSales"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYMillSales"]) == 0)
            lblMillSalesDlrCurYr.Text = "&nbsp;";
        else
            lblMillSalesDlrCurYr.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["CYMillSales"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYOELbs"]) == 0)
            lblSOESalesLbsCurYr.Text = "&nbsp;";
        else
            lblSOESalesLbsCurYr.Text = string.Format("{0:n1}", dtActivity.Rows[0]["CYOELbs"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYEComLbs"]) == 0)
            lblECSalesLbsCurYr.Text = "&nbsp;";
        else
            lblECSalesLbsCurYr.Text = string.Format("{0:n1}", dtActivity.Rows[0]["CYEComLbs"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYMillLbs"]) == 0)
            lblMillSalesLbsCurYr.Text = "&nbsp;";
        else
            lblMillSalesLbsCurYr.Text = string.Format("{0:n1}", dtActivity.Rows[0]["CYMillLbs"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYOEOrders"]) == 0)
            lblSOEOrdCountCurYr.Text = "&nbsp;";
        else
            lblSOEOrdCountCurYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CYOEOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYEComOrders"]) == 0)
            lblECOrdCountCurYr.Text = "&nbsp;";
        else
            lblECOrdCountCurYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CYEComOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYMillOrders"]) == 0)
            lblMillOrdCountCurYr.Text = "&nbsp;";
        else
            lblMillOrdCountCurYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CYMillOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYOELines"]) == 0)
            lblSOELineCountCurYr.Text = "&nbsp;";
        else
            lblSOELineCountCurYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CYOELines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYEComLines"]) == 0)
            lblECLineCountCurYr.Text = "&nbsp;";
        else
            lblECLineCountCurYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CYEComLines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYMillLines"]) == 0)
            lblMillLineCountCurYr.Text = "&nbsp;";
        else
            lblMillLineCountCurYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CYMillLines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYOEQDol"]) == 0)
            lblSOEQuoteDlrCurYr.Text = "&nbsp;";
        else
            lblSOEQuoteDlrCurYr.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["CYOEQDol"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYEComQDol"]) == 0)
            lblECQuoteDlrCurYr.Text = "&nbsp;";
        else
            lblECQuoteDlrCurYr.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["CYEComQDol"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYOEQOrders"]) == 0)
            lblSOEQuoteCountCurYr.Text = "&nbsp;";
        else
            lblSOEQuoteCountCurYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CYOEQOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYEComQOrders"]) == 0)
            lblECQuoteCountCurYr.Text = "&nbsp;";
        else
            lblECQuoteCountCurYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CYEComQOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYOEQLines"]) == 0)
            lblSOEQuoteLineCountCurYr.Text = "&nbsp;";
        else
            lblSOEQuoteLineCountCurYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CYOEQLines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYEComQLines"]) == 0)
            lblECQuoteLineCountCurYr.Text = "&nbsp;";
        else
            lblECQuoteLineCountCurYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CYEComQLines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYRGACount"]) == 0)
            lblRGACountPerDlrCurYr.Text = "&nbsp;";
        else
            lblRGACountPerDlrCurYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CYRGACount"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["CYCreditCount"]) == 0)
            lblCreditCountPerDlrCurYr.Text = "&nbsp;";
        else
            lblCreditCountPerDlrCurYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["CYCreditCount"]).ToString();
        #endregion

        #region LY - Fiscal Year-Last Year
        lblCustRankLastYr.Text = dtActivity.Rows[0]["LYCorpRank"].ToString();
        lblTerrRankLastYr.Text = dtActivity.Rows[0]["LYTerRank"].ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYSales"]) == 0)
            lblFiscalSlsLastYr.Text = "&nbsp;";
        else
            lblFiscalSlsLastYr.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["LYSales"]).ToString();

        //lblDlrPctChgLastYr.Text = dtActivity.Rows[0][""].ToString();
        if (Convert.ToDecimal(dtActivity.Rows[0]["LYGM"]) == 0 && Convert.ToDecimal(dtActivity.Rows[0]["LYGMPct"]) == 0)
            lblMgnDlrPctLastYr.Text = "&nbsp;";
        else
            lblMgnDlrPctLastYr.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["LYGM"]).ToString() + " / " + string.Format("{0:0%}", Convert.ToDecimal(dtActivity.Rows[0]["LYGMPct"])).ToString();
        //test max length $999,999.99/100.00%
        //lblMgnDlrPctLastYr.Text = "$999,999 99/100 00%";

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYSalesPerLb"]) == 0)
            lblDlrPerLbLastYr.Text = "&nbsp;";
        else
            lblDlrPerLbLastYr.Text = string.Format("{0:$#,#0.000}", dtActivity.Rows[0]["LYSalesPerLb"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYGMPerLb"]) == 0)
            lblGMDlrPerLbLastYr.Text = "&nbsp;";
        else
            lblGMDlrPerLbLastYr.Text = string.Format("{0:c}", dtActivity.Rows[0]["LYGMPerLb"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYAvgDolPerOrder"]) == 0)
            lblAvgDlrPerOrdLastYr.Text = "&nbsp;";
        else
            lblAvgDlrPerOrdLastYr.Text = string.Format("{0:c}", dtActivity.Rows[0]["LYAvgDolPerOrder"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYAvgDolPerLine"]) == 0)
            lblAvgDlrPerLineLastYr.Text = "&nbsp;";
        else
            lblAvgDlrPerLineLastYr.Text = string.Format("{0:c}", dtActivity.Rows[0]["LYAvgDolPerLine"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["Prev4YrSales"]) == 0)
            lblSlsHistLastYr.Text = "&nbsp;";
        else
            lblSlsHistLastYr.Text = dtActivity.Rows[0]["Prev4YrName"].ToString() + " / " + string.Format("{0:$#,#0}", dtActivity.Rows[0]["Prev4YrSales"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["Prev4YrLbs"]) == 0)
            lblLbsHistLastYr.Text = "&nbsp;";
        else
            lblLbsHistLastYr.Text = dtActivity.Rows[0]["Prev4YrName"].ToString() + " / " + string.Format("{0:n1}", dtActivity.Rows[0]["Prev4YrLbs"]).ToString();

        //if (Convert.ToDecimal(dtActivity.Rows[0]["WeeklyGoal"]) == 0)
        //    lblCurWkGoalLastYr.Text = "&nbsp;";
        //else
        //    lblCurWkGoalLastYr.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["WeeklyGoal"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYOESales"]) == 0)
            lblSOESalesDlrLastYr.Text = "&nbsp;";
        else
            lblSOESalesDlrLastYr.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["LYOESales"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYEComSales"]) == 0)
            lblECSalesDlrLastYr.Text = "&nbsp;";
        else
            lblECSalesDlrLastYr.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["LYEComSales"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYMillSales"]) == 0)
            lblMillSalesDlrLastYr.Text = "&nbsp;";
        else
            lblMillSalesDlrLastYr.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["LYMillSales"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYOELbs"]) == 0)
            lblSOESalesLbsLastYr.Text = "&nbsp;";
        else
            lblSOESalesLbsLastYr.Text = string.Format("{0:n1}", dtActivity.Rows[0]["LYOELbs"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYEComLbs"]) == 0)
            lblECSalesLbsLastYr.Text = "&nbsp;";
        else
            lblECSalesLbsLastYr.Text = string.Format("{0:n1}", dtActivity.Rows[0]["LYEComLbs"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYMillLbs"]) == 0)
            lblMillSalesLbsLastYr.Text = "&nbsp;";
        else
            lblMillSalesLbsLastYr.Text = string.Format("{0:n1}", dtActivity.Rows[0]["LYMillLbs"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYOEOrders"]) == 0)
            lblSOEOrdCountLastYr.Text = "&nbsp;";
        else
            lblSOEOrdCountLastYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LYOEOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYEComOrders"]) == 0)
            lblECOrdCountLastYr.Text = "&nbsp;";
        else
            lblECOrdCountLastYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LYEComOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYMillOrders"]) == 0)
            lblMillOrdCountLastYr.Text = "&nbsp;";
        else
            lblMillOrdCountLastYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LYMillOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYOELines"]) == 0)
            lblSOELineCountLastYr.Text = "&nbsp;";
        else
            lblSOELineCountLastYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LYOELines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYEComLines"]) == 0)
            lblECLineCountLastYr.Text = "&nbsp;";
        else
            lblECLineCountLastYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LYEComLines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYMillLines"]) == 0)
            lblMillLineCountLastYr.Text = "&nbsp;";
        else
            lblMillLineCountLastYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LYMillLines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYOEQDol"]) == 0)
            lblSOEQuoteDlrLastYr.Text = "&nbsp;";
        else
            lblSOEQuoteDlrLastYr.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["LYOEQDol"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYEComQDol"]) == 0)
            lblECQuoteDlrLastYr.Text = "&nbsp;";
        else
            lblECQuoteDlrLastYr.Text = string.Format("{0:$#,#0}", dtActivity.Rows[0]["LYEComQDol"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYOEQOrders"]) == 0)
            lblSOEQuoteCountLastYr.Text = "&nbsp;";
        else
            lblSOEQuoteCountLastYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LYOEQOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYEComQOrders"]) == 0)
            lblECQuoteCountLastYr.Text = "&nbsp;";
        else
            lblECQuoteCountLastYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LYEComQOrders"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYOEQLines"]) == 0)
            lblSOEQuoteLineCountLastYr.Text = "&nbsp;";
        else
            lblSOEQuoteLineCountLastYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LYOEQLines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYEComQLines"]) == 0)
            lblECQuoteLineCountLastYr.Text = "&nbsp;";
        else
            lblECQuoteLineCountLastYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LYEComQLines"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYRGACount"]) == 0)
            lblRGACountPerDlrLastYr.Text = "&nbsp;";
        else
            lblRGACountPerDlrLastYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LYRGACount"]).ToString();

        if (Convert.ToDecimal(dtActivity.Rows[0]["LYCreditCount"]) == 0)
            lblCreditCountPerDlrLastYr.Text = "&nbsp;";
        else
            lblCreditCountPerDlrLastYr.Text = string.Format("{0:n0}", dtActivity.Rows[0]["LYCreditCount"]).ToString();
        #endregion
    }
    #endregion

    #region Toggle Report Data
    protected void rdoVersion_Changed(object sender, EventArgs e)
    {
        if (rdoVersion.SelectedValue.ToString() != "PFC Employee")
            HidePFCOnly();
        else
            UnHidePFCOnly();

        NewPreviewURL();
    }

    protected void ddlRptGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindDataGrid();
        NewPreviewURL();
    }

    //protected void rdoGroup_Changed(object sender, EventArgs e)
    //{
    //    if (rdoGroup.SelectedValue.ToString() == "Category")
    //    {
    //        lblGridHdr.Text = "Sales Summary By Category";
    //        dtGrid = (DataTable)ViewState["dtSOHistCat"];
    //    }
    //    else
    //    {
    //        lblGridHdr.Text = "Sales Summary By Buy Group";
    //        dtGrid = (DataTable)ViewState["dtSOHistGrp"];
    //    }
    //    TotSalesCurYTD = Convert.ToDecimal(dtGrid.Compute("sum(SalesCurYTD)", ""));
    //    BindDataGrid();
    //    NewPreviewURL();
    //}

    private void HidePFCOnly()
    {
        tblCustPFC.Visible = false;
        trCustRank.Visible = false;
        trTerrRank.Visible = false;
        trMgnDlrPct.Visible = false;
        trDlrPerLb.Visible = false;
        trGMDlrPerLb.Visible = false;
        trAvgDlrPerOrd.Visible = false;
        trAvgDlrPerLine.Visible = false;
        trSlsHist.Visible = false;
        trLbsHist.Visible = false;
        trCurWkGoal.Visible = false;

        dgSummary.Width = 805;
        dgSummary.Columns[8].Visible = false;
        dgSummary.Columns[9].Visible = false;
        dgSummary.Columns[10].Visible = false;
        dgSummary.Columns[11].Visible = false;
        dgSummary.Columns[12].Visible = false;
        dgSummary.Columns[13].Visible = false;
        dgSummary.Columns[14].Visible = false;
        dgSummary.Columns[15].Visible = false;
        dgSummary.Columns[16].Visible = false;
        dgSummary.Columns[17].Visible = false;
        dgSummary.Columns[18].Visible = false;
    }

    private void UnHidePFCOnly()
    {
        if (Request.QueryString["RecType"].ToUpper().ToString().Trim() == "CUST")
            tblCustPFC.Visible = true;
        trCustRank.Visible = true;
        trTerrRank.Visible = true;
        trMgnDlrPct.Visible = true;
        trDlrPerLb.Visible = true;
        trGMDlrPerLb.Visible = true;
        trAvgDlrPerOrd.Visible = true;
        trAvgDlrPerLine.Visible = true;
        trSlsHist.Visible = true;
        trLbsHist.Visible = true;
        trCurWkGoal.Visible = true;

        dgSummary.Width = 2000;
        dgSummary.Columns[8].Visible = true;
        dgSummary.Columns[9].Visible = true;
        dgSummary.Columns[10].Visible = true;
        dgSummary.Columns[11].Visible = true;
        dgSummary.Columns[12].Visible = true;
        dgSummary.Columns[13].Visible = true;
        dgSummary.Columns[14].Visible = true;
        dgSummary.Columns[15].Visible = true;
        dgSummary.Columns[16].Visible = true;
        dgSummary.Columns[17].Visible = true;
        dgSummary.Columns[18].Visible = true;
    }
    #endregion
    #endregion

    #region Export Grid Data
    protected void btnExport_Click(object sender, ImageClickEventArgs e)
    {
        xlsFile = "CASRpt" + Session["SessionID"] + ".xls";
        ExportFile = Server.MapPath("..//Common//ExcelUploads//") + xlsFile;
        fnExcel = new FileInfo(ExportFile);
        reportWriter = fnExcel.CreateText();

        headerContent = string.Empty;
        footerContent = string.Empty;
        excelContent = string.Empty;

        try
        {
            BindDataGrid();
        }
        catch (Exception ex)
        {
            return;
        }

        if (dtGrid != null && dtGrid.DefaultView.ToTable().Rows.Count > 0)
        {
            if (rdoVersion.SelectedValue.ToString() != "PFC Employee")
                ExportCustGrid();
            else
                ExportPFCGrid();
        }
        else
            return;

        reportWriter.Close();

        //Downloding Process
        FileStream fileStream = File.Open(ExportFile, FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(ExportFile));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }

    protected void ExportCustGrid()
    {
        //Headers
        headerContent = "<table border='1' width='100%'>";

        switch (ddlRptGroup.SelectedValue.ToString())
        {
            case "Category":
                headerContent += "<tr><th colspan='8' style='color:blue' align=left><center><b>Run By: " + Session["UserName"].ToString() +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Customer Activity Sheet (Sales Summary By Category) - Customer Version" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Run Date: " + DateTime.Now.ToShortDateString() + "</b></center></th></tr>";

                headerContent += "<tr><th colspan='8' align=left><center><b>" + lblCustParam.Text.ToString() +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Period: " + lblPerParam.Text + "</b></center></th></tr>";

                headerContent += "<tr><th nowrap><center>Category</center></th>";
                break;
            case "BuyGroup":
                headerContent += "<tr><th colspan='8' style='color:blue' align=left><center><b>Run By: " + Session["UserName"].ToString() +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Customer Activity Sheet (Sales Summary By Buy Group) - Customer Version" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Run Date: " + DateTime.Now.ToShortDateString() + "</b></center></th></tr>";

                headerContent += "<tr><th colspan='8' align=left><center><b>" + lblCustParam.Text.ToString() +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Period: " + lblPerParam.Text + "</b></center></th></tr>";

                headerContent += "<tr><th nowrap><center>Buy Group</center></th>";
                break;
            case "ProdFam":
                headerContent += "<tr><th colspan='8' style='color:blue' align=left><center><b>Run By: " + Session["UserName"].ToString() +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Customer Activity Sheet (Sales Summary By Prod Family) - Customer Version" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Run Date: " + DateTime.Now.ToShortDateString() + "</b></center></th></tr>";

                headerContent += "<tr><th colspan='8' align=left><center><b>" + lblCustParam.Text.ToString() +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Period: " + lblPerParam.Text + "</b></center></th></tr>";

                headerContent += "<tr><th nowrap><center>Prod Family</center></th>";
                break;
        }


        //if (rdoGroup.SelectedValue.ToString() == "Category")
        //{
        //    headerContent += "<tr><th colspan='8' style='color:blue' align=left><center><b>Run By: " + Session["UserName"].ToString() +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "Customer Activity Sheet (Sales Summary By Category) - Customer Version" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "Run Date: " + DateTime.Now.ToShortDateString() + "</b></center></th></tr>";

        //    headerContent += "<tr><th colspan='8' align=left><center><b>" + lblCustParam.Text.ToString() +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "Period: " + lblPerParam.Text + "</b></center></th></tr>";

        //    headerContent += "<tr><th nowrap><center>Category</center></th>";
        //}
        //else
        //{
        //    headerContent += "<tr><th colspan='8' style='color:blue' align=left><center><b>Run By: " + Session["UserName"].ToString() +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "Customer Activity Sheet (Sales Summary By Buy Group) - Customer Version" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "Run Date: " + DateTime.Now.ToShortDateString() + "</b></center></th></tr>";

        //    headerContent += "<tr><th colspan='8' align=left><center><b>" + lblCustParam.Text.ToString() +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "Period: " + lblPerParam.Text + "</b></center></th></tr>";

        //    headerContent += "<tr><th nowrap><center>Buy Group</center></th>";
        //}


        headerContent += "<th nowrap><center>YTD Sales $</center></th>" +
                         "<th nowrap><center>MTD Sales $</center></th>" +
                         "<th nowrap><center>" + dtGrid.Rows[0]["LastYTDHdr"].ToString() + "</center></th>" +
                         "<th nowrap><center>" + dtGrid.Rows[0]["PrevYTDHdr"].ToString() + "</center></th>" +
                         "<th nowrap><center>YTD Lbs</center></th>" +
                         "<th nowrap><center>MTD Lbs</center></th>" +
                         "<th nowrap><center>% of Sales $</center></th></tr>";
        reportWriter.Write(headerContent);

        foreach (DataRow Row in dtGrid.DefaultView.ToTable().Rows)
        {
            //Detail line
            excelContent = "<tr><td align=left>" + Row["GroupDesc"].ToString() + "</td>" +
                               "<td align=right>" + String.Format("{0:c}", Row["SalesCurYTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:c}", Row["SalesCurMTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:c}", Row["SalesLastYTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:c}", Row["SalesPrevYTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:n}", Row["WghtCurYTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:n}", Row["WghtCurMTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:c}", Row["SalesCurYTD"]) + "</td></tr>";
            reportWriter.Write(excelContent);

            ////Grand Totals
            //dtUnrcvdPO = (DataTable)Session["dtPO"];
            //TotQtyOrd = Convert.ToDecimal(dtUnrcvdPO.Compute("sum(QtyOrdered)", ""));
            //TotQtyRcvd = Convert.ToDecimal(dtUnrcvdPO.Compute("sum(QtyReceived)", ""));
            //TotQtyDue = Convert.ToDecimal(dtUnrcvdPO.Compute("sum(QtyDue)", ""));
            //TotExtCost = Convert.ToDecimal(dtUnrcvdPO.Compute("sum(ExtendedCost)", ""));

            //footerContent = "<tr ><td align=left><b>Grand Totals for all Categories</b></td>" +
            //                     "<td></td>" +
            //                     "<td align=left><b>Number of lines: " + String.Format("{0:n0}", dtUnrcvdPO.Rows.Count) + "</b></td>" +
            //                     "<td></td>" +
            //                     "<td></td>" +
            //                     "<td></td>" +
            //                     "<td></td>" +
            //                     "<td></td>" +
            //                     "<td align=right><b>" + String.Format("{0:n0}", TotQtyOrd) + "</b></td>" +
            //                     "<td align=right><b>" + String.Format("{0:n0}", TotQtyRcvd) + "</b></td>" +
            //                     "<td></td>" +
            //                     "<td></td>" +
            //                     "<td></td>" +
            //                     "<td align=right><b>" + String.Format("{0:n0}", TotQtyDue) + "</b></td>" +
            //                     "<td></td>" +
            //                     "<td align=right><b>" + String.Format("{0:c}", TotExtCost) + "</b></td></tr>";
            //reportWriter.WriteLine(footerContent);
        }
    }

    protected void ExportPFCGrid()
    {
        //Headers
        headerContent = "<table border='1' width='100%'>";

        switch (ddlRptGroup.SelectedValue.ToString())
        {
            case "Category":
                headerContent += "<tr><th colspan='19' style='color:blue' align=left><center><b>Run By: " + Session["UserName"].ToString() +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Customer Activity Sheet (Sales Summary By Category) - Employee Version" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Run Date: " + DateTime.Now.ToShortDateString() + "</b></center></th></tr>";

                headerContent += "<tr><th colspan='19' align=left><center><b>" + lblCustParam.Text.ToString() +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Period: " + lblPerParam.Text + "</b></center></th></tr>";

                headerContent += "<tr><th nowrap><center>Category</center></th>";
                break;
            case "BuyGroup":
                headerContent += "<tr><th colspan='19' style='color:blue' align=left><center><b>Run By: " + Session["UserName"].ToString() +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Customer Activity Sheet (Sales Summary By Buy Group) - Employee Version" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Run Date: " + DateTime.Now.ToShortDateString() + "</b></center></th></tr>";

                headerContent += "<tr><th colspan='19' align=left><center><b>" + lblCustParam.Text.ToString() +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Period: " + lblPerParam.Text + "</b></center></th></tr>";

                headerContent += "<tr><th nowrap><center>Buy Group</center></th>";
                break;
            case "ProdFam":
                headerContent += "<tr><th colspan='19' style='color:blue' align=left><center><b>Run By: " + Session["UserName"].ToString() +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Customer Activity Sheet (Sales Summary By Prod Family) - Employee Version" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Run Date: " + DateTime.Now.ToShortDateString() + "</b></center></th></tr>";

                headerContent += "<tr><th colspan='19' align=left><center><b>" + lblCustParam.Text.ToString() +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Period: " + lblPerParam.Text + "</b></center></th></tr>";

                headerContent += "<tr><th nowrap><center>Prod Family</center></th>";
                break;
        }

        //if (rdoGroup.SelectedValue.ToString() == "Category")
        //{
        //    headerContent += "<tr><th colspan='19' style='color:blue' align=left><center><b>Run By: " + Session["UserName"].ToString() +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "Customer Activity Sheet (Sales Summary By Category) - Employee Version" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "Run Date: " + DateTime.Now.ToShortDateString() + "</b></center></th></tr>";
            
        //    headerContent += "<tr><th colspan='19' align=left><center><b>" + lblCustParam.Text.ToString() +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "Period: " + lblPerParam.Text + "</b></center></th></tr>";
            
        //    headerContent += "<tr><th nowrap><center>Category</center></th>";
        //}
        //else
        //{
        //    headerContent += "<tr><th colspan='19' style='color:blue' align=left><center><b>Run By: " + Session["UserName"].ToString() +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "Customer Activity Sheet (Sales Summary By Buy Group) - Employee Version" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "Run Date: " + DateTime.Now.ToShortDateString() + "</b></center></th></tr>";

        //    headerContent += "<tr><th colspan='19' align=left><center><b>" + lblCustParam.Text.ToString() +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
        //                            "Period: " + lblPerParam.Text + "</b></center></th></tr>";

        //    headerContent += "<tr><th nowrap><center>Buy Group</center></th>";
        //}

        headerContent += "<th nowrap><center>YTD Sales $</center></th>" +
                         "<th nowrap><center>MTD Sales $</center></th>" +
                         "<th nowrap><center>" + dtGrid.Rows[0]["LastYTDHdr"].ToString() + "</center></th>" +
                         "<th nowrap><center>" + dtGrid.Rows[0]["PrevYTDHdr"].ToString() + "</center></th>" +
                         "<th nowrap><center>YTD Lbs</center></th>" +
                         "<th nowrap><center>MTD Lbs</center></th>" +
                         "<th nowrap><center>% of Sales $</center></th>" +
                         "<th nowrap><center>YTD GM$</center></th>" +
                         "<th nowrap><center>MTD GM$</center></th>" +
                         "<th nowrap><center>YTD Avg GM %</center></th>" +
                         "<th nowrap><center>MTD Avg GM %</center></th>" +
                         "<th nowrap><center>YTD Price GM %</center></th>" +
                         "<th nowrap><center>MTD Price GM %</center></th>" +
                         "<th nowrap><center>Target GM %</center></th>" +
                         "<th nowrap><center>YTD $/Lb</center></th>" +
                         "<th nowrap><center>MTD $/Lb</center></th>" +
                         "<th nowrap><center>YTD GM/Lb</center></th>" +
                         "<th nowrap><center>MTD GM/Lb</center></th></tr>";
        reportWriter.Write(headerContent);

        foreach (DataRow Row in dtGrid.DefaultView.ToTable().Rows)
        {
            //Detail line
            excelContent = "<tr><td align=left>" + Row["GroupDesc"].ToString() + "</td>" +
                               "<td align=right>" + String.Format("{0:c}", Row["SalesCurYTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:c}", Row["SalesCurMTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:c}", Row["SalesLastYTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:c}", Row["SalesPrevYTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:n}", Row["WghtCurYTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:n}", Row["WghtCurMTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:c}", Row["SalesCurYTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:c}", Row["GMDlrCurYTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:c}", Row["GMDlrCurMTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:0.0%}", Row["AvgGMPctYTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:0.0%}", Row["AvgGMPctMTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:0.0%}", Row["PriceGMPctYTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:0.0%}", Row["PriceGMPctMTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:0.0%}", Row["DefaultGMPct"].ToString()) + "</td>" +
                               "<td align=right>" + String.Format("{0:c}", Row["DlrPerLbCurYTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:c}", Row["DlrPerLbCurMTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:c}", Row["GMPerLbCurYTD"]) + "</td>" +
                               "<td align=right>" + String.Format("{0:c}", Row["GMPerLbCurMTD"]) + "</td></tr>";
            reportWriter.Write(excelContent);

            ////Grand Totals
            //dtUnrcvdPO = (DataTable)Session["dtPO"];
            //TotQtyOrd = Convert.ToDecimal(dtUnrcvdPO.Compute("sum(QtyOrdered)", ""));
            //TotQtyRcvd = Convert.ToDecimal(dtUnrcvdPO.Compute("sum(QtyReceived)", ""));
            //TotQtyDue = Convert.ToDecimal(dtUnrcvdPO.Compute("sum(QtyDue)", ""));
            //TotExtCost = Convert.ToDecimal(dtUnrcvdPO.Compute("sum(ExtendedCost)", ""));

            //footerContent = "<tr ><td align=left><b>Grand Totals for all Categories</b></td>" +
            //                     "<td></td>" +
            //                     "<td align=left><b>Number of lines: " + String.Format("{0:n0}", dtUnrcvdPO.Rows.Count) + "</b></td>" +
            //                     "<td></td>" +
            //                     "<td></td>" +
            //                     "<td></td>" +
            //                     "<td></td>" +
            //                     "<td></td>" +
            //                     "<td align=right><b>" + String.Format("{0:n0}", TotQtyOrd) + "</b></td>" +
            //                     "<td align=right><b>" + String.Format("{0:n0}", TotQtyRcvd) + "</b></td>" +
            //                     "<td></td>" +
            //                     "<td></td>" +
            //                     "<td></td>" +
            //                     "<td align=right><b>" + String.Format("{0:n0}", TotQtyDue) + "</b></td>" +
            //                     "<td></td>" +
            //                     "<td align=right><b>" + String.Format("{0:c}", TotExtCost) + "</b></td></tr>";
            //reportWriter.WriteLine(footerContent);
        }
    }
    #endregion

    private void NewPreviewURL()
    {
        PreviewURL = "SalesAnalysisReport/CustomerActivityRptPreview.aspx" +
                     "?RecID=" + Request.QueryString["RecID"].ToString() +
                     "&RecType=" + Request.QueryString["RecType"].ToUpper().ToString().Trim() +
                     "&Period=" + Request.QueryString["Period"].ToString() +
                     "&Version=" + ((rdoVersion.SelectedValue.ToString() == "PFC Employee") ? "Emp" : "Cus") +
//                     "&Group=" + ((rdoGroup.SelectedValue.ToString() == "Buy Group") ? "BuyGroup" : "Category") +
                     "&Group=" + ddlRptGroup.SelectedValue.ToString() +
                     "&Sort=" + ((hidSort.Value == "") ? " 'SalesCurYTD DESC, SalesLastYTD DESC, SalesPrevYTD DESC'" : hidSort.Value);
        PrintDialogue1.PageUrl = PreviewURL;
        pnlExport.Update();
    }

    private void DisplayStatusMessage(string message, string messageType)
    {
        lblMessage.Visible = true;
        if (messageType.ToLower() == "success")
        {
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = message;
        }
        else if (messageType.ToLower() == "fail")
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = message;
        }
        else
        {
            lblMessage.ForeColor = System.Drawing.Color.Black;
            lblMessage.Text = message;
        }

        pnlStatus.Update();
    }

    [Ajax.AjaxMethod()]
    public string Close(string strSession)
    {
        ViewState["dtSOHistCat"] = null;
        ViewState["dtSOHistGrp"] = null;
        ViewState["dtSOHistFam"] = null;

        try
        {
            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..//Common//ExcelUploads//"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(strSession))
                    fn.Delete();
            }

            return "";
        }
        catch (Exception ex) { return ""; }

        return "";
    }

    //private string GetMonth(string monthNum)
    //{
    //    string _month = "null";
    //    switch (monthNum)
    //    {
    //        case "01":
    //            _month = "January";
    //            break;
    //        case "02":
    //            _month = "February";
    //            break;
    //        case "03":
    //            _month = "March";
    //            break;
    //        case "04":
    //            _month = "April";
    //            break;
    //        case "05":
    //            _month = "May";
    //            break;
    //        case "06":
    //            _month = "June";
    //            break;
    //        case "07":
    //            _month = "July";
    //            break;
    //        case "08":
    //            _month = "August";
    //            break;
    //        case "09":
    //            _month = "September";
    //            break;
    //        case "10":
    //            _month = "October";
    //            break;
    //        case "11":
    //            _month = "November";
    //            break;
    //        case "12":
    //            _month = "December";
    //            break;
    //    }
    //    return _month + " '";
    //}

    #region Add Default GM %

    public void DefaultGMPctJoins(ref DataTable dtSOHist, DataTable dtCustDiscPct)
    {
        try
        {
            DataSet dsFinalResult = new DataSet();
            dtSOHist.TableName = "SOHist"; // Master
            dtCustDiscPct.TableName = "CustDiscPct";

            //DataColumn dcGMPct = new DataColumn("DefaultGMPct2", typeof(string));
            //dcGMPct.DefaultValue = "";
            //dtSOHist.Columns.Add(dcGMPct); // Br
            dsFinalResult.Tables.Add(dtSOHist.Copy());
            dsFinalResult.Tables.Add(dtCustDiscPct.Copy());

            DataRelation customerNumberRelation =
            dsFinalResult.Relations.Add("DiscPct",
            new DataColumn[] { dsFinalResult.Tables["SOHist"].Columns["GroupNo"] },
            new DataColumn[] { dsFinalResult.Tables["CustDiscPct"].Columns["ItemNo"] }, false);

            foreach (DataRow pfcBranchRow in dsFinalResult.Tables["SOHist"].Rows)
            {
                foreach (DataRow custDiscPctRow in pfcBranchRow.GetChildRows(customerNumberRelation))
                {
                    pfcBranchRow["DefaultGMPct"] = custDiscPctRow["DiscPct"].ToString() + "%";
                }
            }

            dtSOHist = dsFinalResult.Tables["SOHist"];
        }
        catch (Exception ex)
        {
        }
    }

    #endregion
}
