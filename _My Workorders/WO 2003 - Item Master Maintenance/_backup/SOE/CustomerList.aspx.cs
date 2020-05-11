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


public partial class CustomerList : System.Web.UI.Page
{
    // Create instance for the webservice
    OrderEntry service = new OrderEntry();
    CustomerDetail custDetail = new CustomerDetail();
    string customer = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Request.QueryString["ctrlName"] != null)
                hidfname.Value = Request.QueryString["ctrlName"].ToString();

            if (!IsPostBack)
            {
                customer = PFC.SOE.Securitylayer.Cryptor.Decrypt(Request.QueryString["Customer"].ToString());
                if(!customer.Contains("%"))
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

    #region Bind Customer Data to Grid
    protected void ibtnCustSearch_Click(object sender, ImageClickEventArgs e)
    {
        BindCustomer();
    }
    
    public void BindCustomer()
    {
        try
        {
            int strCnt = 0;
            DataTable dtCustomer = new DataTable();
            DataSet dsCustomer = service.GetCustomerSelect(customer.Replace("'", "''"));
            dtCustomer = dsCustomer.Tables[0];

            // Filter DataTable 
            dtCustomer.DefaultView.RowFilter = BindWhereClause();
            strCnt = dtCustomer.DefaultView.ToTable().Rows.Count;
            dtCustomer = dtCustomer.DefaultView.ToTable();
            //if (isNumeric(customer.Remove(customer.Length - 1, 1), System.Globalization.NumberStyles.Integer) == false)
            //    strCnt = Convert.ToInt32(cntCustName(customer));
            //else
            //    strCnt = Convert.ToInt32(cntCustNo(customer));

            int maxRowCount = custDetail.GetSQLWarningRowCount();

            if (strCnt < maxRowCount)
            {
                if (dtCustomer.Rows.Count > 0)
                {
                    if (hidSort.Value.Trim() != "")
                        dtCustomer.DefaultView.Sort = hidSort.Value;
                    else
                        dtCustomer.DefaultView.Sort = "CustName ASC";

                    dgCustomerList.DataSource = dtCustomer;
                    dgCustomerList.DataBind();
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
        e.Item.Cells[0].Visible = false;

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            e.Item.Cells[1].Style.Add(HtmlTextWriterStyle.Cursor, "hand");
            if ((e.Item.Cells[11].Text.Trim() == "E") || (e.Item.Cells[11].Text.Trim() == "X"))
                e.Item.Attributes.Add("onclick", "javascript:alert('Credit is suspended for the Selected Customer');");
            else
                e.Item.Attributes.Add("onclick", "javascript:BindCustomer('" + e.Item.Cells[1].Text.Trim() + "');");
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

    private string BindWhereClause()
    {
        string _whereClause = "";
        if (txtCustCity.Text.Trim() != "" && txtCustState.Text.Trim() != "")
            _whereClause = " City like '%" + txtCustCity.Text + "%' and State like '%" + txtCustState.Text + "%'";
        else if (txtCustCity.Text.Trim() != "")
            _whereClause = " City like '%" + txtCustCity.Text + "%'";
        else if (txtCustState.Text.Trim() != "")
            _whereClause = " State like '%" + txtCustState.Text + "%'";

        return _whereClause;
    }
    #endregion

    #region Customer Validation
    //private string cntCustName(string custNo)
    //{
    //    string _whereClause = BindWhereClause();
    //    _whereClause = (_whereClause == "" ? "" : " and " + _whereClause);

    //    DataTable dtCustomer = new DataTable();
    //    string tableName = "CustomerMaster";
    //    string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
    //    string whereClause = " CustName Like '" + custNo.Trim().Replace("%", "").Replace("'", "''") + "%'" + _whereClause;
    //    DataSet dsCustomer = service.ExecuteERPSelectQuery(tableName, columnName, whereClause);

    //    if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
    //    {
    //        dtCustomer = dsCustomer.Tables[0];
    //        return dtCustomer.Rows[0]["totalcount"].ToString();
    //    }
    //    else
    //        return "0";
    //}

    //private string cntCustNo(string custNo)
    //{
    //    string _whereClause = BindWhereClause();
    //    _whereClause = (_whereClause == "" ? "" : " and " + _whereClause);

    //    DataTable dtCustomer = new DataTable();
    //    string tableName = "CustomerMaster";
    //    string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
    //    string whereClause = "[CustNo] Like '" + custNo.Trim().Replace("%", "").Replace("'", "''") + "%'" + _whereClause;
    //    DataSet dsCustomer = service.ExecuteERPSelectQuery(tableName, columnName, whereClause);

    //    if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
    //    {
    //        dtCustomer = dsCustomer.Tables[0];
    //        return dtCustomer.Rows[0]["totalcount"].ToString();
    //    }
    //    else
    //        return "0";
    //}

    //private bool isNumeric(string val, System.Globalization.NumberStyles NumberStyle)
    //{
    //    Double result;
    //    return Double.TryParse(val, NumberStyle,
    //        System.Globalization.CultureInfo.CurrentCulture, out result);
    //}
    #endregion
}
