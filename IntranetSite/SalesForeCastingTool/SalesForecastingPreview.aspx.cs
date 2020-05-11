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

public partial class SalesForeCastingTool_SalesForecastingTool : System.Web.UI.Page
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
    private string sCategoryGroupNo;



    private string lblQ1ActualTotal = "";
    private string lblQ2ActualTotal = "";
    private string lblQ3ActualTotal = "";
    private string lblQ4ActualTotal = "";
    private string lblAnnualActualTotal = "";
    private decimal AddAnnualTotal = 0;

    private string Q1ForecastTotal = "";
    private string Q2ForecastTotal = "";
    private string Q3ForecastTotal = "";
    private string Q4ForecastTotal = "";

    private Decimal Q1AddTotal = 0;
    private Decimal Q2AddTotal = 0;
    private Decimal Q3AddTotal = 0;
    private Decimal Q4AddTotal = 0;

    private string lblDiffTotal = "";
    private string AnnualForecastTotal = "";

    #region page events



    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        //Comment should be removed
        systemCheck.SessionCheck();

        branchID = Request.QueryString["Branch"].ToString();
        orderType = Request.QueryString["OrderType"].ToString();
        customerNumber = Request.QueryString["CustNumber"].ToString();

        //customerNumber = "BAYF-2";
        //branchID = "02";
        //orderType = "w";

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


    private void BindDataGrid()
    {
        sortExpression = ((hidSort.Value != "") ? " ORDER BY  " + hidSort.Value : "  ORDER BY AnnualActualLbs DESC,CatGrpDesc ASC");
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

        lblQ1ActualTotal = String.Format("{0:#,##0}", _q1AcutalLbs).ToString();
        lblQ2ActualTotal = String.Format("{0:#,##0}", _q2AcutalLbs).ToString();
        lblQ3ActualTotal = String.Format("{0:#,##0}", _q3AcutalLbs).ToString();
        lblQ4ActualTotal = String.Format("{0:#,##0}", _q4AcutalLbs).ToString();

        Q1ForecastTotal = String.Format("{0:#,##0}", _q1ForecastLbs).ToString();
        Q2ForecastTotal = String.Format("{0:#,##0}", _q2ForecastLbs).ToString();
        Q3ForecastTotal = String.Format("{0:#,##0}", _q3ForecastLbs).ToString();
        Q4ForecastTotal = String.Format("{0:#,##0}", _q4ForecastLbs).ToString();


        decimal ActualTotal = Convert.ToDecimal(lblQ1ActualTotal) + Convert.ToDecimal(lblQ2ActualTotal) + Convert.ToDecimal(lblQ3ActualTotal) + Convert.ToDecimal(lblQ4ActualTotal);
        lblAnnualActualTotal = String.Format("{0:#,##0}", ActualTotal);
        decimal ActualForecast = Convert.ToDecimal((Q1ForecastTotal == "" ? "0" : Q1ForecastTotal)) + Convert.ToDecimal((Q2ForecastTotal == "" ? "0" : Q2ForecastTotal)) + Convert.ToDecimal((Q3ForecastTotal == "" ? "0" : Q3ForecastTotal)) + Convert.ToDecimal((Q4ForecastTotal == "" ? "0" : Q4ForecastTotal));
        AnnualForecastTotal = String.Format("{0:#,##0}", ActualForecast); ;


        //
        // Display Add % column
        //
        if (String.Format("{0:#,##0.0}", _q1AcutalLbs).ToString() != "0.0")
            Q1AddTotal = ((_q1ForecastLbs - _q1AcutalLbs) / (_q1AcutalLbs)) * 100;

        if (String.Format("{0:#,##0.0}", _q2AcutalLbs).ToString() != "0.0")
            Q2AddTotal =((_q2ForecastLbs - _q2AcutalLbs) / (_q2AcutalLbs)) * 100;

        if (String.Format("{0:#,##0.0}", _q3AcutalLbs).ToString() != "0.0")
            Q3AddTotal = ((_q3ForecastLbs - _q3AcutalLbs) / (_q3AcutalLbs)) * 100;

        if (String.Format("{0:#,##0.0}", _q4AcutalLbs).ToString() != "0.0")
            Q4AddTotal =  ((_q4ForecastLbs - _q4AcutalLbs) / (_q4AcutalLbs)) * 100;

        if (String.Format("{0:#,##0.0}", ActualTotal).ToString() != "0.0")
        {
            AddAnnualTotal = ((ActualForecast - ActualTotal) / (ActualTotal)) * 100;
            lblDiffTotal = String.Format("{0:0.0}", ((ActualForecast - ActualTotal) / ActualTotal) * 100);
        }

        // Annual forecast will be 0 for new custoemr, if zero replace with empty string
        AnnualForecastTotal = (AnnualForecastTotal == "0" ? "0" : AnnualForecastTotal);

        if (dgCas.Items.Count <= 0)
            divdatagrid.Style.Add(HtmlTextWriterStyle.Height, "510px");

        DataRow dr = dsBranchSummary.Tables[0].NewRow();
        dr["CatGrpDesc"] = "TOTALS";
        dr["Q1ActualLbs"] = _q1AcutalLbs;
        dr["Q1AddedPct"] = Q1AddTotal;
        dr["Q1ForeCastLbs"] = _q1ForecastLbs;
        dr["Q2ActualLbs"] = _q2AcutalLbs;
        dr["Q2AddedPct"] = Q2AddTotal;
        dr["Q2ForeCastLbs"] = _q2ForecastLbs;
        dr["Q3ActualLbs"] = _q3AcutalLbs;
        dr["Q3AddedPct"] = Q3AddTotal;
        dr["Q3ForeCastLbs"] = _q3ForecastLbs;
        dr["Q4ActualLbs"] = _q4AcutalLbs;
        dr["Q4AddedPct"] = Q4AddTotal;
        dr["Q4ForeCastLbs"] = _q4ForecastLbs;
        dr["AnnualActualLbs"] = ActualTotal;
        dr["AnnualAddedPct"] = AddAnnualTotal;
        dr["AnnualForeCastLbs"] = ActualForecast;
        if (String.Format("{0:#,##0.0}", ActualTotal).ToString() != "0.0")
        {
            dr["PctDiff"] = ((ActualForecast - ActualTotal) / ActualTotal) * 100; ;
        }
        else
        {
            dr["PctDiff"] = 0.0;
        }
        dsBranchSummary.Tables[0].Rows.InsertAt(dr, 0);

        dgBranchSummary.DataSource = dsBranchSummary.Tables[0];
        dgBranchSummary.DataBind();
        pnldgrid.Update();
    }

    #endregion



    //protected void dgBranchSummary_ItemDataBound(object sender, DataGridItemEventArgs e)
    //{
    //    if (e.Item.ItemType == ListItemType.Header)
    //    {
    //        e.Item.Cells[0].Visible = false;
    //        e.Item.Cells[1].ColumnSpan = 17;
    //        e.Item.Cells[1].Text = " <table cellpadding=\"0\" border='0' class=\"GreyBorderAll\" bgcolor='#dff3f9' cellspacing=\"0\" > " +
    //        " <tr><td class=\"rightsplit\"  style=\"width:180px\"><table cellspacing=\"0\" border=\"0px\" width=180px cellpadding=\"0\">  " +
    //        " <tr><td height=\"21px\" >&nbsp; </td></tr><tr><td height=\"21px\" >&nbsp; </td></tr><tr valign=\"center\"><td class=\"GridHead\" style=\"width:168px\" height=\"21px\"  bgcolor=\"#ffffff\">TOTALS</td></tr> </table></td>" +

    //        "<td class=\"GridHead rightsplit\"  style=\"width:0px\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td align=\"center\"  colspan=\"3\" class=\"GridHead\">Q1 </td></tr> " +
    //        " <tr><td class=\"GridHead\" width=\"60px\" align=\"Center\">Actual</td><td class=\"GridHead\" width=\"26px\" align=\"Center\">Add<br /> %</td><td class=\"GridHead\" align=\"Center\">Forecast</td></tr><tr ><td class=\"GridHead rightsplit\" bgcolor=\"#ffffff\" align=\"right\"> " + lblQ1ActualTotal.ToString() +
    //        " </td><td bgcolor=\"#ffffff\" class=\"GridHead rightsplit\" align=\"center\"> " + Q1AddTotal +
    //        " </td> <td bgcolor=\"#ffffff\" class=\"GridHead\"  height=\"22px\" width=\"60px\"  align=\"right\"> " + Q1ForecastTotal.ToString() + "</td></tr></table></td>" +

    //        "<td class=\"GridHead rightsplit\"  style=\"width:0px\"><table width=\"100%\"  cellspacing=\"0\" cellpadding=\"0\"> " +
    //        " <tr><td align=\"center\" class=\"GridHead\" colspan=\"3\">Q2</td></tr><tr><td class=\"GridHead\" width=\"60px\"  align=\"Center\">Actual</td> " +
    //        " <td class=\"GridHead\" width=\"26px\"  align=\"Center\">Add<br /> %</td><td class=\"GridHead\" align=\"Center\">Forecast</td></tr><tr><td class=\"GridHead rightsplit\" bgcolor=\"#ffffff\" align=\"right\"> " + lblQ2ActualTotal.ToString() +
    //        " </td><td bgcolor=\"#ffffff\" class=\"GridHead rightsplit\"  align=\"center\">" + Q2AddTotal +
    //        " </td> <td bgcolor=\"#ffffff\" class=\"GridHead\"  height=\"22px\" width=\"60px\"   align=\"right\"> " + Q2ForecastTotal.ToString() + " </td></tr></table> </td>" +

    //        "<td class=\"GridHead rightsplit\"  style=\"width:0px\"><table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\"> " +
    //        " <tr><td align=\"center\" class=\"GridHead\" colspan=\"3\">Q3 </td></tr><tr><td class=\"GridHead\" width=\"60px\" align=\"Center\">Actual</td> " +
    //        " <td class=\"GridHead\" width=\"26px\"align=\"Center\">Add<br /> %</td><td class=\"GridHead\" align=\"Center\">Forecast</td></tr><tr><td class=\"GridHead rightsplit\" bgcolor=\"#ffffff\" align=\"right\"> " + lblQ3ActualTotal.ToString() +
    //        " </td><td bgcolor=\"#ffffff\" class=\"GridHead rightsplit\" align=\"center\">" + Q3AddTotal +
    //        " </td> <td bgcolor=\"#ffffff\" class=\"GridHead\"  height=\"22px\" width=\"60px\" align=\"right\"> " + Q3ForecastTotal.ToString() + " </td></tr></table></td>" +

    //        "<td class=\"GridHead rightsplit\"  style=\"width:0px\"><table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\"><tr> " +
    //        " <td align=\"center\" class=\"GridHead\" colspan=\"3\">Q4 </td></tr><tr><td class=\"GridHead\" width=\"60px\" align=\"Center\">Actual</td> " +
    //        " <td class=\"GridHead\" width=\"26px\"align=\"Center\">Add<br /> %</td><td class=\"GridHead\" align=\"Center\">Forecast</td></tr> <tr><td class=\"GridHead rightsplit\" bgcolor=\"#ffffff\" align=\"right\"> " + lblQ4ActualTotal.ToString() +
    //        " </td><td bgcolor=\"#ffffff\" class=\"GridHead rightsplit\" align=\"center\">" + Q4AddTotal +
    //        " </td> <td bgcolor=\"#ffffff\" class=\"GridHead\"  height=\"22px\" width=\"60px\" align=\"right\"> " + Q4ForecastTotal.ToString() + " </td></tr></table></td>" +

    //        "<td class=\"GridHead rightsplit\"  style=\"width:0px\"><table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\"><tr>" +
    //        "<td align=\"center\" class=\"GridHead\" colspan=\"3\">&nbsp;&nbsp;&nbsp;Annual </td></tr><tr><td class=\"GridHead\" width=\"60px\" align=\"Center\">Actual</td>" +
    //        "<td class=\"GridHead\" width=\"26px\"align=\"Center\">Add<br /> %</td> <td class=\"GridHead\" align=\"Center\">Forecast</td></tr>   <tr><td class=\"GridHead rightsplit\" bgcolor=\"#ffffff\" align=\"right\"> " + lblAnnualActualTotal.ToString() +
    //        " </td><td bgcolor=\"#ffffff\" class=\"GridHead rightsplit\"  height=\"22px\" align=\"center\">" + AddAnnualTotal +
    //        " </td> <td bgcolor=\"#ffffff\" class=\"GridHead\"  height=\"22px\" width=\"60px\" align=\"right\"> " + AnnualForecastTotal.ToString() + " </td></tr></table></td>" +

    //        "<td class=\"GridHead\"><table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\"><tr><td height=\"21px\" >&nbsp; </td></tr><tr><td height=\"21px\"  align=\"center\" style=\"color:#3A3A56;\">% Diff " +
    //        " </td></tr><tr valign=\"bottom\"><td class=\"GridHead\" width =\"49px\" height=\"21px\"  bgcolor=\"#ffffff\" align=right style=\"padding-right:10px\"> " + lblDiffTotal.ToString() +
    //        " </td></tr> </table></td></tr></table> ";


    //        e.Item.Cells[2].Visible = false;
    //        e.Item.Cells[3].Visible = false;
    //        e.Item.Cells[4].Visible = false;
    //        e.Item.Cells[5].Visible = false;
    //        e.Item.Cells[6].Visible = false;
    //        e.Item.Cells[7].Visible = false;
    //        e.Item.Cells[8].Visible = false;
    //        e.Item.Cells[9].Visible = false;
    //        e.Item.Cells[10].Visible = false;
    //        e.Item.Cells[12].Visible = false;
    //        e.Item.Cells[13].Visible = false;
    //        e.Item.Cells[14].Visible = false;
    //        e.Item.Cells[15].Visible = false;
    //        e.Item.Cells[16].Visible = false;
    //        e.Item.Cells[17].Visible = false;
    //        e.Item.Cells[11].Visible = false;

    //    }

    //}
    protected void dgBranchSummary_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            if(e.Item.ItemIndex==0)
            e.Item.Style.Add(HtmlTextWriterStyle.FontWeight, "bold");
        }
        if (e.Item.ItemType == ListItemType.Header)
        {
            e.Item.Cells[0].Visible = false;
            e.Item.Cells[0].Width = Unit.Pixel(0);
            e.Item.Style.Add(HtmlTextWriterStyle.BackgroundColor, "#DFF3F9");
            e.Item.Cells[17].CssClass = "GridHead";

            e.Item.Cells[2].ColumnSpan = 3;
            e.Item.Cells[2].Text = "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr bgcolor='#DFF3F9'><td align=\"center\"  colspan=\"3\" class=\"GridHead \">Q1 </td></tr> " +
                " <tr bgcolor='#DFF3F9'><td class=\"GridHead \" width=\"60px\" align=\"Center\">Actual</td><td class=\"GridHead \" bgcolor='#DFF3F9' width=\"33px\"  align=\"Center\">&nbsp;Add %</td><td class=\"GridHead\" width=\"60px\" bgcolor='#DFF3F9' align=\"Center\">Forecast</td></tr></table>";
            e.Item.Cells[5].ColumnSpan = 3;
            e.Item.Cells[5].Text = "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr bgcolor='#DFF3F9'><td align=\"center\"  colspan=\"3\" class=\"GridHead \">Q2 </td></tr> " +
                " <tr bgcolor='#DFF3F9'><td class=\"GridHead \" width=\"60px\" align=\"Center\">Actual</td><td class=\"GridHead \" bgcolor='#DFF3F9' width=\"33px\"  align=\"Center\">&nbsp;Add %</td><td class=\"GridHead\" width=\"60px\" bgcolor='#DFF3F9' align=\"Center\">Forecast</td></tr></table>";
            e.Item.Cells[8].ColumnSpan = 3;
            e.Item.Cells[8].Text = "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr bgcolor='#DFF3F9'><td align=\"center\"  colspan=\"3\" class=\"GridHead \">Q3 </td></tr> " +
                " <tr bgcolor='#DFF3F9'><td class=\"GridHead \" width=\"60px\" align=\"Center\">Actual</td><td class=\"GridHead \" bgcolor='#DFF3F9' width=\"33px\"  align=\"Center\">&nbsp;Add %</td><td class=\"GridHead\" width=\"60px\" bgcolor='#DFF3F9' align=\"Center\">Forecast</td></tr></table>";
            e.Item.Cells[11].ColumnSpan = 3;
            e.Item.Cells[11].Text = "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr bgcolor='#DFF3F9'><td align=\"center\"  colspan=\"3\" class=\"GridHead \">Q4 </td></tr> " +
                " <tr bgcolor='#DFF3F9'><td class=\"GridHead \" width=\"60px\" align=\"Center\">Actual</td><td class=\"GridHead \" bgcolor='#DFF3F9' width=\"33px\"  align=\"Center\">&nbsp;Add %</td><td class=\"GridHead\" width=\"60px\" bgcolor='#DFF3F9' align=\"Center\">Forecast</td></tr></table>";
            e.Item.Cells[14].ColumnSpan = 3;
            e.Item.Cells[14].Text = "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr bgcolor='#DFF3F9'><td align=\"center\"  colspan=\"3\" class=\"GridHead \">Annual </td></tr> " +
                " <tr bgcolor='#DFF3F9'><td class=\"GridHead \" width=\"60px\" align=\"Center\">Actual</td><td class=\"GridHead \" bgcolor='#DFF3F9' width=\"33px\"  align=\"Center\">&nbsp;Add %</td><td class=\"GridHead\" width=\"60px\" bgcolor='#DFF3F9' align=\"Center\">Forecast</td></tr></table>";
            e.Item.Cells[17].Text = "% Diff " ;
            e.Item.Cells[17].HorizontalAlign = HorizontalAlign.Center;
         
         
            e.Item.Cells[3].Visible = false;
            e.Item.Cells[4].Visible = false;
          
            e.Item.Cells[6].Visible = false;
            e.Item.Cells[7].Visible = false;
           
            e.Item.Cells[9].Visible = false;
            e.Item.Cells[10].Visible = false;
            e.Item.Cells[12].Visible = false;
            e.Item.Cells[13].Visible = false;
           
            e.Item.Cells[15].Visible = false;
            e.Item.Cells[16].Visible = false;
           
           

        }

    }

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

                // Display the info to the user when table contains no records
                lblStatus.Visible = (dgCas.Items.Count <= 0 ? true : false);
                tblHeader.Visible = (dgCas.Items.Count <= 0 ? false : true);

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

}