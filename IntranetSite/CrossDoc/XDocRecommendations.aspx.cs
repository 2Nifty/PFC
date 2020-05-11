using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Globalization;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet.DataAccessLayer;

public partial class XDocRecommendations : System.Web.UI.Page
{
    #region Variable declaration
    DataTable dtItemDetails;
    DataTable dt;
    ContainerXDockData XDockData = new ContainerXDockData();

    string totalRequired = string.Empty;
    string sumROP = string.Empty;
    string sumAvl = string.Empty;
    string sumRTSB = string.Empty;
    string sumIntransit = string.Empty;
    string sumRequired = string.Empty;
    string sumSupEqv = string.Empty;
    string sumAllocated = string.Empty;
    string sumRecommended = string.Empty;
    string sumCommited = string.Empty;
    string sumMOH = string.Empty;
    string QtyFilter = string.Empty;

    string holdLocation = "90";
    string detailTable = "GERRTSDtl";

    int unUsedQty = 0;
    int nonePPQty = 0;
    int total = 0;
    
    bool focusStatus;
    int currentIndex = 0;
    TextBox txtDefault;
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        Ajax.Utility.RegisterTypeForAjax(typeof(XDocRecommendations));

        lblMessage.Text = "";
        if (!IsPostBack)
        {
            // Get the container data
            lblContainer.Text = Request.QueryString["Container"].ToString();
            Session["ContXDockGridData"] = null;
            BindItemNo();
        }

        if (Session["CPRFactor"] != null)
            CPRFactor.Text = Session["CPRFactor"].ToString();

