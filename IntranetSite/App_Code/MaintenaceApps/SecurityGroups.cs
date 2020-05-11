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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;

namespace PFC.Intranet.BusinessLogicLayer
{
    public class SecurityGroups
    {
        string tableName = "";
        string columnName = "";
        string whereClause = "";

        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        public DataTable GetGroups(string whereCondition)
        {
            try
            {
                columnName = "pSecGroupID AS ID, GroupName, SecurityGroupApp, GroupDesc, Comments";
                tableName = "dbo.SecurityGroups (NOLOCK)";
                whereClause = "(DeleteDt is null OR DeleteDt = '') " + whereCondition + " Order By GroupName";

                DataSet dsDetails = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                    new SqlParameter("@tableName", tableName),
                    new SqlParameter("@columnNames", columnName),
                    new SqlParameter("@whereClause", whereClause));

                return dsDetails.Tables[0];
            }
            catch (Exception ex)
            { throw ex; }
        }

        public void InsertSecurityGroups(string columnNames, string columnValues)
        {
            try
            {
                SqlHelper.ExecuteDataset(connectionString, "pSOEInsert",
                             new SqlParameter("@tableName", "SecurityGroups"),
                             new SqlParameter("@columnNames", columnNames),
                             new SqlParameter("@columnValues", columnValues));
            }
            catch (Exception ex) { }
        }

        public void UpdateSecurityGroups(string columnValues, string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                             new SqlParameter("@tableName", "SecurityGroups"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex) { }
        }

        public void BindListValue(string listName, string defaultString, DropDownList ddlList)
        {
            DataTable dtList = GetListValue(listName);
            if (dtList != null)
            {
                ddlList.DataSource = dtList;
                ddlList.DataTextField = "Desc";
                ddlList.DataValueField = "ListValue";
                ddlList.DataBind();
            }
            ddlList.Items.Insert(0, new ListItem(defaultString, ""));
        }

        public DataTable GetListValue(string listName)
        {
            string _whereClause = "LM.pListMasterID=LD.fListMasterID AND LM.ListName='" + listName + "' Order By LD.SequenceNo";
            string _tableName = "ListDetail LD, ListMaster LM (NOLOCK) ";
            string _columnName = "LD.ListValue as ListValue, LD.ListValue +' - '+ LD.ListDtlDesc as 'Desc'";

            DataSet dsListValue = new DataSet();
            dsListValue = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            return dsListValue.Tables[0];
        }
    }
}
