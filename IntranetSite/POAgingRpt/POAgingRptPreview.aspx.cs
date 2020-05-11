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
using PFC.Intranet.DataAccessLayer;

public partial class POAgingRptPreview : System.Web.UI.Page
{
    SqlConnection cnReports = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCReportsConnectionString"].ConnectionString);

    DataSet dsResult, dsPOAging, dsPOAgingGroup;
    DataTable dtTotal;

    Decimal TotAvgUseLbs, TotAvlLbs, TotTrfLbs, TotOTWLbs, TotRTSLbs, TotOOLbs, TotalLbs, TotForecastLbs,
            TotMth1RcptLbs, TotMth1AvlLbs, TotMth2RcptLbs, TotMth2AvlLbs, TotMth3RcptLbs, TotMth3AvlLbs;

    string _cmdText;

    //POAging POAging = new POAging();

    protected void Page_Load(object sender, EventArgs e)
    {
        BindDataGrid();
    }

    #region Bind Grid
    private void BindDataGrid()
    {
        TotAvgUseLbs = 0;
        TotAvlLbs = 0;
        TotTrfLbs = 0;
        TotOTWLbs = 0;
        TotRTSLbs = 0;
        TotOOLbs = 0;
        TotalLbs = 0;

        TotForecastLbs = 0;
        TotMth1RcptLbs = 0;
        TotMth1AvlLbs = 0;
        TotMth2RcptLbs = 0;
        TotMth2AvlLbs = 0;
        TotMth3RcptLbs = 0;
        TotMth3AvlLbs = 0;

        //dsPOAging = POAging.GetPOAging();
        //dsPOAgingGroup = POAging.GetPOAgingGroup();
        dsPOAging = GetPOAging();
        dsPOAgingGroup = GetPOAgingGroup();
        dtTotal = dsPOAging.Tables[0].DefaultView.ToTable().Clone();

        foreach (DataRow dr in dsPOAgingGroup.Tables[0].DefaultView.ToTable().Rows)
        {
            try
            {
                dsPOAging.Tables[0].DefaultView.RowFilter = "SubTotGroup='" + dr["SubTotGroup"].ToString() + "'";
                DataTable dtFiltered = dsPOAging.Tables[0].DefaultView.ToTable();
                if (dtFiltered != null && dtFiltered.Rows.Count > 0)
                {
                    DataRow drSum = dtTotal.NewRow();
                    dtTotal.Merge(dtFiltered);
                    drSum["CatGroup"] = "Group Total: " + dtFiltered.Rows[0]["SubTotGroupDesc"];
                    //drSum["CatGroup"] = "Group Total: " + dtFiltered.Rows[0]["SubTotGroup"] + " - " + dtFiltered.Rows[0]["SubTotGroupDesc"];

                    //Group Totals
                    drSum["AvgUseLbs"] = dtFiltered.Compute("SUM(AvgUseLbs)", "");
                    //drSum["AvgUseLbs"] = "999,999,999,999";
                    drSum["AvlLbs"] = dtFiltered.Compute("SUM(AvlLbs)", "");
                    drSum["TrfLbs"] = dtFiltered.Compute("SUM(TrfLbs)", "");
                    drSum["OTWLbs"] = dtFiltered.Compute("SUM(OTWLbs)", "");
                    drSum["RTSLbs"] = dtFiltered.Compute("SUM(RTSLbs)", "");
                    drSum["OOLbs"] = dtFiltered.Compute("SUM(OOLbs)", "");
                    drSum["TotalLbs"] = dtFiltered.Compute("SUM(TotalLbs)", "");

                    TotAvgUseLbs = TotAvgUseLbs + Convert.ToInt32(drSum["AvgUseLbs"]);
                    TotAvlLbs = TotAvlLbs + Convert.ToInt32(drSum["AvlLbs"]);
                    TotTrfLbs = TotTrfLbs + Convert.ToInt32(drSum["TrfLbs"]);
                    TotOTWLbs = TotOTWLbs + Convert.ToInt32(drSum["OTWLbs"]);
                    TotRTSLbs = TotRTSLbs + Convert.ToInt32(drSum["RTSLbs"]);
                    TotOOLbs = TotOOLbs + Convert.ToInt32(drSum["OOLbs"]);
                    TotalLbs = TotalLbs + Convert.ToInt32(drSum["TotalLbs"]);

                    if (Convert.ToInt32(dtFiltered.Compute("SUM(AvgUseLbs)", "")) != 0)
                    {
                        drSum["AvlMos"] = dtFiltered.Compute("(SUM(AvlLbs)) / (SUM(AvgUseLbs))", "");
                        drSum["TrfMos"] = dtFiltered.Compute("(SUM(TrfLbs)) / (SUM(AvgUseLbs))", "");
                        drSum["OTWMos"] = dtFiltered.Compute("(SUM(OTWLbs)) / (SUM(AvgUseLbs))", "");
                        drSum["RTSMos"] = dtFiltered.Compute("(SUM(RTSLbs)) / (SUM(AvgUseLbs))", "");
                        drSum["OOMos"] = dtFiltered.Compute("(SUM(OOLbs)) / (SUM(AvgUseLbs))", "");
                        drSum["TotalMos"] = dtFiltered.Compute("(SUM(TotalLbs)) / (SUM(AvgUseLbs))", "");
                    }
                    else
                    {
                        drSum["AvlMos"] = 0;
                        drSum["TrfMos"] = 0;
                        drSum["OTWMos"] = 0;
                        drSum["RTSMos"] = 0;
                        drSum["OOMos"] = 0;
                        drSum["TotalMos"] = 0;
                    }

                    //Forecast Group Totals
                    drSum["ForecastLbs1"] = dtFiltered.Compute("SUM(ForecastLbs1)", "");
                    drSum["Month1RcptLbs"] = dtFiltered.Compute("SUM(Month1RcptLbs)", "");
                    drSum["Month1AvlLbs"] = dtFiltered.Compute("SUM(Month1AvlLbs)", "");
                    drSum["ForecastLbs2"] = dtFiltered.Compute("SUM(ForecastLbs2)", "");
                    drSum["Month2RcptLbs"] = dtFiltered.Compute("SUM(Month2RcptLbs)", "");
                    drSum["Month2AvlLbs"] = dtFiltered.Compute("SUM(Month2AvlLbs)", "");
                    drSum["ForecastLbs3"] = dtFiltered.Compute("SUM(ForecastLbs3)", "");
                    drSum["Month3RcptLbs"] = dtFiltered.Compute("SUM(Month3RcptLbs)", "");
                    drSum["Month3AvlLbs"] = dtFiltered.Compute("SUM(Month3AvlLbs)", "");

                    TotForecastLbs = TotForecastLbs + Convert.ToInt32(drSum["ForecastLbs1"]);
                    TotMth1RcptLbs = TotMth1RcptLbs + Convert.ToInt32(drSum["Month1RcptLbs"]);
                    TotMth1AvlLbs = TotMth1AvlLbs + Convert.ToInt32(drSum["Month1AvlLbs"]);
                    TotMth2RcptLbs = TotMth2RcptLbs + Convert.ToInt32(drSum["Month2RcptLbs"]);
                    TotMth2AvlLbs = TotMth2AvlLbs + Convert.ToInt32(drSum["Month2AvlLbs"]);
                    TotMth3RcptLbs = TotMth3RcptLbs + Convert.ToInt32(drSum["Month3RcptLbs"]);
                    TotMth3AvlLbs = TotMth3AvlLbs + Convert.ToInt32(drSum["Month3AvlLbs"]);

                    if (Convert.ToInt32(dtFiltered.Compute("SUM(ForecastLbs1)", "")) != 0)
                        drSum["Month1Mos"] = dtFiltered.Compute("(SUM(Month1AvlLbs)) / (SUM(ForecastLbs1))", "");
                    else
                        drSum["Month1Mos"] = 0;

                    if (Convert.ToInt32(dtFiltered.Compute("SUM(ForecastLbs2)", "")) != 0)
                        drSum["Month2Mos"] = dtFiltered.Compute("(SUM(Month2AvlLbs)) / (SUM(ForecastLbs2))", "");
                    else
                        drSum["Month2Mos"] = 0;

                    if (Convert.ToInt32(dtFiltered.Compute("SUM(ForecastLbs3)", "")) != 0)
                        drSum["Month3Mos"] = dtFiltered.Compute("(SUM(Month3AvlLbs)) / (SUM(ForecastLbs3))", "");
                    else
                        drSum["Month3Mos"] = 0;

                    dtTotal.Rows.Add(drSum);
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        dgPOAging.DataSource = dtTotal.DefaultView.ToTable();
        dgPOAging.DataBind();

        //Grand Totals
        lblTotAvgUseLbs.Text = String.Format("{0:n0}", TotAvgUseLbs);
        lblTotAvlLbs.Text = String.Format("{0:n0}", TotAvlLbs);
        lblTotTrfLbs.Text = String.Format("{0:n0}", TotTrfLbs);
        lblTotOTWLbs.Text = String.Format("{0:n0}", TotOTWLbs);
        lblTotRTSLbs.Text = String.Format("{0:n0}", TotRTSLbs);
        lblTotOOLbs.Text = String.Format("{0:n0}", TotOOLbs);
        lblTotalLbs.Text = String.Format("{0:n0}", TotalLbs);

        if (TotAvgUseLbs != 0)
        {
            lblTotAvlMos.Text = String.Format("{0:n1}", TotAvlLbs / TotAvgUseLbs);
            lblTotTrfMos.Text = String.Format("{0:n1}", TotTrfLbs / TotAvgUseLbs);
            lblTotOTWMos.Text = String.Format("{0:n1}", TotOTWLbs / TotAvgUseLbs);
            lblTotRTSMos.Text = String.Format("{0:n1}", TotRTSLbs / TotAvgUseLbs);
            lblTotOOMos.Text = String.Format("{0:n1}", TotOOLbs / TotAvgUseLbs);
            lblTotalMos.Text = String.Format("{0:n1}", TotalLbs / TotAvgUseLbs);
        }
        else
        {
            lblTotAvlMos.Text = "0.0";
            lblTotTrfMos.Text = "0.0";
            lblTotOTWMos.Text = "0.0";
            lblTotRTSMos.Text = "0.0";
            lblTotOOMos.Text = "0.0";
            lblTotalMos.Text = "0.0";
        }

        //Forecast Grand Totals
        lblTotMth1Sls.Text = String.Format("{0:n0}", TotForecastLbs);
        lblTotMth1Rct.Text = String.Format("{0:n0}", TotMth1RcptLbs);
        lblTotMth1Avl.Text = String.Format("{0:n0}", TotMth1AvlLbs);
        lblTotMth2Sls.Text = String.Format("{0:n0}", TotForecastLbs);
        lblTotMth2Rct.Text = String.Format("{0:n0}", TotMth2RcptLbs);
        lblTotMth2Avl.Text = String.Format("{0:n0}", TotMth2AvlLbs);
        lblTotMth3Sls.Text = String.Format("{0:n0}", TotForecastLbs);
        lblTotMth3Rct.Text = String.Format("{0:n0}", TotMth3RcptLbs);
        lblTotMth3Avl.Text = String.Format("{0:n0}", TotMth3AvlLbs);

        if (TotForecastLbs != 0)
        {
            lblTotMth1Mos.Text = String.Format("{0:n1}", TotMth1AvlLbs / TotForecastLbs);
            lblTotMth2Mos.Text = String.Format("{0:n1}", TotMth2AvlLbs / TotForecastLbs);
            lblTotMth3Mos.Text = String.Format("{0:n1}", TotMth3AvlLbs / TotForecastLbs);
        }
        else
        {
            lblTotMth1Mos.Text = "0.0";
            lblTotMth2Mos.Text = "0.0";
            lblTotMth3Mos.Text = "0.0";
        }
    }

    protected void dgPOAging_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            if (e.Item.Cells[0].Text.Contains("Group Total: "))
            {
                e.Item.Font.Bold = true;
                e.Item.Cells[0].Text = e.Item.Cells[0].Text.Replace("Group Total: ", "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
                //e.Item.Cells[0].HorizontalAlign = HorizontalAlign.Center;
            }
        }
    }
    #endregion

    #region Table I/O
    public DataSet GetPOAging()
    {
        _cmdText = "SELECT BuyGroupNo + ' - ' + BuyGroupDesc AS CatGroup, SubTotGroup, SubTotGroupDesc, " +
                   "       AvgUseLbs, AvlLbs, AvlMos, TrfLbs, TrfMos, OTWLbs, OTWMos, RTSLbs, RTSMos, OOLbs, OOMos, TotalLbs, TotalMos, " +
                   "       ForecastLbs AS ForecastLbs1, Month1RcptLbs, Month1AvlLbs, Month1Mos, " +
                   "       ForecastLbs AS ForecastLbs2, Month2RcptLbs, Month2AvlLbs, Month2Mos, " +
                   "       ForecastLbs AS ForecastLbs3, Month3RcptLbs, Month3AvlLbs, Month3Mos " +
                   "FROM   POAgingRpt (NoLock) ORDER BY RIGHT(('000' + SubTotGroup),3), RIGHT(('000' + BuyGroupNo),3)";
        dsResult = SqlHelper.ExecuteDataset(cnReports, CommandType.Text, _cmdText);
        return dsResult;
    }

    public DataSet GetPOAgingGroup()
    {
        _cmdText = "SELECT SubTotGroup FROM POAgingRpt (NoLock) GROUP BY SubTotGroup";
        dsResult = SqlHelper.ExecuteDataset(cnReports, CommandType.Text, _cmdText);
        return dsResult;
    }
    #endregion
}
