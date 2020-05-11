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


public partial class CriticalItemDetPreview : System.Web.UI.Page
{
    Int32 TotAvail = 0;
    Decimal TotUse = 0;
    Decimal TotCriticalLbs = 0;
    Decimal TotLbs = 0;
    Decimal TotQtyWgt = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        //GridViewDet.Width = 800;
        BindDataToGrid();
        decimal Count = GridViewDet.Items.Count;
        for (int i = 0; i < Count; i++)
            GridViewDet.Items[i].Font.Size = 8;
    }

    public void BindDataToGrid()
    {
        string cmd = string.Empty;
        try
        {
            if (string.IsNullOrEmpty(Request.QueryString["VelocityCode"].ToString()))
            {
                cmd = "SELECT [ItemNo], [CorpFixedVelCode] as VelocityCode, [ExtSoldWght], [AvailQty], [TotUse30], [AvailQty] * [Net_Wgt] as QtyWgt, [AvailQty] * [Net_Wgt] / [ExtSoldWght] AS MonthsOnHand, [CriticalQty], [CriticalFlag], [NonCriticalFlag], [CriticalWght], [NonCriticalWght], [CriticalWghtPct], [NonCriticalWghtPct], [TargetPct], [Description], [LocationCode], [LocationName], [Net_Wgt] as NetWgt FROM [CriticalItemDetail] WHERE (([CriticalFlag] >= " + Request.QueryString["Critical"].ToString() + ") AND ([LocationCode] = '" + Request.QueryString["LocNum"].ToString() + "')) ORDER BY ItemNo";
                if (Convert.ToInt32(Request.QueryString["Critical"]) > 0)
                    lblVelocityType.Text = "All Velocity Codes - Critical Items Only";
                else
                    lblVelocityType.Text = "All Velocity Codes";
            }
            else
            {
                if (Request.QueryString["VelocityType"].ToString() == "Corp")
                {
                    //Response.Write(Request.QueryString["VelocityType"].ToString());
                    cmd = "SELECT [ItemNo], [CorpFixedVelCode] as VelocityCode, [ExtSoldWght], [AvailQty], [TotUse30], [AvailQty] * [Net_Wgt] as QtyWgt, [AvailQty] * [Net_Wgt] / [ExtSoldWght] AS MonthsOnHand, [CriticalQty], [CriticalFlag], [NonCriticalFlag], [CriticalWght], [NonCriticalWght], [CriticalWghtPct], [NonCriticalWghtPct], [TargetPct], [Description], [LocationCode], [LocationName], [Net_Wgt] as NetWgt FROM [CriticalItemDetail] WHERE (([CorpFixedVelCode] = '" + Request.QueryString["VelocityCode"].ToString() + "') AND ([CriticalFlag] >= " + Request.QueryString["Critical"].ToString() + ") AND ([LocationCode] = '" + Request.QueryString["LocNum"].ToString() + "')) ORDER BY ItemNo";
                    lblVelocityType.Text = "Corp Fixed Velocity : " + Request.QueryString["VelocityCode"].ToString();
                    if (Convert.ToInt32(Request.QueryString["Critical"]) > 0)
                        lblVelocityType.Text = lblVelocityType.Text + " - Critical Items Only";
                }
                if (Request.QueryString["VelocityType"].ToString() == "Cat")
                {
                    //Response.Write(Request.QueryString["VelocityType"].ToString());
                    cmd = "SELECT [ItemNo], [CatVelCode] as VelocityCode, [ExtSoldWght], [AvailQty], [TotUse30], [AvailQty] * [Net_Wgt] as QtyWgt, [AvailQty] * [Net_Wgt] / [ExtSoldWght] AS MonthsOnHand, [CriticalQty], [CriticalFlag], [NonCriticalFlag], [CriticalWght], [NonCriticalWght], [CriticalWghtPct], [NonCriticalWghtPct], [TargetPctCat] AS TargetPct, [Description], [LocationCode], [LocationName], [Net_Wgt] as NetWgt FROM [CriticalItemDetail] WHERE (([CatVelCode] = '" + Request.QueryString["VelocityCode"].ToString() + "') AND ([CriticalFlag] >= " + Request.QueryString["Critical"].ToString() + ") AND ([LocationCode] = '" + Request.QueryString["LocNum"].ToString() + "')) ORDER BY ItemNo";
                    lblVelocityType.Text = "Category Velocity : " + Request.QueryString["VelocityCode"].ToString();
                    if (Convert.ToInt32(Request.QueryString["Critical"]) > 0)
                        lblVelocityType.Text = lblVelocityType.Text + " - Critical Items Only";
                }
            }

            SqlDataAdapter adp = new SqlDataAdapter(cmd, System.Configuration.ConfigurationManager.ConnectionStrings["csPFCReports"].ConnectionString);
            DataSet ds = new DataSet();
            adp.Fill(ds);
            GridViewDet.DataSource = ds.Tables[0];
            if (ds.Tables[0].Rows.Count > 0)
            {
                GridViewDet.DataBind();
            }
        }
        catch (Exception ex) { Response.Write(ex.Message.ToString()); }
    }

    protected void Total_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            //Response.Write(Convert.ToInt32(e.Item.Cells[3].Text));

            TotAvail = TotAvail + Convert.ToInt32(e.Item.Cells[2].Text);
            e.Item.Cells[2].Text = String.Format("{0:0,0}", Convert.ToInt32(e.Item.Cells[2].Text));

            TotUse = TotUse + Convert.ToDecimal(e.Item.Cells[3].Text);
            e.Item.Cells[3].Text = String.Format("{0:0,0}", Convert.ToDecimal(e.Item.Cells[3].Text));

            e.Item.Cells[4].Text = String.Format("{0:0.0}", Convert.ToDecimal(e.Item.Cells[4].Text));

            TotLbs = TotLbs + Convert.ToDecimal(e.Item.Cells[5].Text);
            e.Item.Cells[5].Text = String.Format("{0:0,0}", Convert.ToDecimal(e.Item.Cells[5].Text));

            TotCriticalLbs = TotCriticalLbs + Convert.ToDecimal(e.Item.Cells[6].Text);
            e.Item.Cells[6].Text = String.Format("{0:0,0}", Convert.ToDecimal(e.Item.Cells[6].Text));

            TotQtyWgt = TotQtyWgt + Convert.ToDecimal(e.Item.Cells[2].Text) * Convert.ToDecimal(e.Item.Cells[10].Text);
        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            //Response.Write(TotItemCount);

            e.Item.Cells[2].Text = Convert.ToString(TotAvail);
            e.Item.Cells[2].Text = String.Format("{0:0,0}", Convert.ToInt32(e.Item.Cells[2].Text));

            e.Item.Cells[3].Text = Convert.ToString(TotUse);
            e.Item.Cells[3].Text = String.Format("{0:0,0}", Convert.ToDecimal(e.Item.Cells[3].Text));

            e.Item.Cells[4].Text = Convert.ToString(TotQtyWgt / TotLbs);
            e.Item.Cells[4].Text = String.Format("{0:0.0}", Convert.ToDecimal(e.Item.Cells[4].Text));

            e.Item.Cells[5].Text = Convert.ToString(TotLbs);
            e.Item.Cells[5].Text = String.Format("{0:0,0}", Convert.ToDecimal(e.Item.Cells[5].Text));

            e.Item.Cells[6].Text = Convert.ToString(TotCriticalLbs);
            e.Item.Cells[6].Text = String.Format("{0:0,0}", Convert.ToDecimal(e.Item.Cells[6].Text));

            e.Item.Cells[7].Text = Convert.ToString(0);
            if (TotLbs > 0)
            {
                e.Item.Cells[7].Text = Convert.ToString(Convert.ToDecimal(TotCriticalLbs) / Convert.ToDecimal(TotLbs));
                e.Item.Cells[8].Text = Convert.ToString(1 - (Convert.ToDecimal(TotCriticalLbs) / Convert.ToDecimal(TotLbs)));
            }
            if (TotCriticalLbs > TotLbs)
            {
                e.Item.Cells[7].Text = Convert.ToString(1);
            }
            e.Item.Cells[7].Text = String.Format("{0:0.0%}", Convert.ToDecimal(e.Item.Cells[7].Text));
            e.Item.Cells[8].Text = String.Format("{0:0.0%}", Convert.ToDecimal(e.Item.Cells[8].Text));
        }
    }

}

