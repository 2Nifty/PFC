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

using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;

public partial class CompetitorPriceMaint : System.Web.UI.Page
{
    MaintenanceUtility utility ;
    DataTable dtTablesData = new DataTable();
    string PageMode = "";
    string CompListCd = "";
    string CompItemId = "";
    string custNo = "";
    string updateMessage = "Data has been successfully updated";
    string deleteMessage = "Data has been successfully deleted";
    string connectionString = Global.PFCERPConnectionString;
    string PFCItemNo = "";

    #region Page Load Methods

    protected string PriceSecurity
    {
        get
        {
            return "true";            
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(CompetitorPriceMaint));
        utility = new MaintenanceUtility();        
        ViewState["Operation"] = "";
        lblMessage.Text = "";
        lnkCode.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");        
        PageMode = Request.QueryString["PageMode"].ToString().Trim().ToLower(); 
        custNo = Request.QueryString["CustNo"].ToString().Trim();
        CompListCd = (Request.QueryString["CompListCd"] != null ? Request.QueryString["CompListCd"].ToString().Trim() : "");
        CompItemId = (Request.QueryString["CompItemId"] != null ? Request.QueryString["CompItemId"].ToString().Trim() : "");
        PFCItemNo = (Request.QueryString["ItemNo"] != null ? Request.QueryString["ItemNo"].ToString().Trim() : "");

        if (!Page.IsPostBack)
        {
            //Session["CommentSecurity"] = null;
            //Session["CommentSecurity"] = utility.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.OrganisationComments);
            Pager1.Visible = false;
            BindCompetitorDropdown();            
            ViewState["Mode"] = "Add";

            // Change display based on page mode
            if (PageMode == "itemhistory")
            {
                lblGridHeading.Text = "Competitor Price History";
                btnAdd.Visible = false;
                tblPriceMaintHeader.Visible = false;
                btnSearch.Visible = false;
                ddlCompName.Enabled = false;
                divdatagrid.Attributes.Add("style", "height: 540px; overflow-x: auto; overflow-y: auto; position: relative; top: 0px; left: 0px; width: 1015px; border: 0px solid;");
            }
            else if (PageMode == "pircemode" && CompItemId != "" )
            {
                if (CompItemId != "0")
                {
                    hidpCompetitorItemsID.Value = CompItemId;
                    dtTablesData = GetCompetitorTablesData("getgriditems", hidRegionId.Value, ddlCompName.SelectedValue, "", CompItemId);
                    DisplayRecord();
                }
                tblGrid.Visible = false;
                dgCompPrice.Visible = false;
                btnSearch.Visible = false;
                ddlCompName.Enabled = false;
                btnAdd.Visible = false;
                btnCancel.Visible = false;
                UpdatePanels();
            }
            else if (PageMode == "competitormode")
            {
                tblPriceMaint.Visible = true;
                tblDataEntry.Visible = true;
                btnAdd.Visible = false;
            }
        }
    }

    #endregion

    #region Search Header Methods

    protected void btnSearch_Click(object sender, ImageClickEventArgs e)
    {
        if (ddlCompName.SelectedIndex != 0)
        {
            ClearControls();
            GetSearch();
        }
        else
        {
            tblDataEntry.Visible = false;
            btnAdd.Visible = false;
            DisplaStatusMessage("Select valid competitor name.", "fail");
        }

        UpdatePanels();
    }

    protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
        btnSave.Visible = (PriceSecurity != "") ? true : false;
        btnCancel.Visible = (PriceSecurity != "") ? true : false;
        BindDataGrid();
        ClearControls();
        ViewState["Mode"] = "Add";        
        tblDataEntry.Visible = true;
        btnAdd.Visible = true;
        MyScript.SetFocus(txtPFCItemNo);        
        UpdatePanels();        
    }

    private void BindCompetitorDropdown()
    {
        DataTable dtCompName = GetCompetitorTablesData("getcompetitors", "", "", "", "");
        Session["CompetitorMaster"] = dtCompName;

        if (dtCompName != null && dtCompName.Rows.Count > 0)
        {
            ddlCompName.DataSource = dtCompName;
            ddlCompName.DataTextField = "CompDesc";
            ddlCompName.DataValueField = "CompetitorListCd";
            ddlCompName.DataBind();
            ddlCompName.Items.Insert(0, new ListItem("------ Select Competitor ------", ""));

            if (ddlCompName.Items.Count > 0 && PageMode != "competitormode")
            {
                ddlCompName.SelectedValue = CompListCd;

                GetSearch();
            }
        }
        else
            ddlCompName.Items.Insert(0, new ListItem("------ Select Competitor ------", ""));


    }

    private void GetSearch()
    {
        ViewState["Mode"] = "Add";
        DataTable dtCompMaster = Session["CompetitorMaster"] as DataTable;
        DataRow[] drCompMaster = dtCompMaster.Select("CompetitorListCd='" + ddlCompName.SelectedItem.Value.ToString() + "'");
        hidRegionId.Value = drCompMaster[0]["RegionLocID"].ToString();
        hidCompName.Value = drCompMaster[0]["CompetitorName"].ToString();
        BindDataGrid();
        btnAdd.Visible = true;
        tblPriceMaint.Visible = true;
        tblDataEntry.Visible = true;
        UpdatePanels();
    }

    #endregion

    #region Data Entry Methods

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {


        if (txtPFCItemNo.Text == "" ||
            txtCompPrice.Text == "")
        {
            ScriptManager.RegisterClientScriptBlock(btnSave, btnSave.GetType(), "required", "alert(' *  Marked fields are mandatory')", true);
        }
        else
        {
            try
            {
                if (ViewState["Mode"].ToString() == "Add")
                {
                    UpdateCompItemTable("Add");
                    DisplaStatusMessage(updateMessage, "Success");
                }
                else
                {
                    if (hidPreviousPrice.Value != txtCompPrice.Text)
                    {
                        UpdateCompItemTable("UpdatePrice");
                    }
                    else
                    {
                        UpdateCompItemTable("UpdateProductInfo");
                    }

                    DisplaStatusMessage(updateMessage, "Success");
                }


                if (PageMode == "pircemode")
                {
                    if (hidPreviousPrice.Value != txtCompPrice.Text)
                    {
                        ScriptManager.RegisterClientScriptBlock(btnSave, btnSave.GetType(), "refreshParent", "RefreshPricingWorkSheet();", true);
                    }
                    UpdatePanels();
                    return;
                }

                tblDataEntry.Visible = true;
                btnAdd.Visible = true;
                btnSave.Visible = false;
                btnCancel.Visible = false;

                ClearControls();
                BindDataGrid();

            }
            catch (Exception ex)
            {
                DisplaStatusMessage(ex.Message, "Fail");
            }
            UpdatePanels();
        }

    }

    protected void btnCancel_Click1(object sender, ImageClickEventArgs e)
    {
        btnSave.Visible = true;
        UpdatePanels();
        ClearControls();
        ViewState["Mode"] = "Add";
    }

    protected void btnGetItem_Click(object sender, EventArgs e)
    {
        DataTable dtItem = GetCompetitorTablesData("getitem", "", "", txtPFCItemNo.Text, "");

        if (dtItem.Rows.Count > 0)
        {
            lblPFCSellUM.Text = dtItem.Rows[0]["SellUM"].ToString();
            MyScript.SetFocus(txtPFCCustNo);
            upnlEntry.Update();
        }
        else
        {
            lblPFCSellUM.Text = "";
            DisplaStatusMessage("Item " + txtPFCItemNo.Text + " not on file", "fail");
            pnlProgress.Update();
        }
    }

    protected void ClearControls()
    {
        try
        {
            lblPFCSellUM.Text = txtCompItemNo.Text = txtCompItemDesc.Text = txtPFCCustNo.Text = "";
            txtPcsCount.Text = txtCompPrice.Text = txtCompPriceUM.Text = txtCompPricePerLb.Text = "";
            dpCompPriceDt.SelectedDate = "";
            txtPFCItemNo.Text = txtWghtPerUM.Text = "";
            rdoStockYes.Checked = true;
            lblChangeID.Text = lblChangeDate.Text = lblEntryID.Text = lblEntryDate.Text = "";
            upnlEntry.Update();
        }
        catch (Exception ex) { }
    }

    #endregion

    #region Data Grid Methods

    private void BindDataGrid()
     {
         if (PageMode != "pircemode")
         {
             string dbSourcetype = (PageMode != "itemhistory" ? "getgriditems" : "getitemhistory");
             DataTable dtCompItems = GetCompetitorTablesData(dbSourcetype, hidRegionId.Value, ddlCompName.SelectedItem.Value, PFCItemNo, "");

             if (dtCompItems != null)
             {
                 if (PageMode == "itemhistory")
                     dgCompPrice.Columns[0].Visible = false;

                 dtCompItems.DefaultView.Sort = (hidSort.Value == "") ? "" : hidSort.Value;
                 dgCompPrice.DataSource = dtCompItems.DefaultView.ToTable();
                 Pager1.InitPager(dgCompPrice, 50);
                 Pager1.Visible = true;
                 //dgCompPrice.DataBind();
                 upnlGrid.Update();
                 if (dtCompItems.Rows.Count == 0)
                 {
                     DisplaStatusMessage("No Records Found", "Fail");
                 }
             }
             else
                 DisplaStatusMessage("No Records Found", "Fail");
         }

     }

    protected void dgCompPrice_ItemDataBound(object sender, DataGridItemEventArgs e)
     {
         if ((e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
             && PageMode == "itemhistory")
         {
             //LinkButton lnkDelete = e.Item.FindControl("lnlDelete") as LinkButton;
             //LinkButton lnkEdit = e.Item.FindControl("lnlEdit") as LinkButton;

             //lnkDelete.Visible = false;
             //lnkEdit.Visible = false;

         }
     }

    protected void dgCompPrice_ItemCommand(object source, DataGridCommandEventArgs e)
     {
         if (e.CommandName == "Edit")
         {
             hidpCompetitorItemsID.Value = e.CommandArgument.ToString();
             dtTablesData = GetCompetitorTablesData("getgriditems", hidRegionId.Value, ddlCompName.SelectedValue, "", e.CommandArgument.ToString());
             DisplayRecord();
         }
         if (e.CommandName == "Delete")
         {
             ViewState["Operation"] = "Delete";
             DeleteTablesData(e.CommandArgument.ToString());
             BindDataGrid();
             DisplaStatusMessage(deleteMessage, "Success");
             ClearControls();
             ViewState["Mode"] = "Add";
         }

         UpdatePanels();
     }

    protected void dgCompPrice_SortCommand(object source, DataGridSortCommandEventArgs e)
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

        hidPrimaryKey.Value = dtTablesData.Rows[0]["pCompetitorItemsID"].ToString().Trim();
        hidRegionId.Value = dtTablesData.Rows[0]["RegionLocID"].ToString().Trim();
        txtPFCItemNo.Text = dtTablesData.Rows[0]["PFCItemNo"].ToString().Trim();
        lblPFCSellUM.Text = dtTablesData.Rows[0]["PFCSellUM"].ToString().Trim();
        txtCompItemNo.Text = dtTablesData.Rows[0]["CompetitorItemNo"].ToString().Trim();
        txtCompItemDesc.Text = dtTablesData.Rows[0]["CompetitorItemDesc"].ToString().Trim();
        txtPFCCustNo.Text = dtTablesData.Rows[0]["PFCCustNo"].ToString().Trim();
        txtCompPrice.Text = dtTablesData.Rows[0]["CompetitorPrice"].ToString().Trim();
        hidPreviousPrice.Value = txtCompPrice.Text;
        txtCompPriceUM.Text = dtTablesData.Rows[0]["CompetitorPriceUM"].ToString().Trim();
        dpCompPriceDt.SelectedDate = dtTablesData.Rows[0]["CompetitorPriceDate"].ToString().Trim();
        txtCompPricePerLb.Text = dtTablesData.Rows[0]["CompetitorPricePer100Lbs"].ToString().Trim();
        txtPcsCount.Text = dtTablesData.Rows[0]["CompetitorPcsCount"].ToString().Trim();
        txtWghtPerUM.Text = dtTablesData.Rows[0]["CompetitorWghtPerUM"].ToString().Trim();

        if (dtTablesData.Rows[0]["CompetitorStockInd"].ToString().Trim().ToUpper() == "Y")
        {
            rdoStockYes.Checked = true;
            rdoStockNo.Checked = false;
        }
        else
        {
            rdoStockYes.Checked = false;
            rdoStockNo.Checked = true;
        }

        lblEntryID.Text = dtTablesData.Rows[0]["EntryID"].ToString().Trim();
        lblEntryDate.Text = (dtTablesData.Rows[0]["EntryDt"].ToString() != "" ? Convert.ToDateTime(dtTablesData.Rows[0]["EntryDt"].ToString()).ToShortDateString() : "");
        lblChangeID.Text = dtTablesData.Rows[0]["ChangeID"].ToString().Trim();
        lblChangeDate.Text = (dtTablesData.Rows[0]["ChangeDt"].ToString() != "" ? Convert.ToDateTime(dtTablesData.Rows[0]["ChangeDt"].ToString()).ToShortDateString() : "");

        btnSave.Visible = (PriceSecurity != "") ? true : false;
        btnCancel.Visible = (PriceSecurity != "") ? true : false;
        btnAdd.Visible = (PriceSecurity != "") ? true : false;

    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgCompPrice.CurrentPageIndex = Pager1.GotoPageNumber;

        BindDataGrid();
    }

    #endregion
    
    #region Database & Utility Methods

    public DataTable GetCompetitorTablesData(string source, string regionCd, string compCd, string pfcItemNo,string pCompItemId)
    {
        try
        {
            DataSet dsCompetitor = new DataSet();
            dsCompetitor = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOECompetitorPriceFrm]",
                                                new SqlParameter("@source", source),
                                                new SqlParameter("@custNo", custNo),
                                                new SqlParameter("@regionCd", regionCd),
                                                new SqlParameter("@compCd", compCd),
                                                new SqlParameter("@pfcItemNo", pfcItemNo),
                                                new SqlParameter("@pCompItemId", pCompItemId));
            return dsCompetitor.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }
        
    public void UpdateCompItemTable(string mode)
    {
        try
        {
            SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "[pSOECompetitorPriceUpdate]",
                                 new SqlParameter("@mode", mode),
                                 new SqlParameter("@pCompItemsID", hidpCompetitorItemsID.Value),
                                 new SqlParameter("@regionLocID", hidRegionId.Value),
                                 new SqlParameter("@competitorListCd", ddlCompName.SelectedItem.Value),
                                 new SqlParameter("@competitorName", hidCompName.Value.Trim()),
                                 new SqlParameter("@pfcItemNo", txtPFCItemNo.Text.Trim()),
                                 new SqlParameter("@pfcSellUM", lblPFCSellUM.Text.Trim()),
                                 new SqlParameter("@competitorItemNo", txtCompItemNo.Text.Trim()),
                                 new SqlParameter("@competitorItemDesc", txtCompItemDesc.Text.Trim()),
                                 new SqlParameter("@pfcCustNo", txtPFCCustNo.Text.Trim()),
                                 new SqlParameter("@competitorPrice", txtCompPrice.Text.Trim()),
                                 new SqlParameter("@competitorPriceUM", txtCompPriceUM.Text.Trim()),
                                 new SqlParameter("@competitorPriceDate", (dpCompPriceDt.SelectedDate != "" ? dpCompPriceDt.SelectedDate : "1/1/1900")),
                                 new SqlParameter("@competitorPricePer100Lbs", (txtCompPricePerLb.Text.Trim() != "" ? txtCompPricePerLb.Text.Trim() : "0.0")),
                                 new SqlParameter("@competitorPcsCount", (txtPcsCount.Text.Trim() != "" ? txtPcsCount.Text.Trim() : "0")),
                                 new SqlParameter("@competitorWghtPerUM", (txtWghtPerUM.Text.Trim() != "" ? txtWghtPerUM.Text.Trim() : "0.0")),
                                 new SqlParameter("@competitorStockInd", (rdoStockYes.Checked == true ? "Y" : "N")),
                                 new SqlParameter("@entryID", Session["UserName"]));
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    public void DeleteTablesData(string primaryKey)
    {
        try
        {
            string whereClause = "pCompetitorItemsID ='" + primaryKey + "'";
            SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "pSOEDelete",
                                        new SqlParameter("@tableName", "[CompetitorItems]"),
                                        new SqlParameter("@whereClause", whereClause));
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    private void UpdatePanels()
    {
        pnlPriceMaint.Update();
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
    #endregion


}



