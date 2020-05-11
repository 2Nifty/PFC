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
using System.Data.Sql;
using System.Data.SqlClient;
using System.Data.SqlClient;

using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.DataAccessLayer;

public partial class SelectContacts : System.Web.UI.Page
{
    SelectContact contact = new SelectContact();
    string custNo = "";
    string mode = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(SelectContacts));

        if (Request.QueryString["CustNo"] != null)
        {
            custNo = Request.QueryString["CustNo"].ToString();
        }
      
        if(!IsPostBack)
        {       
            BindGrid(custNo);
        }
    }

    private void BindGrid(string custNum)
    {

        DataSet dsPromos = GetActivePromotions(custNum);
        if (dsPromos != null && dsPromos.Tables[0].Rows.Count > 0)
        {
            gvPromos.DataSource = dsPromos.Tables[0];
            gvPromos.DataBind();
        }
        else 
        {
            gvPromos.Visible = false;
            lblMessage.Visible = true;
        }
        upnlContactsGrid.Update();
    }

    public DataSet GetActivePromotions(string custNo)
    {
        try
        {
            DataSet dsPromoDeatils = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEGetCustPromoList]",
                                           new SqlParameter("@SellCustNo", custNo),
                                           new SqlParameter("@OrderSource", "ALL"));

            if (dsPromoDeatils != null && dsPromoDeatils.Tables[0].Rows.Count != 0)
                return dsPromoDeatils;
            else
                return null;
        }
        catch (Exception ex)
        {
            return null;
        }
    }
  
           
}

