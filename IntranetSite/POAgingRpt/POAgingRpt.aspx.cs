using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.IO;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;

public partial class POAgingRpt : System.Web.UI.Page
{
    SqlConnection cnReports = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCReportsConnectionString"].ConnectionString);

    DataSet dsResult, dsPOAging, dsPOAgingGroup;
    DataTable dtTotal;

    Decimal TotAvgUseLbs, TotAvlLbs, TotTrfLbs, TotOTWLbs, TotRTSLbs, TotOOLbs, TotalLbs, TotForecastLbs,
            TotMth1RcptLbs, TotMth1AvlLbs, TotMth2RcptLbs, TotMth2AvlLbs, TotMth3RcptLbs, TotMth3AvlLbs;

    string _cmdText;
    string PreviewURL;

    //POAging POAging = new POAging();

    protected void Page_Load(object sender, EventArgs e)
    {
        //if (Request.QueryString["UserName"] != null)
        //    Session["UserName"] = Request.QueryString["UserName"].ToString();
        //Session["UserName"] = ((Session["UserName"] != null) ? Session["UserName"].ToString() : "[null]");

        //if (Request.QueryString["UserID"] != null)
        //    Session["UserID"] = Request.QueryString["UserID"].ToString();

        //if (Request.QueryString["SessionID"] != null)
        //    Session["SessionID"] = Request.QueryString["SessionID"].ToString();

        Session["UserName"] = ((Session["UserName"] != null) ? Session["UserName"].ToString() : "[null]");

        PreviewURL = "POAgingRpt/POAgingRptPreview.aspx?UserID=" + Session["UserID"].ToString() + "&UserName=" + Session["UserName"].ToString() + "&SessionID=" + Session["SessionID"].ToString();

        Ajax.Utility.RegisterTypeForAjax(typeof(POAgingRpt));

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
                    drSum["AvgUseLbs"] = dtFiltered.Compute("SUM(AvgUseLbs)","");
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

        pnlRptGrid.Update();

        PrintDialogue1.PageUrl = PreviewURL;
        pnlExport.Update();

        Pager1.InitPager(dgPOAging, 18);
        pnlPager.Update();
    }

