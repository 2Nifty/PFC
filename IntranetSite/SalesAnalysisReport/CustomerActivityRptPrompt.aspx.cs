using System;
using System.IO;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.MaintenanceApps;
using PFC.SOE.BusinessLogicLayer;

public partial class CustomerActivityRptPrompt : System.Web.UI.Page
{
    SqlConnection cnERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
    SqlConnection cnReports = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCReportsConnectionString"].ConnectionString);
    DataSet dsResult = new DataSet();
    DataTable newDT = new DataTable();

    SalesReportUtils salesReportUtils = new SalesReportUtils();
    InvoiceAnalysis invoiceAnalysis = new InvoiceAnalysis();
    PrintUtilityDialogue printUtility = new PrintUtilityDialogue();
    MaintenanceUtility MaintUtil = new MaintenanceUtility();

    string strSQL, PreviewURL, RecID, RecType, tempChainXLS, tempChainTbl, tempCustXLS, tempCustTbl, FilterCode;

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(CustomerActivityRptPrompt));

        tempChainXLS = Server.MapPath("..//Common//ExcelUploads//") + "tWO2154_CustActivity_Chain_" + Session["UserName"].ToString() + ".xls";
        tempChainTbl = "tWO2154_CustActivity_Chain_" + Session["UserName"].ToString();
        tempCustXLS = Server.MapPath("..//Common//ExcelUploads//") + "tWO2154_CustActivity_Cust_" + Session["UserName"].ToString() + ".xls";
        tempCustTbl = "tWO2154_CustActivity_Cust_" + Session["UserName"].ToString();

        if (!IsPostBack)
        {
            GetSecurity();

            BindPeriod();
            BindBranch();
            //salesReportUtils.GetChainName(ddlChain);    //Fill the Chain DDL
            BindChain();
            BindTerritory();
            BindOutsideRep();
            BindInsideRep();
            BindRegionalMgr();
            BindBuyGroup();
            BindRptGroup();
            BindPrintServer();
            BindPrinter();

            chkCustRpt.Checked = false;
            chkEmpRpt.Checked = true;
            //chkBuyGrpRpt.Checked = false;
            //chkCatRpt.Checked = true;
            ddlRptGroup.SelectedIndex = 0;
        }
    }

    #region Bind User Prompts
    //Fill the Period (Year) DDL
    private void BindPeriod()
    {
        ddlYear.Items.Clear();
        string strYear = string.Empty;
        for (int i = 0; ; i++)
        {
            strYear = i.ToString();
            strYear = (strYear.Length == 1) ? "200" + i.ToString() : "20" + i.ToString();
            if (Convert.ToInt32(strYear) > DateTime.Now.Year)
                break;

            ddlYear.Items.Insert(i, new ListItem(strYear, strYear));
        }

        int month = (int)DateTime.Now.Month;
        int year = Convert.ToInt16(DateTime.Now.Year.ToString().Substring(2));
        if (month != 1)
        {
            ddlMonth.Items[month - 2].Selected = true;
            ddlYear.Items[year].Selected = true;
        }
        else
        {
            ddlMonth.Items[ddlMonth.Items.Count - 1].Selected = true;
            ddlYear.Items[year - 1].Selected = true;
        }
    }

    #region Branch
    //Fill the Branch DDL
    private void BindBranch()
    {
        try
        {
            salesReportUtils.GetALLBranches(ddlBranch, Session["UserID"].ToString());
            for (int i = 0; i <= ddlBranch.Items.Count - 1; i++)
                if (ddlBranch.Items[i].Value.Trim() == Session["BranchID"].ToString())
                {
                    ddlBranch.Items[i].Selected = true;
                    break;
                }
        }
        catch (Exception ex) { }
    }

    //Branch Change Event
    protected void ddlBranch_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindTerritory();
        BindOutsideRep();
        BindInsideRep();
        BindRegionalMgr();

        pnlTerritory.Update();
        pnlOutsideRep.Update();
        pnlInsideRep.Update();
        pnlRegionalMgr.Update();
    }

    protected void chkBrSumm_CheckedChanged(object sender, EventArgs e)
    {
        if (chkBrSumm.Checked)
        {
            if (ddlBranch.SelectedValue == "00")
                ddlBranch.SelectedIndex = 0;
            DisablePrompt1();
            DisablePrompt2();
            chkBrSumm.Enabled = true;
        }
        else
        {
            EnablePrompt1();
            EnablePrompt2();
        }
        RefreshUserPromptPanels();
    }
    #endregion

    //Fill the Chain DDL
    public void BindChain()
    {
        DataTable dt = invoiceAnalysis.GetChainListNoSumm();
        ddlChain.DataSource = dt;
        ddlChain.DataValueField = "ValueField";
        ddlChain.DataTextField = "TextField";
        ddlChain.DataBind();
        ddlChain.Items.Insert(0, new ListItem("ALL", "ALL"));
    }

    //Fill the Territory DDL
    public void BindTerritory()
    {
        string branchID = (ddlBranch.SelectedIndex == 0 ? "ALL" : ddlBranch.SelectedValue);
        DataTable dt = invoiceAnalysis.GetTerritory(branchID);
        ddlTerritory.DataSource = dt;
        ddlTerritory.DataValueField = "ValueField";
        ddlTerritory.DataTextField = "TextField";
        ddlTerritory.DataBind();
        ddlTerritory.Items.Insert(0, new ListItem("ALL", "ALL"));
    }

    //Fill the Outside Sales Rep DDL
    public void BindOutsideRep()
    {
        string branchID = (ddlBranch.SelectedIndex == 0 ? "ALL" : ddlBranch.SelectedValue);
        DataTable dt = invoiceAnalysis.GetCSRNames(branchID);
        ddlOutsideRep.DataSource = dt;
        ddlOutsideRep.DataValueField = "RepNo";
        ddlOutsideRep.DataTextField = "RepName";
        ddlOutsideRep.DataBind();
        ddlOutsideRep.Items.Insert(0, new ListItem("ALL", "ALL"));
    }

    //Fill the Inside Sales Rep DDL
    public void BindInsideRep()
    {
        string branchID = (ddlBranch.SelectedIndex == 0 ? "ALL" : ddlBranch.SelectedValue);
        DataTable dt = invoiceAnalysis.GetSalesPerson(branchID);
        ddlInsideRep.DataSource = dt;
        ddlInsideRep.DataValueField = "RepNo";
        ddlInsideRep.DataTextField = "RepName";
        ddlInsideRep.DataBind();
        ddlInsideRep.Items.Insert(0, new ListItem("ALL", "ALL"));
    }

    //Fill the Regional Mgr DDL
    public void BindRegionalMgr()
    {
        string branchID = (ddlBranch.SelectedIndex == 0 ? "ALL" : ddlBranch.SelectedValue);
        DataTable dt = invoiceAnalysis.GetRegionalMgr(branchID);
        ddlRegionalMgr.DataSource = dt;
        ddlRegionalMgr.DataValueField = "RepNo";
        ddlRegionalMgr.DataTextField = "RepName";
        ddlRegionalMgr.DataBind();
        ddlRegionalMgr.Items.Insert(0, new ListItem("ALL", "ALL"));
    }

    //Fill the Buy Group
    public void BindBuyGroup()
    {
        DataTable dt = invoiceAnalysis.GetDataFromList("BuyGrp");  //Fill the Buy Group DDL

        ddlBuyGroup.DataSource = dt;
        ddlBuyGroup.DataValueField = "ValueField";
        ddlBuyGroup.DataTextField = "TextField";
        ddlBuyGroup.DataBind();
        ddlBuyGroup.Items.Insert(0, new ListItem("ALL", "ALL"));
    }

    //Fill the Rpt Group
    public void BindRptGroup()
    {
        ListItem ddlList = new ListItem("Category", "Category", true);
        ddlRptGroup.Items.Add(ddlList);
        ddlList = new ListItem("Category Buy Group", "BuyGroup", true);
        ddlRptGroup.Items.Add(ddlList);
        ddlList = new ListItem("Product Family", "ProdFam", true);
        ddlRptGroup.Items.Add(ddlList);
    }

    public void BindPrintServer()
    {
        DataTable dtPrinterServer = printUtility.GetPrinterServer();
        ddlPrintServer.DataSource = dtPrinterServer;
        ddlPrintServer.DataTextField = "Printserver";
        ddlPrintServer.DataValueField = "Printserver";
        ddlPrintServer.DataBind();
    }

    public void BindPrinter()
    {
        string whereCondition = ddlPrintServer.SelectedItem.Value.ToString();
        DataTable dtPrinterName = printUtility.GetPrinterName(whereCondition);
        ddlPrintName.DataSource = dtPrinterName;
        ddlPrintName.DataTextField = "PrinterPath";
        ddlPrintName.DataValueField = "PrinterNetworkAddress";
        ddlPrintName.DataBind();
    }
    
    protected void ddlPrintServer_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindPrinter();
    }
    #endregion

    #region Change Events
    #region Chain Prompts
    protected void ddlChain_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlChain.SelectedIndex != 0)
        {
            DisablePrompt1();
            DisablePrompt2();
            ddlChain.Enabled = true;
        }
        else
        {
            EnablePrompt1();
            EnablePrompt2();        
        }
        RefreshUserPromptPanels();
    }

    protected void chkChainXLS_CheckedChanged(object sender, EventArgs e)
    {
        if (chkChainXLS.Checked)
        {
            DisablePrompt1();
            DisablePrompt2();
            chkChainXLS.Enabled = true;
            uplChainXLS.Enabled = true;
        }
        else
        {
            EnablePrompt1();
            EnablePrompt2();
            uplChainXLS.Enabled = false;
        }
        RefreshUserPromptPanels();
    }

    protected void chkListChain_CheckedChanged(object sender, EventArgs e)
    {
        if (chkListChain.Checked)
        {
            DisablePrompt1();
            DisablePrompt2();
            chkListChain.Enabled = true;
            txtListChain.Enabled = true;
        }
        else
        {
            EnablePrompt1();
            EnablePrompt2();
            txtListChain.Enabled = false;
            txtListChain.Text = string.Empty;
        }
        RefreshUserPromptPanels();
    }
    #endregion

    #region Customer Prompts
    protected void txtCustNo_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtCustNo.Text))
        {
            DisablePrompt1();
            txtCustNo.Enabled = true;
        }
        else
        {
            EnablePrompt1();
        }
        RefreshUserPromptPanels();
    }

    protected void chkCustXLS_CheckedChanged(object sender, EventArgs e)
    {
        if (chkCustXLS.Checked)
        {
            DisablePrompt1();
            chkCustXLS.Enabled = true;
            uplCustXLS.Enabled = true;
        }
        else
        {
            EnablePrompt1();
            uplCustXLS.Enabled = false;
        }
        RefreshUserPromptPanels();
    }

    protected void chkListCust_CheckedChanged(object sender, EventArgs e)
    {
        if (chkListCust.Checked)
        {
            DisablePrompt1();
            chkListCust.Enabled = true;
            txtListCust.Enabled = true;
        }
        else
        {
            EnablePrompt1();
            txtListCust.Enabled = false;
            txtListCust.Text = string.Empty;
        }
        RefreshUserPromptPanels();
    }
    #endregion

    #region Report Options
    protected void chkCustRpt_CheckedChanged(object sender, EventArgs e)
    {
        if (chkCustRpt.Checked)
            chkEmpRpt.Checked = false;
        else
            chkEmpRpt.Checked = true;
        RefreshUserPromptPanels();
    }

    protected void chkEmpRpt_CheckedChanged(object sender, EventArgs e)
    {
        if (chkEmpRpt.Checked)
            chkCustRpt.Checked = false;
        else
            chkCustRpt.Checked = true;
        RefreshUserPromptPanels();
    }
    
    //protected void chkBuyGrpRpt_CheckedChanged(object sender, EventArgs e)
    //{
    //    if (chkBuyGrpRpt.Checked)
    //        chkCatRpt.Checked = false;
    //    else
    //        chkCatRpt.Checked = true;
    //    RefreshUserPromptPanels();
    //}
    
    //protected void chkCatRpt_CheckedChanged(object sender, EventArgs e)
    //{
    //    if (chkCatRpt.Checked)
    //        chkBuyGrpRpt.Checked = false;
    //    else
    //        chkBuyGrpRpt.Checked = true;
    //    RefreshUserPromptPanels();
    //}
    #endregion
    #endregion

    #region Button Events
    protected void btnSubmit_Click(object sender, ImageClickEventArgs e)
    {
        string _Period = string.Empty,
               _Branch = string.Empty,
               _Chain = string.Empty,
               _ChainList = string.Empty,
               _CustNo = string.Empty,
               _CustList = string.Empty,
               _FilterCd = "NoFilter",
               _Territory = string.Empty,
               _OutsideRep = string.Empty,
               _InsideRep = string.Empty,
               _RegionalMgr = string.Empty,
               _BuyGroup = string.Empty,
               _ParamTbl = string.Empty;

        _Period = ddlYear.SelectedItem.ToString() + ddlMonth.SelectedValue.ToString();
        hidPeriod.Value = _Period;
        
        if (ddlBranch.SelectedIndex != 0)
            _Branch = ddlBranch.SelectedValue.ToString();

        if (chkBrSumm.Checked)
        {
            if (ddlBranch.SelectedIndex == 0)
                _Branch = "00";
            _FilterCd = "Branch-" + _Branch;
        }

        if (ddlChain.SelectedIndex != 0)
        {
            _Chain = ddlChain.SelectedValue.ToString();
            _FilterCd = "ChainCd";
        }

        if (chkChainXLS.Checked)
        {
            uplChainXLS.SaveAs(tempChainXLS);
            try
            {
                XLStoTable(tempChainXLS, tempChainTbl);
                File.Delete(tempChainXLS);
            }
            catch (Exception ex)
            {
                DisplayStatusMessage("Error processing Excel parameter file (Chain)", "fail");
                return;
            }
            _ParamTbl = tempChainTbl;
            _FilterCd = "ChainXLS";
        }

        if (chkListChain.Checked)
        {
            _ChainList = txtListChain.Text.ToString().Replace("'","").Replace("\"","");
            _ChainList = _ChainList.Replace(",", "','");
            _ChainList = "'" + _ChainList + "'";
            txtListChain.Text = _ChainList;
            _FilterCd = "ChainList";
        }

        if (!string.IsNullOrEmpty(txtCustNo.Text))
        {
            _CustNo = txtCustNo.Text.ToString();
            _FilterCd = "CustNo";
        }

        if (chkCustXLS.Checked)
        {
            uplCustXLS.SaveAs(tempCustXLS);
            try
            {
                XLStoTable(tempCustXLS, tempCustTbl);
                File.Delete(tempCustXLS);
            }
            catch (Exception ex)
            {
                DisplayStatusMessage("Error processing Excel parameter file (Customer)", "fail");
                return;
            }
            _ParamTbl = tempCustTbl;
            _FilterCd = "CustXLS";
        }

        if (chkListCust.Checked)
        {
            //_CustList = ParseList(txtListCust.Text);
            //txtListCust.Text = _CustList;
            _CustList = txtListCust.Text.ToString().Replace("'", "").Replace("\"", "");
            _CustList = _CustList.Replace(",", "','");
            _CustList = "'" + _CustList + "'";
            txtListCust.Text = _CustList;
            _FilterCd = "CustList";
        }

        if (ddlTerritory.SelectedIndex != 0)
            _Territory = ddlTerritory.SelectedValue.ToString();

        if (ddlOutsideRep.SelectedIndex != 0)
            _OutsideRep = ddlOutsideRep.SelectedItem.ToString();

        if (ddlInsideRep.SelectedIndex != 0)
            _InsideRep = ddlInsideRep.SelectedItem.ToString();

        if (ddlRegionalMgr.SelectedIndex != 0)
            _RegionalMgr = ddlRegionalMgr.SelectedItem.ToString();

        if (ddlBuyGroup.SelectedIndex != 0)
            _BuyGroup = ddlBuyGroup.SelectedValue.ToString();

        lblResults.Visible = false;
        lblRptCount.Text = "";
        divdatagrid.Visible = false;
        divPrinter.Visible = false;

        lblMessage.Text = "";
        pnlStatus.Update();

        try
        {
            dsResult = SqlHelper.ExecuteDataset(cnReports, "pCustActivityGetList",
                                                new SqlParameter("@Action", "GET"),
                                                new SqlParameter("@Period", _Period),
                                                new SqlParameter("@CustShipLocation", _Branch),
                                                new SqlParameter("@ChainCd", _Chain),
                                                new SqlParameter("@ChainList", _ChainList),
                                                new SqlParameter("@CustNo", _CustNo),
                                                new SqlParameter("@CustList", _CustList),
                                                new SqlParameter("@FilterCd", _FilterCd),
                                                new SqlParameter("@SalesTerritory", _Territory),
                                                new SqlParameter("@OutsideRep", _OutsideRep),
                                                new SqlParameter("@InsideRep", _InsideRep),
                                                new SqlParameter("@RegionalMgr", _RegionalMgr),
                                                new SqlParameter("@BuyGroup", _BuyGroup),
                                                new SqlParameter("@ParamTbl", _ParamTbl));
        }
        catch (Exception ex)
        {
            DisplayStatusMessage("Error executing stored procedure (pCustActivityGetList: GET)", "fail");
            return;
        }

        if (dsResult.Tables[0].Rows.Count > 0)
        {
            Session["dsActivity"] = dsResult;
            BindDataGrid();
        }
        else
            DisplayStatusMessage("No Customers or Chains to Report", "fail");

        //DisplayStatusMessage(_ChainXLS, "fail");
        //DisplayStatusMessage(_ChainSheet, "fail");
        //DisplayStatusMessage(_CustXLS, "fail");
        //DisplayStatusMessage(_CustSheet, "fail");
        
        RefreshUserPromptPanels();
    }

    protected void btnClear_Click(object sender, ImageClickEventArgs e)
    {
        lblResults.Visible = false;
        lblRptCount.Text = "";
        divdatagrid.Visible = false;
        divPrinter.Visible = false;

        ddlMonth.Enabled = true;
        ddlYear.Enabled = true;
        ddlBranch.Enabled = true;

        EnablePrompt1();
        EnablePrompt2();

        if (chkBrSumm.Checked)
        {
            if (ddlBranch.SelectedValue == "00")
                ddlBranch.SelectedIndex = 0;
            DisablePrompt1();
            DisablePrompt2();
            chkBrSumm.Enabled = true;
        } 
        else if (ddlChain.SelectedIndex != 0)
        {
            DisablePrompt1();
            DisablePrompt2();
            ddlChain.Enabled = true;
        }
        else if (chkChainXLS.Checked)
        {
            DisablePrompt1();
            DisablePrompt2();
            chkChainXLS.Enabled = true;
            uplChainXLS.Enabled = true;
        }
        else if (chkListChain.Checked)
        {
            DisablePrompt1();
            DisablePrompt2();
            chkListChain.Enabled = true;
            txtListChain.Enabled = true;
        }
        else if (!string.IsNullOrEmpty(txtCustNo.Text))
        {
            DisablePrompt1();
            txtCustNo.Enabled = true;
        }
        else if (chkCustXLS.Checked)
        {
            DisablePrompt1();
            chkCustXLS.Enabled = true;
            uplCustXLS.Enabled = true;
        }
        else if (chkListCust.Checked)
        {
            DisablePrompt1();
            chkListCust.Enabled = true;
            txtListCust.Enabled = true;
        }
        
        btnSubmitTop.Visible = true;
        btnSubmitBtm.Visible = true;
        btnClearTop.Visible = false;
        btnClearBtm.Visible = false;
        btnPrint.Visible = false;
        lblMessage.Visible = false;

        uplReportContentTop.Update();
        uplReportContentBtm.Update();

        Close();
        RefreshUserPromptPanels();
    }

    protected void btnPrint_Click(object sender, ImageClickEventArgs e)
    {
        dsResult = (DataSet)Session["dsActivity"];
        foreach (DataRow Row in dsResult.Tables[0].DefaultView.ToTable().Rows)
        {
            PreviewURL = ConfigurationManager.AppSettings["IntranetSiteURL"].ToString() +
                         "SalesAnalysisReport/CustomerActivityRptPreview.aspx" +
                         "?RecID=" + Row["RecID"].ToString() +
                         "&RecType=" + Row["RecType"].ToString() +
                         "&Period=" + hidPeriod.Value +
                         "&Version=" + ((chkEmpRpt.Checked) ? "Emp" : "Cus") +
//                       "&Group=" + ((chkBuyGrpRpt.Checked) ? "BuyGroup" : "Category") +                         
                         "&Group=" + ddlRptGroup.SelectedValue.ToString().Trim() + 
                        //"&ScriptX=YES&Sort=";
                         "&Sort=";
            try
            {
                printUtility.PostRequestQueue(ddlPrintName.SelectedValue.ToString(), "CustomerActivityRptPreview", PreviewURL, "P", "Print", Session["UserName"].ToString(), "");
            }
            catch (Exception ex)
            {
                DisplayStatusMessage("Error adding Print Records to the RequestQueue", "fail");
                return;
            }
        }
        DisplayStatusMessage("Print Records added to the RequestQueue", "success");
    }
    #endregion

    #region Results DataGrid
    protected void BindDataGrid()
    {
        dsResult = (DataSet)Session["dsActivity"];
        RecType = dsResult.Tables[0].Rows[0]["RecType"].ToString();

        switch (RecType)
        {
            case "Chain":
                lblResults.Text = "Chains to report:&nbsp;&nbsp;";
                lblRptCount.Text = dsResult.Tables[0].Rows.Count.ToString();
                break;
            case "Cust":
                lblResults.Text = "Customers to report:&nbsp;&nbsp;";
                lblRptCount.Text = dsResult.Tables[0].Rows.Count.ToString();
                break;
            case "Summ":
                lblResults.Text = "Branch Sumaries";
                lblRptCount.Text = string.Empty;
                break;
        }
        lblResults.Visible = true;

        //DisplayStatusMessage(lblRptCount.Text, "success");
        divdatagrid.Visible = true;
        divPrinter.Visible = true;

        ddlMonth.Enabled = false;
        ddlYear.Enabled = false;
        ddlBranch.Enabled = false;

        DisablePrompt1();
        uplChainXLS.Enabled = false;
        txtListChain.Enabled = false;
        uplCustXLS.Enabled = false;
        txtListCust.Enabled = false;
        ddlTerritory.Enabled = false;
        ddlOutsideRep.Enabled = false;
        ddlInsideRep.Enabled = false;
        ddlRegionalMgr.Enabled = false;
        ddlBuyGroup.Enabled = false;
        ddlRptGroup.Enabled = false;
        //chkCustRpt.Enabled = false;
        //chkEmpRpt.Enabled = false;
        //chkBuyGrpRpt.Enabled = false;
        //chkCatRpt.Enabled = false;
        btnSubmitTop.Visible = false;
        btnSubmitBtm.Visible = false;
        btnClearTop.Visible = true;
        btnClearBtm.Visible = true;
        btnPrint.Visible = true;

        uplReportContentTop.Update();
        uplReportContentBtm.Update();

        dgResults.DataSource = dsResult.Tables[0].DefaultView.ToTable();
        dgResults.DataBind();
    }

    protected void dgResults_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            RecID = dsResult.Tables[0].DefaultView.ToTable().Rows[e.Item.DataSetIndex]["RecID"].ToString().Trim();

            //Link Individual Report Preview
            LinkButton _lnkPreview = e.Item.FindControl("lnkPreview") as LinkButton;
            _lnkPreview.Attributes.Add("style", "cursor:hand; text-decoration:underline;");
            _lnkPreview.Attributes.Add("title", "Click to preview");
            _lnkPreview.Attributes.Add("onclick", "return RptPreview('" + RecID + "','" + RecType + "');");
        }
    }
    #endregion

    #region Parse Function (commented)
    //private string ParseList(string List)
    //{
    //    int pos1,
    //        posList = -1,
    //        lenList = -1;

    //    string result = string.Empty;

    //    for (pos1 = 0; pos1 <= List.Length - 1; pos1++)
    //    {
    //        if (List.Substring(pos1, 1) == "0" || List.Substring(pos1, 1) == "1" ||
    //            List.Substring(pos1, 1) == "2" || List.Substring(pos1, 1) == "3" ||
    //            List.Substring(pos1, 1) == "4" || List.Substring(pos1, 1) == "5" ||
    //            List.Substring(pos1, 1) == "6" || List.Substring(pos1, 1) == "7" ||
    //            List.Substring(pos1, 1) == "8" || List.Substring(pos1, 1) == "9")
    //        {
    //            if (posList < 0)
    //                posList = pos1;
    //        }
    //        else
    //        {
    //            if (posList >= 0)
    //                lenList = pos1 - posList;
    //        }

    //        if (lenList >= 0)
    //        {
    //            if (string.IsNullOrEmpty(result))
    //                result = "'" + List.Substring(posList, lenList).Trim() + "'";
    //            else
    //                result += ",'" + List.Substring(posList, lenList).Trim() + "'";

    //            posList = -1;
    //            lenList = -1;
    //        }
    //    }

    //    if (posList >= 0)
    //        lenList = pos1 - posList;

    //    if (lenList >= 0)
    //    {
    //        if (string.IsNullOrEmpty(result))
    //            result = "'" + List.Substring(posList, lenList).Trim() + "'";
    //        else
    //            result += "," + List.Substring(posList, lenList).Trim() + "'";
    //    }

    //    return result;
    //}
    #endregion

    #region XLS Param File Import
    //private string GetXLSSheet(string XLSFile)
    //{
    //    String strExcelConn = "Provider=Microsoft.Jet.OLEDB.4.0;"
    //                        + "Data Source=" + XLSFile + ";"
    //                        + "Extended Properties='Excel 8.0;HDR=No;IMEX=1'";

    //    OleDbConnection cnx = new OleDbConnection(strExcelConn);
    //    OleDbCommand cmd = new OleDbCommand();
    //    cmd.Connection = cnx;
    //    cnx.Open();
    //    DataTable dt;
    //    dt = cnx.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
    //    cnx.Close();
    //    return dt.Rows[0]["TABLE_NAME"].ToString();
    //}

    protected void XLStoTable(string XLSFile, string tableName)
    {
        DataTable dt;
        DataSet ds;

        String strExcelConn = "Provider=Microsoft.Jet.OLEDB.4.0;"
                    + "Data Source=" + XLSFile + ";"
                    + "Extended Properties='Excel 8.0;HDR=No;IMEX=1'";

        OleDbConnection cnx = new OleDbConnection(strExcelConn);
        OleDbCommand cmd = new OleDbCommand();

        //Open the spreadsheet
        cmd.Connection = cnx;
        cnx.Open();
        dt = cnx.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
        cnx.Close();

        //Get the SheetName and load the DataTable
        OleDbDataAdapter da = new OleDbDataAdapter();
        string SheetName = dt.Rows[0]["TABLE_NAME"].ToString();
        cmd.CommandText = "SELECT * From [" + SheetName + "]";
        da.SelectCommand = cmd;
        da.Fill(newDT);

        //Create the temp table in SQL
        SqlHelper.ExecuteDataset(cnReports, "pCustActivityGetList",
                                        new SqlParameter("@Action", "CREATE"),
                                        new SqlParameter("@Period", ""),
                                        new SqlParameter("@CustShipLocation", ""),
                                        new SqlParameter("@ChainCd", ""),
                                        new SqlParameter("@ChainList", ""),
                                        new SqlParameter("@CustNo", ""),
                                        new SqlParameter("@CustList", ""),
                                        new SqlParameter("@FilterCd", ""),
                                        new SqlParameter("@SalesTerritory", ""),
                                        new SqlParameter("@OutsideRep", ""),
                                        new SqlParameter("@InsideRep", ""),
                                        new SqlParameter("@RegionalMgr", ""),
                                        new SqlParameter("@BuyGroup", ""),
                                        new SqlParameter("@ParamTbl", tableName));

        //Use SqlBulkCopy to copy the data from the spreadsheet to the temp table
        cnReports.Open();
        SqlBulkCopy sqlBC = new SqlBulkCopy(cnReports);
        try
        {
            sqlBC.DestinationTableName = tableName;
            sqlBC.WriteToServer(newDT);
            sqlBC.Close();
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            sqlBC.Close();
        }

        cnReports.Close();
    }
    #endregion

    private void EnablePrompt1()
    {
        chkBrSumm.Enabled = true;
        ddlChain.Enabled = true;
        chkChainXLS.Enabled = true;
        chkListChain.Enabled = true;
        txtCustNo.Enabled = true;
        chkCustXLS.Enabled = true;
        chkListCust.Enabled = true;
    }

    private void EnablePrompt2()
    {
        ddlTerritory.Enabled = true;
        ddlOutsideRep.Enabled = true;
        ddlInsideRep.Enabled = true;
        ddlRegionalMgr.Enabled = true;
        ddlBuyGroup.Enabled = true;
        ddlRptGroup.Enabled = true;
        pnlRptGroup.Update();
    }

    private void DisablePrompt1()
    {
        chkBrSumm.Enabled = false;
        ddlChain.Enabled = false;
        chkChainXLS.Enabled = false;
        chkListChain.Enabled = false;
        txtCustNo.Enabled = false;
        chkCustXLS.Enabled = false;
        chkListCust.Enabled = false;
    }

    private void DisablePrompt2()
    {
        ddlTerritory.SelectedIndex = 0;
        ddlOutsideRep.SelectedIndex = 0;
        ddlInsideRep.SelectedIndex = 0;
        ddlRegionalMgr.SelectedIndex = 0;
        ddlBuyGroup.SelectedIndex = 0;
        ddlRptGroup.SelectedIndex = 0;
        ddlTerritory.Enabled = false;
        ddlOutsideRep.Enabled = false;
        ddlInsideRep.Enabled = false;
        ddlRegionalMgr.Enabled = false;
        ddlBuyGroup.Enabled = false;
        ddlRptGroup.Enabled = false;
    }

    private void RefreshUserPromptPanels()
    {
        pnlPeriod.Update();
        pnlBranch.Update();
        pnlBrSumm.Update();
        pnlChain.Update();
        pnlChainXLS.Update();
        pnlListChain.Update();
        pnlCustNo.Update();
        pnlCustXLS.Update();
        pnlListCust.Update();
        pnlTerritory.Update();
        pnlOutsideRep.Update();
        pnlInsideRep.Update();
        pnlRegionalMgr.Update();
        pnlBuyGroup.Update();
        pnlRptGroup.Update();
        pnlCustRpt.Update();
        pnlEmpRpt.Update();
        //pnlBuyGrpRpt.Update();
        //pnlCatRpt.Update();
        pnlCount.Update();
        pnlResults.Update();
        pnlPrinter.Update();
        pnlStatus.Update();
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

    //
    //Determine user security for this page
    //For CAS: MAINTENANCE (W)
    //
    private void GetSecurity()
    {
        hidSecurity.Value = MaintUtil.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.CustomerActivity);
        if (hidSecurity.Value.ToString() == "")
            hidSecurity.Value = "Query";
        else
            hidSecurity.Value = "Full";

        //
        //If the page does not allow 'Query' only, change to 'None'
        //
        if (hidSecurity.Value.ToString() == "Query")
            hidSecurity.Value = "None";


        //Hard code the security value(s) until specific security is implemented
        //Toggle between Query, Full and None
        //hidSecurity.Value = "Query";
        //hidSecurity.Value = "Full"; //
        //hidSecurity.Value = "None";


        switch (hidSecurity.Value.ToString())
        {
            case "None":
                Response.Redirect("~/Common/ErrorPage/unauthorizedpage.aspx", true);
                break;
            case "Full":
                break;
        }
    }

    [Ajax.AjaxMethod()]
    public string Close()
    {
        Session["dsActivity"] = null;
        return "";
    }
}