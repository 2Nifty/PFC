using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;
using System.Data.Sql;
using System.Data.SqlClient;

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for VendorForecast
    /// </summary>
    public class VendorForecast
    {
        public VendorForecast()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public DataTable GetLocation()
        {
            try
            {
                DataSet dslocation = (DataSet)SqlHelper.ExecuteDataset(ConfigurationSettings.AppSettings["ReportsConnectionString"], "[UGEN_SP_Select]",
                                                      new SqlParameter("@TableName", "vendorforecast"),
                                                      new SqlParameter("@columnNames", "distinct TerrLoc"),
                                                      new SqlParameter("@whereClause", "1=1 order by TerrLoc"));
                return dslocation.Tables[0];

            }
            catch (Exception ex)
            {

                return null;
            }
        }
        public DataSet GetVendorForeCastData(string multiplier, string category, string variance, string platingType, string sort)
        {
            DataSet dsVendorFC = new DataSet();
            try
            {
                dsVendorFC = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVendorForecastRpt]",
                    new SqlParameter("@Multiplier", multiplier),
                    new SqlParameter("@Category", category),
                    new SqlParameter("@Variance", variance),
                    new SqlParameter("@PlatingType", platingType),                   
                    new SqlParameter("@Sort", sort));
            }
            catch (Exception ex)
            {

            }
            return dsVendorFC;
        }
    }
}
