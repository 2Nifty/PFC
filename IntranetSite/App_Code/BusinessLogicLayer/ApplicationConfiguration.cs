using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;

using System.Data.SqlClient;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for ApplicationConfiguration
    /// </summary>
    public class ApplicationConfiguration
    {
        public static string CorporateName
        {
            get
            {
                return GetCorporateName();
            }
        }

        public static string GetCorporateName()
        {
            try
            {

                if (HttpContext.Current.Session["CorporateName"] == null)
                {
                    String _companyName = SqlHelper.ExecuteScalar(Global.ReportsConnectionString, "[UGEN_SP_Select]",
                                           new SqlParameter("@TableName", "LocMaster"),
                                           new SqlParameter("@columnNames", "LocName"),
                                           new SqlParameter("@whereClause", "LocID='00'")).ToString();
                    HttpContext.Current.Session["CorporateName"] = _companyName;
                }

                return HttpContext.Current.Session["CorporateName"].ToString();
            }
            catch (Exception ex)
            {
                return "";
            }
        }
    }
}
