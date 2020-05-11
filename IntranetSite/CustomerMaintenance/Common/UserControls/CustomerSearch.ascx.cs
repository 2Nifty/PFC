using System;
using System.Data;
using System.Data.SqlClient;
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
    public partial class CustomerSearch : System.Web.UI.UserControl
    {
        CustomerMaintenance customerDetails = new CustomerMaintenance();
        string connectionString;

        public CustomerType CustType
        {
            get { return (Session["CustomerType"] == null) ? CustomerType.BTST : (CustomerType)Session["CustomerType"]; }
            set { Session["CustomerType"] = value; }
        }
	
       

        protected void Page_Load(object sender, EventArgs e)
        {
            connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
            if (!IsPostBack)
            {
 
            }
            if (Session["SecurityCode"].ToString().Trim() != "")
                btnAdd.Visible = true;
            else
                btnAdd.Visible = false;
        }

        #region Property Bags

        public string CustomerNumber
        {
            set
            {
                txtCustomer.Text = value;
            }
            get
            {
                return txtCustomer.Text.Trim();
            }
        }

        public string CustomerID
        {
            set
            {
                hidCustomerID.Value = value;
            }
            get { return hidCustomerID.Value.Trim(); }
        }
        public string BillToCustomerNo
        {
            set
            {
                hidBillToCustomerNo.Value = value;
            }
            get { return hidBillToCustomerNo.Value.Trim(); }
        }
        public string BillToCustomerID
        {
            set
            {
                hidBillToCustomerID.Value = value;
            }
            get { return hidBillToCustomerID.Value.Trim(); }
        }
        

        #endregion

        #region Events

     
        public void btnSearch_Click(object sender, EventArgs e)
        {
            string strCustNo = txtCustomer.Text;

            if (strCustNo != "")             
            {  
                int strCnt = 0;
                bool textIsNumeric = true;

                try
                {
                    int.Parse(strCustNo);
                }
                catch
                {
                    textIsNumeric = false;
                }                

                if (!textIsNumeric)
                {        
                    ScriptManager.RegisterClientScriptBlock(txtCustomer, txtCustomer.GetType(), "Customer", "LoadCustomerLookup('" + Server.UrlEncode(PFC.Intranet.Securitylayer.Cryptor.Encrypt(strCustNo)) + "','" + txtCustomer.ClientID + "');", true);                                            
                }
                else
                {
                    GetSearch();
                    customerDetails.ReleaseLock();
                    customerDetails.SetLock(hidCustomerID.Value.Trim());
                }
            }
         }
      
        public void GetSearch()
        {
            try
            {
                DataSet dsCustomer = (DataSet)customerDetails.GetDataToDateset("CustomerMaster (NOLOCK) ", "pCustMstrID,fBillToNo,CustCd,CustNo", "CustNo='" + CustomerNumber + "' or CustSearchKey='" + CustomerNumber + "'"); ;
                if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
                {

                    customerDetails.ReleaseLock();
                    customerDetails.SetLock(dsCustomer.Tables[0].Rows[0]["pCustMstrID"].ToString().Trim());

                    CustomerID = dsCustomer.Tables[0].Rows[0]["pCustMstrID"].ToString().Trim();
                    CustomerNumber = dsCustomer.Tables[0].Rows[0]["CustNo"].ToString().Trim();
                    txtCustomer.Text = dsCustomer.Tables[0].Rows[0]["CustNo"].ToString().Trim();
                    BillToCustomerNo = dsCustomer.Tables[0].Rows[0]["fBillToNo"].ToString().Trim();
                    string customerCd = dsCustomer.Tables[0].Rows[0]["CustCd"].ToString().Trim();

                    if (BillToCustomerNo == "" && customerCd.ToUpper() == "BT")
                    {
                        CustType = CustomerType.BT;
                        BillToCustomerNo = CustomerNumber;
                        BillToCustomerID = CustomerID;
                    }
                    else if (BillToCustomerNo == CustomerNumber && customerCd.ToUpper() == "BTST")
                    {
                        CustType = CustomerType.BTST;
                        BillToCustomerNo = CustomerNumber;
                        BillToCustomerID = CustomerID;
                    }
                    else if (BillToCustomerNo != CustomerNumber && customerCd.ToUpper() == "ST")
                    {
                        CustType = CustomerType.ST;
                        DataSet dsBillToCustomer = customerDetails.GetDataToDateset("CustomerMaster (NOLOCK) ", "pCustMstrID,fBillToNo,CustCd,CustNo", "CustNo='" + BillToCustomerNo + "'");
                        if(dsBillToCustomer!=null && dsBillToCustomer.Tables[0].Rows.Count>0)
                            BillToCustomerID = dsBillToCustomer.Tables[0].Rows[0]["pCustMstrID"].ToString();
                    }
                }
                else
                        ScriptManager.RegisterClientScriptBlock(txtCustomer, txtCustomer.GetType(), "Customer", "alert('Invalid Customer.');document.getElementById('" + txtCustomer.ClientID + "').focus();document.getElementById('" + txtCustomer.ClientID + "').select();", true);
            }
            catch (Exception ex) 
            {
            }
        }
        public bool isNumeric(string val, System.Globalization.NumberStyles NumberStyle)
        {
            Double result;
            return Double.TryParse(val, NumberStyle,
                System.Globalization.CultureInfo.CurrentCulture, out result);
        }
        public string cntCustNo(string custNo)
        {
          
                DataTable dtCustomer = new DataTable();
                string tableName = "CustomerMaster (NOLOCK) ";
                string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
                string whereClause = "CustNo Like '" + custNo.Trim().Replace("%", "") + "%'";
                //DataSet dsCustomer = salesHis.ExecuteSelectQuery(tableName, columnName, whereClause);
                DataSet dsCustomer = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                   new SqlParameter("@tableName", tableName),
                                   new SqlParameter("@columnNames", columnName),
                                   new SqlParameter("@whereClause", whereClause));
                if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
                {
                    dtCustomer = dsCustomer.Tables[0];
                    return dtCustomer.Rows[0]["totalcount"].ToString();
                }
                else
                    return "0";
            
        }

        public string cntCustName(string custNo)
        {
            
            DataTable dtCustomer = new DataTable();
            string tableName = "CustomerMaster (NOLOCK) ";
            string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
            string whereClause = "CustName Like '" + custNo.Trim().Replace("%", "") + "%'";
            //DataSet dsCustomer = salesHis.ExecuteSelectQuery(tableName, columnName, whereClause);
            DataSet dsCustomer = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                new SqlParameter("@tableName", tableName),
                                new SqlParameter("@columnNames", columnName),
                                new SqlParameter("@whereClause", whereClause));
            if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
            {
                dtCustomer = dsCustomer.Tables[0];
                return dtCustomer.Rows[0]["totalcount"].ToString();
            }
            else
                return "0";
         
        }

        private void ClearValue()
        {
            CustomerID = "";
            CustomerNumber = "";            
            BillToCustomerNo = "";
        }
        #endregion
        protected void txtCustomer_TextChanged(object sender, EventArgs e)
        {
            DataSet dsCustomer = customerDetails.GetDataToDateset("CustomerMaster (NOLOCK) ", "pCustMstrID,fBillToNo,CustCd,CustNo", "CustNo='" + CustomerNumber + "' or CustSearchKey='" + CustomerNumber + "'");
            Session["CustometDetail"] = dsCustomer;
            if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
            {
                customerDetails.ReleaseLock();
                customerDetails.SetLock(dsCustomer.Tables[0].Rows[0]["pCustMstrID"].ToString().Trim());
            }
            else
            {
                CustomerID = "";
                BillToCustomerID = "";
                BillToCustomerNo = "";
                CustomerNumber = txtCustomer.Text;
              
            }

        }
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            CustomerID = "";
            BillToCustomerID = "";
            BillToCustomerNo = "";
            CustomerNumber = txtCustomer.Text;
        }
        protected void ibtnClose_Click(object sender, ImageClickEventArgs e)
        {
            if (Session["CustometDetail"] !=null)
            {

                Session["CustometDetail"] = null;
                customerDetails.ReleaseLock(); 
            }
            ScriptManager.RegisterClientScriptBlock(ibtnClose, typeof(ImageButton), "windowClose", "window.close();", true);
        }
} 
}
