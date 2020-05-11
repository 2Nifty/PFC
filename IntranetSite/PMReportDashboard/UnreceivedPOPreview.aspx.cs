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
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;

public partial class UnreceivedPOPreview : System.Web.UI.Page
{
    SqlConnection cnPERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);

    Decimal QtyOrd, QtyRcvd, QtyDue, ExtCost;
    Decimal TotLines, TotQtyOrd, TotQtyRcvd, TotQtyDue, TotExtCost;
    string strSQL, RowFilter;
    Boolean Header = true;

    DataSet dsUnrcvdPO;
    DataTable dtUnrcvdPO, dtUnrcvdPOCat;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        RowFilter = string.Empty;

        if (!string.IsNullOrEmpty(Request.QueryString["Category"].ToString()))
        {
            RowFilter = RowFilter + "CatNo = '" + Request.QueryString["Category"].ToString() + "'";
            lblCategory.Text = Request.QueryString["Category"].ToString();
        }
        else
        {
            lblCategory.Text = "ALL";
            //lblCategory.Text = "00020";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["Size"].ToString()))
        {
            if (!string.IsNullOrEmpty(RowFilter.ToString())) RowFilter = RowFilter + " AND ";
            RowFilter = RowFilter + "SizeNo = '" + Request.QueryString["Size"].ToString() + "'";
            lblSize.Text = Request.QueryString["Size"].ToString();
        }
        else
        {
            lblSize.Text = "ALL";
            //lblSize.Text = "2800";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["Variance"].ToString()))
        {
            if (!string.IsNullOrEmpty(RowFilter.ToString())) RowFilter = RowFilter + " AND ";
            RowFilter = RowFilter + "VarianceNo = '" + Request.QueryString["Variance"].ToString() + "'";
            lblVariance.Text = Request.QueryString["Variance"].ToString();
        }
        else
        {
            lblVariance.Text = "ALL";
            //lblVariance.Text = "020";
        }

        hidFilter.Value = RowFilter;
        dsUnrcvdPO = SqlHelper.ExecuteDataset(cnPERP, "pPORptUnRcvd");

        if (!string.IsNullOrEmpty(RowFilter.ToString()))
            dsUnrcvdPO.Tables[0].DefaultView.RowFilter = RowFilter.ToString();

        if (dsUnrcvdPO.Tables[0].DefaultView.ToTable().Rows.Count > 0)
        {
            BindDataGrid();
        }
    }

    private void BindDataGrid()
    {
        TotLines = 0;
        TotQtyOrd = 0;
        TotQtyRcvd = 0;
        TotQtyDue = 0;
        TotExtCost = 0;
        tblGrdTotals.Visible = true;

        dtUnrcvdPOCat = SelectDistinct(dsUnrcvdPO.Tables[0].DefaultView.ToTable(), "CatNo");
        if (!string.IsNullOrEmpty(Request.QueryString["Category"].ToString()))
            dtUnrcvdPOCat.DefaultView.RowFilter = "CatNo = '" + Request.QueryString["Category"].ToString() + "'";
        dtUnrcvdPOCat.DefaultView.Sort = "CatNo ASC";
        dgUnrcvdPOCat.DataSource = dtUnrcvdPOCat.DefaultView.ToTable();
        dgUnrcvdPOCat.DataBind();

        lblTotLines.Text = "Total number of lines: " + String.Format("{0:n0}", TotLines);
        lblTotQtyOrd.Text = String.Format("{0:n0}", TotQtyOrd);
        lblTotQtyRcvd.Text = String.Format("{0:n0}", TotQtyRcvd);
        lblTotQtyDue.Text = String.Format("{0:n0}", TotQtyDue);
        lblTotExtCost.Text = String.Format("{0:c}", TotExtCost);
    }

    protected void dgUnrcvdPOCat_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            DataGrid _dgUnrcvdPODtl = e.Item.FindControl("dgUnrcvdPODtl") as DataGrid;

            string CatNo = dtUnrcvdPOCat.DefaultView.ToTable().Rows[e.Item.DataSetIndex]["CatNo"].ToString().Trim();

            if (!string.IsNullOrEmpty(hidFilter.Value.ToString()))
                dsUnrcvdPO.Tables[0].DefaultView.RowFilter = hidFilter.Value + " AND CatNo = '" + CatNo.ToString() + "'";
            else
                dsUnrcvdPO.Tables[0].DefaultView.RowFilter = "CatNo = '" + CatNo.ToString() + "'";

            dsUnrcvdPO.Tables[0].DefaultView.Sort = "CatNo ASC";

            if (dsUnrcvdPO.Tables[0].DefaultView.ToTable().Rows.Count > 0)
            {
                _dgUnrcvdPODtl.DataSource = dsUnrcvdPO.Tables[0].DefaultView.ToTable();
                _dgUnrcvdPODtl.ShowHeader = Header;
                _dgUnrcvdPODtl.DataBind();
                Header = false;
            }
        }

        QtyOrd = 0;
        QtyRcvd = 0;
        QtyDue = 0;
        ExtCost = 0;
    }

    protected void dgUnrcvdPODtl_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            Label _lblCost = e.Item.FindControl("lblCost") as Label;
            _lblCost.Text = String.Format("{0:c}", dsUnrcvdPO.Tables[0].DefaultView.ToTable().Rows[e.Item.DataSetIndex]["AlternateCost"]) + "/" + dsUnrcvdPO.Tables[0].DefaultView.ToTable().Rows[e.Item.DataSetIndex]["CostUM"].ToString().Trim();
            QtyOrd = QtyOrd + Convert.ToDecimal(e.Item.Cells[8].Text);
            QtyRcvd = QtyRcvd + Convert.ToDecimal(e.Item.Cells[9].Text);
            QtyDue = QtyDue + Convert.ToDecimal(e.Item.Cells[13].Text);
            ExtCost = ExtCost + Convert.ToDecimal(e.Item.Cells[15].Text);
            e.Item.Cells[15].Text = String.Format("{0:c}", Convert.ToDecimal(e.Item.Cells[15].Text));
        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].Text = dsUnrcvdPO.Tables[0].DefaultView.ToTable().Rows[0]["CatDesc"].ToString().Trim();
            e.Item.Cells[0].HorizontalAlign = HorizontalAlign.Left;
            e.Item.Cells[2].Text = "Number of lines: " + dsUnrcvdPO.Tables[0].DefaultView.ToTable().Rows.Count.ToString();
            e.Item.Cells[2].HorizontalAlign = HorizontalAlign.Left;
            e.Item.Cells[8].Text = String.Format("{0:n0}", QtyOrd);
            e.Item.Cells[8].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[9].Text = String.Format("{0:n0}", QtyRcvd);
            e.Item.Cells[9].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[13].Text = String.Format("{0:n0}", QtyDue);
            e.Item.Cells[13].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[15].Text = String.Format("{0:c}", ExtCost);
            e.Item.Cells[15].HorizontalAlign = HorizontalAlign.Right;

            TotLines = TotLines + dsUnrcvdPO.Tables[0].DefaultView.ToTable().Rows.Count;
            TotQtyOrd = TotQtyOrd + QtyOrd;
            TotQtyRcvd = TotQtyRcvd + QtyRcvd;
            TotQtyDue = TotQtyDue + QtyDue;
            TotExtCost = TotExtCost + ExtCost;
        }
    }

    public DataTable SelectDistinct(DataTable SourceTable, string FieldName)
    {
        DataTable dt = new DataTable();
        dt.Columns.Add(FieldName, SourceTable.Columns[FieldName].DataType);

        object LastValue = null;
        foreach (DataRow dr in SourceTable.Select("", FieldName))
        {
            if (LastValue == null || !(ColumnEqual(LastValue, dr[FieldName])))
            {
                LastValue = dr[FieldName];
                dt.Rows.Add(new object[] { LastValue });
            }
        }
        return dt;
    }

    private bool ColumnEqual(object field1, object field2)
    {
        // Compares two values to see if they are equal. Also compares DBNULL.Value.
        // Note: If your DataTable contains object fields, then you must extend this
        // function to handle them in a meaningful way if you intend to group on them.

        if (field1 == DBNull.Value && field2 == DBNull.Value) //both are DBNull.Value
            return true;
        if (field1 == DBNull.Value || field2 == DBNull.Value) //only one is DBNull.Value
            return false;
        return (field1.Equals(field2));   //value type standard comparison
    }
}
