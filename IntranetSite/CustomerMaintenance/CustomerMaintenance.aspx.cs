
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
    public partial class CustomerMaster : System.Web.UI.Page
    {
        CustomerMaintenance customerDetails = new CustomerMaintenance();       
        string unAuthorizedPage = "~/Common/ErrorPage/unauthorizedpage.aspx";
       
        protected void Page_Load(object sender, EventArgs e)
        {
            #region Search Customer  Handler      
         
            Button btnSearch = ucSearchCustomer.FindControl("btnSearch") as Button; 
            btnSearch.Click += new EventHandler(btnSearch_Click);
            Button btnAdd = ucSearchCustomer.FindControl("btnAdd") as Button;
            btnAdd.Click += new EventHandler(btnAdd_Click); 
            #endregion

            #region Address Info 
            Button btnCancel = ucAddressInfo.FindControl("btnCancel") as Button;
            btnCancel.Click += new EventHandler(btnCancel_Click);
            Button btnSave = ucAddressInfo.FindControl("btnSave") as Button;
            btnSave.Click += new EventHandler(btnSave_Click);
           
            Button ibtnSalesSave = ucSales.FindControl("ibtnSave") as Button;
            ibtnSalesSave.Click += new EventHandler(ibtnSave_Click);
            Button ibtnCreditSave = ucCredit.FindControl("ibtnSave") as Button;
            ibtnCreditSave.Click += new EventHandler(ibtnSave_Click);
            Button ibtnShipSave = ucShipping.FindControl("ibtnSave") as Button;
            ibtnShipSave.Click += new EventHandler(ibtnSave_Click);

            #endregion

            if (!IsPostBack)
            {
                if (Request.QueryString["Mode"] == null)
                {
                    string securityCode = customerDetails.GetSecurityCode(Session["UserName"].ToString()); 
                    Session["SecurityCode"] = securityCode;
                    Session["CustomerLock"] = "";
                }
                else
                {
                    Session["SecurityCode"] = "";
                    Session["CustomerLock"] = "L";
                    ucSearchCustomer.CustomerNumber = Request.QueryString["CustomerNumber"].ToString();
                    ucSearchCustomer.btnSearch_Click(btnSearch, new EventArgs());
                    btnSearch_Click(btnSearch, new EventArgs());
                }
                TextBox _txt = ucSearchCustomer.FindControl("txtCustomer") as TextBox;
                MyScript.SetFocus(_txt);
            }
         
             //Session["UserID"] = Session["UserName"].ToString();
            // Register AJAX
            Ajax.Utility.RegisterTypeForAjax(typeof(CustomerMaster));
          
            if (!IsPostBack)
            {
               // AddMode();
            }

           
           
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            //if (ucAddressInfo.Mode != "Add" && ucAddressInfo.Type!="BT")
            //{
            if (ucSearchCustomer.CustomerID != "")
            {
                ucLocation.BillToCustomerID = ucSearchCustomer.BillToCustomerID;
                pnlLocationDetails.Update();
                ucCustomerHeader.CustType = ucSearchCustomer.CustType;
                ucCustomerHeader.BillToCustomerNo = ucSearchCustomer.BillToCustomerNo;
                ucCustomerHeader.CustomerNumber = ucSearchCustomer.CustomerNumber;
                ucAddressInfo.Mode = "Edit";
                ucAddressInfo.Type = (ucSearchCustomer.CustType == CustomerType.ST) ? "ST" : "BT";
                ucAddressInfo.BillCustomerID = ucSearchCustomer.BillToCustomerID;
                ucAddressInfo.BillCustomerNo = ucSearchCustomer.BillToCustomerNo;
                ucAddressInfo.CustomerID = ucSearchCustomer.CustomerID;
                HideLinks(true);
                EnableAddressPanel();
                pnHeaderDetails.Update();
                pnlAddressInformation.Update();
            }
           // }
            
        }
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            ucCustomerHeader.CustomerNumber = "";
            ucLocation.BillToCustomerID = "";
            HideLinks(false);
            ucAddressInfo.Mode = "Add";
            ucAddressInfo.Type = "BT";
            ucAddressInfo.CustomerNumber = ucSearchCustomer.CustomerNumber;
            pnHeaderDetails.Update();
            pnlAddressInformation.Update();
            pnlLocationDetails.Update();
            pnlSearchCustomer.Update();
           
        }
        protected void btnCancel_Click(object sender, EventArgs e)
        {          
            ucAddressInfo.Mode = "Edit";
            ucAddressInfo.Type = (ucSearchCustomer.CustType == CustomerType.ST) ? "ST" : "BT";
            ucAddressInfo.CustomerID = ucSearchCustomer.CustomerID;
            pnlAddressInformation.Update();
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            ucLocation.BillToCustomerID = ucAddressInfo.BillCustomerID;
            pnlLocationDetails.Update();
            if (ucAddressInfo.Type == "BT")
            {
                ucCustomerHeader.CustType = ucAddressInfo.GetCustType;
                ucCustomerHeader.BillToCustomerNo = ucAddressInfo.BillCustomerNo;
                ucCustomerHeader.CustomerNumber = ucAddressInfo.CustomerNumber;
            }
            HideLinks(true);
            pnHeaderDetails.Update();
            lblMessage.Text =(ucAddressInfo.UpdateStatus == "Success")? customerDetails.UpdateMessage:ucAddressInfo.UpdateStatus;
            pnlMessage.Update();
        }
        protected void ibtnSave_Click(object sender, EventArgs e)
        {             
           
            lblMessage.Text =  customerDetails.UpdateMessage;
            pnlMessage.Update();
        }
        protected void lnkOptions_Click(object sender, EventArgs e)
        {
            LinkButton ctrl = sender as LinkButton;

            HideAllControls();

            if (ctrl.ID == "lnkAddress")
            {
                divAddressInfo.Style.Add(HtmlTextWriterStyle.Display, "");
                //ucAddressInfo.SetOptionsValue = dtLocationMaster;
                
            }
            else if (ctrl.ID == "lnkCredit")
            {
                divCredit.Style.Add(HtmlTextWriterStyle.Display, "");
                ucCredit.CustomerID = ucSearchCustomer.CustomerID;
                
            }
            else if (ctrl.ID == "lnkSales")
            {
                divSales.Style.Add(HtmlTextWriterStyle.Display, "");
                ucSales.CustomerID = ucSearchCustomer.CustomerID;
               
            }
            else if (ctrl.ID == "lnkShipping")
            {
                divShipping.Style.Add(HtmlTextWriterStyle.Display, "");             
                ucShipping.CustomerID = ucSearchCustomer.CustomerID;                
            }
            pnlAddressInformation.Update();
        }
        protected void btnBindDetail_Click(object sender, EventArgs e)
        {  
            ucAddressInfo.Type = hidType.Value;
            ucAddressInfo.Mode = hidMode.Value;                    
            ucAddressInfo.AddressID = hidAddressID.Value;            
            ucAddressInfo.CustomerID = hidCustomerID.Value;
            EnableAddressPanel();
        }
        private void EnableAddressPanel()
        {
            divAddressInfo.Style.Add(HtmlTextWriterStyle.Display, "");
            divCredit.Style.Add(HtmlTextWriterStyle.Display, "none");
            divSales.Style.Add(HtmlTextWriterStyle.Display, "none");
            divShipping.Style.Add(HtmlTextWriterStyle.Display, "none");
            
        }
        private void HideAllControls()
        {
            divAddressInfo.Style.Add(HtmlTextWriterStyle.Display, "none");
            divCredit.Style.Add(HtmlTextWriterStyle.Display, "none");
            divSales.Style.Add(HtmlTextWriterStyle.Display, "none");
            divShipping.Style.Add(HtmlTextWriterStyle.Display, "none");
         
        }

        private void HideLinks(bool isEnable)
        {
            string status = (isEnable)?"":"none";
            lnkCredit.Style.Add(HtmlTextWriterStyle.Display, status);
            lnkShipping.Style.Add(HtmlTextWriterStyle.Display, status);
            lnkSales.Style.Add(HtmlTextWriterStyle.Display, status);          
            if(ucSearchCustomer.CustType==CustomerType.ST)
                lnkCredit.Style.Add(HtmlTextWriterStyle.Display, "none");
            
            //if (Session["SecurityCode"].ToString() != "SALES (W)" && Session["SecurityCode"].ToString() != "SALES (R)" && Request.QueryString["Mode"] == null)
            //{
            //    lnkSales.Style.Add(HtmlTextWriterStyle.Display, "none");
            //    lnkShipping.Style.Add(HtmlTextWriterStyle.Display, "none");
            //}
        }


        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public string CheckCustomer(string custNo)
        {
            try
            {
                
                DataSet dsCustDetail = customerDetails.GetDataToDateset("CustomerMaster (NOLOCK)", "pCustMstrID,fBillToNo,CustCd,CustNo", "CustNo='" + custNo + "' or CustSearchKey='" + custNo + "'");
                Session["CustometDetail"] = dsCustDetail;
                if (dsCustDetail != null && dsCustDetail.Tables[0].Rows.Count > 0)
                {
                 DataTable dtLock = customerDetails.CustomerLock("Lock", dsCustDetail.Tables[0].Rows[0][0].ToString().Trim());
              
                if (dtLock != null && dtLock.Rows.Count > 0)
                    return dtLock.Rows[0][0].ToString().Trim() + "~" + dtLock.Rows[0][1].ToString().Trim() + "~" + custNo;
                else
                    return "";
                }
                else
                    return "";
            }
            catch (Exception ex) { return ""; }
        }

    
    } 


}
