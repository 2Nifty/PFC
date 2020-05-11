using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;

using System.Data.SqlClient;
using PFC.WOE.DataAccessLayer;
using PFC.WOE;

namespace PFC.WOE.BusinessLogicLayer
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
                    String _companyName = SqlHelper.ExecuteScalar(ConfigurationSettings.AppSettings["PFCERPConnectionString"], "[UGEN_SP_Select]",
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
