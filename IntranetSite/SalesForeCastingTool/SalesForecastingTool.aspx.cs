using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Text;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Threading;
using System.IO;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
using PFC.Intranet.Utility;

public partial class SalesForeCasting : System.Web.UI.Page
{
    SalesForecastingTool salesSorecastingTool = new SalesForecastingTool();
    private DataSet dsBranchSummary = new DataSet();
    private string branchID = "";
    private string sortExpression = string.Empty;
    private string customerNumber = string.Empty;
    private string orderType = string.Empty;
    private string strColumnVaues;
    private string strWhereClause;
    private string sAddPerc;

    #region page events

    protected void Page_Load(object sender, EventArgs e)
    {
        Session["SFTQ1Actualtotal"] = "test";

        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();

        // Register AJAX
        Ajax.Utility.RegisterTypeForAjax(typeof(SalesForeCasting));

        hidFocus.Value = "";
        branchID = Request.QueryString["Branch"].ToString();
        orderType = Request.QueryString["OrderType"].ToString();
        customerNumber = Request.QueryString["CustNumber"].ToString();

        // Session values created to use in Ajax method
        Session["SFTBranchID"] = Request.QueryString["Branch"].ToString();
        Session["SFTOrderType"] = Request.QueryString["OrderType"].ToString();
        Session["SFTCustNo"] = Request.QueryString["CustNumber"].ToString();
        
        if (orderType.Trim() == "w")
        {
            Footer1.Title = "Sales Forecasting Tool : Warehouse Sales";
        }
        else
        {
            Footer1.Title = "Sales Forecasting Tool : Mill Sales";
        }

        lblMessage.Text = "";

        if (!Page.IsPostBack)
        {
            FillCASHeader();
            BindDataGrid();
        }
    }

