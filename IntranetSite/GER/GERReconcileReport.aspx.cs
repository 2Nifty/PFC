using System;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Collections.Specialized;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
using PFC.Intranet.Utility;

public partial class GERReconcileReport : System.Web.UI.Page
{
    string BOL;
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataRow GrandTotals;
    Utility utility = new Utility();
    int pagesize = 16;

    protected void Page_Init(object sender, EventArgs e)
    {
        Session["FooterTitle"] = "Goods En Route - GER to AP Reconciliation Report";
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            RunDateLabel.Text = DateTime.Now.Date.ToShortDateString();
            RunByLabel.Text = Session["UserName"].ToString();
            NameValueCollection pColl = Request.QueryString;
            string[] RunType = pColl.GetValues("RunType");
            RunTypeLabel.Text = RunType[0];
            string[] PassedBOL = pColl.GetValues("BOL");
            if (PassedBOL != null)
            {
                BOL = PassedBOL[0];
                //RunTypeLabel.Text = BOL;
            }
            else
            {
                BOL = "";
            }
            string[] BegDate = pColl.GetValues("BegDate");
            if (BegDate != null)
            {
                BegDateLabel.Text = BegDate[0];
            }
            else
            {
                BegDateLabel.Text = "None";
            }
            string[] EndDate = pColl.GetValues("EndDate");
            if (EndDate != null)
            {
                EndDateLabel.Text = EndDate[0];
            }
            else
            {
                EndDateLabel.Text = "None";
            }
            GLVariance.Text=GetVarianceAccounts();
            ExcelPath.Value = GetAppPref("ExcelPath");
            BindGrid();
        }

    }

    protected void BindGrid()
    {
        string GridColumns = "Hdr.BOLNo, max(BOLDate) as BolDate, sum(Det.UOMatlAmt) as BOLMatl";
        GridColumns += ", sum(UODutyAmt + UOOceanFrghtAmt + UOBrokerageAmt + UODrayAmt + UOMerchProcFee + UOHarborMaintFee + isnull(UOMiscWghtFee,0) + UOTrkFrghtAmt) as BOLLanded";
        GridColumns += ", 0.0 as APMatl, 0.0 as APLanded, 0.0 as GERvsAP, 0.0 as APVariance, 0.0 as GERTot, 0.0 as APTot, 0.0 as TotalVariance";
        ds = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[UGEN_SP_Select]",
            new SqlParameter("@tableName", "GERHeaderHist Hdr inner join GERDetailHist Det on Hdr.BOLNo=Det.BOLNo"),
            new SqlParameter("@displayColumns", GridColumns),
            new SqlParameter("@whereCondition", "Hdr.BOLNo='" + BOL + "' group by Hdr.BOLNo order by Hdr.BOLNo"));
        dt = ds.Tables[0];
        if (dt.Rows.Count == 0)
        {
            lblErrorMessage.Text = "Nothing on file for BOL " + BOL;
        }
        else
        {
            //lblSuccessMessage.Text = "BOL " + BOL + " processed";
            foreach (DataRow row in dt.Rows)
            {
                row["GERTot"] = (decimal)row["BOLMatl"] + (decimal)row["BOLLanded"];
                GetNVData(row);
                row["APTot"] = (decimal)row["APMatl"] + (decimal)row["APLanded"] + (decimal)row["APVariance"];
                row["GERvsAP"] = (decimal)row["GERTot"] - ((decimal)row["APMatl"] + (decimal)row["APLanded"]);
                row["TotalVariance"] = (decimal)row["GERTot"] - (decimal)row["APTot"];
            }
        }
        ReconGrid.DataSource = dt.DefaultView.ToTable();
        Pager1.InitPager(ReconGrid, pagesize);
    }

    protected void GetNVData(DataRow CurRow)
    {
        string VarAccts = GLVariance.Text;
        //string VarAccts = "1323,1327,1328,1329,1330,1331";
        string SqlStatement = "select BolNo, sum (APMatl) as APMatl,sum (APLanded) as APLanded, sum (APVariance) as APVariance from ";
        SqlStatement += " (select [Bill of Lading No_] as BolNo, ";
        SqlStatement += "case when Type = 2 then Quantity * [Direct Unit Cost] else 0 end as APMatl, ";
        SqlStatement += "case when Type = 1 and CHARINDEX(Det.[No_], '" + VarAccts + "') = 0  then Quantity * [Direct Unit Cost] else 0 end as APLanded, ";
        SqlStatement += "case when Type = 1 and CHARINDEX(Det.[No_], '" + VarAccts + "') <> 0 then Quantity * [Direct Unit Cost] else 0 end as APVariance ";
        SqlStatement += "from [Porteous$Purch_ Inv_ Line] Det ";
        SqlStatement += "where [Bill of Lading No_] = '" + CurRow["BOLNo"] + "') InvLine ";
        SqlStatement += "group by BolNo ";
        DataSet NVds = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["NVConnectionString"].ToString(), CommandType.Text, SqlStatement);
        DataTable NVdt = NVds.Tables[0];
        if (NVdt.Rows.Count == 0)
        {
            //CurRow["APMatl"] = -1;
            //CurRow["APLanded"] = -1;
            //CurRow["APVariance"] = -1;
        }
        else
        {
            CurRow["APMatl"] = (decimal)NVdt.Rows[0]["APMatl"];
            CurRow["APLanded"] = (decimal)NVdt.Rows[0]["APLanded"];
            CurRow["APVariance"] = (decimal)NVdt.Rows[0]["APVariance"];
        }
    }

    protected string GetVarianceAccounts()
    {
        string GERVariance = "";
        DataSet APds = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[UGEN_SP_Select]",
            new SqlParameter("@tableName", "AppPref"),
            new SqlParameter("@displayColumns", "AppOptionNumber"),
            new SqlParameter("@whereCondition", "(ApplicationCd = 'GER') AND (AppOptionType = 'VARGL') order by AppOptionNumber"));
        DataTable APdt = APds.Tables[0];
        if (APdt.Rows.Count == 0)
        {
            lblErrorMessage.Text = "!!!ERROR!!! Variance Accounts not in AppPref";
        }
        else
        {
            foreach (DataRow row in APdt.Rows)
            {
                GERVariance += row["AppOptionNumber"].ToString().Replace(".000000","") + ",";
            }
        }
        return GERVariance;
    }
    
    protected void ExcelButton_Click(object sender, ImageClickEventArgs e)
    {
        // 
        string ExcelFullPath = ExcelPath.Value + "GERAPRecon.xls";
        using (StreamWriter sw = new StreamWriter(ExcelFullPath))
        {
            foreach (DataGridColumn column in ReconGrid.Columns)
            {
                sw.Write(column.HeaderText);
                sw.Write("\t");
            }
            sw.WriteLine();
            foreach (DataGridItem row in ReconGrid.Items)
            {
                foreach (TableCell column in row.Cells)
                {
                    sw.Write(column.Text);
                    sw.Write("\t");
                }
                sw.WriteLine();
            }
        }
        Response.Redirect("file:" + ExcelFullPath);
    }

    public string GetAppPref(string OptType)
    {
        //try
        //{
        DataSet dsAppPref = new DataSet();
        dsAppPref = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[UGEN_SP_Select]",
                new SqlParameter("@tableName", "AppPref"),
                new SqlParameter("@displayColumns", "AppOptionValue"),
                new SqlParameter("@whereCondition", " (ApplicationCd = 'GER') AND (AppOptionType = '" + OptType + "')"));
        //}
        //catch (Exception ex)
        //{
        //}
        return dsAppPref.Tables[0].Rows[0]["AppOptionValue"].ToString(); ;
    }
}
