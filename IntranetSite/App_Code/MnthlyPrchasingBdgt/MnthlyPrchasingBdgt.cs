using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using PFC.Intranet.DataAccessLayer;


/// <summary>
/// Summary description for _DayInventoryReport
/// </summary>
/// 
namespace PFC.Intranet.MnthlyPrchasingBdgt
{
    public class MnthlyPrchasingBdgt
    {
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        public string GetDateCondition()
        {
            try
            {
                DateTime dtCurrentMonth = DateTime.Now.AddMonths(-1);
                string currentFiscalMonth = String.Format("{0:MMMM}", dtCurrentMonth);
                string currentFiscalYear = dtCurrentMonth.Year.ToString();
                string strDateCondition = currentFiscalMonth + " " + currentFiscalYear;
                return strDateCondition;

            }
            catch (Exception ex)
            {
                return "";
            }
        }

        public DataSet GetAllBdgt()
        {
            try
            {
                return SqlHelper.ExecuteDataset(connectionString, "pPurchaseBudgetRpt",
                    new SqlParameter("@Action", "GetGroups"),
                    new SqlParameter("@RecType", "G"),
                    new SqlParameter("@Filter", "")); 
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetGroupsCats(string Group)
        {
            try
            {
                return SqlHelper.ExecuteDataset(connectionString, "pPurchaseBudgetRpt",
                    new SqlParameter("@Action", "GetCats"),
                    new SqlParameter("@RecType", "C"),
                    new SqlParameter("@Filter", Group));
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetCatItems(string Cat)
        {
            try
            {
                return SqlHelper.ExecuteDataset(connectionString, "pPurchaseBudgetRpt",
                    new SqlParameter("@Action", "GetItems"),
                    new SqlParameter("@RecType", "I"),
                    new SqlParameter("@Filter", Cat));
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetAllFactors()
        {
            try
            {
                return WorkFactors("GetAll", "", "", "", "", "");
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetAllGroups()
        {
            try
            {
                return WorkFactors("GetGroups", "", "", "", "", "");
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet WorkFactors(string Action, string BegFilter, string EndFilter, string GroupNo, string CPRFactor, string UserID)
        {
            try
            {
                if (CPRFactor == "")
                {
                    CPRFactor = "0.0";
                }
                return SqlHelper.ExecuteDataset(connectionString, "pPurchaseBudgetFactorMaint",
                                    new SqlParameter("@Action", Action),
                                    new SqlParameter("@BegFilter", BegFilter),
                                    new SqlParameter("@EndFilter", EndFilter),
                                    new SqlParameter("@GroupNo", GroupNo),
                                    new SqlParameter("@CPRFactor", CPRFactor),
                                    new SqlParameter("@UserID", UserID)
                                   ); 
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
 }


