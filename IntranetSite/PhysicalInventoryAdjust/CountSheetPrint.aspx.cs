using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.IO;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Data.Sql;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.InvoiceRegister;
using System.Text.RegularExpressions;

public partial class PhysicalInventoryAdjustPage : System.Web.UI.Page
{
    # region Variable Declaration
        
    PhysicalInventoryAdjustment physicalInventoryAdjustment = new PhysicalInventoryAdjustment();
    DataTable dtExcelData = new DataTable();
    DataSet dsInvData = new DataSet();
    GridView dv = new GridView();

    int pageCount = 18;
    string border = "0";// Border is a dynamic variable because we need to print grid headers without border
    string StartDate = "";
    string EndDate = "";
    string BranchID = "";
    string SalesPerson = "";
    string BranchDesc = "";
    string sortExpression = string.Empty;    
    string excelFilePath = "../Common/ExcelUploads/";
    
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(PhysicalInventoryAdjustPage));
        Response.Cache.SetCacheability(HttpCacheability.NoCache);                

        if (!IsPostBack)
        {
            //string securityCode = physicalInventoryAdjustment.GetSecurityCode(Session["UserName"].ToString());
            //if (securityCode == "")
            //    Response.Redirect("../Common/ErrorPage/unauthorizedpage.aspx");

            Session["InvAdjustData"] = null;
            hidFileName.Value = "PhyInvAdjust" + Session["SessionID"].ToString() + ".xls";

            BindLocationDropdown();            
        }
    }


    protected void btnGetItem_Click(object sender, ImageClickEventArgs e)
    {
        Session["InvAdjustData"] = null;

        BindDataGrid();
                
        divdatagrid.Attributes.Add("style", "height: 500px;overflow-y: auto;");
        pnlGrid.Update();
    }


    private void BindDataGrid()
    {
        //if (Session["InvAdjustData"] == null)
        //{
        DataSet _dsInventoryData = physicalInventoryAdjustment.GetInventoryData(ddlLocation.SelectedValue.ToString());
        Session["InvAdjustData"] = _dsInventoryData;
        //    hidSort.Value = "";
        //}

        dsInvData = Session["InvAdjustData"] as DataSet;
        if (dsInvData != null)
        {
            DataTable dtQuoteData = dsInvData.Tables[0];
            if (dtQuoteData != null && dtQuoteData.Rows.Count > 0)
            {
                gvPhysicalInv.DataSource = dtQuoteData.DefaultView.ToTable();
                pager.InitPager(gvPhysicalInv, pageCount);
                gvPhysicalInv.Visible = true;
                lblStatus.Visible = false;
                pager.Visible = true;
            }
            else
            {
                gvPhysicalInv.Visible = false;
                lblStatus.Visible = true;
                pager.Visible = false;
            }
        }

        pnlGrid.Update();
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        gvPhysicalInv.PageIndex = pager.GotoPageNumber;
        BindDataGrid();
    }

    protected void gvPhysicalInv_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            TextBox txtAfterQty = e.Row.FindControl("txtAfterQty") as TextBox;
            HiddenField _hidItemNo = e.Row.FindControl("hidItemNo") as HiddenField;            
            string binLoc = e.Row.Cells[0].Text;

            txtAfterQty.Attributes.Add("onchange", "javascript:PhysicalInventoryAdjustPage.UpdateDisplayAfterQty('" + _hidItemNo.Value + "',this.value,'" + binLoc + "');");
        }        
    }

    protected void btnSort_Click(object sender, EventArgs e)
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

        hidSort.Value = hidSortExpression.Value + " " + hidSort.Attributes["sortType"].ToString();
        BindDataGrid();
    }

    protected void gvPhysicalInv_Sorting(object sender, GridViewSortEventArgs e)
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

    private void BindLocationDropdown()
    {
        physicalInventoryAdjustment.BindListControls(ddlLocation, "Name", "Code", physicalInventoryAdjustment.GetERPBranches(), "--- Select ---");
    }  

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public bool UpdateDisplayAfterQty(string itemNo,string newQty,string binLoc)
    {
        try
        {
            DataSet _dsInvData = Session["InvAdjustData"] as DataSet;
            DataRow[] dr = _dsInvData.Tables[0].Select("ItemNo='" + itemNo + "' and BinLoc='" + binLoc + "'");
            dr[0]["DispAfterQty"] = newQty;
            _dsInvData.Tables[0].AcceptChanges();
            Session["InvAdjustData"] = _dsInvData;

            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }

    #region Export Options - To be Deleted

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        string _excelData = GenerateExportData("Excel");

        FileInfo fnExcel = new FileInfo(Server.MapPath(excelFilePath + hidFileName.Value.ToString()));
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        reportWriter.WriteLine(_excelData);
        reportWriter.Close();

        // Downloding Process
        FileStream fileStream = File.Open(Server.MapPath(excelFilePath + hidFileName.Value.ToString()), FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        // Download Process
        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath(excelFilePath + hidFileName.Value.ToString())));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }

    protected void dv_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //if (e.Row.RowType == DataControlRowType.Header)
        //{
        //    e.Row.Cells[3].ColumnSpan = 2;
        //    e.Row.Cells[3].Text = "<table border='" + border + "' style='font-weight:bold;' cellpadding='0' cellspacing='0'  width='100%'><tr><td  colspan=2 nowrap ><center>Final Quote</center></td></tr><tr><td width='53' nowrap ><center>" +
        //                                "<Div style='cursor:hand;' onclick=\"javascript:BindValue('RequestQuantity');\">Req Qty</div></center></td><td width='45' nowrap align='center' nowrap >" +
        //                                "<Div onclick=\"javascript:BindValue('AvailableQuantity');\">Avl Qty</div></td></tr></table>";

        //    e.Row.Cells[4].Visible = false;

        //    e.Row.Cells[6].ColumnSpan = 3;
        //    e.Row.Cells[6].Text = "<table border='" + border + "' style='font-weight:bold;' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' colspan=3 nowrap ><center>Initial Entry</center></td></tr><tr><td width='43'><center>" +
        //                                "<Div style='cursor:hand;' onclick=\"javascript:BindValue('InitialReqQty');\">Req Qty</div></center></td><td width='42' align='center'>" +
        //                                "<Div style='cursor:hand;' onclick=\"javascript:BindValue('InitialAvailableQty');\">Avl Qty</div></center></td><td width='38' align='center'>" +
        //                                "<Div onclick=\"javascript:BindValue('InitialLocationCode');\">Loc</div></td></tr></table>";

        //    e.Row.Cells[7].Visible = false;
        //    e.Row.Cells[8].Visible = false;

        //    e.Row.Cells[9].ColumnSpan = 2;
        //    e.Row.Cells[9].Text = "<table border='" + border + "' style='font-weight:bold;'  cellpadding='0' cellspacing='0'  width='100%'><tr><td colspan=2 nowrap ><center>Sales Person</center></td></tr><tr><td width='73' ><center>" +
        //                                "<Div style='cursor:hand;' onclick=\"javascript:BindValue('Name');\">Name</div></center></td><td width='39'>" +
        //                                "<Div onclick=\"javascript:BindValue('OELoc');\">Loc</div></td></tr></table>";

        //    e.Row.Cells[10].Visible = false;


        //    e.Row.Cells[13].ColumnSpan = 3;
        //    e.Row.Cells[13].Text = "<table border='" + border + "' style='font-weight:bold;'  cellpadding='0' cellspacing='0'  width='100%'><tr><td colspan=3 nowrap ><center>Count</center></td></tr><tr><td width='52'><center>" +
        //                                "<Div style='cursor:hand;' onclick=\"javascript:BindValue('LineCnt');\">Lines</div></center></td><td width='55' >" +
        //                                "<Div style='cursor:hand;' onclick=\"javascript:BindValue('AvlShort');\">Avl Short</div></center></td><td width='65'>" +
        //                                "<Div onclick=\"javascript:BindValue('MadeOrder');\">Made Order</div></td></tr></table>";

        //    e.Row.Cells[14].Visible = false;
        //    e.Row.Cells[15].Visible = false;
        //}
        //if (e.Row.RowType == DataControlRowType.DataRow)
        //{
        //    e.Row.Cells[1].Attributes.Add("class", "text");
        //    e.Row.Cells[8].Attributes.Add("class", "text");
        //    e.Row.Cells[10].Attributes.Add("class", "text");

        //    if (e.Row.Cells[0].Text.Trim() == "Total")
        //    {
        //        e.Row.Font.Bold = true;
        //        e.Row.Cells[10].Visible = false;
        //        e.Row.Cells[0].Text = "";
        //        e.Row.Cells[9].ColumnSpan = 2;                
        //    }
        //}

    }

    private string GenerateExportData(string dataFormat)
    {
        border = (dataFormat == "Print" ? "0" : "1");
        DataSet _dsQuoteData = Session["InvAdjustData"] as DataSet;
        dtExcelData = new DataTable();

        string styleSheet = "<style>.text { mso-number-format:\\@; } </style>";
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;

        dtExcelData = _dsQuoteData.Tables[0];

        //headerContent = "<table border='" + border + "' width='100%'>";
        //headerContent += "<tr><th colspan='16' style='color:blue' align=left><center>Quote Metrics Report</center></th></tr>";
        //headerContent += "<tr><td colspan='3'><b>Beginning Date :" + StartDate + "</b></td><td  colspan='3'><b>Ending Date:" + EndDate + "</b></td><td colspan='10'></td></tr>";
        //headerContent += "<tr><td  colspan='3'> <b>Branch:" + BranchDesc + "</b></td>" +
        //                    "<td  colspan='3'><b>Sales Person: " + SalesPerson + "</b></td>" +
        //                    "<td colspan='5'><b>Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;  Run Date: " + DateTime.Now.ToShortDateString() + "</></td></tr>";
        //headerContent += "<tr><th colspan='16' style='color:blue' align=left></th></tr>";

        if (dtExcelData.Rows.Count > 0)
        {
            dv.AutoGenerateColumns = false;
            dv.ShowHeader = true;
            dv.ShowFooter = false;
            dv.RowDataBound += new GridViewRowEventHandler(dv_RowDataBound);
            dv.RowStyle.Height = 30;
            dv.HeaderStyle.Height = 20;
            dv.RowStyle.VerticalAlign = VerticalAlign.Top;

            BoundField bfExcel = new BoundField();
            bfExcel.HeaderText = "Bin Loc";
            bfExcel.DataField = "BinLoc";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Category";
            bfExcel.DataField = "Category";            
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Size";
            bfExcel.DataField = "Size";
            bfExcel.ItemStyle.Width = 60;
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Pack/Plate";
            bfExcel.DataField = "PackPlate";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Description";
            bfExcel.ItemStyle.Width = 200;
            bfExcel.DataField = "ItemDesc";            
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Before Qty";
            bfExcel.DataField = "BeforeQty";            
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "New Qty";
            bfExcel.DataField = "";
            bfExcel.ItemStyle.Width = 60;
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            dv.DataSource = dtExcelData;
            dv.DataBind();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            System.IO.StringWriter sw = new System.IO.StringWriter(sb);
            HtmlTextWriter htw = new HtmlTextWriter(sw);
            dv.RenderControl(htw);
            excelContent = sb.ToString();

        }
        else
        {
            excelContent = "<tr  ><th width='100%' align ='center' colspan='7' > No records found</th></tr> </table>";
        }

        return styleSheet + headerContent + excelContent;
    }

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath(excelFilePath));

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
        string excelContent = GenerateExportData("Print");

        string pattern = @"\s*\r?\n\s*";
        excelContent = Regex.Replace(excelContent, pattern, "");
        excelContent = Regex.Replace(excelContent, "<tr><th", "<THEAD style='display:table-header-group;'><TR><th").Replace("</th></tr>", "</th></TR></THEAD>");
        excelContent = excelContent.Replace("BORDER-COLLAPSE: collapse;", "border-collapse:separate;").Replace("BORDER-LEFT: #c9c6c6 1px solid;", "BORDER-LEFT: #c9c6c6 0px solid;").Replace("BORDER-RIGHT: #c9c6c6 1px solid;", "BORDER-RIGHT: #c9c6c6 0px solid;");
        excelContent = excelContent.Replace("BORDER-TOP: #c9c6c6 1px solid;", "BORDER-TOP: #c9c6c6 0px solid;").Replace("BORDER-BOTTOM: #c9c6c6 1px solid;", "BORDER-BOTTOM: #c9c6c6 0px solid;");

        Session["PrintContent"] = excelContent;
        ScriptManager.RegisterClientScriptBlock(ibtnPrint, ibtnPrint.GetType(), "Print", "PrintReport();", true);
    }
}

