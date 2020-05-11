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
using System.Data.SqlClient;
using System.IO;

using PFC.Intranet;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet.MaintenanceApps;

public partial class PriceCostMaint : System.Web.UI.Page
{
    MaintenanceUtility SecurityUtil = new MaintenanceUtility();    
    ddlBind objDDLBind = new ddlBind();    
    DataSet dsTablesData = new DataSet();
    GridView dvExcelExport = new GridView();

    string excelFilePath = "../Common/ExcelUploads/";   
    string updateMessage = "Data has been successfully updated";
    string deleteMessage = "Data has been successfully deleted";
    string ERPConnectionString = Global.PFCERPConnectionString;
    bool enableLocDDL = false;

    #region Page Load Methods

    protected string PriceSecurity
    {
        get
        {
            return ViewState["PriceCostSecurity"].ToString();            
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(PriceCostMaint));
        ViewState["Operation"] = "";
        lblMessage.Text = "";        

        if (!Page.IsPostBack)
        {
            hidFileName.Value = "PriceCostReport_" + Session["UserName"].ToString() + ".xls";

            #region Set Security

            ViewState["PriceCostSecurity"] = SecurityUtil.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.PriceCostOverlayAccess);

            if (ViewState["PriceCostSecurity"].ToString() != "")
                ViewState["PriceCostSecurity"] = "Full";
           
            #endregion

            BindDropdowns();
            ViewState["GridViewMode"] = "getgridlines";
            //btnSearch_Click(this.Page, new ImageClickEventArgs(0, 0));
        }

