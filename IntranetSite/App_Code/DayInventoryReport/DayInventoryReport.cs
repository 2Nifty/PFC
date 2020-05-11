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
namespace PFC.Intranet.DayInventoryReport
{
    public class DayInventoryReport
    {
        string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();

        public string GetDateCondition()
        {
            try
            {
                string strDateCondition = "";
                string _tableName = "DashboardRanges";
                string _columnName = "MonthValue,YearValue";
                string _whereClause = "DashboardParameter='CurrentMonth'";

                DataSet dsDashboardRange = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[UGEN_SP_Select]",
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));
                if (dsDashboardRange != null && dsDashboardRange.Tables[0].Rows.Count > 0)
                {
                    DateTime date = new DateTime(1900, Convert.ToInt32(dsDashboardRange.Tables[0].Rows[0]["MonthValue"].ToString()), 1);                    
                    strDateCondition = date.ToString("MMMM") +" " + dsDashboardRange.Tables[0].Rows[0]["YearValue"].ToString();
                }

                return strDateCondition;

            }
            catch (Exception ex)
            {
                return "";
            }
        }

        public DataSet GetDayReport(string status,string sortExpression)
        {
            try
            {
                string _whereClause="";

                if(status=="withExclusion")
                    _whereClause = "RecType='WE'";
                else if(status== "withoutExclusion") 
                    _whereClause = "RecType='NE'";
                else if (status == "36MonthUsage")
                    _whereClause = "RecType='36'";

                string _tableName = "R365Summ";
                string _columnName = "CategoryGroup,ContainersOH,InvExtCost,AvgCstPerDay,DaysOH,OHover150Days,OHover365Days ,CategoryDsc";
                DataSet dsDayReport = new DataSet();

                dsDayReport = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause + sortExpression));
                return dsDayReport;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetBranch()
        {
            try
            {

                string _tableName = "KPIBranches";
                string _columnName = "Branch,Branch +' - '+BranchName as BranchName";
                string _whereClause = "ExcludefromKPI<>'1' order by Branch";
                DataSet dsBranch = new DataSet();

                dsBranch = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsBranch;

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetCategoryReport(string status,string strCategory,string strBranch,string sortExpression)
        {
            try
            {
                string _whereClause = "";
                string _columnName = "";
                string _tableName = "R365Detail";

                if (status == "withExclusion")
                    _whereClause = "CategoryGrpNo='" + strCategory + "'  and CatExcluded='1'";
                else
                    _whereClause = "CategoryGrpNo='" + strCategory + "' and CatExcluded='0'";

                if (strBranch == "00")
                {
                    _columnName = "ItemNo,ItemDesc,sum(OnHand) as OnHand,sum(OnHandValue) as OnHandValue,sum(DailySalesValue) as DailySalesValue,sum(DaysOnHand) as DaysOnHand,sum(OHgt150Days) as OHgt150Days,sum(OHgt365Days) as OHgt365Days ";
                    _whereClause = _whereClause + " group by Itemno,ItemDesc";
                }
                else
                {
                    _columnName = "ItemNo,OnHand,OnHandValue,DailySalesValue,DaysOnHand,OHgt150Days,OHgt365Days,ItemDesc";
                    _whereClause = _whereClause + " and Branch='" + strBranch + "'";
                }

                DataSet dsDayReport = new DataSet();

                dsDayReport = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause + sortExpression));
                return dsDayReport;
            }
            catch (Exception ex)
            {
                return null;
            }

        }

    }
 }


