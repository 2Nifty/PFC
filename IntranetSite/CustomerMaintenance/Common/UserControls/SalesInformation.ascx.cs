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

using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;

namespace PFC.Intranet.Maintenance
{
    public partial class SalesDetails : System.Web.UI.UserControl
    {
        CustomerMaintenance customerDetails = new CustomerMaintenance();
        ddlBind _ddlBind = new ddlBind();
        private DataTable dtValues = new DataTable();

        #region Property Bags

        public string CustomerID
        {
            set
            {
                hidCustomerID.Value = value;
                BindControls();
            }
            get
            {
                return hidCustomerID.Value;
            }
        }

        #endregion

        #region Control Events

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
              BindDropDownList();
            }
            
            if (Session["SecurityCode"].ToString().Trim() != "" && Session["CustomerLock"].ToString().Trim() != "L")
                ibtnSave.Visible = true;
            else
                ibtnSave.Visible = false;
        }

        private void BindDropDownList()
        {
            customerDetails.BindListControls(ddlIMLocation, "ListDesc", "ListValue", customerDetails.GetLocationList(), "-- Select --");
            customerDetails.BindListControls(ddlAbcCode, "ListDesc", "ListValue", customerDetails.GetListDetails("CustSlsRank"), "-- Select --");
            customerDetails.BindListControls(ddlPriceCode, "ListDesc", "ListValue", customerDetails.GetListDetails("CustPriceCd"), "-- Select --");
            customerDetails.BindListControls(ddlChainCode, "ListDesc", "ListValue", customerDetails.GetChainDetails(), "-- Select --");
            customerDetails.BindListControls(ddlCustomerType, "ListDesc", "ListValue", customerDetails.GetListDetails("CustType"), "-- Select --");
            customerDetails.BindListControls(ddlcSchedule1, "ListValue", "ListValue", customerDetails.GetListDetails("CustContractSchd1"), "-- Select --");
            DataTable dtCustomerContractSchd = customerDetails.GetListDetails("CustContractSchd");
            customerDetails.BindListControls(ddlcSchedule2, "ListValue", "ListValue", dtCustomerContractSchd, "-- Select --");
            customerDetails.BindListControls(ddlcSchedule3, "ListValue", "ListValue", dtCustomerContractSchd, "-- Select --");
            customerDetails.BindListControls(ddlcSchedule4, "ListValue", "ListValue", dtCustomerContractSchd, "-- Select --");
            customerDetails.BindListControls(ddlcSchedule5, "ListValue", "ListValue", dtCustomerContractSchd, "-- Select --");
            customerDetails.BindListControls(ddlcSchedule6, "ListValue", "ListValue", dtCustomerContractSchd, "-- Select --");
            customerDetails.BindListControls(ddlcSchedule7, "ListValue", "ListValue", dtCustomerContractSchd, "-- Select --");
            customerDetails.BindListControls(ddlSODocSort, "ListDesc", "ListValue", customerDetails.GetListDetails("SODocSortInd"), "-- Select --");
            customerDetails.BindListControls(ddlCustDefPrice, "ListDesc", "ListValue", customerDetails.GetListDetails("CustDefPriceSchd"), "-- Select --");
            customerDetails.BindListControls(ddlCustPriceInd, "ListDesc", "ListValue", customerDetails.GetListDetails("CustPriceInd"), "-- Select --");
            customerDetails.BindListControls(ddlSerialCode, "ListDesc", "ListValue", customerDetails.GetListDetails("YesNoInd"), "-- Select --");
            customerDetails.BindListControls(ddlTypeOrder, "ListDesc", "ListValue", customerDetails.GetListDetails("SOEOrderTypes"), "-- Select --");
            customerDetails.BindListControls(ddlShippingTerms, "ListDesc", "ListValue", customerDetails.GetListDetails("ShipTermsCode"), "-- Select --");
            customerDetails.BindListControls(ddlReasonCode, "ListDesc", "ListValue", customerDetails.GetTableValues("REAS"), "-- Select --");
            customerDetails.BindListControls(ddlClassTrade, "ListDesc", "ListValue", customerDetails.GetTableValues("TRD"), "-- Select --");
            customerDetails.BindListControls(ddlRegion, "ListDesc", "ListValue", customerDetails.GetListDetails("SOEOrderTypes"), "-- Select --");
            customerDetails.BindListControls(ddlSalesOrganization, "ListDesc", "ListValue", customerDetails.GetLocationList(), "-- Select --");
            customerDetails.BindListControls(ddlTerritory, "ListDesc", "ListValue", customerDetails.GetListDetails("SalesTerritory"), "-- Select --");
            customerDetails.BindListControls(ddlSalesRep, "ListDesc", "ListValue", customerDetails.GetSalesRep(), "-- Select --");
            customerDetails.BindListControls(ddlcSupportRep, "ListDesc", "ListValue", customerDetails.GetSalesRep(), "-- Select --");
            customerDetails.BindListControls(ddlSalesRank, "ListDesc", "ListValue", customerDetails.GetListDetails("CustSlsRank"), "-- Select --");
            customerDetails.BindListControls(ddlInvoiceIns, "ListDesc", "ListValue", customerDetails.GetListDetails("InvoiceInstr"), "-- Select --");
            customerDetails.BindListControls(ddlInvDelivery, "ListDesc", "ListValue", customerDetails.GetListDetails("InvDeliveryInd"), "-- Select --");
            customerDetails.BindListControls(ddlDiscountType, "ListDesc", "ListValue", customerDetails.GetListDetails("SalesDiscType"), "-- Select --");
            customerDetails.BindListControls(ddlBuyGroup, "ListDesc", "ListValue", customerDetails.GetListDetails("BuyGrp"), "-- Select --");
            customerDetails.BindListControls(ddlRebateGroup, "ListDesc", "ListValue", customerDetails.GetListDetails("CustRebateGrp"), "-- Select --");
            customerDetails.BindListControls(ddlLOB, "ListDesc", "ListValue", customerDetails.GetListDetails("CustSalesLOB"), "-- Select --");
            customerDetails.BindListControls(ddlSIC, "ListDesc", "ListValue", customerDetails.GetListDetails("CustSalesSIC"), "-- Select --");
            //customerDetails.BindListControls(ddlCertsInd, "ListDesc", "ListValue", customerDetails.GetListDetails("CertsRequiredInd"), "-- Select --");
            _ddlBind.BindFromList("CertsRequiredInd", ddlCertsInd, "", "-- Select --");
        }

        private void BindControls()
        {
            dtValues = customerDetails.GetCustomerDetail(CustomerID);
            if (dtValues != null && dtValues.Rows.Count > 0)
            {
                dpLastPurchaseDate.SelectedDate = (dtValues.Rows[0]["SoldSinceDt"].ToString() == "") ? "" : Convert.ToDateTime(dtValues.Rows[0]["SoldSinceDt"].ToString()).ToShortDateString();
                dpFirstActivity.SelectedDate = (dtValues.Rows[0]["FirstActivityDt"].ToString() == "") ? "" : Convert.ToDateTime(dtValues.Rows[0]["FirstActivityDt"].ToString()).ToShortDateString();
                customerDetails.SetValueListControl(ddlIMLocation, dtValues.Rows[0]["CustShipLocation"].ToString());
                customerDetails.SetValueListControl(ddlAbcCode, dtValues.Rows[0]["ABCCd"].ToString());
                customerDetails.SetValueListControl(ddlPriceCode, dtValues.Rows[0]["PriceCd"].ToString());
                customerDetails.SetValueListControl(ddlChainCode, dtValues.Rows[0]["ChainCd"].ToString());
                customerDetails.SetValueListControl(ddlCustomerType, dtValues.Rows[0]["CustType"].ToString());
                txtContractNo.Text = dtValues.Rows[0]["ContractNo"].ToString();
                customerDetails.SetValueListControl(ddlcSchedule1, dtValues.Rows[0]["ContractSchd1"].ToString());
                customerDetails.SetValueListControl(ddlcSchedule2, dtValues.Rows[0]["ContractSchd2"].ToString());
                customerDetails.SetValueListControl(ddlcSchedule3, dtValues.Rows[0]["ContractSchd3"].ToString());
                customerDetails.SetValueListControl(ddlcSchedule4, dtValues.Rows[0]["ContractSchedule4"].ToString());
                customerDetails.SetValueListControl(ddlcSchedule5, dtValues.Rows[0]["ContractSchedule5"].ToString());
                customerDetails.SetValueListControl(ddlcSchedule6, dtValues.Rows[0]["ContractSchedule6"].ToString());
                customerDetails.SetValueListControl(ddlcSchedule7, dtValues.Rows[0]["ContractSchedule7"].ToString());
                customerDetails.SetValueListControl(ddlSODocSort, dtValues.Rows[0]["SODocSortInd"].ToString().Trim());
                customerDetails.SetValueListControl(ddlCustDefPrice, dtValues.Rows[0]["CustomerDefaultPrice"].ToString());
                customerDetails.SetValueListControl(ddlCustPriceInd, dtValues.Rows[0]["CustomerPriceInd"].ToString());
                txtWebDiscPct.Text = String.Format("{0:0.00}", dtValues.Rows[0]["WebDiscountPct"]);
                chkWebDiscInd.Checked = (dtValues.Rows[0]["WebDiscountInd"].ToString().ToUpper().Trim() == "1");
                txtIRSEINNo.Text = dtValues.Rows[0]["IRSEINNo"].ToString();
                customerDetails.SetValueListControl(ddlSerialCode, dtValues.Rows[0]["SerialNoCd"].ToString());
                customerDetails.SetValueListControl(ddlTypeOrder, dtValues.Rows[0]["TypeofOrder"].ToString());
                customerDetails.SetValueListControl(ddlShippingTerms, dtValues.Rows[0]["ShipTermsCd"].ToString());
                customerDetails.SetValueListControl(ddlReasonCode, dtValues.Rows[0]["ReasonCd"].ToString());
                customerDetails.SetValueListControl(ddlClassTrade, dtValues.Rows[0]["CLTradeCd"].ToString());
                customerDetails.SetValueListControl(ddlRegion, dtValues.Rows[0]["CustReg"].ToString());
                customerDetails.SetValueListControl(ddlSalesOrganization, dtValues.Rows[0]["SalesOrgNo"].ToString());
                customerDetails.SetValueListControl(ddlTerritory, dtValues.Rows[0]["SalesTerritory"].ToString());
                customerDetails.SetValueListControl(ddlSalesRep, dtValues.Rows[0]["SlsRepNo"].ToString());
                customerDetails.SetValueListControl(ddlcSupportRep, dtValues.Rows[0]["SupportRepNo"].ToString());
                customerDetails.SetValueListControl(ddlSalesRank, dtValues.Rows[0]["CustSlsRank"].ToString());
                customerDetails.SetValueListControl(ddlInvoiceIns, dtValues.Rows[0]["InvInstr"].ToString());
                customerDetails.SetValueListControl(ddlInvDelivery, dtValues.Rows[0]["InvDeliveryInd"].ToString());
                customerDetails.SetValueListControl(ddlDiscountType, dtValues.Rows[0]["DiscTypeCd"].ToString());
                customerDetails.SetValueListControl(ddlBuyGroup, dtValues.Rows[0]["BuyGroup"].ToString());
                customerDetails.SetValueListControl(ddlRebateGroup, dtValues.Rows[0]["RebateGroup"].ToString());
                txtMinBillingAmt.Text = dtValues.Rows[0]["MinBillAmt"].ToString();
                customerDetails.SetValueListControl(ddlLOB, dtValues.Rows[0]["LOB"].ToString());
                customerDetails.SetValueListControl(ddlSIC, dtValues.Rows[0]["SIC"].ToString());
                chkList.Items[0].Selected = (dtValues.Rows[0]["NetPriceInd"].ToString().ToUpper().Trim() == "Y");
                chkList.Items[1].Selected = (dtValues.Rows[0]["NextPriceInd"].ToString().ToUpper().Trim() == "Y");
                chkList.Items[2].Selected = (dtValues.Rows[0]["NickelSurChrgInd"].ToString().ToUpper().Trim() == "Y");
                chkList2.Items[0].Selected = (dtValues.Rows[0]["PORequiredInd"].ToString().ToUpper().Trim() == "1");
                //chkList2.Items[1].Selected = (dtValues.Rows[0]["CertRequiredInd"].ToString().ToUpper().Trim() == "1");
                customerDetails.SetValueListControl(ddlCertsInd, dtValues.Rows[0]["CertRequiredInd"].ToString());

            }
            else
            {
                ClearControl();
            }
        }
        private void ClearControl()
        {
            txtContractNo.Text = "";
            dpFirstActivity.SelectedDate = "";
            dpLastPurchaseDate.SelectedDate = "";
            txtWebDiscPct.Text = "";
            txtIRSEINNo.Text = "";
            txtMinBillingAmt.Text = "";
            chkWebDiscInd.Checked = false;
            for (int count = 0; count < chkList.Items.Count; count++)
                chkList.Items[count].Selected = false;
            for (int count = 0; count < chkList2.Items.Count; count++)
                chkList2.Items[count].Selected = false;
        }
        /// <summary>
        /// Code to insert the vendor address details
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ibtnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    string updateString = "ContractNo='" + txtContractNo.Text + "'," +
                                            "PriceCd='" + ddlPriceCode.SelectedValue.Trim() + "'," +
                                            "FirstActivityDt='" + dpFirstActivity.SelectedDate + "'," +
                                            "SoldSinceDt='" + dpLastPurchaseDate.SelectedDate + "'," +
                                            "MinBillAmt=" + ((txtMinBillingAmt.Text == "") ? "null" : "'" + txtMinBillingAmt.Text + "'") + "," +
                                            "CustSlsRank='" + ddlSalesRank.SelectedValue.Trim() + "'," +
                                            "ABCCd='" + ddlAbcCode.SelectedValue.Trim() + "'," +
                                            "ChainCd='" + ddlChainCode.SelectedValue.Trim() + "'," +
                                            "CLTradeCd='" + ddlClassTrade.SelectedValue.Trim() + "'," +
                                            "ContractSchd1='" + ddlcSchedule1.SelectedValue.Trim() + "'," +
                                            "ContractSchd2='" + ddlcSchedule2.SelectedValue.Trim() + "'," +
                                            "ContractSchd3='" + ddlcSchedule3.SelectedValue.Trim() + "'," +
                                            "ContractSchedule4='" + ddlcSchedule4.SelectedValue.Trim() + "'," +
                                            "ContractSchedule5='" + ddlcSchedule5.SelectedValue.Trim() + "'," +
                                            "ContractSchedule6='" + ddlcSchedule6.SelectedValue.Trim() + "'," +
                                            "ContractSchedule7='" + ddlcSchedule7.SelectedValue.Trim() + "'," +
                                            "CustomerDefaultPrice='" + ddlCustDefPrice.SelectedValue.Trim() + "'," +
                                            "CustomerPriceInd='" + ddlCustPriceInd.SelectedValue.Trim() + "'," +
                                            "WebDiscountPct='" + ((txtWebDiscPct.Text != "") ? txtWebDiscPct.Text : "0") + "'," +
                                            "WebDiscountInd='" + ((chkWebDiscInd.Checked) ? "1" : "0") + "'," +
                                            "SODocSortInd='" + ddlSODocSort.SelectedValue.Trim() + "'," +
                                            "IRSEINNo='" + txtIRSEINNo.Text + "'," +
                                            "SupportRepNo='" + ddlcSupportRep.SelectedValue.Trim() + "'," +
                                            "CustType='" + ddlCustomerType.SelectedValue.Trim() + "'," +
                                            "DiscTypeCd='" + ddlDiscountType.SelectedValue.Trim() + "'," +
                                            "CustShipLocation='" + ddlIMLocation.SelectedValue.Trim() + "'," +
                                            "InvInstr='" + ddlInvoiceIns.SelectedValue.Trim() + "'," +
                                            "InvDeliveryInd='" + ddlInvDelivery.SelectedValue.Trim() + "'," +
                                            "BuyGroup='" + ddlBuyGroup.SelectedValue.Trim() + "'," +
                                            "RebateGroup='" + ddlRebateGroup.SelectedValue.Trim() + "'," +
                                            "LOB='" + ddlLOB.SelectedValue.Trim() + "'," +
                                            "ReasonCd='" + ddlReasonCode.SelectedValue.Trim() + "'," +
                                            "CustReg='" + ddlRegion.SelectedValue.Trim() + "'," +
                                            "SalesOrgNo='" + ddlSalesOrganization.SelectedValue.Trim() + "'," +
                                            "SlsRepNo='" + ddlSalesRep.SelectedValue.Trim() + "'," +
                                            "SerialNoCd='" + ddlSerialCode.SelectedValue.Trim() + "'," +
                                            "ShipTermsCd='" + ddlShippingTerms.SelectedValue.Trim() + "'," +
                                            "SIC='" + ddlSIC.SelectedValue.Trim() + "'," +
                                            "SalesTerritory='" + ddlTerritory.SelectedValue.Trim() + "'," +
                                            "TypeofOrder='" + ddlTypeOrder.SelectedValue.Trim() + "'," +                                         
                                            "NetPriceInd='" + ((chkList.Items[0].Selected) ? "Y" : "N") + "'," +
                                            "NextPriceInd='" + ((chkList.Items[1].Selected) ? "Y" : "N") + "'," +
                                            "NickelSurChrgInd='" + ((chkList.Items[2].Selected) ? "Y" : "N") + "'," +
                                            "PORequiredInd='" + ((chkList2.Items[0].Selected) ? "1" : "0") + "'," +
                                            "CertRequiredInd='" + ddlCertsInd.SelectedValue + "'," +                     
                                            "ChangeDt='" + DateTime.Now.ToShortDateString() + "'," +
                                            "ChangeID='" + Session["UserName"].ToString().Replace("'", "''") + "'";
                    
                    customerDetails.UpdateCustomerDetails(updateString, CustomerID);

                    // Update Change Dt & ID in header section
                    AddressHeader customerHeader = this.Parent.FindControl("ucCustomerHeader") as AddressHeader;                    
                    customerHeader.SetChangeIDAndDt();

                    UpdatePanel pnHeaderDetails = this.Parent.FindControl("pnHeaderDetails") as UpdatePanel;                    
                    pnHeaderDetails.Update();
                }
                catch (Exception ex) { throw ex; }
            }
        }
        protected void ibtnCancel_Click(object sender, ImageClickEventArgs e)
        {
            ClearControl();
        }

        protected void txtWebDiscPct_TextChanged(object sender, EventArgs e)
        {
            txtWebDiscPct.Text = Convert.ToString(Math.Round(Convert.ToDecimal(txtWebDiscPct.Text), 2));
        }

        #endregion
} 
}
