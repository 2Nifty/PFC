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
    public partial class CreditInformation : System.Web.UI.UserControl
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
            if (Session["SecurityCode"].ToString().Trim() != "" && Session["CustomerLock"].ToString().Trim() != "L")
                ibtnSave.Visible = true;
            else
                ibtnSave.Visible = false;
        }

        private void BindDropDownList()
        {
            customerDetails.BindListControls(ddlCashDiscount, "ListDesc", "ListValue", customerDetails.GetListDetails("CashDiscCd"), "-- Select --");
            customerDetails.BindListControls(ddlCycleBilling,  "ListDesc", "ListValue",customerDetails.GetListDetails("CycBillInd"), "-- Select --");
            customerDetails.BindListControls(ddlGLPosting,  "ListDesc", "ListValue",customerDetails.GetListDetails("GLTypeCd"), "-- Select --");
            customerDetails.BindListControls(ddlTaxCode,  "ListDesc", "ListValue",customerDetails.GetListDetails("TaxStatusCd"), "-- Select --");
            customerDetails.BindListControls(ddlTradeTerm, "ListDesc", "ListValue", customerDetails.GetTableValues("TRM"), "-- Select --");
            customerDetails.BindListControls(ddlCreditApp, "ListDesc", "ListValue", customerDetails.GetListDetails("YesNoInd"), "-- Select --");
            customerDetails.BindListControls(ddlCreditReview, "ListDesc", "ListValue", customerDetails.GetListDetails("YesNoInd"), "-- Select --");
        }
        private void BindControls()
        {

            // Unknown ZeroBalanceMo,

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
                txtZeroBalance.Text = dtValues.Rows[0]["ZeroBalMo"].ToString();
                txtCreditIndicator.Text = dtValues.Rows[0]["CreditInd"].ToString();
                txtCreditLimeit.Text = dtValues.Rows[0]["CreditLmt"].ToString();
                dpCreditReviewdt.SelectedDate = (dtValues.Rows[0]["CreditRvwDT"].ToString() == "") ? "" : Convert.ToDateTime(dtValues.Rows[0]["CreditRvwDT"].ToString()).ToShortDateString();  
                txtDunsNo.Text = dtValues.Rows[0]["DunsNo"].ToString();
                txtDunsRating.Text = dtValues.Rows[0]["DunsRating"].ToString();
                txtLateCharge.Text = dtValues.Rows[0]["LateChrgPct"].ToString();
                txtServiceCharge.Text = dtValues.Rows[0]["SvcChrgMo"].ToString();
                txtMultiTaxCd.Text = dtValues.Rows[0]["MultiTaxCd"].ToString();
                dpWriteOffDate.SelectedDate = (dtValues.Rows[0]["WriteOffDt"].ToString() == "") ? "" : Convert.ToDateTime(dtValues.Rows[0]["WriteOffDt"].ToString()).ToShortDateString();
                 

                customerDetails.SetValueListControl(ddlCashDiscount, dtValues.Rows[0]["CashDiscCd"].ToString());
                customerDetails.SetValueListControl(ddlCreditApp, dtValues.Rows[0]["CreditAppInd"].ToString());
                customerDetails.SetValueListControl(ddlCreditReview, dtValues.Rows[0]["CreditRvwInd"].ToString());
                customerDetails.SetValueListControl(ddlCycleBilling, dtValues.Rows[0]["CycBillInd"].ToString());
                customerDetails.SetValueListControl(ddlGLPosting, dtValues.Rows[0]["GLPostCd"].ToString());
                customerDetails.SetValueListControl(ddlTaxCode, dtValues.Rows[0]["TaxCd"].ToString());
                customerDetails.SetValueListControl(ddlTradeTerm, dtValues.Rows[0]["TradeTermCd"].ToString());

                chkList.Items[0].Selected = (dtValues.Rows[0]["SummBillInd"].ToString().ToUpper().Trim() == "Y");
                chkList.Items[1].Selected = (dtValues.Rows[0]["DelinqInd"].ToString().ToUpper().Trim() == "Y");
                chkList.Items[2].Selected = (dtValues.Rows[0]["TaxStat"].ToString().ToUpper().Trim() == "Y");
                chkList.Items[3].Selected = (dtValues.Rows[0]["ChgBackInd"].ToString().ToUpper().Trim() == "Y");
                chkList.Items[4].Selected = (dtValues.Rows[0]["FinChrgInd"].ToString().ToUpper().Trim() == "Y");
                chkList.Items[5].Selected = (dtValues.Rows[0]["Rebate"].ToString().ToUpper().Trim() == "Y");
            }
            else
            {
                ClearControl();
            }
        }
        private void ClearControl()
        {
            txtZeroBalance.Text = "";
            txtCreditIndicator.Text = "";
            txtCreditLimeit.Text = "";
            dpCreditReviewdt.SelectedDate = "";
            txtDunsNo.Text = "";
            txtDunsRating.Text = "";
            txtLateCharge.Text = "";
            txtServiceCharge.Text = "";
            txtMultiTaxCd.Text = "";
            dpWriteOffDate.SelectedDate = "";
            for (int count = 0; count < chkList.Items.Count; count++)
            {
                chkList.Items[count].Selected = false;
            }
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
                    string updateString = "ZeroBalMo='" + txtZeroBalance.Text.Replace("'", "''") + "'," +
                                            "CreditInd='" + txtCreditIndicator.Text.Replace("'", "''") + "'," +
                                            "CreditLmt='" + txtCreditLimeit.Text.Replace("'", "''") + "'," +
                                            "CreditRvwDT='" + dpCreditReviewdt.SelectedDate.Replace("'", "''") + "'," +
                                            "DunsNo='" + txtDunsNo.Text.Replace("'", "''") + "'," +
                                            "DunsRating='" + txtDunsRating.Text.Replace("'", "''") + "'," +
                                            "LateChrgPct=" + ((txtLateCharge.Text=="")?"null":"'" +txtLateCharge.Text.Replace("'", "''")+"'") + "," +
                                            "SvcChrgMo='" + txtServiceCharge.Text.Replace("'", "''") + "'," +
                                            "MultiTaxCd='" + txtMultiTaxCd.Text.Replace("'", "''") + "'," +
                                            "WriteOffDt='" + dpWriteOffDate.SelectedDate.Replace("'", "''") + "'," +
                                            "CashDiscCd='" + ddlCashDiscount.SelectedValue.Trim() + "'," +
                                            "CreditAppInd='" + ddlCreditApp.SelectedValue.Trim() + "'," +
                                            "CreditRvwInd='" + ddlCreditReview.SelectedValue.Trim() + "'," +
                                            "CycBillInd='" + ddlCycleBilling.SelectedValue.Trim() + "'," +
                                            "GLPostCd='" + ddlGLPosting.SelectedValue.Trim() + "'," +
                                            "TaxCd='" + ddlTaxCode.SelectedValue.Trim() + "'," +
                                            "TradeTermCd='" + ddlTradeTerm.SelectedValue.Trim() + "'," +
                                            "SummBillInd='" + ((chkList.Items[0].Selected) ? "Y" : "N") + "'," +
                                            "DelinqInd='" + ((chkList.Items[1].Selected) ? "Y" : "N") + "'," +
                                            "TaxStat='" + ((chkList.Items[2].Selected) ? "Y" : "N") + "'," +
                                            "ChgBackInd='" + ((chkList.Items[3].Selected) ? "Y" : "N") + "'," +
                                            "FinChrgInd='" + ((chkList.Items[4].Selected) ? "Y" : "N") + "'," +
                                            "Rebate='" + ((chkList.Items[5].Selected) ? "Y" : "N") + "',"+
                                            "ChangeDt='" + DateTime.Now.ToShortDateString() + "'," +
                                            "ChangeID='" + Session["UserName"].ToString().Replace("'", "''") + "'";
                    customerDetails.UpdateCustomerDetails(updateString, CustomerID);

                    // Update Change Dt & ID in header section
                    AddressHeader customerHeader = this.Parent.FindControl("ucCustomerHeader") as AddressHeader;
                    customerHeader.SetChangeIDAndDt();

                    UpdatePanel pnHeaderDetails = this.Parent.FindControl("pnHeaderDetails") as UpdatePanel;
                    pnHeaderDetails.Update();
                }
                catch (Exception ex) {   }
            }            
        }       
        protected void ibtnCancel_Click(object sender, ImageClickEventArgs e)
        {
            ClearControl();
        }
        #endregion

    } 
}
