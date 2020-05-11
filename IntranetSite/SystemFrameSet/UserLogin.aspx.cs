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
using PFC.Intranet;

namespace PFC.Intranet
{
    public partial class UserLogin : System.Web.UI.Page
    {
        UserValidation user = new UserValidation();

        #region Event handler
        /// <summary>
        /// btnSubmit_Click:Event handler used to submit user detail to server
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                if (Page.IsValid)
                {
                    if (ValidateLoginUser())
                    {
                        Response.Redirect("PFCVision.aspx");
                    }
                    else
                    {
                        lblUserStatus.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        } 
        #endregion

        #region Developer Code
        /// <summary>
        /// ValidateLoginUser:Method used to validate user
        /// </summary>
        /// <returns>return boolean value based on the validation</returns>
        public Boolean ValidateLoginUser()
        {
            try
            {
                DataSet dsUserDetail = user.ValidateUser(txtLoginName.Text, txtPassword.Text);
                if (dsUserDetail != null)
                {
                    Session["UserName"] = dsUserDetail.Tables[0].Rows[0]["UserName"].ToString();
                    Session["imageUrl"] = dsUserDetail.Tables[0].Rows[0]["Picture"].ToString();
                    Session["UserID"] = dsUserDetail.Tables[0].Rows[0]["UserID"].ToString();
                    Session["MaxSensitivity"] = dsUserDetail.Tables[0].Rows[0]["MaxSensitivity"].ToString();
                    Session["CompanyID"] = dsUserDetail.Tables[0].Rows[0]["CompanyID"].ToString();
                    System.Web.HttpContext.Current.Session["BranchID"] = (dsUserDetail.Tables[0].Rows[0]["CompanyID"].ToString().Length > 1 ? dsUserDetail.Tables[0].Rows[0]["CompanyID"].ToString() : "0" + dsUserDetail.Tables[0].Rows[0]["CompanyID"].ToString());
                    Session["Department"] = dsUserDetail.Tables[0].Rows[0]["Department"].ToString();
                    Session["Name"] = dsUserDetail.Tables[0].Rows[0]["Name"].ToString();
                    Session["Branch"] = dsUserDetail.Tables[0].Rows[0]["BranchName"].ToString();
                    Session["UserType"] = dsUserDetail.Tables[0].Rows[0]["UserType"].ToString();
                    //Session["DefaultCompanyID"] = dsUserDetail.Tables[0].Rows[0]["DefaultCompanyID"].ToString();
                    Session["DefaultCompanyID"] = user.GetBranchCode(dsUserDetail.Tables[0].Rows[0]["DefaultCompanyID"].ToString());
                    Session["BranchID"] = user.GetBranchCode(dsUserDetail.Tables[0].Rows[0]["CompanyID"].ToString());
                    Session["SalesPersonEmail"] = user.GetUserEmail(Session["UserName"].ToString());
                    return true;
                }
                else
                    return false;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        } 
        #endregion
    } 
}
