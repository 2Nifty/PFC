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


public partial class TheoreticalFillRate : System.Web.UI.Page
{
    SqlConnection cnERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
    DataSet dsTheoretical = new DataSet();

    private string sortExpression = string.Empty;
    int pageSize = 19;


    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(TheoreticalFillRate));
        
        if (!IsPostBack)
        {
            lblRollingMonths.Text = "Rolling of Months: " + Request.QueryString["rollingMonths"].ToString();

            lblAddAvailWO.Text = "Include WO: " + Request.QueryString["addAvailWO"].ToString();
            lblAddAvailPO.Text = "Include PO: " + Request.QueryString["addAvailPO"].ToString();
            lblAddAvailTI.Text = "Include TI: " + Request.QueryString["addAvailTI"].ToString();


            string _startLocText = (Request.QueryString["StrLoc"].ToString() == "0" ? "" : Request.QueryString["StrLoc"].ToString());
            string _endLocText = (Request.QueryString["EndLoc"].ToString() == "9999999999" ? "" : Request.QueryString["EndLoc"].ToString());
            string _locListText = (Request.QueryString["LocList"].ToString() == "0" ? "" : Request.QueryString["LocList"].ToString());
            lblStartLoc.Text = "Start Loc: " + _startLocText;
            lblEndLoc.Text = "End Loc: " + _endLocText;
            lblLocList.Text = "Loc List: " + _locListText;

            string _startCatText = (Request.QueryString["StrCat"].ToString() == "00000" ? "" : Request.QueryString["StrCat"].ToString());
            string _endCatText = (Request.QueryString["EndCat"].ToString() == "99999" ? "" : Request.QueryString["EndCat"].ToString());
            string _catListText = (Request.QueryString["CatList"].ToString() == "0" ? "" : Request.QueryString["CatList"].ToString());
            lblStartCat.Text = "Start Cat: " + _startCatText;
            lblEndCat.Text = "End Cat: " + _endCatText;
            lblCatList.Text = "Cat List: " + _catListText;

            //lblStartSize.Text = "Start Size: " + Request.QueryString["StrSize"].ToString();
            //lblEndSize.Text = "End Size: " + Request.QueryString["StrSize"].ToString();
            //lblSizeList.Text = "Size List: " + Request.QueryString["SizeList"].ToString();

            //lblStartVar.Text = "Start Var: " + Request.QueryString["StrVar"].ToString();
            //lblEndVar.Text = "End Var: " + Request.QueryString["EndVar"].ToString();
            //lblVarList.Text = "Var List: " + Request.QueryString["VarList"].ToString();

            if (Request.QueryString["CFVList"].ToString() == "~")
            {
                string _startCFVText = (Request.QueryString["StrCFV"].ToString() == "0" ? "" : Request.QueryString["StrCFV"].ToString());
                string _endCFVText = (Request.QueryString["EndCFV"].ToString() == "0" ? "" : Request.QueryString["EndCFV"].ToString());
                string _CFVListText = (Request.QueryString["CFVList"].ToString() == "0" ? "" : Request.QueryString["CFVList"].ToString());
                lblStartCFV.Text = "Start CFV: " + _startCFVText;
                lblEndCFV.Text = "End CFV: " + _endCFVText;
                lblCFVList.Text = "CFV List: " + _CFVListText;

            }
            else
            {
                string _startCFVText = (Request.QueryString["StrCFV"].ToString() == "A" ? "" : Request.QueryString["StrCFV"].ToString());
                string _endCFVText = (Request.QueryString["EndCFV"].ToString() == "z" ? "" : Request.QueryString["EndCFV"].ToString());
                string _CFVListText = (Request.QueryString["CFVList"].ToString() == "0" ? "" : Request.QueryString["CFVList"].ToString());
                lblStartCFV.Text = "Start CFV: " + _startCFVText;
                lblEndCFV.Text = "End CFV: " + _endCFVText;
                lblCFVList.Text = "CFV List: " + _CFVListText;
            }
          

            if (Request.QueryString["SVCList"].ToString() == "~")
            {
                string _startSVCText = (Request.QueryString["StrSVC"].ToString() == "0" ? "" : Request.QueryString["StrSVC"].ToString());
                string _endSVCText = (Request.QueryString["EndSVC"].ToString() == "0" ? "" : Request.QueryString["EndSVC"].ToString());
                string _SVCListText = (Request.QueryString["SVCList"].ToString() == "0" ? "" : Request.QueryString["SVCList"].ToString());
                lblStartSVC.Text = "Start SVC: " + _startSVCText;
                lblEndSVC.Text = "End SVC: " + _endSVCText;
                lblSVCList.Text = "SVC List: " + _SVCListText;
            }
            else
            {
                string _startSVCText = (Request.QueryString["StrSVC"].ToString() == "A" ? "" : Request.QueryString["StrSVC"].ToString());
                string _endSVCText = (Request.QueryString["EndSVC"].ToString() == "z" ? "" : Request.QueryString["EndSVC"].ToString());
                string _SVCListText = (Request.QueryString["SVCList"].ToString() == "0" ? "" : Request.QueryString["SVCList"].ToString());
                lblStartSVC.Text = "Start SVC: " + _startSVCText;
                lblEndSVC.Text = "End SVC: " + _endSVCText;
                lblSVCList.Text = "SVC List: " + _SVCListText;
            }

           // string _startSVCText = (Request.QueryString["StrSVC"].ToString() == "0" ? "" : Request.QueryString["StrSVC"].ToString());
           // string _endSVCText = (Request.QueryString["EndSVC"].ToString() == "z" ? "" : Request.QueryString["EndSVC"].ToString());
           // string _SVCListText = (Request.QueryString["SVCList"].ToString() == "0" ? "" : Request.QueryString["SVCList"].ToString());
            //lblStartSVC.Text = "Start SVC: " + _startSVCText;
            //lblEndSVC.Text = "End SVC: " + _endSVCText;
            //lblSVCList.Text = "SVC List: " + _SVCListText;

            //lblPkType.Text = "Pack Type: " + Request.QueryString["PkType"].ToString();
            //lblPkTypeList.Text = "Pack Type List: " + Request.QueryString["PkTypeList"].ToString();

            lblPlatingCdList.Text = "Plating Code List: " + Request.QueryString["platingCdList"].ToString();

            // lblPlatingCdList.Text = "Plating Code List: " + Request.QueryString["platingCdList"].ToString(); Web Items ?

            GetDataSet();
        }
    }

    #region Get DataSet & Bind GridView
    protected void GetDataSet()
    {
        string _ProcName,
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
                _PkType = Request.QueryString["PkType"].ToString().Trim(),
                _PkTypeList = Request.QueryString["PkTypeList"].ToString().Trim(),
                _platingCdList = Request.QueryString["platingCdList"].ToString().Trim(),
                _StrWeb = Request.QueryString["StrWeb"].ToString().Trim(),
                _EndWeb = Request.QueryString["EndWeb"].ToString().Trim(),
                _rollingMonths = Request.QueryString["rollingMonths"].ToString().Trim(),                
                _addAvailWO = Request.QueryString["addAvailWO"].ToString().Trim(),
                _addAvailPO = Request.QueryString["addAvailPO"].ToString().Trim(),
                _addAvailTI = Request.QueryString["addAvailTI"].ToString().Trim();  //27

        if (_StrLoc == "00")
            _ProcName = "pTheorecticalFillRateRpt_CorpVer";
        else
            _ProcName = "pTheoreticalFillRateRpt_BrVer";

        #region Call SP to get Dataset for GridView
        try
        {
            dsTheoretical = SqlHelper.ExecuteDataset(cnERP, _ProcName,
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
                                                    new SqlParameter("@PkType", _PkType),
                                                    new SqlParameter("@PkTypeList", _PkTypeList),
                                                    new SqlParameter("@PlatingCdList", _platingCdList),  
                                                    new SqlParameter("@StrWeb", _StrWeb),
                                                    new SqlParameter("@EndWeb", _EndWeb),
                                                    new SqlParameter("@RollingMonths", _rollingMonths),
                                                    new SqlParameter("@AddAvailWO", _addAvailWO),
                                                    new SqlParameter("@AddAvailPO", _addAvailPO),
                                                    new SqlParameter("@AddAvailTI", _addAvailTI));
        }
        catch (Exception ex)
        {
            DisplayStatusMessage("Error executing stored procedure (pTheoreticalFillRateRpt_BrVer)", "fail");
            DisplayStatusMessage(ex.ToString(), "fail");
            return;
        }

        if (dsTheoretical.Tables[0].Rows.Count > 0)
        {
            Session["dsTheoretical"] = dsTheoretical;
            BindGridView();
            //            gvPager.InitPager(gvSKU, pageSize);
        }
        else
            DisplayStatusMessage("No Data", "fail");

        pnlGrid.Update();
        #endregion
    }

    protected void BindGridView()
    {
        dsTheoretical = (DataSet)Session["dsTheoretical"];
        //sortExpression = ((hidSort.Value != "") ? hidSort.Value : "ItemNo,Location ASC");
        sortExpression = ((hidSort.Value != "") ? hidSort.Value : "NetSaleWghtt DESC");
        dsTheoretical.Tables[0].DefaultView.Sort = sortExpression;
        gvSKU.DataSource = dsTheoretical.Tables[0].DefaultView.ToTable();
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

        String xlsFile = "Theoretical" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//Common//ExcelUploads//") + xlsFile;
        FileInfo fnExcel = new FileInfo(ExportFile);
        StreamWriter reportWriter = fnExcel.CreateText();

        string headerContent = string.Empty;
        string excelContent = string.Empty;

        try
        {
            dsTheoretical = (DataSet)Session["dsTheoretical"];
        }
        catch (Exception ex)
        {
        }

        if (dsTheoretical.Tables[0] != null && dsTheoretical.Tables[0].DefaultView.ToTable().Rows.Count > 0)
        {
            dsTheoretical.Tables[0].DefaultView.Sort = "NetSaleWghtt Desc";

            //Headers
            headerContent = "<table border='1' width='100%'>";
            headerContent += "<tr><th colspan='18' style='color:blue' align=left><Left><b>Run By: " + Session["UserName"].ToString() +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Theoretical Fill Rate" +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "" + lblRollingMonths.Text +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "" + lblAddAvailWO.Text +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "" + lblAddAvailPO.Text +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "" + lblAddAvailTI.Text +
                                         "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "" + lblPlatingCdList.Text +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                        "Run Date: " + DateTime.Now.ToShortDateString() + "</b></center></th></tr>";

            headerContent += "<tr><th nowrap><center>Item No</center></th>" +
                                 "<th nowrap><center>Desc</center></th>" +
                                 "<th nowrap><center>CFV</center></th>" +
                                 "<th nowrap><center>Loc</center></th>" +
                                 "<th nowrap><center>SVC</center></th>" +
                                 "<th nowrap><center>Qty Avail</center></th>" +
                                 "<th nowrap><center>Avail Wght</center></th>" +
                                 "<th nowrap><center>Net Sales Qty</center></th>" +
                                 "<th nowrap><center>Net Sales Wght</center></th>" +
                                 "<th nowrap><center>Mo.Lbs</center></th>" +
                                 "<th nowrap><center>Mo.Avail</center></th>" +
                                 "<th nowrap><center>Mod Value Mo</center></th>" +
                                 "<th nowrap><center>Corp Avail Units+TI</center></th>" +
                                 "<th nowrap><center>Corp Mo.Avail</center></th>" +
                                 "<th nowrap><center>CorpUsageMo Wght</center></th>" +
                                 //"<th nowrap><center>New</center></th>" +
                                 //"<th nowrap><center>DocNo</center></th>" +
                                 //"<th nowrap><center>WO Qty</center></th>" +
                                 //"<th nowrap><center>PO Qty</center></th>" +
                                 //"<th nowrap><center>OW Qty</center></th>" +
                                 "<th nowrap><center>Pct To Total</center></th>" +
                                 "<th nowrap><center>Mod Value</center></th>" +
                                 "<th nowrap><center>Cum of Total</center></th>" +
                                 "<th nowrap><center>Co Fill Resip</center></th>" +
                                 "<th nowrap><center>T-Fill</center></th>"; 
            reportWriter.Write(headerContent);

            foreach (DataRow Row in dsTheoretical.Tables[0].DefaultView.ToTable().Rows)
            {
                //Detail line
                excelContent = "<tr><td align=center>" + Row["ItemNo"] + "</td>" +
                                   "<td align=left style='mso-number-format:\\@;'>" + Row["ItemDesc"] + "</td>" +
                                   "<td align=center>" + Row["CorpFixedVelocity"] + "</td>" +
                                   "<td align=center>" + Row["Location"].ToString() + "</td>" +
                                   "<td align=center>" + Row["SalesVelocityCd"] + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["QtyAvail"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["AvailWght"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["NetSalesQty"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["NetSaleWghtt"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["MonthLbs"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n1}", Row["MonthsAvail"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n3}", Row["ModifierValueMo"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["BegQOH"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n1}", Row["CorpMonthsAvail"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n0}", Row["CorpUsage36MoWght"]) + "</td>" +
                                   //"<td align=right>" + String.Format("{0:n0}", Row["New"]) + "</td>" +
                                   //"<td align=center>" + Row["DocNo"] + "</td>" +
                                   //"<td align=right>" + String.Format("{0:n0}", Row["WOQty"]) + "</td>" +
                                   //"<td align=right>" + String.Format("{0:n0}", Row["POQty"]) + "</td>" +
                                   //"<td align=right>" + String.Format("{0:n0}", Row["OWQty"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n2}", Row["Pct_To_Total"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n2}", Row["ModValue"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n2}", Row["Running_Total"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n2}", Row["MDiffPct_ModV"]) + "</td>" +
                                   "<td align=right>" + String.Format("{0:n2}", Row["TFill"]) + "</td>" + 
                                   "</tr>";

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
                if (fn.Name.Contains("Theoretical" + strSession))
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
        Session["dsTheoretical"] = null;    //Clear the session variable
        return "";
    }
}
