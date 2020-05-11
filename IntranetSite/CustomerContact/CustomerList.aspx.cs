
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


public partial class CustomerList : System.Web.UI.Page
{
    CustomerMaintenance customerMaintenance = new CustomerMaintenance();    
    string customer = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Request.QueryString["ctrlName"] != null)
                hidfname.Value = Request.QueryString["ctrlName"].ToString();
            if (!IsPostBack)
            {
                customer = PFC.Intranet.Securitylayer.Cryptor.Decrypt(Request.QueryString["Customer"].ToString());

                if (!customer.Contains("%"))
                    customer += "%";

                txtCustName.Text = customer;

                BindCustomer();
            }
            else
            {
                customer = txtCustName.Text;

                if (!customer.Contains("%"))
                    customer += "%";

                txtCustName.Text = customer;
            }

            ScriptManager1.SetFocus(txtCustName);
            pnlCustomerSearch.Update();
        }
        catch (Exception ex)
        {

        }
    }

    public void BindCustomer()
    {
        try
        {
            int strCnt = 0;
            DataTable dtCustomer = new DataTable();
            DataSet dsCustomer = customerMaintenance.GetCustomerSelect(customer.Replace("'", "''"));
            dtCustomer = dsCustomer.Tables[0];

            // Filter DataTable 
            dtCustomer.DefaultView.RowFilter = BindWhereClause();
            strCnt = dtCustomer.DefaultView.ToTable().Rows.Count;
            dtCustomer = dtCustomer.DefaultView.ToTable();

            int maxRowCount = customerMaintenance.GetSQLWarningRowCount();

            if (strCnt < maxRowCount)
            {
                if (dtCustomer.Rows.Count > 0)
                {
                    if (hidSort.Value.Trim() != "")
                        dtCustomer.DefaultView.Sort = hidSort.Value;
                    else
                        dtCustomer.DefaultView.Sort = "CustName ASC";

                    dtCustomer = dtCustomer.DefaultView.ToTable();
                    dgCustomerList.DataSource = dtCustomer;
                    gridPager.InitPager(dgCustomerList, 100);
                    //dgCustomerList.DataBind();
                    lblMessage.Visible = false;
                    dgCustomerList.Visible = true; ;
                }
                else
                {
                    lblMessage.Text = "No record found";
                    lblMessage.Visible = true;
                    dgCustomerList.Visible = false;
                }
            }
            else
            {
                lblMessage.Text = "Maximum rows exceeded. Please refine your filter with using the parameters above and then click Search.";
                lblMessage.Visible = true;
                dgCustomerList.Visible = false;                
            }

        }
        catch (Exception ex) 
        {
            lblMessage.Text = "No record found";
            lblMessage.Visible = true;
            dgCustomerList.Visible = false;
        }

        pnlCustomerSearch.Update();
    }

    protected void dgCustomerList_ItemDataBound(object sender, DataGridItemEventArgs e)
    {

        e.Item.Cells[1].CssClass = "locked";
        e.Item.Cells[2].Visible = false;

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            e.Item.Attributes.Add("onclick", "javascript:BindCustomer('" + e.Item.Cells[0].Text.Trim() + "');");
            e.Item.Style.Add(HtmlTextWriterStyle.Cursor, "hand");
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

    #region Customer Validation
    private string cntCustName(string custNo)
    {
        string _whereClause = BindWhereClause();
        _whereClause = (_whereClause == "" ? "" : " and " + _whereClause);

        DataTable dtCustomer = new DataTable();
        string tableName = "CustomerMaster";
        string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
        string whereClause = " CustName Like '" + custNo.Trim().Replace("%", "").Replace("'", "''") + "%'" + _whereClause;
        DataSet dsCustomer = customerMaintenance.ExecuteERPSelectQuery(tableName, columnName, whereClause);

        if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
        {
            dtCustomer = dsCustomer.Tables[0];
            return dtCustomer.Rows[0]["totalcount"].ToString();
        }
        else
            return "0";
    }

    private string cntCustNo(string custNo)
    {
        string _whereClause = BindWhereClause();
        _whereClause = (_whereClause == "" ? "" : " and " + _whereClause);

        DataTable dtCustomer = new DataTable();
        string tableName = "CustomerMaster";
        string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
        string whereClause = "[CustNo] Like '" + custNo.Trim().Replace("%", "").Replace("'", "''") + "%'" + _whereClause;
        DataSet dsCustomer = customerMaintenance.ExecuteERPSelectQuery(tableName, columnName, whereClause);

        if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
        {
            dtCustomer = dsCustomer.Tables[0];
            return dtCustomer.Rows[0]["totalcount"].ToString();
        }
        else
            return "0";
    }

    private bool isNumeric(string val, System.Globalization.NumberStyles NumberStyle)
    {
        Double result;
        return Double.TryParse(val, NumberStyle,
            System.Globalization.CultureInfo.CurrentCulture, out result);
    }

    private string BindWhereClause()
    {
        string _whereClause = "";
        if (txtCustCity.Text.Trim() != "" && txtCustState.Text.Trim() != "")
            _whereClause = " City like '%" + txtCustCity.Text + "%' and State like '%" + txtCustState.Text + "%'";
        else if (txtCustCity.Text.Trim()!="")
            _whereClause = " City like '%" + txtCustCity.Text + "%'";
        else if (txtCustState.Text.Trim() != "")
            _whereClause = " State like '%" + txtCustState.Text + "%'";
        
        return _whereClause;
    }
    #endregion

    protected void ibtnCustSearch_Click(object sender, ImageClickEventArgs e)
    {
        BindCustomer();
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgCustomerList.CurrentPageIndex = gridPager.GotoPageNumber;
        BindCustomer();
        pnlCustomerSearch.Update();
    }
}
