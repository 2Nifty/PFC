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

public partial class ManualTransfer : System.Web.UI.Page
{
    #region Variable declaration
    DataTable dtItemDetails;
    DataTable dtItemTotals;
    DataTable dtXFerDetails;
    DataTable dt;
    DataSet ds;
    ManualTransferData XFerData = new ManualTransferData();

    string totalRequired = string.Empty;
    string sumROP = string.Empty;
    string sumAvl = string.Empty;
    string sumRTSB = string.Empty;
    string sumIntransit = string.Empty;
    string sumOHExc = string.Empty;
    string sumAccumQty = string.Empty;
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
        Ajax.Utility.RegisterTypeForAjax(typeof(ManualTransfer));

        lblMessage.Text = "";
        if (!IsPostBack)
        {
            // Get the items and first grid data
            Session["XFerMasterData"] = null;
            Session["ItemGridData"] = null;

            if (Session["CPRFactor"] != null)
                CPRFactor.Text = Session["CPRFactor"].ToString();

            string OrderBy = "CPR.ItemNo";
            if (Session["CPRSort"] != null)
            {
                if (Session["CPRSort"].ToString() == "SortPlating") OrderBy = "substring(CPR.ItemNo,14,1), CPR.ItemNo";
                if (Session["CPRSort"].ToString() == "SortItem") OrderBy = "CPR.ItemNo";
                if (Session["CPRSort"].ToString() == "SortVariance") OrderBy = "substring(CPR.ItemNo,12,3), CPR.ItemNo";
                if (Session["CPRSort"].ToString() == "SortNetBuyBucks") OrderBy = "FactoredBuyCost, CPR.ItemNo";
                if (Session["CPRSort"].ToString() == "SortNewBuyLBS") OrderBy = "FactoredBuyQty*ItemMaster.Wght, CPR.ItemNo";
                if (Session["CPRSort"].ToString() == "SortCFVC") OrderBy = "CorpFixedVelocity, CPR.ItemNo";
            }
            dt = CheckError(XFerData.GetCPRItems(Session["UserName"].ToString(), Session["CPRFactor"].ToString(), OrderBy));
            if ((dt != null) && (dt.Rows.Count > 0))
            {
                Session["XFerMasterData"] = dt;
                BindData();
                //ItemGrid.DataSource = dt.DefaultView.ToTable();
            }
            pnlProgress.Update();
        }
    }

    // Bind the Pgaer Data
    public void BindData()
    {
        try
        {
            // get the data.
            if (dt != null && dt.Rows.Count > 0)
            {
                dt.Columns.Add("Id");
                for (int i = 0; i < dt.Rows.Count; i++)
                    dt.Rows[i]["Id"] = (i + 1).ToString();
                dt.AcceptChanges();

                ddlPages.DataSource = dt;
                ddlPages.DataTextField = "Id";
                ddlPages.DataValueField = "ItemNo";
                ddlPages.DataBind();

                BindPageDetails();
            }
        }
        catch (Exception ex)
        {
            lblMessage.Text = "BindData fail" + ex.ToString();
        }
    }

    #region Button Events
    protected void btnFindItem_Click(object sender, EventArgs e)
    {
        string mess1 = "";
        try
        {
            ddlPages.SelectedValue = txtItemNo.Text;
            BindPageDetails();
            lblMessage.ForeColor = System.Drawing.Color.Green;
            //lblMessage.Text = RecsAdded.ToString() + " lines committed." + ddlItemNo.SelectedValue.ToString();
        }
        catch (ArgumentOutOfRangeException ex1)
        {
            lblMessage.Text = txtItemNo.Text + " not found.";
            pnlProgress.Update();
        }
        catch (Exception ex)
        {
            lblMessage.Text = "btnFindItem_Click fail" + ex.ToString();
            pnlProgress.Update();
        }
    }

    protected void btnUpdXfers_Click(object sender, EventArgs e)
    {
        //lblMessage.Text = "Xfer update ";
        //pnlProgress.Update();
        GetXferDetails();
    }

    #endregion

    #region Developer Methods
    // Method to bind the Branch Item Details Grid (dgItemDtl)
    public void BindItemDetails()
    {
        try
        {
            totalRequired = "";
            dtItemDetails = CheckError(XFerData.GetItemData(lblItemNo.Text, Session["CPRFactor"].ToString(), Session["IncludeSummQtys"].ToString()));
            pnlItemDetails.Update();
            if (dtItemDetails != null && dtItemDetails.Rows.Count > 0)
            {
                dtXFerDetails = CheckError(XFerData.GetCurXFers(lblItemNo.Text, Session["UserName"].ToString()));
                //try
                //{
                //foreach (DataRow dr in dtItemDetails.Rows)
                //{
                //    if (dr["LocationCode"].ToString().Trim() == "Child")
                //        dtItemDetails.Rows[dr...Remove(dr);
                //}
                dtItemDetails.DefaultView.RowFilter = "LocationCode <> 'Child'";
                dtItemDetails = dtItemDetails.DefaultView.ToTable();
                dtItemDetails.DefaultView.RowFilter = "LocationCode <> 'Loc 01'";
                dtItemDetails = dtItemDetails.DefaultView.ToTable();
                dtItemDetails.DefaultView.RowFilter = "LocationCode <> '" + lblItemNo.Text.Substring(0, 6) + "'";
                dtItemDetails = dtItemDetails.DefaultView.ToTable();
                dtItemDetails.Columns.Add("InTransit", typeof(decimal));
                dtItemDetails.Columns.Add("OnHandExcess", typeof(int));
                dtItemDetails.Columns.Add("AccumQty", typeof(int));
                dtItemDetails.Columns.Add("CommitQty", typeof(int));
                dtItemDetails.Columns.Add("Allocated", typeof(int));
                DataTable ATotalTable = dtItemDetails.Clone();
                DataRow ATotalRow = ATotalTable.NewRow();
                ATotalTable.Rows.Add(ATotalRow);
                ds = PreTotalFix(dtItemDetails, ATotalTable);
                if (ds != null)
                {
                    dtItemDetails = ds.Tables[0];
                    dtItemTotals = ds.Tables[1];
                    if ((decimal)dtItemTotals.Rows[0]["ROP"] != 0)
                    {
                        lblROPFactor.Text = String.Format("{0:#,##0.000}",
                            ((decimal)dtItemTotals.Rows[0]["Avl"] + (decimal)dtItemTotals.Rows[0]["InTransit"] + (decimal)dtItemTotals.Rows[0]["RTSB"]) / (decimal)dtItemTotals.Rows[0]["ROP"]);
                    }
                    else
                    {
                        lblROPFactor.Text = "0.000";
                    }
                    //PostTotalFix();
                    //sumROP = String.Format("{0:#,##0.0}", dtItemTotals.Rows[0]["ROP"], NumberStyles.Number);
                    //sumAvl = String.Format("{0:#,##0}", dtItemTotals.Rows[0]["Avl"], NumberStyles.Number);
                    //sumMOH = String.Format("{0:#,##0.0}", dtItemTotals.Rows[0]["MosAvl"], NumberStyles.Number);
                    //sumRTSB = String.Format("{0:#,##0}", dtItemTotals.Rows[0]["RTSB"], NumberStyles.Number);
                    //sumIntransit = String.Format("{0:#,##0}", dtItemTotals.Rows[0]["InTransit"], NumberStyles.Number);
                    //sumAllocated = String.Format("{0:#,##0}", dtItemTotals.Rows[0]["Allocated"], NumberStyles.Number);
                    //sumOHExc = String.Format("{0:#,##0}", dtItemTotals.Rows[0]["OnHandExcess"], NumberStyles.Number);
                    //sumAccumQty = String.Format("{0:#,##0}", dtItemTotals.Rows[0]["AccumQty"], NumberStyles.Number);
                    //sumCommited = String.Format("{0:#,##0}", dtItemTotals.Rows[0]["CommitQty"], NumberStyles.Number);
                    //}
                    //catch (Exception ex)
                    //{
                    //    lblMessage.Text = "sum fail" + ex.ToString();
                    //}

                    lblBrMsg.Visible = false;
                    dgItemDtl.Visible = true;
                    dgItemDtl.DataSource = dtItemDetails;
                    dgItemDtl.DataBind();
                    txtItemNo.Focus();
                    Session["ItemGridData"] = dtItemDetails;
                    //btnAccept.Visible = true;
                    //pnlCommit.Update();
                }
            }
            else
            {
                dgItemDtl.Visible = false;
                lblBrMsg.Visible = true;
                lblBrMsg.ForeColor = System.Drawing.Color.FromName("#CC0000");
                Session["ItemGridData"] = null;
                Session["ItemGridData"] = null;
            }
            pnlShipDetails.Update();
        }
        catch (Exception ex)
        {
            lblMessage.Text = "BindItemDetails fail" + ex.ToString();
            pnlProgress.Update();
        }
    }

    // Method to bind the Vendor Item Details
    public void GetItemDetails()
    {
        try
        {
            lblMessage.Text = "";
            hidShippingLoc.Value = "";
            lblShippingLoc.Text = "";
            pnlProgress.Update();
            // Method to bind the Branch Item Details Grid (dgItemDtl)
            BindItemDetails();

            if (dtItemDetails != null && dtItemDetails.Rows.Count > 0)
            {
                int lastRec = 0;  // dtItemDetails.Rows.Count - 1;
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "debug1", "alert('" + dtItemDetails.Rows[lastRec]["LocationCode"].ToString().Trim() + "');", true);
                decimal superQty = decimal.Parse(dtItemDetails.Rows[lastRec]["SupEqv_Qty"].ToString(), NumberStyles.Number);
                decimal wght = decimal.Parse(dtItemDetails.Rows[lastRec]["Net_Wgt"].ToString(), NumberStyles.Number);
                lblDescription.Text = dtItemDetails.Rows[lastRec]["Description"].ToString().Trim();
                lblUOM.Text = dtItemDetails.Rows[lastRec]["UOM"].ToString().Trim();
                lblQtyPer.Text = string.Format("{0:#,##0}", ((dtItemDetails.Rows[lastRec]["UOM_Qty"].ToString().Trim() != null && dtItemDetails.Rows[lastRec]["UOM_Qty"].ToString().Trim() != "") ? dtItemDetails.Rows[lastRec]["UOM_Qty"] : "0"));
                lblLbs.Text = string.Format("{0:#,##0.0}", ((dtItemDetails.Rows[lastRec]["Net_Wgt"].ToString().Trim() != null && dtItemDetails.Rows[lastRec]["Net_Wgt"].ToString().Trim() != "") ? dtItemDetails.Rows[lastRec]["Net_Wgt"] : "0"));
                lblSuperEqu.Text = string.Format("{0:#,##0}", dtItemDetails.Rows[lastRec]["SupEqv_Qty"]);
                lblLowProfileQty.Text = string.Format("{0:#,##0}", dtItemDetails.Rows[lastRec]["LowPalletQty"]);
                lblPCS.Text = string.Format("{0:###,##0}", dtItemDetails.Rows[lastRec]["SupEqv_Pcs"]);
                lblTotLbs.Text = string.Format("{0:###,##0.0}", wght * superQty);
                lbl100Wgt.Text = string.Format("{0:###,##0.0}", dtItemDetails.Rows[lastRec]["Wgt100"]);
                lblHarmCode.Text = dtItemDetails.Rows[lastRec]["PPI"].ToString().Trim();
                lblVelocity.Text = dtItemDetails.Rows[lastRec]["CorpFixedVelCode"].ToString().Trim();
                //lblContItemQty.Text = string.Format("{0:###,##0}", dtItemDetails.Rows[0]["LPNQty"]);
                //lblCommittedQty.Text = sumCommited;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "DoRefreshCommitted", "RefreshCommitted();", true);

            }
            else
                Clear();
            pnlItemDetails.Update();
        }
        catch (Exception ex)
        {
            lblMessage.Text = "GetItemDetails fail " + ex.ToString();
            pnlProgress.Update();
        }
    }

    // Method to bind the Item Transfer Details
    public void GetXferDetails()
    {
        dtXFerDetails = CheckError(XFerData.GetCurXFers(lblItemNo.Text.ToString(), Session["UserName"].ToString()));
        dgOther.DataSource = dtXFerDetails;
        dgOther.DataBind();
        if (dtXFerDetails != null && dtXFerDetails.Rows.Count > 0)
        {
            lblOtherMsg.Style.Add("display", "none");
        }
        else
        {
            lblOtherMsg.Style.Add("display", "");
        }
        pnlXFerLines.Update();
        dtItemDetails = (DataTable)Session["ItemGridData"];
        FromLocRem();
        DataTable ATotalTable = dtItemDetails.Clone();
        DataRow ATotalRow = ATotalTable.NewRow();
        ATotalTable.Rows.Add(ATotalRow);
        ds = PreTotalFix(dtItemDetails, ATotalTable);
        if (ds != null)
        {
            dtItemDetails = ds.Tables[0];
            dtItemTotals = ds.Tables[1];
            PostTotalFix();
            sumROP = String.Format("{0:#,##0.0}", dtItemTotals.Rows[0]["ROP"], NumberStyles.Number);
            sumAvl = String.Format("{0:#,##0}", dtItemTotals.Rows[0]["Avl"], NumberStyles.Number);
            sumMOH = String.Format("{0:#,##0.0}", dtItemTotals.Rows[0]["MosAvl"], NumberStyles.Number);
            sumRTSB = String.Format("{0:#,##0}", dtItemTotals.Rows[0]["RTSB"], NumberStyles.Number);
            sumIntransit = String.Format("{0:#,##0}", dtItemTotals.Rows[0]["InTransit"], NumberStyles.Number);
            sumAllocated = String.Format("{0:#,##0}", dtItemTotals.Rows[0]["Allocated"], NumberStyles.Number);
            sumOHExc = String.Format("{0:#,##0}", dtItemTotals.Rows[0]["OnHandExcess"], NumberStyles.Number);
            sumAccumQty = String.Format("{0:#,##0}", dtItemTotals.Rows[0]["AccumQty"], NumberStyles.Number);
            sumCommited = String.Format("{0:#,##0}", dtItemTotals.Rows[0]["CommitQty"], NumberStyles.Number);
            //sumAccumQty = "0";
            //if (dtXFerDetails != null)
            //{
            //    sumAccumQty = String.Format("{0:#,##0}",
            //        dtXFerDetails.Compute("sum(Qty)", "FromLocationCode='" + hidShippingLoc.Value.ToString() + "'"), NumberStyles.Number);
            //}
            //sumCommited = String.Format("{0:#,##0}", dtItemTotals.Rows[0]["CommitQty"], NumberStyles.Number);
            lblBrMsg.Visible = false;
            dgItemDtl.Visible = true;
            dgItemDtl.DataSource = dtItemDetails;
            dgItemDtl.DataBind();
            Session["ItemGridData"] = dtItemDetails;
            Session["XFerGridData"] = dtXFerDetails;
        }
    }

    // Compute the remaining qty for the From Loc
    public void FromLocRem()
    {
        lblOnHandExcessQty.Text = "0";
        lblCommittedQty.Text = "0";
        lblRemainingQty.Text = "0";
        lblShippingLoc.Text = hidShippingLoc.Value.ToString();
        if (hidShippingLoc.Value.ToString().Trim().Length == 2)
        {
            DataRow[] FromRow = dtItemDetails.Select("LocationCode = '" + hidShippingLoc.Value.ToString() + "'");
            lblOnHandExcessQty.Text = String.Format("{0:#,##0}", FromRow[0]["OnHandExcess"].ToString());
            lblCommittedQty.Text = String.Format("{0:#,##0}", FromRow[0]["AccumQty"].ToString());
            lblRemainingQty.Text = String.Format("{0:#,##0}", ((int)FromRow[0]["OnHandExcess"] - (int)FromRow[0]["AccumQty"]).ToString());
        }
        pnlFromTots.Update();
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

    private DataSet PreTotalFix(DataTable cprData, DataTable Tots)
    {
        DataSet dsFixed = new System.Data.DataSet();
        try
        {
            Decimal SubROP = 0;
            Decimal TotROP = 0;
            Decimal SubAvl = 0;
            Decimal TotAvl = 0;
            Decimal SubAvlMo = 0;
            Decimal TotAvlMo = 0;
            Decimal SubRTSB = 0;
            Decimal TotRTSB = 0;
            Decimal SubTrfOW = 0;
            Decimal TotTrfOW = 0;
            Decimal SubOHExc = 0;
            Decimal TotOHExc = 0;
            Decimal SubAccum = 0;
            Decimal TotAccum = 0;
            Decimal SubCommit = 0;
            Decimal TotCommit = 0;
            Decimal AccumQty;
            Decimal CommitQty;
            foreach (System.Data.DataRow row in cprData.Rows)
            {
                row["InTransit"] = 0;
                row["OnHandExcess"] = 0;

                if (row["LocationCode"].ToString().Trim().Length == 2 || row["LocationCode"].ToString().Substring(0, 5) == "Child")
                {
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "debug1", "alert('" + row["LocationCode"].ToString().Trim() + "');", true);
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "debug2", "alert('" + dtXFerDetails.Compute("Sum(Qty)", "FromLocationCode='" + row["LocationCode"].ToString().Trim() + "'").ToString() + "');", true);
                    AccumQty = 0;
                    CommitQty = 0;
                    if ((dtXFerDetails != null) && (dtXFerDetails.Rows.Count > 0))
                    {
                        if (!Decimal.TryParse(dtXFerDetails.Compute("Sum(Qty)", "FromLocationCode='" + row["LocationCode"].ToString().Trim() + "'").ToString(), out AccumQty))
                        {
                        }
                        if (hidShippingLoc.Value.ToString().Trim().Length == 2)
                        {
                            if (!Decimal.TryParse(dtXFerDetails.Compute("Sum(Qty)", "FromLocationCode='" + hidShippingLoc.Value.ToString().Trim() + "' and ToLocationCode='" + row["LocationCode"].ToString().Trim() + "'").ToString(), out CommitQty))
                            {
                            }
                        }
                        else
                        {
                            if (!Decimal.TryParse(dtXFerDetails.Compute("Sum(Qty)", "ToLocationCode='" + row["LocationCode"].ToString().Trim() + "'").ToString(), out CommitQty))
                            {
                            }
                        }

                        //AccumQty = (decimal)dtXFerDetails.Compute("Sum(Qty)", "FromLocationCode='" + row["LocationCode"].ToString().Trim() + "'");
                        //CommitQty = (decimal)dtXFerDetails.Compute("Sum(Qty)", "FromLocationCode='" + row["LocationCode"].ToString().Trim() + "' and ToLocationCode='" + row["LocationCode"].ToString().Trim() + "'");
                    }
                    //CommQty = dtXFerDetails.Compute("Sum(Qty)", "ToLocationCode='" + row["LocationCode"].ToString().Trim() + "'")
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "debug3", "alert('" + Decimal.TryParse(dtXFerDetails.Compute("Sum(Qty)", "FromLocationCode='" + row["LocationCode"].ToString().Trim() + "'").ToString(), out AccumQty).ToString() + "');", true);
                    row["AccumQty"] = AccumQty;
                    row["CommitQty"] = CommitQty;
                    row["InTransit"] = (decimal)row["Trf"] + (decimal)row["OW"];
                    row["OnHandExcess"] = (decimal)row["Avl"] - (decimal)row["ROP"];
                    SubROP += decimal.Parse(row["ROP"].ToString(), NumberStyles.Number);
                    TotROP += decimal.Parse(row["ROP"].ToString(), NumberStyles.Number);
                    SubAvl += decimal.Parse(row["Avl"].ToString(), NumberStyles.Number);
                    TotAvl += decimal.Parse(row["Avl"].ToString(), NumberStyles.Number);
                    SubAvlMo += decimal.Parse(row["MosAvl"].ToString(), NumberStyles.Number);
                    TotAvlMo += decimal.Parse(row["MosAvl"].ToString(), NumberStyles.Number);
                    SubRTSB += decimal.Parse(row["RTSB"].ToString(), NumberStyles.Number);
                    TotRTSB += decimal.Parse(row["RTSB"].ToString(), NumberStyles.Number);
                    SubTrfOW += decimal.Parse(row["InTransit"].ToString(), NumberStyles.Number);
                    TotTrfOW += decimal.Parse(row["InTransit"].ToString(), NumberStyles.Number);
                    SubOHExc += decimal.Parse(row["OnHandExcess"].ToString(), NumberStyles.Number);
                    TotOHExc += decimal.Parse(row["OnHandExcess"].ToString(), NumberStyles.Number);
                    SubAccum += decimal.Parse(row["AccumQty"].ToString(), NumberStyles.Number);
                    TotAccum += decimal.Parse(row["AccumQty"].ToString(), NumberStyles.Number);
                    SubCommit += decimal.Parse(row["CommitQty"].ToString(), NumberStyles.Number);
                    TotCommit += decimal.Parse(row["CommitQty"].ToString(), NumberStyles.Number);
                }
                if (row["LocationCode"].ToString().Contains("-"))
                {
                    row["ROP"] = SubROP;
                    row["Avl"] = SubAvl;
                    row["MosAvl"] = SubAvlMo;
                    row["RTSB"] = SubRTSB;
                    row["InTransit"] = SubTrfOW;
                    row["OnHandExcess"] = SubOHExc;
                    row["AccumQty"] = SubAccum;
                    row["CommitQty"] = SubCommit;
                    SubROP = 0;
                    SubAvl = 0;
                    SubAvlMo = 0;
                    SubRTSB = 0;
                    SubTrfOW = 0;
                    SubOHExc = 0;
                    SubAccum = 0;
                    SubCommit = 0;
                }
            }
            cprData.TableName = "GridDetail";
            dsFixed.Tables.Add(cprData);
            Tots.TableName = "Totals";
            DataRow ATotalRow = Tots.Rows[0];
            ATotalRow["ROP"] = TotROP;
            ATotalRow["Avl"] = TotAvl;
            ATotalRow["MosAvl"] = TotAvlMo;
            ATotalRow["RTSB"] = TotRTSB;
            ATotalRow["InTransit"] = TotTrfOW;
            ATotalRow["OnHandExcess"] = TotOHExc;
            ATotalRow["AccumQty"] = TotAccum;
            ATotalRow["CommitQty"] = TotCommit;
            dsFixed.Tables.Add(Tots);
        }
        catch (Exception ex)
        {
            lblMessage.Text = "PreTotalFix fail " + ex.ToString();
            pnlProgress.Update();
            return null;
        }
        return dsFixed;
    }

    private void PostTotalFix()
    {
        Decimal SubAlloc = 0;
        Decimal TotAlloc = 0;
        foreach (System.Data.DataRow row in dtItemDetails.Rows)
        {
            row["Allocated"] = 0;

            if (row["LocationCode"].ToString().Trim().Length == 2 || row["LocationCode"].ToString().Substring(0, 5) == "Child")
            {
                row["Allocated"] = (decimal.Parse(lblROPFactor.Text.ToString(), NumberStyles.Number) * (decimal)row["ROP"])
                    - ((decimal)row["Avl"] + (decimal)row["InTransit"] + (decimal)row["RTSB"]);
                SubAlloc += decimal.Parse(row["Allocated"].ToString(), NumberStyles.Number);
                TotAlloc += decimal.Parse(row["Allocated"].ToString(), NumberStyles.Number);
            }
            if (row["LocationCode"].ToString().Contains("-"))
            {
                row["Allocated"] = SubAlloc;
                SubAlloc = 0;
            }
        }
        dtItemTotals.Rows[0]["Allocated"] = TotAlloc;
    }

    public void SortXFerGrid(Object sender,  DataGridSortCommandEventArgs e)
    {

        // Retrieve the data source from session state.
        dt = (DataTable)Session["XFerGridData"];

        // Create a DataView from the DataTable.
        DataView dv = new DataView(dt);

        // The DataView provides an easy way to sort. Simply set the
        // Sort property with the name of the field to sort by.
        dv.Sort = e.SortExpression;

        // Re-bind the data source and specify that it should be sorted
        // by the field specified in the SortExpression property.
        dgOther.DataSource = dv;
        dgOther.DataBind();

    }

    #endregion

    #region Branch Item Details Grid (dgItemDtl)
    protected void dgItemDtl_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        string ShipLoc = hidShippingLoc.Value.ToString().Trim();
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            TextBox txtCommit = e.Item.FindControl("txtCommit") as TextBox;
            Label lblCommit = e.Item.FindControl("lblCommit") as Label;
            Label LineLoc = e.Item.FindControl("LocID") as Label;
            if (LineLoc.Text.Contains("-"))
            {
                txtCommit.Style.Add("display", "none");
                lblCommit.Style.Add("display", "");
                e.Item.CssClass = "BluBg itemTotal ";
                for (int count = 0; count < e.Item.Cells.Count; count++)
                    e.Item.Cells[count].ForeColor = System.Drawing.Color.FromName("#CC0000"); ;
            }
            else
            {
                e.Item.Cells[6].BackColor = System.Drawing.Color.LightGreen;
                e.Item.Cells[8].BackColor = System.Drawing.Color.Yellow;
                if (LineLoc.Text.ToString().Trim() == ShipLoc)
                {
                    txtCommit.Style.Add("display", "none");
                    lblCommit.Style.Add("display", "");
                    for (int count = 0; count < e.Item.Cells.Count; count++)
                        e.Item.Cells[count].BackColor = System.Drawing.Color.Yellow; ;
                }
                else
                {
                    if (ShipLoc == "")
                    {
                        txtCommit.Style.Add("display", "none");
                        lblCommit.Style.Add("display", "");
                    }
                    else
                    {
                        txtCommit.Style.Add("display", "");
                        lblCommit.Style.Add("display", "none");
                    }
                    LineLoc.Attributes.Add("onClick", "SetShipFrom(this);");
                    LineLoc.CssClass = "BrLink";
                }
                return;
            }
        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            Label lblItmNo = e.Item.FindControl("lblItmNo") as Label;
            lblItmNo.Text = lblItemNo.Text;
            e.Item.Cells[0].ColumnSpan = 2;
            e.Item.Cells[1].Visible = false;
            e.Item.Cells[2].Text = "<span style='color:#003366;'>" + sumROP + "</span>";
            e.Item.Cells[4].Text = "<span style='color:#003366;'>" + sumAvl + "</span>";
            e.Item.Cells[5].Text = "<span style='color:#003366;'>" + sumMOH + "</span>";
            e.Item.Cells[6].Text = "<span style='color:#003366;'>" + sumRTSB + "</span>";
            e.Item.Cells[7].Text = "<span style='color:#003366;'>" + sumIntransit + "</span>";
            e.Item.Cells[8].Text = "<span style='color:#003366;'>" + sumAllocated + "</span>";
            e.Item.Cells[9].Text = "<span style='color:#003366;'>" + sumOHExc + "</span>";
            e.Item.Cells[10].Text = "<span style='color:#003366;'>" + sumAccumQty + "</span>";
            e.Item.Cells[11].Text = "<span style='color:#003366;' ID='CommitTot'>" + sumCommited + "</span>";
        }
    }

    #endregion

    #region Pager Functionality
    protected void ibtnFirst_Click(object sender, ImageClickEventArgs e)
    {
        ddlPages.SelectedIndex = 0;
        BindPageDetails();
    }

    protected void ibtnPrevious_Click(object sender, ImageClickEventArgs e)
    {
        if (ddlPages.SelectedIndex == 0)
        { }
        else
        {
            ddlPages.SelectedIndex = ddlPages.SelectedIndex - 1;
            BindPageDetails();
        }
    }

    protected void btnNext_Click(object sender, ImageClickEventArgs e)
    {
        //ScriptManager.RegisterClientScriptBlock(btnGo, typeof(Button), "debugit", "alert('" + ddlPages.SelectedIndex.ToString() + "');", true);
        if (ddlPages.SelectedIndex == ddlPages.Items.Count - 1)
        { }
        else
        {
            ddlPages.SelectedIndex = ddlPages.SelectedIndex + 1;
            BindPageDetails();
        }
    }

    protected void btnLast_Click(object sender, ImageClickEventArgs e)
    {
        ddlPages.SelectedIndex = ddlPages.Items.Count - 1;
        BindPageDetails();
    }

    protected void btnGo_Click(object sender, ImageClickEventArgs e)
    {
        if (Convert.ToInt32(txtGotoPage.Text.Trim()) >= 1 && Convert.ToInt32(txtGotoPage.Text.Trim()) <= ddlPages.Items.Count)
        {
            ddlPages.SelectedIndex = Convert.ToInt32(txtGotoPage.Text.Trim()) - 1;
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
        lblItemNo.Text = ddlPages.SelectedItem.Value.ToString();
        GetItemDetails();
    }
    #endregion

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string GetBrQtys(string Loc)
    {
        string status = Loc;
        try
        {
            //dt = XFerData.GetBranchTots(Item, Loc);
            // get the ship from totals.
            DataTable tempDt = (DataTable)Session["ItemGridData"];
            int _OHExcessQty = (int)tempDt.Compute("max(OnHandExcess)", "LocationCode='" + Loc.Trim() + "'");
            int _AccumQty = (int)tempDt.Compute("max(AccumQty)", "LocationCode='" + Loc.Trim() + "'");
            int _RemainQty = _OHExcessQty - _AccumQty;
            status = String.Format("{0:#,##0}", _OHExcessQty.ToString());
            status += ":";
            status += String.Format("{0:#,##0}", _AccumQty.ToString());
            status += ":";
            status += String.Format("{0:#,##0}", _RemainQty.ToString());
        }
        catch (Exception ex)
        {
            status = "!!GetBrQtys fail" + ex.ToString();
        }
        return status;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdCommitQty(string ToLoc, string FromLoc, string ItemNo, string NewQty)
    {
        string status = ToLoc;
        DataTable tempDt;
        try
        {
            int qty = 0;
            // update the table in the session variable to with the commit qty.
            if (int.TryParse(NewQty, out qty))
            {
                if (qty < 0)
                {
                    status = "Negative Qtys not allowed";
                }
                else
                {
                    if ((FromLoc.Trim().Length == 2) && (ToLoc.Trim().Length == 2))
                    {
                        tempDt = (DataTable)Session["ItemGridData"];
                        DataRow[] ToRow = tempDt.Select("LocationCode = '" + ToLoc + "'");
                        DataRow[] FromRow = tempDt.Select("LocationCode = '" + FromLoc + "'");
                        FromRow[0]["AccumQty"] = (int)FromRow[0]["AccumQty"] - (int)ToRow[0]["CommitQty"] + qty;
                        ToRow[0]["CommitQty"] = qty;
                        Session["ItemGridData"] = tempDt;
                        // update the ManualTransfers table
                        DataSet dtAdded = XFerData.AddXFerRecs(
                          ToLoc
                          , FromLoc
                          , ItemNo
                          , NewQty
                          , Session["UserName"].ToString()
                          );
                        status = "OK&";
                        Session["XFerGridData"] = dtAdded.Tables[0];
                        tempDt = dtAdded.Tables[0];
                        foreach (DataRow row in tempDt.Rows)
                        {
                            status += row["FromLocationCode"].ToString().Trim() + ":";
                            status += row["ToLocationCode"].ToString().Trim() + ":";
                            status += String.Format("{0:#,##0}", row["Qty"]) + ":";
                            status += String.Format("{0:MM/dd/yyyy}", row["AcceptDt"]) + ":";
                            status += row["EntryID"].ToString().Trim() + "|";
                        }
                        status += "&";
                        tempDt = dtAdded.Tables[1];
                        foreach (DataRow row in tempDt.Rows)
                        {
                            status += row["FromLocationCode"].ToString().Trim() + ":";
                            status += String.Format("{0:#,##0}", row["Qty"]) + "|";
                        }
                    }
                    
                }
                //else if (_SumCommited + qty > _ItemQty)
                //{
                //    status = "Over-Commit is not allowed.";
                //}
            }
            else
            {
                status = "Invalid Commit Qty Entered";
            }
        }
        catch (Exception ex)
        {
            status = "UpdCommitQty fail" + ex.ToString();
        }
        return status;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdAccept(string ItemNo)
    {
        string status = ItemNo;
        DataTable tempDt;
        try
        {
            tempDt = XFerData.AcceptTransfers(
             ItemNo
             , Session["UserName"].ToString()
             );
            status = "OK&";
            Session["XFerGridData"] = tempDt;
            foreach (DataRow row in tempDt.Rows)
            {
                status += row["FromLocationCode"].ToString().Trim() + ":";
                status += row["ToLocationCode"].ToString().Trim() + ":";
                status += String.Format("{0:#,##0}", row["Qty"]) + ":";
                status += String.Format("{0:MM/dd/yyyy}", row["AcceptDt"]) + ":";
                status += row["EntryID"].ToString().Trim() + "|";
            }
        }
        catch (Exception ex)
        {
            status = "UpdAccept fail" + ex.ToString();
        }
        return status;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdLockIn()
    {
        string status = "Bad";
        DataTable tempDt;
        try
        {
            dt = (DataTable)Session["XFerMasterData"];
            foreach (DataRow ItemRow in dt.Rows)
            {
                tempDt = XFerData.LockInTransfers(
                  ItemRow["ItemNo"].ToString()
                  , Session["UserName"].ToString()
                  );
                //foreach (DataRow row in tempDt.Rows)
                //{
                //    status += row["FromLocationCode"].ToString().Trim() + ":";
                //    status += row["ToLocationCode"].ToString().Trim() + ":";
                //    status += String.Format("{0:#,##0}", row["Qty"]) + ":";
                //    status += String.Format("{0:MM/dd/yyyy}", row["AcceptDt"]) + ":";
                //    status += row["EntryID"].ToString().Trim() + "|";
                //}
            }
            status = "OK";
        }
        catch (Exception ex)
        {
            status = "UpdAccept fail" + ex.ToString();
        }
        return status;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string SumCommitQty(string Loc)
    {
        string status = Loc;
        try
        {
            DataTable tempDt = (DataTable)Session["ItemGridData"];
            status = String.Format("{0:#,##0}", tempDt.Compute("Sum(AccumQty)", "LocationCode='" + Loc + "'"));
            status += ":";
            status += String.Format("{0:#,##0}", tempDt.Compute("Sum(CommitQty)", "LocationCode='" + Loc + "'"));
        }
        catch (Exception ex)
        {
            status = "!!SumCommitQty fail" + ex.ToString();
        }
        return status;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string ReleaseSoftLock(string Container)
    {
        string status = "0";
        //try
        //{
        //    DataTable tempDt = XFerData.ReleaseContainer(Container, Session["UserName"].ToString());
        //    status = "Released";
        //}
        //catch (Exception ex)
        //{
        //    status = "ReleaseSoftLock fail" + ex.ToString();
        //}
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
