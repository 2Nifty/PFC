/********************************************************************************************
 * File	Name			:	BOLSummary.aspx.cs
 * File Type			:	C#
 * Project Name			:	Goods En Route
 * Created By			:	Slater
 * Created Date			:	07/22/2007	
 * History				: 
 * DATE					VERSION			AUTHOR			            ACTION
 * ****					*******			******				        ******
 * 07/22/2007		    Version 1		Slater              		Created 
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

public partial class BOLSummary : System.Web.UI.Page
{

    #region Global Variable Decalaration
    DataTable dtBOLData = new DataTable();
    DataTable dtChargeData = new DataTable();
    DataTable dtBOLChargeData = new DataTable();
    PFC.Intranet.BusinessLogicLayer.GER ger = new PFC.Intranet.BusinessLogicLayer.GER();
    string BOL;
    #endregion

    #region Auto generated events

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblSuccessMessage.Text = "Enter BOL Number";
        }
        if (IsPostBack)
        {
            lblErrorMessage.Text = "";
            BindBOLData(BOLNumberBox.Text);
            lblSuccessMessage.Text = "";
        }
        BOLNumberBox.Focus();
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
            PrintButton.Visible = false;
            BOLNumberBox.Visible = false;
            FindBOLButt.Visible = false;
            BOLLabel.Visible = false;
            CloseButton.PostBackUrl = "javascript:window.close();";
            lblSuccessMessage.Text = "";
        }
    }

    #endregion

    #region BOLSummary functions

    public void BindBOLData(string BOLNumber)
    {
        DataSet dsGER = new DataSet();
        DataSet dsCharges = new DataSet();
        DataSet dsBOLCharges = new DataSet();
        string ColumnNames = "";
        ColumnNames = "BOLNo ,";
        ColumnNames += "BOLDate,";
        ColumnNames += "VendNo,VendName,";
        ColumnNames += "APInvoiceNumber,PurchReceiptNumber,";
        ColumnNames += "TransferOrderNumber,TransferShipmentNumber,";
        ColumnNames += "UOMatlAmtLanded";
        dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
            new SqlParameter("@tableName", "GERBOLSummary"),
            new SqlParameter("@columnNames", ColumnNames),
            new SqlParameter("@whereClause", "BOLNo='" + BOLNumber + "'"));
        // get the detail data
        ColumnNames = "UOMatlAmt,";
        ColumnNames += "UODutyAmt,";
        ColumnNames += "UOOceanFrghtAmt,";
        ColumnNames += "UOBrokerageAmt,";
        ColumnNames += "UODrayAmt,";
        ColumnNames += "UOMerchProcFee,";
        ColumnNames += "UOHarborMaintFee,";
        ColumnNames += "UOMiscWghtFee,";
        ColumnNames += "UOMiscFeeAmt,";
        ColumnNames += "UOTrkFrghtAmt";
        dsBOLCharges = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
                        new SqlParameter("@tableName", "GERBOLSummary"),
                        new SqlParameter("@columnNames", ColumnNames),
                        new SqlParameter("@whereClause", "BOLNo='" + BOLNumber + "'"));

        if (dsGER.Tables[0] != null)
        {
            dtBOLData = dsGER.Tables[0];
            BOLDetails.DataSource = dtBOLData;
            BOLDetails.DataBind();
            if (dtBOLData.Rows.Count == 0)
            {
                lblErrorMessage.Text = "BOL Number not on file";
            }
            else
            {
                dtBOLChargeData = dsBOLCharges.Tables[0];
                BOLAmounts.DataSource = dtBOLChargeData;
                BOLAmounts.DataBind();
                PrintButton.Visible = true;
            }
        }
        else
        {
            lblErrorMessage.Text = "BOL Number not on file";
        }
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
