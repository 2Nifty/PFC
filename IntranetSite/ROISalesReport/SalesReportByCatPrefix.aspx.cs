#region namespaces

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
using PFC.Intranet.ROISalesReport;

#endregion

public partial class Sales_Inventory_Report_SalesReportByCatPrefix : System.Web.UI.Page
{
    #region Global Variables

    private DataSet dsSalesPrefix = new DataSet();
    private DataTable dtTotal = new DataTable();
    private string strCategoryGroupNo = string.Empty;
    private string keyColumn = "CatPrefix";
    private string sortExpression = string.Empty;
    string MonthWhere = string.Empty;
    string YearWhere = string.Empty;
    private string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    int pagesize = 20;
    protected ROISalesReport ROISalesReport = new ROISalesReport(); 

    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(Sales_Inventory_Report_SalesReportByCatPrefix));
        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");       
        hidFileName.Value = "SalesInventoryCategoryPrefix" + Session["SessionID"].ToString() + name + ".xls";
        strCategoryGroupNo = Request.QueryString["CategoryGroupNo"];
        MonthWhere = Request.QueryString["Month"];
        YearWhere = Request.QueryString["Year"];
        if (!IsPostBack)
            BindDataGrid();

    }

    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        sortExpression = ((hidSort.Value != "") ? hidSort.Value : keyColumn);
        dsSalesPrefix = ROISalesReport.GetSalesByCategoryPrefix(strCategoryGroupNo, sortExpression, MonthWhere, YearWhere);
        //dtTotal = dsSalesPrefix.Tables[0].DefaultView.ToTable();
        //if (dtTotal.Rows.Count > 0)
        //{
        //    GetTotal();
        //    dgPrefix.DataSource = dsSalesPrefix.Tables[0];            
        //    Pager1.InitPager(dgPrefix, pagesize);
        //    Pager1.Visible = true;
        //    lblStatus.Visible = false;
        //}
        //else
        //{
        //    Pager1.Visible = false;
        //    lblStatus.Visible = true;
        //    lblStatus.Text = "No Records Found";
        //}

        if (dsSalesPrefix != null && dsSalesPrefix.Tables[0].Rows.Count > 0)
        {
            dtTotal = dsSalesPrefix.Tables[0].DefaultView.ToTable();
            GetTotal();
            dgPrefix.DataSource = dsSalesPrefix.Tables[0];
            Pager1.InitPager(dgPrefix, pagesize);
            Pager1.Visible = true;
            lblStatus.Visible = false;
        }

        else
        {
            Pager1.Visible = false;
            lblStatus.Visible = true;
            lblStatus.Text = "No Records Found";
        }
       

    }

    private void GetTotal()
    {
        DataSet dsSalesLbs = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                   new SqlParameter("@tableName", " (SELECT CurYear, CurMonth, RecType, Roll12Sales, Roll12Lbs, Roll12GM FROM CAS_CategoryPrefixSum WHERE (CurYear = " + Request.QueryString["Year"].Trim() + ") AND (CurMonth = " + Request.QueryString["Month"].Trim() + ") AND (RecType = 'Customer' AND CatGrpNo = '" + strCategoryGroupNo + "')) tmp"),
                                   new SqlParameter("@columnNames", "SUM(Roll12GM) / SUM(Roll12Sales) * 100 AS PctCorpGMDollar, SUM(Roll12Sales) / SUM(Roll12Lbs) AS DolPerLb, SUM(Roll12GM) / SUM(Roll12Lbs) AS GMPerLb"),
                                   new SqlParameter("@whereClause", "1=1"));

        dtTotal.Clear();
        DataRow drow = dtTotal.NewRow();
        drow["CatPrefixDes"] = "Grand Total";
        drow["ExtAvgCost"] = Convert.ToDecimal(dsSalesPrefix.Tables[0].Compute("sum(ExtAvgCost)", "")).ToString();
        drow["Roll12Sales"] = Convert.ToDecimal(dsSalesPrefix.Tables[0].Compute("sum(Roll12Sales)", "")).ToString();
        drow["MOH"] = Convert.ToDecimal(dsSalesPrefix.Tables[0].Compute("(sum(ExtAvgCost)/sum(Roll12Sales)*12)", "")).ToString();
        drow["DLB"] = dsSalesLbs.Tables[0].Rows[0]["DolPerLb"].ToString();
        drow["GMLb"] = dsSalesLbs.Tables[0].Rows[0]["GMPerLb"].ToString();
        drow["Roll12PctTotSalesCorpAvg"] = Convert.ToString(Convert.ToDecimal(dsSalesPrefix.Tables[0].Compute("sum(Roll12PctTotSalesCorpAvg)", "")));
        drow["Roll12GMPctCorpAvg"] = dsSalesLbs.Tables[0].Rows[0]["PctCorpGMDollar"].ToString();


        if ((dsSalesPrefix.Tables[0].Rows.Count > 0) && Convert.ToDecimal(dsSalesPrefix.Tables[0].Compute("(sum(OHCost)*avg(AppOptionNumber))", "")) != 0)
            drow["ROI"] = Convert.ToDecimal(dsSalesPrefix.Tables[0].Compute("sum(Roll12GMSum)/(sum(OHCost)*avg(AppOptionNumber))", "")).ToString();
        else
            drow["ROI"] = Convert.ToDecimal(0); 
        dtTotal.Rows.Add(drow);
    }
    
    #endregion

    #region Write to Excel

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        string sortExpression = ((hidSort.Value != "") ? hidSort.Value : keyColumn);
        dsSalesPrefix = ROISalesReport.GetSalesByCategoryPrefix(strCategoryGroupNo, sortExpression, MonthWhere, YearWhere);
        dtTotal = dsSalesPrefix.Tables[0].DefaultView.ToTable();
        headerContent = "<table border='1'>";
        headerContent += "<tr><th colspan='9' style='color:blue'>ROI Sales Report By Category Prefix</th></tr>";
        headerContent += "<tr><th colspan='5' align='left'>Fiscal Period :" + ROISalesReport.GetDate(Request.QueryString["Month"]) + "&nbsp;&nbsp;" + Request.QueryString["Year"] + "</th><th colspan='2'>Run By : " + Session["UserName"].ToString() + "</th><th colspan='2'>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>";
        headerContent += "<tr><th>Cat Group</th><th>Inv $</th><th>12 Mos Sales</th><th>M_OH</th><th>$/Lb</th><th>GM/Lb</th><th>% Corp $</th><th>% Corp GM $</th><th>ROI</th></tr>";