    protected void dgBranchSummary_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgBranchSummary.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
        pnldgrid.Update();
    }

    protected void btnSort_Click(object sender, EventArgs e)
    {
        if (hidSort.Attributes["sortType"] != null)
        {
            if (hidSort.Attributes["sortType"].ToString() == "ASC")
                hidSort.Attributes["sortType"] = "DESC";
            else
                hidSort.Attributes["sortType"] = "ASC";
        }
        else
            hidSort.Attributes.Add("sortType", "ASC");

        hidSort.Value = hidSortExpression.Value + " " + hidSort.Attributes["sortType"].ToString();
        BindDataGrid();
        pnldgrid.Update();
    }

    #endregion

    #region Developer Methods

    public void FillCASHeader()
    {
        try
        {
            DataTable dtCasHeader;
            //
            // If customer number is "OTHERS", don't display CAS header
            //
            if (!customerNumber.ToUpper().Contains("OTHER"))
            {
                dtCasHeader = salesSorecastingTool.GetCustomerRecord(customerNumber);

                // Bind the datagrid with datatable
                dgCas.DataSource = dtCasHeader;
                dgCas.DataBind();

                if (dgCas.Items.Count > 0)
                {
                    // Display Header text
                    lblHeaderBranch.Text = dtCasHeader.Rows[0]["CustName"].ToString();
                }
            }
            else
            {
                // Display Header text
                lblHeaderBranch.Text = customerNumber;
            }
        }
        catch (Exception ex) { Response.Write(ex.ToString()); }
    }

    private void BindDataGrid()
    {
        sortExpression = ((hidSort.Value != "") ? " ORDER BY  " + hidSort.Value : " ORDER BY AnnualActualLbs DESC,CatGrpDesc ASC");
        Session["sortExpression"] = sortExpression;

        dsBranchSummary = salesSorecastingTool.GetBranchPoundsDetail(branchID, orderType, customerNumber, sortExpression);
        //
        DataTable dtTotal = new DataTable();
        dtTotal = dsBranchSummary.Tables[0].DefaultView.ToTable();

        decimal _q1AcutalLbs = Convert.ToDecimal(dtTotal.Compute("Sum(Q1ActualLbs)", ""));
        decimal _q2AcutalLbs = Convert.ToDecimal(dtTotal.Compute("Sum(Q2ActualLbs)", ""));
        decimal _q3AcutalLbs = Convert.ToDecimal(dtTotal.Compute("Sum(Q3ActualLbs)", ""));
        decimal _q4AcutalLbs = Convert.ToDecimal(dtTotal.Compute("Sum(Q4ActualLbs)", ""));

        decimal _q1ForecastLbs = Convert.ToDecimal(dtTotal.Compute("Sum(Q1ForecastLbs)", ""));
        decimal _q2ForecastLbs = Convert.ToDecimal(dtTotal.Compute("Sum(Q2ForecastLbs)", ""));
        decimal _q3ForecastLbs = Convert.ToDecimal(dtTotal.Compute("Sum(Q3ForecastLbs)", ""));
        decimal _q4ForecastLbs = Convert.ToDecimal(dtTotal.Compute("Sum(Q4ForecastLbs)", ""));

        lblQ1ActualTotal.Text = String.Format("{0:#,##0}", _q1AcutalLbs).ToString();
        lblQ2ActualTotal.Text = String.Format("{0:#,##0}", _q2AcutalLbs).ToString();
        lblQ3ActualTotal.Text = String.Format("{0:#,##0}", _q3AcutalLbs).ToString();
        lblQ4ActualTotal.Text = String.Format("{0:#,##0}", _q4AcutalLbs).ToString();

        Q1ForecastTotal.Text = String.Format("{0:#,##0}", _q1ForecastLbs).ToString();
        Q2ForecastTotal.Text = String.Format("{0:#,##0}", _q2ForecastLbs).ToString();
        Q3ForecastTotal.Text = String.Format("{0:#,##0}", _q3ForecastLbs).ToString();
        Q4ForecastTotal.Text = String.Format("{0:#,##0}", _q4ForecastLbs).ToString();

        decimal ActualTotal = Convert.ToDecimal(lblQ1ActualTotal.Text) + Convert.ToDecimal(lblQ2ActualTotal.Text) + Convert.ToDecimal(lblQ3ActualTotal.Text) + Convert.ToDecimal(lblQ4ActualTotal.Text);
        lblAnnualActualTotal.Text = String.Format("{0:#,##0}", ActualTotal);
        decimal ActualForecast = Convert.ToDecimal((Q1ForecastTotal.Text == "" ? "0" : Q1ForecastTotal.Text)) + Convert.ToDecimal((Q2ForecastTotal.Text == "" ? "0" : Q2ForecastTotal.Text)) + Convert.ToDecimal((Q3ForecastTotal.Text == "" ? "0" : Q3ForecastTotal.Text)) + Convert.ToDecimal((Q4ForecastTotal.Text == "" ? "0" : Q4ForecastTotal.Text));
        AnnualForecastTotal.Text = String.Format("{0:#,##0}", ActualForecast); ;

        //
        // Display Add % column
        //
        if (String.Format("{0:#,##0.0}", _q1AcutalLbs).ToString() != "0.0")
            Q1AddTotal.Text = String.Format("{0:###0.0}", ((_q1ForecastLbs - _q1AcutalLbs) / (_q1AcutalLbs)) * 100).ToString();

        if (String.Format("{0:#,##0.0}", _q2AcutalLbs).ToString() != "0.0")
            Q2AddTotal.Text = String.Format("{0:###0.0}", ((_q2ForecastLbs - _q2AcutalLbs) / (_q2AcutalLbs)) * 100).ToString();

        if (String.Format("{0:#,##0.0}", _q3AcutalLbs).ToString() != "0.0")
            Q3AddTotal.Text = String.Format("{0:###0.0}", ((_q3ForecastLbs - _q3AcutalLbs) / (_q3AcutalLbs)) * 100).ToString();

        if (String.Format("{0:#,##0.0}", _q4AcutalLbs).ToString() != "0.0")
            Q4AddTotal.Text = String.Format("{0:###0.0}", ((_q4ForecastLbs - _q4AcutalLbs) / (_q4AcutalLbs)) * 100).ToString();

        if (String.Format("{0:#,##0.0}", ActualTotal).ToString() != "0.0")
        {
            AddAnnualTotal.Text = String.Format("{0:###0.0}", ((ActualForecast - ActualTotal) / (ActualTotal)) * 100).ToString();
            hidAnnuTot.Value = String.Format("{0:###0.0}", ((ActualForecast - ActualTotal) / (ActualTotal)) * 100).ToString();
            lblDiffTotal.Text = String.Format("{0:0.0}", ((ActualForecast - ActualTotal) / ActualTotal) * 100);
        }
        else
        {
            lblDiffTotal.Text = "0.0";
        }

        

        // Annual forecast will be 0 for new custoemr, if zero replace with empty string
        AnnualForecastTotal.Text = (AnnualForecastTotal.Text == "0" ? "0" : AnnualForecastTotal.Text);

        dgBranchSummary.DataSource = dsBranchSummary.Tables[0];
        dgBranchSummary.DataBind();
        pnldgrid.Update();
        if (dgCas.Items.Count <= 0)
            divdatagrid.Style.Add(HtmlTextWriterStyle.Height, "490px");
        if (Page.IsPostBack)
            PostBackScripts();
    }

    #endregion

    protected void AddAnnualTotal_TextChanged(object sender, EventArgs e)
    {
        
    }

    protected void btnAnnPctChg_Click(object sender, EventArgs e)
    {
        string annTotal = "";
        if (hidHeaderTotPct.Value.Trim() == "")
        {
            annTotal = "0";
        }
        else
        {
            annTotal = hidHeaderTotPct.Value;
        }
        annTotal = (Convert.ToDouble(annTotal) / 100).ToString();

        //Event action will occur when even you entered the values in the textBox Annual header in the Total Row 
        strColumnVaues = "Q1ForecastLbs=(Q1ActualLbs * " + annTotal + ") + Q1ActualLbs , Q2ForecastLbs=(Q2ActualLbs * " + annTotal + ") + Q2ActualLbs , Q3ForecastLbs=(Q3ActualLbs *" + annTotal + ") + Q3ActualLbs ,Q4ForecastLbs=(Q4ActualLbs *" + annTotal + ") + Q4ActualLbs ";
        strWhereClause = "1=1";
        salesSorecastingTool.UpdateCustomerSalesForecastData(strColumnVaues, branchID, orderType, customerNumber, strWhereClause);
        hidFocus.Value = AddAnnualTotal.ClientID;
        BindDataGrid();
    }

    protected void Q4AddTotal_TextChanged(object sender, EventArgs e)
    {
        if (hidHeaderTotPct.Value.Trim() == "")
        {
            sAddPerc = "0";
        }
        else
        {
            sAddPerc = hidHeaderTotPct.Value.Trim();
        }

        sAddPerc = (Convert.ToDouble(sAddPerc) / 100).ToString();
        strColumnVaues = "Q4ForecastLbs=(Q4ActualLbs * " + sAddPerc + ") + Q4ActualLbs ";
        strWhereClause = "1=1";

        salesSorecastingTool.UpdateCustomerSalesForecastData(strColumnVaues, branchID, orderType, customerNumber, strWhereClause);
        hidFocus.Value = Q4AddTotal.ClientID.Replace("Q4AddTotal", "AddAnnualTotal");
        BindDataGrid();
    }

    protected void Q3AddTotal_TextChanged(object sender, EventArgs e)
    {
        if (hidHeaderTotPct.Value.Trim() == "")
        {
            sAddPerc = "0";
        }
        else
        {
            sAddPerc = hidHeaderTotPct.Value.Trim();
        }

        sAddPerc = (Convert.ToDouble(sAddPerc) / 100).ToString();
        strColumnVaues = "Q3ForecastLbs=(Q3ActualLbs * " + sAddPerc + ") + Q3ActualLbs ";
        strWhereClause = "1=1";
        salesSorecastingTool.UpdateCustomerSalesForecastData(strColumnVaues, branchID, orderType, customerNumber, strWhereClause);
        hidFocus.Value = Q3AddTotal.ClientID.Replace("Q3AddTotal", "Q4AddTotal");
        BindDataGrid();
    }

    protected void Q2AddTotal_TextChanged(object sender, EventArgs e)
    {
        if (hidHeaderTotPct.Value.Trim() == "")
        {
            sAddPerc = "0";
        }
        else
        {
            sAddPerc = hidHeaderTotPct.Value.Trim();
        }

        sAddPerc = (Convert.ToDouble(sAddPerc) / 100).ToString();
        strColumnVaues = "Q2ForecastLbs=(Q2ActualLbs * " + sAddPerc + ") + Q2ActualLbs ";
        strWhereClause = "1=1";

        salesSorecastingTool.UpdateCustomerSalesForecastData(strColumnVaues, branchID, orderType, customerNumber, strWhereClause);
        hidFocus.Value = Q2AddTotal.ClientID.Replace("Q2AddTotal", "Q3AddTotal");
        BindDataGrid();
    }

    protected void Q1AddTotal_TextChanged(object sender, EventArgs e)
    {
        if (hidHeaderTotPct.Value.Trim() == "")
        {
            sAddPerc = "0";
        }
        else
        {
            sAddPerc = hidHeaderTotPct.Value.Trim();
        }

        sAddPerc = (Convert.ToDouble(sAddPerc) / 100).ToString();
        strColumnVaues = "Q1ForecastLbs=(Q1ActualLbs * " + sAddPerc + ") + Q1ActualLbs ";
        strWhereClause = "1=1";

        salesSorecastingTool.UpdateCustomerSalesForecastData(strColumnVaues, branchID, orderType, customerNumber, strWhereClause);
        hidFocus.Value = Q1AddTotal.ClientID.Replace("Q1AddTotal", "Q2AddTotal");
        BindDataGrid();
    }
    
    public void fillQuarterlyData(string txtQPerc, string txtForecast, object sender)
    {
        TextBox txtPercQ1 = sender as TextBox;
        string strAnnPerc = txtPercQ1.ClientID;
        string[] strCtlName = strAnnPerc.Split('_');
        int ctlNo = Convert.ToInt32(strCtlName[1].Substring(3));

        TextBox txtQ1Perc = dgBranchSummary.Items[ctlNo - 2].FindControl(txtQPerc) as TextBox;
        TextBox txtQ1Forecast = dgBranchSummary.Items[ctlNo - 2].FindControl(txtForecast) as TextBox;

        txtQ1Perc.Text = txtPercQ1.Text.ToString();

        decimal dQ1 = Convert.ToDecimal(dgBranchSummary.Items[ctlNo - 2].Cells[2].Text.Trim());
        dQ1 = dQ1 * (Convert.ToDecimal(txtQ1Perc.Text) / 100) + dQ1;
        txtQ1Forecast.Text = dQ1.ToString();
        BindDataGrid();
    }

    private void PostBackScripts()
    {
        string script = "if(document.getElementById('divdatagrid')) {document.getElementById('divdatagrid').scrollTop='" + hidScrollTop.Value + "';}" +
                        "if(document.getElementById('" + hidFocus.Value + "')!='undefined' && document.getElementById('" + hidFocus.Value + "')!=null){document.getElementById('" + hidFocus.Value + "').focus(); document.getElementById('" + hidFocus.Value + "').select();}window.opener.location.reload();";
        //"if(document.getElementById('" + hidFocus.Value + "')){document.getElementById('" + hidFocus.Value + "').focus(); document.getElementById('" + hidFocus.Value + "').select();}window.opener.location.reload();";

        ScriptManager.RegisterClientScriptBlock(dgBranchSummary, typeof(DataGrid), "script", script, true);



    }

    #region Ajax Methods

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.Read)]
    public ArrayList UpdateQuoter1Values(string categoryNo,string addPct,string qtr)
    {
        try
        {
            salesSorecastingTool = new SalesForecastingTool();
            if (addPct.Trim() == "")
                sAddPerc = "0";
            else
                sAddPerc = addPct.ToString();

            sAddPerc = (Convert.ToDouble(sAddPerc) / 100).ToString();

            strColumnVaues = qtr+"ForecastLbs=("+qtr+"ActualLbs * " + sAddPerc + ") + "+qtr+"ActualLbs";
            strWhereClause = "CatGrpNo='" + categoryNo + "'";

            salesSorecastingTool.UpdateCustomerSalesForecastData(strColumnVaues, Session["SFTBranchID"].ToString(), Session["SFTOrderType"].ToString(), Session["SFTCustNo"].ToString(), strWhereClause);

            ArrayList arr = GetSalesForecastMasterData(categoryNo,qtr);

            return arr;
        }
        catch (Exception ex)
        {
            
            throw ex;
        }
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.Read)]
    public ArrayList UpdateQuoterForecastValues(string categoryNo, string forecastLbs, string qtr)
    {
        try
        {
            strColumnVaues = qtr + "ForecastLbs=" + (forecastLbs.Trim() == "" ? "0" : forecastLbs.Replace(",", ""));
            strWhereClause = "CatGrpNo='" + categoryNo + "'";
            salesSorecastingTool.UpdateCustomerSalesForecastData(strColumnVaues, Session["SFTBranchID"].ToString(), Session["SFTOrderType"].ToString(), Session["SFTCustNo"].ToString(), strWhereClause);

            ArrayList arr = GetSalesForecastMasterData(categoryNo, qtr);

            return arr;
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public ArrayList GetSalesForecastMasterData(string categoryNumber,string qtr)
    {
        DataSet _dsSalesData = new DataSet();
        _dsSalesData = salesSorecastingTool.GetBranchPoundsDetail(Session["SFTBranchID"].ToString(), Session["SFTOrderType"].ToString(), Session["SFTCustNo"].ToString(), Session["sortExpression"].ToString());
       
        DataTable dtTotal = new DataTable();
        dtTotal = _dsSalesData.Tables[0].DefaultView.ToTable();

        ArrayList arrHeader = new ArrayList();

        #region Calculate Header Annual values
        decimal _q1AcutalLbs = Convert.ToDecimal(dtTotal.Compute("Sum(Q1ActualLbs)", ""));
        decimal _q2AcutalLbs = Convert.ToDecimal(dtTotal.Compute("Sum(Q2ActualLbs)", ""));
        decimal _q3AcutalLbs = Convert.ToDecimal(dtTotal.Compute("Sum(Q3ActualLbs)", ""));
        decimal _q4AcutalLbs = Convert.ToDecimal(dtTotal.Compute("Sum(Q4ActualLbs)", ""));
        
        decimal _q1ForecastLbs = Convert.ToDecimal(dtTotal.Compute("Sum(Q1ForecastLbs)", ""));
        decimal _q2ForecastLbs = Convert.ToDecimal(dtTotal.Compute("Sum(Q2ForecastLbs)", ""));
        decimal _q3ForecastLbs = Convert.ToDecimal(dtTotal.Compute("Sum(Q3ForecastLbs)", ""));
        decimal _q4ForecastLbs = Convert.ToDecimal(dtTotal.Compute("Sum(Q4ForecastLbs)", ""));

        string _sQ1ActualTotal  = String.Format("{0:#,##0}", _q1AcutalLbs).ToString();
        string _sQ2ActualTotal  = String.Format("{0:#,##0}", _q2AcutalLbs).ToString();
        string _sQ3ActualTotal = String.Format("{0:#,##0}", _q3AcutalLbs).ToString();
        string _sQ4ActualTotal = String.Format("{0:#,##0}", _q4AcutalLbs).ToString();
        string _sAnnualAcutalTotal = "";

        string _sq1ForecastLbs = String.Format("{0:#,##0}", _q1ForecastLbs).ToString();
        string _sq2ForecastLbs = String.Format("{0:#,##0}", _q2ForecastLbs).ToString();
        string _sq3ForecastLbs = String.Format("{0:#,##0}", _q3ForecastLbs).ToString();
        string _sq4ForecastLbs = String.Format("{0:#,##0}", _q4ForecastLbs).ToString();
        string _sAnnualForecastTotal = "";

        string _sQ1AddTotal = "";
        string _sQ2AddTotal = "" ;
        string _sQ3AddTotal = ""; 
        string _sQ4AddTotal = "";
        string _sAnnualAddTotal ="";
        string _sPctDiffTotal = "";

        arrHeader.Add(_sq1ForecastLbs);
        arrHeader.Add(_sq2ForecastLbs);
        arrHeader.Add(_sq3ForecastLbs);
        arrHeader.Add(_sq4ForecastLbs);

        decimal ActualTotal = Convert.ToDecimal(_sQ1ActualTotal) + Convert.ToDecimal(_sQ2ActualTotal) + Convert.ToDecimal(_sQ3ActualTotal) + Convert.ToDecimal(_sQ4ActualTotal);
        _sAnnualAcutalTotal = String.Format("{0:#,##0}", ActualTotal);
        decimal ActualForecast = Convert.ToDecimal((_sq1ForecastLbs == "" ? "0" : _sq1ForecastLbs)) + Convert.ToDecimal((_sq2ForecastLbs == "" ? "0" : _sq2ForecastLbs)) + Convert.ToDecimal((_sq3ForecastLbs == "" ? "0" : _sq3ForecastLbs)) + Convert.ToDecimal((_sq4ForecastLbs == "" ? "0" : _sq4ForecastLbs));
        _sAnnualForecastTotal = String.Format("{0:#,##0}", ActualForecast); ;

        // Add Annual Forcast lbs
        arrHeader.Add(_sAnnualForecastTotal);

        ////
        //// Display Add % column
        ////
        if (String.Format("{0:#,##0.0}", _q1AcutalLbs).ToString() != "0.0")
            _sQ1AddTotal = String.Format("{0:###0.0}", ((_q1ForecastLbs - _q1AcutalLbs) / (_q1AcutalLbs)) * 100).ToString();

        if (String.Format("{0:#,##0.0}", _q2AcutalLbs).ToString() != "0.0")
            _sQ2AddTotal = String.Format("{0:#,##0.0}", ((_q2ForecastLbs - _q2AcutalLbs) / (_q2AcutalLbs)) * 100).ToString();

        if (String.Format("{0:#,##0.0}", _q3AcutalLbs).ToString() != "0.0")
            _sQ3AddTotal = String.Format("{0:###0.0}", ((_q3ForecastLbs - _q3AcutalLbs) / (_q3AcutalLbs)) * 100).ToString();

        if (String.Format("{0:#,##0.0}", _q4AcutalLbs).ToString() != "0.0")
            _sQ4AddTotal = String.Format("{0:###0.0}", ((_q4ForecastLbs - _q4AcutalLbs) / (_q4AcutalLbs)) * 100).ToString();

        if (String.Format("{0:#,##0.0}", ActualTotal).ToString() != "0.0")
            _sAnnualAddTotal = String.Format("{0:###0.0}", ((ActualForecast - ActualTotal) / (ActualTotal)) * 100).ToString();

        _sPctDiffTotal = String.Format("{0:0.0}", ((ActualForecast - ActualTotal) / ActualTotal) * 100);

        arrHeader.Add(_sQ1AddTotal);
        arrHeader.Add(_sQ2AddTotal);
        arrHeader.Add(_sQ3AddTotal);
        arrHeader.Add(_sQ4AddTotal);
        arrHeader.Add(_sAnnualAddTotal);

        arrHeader.Add(_sPctDiffTotal);
        #endregion

        //
        // Fetch new datarow form master table for that paricular row which was modified by the user
        //
        DataRow[] drModifedRow = dtTotal.Select("CatGrpNo='" + categoryNumber + "'");

        arrHeader.Add(String.Format("{0:#,##0}", Convert.ToDecimal(drModifedRow[0][qtr+"ForecastLbs"].ToString())));       
        arrHeader.Add(String.Format("{0:###0.0}",Convert.ToDecimal(drModifedRow[0]["AnnualAddedPct"].ToString())));         
        arrHeader.Add(String.Format("{0:#,##0}",Convert.ToDecimal(drModifedRow[0]["AnnualForecastLbs"].ToString())));
        arrHeader.Add(String.Format("{0:###0.0}",Convert.ToDecimal(drModifedRow[0]["PctDiff"].ToString())));

        arrHeader.Add(String.Format("{0:###0.0}", Convert.ToDecimal(drModifedRow[0][qtr + "AddedPct"].ToString())));
        return arrHeader;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.Read)]
    public ArrayList UpdateAnnualQuoterValues(string addPct, string qtr)
    {
        try
        {
            salesSorecastingTool = new SalesForecastingTool();
            if (addPct.Trim() == "")
                sAddPerc = "0";
            else
                sAddPerc = addPct.ToString();

            sAddPerc = (Convert.ToDouble(sAddPerc) / 100).ToString();

            strColumnVaues = qtr + "ForecastLbs=(" + qtr + "ActualLbs * " + sAddPerc + ") + " + qtr + "ActualLbs";
            strWhereClause = "1=1";

            salesSorecastingTool.UpdateCustomerSalesForecastData(strColumnVaues, Session["SFTBranchID"].ToString(), Session["SFTOrderType"].ToString(), Session["SFTCustNo"].ToString(), strWhereClause);

            DataSet _dsSalesData = new DataSet();
            _dsSalesData = salesSorecastingTool.GetBranchPoundsDetail(Session["SFTBranchID"].ToString(), Session["SFTOrderType"].ToString(), Session["SFTCustNo"].ToString(), Session["sortExpression"].ToString());

            DataTable dtTotal = new DataTable();
            dtTotal = _dsSalesData.Tables[0].DefaultView.ToTable();
            
            ArrayList arr = new ArrayList();
            arr.Add(dtTotal);

            return arr;
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }

    #endregion

    protected void dgBranchSummary_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            TextBox _txtAnnualPct = e.Item.FindControl("txtAnnPerc") as TextBox;
            TextBox _txtQ1AddedPct = e.Item.FindControl("txtQ1Perc") as TextBox;
            TextBox _txtQ2AddedPct = e.Item.FindControl("txtQ2Perc") as TextBox;
            TextBox _txtQ3AddedPct = e.Item.FindControl("txtQ3Perc") as TextBox;
            TextBox _txtQ4AddedPct = e.Item.FindControl("txtQ4Perc") as TextBox;
            TextBox _txtQ1Forecast = e.Item.FindControl("txtQ1Forecast") as TextBox;
            TextBox _txtQ2Forecast = e.Item.FindControl("txtQ2Forecast") as TextBox;
            TextBox _txtQ3Forecast = e.Item.FindControl("txtQ3Forecast") as TextBox;
            TextBox _txtQ4Forecast = e.Item.FindControl("txtQ4Forecast") as TextBox;

            _txtAnnualPct.Attributes.Add("originalText", _txtAnnualPct.Text);
            _txtQ1AddedPct.Attributes.Add("originalText", _txtQ1AddedPct.Text);
            _txtQ2AddedPct.Attributes.Add("originalText", _txtQ2AddedPct.Text);
            _txtQ3AddedPct.Attributes.Add("originalText", _txtQ3AddedPct.Text);
            _txtQ4AddedPct.Attributes.Add("originalText", _txtQ4AddedPct.Text);
            _txtQ1Forecast.Attributes.Add("originalText", _txtQ1Forecast.Text);
            _txtQ2Forecast.Attributes.Add("originalText", _txtQ2Forecast.Text);
            _txtQ3Forecast.Attributes.Add("originalText", _txtQ3Forecast.Text);
            _txtQ4Forecast.Attributes.Add("originalText", _txtQ4Forecast.Text);
        }
    }

    
}