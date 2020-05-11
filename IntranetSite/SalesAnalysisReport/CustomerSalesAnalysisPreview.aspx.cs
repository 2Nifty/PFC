/********************************************************************************************
 * File	Name			:	CustomerSalesAnalysisPreview.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Retrive Data From Curvalsum Table - Customerwise.
 * Created By			:	Senthilkumar
 * Created Date			:	08/07/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/12/2005		    Version 1		Menaka		        Created
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

using PFC.Intranet.Utility;


public partial class Sales_Analysis_Report_CustomerSalesAnalysisPreview : System.Web.UI.Page
{
    string strYear = string.Empty;
    DataRow Total;
    Utility utility = new Utility();

    protected void Page_Load(object sender, EventArgs e)
    {
        utility.CheckBrowserCompatibility(Request, dgAnalysis);
        DataTable dtFooter = Session["GrandTotal"] as DataTable;
        Total = dtFooter.Rows[0];

        strYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";

        if (Request.QueryString["version"] == "long")
        {
            ChangeVersion();
            DetVersion();

        }

        if (Request.QueryString["version"] == "short")
        {
            ChangeVersion();
            DetVersion();
        }

        if (Request.QueryString["period"] == "ytd")
        {
            ChangeVersion();
            DetVersion();
        }

        if (Request.QueryString["period"] == "mtd")
        {
            ChangeVersion();
            DetVersion();
        }

        BindDataToGrid();

    }
    public void ChangeVersion()
    {
        //bool mtdVisible = ((Request.QueryString["period"] == "mtd") ? true : false);
        //dgAnalysis.Columns[5].Visible = mtdVisible;
        //dgAnalysis.Columns[6].Visible = mtdVisible;
        //dgAnalysis.Columns[8].Visible = mtdVisible;
        //dgAnalysis.Columns[10].Visible = mtdVisible;
        //dgAnalysis.Columns[12].Visible = mtdVisible;
        //dgAnalysis.Columns[14].Visible = mtdVisible;

        bool ytdVisible = ((Request.QueryString["period"] == "ytd") ? true : false);
        dgAnalysis.Columns[15].Visible = ytdVisible;
        dgAnalysis.Columns[16].Visible = ytdVisible;
        dgAnalysis.Columns[18].Visible = ytdVisible;
        dgAnalysis.Columns[23].Visible = ytdVisible;
        dgAnalysis.Columns[28].Visible = ytdVisible;
        dgAnalysis.Columns[30].Visible = ytdVisible;
        dgAnalysis.Columns[19].Visible = ytdVisible;
        dgAnalysis.Columns[20].Visible = ytdVisible;
        dgAnalysis.Columns[21].Visible = ytdVisible;
        dgAnalysis.Columns[24].Visible = ytdVisible;
        dgAnalysis.Columns[25].Visible = ytdVisible;
        dgAnalysis.Columns[26].Visible = ytdVisible;
    }

    public void DetVersion()
    {
        bool longVersionmtd = (Request.QueryString["version"] == "long") ? true : false;

        dgAnalysis.Columns[7].Visible = longVersionmtd;
        dgAnalysis.Columns[9].Visible = longVersionmtd;
        dgAnalysis.Columns[11].Visible = longVersionmtd;
        dgAnalysis.Columns[13].Visible = longVersionmtd;

        bool longVersionYtd = (Request.QueryString["version"] == "long") ? ((Request.QueryString["period"] == "ytd") ? true : false) : false;
        dgAnalysis.Columns[17].Visible = longVersionYtd;
        dgAnalysis.Columns[22].Visible = longVersionYtd;
        dgAnalysis.Columns[27].Visible = longVersionYtd;
        dgAnalysis.Columns[29].Visible = longVersionYtd;

        dgAnalysis.Width = ((Request.QueryString["version"] == "long") && (Request.QueryString["period"] == "ytd"))
                           ? 2500 :
                           ((Request.QueryString["version"] == "short") && (Request.QueryString["period"] == "ytd")) ? 1600 : 1100;

        BindDataToGrid();
    }

    public void BindDataGridHeader()
    {
        string strYearNew = ((Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) ? Request.QueryString["Year"].ToString().Trim() :
                    Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString().Trim()) + 1));

        string strYearDis = "'" + strYearNew.Substring(2);
        string strPreYearDis = "'" + (Convert.ToInt16(strYearNew) - 1).ToString().Substring(2);

        dgAnalysis.Columns[0].HeaderText = "Cust #";
        dgAnalysis.Columns[1].HeaderText = "Name";
        dgAnalysis.Columns[2].HeaderText = "City";
        dgAnalysis.Columns[3].HeaderText = "Brn";
        dgAnalysis.Columns[4].HeaderText = "Chain";
        dgAnalysis.Columns[5].HeaderText = strYearDis + " Sales $";
        dgAnalysis.Columns[6].HeaderText = strPreYearDis + " Sales $";
        dgAnalysis.Columns[7].HeaderText = strYearDis + " GM$";
        dgAnalysis.Columns[8].HeaderText = strYearDis + " GM%";
        dgAnalysis.Columns[9].HeaderText = strPreYearDis + " GM$";
        dgAnalysis.Columns[10].HeaderText = strPreYearDis + " GM%";
        dgAnalysis.Columns[11].HeaderText = strYearDis + " Wgt";
        dgAnalysis.Columns[12].HeaderText = strYearDis + " $/Lb";
        dgAnalysis.Columns[13].HeaderText = strPreYearDis + " Wgt";
        dgAnalysis.Columns[14].HeaderText = strPreYearDis + " $/Lb";
        dgAnalysis.Columns[15].HeaderText = "YTD " + strYearDis + " Sales $";
        dgAnalysis.Columns[16].HeaderText = "YTD " + strPreYearDis + " Sales $";
        dgAnalysis.Columns[17].HeaderText = "YTD " + strYearDis + " GM$";
        dgAnalysis.Columns[18].HeaderText = "YTD " + strYearDis + " GM%";
        dgAnalysis.Columns[19].HeaderText = "YTD " + strYearDis + " Exp$";
        dgAnalysis.Columns[20].HeaderText = "YTD " + strYearDis + " NP$";
        dgAnalysis.Columns[21].HeaderText = "Accum " + strYearDis + " NP$";
        dgAnalysis.Columns[22].HeaderText = "YTD " + strPreYearDis + " GM$";
        dgAnalysis.Columns[23].HeaderText = "YTD " + strPreYearDis + " GM%";
        dgAnalysis.Columns[24].HeaderText = "YTD " + strPreYearDis + " Exp$";
        dgAnalysis.Columns[25].HeaderText = "YTD " + strPreYearDis + " NP$";
        dgAnalysis.Columns[26].HeaderText = "Accum " + strPreYearDis + " NP$";
        dgAnalysis.Columns[27].HeaderText = "YTD " + strYearDis + " Wgt";
        dgAnalysis.Columns[28].HeaderText = "YTD " + strYearDis + " $/Lb";
        dgAnalysis.Columns[29].HeaderText = "YTD " + strPreYearDis + " Wgt";
        dgAnalysis.Columns[30].HeaderText = "YTD " + strPreYearDis + " $/Lb";
        dgAnalysis.Columns[31].HeaderText = "Rep";
        dgAnalysis.Columns[32].HeaderText = "Group";
        dgAnalysis.Columns[33].HeaderText = "Zip";
        dgAnalysis.Columns[34].HeaderText = "PFC Rep";
        dgAnalysis.Columns[35].HeaderText = "ABC";
        dgAnalysis.Columns[36].HeaderText = "YTD Budget$";

        dgAnalysis.Columns[34].HeaderStyle.Wrap = false;
        dgAnalysis.Columns[36].HeaderStyle.Wrap = false;

        dgAnalysis.Columns[0].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[1].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[2].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[3].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[4].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[31].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[32].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[34].HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        dgAnalysis.Columns[36].HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
    }

    public void BindDataToGrid()
    {
        try
        {
            BindDataGridHeader();
            dgAnalysis.DataSource = (DataTable)Session["CustomerSale"];
            dgAnalysis.DataBind();
        }
        catch (Exception ex) { Response.Write(ex.Message.ToString()); }
    }

    protected void dgAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Footer && Session["GrandTotal"] != null)
        {
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[0].CssClass = "GridHead";
            DataTable dtGrandTotal = Session["GrandTotal"] as DataTable;
            Total = dtGrandTotal.Rows[0];
            decimal dmlGrandTotal;
            for (int i = 1; i <= 35; i++)
            {
                dmlGrandTotal = 0;
                if (Total[i].ToString() != "")
                {
                    if (i != 21 && i != 26)
                    {
                        dmlGrandTotal = Convert.ToDecimal(Total[i].ToString());
                        e.Item.Cells[i].Text = (i == 8 || i == 10 || i == 18 || i == 12 || i == 14 || i == 23 || i == 28 || i == 30) ?
                             (dmlGrandTotal.ToString() != "0.00") ? dmlGrandTotal.ToString() : "0.00" :
                            String.Format("{0:#,###}", dmlGrandTotal);
                    }
                }

                e.Item.Cells[i].HorizontalAlign = HorizontalAlign.Right;
                e.Item.Cells[i].CssClass = "GridHead";
            }
        }



    }

}

