using System;
using System.IO;
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

public partial class SOCustomerRpt : System.Web.UI.Page
{
    SqlConnection cnxReports;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet ds = new DataSet();

    Decimal DispVal, TotSales, TotPounds, TotMgn, TotMTDGoal, TotMTDGoalMgn, TotYTDSales, TotYTDGoal, TotYTDGoalMgn, TotSalesWeb, TotMgnWeb;    
    Decimal GrdTotSales, GrdTotPounds, GrdTotMgnDol, GrdTotMTDGoal, GrdTotMTDGoalMgnDol, GrdTotYTDSales, GrdTotYTDGoal, GrdTotYTDGoalMgnDol, GrdTotWebSales, GrdTotWebMgnDol;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(SOCustomerRpt));
        Session["SessionID"] = ((Session["SessionID"] != null) ? Session["SessionID"].ToString() : "null");

        //PFCReports
        cnxReports = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCReportsConnectionString"].ConnectionString);

        lblBranchHd.Text = ": " + Request.QueryString["LocName"].ToString();

        if (Request.QueryString["Range"].ToString() == "Daily")
        {
            GridView1.Width = 910;
            td1.Visible = false;
            td2.Visible = false;
            td3.Visible = false;
            td4.Visible = false;
            td5.Visible = false;
            tblGrdTot.Style.Value = "position: relative; top: 0px; left: 0px; height: 30px; width: 910px; border: 1px solid;";
            lblRangeHd.Text = "Daily Sales Orders By Customer";
            cmd = new SqlCommand("pDashboardSODrilldownDaily", cnxReports);
        }

        if (Request.QueryString["Range"].ToString() == "MTD")
        {
            GridView1.Width = 1245;
            tblGrdTot.Style.Value = "position: relative; top: 0px; left: 0px; height: 30px; width: 1245px; border: 1px solid;";
            lblRangeHd.Text = "MTD Sales Orders By Customer";
            cmd = new SqlCommand("pDashboardSODrilldownMTD", cnxReports);
        }

        cmd.Parameters.AddWithValue("@Loc", Request.QueryString["Location"].ToString());
        cmd.Parameters.AddWithValue("@CustNo", Request.QueryString["Customer"].ToString());
        cmd.Parameters.AddWithValue("@InvoiceNo", Request.QueryString["Invoice"].ToString());
        cmd.CommandType = CommandType.StoredProcedure;

        hidSort.Value = ((Session["SortSOCustomer"] != null) ? Session["SortSOCustomer"].ToString() : " SalesDollars DESC");

        if (!Page.IsPostBack)
        {
            BindDataGrid();
            hidRange.Value = Request.QueryString["Range"].ToString();
        }
    }

    public void BindDataGrid()
    {
        String sortExpression = (hidSort.Value == "") ? " SalesDollars DESC" : hidSort.Value;
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "SoCust");
        ds.Tables["SoCust"].DefaultView.Sort = sortExpression;
        GridView1.DataSource = ds.Tables["SoCust"].DefaultView.ToTable();

        if (ds.Tables["SoCust"].Rows.Count > 0)
        {
            GrdTotSales = Convert.ToDecimal(ds.Tables["SoCust"].Compute("sum(SalesDollars)", ""));
            lblTotSales.Text = String.Format("{0:c}", GrdTotSales);

            // Display tooltip 
            Decimal TotWhseSalesDollars, TotWhseMarginDollars, TotWhseMarginPct, TotMillSalesDollars, TotMillMarginDollars, TotMillMarginPct;

            TotWhseSalesDollars = Math.Round(Convert.ToDecimal(ds.Tables["SoCust"].DefaultView.ToTable().Compute("Sum(WhseSalesDollars)", "").ToString()),2);
            TotWhseMarginDollars = Math.Round(Convert.ToDecimal(ds.Tables["SoCust"].DefaultView.ToTable().Compute("Sum(WhseMarginDollars)", "").ToString()),2);            
            TotWhseMarginPct = (TotWhseSalesDollars.ToString() == "0.00" ? 0 : ((TotWhseMarginDollars / TotWhseSalesDollars) * 100));
            TotMillSalesDollars = Math.Round(Convert.ToDecimal(ds.Tables["SoCust"].DefaultView.ToTable().Compute("Sum(MillSalesDollars)", "").ToString()),2);
            TotMillMarginDollars = Math.Round(Convert.ToDecimal(ds.Tables["SoCust"].DefaultView.ToTable().Compute("Sum(MillMarginDollars)", "").ToString()),2);
            TotMillMarginPct = (TotMillSalesDollars.ToString() == "0.00" ? 0 : ((TotMillMarginDollars / TotMillSalesDollars) * 100));
            
            lblFooterWhseSalesDollars.Text = String.Format("{0:c}", TotWhseSalesDollars);
            lblFooterWhseMarginDollars.Text = String.Format("{0:c}", TotWhseMarginDollars);
            lblFooterWhseMarginPct.Text = String.Format("{0:N2}%",TotWhseMarginPct);
            lblFooterMillSalesDollars.Text = String.Format("{0:c}", TotMillSalesDollars);
            lblFooterMillMarginDollars.Text = String.Format("{0:c}", TotMillMarginDollars);
            lblFooterMillMarginPct.Text = String.Format("{0:N2}%", TotMillMarginPct);

            lblTotSales.Attributes.Add("onmouseover", "javascript:ShowGridtooltip('" + divFooterToolTips.ClientID + "','" + lblTotSales.ClientID + "');");
            lblTotSales.Attributes.Add("onmouseout", "javascript:document.getElementById('" + divFooterToolTips.ClientID + "').style.display='none';");
            
            GrdTotPounds = Math.Round(Convert.ToDecimal(ds.Tables["SoCust"].Compute("sum(Lbs)", "")), 2);
            lblTotPounds.Text = String.Format("{0:0,0.00}", GrdTotPounds);

            if (GrdTotPounds == 0)
                lblTotPricePerLb.Text = "0";
            else
                lblTotPricePerLb.Text = String.Format("{0:c}", GrdTotSales / GrdTotPounds);

            GrdTotMgnDol = Convert.ToDecimal(ds.Tables["SoCust"].Compute("sum(MarginDollars)", ""));
            lblTotMgnDollars.Text = String.Format("{0:c}", GrdTotMgnDol);

            if (GrdTotPounds == 0)
                lblTotMgnPerLb.Text = "0";
            else
                lblTotMgnPerLb.Text = String.Format("{0:c}", GrdTotMgnDol / GrdTotPounds);

            if (GrdTotSales == 0)
                lblTotMgnPct.Text = "0";
            else
                lblTotMgnPct.Text = String.Format("{0:N2}%", GrdTotMgnDol / GrdTotSales * 100);

            if (Request.QueryString["Range"].ToString() == "MTD")
            {
                GrdTotMTDGoal = Convert.ToDecimal(ds.Tables["SoCust"].Compute("sum(MTDGoalDol)", ""));
                lblMTDGoal.Text = String.Format("{0:c}", GrdTotMTDGoal);

                GrdTotMTDGoalMgnDol = Convert.ToDecimal(ds.Tables["SoCust"].Compute("sum(MTDGoalMgnDol)", ""));

                if (GrdTotMTDGoal == 0)
                    lblMTDGoalGM.Text = "0";
                else
                    lblMTDGoalGM.Text = String.Format("{0:N2}%", GrdTotMTDGoalMgnDol / GrdTotMTDGoal * 100);

                GrdTotYTDSales = Convert.ToDecimal(ds.Tables["SoCust"].Compute("sum(YTDSalesDol)", ""));
                lblYTDSales.Text = String.Format("{0:c}", GrdTotYTDSales);

                GrdTotYTDGoal = Convert.ToDecimal(ds.Tables["SoCust"].Compute("sum(YTDGoalDol)", ""));
                lblYTDGoal.Text = String.Format("{0:c}", GrdTotYTDGoal);

                GrdTotYTDGoalMgnDol = Convert.ToDecimal(ds.Tables["SoCust"].Compute("sum(YTDGoalMgnDol)", ""));
                if (GrdTotYTDGoal == 0)
                    lblYTDGoalGM.Text = "0";
                else
                    lblYTDGoalGM.Text = String.Format("{0:N2}%", GrdTotYTDGoalMgnDol / GrdTotYTDGoal * 100);
            }

            GrdTotWebSales = Convert.ToDecimal(ds.Tables["SoCust"].Compute("sum(SalesDollarsWeb)", ""));
            lblTotWebSales.Text = String.Format("{0:c}", GrdTotWebSales);

            GrdTotWebMgnDol = Convert.ToDecimal(ds.Tables["SoCust"].Compute("sum(MarginDollarsWeb)", ""));
            lblTotWebMgnDollars.Text = String.Format("{0:c}", GrdTotWebMgnDol);

            if (GrdTotWebSales == 0)
                lblTotWebMgnPct.Text = "0";
            else
                lblTotWebMgnPct.Text = String.Format("{0:N2}%", GrdTotWebMgnDol / GrdTotWebSales * 100);

            if (GrdTotSales == 0)
                lblTotWebPctSales.Text = "0";
            else
                lblTotWebPctSales.Text = String.Format("{0:N2}%", GrdTotWebSales / GrdTotSales * 100);
        }

        Pager1.InitPager(GridView1, 22);
    }

    protected void ItemDataBound(Object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Header)
            if (Request.QueryString["Range"].ToString() != "MTD")
            {
                e.Item.Cells[8].Visible = false;
                e.Item.Cells[9].Visible = false;
                e.Item.Cells[10].Visible = false;
                e.Item.Cells[11].Visible = false;
                e.Item.Cells[12].Visible = false;
            }
        
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
           
            Label _lblSalesDol = e.Item.FindControl("lblSalesDol") as Label;

            HtmlGenericControl _divToolTips = e.Item.FindControl("divToolTips") as HtmlGenericControl;
            _lblSalesDol.Attributes.Add("onmouseover", "javascript:ShowGridtooltip('" + _divToolTips.ClientID + "','" + _lblSalesDol.ClientID + "');");
            _lblSalesDol.Attributes.Add("onmouseout", "javascript:document.getElementById('" + _divToolTips.ClientID + "').style.display='none';");

            TotSales = TotSales + Convert.ToDecimal(_lblSalesDol.Text);

            DispVal = Convert.ToDecimal(_lblSalesDol.Text);
            _lblSalesDol.Text = String.Format("{0:c}", DispVal);

            TotPounds = TotPounds + Convert.ToDecimal(e.Item.Cells[3].Text);
            DispVal = Math.Round(Convert.ToDecimal(e.Item.Cells[3].Text), 2);
            e.Item.Cells[3].Text = String.Format("{0:0,0.00}", DispVal);

            TotMgn = TotMgn + Convert.ToDecimal(e.Item.Cells[5].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[5].Text);
            e.Item.Cells[5].Text = String.Format("{0:c}", DispVal);

            if (Request.QueryString["Range"].ToString() == "MTD")
            {
                TotMTDGoalMgn = TotMTDGoalMgn + (Convert.ToDecimal(e.Item.Cells[8].Text) * Convert.ToDecimal(e.Item.Cells[9].Text));
                TotMTDGoal = TotMTDGoal + Convert.ToDecimal(e.Item.Cells[8].Text);
                DispVal = Convert.ToDecimal(e.Item.Cells[8].Text);
                e.Item.Cells[8].Text = String.Format("{0:c}", DispVal);

                DispVal = Convert.ToDecimal(e.Item.Cells[9].Text) * 100;
                e.Item.Cells[9].Text = String.Format("{0:N2}%", DispVal);

                HyperLink _hplYTDSalesDol = e.Item.FindControl("hplYTDSalesDol") as HyperLink;
                TotYTDSales = TotYTDSales + Convert.ToDecimal(_hplYTDSalesDol.Text);
                DispVal = Convert.ToDecimal(_hplYTDSalesDol.Text);

                string PrevMth1SalesDol = e.Item.Cells[17].Text.ToString().Trim();
                string PrevMth2SalesDol = e.Item.Cells[18].Text.ToString().Trim();
                string PrevMth3SalesDol = e.Item.Cells[19].Text.ToString().Trim();

                string PrevMth1GMPct = e.Item.Cells[20].Text.ToString().Trim();
                string PrevMth2GMPct = e.Item.Cells[21].Text.ToString().Trim();
                string PrevMth3GMPct = e.Item.Cells[22].Text.ToString().Trim();
                
                _hplYTDSalesDol.Text = String.Format("{0:c}", DispVal);
                _hplYTDSalesDol.NavigateUrl = "PrevMthSalesPopup.aspx?Mth1Sales=" + PrevMth1SalesDol + "&Mth2Sales=" + PrevMth2SalesDol + "&Mth3Sales=" + PrevMth3SalesDol +
                                                                    "&Mth1GMPct=" + PrevMth1GMPct    + "&Mth2GMPct=" + PrevMth2GMPct    + "&Mth3GMPct=" + PrevMth3GMPct;
                _hplYTDSalesDol.ForeColor = System.Drawing.Color.Green;
                _hplYTDSalesDol.Font.Underline = true;
                _hplYTDSalesDol.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'YTDSales', 'height=50,width=350,scrollbars=no,status=no,top='+((screen.height/2) - (50/2))+',left='+((screen.width/2) - (350/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");

                TotYTDGoalMgn = TotYTDGoalMgn + (Convert.ToDecimal(e.Item.Cells[11].Text) * Convert.ToDecimal(e.Item.Cells[12].Text));
                TotYTDGoal = TotYTDGoal + Convert.ToDecimal(e.Item.Cells[11].Text);
                DispVal = Convert.ToDecimal(e.Item.Cells[11].Text);
                e.Item.Cells[11].Text = String.Format("{0:c}", DispVal);

                DispVal = Convert.ToDecimal(e.Item.Cells[12].Text) * 100;
                e.Item.Cells[12].Text = String.Format("{0:N2}%", DispVal);
            }
            else    //Hide MTD/YTD Goal/Sales data
            {
                e.Item.Cells[8].Visible = false;
                e.Item.Cells[9].Visible = false;
                e.Item.Cells[10].Visible = false;
                e.Item.Cells[11].Visible = false;
                e.Item.Cells[12].Visible = false;
            }

            TotSalesWeb = TotSalesWeb + Convert.ToDecimal(e.Item.Cells[13].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[13].Text);
            e.Item.Cells[13].Text = String.Format("{0:c}", DispVal);

            TotMgnWeb = TotMgnWeb + Convert.ToDecimal(e.Item.Cells[14].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[14].Text);
            e.Item.Cells[14].Text = String.Format("{0:c}", DispVal);
        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[1].Text = "Sub-Totals:";

            e.Item.Cells[2].Text = String.Format("{0:c}", TotSales);

            e.Item.Cells[3].Text = String.Format("{0:0,0.00}", Math.Round(TotPounds, 2));

            if (TotPounds == 0)
                e.Item.Cells[4].Text = "0";
            else
                e.Item.Cells[4].Text = String.Format("{0:c}", TotSales / TotPounds);

            e.Item.Cells[5].Text = String.Format("{0:c}", TotMgn);

            if (TotPounds == 0)
                e.Item.Cells[6].Text = "0";
            else
                e.Item.Cells[6].Text = String.Format("{0:c}", TotMgn / TotPounds);

            if (TotSales == 0)
                e.Item.Cells[7].Text = "0";
            else
                e.Item.Cells[7].Text = String.Format("{0:N2}%", TotMgn / TotSales * 100);

            if (Request.QueryString["Range"].ToString() == "MTD")
            {
                e.Item.Cells[8].Text = String.Format("{0:c}", TotMTDGoal);

                if (TotMTDGoal == 0)
                    e.Item.Cells[9].Text = "0";
                else
                    e.Item.Cells[9].Text = String.Format("{0:N2}%", TotMTDGoalMgn / TotMTDGoal * 100);

                e.Item.Cells[10].Text = String.Format("{0:c}", TotYTDSales);

                e.Item.Cells[11].Text = String.Format("{0:c}", TotYTDGoal);

                if (TotYTDGoal == 0)
                    e.Item.Cells[12].Text = "0";
                else
                    e.Item.Cells[12].Text = String.Format("{0:N2}%", TotYTDGoalMgn / TotYTDGoal * 100);
            }
            else
            {
                e.Item.Cells[8].Visible = false;
                e.Item.Cells[9].Visible = false;
                e.Item.Cells[10].Visible = false;
                e.Item.Cells[11].Visible = false;
                e.Item.Cells[12].Visible = false;
            }

            e.Item.Cells[13].Text = String.Format("{0:c}", TotSalesWeb);

            e.Item.Cells[14].Text = String.Format("{0:c}", TotMgnWeb);

            if (TotSalesWeb == 0)
                e.Item.Cells[15].Text = "0";
            else
                e.Item.Cells[15].Text = String.Format("{0:N2}%", TotMgnWeb / TotSalesWeb * 100);

            if (TotSales == 0)
                e.Item.Cells[16].Text = "0";
            else
                e.Item.Cells[16].Text = String.Format("{0:N2}%", TotSalesWeb / TotSales * 100);
        }
    }

    protected void GridView1_SortCommand(object source, DataGridSortCommandEventArgs e)
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

        hidSort.Value = "[" + e.SortExpression + "] " + hidSort.Attributes["sortType"].ToString();
        Session["SortSOCustomer"] = hidSort.Value;
        BindDataGrid();
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        GridView1.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        char tab = '\t';

        String xlsFile = "SOCustomer_" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//DashboardDrilldown//Excel//") + xlsFile;

        StreamWriter swExcel = new StreamWriter(ExportFile, false);

        String xlsHdr = string.Empty;
        String xlsDtl = string.Empty;

        #region xlsHeader
        xlsHdr =    "Cust No" + tab +
                    "Customer Name" + tab +
                    "Sales $" + tab +
                    "Pounds" + tab +
                    "Price/Lb" + tab +
                    "Mgn $" + tab +
                    "Mgn/Lb" + tab +
                    "Mgn %" + tab;

        if (Request.QueryString["Range"].ToString() == "MTD")
        {
            xlsHdr +=   "MTD Goal $" + tab +
                        "MTD Goal GM%" + tab +
                        "YTD Sales $" + tab +
                        "YTD Goal $" + tab +
                        "YTD Goal GM%" + tab;
        }

        xlsHdr +=   "Web Sales $" + tab +
                    "Web Mgn $" + tab +
                    "Web Mgn %" + tab +
                    "% Web Orders";

        swExcel.WriteLine(xlsHdr);
        #endregion

        String sortExpression = (hidSort.Value == "") ? " SalesDollars DESC" : hidSort.Value;
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "SoCust");
        ds.Tables["SoCust"].DefaultView.Sort = sortExpression;

        #region xlsDetail
        foreach (DataRow SoCustRow in ds.Tables["SoCust"].DefaultView.ToTable().Rows)
        {
            xlsDtl =    SoCustRow["CustNo"].ToString() + tab +
                        SoCustRow["CustName"].ToString() + tab +
                        String.Format("{0:c}", SoCustRow["SalesDollars"]) + tab +
                        String.Format("{0:0,0.00}", SoCustRow["Lbs"]) + tab +
                        String.Format("{0:c}", SoCustRow["SalesPerLb"]) + tab +
                        String.Format("{0:c}", SoCustRow["MarginDollars"]) + tab +
                        String.Format("{0:c}", SoCustRow["MarginPerLb"]) + tab +
                        String.Format("{0:N2}%", SoCustRow["MarginPct"]) + tab;

            if (Request.QueryString["Range"].ToString() == "MTD")
            {
                xlsDtl +=   String.Format("{0:c}", SoCustRow["MTDGoalDol"]) + tab +
                            String.Format("{0:N2}%", Convert.ToDecimal(SoCustRow["MTDGoalGMPct"]) * 100) + tab +
                            String.Format("{0:c}", SoCustRow["YTDSalesDol"]) + tab +
                            String.Format("{0:c}", SoCustRow["YTDGoalDol"]) + tab +
                            String.Format("{0:N2}%", Convert.ToDecimal(SoCustRow["YTDGoalGMPct"]) * 100) + tab;
            }

            xlsDtl +=   String.Format("{0:c}", SoCustRow["SalesDollarsWeb"]) + tab +
                        String.Format("{0:c}", SoCustRow["MarginDollarsWeb"]) + tab +
                        String.Format("{0:N2}%", SoCustRow["MarginPctWeb"]) + tab +
                        String.Format("{0:N2}%", SoCustRow["WebPctSales"]);

            swExcel.WriteLine(xlsDtl);
        }
        #endregion

        swExcel.Close();

        //Response.Redirect("ExcelExport.aspx?Filename=../DashboardDrilldown/Excel/" + xlsFile, true);

        //Downloading Process
        FileStream fileStream = File.Open(ExportFile, FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(ExportFile));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..//DashboardDrilldown//Excel//"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(strSession))
                    fn.Delete();
            }

            return "";
        }
        catch (Exception ex) { return ""; }
    }
}
