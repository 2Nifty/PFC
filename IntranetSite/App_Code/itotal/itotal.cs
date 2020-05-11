
using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Data.SqlClient;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;

/// <summary>
/// Summary description for ITotal
/// </summary>
public class ITotal
{
    string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    string ACConnectionString = ConfigurationManager.AppSettings["ACConnectionString"].ToString();
    //string ACConnectionString = ConfigurationManager.ConnectionStrings["ACAdminAdj"].ToString();
    
    const string RPTITOTAL = "rptITotal";
    private string _brDolPerLB = "0";
    private string _otwDolPerLB ="0";
    private string _reportType = "Current";

    public string BranchDolPerLB
    {
        get
        {
            return _brDolPerLB;
        }
    }

    public string OTWDolPerLB
    {
        get
        {
            return _otwDolPerLB;
        }
    }

    public string ReportType
    {
        get
        {
            return _reportType;
        }
    }

    /// <summary>
    /// Method to fill Inventory On Hand report
    /// </summary>
    /// <param name="Period"></param>
    /// <returns></returns>
    public DataTable GetBranchInventoryOnHand(string Period)
    {
        try
        {
            DataSet dsResult = new DataSet();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string spName = "[pITotalBranchInvOH]";
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = spName;
                Cmd.Parameters.Add(new SqlParameter("@Period", Period));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsResult);
            }                
                

            // Get Total value form database and assign to property(to display in Footer)
            GetCoporateDolPerLB(Period);
            _reportType = dsResult.Tables[1].Rows[0][0].ToString().ToLower();
            return dsResult.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    /// <summary>
    /// Method to fill Inventory On Hand report pkgtype filtered version
    /// </summary>
    /// <param name="Period"></param>
    /// <returns></returns>
    public DataTable GetBranchInventoryOnHand(string Period, string PkgType)    //Pete Added for 1st page. check
    {
        try
        {
            DataSet dsResult = new DataSet();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string spName = "[pITotalBranchInvOH]";
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = spName;
                Cmd.Parameters.Add(new SqlParameter("@Period", Period));
                Cmd.Parameters.Add(new SqlParameter("@PkgType", PkgType));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsResult);
            }


