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
        lblHeaderMsg.Text = "";
        lblMsg.Text = "";

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

    protected void btnSubmit_Click(object sender, ImageClickEventArgs e)
    {
        DataSet _dsInvData = Session["InvAdjustData"] as DataSet;
        DataRow[] dr = _dsInvData.Tables[0].Select("DispAfterQty <> OrgAfterQty OR NewRec='1'");

        DataTable dtModifiedData = new DataTable();
        dtModifiedData.Columns.Add("pPhysicalInventoryERPAdjID", typeof(int));
        dtModifiedData.Columns.Add("Location");
        dtModifiedData.Columns.Add("BinLoc");
        dtModifiedData.Columns.Add("ItemNo");
        dtModifiedData.Columns.Add("PackSize");
        dtModifiedData.Columns.Add("CountQty", typeof(float));
        dtModifiedData.Columns.Add("EntryID");
        dtModifiedData.Columns.Add("EntryDt", typeof(DateTime));
        dtModifiedData.Columns.Add("ChangeID");
        dtModifiedData.Columns.Add("ChangeDt", typeof(DateTime));
        dtModifiedData.Columns.Add("AdjCreated");

        for (int i = 0; i < dr.Length; i++)
        {
            DataRow drMod = dtModifiedData.NewRow();
            drMod["Location"] = dr[i]["Location"];
            drMod["BinLoc"] = dr[i]["BinLoc"];
            drMod["ItemNo"] = dr[i]["ItemNo"];
            drMod["PackSize"] = "1";
            drMod["CountQty"] = dr[i]["DispAfterQty"];
            drMod["EntryID"] = Session["UserName"].ToString();
            drMod["EntryDt"] = DateTime.Now;
            drMod["AdjCreated"] = "0";
            dtModifiedData.Rows.Add(drMod);
        }


        if (dtModifiedData.Rows.Count > 0)
        {
            try
            {
                physicalInventoryAdjustment.SubmitChanges(dtModifiedData);

                btnSubmit.Visible = false;
                btnAddItem.Visible = false;
                gvPhysicalInv.Visible = false;
                pager.Visible = false;
                pnlEntry.Update();
                pnlGrid.Update();

                lblMsg.Visible = true;
                lblMsg.ForeColor = System.Drawing.Color.Green;
                lblMsg.Text = "Changes submitted successfully.";
            }
            catch (Exception ex)
            {
                lblMsg.Visible = true;
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Process Failed:" + ex.Message;
            }
        }
        else
        {
            lblMsg.Visible = true;
            lblMsg.ForeColor = System.Drawing.Color.Red;
            lblMsg.Text = "No new changes found.";
        }
    }

    protected void btnGetItemDetail_Click(object sender, EventArgs e)
    {
        DataTable dtItem = physicalInventoryAdjustment.GetItemInformation(txtCategory.Text + "-" + txtSize.Text + "-" + txtPlating.Text);

        if (dtItem != null)
        {
            lblDesc.Text = dtItem.Rows[0]["ItemDesc"].ToString();
            lblPack.Text = dtItem.Rows[0]["ItemUOM"].ToString();
            lblBeforeQty.Text = "0";
            ScriptManager1.SetFocus(txtNewQty);
        }
        else
        {
            lblMsg.ForeColor = System.Drawing.Color.Red;
            lblMsg.Text = "Invalid item number.";
        }
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        DataSet _dsInvData = Session["InvAdjustData"] as DataSet;
        string _binLoc = ddlLocation.SelectedValue.ToString() + "STK" + ddlLocation.SelectedValue.ToString();
        string _itemNo = txtCategory.Text.Trim() + "-" + txtSize.Text.Trim() + "-" + txtPlating.Text.Trim();

        DataRow[] dr = _dsInvData.Tables[0].Select("ItemNo='" + _itemNo + "' and BinLoc='" + _binLoc + "'");
        if (dr.Length > 0)
        {
            ScriptManager.RegisterClientScriptBlock(btnSave, btnSave.GetType(), "validate", "alert('Item already exist.');", true);
        }
        else
        {
            // Add the item to temp session variable
            DataRow _drNew = _dsInvData.Tables[0].NewRow();
            _drNew["Location"] = ddlLocation.SelectedValue.ToString();
            _drNew["BinLoc"] = _binLoc;
            _drNew["ItemNo"] = _itemNo;
            _drNew["Category"] = txtCategory.Text.Trim();
            _drNew["Size"] = txtSize.Text.Trim();
            _drNew["PackPlate"] = txtPlating.Text.Trim();
            _drNew["ItemDesc"] = lblDesc.Text;
            _drNew["BeforeQty"] = "0";
            _drNew["Pack"] = lblPack.Text;
            _drNew["DispAfterQty"] = txtNewQty.Text;
            _drNew["PackTypeId"] = _itemNo.Substring(11, 2);
            _drNew["Plating"] = _itemNo.Substring(13, 1);
            _drNew["NewRec"] = "1";
            _dsInvData.Tables[0].Rows.Add(_drNew);

            _dsInvData.Tables[0].DefaultView.Sort = "PackTypeId,Plating,Category,ItemNo";
            DataTable tempTbl = _dsInvData.Tables[0].DefaultView.ToTable();
            _dsInvData.Tables.Clear();
            _dsInvData.Tables.Add(tempTbl);
            Session["InvAdjustData"] = _dsInvData;
            BindDataGrid();

            // Cleare Controls
            ClearDataEntryFields();
            lblHeaderMsg.ForeColor = System.Drawing.Color.Green;
            lblHeaderMsg.Text = "Item added successfully.";
            ScriptManager1.SetFocus(txtCategory);
        }
    }

    protected void btnGetItem_Click(object sender, ImageClickEventArgs e)
    {
        ClearDataEntryFields();
        Session["InvAdjustData"] = null;

        tblDataEntry.Visible = false;
        BindDataGrid();
        pnlEntry.Update();

        btnAddItem.Visible = true;
        btnSubmit.Visible = true;

        divdatagrid.Attributes.Add("style", "height: 500px;overflow-y: auto;");
        pnlGrid.Update();
    }

    protected void btnAddItem_Click(object sender, ImageClickEventArgs e)
    {
        ClearDataEntryFields();
        tblDataEntry.Visible = true;
        pnlEntry.Update();

        divdatagrid.Attributes.Add("style", "height: 400px;overflow-y: auto;");
        pnlGrid.Update();
    }

    protected void btnCloseAddPanel_Click(object sender, ImageClickEventArgs e)
    {
        ClearDataEntryFields();

        divdatagrid.Attributes.Add("style", "height: 500px;overflow-y: auto;");
        pnlGrid.Update();

        tblDataEntry.Visible = false;
        pnlEntry.Update();
    }

    private void BindDataGrid()
    {
        if (Session["InvAdjustData"] == null)
        {
            DataSet _dsInventoryData = physicalInventoryAdjustment.GetInventoryData(ddlLocation.SelectedValue.ToString());
            Session["InvAdjustData"] = _dsInventoryData;
            hidSort.Value = "";
        }

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

    private void ClearDataEntryFields()
    {
        txtCategory.Text = "";
        txtSize.Text = "";
        txtPlating.Text = "";
        txtNewQty.Text = "";
        lblDesc.Text = "";
        lblPack.Text = "";
        lblBeforeQty.Text = "";
        
        lblHeaderMsg.Text = "";
        lblMsg.Text = "";
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

        headerContent = "<table border='" + border + "' width='100%'>";
        headerContent += "<tr><th colspan='16' style='color:blue' align=left><center>Quote Metrics Report</center></th></tr>";
        headerContent += "<tr><td colspan='3'><b>Beginning Date :" + StartDate + "</b></td><td  colspan='3'><b>Ending Date:" + EndDate + "</b></td><td colspan='10'></td></tr>";
        headerContent += "<tr><td  colspan='3'> <b>Branch:" + BranchDesc + "</b></td>" +
                            "<td  colspan='3'><b>Sales Person: " + SalesPerson + "</b></td>" +
                            "<td colspan='5'><b>Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;  Run Date: " + DateTime.Now.ToShortDateString() + "</></td></tr>";
        headerContent += "<tr><th colspan='16' style='color:blue' align=left></th></tr>";

        if (dtExcelData.Rows.Count > 0)
        {
            dv.AutoGenerateColumns = false;
            dv.ShowHeader = true;
            dv.ShowFooter = true;
            dv.RowDataBound += new GridViewRowEventHandler(dv_RowDataBound);

            BoundField bfExcel = new BoundField();
            bfExcel.HeaderText = "ItemNo";
            bfExcel.DataField = "PFCItemNo";
            bfExcel.DataFormatString = "{0:MM/dd/yy}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Sales Loc";
            bfExcel.DataField = "SalesLocationCode";
            bfExcel.DataFormatString = "{0:00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Customer Name";
            bfExcel.DataField = "CustomerName";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "RequestQuantity";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "AvailableQuantity";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Quote Date";
            bfExcel.DataField = "QuotationDate";
            bfExcel.DataFormatString = "{0:MM/dd/yy}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "InitialRequestQty";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "InitialAvailableQty";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "InitialLocationCode";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "Name";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "OELoc";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Quote $";
            bfExcel.DataField = "Quote";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Ordered $";
            bfExcel.DataField = "MadeOrd";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "LineCnt";
            bfExcel.DataFormatString = "{0:#,##0.0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "AvlShort";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "MadeOrder";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
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
            excelContent = "<tr  ><th width='100%' align ='center' colspan='18' > No records found</th></tr> </table>";
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
}

