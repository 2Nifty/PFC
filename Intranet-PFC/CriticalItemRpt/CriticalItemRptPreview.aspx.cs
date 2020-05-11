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
using System.Data.SqlClient;

public partial class CriticalItemRptPreview : System.Web.UI.Page
{
    Int32 TotItemCount = 0;
    Int32 TotCriticalCount = 0;
    Int32 TotCriticalLbs = 0;
    Int32 TotLbs = 0;
    
    protected void Page_Load(object sender, EventArgs e)
    {

        BindDataToGrid();
        
        decimal Count = GridView1.Items.Count;
        for (int i = 0; i < Count; i++)
            GridView1.Items[i].Font.Size = 8;
    }

    public void BindDataToGrid()
    {
        try
        {
            if (Request.QueryString["VelocityType"].ToString() == "Corp")
            {
                //Response.Write(Request.QueryString["VelocityType"].ToString());
                lblVelocityType.Text = "Corp Fixed Velocity";
                string cmd = "SELECT [VelocityCode], [TotCount], [CriticalCount], [CriticalCountPct], [TotWght], [TotWghtCritical], [CriticalWghtPct], [NonCriticalWghtPct], [TargetPct] FROM [CriticalItemSummary] WHERE ([LocationCode] = '" + Request.QueryString["LocNum"].ToString() + "')";
                SqlDataAdapter adp = new SqlDataAdapter(cmd, System.Configuration.ConfigurationManager.ConnectionStrings["csPFCReports"].ConnectionString);
                DataSet ds = new DataSet();
                adp.Fill(ds);
                GridView1.DataSource = ds.Tables[0];
                GridView1.DataBind();
            }
            if (Request.QueryString["VelocityType"].ToString() == "Cat")
            {
                //Response.Write(Request.QueryString["VelocityType"].ToString());
                lblVelocityType.Text = "Category Velocity";
                string cmd = "SELECT [VelocityCode], [TotCount], [CriticalCount], [CriticalCountPct], [TotWght], [TotWghtCritical], [CriticalWghtPct], [NonCriticalWghtPct], [TargetPct] FROM [CriticalItemSummaryCat] WHERE ([LocationCode] = '" + Request.QueryString["LocNum"].ToString() + "')";
                SqlDataAdapter adp = new SqlDataAdapter(cmd, System.Configuration.ConfigurationManager.ConnectionStrings["csPFCReports"].ConnectionString);
                DataSet ds = new DataSet();
                adp.Fill(ds);
                GridView1.DataSource = ds.Tables[0];
                GridView1.DataBind();
            }
    }
    catch (Exception ex) { Response.Write(ex.Message.ToString()); }
    }

    protected void Total_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            //Response.Write(Convert.ToInt32(e.Item.Cells[6].Text));

            TotItemCount = TotItemCount + Convert.ToInt32(e.Item.Cells[2].Text);
            TotCriticalCount = TotCriticalCount + Convert.ToInt32(e.Item.Cells[4].Text);

            TotLbs = TotLbs + Convert.ToInt32(e.Item.Cells[6].Text);
            e.Item.Cells[6].Text = String.Format("{0:0,0}", Convert.ToInt32(e.Item.Cells[6].Text));

            TotCriticalLbs = TotCriticalLbs + Convert.ToInt32(e.Item.Cells[7].Text);
            e.Item.Cells[7].Text = String.Format("{0:0,0}", Convert.ToInt32(e.Item.Cells[7].Text));
        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            //Response.Write(TotItemCount);

            e.Item.Cells[1].Text = Convert.ToString(TotItemCount);
            e.Item.Cells[1].Text = String.Format("{0:0,0}", Convert.ToInt32(e.Item.Cells[1].Text));

            e.Item.Cells[3].Text = Convert.ToString(TotCriticalCount);
            e.Item.Cells[3].Text = String.Format("{0:0,0}", Convert.ToInt32(e.Item.Cells[3].Text));

            e.Item.Cells[5].Text = Convert.ToString(0);
            if (TotItemCount > 0)
            {
                e.Item.Cells[5].Text = Convert.ToString(Convert.ToDecimal(TotCriticalCount) / Convert.ToDecimal(TotItemCount));
            }
            e.Item.Cells[5].Text = String.Format("{0:0.0%}", Convert.ToDecimal(e.Item.Cells[5].Text));

            e.Item.Cells[6].Text = Convert.ToString(TotLbs);
            e.Item.Cells[6].Text = String.Format("{0:0,0}", Convert.ToInt32(e.Item.Cells[6].Text));

            e.Item.Cells[7].Text = Convert.ToString(TotCriticalLbs);
            e.Item.Cells[7].Text = String.Format("{0:0,0}", Convert.ToInt32(e.Item.Cells[7].Text));

            e.Item.Cells[8].Text = Convert.ToString(0);
            if (TotLbs > 0)
            {
                e.Item.Cells[8].Text = Convert.ToString(Convert.ToDecimal(TotCriticalLbs) / Convert.ToDecimal(TotLbs));
            }
            e.Item.Cells[9].Text = Convert.ToString((1 - Convert.ToDecimal(e.Item.Cells[8].Text)));
            e.Item.Cells[8].Text = String.Format("{0:0.0%}", Convert.ToDecimal(e.Item.Cells[8].Text));
            e.Item.Cells[9].Text = String.Format("{0:0.0%}", Convert.ToDecimal(e.Item.Cells[9].Text));
        }
    }
}