if (dtTotal.Rows.Count > 0)
        {
        foreach (DataRow roiReader in dtTotal.Rows)
        {
            excelContent += "<tr><td>" + roiReader["CatPrefixDes"].ToString() + "</td><td>" +
                 String.Format("{0:#,##0.00}", roiReader["ExtAvgCost"]) + "</td><td>" +
                 String.Format("{0:#,##0.00}", roiReader["Roll12Sales"]) + "</td><td>" +
                 String.Format("{0:#,##0.0}", roiReader["MOH"]) + "</td><td>" +
                 String.Format("{0:#,##0.000}", roiReader["DLB"]) + "</td><td>" +
                 String.Format("{0:#,##0.000}", roiReader["GMLb"]) + "</td><td>" +
                 String.Format("{0:#,##0.0}", roiReader["Roll12PctTotSalesCorpAvg"]) + "</td><td>" +
                 String.Format("{0:#,##0.0}", roiReader["Roll12GMPctCorpAvg"]) + "</td><td>"+
                 String.Format("{0:#,##0.000}", roiReader["ROI"]) +"</td></tr>";
        }
        GetTotal();
        footerContent = "<tr style='font-weight:bold;'><td>" + dtTotal.Rows[0]["CatPrefixDes"].ToString() + "</td><td>" +
                  String.Format("{0:#,##0}", dtTotal.Rows[0]["ExtAvgCost"]) + "</td><td>" +
                  String.Format("{0:#,##0}", dtTotal.Rows[0]["Roll12Sales"]) + "</td><td>" +
                  String.Format("{0:#,##0.0}", dtTotal.Rows[0]["MOH"]) + "</td><td>" +
                  String.Format("{0:#,##0.000}", dtTotal.Rows[0]["DLB"]) + "</td><td>" +
                  String.Format("{0:#,##0.000}", dtTotal.Rows[0]["GMLb"]) + "</td><td>" +
                  String.Format("{0:#,##0.0}", dtTotal.Rows[0]["Roll12PctTotSalesCorpAvg"]) + "</td><td>" +
                  String.Format("{0:#,##0.0}", dtTotal.Rows[0]["Roll12GMPctCorpAvg"]) + "</td><td>" +
                  String.Format("{0:#,##0.000}", dtTotal.Rows[0]["ROI"]) + "</td></tr></table>";
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

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\ROISalesReport\\Common\\ExcelUploads"));

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

    #region Events

    protected void dgPrefix_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].Text = dtTotal.Rows[0]["CatPrefixDes"].ToString();
            e.Item.Cells[1].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["ExtAvgCost"]);
            e.Item.Cells[2].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["Roll12Sales"]);
            e.Item.Cells[3].Text = String.Format("{0:#,##0.0}", dtTotal.Rows[0]["MOH"]);
            e.Item.Cells[4].Text = String.Format("{0:#,##0.000}", dtTotal.Rows[0]["DLB"]);
            e.Item.Cells[5].Text = String.Format("{0:#,##0.000}", dtTotal.Rows[0]["GMLb"]);
            e.Item.Cells[6].Text = String.Format("{0:#,##0.0}", dtTotal.Rows[0]["Roll12PctTotSalesCorpAvg"]);
            e.Item.Cells[7].Text = String.Format("{0:#,##0.0}", dtTotal.Rows[0]["Roll12GMPctCorpAvg"]);
            e.Item.Cells[8].Text = String.Format("{0:#,##0.000}", dtTotal.Rows[0]["ROI"]);
        }
    }

    protected void dgPrefix_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgPrefix.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgPrefix.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void dgPrefix_SortCommand(object source, DataGridSortCommandEventArgs e)
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
        BindDataGrid();

    } 

    #endregion
}
