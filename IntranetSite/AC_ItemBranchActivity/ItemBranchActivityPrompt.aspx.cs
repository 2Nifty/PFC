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
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet.BusinessLogicLayer;
using System.Threading;

namespace PFC.Intranet
{
    public partial class ItemBranchActivityPrompt : System.Web.UI.Page
    {
        SqlConnection cnxAvail;
        SqlCommand cmd;
        SqlDataAdapter adp;
        DataSet dsAvail = new DataSet();
        
        SalesReportUtils salesReportUtils = new SalesReportUtils();
        
        protected void Page_Load(object sender, EventArgs e)
        {
            Ajax.Utility.RegisterTypeForAjax(typeof(ItemBranchActivityPrompt));
            
            Session["UserID"] = ((Session["UserID"] != null) ? Session["UserID"].ToString() : "Testing");
            Session["SessionID"] = ((Session["SessionID"] != null) ? Session["SessionID"].ToString() : "null");
            Session["SortAC"] = " CurDate ASC";

            //lblError.Visible = false;
            if (!IsPostBack)
            {
                salesReportUtils.FillBranchesAndChainSession(Session["UserID"].ToString());             

                FillBranches();     // Fill The Branches in the Combo
                hidEndDt.Value = cldEndDt.SelectedDate.ToShortDateString();
                hidStartDt.Value = cldStartDt.SelectedDate.ToShortDateString();

                for (int i = 0; i <= ddlBranch.Items.Count - 1; i++)
                {
                    if (ddlBranch.Items[i].Value.Trim() == Session["BranchID"].ToString())
                    {
                        ddlBranch.Items[i].Selected = true;
                        break;
                    }
                }
            }
        }

        public void FillBranches()
        {
            try
            {
                salesReportUtils.GetALLBranches(ddlBranch, Session["UserID"].ToString());
            }
            catch (Exception ex) { }
        }

        protected void cldEndDt_SelectionChanged(object sender, EventArgs e)
        {
            hidEndDt.Value = cldEndDt.SelectedDate.ToShortDateString();
        }

        protected void cldStartDt_SelectionChanged(object sender, EventArgs e)
        {
            hidStartDt.Value = cldStartDt.SelectedDate.ToShortDateString();
        }

        #region Check Item No And Cross Reference
        /// <summary>
        /// Check Cross reference against Itemno and customer number
        /// </summary>
        /// <param name="itemNo"></param>
        /// <returns></returns>
        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public string GetCrossreference(string itemNo)
        {
            string status = "false";
            // get the data.
            //DataSet dsAvail = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEGetItemAlias]",
            //          new SqlParameter("@SearchItemNo", itemNo),
            //          new SqlParameter("@Organization", Session["CustomerNumber"].ToString().Trim()));

            cnxAvail = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
            cmd = new SqlCommand("pSOEGetItemAlias", cnxAvail);
            cmd.Parameters.AddWithValue("@SearchItemNo", itemNo);
            cmd.Parameters.AddWithValue("@Organization", 0);
            cmd.CommandType = CommandType.StoredProcedure;
            adp = new SqlDataAdapter(cmd);
            dsAvail.Clear();
            adp.Fill(dsAvail, "Avail");

            if (dsAvail.Tables.Count >= 1)
            {
                if (dsAvail.Tables.Count == 1)
                {
                    if (dsAvail.Tables[0].Rows.Count > 0)
                    {
                        status = "false";
                    }
                }
                else
                {
                    status = "true";
                }
            }
            return status;
        }
        #endregion
    }
}
