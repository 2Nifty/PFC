/********************************************************************************************
 * File	Name			:	MoveFromHist.aspx.cs
 * File Type			:	C#
 * Project Name			:	Goods En Route
 * Created By			:	Slater
 * Created Date			:	05/28/2008	
 * History				: 
 * DATE					VERSION			AUTHOR			            ACTION
 * ****					*******			******				        ******
 * 05/28/2008		    Version 1		Slater              		Created 
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

public partial class GERMoveFromHist : System.Web.UI.Page
{

    #region Global Variable Decalaration
    DataTable dtBOLData = new DataTable();
    PFC.Intranet.BusinessLogicLayer.GER ger = new PFC.Intranet.BusinessLogicLayer.GER();
    string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    string NVconnectionString = ConfigurationManager.AppSettings["NVConnectionString"].ToString();
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

    #region GERMoveFromHist methods

    public void BindBOLData(string BOLNumber)
    {
        lblSuccessMessage.Text = "";
        lblErrorMessage.Text = "";
        DataSet dsGER = new DataSet();
        DataTable dtBOLLineData = new DataTable();
        DataTable dtRcptData = new DataTable();
        String PONumber = "";
        String POLineNumber = "";
        Boolean UpdateOK = true;
        UpdateButton.Visible = false;
        PreUpdateGridView.Visible = false;
        NVStatusGrid.Visible = false;
        string SqlStatement = " select pGERHdrHstID, BOLNo, BOLDate, VendNo, VendName, ProcDt ";
        SqlStatement += " FROM GERHeaderHist";
        SqlStatement += "   WHERE (BOLNo = '" + BOLNumber + "') ";
        dsGER = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, SqlStatement);
        if (dsGER.Tables[0] != null)
        {
            dtBOLData = dsGER.Tables[0];
            PreUpdateGridView.DataSource = dtBOLData;
            PreUpdateGridView.DataBind();
            if (dtBOLData.Rows.Count == 0)
            {
                lblErrorMessage.Text = "BOL not in History.";
                UpdateOK = false;
            }
            else
            {
                DataTable dtStatusData = new DataTable();
                dtStatusData.Columns.Add("DataType", typeof(String));
                dtStatusData.Columns.Add("DataStatus", typeof(String));
                dtStatusData.Columns.Add("RcptNo", typeof(String));
                dtStatusData.Columns.Add("RcptLine", typeof(String));
                dtStatusData.Columns.Add("Item", typeof(String));
                dtStatusData.Columns.Add("PONo", typeof(String));
                dtStatusData.Columns.Add("POLine", typeof(String));
                // now check the lines
                SqlStatement = " select  PFCPONo, PFCPOLineNo, PFCItemNo, RcptQty ";
                SqlStatement += " FROM GERDetailHist";
                SqlStatement += "   WHERE (BOLNo = '" + BOLNumber + "') ";
                dsGER = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, SqlStatement);
                if (dsGER.Tables[0] != null)
                {
                    dtBOLLineData = dsGER.Tables[0];
                    if (dtBOLData.Rows.Count == 0)
                    {
                        lblErrorMessage.Text = "Problem: No BOL Lines in History.";
                        UpdateOK = false;
                    }
                    else
                    {
                        foreach (DataRow row in dtBOLLineData.Rows)
                        {
                            PONumber = row["PFCPONo"].ToString();
                            POLineNumber = row["PFCPOLineNo"].ToString();
                            SqlStatement = " select   [Document No_], [Line No_], No_, [Location Code], [Order No_], [Order Line No_], [Bill of Lading No_], [Bill of Lading Date] ";
                            SqlStatement += " FROM   [Porteous$Purch_ Rcpt_ Line] WITH (NOLOCK) ";
                            SqlStatement += "   WHERE ([Order No_] = '" + PONumber + "') ";
                            SqlStatement += "   and ([Order Line No_] = " + POLineNumber + ") ";
                            SqlStatement += "   and ([Bill of Lading No_] = '" + BOLNumber + "') ";
                            dsGER = SqlHelper.ExecuteDataset(NVconnectionString, CommandType.Text, SqlStatement);
                            if (dsGER.Tables[0] != null)
                            {
                                dtRcptData = dsGER.Tables[0];
                                if (dtRcptData.Rows.Count == 0)
                                {
                                    dtStatusData.Rows.Add(new Object[] { "P.O. Receipts", 
                                        "OK", "None", "", row["PFCItemNo"].ToString(), PONumber, POLineNumber });
                                }
                                else
                                {
                                    dtStatusData.Rows.Add(new Object[] { "P.O. Receipts", 
                                        "Records found" , dtRcptData.Rows[0]["Document No_"].ToString(), 
                                        dtRcptData.Rows[0]["Line No_"].ToString(), row["PFCItemNo"].ToString(), 
                                        PONumber, POLineNumber });
                                    UpdateOK = false;
                                    lblErrorMessage.Text = "Receipts already exist for this BOL so it cannot be reprocessed.";
                                }
                            }
                        }
                    }
                }
                if (UpdateOK)
                {
                    UpdateButton.Visible = true;
                    lblSuccessMessage.Text = "Press the Update button to move this BOL from history and make it ready for reprocessing";
                }
                PreUpdateGridView.Visible = true;
                NVStatusGrid.DataSource = dtStatusData;
                NVStatusGrid.DataBind();
                NVStatusGrid.Visible = true;
            }
        }
        else
        {
            lblErrorMessage.Text = "BOL not in History..";
        }
    }

    protected void UpdateButton_Click(object sender, ImageClickEventArgs e)
    {
        // 
        string UserName = ((Session["UserName"] != null) ? Session["UserName"].ToString() : "Unknown");
        int result = SqlHelper.ExecuteNonQuery(connectionString, "pGERMoveFromHist",
              new SqlParameter("@BOL", BOLNumberBox.Text),
              new SqlParameter("@EntryID", UserName));
        lblSuccessMessage.Text = "BOL ready to be processed in GER maintenance.";
        //SqlStatement = " select BOLNo, ProcessRecInd from (  ";
        //SqlStatement += " Select BOLNo, case GERProcess.ProcessRecInd when 1 then 'Now' else 'Nightly' end as ProcessRecInd  ";
        //SqlStatement += " FROM GERProcess,  ";
        //SqlStatement += "   (SELECT * ";
        //SqlStatement += " 	FROM GERDetail ";
        //SqlStatement += "   WHERE (BOLNo = '" + BOLNumberBox.Text + "')) GERDtl";
        //SqlStatement += " WHERE GERDtl.pGERDtlID = GERProcess.GERDetailID  ";
        //SqlStatement += " and GERProcess.ProcessDt IS NULL) GetMstr ";
        //SqlStatement += " group by BOLNo, ProcessRecInd";
        //dsGER = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, SqlStatement);
        //dtBOLData = dsGER.Tables[0];
        //ResultsGridView.DataSource = dtBOLData;
        //ResultsGridView.DataBind();
        //ResultsGridView.Visible = true;
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
