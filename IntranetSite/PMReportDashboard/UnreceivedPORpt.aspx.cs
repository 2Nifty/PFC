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

public partial class UnreceivedPORpt : System.Web.UI.Page
{
    SqlConnection cnPERP;
    DataSet dsUnrcvdPO;
    DataTable dtUnrcvdPO, dtUnrcvdPOCat;
    GridView dvExcel = new GridView();

    Decimal QtyOrd, QtyRcvd, QtyDue, ExtCost;
    Decimal TotLines, TotQtyOrd, TotQtyRcvd, TotQtyDue, TotExtCost;
    string strSQL, RowFilter, PreviewURL;
    //Boolean Header = true;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        cnPERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
        Ajax.Utility.RegisterTypeForAjax(typeof(UnreceivedPORpt));

        if (!Page.IsPostBack)
        {
            Session["UserName"] = ((Session["UserName"] != null) ? Session["UserName"].ToString() : "[null]");
            ClearGrid();
        }
    }

    #region Filters
    protected void txtCat_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtCat.Text.ToString()))
            txtCat.Text = txtCat.Text.PadLeft(5, '0').ToString();
        smUnrcvdPO.SetFocus(txtSize);
    }

    protected void txtSize_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtSize.Text.ToString()))
            txtSize.Text = txtSize.Text.PadLeft(4, '0').ToString();
        smUnrcvdPO.SetFocus(txtVar);
    }

    protected void txtVar_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtVar.Text.ToString()))
            txtVar.Text = txtVar.Text.PadLeft(3, '0').ToString();
        smUnrcvdPO.SetFocus(btnSubmit);
    }

    protected void btnSubmit_Click(object sender, ImageClickEventArgs e)
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        Pager1.Visible = false;
        dgUnrcvdPOCat.CurrentPageIndex = 0;
        pnlPager.Update();

        PreviewURL = "PMReportDashboard/UnreceivedPOPreview.aspx?Category=";

        RowFilter = string.Empty;

        if (!string.IsNullOrEmpty(txtCat.Text.ToString()))
        {
            RowFilter = RowFilter + "CatNo = '" + txtCat.Text.ToString() + "'";
            PreviewURL = PreviewURL + txtCat.Text.ToString();
        }

        PreviewURL = PreviewURL + "&Size=";
        if (!string.IsNullOrEmpty(txtSize.Text.ToString()))
        {
            if (!string.IsNullOrEmpty(RowFilter.ToString())) RowFilter = RowFilter + " AND ";
            RowFilter = RowFilter + "SizeNo = '" + txtSize.Text.ToString() + "'";
            PreviewURL = PreviewURL + txtSize.Text.ToString();
        }

        PreviewURL = PreviewURL + "&Variance=";
        if (!string.IsNullOrEmpty(txtVar.Text.ToString()))
        {
            if (!string.IsNullOrEmpty(RowFilter.ToString())) RowFilter = RowFilter + " AND ";
            RowFilter = RowFilter + "VarianceNo = '" + txtVar.Text.ToString() + "'";
            PreviewURL = PreviewURL + txtVar.Text.ToString();
        }

        hidFilter.Value = RowFilter;

        PrintDialogue1.PageUrl = PreviewURL;
        pnlExport.Update();

        dsUnrcvdPO = SqlHelper.ExecuteDataset(cnPERP, "pPORptUnRcvd");

        if (!string.IsNullOrEmpty(RowFilter.ToString()))
            dsUnrcvdPO.Tables[0].DefaultView.RowFilter = RowFilter.ToString();

        Session["dtPO"] = dsUnrcvdPO.Tables[0].DefaultView.ToTable();

        if (dsUnrcvdPO.Tables[0].DefaultView.ToTable().Rows.Count > 0)
        {
            BindDataGrid();
        }
        else
        {
            DisplayStatusMessage("No matching records found", "fail");
            ClearGrid();
        }
    }
    #endregion

    #region Bind Grid
    private void BindDataGrid()
    {
        dtUnrcvdPO = (DataTable)Session["dtPO"];

        TotLines = dtUnrcvdPO.DefaultView.ToTable().Rows.Count;
        lblTotLines.Text = "Total number of lines: " + String.Format("{0:n0}", TotLines);
        TotQtyOrd = Convert.ToDecimal(dtUnrcvdPO.Compute("sum(QtyOrdered)", ""));
        lblTotQtyOrd.Text = String.Format("{0:n0}", TotQtyOrd);
        TotQtyRcvd = Convert.ToDecimal(dtUnrcvdPO.Compute("sum(QtyReceived)", ""));
        lblTotQtyRcvd.Text = String.Format("{0:n0}", TotQtyRcvd);
        TotQtyDue = Convert.ToDecimal(dtUnrcvdPO.Compute("sum(QtyDue)", ""));
        lblTotQtyDue.Text = String.Format("{0:n0}", TotQtyDue);
        TotExtCost = Convert.ToDecimal(dtUnrcvdPO.Compute("sum(ExtendedCost)", ""));
        lblTotExtCost.Text = String.Format("{0:c}", TotExtCost);
        tblGrdTotals.Visible = true;

        dtUnrcvdPOCat = SelectDistinct(dtUnrcvdPO.DefaultView.ToTable(), "CatNo");
        //if (!string.IsNullOrEmpty(txtCat.Text.ToString()))
        //    dtUnrcvdPOCat.DefaultView.RowFilter = "CatNo = '" + txtCat.Text.ToString() + "'";
        dtUnrcvdPOCat.DefaultView.Sort = "CatNo ASC";
        dgUnrcvdPOCat.DataSource = dtUnrcvdPOCat.DefaultView.ToTable();
        dgUnrcvdPOCat.AllowPaging = true;
        dgUnrcvdPOCat.DataBind();

        pnlRptGrid.Update();

        Pager1.InitPager(dgUnrcvdPOCat, 1);
        Pager1.Visible = true;
        pnlPager.Update();
    }

    protected void PageChanged(Object sender, System.EventArgs e)
    {
        dgUnrcvdPOCat.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void dgUnrcvdPOCat_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            DataGrid _dgUnrcvdPODtl = e.Item.FindControl("dgUnrcvdPODtl") as DataGrid;

            string CatNo = dtUnrcvdPOCat.DefaultView.ToTable().Rows[e.Item.DataSetIndex]["CatNo"].ToString().Trim();

            dtUnrcvdPO = (DataTable)Session["dtPO"];
            if (!string.IsNullOrEmpty(hidFilter.Value.ToString()))
                dtUnrcvdPO.DefaultView.RowFilter = hidFilter.Value + " AND CatNo = '" + CatNo.ToString() + "'";
            else
                dtUnrcvdPO.DefaultView.RowFilter = "CatNo = '" + CatNo.ToString() + "'";

            dtUnrcvdPO.DefaultView.Sort = "CatNo ASC, ItemNo ASC, DocNo ASC, Loc ASC";

            if (dtUnrcvdPO.DefaultView.ToTable().Rows.Count > 0)
            {
                _dgUnrcvdPODtl.DataSource = dtUnrcvdPO.DefaultView.ToTable();
                //_dgUnrcvdPODtl.ShowHeader = Header;
                _dgUnrcvdPODtl.DataBind();
                pnlRptGrid.Update();
                //Header = false;
            }
        }

        QtyOrd = 0;
        QtyRcvd = 0;
        QtyDue = 0;
        ExtCost = 0;
    }

    protected void dgUnrcvdPODtl_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        dtUnrcvdPO = (DataTable)Session["dtPO"];

        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            Label _lblCost = e.Item.FindControl("lblCost") as Label;
            _lblCost.Text = String.Format("{0:c}", dtUnrcvdPO.DefaultView.ToTable().Rows[e.Item.DataSetIndex]["AlternateCost"]) + "/" + dtUnrcvdPO.DefaultView.ToTable().Rows[e.Item.DataSetIndex]["CostUM"].ToString().Trim();
            QtyOrd = QtyOrd + Convert.ToDecimal(e.Item.Cells[8].Text);
            QtyRcvd = QtyRcvd + Convert.ToDecimal(e.Item.Cells[9].Text);
            QtyDue = QtyDue + Convert.ToDecimal(e.Item.Cells[13].Text);
            ExtCost = ExtCost + Convert.ToDecimal(e.Item.Cells[15].Text);
            e.Item.Cells[15].Text = String.Format("{0:c}", Convert.ToDecimal(e.Item.Cells[15].Text));
        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].Text = dtUnrcvdPO.DefaultView.ToTable().Rows[0]["CatDesc"].ToString().Trim();
            e.Item.Cells[0].HorizontalAlign = HorizontalAlign.Left;
            e.Item.Cells[2].Text = "Number of lines: " + dtUnrcvdPO.DefaultView.ToTable().Rows.Count.ToString();
            e.Item.Cells[2].HorizontalAlign = HorizontalAlign.Left;
            e.Item.Cells[8].Text = String.Format("{0:n0}", QtyOrd);
            e.Item.Cells[8].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[9].Text = String.Format("{0:n0}", QtyRcvd);
            e.Item.Cells[9].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[13].Text = String.Format("{0:n0}", QtyDue);
            e.Item.Cells[13].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[15].Text = String.Format("{0:c}", ExtCost);
            e.Item.Cells[15].HorizontalAlign = HorizontalAlign.Right;
        }
    }
    #endregion

    protected void btnCancel_Click(object sender, ImageClickEventArgs e)
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        ClearGrid();
    }

    private void ClearGrid()
    {
        txtCat.Text = "";
        txtSize.Text = "";
        txtVar.Text = "";
        smUnrcvdPO.SetFocus(txtCat);

        Session["dtPO"] = "";
        dgUnrcvdPOCat.DataSource = "";
        dgUnrcvdPOCat.AllowPaging = false;
        dgUnrcvdPOCat.DataBind();

        //Header = true;
        tblGrdTotals.Visible = false;

        pnlRptGrid.Update();

        Pager1.Visible = false;
        dgUnrcvdPOCat.CurrentPageIndex = 0;
        pnlPager.Update();

        PreviewURL = "PMReportDashboard/UnreceivedPOPreview.aspx?Category=&Size=&Variance=";
        PrintDialogue1.PageUrl = PreviewURL;
        pnlExport.Update();
    }

    #region Export

    #region Orig Export (commented)
    //protected void btnExport_Click(object sender, ImageClickEventArgs e)
    //{
    //    //BindDataGrid();

    //    dtUnrcvdPO = (DataTable)Session["dtPO"];

    //    char tab = '\t';

    //    String xlsFile = "UnrcvdPO" + Session["SessionID"] + ".xls";
    //    String ExportFile = Server.MapPath("..//Common//ExcelUploads//") + xlsFile;

    //    StreamWriter swExcel = new StreamWriter(ExportFile, false);

    //    swExcel.WriteLine("Category Description" + tab + "Item Number" + tab + "Size" + tab + "Doc No" + tab + "Status" + tab +
    //                      "Vendor" + tab + "Loc" + tab + "Super Eqv Qty" + tab + "Qty Ord" + tab + "Qty Rcvd" + tab +
    //                      "Req Rcpt Date" + tab + "Planned Rcpt Date" + tab + "Expected Rcpt Date" + tab + "Qty Due" + tab +
    //                      "Cost" + tab + "Ext Cost");

    //    foreach (DataRow Row in dtUnrcvdPO.DefaultView.ToTable().Rows)
    //        swExcel.WriteLine(Row["CatDesc"].ToString() + tab + Row["ItemNo"].ToString() + tab + Row["ItemSize"].ToString() + tab +
    //                          Row["DocNo"].ToString() + tab + Row["POStatusCd"].ToString() + tab + Row["VendorCd"].ToString() + tab +
    //                          Row["Loc"].ToString() + tab + String.Format("{0:n0}", Row["QtySuperEquiv"]) + tab +
    //                          String.Format("{0:n0}", Row["QtyOrdered"]) + tab + String.Format("{0:n0}", Row["QtyReceived"]) + tab +
    //                          String.Format("{0:MM/dd/yyyy}", Row["RequestedDt"]) + tab + String.Format("{0:MM/dd/yyyy}", Row["PlannedRcptDt"]) + tab +
    //                          String.Format("{0:MM/dd/yyyy}", Row["ExpectedDt"]) + tab + String.Format("{0:n0}", Row["QtyDue"]) + tab +
    //                          String.Format("{0:c}", Row["AlternateCost"]) + "/" + Row["CostUM"] + tab + String.Format("{0:c}", Row["ExtendedCost"]));

    //    swExcel.Close();

    //    string URL = "UnreceivedPOXLS.aspx?Filename=../Common/ExcelUploads/" + xlsFile;
    //    string script = "window.open('" + URL + "' ,'export','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	";
    //    ScriptManager.RegisterClientScriptBlock(btnExport, btnExport.GetType(), "export", script, true);
    //}
    #endregion

    #region New Export with Row Loop
    protected void btnExport_Click(object sender, ImageClickEventArgs e)
    {
        DataTable dtTotExcel = new DataTable();

        String xlsFile = "UnrcvdPO" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//Common//ExcelUploads//") + xlsFile;
        FileInfo fnExcel = new FileInfo(ExportFile);
        StreamWriter reportWriter = fnExcel.CreateText();

        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;
        string saveCat = string.Empty;
        string saveDesc = string.Empty;

        try
        {
            dtUnrcvdPO = (DataTable)Session["dtPO"];
        }
        catch (Exception ex)
        {
        }

        if (dtUnrcvdPO != null && dtUnrcvdPO.DefaultView.ToTable().Rows.Count > 0)
        {
            dtUnrcvdPO.DefaultView.Sort = "CatNo ASC, ItemNo ASC, DocNo ASC, Loc ASC";

            //Headers
            headerContent = "<table border='1' width='100%'>";
            headerContent += "<tr><th colspan='16' style='color:blue' align=left><center>Unreceived Purchase Orders By Category</center></th></tr>";
            headerContent += "<tr><th nowrap><center>Category Description</center></th>" +
                                 "<th nowrap><center>Item No</center></th>" +
                                 "<th nowrap><center>Size</center></th>" +
                                 "<th nowrap><center>Doc No</center></th>" +
                                 "<th nowrap><center>Status</center></th>" +
                                 "<th nowrap><center>Vendor</center></th>" +
                                 "<th nowrap><center>Loc</center></th>" +
                                 "<th nowrap><center>Super Eqv Qty</center></th>" +
                                 "<th nowrap><center>Qty Ord</center></th>" +
                                 "<th nowrap><center>Qty Rcvd</center></th>" +
                                 "<th nowrap><center>Req Rcpt Date</center></th>" +
                                 "<th nowrap><center>Planned Rcpt Date</center></th>" +
                                 "<th nowrap><center>Expected Rcpt Date</center></th>" +
                                 "<th nowrap><center>Qty Due</center></th>" +
                                 "<th nowrap><center>Cost</center></th>" +
                                 "<th nowrap><center>Ext Cost</center></th></tr>";
            reportWriter.Write(headerContent);

            foreach (DataRow Row in dtUnrcvdPO.DefaultView.ToTable().Rows)
            {
                if (string.IsNullOrEmpty(saveCat))
                {
                    saveCat = Row["CatNo"].ToString();
                    saveDesc = Row["CatDesc"].ToString();
                }

                //Category Sub-Totals
                if (saveCat != Row["CatNo"].ToString())
                {
                    dtTotExcel = (DataTable)Session["dtPO"];
                    dtTotExcel.DefaultView.RowFilter = "CatNo = '" + saveCat.ToString() + "'";

                    QtyOrd = Convert.ToDecimal(dtTotExcel.DefaultView.ToTable().Compute("sum(QtyOrdered)", ""));
                    QtyRcvd = Convert.ToDecimal(dtTotExcel.DefaultView.ToTable().Compute("sum(QtyReceived)", ""));
                    QtyDue = Convert.ToDecimal(dtTotExcel.DefaultView.ToTable().Compute("sum(QtyDue)", ""));
                    ExtCost = Convert.ToDecimal(dtTotExcel.DefaultView.ToTable().Compute("sum(ExtendedCost)", ""));

                    footerContent = "<tr ><td align=left><b>" + saveDesc.ToString() + "</b></td>" +
                                         "<td></td>" +
                                         "<td align=left><b>Number of lines: " + String.Format("{0:n0}", dtTotExcel.DefaultView.ToTable().Rows.Count) + "</b></td>" +
                                         "<td></td>" +
                                         "<td></td>" +
                                         "<td></td>" +
                                         "<td></td>" +
                                         "<td></td>" +
                                         "<td align=right><b>" + String.Format("{0:n0}", QtyOrd) + "</b></td>" +
                                         "<td align=right><b>" + String.Format("{0:n0}", QtyRcvd) + "</b></td>" +
                                         "<td></td>" +
                                         "<td></td>" +
                                         "<td></td>" +
                                         "<td align=right><b>" + String.Format("{0:n0}", QtyDue) + "</b></td>" +
                                         "<td></td>" +
                                         "<td align=right><b>" + String.Format("{0:c}", ExtCost) + "</b></td></tr>";
                    reportWriter.Write(footerContent);

                    saveCat = Row["CatNo"].ToString();
                    saveDesc = Row["CatDesc"].ToString();
                }

                //Detail line
                excelContent = "<tr><td align=left>" + Row["CatDesc"].ToString() + "</td>" +
                                   "<td align=center>" + Row["ItemNo"] + "</td>" +
                                   "<td align=left style='mso-number-format:\\@;'>" + Row["ItemSize"] + "</td>" +
                                   "<td align=center>" + Row["DocNo"] + "</td>" +
                                   "<td align=center>" + Row["POStatusCd"] + "</td>" +
                                   "<td align=center>" + Row["VendorCd"] + "</td>" +
                                   "<td align=center>" + Row["Loc"] + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["QtySuperEquiv"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["QtyOrdered"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["QtyReceived"]) + "</td>" +
                                   "<td align=center>" + String.Format("{0:MM/dd/yyyy}", Row["RequestedDt"]) + "</td>" +
                                   "<td align=center>" + String.Format("{0:MM/dd/yyyy}", Row["PlannedRcptDt"]) + "</td>" +
                                   "<td align=center>" + String.Format("{0:MM/dd/yyyy}", Row["ExpectedDt"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["QtyDue"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:c}", Row["AlternateCost"]) + "/" + Row["CostUM"] + "</td>" +
                                   "<td align=right>" + String.Format("{0:c}", Row["ExtendedCost"]) + "</td></tr>";
                reportWriter.Write(excelContent);
            }

            //Final Category Sub-Totals
            dtTotExcel = (DataTable)Session["dtPO"];
            dtTotExcel.DefaultView.RowFilter = "CatNo = '" + saveCat.ToString() + "'";

            QtyOrd = Convert.ToDecimal(dtTotExcel.DefaultView.ToTable().Compute("sum(QtyOrdered)", ""));
            QtyRcvd = Convert.ToDecimal(dtTotExcel.DefaultView.ToTable().Compute("sum(QtyReceived)", ""));
            QtyDue = Convert.ToDecimal(dtTotExcel.DefaultView.ToTable().Compute("sum(QtyDue)", ""));
            ExtCost = Convert.ToDecimal(dtTotExcel.DefaultView.ToTable().Compute("sum(ExtendedCost)", ""));

            footerContent = "<tr ><td align=left><b>" + saveDesc.ToString() + "</b></td>" +
                                 "<td></td>" +
                                 "<td align=left><b>Number of lines: " + String.Format("{0:n0}", dtTotExcel.DefaultView.ToTable().Rows.Count) + "</b></td>" +
                                 "<td></td>" +
                                 "<td></td>" +
                                 "<td></td>" +
                                 "<td></td>" +
                                 "<td></td>" +
                                 "<td align=right><b>" + String.Format("{0:n0}", QtyOrd) + "</b></td>" +
                                 "<td align=right><b>" + String.Format("{0:n0}", QtyRcvd) + "</b></td>" +
                                 "<td></td>" +
                                 "<td></td>" +
                                 "<td></td>" +
                                 "<td align=right><b>" + String.Format("{0:n0}", QtyDue) + "</b></td>" +
                                 "<td></td>" +
                                 "<td align=right><b>" + String.Format("{0:c}", ExtCost) + "</b></td></tr>";
            reportWriter.Write(footerContent);

            //Grand Totals
            dtUnrcvdPO = (DataTable)Session["dtPO"];
            TotQtyOrd = Convert.ToDecimal(dtUnrcvdPO.Compute("sum(QtyOrdered)", ""));
            TotQtyRcvd = Convert.ToDecimal(dtUnrcvdPO.Compute("sum(QtyReceived)", ""));
            TotQtyDue = Convert.ToDecimal(dtUnrcvdPO.Compute("sum(QtyDue)", ""));
            TotExtCost = Convert.ToDecimal(dtUnrcvdPO.Compute("sum(ExtendedCost)", ""));

            footerContent = "<tr ><td align=left><b>Grand Totals for all Categories</b></td>" +
                                 "<td></td>" +
                                 "<td align=left><b>Number of lines: " + String.Format("{0:n0}", dtUnrcvdPO.Rows.Count) + "</b></td>" +
                                 "<td></td>" +
                                 "<td></td>" +
                                 "<td></td>" +
                                 "<td></td>" +
                                 "<td></td>" +
                                 "<td align=right><b>" + String.Format("{0:n0}", TotQtyOrd) + "</b></td>" +
                                 "<td align=right><b>" + String.Format("{0:n0}", TotQtyRcvd) + "</b></td>" +
                                 "<td></td>" +
                                 "<td></td>" +
                                 "<td></td>" +
                                 "<td align=right><b>" + String.Format("{0:n0}", TotQtyDue) + "</b></td>" +
                                 "<td></td>" +
                                 "<td align=right><b>" + String.Format("{0:c}", TotExtCost) + "</b></td></tr>";
            reportWriter.WriteLine(footerContent);
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
    #endregion

    #region New Export with DataView (commented)
    //protected void btnExport_Click(object sender, ImageClickEventArgs e)
    //{
    //    DataTable dtTotExcel = new DataTable();

    //    String xlsFile = "UnrcvdPO" + Session["SessionID"] + ".xls";
    //    String ExportFile = Server.MapPath("..//Common//ExcelUploads//") + xlsFile;
    //    FileInfo fnExcel = new FileInfo(ExportFile);
    //    StreamWriter reportWriter = fnExcel.CreateText();

    //    string styleSheet = "<style>.text { mso-number-format:\\@; } </style>";
    //    string headerContent = "<table border='1' width='100%'><tr><th colspan='16' style='color:blue' align=left><center>Unreceived Purchase Orders By Category</center></th></tr>";
    //    string excelContent = string.Empty;

    //    try
    //    {
    //        dtUnrcvdPO = (DataTable)Session["dtPO"];
    //    }
    //    catch (Exception ex)
    //    {
    //    }

    //    if (dtUnrcvdPO != null && dtUnrcvdPO.DefaultView.ToTable().Rows.Count > 0)
    //    {
    //        dtUnrcvdPO.DefaultView.Sort = "CatNo ASC, ItemNo ASC, DocNo ASC, Loc ASC";

    //        dvExcel.AutoGenerateColumns = false;
    //        dvExcel.ShowHeader = true;
    //        dvExcel.ShowFooter = true;
    //        dvExcel.RowDataBound += new GridViewRowEventHandler(dvExcel_RowDataBound);

    //        BoundField bfExcel = new BoundField();
    //        bfExcel.HeaderText = "Category Description";
    //        bfExcel.DataField = "CatDesc";
    //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
    //        dvExcel.Columns.Add(bfExcel);

    //        bfExcel = new BoundField();
    //        bfExcel.HeaderText = "Item No";
    //        bfExcel.DataField = "ItemNo";
    //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
    //        dvExcel.Columns.Add(bfExcel);

    //        bfExcel = new BoundField();
    //        bfExcel.HeaderText = "Size";
    //        bfExcel.DataField = "ItemSize";
    //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
    //        dvExcel.Columns.Add(bfExcel);

    //        bfExcel = new BoundField();
    //        bfExcel.HeaderText = "Doc No";
    //        bfExcel.DataField = "DocNo";
    //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
    //        dvExcel.Columns.Add(bfExcel);

    //        bfExcel = new BoundField();
    //        bfExcel.HeaderText = "Status";
    //        bfExcel.DataField = "POStatusCd";
    //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
    //        dvExcel.Columns.Add(bfExcel);

    //        bfExcel = new BoundField();
    //        bfExcel.HeaderText = "Vendor";
    //        bfExcel.DataField = "VendorCd";
    //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
    //        dvExcel.Columns.Add(bfExcel);

    //        bfExcel = new BoundField();
    //        bfExcel.HeaderText = "Loc";
    //        bfExcel.DataField = "Loc";
    //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
    //        dvExcel.Columns.Add(bfExcel);

    //        bfExcel = new BoundField();
    //        bfExcel.HeaderText = "Super Eqv Qty";
    //        bfExcel.DataField = "QtySuperEquiv";
    //        bfExcel.DataFormatString = "{0:n0}";
    //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
    //        dvExcel.Columns.Add(bfExcel);

    //        bfExcel = new BoundField();
    //        bfExcel.HeaderText = "Qty Ord";
    //        bfExcel.DataField = "QtyOrdered";
    //        bfExcel.DataFormatString = "{0:n0}";
    //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
    //        dvExcel.Columns.Add(bfExcel);

    //        bfExcel = new BoundField();
    //        bfExcel.HeaderText = "Qty Rcvd";
    //        bfExcel.DataField = "QtyReceived";
    //        bfExcel.DataFormatString = "{0:n0}";
    //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
    //        dvExcel.Columns.Add(bfExcel);

    //        bfExcel = new BoundField();
    //        bfExcel.HeaderText = "Req Rcpt Date";
    //        bfExcel.DataField = "RequestedDt";
    //        bfExcel.DataFormatString = "{0:MM/dd/yy}";
    //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
    //        dvExcel.Columns.Add(bfExcel);

    //        bfExcel = new BoundField();
    //        bfExcel.HeaderText = "Planned Rcpt Date";
    //        bfExcel.DataField = "PlannedRcptDt";
    //        bfExcel.DataFormatString = "{0:MM/dd/yy}";
    //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
    //        dvExcel.Columns.Add(bfExcel);

    //        bfExcel = new BoundField();
    //        bfExcel.HeaderText = "Expected Rcpt Date";
    //        bfExcel.DataField = "ExpectedDt";
    //        bfExcel.DataFormatString = "{0:MM/dd/yy}";
    //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
    //        dvExcel.Columns.Add(bfExcel);

    //        bfExcel = new BoundField();
    //        bfExcel.HeaderText = "Qty Due";
    //        bfExcel.DataField = "QtyDue";
    //        bfExcel.DataFormatString = "{0:n0}";
    //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
    //        dvExcel.Columns.Add(bfExcel);

    //        bfExcel = new BoundField();
    //        bfExcel.HeaderText = "Cost";
    //        bfExcel.DataField = "AlternateCost";
    //        bfExcel.DataFormatString = "{0:c}";
    //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
    //        dvExcel.Columns.Add(bfExcel);

    //        bfExcel = new BoundField();
    //        bfExcel.HeaderText = "Ext Cost";
    //        bfExcel.DataField = "ExtendedCost";
    //        bfExcel.DataFormatString = "{0:c}";
    //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
    //        dvExcel.Columns.Add(bfExcel);

    //        dvExcel.DataSource = dtUnrcvdPO.DefaultView.ToTable();
    //        dvExcel.DataBind();

    //        System.Text.StringBuilder sb = new System.Text.StringBuilder();
    //        System.IO.StringWriter sw = new System.IO.StringWriter(sb);
    //        HtmlTextWriter htw = new HtmlTextWriter(sw);
    //        dvExcel.RenderControl(htw);
    //        excelContent = sb.ToString();
    //    }
    //    else
    //    {
    //        excelContent = "<tr  ><th width='100%' align ='center' colspan='16' > No records found</th></tr> </table>";
    //    }

    //    reportWriter.WriteLine(styleSheet + headerContent + excelContent);
    //    reportWriter.Close();

    //    //Downloding Process
    //    FileStream fileStream = File.Open(ExportFile, FileMode.Open);
    //    Byte[] bytBytes = new Byte[fileStream.Length];
    //    fileStream.Read(bytBytes, 0, (int)fileStream.Length);
    //    fileStream.Close();

    //    Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(ExportFile));
    //    Response.ContentType = "application/octet-stream";
    //    Response.BinaryWrite(bytBytes);
    //    Response.End();
    //}

    //protected void dvExcel_RowDataBound(object sender, GridViewRowEventArgs e)
    //{
    //    if (e.Row.RowType == DataControlRowType.DataRow)
    //    {
    //        e.Row.Cells[2].Attributes.Add("class", "text");
    //    }
    //}
    #endregion

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
        pnlStatus.Update();
    }

    public DataTable SelectDistinct(DataTable SourceTable, string FieldName)
    {
        DataTable dt = new DataTable();
        dt.Columns.Add(FieldName, SourceTable.Columns[FieldName].DataType);

        object LastValue = null;
        foreach (DataRow dr in SourceTable.Select("", FieldName))
        {
            if (LastValue == null || !(ColumnEqual(LastValue, dr[FieldName])))
            {
                LastValue = dr[FieldName];
                dt.Rows.Add(new object[] { LastValue });
            }
        }
        return dt;
    }

    private bool ColumnEqual(object field1, object field2)
    {
        // Compares two values to see if they are equal. Also compares DBNULL.Value.
        // Note: If your DataTable contains object fields, then you must extend this
        // function to handle them in a meaningful way if you intend to group on them.

        if (field1 == DBNull.Value && field2 == DBNull.Value) //both are DBNull.Value
            return true;
        if (field1 == DBNull.Value || field2 == DBNull.Value) //only one is DBNull.Value
            return false;
        return (field1.Equals(field2));   //value type standard comparison
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void UnloadPage()
    {
        Session["dtPO"] = "";
    }
}
