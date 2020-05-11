/********************************************************************************************
 * File	Name			:	BOLHistDetail.aspx.cs
 * File Type			:	C#
 * Project Name			:	Goods En Route
 * Created By			:	Slater
 * Created Date			:	07/22/2007	
 * History				: 
 * DATE					VERSION			AUTHOR			            ACTION
 * ****					*******			******				        ******
 * 09/06/2007		    Version 1		Slater              		Created 
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

public partial class BOLHistDetail : System.Web.UI.Page
{

    #region Global Variable Decalaration
    DataTable dtBOLData = new DataTable();
    DataTable dtBOLDetail = new DataTable();
    PFC.Intranet.BusinessLogicLayer.GER ger = new PFC.Intranet.BusinessLogicLayer.GER();
    string BOL;
    #endregion

    #region Auto generated events

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblSuccessMessage.Text = "Enter BOL Number";
            BOLNumberBox.Focus();
        }
        if (IsPostBack)
        {
            lblErrorMessage.Text = "";
            if (BindBOLData(BOLNumberBox.Text))
            {
                BOLDetail.Focus();
            }
            lblSuccessMessage.Text = "";
        }
    }

    protected void Page_LoadComplete(object sender, EventArgs e)
    {
    }

    #endregion

    #region BOLHistDetail functions

    public Boolean BindBOLData(string BOLNumber)
    {
        DataSet dsGER = new DataSet();
        DataSet dsBOLDetail = new DataSet();
        string ColumnNames = "";
        dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
            new SqlParameter("@tableName", "GERHeaderHist"),
            new SqlParameter("@columnNames", "*"),
            new SqlParameter("@whereClause", "BOLNo='" + BOLNumber + "'"));
        // get the detail data
        dsBOLDetail = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
            new SqlParameter("@tableName", "GERDetailHist"),
            new SqlParameter("@columnNames", "*"),
            new SqlParameter("@whereClause", "BOLNo='" + BOLNumber + "'"));

        if (dsGER.Tables[0] != null)
        {
            dtBOLData = dsGER.Tables[0];
            BOLHeaderLeft.DataSource = dtBOLData;
            BOLHeaderLeft.DataBind();
            BOLHeaderCenter.DataSource = dtBOLData;
            BOLHeaderCenter.DataBind();
            BOLHeaderRight.DataSource = dtBOLData;
            BOLHeaderRight.DataBind();
            if (dtBOLData.Rows.Count == 0)
            {
                lblErrorMessage.Text = "BOL Number not on file";
                return false;
            }
            else
            {
                //
                // Assign the BOL number in header[Used to print the report]
                //
                lblBOLNumber.Text = dtBOLData.Rows[0]["BOLNo"].ToString();

                dtBOLDetail = dsBOLDetail.Tables[0];
                BOLDetail.DataSource = dtBOLDetail;
                BOLDetail.DataBind();
                //PrintButton.Visible = true;
                return true;
            }
        }
        else
        {
            lblErrorMessage.Text = "BOL Number not on file";
            return false;
        }
    }

    public void Sort_Grid(Object sender, DataGridSortCommandEventArgs e)
    {

        // Retrieve the data source from session state.
        //DataTable dt = (DataTable)Session["Source"];

        // Create a DataView from the DataTable.
        DataView dv = new DataView(dtBOLDetail);

        // The DataView provides an easy way to sort. Simply set the
        // Sort property with the name of the field to sort by.
        dv.Sort = e.SortExpression;

        // Re-bind the data source and specify that it should be sorted
        // by the field specified in the SortExpression property.
        BOLDetail.DataSource = dv;
        BOLDetail.DataBind();

    }

    /// <summary>
    /// Function to format decimal field in Container Grid
    /// </summary>
    /// <param name="container"></param>
    /// <param name="fieldName"></param>
    /// <param name="decimalPlaces"></param>
    /// <returns></returns>
    public string FormatToDecimal(object container, string fieldName, string decimalPlaces)
    {
        if (DataBinder.Eval(container, "DataItem." + fieldName).ToString() != "")
        {
            Decimal dcInvCost = Convert.ToDecimal(DataBinder.Eval(container, "DataItem." + fieldName).ToString());
            if (dcInvCost != 0)
                return dcInvCost.ToString("###,###,###,###,###.00");
        }
        return "0.00";
    }
    #endregion

}
