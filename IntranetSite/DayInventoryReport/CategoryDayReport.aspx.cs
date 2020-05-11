#region Namespace

using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Threading;
using System.IO;
using System.Reflection;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
using PFC.Intranet.DayInventoryReport;

#endregion

public partial class CategoryDayReport : System.Web.UI.Page
{
    #region Global Variables

    protected DayInventoryReport DayInventoryReport = new DayInventoryReport();
    private string strStatus = string.Empty;
    private string strCategory = string.Empty;
    private string keyColumn = "ItemNo";
    private string sortExpression = string.Empty;
    public DataSet dsReport = new DataSet();
    private DataTable dtTotal = new DataTable();
    private int pagesize = 19; 

    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(CategoryDayReport));
        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");
        hidFileName.Value = "DayInventoryCategory" + Session["SessionID"].ToString() + name + ".xls";
        strStatus = Request.QueryString["status"];
        strCategory = Request.QueryString["CategoryGroup"];

        if (strStatus == "withExclusion")
            lblMenuName.Text = "365 Day Inventory Report - With Exclusions";
        else
            lblMenuName.Text = "365 Day Inventory Report - Without Exclusions";
        if (!IsPostBack)
        {
            sortExpression = ((hidSort.Value != "") ? " ORDER BY  " + hidSort.Value : " ORDER BY " + keyColumn);
            BindBranchDetails();
            dsReport = DayInventoryReport.GetCategoryReport(strStatus, strCategory, ddlBranch.SelectedValue.Trim(), sortExpression);
            dtTotal = dsReport.Tables[0].DefaultView.ToTable();
            BindDataGrid();
        }

    } 

    #endregion

    #region Developer Code

    private void BindBranchDetails()
    {
        try
        {

            DataSet dsBranch = DayInventoryReport.GetBranch();

            // fill DropdownList Branch
            ddlBranch.DataSource = dsBranch.Tables[0];
            ddlBranch.DataTextField = "BranchName";
            ddlBranch.DataValueField = "Branch";
            ddlBranch.DataBind();
            ListItem item = new ListItem("00 - Corporate", "00");
            ddlBranch.Items.Insert(0, item);

        }
        catch (Exception ex) { }
    }

    private void BindReport()
    {
        try
        {
            sortExpression = ((hidSort.Value != "") ? " ORDER BY  " + hidSort.Value : " ORDER BY " + keyColumn);
            dsReport = DayInventoryReport.GetCategoryReport(strStatus, strCategory, ddlBranch.SelectedValue.Trim(), sortExpression);
            dtTotal = dsReport.Tables[0].DefaultView.ToTable();
            BindDataGrid();
        }
        catch (Exception ex) { }
    }

    private void GetTotal()
    {
        dtTotal.Clear();
        DataRow drow = dtTotal.NewRow();
        drow["ItemNo"] = "0";
        drow["OnHand"] = Convert.ToInt32(dsReport.Tables[0].Compute("sum(OnHand)", "")).ToString();
        drow["OnHandValue"] = Convert.ToInt32(dsReport.Tables[0].Compute("sum(OnHandValue)", "")).ToString();
        drow["DailySalesValue"] = Convert.ToInt32(dsReport.Tables[0].Compute("sum(DailySalesValue)", "")).ToString();
        drow["DaysOnHand"] = Convert.ToInt32(dsReport.Tables[0].Compute("sum(DaysOnHand)", "")).ToString();
        drow["OHgt150Days"] = Convert.ToInt32(dsReport.Tables[0].Compute("sum(OHgt150Days)", "")).ToString();
        drow["OHgt365Days"] = Convert.ToInt32(dsReport.Tables[0].Compute("sum(OHgt365Days)", "")).ToString();
        dtTotal.Rows.Add(drow);
    }

    private void BindDataGrid()
    {

        try
        {
            if (dtTotal.Rows.Count > 0)
            {
                GetTotal();
                dgDayReport.DataSource = dsReport.Tables[0];
                dgDayReport.Visible = true;
                lblStatus.Visible = false;
                Pager1.InitPager(dgDayReport, pagesize);
                Pager1.Visible = true;
                udpReportContent.Update();
            }
            else
            {
                dgDayReport.Visible = false;
                Pager1.Visible = false;
                lblStatus.Visible=true;
                lblStatus.Text = "No Records Found";

            }
            
            
        }
        catch (Exception ex)
        {

            throw ex;
        }
        //lblStatus.Text = "No Records Found";
        //lblStatus.Visible = (dgDayReport.Items.Count < 1) ? true : false;
    } 

    #endregion

    #region Events

    protected void ddlBranch_SelectedIndexChanged(object sender, EventArgs e)
    {
        dgDayReport.CurrentPageIndex = 0;
        BindReport();
        udpReportContent.Update();
    }

    protected void dgDayReport_SortCommand(object source, DataGridSortCommandEventArgs e)
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
        BindReport();
    }

    protected void dgDayReport_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Footer)
        {
            if (dtTotal.Rows.Count > 0)
            {
                e.Item.Cells[0].Text = "Grand Total";
                e.Item.Cells[1].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["OnHand"]);
                e.Item.Cells[2].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["OnHandValue"]);
                e.Item.Cells[3].Text = String.Format("{0:#,##0.00}", dtTotal.Rows[0]["DailySalesValue"]);
                e.Item.Cells[4].Text = String.Format("{0:#,##0.000}", dtTotal.Rows[0]["DaysOnHand"]);
                e.Item.Cells[5].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["OHgt150Days"]);
                e.Item.Cells[6].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["OHgt365Days"]);
            }

        }

    }

    protected void dgDayReport_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgDayReport.CurrentPageIndex = e.NewPageIndex;
        BindReport();

    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgDayReport.CurrentPageIndex = Pager1.GotoPageNumber;
        BindReport();

    } 

    #endregion     
      
    #region Delete the Excel File when the close button is clicked

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\DayInventoryReport\\Common\\ExcelUploads"));

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

    #region Excel Export

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        string sortExpression = ((hidSort.Value != "") ? " ORDER BY  " + hidSort.Value : " ORDER BY " + keyColumn);
        dsReport = DayInventoryReport.GetCategoryReport(strStatus, strCategory, ddlBranch.SelectedValue.Trim(), sortExpression);
        dtTotal = dsReport.Tables[0].DefaultView.ToTable();
        headerContent = "<table border='1' width='90%'>";
        headerContent += "<tr><th colspan='8' style='color:blue'>" + lblMenuName.Text + "</th></tr>";
        headerContent += "<tr><th colspan='4' align='left'>Fiscal Period :" + DayInventoryReport.GetDateCondition() + "&nbsp;&nbsp;" + Request.QueryString["Year"] + "</th><th colspan='2'>Run By : " + Session["UserName"].ToString() + "</th><th colspan='2'>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>";
        headerContent += "<tr><th colspan='6' align='left'>Cat Grp - " + Request.QueryString["CategoryGroup"] + " " + Request.QueryString["CategoryGroupDesc"] + "</th><th colspan='2' align='left'>BRANCH : " + ddlBranch.SelectedItem.Text + "</th></tr>";
        
        if (dtTotal.Rows.Count > 0)
        {
            headerContent += "<tr><th style='width:120px;'>Item No.</th><th>Qty O/H</th><th>$ O/H</th><th style='width:80px;'>Daily Usg $ @ Avg Cost</th><th style='width:80px;'>Days Supply</th><th style='width:100px;'>$ Value Days Supply > 150D</th><th style='width:100px;'>$ Value Days Supply > 365D </th><th>Category Description</th></tr>";
            foreach (DataRow roiReader in dtTotal.Rows)
            {
                excelContent += "<tr><td>" + roiReader["ItemNo"].ToString() + "</td><td>" +
                     String.Format("{0:#,##0}", roiReader["OnHand"]) + "</td><td nowrap=nowrap>" +
                     String.Format("{0:#,##0}", roiReader["OnHandValue"]) + "</td><td>" +
                     String.Format("{0:#,##0.00}", roiReader["DailySalesValue"]) + "</td><td nowrap=nowrap>" +
                     String.Format("{0:#,##0.000}", roiReader["DaysOnHand"]) + "</td><td nowrap=nowrap>" +
                     String.Format("{0:#,##0}", roiReader["OHgt150Days"]) + "</td><td>" +
                     String.Format("{0:#,##0}", roiReader["OHgt365Days"]) + "</td><td style='width:350px;' nowrap=nowrap>" +
                     roiReader["ItemDesc"].ToString() + "</td>" + "</tr>";

            }
            GetTotal();
            footerContent = "<tr style='font-weight:bold;'><td>Grand Total</td><td>" +
                      String.Format("{0:#,##0}", dtTotal.Rows[0]["OnHand"]) + "</td><td>" +
                      String.Format("{0:#,##0}", dtTotal.Rows[0]["OnHandValue"]) + "</td><td>" +
                      String.Format("{0:#,##0.00}", dtTotal.Rows[0]["DailySalesValue"]) + "</td><td>" +
                      String.Format("{0:#,##0.000}", dtTotal.Rows[0]["DaysOnHand"]) + "</td><td>" +
                      String.Format("{0:#,##0}", dtTotal.Rows[0]["OHgt150Days"]) + "</td><td>" +
                      String.Format("{0:#,##0}", dtTotal.Rows[0]["OHgt365Days"]) + "</td><td>" +
                      dtTotal.Rows[0]["ItemDesc"].ToString() + "</td>" + "</tr>";

        }
        reportWriter.WriteLine(headerContent + excelContent + footerContent);
        reportWriter.Close();


        //
        // Downloding Process
        //
        FileStream fileStream = File.Open(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()), FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        //
        // Download Process
        //
        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString())));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    } 

    #endregion       

    //protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
    //{
    //    string url = "CategoryDayReportPreview.aspx?status=" + Request.QueryString["status"].ToString() + "&CategoryGroup=" + Request.QueryString["CategoryGroup"].ToString() + "&CategoryGroupDesc=" + Request.QueryString["CategoryGroupDesc"].ToString() + "&Branch=" + ddlBranch.SelectedItem.Text.Trim() + "&BranchCode=" + ddlBranch.SelectedItem.Value.Trim() + "&Sort=" + hidSort.Value;
    //    string script = " window.open(" + url + ",'CategoryDayReportPreview' ,'height=700,width=1020,scrollbars=no,status=no,top=0,resizable=Yes','');";

    //    ScriptManager.RegisterClientScriptBlock(ibtnPrint, typeof(ImageButton), "print", script, true);
    //}
}
