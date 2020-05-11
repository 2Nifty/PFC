/********************************************************************************************
 * File	Name			:	ChargesMaint.aspx.cs
 * File Type			:	C#
 * Project Name			:	Goods En Route
 * Created By			:	Slater
 * Created Date			:	09/10/2007	
 * History				: 
 * DATE					VERSION			AUTHOR			            ACTION
 * ****					*******			******				        ******
 * 09/10/2007		    Version 1		Slater              		Created 
  *********************************************************************************************/

#region NameSpace
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
using PFC.Intranet.DataAccessLayer;
using System.Data.SqlClient;
using GER;
#endregion

public partial class SupportTableMaint : System.Web.UI.Page
{

    #region Global Variable Decalaration
    DataTable dtTableTypes = new DataTable();
    DataTable dtTableContents = new DataTable();
    DataView GridView;   
    #endregion

    #region Auto generated events

    protected void Page_Init(object sender, EventArgs e)
    {
        DataRow workRow;
        dtTableTypes.Columns.Add("TableName", Type.GetType("System.String"));
        dtTableTypes.Columns.Add("FilterValue", Type.GetType("System.String"));
        dtTableTypes.Columns.Add("SelectString", Type.GetType("System.String"));
        dtTableTypes.Columns.Add("SortField", Type.GetType("System.String"));
        dtTableTypes.Columns.Add("DescData", Type.GetType("System.String"));
        dtTableTypes.Columns.Add("Col1Data", Type.GetType("System.String"));
        dtTableTypes.Columns.Add("Col1Hdr", Type.GetType("System.String"));
        dtTableTypes.Columns.Add("Col2Data", Type.GetType("System.String"));
        dtTableTypes.Columns.Add("Col2Hdr", Type.GetType("System.String"));
        // The various support tables names and filters are hardcoded here
        workRow = dtTableTypes.NewRow();
        workRow["TableName"] = "Types of Charges";
        workRow["FilterValue"] = "GERCHRG";
        workRow["SelectString"] = "Dsc as KeyValue, ChrgTypeDsc as TypeDesc, SpreadMeth , DisplayOrder , convert(varchar(50), pTableID) as pTableID";
        workRow["SortField"] = "DisplayOrder";
        workRow["DescData"] = "ChrgTypeDsc";
        workRow["Col1Data"] = "SpreadMeth";
        workRow["Col1Hdr"] = "Spread";
        workRow["Col2Data"] = "DisplayOrder";
        workRow["Col2Hdr"] = "Order";
        dtTableTypes.Rows.Add(workRow);
        workRow = dtTableTypes.NewRow();
        workRow["TableName"] = "Types of Receipts";
        workRow["FilterValue"] = "GERREC";
        workRow["SelectString"] = "Dsc as KeyValue, RcptTypeDsc as TypeDesc, convert(varchar(50), pTableID) as pTableID";
        workRow["SortField"] = "KeyValue";
        workRow["DescData"] = "RcptTypeDsc";
        workRow["Col1Data"] = "";
        workRow["Col1Hdr"] = "";
        workRow["Col2Data"] = "";
        workRow["Col2Hdr"] = "";
        dtTableTypes.Rows.Add(workRow);
        workRow = dtTableTypes.NewRow();
        workRow["TableName"] = "Ports Of Lading";
        workRow["FilterValue"] = "GERPORT";
        workRow["SelectString"] = "Dsc as KeyValue, convert(varchar(50), pTableID) as pTableID";
        workRow["SortField"] = "KeyValue";
        workRow["DescData"] = "";
        workRow["Col1Data"] = "";
        workRow["Col1Hdr"] = "";
        workRow["Col2Data"] = "";
        workRow["Col2Hdr"] = "";
        dtTableTypes.Rows.Add(workRow);
        workRow = dtTableTypes.NewRow();
        workRow["TableName"] = "Tariff Numbers";
        workRow["FilterValue"] = "GERTARIFF";
        workRow["SelectString"] = "Dsc as KeyValue, ShortDsc as TypeDesc, Pct as Rate , convert(varchar(50), pTableID) as pTableID";
        workRow["SortField"] = "KeyValue";
        workRow["DescData"] = "ShortDsc";
        workRow["Col1Data"] = "Pct";
        workRow["Col1Hdr"] = "Rate";
        workRow["Col2Data"] = "";
        workRow["Col2Hdr"] = "";
        dtTableTypes.Rows.Add(workRow);
        workRow = dtTableTypes.NewRow();
        workRow["TableName"] = "Charge Adder Functions";
        workRow["FilterValue"] = "GERADDERFUNC";
        workRow["SelectString"] = "Dsc as KeyValue, convert(varchar(50), pTableID) as pTableID";
        workRow["SortField"] = "KeyValue";
        workRow["DescData"] = "";
        workRow["Col1Data"] = "";
        workRow["Col1Hdr"] = "";
        workRow["Col2Data"] = "";
        workRow["Col2Hdr"] = "";
        dtTableTypes.Rows.Add(workRow);
        workRow = dtTableTypes.NewRow();
        workRow["TableName"] = "Charge Adder Types";
        workRow["FilterValue"] = "GERADDERTYP";
        workRow["SelectString"] = "Dsc as KeyValue, convert(varchar(50), pTableID) as pTableID";
        workRow["SortField"] = "KeyValue";
        workRow["DescData"] = "";
        workRow["Col1Data"] = "";
        workRow["Col1Hdr"] = "";
        workRow["Col2Data"] = "";
        workRow["Col2Hdr"] = "";
        dtTableTypes.Rows.Add(workRow);
        TableFilter.DataValueField = "FilterValue";
        TableFilter.DataTextField = "TableName";
        TableFilter.DataSource = dtTableTypes;
        TableFilter.DataBind();
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblSuccessMessage.Text = "";
        }
        if (IsPostBack)
        {
            if (PageFunc.Value == "Find")
            {
                lblErrorMessage.Text = "";
                BindTableData(TableFilter.SelectedValue);
                lblSuccessMessage.Text = "";
            }
        }
        TableFilter.Focus();
    }

    protected void Page_LoadComplete(object sender, EventArgs e)
    {
        for (int i = 0; i < DetailGrid.Columns.Count; i++)
        {
            DetailGrid.Columns[i].ItemStyle.Width = 280;
        }
    }

    #endregion

    #region SupportTableMaintenance functions

    public void BindTableData(string TableFilter)
    {
        DataRow[] foundRows;
        DataRow foundRow;
        foundRows = dtTableTypes.Select("FilterValue = '" + TableFilter + "'");
        foundRow = foundRows[0];
        DataSet dsTableDetail = new DataSet();
        // get the support table data
        dsTableDetail = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
            new SqlParameter("@tableName", "Tables"),
            new SqlParameter("@columnNames", foundRow["SelectString"]),
            new SqlParameter("@whereClause", "TableType = '" + TableFilter + "'"));

        if ((dsTableDetail.Tables[0] != null) && (dsTableDetail.Tables[0].Rows.Count > 0))
        {
            dtTableContents = dsTableDetail.Tables[0];
            // Create a DataView and specify the field to sort by.
            GridView = new DataView(dtTableContents);
            GridView.Sort = foundRow["SortField"].ToString();
            //DetailGrid.Columns[2].HeaderText = foundRow["Col1Hdr"].ToString();
            //DetailGrid.Columns[3].HeaderText = foundRow["Col2Hdr"].ToString();
            if (foundRow["DescData"].ToString() != "")
            {
                DescLabel.Text = "Description";
                DescUpd.Visible = true;
                DescLabel.Visible = true;
            }
            else
            {
                DescLabel.Text = "";
                DescUpd.Text = "";
                DescUpd.Visible = false;
                DescLabel.Visible = false;
            }
            if (foundRow["Col1Hdr"].ToString() != "")
            {
                Col1Label.Text = foundRow["Col1Hdr"].ToString();
                Col1TextBox.Visible = true;
                Col1Label.Visible = true;
            }
            else
            {
                Col1Label.Text = "";
                Col1TextBox.Text = "";
                Col1TextBox.Visible = false;
                Col1Label.Visible = false;
            }
            if (foundRow["Col2Hdr"].ToString() != "")
            {
                Col2Label.Text = foundRow["Col2Hdr"].ToString();
                Col2TextBox.Visible = true;
                Col2Label.Visible = true;
            }
            else
            {
                Col2Label.Text = "";
                Col2TextBox.Text = "";
                Col2TextBox.Visible = false;
                Col2Label.Visible = false;
            }
            DetailGrid.DataSource = GridView;
            DetailGrid.DataBind();
            DetailPanel.Visible = true;
        }
        else
        {
            lblErrorMessage.Text = "No matching records on file";
            DetailPanel.Visible = false;
        }
        AddButt.Visible = true;
   }

    public void FindButt_Click(object sender, EventArgs e)
    {
        PageFunc.Value = "Find";
        UpdPanel.Visible = false;
        DetailPanel.Visible = true;
        DetailPanel.Height = 550;
        BindTableData(TableFilter.SelectedValue);
    }

    public void AddButt_Click(object sender, EventArgs e)
    {
        UpdFunction.Value = "Add";
        PageFunc.Value = "Add";
        UpdPanel.Visible = true;
        DetailPanel.Height = 300;
    }

    public void DoneButt_Click(object sender, EventArgs e)
    {
        UpdFunction.Value = "Add";
        PageFunc.Value = "Find";
        UpdPanel.Visible = false;
        DetailPanel.Height = 550;
    }

    public void SaveButt_Click(object sender, EventArgs e)
    {
        DataRow[] foundRows;
        DataRow foundRow;
        foundRows = dtTableTypes.Select("FilterValue = '" + TableFilter.SelectedValue + "'");
        foundRow = foundRows[0];
        if (UpdFunction.Value == "Add")
        {
            string columnNames = "TableType, Dsc";
            string columnValues = "'" + TableFilter.SelectedValue + "'";
            columnValues += ", '" + KeyUpd.Text + "'";
            if (foundRow["DescData"].ToString() != "")
            {
                columnNames += ", " + foundRow["DescData"].ToString();
                columnValues += ", '" + DescUpd.Text + "'";
            }
            if (foundRow["Col1Data"].ToString() != "")
            {
                columnNames += ", " + foundRow["Col1Data"].ToString();
                columnValues += ",'" + Col1TextBox.Text + "'";
            }
            if (foundRow["Col2Data"].ToString() != "")
            {
                columnNames += ", " + foundRow["Col2Data"].ToString();
                columnValues += ",'" + Col2TextBox.Text + "'";
            }
            SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "pVMI_Insert",
              new SqlParameter("@tableName", "Tables"),
              new SqlParameter("@columnNames", columnNames),
              new SqlParameter("@columnValues", columnValues));

        }
        else
        {
            string columnValues = "Dsc = '" + KeyUpd.Text + "'";
            if (foundRow["DescData"].ToString() != "") columnValues += ", " + foundRow["DescData"].ToString() + " = '" + DescUpd.Text + "' ";
            if (foundRow["Col1Data"].ToString() != "") columnValues += ", " + foundRow["Col1Data"].ToString() + " = '" + Col1TextBox.Text + "' ";
            if (foundRow["Col2Data"].ToString() != "") columnValues += ", " + foundRow["Col2Data"].ToString() + " = '" + Col2TextBox.Text + "' ";
            SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "pVMI_Update",
              new SqlParameter("@tableName", "Tables"),
              new SqlParameter("@columnNames", columnValues),
              new SqlParameter("@whereClause", "pTableID='" + HiddenGERID.Value + "'"));
        }
        BindTableData(TableFilter.SelectedValue);
        DetailPanel.Visible = true;
        PageFunc.Value = "Find";
    }


    public void GridDeleteHandler(Object sender, GridViewDeleteEventArgs e)
    {
        GridViewRow row = DetailGrid.Rows[e.RowIndex];
        DeleteItem(row.Cells[row.Cells.Count - 1].Text);
    }

    void DeleteItem(string item)
    {

        // Remove the selected item from the data source.         
        GridView.RowFilter = "pTableID = '" + item + "'";
        if (GridView.Count > 0)
        {
            GridView.Delete(0);
            SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVMI_delete]",
                     new SqlParameter("@tableName", "Tables"),
                     new SqlParameter("@whereClause", "pTableID='" + item + "'"));
            lblErrorMessage.Text = "Record Deleted";
        }
        GridView.RowFilter = "";

        // Rebind the data source to refresh the DataGrid control.
        BindTableData(TableFilter.SelectedValue);

    }

    public void GridEditHandler(Object sender, GridViewEditEventArgs e)
    {
        DataRow[] foundRows;
        DataRow foundRow;
        foundRows = dtTableTypes.Select("FilterValue = '" + TableFilter.SelectedValue + "'");
        foundRow = foundRows[0];
        GridViewRow row = DetailGrid.Rows[e.NewEditIndex];
        HiddenGERID.Value = row.Cells[row.Cells.Count - 1].Text;
        KeyUpd.Text = row.Cells[1].Text;
        if (foundRow["DescData"].ToString() != "") DescUpd.Text = row.Cells[2].Text;
        if (foundRow["Col1Hdr"].ToString() != "") Col1TextBox.Text = row.Cells[3].Text;
        if (foundRow["Col2Hdr"].ToString() != "") Col2TextBox.Text = row.Cells[4].Text;
        UpdFunction.Value = "Upd";
        PageFunc.Value = "Upd";
        UpdPanel.Visible = true;
        DetailPanel.Height = 300;
    }

    public void SortGrid(Object sender, GridViewSortEventArgs e)
    {
        // Create a DataView from the DataTable.
        DataView dv = new DataView(dtTableContents);
        // The DataView provides an easy way to sort. Simply set the
        // Sort property with the name of the field to sort by.
        dv.Sort = e.SortExpression;
        // Re-bind the data source and specify that it should be sorted
        // by the field specified in the SortExpression property.
        DetailGrid.DataSource = dv;
        DetailGrid.DataBind();
    }

    protected void DetailGrid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        System.Data.DataRowView drv;
        drv = (System.Data.DataRowView)e.Row.DataItem;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (drv != null)
            {
                {
                    //DetailGrid.Columns[0].ItemStyle.Width = 200;
                    //DetailGrid.Columns[0].ItemStyle.Wrap = false;
                }

            }
        }
    }
    #endregion

}
