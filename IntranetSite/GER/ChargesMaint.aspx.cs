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

public partial class ChargesMaint : System.Web.UI.Page
{

    #region Global Variable Decalaration
    DataTable dtCharges = new DataTable();
    DataTable dtBranches = new DataTable();
    DataTable dtAdderFuncs = new DataTable();
    DataTable dtAdderTypes = new DataTable();
    DataView GridView;   
    #endregion

    #region Auto generated events

    protected void Page_Init(object sender, EventArgs e)
    {
        // branches
        DataSet dsGER = new DataSet();
        dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
          new SqlParameter("@tableName", "LocMaster"),
          new SqlParameter("@columnNames", "distinct rtrim(LocID) as Branch , LocID + ' - ' + LocName as TextValue"),
          new SqlParameter("@whereClause", "MaintainIMQtyInd='Y'"));
        dtBranches = dsGER.Tables[0];
        BranchUpd.DataValueField = "Branch";
        BranchUpd.DataTextField = "TextValue";
        BranchUpd.DataSource = dtBranches;
        BranchUpd.DataBind();
        dtBranches.Rows.Add(new Object[] {"-", "- Show All -"});
        DataView BranchView = new DataView(dtBranches);
        BranchView.Sort = "Branch";
        BranchFilter.DataValueField = "Branch";
        BranchFilter.DataTextField = "TextValue";
        BranchFilter.DataSource = BranchView;
        BranchFilter.DataBind();
        // Receipt Types
        dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
          new SqlParameter("@tableName", "GERRcptTypes"),
          new SqlParameter("@columnNames", "GERRcptType, RcptTypeDesc"),
          new SqlParameter("@whereClause", "1=1"));
        ReceiptTypeUpd.DataValueField = "GERRcptType";
        ReceiptTypeUpd.DataTextField = "RcptTypeDesc";
        ReceiptTypeUpd.DataSource = dsGER.Tables[0];
        ReceiptTypeUpd.DataBind();
        dsGER.Tables[0].Rows.Add(new Object[] { "-", "- Show All -" });
        DataView ReceiptTypeView = new DataView(dsGER.Tables[0]);
        ReceiptTypeView.Sort = "GERRcptType";
        ReceiptTypeFilter.DataValueField = "GERRcptType";
        ReceiptTypeFilter.DataTextField = "RcptTypeDesc";
        ReceiptTypeFilter.DataSource = ReceiptTypeView;
        ReceiptTypeFilter.DataBind();
        // Ports of Lading
        dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
          new SqlParameter("@tableName", "Tables"),
          new SqlParameter("@columnNames", "distinct Dsc as POL, Dsc as PortofLading"),
          new SqlParameter("@whereClause", "TableType = 'GERPORT'"));
        POLUpd.DataValueField = "POL";
        POLUpd.DataTextField = "PortofLading";
        POLUpd.DataSource = dsGER.Tables[0];
        POLUpd.DataBind();
        dsGER.Tables[0].Rows.Add(new Object[] { "-", "- Show All -" });
        DataView PortOfLadingView = new DataView(dsGER.Tables[0]);
        PortOfLadingView.Sort = "PortofLading";
        PortOfLadingFilter.DataValueField = "POL";
        PortOfLadingFilter.DataTextField = "PortofLading";
        PortOfLadingFilter.DataSource = PortOfLadingView;
        PortOfLadingFilter.DataBind();
        // Charge Types
        dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
          new SqlParameter("@tableName", "GERChargeTypes"),
          new SqlParameter("@columnNames", "GERChrgType, ChargeTypeDesc"),
          new SqlParameter("@whereClause", "1=1 order by GERChrgType"));
        ChargeTypeUpd.DataValueField = "GERChrgType";
        ChargeTypeUpd.DataTextField = "ChargeTypeDesc";
        ChargeTypeUpd.DataSource = dsGER.Tables[0];
        ChargeTypeUpd.DataBind();
        dsGER.Tables[0].Rows.Add(new Object[] { "-", "- Show All -" });
        DataView ChargeTypeView = new DataView(dsGER.Tables[0]);
        ChargeTypeView.Sort = "GERChrgType";
        ChargeTypeFilter.DataValueField = "GERChrgType";
        ChargeTypeFilter.DataTextField = "ChargeTypeDesc";
        ChargeTypeFilter.DataSource = ChargeTypeView;
        ChargeTypeFilter.DataBind();
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
                BindChargeData(BranchFilter.SelectedValue, ReceiptTypeFilter.SelectedValue, PortOfLadingFilter.SelectedValue, ChargeTypeFilter.SelectedValue);
                lblSuccessMessage.Text = "";
            }
        }
        BranchFilter.Focus();
    }

    protected void Page_LoadComplete(object sender, EventArgs e)
    {
    }

    #endregion

    #region ChargeMaintenance functions

    public void BindChargeData(string BranchNumber, string RcptType, string POL, string ChargeType)
    {
        DataSet dsChargeDetail = new DataSet();
        string WhereClause = "";
        if (BranchNumber != "-") { WhereClause += "DestBranch='" + BranchNumber + "' "; } else { WhereClause += " 1=1 "; }
        if (RcptType != "-") { WhereClause += " and RcptTypeDesc='" + RcptType + "' "; } else { WhereClause += " and 1=1 "; }
        if (POL != "-") { WhereClause += " and PortofLading='" + POL + "' "; } else { WhereClause += " and 1=1 "; }
        if (ChargeType != "-") { WhereClause += " and ChrgType='" + ChargeType + "' "; } else { WhereClause += " and 1=1 "; }
        WhereClause += " order by DestBranch, RcptTypeDesc, PortofLading, ChrgType, QtyMin ";
        // get the detail data
        dsChargeDetail = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
            new SqlParameter("@tableName", "GERCharges"),
            new SqlParameter("@columnNames", "*"),
            new SqlParameter("@whereClause", WhereClause));

        if ((dsChargeDetail.Tables[0] != null) && (dsChargeDetail.Tables[0].Rows.Count > 0))
        {
            dtCharges = dsChargeDetail.Tables[0];
            ChargeDetailGrid.DataSource = dtCharges;
            ChargeDetailGrid.DataBind();
            DetailPanel.Visible = true;
            // Create a DataView and specify the field to sort by.
            GridView = new DataView(dtCharges);
            GridView.Sort = "pGERChargesID";

        }
        else
        {
            lblErrorMessage.Text = "No matching records on file";
            DetailPanel.Visible = false;
        }
    }

    public void FindButt_Click(object sender, EventArgs e)
    {
        PageFunc.Value = "Find";
        UpdPanel.Visible = false;
        DetailPanel.Visible = true;
        DetailPanel.Height = 550;
        BindChargeData(BranchFilter.SelectedValue, ReceiptTypeFilter.SelectedValue, PortOfLadingFilter.SelectedValue, ChargeTypeFilter.SelectedValue);
    }

    public void AddButt_Click(object sender, EventArgs e)
    {
        UpdFunction.Value = "Add";
        PageFunc.Value = "Add";
        UpdPanel.Visible = true;
        DetailPanel.Height = 300;
        if (BranchFilter.SelectedIndex != 1) BranchUpd.SelectedIndex = BranchFilter.SelectedIndex - 1;
        if (ReceiptTypeFilter.SelectedIndex != 1) ReceiptTypeUpd.SelectedIndex = ReceiptTypeFilter.SelectedIndex - 1;
        if (PortOfLadingFilter.SelectedIndex != 1) POLUpd.SelectedIndex = PortOfLadingFilter.SelectedIndex - 1;
        if (ChargeTypeFilter.SelectedIndex!=1) ChargeTypeUpd.SelectedIndex = ChargeTypeFilter.SelectedIndex-1;
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
        if (UpdFunction.Value == "Add")
        {
            string columnValues = "'" + POLUpd.SelectedValue + "'";
            columnValues += ",'" + ReceiptTypeUpd.SelectedValue + "'";
            columnValues += ",'" + BranchUpd.SelectedValue + "'";
            columnValues += ",'" + ChargeTypeUpd.SelectedValue + "'";
            columnValues += ", " + AdderUpd.Text.Replace(",","") + " ";
            columnValues += ", " + MinUpd.Text.Replace(",", "") + " ";
            columnValues += ", " + MaxUpd.Text.Replace(",", "") + " ";
            columnValues += ", '" + AdderFuncUpd.SelectedValue + "'";
            columnValues += ", '" + AdderTypeUpd.SelectedValue + "'";
            SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "pVMI_Insert",
              new SqlParameter("@tableName", "GERCharges"),
              new SqlParameter("@columnNames", "PortofLading, RcptTypeDesc, DestBranch, ChrgType, ChrgAdder, QtyMin, QtyMax, AdderFunc, AdderType"),
              new SqlParameter("@columnValues", columnValues));

        }
        else
        {
            string columnValues = "PortofLading = '" + POLUpd.SelectedValue + "'";
            columnValues += ", RcptTypeDesc = '" + ReceiptTypeUpd.SelectedValue + "'";
            columnValues += ", DestBranch = '" + BranchUpd.SelectedValue + "'";
            columnValues += ", ChrgType = '" + ChargeTypeUpd.SelectedValue + "'";
            columnValues += ", ChrgAdder = " + AdderUpd.Text.Replace(",","") + " ";
            columnValues += ", QtyMin = " + MinUpd.Text.Replace(",", "") + " ";
            columnValues += ", QtyMax = " + MaxUpd.Text.Replace(",", "") + " ";
            columnValues += ", AdderFunc = '" + AdderFuncUpd.SelectedValue + "'";
            columnValues += ", AdderType = '" + AdderTypeUpd.SelectedValue + "'";
            SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "pVMI_Update",
              new SqlParameter("@tableName", "GERCharges"),
              new SqlParameter("@columnNames", columnValues),
              new SqlParameter("@whereClause", "pGERChargesID=" + HiddenGERID.Value + ""));
        }
        BindChargeData(BranchFilter.SelectedValue, ReceiptTypeFilter.SelectedValue, PortOfLadingFilter.SelectedValue, ChargeTypeFilter.SelectedValue);
        DetailPanel.Visible = true;
        PageFunc.Value = "Find";
    }


    public void GridDeleteHandler(Object sender, GridViewDeleteEventArgs e)
    {
        GridViewRow row = ChargeDetailGrid.Rows[e.RowIndex];
        DeleteItem(row.Cells[10].Text);
    }

    void DeleteItem(string item)
    {

        // Remove the selected item from the data source.         
        GridView.RowFilter = "pGERChargesID=" + item + "";
        if (GridView.Count > 0)
        {
            GridView.Delete(0);
            SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVMI_delete]",
                     new SqlParameter("@tableName", "GERCharges"),
                     new SqlParameter("@whereClause", "pGERChargesID=" + item + ""));
            lblErrorMessage.Text = "Record Deleted";
        }
        GridView.RowFilter = "";

        // Rebind the data source to refresh the DataGrid control.
        ChargeDetailGrid.DataBind();

    }

    public void GridEditHandler(Object sender, GridViewEditEventArgs e)
    {
        GridViewRow row = ChargeDetailGrid.Rows[e.NewEditIndex];
        HiddenGERID.Value = row.Cells[10].Text;
        DataBoundLiteralControl POLUpdLiteral = (DataBoundLiteralControl)row.Cells[3].Controls[0];
        POLUpd.SelectedValue = POLUpdLiteral.Text.Trim();
        DataBoundLiteralControl ReceiptTypeLiteral = (DataBoundLiteralControl)row.Cells[2].Controls[0];
        ReceiptTypeUpd.SelectedValue = ReceiptTypeLiteral.Text.Trim();
        //BranchUpd.SelectedValue = row.Cells[0].Text;
        DataBoundLiteralControl BranchUpdLiteral = (DataBoundLiteralControl)row.Cells[1].Controls[0];
        BranchUpd.SelectedValue = BranchUpdLiteral.Text.Trim();
        DataBoundLiteralControl ChargeTypeLiteral = (DataBoundLiteralControl)row.Cells[4].Controls[0];
        ChargeTypeUpd.SelectedValue = ChargeTypeLiteral.Text.Trim();
        DataBoundLiteralControl AdderUpdLiteral = (DataBoundLiteralControl)row.Cells[5].Controls[0];
        AdderUpd.Text = AdderUpdLiteral.Text.Trim();
        DataBoundLiteralControl MinUpdLiteral = (DataBoundLiteralControl)row.Cells[6].Controls[0];
        MinUpd.Text = MinUpdLiteral.Text.Trim();
        DataBoundLiteralControl MaxUpdLiteral = (DataBoundLiteralControl)row.Cells[7].Controls[0];
        MaxUpd.Text = MaxUpdLiteral.Text.Trim();
        DataBoundLiteralControl AdderFuncLiteral = (DataBoundLiteralControl)row.Cells[8].Controls[0];
        AdderFuncUpd.SelectedValue = AdderFuncLiteral.Text.Trim();
        DataBoundLiteralControl AdderTypeLiteral = (DataBoundLiteralControl)row.Cells[9].Controls[0];
        AdderTypeUpd.SelectedValue = AdderTypeLiteral.Text.Trim();
        UpdFunction.Value = "Upd";
        PageFunc.Value = "Upd";
        UpdPanel.Visible = true;
        DetailPanel.Height = 300;
        //ChargeDetailGrid.EditIndex = e.NewEditIndex;
        //ChargeDetailGrid.DataBind();
    }

    //public void GridCancelHandler(Object sender, DataGridCommandEventArgs e)
    //{

    //    // Set the EditItemIndex property to -1 to exit editing mode. 
    //    // Be sure to rebind the DateGrid to the data source to refresh
    //    // the control.
    //    ChargeDetailGrid.EditItemIndex = -1;
    //    ChargeDetailGrid.DataBind();

    //}

    public void SortGrid(Object sender, GridViewSortEventArgs e)
    {

        // Retrieve the data source from session state.
        //DataTable dt = (DataTable)Session["Source"];

        // Create a DataView from the DataTable.
        DataView dv = new DataView(dtCharges);

        // The DataView provides an easy way to sort. Simply set the
        // Sort property with the name of the field to sort by.
        dv.Sort = e.SortExpression;

        // Re-bind the data source and specify that it should be sorted
        // by the field specified in the SortExpression property.
        ChargeDetailGrid.DataSource = dv;
        ChargeDetailGrid.DataBind();

    }

    #endregion

}
