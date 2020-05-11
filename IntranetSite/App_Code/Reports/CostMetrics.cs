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
using PFC.Intranet.BusinessLogicLayer;

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary for Cost Analysis Report
    /// </summary>
    public class CostMetrics
    {        
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string reportConnectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();       

        public DataTable GetCostMetricsData(string startDate, string endDate, string restrictInd) //, string sortExpression) 
        {
            try
            {               
                // Code to execute the stored procedure
                DataSet dsData = new DataSet();
                SqlConnection conn = new SqlConnection(ERPConnectionString);
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();                
                Cmd.CommandText = "[pCostAnalysisReport]";
                Cmd.Parameters.Add(new SqlParameter("@StartDate", startDate));
                Cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));
                Cmd.Parameters.Add(new SqlParameter("@RestrictInd", restrictInd)); 

                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsData);

                if (dsData == null)
                    return null;

                return dsData.Tables[0];                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}