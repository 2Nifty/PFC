#region Namespaces
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
using System.IO;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.Securitylayer;
#endregion

public partial class CASFrameSet : System.Web.UI.Page
{
    #region Variable Declaration
    public string StrBranch = string.Empty;
    #endregion

    #region Page Load Method
    /// <summary>
    /// Page_Load:Page load Event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        
 SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        UserTracking userTracking = new UserTracking();
        userTracking.TrackPageEntry("50045");
        Session["ChartType"] = "Pie";
        Session["ChartPalette"] = "WarmEarth";
        Session["CustomerType"] = "PFC Employee";
        GetCustomerName();
    }
    #endregion

    #region Developer Code
    /// <summary>
    /// GetCustomerName :Private method used to get customer name
    /// </summary>
    private void GetCustomerName()
    {
        try
        {
            string strWhere = string.Empty;
            string strTable = string.Empty;

            if (Request.QueryString["CASMode"] == null)
            {
                strWhere = "CustNo='" + Request.QueryString["CustNo"].Trim().Replace("||", "&") + "'";
                strTable = "CAS_CustomerData";
            }
            else
            {
                strWhere = "Chain='" + Request.QueryString["Chain"].Trim().Replace("||", "&") + "'";
                strTable = "CAS_ChainData";
            }

            PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet customerData = new PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet();

            DataTable dtSalesDetails = customerData.GetCustomerActivityDetail(strWhere, "CustName,BranchNo,BranchDesc", strTable);

            if (dtSalesDetails.Rows.Count > 0)
            {
                Session["CustomerName"] = dtSalesDetails.Rows[0]["CustName"].ToString();
                if (Request.QueryString["Branch"].Trim() == "0")
                    StrBranch = dtSalesDetails.Rows[0]["BranchNo"].ToString() + "-" + dtSalesDetails.Rows[0]["BranchDesc"].ToString();
                else
                    StrBranch = Request.QueryString["BranchName"].Trim();
            }
            else
            {
                Session["CustomerName"] = "";
                if (Request.QueryString["Branch"].Trim() == "0")
                    StrBranch = Request.QueryString["BranchName"].Trim();
            }
        }
        catch (Exception ex)
        {
            Response.Write(ex.ToString());
        }
    }
    #endregion

}//End Class
