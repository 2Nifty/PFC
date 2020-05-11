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
using PFC.WOE.BusinessLogicLayer;
using PFC.WOE.DataAccessLayer;

public partial class Common_UserControls_SubHeader : System.Web.UI.UserControl
{
    public string PONumber
    {
        set 
        {
            hidPONumber.Value = value; 
            BindSaleOrderDetails(); 
        }
        get
        {
            return hidPONumber.Value;
        }
    }

    DataUtility dataUtility = new DataUtility();

    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    private void BindSaleOrderDetails()
    {
        string whereClause = "pPoHeaderID=" + hidPONumber.Value;
        
        if(Session["POHeaderTableName"].ToString().ToLower() == "poheaderhist")
            whereClause = "pPoHeaderHistID=" + hidPONumber.Value;

        DataTable dsSalesOrderDetails = dataUtility.GetTableData(Session["POHeaderTableName"].ToString(), "*", whereClause);

        if (dsSalesOrderDetails != null && dsSalesOrderDetails.Rows.Count > 0)
        {
            lblWONumber.Text = dsSalesOrderDetails.Rows[0]["POOrderNo"].ToString().Trim();
            lblMfgName.Text = dsSalesOrderDetails.Rows[0]["OrderContactName"].ToString().Trim();
            lblMfgAddress.Text = dsSalesOrderDetails.Rows[0]["BuyFromAddress"].ToString().Trim();
            lblMfgAddress2.Text = dsSalesOrderDetails.Rows[0]["BuyFromAddress2"].ToString();
            lblMfgCity.Text = dsSalesOrderDetails.Rows[0]["BuyFromCity"].ToString().Trim();
            lblMfgState.Text = dsSalesOrderDetails.Rows[0]["BuyFromState"].ToString().Trim();
            lblMfgPhone.Text = dsSalesOrderDetails.Rows[0]["OrderContactPhoneNo"].ToString().Trim();
            lblMfgPincode.Text = dsSalesOrderDetails.Rows[0]["BuyFromZip"].ToString().Trim();
            lblMfgComma.Visible = ((lblMfgCity.Text.Trim() != "" && lblMfgState.Text.Trim() != "") ? true : false);
            lblMfgCountry.Text = dsSalesOrderDetails.Rows[0]["BuyFromCountry"].ToString().Trim();

            lblPckName.Text = dsSalesOrderDetails.Rows[0]["ShipToName"].ToString().Trim();
            lblPckAddress.Text = dsSalesOrderDetails.Rows[0]["ShipToAddress"].ToString().Trim();
            lblPckAddress2.Text = dsSalesOrderDetails.Rows[0]["ShipToAddress2"].ToString().Trim();
            lblPckCity.Text = dsSalesOrderDetails.Rows[0]["ShipToCity"].ToString().Trim();
            lblPckState.Text = dsSalesOrderDetails.Rows[0]["ShipToState"].ToString().Trim();
            lblPckPhone.Text = dsSalesOrderDetails.Rows[0]["ShipToPhoneNo"].ToString().Trim();
            lblPckPincode.Text = dsSalesOrderDetails.Rows[0]["ShipToZip"].ToString().Trim();
            lblPckComma.Visible = ((lblPckCity.Text.Trim() != "" && lblPckState.Text.Trim() != "") ? true : false);
            lblPckCountry.Text = dsSalesOrderDetails.Rows[0]["ShipToCountry"].ToString().Trim();

            lblMfgCode.Text = dsSalesOrderDetails.Rows[0]["BuyFromVendorNo"].ToString();           
        }
    }
}
