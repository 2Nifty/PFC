#region Namespaces

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

public partial class Sales_Inventory_Report_SalesReportByCatGroup : System.Web.UI.Page
{
    #region Global Variables

    private string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    private DataTable dtTotal = new DataTable();
    private DataSet dsCatGroup = new DataSet();
    private string keyColumn = "CatGrpNo";
    private string sortExpression = string.Empty;
    private string WhereMonth = string.Empty;
    int pagesize = 20;
    string curMonth = string.Empty;
    string curYear = string.Empty;
    protected ROISalesReport ROISalesReport = new ROISalesReport();

    DataSet dsSalesPrefix = new DataSet();
    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(Sales_Inventory_Report_SalesReportByCatGroup));
        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");        
        curMonth = (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "";
        curYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";
        hidFileName.Value = "SalesInventory" + Session["SessionID"].ToString() + name + ".xls";
        if (!IsPostBack)
            BindDataGrid();
        
    } 

    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        sortExpression = ((hidSort.Value != "") ?  hidSort.Value : keyColumn);

        dsCatGroup = ROISalesReport.GetSalesByCategory(sortExpression, curMonth,curYear);
        
        dtTotal = dsCatGroup.Tables[0].DefaultView.ToTable();
        if (dtTotal.Rows.Count > 0)
        {
            GetTotal();
            dgCategoryGroup.DataSource = dsCatGroup.Tables[0];
            Pager1.Visible = true;
            Pager1.InitPager(dgCategoryGroup, pagesize);
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
                                    new SqlParameter("@tableName", " (SELECT CurYear, CurMonth, RecType, Roll12Sales, Roll12Lbs, Roll12GM FROM CAS_CategorySum WHERE (CurYear = " + Request.QueryString["Year"].Trim() + ") AND (CurMonth = " + Request.QueryString["Month"].Trim() + ") AND (RecType = 'Customer')) tmp"),
                                    new SqlParameter("@columnNames", "case when (ISNULL(SUM(Roll12Sales),0)=0) THEN 0 ELSE SUM(Roll12GM) / SUM(Roll12Sales) * 100 END AS PctCropGMDollar, case when (ISNULL(SUM(Roll12Lbs),0) = 0) THEN 0 ELSE SUM(Roll12Sales) / SUM(Roll12Lbs) END AS DolPerLb, case when ISNULL(SUM(Roll12Lbs),0) = 0 THEN 0 ELSE SUM(Roll12GM) / SUM(Roll12Lbs) END AS GMPerLb"),
                                    new SqlParameter("@whereClause", "1=1"));

        dtTotal.Clear();
        DataRow drow = dtTotal.NewRow();
        string test = dsCatGroup.Tables[0].Compute("avg(AppOptionNumber)", "").ToString();
        drow["CatGroup"] = "Grand Total";
        drow["ExtAvgCost"] = Convert.ToDecimal(dsCatGroup.Tables[0].Compute("sum(ExtAvgCost)", "")).ToString();
        drow["Roll12Sales"] = Convert.ToDecimal(dsCatGroup.Tables[0].Compute("sum(Roll12Sales)", "")).ToString();
        drow["AvgCostSales"] = Convert.ToDecimal(dsCatGroup.Tables[0].Compute("(sum(ExtAvgCost)/sum(Roll12Sales)*12)", "")).ToString();
        //drow["SalesLbs"] = Convert.ToString(Convert.ToDecimal(dsCatGroup.Tables[0].Compute("sum(SalesLbs)", "")));
        drow["SalesLbs"] = dsSalesLbs.Tables[0].Rows[0]["DolPerLb"].ToString();
        //drow["GMLbs"] = Convert.ToString(Convert.ToDecimal(dsCatGroup.Tables[0].Compute("avg(GMLbs)", "")));
        drow["GMLbs"] = dsSalesLbs.Tables[0].Rows[0]["GMPerLb"].ToString();
        drow["Roll12PctTotSalesCorpAvg"] = Convert.ToString(Convert.ToDecimal(dsCatGroup.Tables[0].Compute("sum(Roll12PctTotSalesCorpAvg)", "")));
        //drow["Roll12GMPctCorpAvg"] = Convert.ToString(Convert.ToDecimal(dsCatGroup.Tables[0].Compute("avg(Roll12GMPctCorpAvg)", "")));        
        drow["Roll12GMPctCorpAvg"] = dsSalesLbs.Tables[0].Rows[0]["PctCropGMDollar"].ToString();
        drow["ROI"] = ((Convert.ToDecimal(dsCatGroup.Tables[0].Compute("sum(OHCost)", "")) == 0) | (Convert.ToDecimal(dsCatGroup.Tables[0].Compute("sum(AppOptionNumber)", "")) == 0)) ? 0 : Convert.ToDecimal(dsCatGroup.Tables[0].Compute("sum(Roll12GMSum)/(sum(OHCost)*avg(AppOptionNumber))", ""));
        dtTotal.Rows.Add(drow);
    } 

    #endregion

    #region Events

    protected void dgCategoryGroup_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {

            HyperLink hplButton = e.Item.Cells[0].Controls[1] as HyperLink;
            hplButton.ForeColor = System.Drawing.Color.Blue;
            hplButton.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'popupwindow2', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");

        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].Text = dtTotal.Rows[0]["CatGroup"].ToString();
            e.Item.Cells[1].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["ExtAvgCost"]);
            e.Item.Cells[2].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["Roll12Sales"]);
            e.Item.Cells[3].Text = String.Format("{0:#,##0.0}", dtTotal.Rows[0]["AvgCostSales"]);
            e.Item.Cells[4].Text = String.Format("{0:#,##0.000}", dtTotal.Rows[0]["SalesLbs"]);
            e.Item.Cells[5].Text = String.Format("{0:#,##0.000}", dtTotal.Rows[0]["GMLbs"]);
            e.Item.Cells[6].Text = String.Format("{0:#,##0.0}", dtTotal.Rows[0]["Roll12PctTotSalesCorpAvg"]);
            e.Item.Cells[7].Text = String.Format("{0:#,##0.0}", dtTotal.Rows[0]["Roll12GMPctCorpAvg"]);
            e.Item.Cells[8].Text = String.Format("{0:#,##0.000}", dtTotal.Rows[0]["ROI"]);
        }
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgCategoryGroup.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void dgCategoryGroup_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgCategoryGroup.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
    }

    protected void dgCategoryGroup_SortCommand(object source, DataGridSortCommandEventArgs e)
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

    #region Write to Excel

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
        string headerContent=string.Empty;
        string footerContent=string.Empty;
        string excelContent = string.Empty; 
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        string sortExpression = ((hidSort.Value != "") ? hidSort.Value : keyColumn);
        
        dsCatGroup = ROISalesReport.GetSalesByCategory(sortExpression,curMonth,curYear);
        dtTotal = dsCatGroup.Tables[0].DefaultView.ToTable();
        headerContent = "<table border='1'>";
        headerContent += "<tr><th colspan='9' style='color:blue'>ROI Sales Report By Category Group</th></tr>";
        headerContent += "<tr><th colspan='5' align='left'>Fiscal Period :" + ROISalesReport.GetDate(Request.QueryString["Month"]) + "&nbsp;&nbsp;" +  Request.QueryString["Year"]  + "</th><th colspan='2'>Run By : " + Session["UserName"].ToString() + "</th><th colspan='2'>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>";
        headerContent += "<tr><th>Cat Group</th><th>Inv $</th><th>12 Mos Sales</th><th>M_OH</th><th>$/Lb</th><th>GM/Lb</th><th>% Corp $</th><th>% Corp GM $</th><th>ROI</th></tr>";
        if (dtTotal.Rows.Count > 0)
        {
            foreach (DataRow roiReader in dtTotal.Rows)
            {
                excelContent += "<tr><td>" + roiReader["CatGroup"].ToString() + "</td><td>" +
                     String.Format("{0:#,##0}", roiReader["ExtAvgCost"]) + "</td><td>" +
                     String.Format("{0:#,##0}", roiReader["Roll12Sales"]) + "</td><td>" +
                     String.Format("{0:#,##0.0}", roiReader["AvgCostSales"]) + "</td><td>" +
                     String.Format("{0:#,##0.000}", roiReader["SalesLbs"]) + "</td><td>" +
                     String.Format("{0:#,##0.000}", roiReader["GMLbs"]) + "</td><td>" +
                     String.Format("{0:#,##0.0}", roiReader["Roll12PctTotSalesCorpAvg"]) + "</td><td>" +
                     String.Format("{0:#,##0.0}", roiReader["Roll12GMPctCorpAvg"]) + "</td><td>"+
                     String.Format("{0:#,##0.000}", roiReader["ROI"]) + "</td></tr>";
            }
            GetTotal();
            footerContent = "<tr style='font-weight:bold;' align='right'><td>" + dtTotal.Rows[0]["CatGroup"].ToString() + "</td><td>" +
                      String.Format("{0:#,##0}", dtTotal.Rows[0]["ExtAvgCost"]) + "</td><td>" +
                      String.Format("{0:#,##0}", dtTotal.Rows[0]["Roll12Sales"]) + "</td><td>" +
                      String.Format("{0:#,##0.0}", dtTotal.Rows[0]["AvgCostSales"]) + "</td><td>" +
                      String.Format("{0:#,##0.000}", dtTotal.Rows[0]["SalesLbs"]) + "</td><td>" +
                      String.Format("{0:#,##0.000}", dtTotal.Rows[0]["GMLbs"]) + "</td><td>" +
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
  
    #endregion

    #region Delete Excel using sessionid

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
   
}