            // Get Total value form database and assign to property(to display in Footer)
            GetCoporateDolPerLB(Period);
            _reportType = dsResult.Tables[1].Rows[0][0].ToString().ToLower();
            return dsResult.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }




    /// <summary>
    /// This method used to fill Footer value in Inventory On Hand Report
    /// In Inventory On Hand Report we have display only grand total in two columns,so we create two property bags
    /// </summary>
    private void GetCoporateDolPerLB(string period)
    {
        try
        {
            DataSet dsTotal = new DataSet();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string spName = "[pITotalDolPerLB]";
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = spName;
                Cmd.Parameters.Add(new SqlParameter("@Period", period));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsTotal);
            }
               
                if (dsTotal != null && dsTotal.Tables[1].Rows.Count > 0)
                {
                    _otwDolPerLB = Convert.ToDecimal(dsTotal.Tables[1].Rows[0][0]).ToString("#,##0.000");
                }
                if (dsTotal != null && dsTotal.Tables[0].Rows.Count > 0)
                {
                    _brDolPerLB = Convert.ToDecimal(dsTotal.Tables[0].Rows[0][0]).ToString("#,##0.000");
                }
            
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    /// <summary>
    /// Method to fill Inventory By Category/Branch report
    /// </summary>
    /// <param name="Period"></param>
    /// <returns></returns>
    public DataTable GetInventoryByCategoryBranch(string Period, string category)
    {
        try
        {
            DataSet dsResult = new DataSet();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string spName = "[pITotalInvByCategoryBranch]";
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = spName;
                Cmd.Parameters.Add(new SqlParameter("@Period", Period));
                Cmd.Parameters.Add(new SqlParameter("@Category", category));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsResult);
            } 

            return dsResult.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    /// <summary>
    /// Method to fill Inventory By Category/Branch report
    /// </summary>
    /// <param name="Period"></param>
    /// <returns></returns>
    public DataTable GetInventoryByCategoryBranch(string Period, string category, string PkgType) //Pete Added for 4th page. check
    {
        try
        {
            DataSet dsResult = new DataSet();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string spName = "[pITotalInvByCategoryBranch]";
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = spName;
                Cmd.Parameters.Add(new SqlParameter("@Period", Period));
                Cmd.Parameters.Add(new SqlParameter("@Category", category));
                Cmd.Parameters.Add(new SqlParameter("@PkgType", PkgType));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsResult);
            }

            return dsResult.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }


    /// <summary>
    /// Method to fill Inventory By Category/Item report
    /// </summary>
    /// <param name="Period"></param>
    /// <param name="category"></param>
    /// <returns></returns>
    public DataTable GetInventoryByCategoryItem(string Period, string category)
    {
        try
        {
            DataSet dsResult = new DataSet();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string spName = "[pITotalInvByCategoryItem]";
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = spName;
                Cmd.Parameters.Add(new SqlParameter("@Period", Period));
                Cmd.Parameters.Add(new SqlParameter("@Category", category));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsResult);
            } 
            return dsResult.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }


    /// <summary>
    /// Method to fill Inventory By Category/Item report
    /// </summary>
    /// <param name="Period"></param>
    /// <param name="category"></param>
    /// <returns></returns>
    public DataTable GetInventoryByCategoryItem(string Period, string category, string PkgType) //Pete Added for 3rd page .check
    {
        try
        {
            DataSet dsResult = new DataSet();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string spName = "[pITotalInvByCategoryItem]";
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = spName;
                Cmd.Parameters.Add(new SqlParameter("@Period", Period));
                Cmd.Parameters.Add(new SqlParameter("@Category", category));
                Cmd.Parameters.Add(new SqlParameter("@PkgType", PkgType));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsResult);
            }
            return dsResult.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }



    /// <summary>
    /// Method to fill Inventory By Category/Branch Item report
    /// </summary>
    /// <param name="Period"></param>
    /// <param name="category"></param>
    /// <param name="branch"></param>
    /// <returns></returns>
    public DataTable GetInventoryByCategoryBranchItem(string Period, string category, string branch)
    {
        try
        {
            DataSet dsResult = new DataSet();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string spName = "[pITotalInvByCategoryBranchItem]";
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = spName;
                Cmd.Parameters.Add(new SqlParameter("@Period", Period));
                Cmd.Parameters.Add(new SqlParameter("@Category", category));
                Cmd.Parameters.Add(new SqlParameter("@Branch", branch));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsResult);
            }        

            return dsResult.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }


    /// <summary>
    /// Method to fill Inventory By Category/Branch Item report
    /// </summary>
    /// <param name="Period"></param>
    /// <param name="category"></param>
    /// <param name="branch"></param>
    /// <returns></returns>
    public DataTable GetInventoryByCategoryBranchItem(string Period, string category, string branch, string PkgType) //Pete Added for 5th page .check
    {
        try
        {
            DataSet dsResult = new DataSet();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string spName = "[pITotalInvByCategoryBranchItem]";
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = spName;
                Cmd.Parameters.Add(new SqlParameter("@Period", Period));
                Cmd.Parameters.Add(new SqlParameter("@Category", category));
                Cmd.Parameters.Add(new SqlParameter("@Branch", branch));
                Cmd.Parameters.Add(new SqlParameter("@PkgType", PkgType));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsResult);
            }

            return dsResult.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public DataTable GetInventoryBranchItemDetail(string Period, string branch)
    {
        try
        {
            DataSet dsResult = new DataSet();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string spName = "[pITotalInvBranchItem]";
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = spName;
                Cmd.Parameters.Add(new SqlParameter("@Period", Period));                
                Cmd.Parameters.Add(new SqlParameter("@Branch", branch));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsResult);
            } 

            return dsResult.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public DataTable GetInventoryBranchItemDetail(string Period, string branch, string PkgType)     //Pete Added for 6th page .check
    {
        try
        {
            DataSet dsResult = new DataSet();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string spName = "[pITotalInvBranchItem]";
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = spName;
                Cmd.Parameters.Add(new SqlParameter("@Period", Period));
                Cmd.Parameters.Add(new SqlParameter("@Branch", branch));
                Cmd.Parameters.Add(new SqlParameter("@PkgType", PkgType));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsResult);
            }

            return dsResult.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }


    /// <summary>
    /// Method to fill Inventory By Category report
    /// </summary>
    /// <param name="Period"></param>
    /// <returns></returns>
    public DataTable GetInventoryByCategory(string Period)
    {
        try
        {
            DataSet dsResult =new DataSet();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string spName= "[pITotalInvByCategory]";
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = spName;
                Cmd.Parameters.Add(new SqlParameter("@period", Period));
         
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsResult);

            }        

            return dsResult.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public DataTable GetInventoryByCategory(string Period, string PkgType) //Pete Added for 2nd page .check
    {
        try
        {
            DataSet dsResult = new DataSet();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string spName = "[pITotalInvByCategory]";
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = spName;
                Cmd.Parameters.Add(new SqlParameter("@period", Period));
                Cmd.Parameters.Add(new SqlParameter("@PkgType", PkgType));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsResult);

            }

            return dsResult.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public DataTable GetInventoryBrActivity(string Branch, string period)
    {

        try
        {
            string paramNull = "0";
            DataSet dsResult = new DataSet();
            using (SqlConnection conn = new SqlConnection(ACConnectionString))
            {
                string spName = "[piTotAcTransValue]";
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = spName;
                Cmd.Parameters.Add(new SqlParameter("@date", period));
                Cmd.Parameters.Add(new SqlParameter("@type", "ALL"));
                Cmd.Parameters.Add(new SqlParameter("@Location", Branch));
                

                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsResult);

            }

            return dsResult.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public DataTable GetInventoryBrActivityDetail(string Branch, string Period, string Type)
    {
        try
        {
            DataSet dsResult = new DataSet();
            using (SqlConnection conn = new SqlConnection(ACConnectionString))
            {
                string spName = "[piTotAcTransreconDetail]";
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = spName;
                Cmd.Parameters.Add(new SqlParameter("@date", Period));
                Cmd.Parameters.Add(new SqlParameter("@type", Type));
                Cmd.Parameters.Add(new SqlParameter("@Location", Branch));
                Cmd.Parameters.Add(new SqlParameter("@Item", DBNull.Value));
                Cmd.Parameters.Add(new SqlParameter("@RowCount", "0"));

                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsResult);

            }

            return dsResult.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }

}
