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

public partial class ROISalesReport_SalesReportByCatGroupPreview : System.Web.UI.Page
{
    #region Global Variables

    private string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    private DataTable dtTotal = new DataTable();
    private DataSet dsCatGroup = new DataSet();
    private string keyColumn = "CatGrpNo";
    private string sortExpression = string.Empty;
    string curMonth = string.Empty;
    string curYear = string.Empty;
    private string sortColumn = string.Empty;
    protected ROISalesReport ROISalesReport = new ROISalesReport();
    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        curMonth = Request.QueryString["Month"];
        curYear = Request.QueryString["Year"];

        sortColumn = Request.QueryString["Sort"].ToString();      
     
        if (!IsPostBack)
            BindDataGrid();
    }

    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        if (sortColumn == "")
            sortExpression = "CatGrpNo";
        else
            sortExpression =  sortColumn;

        dsCatGroup = ROISalesReport.GetSalesByCategory(sortExpression,curMonth,curYear);
        dtTotal = dsCatGroup.Tables[0].DefaultView.ToTable();
        if (dtTotal.Rows.Count > 0)
        {
            GetTotal();
            dgCategoryGroup.DataSource = dsCatGroup.Tables[0];
            dgCategoryGroup.DataBind();
         }

        lblStatus.Text = "No Records Found";
        lblStatus.Visible = (dgCategoryGroup.Items.Count < 1) ? true : false;
    }

    private void GetTotal()
    {

        DataSet dsSalesLbs = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", " (SELECT CurYear, CurMonth, RecType, Roll12Sales, Roll12Lbs, Roll12GM FROM CAS_CategorySum WHERE (CurYear = " + Request.QueryString["Year"].Trim() + ") AND (CurMonth = " + Request.QueryString["Month"].Trim() + ") AND (RecType = 'Customer')) tmp"),
                                    new SqlParameter("@columnNames", "SUM(Roll12GM) / SUM(Roll12Sales) * 100 AS PctCropGMDollar, SUM(Roll12Sales) / SUM(Roll12Lbs) AS DolPerLb, SUM(Roll12GM) / SUM(Roll12Lbs) AS GMPerLb"),
                                    new SqlParameter("@whereClause", "1=1"));

        dtTotal.Clear();
        DataRow drow = dtTotal.NewRow();
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
        //drow["ROI"] = Convert.ToDecimal(dsCatGroup.Tables[0].Compute("sum(Roll12GMSum)/(sum(OHCost)*avg(AppOptionNumber))", "")).ToString();
        drow["ROI"] = ((Convert.ToDecimal(dsCatGroup.Tables[0].Compute("sum(OHCost)", "")) == 0) | (Convert.ToDecimal(dsCatGroup.Tables[0].Compute("sum(AppOptionNumber)", "")) == 0)) ? 0 : Convert.ToDecimal(dsCatGroup.Tables[0].Compute("sum(Roll12GMSum)/(sum(OHCost)*avg(AppOptionNumber))", ""));
        dtTotal.Rows.Add(drow);
    } 

    #endregion

    #region Events

    protected void dgCategoryGroup_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
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
    
    #endregion   
   
}
