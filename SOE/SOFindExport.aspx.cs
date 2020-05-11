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
public partial class SOFind : System.Web.UI.Page
{
 
    #region Variable Declaration
    SOEFind sOEFind = new SOEFind();
    Utility utility = new Utility();

    private bool isSort = false;
    private string whereClause = "";   
    #endregion

    #region Page Load Event
    /// <summary>
    /// Page Load Event Handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    { 
        if (!IsPostBack)
        {
            //lnkStyle.Href = "http://" + Request.ServerVariables["SERVER_NAME"].ToString() + "/SOE/Common/StyleSheet/printstyles.css";
            //imglogo.ImageUrl = "http://" + Request.ServerVariables["SERVER_NAME"].ToString() + "/SOE/Common/Images/PFC_logo.gif";
            //ShipLoc,SoNo,InventoryNo,PORef,Amount,Weight,Type,ShipDate,OrderDate,CustReq,Status,Carrier,CustomerNo		
            BindValues();
            BindDataGrid();
        }
         
    }
    #endregion

    #region Developer Code
    private void BindValues()
    {
        DataTable dtCustomer = sOEFind.ValidateCustomer(Request.QueryString["CustomerNumber"].ToString());
        if (dtCustomer != null && dtCustomer.Rows.Count > 0)
        {             
            lblContractNumber.Text = dtCustomer.Rows[0]["ContractNo"].ToString();
            lblSalesRepNumber.Text = dtCustomer.Rows[0]["SlsRepNo"].ToString();
            lblSalesRepName.Text = dtCustomer.Rows[0]["RepName"].ToString();
            lblPriceCode.Text = dtCustomer.Rows[0]["PriceCd"].ToString();
        }
      
    }
 
    /// <summary>
    /// Bind Expense grid based on SOHeader id
    /// </summary>
    private void BindDataGrid()
    {
        whereClause = Request.QueryString["WhereClause"].ToString();
        string tableName = Request.QueryString["TableName"].ToString();
        DataTable dsSoFind = sOEFind.GetSalesOrder(whereClause.Replace("`","'"),tableName);
        if (dsSoFind != null)
        {
            if (dsSoFind.Rows.Count == 0)
            {
                DataRow dr = dsSoFind.NewRow();
                dsSoFind.Rows.Add(dr);
            }
            dsSoFind.DefaultView.Sort = Request.QueryString["Sort"].ToString();
            gvFind.DataSource = dsSoFind.DefaultView.ToTable();
            gvFind.DataBind();
            gvFind.Visible = true;             
        }
        
    }   

    #endregion

   
}
