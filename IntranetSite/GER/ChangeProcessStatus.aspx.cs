/********************************************************************************************
 * File	Name			:	ChangeProcessStatus.aspx.cs
 * File Type			:	C#
 * Project Name			:	Goods En Route
 * Created By			:	Slater
 * Created Date			:	05/14/2008	
 * History				: 
 * DATE					VERSION			AUTHOR			            ACTION
 * ****					*******			******				        ******
 * 05/14/2008		    Version 1		Slater              		Created 
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

public partial class GERChangeProcessStatus : System.Web.UI.Page
{

    #region Global Variable Decalaration
    DataTable dtBOLData = new DataTable();
    PFC.Intranet.BusinessLogicLayer.GER ger = new PFC.Intranet.BusinessLogicLayer.GER();
    string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    string BOL;
    #endregion

    #region Auto generated events

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblSuccessMessage.Text = "Enter BOL Number";
            BOLNumberBox.Focus();
            UpdateButton.Visible = false;
        }
        if (IsPostBack)
        {
            lblErrorMessage.Text = "";
            lblSuccessMessage.Text = "";
            BindBOLData(BOLNumberBox.Text);
        }
    }

    protected void Page_LoadComplete(object sender, EventArgs e)
    {
        // 
        // see if args were passed
        int loop1, loop2;
        BOL = "";
        // Load NameValueCollection object.
        System.Collections.Specialized.NameValueCollection coll = Request.QueryString;
        // Get names of all keys into a string array.
        String[] arr1 = coll.AllKeys;
        for (loop1 = 0; loop1 < arr1.Length; loop1++)
        {
            //Response.Write("Key: " + Server.HtmlEncode(arr1[loop1]) + "<br>");
            String[] arr2 = coll.GetValues(arr1[loop1]);
            for (loop2 = 0; loop2 < arr2.Length; loop2++)
            {
                //Response.Write("Value " + loop2 + ": " + Server.HtmlEncode(arr2[loop2]) + "<br>");
            }
            if (arr1[loop1] == "BOL")
            {
                BOL = arr2[0];
            }
        }
        if (BOL != "")
        {
            BindBOLData(BOL);
            BOLNumberBox.Visible = false;
            FindBOLButt.Visible = false;
            BOLLabel.Visible = false;
            CloseButton.PostBackUrl = "javascript:window.close();";
            lblSuccessMessage.Text = "";
        }
    }

    #endregion

    #region GERChangeProcessStatus functions

    public void BindBOLData(string BOLNumber)
    {
        DataSet dsGER = new DataSet();
        UpdateButton.Visible = false;
        PreUpdateGridView.Visible = false;
        ResultsGridView.Visible = false;
        string SqlStatement = " select BOLNo, ProcessRecInd from (  ";
        SqlStatement += " Select BOLNo, case GERProcess.ProcessRecInd when 1 then 'Now' else 'Nightly' end as ProcessRecInd  ";
        SqlStatement += " FROM GERProcess,  ";
        SqlStatement += "   (SELECT * ";
        SqlStatement += " 	FROM GERDetail ";
        SqlStatement += "   WHERE (BOLNo = '" + BOLNumber + "')) GERDtl";
        SqlStatement += " WHERE GERDtl.pGERDtlID = GERProcess.GERDetailID  ";
        SqlStatement += " and GERProcess.ProcessDt IS NULL) GetMstr ";
        SqlStatement += " group by BOLNo, ProcessRecInd";
        dsGER = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, SqlStatement);
        if (dsGER.Tables[0] != null)
        {
            dtBOLData = dsGER.Tables[0];
            PreUpdateGridView.DataSource = dtBOLData;
            PreUpdateGridView.DataBind();
            if (dtBOLData.Rows.Count == 0)
            {
                lblErrorMessage.Text = "No records waiting to process for this BOL.";
            }
            else
            {
                UpdateButton.Visible = true;
                PreUpdateGridView.Visible = true;
            }
        }
        else
        {
            lblErrorMessage.Text = "No records waiting to process for this BOL..";
        }
    }

    protected void UpdateButton_Click(object sender, ImageClickEventArgs e)
    {
        // 
        DataSet dsGER = new DataSet();
        string SqlStatement = "UPDATE GERProcess ";
        SqlStatement += " SET GERProcess.ProcessRecInd = '1' ";
        SqlStatement += " FROM GERProcess,  ";
        SqlStatement += "   (SELECT * ";
        SqlStatement += " 	FROM GERDetail ";
        SqlStatement += "   WHERE (BOLNo = '" + BOLNumberBox.Text + "')) GERDtl";
        SqlStatement += " WHERE GERDtl.pGERDtlID = GERProcess.GERDetailID  ";
        SqlStatement += " and GERProcess.ProcessDt IS NULL ";
        int iRslt = SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, SqlStatement);
        lblSuccessMessage.Text = "Number of BOL Lines Updated : " + iRslt.ToString();
        SqlStatement = " select BOLNo, ProcessRecInd from (  ";
        SqlStatement += " Select BOLNo, case GERProcess.ProcessRecInd when 1 then 'Now' else 'Nightly' end as ProcessRecInd  ";
        SqlStatement += " FROM GERProcess,  ";
        SqlStatement += "   (SELECT * ";
        SqlStatement += " 	FROM GERDetail ";
        SqlStatement += "   WHERE (BOLNo = '" + BOLNumberBox.Text + "')) GERDtl";
        SqlStatement += " WHERE GERDtl.pGERDtlID = GERProcess.GERDetailID  ";
        SqlStatement += " and GERProcess.ProcessDt IS NULL) GetMstr ";
        SqlStatement += " group by BOLNo, ProcessRecInd";
        dsGER = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, SqlStatement);
        dtBOLData = dsGER.Tables[0];
        ResultsGridView.DataSource = dtBOLData;
        ResultsGridView.DataBind();
        ResultsGridView.Visible = true;
        UpdateButton.Visible = false;
        BOLNumberBox.Focus();
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
