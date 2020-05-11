using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.SOE.DataAccessLayer;
namespace PFC.SOE.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for OrderEntry
    /// </summary>
    public class ECommQuotes
    {
        //For Security Code
        string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";

        public ECommQuotes()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        #region Variable Declaration
        //
        // variable declaration
        //
        string QuoteDBConnectionString = ConfigurationManager.AppSettings["PFCQuoteDBConnectionString"].ToString();
        string ERPDBConnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
        #endregion

        #region Methods

        public DataSet ExecuteRecallQuotes(string Action, string CustNo, string QuoteNo, string QuoteDate, string NewAltPrice, string NewUnitPrice)
        {
            try
            {
                DataSet dsSelect = SqlHelper.ExecuteDataset(QuoteDBConnectionString, "pRecallQuotes",
                    new SqlParameter("@Action", Action),
                    new SqlParameter("@Organization", CustNo),
                    new SqlParameter("@QuoteNo", QuoteNo),
                    new SqlParameter("@QuoteDate", QuoteDate),
                    new SqlParameter("@NewAltPrice", NewAltPrice),
                    new SqlParameter("@NewUnitPrice", NewUnitPrice));
                return dsSelect;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataSet GetCustSummary(string CustNo)
        {
            return ExecuteRecallQuotes("GetSummary", CustNo, "", "", "0.0", "0.0");
        }

        public DataSet GetDateSummary(string CustNo, string QuoteDate)
        {
            return ExecuteRecallQuotes("QuoteDateSumm", CustNo, "", QuoteDate, "0.0", "0.0");
        }

        public DataSet GetDateDetail(string CustNo, string QuoteDate)
        {
            return ExecuteRecallQuotes("GetDateLines", CustNo, "", QuoteDate, "0.0", "0.0");
        }

        public DataSet GetQuoteDetail(string CustNo, string QuoteNo)
        {
            return ExecuteRecallQuotes("GetQuoteLines", CustNo, QuoteNo, "", "0.0", "0.0");
        }

        public DataSet UpdatePrice(string QuoteNo, string AltPrice, string UnitPrice)
        {
            return ExecuteRecallQuotes("UpdatePrice", "", QuoteNo, "", AltPrice, UnitPrice);
        }

        public DataSet ExecutePendingQuotes(string CustNo, string Location, string UserID, string OrderSource, string BegDate, string EndDate)
        {
            try
            {
                if (CustNo.Trim() == "")
                    CustNo = "%";
                if ((Location.Trim() == "ALL") || (Location.Trim() == ""))
                    Location = "%";
                if ((UserID.Trim() == "ALL") || (UserID.Trim() == ""))
                    UserID = "%";
                if ((OrderSource.Trim() == "ALL") || (OrderSource.Trim() == ""))
                    OrderSource = "%";

                DataSet dsSelect = SqlHelper.ExecuteDataset(ERPDBConnectionString, "pPendingECommQuotes",
                    new SqlParameter("@Action", "GridData"),
                    new SqlParameter("@CustNo", CustNo),
                    new SqlParameter("@Location", Location),
                    new SqlParameter("@UserID", UserID),
                    new SqlParameter("@OrderSource", OrderSource),
                    new SqlParameter("@BegDate", BegDate),
                    new SqlParameter("@EndDate", EndDate));
                return dsSelect;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetSalesPerson(string branchID)
        {
            DataSet dsSelect = SqlHelper.ExecuteDataset(ERPDBConnectionString, "pPendingECommQuotes",
                new SqlParameter("@Action", "UserDLL"),
                new SqlParameter("@CustNo", ""),
                new SqlParameter("@Location", (branchID == "ALL" ? "%" : branchID)),
                new SqlParameter("@UserID", ""),
                new SqlParameter("@OrderSource", ""),
                new SqlParameter("@BegDate", DateTime.Now.ToShortDateString()),
                new SqlParameter("@EndDate", DateTime.Now.ToShortDateString()));

            return dsSelect.Tables[0];
        }

        public DataTable GetBranch()
        {
            DataSet dsSelect = SqlHelper.ExecuteDataset(ERPDBConnectionString, "pPendingECommQuotes",
                new SqlParameter("@Action", "BranchDLL"),
                new SqlParameter("@CustNo", ""),
                new SqlParameter("@Location",""),
                new SqlParameter("@UserID", ""),
                new SqlParameter("@OrderSource", ""),
                new SqlParameter("@BegDate", DateTime.Now.ToShortDateString()),
                new SqlParameter("@EndDate", DateTime.Now.ToShortDateString()));

            return dsSelect.Tables[0];
        }

        public void UpdateRep(string Rep)
        {
            SqlHelper.ExecuteNonQuery(ERPDBConnectionString, "pPendingECommQuotes",
                new SqlParameter("@Action", "UpdRep"),
                new SqlParameter("@CustNo", ""),
                new SqlParameter("@Location",""),
                new SqlParameter("@UserID", Rep),
                new SqlParameter("@OrderSource", ""),
                new SqlParameter("@BegDate", DateTime.Now.ToShortDateString()),
                new SqlParameter("@EndDate", DateTime.Now.ToShortDateString()));

        }

        #endregion

        #region Security Code
        /// <summary>
        /// Public Method user to get User security code
        /// </summary>
        /// <param name="userName">Parameter:username</param>
        /// <returns>User security code</returns>
        public string GetSecurityCode(string userName)
        {
            try
            {
                object objSecurityCode = (object)SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and SU.UserName='" + userName + "' AND (SG.groupname='SOE(W)' OR  SG.groupname='ENTRY(W)')"));

                if (objSecurityCode != null)
                    return objSecurityCode.ToString().Trim();
                else
                    return "";

            }
            catch (Exception Ex) { return ""; }
        }
        #endregion

    }
}