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
    public partial class SystemFrameSet_Winlogin : System.Web.UI.Page
    {
        UserValidation user = new UserValidation();
       
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (Request.QueryString["UserName"] != null && Request.QueryString["UserName"].ToString() != "")
                ValidateLoginUser();
            else
                Response.Redirect("Userlogin.aspx", true);

        }
        public void ValidateLoginUser()
        {
            try
            {
				
                DataSet dsUserDetail = user.ValidateUser(Request.QueryString["UserName"].ToString());
                
                if (dsUserDetail == null)
                {
                    dsUserDetail = user.ValidateUser();                 
			        //Response.Write("<script>window.close()</script>");
                }
                if (dsUserDetail != null)
                {
                
               
                    if (dsUserDetail.Tables[0].Rows.Count > 0)
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
                       // Session["DefaultCompanyID"] = dsUserDetail.Tables[0].Rows[0]["DefaultCompanyID"].ToString();
                        Session["DefaultCompanyID"] = user.GetBranchCode(dsUserDetail.Tables[0].Rows[0]["DefaultCompanyID"].ToString());
			Session["SalesPersonEmail"] = user.GetUserEmail(Session["UserName"].ToString());
                        Session["BranchID"] = user.GetBranchCode(dsUserDetail.Tables[0].Rows[0]["CompanyID"].ToString());
                        Response.Redirect("PFCVision.aspx");
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    } 
}
