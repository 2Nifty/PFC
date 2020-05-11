using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.IO;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.BusinessLogicLayer;

public partial class WarehouseMgmt_ReceiveReport : System.Web.UI.Page
{
    Warehouse warehouse = new Warehouse();
    DataTable dtReport = new DataTable();
    DataTable dtExcelReport = new DataTable();
    string location = "";
    string _lpn="";
    string LPNNo = "";
    string containerNo = "";
    string documentNo = "";
    string bolNo = "";

    bool LPNval;

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(WarehouseMgmt_ReceiveReport));

        location = Request.QueryString["Location"].ToString();
        containerNo = Request.QueryString["ContainerNo"].ToString();
        bolNo = Request.QueryString["BOLNo"].ToString();
        documentNo = Request.QueryString["DocumentNo"].ToString();

        if (!IsPostBack)
        {
            hidFileName.Value = "ReceiveReport" + Session["SessionID"].ToString() + ".xls";
            BindDataGrid();
        }
        BindLabels();
    }

    private void BindDataGrid()
    {
        string whereClause ="";
        

        if (location != "")
            whereClause = "location='" + location + "'";
        else 
            whereClause = "location<>''";

        if (containerNo != "")
            whereClause += " AND ContainerNo='" + containerNo + "'";
        if(bolNo != "")
            whereClause += " AND BolNo='" + bolNo + "'";
        if (documentNo != "")
            whereClause += " AND DocumentNo='" + documentNo + "'";

        dtReport = warehouse.GetLPNInformation(whereClause);

        ViewState["WhereClause"] = whereClause;
        if (dtReport != null && dtReport.Rows.Count > 0)
        {
            if (hidSort.Value != "")
            {
                dtReport.DefaultView.Sort = hidSort.Value;
            }
            gvReport.DataSource = dtReport.DefaultView;
            gvReport.DataBind();
            lblStatus.Visible = false;
        }
        else
        {
            ClearControl();
          
            lblStatus.Visible = true;
            lblStatus.Text = "No Records Found";
        }
    }


    protected void gvReport_Sorting(object sender, GridViewSortEventArgs e)
    {
        if (hidSort.Attributes["sortType"] != null)
        {
            if (hidSort.Attributes["sortType"].ToString() == "ASC")
                hidSort.Attributes["sortType"] = "DESC";
            else
                hidSort.Attributes["sortType"] = "ASC";
        }
        else
            hidSort.Attributes.Add("sortType", "ASC");

        hidSort.Value = e.SortExpression + " " + hidSort.Attributes["sortType"].ToString();
       
        BindDataGrid();

    }
    private void BindLabels()
    {
        lblWhse.Text = (location != "") ? Request.QueryString["LocName"].ToString() : "ALL";
        lblContainerNo.Text = containerNo.Trim();
        lblBOLNo.Text = bolNo.Trim();
        lblDocumentNo.Text = documentNo.Trim();
        lblRunBy.Text = Session["UserName"].ToString();
        lblRunDate.Text = DateTime.Now.ToShortDateString();
    }
    private void ClearControl()
    {
        lblWhse.Text = lblContainerNo.Text=lblDocumentNo.Text ="";
        lblBOLNo.Text = lblRunDate.Text = lblRunBy.Text = "";
         
    }

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
        DataTable dtTrendExcel = new DataTable();

        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;

        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();

        dtExcelReport = (DataTable)warehouse.GetLPNInformation(ViewState["WhereClause"].ToString());
       

        headerContent = "<table border='1' width='70%'>";
        headerContent += "<tr><th colspan='10' style='color:blue'>Warehouse Receiving Report</th></tr>";
        headerContent += "<tr><th colspan='3' width='500px' align='left' > Whse:" + lblWhse.Text + "</th><th colspan='3'  align='left' >Bill of Lading #:" + lblBOLNo.Text + "</th><th colspan='2' align='right' >Run By: " + Session["UserName"].ToString() + "</th><th colspan='2' >Run Date: " + DateTime.Now.ToShortDateString() + "</th></tr>";
        headerContent += "<tr><th colspan='3' width='500px' align='left' > Container #:" + lblContainerNo.Text + "</th><th colspan='3'  align='left' >Document #:" + lblDocumentNo.Text + "</th><th colspan='2' align='right' ></th><th colspan='2' ></th></tr>";
        headerContent += "<tr><th colspan='10' style='color:blue'></th></tr>";


        if (dtExcelReport.Rows.Count > 0)
        {
            headerContent += "<tr><th style='width:120px;'>License Plate #</th><th style='width:150px;'>Container #</th><th style='width:80px;'>Bill of Landing #</th>" +
                                "<th style='width:80px;'>Document #</th><th style='width:50px;'>WHSE</th>" +
                                "<th style='width:120px;'>Item No</th><th style='width:80px;'>Qty/UOM</th>" +
                                "<th style='width:50px;'> Qty Rcvd</th><th style='width:100px;'>Bin Location</th>" +
                                "<th width='100' align='center'   >LPN Date</th> </th>";
            foreach (DataRow roiReader in dtExcelReport.Rows)
            {
                excelContent += "<tr><td align='left'>" + roiReader["LPN"].ToString() + "</td><td style=\"mso-number-format:\\@;\">" +
                            roiReader["ContainerNo"].ToString() + "</td><td >" +
                            roiReader["BolNo"].ToString() + "</td><td >" +
                            roiReader["DocumentNo"].ToString() + "</td><td style=\"mso-number-format:\\@;\">" +
                            roiReader["WHSE"].ToString() + "</td><td >" +
                            roiReader["ItemNo"].ToString() + "</td><td >" +
                            roiReader["QtyUOM"].ToString() + "</td><td>" +
                            "</td><td nowrap=nowrap>" +
                            roiReader["BinLoc"].ToString() + "</td><td align='left'>" +
                            String.Format("{0:MM/dd/yyyy}", roiReader["LPNDate"].ToString()) + "</td></tr>";
                      

            }
           

        }
        reportWriter.WriteLine(headerContent + excelContent );
        reportWriter.Close();

        //Downloding Process
        FileStream fileStream = File.Open(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()), FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();


        //  Download Process
        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString())));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();


    }

    #region Delete Excel using sessionid

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\WarehouseMgmt\\Common\\ExcelUploads"));

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

    protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
    {
        string strURL = "Location=" + location +  "&LocName=" + lblWhse.Text;
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "PrintReport('" + strURL + "');", true);
    }
}