    protected void PageChanged(Object sender, System.EventArgs e)
    {
        dgPOAging.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
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

    #region Export
    protected void btnExport_Click(object sender, ImageClickEventArgs e)
    {
        String xlsFile = "POAging" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//Common//ExcelUploads//") + xlsFile;
        FileInfo fnExcel = new FileInfo(ExportFile);
        StreamWriter reportWriter = fnExcel.CreateText();

        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;

        BindDataGrid();

        if (dtTotal != null && dtTotal.DefaultView.ToTable().Rows.Count > 0)
        {
            //Headers
            headerContent = "<table border='1' width='100%'>";
            headerContent += "<td colspan='24' style='color:blue; border-bottom:2' align=left>" +
                                "<center>Run Date: " + DateTime.Now.ToShortDateString() +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "<b>PO Aging Trend Report</b>" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                         "Run By: " + Session["UserName"].ToString() + "</center></td></tr>";

            headerContent += "<tr><th nowrap><center>Category Group</center></th>" +
                                 "<th nowrap><center>Avg Use Lbs</center></th>" +
                                 "<th nowrap><center>Avl Lbs</center></th>" +
                                 "<th nowrap><center>Avl Mos</center></th>" +
                                 "<th nowrap><center>Trf Lbs</center></th>" +
                                 "<th nowrap><center>Trf Mos</center></th>" +
                                 "<th nowrap><center>OTW Lbs</center></th>" +
                                 "<th nowrap><center>OTW Mos</center></th>" +
                                 "<th nowrap><center>OO Lbs</center></th>" +
                                 "<th nowrap><center>OO Mos</center></th>" +
                                 "<th nowrap><center>Tot Lbs</center></th>" +
                                 "<th nowrap><center>Tot Mos</center></th>" +
                                 "<th nowrap><center>Month 1 Sales</center></th>" +
                                 "<th nowrap><center>Month 1 Receipts</center></th>" +
                                 "<th nowrap><center>Month 1 Avl</center></th>" +
                                 "<th nowrap><center>Mth 1 Mos</center></th>" +
                                 "<th nowrap><center>Month 2 Sales</center></th>" +
                                 "<th nowrap><center>Month 2 Receipts</center></th>" +
                                 "<th nowrap><center>Month 2 Avl</center></th>" +
                                 "<th nowrap><center>Mth 2 Mos</center></th>" +
                                 "<th nowrap><center>Month 3 Sales</center></th>" +
                                 "<th nowrap><center>Month 3 Receipts</center></th>" +
                                 "<th nowrap><center>Month 3 Avl</center></th>" +
                                 "<th nowrap><center>Mth 3 Mos</center></th></tr>";
            reportWriter.Write(headerContent);

            //Detail
            if (dtTotal.DefaultView.ToTable().Rows.Count > 0)
            {
                foreach (DataRow dr in dtTotal.DefaultView.ToTable().Rows)
                {
                    if (dr["CatGroup"].ToString().Contains("Group Total: "))
                    {
                        dr["CatGroup"] = dr["CatGroup"].ToString().Replace("Group Total: ", "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
                        excelContent += " <tr style='font-weight:bold'>";
                    }
                    else
                        excelContent += " <tr>";

                    excelContent += "<td nowrap align='left'>" +
                                        dr["CatGroup"].ToString() + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", dr["AvgUseLbs"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", dr["AvlLbs"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0.0}", dr["AvlMos"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", dr["TrfLbs"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0.0}", dr["TrfMos"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", dr["OTWLbs"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0.0}", dr["OTWMos"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", dr["OOLbs"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0.0}", dr["OOMos"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", dr["TotalLbs"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0.0}", dr["TotalMos"]) + "</td><td nowrap>" +

                                        string.Format("{0:#,##0}", dr["ForecastLbs1"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", dr["Month1RcptLbs"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", dr["Month1AvlLbs"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0.0}", dr["Month1Mos"]) + "</td><td nowrap>" +

                                        string.Format("{0:#,##0}", dr["ForecastLbs2"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", dr["Month2RcptLbs"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", dr["Month2AvlLbs"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0.0}", dr["Month2Mos"]) + "</td><td nowrap>" +

                                        string.Format("{0:#,##0}", dr["ForecastLbs3"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", dr["Month3RcptLbs"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", dr["Month3AvlLbs"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0.0}", dr["Month3Mos"]) + "</td></tr>";
                }

                reportWriter.Write(excelContent);

                //Grand Totals
                footerContent = "<tr><td style='border-top:2' align=left><b>Grand Totals for all Groups</b></td>" +
                                    "<td style='border-top:2'><b>" + String.Format("{0:n0}", TotAvgUseLbs) + "</b></td>" +
                                    "<td style='border-top:2'><b>" + String.Format("{0:n0}", TotAvlLbs) + "</b></td>";

                if (TotAvgUseLbs != 0)
                    footerContent += "<td style='border-top:2'><b>" + String.Format("{0:n1}", TotAvlLbs / TotAvgUseLbs) + "</b></td>";
                else
                    footerContent += "<td style='border-top:2'><b>0.0</b></td>";

                footerContent +=     "<td style='border-top:2'><b>" + String.Format("{0:n0}", TotTrfLbs) + "</b></td>";

                if (TotAvgUseLbs != 0)
                    footerContent += "<td style='border-top:2'><b>" + String.Format("{0:n1}", TotTrfLbs / TotAvgUseLbs) + "</b></td>";
                else
                    footerContent += "<td style='border-top:2'><b>0.0</b></td>";

                footerContent +=     "<td style='border-top:2'><b>" + String.Format("{0:n0}", TotOTWLbs) + "</b></td>";

                if (TotAvgUseLbs != 0)
                    footerContent += "<td style='border-top:2'><b>" + String.Format("{0:n1}", TotOTWLbs / TotAvgUseLbs) + "</b></td>";
                else
                    footerContent += "<td style='border-top:2'><b>0.0</b></td>";

                footerContent +=     "<td style='border-top:2'><b>" + String.Format("{0:n0}", TotOOLbs) + "</b></td>";

                if (TotAvgUseLbs != 0)
                    footerContent += "<td style='border-top:2'><b>" + String.Format("{0:n1}", TotOOLbs / TotAvgUseLbs) + "</b></td>";
                else
                    footerContent += "<td style='border-top:2'><b>0.0</b></td>";

                footerContent +=     "<td style='border-top:2'><b>" + String.Format("{0:n0}", TotalLbs) + "</b></td>";

                if (TotAvgUseLbs != 0)
                    footerContent += "<td style='border-top:2'><b>" + String.Format("{0:n1}", TotalLbs / TotAvgUseLbs) + "</b></td>";
                else
                    footerContent += "<td style='border-top:2'><b>0.0</b></td>";

                footerContent +=     "<td style='border-top:2'><b>" + String.Format("{0:n0}", TotForecastLbs) + "</b></td>" +
                                     "<td style='border-top:2'><b>" + String.Format("{0:n0}", TotMth1RcptLbs) + "</b></td>" +
                                     "<td style='border-top:2'><b>" + String.Format("{0:n0}", TotMth1AvlLbs) + "</b></td>";

                if (TotForecastLbs != 0)
                    footerContent += "<td style='border-top:2'><b>" + String.Format("{0:n1}", TotMth1AvlLbs / TotForecastLbs) + "</b></td>";
                else
                    footerContent += "<td style='border-top:2'><b>0.0</b></td>";

                footerContent +=     "<td style='border-top:2'><b>" + String.Format("{0:n0}", TotForecastLbs) + "</b></td>" +
                                     "<td style='border-top:2'><b>" + String.Format("{0:n0}", TotMth2RcptLbs) + "</b></td>" +
                                     "<td style='border-top:2'><b>" + String.Format("{0:n0}", TotMth2AvlLbs) + "</b></td>";

                if (TotForecastLbs != 0)
                    footerContent += "<td style='border-top:2'><b>" + String.Format("{0:n1}", TotMth2AvlLbs / TotForecastLbs) + "</b></td>";
                else
                    footerContent += "<td style='border-top:2'><b>0.0</b></td>";

                footerContent +=     "<td style='border-top:2'><b>" + String.Format("{0:n0}", TotForecastLbs) + "</b></td>" +
                                     "<td style='border-top:2'><b>" + String.Format("{0:n0}", TotMth3RcptLbs) + "</b></td>" +
                                     "<td style='border-top:2'><b>" + String.Format("{0:n0}", TotMth3AvlLbs) + "</b></td>";

                if (TotForecastLbs != 0)
                    footerContent += "<td style='border-top:2'><b>" + String.Format("{0:n1}", TotMth3AvlLbs / TotForecastLbs) + "</b></td>";
                else
                    footerContent += "<td style='border-top:2'><b>0.0</b></td>";

                footerContent +=     "</tr>";

                reportWriter.WriteLine(footerContent);
            }

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
    }

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
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
    }
    #endregion
}
