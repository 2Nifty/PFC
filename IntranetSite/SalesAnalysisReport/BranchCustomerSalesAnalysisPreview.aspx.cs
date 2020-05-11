
/********************************************************************************************
 * File	Name			:	BranchCustomerSalesAnalysisPreview.aspx.cs
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


public partial class Sales_Analysis_Report_BranchCustomerSalesAnalysisPreview : System.Web.UI.Page
{
    string strYear = string.Empty;
    string strVersion = string.Empty;
    string strPeriod = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        strYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";

        strVersion = (Request.QueryString["Version"] != null) ? Request.QueryString["Version"].ToString().Trim() : "";
        strPeriod = (Request.QueryString["Period"] != null) ? Request.QueryString["Period"].ToString().Trim() : "";
        ChangeFormat();
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
        dgAnalysis.Columns[5].HeaderText = strYearDis + " Sales";
        dgAnalysis.Columns[6].HeaderText = strPreYearDis + " Sales";
        dgAnalysis.Columns[7].HeaderText = strYearDis + " GM$";
        dgAnalysis.Columns[8].HeaderText = strYearDis + " GM%";
        dgAnalysis.Columns[9].HeaderText = strPreYearDis + " GM$";
        dgAnalysis.Columns[10].HeaderText = strPreYearDis + " GM%";
        dgAnalysis.Columns[11].HeaderText = strYearDis + " Wgt";
        dgAnalysis.Columns[12].HeaderText = strYearDis + " $/Lb";
        dgAnalysis.Columns[13].HeaderText = strPreYearDis + " Wgt";
        dgAnalysis.Columns[14].HeaderText = strPreYearDis + " $/Lb";
        dgAnalysis.Columns[15].HeaderText = "YTD " + strYearDis + " Sales";
        dgAnalysis.Columns[16].HeaderText = "YTD " + strPreYearDis + " Sales";
        dgAnalysis.Columns[17].HeaderText = "YTD " + strYearDis + " GM$";
        dgAnalysis.Columns[18].HeaderText = "YTD " + strYearDis + " GM%";
        dgAnalysis.Columns[19].HeaderText = "YTD " + strPreYearDis + " GM$";
        dgAnalysis.Columns[20].HeaderText = "YTD " + strPreYearDis + " GM%";
        dgAnalysis.Columns[21].HeaderText = "YTD " + strYearDis + " Wgt";
        dgAnalysis.Columns[22].HeaderText = "YTD " + strYearDis + " $/Lb";
        dgAnalysis.Columns[23].HeaderText = "YTD " + strPreYearDis + " Wgt";
        dgAnalysis.Columns[24].HeaderText = "YTD " + strPreYearDis + " $/Lb";
        dgAnalysis.Columns[25].HeaderText = "Rep";
        dgAnalysis.Columns[26].HeaderText = "Group";

        for (int i = 0; i <= 26; i++)
        {
            dgAnalysis.Columns[i].HeaderStyle.HorizontalAlign = HorizontalAlign.Right;
        }
        dgAnalysis.Columns[0].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[1].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[2].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[3].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[4].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[25].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[26].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[27].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
    }


    public void BindDataToGrid()
    {
        try
        {
            BindDataGridHeader();
            dgAnalysis.DataSource = (DataTable)Session["BranchCustomer"];
            dgAnalysis.DataBind();
        }
        catch (Exception ex) { Response.Write(ex.Message.ToString()); }
    }

    protected void dgAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.Footer && Session["dtBranchCustomerSalesGrandTotal"] != null)
        {
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[0].CssClass = "GridHead";

            System.Data.DataTable dtFooter = Session["dtBranchCustomerSalesGrandTotal"] as System.Data.DataTable;

            DataRow ColTotal = dtFooter.Rows[0];
            decimal dmlGrandTotal;
            for (int iCnt = 5; iCnt <= 26; iCnt++)
            {
                dmlGrandTotal = 0;
                if (ColTotal[iCnt].ToString() != "")
                    dmlGrandTotal = Convert.ToDecimal(ColTotal[iCnt].ToString());

                if (iCnt == 8 || iCnt == 10 || iCnt == 18 || iCnt == 20)
                    e.Item.Cells[iCnt].Text = String.Format("{0:0.0}", dmlGrandTotal);
                else if (iCnt == 12 || iCnt == 14 || iCnt == 22 || iCnt == 24)
                    e.Item.Cells[iCnt].Text = String.Format("{0:0.00}", dmlGrandTotal);
                else
                    e.Item.Cells[iCnt].Text = String.Format("{0:#,###}", dmlGrandTotal);


                e.Item.Cells[iCnt].HorizontalAlign = HorizontalAlign.Right;
                e.Item.Cells[iCnt].CssClass = "GridHead";
            }
        }


    }

    public void ChangeFormat()
    {

        bool version1 = ((strVersion == "long" && strPeriod == "ytd") || (strVersion == "long" && strPeriod == "mtd")) ? true : false;
        dgAnalysis.Columns[7].Visible = version1;
        dgAnalysis.Columns[9].Visible = version1;
        dgAnalysis.Columns[11].Visible = version1;
        dgAnalysis.Columns[13].Visible = version1;

        bool version = (strVersion == "long" && strPeriod == "ytd") ? true : false;
        dgAnalysis.Columns[17].Visible = version;
        dgAnalysis.Columns[19].Visible = version;
        dgAnalysis.Columns[21].Visible = version;
        dgAnalysis.Columns[23].Visible = version;


        bool period = (strPeriod == "ytd") ? true : false;
        dgAnalysis.Columns[15].Visible = period;
        dgAnalysis.Columns[16].Visible = period;
        dgAnalysis.Columns[18].Visible = period;
        dgAnalysis.Columns[20].Visible = period;
        dgAnalysis.Columns[22].Visible = period;
        dgAnalysis.Columns[24].Visible = period;

        dgAnalysis.Width = (strPeriod == "ytd" && strVersion == "long")
                            ? 1700 :
                            ((strPeriod == "ytd" && strVersion == "short") ? 1600 : 1000);

        BindDataToGrid();
    }
}

