/********************************************************************************************
 * File	Name			:	DocumentSalesAnalysisPreview.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Retrive Data From Curvalsum Table - Customerwise.
 * Created By			:	Senthilkumar
 * Created Date			:	08/07/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/12/2005		    Version 1		Menaka		        Created
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


public partial class Sales_Analysis_Report_DocumentSalesAnalysisPreview : System.Web.UI.Page
{
    string strYear = string.Empty;
    DataRow Total;

    protected void Page_Load(object sender, EventArgs e)
    {

        DataTable dt = Session["DocumentSalesGrandTotal"] as DataTable;
        Total = dt.Rows[0];

        strYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";
        if (Request.QueryString["version"] == "long")
        {
            dgAnalysis.Columns[11].Visible = true;
            dgAnalysis.Columns[13].Visible = true;
            dgAnalysis.Columns[14].Visible = true;
            dgAnalysis.Width = 1200;
            //BindDataToGrid();
        }
        if (Request.QueryString["version"] == "short")
        {
            dgAnalysis.Columns[11].Visible = false;
            dgAnalysis.Columns[13].Visible = false;
            dgAnalysis.Columns[14].Visible = false;
            dgAnalysis.Width = 1000;
            //BindDataToGrid();
        }
        BindDataToGrid();
    }

    public void BindDataGridHeader()
    {
        for (int i = 1; i <= 16; i++)
            dgAnalysis.Columns[i].HeaderStyle.HorizontalAlign = HorizontalAlign.Right;

        dgAnalysis.Columns[0].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[1].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[2].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[3].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[4].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[5].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[6].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
    }


    public void BindDataToGrid()
    {
        try
        {
            BindDataGridHeader();
            dgAnalysis.DataSource = (DataTable)Session["DocSale"];
            dgAnalysis.DataBind();
        }
        catch (Exception ex) { Response.Write(ex.Message.ToString()); }
    }

    protected void dgAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Footer && Session["DocumentSalesGrandTotal"] != null)
        {
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[0].CssClass = "GridHead";
            DataTable dtGrandTotal = Session["DocumentSalesGrandTotal"] as DataTable;
            Total = dtGrandTotal.Rows[0];
            decimal dmlGrandTotal;
            for (int i = 1; i <= 16; i++)
            {
                dmlGrandTotal = 0;
                if (Total[i].ToString() != "")
                    dmlGrandTotal = Convert.ToDecimal(Total[i].ToString());

                e.Item.Cells[i].Text = (i == 12 || i == 15) ? (i == 12) ? String.Format("{0:0.0}", dmlGrandTotal) : String.Format("{0:0.00}", dmlGrandTotal) : String.Format("{0:#,###}", dmlGrandTotal);

                e.Item.Cells[i].HorizontalAlign = HorizontalAlign.Right;
                e.Item.Cells[i].CssClass = "GridHead";
            }
        }
    }


}

