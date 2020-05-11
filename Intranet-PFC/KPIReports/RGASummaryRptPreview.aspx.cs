using System;
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

public partial class RGASummaryRptPreview : System.Web.UI.Page
{
    SqlDataAdapter adp;
    DataSet ds = new DataSet();
    string cmdRGASummary;
    string cnxNV = System.Configuration.ConfigurationManager.ConnectionStrings["csNV"].ConnectionString.ToString();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            cmdRGASummary = "SELECT CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + RIGHT('00' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)),2) AS [Date], [Location Code], [Return Reason Code], COUNT([Return Reason Code]) AS [Record Count], SUM(ExtValue) AS ExtendedValue FROM (SELECT [Posting Date], [Location Code], [Return Reason Code], [Document No_], [Line No_], [Sell-to Customer No_], Type, No_, Quantity, Quantity * [Unit Cost (LCY)] AS ExtValue FROM [Porteous$Sales Cr_Memo Line] WHERE (Quantity * [Unit Cost (LCY)] > 0) and ([Return Reason Code]<>'') and ([Posting Date] BETWEEN CONVERT(DATETIME, '";
            cmdRGASummary = cmdRGASummary + Request.QueryString["BeginDt"].ToString() + "', 102) AND CONVERT(DATETIME, '" + Request.QueryString["EndDt"].ToString() + "', 102)) AND (Type = 2)) Reasons GROUP BY [Location Code], [Return Reason Code], CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + RIGHT('00' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)),2) ORDER BY CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + RIGHT('00' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)),2), [Location Code], [Return Reason Code]";
            BindDataGrid();
        }
    }

    public void BindDataGrid()
    {
        adp = new SqlDataAdapter(cmdRGASummary, cnxNV);
        adp.Fill(ds, "RGASummary");
        GridView1.DataSource = ds.Tables[0];
        GridView1.DataBind();
    }
}

