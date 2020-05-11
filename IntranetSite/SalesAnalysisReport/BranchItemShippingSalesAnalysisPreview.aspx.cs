
/********************************************************************************************
 * File	Name			:	BranchItemSalesAnalysisPreview.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Retrive Data From Curvalsum Table - Customerwise.
 * Created By			:	Senthilkumar
 * Created Date			:	08/07/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/12/2005		    Version 1		Senthilkumar		Excel Report Added 
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


public partial class Sales_Analysis_Report_BranchItemShippingSalesAnalysisPreview : System.Web.UI.Page
{
    string strYear = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        strYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";
        if (Request.QueryString["version"] == "long")
        {
            if (Request.QueryString["period"].ToString() == "ytd")
            {
                LongVersion();
                MtdVersion();
                dgAnalysis.Width = 800;
            }
            else
            {
                LongVersion();
                YtdVersion();
                dgAnalysis.Width = 1800;
            }

            BindDataToGrid();
        }
        if (Request.QueryString["version"] == "short")
        {
            if (Request.QueryString["period"].ToString() == "ytd")
            {
                MtdVersion();
                ShortVersion();
                dgAnalysis.Width = 650;
            }
            else
            {
                YtdVersion();
                ShortVersion();
                dgAnalysis.Width = 1300;
            }
            BindDataToGrid();
        }

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
        dgAnalysis.Columns[6].HeaderText = " GM %";
        dgAnalysis.Columns[7].HeaderText = strYearDis + " SellWgt";
        dgAnalysis.Columns[8].HeaderText = " $/Lb";
        dgAnalysis.Columns[9].HeaderText = strYearDis + " Ord";

        dgAnalysis.Columns[10].HeaderText = "YTD" + strYearDis + " Qty";
        dgAnalysis.Columns[11].HeaderText = "YTD" + strPreYearDis + " Qty";
        dgAnalysis.Columns[12].HeaderText = "YTD" + strYearDis + " Sales $";
        dgAnalysis.Columns[13].HeaderText = "YTD" + strPreYearDis + " Sales $";
        dgAnalysis.Columns[14].HeaderText = "YTD" + strYearDis + " GM$";
        dgAnalysis.Columns[15].HeaderText = "YTD" + strPreYearDis + " GM$";
        dgAnalysis.Columns[16].HeaderText = "YTD" + strYearDis + " GM%";
        dgAnalysis.Columns[17].HeaderText = "YTD" + strPreYearDis + " GM%";
        dgAnalysis.Columns[18].HeaderText = "YTD" + strYearDis + " SellWgt";
        dgAnalysis.Columns[19].HeaderText = "YTD" + strPreYearDis + " SellWgt";
        dgAnalysis.Columns[20].HeaderText = "YTD" + strYearDis + " $/Lb";
        dgAnalysis.Columns[21].HeaderText = "YTD" + strPreYearDis + " $/Lb";
        dgAnalysis.Columns[22].HeaderText = "YTD" + strYearDis + " Ord";
        dgAnalysis.Columns[23].HeaderText = "YTD" + strPreYearDis + " Ord";

        for (int i = 0; i <= 23; i++)
            dgAnalysis.Columns[i].HeaderStyle.HorizontalAlign = HorizontalAlign.Right;

        dgAnalysis.Columns[0].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[1].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[2].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
    }

    public void BindDataToGrid()
    {
        try
        {
            BindDataGridHeader();
            dgAnalysis.DataSource = (DataTable)Session["BranchItem"];
            dgAnalysis.DataBind();
        }
        catch (Exception ex) { Response.Write(ex.Message.ToString()); }
    }

    protected void dgAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Footer && Session["dtGrandTotal"] != null)
        {

            System.Data.DataTable dtFooter = Session["dtGrandTotal"] as System.Data.DataTable;

            DataRow dr = dtFooter.Rows[0];

            e.Item.Cells[0].Text = "Total";
            //e.Item.Cells[3].Text = CMQty.ToString();
            //e.Item.Cells[3].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[3].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CM_InvQty"].ToString() != "" ? dr["CM_InvQty"].ToString() : "0")));
            e.Item.Cells[3].HorizontalAlign = HorizontalAlign.Right;

            e.Item.Cells[4].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CM_sales"].ToString() != "" ? dr["CM_sales"].ToString() : "0")));
            e.Item.Cells[4].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[5].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CM_GM$"].ToString() != "" ? dr["CM_GM$"].ToString() : "0")));
            e.Item.Cells[5].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[6].Text = string.Format("{0:0.0}", Convert.ToDouble((dr["CM_GMPer"].ToString() != "" ? dr["CM_GMPer"].ToString() : "0")));
            e.Item.Cells[6].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[7].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CM_SellWgt"].ToString() != "" ? dr["CM_SellWgt"].ToString() : "0")));
            e.Item.Cells[7].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[8].Text = string.Format("{0:0.00}", Convert.ToDouble((dr["CM_lb"].ToString() != "" ? dr["CM_lb"].ToString() : "0")));
            e.Item.Cells[8].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[9].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CM_order"].ToString() != "" ? dr["CM_order"].ToString() : "0")));
            e.Item.Cells[9].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[10].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CY_InvQty"].ToString() != "" ? dr["CY_InvQty"].ToString() : "0")));
            e.Item.Cells[10].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[11].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["PY_InvQty"].ToString() != "" ? dr["PY_InvQty"].ToString() : "0")));
            e.Item.Cells[11].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[12].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CY_Sales"].ToString() != "" ? dr["CY_Sales"].ToString() : "0")));
            e.Item.Cells[12].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[13].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["PY_Sales"].ToString() != "" ? dr["PY_Sales"].ToString() : "0")));
            e.Item.Cells[13].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[14].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CY_GM$"].ToString() != "" ? dr["CY_GM$"].ToString() : "0")));
            e.Item.Cells[14].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[15].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["PY_GM$"].ToString() != "" ? dr["PY_GM$"].ToString() : "0")));
            e.Item.Cells[15].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[16].Text = string.Format("{0:0.0}", Convert.ToDouble((dr["CY_GMPer"].ToString() != "" ? dr["CY_GMPer"].ToString() : "0")));
            e.Item.Cells[16].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[17].Text = string.Format("{0:0.0}", Convert.ToDouble((dr["PY_GMPer"].ToString() != "" ? dr["PY_GMPer"].ToString() : "0")));
            e.Item.Cells[17].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[18].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CY_Sellwgt"].ToString() != "" ? dr["CY_Sellwgt"].ToString() : "0")));
            e.Item.Cells[18].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[19].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["PY_Sellwgt"].ToString() != "" ? dr["PY_Sellwgt"].ToString() : "0")));
            e.Item.Cells[19].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[20].Text = string.Format("{0:0.00}", Convert.ToDouble((dr["CY_lb"].ToString() != "" ? dr["CY_lb"].ToString() : "0")));
            e.Item.Cells[20].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[21].Text = string.Format("{0:0.00}", Convert.ToDouble((dr["PY_lb"].ToString() != "" ? dr["PY_lb"].ToString() : "0")));
            e.Item.Cells[21].HorizontalAlign = HorizontalAlign.Right;

            e.Item.Cells[22].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CY_Order"].ToString() != "" ? dr["CY_Order"].ToString() : "0")));
            e.Item.Cells[22].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[23].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["PY_Order"].ToString() != "" ? dr["PY_Order"].ToString() : "0")));
            e.Item.Cells[23].HorizontalAlign = HorizontalAlign.Right;
        }
        e.Item.Cells[1].Width = 75;
        e.Item.Cells[1].Width = 250;
    }
    private void LongVersion()
    {
        dgAnalysis.Columns[5].Visible = true;
        dgAnalysis.Columns[7].Visible = true;
        dgAnalysis.Columns[14].Visible = true;
        dgAnalysis.Columns[15].Visible = true;
        dgAnalysis.Columns[18].Visible = true;
        dgAnalysis.Columns[19].Visible = true;

    }
    private void ShortVersion()
    {
        dgAnalysis.Columns[5].Visible = false;
        dgAnalysis.Columns[7].Visible = false;
        dgAnalysis.Columns[14].Visible = false;
        dgAnalysis.Columns[15].Visible = false;
        dgAnalysis.Columns[18].Visible = false;
        dgAnalysis.Columns[19].Visible = false;
    }
    private void MtdVersion()
    {


        dgAnalysis.Columns[10].Visible = false;
        dgAnalysis.Columns[11].Visible = false;
        dgAnalysis.Columns[12].Visible = false;
        dgAnalysis.Columns[13].Visible = false;
        dgAnalysis.Columns[14].Visible = false;
        dgAnalysis.Columns[15].Visible = false;
        dgAnalysis.Columns[16].Visible = false;
        dgAnalysis.Columns[17].Visible = false;
        dgAnalysis.Columns[18].Visible = false;
        dgAnalysis.Columns[19].Visible = false;
        dgAnalysis.Columns[20].Visible = false;
        dgAnalysis.Columns[21].Visible = false;
        dgAnalysis.Columns[22].Visible = false;
        dgAnalysis.Columns[23].Visible = false;
    }
    private void YtdVersion()
    {



        dgAnalysis.Columns[10].Visible = true;
        dgAnalysis.Columns[11].Visible = true;
        dgAnalysis.Columns[12].Visible = true;
        dgAnalysis.Columns[13].Visible = true;
        dgAnalysis.Columns[14].Visible = true;
        dgAnalysis.Columns[15].Visible = true;
        dgAnalysis.Columns[16].Visible = true;
        dgAnalysis.Columns[17].Visible = true;
        dgAnalysis.Columns[18].Visible = true;
        dgAnalysis.Columns[19].Visible = true;
        dgAnalysis.Columns[20].Visible = true;
        dgAnalysis.Columns[21].Visible = true;
        dgAnalysis.Columns[22].Visible = true;
        dgAnalysis.Columns[23].Visible = true;
    }

}

