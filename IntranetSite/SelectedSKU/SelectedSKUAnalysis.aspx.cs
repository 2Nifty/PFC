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
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;

public partial class SelectedSKUAnalysis : System.Web.UI.Page
{
    SqlConnection cnERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
    DataSet dsSKU = new DataSet();

    private string sortExpression = string.Empty;
    int pageSize = 23;

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(SelectedSKUAnalysis));

        if (!IsPostBack)
        {
            GetDataSet();
        }
    }

    #region Get DataSet & Bind GridView
    protected void GetDataSet()
    {
        string  _ProcName,
                _StrLoc = Request.QueryString["StrLoc"].ToString().Trim(),
                _EndLoc = Request.QueryString["EndLoc"].ToString().Trim(),
                _LocList = Request.QueryString["LocList"].ToString().Trim(),
                _StrCat = Request.QueryString["StrCat"].ToString().Trim(),
                _EndCat = Request.QueryString["EndCat"].ToString().Trim(),
                _CatList = Request.QueryString["CatList"].ToString().Trim(),
                _StrSize = Request.QueryString["StrSize"].ToString().Trim(),
                _EndSize = Request.QueryString["EndSize"].ToString().Trim(),
                _SizeList = Request.QueryString["SizeList"].ToString().Trim(),
                _StrVar = Request.QueryString["StrVar"].ToString().Trim(),
                _EndVar = Request.QueryString["EndVar"].ToString().Trim(),
                _VarList = Request.QueryString["VarList"].ToString().Trim(),
                _StrCFV = Request.QueryString["StrCFV"].ToString().Trim(),
                _EndCFV = Request.QueryString["EndCFV"].ToString().Trim(),
                _CFVList = Request.QueryString["CFVList"].ToString().Trim(),
                _StrSVC = Request.QueryString["StrSVC"].ToString().Trim(),
                _EndSVC = Request.QueryString["EndSVC"].ToString().Trim(),
                _SVCList = Request.QueryString["SVCList"].ToString().Trim(),
                _StrWeb = Request.QueryString["StrWeb"].ToString().Trim(),
                _EndWeb = Request.QueryString["EndWeb"].ToString().Trim(),
                _StrDt = Request.QueryString["StrDt"].ToString().Trim(),
                _EndDt = Request.QueryString["EndDt"].ToString().Trim(),
                _DtParam = Request.QueryString["DateCtl"].ToString().Trim();

        if (_StrLoc == "00")
            _ProcName = "pSelectedSKUCorp";
        else
            _ProcName = "pSelectedSKU";

        #region Call SP to get Dataset for GridView
        try
        {
            dsSKU = SqlHelper.ExecuteDataset(cnERP, _ProcName,
                                                    new SqlParameter("@StrLoc", _StrLoc),
                                                    new SqlParameter("@EndLoc", _EndLoc),
                                                    new SqlParameter("@LocList", _LocList),
                                                    new SqlParameter("@StrCat", _StrCat),
                                                    new SqlParameter("@EndCat", _EndCat),
                                                    new SqlParameter("@CatList", _CatList),
                                                    new SqlParameter("@StrSize", _StrSize),
                                                    new SqlParameter("@EndSize", _EndSize),
                                                    new SqlParameter("@SizeList", _SizeList),
                                                    new SqlParameter("@StrVar", _StrVar),
                                                    new SqlParameter("@EndVar", _EndVar),
                                                    new SqlParameter("@VarList", _VarList),
                                                    new SqlParameter("@StrCFV", _StrCFV),
                                                    new SqlParameter("@EndCFV", _EndCFV),
                                                    new SqlParameter("@CFVList", _CFVList),
                                                    new SqlParameter("@StrSVC", _StrSVC),
                                                    new SqlParameter("@EndSVC", _EndSVC),
                                                    new SqlParameter("@SVCList", _SVCList),
                                                    new SqlParameter("@StrWeb", _StrWeb),
                                                    new SqlParameter("@EndWeb", _EndWeb),
                                                    new SqlParameter("@StrDt", _StrDt),
                                                    new SqlParameter("@EndDt", _EndDt),
                                                    new SqlParameter("@DtParam", _DtParam));
        }
        catch (Exception ex)
        {
            DisplayStatusMessage("Error executing stored procedure (" + _ProcName + ")", "fail");
            //DisplayStatusMessage(ex.ToString(), "fail");
            return;
        }

        if (dsSKU.Tables[0].Rows.Count > 0)
        {
            Session["dsSelectedSKU"] = dsSKU;
            BindGridView();
//            gvPager.InitPager(gvSKU, pageSize);
        }
        else
            DisplayStatusMessage("No SKUs", "fail");

        pnlGrid.Update();
        #endregion
    }

    protected void BindGridView()
    {
        dsSKU = (DataSet)Session["dsSelectedSKU"];
        sortExpression = ((hidSort.Value != "") ? hidSort.Value : "ItemNo,Location ASC");
        dsSKU.Tables[0].DefaultView.Sort = sortExpression;
        gvSKU.DataSource = dsSKU.Tables[0].DefaultView.ToTable();
        gvSKU.DataBind();
        gvPager.InitPager(gvSKU, pageSize);
        pnlGrid.Update();
    }

    protected void gvSKU_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            ////Hard coded values to test cell widths against max field length
            //e.Row.Cells[2].Text = "***** ***** Item Desc is 50 chara ters **** *****";
            //e.Row.Cells[3].Text = "*Item Size is 29 chara ters *";
            //e.Row.Cells[6].Text = "9 999 999";
            //e.Row.Cells[7].Text = "9 999 999";
            //e.Row.Cells[8].Text = "9 999 999";
            //e.Row.Cells[9].Text = "999 999 999";
            //e.Row.Cells[10].Text = "999 999 999";
            //e.Row.Cells[11].Text = "999 999 999";
            //e.Row.Cells[12].Text = "999 999 999";
            //e.Row.Cells[13].Text = "$999 999 99";
            //e.Row.Cells[14].Text = "$999 999 99";
            //e.Row.Cells[15].Text = "999 999";
            //e.Row.Cells[16].Text = "999 999";
            //e.Row.Cells[17].Text = "999 999";
            //e.Row.Cells[18].Text = "999 999";
            //e.Row.Cells[27].Text = "$999 999 99";
            //e.Row.Cells[28].Text = "$999 999 99";
            //e.Row.Cells[29].Text = "$999 999 99";
            //e.Row.Cells[30].Text = "$999 999 99";
            //e.Row.Cells[45].Text = "07318 016 00085";
        }
    }

    protected void gvSKU_Sorting(object sender, GridViewSortEventArgs e)
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

        hidSort.Value = e.SortExpression + " " + hidSort.Attributes["sortType"].ToString();
        BindGridView();
    }

    protected void gvPager_PageChanged(Object sender, System.EventArgs e)
    {
        gvSKU.PageIndex = gvPager.GotoPageNumber;
        BindGridView();
    }
    #endregion

    #region Excel Export
    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        DataTable dtExcel = new DataTable();

        String xlsFile = "SelectedSKU" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//Common//ExcelUploads//") + xlsFile;
        FileInfo fnExcel = new FileInfo(ExportFile);
        StreamWriter reportWriter = fnExcel.CreateText();

        string headerContent = string.Empty;
        string excelContent = string.Empty;

        try
        {
            dsSKU = (DataSet)Session["dsSelectedSKU"];
        }
        catch (Exception ex)
        {
        }

        if (dsSKU.Tables[0] != null && dsSKU.Tables[0].DefaultView.ToTable().Rows.Count > 0)
        {
            sortExpression = ((hidSort.Value != "") ? hidSort.Value : "ItemNo, Location ASC");
            dsSKU.Tables[0].DefaultView.Sort = sortExpression;

            //Headers
            headerContent = "<table border='1' width='100%'>";
            headerContent += "<tr><th colspan='46' style='color:blue' align=left><center><b>Run By: " + Session["UserName"].ToString() +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Selected SKU Analysis" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Run Date: " + DateTime.Now.ToShortDateString() + "</b></center></th></tr>";

            headerContent += "<tr><th nowrap><center>Loc</center></th>" +
                                 "<th nowrap><center>Item No</center></th>" +
                                 //"<th nowrap><center>Desc</center></th>" +
                                 "<th nowrap><center>Cat Desc</center></th>" +
                                 "<th nowrap><center>Item Size</center></th>" +
                                 "<th nowrap><center>Plat</center></th>" +
                                 "<th nowrap><center>Qty OH</center></th>" +
                                 "<th nowrap><center>Qty Avl</center></th>" +
                                 "<th nowrap><center>ROP</center></th>" +
                                 "<th nowrap><center>SVC</center></th>" +
                                 "<th nowrap><center>CFV</center></th>" +
                                 "<th nowrap><center>Avg Cost/Alt UM</center></th>" +
                                 "<th nowrap><center>OH Cost Ext</center></th>" +
                                 "<th nowrap><center>Avg Value/LB</center></th>" +
                                 //"<th nowrap><center>Cntr Qty/UM</center></th>" +
                                 //"<th nowrap><center>Super Qty/UM</center></th>" +
                                 "<th nowrap><center>Cntr Qty</center></th>" +
                                 "<th nowrap><center>UM</center></th>" +
                                 "<th nowrap><center>Super Qty</center></th>" +
                                 "<th nowrap><center>UM</center></th>" +
                                 "<th nowrap><center>UnRcvd PO Qty</center></th>" +
                                 "<th nowrap><center>Trf Qty</center></th>" +
                                 "<th nowrap><center>Prod Qty</center></th>" +
                                 "<th nowrap><center>OTW Qty</center></th>" +
                                 "<th nowrap><center>100pc Wght</center></th>" +
                                 "<th nowrap><center>Net Wght</center></th>" +
                                 "<th nowrap><center>OH Net Ext</center></th>" +
                                 "<th nowrap><center>Gross Wght</center></th>" +
                                 "<th nowrap><center>Capacity</center></th>" +
                                 "<th nowrap><center>Routing</center></th>" +
                                 "<th nowrap><center>Stock Code</center></th>" +
                                 "<th nowrap><center>PPI Code</center></th>" +
                                 "<th nowrap><center>UPC Code</center></th>" +
                                 "<th nowrap><center>Parent BOM</center></th>" +
                                 "<th nowrap><center>Create Dt</center></th>" +
                                 "<th nowrap><center>List Price Alt</center></th>" +
                                 "<th nowrap><center>Smooth Avg Cost Alt</center></th>" +
                                 "<th nowrap><center>Price Cost Alt</center></th>" +
                                 "<th nowrap><center>Repl Cost Alt</center></th>" +
                                 "<th nowrap><center>Buy Grp No</center></th>" +
                                 "<th nowrap><center>Rpt Grp No</center></th>" +
                                 "<th nowrap><center>Rpt Sort</center></th>" +
                                 "<th nowrap><center>Web Ind</center></th>" +
                                 "<th nowrap><center>FQA Ind</center></th>" +
                                 "<th nowrap><center>Cert Req</center></th>" +
                                 "<th nowrap><center>Prop 65</center></th>" +
                                 "<th nowrap><center>Cust No</center></th>" +
                                 "<th nowrap><center>Stock SKU</center></th>" +
                                 "<th nowrap><center>Harm Cd</center></th></tr>";
            reportWriter.Write(headerContent);

            foreach (DataRow Row in dsSKU.Tables[0].DefaultView.ToTable().Rows)
            {
                //Detail line
                excelContent = "<tr><td align=center>" + Row["Location"].ToString() + "</td>" +
                                   "<td align=center>" + Row["ItemNo"] + "</td>" +
                                   //"<td align=left style='mso-number-format:\\@;'>" + Row["ItemDesc"] + "</td>" +
                                   "<td align=left>" + Row["CatDesc"] + "</td>" +
                                   "<td align=left style='mso-number-format:\\@;'>" + Row["ItemSize"] + "</td>" +
                                   "<td align=left>" + Row["Finish"] + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["QtyOH"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["QtyAvail"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n1}", Row["ReOrderPoint"]) + "</td>" +
                                   "<td align=center>" + Row["SalesVelocityCd"] + "</td>" +
                                   "<td align=center>" + Row["CorpFixedVelocity"] + "</td>" +
                                   "<td align=right>" + String.Format("{0:n2}", Row["AvgCostaltUM"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n2}", Row["ExtCostOH"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n3}", Row["NetAvgLBVal"]) + "</td>" +
                                   //"<td align=right>" + Row["AltSell"] + "</td>" +
                                   //"<td align=right>" + Row["SuperUMQty"] + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["BaseStkQty"]) + "</td>" +
                                   "<td align=left>" + Row["AltSellUM"] + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["SuperQty"]) + "</td>" +
                                   "<td align=left>" + Row["SuperUM"] + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["UnRcvdPOQty"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["TrfQty"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["ProdOrdQty"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["OWQty"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n2}", Row["HundredWght"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n3}", Row["NetWght"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n3}", Row["ExtNetWghtOH"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n3}", Row["GrossWght"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["Capacity"]) + "</td>" +
                                   "<td align=right style='mso-number-format:\\@;'>" + Row["RoutingNo"] + "</td>" +
                                   "<td align=center>" + Row["StockInd"] + "</td>" +
                                   "<td align=center>" + Row["PPICode"] + "</td>" +
                                   "<td align=center>" + Row["UPCCd"] + "</td>" +
                                   "<td align=center>" + Row["ParentProdNo"] + "</td>" +
                                   "<td align=center>" + String.Format("{0:MM/dd/yyyy}", Row["EntryDt"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n2}", Row["ListPriceAlt"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n2}", Row["SmoothAvgAlt"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n2}", Row["PriceCostalt"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n2}", Row["ReplacementCostAlt"]) + "</td>" +
                                   "<td align=center>" + Row["BuyGroupNo"] + "</td>" +
                                   "<td align=center>" + Row["ReportGroupNo"] + "</td>" +
                                   "<td align=center>" + Row["ReportSort"] + "</td>" +
                                   "<td align=center>" + Row["WebEnabledInd"] + "</td>" +
                                   "<td align=center>" + Row["FQAInd"] + "</td>" +
                                   "<td align=center>" + Row["CertRequiredInd"] + "</td>" +
                                   "<td align=center>" + Row["Prop65"] + "</td>" +
                                   "<td align=center>" + Row["IMCustNo"] + "</td>" +
                                   "<td align=center>" + Row["SVCInd"] + "</td>" +
                                   "<td align=center>" + Row["Tariff"] + "</td></tr>";

                reportWriter.Write(excelContent);
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

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string DelExcel(string strSession)
    {
        //Delete the excel file(s)
        try
        {
            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..//Common//ExcelUploads//"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains("SelectedSKU" + strSession))
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
        else
        {
            lblMessage.ForeColor = System.Drawing.Color.Black;
            lblMessage.Text = message;
        }

        pnlStatus.Update();
    }

    [Ajax.AjaxMethod()]
    public string Close()
    {
        Session["dsSelectedSKU"] = null;    //Clear the session variable
        return "";
    }
}
