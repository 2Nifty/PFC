using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.Securitylayer;

public partial class RTSRecommendations : System.Web.UI.Page
{
    #region Variable declaration
    ReadyToShipUtility detRTS = new ReadyToShipUtility();
    RTSPriorityCode updtPriority = new RTSPriorityCode();

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
        Ajax.Utility.RegisterTypeForAjax(typeof(RTSRecommendations));


        if (!IsPostBack)
        {
            hidSortVendor.Value = "PO# ASC";
            hidSortVendor.Attributes.Add("sortType", "ASC");
            BindItemNo();
            BindSummary();
            ClearActionPanel();
            pnlAction.Update();
        }
        else
        {
            lblMessage.Text = "";
        }
        if (Session["CPRFactor"] != null)
            CPRFactor.Text = Session["CPRFactor"].ToString();

        pnlProgress.Update();
    }

    #region Select Item
    // Bind the Item DropDown
    public void BindItemNo()
    {
        try
        {
            string tableName = "GERRTS";
            string columnName = "DISTINCT ItemNo as Item";
            string whereClause = "ItemNo <> '' and StatusCd = '00' ORDER BY ItemNo ASC";
            DataSet dsItem = detRTS.GetDetails(tableName, columnName, whereClause);

            if (dsItem != null && dsItem.Tables[0].Rows.Count > 0)
            {
                ddlItemNo.DataSource = dsItem.Tables[0];
                ddlItemNo.DataTextField = "Item";
                ddlItemNo.DataValueField = "Item";
                ddlItemNo.DataBind();
                ddlItemNo.SelectedIndex = 0;
                DataTable dtITem = dsItem.Tables[0];
                dtITem.Columns.Add("Id");

                for (int i = 0; i < dtITem.Rows.Count; i++)
                    dtITem.Rows[i]["Id"] = (i + 1).ToString();
                dtITem.AcceptChanges();

                ddlPages.DataSource = dtITem;
                ddlPages.DataTextField = "Id";
                ddlPages.DataValueField = "Item";
                ddlPages.DataBind();

                ddlPages.SelectedIndex = ddlItemNo.SelectedIndex;

                BindPageDetails();
            }
        }
        catch (Exception ex) { }
    }

    // Fill the details for the selected item
    protected void ddlItemNo_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            hidBranch.Value = "";
            hidVendor.Value = "";
            ddlPages.SelectedValue = ddlItemNo.SelectedValue.Trim();

            BindPageDetails();

            pnlProgress.Update();
            ScriptManager.RegisterClientScriptBlock(ddlPages, typeof(ListBox), "", "AdjustHeight();", true);
        }
        catch (Exception ex) { }
    }
    #endregion

    #region Bind the data to the display
    public void BindPageDetails()
    {
        lblCurrentPageRecCount.Text = " " + (ddlPages.SelectedIndex + 1).ToString();
        lblTotalNoOfRec.Text = " " + ddlPages.Items.Count.ToString();
        lblCurrentPage.Text = " " + (ddlPages.SelectedIndex + 1).ToString();
        lblTotalPage.Text = " " + ddlPages.Items.Count.ToString();
        lblCurrentTotalRec.Text = " " + (ddlPages.SelectedIndex + 1).ToString();
        pnlPager.Update();

        // Bind the Vendor Item Details
        GetItemDetails();

        // Bind the Vendor Shipment Details Grid (dgVendor)
        BindVendorPODetails();

        // Bind the Item Shipment Totals
        BindSummary();

        // Bind the Branch Item Details Grid (dgItemDtl)
        BindItemDetails();

        pnlShipDetails.Update();
        pnlItemDetails.Update();
        pnlVendorItemDetails.Update();

        ClearActionPanel();
        pnlAction.Update();
    }

    // Bind the Vendor Item Details
    public void GetItemDetails()
    {
        hidBranch.Value = "";
        hidVendor.Value = "";
        hidPO.Value = "";

        DataSet dsItemDetails = detRTS.GetVendorItemDetails(ddlItemNo.SelectedValue.Trim());
        if (dsItemDetails != null && dsItemDetails.Tables[0].Rows.Count > 0)
        {
            lblDescription.Text = dsItemDetails.Tables[0].Rows[0]["Description"].ToString().Trim();
            lblUOM.Text = dsItemDetails.Tables[0].Rows[0]["UOM"].ToString().Trim();
            lblQtyPer.Text = string.Format("{0:#,##0}", ((dsItemDetails.Tables[0].Rows[0]["Qty Per"].ToString().Trim() != null && dsItemDetails.Tables[0].Rows[0]["Qty Per"].ToString().Trim() != "") ? dsItemDetails.Tables[0].Rows[0]["Qty Per"] : "0"));
            lbl_Lbs.Text = string.Format("{0:#,##0.0}", ((dsItemDetails.Tables[0].Rows[0]["Lbs"].ToString().Trim() != null && dsItemDetails.Tables[0].Rows[0]["Lbs"].ToString().Trim() != "") ? dsItemDetails.Tables[0].Rows[0]["Lbs"] : "0"));
            lblSuperEqu.CssClass = "";
            lblSuperEqu.Text = dsItemDetails.Tables[0].Rows[0]["Super Equiv."].ToString().Trim();
            if (int.Parse(dsItemDetails.Tables[0].Rows[0]["SupEqvQty"].ToString()) != 36)
            {
                lblSuperEqu.CssClass = "SpecialSuper";
            }
            lblLowProfileQty.Text = string.Format("{0:#,##0}", dsItemDetails.Tables[0].Rows[0]["LowPalletQty"]);
            lblPCS.Text = string.Format("{0:#,##0}", ((dsItemDetails.Tables[0].Rows[0]["Pcs"].ToString().Trim() != null && dsItemDetails.Tables[0].Rows[0]["Pcs"].ToString().Trim() != "") ? dsItemDetails.Tables[0].Rows[0]["Pcs"] : "0"));
            lblTotLbs.Text = string.Format("{0:#,##0.0}", ((dsItemDetails.Tables[0].Rows[0]["Tot_Lbs"].ToString().Trim() != null && dsItemDetails.Tables[0].Rows[0]["Tot_Lbs"].ToString().Trim() != "") ? dsItemDetails.Tables[0].Rows[0]["Tot_Lbs"] : "0"));
            lblWgt.Text = dsItemDetails.Tables[0].Rows[0]["Wgt/100"].ToString().Trim();
            lblHarmCode.Text = dsItemDetails.Tables[0].Rows[0]["HarmCode"].ToString().Trim();
            lblVelocity.Text = dsItemDetails.Tables[0].Rows[0]["Fixed Velocity"].ToString().Trim();
        }
        else
            Clear();
    }

    // Bind the Vendor Shipment Details Grid (dgVendor)
    public void BindVendorPODetails()
    {
        try
        {
            string whereClause = "ItemNo = '" + ddlItemNo.SelectedValue.Trim() + "'";

            // added by Slater for vendor data filtering
            QtyFilter = " ";

            if (POQtyShowDone.Checked)
                QtyFilter = " and QtyRemaining = 0";

            if (POQtyShowRem.Checked)
                QtyFilter = " and QtyRemaining <> 0";

            whereClause += QtyFilter;

            DataSet dsVendor = detRTS.GetVendorPODetails(whereClause);
            //DataTable dtVendor = ((dsVendor != null && dsVendor.Tables[0].Rows.Count > 0) ? (DataTable)dsVendor.Tables[0] : null);
            DataTable dtVendor = dsVendor.Tables[0];
            if (dtVendor != null && dtVendor.Rows.Count > 0)
            {
                dtVendor.DefaultView.Sort = hidSortVendor.Value.Trim();
                dgVendor.DataSource = dtVendor.DefaultView.ToTable();
                dgVendor.DataBind();
                lblVendormsg.Visible = false;
                dgVendor.Visible = true;
            }
            else
            {
                dgVendor.Visible = false;
                lblVendormsg.Visible = true;
                lblVendormsg.ForeColor = System.Drawing.Color.FromName("#CC0000");
            }
        }
        catch (Exception ex) { }
    }

    // Bind the Item Shipment Totals
    public void BindSummary()
    {
        try
        {
            DataSet dsSummary = detRTS.GetVendorItemSummary(ddlItemNo.SelectedItem.Text);
            string totalPOLine = "0";
            string totalQty = "0";
            string totalPP = "0";
            string totalNonPP = "0";
            string totalOther = "0";

            if (dsSummary != null && dsSummary.Tables[0].Rows.Count > 0)
            {
                totalPOLine = (dsSummary.Tables[0].Compute("COUNT(PoNo)", "").ToString() != "") ? dsSummary.Tables[0].Compute("COUNT(PoNo)", "").ToString() : "0";
                totalQty = (dsSummary.Tables[0].Compute("SUM(qty)", "GERRTSStatCd <> 'OtherPO'").ToString() != "") ? dsSummary.Tables[0].Compute("SUM(qty)", "GERRTSStatCd <> 'OtherPO'").ToString() : "0";
                totalPP = (dsSummary.Tables[0].Compute("SUM(qty)", "GERRTSStatCd = 'PP'").ToString() != "") ? dsSummary.Tables[0].Compute("SUM(qty)", "GERRTSStatCd = 'PP'").ToString() : "0";
                totalNonPP = (dsSummary.Tables[0].Compute("SUM(qty)", "GERRTSStatCd <> 'PP' and GERRTSStatCd <> 'OtherPO'").ToString() != "") ? dsSummary.Tables[0].Compute("SUM(qty)", "GERRTSStatCd <> 'PP' and GERRTSStatCd <> 'OtherPO'").ToString() : "0";
                totalOther = (dsSummary.Tables[0].Compute("SUM(qty)", "GERRTSStatCd = 'OtherPO'").ToString() != "") ? dsSummary.Tables[0].Compute("SUM(qty)", "GERRTSStatCd = 'OtherPO'").ToString() : "0";
            }

            lblTotlaPo.Text = string.Format("{0:#,##0}", Convert.ToDecimal(totalPOLine));
            lblTotQty.Text = string.Format("{0:#,##0}", Convert.ToDecimal(totalQty));
            lblPallet.Text = string.Format("{0:#,##0}", Convert.ToDecimal(totalPP));
            lblNonPallet.Text = string.Format("{0:#,##0}", Convert.ToDecimal(totalNonPP));
            lblOther.Text = string.Format("{0:#,##0}", Convert.ToDecimal(totalOther));
        }
        catch (Exception ex) { }
    }

    // Bind the Branch Item Details Grid (dgItemDtl)
    public void BindItemDetails()
    {
        try
        {
            totalRequired = "";
            DataSet dsItemDetails = detRTS.GERReadyToShipItemDetails(ddlItemNo.SelectedValue.Trim());
            if (dsItemDetails != null && dsItemDetails.Tables[0].Rows.Count > 0)
            {
                lblROPFct.Text = string.Format("{0:n3}", dsItemDetails.Tables[0].Rows[0]["ROPFactor"]);
                //lblROPFct.Text = string.Format("{0:n3}", dsItemDetails.Tables[0].Rows[0]["OrigRemain"]);
                try
                {
                    totalRequired = dsItemDetails.Tables[0].Compute("sum(Required)", "").ToString();
                    sumROP = dsItemDetails.Tables[0].Compute("sum(ROPHubCalc)", "").ToString();
                    sumAvl = dsItemDetails.Tables[0].Compute("sum(AvailQty)", "").ToString();
                    sumRTSB = dsItemDetails.Tables[0].Compute("sum(RTSBQty)", "").ToString();
                    sumIntransit = dsItemDetails.Tables[0].Compute("sum(InTransit)", "").ToString();
                    sumAllocated = dsItemDetails.Tables[0].Compute("sum(Allocated)", "").ToString();
                    sumRecommended = dsItemDetails.Tables[0].Compute("sum(RecommQty)", "").ToString();
                    sumCommited = dsItemDetails.Tables[0].Compute("sum(CommitQty)", "").ToString();
                    sumMOH = dsItemDetails.Tables[0].Compute("sum(Avail_Mos)", "").ToString();
                    //sumSupEqv = dsItemDetails.Tables[0].Compute("sum(SupEqQty)", "").ToString();
                    sumSupEqv = string.Format("{0:0.0}", dsItemDetails.Tables[0].Compute("Sum(SupEqQty) / ((Sum(ROPHubCalc) / Sum(ROPDays)) * 30)", ""));
                }
                catch (Exception ex) { }

                DataTable dtShipDetails = (DataTable)dsItemDetails.Tables[0].Copy();
                DataTable dtBrGroup = detRTS.GetDetails("vRTS_Details", "DISTINCT LocIMRegion", "ItemNo = '" + ddlItemNo.SelectedValue.Trim() + "'").Tables[0];
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
                        drGroup["AvailQty"] = dtShipDetails.Compute("Sum(AvailQty)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        drGroup["InTransit"] = dtShipDetails.Compute("Sum(InTransit)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        drGroup["Allocated"] = dtShipDetails.Compute("Sum(Allocated)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        drGroup["Required"] = dtShipDetails.Compute("Sum(Required)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        //drGroup["SupEqQty"] = dtShipDetails.Compute("Sum(SupEqQty)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        drGroup["SupEqQty"] = dtShipDetails.Compute("Sum(SupEqQty) / ((Sum(ROPHubCalc) / Sum(ROPDays)) * 30)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        drGroup["RecommQty"] = dtShipDetails.Compute("Sum(RecommQty)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        drGroup["CommitQty"] = dtShipDetails.Compute("Sum(CommitQty)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        drGroup["Avail_Mos"] = dtShipDetails.Compute("Sum(Avail_Mos)", "LocIMRegion='" + drow[0].ToString().Trim() + "'");
                        drGroup["ItemNo"] = "Sum";
                        dtGroup.Rows.Add(drGroup);
                    }
                }

                decimal holdedQty = detRTS.GERReadyToShipHoldQuantity(ddlItemNo.SelectedValue.Trim());
                DataRow drHold = dtGroup.NewRow();
                drHold["LocationCode"] = "HOLD";
                drHold["CommitQty"] = holdedQty;
                drHold["ItemNo"] = ddlItemNo.SelectedValue.Trim();
                dtGroup.Rows.Add(drHold);

                lblBrMsg.Visible = false;
                dgItemDtl.Visible = true;
                dgItemDtl.DataSource = dtGroup;
                dgItemDtl.DataBind();
                BindFooter();
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
            lblBrMsg.Text = ex.ToString();
        }
    }

    public void BindFooter()
    {
        // Set unused & Total value
        nonePPQty = Convert.ToInt32(detRTS.GetNonPPQuantity(ddlItemNo.SelectedItem.Text));
        unUsedQty = Convert.ToInt32(sumRecommended) - nonePPQty;
        total = unUsedQty + Convert.ToInt32(sumRecommended);
    }
    #endregion

    #region Branch Item Details Grid (dgItemDtl)
    protected void dgItemDtl_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            HiddenField hidItemNo = e.Item.FindControl("hidItemNo") as HiddenField;

            if (hidItemNo.Value.Trim() == "Sum")
            {
                LinkButton lnkBr = e.Item.FindControl("lnkLocation") as LinkButton;
                LinkButton lnkCommit = e.Item.FindControl("lnkCommit") as LinkButton;

                lnkBr.Style.Add("color", "#CC0000");
                lnkCommit.Style.Add("color", "#CC0000");

                lnkBr.Font.Underline = false;
                lnkCommit.Font.Underline = false;
                lnkCommit.Style.Add("font-decoration", "none");
                lnkBr.Attributes.Add("onclick", "Javascript:return false;");
                lnkCommit.Attributes.Add("onclick", "Javascript:return false;");
                e.Item.CssClass = "BluBg itemTotal ";
                for (int count = 0; count < e.Item.Cells.Count; count++)
                    e.Item.Cells[count].ForeColor = System.Drawing.Color.FromName("#CC0000"); ;
            }
            //else if (hidItemNo.Value.Trim() == "HOLD")
            //{
            //    LinkButton lnkBr = e.Item.FindControl("lnkLocation") as LinkButton;
            //    LinkButton lnkCommit = e.Item.FindControl("lnkCommit") as LinkButton;

            //    lnkBr.Style.Add("color", "#CC0000");
            //    lnkCommit.Style.Add("color", "#CC0000");
            //    lnkBr.Font.Underline = false;
            //    //lnkBr.Font.Bold = true;
            //    //lnkCommit.Font.Bold = true;
            //    lnkBr.Attributes.Add("onclick", "Javascript:return false;"); 
            //}            
            else
            {
                e.Item.Cells[5].BackColor = System.Drawing.Color.LightGreen;
                e.Item.Cells[8].BackColor = System.Drawing.Color.Yellow;
                return;
            }
        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            //e.Item.Cells[7].CssClass = "lock";
            //Label lblRecom = e.Item.FindControl("lblRecomm") as Label;
            //Label lblUnused = e.Item.FindControl("lblUnusedQty") as Label;
            //Label lblTotal = e.Item.FindControl("lblTotalQty") as Label;
            Label lblItmNo = e.Item.FindControl("lblItmNo") as Label;

            // Set unused & Total value
            nonePPQty = Convert.ToInt32(detRTS.GetNonPPQuantity(ddlItemNo.SelectedItem.Text));
            unUsedQty = nonePPQty - Convert.ToInt32(sumCommited);
            total = unUsedQty + Convert.ToInt32(sumRecommended);

            lblItmNo.Text = ddlItemNo.SelectedItem.Text;
            //lblTotal.Text = total.ToString();
            //lblUnused.Text = unUsedQty.ToString();

            e.Item.Cells[0].ColumnSpan = 2;
            e.Item.Cells[1].Visible = false;

            e.Item.Cells[2].Text = "<span style='color:#003366;'>" + sumROP + "</span>";
            e.Item.Cells[4].Text = "<span style='color:#003366;'>" + sumAvl + "</span>";
            e.Item.Cells[5].Text = "<span style='color:#003366;'>" + sumRTSB + "</span>";
            e.Item.Cells[6].Text = "<span style='color:#003366;'>" + sumIntransit + "</span>";
            e.Item.Cells[7].Text = "<span style='color:#003366;'>" + sumMOH + "</span>";
            e.Item.Cells[8].Text = "<span style='color:#003366;'>" + sumAllocated + "</span>";
            e.Item.Cells[9].Text = "<span style='color:#003366;'>" + totalRequired + "</span>";
            e.Item.Cells[10].Text = "<span style='color:#003366;'>" + sumSupEqv + "</span>";
            e.Item.Cells[11].Text = "<span style='color:#003366;'>" + sumCommited + "</span>";
            //lblRecom.Text = sumRecommended.Trim();          
        }
    }

    protected void dgItemDtl_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        LinkButton lnkLocation = e.Item.FindControl("lnkLocation") as LinkButton;
        try
        {
            HiddenField hidItemNo = e.Item.FindControl("hidItemNo") as HiddenField;
            hidBranch.Value = ((lnkLocation.Text == "HOLD") ? holdLocation : lnkLocation.Text);
            SetGridStyle(dgItemDtl);

            // Change the color of the current item
            e.Item.CssClass = "itemHighLight";

            if (e.CommandName == "Action")
            {
                ViewState["mode"] = "Branch";
                if (hidVendor.Value.Trim() != "" && hidBranch.Value.Trim() != "")
                {
                    string whereClause = "VendNo = '" + hidVendor.Value.Trim() + "' and ItemNo = '" + ddlItemNo.SelectedValue.Trim() + "' and PoNo = '" + hidPO.Value.Trim() + "'";
                    BindActionPanel(whereClause);
                }
                else
                    ClearActionPanel();
            }

            if (e.CommandName == "Commit")
            {
                ViewState["mode"] = "Commit";
                //string whereClause = (lnkLocation.Text == "HOLD") ? "HOLD = 'Y' and ItemNo = '" + ddlItemNo.SelectedValue.Trim() + "'" : "LocCd = '" + hidBranch.Value.Trim() + "' and ItemNo = '" + hidItemNo.Value.Trim() + "'";
                string whereClause = "LocCd = '" + hidBranch.Value.Trim() + "' and ItemNo = '" + hidItemNo.Value.Trim() + "'";
                BindActionPanel(whereClause);
            }

            pnlShipDetails.Update();
            pnlAction.Update();
            //ScriptManager.RegisterClientScriptBlock(lnkLocation, typeof(LinkButton), "", "AdjustHeight();", true);
        }
        catch (Exception ex) { }
        ScriptManager.RegisterClientScriptBlock(lnkLocation, typeof(LinkButton), "", "AdjustHeight();", true);
    }

    protected void dgItemDtl_SortCommand(object source, DataGridSortCommandEventArgs e)
    {
        if (hidSortBranch.Attributes["sortType"] != null)
        {
            if (hidSortBranch.Attributes["sortType"].ToString() == "ASC")
                hidSortBranch.Attributes["sortType"] = "DESC";
            else
                hidSortBranch.Attributes["sortType"] = "ASC";
        }
        else
            hidSortBranch.Attributes.Add("sortType", "ASC");

        hidSortBranch.Value = e.SortExpression + " " + hidSortBranch.Attributes["sortType"].ToString();

        BindItemDetails();
        SelectGridItem();
        pnlShipDetails.Update();
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
    
    protected void dgVendor_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        LinkButton lnkVendor = e.Item.FindControl("lnkVendor") as LinkButton;
        try
        {
            if (e.CommandName == "Action")
            {
                HiddenField hidItemNo = e.Item.FindControl("hidItemNo") as HiddenField;
                hidPO.Value = e.Item.Cells[1].Text.Trim();
                hidMfgPlant.Value = e.Item.Cells[9].Text.Trim();
                hidVendor.Value = lnkVendor.Text;
                ViewState["mode"] = "Branch";

                SetGridStyle(dgVendor);
                dgVendor.FooterStyle.ForeColor = System.Drawing.Color.FromName("#003366");

                // Change the color of the current item
                e.Item.CssClass = "itemHighLight";

                if (hidVendor.Value.Trim() != "" && hidBranch.Value.Trim() != "")
                {
                    string whereClause = "VendNo = '" + hidVendor.Value.Trim() + "' and ItemNo = '" + ddlItemNo.SelectedValue.Trim() + "' and PoNo = '" + hidPO.Value.Trim() + "'";
                    BindActionPanel(whereClause);
                }
                else
                    ClearActionPanel();

                //if (int.Parse(lblSuperEqu.Text.ToString()) != 36)
                //{
                //    lblSuperEqu.ForeColor = System.Drawing.Color.FromName("#CC0000");
                //    lblSuperEqu.BackColor = System.Drawing.Color.White;
                //    lblSuperEqu.r
                //}
                pnlShipDetails.Update();
                pnlAction.Update();
            }
        }
        catch (Exception ex) { }
        ScriptManager.RegisterClientScriptBlock(lnkVendor, typeof(LinkButton), "", "AdjustHeight();", true);
    }

    protected void dgVendor_SortCommand(object source, DataGridSortCommandEventArgs e)
    {
        if (hidSortVendor.Attributes["sortType"] != null)
        {
            if (hidSortVendor.Attributes["sortType"].ToString() == "ASC")
                hidSortVendor.Attributes["sortType"] = "DESC";
            else
                hidSortVendor.Attributes["sortType"] = "ASC";
        }
        else
            hidSortVendor.Attributes.Add("sortType", "ASC");

        hidSortVendor.Value = e.SortExpression + " " + hidSortVendor.Attributes["sortType"].ToString();

        BindVendorPODetails();
        SelectGridItem();
        pnlVendorItemDetails.Update();
    }
    #endregion

    #region Ready To Ship Action Grid (dgAction)
    protected void dgAction_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            if (e.Item.ItemIndex == 0)
                txtDefault = e.Item.FindControl("txtActQty") as TextBox;
            TextBox txtActQty;
            if (e.Item.ItemIndex == currentIndex)
            {
                focusStatus = true;
                txtActQty = e.Item.FindControl("txtActQty") as TextBox;
                SetFocusControl(txtActQty);
            }
        }
    }

    protected void dgAction_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        Button btnAction = e.Item.FindControl("btnAction") as Button;
        System.Drawing.Color msgColor = System.Drawing.Color.Green;
        if (e.CommandName == "ActionQty")
        {
            #region Get the values from the action grid controls
            TextBox txtAction = e.Item.FindControl("txtActQty") as TextBox;
            HiddenField hidId = e.Item.FindControl("hidId") as HiddenField;
            HiddenField hidItem = e.Item.FindControl("hidItem") as HiddenField;
            HiddenField hidPreviousQty = e.Item.FindControl("hidCurrentQty") as HiddenField;
            HiddenField hidGrossWgt = e.Item.FindControl("hidGrossWgt") as HiddenField;
            string holdPO = e.Item.Cells[e.Item.Cells.Count - 1].Text.ToString().Trim();

            int _previousQty = Convert.ToInt32(hidPreviousQty.Value.Trim());
            int _currentQty = Convert.ToInt32(((txtAction.Text == "") ? "0" : txtAction.Text));
            int _diffQty = 0;

            if (_currentQty > _previousQty)
            {
                _diffQty = _currentQty - _previousQty;
                // Flag Usage: Don't Consider vendor remaining Qty in commit mode
                // If this falg is "SUM" consider remaining qty
                ViewState["CommitAction"] = "SUM";
            }
            else
            {
                _diffQty = _previousQty - _currentQty;
                // If this falg is "SUB" don't consider vedor remaining qty
                ViewState["CommitAction"] = "SUB";
            }

            string location = hidBranch.Value.Trim(); //e.Item.Cells[1].Text.Trim();
            string poNumber = e.Item.Cells[6].Text.Trim();
            string flag = string.Empty;
            string whereClause = (location.Trim() == "HOLD") ? "PoNo = '" + poNumber + "' and ItemNo = '" + hidItem.Value.Trim() + "' and VendNo = '" + ((ViewState["mode"].ToString().Trim() == "Branch") ? hidVendor.Value.Trim() : e.Item.Cells[5].Text.Trim()) + "' " : "LocCd = '" + location.Trim() + "' and PoNo = '" + poNumber + "' and ItemNo = '" + hidItem.Value.Trim() + "' and VendNo = '" + ((ViewState["mode"].ToString().Trim() == "Branch") ? hidVendor.Value.Trim() : e.Item.Cells[5].Text.Trim()) + "' ";
            string detailInsertColumnName = "ActionQty, LocCd, PONo, ItemNo, VendNo, Qty, PortofLading, GrossWght, GERRTSStatCd, ChangeID, EntryID, ChangeDt, EntryDt, MfgPlant";
            string whereGERRTS = "ItemNo = '" + hidItem.Value.Trim() + "' and PONo = '" + poNumber + "' and VendNo = '" + ((ViewState["mode"].ToString().Trim() == "Branch") ? hidVendor.Value.Trim() : e.Item.Cells[5].Text.Trim()) + "' and StatusCd = '00'";
            string whereGERRTSHdr = (location.Trim() == "HOLD") ? "ItemNo = '" + hidItem.Value.Trim() + "'" : "LocCd = '" + location.Trim() + "' and ItemNo = '" + hidItem.Value.Trim() + "'";

            DataSet dsShipTo = detRTS.GetDetails("GERRTS", "QtyRemaining", " PoNo = '" + poNumber + "' and ItemNo = '" + hidItem.Value.Trim() + "' and VendNo = '" + ((ViewState["mode"].ToString().Trim() == "Branch") ? hidVendor.Value.Trim() : e.Item.Cells[5].Text.Trim()) + "' and StatusCd = '00'");
            string sumRemQty = ((dsShipTo != null && dsShipTo.Tables[0].Rows.Count > 0) ? dsShipTo.Tables[0].Rows[0]["QtyRemaining"].ToString().Trim() : "0");
            int remainingQty = Convert.ToInt32(sumRemQty);
            #endregion

            if (ViewState["mode"] != null)
            {
                switch (ViewState["mode"].ToString().Trim())
                {
                    case "Branch":
                        if (_currentQty <= remainingQty)
                        {
                            // Get Gross weight value for single item
                            double _grossWeight = Convert.ToDouble(hidGrossWgt.Value.Trim());
                            string detailInsertValue = ((txtAction.Text == "") ? "0" : txtAction.Text.Trim()) + ",'" + location.Trim() + "','" + poNumber + "', '" + hidItem.Value.Trim() + "', '" + hidVendor.Value.Trim() + "'," + _currentQty.ToString() + ",'" + e.Item.Cells[7].Text.Trim() + "','" + _grossWeight.ToString() + "','" + Server.HtmlDecode(e.Item.Cells[4].Text).Trim() + "','" + Session["UserName"].ToString().Trim() + "','" + Session["UserName"].ToString().Trim() + "','" + DateTime.Now.ToString() + "','" + DateTime.Now.ToString() + "','" + hidMfgPlant.Value.Trim() + "'";
                            object objIden = detRTS.InsertActionQty(detailTable, detailInsertColumnName, detailInsertValue);

                            if (objIden != null)
                                updtPriority.UpdatePriority(poNumber, hidItem.Value.Trim(), objIden.ToString().Trim(), hidPreviousQty.Value.Trim(), _currentQty.ToString());

                            detRTS.UpdateQuantity("GERRTSHdr", "CommitQty = isnull(CommitQty,0) + " + _currentQty.ToString() + ", ChangeID = '" + Session["UserName"].ToString().Trim() + "', ChangeDt = '" + DateTime.Now.ToString() + "'", whereGERRTSHdr);
                            detRTS.UpdateQuantity("GERRTS", "QtyRemaining = QtyRemaining - " + _currentQty.ToString() + ", ChangeID = '" + Session["UserName"].ToString().Trim() + "', ChangeDt = '" + DateTime.Now.ToString() + "'", whereGERRTS);

                            //Code to unhold the polines
                            if (Convert.ToInt32(_currentQty.ToString()) == 0 && (holdPO.Trim().Replace("&nbsp;", "") == "Y" || holdPO.Trim().Replace("&nbsp;", "") == ""))
                            {
                                detRTS.UpdateQuantity("GERRTSDtl", "Hold = 'N'", "PoNo = '" + poNumber + "' and ItemNo = '" + hidItem.Value.Trim() + "'");
                                flag = "Purchase order has been successfully unholded";
                            }
                            if (_currentQty == remainingQty)
                            {
                                flag = "Successfully Cleared Remaining Qty";
                                msgColor = System.Drawing.Color.FromName("#CC0000");
                            }
                        }
                        else
                        {
                            txtAction.Text = hidPreviousQty.Value.Trim();
                            ShowProgress();
                            SetFocusControl(txtAction);
                            return;
                        }
                        break;
                    case "Commit":
                        //Code to unhold the polines
                        if (Convert.ToInt32(_currentQty.ToString()) == 0 && (holdPO.Trim().Replace("&nbsp;", "") == "Y" || holdPO.Trim().Replace("&nbsp;", "") == ""))
                        {
                            detRTS.UpdateQuantity("GERRTSDtl", "Hold = 'N', ActionQty = 0", "PoNo = '" + poNumber + "' and ItemNo = '" + hidItem.Value.Trim() + "' and pGERRTSDtlID = " + hidId.Value);
                            flag = "Purchase order has been successfully unholded";
                        }

                        if (ViewState["CommitAction"].ToString() == "SUB")
                        {
                            detRTS.UpdateQuantity(detailTable, "qty = " + _currentQty.ToString() + ", ActionQty = " + _currentQty.ToString() + ", ChangeID = '" + Session["UserName"].ToString().Trim() + "', ChangeDt = '" + DateTime.Now.ToString() + "'", whereClause + " and pGERRTSDtlID = " + hidId.Value.Trim());
                            detRTS.UpdateQuantity("GERRTSHdr", "CommitQty = CommitQty " + ((Convert.ToInt32(_currentQty.ToString()) >= Convert.ToInt32(hidPreviousQty.Value.Trim())) ? "+ " : "- ") + _diffQty + ", ChangeID = '" + Session["UserName"].ToString().Trim() + "', ChangeDt = '" + DateTime.Now.ToString() + "'", whereGERRTSHdr);
                            detRTS.UpdateQuantity("GERRTS", "QtyRemaining = QtyRemaining " + ((Convert.ToInt32(_currentQty.ToString()) >= Convert.ToInt32(hidPreviousQty.Value.Trim())) ? "- " : "+ ") + _diffQty + ", ChangeID = '" + Session["UserName"].ToString().Trim() + "', ChangeDt = '" + DateTime.Now.ToString() + "'", whereGERRTS);
                        }
                        else
                        {
                            if (ViewState["CommitAction"].ToString() == "SUM" && _diffQty <= remainingQty)
                            {
                                detRTS.UpdateQuantity(detailTable, "qty = " + _currentQty.ToString() + ", ActionQty = " + _currentQty.ToString() + ", ChangeID = '" + Session["UserName"].ToString().Trim() + "', ChangeDt = '" + DateTime.Now.ToString() + "'", whereClause + " and pGERRTSDtlID = " + hidId.Value.Trim());
                                detRTS.UpdateQuantity("GERRTSHdr", "CommitQty = CommitQty " + ((Convert.ToInt32(_currentQty.ToString()) >= Convert.ToInt32(hidPreviousQty.Value.Trim())) ? "+ " : "- ") + _diffQty + ", ChangeID = '" + Session["UserName"].ToString().Trim() + "', ChangeDt = '" + DateTime.Now.ToString() + "'", whereGERRTSHdr);
                                detRTS.UpdateQuantity("GERRTS", "QtyRemaining = QtyRemaining " + ((Convert.ToInt32(_currentQty.ToString()) >= Convert.ToInt32(hidPreviousQty.Value.Trim())) ? "- " : "+ ") + _diffQty + ", ChangeID = '" + Session["UserName"].ToString().Trim() + "', ChangeDt = '" + DateTime.Now.ToString() + "'", whereGERRTS);
                            }
                            else
                            {
                                txtAction.Text = hidPreviousQty.Value.Trim();
                                ShowProgress();
                                SetFocusControl(txtAction);
                                return;
                            }
                        }
                        break;
                }

                currentIndex = e.Item.ItemIndex + 1;
                string whrClause = ((ViewState["mode"].ToString().Trim() != "Commit") ? "VendNo = '" + hidVendor.Value.Trim() + "' and ItemNo = '" + ddlItemNo.SelectedValue.Trim() + "' and PoNo = '" + hidPO.Value.Trim() + "'" : hidBranch.Value == "HOLD" ? "ItemNo = '" + ddlItemNo.SelectedValue.Trim() + "' and HOLD = 'Y'" : "LocCd = '" + hidBranch.Value.Trim() + "' and ItemNo = '" + ddlItemNo.SelectedValue.Trim() + "'");
                BindActionPanel(whrClause);
                BindVendorPODetails();
                BindItemDetails();
                SelectGridItem();
                lblMessage.ForeColor = msgColor;
                lblMessage.Text = (flag != "") ? flag : "";
                flag = "";
                pnlProgress.Update();
                pnlShipDetails.Update();
                pnlVendorItemDetails.Update();

                pnlAction.Update();
                return;
            }
        }
        ScriptManager.RegisterClientScriptBlock(btnAction, typeof(Button), "", "AdjustHeight();", true);
    }
    #endregion

    #region Developer Methods
    #region Bind the Ready To Ship Action Grid (dgAction)
    public void BindActionPanel(string whereClause)
    {
        try
        {
            DataSet dsActionQty = new DataSet();
            if (hidBranch.Value.Trim() != holdLocation)
                dsActionQty = detRTS.GetRTSActionQty(whereClause, ViewState["mode"].ToString().Trim());
            else
                dsActionQty = detRTS.GetRTSActionQtyHold(whereClause, ViewState["mode"].ToString().Trim());

            if (dsActionQty != null && dsActionQty.Tables[0].Rows.Count > 0)
            {
                DataTable dtAction = dsActionQty.Tables[0];

                if (ViewState["mode"].ToString().Trim() != "Commit")
                {
                    dtAction.Rows[0]["PFCLoc"] = hidBranch.Value.Trim();
                    dtAction.Rows[0]["BrDesc"] = ((hidBranch.Value.Trim() == holdLocation) ? "HOLD" : detRTS.GetBranchDesc(hidBranch.Value.Trim()));
                }

                BindAction(dtAction);
                lblFlag.Visible = false;
                pnlAction.Update();
            }
            else
            {
                ClearActionPanel();
                //lblFlag.Text = whereClause;
                lblFlag.Visible = true;
                pnlAction.Update();
            }
        }
        catch (Exception ex)
        {
            ClearActionPanel();
            lblFlag.Text = ex.ToString();
            lblFlag.Visible = true;
            pnlAction.Update();
        }
    }

    public void BindAction(DataTable dtAction)
    {
        try
        {
            dgAction.DataSource = dtAction;
            dgAction.DataBind();
            if (!focusStatus)
                SetFocusControl(txtDefault);
            dgAction.Visible = true;
            pnlAction.Update();
        }
        catch (Exception ex) { }
    }
    #endregion

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

    public void SelectGridItem()
    {
        if (hidBranch.Value.Trim() != "")
            for (int i = 0; i < dgItemDtl.Items.Count; i++)
            {
                LinkButton lnkLoc = dgItemDtl.Items[i].FindControl("lnkLocation") as LinkButton;
                HiddenField hidItemNo = dgItemDtl.Items[i].FindControl("hidItemNo") as HiddenField;
                if (((lnkLoc.Text.Trim() == hidBranch.Value.Trim()) || (lnkLoc.Text == "HOLD" && hidBranch.Value.Trim() == holdLocation)) && hidItemNo.Value.Trim() != "Sum")
                {
                    dgItemDtl.Items[i].CssClass = "itemHighLight";
                    break;
                }
            }

        if (hidVendor.Value.Trim() != "" && hidPO.Value.Trim() != "")
            for (int i = 0; i < dgVendor.Items.Count; i++)
            {
                LinkButton lnkVendor = dgVendor.Items[i].FindControl("lnkVendor") as LinkButton;
                string poNumber = dgVendor.Items[i].Cells[1].Text.Trim();
                string remQty = dgVendor.Items[i].Cells[5].Text.Trim();
                if (lnkVendor.Text.Trim() == hidVendor.Value.Trim() && poNumber.Trim() == hidPO.Value.Trim() && remQty.Trim() != "0")
                {
                    dgVendor.Items[i].CssClass = "itemHighLight";
                    break;
                }
            }
    }

    // Method to clear the labels
    public void Clear()
    {
        lblDescription.Text = "";
        lblUOM.Text = "";
        lblQtyPer.Text = "";
        lbl_Lbs.Text = "";
        lblSuperEqu.Text = "";
        lblPCS.Text = "";
        lblTotLbs.Text = "";
        lblWgt.Text = "";
        lblHarmCode.Text = "";
        lblVelocity.Text = "";
        lblLowProfileQty.Text = "";
    }

    // Method to clear the action panel
    public void ClearActionPanel()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("ID");
        dt.Columns.Add("PFCLoc");
        dt.Columns.Add("Lbs");
        dt.Columns.Add("PO #");
        dt.Columns.Add("Leading Port");
        dt.Columns.Add("Action Qty");
        dt.Columns.Add("Status Code");
        dt.Columns.Add("Vendor");
        dt.Columns.Add("ItemNo");
        dt.Columns.Add("Qty");
        dt.Columns.Add("BrDesc");
        dt.Columns.Add("GrossWght");
        dt.Columns.Add("Hold");
        DataRow dr = dt.NewRow();
        dr[0] = "";
        dt.Rows.Add(dr);

        dgAction.DataSource = dt;
        dgAction.DataBind();
        if (!focusStatus)
            SetFocusControl(txtDefault);
        dgAction.Visible = false;
        lblFlag.Visible = false;
    }

    public void ShowProgress()
    {
        lblMessage.ForeColor = System.Drawing.Color.FromName("#CC0000");
        lblMessage.Text = "Vendor PO quantity has been consumed quantity insufficient ";
        pnlProgress.Update();
        return;
    }

    public void SetFocusControl(TextBox txtActionQty)
    {
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "if(document.getElementById('" + txtActionQty.ClientID + "')!=null){document.getElementById('" + txtActionQty.ClientID + "').focus();document.getElementById('" + txtActionQty.ClientID + "').select();}", true);
    }
    #endregion

    #region Button Events
    protected void SetQtyFilter(Object sender, EventArgs e)
    {
        // Filter will be set in BindVendorPODetails so all we need to do is refresh
        BindVendorPODetails();
        pnlVendorItemDetails.Update();
    }

    protected void btnAccept_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            bool updtFlag = detRTS.CommitRTS(ddlItemNo.SelectedValue.Trim());

            if (updtFlag)
            {
                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Quantities has been processed successfully";
                hidVendor.Value = "";
                hidPO.Value = "";
                hidBranch.Value = "";
                BindVendorPODetails();
                BindSummary();
                BindItemDetails();
                pnlShipDetails.Update();
                pnlVendorItemDetails.Update();
                ClearActionPanel();
                pnlAction.Update();
                pnlProgress.Update();
            }
            else
            {
                lblMessage.ForeColor = System.Drawing.Color.FromName("#CC0000");
                lblMessage.Text = "Vendor remaining quantity insufficient ";
            }
        }
        catch (Exception ex) { }
    }

    protected void ibtnClose_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            ClearActionPanel();
            SetGridStyle(dgVendor);
            SetGridStyle(dgItemDtl);
            hidVendor.Value = "";
            hidPO.Value = "";
            hidBranch.Value = "";

            pnlVendorItemDetails.Update();
            pnlShipDetails.Update();
            pnlAction.Update();
        }
        catch (Exception ex) { }
    }
    #endregion

    #region Pager Functionality
    protected void ibtnFirst_Click(object sender, ImageClickEventArgs e)
    {
        ddlPages.SelectedIndex = 0;
        ddlItemNo.SelectedValue = ddlPages.SelectedValue;
        BindPageDetails();
    }

    protected void ibtnPrevious_Click(object sender, ImageClickEventArgs e)
    {
        if (ddlPages.SelectedIndex == 0)
        { }
        else
        {
            ddlPages.SelectedIndex = ddlPages.SelectedIndex - 1;
            ddlItemNo.SelectedValue = ddlPages.SelectedValue;
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
            ddlItemNo.SelectedValue = ddlPages.SelectedValue;
            BindPageDetails();
        }
    }

    protected void btnLast_Click(object sender, ImageClickEventArgs e)
    {
        ddlPages.SelectedIndex = ddlPages.Items.Count - 1;
        ddlItemNo.SelectedValue = ddlPages.SelectedValue;
        BindPageDetails();
    }

    protected void btnGo_Click(object sender, ImageClickEventArgs e)
    {
        if (Convert.ToInt32(txtGotoPage.Text.Trim()) >= 1 && Convert.ToInt32(txtGotoPage.Text.Trim()) <= ddlPages.Items.Count)
        {
            ddlPages.SelectedIndex = Convert.ToInt32(txtGotoPage.Text.Trim()) - 1;
            ddlItemNo.SelectedValue = ddlPages.SelectedValue;
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
        ddlItemNo.SelectedValue = ddlPages.SelectedValue.Trim();
        BindPageDetails();
        ScriptManager.RegisterClientScriptBlock(ddlPages, typeof(ListBox), "", "AdjustHeight();", true);
    }
    #endregion
}
