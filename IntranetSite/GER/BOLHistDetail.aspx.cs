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
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.IO;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;
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
        Ajax.Utility.RegisterTypeForAjax(typeof(BOLHistDetail));

        if (!IsPostBack)
        {
            lblSuccessMessage.Text = "Enter BOL Number";
            BOLNumberBox.Focus();

            // if the page is called from GERFilter page
            if (Request.QueryString["BOLNo"] != null &&
                Request.QueryString["BOLNo"].ToString() != "")
            {
                lblErrorMessage.Text = "";
                BOLNumberBox.Text = Request.QueryString["BOLNo"].ToString();

                if (BindBOLData(BOLNumberBox.Text))
                    BOLDetail.Focus();

                lblSuccessMessage.Text = "";
            }
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
        string ColumnNames = "*, convert(varchar,RcptQty) + BaseUOM as UMQty, UOMatlAmt/RcptQty as MatlCost";
        ColumnNames += ", UODutyAmt/RcptQty as DutyPerUnit";
        ColumnNames += ", UOOceanFrghtAmt/RcptQty as OceanPerUnit";
        ColumnNames += ", UOBrokerageAmt/RcptQty as BrokerPerUnit";
        ColumnNames += ", UODrayAmt/RcptQty as DrayPerUnit";
        ColumnNames += ", (UOMerchProcFee+UOHarborMaintFee)/RcptQty as HarborPerUnit";
        ColumnNames += ", UOMiscFeeAmt/RcptQty as MiscPerUnit";
        ColumnNames += ", UOTrkFrghtAmt/RcptQty as TruckPerUnit";
        ColumnNames += ", (1000*UOMatlAmt/PcsPerAlt)/RcptQty as MatlK";
        dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
            new SqlParameter("@tableName", "GERHeaderHist"),
            new SqlParameter("@columnNames", "*"),
            new SqlParameter("@whereClause", "BOLNo='" + BOLNumber + "'"));
        // get the detail data
        dsBOLDetail = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
            new SqlParameter("@tableName", "GERDetailHist"),
            new SqlParameter("@columnNames", ColumnNames),
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


    #region Write to Excel
    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        String xlsFile = "BOLHistDetail" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//Common//ExcelUploads//") + xlsFile;
        FileInfo fnExcel = new FileInfo(ExportFile);
        StreamWriter reportWriter = fnExcel.CreateText();

        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;

        headerContent = "<table border='1'>";
        headerContent += "<tr><th colspan='12' style='color:blue' align=left><center>BOL Historical Detail</center></th></tr><tr><td></td>";

        if (dtBOLData != null && dtBOLData.Rows.Count > 0)
        {
            headerContent += "<td colspan='4'><b>BOL # " + dtBOLData.Rows[0]["BOLNo"].ToString() + "</b></td>" +
                             "<td colspan='3'><b>Processed: " + string.Format("{0:MM/dd/yyyy}", dtBOLData.Rows[0]["ProcDt"]) + "</b></td>" +
                             "<td colspan='4'><b>Rcpt Type: " + dtBOLData.Rows[0]["RcptTypeDesc"].ToString() + "</b></td><td colspan='6'></td></tr><tr><td></td>" +

                             "<td colspan='4'><b>BOL Date: " + string.Format("{0:MM/dd/yyyy}", dtBOLData.Rows[0]["BOLDate"]) + "</b></td>" +
                             "<td colspan='3'><b>Vendor: " + dtBOLData.Rows[0]["VendNo"].ToString() + " - " + dtBOLData.Rows[0]["VendName"].ToString() + "</b></td>" +
                             "<td colspan='4'><b>Port: " + dtBOLData.Rows[0]["PortOfLading"].ToString() + "</b></td><td colspan='6'></td></tr><tr><td></td>" +

                             "<td colspan='4'><b>BOL Loc: " + dtBOLData.Rows[0]["PFCLocCd"].ToString() + " - " + dtBOLData.Rows[0]["PFCLocName"].ToString() + "</b></td>" +
                             "<td colspan='3'><b>Pay-To-Acct: " + dtBOLData.Rows[0]["PayToVend"].ToString() + "</b></td>" +
                             "<td colspan='4'><b>Vessel: " + dtBOLData.Rows[0]["VesselName"].ToString() + "</b></td><td colspan='6'></td></tr>" +
                             "<tr><th colspan='18' style='color:blue' align=left></th></tr>";
        }

        headerContent += "<tr>" +
                         "<th width='100' nowrap align='center'>Invoice</td>" +
                         "<th width='100' nowrap align='center'>Inv Date</th>" +
                         "<th width='100' nowrap align='center'>Container</th>" +
                         "<th width='100' nowrap align='center'>PO</th>" +
                         "<th width='100' nowrap align='center'>Item</th>" +
                         "<th width='250' nowrap align='center'>Item Desc</th>" +
                         "<th width='80'  nowrap align='center'>UM Qty</th>" +
                         "<th width='80'  nowrap align='center'>Pcs Qty</th>" +
                         "<th width='80'  nowrap align='center'>Land Cost UM</th>" +
                         "<th width='80'  nowrap align='center'>Matl Cost</th>" +
                         "<th width='80'  nowrap align='center'>Duty</th>" +
                         "<th width='80'  nowrap align='center'>Oc Fr</th>" +
                         "<th width='80'  nowrap align='center'>Broker</th>" +
                         "<th width='80'  nowrap align='center'>Dray</th>" +
                         "<th width='80'  nowrap align='center'>Harbor</th>" +
                         "<th width='80'  nowrap align='center'>Misc</th>" +
                         "<th width='80'  nowrap align='center'>Trk Frt</th>" +
                         "<th width='80'  nowrap align='center'>Alt Cost</th>" +
                         "</tr>";

        if (dtBOLDetail != null && dtBOLDetail.Rows.Count > 0)
        {
            foreach (DataRow drBOLDetail in dtBOLDetail.Rows)
            {
                excelContent += "<tr><td nowrap align='center'>" +
                                drBOLDetail["VendInvNo"] + "</td><td nowrap align='center'>" +
                                string.Format("{0:MM/dd/yyyy}", drBOLDetail["VendInvDt"]) + "</td><td nowrap align='center'>" +
                                drBOLDetail["ContainerNo"] + "</td><td nowrap align='center'>" +
                                drBOLDetail["PFCPONo"] + "</td><td nowrap align='center'>" +
                                drBOLDetail["PFCItemNo"] + "</td><td nowrap align='left'>" +
                                drBOLDetail["PFCItemDesc"] + "</td><td nowrap align='right'>" +

                                string.Format("{0:d1}", drBOLDetail["UMQty"]) + "</td><td nowrap>" +
                                string.Format("{0,-10:###,##0}", drBOLDetail["PcsPerAlt"]) + "</td><td nowrap>" +
                                string.Format("{0,-10:$##,##0.00}", drBOLDetail["UOMatlAmtLanded"]) + "</td><td nowrap>" +
                                string.Format("{0,-10:$##,##0.00}", drBOLDetail["MatlCost"]) + "</td><td nowrap>" +
                                string.Format("{0,-10:$##,##0.00}", drBOLDetail["DutyPerUnit"]) + "</td><td nowrap>" +
                                string.Format("{0,-10:$##,##0.00}", drBOLDetail["OceanPerUnit"]) + "</td><td nowrap>" +
                                string.Format("{0,-10:$##,##0.00}", drBOLDetail["BrokerPerUnit"]) + "</td><td nowrap>" +
                                string.Format("{0,-10:$##,##0.00}", drBOLDetail["DrayPerUnit"]) + "</td><td nowrap>" +


                                string.Format("{0,-10:$##,##0.00}", drBOLDetail["HarborPerUnit"]) + "</td><td nowrap>" +
                                string.Format("{0,-10:$##,##0.00}", drBOLDetail["MiscPerUnit"]) + "</td><td nowrap>" +
                                string.Format("{0,-10:$##,##0.00}", drBOLDetail["TruckPerUnit"]) + "</td><td nowrap align='right'>" +
                                string.Format("{0,-10:$##,##0.00} M", drBOLDetail["MatlK"]) + "</td>" +
                                "</tr>";
            }
        }


        reportWriter.WriteLine(headerContent + excelContent + footerContent);
        reportWriter.Close();

        //Downloding Process
        FileStream fileStream = File.Open(ExportFile, FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(ExportFile));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {
            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..//Common//ExcelUploads//"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(strSession))
                    fn.Delete();
            }

            return "";
        }
        catch (Exception ex) { return ""; }
    }
    #endregion
}