        if (ViewState["PriceCostSecurity"].ToString() == "")
        {
            btnAdd.Visible = false;
            btnSave.Visible = false;
            btnCancel.Visible = false;
        }
    }
    
    private void BindDropdowns()
    {
        DataSet dsLocations = GetPriceCostTablesData("getlocations", "", "", "", "", "");
        ddlLocation.DataSource = dsLocations.Tables[0];
        ddlLocation.DataTextField = "LocName";
        ddlLocation.DataValueField = "LocID";
        ddlLocation.DataBind();        
        ddlLocation.SelectedValue = Session["BranchID"].ToString();

        ddlSearchLocation.DataSource = dsLocations.Tables[0];
        ddlSearchLocation.DataTextField = "LocName";
        ddlSearchLocation.DataValueField = "LocID";
        ddlSearchLocation.DataBind();
        ddlSearchLocation.Items.Insert(0, new ListItem("ALL", ""));
        //ddlSearchLocation.SelectedValue = Session["BranchID"].ToString();
        //ddlLocation.Enabled = enableLocDDL;
    }

    #endregion

    #region Search Header Methods

    protected void btnSearch_Click(object sender, ImageClickEventArgs e)
    {
        ViewState["GridViewMode"] = "getgridlines";
        ClearControls();        
        GetSearch();       
        UpdatePanels();        
    }

    protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
        btnSave.Visible = (PriceSecurity != "") ? true : false;
        btnCancel.Visible = (PriceSecurity != "") ? true : false;
        ViewState["GridViewMode"] = "addItemgetgridlines";
        BindDataGrid();
        ClearControls();        
        ViewState["Mode"] = "Add";
        
        tblDataEntry.Visible = true;
        btnAdd.Visible = true;
        scmPriceCost.SetFocus(txtPFCItemNo);        
        UpdatePanels();        
    }

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        string _excelData = GenerateExportData();

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
       
    private void GetSearch()
    {
        ViewState["Mode"] = "Add";                  
        BindDataGrid();
        //btnAdd.Visible = true;
        tblVendorMaint.Visible = true;
        tblDataEntry.Visible = true;
        UpdatePanels();
    }

    private string GenerateExportData()
    {
        DataTable dtExcelData = Session["PriceCostExcelData"] as DataTable;

        string styleSheet = "<style>.text { mso-number-format:\\@; } </style>";
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;       

        headerContent = "<table border='1' width='100%'>";
        headerContent += "<tr><th colspan='12' style='color:blue' align=left><center>Price Cost Overlay Data</center></th></tr>";        
        headerContent += "<tr><td  colspan='7'></td>" +
                         "<td colspan='5'><b>Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;  Run Date: " + DateTime.Now.ToShortDateString() + "</></td></tr>";
        headerContent += "<tr><th colspan='12' style='color:blue' align=left></th></tr>";

        if (dtExcelData.Rows.Count > 0)
        {
            dvExcelExport.AutoGenerateColumns = false;
            dvExcelExport.ShowHeader = true;
            dvExcelExport.ShowFooter = true;
            //dvExcelExport.RowDataBound += new GridViewRowEventHandler(dv_RowDataBound);

            BoundField bfExcel = new BoundField();
            bfExcel.HeaderText = "Item #";
            bfExcel.DataField = "ItemNo";            
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dvExcelExport.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Location";
            bfExcel.DataField = "Branch";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dvExcelExport.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Overlay Base PriCost";
            bfExcel.DataField = "OverlayPriceCost";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dvExcelExport.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Overlay Base Alt. PriCost";
            bfExcel.DataField = "OverlayPriceCostAlt";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dvExcelExport.Columns.Add(bfExcel);           

            bfExcel = new BoundField();
            bfExcel.HeaderText = "IB Smooth Avg Cost";
            bfExcel.DataField = "SmoothAvgCost";            
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dvExcelExport.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "IB RplCost";
            bfExcel.DataField = "RplCost";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dvExcelExport.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "IB AvgCost";
            bfExcel.DataField = "AvgCost";            
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dvExcelExport.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "IB PriceCost";
            bfExcel.DataField = "IBPriceCostAlt";            
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dvExcelExport.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Entry ID";
            bfExcel.DataField = "EntryID";            
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dvExcelExport.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Entry Dt";
            bfExcel.DataField = "EntryDt";            
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dvExcelExport.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Change ID";
            bfExcel.DataField = "ChangeID";            
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dvExcelExport.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "ChangeDt";
            bfExcel.HeaderText = "Change Dt";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;            
            dvExcelExport.Columns.Add(bfExcel);

            dvExcelExport.DataSource = dtExcelData;
            dvExcelExport.DataBind();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            System.IO.StringWriter sw = new System.IO.StringWriter(sb);
            HtmlTextWriter htw = new HtmlTextWriter(sw);
            dvExcelExport.RenderControl(htw);
            excelContent = sb.ToString();

        }
        else
        {
            excelContent = "<tr><th width='100%' align ='center' colspan='18' > No records found</th></tr> </table>";
        }

        return styleSheet + headerContent + excelContent;
    }

    #endregion

    #region Data Entry Methods

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            #region Data Validations
            
            if (txtPFCItemNo.Text == "" ||
                txtAltPriceCost.Text == "")
            {
                ScriptManager.RegisterClientScriptBlock(btnSave, btnSave.GetType(), "required", "alert(' *  Marked fields are mandatory')", true);
                return;
            }
            
            #endregion
                        
            if (ViewState["Mode"].ToString() == "Add")
            {
                DataSet dsResult = GetPriceCostTablesData("insertpricecost"
                                        , txtPFCItemNo.Text
                                        , ddlLocation.SelectedValue
                                        , hidBasePriceCost.Value
                                        , txtAltPriceCost.Text
                                        , "");

                if (dsResult != null &&
                    dsResult.Tables[0].Rows[0]["ErrorMsg"].ToString() != "")
                {
                    DisplaStatusMessage(dsResult.Tables[0].Rows[0]["ErrorMsg"].ToString(), "fail");
                    scmPriceCost.SetFocus(txtPFCItemNo);
                    pnlProgress.Update();
                    return;
                }
                else
                {
                    DisplaStatusMessage(updateMessage, "Success");
                }
            }
            else
            {
                GetPriceCostTablesData("updatepricecost"
                                        , txtPFCItemNo.Text
                                        , ddlLocation.SelectedValue
                                        , hidBasePriceCost.Value
                                        , txtAltPriceCost.Text
                                        , hidPrimaryKey.Value);

                DisplaStatusMessage(updateMessage, "Success");
            }

            tblDataEntry.Visible = true;
            btnAdd.Visible = true;
            btnSave.Visible = false;
            btnCancel.Visible = false;
            scmPriceCost.SetFocus(txtPFCItemNo);
            
            ClearControls();
            BindDataGrid();

        }
        catch (Exception ex)
        {
            DisplaStatusMessage(ex.Message, "Fail");
        }

        UpdatePanels();       

    }

    protected void btnCancel_Click1(object sender, ImageClickEventArgs e)
    {
        BindDataGrid();
        btnSave.Visible = true;
        UpdatePanels();
        ClearControls();
        ViewState["Mode"] = "Add";
        scmPriceCost.SetFocus(txtPFCItemNo);
    }

    protected void btnGetItem_Click(object sender, EventArgs e)
    {
        string _pfcItemNo = (hidPageMode.Value == "VendorPriceMode" ? txtSearchItemNo.Text.Trim() : txtPFCItemNo.Text);

        dsTablesData = GetPriceCostTablesData("getitem", _pfcItemNo, ddlLocation.SelectedValue, "", "", "");

        if (dsTablesData != null && dsTablesData.Tables[0].Rows.Count > 0)
        {
            lblSellUM.Text = dsTablesData.Tables[0].Rows[0]["SellUM"].ToString();            
            lblPFCItemDesc.Text = dsTablesData.Tables[0].Rows[0]["ItemDesc"].ToString();
            lblSellStock.Text = dsTablesData.Tables[0].Rows[0]["SellStkUMQty"].ToString() + " / " + dsTablesData.Tables[0].Rows[0]["SellStkUM"].ToString();
            txtAltPriceCost.Text = dsTablesData.Tables[0].Rows[0]["PriceCostAlt"].ToString();
            lblBasePriceCost.Text = dsTablesData.Tables[0].Rows[0]["PriceCost"].ToString() + " / " + dsTablesData.Tables[0].Rows[0]["SellStkUM"].ToString();
            hidBasePriceCost.Value = dsTablesData.Tables[0].Rows[0]["PriceCost"].ToString();
            hidSellStockUM.Value = dsTablesData.Tables[0].Rows[0]["SellStkUM"].ToString();

            lblSmoothAvg.Text = dsTablesData.Tables[0].Rows[0]["SmoothAvgCost"].ToString() + " / " + lblSellUM.Text;
            lblAvgCost.Text = dsTablesData.Tables[0].Rows[0]["AvgCost"].ToString() + " / " + lblSellUM.Text;
            lblRplCost.Text = dsTablesData.Tables[0].Rows[0]["RplCost"].ToString() + " / " + lblSellUM.Text;
            lblPriceCost.Text = dsTablesData.Tables[0].Rows[0]["PriceCostAlt"].ToString() + " / " + lblSellUM.Text;

            scmPriceCost.SetFocus(txtAltPriceCost);

            btnSave.Visible = (PriceSecurity != "") ? true : false;
            btnCancel.Visible = (PriceSecurity != "") ? true : false;            
            ViewState["Mode"] = "Add";
            upnlButtons.Update();            
        }
        else
        {
            lblPFCItemDesc.Text = lblSellUM.Text = "";
            lblSellStock.Text = lblBasePriceCost.Text = lblSmoothAvg.Text = lblAvgCost.Text = "";
            lblRplCost.Text = lblPriceCost.Text = "";

            DisplaStatusMessage("Item " + txtPFCItemNo.Text + " not on file", "fail");
            scmPriceCost.SetFocus(txtPFCItemNo);
            pnlProgress.Update();
        }
    }

    protected void ClearControls()
    {
        try
        {
            txtPFCItemNo.Text = lblSellUM.Text = lblSellStock.Text = lblBasePriceCost.Text =  lblPFCItemDesc.Text = "";
            txtAltPriceCost.Text = lblSmoothAvg.Text = lblRplCost.Text = "";
            lblAvgCost.Text = lblPriceCost.Text = "";
            lblChangeId.Text = lblChangeDt.Text = lblEntryId.Text = lblEntryDt.Text = "";
            upnlEntry.Update();
        }
        catch (Exception ex) { }
    }

    #endregion

    #region Data Grid Methods

    private void BindDataGrid()
    {
        DataSet dsVendItems = new DataSet();         
        string pfcItemNo = txtSearchItemNo.Text;

        if (txtCategory.Text.Trim() != "" ||
            txtSize.Text.Trim() != "" ||
            txtVar.Text.Trim() != "")
        {
            pfcItemNo = "Category-Size-Var";
            pfcItemNo = (txtCategory.Text.Trim() != "" ? pfcItemNo.Replace("Category", txtCategory.Text) : pfcItemNo.Replace("Category", "%%%%%"));
            pfcItemNo = (txtSize.Text.Trim() != "" ? pfcItemNo.Replace("Size", txtSize.Text) : pfcItemNo.Replace("Size", "%%%%"));
            pfcItemNo = (txtVar.Text.Trim() != "" ? pfcItemNo.Replace("Var", txtVar.Text) : pfcItemNo.Replace("Var", "%%%"));
        }

        if (txtSearchItemNo.Text.Trim() != "")
            pfcItemNo = txtSearchItemNo.Text;

        dsVendItems = GetPriceCostTablesData(ViewState["GridViewMode"].ToString(), pfcItemNo, ddlSearchLocation.SelectedValue, "", "", "");
    

        if (dsVendItems != null && dsVendItems.Tables.Count > 1)
        {
            dsVendItems.Tables[0].DefaultView.Sort = (hidSort.Value == "") ? "" : hidSort.Value;
            Session["PriceCostExcelData"] = dsVendItems.Tables[0].DefaultView.ToTable();
            dgPriceCost.DataSource = dsVendItems.Tables[0].DefaultView.ToTable();
            Pager1.InitPager(dgPriceCost, 13);
            Pager1.Visible = true;
            if (dsVendItems.Tables[0].Rows.Count == 0)
            {
                DisplaStatusMessage("No Records Found", "Fail");
            }
        }
        else
        {
            DisplaStatusMessage("No Records Found", "Fail");

            dgPriceCost.DataSource = null;
            dgPriceCost.DataBind();
        }

        upnlGrid.Update();
        //ScriptManager.RegisterClientScriptBlock(dgVendorPrice, dgVendorPrice.GetType(), "setMenu", "RestoreControlPosition();", true);
     }

    protected void dgPriceCost_ItemDataBound(object sender, DataGridItemEventArgs e)
     {
         if (e.Item.ItemType == ListItemType.Header)
         {
             e.Item.Cells[3].ColumnSpan = 2;
             e.Item.Cells[3].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'>" +
                                        "<tr>" +
                                            "<td style='border: 0px solid;height:15px;' colspan=2 nowrap ><center>Overlay</center></td>" +
                                        "</tr>" +
                                        "<tr>" +
                                            "<td width='85' class=' splitBorders' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;height:15px;border-left:solid 0px #c9c6c6;'><center><Div style='cursor:hand;' onclick=\"javascript:BindValue('OverlayPriceCost');\">Base PriCost</div></center></td>" +
                                            "<td width='75' class=' splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;height:15px;'><Div onclick=\"javascript:BindValue('OverlayPriceCostAlt');\">Alt. PriCost</div></td>" +
                                        "</tr>" +
                                    "</table>";

             e.Item.Cells[4].Visible = false;

             e.Item.Cells[5].ColumnSpan = 4;             
             e.Item.Cells[5].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'>" + 
                                        "<tr>" +
                                            "<td style='border: 0px solid;height:15px;' colspan=4 ><center>Item Branch</center></td>" + 
                                        "</tr>" +
                                        "<tr>" +
                                            "<td width='65' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;border-left:solid 0px #c9c6c6;height:15px;'><center><Div style='cursor:hand;' onclick=\"javascript:BindValue('SmoothAvgCost');\">Smth Avg</div></center></td>" +
                                            "<td width='66' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;height:15px;'><center><Div style='cursor:hand;' onclick=\"javascript:BindValue('RplCost');\">Rpl Cost</div></center></td>" +
                                            "<td width='68' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;height:15px;'><center><Div onclick=\"javascript:BindValue('AvgCost');\">Avg Cost</div></center></td>" +
                                            "<td width='68' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;height:15px;'><center><Div onclick=\"javascript:BindValue('IBPriceCostAlt');\">Price Cost</div></center></td>" + 
                                        "</tr>" +
                                    "</table>";

             e.Item.Cells[6].Visible = false;
             e.Item.Cells[7].Visible = false;
             e.Item.Cells[8].Visible = false;
         }
         else if ((e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item))
         {
             
             if (ViewState["PriceCostSecurity"].ToString().Trim() == "")
             {
                 LinkButton lnkDelete = e.Item.FindControl("lnlDelete") as LinkButton;
                 LinkButton lnkEdit = e.Item.FindControl("lnlEdit") as LinkButton;
                 TextBox _txtAltPriceCost = e.Item.FindControl("txtAltPriceCost") as TextBox;

                 lnkDelete.Visible = false;
                 lnkEdit.Visible = false;
                 _txtAltPriceCost.ReadOnly = true;
             }


             
         }
     }

    protected void dgPriceCost_ItemCommand(object source, DataGridCommandEventArgs e)
     {
         if (e.CommandName == "Edit")
         {
             hidpVedorItemsID.Value = e.CommandArgument.ToString();
             dsTablesData = GetPriceCostTablesData("getlineitem", "", "", "", "", e.CommandArgument.ToString());
             
             if (dsTablesData.Tables[0].Rows.Count > 0)             
                 DisplayRecord();             
             else
                DisplaStatusMessage("No Records Found", "Fail");

            // We need to bind the grid to avoid losing grid header style
            BindDataGrid();
         }
         if (e.CommandName == "Delete")
         {
             ViewState["Operation"] = "Delete";
             GetPriceCostTablesData("deleteitem", "", "", "", "", e.CommandArgument.ToString());
             BindDataGrid();
             DisplaStatusMessage(deleteMessage, "Success");
             ClearControls();
             ViewState["Mode"] = "Add";
         }
         //upnlGrid.Update();
         //ScriptManager.RegisterClientScriptBlock(dgVendorPrice, dgVendorPrice.GetType(), "setMenu", "RestoreControlPosition();", true);
         UpdatePanels();
     }

    protected void dgPriceCost_SortCommand(object source, DataGridSortCommandEventArgs e)
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

    private void DisplayRecord()
    {
        ViewState["Mode"] = "Edit";

        hidPrimaryKey.Value = dsTablesData.Tables[0].Rows[0]["pCostCalcPriceCostOverlayID"].ToString().Trim();

        txtPFCItemNo.Text = dsTablesData.Tables[0].Rows[0]["ItemNo"].ToString();
        lblPFCItemDesc.Text = dsTablesData.Tables[0].Rows[0]["ItemDesc"].ToString();

        lblSellUM.Text = dsTablesData.Tables[0].Rows[0]["SellUM"].ToString();
        lblPFCItemDesc.Text = dsTablesData.Tables[0].Rows[0]["ItemDesc"].ToString();
        lblSellStock.Text = dsTablesData.Tables[0].Rows[0]["SellStkUMQty"].ToString() + " / " + dsTablesData.Tables[0].Rows[0]["SellStkUM"].ToString();
        txtAltPriceCost.Text = dsTablesData.Tables[0].Rows[0]["OverlayPriceCostAlt"].ToString();
        lblBasePriceCost.Text = dsTablesData.Tables[0].Rows[0]["OverlayPriceCost"].ToString() + " / " + dsTablesData.Tables[0].Rows[0]["SellStkUM"].ToString();
        hidBasePriceCost.Value = dsTablesData.Tables[0].Rows[0]["OverlayPriceCost"].ToString();
        hidSellStockUM.Value = dsTablesData.Tables[0].Rows[0]["SellStkUM"].ToString();

        lblSmoothAvg.Text = dsTablesData.Tables[0].Rows[0]["SmoothAvgCost"].ToString() + " / " + lblSellUM.Text;
        lblAvgCost.Text = dsTablesData.Tables[0].Rows[0]["AvgCost"].ToString() + " / " + lblSellUM.Text;
        lblRplCost.Text = dsTablesData.Tables[0].Rows[0]["RplCost"].ToString() + " / " + lblSellUM.Text;
        lblPriceCost.Text = dsTablesData.Tables[0].Rows[0]["IBPriceCostAlt"].ToString() + " / " + lblSellUM.Text;

        scmPriceCost.SetFocus(txtAltPriceCost);

        lblEntryId.Text = dsTablesData.Tables[0].Rows[0]["EntryID"].ToString().Trim();
        lblEntryDt.Text = (dsTablesData.Tables[0].Rows[0]["EntryDt"].ToString() != "" ? Convert.ToDateTime(dsTablesData.Tables[0].Rows[0]["EntryDt"].ToString()).ToShortDateString() : "");
        lblChangeId.Text = dsTablesData.Tables[0].Rows[0]["ChangeID"].ToString().Trim();
        lblChangeDt.Text = (dsTablesData.Tables[0].Rows[0]["ChangeDt"].ToString() != "" ? Convert.ToDateTime(dsTablesData.Tables[0].Rows[0]["ChangeDt"].ToString()).ToShortDateString() : "");
        
        btnSave.Visible = (PriceSecurity != "") ? true : false;
        btnCancel.Visible = (PriceSecurity != "") ? true : false;        
        btnAdd.Visible = (PriceSecurity != "") ? true : false;

    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgPriceCost.CurrentPageIndex = Pager1.GotoPageNumber;

        BindDataGrid();
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

    #endregion

    #region Database & Utility Methods
    
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void DeleteExcel()
    {
        try
        {
            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..//Common//ExcelUploads//"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains("_" + Session["UserName"].ToString()))
                    fn.Delete();
            }
        }
        catch (Exception ex) { }
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string CalculateBasePriceCost(string pfcItemNo, string priceCostAlt)
    {
        DataSet dsVendorFiles = GetPriceCostTablesData("GetBasePriceCost", pfcItemNo, "", "", priceCostAlt, "");

        if(dsVendorFiles != null && dsVendorFiles.Tables[0].Rows.Count >0)
            //return String.Format("{0:0.00}",dsVendorFiles.Tables[0].Rows[0]["BasePriceCost"]);
            return dsVendorFiles.Tables[0].Rows[0]["BasePriceCost"].ToString();

        return "";
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string[] UpdateGridAltPrice(string pfcItemNo, string priceCostAlt, string _pPriceCostId)
    {
        string[] arrResult = new string[10];
        try
        {           
            arrResult[0] = "";
            DataSet dsCostPrice = GetPriceCostTablesData("updategridline", pfcItemNo, "", "", priceCostAlt, _pPriceCostId);

            if (dsCostPrice != null)
            {
                arrResult[0] = dsCostPrice.Tables[0].Rows[0]["BasePriceCost"].ToString();
                arrResult[1] = dsCostPrice.Tables[0].Rows[0]["ChangeId"].ToString();
                arrResult[2] = dsCostPrice.Tables[0].Rows[0]["ChangeDt"].ToString();
                return arrResult;
            }

            return arrResult;
        }
        catch (Exception ex)
        {
            return arrResult;
        }

    }

    private void UpdatePanels()
    {
        pnlVendorMaint.Update();
        upnlbtnSearch.Update();
        upnlEntry.Update();
        upnlGrid.Update();
        pnlProgress.Update();
        upnlButtons.Update();
    }

    private void DisplaStatusMessage(string message, string messageType)
    {
        lblMessage.Visible = true;
        if (messageType.ToLower() == "success")
        {
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = message;
        }
        else if (messageType.ToLower() == "fail")
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = message;
        }
    }

    public DataSet GetPriceCostTablesData(string source, string pfcItemNo, string locId, string priceCost, string priceCostAlt, string pPriceCostId)
    {
        try
        {
            DataSet dsVendorPrice = new DataSet();
            dsVendorPrice = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pPriceCostMaintFrm]",
                                                new SqlParameter("@source", source),                                                
                                                new SqlParameter("@pfcItemNo", pfcItemNo),                                                                                                
                                                new SqlParameter("@location", locId),
                                                new SqlParameter("@priceCost", priceCost),
                                                new SqlParameter("@priceCostAlt", priceCostAlt),                                                                                              
                                                new SqlParameter("@entryId", Session["UserName"].ToString()),
                                                new SqlParameter("@pPriceCostOverlayID", pPriceCostId));
            return dsVendorPrice;
        }
        catch (Exception ex)
        {
            return null;
        }
    }


    #endregion
   
}



