using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.Sql;
using System.Data.SqlClient;
using PFC.SOE.DataAccessLayer;

namespace PFC.SOE.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for SplitLines
    /// </summary>
    public class SplitLines
    {
        public DataSet GetSplitLineFrmData(string source,string filter)
        {
            try
            {
                DataSet dsResult = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOESplitLineFrm]",
                                        new SqlParameter("@source", source),
                                        new SqlParameter("@searchFilter", filter));

                if (dsResult == null)
                    return null;

                return dsResult;
            }
            catch (Exception ex)
            {
                return null;                
            }
        }
    }
}