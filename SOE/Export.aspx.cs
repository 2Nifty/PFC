using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.SOE.BusinessLogicLayer;

public partial class Export : System.Web.UI.Page
{
    // Create instance for the webservice
    OrderEntry orderEntry = new OrderEntry();

    decimal totalExtAmount = 0;
    decimal totalExtWgt = 0;
    decimal totalDolperLB = 0;
    string SoNo = string.Empty;
    string headerTable = "";
    string detailTable = "";

    public string DetailFIDColumn
    {
        get
        {
            if (headerTable == "SOHeader")
                return "fSOHeaderID";
            else if (headerTable == "SOHeaderRel")
                return "fSOHeaderRelID";
            else if (headerTable == "SOHeaderHist")
                return "fSOHeaderHistID";
            else
                return "fSOHeaderID";
        }
    }
    public string HeaderIDColumn
    {
        get
        {
            if (headerTable == "SOHeader")
                return "fSOHeaderID";
            else if (headerTable == "SOHeaderRel")
                return "pSOHeaderRelID";
            else if (headerTable == "SOHeaderHist")
                return "pSOHeaderHistID";
            else
                return "fSOHeaderID";
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        SoNo = Request.QueryString["SOEID"].Trim();
        headerTable = Request.QueryString["OrderTableName"].Trim();
        detailTable = Request.QueryString["DetailTableName"].Trim();
        if (!IsPostBack)
        {
            BindReport();
        }
    }

    public void BindReport()
    {
        try
        {
            // Get the header details by calling the webservice
            DataSet dsHeader = orderEntry.ExecuteERPSelectQuery(headerTable, " * ," + HeaderIDColumn + " as 'HeaderID'", HeaderIDColumn + "=" + SoNo);
            
            // Get the quote details by calling the webservice
            string tableName = detailTable + " a ,LocMaster b";
            string columnName = "CustItemNo as [Customer Item #],ItemNo as [Item #],ItemDsc as Description ,QtyOrdered as [Request Quantity],[SellStkUM] as [Base Qty/UOM]," +
                                "QtyAvail1 as 'Available Qty',CAST(AlternatePrice AS Decimal(25,2)) as 'Sell Price',a.IMLoc as Loc,a.CarrierCd as 'Carrier Code',Cast([NetUnitPrice] AS Decimal(25,2)) as 'Extended Amount',Cast(ExtendedNetWght AS Decimal(25,2)) as [Extended Weight],Cast(AlternateUMQty As Decimal(25,0)) as 'Super Equivalent',(a.AlternateUM) as [Sell Unit]," +
                                "b.LocName as 'Location Name',ltrim(Remark) as 'Line Note'";
            string whereClause = DetailFIDColumn + "=" + SoNo + " And DeleteDt is null and a.IMLOC = b.LocID";
            DataSet dsQuote = orderEntry.ExecuteERPSelectQuery(tableName, columnName, whereClause);


            dlSOEHeader.DataSource = dsHeader.Tables[0];
            dlSOEHeader.DataBind();
            
            dgReport.DataSource = dsQuote.Tables[0];
            dgReport.DataBind();

            if (dgReport.Items.Count > 0)
            {
                Label lblSales = dlSOEHeader.Items[0].FindControl("lblSales") as Label;
                Label lblTotGPLb = dlSOEHeader.Items[0].FindControl("lblTotGPLb") as Label;
                Label lblTotalWeight = dlSOEHeader.Items[0].FindControl("lblTotalWeight") as Label;               
                Label lblOrdSts = dlSOEHeader.Items[0].FindControl("lblOrdSts") as Label;          
               
                lblSales.Text = (dsHeader != null && dsHeader.Tables[0].Rows.Count > 0 && dsHeader.Tables[0].Rows[0]["NetSales"].ToString() != "") ? Math.Round(Convert.ToDecimal(dsHeader.Tables[0].Rows[0]["NetSales"]), 2).ToString() : "0.00";
                lblTotalWeight.Text = (dsHeader != null && dsHeader.Tables[0].Rows.Count > 0 && dsHeader.Tables[0].Rows[0]["ShipWght"].ToString() != "") ? Math.Round(Convert.ToDecimal(dsHeader.Tables[0].Rows[0]["ShipWght"]), 2).ToString() : "0.00";
                lblTotGPLb.Text = (lblTotalWeight.Text == "0.00") ? "0.0" : Math.Round(((Convert.ToDecimal(dsHeader.Tables[0].Rows[0]["NetSales"]) - Convert.ToDecimal(dsHeader.Tables[0].Rows[0]["TotalCost"])) / Convert.ToDecimal(dsHeader.Tables[0].Rows[0]["ShipWght"])), 1).ToString();

                lblOrdSts.Text = (dsHeader.Tables[0].Rows[0]["OrderStatus"].ToString().Trim() == "") ? "SO" : dsHeader.Tables[0].Rows[0]["OrderStatus"].ToString().Trim();
                 lblOrdSts.Text = (headerTable == "SOHeaderRel") ? "Rel" : "SO";
                 if (dsHeader.Tables[0].Rows[0]["AllocDt"].ToString() != "")
                     lblOrdSts.Text = "Alloc"; 
                 if (dsHeader.Tables[0].Rows[0]["MakeOrderDt"].ToString() != "" && dsHeader.Tables[0].Rows[0]["AllocDt"].ToString() == "")
                     lblOrdSts.Text = "Make Order";
                 if (headerTable == "SOHeaderRel")
                    lblOrdSts.Text = "Released";
                 
                 if (dsHeader.Tables[0].Rows[0]["AllocDt"].ToString() != "" && dsHeader.Tables[0].Rows[0]["PickDt"].ToString() == "")
                     lblOrdSts.Text = "Allocated";
                 if (dsHeader.Tables[0].Rows[0]["PickDt"].ToString() != "")
                     lblOrdSts.Text = "Warehouse";
            }
            if(dsHeader.Tables[0].Rows.Count>0)
            {   
                Label lblWHS = dlSOEHeader.Items[0].FindControl("lblWHS") as Label;
                if (dsHeader.Tables[0].Rows[0]["PickDt"].ToString().Trim() != "" && dsHeader.Tables[0].Rows[0]["PickCompDt"].ToString().Trim() != "" && dsHeader.Tables[0].Rows[0]["ShippedDt"].ToString().Trim() != "" && dsHeader.Tables[0].Rows[0]["ConfirmShipDt"].ToString().Trim() != "")
                    lblWHS.Text = "Shipped";
                else if (dsHeader.Tables[0].Rows[0]["PickDt"].ToString().Trim() != "" && dsHeader.Tables[0].Rows[0]["PickCompDt"].ToString().Trim() != "" && dsHeader.Tables[0].Rows[0]["ShippedDt"].ToString().Trim() != "" && dsHeader.Tables[0].Rows[0]["ConfirmShipDt"].ToString().Trim() == "")
                    lblWHS.Text = "Shipping";
                else if (dsHeader.Tables[0].Rows[0]["PickDt"].ToString().Trim() != "" && dsHeader.Tables[0].Rows[0]["PickCompDt"].ToString().Trim() != "" && dsHeader.Tables[0].Rows[0]["ShippedDt"].ToString().Trim() == "" && dsHeader.Tables[0].Rows[0]["ConfirmShipDt"].ToString().Trim() == "")
                    lblWHS.Text = "Picked";
                else if (dsHeader.Tables[0].Rows[0]["PickDt"].ToString().Trim() != "" && dsHeader.Tables[0].Rows[0]["PickCompDt"].ToString().Trim() == "" && dsHeader.Tables[0].Rows[0]["ShippedDt"].ToString().Trim() == "" && dsHeader.Tables[0].Rows[0]["ConfirmShipDt"].ToString().Trim() == "")
                    lblWHS.Text = "Picking";
                if (headerTable == "SOHeaderRel")
                {
                    lblWHS.Text = "Warehouse";
                }
            }
        }
        catch (Exception ex) { }
    }
    protected void dlSOEHeader_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        //if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        //{

        //}
    }
    protected void dgReport_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        //e.Item.Cells[e.Item.Cells.Count - 1].Style.Add("display", "none");

        //if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        //{
        //    DataSet dsDetails = orderEntry.SelectQuery("[Porteous$Stockkeeping Unit]", "[Replacement Cost Alt] as RCA,[Replacement Cost] as RC", "[ItemNo]='" + e.Item.Cells[e.Item.Cells.Count - 1].Text + "'");
        //    if (dsDetails != null && dsDetails.Tables[0].Rows.Count > 0)
        //    {
        //        if (Convert.ToInt32(e.Item.Cells[2].Text) != 0)
        //            totalDolperLB = totalDolperLB + ((Convert.ToDecimal(e.Item.Cells[6].Text.Replace("$", "").Trim()) - ((Convert.ToInt32(e.Item.Cells[2].Text) * Convert.ToDecimal(dsDetails.Tables[0].Rows[0]["RC"])))) / Convert.ToDecimal(e.Item.Cells[7].Text));
        //    }
        //    totalExtAmount = totalExtAmount + Convert.ToDecimal(e.Item.Cells[6].Text.Replace("$", "").Trim());
        //    totalExtWgt = totalExtWgt + Convert.ToDecimal(e.Item.Cells[7].Text);
        //}

    }
}