        pnlProgress.Update();
    }

    // Bind the Item DropDown
    public void BindItemNo()
    {
        try
        {
            // get the data.
            dt = CheckError(XDockData.GetContainerItems(lblContainer.Text, Session["UserName"].ToString()));
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlItemNo.DataSource = dt;
                ddlItemNo.DataTextField = "ItemNo";
                ddlItemNo.DataValueField = "ItemNo";
                ddlItemNo.DataBind();
                ddlItemNo.SelectedIndex = 0;

                dt.Columns.Add("Id");
                for (int i = 0; i < dt.Rows.Count; i++)
                    dt.Rows[i]["Id"] = (i + 1).ToString();
                dt.AcceptChanges();

                ddlPages.DataSource = dt;
                ddlPages.DataTextField = "Id";
                ddlPages.DataValueField = "ItemNo";
                ddlPages.DataBind();

                ddlPages.SelectedIndex = ddlItemNo.SelectedIndex;
                lblLandingLoc.Text = dt.Rows[0]["Location"].ToString();

                BindPageDetails();
            }
        }
        catch (Exception ex)
        {
            lblMessage.Text = "BindItemNo fail" + ex.ToString();
        }
    }

    // Fill the details for the selected item
    protected void ddlItemNo_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            //hidBranch.Value = "";
            //hidVendor.Value = "";
            ddlPages.SelectedValue = ddlItemNo.SelectedItem.Text.Trim();

            BindPageDetails();

            pnlProgress.Update();
            ScriptManager.RegisterClientScriptBlock(ddlPages, typeof(ListBox), "", "AdjustHeight();", true);
        }
        catch (Exception ex)
        {
            lblMessage.Text = "ddlItemNo_SelectedIndexChanged fail" + ex.ToString();
        }
    }

    #region Button Events
    protected void btnAccept_Click(object sender, ImageClickEventArgs e)
    {
        string mess1 = "";
        try
        {
            dt = (DataTable)Session["ContXDockGridData"];
            int RecsAdded = 0;
            foreach (DataRow drow in dt.Rows)
            {
                if (((int)drow["CommitQty"] > 0) && (drow["LocationCode"].ToString().Trim().Length == 2))
                {
                    DataTable dtAdded = CheckError(XDockData.AddXDockRecs(
                        lblContainer.Text.ToString()
                        , drow["LocationCode"].ToString()
                        , lblLandingLoc.Text.ToString()
                        , ddlItemNo.SelectedItem.ToString()
                        , drow["CommitQty"].ToString()
                        , Session["UserName"].ToString()
                        , ddlItemNo.SelectedValue.ToString()
                        ));
                    RecsAdded += 1;
                }
            }
            btnAccept.Visible = false;
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = RecsAdded.ToString() + " lines committed.";
            //lblMessage.Text = RecsAdded.ToString() + " lines committed." + ddlItemNo.SelectedValue.ToString();
        }
        catch (Exception ex)
        {
            lblMessage.Text = "btnAccept_Click fail" + ex.ToString();
        }
    }

    #endregion

    #region Developer Methods
    // Method to bind the Branch Item Details Grid (dgItemDtl)
    public void BindItemDetails()
    {
        try
        {
            totalRequired = "";
            dtItemDetails = CheckError(XDockData.GetItem(lblContainer.Text, ddlItemNo.SelectedValue));
            pnlItemDetails.Update();
            if (dtItemDetails != null && dtItemDetails.Rows.Count > 0)
            {

                try
                {
                    totalRequired = String.Format("{0:#,##0}", dtItemDetails.Compute("sum(Need)", ""));
                    sumROP = String.Format("{0:#,##0.0}", dtItemDetails.Compute("sum(ROPHubCalc)", ""));
                    sumAvl = dtItemDetails.Compute("sum(AvailQty)", "").ToString();
                    sumRTSB = dtItemDetails.Compute("sum(RTSBQty)", "").ToString();
                    sumIntransit = dtItemDetails.Compute("sum(InTransit)", "").ToString();
                    sumAllocated = dtItemDetails.Compute("sum(Allocated)", "").ToString();
                    sumCommited = dtItemDetails.Compute("sum(CommitQty)", "").ToString();
                    sumMOH = String.Format("{0:#,##0.0}", dtItemDetails.Compute("sum(Avail_Mos)", ""));
                    //sumSupEqv = dtItemDetails.Compute("sum(SupEqQty)", "").ToString();
                    //sumSupEqv = string.Format("{0:0.0}", dtItemDetails.Compute("Sum(SupEqQty) / ((Sum(ROPHubCalc) / Sum(ROPDays)) * 30)", ""));
                }
                catch (Exception ex) 
                {
                    lblMessage.Text = "sum fail" + ex.ToString();
                }

                DataTable dtShipDetails = (DataTable)dtItemDetails.Copy();
                DataTable dtBrGroup = CheckError(XDockData.GetItemRegions(lblContainer.Text, ddlItemNo.SelectedValue));
                DataTable dtGroup = dtShipDetails.Copy();
                dtGroup.Rows.Clear();

                foreach (DataRow drow in dtBrGroup.Rows)
                {
                    dtShipDetails.DefaultView.RowFilter = "LocIMRegion = '" + drow[0].ToString().Trim() + "'";
                    if (dtShipDetails.DefaultView.ToTable().Rows.Count > 0)
                    {
                        dtGroup.Merge(dtShipDetails.DefaultView.ToTable());
                        DataRow drGroup = dtGroup.NewRow();
                        drGroup["LocationCode"] = drow[0].ToString().Trim();
                        drGroup["ROPHubCalc"] = dtShipDetails.Compute("Sum(ROPHubCalc)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        drGroup["AvailQty"] = dtShipDetails.Compute("Sum(AvailQty)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        drGroup["RTSBQty"] = dtShipDetails.Compute("Sum(RTSBQty)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        drGroup["InTransit"] = dtShipDetails.Compute("Sum(InTransit)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        drGroup["Allocated"] = dtShipDetails.Compute("Sum(Allocated)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        drGroup["Need"] = dtShipDetails.Compute("Sum(Need)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        //drGroup["SupEqQty"] = dtShipDetails.Compute("Sum(SupEqQty)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        //drGroup["SupEqQty"] = dtShipDetails.Compute("Sum(SupEqQty) / ((Sum(ROPHubCalc) / Sum(ROPDays)) * 30)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        drGroup["CommitQty"] = dtShipDetails.Compute("Sum(CommitQty)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        drGroup["Avail_Mos"] = dtShipDetails.Compute("Sum(Avail_Mos)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        drGroup["ItemNo"] = "Sum";
                        dtGroup.Rows.Add(drGroup);
                    }
                }

                lblBrMsg.Visible = false;
                dgItemDtl.Visible = true;
                dgItemDtl.DataSource = dtGroup;
                dgItemDtl.DataBind();
                dgItemDtl.Focus();
                pnlShipDetails.Update();
                Session["ContXDockGridData"] = dtGroup;
                btnAccept.Visible = true;
                pnlCommit.Update();
            }
            else
            {
                dgItemDtl.Visible = false;
                lblBrMsg.Visible = true;
                lblBrMsg.ForeColor = System.Drawing.Color.FromName("#CC0000");
            }
        }
        catch (Exception ex)
        {
            lblMessage.Text = "BindItemDetails fail" + ex.ToString();
        }
    }

    // Method to bind the Vendor Item Details
    public void GetItemDetails()
    {
        //hidBranch.Value = "";
        //hidVendor.Value = "";
        //hidPO.Value = "";

        // Method to bind the Branch Item Details Grid (dgItemDtl)
        BindItemDetails();

        // Check for other Cross Docks for the same item
        // OnItemDataBound="OtherItemDataBound"
        //                                                                OnSortCommand="dgOtherSortCommand" AllowSorting="True"
        dt = CheckError(XDockData.GetOtherXDock(ddlItemNo.SelectedItem.ToString(), lblContainer.Text.ToString()));
        dgOther.DataSource = dt;
        dgOther.DataBind();
        if (dt != null && dt.Rows.Count > 0)
        {
            lblOtherMsg.Visible = false;
        }
        else
        {
            lblOtherMsg.Visible = true;
        }

        if (dtItemDetails != null && dtItemDetails.Rows.Count > 0)
        {
            lblDescription.Text = dtItemDetails.Rows[0]["ItemDesc"].ToString().Trim();
            lblUOM.Text = dtItemDetails.Rows[0]["SellStkUM"].ToString().Trim();
            lblQtyPer.Text = string.Format("{0:#,##0}", ((dtItemDetails.Rows[0]["SellStkUMQty"].ToString().Trim() != null && dtItemDetails.Rows[0]["SellStkUMQty"].ToString().Trim() != "") ? dtItemDetails.Rows[0]["SellStkUMQty"] : "0"));
            lblLbs.Text = string.Format("{0:#,##0.0}", ((dtItemDetails.Rows[0]["Wght"].ToString().Trim() != null && dtItemDetails.Rows[0]["Wght"].ToString().Trim() != "") ? dtItemDetails.Rows[0]["Wght"] : "0"));
            lblSuperEqu.Text = string.Format("{0:#,##0}", dtItemDetails.Rows[0]["SuperEquivQty"]);
            lblLowProfileQty.Text = string.Format("{0:#,##0}", dtItemDetails.Rows[0]["LowProfilePalletQty"]);
            lblPCS.Text = string.Format("{0:###,##0}", dtItemDetails.Rows[0]["SuperPieces"]);
            lblTotLbs.Text = string.Format("{0:###,##0.0}", dtItemDetails.Rows[0]["SuperLbs"]);
            lbl100Wgt.Text = string.Format("{0:###,##0.0}", dtItemDetails.Rows[0]["Wght100"]);
            lblHarmCode.Text = dtItemDetails.Rows[0]["Tariff"].ToString().Trim();
            lblVelocity.Text = dtItemDetails.Rows[0]["CorpFixedVelocity"].ToString().Trim();
            lblContItemQty.Text = string.Format("{0:###,##0}", dtItemDetails.Rows[0]["LPNQty"]);
            lblCommittedQty.Text = sumCommited;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "DoRefreshCommitted", "RefreshCommitted();", true);

        }
        else
            Clear();
        pnlVendorItemDetails.Update();
    }

    // Method to clear the labels
    public void Clear()
    {
        lblDescription.Text = "";
        lblUOM.Text = "";
        lblQtyPer.Text = "";
        lblLbs.Text = "";
        lblSuperEqu.Text = "";
        lblPCS.Text = "";
        lblTotLbs.Text = "";
        lbl100Wgt.Text = "";
        lblHarmCode.Text = "";
        lblVelocity.Text = "";
        lblLowProfileQty.Text = "";
    }

    public void SetGridStyle(DataGrid dgGrid)
    {
        for (int i = 0; i < dgGrid.Items.Count; i++)
            if (dgGrid.ID.Trim() == "dgItemDtl")
            {
                HiddenField hidItemNo = dgItemDtl.Items[i].FindControl("hidItemNo") as HiddenField;
                if (hidItemNo.Value.Trim() != "Sum")
                    dgGrid.Items[i].CssClass = ((i % 2 != 0) ? "zebra" : "gridItem");
                else
                    for (int count = 0; count < dgGrid.Items[i].Cells.Count; count++)
                        dgGrid.Items[i].Cells[count].ForeColor = System.Drawing.Color.FromName("#CC0000"); ;
            }
            else
                dgGrid.Items[i].CssClass = ((i % 2 != 0) ? "zebra" : "gridItem");
    }

    #endregion

    #region Branch Item Details Grid (dgItemDtl)
    protected void dgItemDtl_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            HiddenField hidItemNo = e.Item.FindControl("hidItemNo") as HiddenField;
            TextBox txtCommit = e.Item.FindControl("txtCommit") as TextBox;
            Label lblCommit = e.Item.FindControl("lblCommit") as Label;
            Label LineLoc = e.Item.FindControl("LocID") as Label;
            if (hidItemNo.Value.Trim() == "Sum")
            {
                txtCommit.Style.Add("display", "none");
                lblCommit.Style.Add("display", "");
                e.Item.CssClass = "BluBg itemTotal ";
                for (int count = 0; count < e.Item.Cells.Count; count++)
                    e.Item.Cells[count].ForeColor = System.Drawing.Color.FromName("#CC0000"); ;
            }
            else
            {
                e.Item.Cells[5].BackColor = System.Drawing.Color.LightGreen;
                e.Item.Cells[8].BackColor = System.Drawing.Color.Yellow;
                txtCommit.Style.Add("display", "");
                lblCommit.Style.Add("display", "none");
                if(LineLoc.Text.ToString().Trim() == lblLandingLoc.Text.ToString().Trim())
                    txtCommit.Style.Add("display", "none");

                return;
            }
        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            Label lblItmNo = e.Item.FindControl("lblItmNo") as Label;
            lblItmNo.Text = ddlItemNo.SelectedItem.Text;
            e.Item.Cells[0].ColumnSpan = 2;
            e.Item.Cells[1].Visible = false;
            e.Item.Cells[2].Text = "<span style='color:#003366;'>" + sumROP + "</span>";
            e.Item.Cells[4].Text = "<span style='color:#003366;'>" + sumAvl + "</span>";
            e.Item.Cells[5].Text = "<span style='color:#003366;'>" + sumRTSB + "</span>";
            e.Item.Cells[6].Text = "<span style='color:#003366;'>" + sumMOH + "</span>";
            e.Item.Cells[7].Text = "<span style='color:#003366;'>" + sumIntransit + "</span>";
            e.Item.Cells[8].Text = "<span style='color:#003366;'>" + sumAllocated + "</span>";
            e.Item.Cells[9].Text = "<span style='color:#003366;'>" + totalRequired + "</span>";
            e.Item.Cells[10].Text = "<span style='color:#003366;'>" + sumSupEqv + "</span>";
            e.Item.Cells[11].Text = "<span style='color:#003366;' ID='CommitTot'>" + sumCommited + "</span>";
        }
    }

    #endregion

    #region Vendor Shipment Details Grid (dgVendor)
    protected void dgVendor_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            Label lblVendor = e.Item.FindControl("lblVendor") as Label;
            LinkButton lnkVendor = e.Item.FindControl("lnkVendor") as LinkButton;
            lblVendor.Visible = false;
            if (e.Item.Cells[5].Text.Trim() == "0")
            {
                lblVendor.Visible = true;
                lnkVendor.Visible = false;
            }
        }
    }
    
    #endregion

    #region Pager Functionality
    protected void ibtnFirst_Click(object sender, ImageClickEventArgs e)
    {
        ddlPages.SelectedIndex = 0;
        ddlItemNo.SelectedIndex = ddlPages.SelectedIndex;
        BindPageDetails();
    }

    protected void ibtnPrevious_Click(object sender, ImageClickEventArgs e)
    {
        if (ddlPages.SelectedIndex == 0)
        { }
        else
        {
            ddlPages.SelectedIndex = ddlPages.SelectedIndex - 1;
            ddlItemNo.SelectedIndex = ddlPages.SelectedIndex;
            BindPageDetails();
        }
    }

    protected void btnNext_Click(object sender, ImageClickEventArgs e)
    {
        if (ddlPages.SelectedIndex == ddlPages.Items.Count - 1)
        { }
        else
        {
            ddlPages.SelectedIndex = ddlPages.SelectedIndex + 1;
            ddlItemNo.SelectedIndex = ddlPages.SelectedIndex;
            BindPageDetails();
        }
    }

    protected void btnLast_Click(object sender, ImageClickEventArgs e)
    {
        ddlPages.SelectedIndex = ddlPages.Items.Count - 1;
        ddlItemNo.SelectedIndex = ddlPages.SelectedIndex;
        BindPageDetails();
    }

    protected void btnGo_Click(object sender, ImageClickEventArgs e)
    {
        if (Convert.ToInt32(txtGotoPage.Text.Trim()) >= 1 && Convert.ToInt32(txtGotoPage.Text.Trim()) <= ddlPages.Items.Count)
        {
            ddlPages.SelectedIndex = Convert.ToInt32(txtGotoPage.Text.Trim()) - 1;
            ddlItemNo.SelectedIndex = ddlPages.SelectedIndex;
            BindPageDetails();
        }
        else
        {
            lblMessage.ForeColor = System.Drawing.Color.FromName("#CC0000");
            lblMessage.Text = "Invalid Page #";
            pnlProgress.Update();
        }

        ScriptManager.RegisterClientScriptBlock(btnGo, typeof(Button), "", "AdjustHeight();", true);
    }

    protected void ddlPages_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddlItemNo.SelectedIndex = ddlPages.SelectedIndex;
        BindPageDetails();
        ScriptManager.RegisterClientScriptBlock(ddlPages, typeof(ListBox), "", "AdjustHeight();", true);
    }

    public void BindPageDetails()
    {
        lblCurrentPageRecCount.Text = " " + (ddlPages.SelectedIndex + 1).ToString();
        lblTotalNoOfRec.Text = " " + ddlPages.Items.Count.ToString();
        lblCurrentPage.Text = " " + (ddlPages.SelectedIndex + 1).ToString();
        lblTotalPage.Text = " " + ddlPages.Items.Count.ToString();
        lblCurrentTotalRec.Text = " " + (ddlPages.SelectedIndex + 1).ToString();
        pnlPager.Update();

        GetItemDetails();
    }
    #endregion

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdCommitQty(string Loc, string NewQty, string ItemQty)
    {
        string status = Loc;
        try
        {
            int qty = 0;
            int _ItemQty = int.Parse(ItemQty, NumberStyles.Number);
            // update the table in the session variable to show that the line is selected or not.
            DataTable tempDt = (DataTable)Session["ContXDockGridData"];
            int _SumCommited = int.Parse(tempDt.Compute("sum(CommitQty)", "LocationCode<>'" + Loc.Trim() + "'").ToString(), NumberStyles.Number);
            DataRow[] LPNRow =
               tempDt.Select("LocationCode = '" + Loc + "'");
            status += " was " + LPNRow[0]["CommitQty"].ToString();
            if (int.TryParse(NewQty, out qty))
            {
                if (qty < 0)
                {
                    status = "Negative Qtys not allowed";
                }
                else if (_SumCommited + qty > _ItemQty)
                {
                    status = "Over-Commit is not allowed.";
                }
                else
                {
                    LPNRow[0]["CommitQty"] = qty;
                    status = "OK";
                }
            }
            else
            {
                status = "Invalid Commit Qty Entered";
            }
            Session["ContXDockGridDate"] = tempDt;
        }
        catch (Exception ex)
        {
            status = "UpdCommitQty fail" + ex.ToString();
        }
        return status;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string SumCommitQty()
    {
        string status = "0";
        DataTable tempDt = (DataTable)Session["ContXDockGridData"];
        status = String.Format("{0:#,##0}", tempDt.Compute("Sum(CommitQty)", "len(LocationCode)=2"));
        return status;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string ReleaseSoftLock(string Container)
    {
        string status = "0";
        try
        {
            DataTable tempDt = XDockData.ReleaseContainer(Container, Session["UserName"].ToString());
            status = "Released";
        }
        catch (Exception ex)
        {
            status = "ReleaseSoftLock fail" + ex.ToString();
        }
        return status;
    }

    public DataTable CheckError(DataTable NewData)
    {
        if ((NewData != null) && (NewData.Columns.Contains("ErrorType")))
        {
            lblMessage.Text = NewData.Rows[0]["ErrorText"].ToString();
            pnlProgress.Update();
            return null;
        }
        else
        {
            return NewData;
        }
    }
}
