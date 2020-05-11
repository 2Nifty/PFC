/********************************************************************************************
 * File	Name			:	FinReview.aspx.cs
 * File Type			:	C#
 * Project Name			:	Goods En Route
 * Created By			:	Slater
 * Created Date			:	06/27/2007	
 * History				: 
 * DATE					VERSION			AUTHOR			            ACTION
 * ****					*******			******				        ******
 * 06/27/2007		    Version 1		Slater              		Created 
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

public partial class FinReview : System.Web.UI.Page
{

    #region Global Variable Decalaration
    DataTable dtFinReview = new DataTable();
    DataTable dtDetail = new DataTable();
    Utility utility = new Utility();
    PFC.Intranet.BusinessLogicLayer.GER ger = new PFC.Intranet.BusinessLogicLayer.GER();
    #endregion

    #region Auto generated events

    protected void Page_Load(object sender, EventArgs e)
    {
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(FinReview));
        //AddColumns();

        if (!IsPostBack)
        {
            ViewState["Header"] = "false";
            ViewState["Status"] = "false";
            ViewState["BillData"] = dtFinReview;
            //
            // Get the records to review
            //
            BindFinData();
        }
        if (IsPostBack)
        {
            dtFinReview = ViewState["BillData"] as DataTable;

        }
    }

    #endregion

    #region FinReview functions

    public void BindFinData()
    {
        DataSet dsGER = new DataSet();
        dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
            new SqlParameter("@tableName", "GERContainerRecAdjust"),
            new SqlParameter("@columnNames", "ContainerAdjustID,LicensePlateNo,ItemNo,replace(convert(varchar,cast((cast(isnull([Qty],0) as bigint)) as money),1),'.00','') as Qty, ReasonCd, StatusCd"),
            new SqlParameter("@whereClause", "StatusCd='" + "Y" + "'"));

        if (dsGER.Tables[0] != null)
        {
            dtFinReview = dsGER.Tables[0];
            dgFinReview.DataSource = dtFinReview;
            dgFinReview.DataBind();
        }
    }

    #endregion


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

    #region Function used for Processing

    protected void dgFinReview_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        lblSuccessMessage.Text = "";
        lblErrorMessage.Text = "";
        //try
        //{
        string ContainerNo = e.Item.Cells[1].Text as string;
        string PFCItemNo = e.Item.Cells[2].Text as string;
        string AdjustID = e.Item.Cells[6].Text as string;
        string columnValues = "";
        string whereCondition = "";
        // Close the line
        if (e.CommandName == "Close")
        {
            lblSuccessMessage.Text = "Attempting Update";
            lblErrorMessage.Text = "";
            try
            {

                columnValues = "RcptQty=0";
                whereCondition = "ContainerNo='" + ContainerNo + "' and PFCItemNo='" + PFCItemNo + "'";
                SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVMI_update]",
                          new SqlParameter("@tableName", "GERDetail"),
                          new SqlParameter("@columnNames", columnValues),
                          new SqlParameter("@whereClause", whereCondition));
                lblSuccessMessage.Text = "GERDetail Closed";

            }
            catch (Exception ex)
            {
                lblErrorMessage.Text = "Update failed on GerDetail";
            }
            try
            {

                columnValues = " StatusCd='N' ";
                whereCondition = " ContainerAdjustID='" + AdjustID + "'";
                SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVMI_update]",
                          new SqlParameter("@tableName", "GERContainerRecAdjust"),
                          new SqlParameter("@columnNames", columnValues),
                          new SqlParameter("@whereClause", whereCondition));
                lblSuccessMessage.Text = "Line Closed";

            }
            catch (Exception ex)
            {
                lblErrorMessage.Text = "Update failed on GERContainerRecAdjust";
            }
            e.Item.Cells[0].Controls[1].Visible = false;
            //e.Item.Cells[3].Controls[1].Visible = false;
        }
        //}
    //catch (Exception ex) { }
        //e.Item.Cells[1].Text = "Closed";
        //e.Item.Cells[2].Text = "Closed";
        ViewState["Status"] = "true";
        FamilyPanel.Update();
    }

    protected void dgFinReview_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            // Check for GERDetail records and set link BOL number if found.
            HyperLink aLink = e.Item.Cells[5].Controls[1] as HyperLink;
            DataSet dsGER = new DataSet();
            dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
                new SqlParameter("@tableName", "GERDetail"),
                new SqlParameter("@columnNames", "BOLNo"),
                new SqlParameter("@whereClause", "ContainerNo = '" + e.Item.Cells[1].Text + "' and PFCItemNo = '" + e.Item.Cells[2].Text + "'"));

            if (dsGER.Tables[0].Rows.Count != 0)
            {
                dtDetail.Clear();
                dtDetail = dsGER.Tables[0];
                string Bolno = dtDetail.Rows[0]["BOLNo"].ToString();
                //lblSuccessMessage.Text = "Found " + Bolno;
                aLink.NavigateUrl = "../GER/ProgressBar.aspx?destPage=DataEntry.aspx?BOL=" + Bolno;
            }
            else
            {
                aLink.Text = "No Macthing GERDetail";
            }
        }
    }

    #endregion

}
