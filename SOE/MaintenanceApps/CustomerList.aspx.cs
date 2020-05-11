
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
using System.Data.SqlClient;

using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;


public partial class CustomerList : System.Web.UI.Page
{
    // Create instance for the webservice
    OrgStandardComment service ;
    string connectionString = "";
    string customer = "";
    string type = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        service = new OrgStandardComment();
        connectionString = PFC.Intranet.MaintenanceApps.MaintenanceUtility.GetConnectionString();
        try
        {
            type=Request.QueryString["Type"].ToString();
            customer = PFC.SOE.Securitylayer.Cryptor.Decrypt(Request.QueryString["Customer"].ToString());
            if (Request.QueryString["ctrlName"] != null)
                hidfname.Value = Request.QueryString["ctrlName"].ToString();
            
            if (!IsPostBack)
                BindCustomer();
        }
        catch (Exception ex)
        {

        }
    }

    public void BindCustomer()
    {
        try
        {
            DataTable dtCustomer = new DataTable();
            DataSet dsCustomer = service.GetData(customer,type);
            if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
            {
                dtCustomer = dsCustomer.Tables[0];
                if (hidSort.Value.Trim() != "")
                {
                    dtCustomer.DefaultView.Sort = hidSort.Value;
                    dtCustomer = dtCustomer.DefaultView.ToTable();
                }
                dgCustomerList.DataSource = dsCustomer.Tables[0];
                dgCustomerList.DataBind();
            }
            else
            {
                lblMessage.Visible = true;
                dgCustomerList.Visible = false;
            }

        }
        catch (Exception ex) { }
    }
    protected void dgCustomerList_ItemDataBound(object sender, DataGridItemEventArgs e)
    {      
        e.Item.Cells[1].CssClass = "locked";
        e.Item.Cells[2].Visible = false;

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {          
            e.Item.Attributes.Add("onclick", "javascript:BindCustomer('" + e.Item.Cells[0].Text.Trim() + "');");
        }
    }
    protected void dgCustomerList_SortCommand(object source, DataGridSortCommandEventArgs e)
    {
        if (hidSort.Attributes["sortType"] != null)
        {
            if (hidSort.Attributes["sortType"].ToString() == "ASC")
                hidSort.Attributes["sortType"] = "DESC";
            else
                hidSort.Attributes["sortType"] = "ASC";
        }
        else
            hidSort.Attributes.Add("sortType", "ASC");

        hidSort.Value = ((e.SortExpression.IndexOf(" ") != -1) ? "[" + e.SortExpression + "]" : e.SortExpression) + " " + hidSort.Attributes["sortType"].ToString();
        BindCustomer();
    }
}
