using System;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class RGASummary : System.Web.UI.Page
{
    SqlDataAdapter adp;
    DataSet ds = new DataSet();

    //string cmdFiscalPeriod = "SELECT DISTINCT FiscalPeriod, CASE FiscalCalMonth WHEN 1 THEN 'Jan ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 2 THEN 'Feb ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 3 THEN 'Mar ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 4 THEN 'Apr ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 5 THEN 'May ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 6 THEN 'Jun ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 7 THEN 'Jul ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 8 THEN 'Aug ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 9 THEN 'Sep ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 10 THEN 'Oct ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 11 THEN 'Nov ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 12 THEN 'Dec ' + CAST(FiscalYear AS VARCHAR(4)) END AS [Fiscal Month], CAST(DATEPART(yyyy,CurFiscalMthBeginDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthBeginDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthBeginDt) as varchar(2)),2) AS CurFiscalMthBeginDt, CAST(DATEPART(yyyy,CurFiscalMthEndDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthEndDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthEndDt) as varchar(2)),2) AS CurFiscalMthEndDt, CAST(DATEPART(yyyy,CurFiscalMthBeginDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthBeginDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthBeginDt) as varchar(2)),2) + '|' + CAST(DATEPART(yyyy,CurFiscalMthEndDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthEndDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthEndDt) as varchar(2)),2) AS CurFiscalMth FROM FiscalCalendar WHERE CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) <= CurFiscalMthBeginDt AND CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) <= CurFiscalMthEndDt AND (CAST(DATEPART(yyyy,GETDATE()) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()) as varchar(2)),2) = CurrentDt OR CAST(DATEPART(yyyy,GETDATE()) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()) as varchar(2)),2) >= CurFiscalMthEndDt) ORDER BY CAST(DATEPART(yyyy,CurFiscalMthBeginDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthBeginDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthBeginDt) as varchar(2)),2) DESC";
    string cmdFiscalPeriod = "SELECT DISTINCT FiscalPeriod, CASE FiscalCalMonth WHEN 1 THEN 'Jan ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 2 THEN 'Feb ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 3 THEN 'Mar ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 4 THEN 'Apr ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 5 THEN 'May ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 6 THEN 'Jun ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 7 THEN 'Jul ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 8 THEN 'Aug ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 9 THEN 'Sep ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 10 THEN 'Oct ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 11 THEN 'Nov ' + CAST(FiscalYear AS VARCHAR(4)) WHEN 12 THEN 'Dec ' + CAST(FiscalYear AS VARCHAR(4)) END AS [Fiscal Month], CAST(DATEPART(yyyy,CurFiscalMthBeginDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthBeginDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthBeginDt) as varchar(2)),2) AS CurFiscalMthBeginDt, CAST(DATEPART(yyyy,CurFiscalMthEndDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthEndDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthEndDt) as varchar(2)),2) AS CurFiscalMthEndDt, CAST(DATEPART(yyyy,CurFiscalMthBeginDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthBeginDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthBeginDt) as varchar(2)),2) + '|' + CAST(DATEPART(yyyy,CurFiscalMthEndDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthEndDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthEndDt) as varchar(2)),2) AS CurFiscalMth FROM FiscalCalendar WHERE (CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) = CurrentDt) OR (CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) <= CurFiscalMthBeginDt AND CAST(DATEPART(yyyy,GETDATE()-365) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()-365) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()-365) as varchar(2)),2) <= CurFiscalMthEndDt AND (CAST(DATEPART(yyyy,GETDATE()) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()) as varchar(2)),2) = CurrentDt OR CAST(DATEPART(yyyy,GETDATE()) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,GETDATE()) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,GETDATE()) as varchar(2)),2) >= CurFiscalMthEndDt)) ORDER BY CAST(DATEPART(yyyy,CurFiscalMthBeginDt) as VARCHAR(4)) + '-' + RIGHT('00' + CAST(DATEPART(mm,CurFiscalMthBeginDt) as varchar(2)),2) + '-' + RIGHT('00' + CAST(DATEPART(dd,CurFiscalMthBeginDt) as varchar(2)),2) DESC";
    string cnxERP = System.Configuration.ConfigurationManager.ConnectionStrings["csERP"].ConnectionString.ToString();
    
    string cmdRGASummary;
    string cnxNV = System.Configuration.ConfigurationManager.ConnectionStrings["csNV"].ConnectionString.ToString();

    string BeginDt, EndDt;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            btnClose.Attributes.Add("onclick", "javascript:window.location='" + Request.ServerVariables.Get("HTTP_REFERER") + "'");
            BindFiscalPeriod();
        }

        BeginDt = ddFiscalPeriod.SelectedValue.Substring(0, 10).ToString();
        EndDt = ddFiscalPeriod.SelectedValue.Substring(11, 10).ToString();

        lblBeginDt.Text = BeginDt;
        lblEndDt.Text = EndDt;

        cmdRGASummary = "SELECT CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + RIGHT('00' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)),2) AS [Date], [Location Code], [Return Reason Code], COUNT([Return Reason Code]) AS [Record Count], SUM(ExtValue) AS ExtendedValue FROM (SELECT [Posting Date], [Location Code], [Return Reason Code], [Document No_], [Line No_], [Sell-to Customer No_], Type, No_, Quantity, Quantity * [Unit Cost (LCY)] AS ExtValue FROM [Porteous$Sales Cr_Memo Line] WHERE (Quantity * [Unit Cost (LCY)] > 0) and ([Return Reason Code]<>'') and ([Posting Date] BETWEEN CONVERT(DATETIME, '";
        cmdRGASummary = cmdRGASummary + BeginDt + "', 102) AND CONVERT(DATETIME, '" + EndDt + "', 102)) AND (Type = 2)) Reasons GROUP BY [Location Code], [Return Reason Code], CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + RIGHT('00' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)),2) ORDER BY CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + RIGHT('00' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)),2), [Location Code], [Return Reason Code]";

        if (!Page.IsPostBack)
            BindDataGrid();

    }

    protected void ddFiscalPeriod_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridView1.CurrentPageIndex = 0;

        BeginDt = ddFiscalPeriod.SelectedValue.Substring(0, 10).ToString();
        EndDt = ddFiscalPeriod.SelectedValue.Substring(11, 10).ToString();

        lblBeginDt.Text = BeginDt;
        lblEndDt.Text = EndDt;

        cmdRGASummary = "SELECT CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + RIGHT('00' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)),2) AS [Date], [Location Code], [Return Reason Code], COUNT([Return Reason Code]) AS [Record Count], SUM(ExtValue) AS ExtendedValue FROM (SELECT [Posting Date], [Location Code], [Return Reason Code], [Document No_], [Line No_], [Sell-to Customer No_], Type, No_, Quantity, Quantity * [Unit Cost (LCY)] AS ExtValue FROM [Porteous$Sales Cr_Memo Line] WHERE (Quantity * [Unit Cost (LCY)] > 0) and ([Return Reason Code]<>'') and ([Posting Date] BETWEEN CONVERT(DATETIME, '";
        cmdRGASummary = cmdRGASummary + BeginDt + "', 102) AND CONVERT(DATETIME, '" + EndDt + "', 102)) AND (Type = 2)) Reasons GROUP BY [Location Code], [Return Reason Code], CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + RIGHT('00' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)),2) ORDER BY CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + RIGHT('00' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)),2), [Location Code], [Return Reason Code]";

        BindDataGrid();
    }

    public void BindDataGrid()
    {
        adp = new SqlDataAdapter(cmdRGASummary, cnxNV);
        adp.Fill(ds, "RGASummary");
        GridView1.DataSource = ds.Tables["RGASummary"];
        GridView1.DataBind();
        Pager1.InitPager(GridView1, 20);
    }

    public void BindFiscalPeriod()
    {
        adp = new SqlDataAdapter(cmdFiscalPeriod, cnxERP);
        adp.Fill(ds, "FiscalPeriod");
        ddFiscalPeriod.DataSource = ds.Tables["FiscalPeriod"];
        ddFiscalPeriod.DataTextField = "Fiscal Month";
        ddFiscalPeriod.DataValueField = "CurFiscalMth";
        ddFiscalPeriod.DataBind();
        ddFiscalPeriod.SelectedIndex = 1;
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        GridView1.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void GridView1_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
    {
        //Set the page # and Re-Bind data grid
        GridView1.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
    }

    protected void ExportRpt_Click(object sender, ImageClickEventArgs e)
    {
        char tab = '\t';
        
        adp = new SqlDataAdapter(cmdRGASummary, cnxNV);

        //string filestamp = DateTime.Now.ToString().Replace("/", "");
        //filestamp = filestamp.Replace(" ", "");
        //filestamp = filestamp.Replace(":", "");

        String xlsFile = "RGASummary" + ddFiscalPeriod.SelectedIndex + ".xls";
        String ExportFile = Server.MapPath("..//KPIReports//Excel//") + xlsFile;

        //FileInfo xlsInfo = new FileInfo(ExportFile);
        //if (xlsInfo.Exists)
        //    File.Delete(ExportFile);

        StreamWriter swExcel = new StreamWriter(ExportFile, false);

        swExcel.WriteLine("Date" + tab + "Location" + tab + "Return Reason Code" + tab + "Record Count" + tab + "Extended Value");

        adp.Fill(ds, "RGASummary");

        foreach (DataRow RGArow in ds.Tables["RGASummary"].Rows)
            swExcel.WriteLine(RGArow["Date"].ToString() + tab + RGArow["Location Code"].ToString() + tab + RGArow["Return Reason Code"].ToString() + tab + RGArow["Record Count"].ToString() + tab + String.Format("{0:c}", RGArow["ExtendedValue"]));
        
        swExcel.Close();

        Response.Redirect("ExcelExport.aspx?Filename=../KPIReports/Excel/" + xlsFile, true);
    }
}
