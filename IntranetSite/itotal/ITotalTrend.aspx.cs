using System;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Printing;
using System.Configuration;
using System.Collections;
using System.Collections.Specialized;
using System.IO;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;

public partial class ITotalTrend : System.Web.UI.Page
{
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    string connectionString = ConfigurationManager.ConnectionStrings["csERP"].ToString();

    protected void Page_Init(object sender, EventArgs e)
    {
        Session["FooterTitle"] = "I-Total Month to Date Trend Report";
        //lblUserInfo.Text = DateTime.Now.ToLongDateString() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; You have logged in as <strong>" + Session["UserName"].ToString() + "</strong> in <strong>" + System.Configuration.ConfigurationManager.AppSettings["Environment"];
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // get the data.
            ds = SqlHelper.ExecuteDataset(connectionString, "[pITotalMTDTrend]");
            if (ds.Tables.Count == 1)
            {
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    TrendGrid.DataSource = dt;
                    TrendGrid.DataBind();
                    DataRow drow = dt.Rows[dt.Rows.Count - 1];
                    DateTime periodDate = (DateTime)drow["CurrentDt"];
                    periodDate = periodDate.AddDays(15);
                    PeriodLabel.Text = periodDate.ToString("MMMM yyyy");
                }
            }
        }
        else
        {
        }
    }


    protected void ExcelExportButton_Click(object sender, ImageClickEventArgs e)
    {
        //string ExcelPath = ConfigurationManager.AppSettings["CPRExcelFilePath"].ToString() + "CPRExcel.xls";
        string SiteFileName = @"Excel\"
            + Session["UserName"].ToString()
            + "Export.xls";
        CreateReport(SiteFileName);
        Response.Redirect(SiteFileName);
    }

    public void CreateReport(string FileName)
    {
        string FullFilePath = Server.MapPath(FileName);
        using (StreamWriter sw = new StreamWriter(FullFilePath))
        {
            sw.WriteLine("<html><head>");
            sw.WriteLine("<title>ITotal Trends</title>");
            sw.WriteLine("</head><body>");
            sw.WriteLine("<b>");
            sw.WriteLine(lblParentMenuName.Text);
            sw.WriteLine("&nbsp;&nbsp;&nbsp;");
            sw.WriteLine(PeriodLabel.Text);
            sw.WriteLine("</b>");
            sw.WriteLine("<table border=0 cellspacing=0 cellpadding=2>");
            sw.WriteLine("<tr>");
            foreach (TableCell hcell in TrendGrid.HeaderRow.Cells)
            {
                sw.WriteLine("<td align='center'><b>");
                sw.WriteLine(hcell.Text);
                sw.WriteLine("</b></td>");
            }
            sw.WriteLine("</tr>");
            foreach (TableRow trow in TrendGrid.Rows)
            {
                sw.WriteLine("<tr>");
                foreach (TableCell tcell in trow.Cells)
                {
                    sw.WriteLine("<td width=100>");
                    sw.WriteLine(tcell.Text);
                    sw.WriteLine("</td>");
                }
                sw.WriteLine("</tr>");
            }
            sw.WriteLine("</table>");
            sw.WriteLine("</table></body></html>");
        }
    }

}
