/** 
 * Project Name: SOE
 * Module Name: SO Split Item
 * Author: Sathish 
 * Revision History:
 * 
 *  DATE				VERSION			AUTHOR			ACTION
 * <------------------------------------------------------------->			
 *	05/02/2011          Ver-1			Sathish		    Created
 **/

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
using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.DataAccessLayer;
using System.Data.SqlClient;

public partial class SplitItemGUI : System.Web.UI.Page
{
 
    #region Variable Declaration
    
    Utility utility = new Utility();
    SplitLines splitLine = new SplitLines();
    Common common = new Common();
    OrderEntry orderEntry = new OrderEntry();

    string pSODetailID = "";

    #endregion

    #region Page Load Event
    
    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(SplitItemGUI));
        pSODetailID = Request.QueryString["pSODetailId"].ToString();
        
        if (!Page.IsPostBack)
        {
            BindDropDown();

            DataSet dsItem =  splitLine.GetSplitLineFrmData("getdetailline",pSODetailID);
            if (dsItem != null)
                FillItemInformationFromSODetail(dsItem.Tables[0]);


            // initialize variables
            hidItemChanged.Value = "false";
            hidParentDetailId.Value = pSODetailID;
            txtPFCItemNo.Focus();
        }
    }

    #endregion

    #region Control Events

    protected void btnAddItem_Click1(object sender, ImageClickEventArgs e)
    {
        try
        {
            SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString,
                                        "[pSOESplitLineInsert]",
                                        new SqlParameter("@fSOHeaderId", Session["OrderHeaderID"].ToString()),
                                        new SqlParameter("@parentDetailId", hidParentDetailId.Value),
                                        new SqlParameter("@priceInd", lblPriceInd.Text),
                                        new SqlParameter("@pfcItemNo", txtPFCItemNo.Text),
                                        new SqlParameter("@itemDsc", lblDesc.Text),
                                        new SqlParameter("@shipLoc", ddlShipLoc.SelectedItem.Value),
                                        new SqlParameter("@costInd", hidCostInd.Value), 
                                        new SqlParameter("@priceCd", hidPriceCd.Value), 
                                        new SqlParameter("@netUnitPrice", hidNetUnitPrice.Value), 
                                        new SqlParameter("@listUnitPrice", hidListUnitPrice.Value), 
                                        new SqlParameter("@qtyAvail", lblAvailQty.Text),
                                        new SqlParameter("@reqQty", txtReqQty.Text),
                                        new SqlParameter("@sellStkUM", hidSellStkUM.Value),
                                        new SqlParameter("@avgCost", hidAvgCost.Value), 
                                        new SqlParameter("@stdCost", hidStdCost.Value), 
                                        new SqlParameter("@RplCost", hidRplCost.Value), 
                                        new SqlParameter("@oeCost", hidOECost.Value),
                                        new SqlParameter("@remark", txtLineNotes.Text),
                                        new SqlParameter("@custItemNo", lblCustItemNo.Text),
                                        new SqlParameter("@entryId", Session["UserName"].ToString()),
                                        new SqlParameter("@grossWght", hidGrossWght.Value), 
                                        new SqlParameter("@netWght", hidNetWght.Value),	    
                                        new SqlParameter("@superQty", hidSuperQty.Value), 
                                        new SqlParameter("@altUM", hidAltUM.Value),    
                                        new SqlParameter("@qtyStatus", ((decimal.Parse(txtReqQty.Text) > decimal.Parse(lblAvailQty.Text)) ? "O" : "")),
                                        new SqlParameter("@sellPrice", txtSellPrice.Text),
                                        new SqlParameter("@superUM", hidSuperUM.Value), 
                                        new SqlParameter("@carrierCd", ddlCarrierCd.SelectedItem.Value),
                                        new SqlParameter("@shipLocName", common.GetBranchName(ddlShipLoc.SelectedValue)),
                                        new SqlParameter("@freightCd", ddlFreightCd.SelectedItem.Value),
                                        new SqlParameter("@altUMQty", hidAltUMQty.Value),
                                        new SqlParameter("@sellStkUMQty", hidSellStkQty.Value),
                                        new SqlParameter("@certInd", hidCertsReqd.Value));


            ScriptManager.RegisterClientScriptBlock(btnAddItem, btnAddItem.GetType(), "refreshParent", "RefreshParent();", true);

        }
        catch (Exception ex)
        {

            throw ex;
        }
    }

    protected void btnUpdateReqQty_Click(object sender, EventArgs e)
    {

        #region If user changed the item # then recalculate price

        if (hidNetUnitPrice.Value == "")
        {
            char[] QtyArray = txtReqQty.Text.Trim().ToCharArray();
            string UOMText = "";
            string Qtytext = "";
            DataTable dt = new DataTable();
            foreach (char c in QtyArray)
            {
                if (c.Equals('-')) Qtytext += c;
                if (char.IsDigit(c)) Qtytext += c;
                if (c.Equals('.')) Qtytext += c;
                if (char.IsLetter(c)) UOMText += c;
            }
            // get the data.
            DataSet dsAvail = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEGetBrAvail]",
                      new SqlParameter("@SearchItemNo", txtPFCItemNo.Text),
                      new SqlParameter("@QtyRequested", Qtytext),
                      new SqlParameter("@QtyUOM", UOMText),
                      new SqlParameter("@PrimaryBranch", ddlShipLoc.SelectedValue.Trim()));
            if (dsAvail.Tables.Count >= 1)
            {
                if (dsAvail.Tables.Count == 1)
                {
                    if (dsAvail.Tables[0].Rows.Count > 0)
                    {
                        ShowMessage("Invalid UOM " + UOMText, false);
                        scmSplitItem.SetFocus(txtReqQty);
                        return;
                    }
                }
                else
                {
                    dsAvail.Tables[1].DefaultView.RowFilter = "Location='" + ddlShipLoc.SelectedValue.Trim() + "'";
                    dt = dsAvail.Tables[1].DefaultView.ToTable();
                    lblAvailQty.Text = (dt != null && dt.Rows.Count > 0) ? dt.Rows[0]["QOH"].ToString() : "0";
                    txtReqQty.Text = dsAvail.Tables[2].Rows[0]["QtyToSell"].ToString();
                }
            }

            // Display Pricing Information
            DataSet dsPricedetail = orderEntry.GetProductPriceDetail(Session["OrderHeaderID"].ToString(),
                                    txtPFCItemNo.Text.Trim(),
                                    Session["CustomerNumber"].ToString(),
                                    ddlShipLoc.SelectedValue,
                                    Session["OrderTableName"].ToString(),
                                    Session["DetailTableName"].ToString(),
                                    txtReqQty.Text,
                                    txtSellPrice.Text,
                                    lblPriceInd.Text,
                                    Session["CustPriceCode"].ToString());
            if (dsPricedetail != null && dsPricedetail.Tables.Count >= 1)
            {
                if (dsPricedetail.Tables.Count == 1)
                {
                    // We only go one table back, something is wrong
                    DataTable dtPrice = dsPricedetail.Tables[0];
                    if (dtPrice.Rows.Count > 0)
                    {
                        ShowMessage("Pricing problem", false);
                        scmSplitItem.SetFocus(txtPFCItemNo);
                    }
                }
                else
                {
                    if (dsPricedetail != null && dsPricedetail.Tables[1].Rows.Count > 0)
                    {
                        hidOECost.Value = dsPricedetail.Tables[1].Rows[0]["OECost"].ToString();
                        hidAltUMQty.Value = dsPricedetail.Tables[1].Rows[0]["AltUOMQty"].ToString();
                        txtSellPrice.Text = Math.Round(Convert.ToDecimal(dsPricedetail.Tables[1].Rows[0]["AltSellPrice"]), 2).ToString();
                        hidNetUnitPrice.Value = Math.Round(Convert.ToDecimal(dsPricedetail.Tables[1].Rows[0]["Price"]), 2).ToString();
                        lblPriceInd.Text = dsPricedetail.Tables[1].Rows[0]["PriceOrigin"].ToString();
                        hidAvgCost.Value = dsPricedetail.Tables[1].Rows[0]["AvgCost"].ToString();
                        hidPrevPriceValue.Value = txtSellPrice.Text;
                    }
                }
            }
        }

        #endregion

        if (txtReqQty.Text != "" && hidNetUnitPrice.Value != "")
        {
            int _reqQty = Convert.ToInt32(Math.Round(Convert.ToDecimal(txtReqQty.Text),0));
            int _sellStkQty = Convert.ToInt32(hidSellStkQty.Value);
            decimal _netUnitPrice = Convert.ToDecimal(hidNetUnitPrice.Value);
            decimal _extAmt = _netUnitPrice * _reqQty;
            decimal _extWght = Convert.ToDecimal(hidNetWght.Value) * _reqQty;

            hidAltUMQty.Value = (_sellStkQty * _reqQty).ToString();
            lblExtAmount.Text = Math.Round(_extAmt,2).ToString();
            lblExtWght.Text = Math.Round(_extWght, 2).ToString();
            txtReqQty.Text = _reqQty.ToString();
        }
        
        scmSplitItem.SetFocus(txtSellPrice);
        pnlEntry.Update();
    }

    protected void btnUpdatePrice_Click(object sender, EventArgs e)
    {
        if(txtSellPrice.Text != "")
        {
            decimal _altQty = Convert.ToDecimal(hidItemPriceQty.Value);
            decimal _sellPrice = decimal.Parse(txtSellPrice.Text);
            decimal _baseQty = decimal.Parse(hidSellStkQty.Value);
            decimal _netUnitPrice = (_altQty == 0 ? 0 : _sellPrice * _baseQty / _altQty);
            hidNetUnitPrice.Value = _netUnitPrice.ToString();

            // ReExtend Display Fields
            int _reqQty = Convert.ToInt32(txtReqQty.Text);
            decimal _extAmt = _netUnitPrice * _reqQty;            
            lblExtAmount.Text = Math.Round(_extAmt, 2).ToString();
            lblPriceInd.Text = "E";
        }

        scmSplitItem.SetFocus(ddlShipLoc);
    }

    protected void btnCheckAvail_Click(object sender, EventArgs e)
    {
        try
        {
            string status = "";
            char[] QtyArray = txtReqQty.Text.Trim().ToCharArray();
            string UOMText = "";
            string Qtytext = "";
            DataTable dt = new DataTable();
            foreach (char c in QtyArray)
            {
                if (c.Equals('-')) Qtytext += c;
                if (char.IsDigit(c)) Qtytext += c;
                if (c.Equals('.')) Qtytext += c;
                if (char.IsLetter(c)) UOMText += c;
            }
            // get the data.
            DataSet dsAvail = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEGetBrAvail]",
                      new SqlParameter("@SearchItemNo", txtPFCItemNo.Text),
                      new SqlParameter("@QtyRequested", Qtytext),
                      new SqlParameter("@QtyUOM", UOMText),
                      new SqlParameter("@PrimaryBranch", ddlShipLoc.SelectedValue.Trim()));
            if (dsAvail.Tables.Count >= 1)
            {
                if (dsAvail.Tables.Count == 1)
                {
                    if (dsAvail.Tables[0].Rows.Count > 0)
                    {
                        status = "Invalid UOM " + UOMText;
                    }
                }
                else
                {
                    dsAvail.Tables[1].DefaultView.RowFilter = "Location='" + ddlShipLoc.SelectedValue + "'";
                    dt = dsAvail.Tables[1].DefaultView.ToTable();

                    lblAvailQty.Text = (dt.Rows.Count == 0 ? "0" : dt.Rows[0]["QOH"].ToString());  

                    if (Convert.ToDecimal((dt != null && dt.Rows.Count > 0) ? dt.Rows[0]["QOH"].ToString() : "0") < Convert.ToDecimal(dsAvail.Tables[2].Rows[0]["QtyToSell"].ToString()))
                    {
                        ScriptManager.RegisterClientScriptBlock(btnCheckAvail, btnCheckAvail.GetType(), "AvailAlert", "AvailabilityAlter();", true);                                              
                    }
                   
                }
            }            
        }
        catch (Exception ex)
        {            
            throw;
        }
    }

    #endregion

    #region Developer Code

    private void BindDropDown()
    {
        DataSet dsResult = splitLine.GetSplitLineFrmData("filldropdowns", "");
        if (dsResult != null)
            utility.BindListControls(ddlShipLoc, "LocDesc", "LocID", dsResult.Tables[0]);

        //Bind Carrier Cd
        utility.BindListControls(ddlCarrierCd, "Name", "Code", dsResult.Tables[1]);


        //Bind Carrier Cd
        utility.BindListControls(ddlFreightCd, "Name", "Code", dsResult.Tables[2]);

    }

    private void FillItemInformationFromSODetail(DataTable dtItem)
    {
        txtPFCItemNo.Text = dtItem.Rows[0]["ItemNo"].ToString();
        hiPreviousItemNo.Value = dtItem.Rows[0]["ItemNo"].ToString();
        lblCustItemNo.Text = dtItem.Rows[0]["CustItemNo"].ToString();
        lblDesc.Text = dtItem.Rows[0]["ItemDsc"].ToString();
        txtReqQty.Text = dtItem.Rows[0]["QtyOrdered"].ToString();
        lblBaseQtyUM.Text = dtItem.Rows[0]["BaseQtyUM"].ToString();
        lblAvailQty.Text = dtItem.Rows[0]["QtyAvail"].ToString();
        txtSellPrice.Text = dtItem.Rows[0]["SellPrice"].ToString();
        lblSellUnit.Text = dtItem.Rows[0]["SellUM"].ToString();
        lblPriceInd.Text = dtItem.Rows[0]["LinePriceInd"].ToString();
        utility.HighlightDropdownValue(ddlShipLoc, dtItem.Rows[0]["LocID"].ToString());
        utility.HighlightDropdownValue(ddlCarrierCd, dtItem.Rows[0]["CarrierCd"].ToString());
        utility.HighlightDropdownValue(ddlFreightCd, dtItem.Rows[0]["FreightCd"].ToString());
        lblExtAmount.Text = dtItem.Rows[0]["ExtendedPrice"].ToString();
        lblExtWght.Text = dtItem.Rows[0]["ExtendedNetWght"].ToString();
        lblSuperQty.Text = dtItem.Rows[0]["SuperQtyUM"].ToString();
        txtLineNotes.Text = dtItem.Rows[0]["Remark"].ToString();
        lblSchShipDt.Text = dtItem.Rows[0]["RqstdShipDt"].ToString();

        hidSellStkUM.Value = dtItem.Rows[0]["BaseUM"].ToString();
        hidSellStkQty.Value = dtItem.Rows[0]["BaseQty"].ToString();
        hidCostInd.Value = dtItem.Rows[0]["CostInd"].ToString();
        hidPriceCd.Value = dtItem.Rows[0]["PriceCd"].ToString();
        hidNetUnitPrice.Value = dtItem.Rows[0]["NetUnitPrice"].ToString();
        hidListUnitPrice.Value = dtItem.Rows[0]["ListUnitPrice"].ToString();
        hidAvgCost.Value = dtItem.Rows[0]["AvgCost"].ToString();
        hidStdCost.Value = dtItem.Rows[0]["StdCost"].ToString();
        hidRplCost.Value = dtItem.Rows[0]["RplCost"].ToString();
        hidOECost.Value = dtItem.Rows[0]["OECost"].ToString();
        hidGrossWght.Value = dtItem.Rows[0]["GrossWght"].ToString();
        hidNetWght.Value = dtItem.Rows[0]["NetWght"].ToString();
        hidSuperQty.Value = dtItem.Rows[0]["SuperQty"].ToString();
        hidAltUM.Value = dtItem.Rows[0]["SellUM"].ToString();
        hidSuperUM.Value = dtItem.Rows[0]["SuperUM"].ToString();
        hidAltUMQty.Value = dtItem.Rows[0]["AlternateUMQty"].ToString();
        hidIsDeletedItem.Value = dtItem.Rows[0]["DeletedItem"].ToString();
        hidCertsReqd.Value = dtItem.Rows[0]["CertRequiredInd"].ToString();
        hidPrevPriceValue.Value = txtSellPrice.Text;
        // We need AltUOMQty if user changed the sell price
        FillItemInformationFfromItemMaster();
    }

    private void FillItemInformationFfromItemMaster()
    {
        DataSet dsPricedetail = orderEntry.GetProductPriceDetail(Session["OrderHeaderID"].ToString(),
                                txtPFCItemNo.Text,
                                Session["CustomerNumber"].ToString(),
                                ddlShipLoc.SelectedValue,
                                Session["OrderTableName"].ToString(),
                                Session["DetailTableName"].ToString(),
                                txtReqQty.Text.ToString(),
                                txtSellPrice.Text,
                                "E",
                                Session["CustPriceCode"].ToString());

        if (dsPricedetail != null && dsPricedetail.Tables[1].Rows.Count > 0)
        {
            hidItemPriceQty.Value = dsPricedetail.Tables[1].Rows[0]["AltUOMQty"].ToString();
        }

    }

    private void ShowMessage(string message, bool isValid)
    {
        lblMessage.ForeColor = (isValid) ? System.Drawing.Color.Green : System.Drawing.Color.Red;
        lblMessage.Text = message;
        pnlButton.Update();
    }

    #endregion

    #region Item Number Logic

    string itemType = "PFC";

    protected void btnPFCItem_Click(object sender, EventArgs e)
    {
        itemType = "PFC";
        btnItemNo_Click(btnPFCItem, new EventArgs());
    }

    protected void btnCustItem_Click(object sender, EventArgs e)
    {
        hiPreviousItemNo.Value = txtPFCItemNo.Text;
        itemType = "Alias";
        btnItemNo_Click(btnCustItem, new EventArgs());
    }

    protected void btnItemNo_Click(object sender, EventArgs e)
    {
        hiPreviousItemNo.Value = txtPFCItemNo.Text;

        if (txtPFCItemNo.Text.Trim() != "")
        {
            DataSet dsItemDetail =  orderEntry.GetProductInfo(txtPFCItemNo.Text.Trim(), 
                                    Session["CustomerNumber"].ToString(), 
                                    ddlShipLoc.SelectedValue, 
                                    itemType);
            ClearCommandLine();

            if (dsItemDetail.Tables.Count >= 1)
            {
                if (dsItemDetail.Tables.Count == 1)
                {
                    // We only go one table back, something is wrong
                    DataTable dt = dsItemDetail.Tables[0];

                    if (dt.Rows.Count > 0)
                    {
                        if (dt.Rows[0]["ErrorType"].ToString().Trim() + dt.Rows[0]["ErrorCode"].ToString() == "E0022")
                        {
                            ShowMessage("Item not stocked at any Branch. This item cannot be sold.", false);
                            scmSplitItem.SetFocus(txtPFCItemNo);
                        }
                        else
                        {
                            ShowMessage(txtPFCItemNo.Text + " Alias for " + Session["CustomerNumber"].ToString() + " not on file.", false);
                            scmSplitItem.SetFocus(txtPFCItemNo);
                        }
                    }
                }
                else
                {
                    // Display Item Information
                    DataTable dtItemDetail = dsItemDetail.Tables[1].DefaultView.ToTable();
                    txtPFCItemNo.Text = dtItemDetail.Rows[0]["FoundItem"].ToString();
                    hiPreviousItemNo.Value = dtItemDetail.Rows[0]["FoundItem"].ToString();
                    lblDesc.Text = dtItemDetail.Rows[0]["ItemDesc"].ToString();
                    lblBaseQtyUM.Text = dtItemDetail.Rows[0]["ItemQty"].ToString() + "/" + dtItemDetail.Rows[0]["ItemUOM"].ToString();
                    lblSuperQty.Text = dtItemDetail.Rows[0]["SuperQty"].ToString() + "/" + dtItemDetail.Rows[0]["SuperUM"].ToString();
                    lblSellUnit.Text = dtItemDetail.Rows[0]["AltPriceUM"].ToString();
                    hidSellStkQty.Value = dtItemDetail.Rows[0]["ItemQty"].ToString();
                    hidCertsReqd.Value = dtItemDetail.Rows[0]["CertRequiredInd"].ToString();
                    lblPriceInd.Text = "";

                    if (dtItemDetail.Rows[0]["CustItem"].ToString().Trim() != "No Alias")
                    {
                        lblCustItemNo.Text = dtItemDetail.Rows[0]["CustItem"].ToString();                        
                    }
                    
                    hidRplCost.Value = String.Format("{0:0.000}", dtItemDetail.Rows[0]["ReplacementCost"]);
                    hidStdCost.Value = String.Format("{0:0.000}", dtItemDetail.Rows[0]["StdCost"]);
                    hidListUnitPrice.Value = String.Format("{0:0.000}", dtItemDetail.Rows[0]["ListPrice"]);
                    hidGrossWght.Value = String.Format("{0:0.00}", dtItemDetail.Rows[0]["GrossWght"]);
                    hidNetWght.Value = String.Format("{0:0.00}", dtItemDetail.Rows[0]["Wght"]);
                    
                    scmSplitItem.SetFocus(txtReqQty);
                }
            }
            else
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Invalid Item Number";
                ClearCommandLine();
                scmSplitItem.SetFocus(txtPFCItemNo);
                pnlButton.Update();
            }
        }
        else
        {
            scmSplitItem.SetFocus(txtReqQty);
            ClearCommandLine();
        }
    }

    private void ClearCommandLine()
    {
        lblCustItemNo.Text = "";
        txtReqQty.Text = "";
        lblBaseQtyUM.Text = "";
        lblAvailQty.Text = "";
        txtSellPrice.Text = "";
        lblSellUnit.Text = "";
        lblPriceInd.Text = "";
        lblExtAmount.Text = "0.00";
        lblExtWght.Text = "0.00";
        lblSuperQty.Text = "";        
        txtLineNotes.Text = "";
        hidNetUnitPrice.Value = "";
        hidPrevPriceValue.Value = "";
    }

    #endregion

    

}
