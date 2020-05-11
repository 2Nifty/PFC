/********************************************************************************************
 * File	Name			:	ItemSalesAnalysisPreview.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Retrive Data From Curvalsum Table - Customerwise.
 * Created By			:	Senthilkumar
 * Created Date			:	08/07/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/12/2005		    Version 1		Menaka      		Created
 * 08/19/2005		    Version 2		Senthilkumar 		Store Procedure Name Changed
 *********************************************************************************************/
using System;
using System.Configuration;
using System.Collections;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;



public partial class Sales_Analysis_Report_ItemSalesAnalysisPreview : System.Web.UI.Page
{
    string strYear = string.Empty;
    string strPeriodType = string.Empty;
    DataRow Total;

    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dtFooter = Session["ItemSalesGrandTotal"] as DataTable;
        Total = dtFooter.Rows[0];

        strYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";
        if (Request.QueryString["version"] == "long")
            strPeriodType = "YTD";
        else
            strPeriodType = "MTD";

        ChangeColumns();
    }

    private void ChangeColumns()
    {
        if (Request.QueryString["version"].ToString() == "long" && Request.QueryString["period"].ToString() == "ytd")
        {
            for (int i = 0; i <= 23; i++)
                dgAnalysis.Columns[i].Visible = true;
        }


        if (Request.QueryString["version"].ToString() == "long" && Request.QueryString["period"].ToString() == "mtd")
        {
            for (int i = 10; i <= 23; i++)
                dgAnalysis.Columns[i].Visible = false;

            dgAnalysis.Width = 1000;
            dgAnalysis.Columns[2].Visible = true;
            dgAnalysis.Columns[3].Visible = true;
            dgAnalysis.Columns[4].Visible = true;
            dgAnalysis.Columns[5].Visible = true;
            dgAnalysis.Columns[6].Visible = true;
            dgAnalysis.Columns[7].Visible = true;
            dgAnalysis.Columns[8].Visible = true;
            dgAnalysis.Columns[9].Visible = true;

        }


       
        if (Request.QueryString["version"].ToString() == "short" && Request.QueryString["period"].ToString() == "ytd")
        {
            for (int i = 0; i <= 23; i++)
                dgAnalysis.Columns[i].Visible = true;

            dgAnalysis.Columns[5].Visible = false;
            dgAnalysis.Columns[7].Visible = false;
            dgAnalysis.Columns[14].Visible = false;
            dgAnalysis.Columns[15].Visible = false;
            dgAnalysis.Columns[18].Visible = false;
            dgAnalysis.Columns[19].Visible = false;

        }


       
        if (Request.QueryString["version"].ToString() == "short" && Request.QueryString["period"].ToString() == "mtd")
        {
            for (int i = 10; i <= 23; i++)
                dgAnalysis.Columns[i].Visible = false;

            dgAnalysis.Columns[5].Visible = false;
            dgAnalysis.Columns[7].Visible = false;
            dgAnalysis.Columns[14].Visible = false;
            dgAnalysis.Columns[15].Visible = false;
            dgAnalysis.Columns[18].Visible = false;
            dgAnalysis.Columns[19].Visible = false;
        }

        string strFormat = Request.QueryString["period"].ToString().Trim();
        string strVersion = Request.QueryString["version"].ToString().Trim();

        dgAnalysis.Width = (strFormat == "ytd" && strVersion == "long")
                           ? 1825 :
                           ((strFormat == "ytd" && strVersion == "short") ? 1550 :
                           (strFormat == "mtd" && strVersion == "long") ? 800 : 700);


        BindDataToGrid();
    }

    

    public void BindDataGridHeader()
    {
        string strYearNew = ((Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) ? Request.QueryString["Year"].ToString().Trim() :
                   Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString().Trim()) + 1));

        string strYearDis = "'" + strYearNew.Substring(2);
        string strPreYearDis = "'" + (Convert.ToInt16(strYearNew) - 1).ToString().Substring(2);

        dgAnalysis.Columns[0].HeaderText = "Item";
        dgAnalysis.Columns[1].HeaderText = "Item Desc";
        dgAnalysis.Columns[2].HeaderText = "UOM";
        dgAnalysis.Columns[3].HeaderText = strYearDis + " Qty";
        dgAnalysis.Columns[4].HeaderText = strYearDis + " Sales $";
        dgAnalysis.Columns[5].HeaderText = strYearDis + " GM $";
        dgAnalysis.Columns[6].HeaderText = strYearDis + " GM %";
        dgAnalysis.Columns[7].HeaderText = strYearDis + " SellWgt";
        dgAnalysis.Columns[8].HeaderText = strYearDis + " $/Lb";
        dgAnalysis.Columns[9].HeaderText = strYearDis + " Ord";

        dgAnalysis.Columns[10].HeaderText = "YTD " + strYearDis + " Qty";
        dgAnalysis.Columns[11].HeaderText = "YTD " + strPreYearDis + " Qty";
        dgAnalysis.Columns[12].HeaderText = "YTD " + strYearDis + " Sales $";
        dgAnalysis.Columns[13].HeaderText = "YTD " + strPreYearDis + " Sales $";
        dgAnalysis.Columns[14].HeaderText = "YTD " + strYearDis + " GM$";
        dgAnalysis.Columns[15].HeaderText = "YTD " + strPreYearDis + " GM$";
        dgAnalysis.Columns[16].HeaderText = "YTD " + strYearDis + " GM%";
        dgAnalysis.Columns[17].HeaderText = "YTD " + strPreYearDis + " GM%";
        dgAnalysis.Columns[18].HeaderText = "YTD " + strYearDis + " SellWgt";
        dgAnalysis.Columns[19].HeaderText = "YTD " + strPreYearDis + " SellWgt";
        dgAnalysis.Columns[20].HeaderText = "YTD " + strYearDis + " $/Lb";
        dgAnalysis.Columns[21].HeaderText = "YTD " + strPreYearDis + " $/Lb";
        dgAnalysis.Columns[22].HeaderText = "YTD " + strYearDis + " Ord";
        dgAnalysis.Columns[23].HeaderText = "YTD " + strPreYearDis + " Ord";

        dgAnalysis.Columns[0].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[1].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[2].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
    }

    public void BindDataToGrid()
    {
        try
        {
            BindDataGridHeader();
            dgAnalysis.DataSource = (DataTable)Session["ItemSale"];
            dgAnalysis.DataBind();
        }
        catch (Exception ex) { Response.Write(ex.Message.ToString()); }
    }

    protected void dgAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Footer && Session["ItemSalesGrandTotal"] != null)
        {
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[0].CssClass = "GridHead";
            DataTable dtGrandTotal = Session["ItemSalesGrandTotal"] as DataTable;
            Total = dtGrandTotal.Rows[0];
            decimal dmlGrandTotal;
            for (int i = 1; i <= 23; i++)
            {
                dmlGrandTotal = 0;
                if (Total[i].ToString() != "")
                {

                    dmlGrandTotal = Convert.ToDecimal(Total[i].ToString());

                    e.Item.Cells[i].Text = (i == 6 || i == 16 || i == 17 || i == 21 || i == 22 || i == 8 || i == 20 || i == 22 || i == 23) ?
                                             dmlGrandTotal.ToString() :
                                             String.Format("{0:#,##0}", dmlGrandTotal);
                    e.Item.Cells[i].HorizontalAlign = HorizontalAlign.Right;
                    e.Item.Cells[i].CssClass = "GridHead";
                }
            }
        }
    }


}

