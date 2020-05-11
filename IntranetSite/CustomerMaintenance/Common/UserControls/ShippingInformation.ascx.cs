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
    public partial class ShippingDetails : System.Web.UI.UserControl
    {

        CustomerMaintenance customerDetails = new CustomerMaintenance();

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
            //ScriptManager.RegisterClientScriptBlock(txtASNFormat, txtASNFormat.GetType(), "ASNFormat", "alert('" + Session["CustomerLock"].ToString().Trim() + ".');", true);
            if (Session["SecurityCode"].ToString().Trim() != "" && Session["CustomerLock"].ToString().Trim() != "L")
                ibtnSave.Visible = true;
            else
                ibtnSave.Visible = false;
        }

        private void BindDropDownList()
        {
            customerDetails.BindListControls(ddlConsolidationMethod, "ListDesc", "ListValue", customerDetails.GetListDetails("ConsolMethCd"), "-- Select --");
            customerDetails.BindListControls(ddlShippingInstruction, "ListDesc", "ListValue", customerDetails.GetListDetails("ShipInstr"), "-- Select --");
            customerDetails.BindListControls(ddlSortOrder, "ListDesc", "ListValue", customerDetails.GetListDetails("YesNoInd"), "-- Select --");
            customerDetails.BindListControls(ddlCarrier, "ListDesc", "ListValue", customerDetails.GetTableValues("CAR"), "-- Select --");

            customerDetails.BindListControls(ddlExpedite, "ListDesc", "ListValue", customerDetails.GetTableValues("EXPD"), "-- Select --");
            customerDetails.BindListControls(ddlMethod, "ListDesc", "ListValue", customerDetails.GetTableValues("CAR"), "-- Select --");
            customerDetails.BindListControls(ddlPriority, "ListDesc", "ListValue", customerDetails.GetTableValues("PRI"), "-- Select --");

            customerDetails.BindListControls(ddlShippingLoc, "ListDesc", "ListValue", customerDetails.GetLocationList(), "-- Select --");
            customerDetails.BindListControls(ddlUsageLoc, "ListDesc", "ListValue", customerDetails.GetLocationList(), "-- Select --");
            customerDetails.BindListControls(ddlTrfLoc, "ListDesc", "ListValue", customerDetails.GetLocationList(), "-- Select --");  
        }
        private void BindControls()
        {

            // Unknown ZeroBalanceMo,SurchrgInd

            //"[pCustMstrID],[CustNo],[CustName],[AltCustName],[SortName],[CustSearchKey],[CustSlsRank],[IMLoc],
            //[fBillToNo],[ARGLAcctID],[CustType],[ContractNo],[DunsNo],[DunsRating],[Territory],[CustReg],
            //[SalesOrgNo],[SlsRepNo],[SupportRepNo],[ResaleNo],[UPSNo],[TaxStat],[CreditInd],[SummBillInd],
            //[CycBillInd],[DunInd],[BackOrderInd],[CreditAppInd],[CreditRvwInd],[NetPriceInd],[NextPriceInd],
            //[AllowSubsInd],[AllowPartialsInd],[AllowDelProofInd],[AllowPTLInd],[ASNInd],[DelinqInd],[ChgBackInd],
            //[NickelSurChrgInd],[EDI870Ind],[FinChrgInd],[StmtCopies],[InvCopies],[CashStatus],[InvSortOrd],
            //[TaxCd],[CustCd],[ReasonCd],[CLTradeCd],[PriorityCd],[ExpediteCd],[ShipMethCd],[ShipViaCd],
            //[ShipTermsCd],[TradeTermCd],[ConsMethCd],[DateCdLimit],[SerialNoCd],[MultiTaxCd],[CashDiscCd],
            //[GLPostCd],[DiscTypeCd],[SIC],[LOB],[Rebate],[InvInstr],[ShipInstr],[CreditLmt],[FirstActivityDt],
            //[CreditRvwDT],[SoldSinceDt],[WriteOffDt],[DeleteDt],[LateChrgPct],[ContractSchd1],[ContractSchd2],
            //[ContractSchd3],[MinBillAmt],[SvcChrgMo],[ZeroBalMo],[SpecialLbl],[ASNFormat],[TypeofOrder],
            //[EntryID],[EntryDt],[ChangeID],[ChangeDt],[StatusCd],[ABCCd],[ChainCd],[PriceCd]";

            dtValues = customerDetails.GetCustomerDetail(CustomerID);
            if (dtValues != null && dtValues.Rows.Count > 0)
            {
                txtASNFormat.Text = dtValues.Rows[0]["ASNFormat"].ToString();
                txtSpecialLabel.Text = dtValues.Rows[0]["SpecialLbl"].ToString();
                txtUPSAccount.Text = dtValues.Rows[0]["UPSNo"].ToString();


                customerDetails.SetValueListControl(ddlCarrier, dtValues.Rows[0]["ShipViaCd"].ToString());
                customerDetails.SetValueListControl(ddlConsolidationMethod, dtValues.Rows[0]["ConsMethCd"].ToString());
                customerDetails.SetValueListControl(ddlExpedite, dtValues.Rows[0]["ExpediteCd"].ToString());
                customerDetails.SetValueListControl(ddlMethod, dtValues.Rows[0]["ShipMethCd"].ToString());
                customerDetails.SetValueListControl(ddlPriority, dtValues.Rows[0]["PriorityCd"].ToString());
                customerDetails.SetValueListControl(ddlShippingInstruction, dtValues.Rows[0]["ShipInstr"].ToString());
                customerDetails.SetValueListControl(ddlSortOrder, dtValues.Rows[0]["InvSortOrd"].ToString());
                customerDetails.SetValueListControl(ddlShippingLoc, dtValues.Rows[0]["ShipLocation"].ToString());
                customerDetails.SetValueListControl(ddlUsageLoc, dtValues.Rows[0]["UsageLocation"].ToString());
                customerDetails.SetValueListControl(ddlTrfLoc, dtValues.Rows[0]["TransferLocation"].ToString());

                chkList.Items[0].Selected = (dtValues.Rows[0]["AllowDelProofInd"].ToString().ToUpper().Trim() == "Y");
                chkList.Items[1].Selected = (dtValues.Rows[0]["AllowPartialsInd"].ToString().ToUpper().Trim() == "Y");
                chkList.Items[2].Selected = (dtValues.Rows[0]["AllowSubsInd"].ToString().ToUpper().Trim() == "Y");
                chkList.Items[3].Selected = (dtValues.Rows[0]["ASNInd"].ToString().ToUpper().Trim() == "Y");

                chkList2.Items[0].Selected = (dtValues.Rows[0]["BackOrderInd"].ToString().ToUpper().Trim() == "Y");
                chkList2.Items[1].Selected = (dtValues.Rows[0]["EDI870Ind"].ToString().ToUpper().Trim() == "Y");
                chkList2.Items[2].Selected = (dtValues.Rows[0]["ResidentialDeliveryInd"].ToString().ToUpper().Trim() == "1");
                chkList2.Items[3].Selected = (dtValues.Rows[0]["PackSlipRequired"].ToString().ToUpper().Trim() == "Y");
            }
            else
            {
                ClearControl();
            }
        }
        private void ClearControl()
        {
            txtASNFormat.Text = "";
            txtSpecialLabel.Text = "";
            txtUPSAccount.Text = "";        
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
                    string updateString =   "ASNFormat='" + txtASNFormat.Text.Replace("'", "''") + "'," +
                                            "SpecialLbl='" + txtSpecialLabel.Text.Replace("'", "''") + "'," +
                                            "UPSNo='" + txtUPSAccount.Text.Replace("'", "''") + "'," +
                                            "ShipViaCd='" + ddlCarrier.SelectedValue.Trim() + "'," +
                                            "ConsMethCd='" + ddlConsolidationMethod.SelectedValue.Trim() + "'," +
                                            "ExpediteCd='" + ddlExpedite.SelectedValue.Trim() + "'," +
                                            "ShipMethCd='" + ddlMethod.SelectedValue.Trim() + "'," +
                                            "PriorityCd='" + ddlPriority.SelectedValue.Trim() + "'," +
                                            "ShipInstr='" + ddlShippingInstruction.SelectedValue.Trim() + "'," +
                                            "InvSortOrd='" + ddlSortOrder.SelectedValue.Trim() + "'," +
                                            "ShipLocation='" + ddlShippingLoc.SelectedValue.Trim() + "'," +
                                            "UsageLocation='" + ddlUsageLoc.SelectedValue.Trim() + "'," +
                                            "TransferLocation='" + ddlTrfLoc.SelectedValue.Trim() + "'," +
                                            "AllowDelProofInd='" + ((chkList.Items[0].Selected) ? "Y" : "N") + "'," +
                                            "AllowPartialsInd='" + ((chkList.Items[1].Selected) ? "Y" : "N") + "'," +
                                            "AllowSubsInd='" + ((chkList.Items[2].Selected) ? "Y" : "N") + "'," +
                                            "ASNInd='" + ((chkList.Items[3].Selected) ? "Y" : "N") + "'," +
                                            "BackOrderInd='" + ((chkList2.Items[0].Selected) ? "Y" : "N") + "'," +
                                            "EDI870Ind='" + ((chkList2.Items[1].Selected) ? "Y" : "N") + "'," +
                                            "ResidentialDeliveryInd='" + ((chkList2.Items[2].Selected) ? "1" : "0") + "'," +
                                            "PackSlipRequired='" + ((chkList2.Items[3].Selected) ? "Y" : "N") + "'," +
                                            "ChangeDt='" + DateTime.Now.ToShortDateString() + "'," +
                                            "ChangeID='" + Session["UserName"].ToString().Replace("'", "''") + "'";

                    customerDetails.UpdateCustomerDetails(updateString, CustomerID);
                    //BindControls();


                    // Update Change Dt & ID in header section
                    AddressHeader customerHeader = this.Parent.FindControl("ucCustomerHeader") as AddressHeader;
                    customerHeader.SetChangeIDAndDt();

                    UpdatePanel pnHeaderDetails = this.Parent.FindControl("pnHeaderDetails") as UpdatePanel;
                    pnHeaderDetails.Update();

                }
                catch (Exception ex) { }
            }
        }
        protected void ibtnCancel_Click(object sender, ImageClickEventArgs e)
        {
            ClearControl();
        }
        #endregion

    } 
}
