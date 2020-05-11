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
using PFC.SOE.Enums;

public partial class BillTo : System.Web.UI.Page
{

    #region Variable Declaration

    BillToAddress billToAddress = new BillToAddress();
    Utility utility = new Utility();

    string noRecordMessage = "No Records Found";
    string contactExistMessage = "Contact name already exist";
    string contactSuccessMessage = "Sold To information updated successfully";

    #endregion

    #region Page events
    protected void Page_Load(object sender, EventArgs e)
    {
        SecurityCheck();
        if (!Page.IsPostBack)
        {
            lblSONumber.Text = Request.QueryString["SONumber"].ToString();
            FillDefaultAddressAndContact(); 
        }
    }
    private void SecurityCheck()
    {
        if (Session["UserSecurity"] == null || Session["UserSecurity"].ToString() == string.Empty)
        {
            ibtnHelp.Visible = false;
            ibtnTax.Visible = false;
            ibtnNotes.Visible = false;
        }

    }
    #endregion        

    #region Developer Method

    private void FillDefaultAddressAndContact()
    {
        // Fill Default Address infromation
        DataTable dtDefaultAddress = billToAddress.GetBillToInfo(lblSONumber.Text);

        if (dtDefaultAddress != null && dtDefaultAddress.Rows.Count > 0)
        {

            lblCustNo.Text = dtDefaultAddress.Rows[0]["BillToCustNo"].ToString();
            hidCustNo.Value = dtDefaultAddress.Rows[0]["pCustMstrID"].ToString();
            lblName.Text = dtDefaultAddress.Rows[0]["BillToCustName"].ToString();
            lblAddress1.Text = dtDefaultAddress.Rows[0]["BillToAddress1"].ToString();
            lblAddress2.Text = dtDefaultAddress.Rows[0]["BillToAddress2"].ToString();
            lblCity.Text = dtDefaultAddress.Rows[0]["BillToCity"].ToString();
            lblState.Text = dtDefaultAddress.Rows[0]["BillToState"].ToString();
            lblPostcode.Text = dtDefaultAddress.Rows[0]["BillToZip"].ToString();
            lblCountry.Text = dtDefaultAddress.Rows[0]["BillToCountry"].ToString();
            lblPhone.Text = utility.FormatPhoneNumber(dtDefaultAddress.Rows[0]["BillToContactPhoneNo"].ToString());

            lblContactName.Text = dtDefaultAddress.Rows[0]["BillToContactName"].ToString();
            lblContactJobTitle.Text = dtDefaultAddress.Rows[0]["JobTitle"].ToString();
            lblContactDepart.Text = dtDefaultAddress.Rows[0]["Department"].ToString();
            lblContactPhoneNo.Text = utility.FormatPhoneNumber(dtDefaultAddress.Rows[0]["Phone"].ToString());
            lblContactExt.Text = dtDefaultAddress.Rows[0]["PhoneExt"].ToString();
            lblContactFax.Text = utility.FormatPhoneNumber(dtDefaultAddress.Rows[0]["FaxNo"].ToString());
            lblContactMob.Text = utility.FormatPhoneNumber(dtDefaultAddress.Rows[0]["MobilePhone"].ToString());
            lblContactEmail.Text = dtDefaultAddress.Rows[0]["EmailAddr"].ToString();

            lblTaxCode.Text =  dtDefaultAddress.Rows[0]["TaxCd"].ToString();
            lblTaxStatus.Text =dtDefaultAddress.Rows[0]["TaxStat"].ToString();
            lblTerms.Text =dtDefaultAddress.Rows[0]["TradeTermCd"].ToString();
            lblSalesRep.Text =dtDefaultAddress.Rows[0]["SlsRepNo"].ToString();
            lblContractno.Text =dtDefaultAddress.Rows[0]["ContractNo"].ToString();
            lblCreditApp.Text =dtDefaultAddress.Rows[0]["CreditAppInd"].ToString();
            lblCreditLimit.Text =dtDefaultAddress.Rows[0]["CreditLmt"].ToString();

            lblRvw.Text = dtDefaultAddress.Rows[0]["CreditRvwInd"].ToString();
            lblRvwDt.Text = Convert.ToDateTime(dtDefaultAddress.Rows[0]["CreditRvwDT"].ToString()).ToShortDateString();
            lblinvinstr.Text =dtDefaultAddress.Rows[0]["InvInstr"].ToString();
            lblInvCopies.Text =dtDefaultAddress.Rows[0]["InvCopies"].ToString();

            PrintDialogue1.CustomerNo = lblCustNo.Text;
            PrintDialogue1.PageTitle = "Bill To Address for SO#" + lblSONumber.Text;
            PrintDialogue1.PageUrl = Server.UrlEncode("BillToAddressExport.aspx?SONumber=" + lblSONumber.Text);


        }
    }
    #endregion

    protected void ibtnTax_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            string strCustNo = hidCustNo.Value;
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Tax", "callTaxExempt('" + strCustNo + "');", true);
            
        }
        catch (Exception ex) { }
    }
    protected void ibtnNotes_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            string strCustNo = hidCustNo.Value;
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Tax", "callNotes('" + strCustNo + "');", true);

        }
        catch (Exception ex) { }

    }
}
